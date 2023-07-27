//
//  EditValueView.swift
//
//
//  Created by p-x9 on 2022/10/16.
//
//
import SwiftUI
import SwiftUIColor

@available(iOS 14, *)
public struct EditValueView<Value>: View {

    /// Name of the property to be edited
    /// Used for navigation titles and type descriptions.
    let key: String

    /// This is called when editing is completed by pressing the save button.
    /// They will be received by a modifier named `onUpdate`.
    private var _onUpdate: ((Value) -> Void)?

    /// Used to perform validation checks when editing values
    /// They will be received by a modifier named `validate`.
    private var _validate: ((Value) -> Bool)?

    /// Value to be edited
    @State var value: Value

    /// True if nil set is requested by optionalEditor.
    /// Note: Use the `isNil` property to check if a value is actually nil.
    @State private var shouldSetNil = false

    /// A boolean value indicating whether the current input value can be converted to the actual type.
    @State private var isValidType = true

    /// binding received from the initializer.
    /// When the save button is pressed, the binding is updated to indicate the value change.
    private var binding: Binding<Value>?

    /// A boolean value that indicates whether the current input value can be converted to the actual type and conforms to the validation checks
    var isValid: Bool {
        isValidType && (_validate?(value) ?? true)
    }

    /// A boolean value that indicates whether the type being edited is an Optional type or not
    var isOptional: Bool {
        Value.self is any OptionalType.Type
    }

    /// A boolean value that indicates whether the value is nil
    var isNil: Bool {
        if let optional = value as? any OptionalType {
            return optional.wrapped == nil
        }
        return false
    }

    /// A boolean value that indicates whether optionalEditor should be displayed
    var shouldShowOptionalEditor: Bool {
        isOptional &&
        editorType.shouldShowOptionalEditor
    }

    @Environment(\.presentationMode) private var presentationMode

    public var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        header

                        typeSection
                            .padding(.top)

                        if isOptional && shouldShowOptionalEditor {
                            optionalEditor
                                .padding()
                                .border(.black, width: 0.5)
                                .padding(.vertical)
                        }

                        if !shouldSetNil && !isNil || !shouldShowOptionalEditor {
                            editor
                                .padding(.vertical)
                                .layoutPriority(.infinity)
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(minHeight: proxy.size.height)
                    .navigationTitle(key)
                    .toolbar {
                        ToolbarItem(placement: .destructiveAction) {
                            Button("Save") {
                                save()
                                presentationMode.wrappedValue.dismiss()
                            }
                            .disabled(!isValid)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }

    /// Displays key and type information
    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                let string: String = "Key: \(key)"
                Text(string)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack {
                let string: String = "Type: \(Value.self)"
                Text(string)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }

    /// Displays type information
    @ViewBuilder
    var typeSection: some View {
        HStack {
            let type = "\(Value.self)"
            Text(type)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(Color.iOS.secondarySystemFill)
        .cornerRadius(8)
    }

    @ViewBuilder
    var optionalEditor: some View {
        Toggle(isOn: $shouldSetNil) {
            Text("Set value to `nil`")
        }
        .onChange(of: shouldSetNil) { newValue in
            if newValue {
                setNil()
            } else {
                setDefault()
            }
        }
    }

    @ViewBuilder
    var notSupportedView: some View {
        Text("this type is currently not supported.")
    }

    @ViewBuilder
    var editor: some View {
        switch $value {
        case let v as Binding<String>:
            TextEditor(text: v)
                .frame(minHeight: 200, maxHeight: .infinity)
                .border(.black, width: 0.5)

        case let v as Binding<Bool>:
            Toggle(key, isOn: v)
                .padding()
                .border(.black, width: 0.5)

        case _ where Value.self is any Numeric.Type:
            CodableEditorView($value, key: key, isValidType: $isValidType, textStyle: .single)

        case let v as Binding<Date>:
            DateEditorView(v, key: key)

        case let v as Binding<Color>:
            ColorEditorView(v, key: key)

        case let v as Binding<CGColor>:
            ColorEditorView(v, key: key)

        case let v as Binding<NSUIColor>:
            ColorEditorView(v, key: key)

        case let v as Binding<CIColor>:
            ColorEditorView(v, key: key)

#if canImport(UIKit)
        case let v as Binding<Image>:
            SwiftUIImageEditor(image: .init(v), isOptional: false)

        case let v as Binding<NSUIImage>:
            ImageEditor(v)

        case let v as Binding<CGImage>:
            ImageEditor(v)

        case let v as Binding<CIImage>:
            ImageEditor(v)
#endif

        case _ where Value.self is any CaseIterable.Type:
            CaseIterableEditor($value, key: key)
                .border(.black, width: 0.5)

        /* Optional Type */
        case let v as Binding<String?> where !isNil:
            TextEditor(text: Binding(v)!)
                .frame(minHeight: 200, maxHeight: .infinity)
                .border(.black, width: 0.5)

        case let v as Binding<Bool?> where !isNil:
            Toggle(key, isOn: Binding(v)!)
                .padding()
                .border(.black, width: 0.5)

        case _ where Value.self is any OptionalNumeric.Type:
            CodableEditorView($value, key: key, isValidType: $isValidType, textStyle: .single)

        case let v as Binding<Date?> where !isNil:
            DateEditorView(Binding(v)!, key: key)

        case let v as Binding<Color?> where !isNil:
            ColorEditorView(Binding(v)!, key: key)

        case let v as Binding<CGColor?> where !isNil:
            ColorEditorView(Binding(v)!, key: key)

        case let v as Binding<NSUIColor?> where !isNil:
            ColorEditorView(Binding(v)!, key: key)

        case let v as Binding<CIColor?> where !isNil:
            ColorEditorView(Binding(v)!, key: key)

#if canImport(UIKit)
        case let v as Binding<Image?>:
            SwiftUIImageEditor(image: v, isOptional: true)

        case let v as Binding<NSUIImage?>:
            ImageEditor(v)

        case let v as Binding<CGImage?>:
            ImageEditor(v)

        case let v as Binding<CIImage?>:
            ImageEditor(v)
#endif

        case _ where Value.self is any OptionalCaseIterable.Type:
            CaseIterableEditor($value, key: key)
                .border(.black, width: 0.5)

        /* Other */
        case _ where Value.self is any Codable.Type:
            CodableEditorView($value, key: key, isValidType: $isValidType)

        default:
            notSupportedView
        }
    }

    /// Set the process to be performed when the Save button is pressed.
    /// - Parameter onUpdate: A closure that receives the edited value
    /// - Returns: Self
    public func onUpdate(_ onUpdate: ((Value) -> Void)?) -> Self {
        var new = self
        new._onUpdate = onUpdate
        return new
    }

    /// Set validation checks.
    /// Returning false disables the save button
    /// - Parameter validate: A closure that takes the current value after editing and returns the validation result
    /// - Returns: Self
    public func validate(_ validate: ((Value) -> Bool)?) -> Self {
        var new = self
        new._validate = validate
        return new
    }

    private func save() {
        binding?.wrappedValue = value
        _onUpdate?(value)
    }
}

extension EditValueView {
    /// Initialize with key and value
    /// - Parameters:
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - value: Initial value of the value to be edited
    public init(key: String, value: Value) {
        self.key = key
        self._value = .init(initialValue: value)
    }

    /// Initialize with keyPath
    /// - Parameters:
    ///   - target: Target object that has the property to be edited.
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - keyPath: keyPath of the property to be edited.
    public init<Root>(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Value>) {
        self.init(key: key, value: target[keyPath: keyPath])
    }

    /// Initialize with binding
    /// - Parameters:
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - binding: Binder for the value to be edited
    public init(key: String, binding: Binding<Value>) {
        self.key = key
        self._value = .init(initialValue: binding.wrappedValue)
        self.binding = binding
    }
}

#if DEBUG
enum Enum: CaseIterable {
    case red, yellow, blue
}
enum Enum2: Int, CaseIterable, DefaultRepresentable {
    case red, yellow, blue

    static var defaultValue: Self {
        .red
    }
}
struct Item {
    var name: String
    var bool: Bool
    var date: Date
    var `enum`: Enum
    var enum2: Enum2?
    var image: Image = .init(systemName: "swift")
    var color: Color
    var `codable`: ACodable = .init(text: "", number: 5)
    var array = ["AA", "BB"]
    var dictionary: [String: Int] = [
        "AA": 0,
        "BB": 234
    ]
    var cgColor = NSUIColor.yellow.cgColor
    var uiColor = NSUIColor.blue
    var ciColor = CIColor(color: NSUIColor.brown)

    var nsuiImage = NSUIImage(systemName: "swift")
    var cgImage = NSUIImage(systemName: "swift")?.cgImage
    var ciImage = NSUIImage(systemName: "swift")?.ciImage
}

struct ACodable: Codable {
    var text: String
    var number: Int
    var double: Double = 0.4
    var optionalString: String? = "test"
    var nested: BCodable = .init(text: "", number: 0)
}

extension ACodable: DefaultRepresentable {
    static var defaultValue: ACodable = .init(text: "", number: 0)
}

struct BCodable: Codable {
    var text: String
    var number: Int
    var optionalString: String?
}

let target: Item = .init(name: "Hello!!",
                         bool: true,
                         date: Date(),
                         enum: .red,
                         enum2: .blue,
                         color: .white)

struct EditValueView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                EditValueView(target, key: "name", keyPath: \Item.name)
                    .validate { value in
                        value != "Test"
                    }
                    .previewDisplayName("String")

                EditValueView(target, key: "bool", keyPath: \Item.bool)
                    .previewDisplayName("Bool")

                EditValueView(target, key: "date", keyPath: \Item.date)
                    .previewDisplayName("Date")

                EditValueView(target, key: "number", keyPath: \Item.codable.number)
                    .previewDisplayName("Int")

                EditValueView(target, key: "double", keyPath: \Item.codable.double)
                    .previewDisplayName("Double")
            }

            Group {
                EditValueView(target, key: "enum", keyPath: \Item.enum)
                    .previewDisplayName("Enum(CaseIterable)")

                EditValueView(target, key: "enum", keyPath: \Item.enum2)
                    .previewDisplayName("Enum(CaseIterable & RawRepresentable)")

                EditValueView(target, key: "array", keyPath: \Item.array)
                    .previewDisplayName("Array")

                EditValueView(target, key: "dictionary", keyPath: \Item.dictionary)
                    .previewDisplayName("Dictionary")
            }

            EditValueView(target, key: "codable", keyPath: \Item.codable)
                .previewDisplayName("Codable")

        }
    }
}

struct EditValueView_Color_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            EditValueView(target, key: "color", keyPath: \Item.color)
                .previewDisplayName("Color")

            EditValueView(target, key: "ui/nsColor", keyPath: \Item.uiColor)
                .previewDisplayName("UI/NSColor")

            EditValueView(target, key: "cgColor", keyPath: \Item.cgColor)
                .previewDisplayName("CGColor")

            EditValueView(target, key: "ciColor", keyPath: \Item.ciColor)
                .previewDisplayName("CIColor")
        }
    }
}

struct EditValueView_Image_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            EditValueView(target, key: "image", keyPath: \Item.image)
                .previewDisplayName("Image")

            EditValueView(target, key: "ns/uiImage", keyPath: \Item.nsuiImage)
                .previewDisplayName("NS/UIImage")

            EditValueView(target, key: "cgImage", keyPath: \Item.cgImage)
                .previewDisplayName("CGImage")

            EditValueView(target, key: "ciImage", keyPath: \Item.ciImage)
                .previewDisplayName("CIImage")
        }
    }
}
#endif

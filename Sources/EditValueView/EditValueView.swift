//
//  EditValueView.swift
//
//
//  Created by p-x9 on 2022/10/16.
//
//
import SwiftUI
//import SwiftUIColor

@available(iOS 14, *)
public struct EditValueView<Root, Value: Hashable>: View {
    let target: Root
    let key: String
    let keyPath: PartialKeyPath<Root> //WritableKeyPath<Root, Value>
    private var _onUpdate: ((Root, Value) -> Void)?
    private var isWrappedOptional = false
    
    @State private var value: Value
    @Environment(\.presentationMode) private var presentationMode
    
    @_disfavoredOverload
    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Value>) {
        self.target = target
        self.key = key
        self.keyPath = keyPath
        
        self._value = .init(initialValue: target[keyPath: keyPath])
    }
    
    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Optional<Value>>) where Value: DefaultRepresentable {
        self.init(target, key: key, keyPath: keyPath, defaultValue: Value.defaultValue)
    }
    
    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Optional<Value>>, defaultValue: Value) {
        self.target = target
        self.key = key
        self.keyPath = keyPath
        self.isWrappedOptional = true
        
        self._value = .init(initialValue: target[keyPath: keyPath] ?? defaultValue)
    }
    
    public var body: some View {
        NavigationView {
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
                        .padding([.bottom])
                    Spacer()
                }
                
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
                
                editor
                    .padding(.vertical)
                Spacer()
            }
            .padding()
            .navigationTitle(key)
            .toolbar {
                ToolbarItemGroup(placement: .destructiveAction) {
                    Button("Save") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var editor: some View {
        switch $value {
        case let v as Binding<String>:
            TextEditor(text: v)
                .border(.black, width: 0.5)
            
        case let v as Binding<Bool>:
            Toggle(key, isOn: v)
                .padding()
                .border(.black, width: 0.5)
            
        case _ where (value as? NSNumber) != nil:
            CodableEditorView($value, key: key, textStyle: .single)
            
        case let v as Binding<Date>:
            DateEditorView(v, key: key)
            
        case let v as Binding<Color>:
            ColorPicker(key, selection: v)
                .padding()
                .border(.black, width: 0.5)
            
        case _ where Value.self is any CaseIterable.Type:
            CaseIterableEditor($value, key: key)
                .border(.black, width: 0.5)
            
        case _ where Value.self is any Codable.Type:
            CodableEditorView($value, key: key)
            
        default:
            Text("this type is currently not supported.")
        }
    }
    
    public func onUpdate(_ onUpdate: ((Root, Value) -> Void)?) -> Self {
        var new = self
        new._onUpdate = onUpdate
        return new
    }
    
    private func save() {
        _onUpdate?(target, value)
    }
}

#if DEBUG
enum Enum: CaseIterable {
    case red, yellow, blue
}
enum Enum2: Int, CaseIterable {
    case red, yellow, blue
}
struct Item {
    var name: String
    var bool: Bool
    var date: Date
    var `enum`: Enum
    var enum2: Enum2
    var color: Color
    var `codable`: ACodable = .init(text: "", number: 5)
    var array = ["AA", "BB"]
    var dictionary: [String: Int] = [
        "AA": 0,
        "BB": 234
    ]
}

struct ACodable: Hashable, Codable {
    var text: String
    var number: Int
    var double: Double = 0.4
    var optionalString: String? = "test"
    var nested: BCodable = .init(text: "", number: 0)
}

struct BCodable: Hashable, Codable {
    var text: String
    var number: Int
    var optionalString: String? = nil
}

struct EditValueView_Preview: PreviewProvider {
    static var previews: some View {
        let target: Item =  .init(name: "Hello!!",
                                  bool: true,
                                  date: Date(),
                                  enum: .red,
                                  enum2: .blue,
                                  color: .white)
        
        Group {
            Group {
                EditValueView(target, key: "name", keyPath: \Item.name)
                    .previewDisplayName("String")
                
                EditValueView(target, key: "bool", keyPath: \Item.bool)
                    .previewDisplayName("Bool")
                
                EditValueView(target, key: "date", keyPath: \Item.date)
                    .previewDisplayName("Date")
                
                EditValueView(target, key: "color", keyPath: \Item.color)
                    .previewDisplayName("Color")
                
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
#endif

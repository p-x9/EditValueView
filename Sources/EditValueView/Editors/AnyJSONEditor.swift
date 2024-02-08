import SwiftUI
import SwiftUIColor

struct AnyJSONEditor<Value>: View {
    let key: String

    @Binding private var value: Value
    @Binding private var isValidType: Bool

    @State private var text: String

    init?(_ value: Binding<Value>, key: String, isValidType: Binding<Bool>) {
        self._value = value
        self._isValidType = isValidType
        self.key = key

        guard JSONSerialization.isValidJSONObject(value.wrappedValue),
              let json = try? JSONSerialization.data(withJSONObject: value.wrappedValue, options: [.prettyPrinted, .sortedKeys]),
              let jsonString = String(data: json, encoding: .utf8)
        else {
            return nil
        }

        self._text = .init(initialValue: jsonString)
    }

    var body: some View {
        VStack {
            editor
                .onChange(of: text) { newValue in
                    textChanged(text: newValue)
                }
        }
    }

    @ViewBuilder
    var typeDescriptionView: some View {
        HStack {
            Text(typeDescription())
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(Color.iOS.secondarySystemFill)
        .cornerRadius(8)
    }

    @ViewBuilder
    var editor: some View {
        TextEditor(text: $text)
            .frame(minHeight: 200, maxHeight: .infinity)
            .border(.black, width: 0.5)
            .padding(.vertical)
    }

    func textChanged(text: String) {
        guard let data = text.data(using: .utf8),
              let value = try? JSONSerialization.jsonObject(with: data) as? Value
        else {
            isValidType = false
            return
        }
        self.value = value
        isValidType = true
    }

    func typeDescription() -> String {
        if let optional = value as? (any OptionalType),
           optional.wrapped == nil,
           let type = Value.self as? any DefaultRepresentable.Type {
            return ValueType.extractType(for: Optional.some(type.defaultValue)).typeName
        }
        return ValueType.extractType(for: value).typeName
    }
}

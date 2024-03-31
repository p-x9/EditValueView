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
    var editor: some View {
        TextEditor(text: $text)
            .frame(minHeight: 200, maxHeight: .infinity)
            .border(Color.iOS(.label), width: 0.5)
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
}

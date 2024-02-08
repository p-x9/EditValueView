//
//  CodableEditorView.swift
//  
//
//  Created by p-x9 on 2022/10/21.
//  
//

import SwiftUI
import SwiftUIColor

struct CodableEditorView<Value>: View {

    enum TextStyle {
        case single
        case multiline
    }

    let key: String

    @Binding private var value: Value
    @Binding private var isValidType: Bool

    @State private var text: String
    @State private var textStyle: TextStyle

    init(_ value: Binding<Value>, key: String, isValidType: Binding<Bool>, textStyle: TextStyle = .multiline) {
        self._value = value
        self._isValidType = isValidType
        self.key = key

        self._textStyle = .init(initialValue: textStyle)

        let codableValue = value.wrappedValue as! Codable
        self._text = .init(initialValue: codableValue.jsonString ?? "")
    }

    var body: some View {
        VStack {
            if textStyle == .multiline {
                typeDescriptionView
                    .layoutPriority(1)
            }

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
        switch textStyle {
        case .single:
            TextField("", text: $text)
                .padding()
                .border(.black, width: 0.5)

        case .multiline:
            TextEditor(text: $text)
                .frame(minHeight: 200, maxHeight: .infinity)
                .border(.black, width: 0.5)
                .padding(.vertical)
        }
    }

    func textChanged(text: String) {
        let type = Value.self as! Codable.Type
        guard let value = type.value(from: text) as? Value else {
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
            return ValueType.extractType(for: Optional.some(type.defaultValue)).typeDescription
        }
        return ValueType.extractType(for: value).typeDescription
    }
}

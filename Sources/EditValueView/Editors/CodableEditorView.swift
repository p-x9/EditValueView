//
//  CodableEditorView.swift
//
//
//  Created by p-x9 on 2022/10/21.
//
//

import SwiftUI
import SwiftUIColor
import ReflectionView

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
        HStack(alignment: .center, spacing: 0) {
            TypeInfoView(value)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            Spacer()
        }
        .font(.system(size: 14, design: .monospaced))
        .background(Color.iOS.secondarySystemFill)
        .cornerRadius(8)
    }

    @ViewBuilder
    var editor: some View {
        switch textStyle {
        case .single:
            TextField("", text: $text)
                .padding()
                .border(Color.iOS(.label), width: 0.5)

        case .multiline:
            TextEditor(text: $text)
                .frame(minHeight: 200, maxHeight: .infinity)
                .border(Color.iOS(.label), width: 0.5)
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
}

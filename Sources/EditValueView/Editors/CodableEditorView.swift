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
    @State private var text: String
    @State private var isValid: Bool
    
    @State private var textStyle: TextStyle
    
    private var rawValue: Value
    
    init(_ value: Binding<Value>, key: String, textStyle: TextStyle = .multiline) {
        self._value = value
        self.key = key
        self.rawValue = value.wrappedValue
        
        self._textStyle = .init(initialValue: textStyle)
        
        let codableValue = value.wrappedValue as! Codable
        self._text = .init(initialValue: codableValue.jsonString ?? "")
        self._isValid = .init(initialValue: true)
    }
    
    var body: some View {
        VStack {
            if textStyle == .multiline {
                typeDescriptionView
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
                .border(.black, width: 0.5)
                .padding(.vertical)
        }
    }
    
    func textChanged(text: String) {
        let type = Value.self as! Codable.Type
        guard let value = type.value(from: text) as? Value else {
            isValid = false
            return
        }
        self.value = value
        isValid = true
    }
    
    func typeDescription() -> String {
        ValueType.extractType(for: value).typeName
    }

}

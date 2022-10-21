//
//  CodableEditorView.swift
//  
//
//  Created by p-x9 on 2022/10/21.
//  
//

import SwiftUI

struct CodableEditorView<Value: Hashable>: View {
    
    let key: String
    @Binding private var value: Value
    @State private var text: String
    @State private var isValid: Bool
    
    private var rawValue: Value
    
    init(_ value: Binding<Value>, key: String) {
        self._value = value
        self.key = key
        self.rawValue = value.wrappedValue
        
        let codableValue = value.wrappedValue as! Codable
        self._text = .init(initialValue: codableValue.jsonString ?? "")
        self._isValid = .init(initialValue: true)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(typeDescription())
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(8)
            
            Spacer()
            
            TextEditor(text: $text)
                .border(.black, width: 0.5)
                .onChange(of: text) { newValue in
                    textChanged(text: newValue)
                }
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

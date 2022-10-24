//
//  CaseIterableEditor.swift
//  
//
//  Created by p-x9 on 2022/10/20.
//  
//

import SwiftUI

struct CaseIterableEditor<Value>: View {
    
    let key: String
    @Binding private var value: Value
    @State private var index: Int = 0
    
    private let allCases: [Value]
    
    init(_ value: Binding<Value>, key: String) {
        self._value = value
        self.key = key
        
        let type = Value.self as! any CaseIterable.Type
        self.allCases = type.allCases as! Array<Value>
        
        self._index = .init(wrappedValue: allCases.firstIndex(where: { "\($0)" == "\(value.wrappedValue)" }) ?? 0)
    }
    
    var body: some View {
        VStack {
            if allCases.isEmpty {
                Text("this type is currently not supported.")
            } else {
                editor
            }
        }
        .onChange(of: index) { newValue in
            value = allCases[newValue]
        }
    }
    
    @ViewBuilder
    var editor: some View {
        switch Value.self {
        case let type as any (CaseIterable & RawRepresentable).Type:
            let allCases = type.allCases as! Array<Value>
            Picker(key, selection: $index) {
                ForEach(0..<allCases.count, id: \.self) {
                    let rawValue = (allCases[$0] as! (any RawRepresentable)).rawValue
                    let text = "\(allCases[$0]) (\(rawValue))"
                    Text(text).tag($0)
                }
            }
            .pickerStyle(.automatic)
            
        case let type as any CaseIterable.Type:
            let allCases = type.allCases as! Array<Value>
            Picker(key, selection: $index) {
                ForEach(0..<allCases.count, id: \.self) {
                    let text = "\(allCases[$0])"
                    Text(text).tag($0)
                }
            }
            .pickerStyle(.automatic)
            
        default:
            Text("this type is currently not supported.")
        }
    }
}

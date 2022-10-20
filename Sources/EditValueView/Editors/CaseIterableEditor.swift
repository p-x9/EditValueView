//
//  CaseIterableEditor.swift
//  
//
//  Created by p-x9 on 2022/10/20.
//  
//

import SwiftUI

struct CaseIterableEditor<Value: Hashable>: View {
    
    let key: String
    @Binding private var value: Value
    
    init(_ value: Binding<Value>, key: String) {
        _value = value
        self.key = key
    }
    
    var body: some View {
        switch Value.self {
        case let type as any (CaseIterable & RawRepresentable).Type:
            let allCases = type.allCases as! Array<Value>
            Picker(key, selection: $value) {
                ForEach(allCases, id: \.hashValue) {
                    let rawValue = ($0 as! (any RawRepresentable)).rawValue
                    let text = "\(rawValue)"
                    Text(text).tag($0)
                }
            }
            .pickerStyle(.wheel)
            
        case let type as any CaseIterable.Type:
            let allCases = type.allCases as! Array<Value>
            Picker(key, selection: $value) {
                ForEach(allCases, id: \.hashValue) {
                    let text = "\($0)"
                    Text(text).tag($0)
                }
            }
            .pickerStyle(.wheel)
            
        default:
            Text("this type is currently not supported.")
        }
    }
}

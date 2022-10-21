//
//  ValueType.swift
//  
//
//  Created by p-x9 on 2022/10/22.
//  
//

import Foundation

enum ValueType {
    case int
    case double
    case string
    case bool
    case data
    
    indirect case optional(ValueType)
    
    indirect case array(ValueType)
    indirect case dictionary(ValueType, ValueType)
    
    case classOrStruct([String: ValueType])
    
    case unknown
    
    var typeName: String {
        _typeName(nestDepth: 0)
    }
    
    private func _typeName(nestDepth: Int) -> String {
        switch self {
        case .int:
            return "Int"
            
        case .double:
            return "Double"
            
        case .string:
            return "String"
            
        case .bool:
            return "Bool"
            
        case .data:
            return "Data"
            
        case let .optional(content):
            return "\(content.typeName)?"
            
        case let .array(content):
            return "[\(content.typeName)]"
            
        case let .dictionary(key, value):
            return "[\(key.typeName): \(value.typeName)]"
            
        case let .classOrStruct(dictionary):
            let tab = String(repeating: " ", count: nestDepth*2)
            let typeList = dictionary
                .sorted(by: { lhs, rhs in
                    lhs.key < rhs.key
                })
                .map {
                    tab + "  \($0): \($1._typeName(nestDepth: nestDepth+1))"
                }
            return """
            {
            \(typeList.joined(separator: "\n"))
            \(tab)}
            """
            
        case .unknown:
            return "unknown"
        }
    }
}

extension ValueType {
    static func extractType(for value: Any?) -> ValueType {
        guard let value = value else {
            return .optional(.unknown)
        }
        
        let mirror = Mirror(reflecting: value)
        
        let isOptional = mirror.displayStyle == .optional
        
        switch value {
        case _ as Int:
            return isOptional ? .optional(.int) : .int
            
        case _ as Double:
            return isOptional ? .optional(.double) : .double
            
        case _ as String:
            return isOptional ? .optional(.string) : .string
            
        case let array as Array<Any>:
            var type: ValueType = .unknown
            if let data = array.first  {
                type = extractType(for: data)
            }
            return isOptional ? .optional(.array(type)) : .array(type)
            
        case let dictionary as Dictionary<AnyHashable, Any>:
            var key: ValueType = .unknown
            var value: ValueType = .unknown
            if let data = dictionary.first {
                key = extractType(for: data.key)
                value = extractType(for: data.value)
            }
            return isOptional ?
                .optional(.dictionary(key, value)) :
                .dictionary(key, value)
            
        default:
            break
        }
        
        if mirror.displayStyle == .struct || mirror.displayStyle == .class {
            var description: [String: ValueType] = [:]
            for case let (label?, value) in mirror.children {
                description[label] = extractType(for: value)
            }
            return isOptional ?
                .optional(.classOrStruct(description)) :
                .classOrStruct(description)
        }
        
        return isOptional ? .optional(.unknown) : .unknown
    }
}

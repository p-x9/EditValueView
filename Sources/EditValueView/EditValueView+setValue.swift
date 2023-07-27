//
//  EditValueView+setValue.swift
//  
//
//  Created by p-x9 on 2023/07/23.
//  
//

import Foundation
import SwiftUI

extension EditValueView {
    func setDefault() {
        if let type = Value.self as? any DefaultRepresentable.Type,
           let defaultValue = type.defaultValue as? Value {
            value = defaultValue
        }
    }

    func setNil() {
        guard isOptional else { return }

        switch $value {
        case let v as Binding<String?>:
            v.wrappedValue = nil

        case let v as Binding<Bool?>:
            v.wrappedValue = nil

        case let v as Binding<Date?>:
            v.wrappedValue = nil

        case let v as Binding<Color?>:
            v.wrappedValue = nil

        case let v as Binding<CGColor?>:
            v.wrappedValue = nil

        case let v as Binding<NSUIColor?>:
            v.wrappedValue = nil

        case let v as Binding<CIColor?>:
            v.wrappedValue = nil

#if canImport(UIKit)
        case let v as Binding<Image?>:
            v.wrappedValue = nil

        case let v as Binding<NSUIImage?>:
            v.wrappedValue = nil

        case let v as Binding<CGImage?>:
            v.wrappedValue = nil

        case let v as Binding<CIImage?>:
            v.wrappedValue = nil
#endif

        case _ where Value.self is any Codable.Type,
            _ where Value.self is any OptionalNumeric.Type:
            if let type = Value.self as? any Codable.Type,
               let nilValue = type.value(from: "null") as? Value {
                value = nilValue
            }

        default:
            break
        }
    }
}

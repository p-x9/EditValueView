//
//  ColorEditorView.swift
//  
//
//  Created by p-x9 on 2022/10/30.
//  
//

import SwiftUI

struct ColorEditorView<Value>: View {

    let key: String

    @Binding private var value: Value

    @State private var color: CGColor

    init(_ value: Binding<Value>, key: String) {
        self._value = value
        self.key = key

        _color = .init(initialValue: Self.toCGColor(value.wrappedValue) ?? .defaultValue)
    }

    var body: some View {
        editor
            .onChange(of: color) { newValue in
                colorChanged(newValue)
            }
    }

    @ViewBuilder
    var editor: some View {
        ColorPicker(key, selection: $color)
            .padding()
            .border(Color.iOS(.label), width: 0.5)
    }

    func colorChanged(_ cgColor: CGColor) {
        switch Value.self {
        case is NSUIColor.Type:
            let v = NSUIColor(cgColor: cgColor)
            value = v as! Value
            break

        case is Color.Type:
            let v: Color
            if #available(iOS 15.0, macOS 12.0, *) {
                v = Color(cgColor: cgColor)
            } else {
                v = Color(cgColor)
            }
            value = v as! Value

        case is CIColor.Type:
            let v = CIColor(cgColor: cgColor)
            value = v as! Value

        case is CGColor.Type:
            value = cgColor as! Value

        default:
            break
        }
    }

    static func toCGColor(_ value: Value) -> CGColor? {
        switch value {
        case let v as NSUIColor:
            return v.cgColor

        case let v as CIColor:
            return NSUIColor(ciColor: v).cgColor

        case let v as Color:
            return v.cgColor

        case let v as CGColor where Value.self is CGColor.Type: // Conditional downcast to CoreFoundation type 'CGColor' will always succeed
            return v.copy()

        default:
            return nil
        }
    }
}

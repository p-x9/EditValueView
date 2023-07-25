//
//  EditValueView+EditorType.swift
//  
//
//  Created by p-x9 on 2023/07/23.
//  
//

import Foundation
import SwiftUI

extension EditValueView {
    enum EditorType {
        enum Line {
            case single, multi
        }
        case string
        case toggle
        case codable(Line)
        case caseiterable
        case color
        case image
        case date
        case none

        var shouldShowOptionalEditor: Bool {
            switch self {
            case .image, .codable(.multi), .caseiterable:
                return false
            default:
                return true
            }
        }
    }

    var editorType: EditorType {
        switch Value.self {
        case is String.Type,
            is String?.Type:
            return .string

        case is Bool.Type,
            is Bool?.Type:
            return .toggle

        case is any Numeric.Type,
            is any OptionalNumeric.Type:
            return .codable(.single)

        case is Date.Type,
            is Date?.Type:
            return .date

        case is Color.Type,
            is Color?.Type:
            return .color

        case is CGColor.Type,
            is CGColor?.Type:
            return .color

        case is NSUIColor.Type,
            is NSUIColor?.Type:
            return .color

        case is CIColor.Type,
            is CIColor?.Type:
            return .color

#if canImport(UIKit)
        case is Image.Type,
            is Image?.Type:
            return .image

        case is NSUIImage.Type,
            is NSUIImage?.Type:
            return .image

        case is CGImage.Type,
            is CGImage?.Type:
            return .image

        case is CIImage.Type,
            is CIImage?.Type:
            return .image
#endif

        case is any CaseIterable.Type,
            is any OptionalCaseIterable.Type:
            return .caseiterable
            
        case is any Codable.Type:
            return .codable(.multi)

        default:
            return .none
        }
    }
}

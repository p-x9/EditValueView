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
        case _ as String.Type,
            _ as String?.Type:
            return .string

        case _ as Bool.Type,
            _ as Bool?.Type:
            return .toggle

        case _ as any Numeric.Type,
            _ as any OptionalNumeric.Type:
            return .codable(.single)

        case _ as Date.Type,
            _ as Date?.Type:
            return .date

        case _ as Color.Type,
            _ as Color?.Type:
            return .color

        case _ as CGColor.Type,
            _ as CGColor?.Type:
            return .color

        case _ as NSUIColor.Type,
            _ as NSUIColor?.Type:
            return .color

        case _ as CIColor.Type,
            _ as CIColor?.Type:
            return .color

#if canImport(UIKit)
        case _ as Image.Type,
            _ as Image?.Type:
            return .image

        case _ as NSUIImage.Type,
            _ as NSUIImage?.Type:
            return .image

        case _ as CGImage.Type,
            _ as CGImage?.Type:
            return .image

        case _ as CIImage.Type,
            _ as CIImage?.Type:
            return .image
#endif

        case _ as any CaseIterable.Type,
            _ as any OptionalCaseIterable.Type:
            return .caseiterable

        case _ as any Codable.Type:
            return .codable(.multi)

        default:
            return .none
        }
    }
}

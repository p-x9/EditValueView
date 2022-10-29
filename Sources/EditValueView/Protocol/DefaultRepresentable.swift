//
//  DefaultRepresentable.swift
//
//
//  Created by p-x9 on 2022/10/17.
//
//
import Foundation
import CoreGraphics

public protocol DefaultRepresentable {
    static var defaultValue: Self { get }
}

extension String: DefaultRepresentable {
    public static var defaultValue: String {
        ""
    }
}
extension Int: DefaultRepresentable {
    public static var defaultValue: Int {
        0
    }
}

extension Float: DefaultRepresentable {
    public static var defaultValue: Float {
        0.0
    }
}

extension Double: DefaultRepresentable {
    public static var defaultValue: Double {
        0.0
    }
}

extension NSNumber: DefaultRepresentable {
    public static var defaultValue: Self {
        0
    }
}

extension Bool: DefaultRepresentable {
    public static var defaultValue: Bool {
        false
    }
}

extension Date: DefaultRepresentable {
    public static var defaultValue: Date {
        .init()
    }
}

extension Data: DefaultRepresentable {
    public static var defaultValue: Data {
        .init()
    }
}

extension Array: DefaultRepresentable {
    public static var defaultValue: Array<Element> {
        []
    }
}

extension Dictionary: DefaultRepresentable {
    public static var defaultValue: Dictionary<Key, Value> {
        [:]
    }
}

extension CGFloat: DefaultRepresentable {
    public static var defaultValue: CGFloat {
        0.0
    }
}

extension CGSize: DefaultRepresentable {
    public static var defaultValue: CGSize {
        .init(width: 0, height: 0)
    }
}

extension CGPoint: DefaultRepresentable {
    public static var defaultValue: CGPoint {
        .init(x: 0 , y: 0)
    }
}

extension CGRect: DefaultRepresentable {
    public static var defaultValue: CGRect {
        .init(origin: .defaultValue, size: .defaultValue)
    }
}


extension CGColor: DefaultRepresentable {
    public static var defaultValue: Self {
        .init(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

#if canImport(CoreImage)
import CoreImage
extension CIColor: DefaultRepresentable {
    public static var defaultValue: Self {
        .init()
    }
}
#endif


extension NSUIColor: DefaultRepresentable {
    public static var defaultValue: Self {
        .init()
    }
}

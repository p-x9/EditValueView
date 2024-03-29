//
//  OptionalType.swift
//  
//
//  Created by p-x9 on 2023/07/23.
//  
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped

    var wrapped: Wrapped? { get }
}

extension OptionalType {
    static var isWrappedCaseiterable: Bool {
        Wrapped.self is any CaseIterable.Type
    }
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? { self }
}

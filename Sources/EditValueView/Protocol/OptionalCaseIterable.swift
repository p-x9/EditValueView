//
//  OptionalCaseIterable.swift
//  
//
//  Created by p-x9 on 2023/07/23.
//  
//

import Foundation

public protocol OptionalCaseIterable: OptionalType where Wrapped: CaseIterable {
    /// A type that can represent a collection of all values of this type.
    associatedtype OptionalAllCases : Collection = [Wrapped?] where Wrapped == Wrapped.AllCases.Element

    /// A collection of all values of this type.
    static var optionalAllCases: Self.OptionalAllCases { get }
}

extension OptionalCaseIterable {
    public static var optionalAllCases: [Wrapped?] {
        Array(Wrapped.allCases.map { .some($0) })
    }
}

extension Optional: OptionalCaseIterable where Wrapped: CaseIterable {}

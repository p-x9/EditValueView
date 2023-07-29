//
//  View+.swift
//  
//
//  Created by p-x9 on 2023/07/30.
//  
//

import SwiftUI

extension View {
    func set<T>(_ value: T, for keyPath: WritableKeyPath<Self, T>) -> Self {
        var new = self
        new[keyPath: keyPath] = value
        return new
    }
}

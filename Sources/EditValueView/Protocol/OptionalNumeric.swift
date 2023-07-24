//
//  OptionalNumeric.swift
//  
//
//  Created by p-x9 on 2023/07/23.
//  
//

import Foundation

public protocol OptionalNumeric: OptionalType where Wrapped: Numeric {}

extension Optional: OptionalNumeric where Wrapped: Numeric {}

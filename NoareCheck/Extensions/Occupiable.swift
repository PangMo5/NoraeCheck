//
//  Occupiable.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/21.
//

import Foundation

// Anything that can hold a value (strings, arrays, etc.)
public protocol Occupiable {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

public extension Occupiable {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Occupiable {}
// I can't think of a way to combine these collection types. Suggestions welcomed!
extension Array: Occupiable {}
extension Dictionary: Occupiable {}
extension Set: Occupiable {}

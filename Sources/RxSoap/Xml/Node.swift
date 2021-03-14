//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public enum MappingError: Error {
    case notfound
}

public protocol Node {
    var xml: String { get }

    var first: Node { get }
    var elements: [Node] { get }

    func read<T: Mappable>(_ key: String) throws -> T
    func read<T: Mappable>(_ key: String) -> T?

    func descendant(name: String) -> Node?
    func descendants(name: String) -> [Node]
}

public extension Node {
    var first: Node {
        return elements[0]
    }

    func read<T: Mappable>(_ key: String) throws -> T {
        guard let value: T = read(key) else {
            throw MappingError.notfound
        }
        return value
    }
}

public func << <T: Mappable>(node: Node, key: String) throws -> T {
    return try node.read(key)
}



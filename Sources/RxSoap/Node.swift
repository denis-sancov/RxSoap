//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public enum MappingError: Error {
    case absent
}

public protocol Node {
    var xml: String { get }

    var first: Node { get }
    var elements: [Node] { get }

    func read<T: Mappable>(key: String) throws -> T
    func read<T: Mappable>(key: String) -> T?

    func read<T: Mappable>(attribute: String) throws -> T
    func read<T: Mappable>(attribute: String) -> T?

    func descendant(name: String) -> Node?
    func descendant(closure: @escaping (Node) -> Bool) -> Node?

    func descendants(name: String) -> [Node]
}

public extension Node {
    var first: Node {
        return elements[0]
    }

    func read<T: Mappable>(key: String) throws -> T {
        guard let value: T = read(key: key) else {
            throw MappingError.absent
        }
        return value
    }

    func read<T: Mappable>(attribute: String) throws -> T {
        guard let value: T = read(attribute: attribute) else {
            throw MappingError.absent
        }
        return value
    }
}

public func << <T: Mappable>(node: Node, key: String) throws -> T {
    return try node.read(key: key)
}



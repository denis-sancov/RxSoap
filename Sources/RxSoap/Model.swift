//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public protocol Model {
    init(node: Node) throws
}

public typealias NodeTransform<T> = (Node) throws -> T

extension Array: Model where Element: Model {
    public init(node: Node) throws {
        self.init(node: node) {
            try Element(node: $0)
        }
    }

    public init(node: Node, transform: NodeTransform<Element>) {
        let items = try? node.descendant(name: "ResultStatus")?.elements.map(transform)
        self.init(items ?? [])
    }
}

//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation
import AEXML

struct Envelope {
    public let code: Int
    public let msg: String
    public let data: Node?

    init(data: Data) throws {
        var options = AEXMLOptions()
        options.parserSettings.shouldProcessNamespaces = true

        let doc = try AEXMLDocument(xml: data, options: options)

        #if DEBUG
        print("process document: \(doc.xml)")
        #endif

        let result = doc.root.firstDescendant {
            $0.name.contains("Result")
        }!

        self.code = (try? result << "Code") ?? -1

        let key: String = {
            switch Locale.current.languageCode {
            case "ru":
                return "MessageRU"
            case "ro":
                return "MessageRO"
            default:
                return "Message"
            }
        }()

        let message: String? = try? result << key
        let fallbackMsg: String = (try? result << "Message") ?? ""

        self.msg = message ?? fallbackMsg

        self.data = result.descendant(name: "diffgram")
    }
}

extension AEXMLElement: Node {
    public var elements: [Node] {
        return children
    }

    public func read<T>(_ key: String) -> T? where T : Mappable {
        return try? T.map(value: self[key].string)
    }

    public func descendant(name: String) -> Node? {
        return firstDescendant { $0.name == name }
    }

    public func descendants(name: String) -> [Node] {
        return allDescendants { $0.name == name }
    }
}

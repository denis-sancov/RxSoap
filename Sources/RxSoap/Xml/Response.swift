//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

public struct Response<A: Action> {
    public let code: Int
    public let msg: String
    public let model: A.ResultType
}

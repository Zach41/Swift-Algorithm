//
// Created by ZachZhang on 2017/3/26.
// Copyright (c) 2017 zach. All rights reserved.
//

import Foundation

public struct Edge<T>: Equatable where T: Equatable, T: Hashable {
    public let from: Vertex<T>
    public let to: Vertex<T>

    public let weight: Double?
}

public func ==<T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    guard lhs.from == rhs.from else {
        return false
    }
    guard  lhs.to == rhs.to else {
        return false
    }
    guard lhs.weight == rhs.weight else {
        return false
    }
    return true
}

extension Edge: CustomStringConvertible {
    public var description: String {
        if let weight = weight {
            return "\(from.description) -(\(weight))-> \(to.description)"
        } else {
            return "\(from.description) -> \(to.description)"
        }
    }
}

extension Edge: Hashable {
    public var hashValue: Int {
        get {
            var string = "\(from.description)\(to.description)"
            if weight != nil {}
            string.append("\(weight!)")
            return string.hashValue
        }
    }
}
//
// Created by ZachZhang on 2017/3/26.
// Copyright (c) 2017 zach. All rights reserved.
//

import Foundation

open class AbstractGraph<T>: CustomStringConvertible where T: Equatable, T: Hashable {
    public required init() {}

    public required init(fromGraph graph: AbstractGraph<T>) {
        for edge in graph.edges {
            let from = createVertex(edge.from.data)
            let to = createVertex(edge.to.data)

            addDirectedEdge(from, to: to, withWeight: edge.weight)
        }
    }

    open var description: String {
        get {
            fatalError("abstract property accessed")
        }
    }

    open var vertices: [Vertex<T>] {
        get {
            fatalError("abstract property accessed")
        }
    }

    open var edges: [Edge<T>] {
        get {
            fatalError("abstract property accessed")
        }
    }

    open func createVertex(_ data: T) -> Vertex<T> {
        fatalError("abstract function called")
    }


    open func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        fatalError("abstract function called")
    }

    open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        fatalError("abstract function called")
    }

    open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        fatalError("abstract function called")
    }

    open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        fatalError("abstract function called")
    }
}

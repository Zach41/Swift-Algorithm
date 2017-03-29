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

//    open func dfsTraverse(source: Vertex<T>) -> [Vertex<T>] {
//        fatalError("abstract function called")
//    }
//
//    open func bfsTraverse(source: Vertex<T>) -> [Vertex<T>] {
//        fatalError("abstract function called")
//    }

    private func _dfsTraverse(source: Vertex<T>, visited visited: inout [Bool]) -> [Vertex<T>] {
        guard !visited[source.index] else {
            return []
        }

        var outValues = [source]
        visited[source.index] = true
        let edges = edgesFrom(source)
        for edge in edges {
            outValues += _dfsTraverse(source: edge.to, visited: &visited)
        }

        return outValues
    }

    public func dfsTraverse(source: Vertex<T>) -> [Vertex<T>] {
        var visited = [Bool](repeating: false, count: vertices.count)

        return _dfsTraverse(source: source, visited: &visited)
    }

    public func bfsTraverse(source: Vertex<T>) -> [Vertex<T>] {
        var visited = [Bool](repeating: false, count: vertices.count)

        var outValues = [Vertex<T>]()
        var nodeQueue = Queue<Vertex<T>>()
        nodeQueue.enqueue(source)

        while !nodeQueue.isEmpty {
            let top = nodeQueue.dequeue()!
            guard !visited[top.index] else {
                continue
            }
            visited[top.index] = true
            outValues.append(top)
            let edges = edgesFrom(top)
            for edge in edges {
                nodeQueue.enqueue(edge.to)
            }
        }
        return outValues
    }

    open func dijkstra(_ sourceVertex: Vertex<T>) -> [Double] {
        fatalError("abstract function called")
    }
}

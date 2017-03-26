//
// Created by ZachZhang on 2017/3/26.
// Copyright (c) 2017 zach. All rights reserved.
//

import Foundation

open class AdjacencyMatrixGrapgh<T>: AbstractGraph<T> where T: Equatable, T: Hashable {
    fileprivate var adjacencyMatrix: [[Double?]] = []
    fileprivate var _vertices: [Vertex<T>] = []

    public required init() {
        super.init()
    }

    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }

    open override var vertices: [Vertex<T>] {
        return _vertices
    }

    open override var edges: [Edge<T>] {
        get {
            var edges = [Edge<T>]()
            for row in 0..<adjacencyMatrix.count {
                for column in 0..<adjacencyMatrix.count {
                    if let weight = adjacencyMatrix[row][column] {
                        edges.append(Edge(from: vertices[row], to: vertices[column], weight: weight))
                    }
                }
            }
            return edges
        }
    }

    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchedVertices = vertices.filter {
            vertex in
            vertex.data == data
        }

        if matchedVertices.count > 0 {
            return matchedVertices.last!
        }

        let vertex = Vertex(data: data, index: vertices.count)

        for i in 0..<adjacencyMatrix.count {
            adjacencyMatrix[i].append(nil)
        }

        let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)

        _vertices.append(vertex)

        return vertex
    }

    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        adjacencyMatrix[from.index][to.index] = weight
    }

    open override func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }

    open override func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
    }

    open override func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        var edges = [Edge<T>]()

        let fromIndex = sourceVertex.index
        for i in 0..<adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][i] {
                edges.append(Edge(from: vertices[fromIndex], to: vertices[i], weight: weight))
            }
        }
        return edges
    }

    open override var description: String {
        var grid = [String]()
        let length = adjacencyMatrix.count

        for i in 0 ..< length {
            var row = ""
            for j in 0 ..< length {
                if let value = adjacencyMatrix[i][j] {
                    row += "\(value)"
                } else {
                    row += "N"
                }
                if j != length - 1 {
                    row += "\t"
                }
            }
            grid.append(row)
        }
        return grid.joined(separator: "\n")
    }
}

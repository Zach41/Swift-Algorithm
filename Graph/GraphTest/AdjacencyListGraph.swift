//
// Created by ZachZhang on 2017/3/26.
// Copyright (c) 2017 zach. All rights reserved.
//

import Foundation

private class EdgeList<T> where T: Equatable, T: Hashable {
    var vertex: Vertex<T>
    var edges: [Edge<T>]? = nil

    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }

    func addEdge(_ edge: Edge<T>) {
        self.edges?.append(edge)
    }
}

public class AdjacencyListGraph<T>: AbstractGraph<T> where T: Equatable, T: Hashable {
    fileprivate var adjacentList: [EdgeList<T>] = []

    public required init() {
        super.init()
    }

    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }

    open override var vertices: [Vertex<T>] {
        var vertices: [Vertex<T>] = []
        for edgeList in adjacentList {
            vertices.append(edgeList.vertex)
        }
        return vertices
    }

    open override var edges: [Edge<T>] {
        var ret_edges = Set<Edge<T>>()
        for edgeList in adjacentList {
            guard let edges = edgeList.edges else {
                continue
            }
            for edge in edges {
                ret_edges.insert(edge)
            }
        }
        return Array(ret_edges)
    }

    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchedVertices = vertices.filter {
            vertex in
            vertex.data == data
        };

        if matchedVertices.count > 0 {
            return matchedVertices.last!
        }

        let vertex = Vertex(data: data, index: vertices.count)
        adjacentList.append(EdgeList(vertex: vertex))
        return vertex
    }

    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        let edge = Edge(from: from, to: to, weight: weight)
        let edgeList = adjacentList[from.index]
        if let _ = edgeList.edges {
            edgeList.addEdge(edge)
        } else {
            edgeList.edges = [edge]
        }
    }

    open override func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }

    open override func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        let edgeList = adjacentList[sourceVertex.index];

        guard let egdes = edgeList.edges else {
            return nil
        }
        for edge in edges {
            if edge.to == destinationVertex {
                return edge.weight
            }
        }
        return nil
    }

    open override func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacentList[sourceVertex.index].edges ?? []
    }

    open override var description: String {
        get {
            var rows = [String]()
            for edgeList in adjacentList {
                guard let edges = edgeList.edges else {
                    continue
                }
                var row = [String]()
                for edge in edges {
                    var value = "\(edge.to.data)"
                    if edge.weight != nil {
                        value = "(\(value): \(edge.weight!))"
                    }
                    row.append(value)
                }
                rows.append("\(edgeList.vertex.data) -> [\(row.joined(separator: ", "))]")
            }
            return rows.joined(separator: "\n")
        }
    }

    open override func dijkstra(_ sourceVertex: Vertex<T>) -> [Double] {
        var visited = [Bool](repeating: false, count: vertices.count)
        var dist = [Double](repeating: DBL_MAX, count: vertices.count)

        dist[sourceVertex.index] = 0
        visited[sourceVertex.index] = true

        let edgeList = adjacentList[sourceVertex.index]
        guard let edges = edgeList.edges else {
            return dist
        }
        for edge in edges {
            dist[edge.to.index] = edge.weight ?? DBL_MAX
        }

        for _ in 0..<vertices.count - 1 {
            var minDist = DBL_MAX
            var minIdx = 0
            for j in 0..<vertices.count {
                if minDist > dist[j] && !visited[j] {
                    minIdx = j
                    minDist = dist[j]
                }
            }
            visited[minIdx] = true
            guard let edges = adjacentList[minIdx].edges else {
                continue
            }
            for edge in edges {
                if dist[edge.to.index] > dist[minIdx] + edge.weight! {
                    dist[edge.to.index] = dist[minIdx] + edge.weight!
                }
            }
        }
        return dist
    }
}


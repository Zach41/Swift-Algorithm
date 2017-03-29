//
//  GraphTest.swift
//  GraphTest
//
//  Created by ZachZhang on 2017/3/26.
//
//

import XCTest

class GraphTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdjacencyListGraphDescription() {
        let graph = AdjacencyListGraph<String>()
        let a = graph.createVertex("a");
        let b = graph.createVertex("b");
        let c = graph.createVertex("c");

        graph.addDirectedEdge(a, to: b, withWeight: 1.0)
        graph.addDirectedEdge(a, to: c, withWeight: -5.5)
        graph.addDirectedEdge(b, to: c, withWeight: 2.0)

        let expectedValue = "a -> [(b: 1.0), (c: -5.5)]\nb -> [(c: 2.0)]"
        XCTAssertEqual(graph.description, expectedValue)
    }

    func testAdjacencyMatrixGraphDescription() {
        let graph = AdjacencyMatrixGrapgh<String>()
        let a = graph.createVertex("a")
        let b = graph.createVertex("b")
        let c = graph.createVertex("c")

        graph.addDirectedEdge(a, to: b, withWeight: 1.0)
        graph.addDirectedEdge(b, to: c, withWeight: 2.0)
        let expectedValue = "N\t1.0\tN\nN\tN\t2.0\nN\tN\tN"
        XCTAssertEqual(graph.description, expectedValue)
    }

    func testAddingPreexistingVertex() {
        let matrixGraph = AdjacencyMatrixGrapgh<String>()
        let listGraph = AdjacencyListGraph<String>()

        for graph in [matrixGraph, listGraph] {
            let a = graph.createVertex("a")
            let b = graph.createVertex("a")

            XCTAssertEqual(a, b)
            XCTAssertEqual(graph.vertices.count, 1)
        }
    }

    func testEdgesFromReturn1(_ graph: AbstractGraph<Int>) {
        let a = graph.createVertex(1)
        let b = graph.createVertex(2)

        graph.addDirectedEdge(a, to: b, withWeight: 1.0)
        let edgesFromA = graph.edgesFrom(a)
        let edgesFromB = graph.edgesFrom(b)

        XCTAssertEqual(edgesFromA.count, 1)
        XCTAssertEqual(edgesFromB.count, 0)

        XCTAssertEqual(edgesFromA.first?.to, b)
    }

    func testEdgesFromReturn2(_ graph: AbstractGraph<Int>) {
        let a = graph.createVertex(1)
        let b = graph.createVertex(2)

        graph.addUndirectedEdge((a, b), withWeight: 1.0)
        let edgesFromA = graph.edgesFrom(a)
        let edgesFromB = graph.edgesFrom(b)

        XCTAssertEqual(edgesFromA.count, 1)
        XCTAssertEqual(edgesFromB.count, 1)

        XCTAssertEqual(edgesFromA.first?.to, b)
        XCTAssertEqual(edgesFromB.first?.to, a)
    }

    func testEdgesFromReturn3(_ graph: AbstractGraph<Int>) {
        print(graph.description)
        let a = graph.createVertex(1)

        let edgesFromA = graph.edgesFrom(a)
        print(graph.description)
        XCTAssertEqual(edgesFromA.count, 0)
    }

    func testLargeGraph(_ graph: AbstractGraph<Int>) {
        let verticesCount = 100
        var vertices = [Vertex<Int>]()
        for i in 0..<verticesCount {
            vertices.append(graph.createVertex(i))
        }

        for i in 0..<verticesCount {
            for j in i + 1..<verticesCount {
                graph.addDirectedEdge(vertices[i], to: vertices[j], withWeight: 1)
            }
        }

        for i in 0..<verticesCount {
            let outEdges = graph.edgesFrom(vertices[i])
            let toVerices = outEdges.map { $0.to }
            XCTAssertEqual(outEdges.count, verticesCount - i - 1)
            for j in i+1 ..< verticesCount {
                XCTAssertTrue(toVerices.contains(vertices[j]))
            }
        }
    }

    func testMatrix() {
        var graph = AdjacencyMatrixGrapgh<Int>()
        testEdgesFromReturn1(graph)
        graph = AdjacencyMatrixGrapgh<Int>()
        testEdgesFromReturn2(graph)
        graph = AdjacencyMatrixGrapgh<Int>()
        testEdgesFromReturn3(graph)
        graph = AdjacencyMatrixGrapgh<Int>()
        testLargeGraph(graph)
    }

    func testAdjacencyList() {
        var graph = AdjacencyListGraph<Int>()
        testEdgesFromReturn1(graph)
        graph = AdjacencyListGraph<Int>()
        testEdgesFromReturn3(graph)
        graph = AdjacencyListGraph<Int>()
        testEdgesFromReturn2(graph)
        graph = AdjacencyListGraph<Int>()
        testLargeGraph(graph)
    }

    func testDFS(_ graph: AbstractGraph<Int>) {
//        let graph = AdjacencyMatrixGrapgh<Int>()

        let a = graph.createVertex(1)
        let b = graph.createVertex(2)
        let c = graph.createVertex(3)
        let d = graph.createVertex(4)
        let e = graph.createVertex(5)

        graph.addDirectedEdge(a, to: b, withWeight: 1.0)
        graph.addDirectedEdge(a, to: d, withWeight: 1.0)
        graph.addDirectedEdge(b, to: c, withWeight: 1.0)
        graph.addDirectedEdge(c, to: d, withWeight: 1.0)
        graph.addDirectedEdge(d, to: b, withWeight: 1.0)
        graph.addDirectedEdge(d, to: e, withWeight: 1.0)

        let dfsTraversed = graph.dfsTraverse(source: a)
        XCTAssertEqual(dfsTraversed, [a, b, c, d, e])
    }

    func testBFS(_ graph: AbstractGraph<Int>) {
//        let graph = AdjacencyMatrixGrapgh<Int>()

        let a = graph.createVertex(1)
        let b = graph.createVertex(2)
        let c = graph.createVertex(3)
        let d = graph.createVertex(4)
        let e = graph.createVertex(5)

        graph.addDirectedEdge(a, to: b, withWeight: 1.0)
        graph.addDirectedEdge(a, to: d, withWeight: 1.0)
        graph.addDirectedEdge(b, to: c, withWeight: 1.0)
        graph.addDirectedEdge(c, to: d, withWeight: 1.0)
        graph.addDirectedEdge(d, to: b, withWeight: 1.0)
        graph.addDirectedEdge(d, to: e, withWeight: 1.0)

        let dfsTraversed = graph.bfsTraverse(source: a)
        XCTAssertEqual(dfsTraversed, [a, b, d, c, e])
    }

    func testAdjacencyListTraverse() {
        var graph = AdjacencyListGraph<Int>()
        testDFS(graph)
        graph = AdjacencyListGraph<Int>()
        testBFS(graph)
    }

    func testAdjacencyMatrixTraverse() {
        var graph = AdjacencyMatrixGrapgh<Int>()
        testDFS(graph)
        graph = AdjacencyMatrixGrapgh()
        testBFS(graph)
    }

    func testAdjacencyMatrixDijkstra() {
        let graph = AdjacencyMatrixGrapgh<Int>()

        let a1 = graph.createVertex(1)
        let a2 = graph.createVertex(2)
        let a3 = graph.createVertex(3)
        let a4 = graph.createVertex(4)
        let a5 = graph.createVertex(5)
        let a6 = graph.createVertex(6)

        graph.addDirectedEdge(a1, to: a2, withWeight: 1.0)
        graph.addDirectedEdge(a1, to: a3, withWeight: 12.0)
        graph.addDirectedEdge(a2, to: a3, withWeight: 9.0)
        graph.addDirectedEdge(a2, to: a4, withWeight: 3.0)
        graph.addDirectedEdge(a3, to: a5, withWeight: 5.0)
        graph.addDirectedEdge(a4, to: a3, withWeight: 4.0)
        graph.addDirectedEdge(a4, to: a5, withWeight: 13.0)
        graph.addDirectedEdge(a4, to: a6, withWeight: 15.0)
        graph.addDirectedEdge(a5, to: a6, withWeight: 4.0)

        let shortestPathsFromA1 = graph.dijkstra(a1);

        XCTAssertEqual(shortestPathsFromA1, [0.0, 1.0, 8.0, 4.0, 13.0, 17.0])
    }

    func testAdjacencyListDijkstra() {
        let graph = AdjacencyListGraph<Int>()

        let a1 = graph.createVertex(1)
        let a2 = graph.createVertex(2)
        let a3 = graph.createVertex(3)
        let a4 = graph.createVertex(4)
        let a5 = graph.createVertex(5)
        let a6 = graph.createVertex(6)

        graph.addDirectedEdge(a1, to: a2, withWeight: 1.0)
        graph.addDirectedEdge(a1, to: a3, withWeight: 12.0)
        graph.addDirectedEdge(a2, to: a3, withWeight: 9.0)
        graph.addDirectedEdge(a2, to: a4, withWeight: 3.0)
        graph.addDirectedEdge(a3, to: a5, withWeight: 5.0)
        graph.addDirectedEdge(a4, to: a3, withWeight: 4.0)
        graph.addDirectedEdge(a4, to: a5, withWeight: 13.0)
        graph.addDirectedEdge(a4, to: a6, withWeight: 15.0)
        graph.addDirectedEdge(a5, to: a6, withWeight: 4.0)

        let shortestPathsFromA1 = graph.dijkstra(a1);

        XCTAssertEqual(shortestPathsFromA1, [0.0, 1.0, 8.0, 4.0, 13.0, 17.0])
    }
}

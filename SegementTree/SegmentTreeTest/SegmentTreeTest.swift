//
//  SegmentTreeTest.swift
//  SegmentTreeTest
//
//  Created by ZachZhang on 2017/3/24.
//
//

import XCTest

class SegmentTreeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuery() {
        let tree: SegmentTree<Int> = SegmentTree(array: [1, 2, 3, 4, 5, 6, 7, 8],
                leftBound: 0, rightBound: 7, function: +)
        XCTAssertEqual(tree.query(withLeftBound: 0, rightBound: 4), 15)
        XCTAssertEqual(tree.query(withLeftBound: 2, rightBound: 5), 18)
        XCTAssertEqual(tree.query(withLeftBound: 0, rightBound: 7), 36)
    }
    
    func testReplace() {
        let tree: SegmentTree<Int> = SegmentTree(array: [1, 2, 3, 4, 5, 6, 7, 8],
                leftBound: 0, rightBound: 7, function: max)
        XCTAssertEqual(tree.query(withLeftBound: 2, rightBound: 5), 6)

        tree.replaceItem(at: 3, withItem: 10)
        XCTAssertEqual(tree.query(withLeftBound: 2, rightBound: 5), 10)
    }
    
    func testSegmentTreePerformance() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let array = Array(repeating: 1, count: 10000)
            let tree = SegmentTree(array: array, leftBound: 0, rightBound: array.count - 1, function: +)
            for i in 0..<array.count - 100 {
                XCTAssertEqual(tree.query(withLeftBound: i, rightBound: 100 + i), 101)
            }
        }
    }

    func testNormalPerformance() {
        self.measure {
            let array = Array(repeating: 1, count: 10000)
            for i in 0..<array.count - 100 {
                XCTAssertEqual(array[i...i+100].reduce(0, +), 101)
            }
        }
    }
    
}

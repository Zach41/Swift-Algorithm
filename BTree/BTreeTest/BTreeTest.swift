//
//  BTreeTest.swift
//  BTreeTest
//
//  Created by ZachZhang on 2017/3/24.
//
//

import XCTest

class BTreeTest: XCTestCase {
    var btree: BTree<Int, Int>!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        btree = BTree(order: 3)!
    }

    func testOrder() {
        XCTAssertEqual(btree.order, 3)
    }

    func testRootNode() {
        XCTAssertNotNil(btree.rootNode)
    }

    func testNumberOfKeysOnEmptyTree() {
        XCTAssertEqual(btree.numberOfKeys, 0)
    }

    func testSubscriptEmptyTree() {
        XCTAssertNil(btree[1])
    }

    func testSearchEmptyTree() {
        XCTAssertNil(btree.value(for: 1))
    }

    func testDescriptionOnEmptyTree() {
        XCTAssertEqual(btree.description, "[]")
    }

    func testInOrderTraversal() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }

        var j = 1

        btree.traverseKeysInOrder {
            i in
            XCTAssertEqual(i, j)
            j += 1
        }
    }

    func testSearchMaximumMinimum() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }

        XCTAssertEqual(btree.value(for: 20)!, 20)

        XCTAssertEqual(btree.value(for: 1)!, 1)
    }

    func testInsertion() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }

        XCTAssertEqual(btree.numberOfKeys, 20)

        for i in 1...20 {
            XCTAssertEqual(btree.value(for: i)!, i)
        }

        do {
            try btree.checkBalance()
        } catch {
            XCTFail("BTree not balanced")
        }
    }

    func testRemove() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }
        btree.remove(20)
        XCTAssertNil(btree[20])

        btree.remove(1)
        XCTAssertNil(btree[1])

        btree.remove(9)
        XCTAssertNil(btree[9])

        do {
            try btree.checkBalance()
        } catch {
            XCTFail("BTree not balanced")
        }
    }

    func testRemoveAll() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }

        XCTAssertEqual(btree.numberOfKeys, 20)

        for i in 1...20 {
            btree.remove(i)
        }

        XCTAssertEqual(btree.numberOfKeys, 0)
        XCTAssertNil(btree[11])

        do {
            try btree.checkBalance()
        } catch {
            XCTFail("BTree not balanced")
        }
    }

    func testInorderArray() {
        for i in 1...20 {
            btree.insert(i, for: i)
        }

        let returnedArray = btree.inOrderArrayFromKeys
        XCTAssertEqual(returnedArray, Array<Int>(1...20))
    }
}

enum BTreeError: Error {
    case TooManyNodes
    case TooFewNodes
}

extension BTreeNode {
    func checkBalance(isRoot root: Bool) throws {
        if numberOfKeys > 2 * owner.order {
            throw  BTreeError.TooManyNodes
        } else if !root && numberOfKeys < owner.order {
            throw BTreeError.TooFewNodes
        }

        if !isLeaf {
            for child in children! {
                try child.checkBalance(isRoot: false)
            }
        }
    }
}

extension BTree {
    func checkBalance() throws {
        try rootNode.checkBalance(isRoot: true)
    }
}

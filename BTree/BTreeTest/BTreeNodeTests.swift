//
// Created by ZachZhang on 2017/3/23.
//

import XCTest

class BTreeNodeTests: XCTestCase {
    let owner = BTree<Int, Int>(order: 2)!
    var root : BTreeNode<Int, Int>!
    var leftChild: BTreeNode<Int, Int>!
    var rightChild: BTreeNode<Int, Int>!

    override func setUp() {
        super.setUp()

        root = BTreeNode(owner: owner)
        leftChild = BTreeNode(owner: owner)
        rightChild = BTreeNode(owner: owner)

        root.insert(1, for: 1)
        root.children = [leftChild, rightChild]
    }

    func testIsLeafRoot() {
        XCTAssertFalse(root.isLeaf)
    }

    func testisLeafLeaf() {
        XCTAssertTrue(leftChild.isLeaf)
        XCTAssertTrue(rightChild.isLeaf)
    }

    func testOwner() {
        XCTAssert(root.owner === owner)
        XCTAssert(leftChild.owner === owner)
        XCTAssert(rightChild.owner === owner)
    }

    func testNumberOfKeys() {
        XCTAssertEqual(root.numberOfKeys, 1)
        XCTAssertEqual(leftChild.numberOfKeys, 0)
        XCTAssertEqual(rightChild.numberOfKeys, 0)
    }

    func testChildren() {
        XCTAssertEqual(root.children!.count, 2)
    }
}

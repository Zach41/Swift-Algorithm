//
//  BinarySearchTest.swift
//  BinarySearchTest
//
//  Created by ZachZhang on 2017/3/9.
//
//

import XCTest

class BinarySearchTreeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRootNode() {
        let tree = BinarySearchTree(value: 8)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.minimum().value, 8)
        XCTAssertEqual(tree.maximum().value, 8)
        XCTAssertEqual(tree.depth(), 0)
        XCTAssertEqual(tree.toArray(), [8])
    }
    
    func testFromArray() {
        let tree = BinarySearchTree(array: [8, 5, 10, 3, 12, 9, 6, 16])
        XCTAssertEqual(tree.count, 8)
        XCTAssertEqual(tree.toArray(), [3, 5, 6, 8, 9, 10, 12, 16])
        
        XCTAssertEqual(tree.search(value: 9)?.value, 9)
        XCTAssertNil(tree.search(value: 11))
        
        XCTAssertEqual(tree.minimum().value, 3)
        XCTAssertEqual(tree.maximum().value, 16)
        
        XCTAssertEqual(tree.depth(), 0)
        
        let node1 = tree.search(value: 16)
        XCTAssertNotNil(node1)
        XCTAssertEqual(node1!.value, 16)
        XCTAssertEqual(node1!.depth(), 3)
        
        let node2 = tree.search(value: 12)
        XCTAssertNotNil(node2)
        XCTAssertEqual(node2!.depth(), 2)
        XCTAssertEqual(node2!.value, 12)
        
        let node3 = tree.search(value: 10)
        XCTAssertNotNil(node3)
        XCTAssertEqual(node3!.value, 10)
        XCTAssertEqual(node3!.depth(), 1)
    }
    
    func testInsert() {
        let tree = BinarySearchTree(value: 8)
        tree.insert(value: 5)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.depth(), 0)
        
        let node1 = tree.search(value: 5)
        XCTAssertNotNil(node1)
        XCTAssertEqual(node1!.value, 5)
        XCTAssertEqual(node1!.depth(), 1)
        
        tree.insert(value: 10)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.depth(), 0)
        
        let node2 = tree.search(value: 10)
        XCTAssertNotNil(node2)
        XCTAssertEqual(node2!.value, 10)
        XCTAssertEqual(node2!.depth(), 1)
        
        tree.insert(value: 3)
        XCTAssertEqual(tree.count, 4)
        XCTAssertEqual(tree.depth(), 0)
        
        let node3 = tree.search(value: 3)
        XCTAssertNotNil(node3)
        XCTAssertEqual(node3!.value, 3)
        XCTAssertEqual(node3!.depth(), 2)
        
        XCTAssertEqual(tree.minimum().value, 3)
        XCTAssertEqual(tree.maximum().value, 10)
        XCTAssertEqual(tree.toArray(), [3, 5,  8, 10])
    }
    
    func testInsertDuplicate() {
        let tree = BinarySearchTree(array: [8, 5, 10])
        
        tree.insert(value: 8)
        tree.insert(value: 5)
        tree.insert(value: 10)
        XCTAssertEqual(tree.count, 6)
        XCTAssertEqual(tree.maximum().value, 10)
        XCTAssertEqual(tree.minimum().value, 5)
        XCTAssertEqual(tree.toArray(), [5, 5, 8, 8, 10, 10])
    }
    
    func testTraversing() {
        let tree = BinarySearchTree(array: [8, 5, 10, 3, 12, 9, 6, 16])
        
        var inOrder = [Int]()
        tree.traverseInOrder(process: {v in inOrder.append(v)})
        XCTAssertEqual(inOrder, [3, 5, 6, 8, 9, 10, 12, 16])
        
        var preOrder = [Int]()
        tree.traversePreOrder { v in preOrder.append(v) }
        XCTAssertEqual(preOrder, [8, 5, 3, 6, 10, 9, 12, 16])
        
        var postOrder = [Int]()
        tree.traversePostOrder { v in postOrder.append(v)}
        XCTAssertEqual(postOrder, [3, 6, 5, 9, 16, 12, 10, 8])
    }
    
    func testInsertSorted() {
        let tree = BinarySearchTree(array: [3, 6, 5, 9, 16, 12, 10, 8].sorted(by: <))
        XCTAssertEqual(tree.count, 8)
        XCTAssertEqual(tree.toArray(), [3, 5, 6, 8, 9, 10, 12, 16])
        
        XCTAssertEqual(tree.minimum().value, 3);
        XCTAssertEqual(tree.maximum().value, 16)
        XCTAssertEqual(tree.depth(), 0)
        
        let node1 = tree.search(value: 16)
        XCTAssertNotNil(node1)
        XCTAssertEqual(node1!.depth(), 7)
    }
    
    func testRemoveLeaf() {
        let tree = BinarySearchTree(array: [8, 5, 10, 4])
        
        let node10 = tree.search(value: 10)!
        let node8 = tree.search(value: 8)!
        let node5 = tree.search(value: 5)!
        let node4 = tree.search(value: 4)!
        XCTAssertEqual(node4.value, 4)
        
        let replacement = node4.remove()
        XCTAssertNil(replacement)
        XCTAssertNil(node5.left)
        
        let replacement2 = node5.remove()
        XCTAssertNil(replacement2)
        XCTAssertNil(node8.left)
        
        let replacement3 = node10.remove()
        XCTAssertNil(replacement3)
        XCTAssertNil(node8.right)
    }
    
    func testRemoveLeftChild() {
        let tree = BinarySearchTree(array: [8, 5, 4, 3, 2, 6, 10, 9])
        
        let node5 = tree.search(value: 5)!
        
        let replacement = node5.remove()
        XCTAssertNotNil(replacement)
        XCTAssertEqual(replacement!.value, 6)
        XCTAssertEqual(replacement!.left!.value, 4)
    }
    
    func testRemoveRightChild() {
        let tree = BinarySearchTree(array: [8, 5, 4, 10, 9, 11, 14, 12])
        let node10 = tree.search(value: 10)!
        
        let replacement = node10.remove()
        XCTAssertNotNil(replacement)
        XCTAssertEqual(replacement!.value, 11)
        XCTAssertEqual(replacement!.left!.value, 9)
        XCTAssertEqual(replacement!.right!.value, 12)
    }
    
    func testRemoveTwoChildrenComplex() {
        let tree = BinarySearchTree(array: [8, 5, 10, 4, 9, 20, 11, 15, 13])
        
        let node9 = tree.search(value: 9)!
        let node10 = tree.search(value: 10)!
        let node11 = tree.search(value: 11)!
        let node13 = tree.search(value: 13)!
        let node15 = tree.search(value: 15)!
        let node20 = tree.search(value: 20)!
        XCTAssertTrue(node10.left === node9)
        XCTAssertTrue(node10 === node9.parent)
        XCTAssertTrue(node10.right === node20)
        XCTAssertTrue(node10 === node20.parent)
        XCTAssertTrue(node20.left === node11)
        XCTAssertTrue(node20 === node11.parent)
        XCTAssertTrue(node11.right === node15)
        XCTAssertTrue(node11 === node15.parent)
        
        let replacement = node10.remove()
        XCTAssertTrue(replacement === node11)
        XCTAssertTrue(tree.right === node11)
        XCTAssertTrue(tree === node11.parent)
        XCTAssertTrue(node11.left === node9)
        XCTAssertTrue(node11 === node9.parent)
        XCTAssertTrue(node11.right === node20)
        XCTAssertTrue(node11 === node20.parent)
        XCTAssertTrue(node20.left === node13)
        XCTAssertTrue(node20 === node13.parent)
        XCTAssertNil(node20.right)
        XCTAssertNil(node10.left)
        XCTAssertNil(node10.right)
        XCTAssertNil(node10.parent)
        XCTAssertEqual(tree.count, 8)
        XCTAssertEqual(tree.toArray(), [4, 5, 8, 9, 11, 13, 15, 20])
    }
    
    func testPredecessort() {
        let tree = BinarySearchTree(array: [3, 1, 2, 5, 4])
        let node = tree.search(value: 5)!
        
        XCTAssertEqual(node.value, 5)
        XCTAssertEqual(node.predecessor()!.value, 4)
        XCTAssertEqual(node.predecessor()!.predecessor()!.value, 3)
        XCTAssertEqual(node.predecessor()!.predecessor()!.predecessor()!.value, 2)
        XCTAssertEqual(node.predecessor()!.predecessor()!.predecessor()!.predecessor()!.value, 1)
    }
    
    func testSuccessor() {
        let tree = BinarySearchTree(array: [3, 1, 2, 5, 4])
        
        let node = tree.search(value: 1)!
        XCTAssertEqual(node.value, 1)
        XCTAssertEqual(node.successor()!.value, 2)
        XCTAssertEqual(node.successor()!.successor()!.value, 3)
        XCTAssertEqual(node.successor()!.successor()!.successor()!.value, 4)
        XCTAssertEqual(node.successor()!.successor()!.successor()!.successor()!.value, 5)
    }
    
    func testIsValidBST() {
        let tree = BinarySearchTree(array: [8, 5, 4, 10, 9, 11, 14, 12])
        XCTAssertTrue(tree.isBST(minValue: 4, maxValue: 14))        
    }
    
}

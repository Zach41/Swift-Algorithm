//
//  PriorityQueueTest.swift
//  PriorityQueueTest
//
//  Created by ZachZhang on 2017/3/7.
//
//

import XCTest

private struct Message {
    let text: String
    let priority: Int
}

private func < (m1: Message, m2: Message) -> Bool {
    return m1.priority < m2.priority
}

class PriorityQueueTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmpty() {
        var queue = PriorityQueue<Message>(sort: <)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
        XCTAssertNil(queue.dequeue())
    }
    
    func testOneElement() {
        var queue = PriorityQueue<Message>(sort: <)
        queue.enqueue(Message(text: "Test", priority: 1))
        XCTAssertEqual(queue.count, 1)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.peek()!.priority, 1)
        
        let result = queue.dequeue()
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertNil(queue.peek())
        XCTAssertNil(queue.dequeue())
        XCTAssertEqual(result!.priority, 1)
    }
    
    func testTwoElements() {
        var queue = PriorityQueue<Message>(sort: <)
        queue.enqueue(Message(text: "Zach", priority: 1))
        queue.enqueue(Message(text: "Zach2", priority: 2))
        
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.peek()!.priority, 1)
        
        let result1 = queue.dequeue()
        XCTAssertEqual(result1!.priority, 1)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek()!.priority, 2)
        
        let result2 = queue.dequeue()
        XCTAssertEqual(result2!.priority, 2)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertNil(queue.peek())
        XCTAssertEqual(queue.count, 0)
    }
    
    func testOutOrder() {
        var queue = PriorityQueue<Message>(sort: <)
        queue.enqueue(Message(text: "Zach", priority: 2))
        queue.enqueue(Message(text: "Zach2", priority: 1))
        
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.peek()!.priority, 1)
        
        let result1 = queue.dequeue()
        XCTAssertEqual(result1!.priority, 1)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek()!.priority, 2)
        
        let result2 = queue.dequeue()
        XCTAssertEqual(result2!.priority, 2)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertNil(queue.peek())
        XCTAssertEqual(queue.count, 0)
    }
    
    
}

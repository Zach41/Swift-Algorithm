//
//  Queue.swift
//  Queue
//
//  Created by ZachZhang on 2017/3/6.
//
//

import XCTest

class QueueTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmpty() {
        var queue: Queue<Int> = Queue()
        
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
    }
    
    func testQueueOps() {
        var queue: Queue<Int> = Queue()
        
        queue.enqueue(1)
        XCTAssertEqual(queue.count, 1)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.front, 1)
        
        XCTAssertEqual(queue.dequeue(), 1)
        
        for i in 1..<100 {
            queue.enqueue(i)
        }
        XCTAssertEqual(queue.count, 99)
        XCTAssertEqual(queue.front, 1)
        for i in 1..<100 {
            XCTAssertEqual(queue.dequeue(), i)
        }
        XCTAssertNil(queue.dequeue())
        
    }
    
}

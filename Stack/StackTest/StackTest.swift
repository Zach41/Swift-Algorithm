//
//  StackTest.swift
//  StackTest
//
//  Created by ZachZhang on 2017/3/1.
//  Copyright © 2017年 ZachZhang. All rights reserved.
//

import XCTest

class StackTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmpty() {
        var stack = Stack<Int>()
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertEqual(stack.top, nil)
        XCTAssertNil(stack.pop())
    }
    
    func testOneElement() {
        var stack = Stack<Int>()
        stack.push(123)
        XCTAssertEqual(stack.count, 1)
        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.top, 123)
        
        let result = stack.pop()
        XCTAssertEqual(result, 123)
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertNil(stack.pop())
        XCTAssertEqual(stack.top, nil)
    }
    
    func testTwoElement() {
        var stack = Stack<Int>()
        stack.push(123)
        stack.push(456)
        
        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.count, 2)
        XCTAssertNotNil(stack.top)
        XCTAssertEqual(stack.top, 456)
        
        let result = stack.pop()
        XCTAssertEqual(result, 456)
        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.count, 1)
        XCTAssertEqual(stack.top, 123)
        
        let result2 = stack.pop()
        XCTAssertEqual(result2, 123)
        XCTAssertEqual(stack.count, 0)
        XCTAssertNil(stack.top)
        XCTAssertNil(stack.pop())
    }
}
















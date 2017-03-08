//
//  SwiftHeap.swift
//  Heap
//
//  Created by ZachZhang on 2017/3/1.
//  Copyright © 2017年 ZachZhang. All rights reserved.
//

public struct SwiftHeap<T> {
    var inner: [T] = [T]()
    
    fileprivate var orderFunction: (T, T) -> Bool
    
    public var isEmpty: Bool {
        return self.inner.isEmpty
    }
    
    public var count: Int {
        return self.inner.count
    }
    
    public func peek() -> T? {
        return self.inner.first
    }
    
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderFunction = sort
        buildHeap(fromArray: array)
    }
    
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderFunction = sort
    }
    
    fileprivate mutating func buildHeap(fromArray array: [T]) {
        self.inner = array
        for i in stride(from: (inner.count/2 - 1), through: 0, by: -1) {
            shiftDown(i, heapSize: inner.count)
        }
    }
    
    public mutating func insert(_ value: T) {
        self.inner.append(value)
        shiftUp(self.inner.count - 1)
    }
    
    public mutating func insert<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == T {
            for value in sequence {
                insert(value)
            }
    }
    
    public mutating func replace(index i: Int, value: T) {
        guard i < self.inner.count else { return}
        assert(orderFunction(value, self.inner[i]))
        self.inner[i] = value
        shiftUp(i)
    }
    
    @discardableResult public mutating func remove() -> T? {
        guard self.inner.count > 0 else {
            return nil
        }
        if self.inner.count == 1 {
            return self.inner.removeLast()
        } else {
            let value = self.inner[0]
            self.inner[0] = self.inner.removeLast()
            shiftDown()
            return value
        }
        
    }
    
    public mutating func removeAt(_ index: Int) -> T? {
        guard index < self.inner.count else {
            return nil
        }
        let size = self.inner.count - 1
        if index != size {
            swap(&self.inner[index], &self.inner[size])
            shiftDown(index, heapSize: size)
            shiftUp(index)
        }
        return self.inner.removeLast()
    }
    
    @inline(__always) func parentIndex(ofIndex idx: Int) -> Int {
        return (idx - 1) / 2
    }
    
    @inline(__always) func leftChildIndex(ofIndex idx: Int) -> Int {
        return 2 * idx + 1
    }
    
    @inline(__always) func rightChildIndex(ofIndex idx: Int) -> Int {
        return 2 * idx + 2
    }
    
    mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let element = self.inner[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderFunction(element, self.inner[parentIndex]) {
            self.inner[childIndex] = self.inner[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        self.inner[childIndex] = element
    }
    
    mutating func shiftDown() {
        shiftDown(0, heapSize: self.inner.count)
    }
    
    mutating func shiftDown(_ index: Int, heapSize: Int) {
        var parentIndex = index
        while true {
            let leftChildIndex = self.leftChildIndex(ofIndex: parentIndex)
            let rightChildIndex = leftChildIndex + 1
            
            var first = parentIndex
            if leftChildIndex < heapSize &&
                orderFunction(self.inner[leftChildIndex], self.inner[first]) {
                first = leftChildIndex
            }
            if rightChildIndex < heapSize &&
                orderFunction(self.inner[rightChildIndex], self.inner[first]) {
                first = rightChildIndex
            }
            if parentIndex == first {
                break
            }
            swap(&self.inner[first], &self.inner[parentIndex])
            parentIndex = first
        }
    }
}


extension SwiftHeap where T: Equatable {
    public func index(of element: T) -> Int? {
        return index(of: element, 0)
    }
    
    fileprivate func index(of element: T, _ i: Int) -> Int? {
        if i >= inner.count { return nil }
        if orderFunction(element, inner[i]) { return nil }
        if let j = index(of: element, self.leftChildIndex(ofIndex: i)) {
            return j
        }
        if let j = index(of: element, self.rightChildIndex(ofIndex: i)) {
            return j
        }
        return nil
    }
}

extension SwiftHeap {
    public mutating func sort() -> [T] {
        for i in stride(from: (self.count - 1), through: 1, by: -1) {
            swap(&self.inner[0], &self.inner[i])
            shiftDown(0, heapSize: i)
        }
        return self.inner
    }
}


















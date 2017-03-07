//
//  PriorityQueue.swift
//  PriorityQueue
//
//  Created by ZachZhang on 2017/3/7.
//
//

public struct PriorityQueue<T> {
    fileprivate var heap: SwiftHeap<T>
    
    public init(sort: @escaping (T, T) -> Bool) {
        heap = SwiftHeap(sort: sort)
    }
    
    public var isEmpty: Bool {
        return heap.isEmpty
    }
    
    public var count: Int {
        return heap.count
    }
    
    public func peek() -> T? {
        return heap.peek()
    }
    
    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    
    public mutating func dequeue() -> T? {
        return heap.remove()
    }
    
    public mutating func changePriority(index: Int, value: T) {
        heap.replace(index: index, value: value)
    }
}

extension PriorityQueue where T: Equatable {
    public func index(of element: T) -> Int? {
        return heap.index(of: element)
    }
}

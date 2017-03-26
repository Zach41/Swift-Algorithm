//
//  Queue.swift
//  Queue
//
//  Created by ZachZhang on 2017/3/6.
//
//

public struct Queue<T> {
    fileprivate var inner = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return self.inner.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        self.inner.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard self.count > 0, let element = self.inner[head] else {
            return nil
        }
        self.inner[head] = nil
        head += 1
        
        let percentage = Double(head) / Double(self.inner.count)
        if self.inner.count > 50 && percentage > 0.25 {
            self.inner.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return self.inner[head]
        }
    }
}

//
//  BinarySearchTree.swift
//  BinarySearchTree
//
//  Created by ZachZhang on 2017/3/9.
//
//

import Foundation

public class BinarySearchTree<T: Comparable> {
    fileprivate(set) public var value: T
    fileprivate(set) public var parent: BinarySearchTree?
    fileprivate(set) public var left: BinarySearchTree?
    fileprivate(set) public var right: BinarySearchTree?
    
    public init(value: T) {
        self.value = value
    }
    
    public var isRoot: Bool {
        return self.parent == nil
    }
    
    public var isLeaf: Bool {
        return self.left == nil && self.right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return self.left != nil
    }
    
    public var hasRightChild: Bool {
        return self.right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChild: Bool {
        return hasLeftChild && hasRightChild
    }
    
    public var count: Int {
        return (self.left?.count ?? 0) + 1 + (self.right?.count ?? 0)
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for v in array.dropFirst() {
            self.insert(value: v)
        }
    }
}

extension BinarySearchTree {
    public func insert(value: T) {
        if value < self.value {
            if let left = self.left {
                left.insert(value: value)
            } else {
                self.left = BinarySearchTree(value: value)
                self.left?.parent = self
            }
        } else {
            if let right = self.right {
                right.insert(value: value)
            } else {
                self.right = BinarySearchTree(value: value)
                self.right?.parent = self
            }
        }
    }
}

extension BinarySearchTree {
    public func search(value: T) -> BinarySearchTree? {
        var node: BinarySearchTree? = self
        while case let n? = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }
        return nil
    }
    
    public func contains(value: T) -> Bool {
        return self.search(value: value) != nil
    }
    
    public func minimum() -> BinarySearchTree {
        var node = self
        while case let n? = node.left {
            node = n
        }
        return node
    }
    
    public func maximum() -> BinarySearchTree {
        var node = self
        while case let n? = node.right {
            node = n
        }
        return node
    }
    
    public func depth() -> Int {
        var node = self
        var edge = 0
        
        while case let n? = node.parent {
            node = n
            edge += 1
        }
        return edge
    }
    
//    public func height() -> Int {
//        if self.isLeaf {
//            
//        }
//    }
    
    public func predecessor() -> BinarySearchTree? {
        if let left = self.left {
            return left.maximum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value < self.value {
                    return parent
                }
                node = parent
            }
        }
        return nil
    }
    
    public func successor() -> BinarySearchTree? {
        if let right = self.right {
            return right.minimum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value > self.value {
                    return parent
                }
                node = parent
            }
        }
        return nil
    }
}

extension BinarySearchTree {
    @discardableResult public func remove() -> BinarySearchTree? {
        var replacement: BinarySearchTree?
        
        if let right = self.right {
            replacement = right.minimum()
        } else if let left = self.left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
        
        replacement?.remove()
        
        replacement?.right = self.right
        replacement?.left = self.left
        self.right?.parent = replacement
        self.left?.parent = replacement
        reconnectParentTo(node: replacement)
        
        self.parent = nil
        self.left = nil
        self.right = nil
        
        return replacement
    }
    
    private func reconnectParentTo(node: BinarySearchTree?) {
        if let parent = self.parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
}

extension BinarySearchTree {
    public func traverseInOrder(process: (T) -> Void) {
        self.left?.traverseInOrder(process: process)
        process(self.value)
        self.right?.traverseInOrder(process: process)
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        process(self.value)
        self.left?.traversePreOrder(process: process)
        self.right?.traversePreOrder(process: process)
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        self.left?.traversePostOrder(process: process)
        self.right?.traversePostOrder(process: process)
        process(self.value)
    }
    
    public func map(formula: (T) -> T) -> [T] {
        var ret = [T]()
        if let left = self.left {
            ret += left.map(formula: formula)
        }
        ret.append(formula(self.value))
        if let right = self.right {
            ret += right.map(formula: formula)
        }
        
        return ret
    }
    
    public func toArray() -> [T] {
        return self.map() { $0 }
    }
}

extension BinarySearchTree {
    public func isBST(minValue: T, maxValue: T) -> Bool {
        if self.value < minValue || self.value > maxValue { return false }
        let left = self.left?.isBST(minValue: minValue, maxValue: maxValue) ?? true
        let right = self.right?.isBST(minValue: minValue, maxValue: maxValue) ?? true
        return left && right
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = self.left {
            s += "\(left.description) <- "
        }
        s += "\(self.value)"
        if let right = self.right {
            s += " -> \(right.description)"
        }
        
        return s
    }
}































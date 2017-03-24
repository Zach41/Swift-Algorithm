//
// Created by ZachZhang on 2017/3/24.
//

import Foundation

public class SegmentTree<T> {
    private var value: T
    private var function: (T, T) -> T
    private var leftChild: SegmentTree<T>?
    private var rightChild: SegmentTree<T>?
    private var leftBound: Int
    private var rightBound: Int

    public init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.function = function
        if leftBound == rightBound {
            value = array[leftBound]
            return
        }

        let middle = leftBound + (rightBound - leftBound) / 2
        leftChild = SegmentTree(array: array, leftBound: leftBound, rightBound: middle, function: function)
        rightChild = SegmentTree(array: array, leftBound: middle + 1, rightBound: rightBound, function: function)

        value = function(leftChild!.value, rightChild!.value)
    }

    public func query(withLeftBound leftBound: Int, rightBound: Int) -> T {
        if self.leftBound == leftBound && self.rightBound == rightBound {
            return value
        }

        guard let leftChild = leftChild, let rightChild = rightChild else {
            fatalError("Children should not be empty!")
        }

        if leftChild.rightBound < leftBound {
            return rightChild.query(withLeftBound: leftBound, rightBound: rightBound)
        } else if rightChild.leftBound > rightBound {
            return leftChild.query(withLeftBound: leftBound, rightBound: rightBound)
        } else {
            let value1 = leftChild.query(withLeftBound: leftBound, rightBound: leftChild.rightBound)
            let value2 = rightChild.query(withLeftBound: rightChild.leftBound, rightBound: rightBound)
            return function(value1, value2)
        }
    }

    public func replaceItem(at index: Int, withItem item: T) {
        if leftBound == rightBound {
            value = item
            return
        }

        guard let leftChild = leftChild, let rightChild = rightChild else {
            fatalError("Children should not be empty")
        }

        if index > leftChild.rightBound {
            rightChild.replaceItem(at: index, withItem: item)
        } else {
            leftChild.replaceItem(at: index, withItem: item)
        }

        value = function(leftChild.value, rightChild.value)
    }
}
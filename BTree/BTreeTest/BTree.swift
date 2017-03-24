//
// Created by ZachZhang on 2017/3/23.
//

import Foundation

public class BTreeNode<Key: Comparable, Value> {
    unowned var owner: BTree<Key, Value>

    fileprivate var keys = [Key]()
    fileprivate var values = [Value]()

    var children: [BTreeNode]?

    var isLeaf: Bool {
        return self.children == nil
    }

    var numberOfKeys: Int {
        return self.keys.count
    }

    init(owner: BTree<Key, Value>) {
        self.owner = owner
    }

    convenience init(owner: BTree<Key, Value>, keys: [Key], values: [Value], children: [BTreeNode]? = nil) {
        self.init(owner: owner)
        self.keys += keys
        self.values += values
        self.children = children
    }
}

extension BTreeNode {
    func value(for key: Key) -> Value? {
        var index = keys.startIndex

        while (index + 1) < keys.endIndex && keys[index] < key {
            index += 1
        }

        if key == keys[index] {
            return values[index]
        } else if key < keys[index] {
            return children?[index].value(for: key)
        } else {
            return children?[index+1].value(for: key)
        }
    }
}

extension BTreeNode {
    func traverseKeyInOrder(_ process: (Key) -> Void) {
        for i in 0..<numberOfKeys {
            children?[i].traverseKeyInOrder(process)
            process(keys[i])
        }
        children?.last?.traverseKeyInOrder(process)
    }
}

extension BTreeNode {
    func insert(_ value: Value, for key: Key) {
        var index = keys.startIndex

        while index < keys.endIndex && key > keys[index] {
            index += 1
        }

        if index < keys.endIndex && key == keys[index] {
            values[index] = value
            return
        }

        if isLeaf {
            keys.insert(key, at: index)
            values.insert(value, at: index)
            owner.numberOfKeys += 1
        } else {
            children![index].insert(value, for: key)
            if children![index].numberOfKeys > owner.order * 2 {
                split(child: children![index], atIndex: index)
            }
        }
    }

    private func split(child: BTreeNode<Key, Value>, atIndex index: Int) {
        let middleIndex = child.numberOfKeys / 2
        keys.insert(child.keys[middleIndex], at: index)
        values.insert(child.values[middleIndex], at: index)
        child.keys.remove(at: middleIndex)
        child.values.remove(at: middleIndex)

        let rightSibling = BTreeNode (
                owner: self.owner,
                keys: Array(child.keys[child.keys.indices.suffix(from: middleIndex)]),
                values: Array(child.values[child.values.indices.suffix(from: middleIndex)])
        )
        child.keys.removeSubrange(child.keys.indices.suffix(from: middleIndex))
        child.values.removeSubrange(child.values.indices.suffix(from: middleIndex))

        children!.insert(rightSibling, at: index+1)

        if child.children != nil {
            rightSibling.children = Array(
                    child.children![child.children!.indices.suffix(from: middleIndex+1)]
            )
            child.children!.removeSubrange(child.children!.indices.suffix(from: middleIndex + 1))
        }
    }
}

private enum Position {
    case Left, Right
}

extension BTreeNode {
    private var inorderPredecessor: BTreeNode {
        if isLeaf {
            return self
        } else {
            return children!.last!.inorderPredecessor
        }
    }

    func remove(_ key: Key) {
        var index = keys.startIndex

        while (index + 1) < keys.endIndex && key > keys[index] {
            index += 1
        }

        if keys[index] == key {
            if isLeaf {
                keys.remove(at: index)
                values.remove(at: index)
                owner.numberOfKeys -= 1
            } else {
                let predecessor = children![index].inorderPredecessor
                values[index] = predecessor.values.last!
                keys[index] = predecessor.keys.last!
                children![index].remove(predecessor.keys.last!)
                if children![index].numberOfKeys < owner.order {
                    fix(childWithTooFewKeys: children![index], atIndex: index)
                }
            }
        } else if key < keys[index] {
            if let leftChild = children?[index] {
                leftChild.remove(key)
                if leftChild.numberOfKeys < owner.order {
                    fix(childWithTooFewKeys: leftChild, atIndex: index)
                }
            } else {
                print("The key: \(key) is not in the tree")
            }
        } else {
            if let rightChild = children?[index + 1] {
                rightChild.remove(key)
                if rightChild.numberOfKeys < owner.order {
                    fix(childWithTooFewKeys: rightChild, atIndex: index + 1)
                }
            } else {
                print("The key: \(key) is not in the tree")
            }
        }
    }

    private func fix(childWithTooFewKeys child: BTreeNode, atIndex index: Int) {
        if (index - 1) >= 0 && children![index-1].numberOfKeys > owner.order {
            move(keyAtIndex: (index - 1), to: child, from: children![index - 1], at: .Left)
        } else if (index + 1) < keys.endIndex && children![index + 1].numberOfKeys > owner.order {
            move(keyAtIndex: index, to: child, from: children![index + 1], at: .Right)
        } else if (index - 1) >= 0 {
            merge(child: child, atIndex: index, to: .Left)
        } else {
            merge(child: child, atIndex: index, to: .Right)
        }
    }

    private func move(keyAtIndex index: Int, to targetNode: BTreeNode, from sourceNode: BTreeNode, at position: Position) {
        switch position {
        case .Left:
            targetNode.keys.insert(keys[index], at: targetNode.keys.startIndex)
            targetNode.values.insert(values[index], at: targetNode.values.startIndex)
            keys[index] = sourceNode.keys.last!
            values[index] = sourceNode.values.last!
            sourceNode.values.removeLast()
            sourceNode.keys.removeLast()
            if !targetNode.isLeaf {
                targetNode.children!.insert(sourceNode.children!.last!, at: targetNode.children!.startIndex)
                sourceNode.children!.removeLast()
            }
        case .Right:
            targetNode.keys.insert(keys[index], at: targetNode.keys.endIndex)
            targetNode.values.insert(values[index], at: targetNode.values.endIndex)
            keys[index] = sourceNode.keys.first!
            values[index] = sourceNode.values.first!
            sourceNode.keys.removeFirst()
            sourceNode.values.removeFirst()
            if !targetNode.isLeaf {
                targetNode.children!.insert(sourceNode.children!.first!, at: targetNode.children!.endIndex)
                sourceNode.children!.removeFirst()
            }
        }
    }

    private func merge(child: BTreeNode, atIndex index: Int, to position: Position) {
        switch position {
            case .Left:
                children![index-1].keys = children![index-1].keys + [keys[index - 1]] + child.keys
                children![index-1].values = children![index-1].values + [values[index - 1]] + child.values
                keys.remove(at: index - 1)
                values.remove(at: index - 1)
                if !child.isLeaf {
                    children![index - 1].children = children![index - 1].children! + child.children!
                }
            case .Right:
            children![index + 1].keys = child.keys + [keys[index]] + children![index + 1].keys
            children![index + 1].values = child.values + [values[index]] + children![index + 1].values
            keys.remove(at: index)
            values.remove(at: index)

            if !child.isLeaf {
                children![index + 1].children = child.children! + children![index + 1].children!
            }
        }
        children!.remove(at: index)
    }
}

extension BTreeNode {
    var inorderArrayFromKeys: [Key] {
        var array = [Key]()

        for i in 0..<numberOfKeys {
            if let returnedArray = children?[i].inorderArrayFromKeys {
                array += returnedArray
            }
            array += [keys[i]]
        }

        if let returnedArray = children?.last?.inorderArrayFromKeys {
            array += returnedArray
        }

        return array
    }
}

extension BTreeNode: CustomStringConvertible {
    public var description: String {
        var str = "\(keys)"

        if !isLeaf {
            for child in children! {
                str += child.description
            }
        }
        return str
    }
}

public class BTree<Key: Comparable, Value> {
    public let order: Int
    var rootNode: BTreeNode<Key, Value>!
    fileprivate (set) public var numberOfKeys = 0

    public init?(order: Int) {
        guard order > 0 else {
            print("Order has to be greater than 0.")
            return nil
        }
        self.order = order
        rootNode = BTreeNode<Key, Value>(owner: self)
    }
}

extension BTree {
    public func traverseKeysInOrder(_ process: (Key) -> Void) {
        rootNode.traverseKeyInOrder(process)
    }
}

extension  BTree {
    public subscript(key: Key) -> Value? {
        return value(for: key)
    }
}

extension BTree {
    public func value(for key: Key) -> Value? {
        guard numberOfKeys > 0 else {
            return nil
        }
        return rootNode.value(for: key)
    }
}

extension BTree {
    public func insert(_ value: Value, for key: Key) {
        rootNode.insert(value, for: key)
        if rootNode.numberOfKeys > order * 2 {
            splitRoot()
        }
    }

    private func splitRoot() {
        let middleIndex = rootNode.numberOfKeys / 2

        let newRoot = BTreeNode(owner: self,
                keys: [rootNode.keys[middleIndex]],
                values: [rootNode.values[middleIndex]],
                children: [rootNode])

        rootNode.keys.remove(at: middleIndex)
        rootNode.values.remove(at: middleIndex)
        let newRightSibling = BTreeNode(owner: self,
                keys: Array(rootNode.keys[rootNode.keys.indices.suffix(from: middleIndex)]),
                values: Array(rootNode.values[rootNode.values.indices.suffix(from: middleIndex)]))
        rootNode.keys.removeSubrange(rootNode.keys.indices.suffix(from: middleIndex))
        rootNode.values.removeSubrange(rootNode.keys.indices.suffix(from: middleIndex))
        if rootNode.children != nil {
            newRightSibling.children = Array(rootNode.children![rootNode.children!.indices.suffix(from: middleIndex + 1)])
            rootNode.children!.removeSubrange(rootNode.children!.indices.suffix(from: middleIndex + 1))
        }
        newRoot.children!.append(newRightSibling)
        rootNode = newRoot
    }
}

extension BTree {
    public func remove(_ key: Key) {
        guard numberOfKeys > 0 else { return }
        rootNode.remove(key)

        if rootNode.numberOfKeys == 0 && !rootNode.isLeaf {
            rootNode = rootNode.children!.first!
        }
    }
}

extension BTree {
    public var inOrderArrayFromKeys: [Key] {
        return rootNode.inorderArrayFromKeys
    }
}

extension  BTree: CustomStringConvertible {
    public var description: String {
        return rootNode.description
    }
}
//
//  Huffman.swift
//  HuffmanCoding
//
//  Created by ZachZhang on 2017/3/7.
//
//

import Foundation

public class Huffman {
    typealias NodeIndex = Int
    
    struct Node {
        var count = 0
        var index: NodeIndex = -1
        var parent: NodeIndex = -1
        var left: NodeIndex = -1
        var right: NodeIndex = -1
    }
    
    var tree = [Node](repeating: Node(), count: 256)
    
    var root: NodeIndex = -1
    
    public struct Freq {
        var byte: UInt8 = 0
        var count = 0
    }
    
    public init() {}
}

extension Huffman {
    fileprivate func countByteFrequency(inData data: NSData) {
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
        for _ in 0..<data.length {
            let i = Int(ptr.pointee)
            tree[i].index = i
            tree[i].count += 1
            ptr = ptr.successor()
        }
    }
    
    fileprivate func restoreTree(fromTable frequencyTable: [Freq]) {
        for freq in frequencyTable {
            let i = Int(freq.byte)
            tree[i].index = i
            tree[i].count = freq.count
        }
        buildTree()
    }
    
    public func frequencyTable() -> [Freq] {
        var ret = [Freq]()
        for i in 0..<256 where tree[i].count > 0 {
            ret.append(Freq(byte: UInt8(i), count: tree[i].count))
        }
        return ret
    }
}

extension Huffman {
    fileprivate func buildTree() {
        var queue = PriorityQueue<Node>(sort: {$0.count < $1.count})
        for node in tree where node.count > 0 {
            queue.enqueue(node)
        }
        
        while queue.count > 1 {
            let node1 = queue.dequeue()!
            let node2 = queue.dequeue()!
            
            var parentNode = Node()
            parentNode.left = node1.index
            parentNode.right = node2.index
            parentNode.count = node1.count + node2.count
            parentNode.index = tree.count
            tree.append(parentNode)
            
            tree[node1.index].parent = parentNode.index
            tree[node2.index].parent = parentNode.index
            
            queue.enqueue(parentNode)
        }
        let rootNode = queue.dequeue()!
        root = rootNode.index
    }
}

extension Huffman {
    public func compressData(data: NSData) -> NSData {
        countByteFrequency(inData: data)
        buildTree()
        
        let writer = BitWriter()
        var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
        for _ in 0..<data.length {
            let c = ptr.pointee
            let i = Int(c)
            traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
            ptr = ptr.successor()
        }
        writer.flush()
        return writer.data
    }
    
    private func traverseTree(writer: BitWriter, nodeIndex: Int, childIndex: Int) {
        if tree[nodeIndex].parent != -1 {
            traverseTree(writer: writer, nodeIndex: tree[nodeIndex].parent, childIndex: nodeIndex)
        }
        if childIndex != -1 {
            if childIndex == tree[nodeIndex].left {
                writer.writeBit(bit: true)
            } else {
                writer.writeBit(bit: false)
            }
        }
    }
}


extension Huffman {
    public func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
        restoreTree(fromTable: frequencyTable)
        
        let reader = BitReader(data: data)
        let outData = NSMutableData()
        let byteCount = tree[root].count
        
        var i = 0
        while i < byteCount {
            var b = findLeafNode(reader: reader, nodeIndex: root)
            outData.append(&b, length: 1)
            i += 1
        }
        return outData
    }
    
    private func findLeafNode(reader: BitReader, nodeIndex: Int) -> UInt8 {
        var h = nodeIndex
        while tree[h].right != -1 {
            if reader.readBit() {
                h = tree[h].left
            } else {
                h = tree[h].right
            }
        }
        return UInt8(h)
    }
}

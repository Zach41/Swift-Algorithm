//
//  Trie.swift
//  Trie
//
//  Created by ZachZhang on 2017/3/15.
//
//

import Foundation

class TrieNode<T: Hashable> {
    var value: T?
    weak var parentNode: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    var isLeaf: Bool {
        return children.count == 0
    }
    
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}

class Trie: NSObject, NSCoding {
    typealias Node = TrieNode<Character>
    
    public var count: Int {
        return wordCount
    }
    
    public var isEmpty: Bool {
        return wordCount == 0
    }
    
    public var words: [String] {
        return wordsInSubtrie(rootNode: root, partialWord: "")
    }
    
    fileprivate let root: Node
    fileprivate var wordCount: Int
    
    override init() {
        root = Node()
        wordCount = 0
        super.init()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        let words = decoder.decodeObject(forKey: "words") as? [String]
        for word in words! {
            self.insert(word: word)
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.words, forKey: "words")
    }
}

extension Trie {
    func insert(word: String) {
        guard !word.isEmpty else { return }
        var currentNode = root
        for character in word.lowercased().characters {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }
        wordCount += 1
        currentNode.isTerminating = true
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased().characters {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                return false
            }
        }
        return currentNode.isTerminating
    }
    
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased().characters {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                return nil
            }
        }
        return currentNode
    }
    
    private func deleteNodesForWordEndingWith(terminalNode: Node) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parentNode {
            lastNode = parentNode
            lastNode.children[character!] = nil
            character = lastNode.value
            if lastNode.isTerminating {
                break
            }
        }
    }
    
    func remove(word: String) {
        guard !word.isEmpty else { return }
        guard let terminalNode = findLastNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
        }
        wordCount -= 1
    }
    
    fileprivate func wordsInSubtrie(rootNode: Node, partialWord: String) -> [String] {
        var subtrieWords = [String]()
        var partialLetters = partialWord
        if let value = rootNode.value {
            partialLetters.append(value)
        }
        if rootNode.isTerminating {
            subtrieWords.append(partialLetters)
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: partialLetters)
            subtrieWords += childWords
        }
        return subtrieWords
    }
    
    func findWordsWithPrefix(prefix: String) -> [String] {
        var words = [String]()
        let prefixLowercased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowercased) {
            if lastNode.isTerminating {
                words.append(prefixLowercased)
            }
            for childNode in lastNode.children.values {
                let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowercased)
                words += childWords
            }
        }
        return words
    }
}

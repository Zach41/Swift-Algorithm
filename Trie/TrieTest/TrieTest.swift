//
//  TrieTest.swift
//  TrieTest
//
//  Created by ZachZhang on 2017/3/15.
//
//

import XCTest

class TrieTest: XCTestCase {
    
    var wordArray: [String]?
    var trie = Trie()
    
    func createWordArray() {
        guard wordArray == nil else {
            return
        }
        let resourcePath = "/Users/Zach/Desktop/Zach/Swift/swift-Algorithm/Trie/TrieTest" as NSString
        let fileName = "dictionary.txt"
        let filePath = resourcePath.appendingPathComponent(fileName)
        
        var data: String?
        do {
            data = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            XCTAssertNil(error)
        }
        XCTAssertNotNil(data)
        let dictionarySize = 162825
        wordArray = data!.components(separatedBy: "\n")
        XCTAssertEqual(wordArray!.count, dictionarySize)
    }
    
    func insertWordsIntoTrie() {
        guard let wordArray = wordArray, trie.count == 0 else { return }
        for word in wordArray {
            trie.insert(word: word)
        }
    }
    
    override func setUp() {
        super.setUp()
        createWordArray()
        insertWordsIntoTrie()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testCreate() {
        let trie = Trie()
        XCTAssertEqual(trie.count, 0)
        XCTAssertEqual(trie.words, [])
        XCTAssertTrue(trie.isEmpty)
    }
    
    func testInsert() {
        let trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cutie")
        trie.insert(word: "fred")
        XCTAssertTrue(trie.contains(word: "cute"))
        XCTAssertFalse(trie.contains(word: "cut"))
        trie.insert(word: "cut")
        XCTAssertTrue(trie.contains(word: "cut"))
        XCTAssertEqual(trie.count, 4)
    }
    
    func testRemove() {
        let trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cut")
        XCTAssertEqual(trie.count, 2)
        trie.remove(word: "cute")
        XCTAssertTrue(trie.contains(word: "cut"))
        XCTAssertFalse(trie.contains(word: "cute"))
        XCTAssertEqual(trie.count, 1)
    }
    
    func testWords() {
        let trie = Trie()
        var words = trie.words
        XCTAssertEqual(words.count, 0)
        trie.insert(word: "foobar")
        words = trie.words
        XCTAssertEqual(words[0], "foobar")
        XCTAssertEqual(words.count, 1)
    }
    
    func testFindWordsWithPrefix() {
        let trie = Trie()
        trie.insert(word: "test")
        trie.insert(word: "another")
        trie.insert(word: "exam")
        let wordsAll = trie.findWordsWithPrefix(prefix: "")
        XCTAssertEqual(wordsAll.sorted(), ["another", "exam", "test"]);
        let words = trie.findWordsWithPrefix(prefix: "ex")
        XCTAssertEqual(words, ["exam"]);
        trie.insert(word: "examination")
        let words2 = trie.findWordsWithPrefix(prefix: "exam")
        XCTAssertEqual(words2, ["exam", "examination"]);
        let noWords = trie.findWordsWithPrefix(prefix: "tee")
        XCTAssertEqual(noWords, []);
        let unicodeWord = "😬😎"
        trie.insert(word: unicodeWord)
        let wordsUnicode = trie.findWordsWithPrefix(prefix: "😬")
        XCTAssertEqual(wordsUnicode, [unicodeWord]);
        trie.insert(word: "Team")
        let wordsUpperCase = trie.findWordsWithPrefix(prefix: "Te")
        XCTAssertEqual(wordsUpperCase.sorted(), ["team", "test"]);
        
    }
    
    func testArchiveAndUnarchive() {
        let resourcePath = "/Users/Zach/Desktop/Zach/Swift/swift-Algorithm/Trie/TrieTest" as NSString
        let fileName = "dictionary-archive"
        let filePath = resourcePath.appendingPathComponent(fileName)
        NSKeyedArchiver.archiveRootObject(trie, toFile: filePath)
        let trieCopy = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! Trie
        XCTAssertEqual(trieCopy.count, trie.count)
        
    }

    
    func testRemovePerformance() {
        for word in self.wordArray! {
            self.trie.remove(word: word)
        }
        self.measure() {
            self.insertWordsIntoTrie()
            for word in self.wordArray! {
                self.trie.remove(word: word)
            }
        }
        XCTAssertEqual(trie.count, 0)
    }
    
    func testContainsPerformance() {
        self.measure() {
            for word in self.wordArray! {
                XCTAssertTrue(self.trie.contains(word: word))
            }
        }
    }
    
    func testWordsPerformance() {
        var words: [String]?
        self.measure {
            words = self.trie.words
        }
        XCTAssertEqual(words?.count, trie.count)
        for word in words! {
            XCTAssertTrue(self.trie.contains(word: word))
        }
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

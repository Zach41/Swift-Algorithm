//
//  HuffmanCodingTest.swift
//  HuffmanCodingTest
//
//  Created by ZachZhang on 2017/3/7.
//
//

import XCTest


class HuffmanCodingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHuffman() {
        let str = "so much words wow many compression"
        if let originalData = str.data(using: .utf8) {
            print(originalData.count)
            
            let huffman1 = Huffman()
            let compressedData = huffman1.compressData(data: originalData as NSData)
            print(compressedData.length)
            
            let frequencyTable = huffman1.frequencyTable()
            let huffman2 = Huffman()
            let decompressedData = huffman2.decompressData(data: compressedData, frequencyTable: frequencyTable)
            print(decompressedData.length)
            
            let str2 = String(data: decompressedData as Data, encoding: .utf8)!
            print(str2)
            
            XCTAssert(str == str2)
        }
    }
}

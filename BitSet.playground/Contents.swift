//: Playground - noun: a place where people can play


public struct BitSet {
    private(set) public var size: Int
    
    private let N = 64
    public typealias Word = UInt64
    fileprivate(set) public var words: [Word]
    
    private let allOnes = ~Word()
    
    public init(size: Int) {
        precondition(size > 0)
        self.size = size
        
        let n = (size + N - 1) / N
        words = [Word](repeating: 0, count: n)
    }
    
    private func indexOf(_ i: Int) -> (Int, Word) {
        precondition(i >= 0)
        precondition(i < size)
        
        let idx = i / N
        let mask = 1 << Word(i - idx * N)
        return (idx, mask)
    }
    
    private func lastWordMask() -> Word {
        let diff = words.count * N - size
        if diff > 0 {
            let mask = 1 << Word(63 - diff)
            return mask | (mask - 1)
        } else {
            return allOnes
        }
    }
    
    fileprivate mutating func clearUnusedBits() {
        words[words.count - 1] &= lastWordMask()
    }
    
    public subscript(i: Int) -> Bool {
        get {
            return isSet(i)
        }
        set {
            if newValue { set(i) } else { clear(i) }
        }
    }
    
    public mutating func set(_ i: Int) {
        let (j, mask) = indexOf(i)
        words[j] |= mask
    }
    
    public mutating func clear(_ i: Int) {
        let (j, mask) = indexOf(i)
        words[j] &= ~mask
    }
    
    public func isSet(_ i: Int) -> Bool {
        let (j, m) = indexOf(i)
        return words[j] & m != 0
    }
    
    public mutating func clearAll() {
        for i in 0..<words.count {
            words[i] = 0
        }
    }
    
    public mutating func setAll() {
        for i in 0..<words.count {
            words[i] = allOnes
        }
        clearUnusedBits()
    }
    
    public var cardinality: Int {
        var count = 0
        for x in words {
            var x = x
            while x != 0 {
                let y = x & ~(x - 1)
                x = x ^ y
                count += 1
            }
        }
        return count
    }
    
    public func all1() -> Bool {
        for i in 0..<words.count - 1 {
            if words[i] != allOnes { return false }
        }
        return words[words.count - 1] == lastWordMask()
    }
    
    public func any1() -> Bool {
        for i in 0..<words.count {
            if words[i] != 0 { return true }
        }
        return false
    }
    
    
    public func all0() -> Bool {
        return !any1()
    }
}

extension BitSet: Equatable {
}

public func == (lhs: BitSet, rhs: BitSet) -> Bool {
    return lhs.words == rhs.words
}

private func copyLargest(_ lhs: BitSet, _ rhs: BitSet) -> BitSet {
    return (lhs.size > rhs.size) ? lhs : rhs
}

extension BitSet: BitwiseOperations {
    public static var allZeros: BitSet {
        return BitSet(size: 64)
    }
}

public func & (lhs: BitSet, rhs: BitSet) -> BitSet {
    let m = max(lhs.size, rhs.size)
    var out = BitSet(size: m)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] & rhs.words[i]
    }
    return out
}

public func | (lhs: BitSet, rhs: BitSet) -> BitSet {
    var out = copyLargest(lhs, rhs)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] | rhs.words[i]
    }
    return out
}

public func ^ (lhs: BitSet, rhs: BitSet) -> BitSet {
    var out = copyLargest(lhs, rhs)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] ^ rhs.words[i]
    }
    return out
}

prefix public func ~ (rhs: BitSet) -> BitSet {
    var out = BitSet(size: rhs.size)
    for i in 0..<rhs.words.count {
        out.words[i] = ~rhs.words[i]
    }
    out.clearUnusedBits()
    return out
}

extension UInt64 {
    public func bitsToString() -> String {
        var s = ""
        var n = self
        for _ in 1...64 {
            s += (((n & 1) == 1) ? "1" : "0")
            n >>= 1
        }
        
        return s
    }
}

extension BitSet: CustomStringConvertible {
    public var description: String {
        var s = ""
        for x in self.words {
            s += x.bitsToString()
        }
        return s
    }
}


var bits = BitSet(size: 140)
print("\(bits)\n")

bits[2] = true
bits[3] = true
bits[4] = true
print("\(bits)\n")

bits.cardinality

bits.setAll()

bits.cardinality

print("\(bits)\n")

var a = BitSet(size: 4)
var b = BitSet(size: 8)
a.setAll()
a.cardinality

a[1] = false
a[2] = false
a[3] = false

b[2] = true
b[6] = true
b[7] = true

print("A: \(a)\nB: \(b)\n")

let c = a | b
print("C: \(c)\n")

print("~A: \(~a)")
print("~B: \(~b)\n")

let d = a ^ b
let e = a & b
print("D: \(d)\n")
print("E: \(e)\n")

var z = BitSet(size: 66)
z.all0()
z.all1()

z[45] = true
z.any1()
z.all0()

z[65] = true
z.any1()

z.setAll()
z.all1()

z[65] = false
z.all1()





























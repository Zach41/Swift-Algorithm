//: Playground - noun: a place where people can play

public struct UnionFind<T: Hashable> {
    private var index = [T: Int]()
    private var parent = [Int]()
    private var size = [Int]()
    
    public mutating func addSetWith(_ element: T) {
        index[element] = parent.count
        parent.append(parent.count)
        size.append(1)
    }
    
    public mutating func setOf(_ element: T) -> Int? {
        if let indexOfElement = index[element] {
            return setByIndex(indexOfElement)
        } else {
            return nil
        }
    }
    
    private mutating func setByIndex(_ index: Int) -> Int {
        if parent[index] == index {
            return index
        } else {
            parent[index] = setByIndex(parent[index])
            return parent[index]
        }
    }
    
    public mutating func unionSetsContaining(_ firstElement: T, _ secondElement: T) {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            if firstSet != secondSet {
                if size[firstSet] < size[secondSet] {
                    parent[firstSet] = secondSet
                    size[secondSet] += size[firstSet]
                } else {
                    parent[secondSet] = firstSet
                    size[firstSet] += size[secondSet]
                }
            }
        }
    }
    public mutating func inSameSet(_ firstElement: T, _ secondElement: T) -> Bool {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            return firstSet == secondSet
        } else {
            return false
        }
    }
}

var dsu = UnionFind<Int>()

for i in 1...10 {
    dsu.addSetWith(i)
}

for i in 3...10 {
    if i % 2 == 0 {
        dsu.unionSetsContaining(2, i)
    } else {
        dsu.unionSetsContaining(1, i)
    }
}

print(dsu.inSameSet(2, 4))
print(dsu.inSameSet(4, 6))
print(dsu.inSameSet(6, 8))
print(dsu.inSameSet(8, 10))

print(dsu.inSameSet(1, 3))
print(dsu.inSameSet(3, 5))
print(dsu.inSameSet(5, 7))
print(dsu.inSameSet(7, 9))

print(dsu.inSameSet(7, 4))
print(dsu.inSameSet(3, 6))

var dsuForStrings = UnionFind<String>()
let words = ["all", "border", "boy", "afternoon", "amazing", "awesome", "best"]

dsuForStrings.addSetWith("a")
dsuForStrings.addSetWith("b")

for word in words {
    dsuForStrings.addSetWith(word)
    if word.hasPrefix("a") {
        dsuForStrings.unionSetsContaining("a", word)
    } else if word.hasPrefix("b") {
        dsuForStrings.unionSetsContaining("b", word)
    }
}

print(dsuForStrings.inSameSet("a", "all"))
print(dsuForStrings.inSameSet("all", "awesome"))
print(dsuForStrings.inSameSet("amazing", "afternoon"))

print(dsuForStrings.inSameSet("b", "boy"))
print(dsuForStrings.inSameSet("best", "boy"))
print(dsuForStrings.inSameSet("border", "best"))

print(dsuForStrings.inSameSet("amazing", "boy"))
print(dsuForStrings.inSameSet("all", "border"))
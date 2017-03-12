//: Playground - noun: a place where people can play

func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        return nil
    }
    
    let middleIdx = range.lowerBound + (range.upperBound - range.lowerBound) / 2
    
    if a[middleIdx] > key {
        return binarySearch(a, key: key, range: range.lowerBound ..< middleIdx)
    } else if a[middleIdx] < key {
        return binarySearch(a, key: key, range: middleIdx + 1 ..< range.upperBound)
    } else {
        return middleIdx
    }
}

func binarySearch2<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let middleIdx = lowerBound + (upperBound - lowerBound) / 2
        if a[middleIdx] > key {
            upperBound = middleIdx
        } else if a[middleIdx] < key {
            lowerBound = middleIdx + 1
        } else {
            return middleIdx
        }
    }
    return nil
}

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
binarySearch(numbers, key: 43, range: 0 ..< numbers.count)
binarySearch2(numbers, key: 43)




//: Playground - noun: a place where people can play

func countOccurrencesOfKey(sortedArray array: [Int], key: Int) -> Int {
    func lowBoundary() -> Int {
        var low = 0
        var high = array.count
        
        while low < high {
            let middle = low + (high - low) / 2
            if array[middle] < key {
                low = middle + 1
            } else {
                high = middle
            }
        }
        return low
    }
    
    func highBoundary() -> Int {
        var low = 0
        var high = array.count
        
        while low < high {
            let middle = low + (high - low) / 2
            if array[middle] > key {
                high = middle
            } else {
                low = middle + 1
            }
        }
        return low
    }
    
    return highBoundary() - lowBoundary()
}

countOccurrencesOfKey(sortedArray: [1, 1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 6], key: 2)

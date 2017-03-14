//: Playground - noun: a place where people can play

func partition<T: Comparable>(_ array: inout [T], _ low: Int, _ high: Int) -> Int {
    let pivot = array[high]
    
    var cur = low
    for idx in low..<high {
        if array[idx] <= pivot {
            (array[idx], array[cur]) = (array[cur], array[idx])
            cur += 1
        }
    }
    (array[high], array[cur]) = (array[cur], array[high])
    print("Debug")
    return cur
}

func quickSort<T: Comparable>(_ array: inout [T], _ low: Int, _ high: Int) {
    if low < high {
        let p = partition(&array, low, high)
        quickSort(&array, low, p-1)
        quickSort(&array, p+1, high)
    }
}

var numbers = [4, 3, 5, 2, 1, 6, 8, 7]
quickSort(&numbers, 0, 7)
numbers
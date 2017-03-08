//: Playground - noun: a place where people can play

func insertionSort<T>(array: [T], sort: (T, T) -> Bool) -> [T] {
    var array = array
    for idx in 1..<array.count {
        let temp = array[idx]
        var y = idx
        while y > 0 && sort(temp, array[y-1]) {
            array[y] = array[y-1]
            y -= 1
        }
        array[y] = temp
    }
    return array
}

let array = [2, 5, 3, 9, 7, 1]
let sortedArray = insertionSort(array: array, sort: <)
assert(sortedArray == [1, 2, 3, 5, 7, 9])
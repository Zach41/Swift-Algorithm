//: Playground - noun: a place where people can play

func heapSort<T>(array: [T], sort: @escaping (T, T) -> Bool) -> [T] {
    let reversed_sort = {i1, i2 in sort(i2, i1)}
    var heap = SwiftHeap(array: array, sort: reversed_sort)
    return heap.sort()
}

let array = [5, 13, 2, 25, 7, 17, 20, 8, 4]
let sortedArray = heapSort(array: array, sort: <)
assert(sortedArray == [2, 4, 5, 7, 8, 13, 17, 20, 25])

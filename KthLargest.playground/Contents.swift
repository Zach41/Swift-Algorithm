//: Playground - noun: a place where people can play

import Foundation

func random(min: Int, max: Int) -> Int {
    assert(min < max)
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
    if i != j {
        swap(&a[i], &a[j])
    }
}

func kthLargest<T: Comparable>(array: [T], order k: Int) -> T {
    var arr = array
    
    func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
        let pivotIndex = random(min: low, max: high)
        swap(&a, pivotIndex, high)
        return a[high]
    }
    
    func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
        let pivot = randomPivot(&a, low, high)
        var i = low
        for j in low ..< high {
            if a[j] <= pivot {
                swap(&a, i, j)
                i += 1
            }
        }
        swap(&a, high, i)
        return i
    }
    
    func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
        if low < high {
            let p = randomizedPartition(&a, low, high)
            if k == p {
                return a[p]
            } else if k < p {
                return randomizedSelect(&a, low, p-1, k)
            } else {
                return randomizedSelect(&a, p+1, high, k)
            }
        } else {
            return a[low]
        }
    }
    
    precondition(arr.count > 0)
    return randomizedSelect(&arr, 0, arr.count - 1, k)
}

let numbers = [5, 1, 3, 2, 7, 6, 4]
kthLargest(array: numbers, order: 0)
kthLargest(array: numbers, order: 1)
kthLargest(array: numbers, order: 2)
kthLargest(array: numbers, order: 3)
kthLargest(array: numbers, order: 4)
kthLargest(array: numbers, order: 5)
kthLargest(array: numbers, order: 6)

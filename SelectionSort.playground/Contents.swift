//: Playground - noun: a place where people can play

func selectionSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }
    
    var a = array
    for idx in 0..<a.count {
        var lowest = idx
        for i in lowest+1 ..< a.count {
            if a[i] < a[lowest] {
                lowest = i
            }
        }
        if lowest != idx {
            swap(&a[lowest], &a[idx])
        }
    }
    return a
}

let numbers = [1, 5, 4, 3, 2, 9, 7, 8, 6]
selectionSort(numbers)


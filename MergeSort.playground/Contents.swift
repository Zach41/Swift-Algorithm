//: Playground - noun: a place where people can play

func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else { return array }
    
    let middleIndex = array.count / 2
    let leftArray = mergeSort(Array(array[0..<middleIndex]))
    let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
    return merge(left: leftArray, right: rightArray)
}

func merge<T: Comparable>(left: [T], right: [T]) -> [T] {
    var leftIndex = 0
    var rightIndex = 0
    var orderedPile = [T]()
    
    while leftIndex < left.count && rightIndex < right.count {
        if left[leftIndex] < right[rightIndex] {
            orderedPile.append(left[leftIndex])
            leftIndex += 1
        } else if left[leftIndex] > right[rightIndex] {
            orderedPile.append(right[rightIndex])
            rightIndex += 1
        } else {
            orderedPile.append(left[leftIndex])
            leftIndex += 1
            orderedPile.append(right[rightIndex])
            rightIndex += 1
        }
    }
    
    while leftIndex < left.count {
        orderedPile.append(left[leftIndex])
        leftIndex += 1
    }
    
    while rightIndex < right.count {
        orderedPile.append(right[rightIndex])
        rightIndex += 1
    }
    
    return orderedPile
}

func mergeSort2<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    let n = array.count
    var z = [array, array]
    var d = 0
    
    var width = 1
    while width < n {
        var i = 0
        
        while i < n {
            var j = i
            var left = i
            var right = i + width
            
            let lmax = min(left + width, n)
            let rmax = min(right + width, n)
            
            while left < lmax && right < rmax {
                if isOrderedBefore(z[d][left], z[d][right]) {
                    z[1-d][j] = z[d][left]
                    left += 1
                } else {
                    z[1-d][j] = z[d][right]
                    right += 1
                }
                j += 1
            }
            
            while left < lmax {
                z[1-d][j] = z[d][left]
                left += 1
                j += 1
            }
            while right < rmax {
                z[1-d][j] = z[d][right]
                right += 1
                j += 1
            }
            
            i  += width * 2
        }
        width *= 2
        d = 1-d
    }
    return z[d]
}

mergeSort([2, 8, 5, 34, 4, 3, 1, 3, 7, 5])
mergeSort2([2, 8, 5, 34, 4, 3, 1, 3, 7, 5], <)
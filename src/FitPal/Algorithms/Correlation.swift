//
// Created by dykderrick on 2021/12/23.
//
// FitPal
//
// Copyright © 2021 Derrick Ding. All rights reserved.
//
	 

import Foundation

fileprivate func dotProduct(x: [Double], y: [Double]) -> Double {
    assert(x.count == y.count)
    
    var answer = 0.0
    
    for i in 0 ... x.count - 1 {
        answer += x[i] * y[i]
    }
    
    return answer
}

func getCorrelationArray(sample: [Double], truth: [Double]) -> [Double] {
    let lengthX = sample.count
    let lengthY = truth.count
    let N = max(lengthX, lengthY)
    var x = sample
    var y = truth
    
    if lengthX >= lengthY {
        y.append(contentsOf: Array(repeating: 0.0, count: N - lengthY))
    } else {
        x.append(contentsOf: Array(repeating: 0.0, count: N - lengthX))
    }
    
    var Rxy = Array(repeating: 0.0, count: 2 * N - 1)
    
    for nn in 0 ... N - 1 {
        Rxy[nn + N - 1] = dotProduct(x: Array(x[nn ... x.count - 1]), y: Array(y[0 ... y.count - nn - 1]))
    }
    for nn in 1 - N ... -1 {
        Rxy[nn + N - 1] = dotProduct(x: Array(x[0 ... x.count + nn - 1]), y: Array(y[-nn ... y.count - 1]))
    }
    
    return Rxy
}


//
//  VarDimArray.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/8/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class VarDimArray<T>: NSObject, Collection {
    
    var numDimensions: Int
    var dimensions: [Int]
    var count: Int
    var flatArray: [T?]
    var indexMultipliers: [Int]
    
    var startIndex: Int {
        get {
            return 0
        }
    }
    
    var endIndex: Int {
        get {
            return flatArray.count
        }
    }
    
    init(dimensions: [Int], defaultValue: T? = nil) {
        assert(dimensions.count > 0)
        
        for dim in dimensions {
            assert(dim > 0)
        }
        
        self.numDimensions = dimensions.count
        self.dimensions = dimensions
        
        self.flatArray = [T?](repeating: defaultValue, count: dimensions[0])
        self.count = dimensions[0]
        
        for dim in dimensions.dropFirst() {
            self.flatArray = [[T?]](repeating: self.flatArray, count: dim).reduce([], +)
            self.count *= dim
        }
        
        self.indexMultipliers = [1]
        
        for dim in dimensions.dropFirst().reversed() {
            let lastMult = indexMultipliers[indexMultipliers.count - 1]
            self.indexMultipliers.append(lastMult * dim)
        }
        
        self.indexMultipliers.reverse()
    }
    
    func calculateLinearIdx(idxs: [Int]) -> Int {
        assert(idxs.count == dimensions.count)
        var linearIdx = 0
            
        for ((idx, dim), mult) in zip(zip(idxs, dimensions), indexMultipliers) {
            assert(idx < dim)
            linearIdx += mult * idx
        }
    
        return linearIdx
    }
    
    func calculateMultiIdx(linearIdx: Int) -> [Int] {
        var linIdx = linearIdx
        var idxs: [Int] = []
        
        for mult in indexMultipliers {
            idxs.append(linIdx / mult)
            linIdx %= mult
        }
        
        return idxs
    }
    
    subscript(idx: Int) -> T? {
        get {
            return flatArray[idx]
        }
        set (elem) {
            flatArray[idx] = elem
        }
    }
    
    subscript(idxs: [Int]) -> T? {
        get {
            let linearIdx = calculateLinearIdx(idxs: idxs)
            return flatArray[linearIdx]
        }
        set (elem) {
            let linearIdx = calculateLinearIdx(idxs: idxs)
            flatArray[linearIdx] = elem
        }
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
}

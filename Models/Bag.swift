//
//  Bag.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/11/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Bag: NSObject {
    
    var remainingLetters: [Character: Int]
    
    override init() {
        remainingLetters = [:]
        
        for (letter, count) in zip(Constants.LETTERS, Constants.INIT_LETTER_COUNTS) {
            remainingLetters[letter] = count
        }
    }
    
    func takeRandomLetter() -> Character? {
        let weights: [Int] = remainingLetters.map({ return $0.value })
        var rem = Int.random(in: 0..<weights.reduce(0, +))
        
        for (letter, count) in remainingLetters {
            rem -= count
            
            if rem < 0 {
                remainingLetters[letter] = count - 1
                return letter
            }
        }
        
        return nil
    }
    
    func isEmpty() -> Bool {
        for (_, count) in remainingLetters {
            if count > 0  {
                return false
            }
        }
        
        return true
    }

}

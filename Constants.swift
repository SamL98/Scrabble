//
//  File.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/11/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import Foundation

struct Constants {
    
    static let NR = 15
    static let NC = 15
    static let NTILES = 7
    
    static let LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let INIT_LETTER_COUNTS: [Int] = [
        9, 2, 2, 4, 12, 2, 3, 2, 9, 9, 1, 4, 2,
        6, 8, 2, 1, 6, 4, 4, 2, 2, 1, 2, 1, 2
    ]
    static let LETTER_SCORES: [Character:Int] = [
        "A": 1,
        "B": 3,
        "C": 3,
        "D": 2,
        "E": 1,
        "F": 4,
        "G": 2,
        "H": 4,
        "I": 1,
        "J": 8,
        "K": 5,
        "L": 1,
        "M": 3,
        "N": 1,
        "O": 1,
        "P": 3,
        "Q": 10,
        "R": 1,
        "S": 1,
        "T": 1,
        "U": 1,
        "V": 4,
        "W": 4,
        "X": 8,
        "Y": 4,
        "Z": 10,
        "#": 0
    ]
    
    static let BONUS = 50
    
    static let TRIPLE_WORD_IDXS: [[Int]] = [
        [0,0],
        [7,0],
        [14,0],
        [0,7],
        [14,7],
        [0,14],
        [7,14],
        [14,14]
    ]
    
    static let DOUBLE_WORD_IDXS: [[Int]] = [
        [1,1],
        [2,2],
        [3,3],
        [4,4],
        [7,7],
        [10,10],
        [11,11],
        [12,12],
        [13,13],
        [13,1],
        [12,2],
        [11,3],
        [10,4],
        [4,10],
        [3,11],
        [2,12],
        [1,13]
    ]
    
    static let TRIPLE_LETTER_IDXS: [[Int]] = [
        [1,5],
        [1,9],
        [5,1],
        [5,5],
        [5,9],
        [5,13],
        [9,1],
        [9,5],
        [9,9],
        [9,13],
        [13,5],
        [13,9]
    ]
    
    static let DOUBLE_LETTER_IDXS: [[Int]] = [
        [0,3],
        [0,11],
        [2,6],
        [2,8],
        [3,0],
        [3,7],
        [3,14],
        [6,2],
        [6,6],
        [6,8],
        [6,12],
        [7,3],
        [7,11],
        [8,2],
        [8,6],
        [8,8],
        [8,12],
        [11,0],
        [11,7],
        [11,14],
        [12,6],
        [12,8],
        [14,3],
        [14,11]
    ]
    
}

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
        "J": 1,
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
    
}

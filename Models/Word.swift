//
//  Word.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/20/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Word: NSObject {
    
    var tiles: [Tile]
    
    init(tiles: [Tile]) {
        self.tiles = tiles
        super.init()
    }
    
    func score() -> Int {
        var score_ = 0
        
        for tile in tiles {
            score_ += Constants.LETTER_SCORES[tile.letter]!
        }
        
        return score_
    }
    
    func string() -> String {
        return tiles.map({ "\($0.letter)" }).reduce("", +)
    }
    
    func isValid() -> Bool {
        return ScrabbleDictionary.shared.contains(self.string().lowercased())
    }

}

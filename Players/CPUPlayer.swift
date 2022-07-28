//
//  CPUPlayer.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/12/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class CPUPlayer: Player {
    
    override func isUser() -> Bool {
        return false
    }
    
    override func move() {
        broadcastSelf()
        
        // 1. For all of the valid positions (and directions), get the words
        //      that can be constructed from the rack and valid letters.
        
        var bestScore = 0
        var bestPlacedTiles: [Tile] = []
        let rackLetters = rack.tiles.map({ $0!.letter })
        
        let candidateIdxs = game.board.getValidStartingIndices()
            
        for (idxs, dir) in candidateIdxs {
            let constraints = self.game.board.getConstraints(at: idxs, dir)
            let words = ScrabbleDictionary.shared.getWordsFromLetters(rackLetters, constraints: constraints)
            
            for word in words {
                let placedTiles = self.game.board.getPlacedTiles(for: word, startingAt: idxs, dir)
                self.game.board.setPlacedTiles(placedTiles)
                
                let newWords = self.game.board.getNewWords(dir: dir)
                var wordsOk = true
                
                for word in newWords {
                    if !word.isValid() {
                        wordsOk = false
                        break
                    }
                }
                
                if !wordsOk {
                    self.game.board.clearPlacedTiles()
                    continue
                }
                
                let score = self.game.board.score(newWords)
                
                if score > bestScore {
                    bestScore = score
                    bestPlacedTiles = placedTiles
                }
                
                self.game.board.clearPlacedTiles()
            }
        }
        
        self.game.board.setPlacedTiles(bestPlacedTiles)
        
        for tile in bestPlacedTiles {
            // Search for a tile in the rack that we can use for this newly-created tile.
            let rackTile = self.rack.tiles.first(where: { $0?.letter == tile.letter })!!
            tile.view = rackTile.view
            tile.rackIdxs = rackTile.idxs
            
            self.rack.nullify(at: rackTile.idxs)
            self.broadcastTile(tile)
        }
        
        _ = self.game.submitMove()
    }
}

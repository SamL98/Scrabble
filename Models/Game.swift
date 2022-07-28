//
//  Game.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/15/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    var playerIdx: Int
    var currentPlayer: Player {
        get {
            return players[playerIdx]
        }
    }
    
    var players: [Player]
    var board: Board
    var bag: Bag
    
    var paused: Bool
    var pausingEnabled: Bool
    
    var onResume: (() -> Void)? = nil
    
    init(board: Board, bag: Bag) {        
        self.playerIdx = 0
        self.players = []
        self.board =  board
        self.bag = bag
        
        self.paused = false
        self.pausingEnabled = true
        
        super.init()
    }
    
    func pause(onResume: (() -> Void)? = nil) {
        if self.pausingEnabled {
            self.paused = true
            self.onResume = onResume
        }
    }
    
    func unpause() {
        self.paused = false
        
        if onResume != nil {
            onResume!()
            onResume = nil
        }
    }
    
    func disablePausing() {
        self.pausingEnabled = false
    }
    
    func isFinished() -> Bool {
        // Not sure when the bag could be non-empty when a player has no tiles but you never know.
        if !bag.isEmpty() {
            return false
        }
        
        for player in players {
            if player.rack.numTiles() == 0 {
                return true
            }
        }
        
        return false
    }
    
    func nextPlayer() -> Player {
        playerIdx = (playerIdx + 1) % players.count
        return players[playerIdx]
    }
    
    func start() {
        currentPlayer.move()
    }
    
    func submitMove() -> Bool {
        // 1. Make sure that the board state is valid
        // 2. Freeze the new tiles in the board
        // 3. Replenish the rack.
        
        if !board.isValid() {
            print("Board is in an invalid state")
            return false
        }
        
        let newWords = board.getNewWords()
        
        for word in newWords {
            if !word.isValid() {
                print("Word \(word.string()) is not valid")
                return false
            }
        }
        
        let score = board.score(newWords)
        
        currentPlayer.replenish(oldTiles: board.placedTiles)
        currentPlayer.addScore(score)
        
        let placedTiles = board.placedTiles
        board.clearPlacedTiles()
        
        // We need to re-set the placed tiles in the game board.
        for tile in placedTiles {
            board.set(tile: tile, at: tile.idxs, place: false)
        }
        
        nextPlayer().move()
        return true
    }

}

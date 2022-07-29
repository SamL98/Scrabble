//
//  Player.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/12/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Player: NSObject {
    
    var game: Game
    var rack: Rack
    var score: Int
    var displayTiles: Bool
    
    init(game: Game, rackView: RackView, displayTiles: Bool = true) {
        self.game = game
        self.rack = Rack(view: rackView, displayTiles: displayTiles)
        self.score = 0
        self.displayTiles = displayTiles
        
        super.init()
        self.game.players.append(self)
        
        for i in 0..<Constants.NTILES {
            _ = setNewTile(at: [i])
        }
    }
    
    func printRack() {
        var rackString = ""
        
        for i in 0..<Constants.NTILES {
            if rack.tiles[[i]] == nil {
                rackString += "_ "
            }
            else {
                rackString += "\(rack.tiles[[i]]!.letter) "
            }
        }
        
        print(rackString)
    }
    
    func setNewTile(at idxs: [Int]) -> Tile? {
        if let letter = game.bag.takeRandomLetter() {
            let tile = Tile(container: rack, indices: idxs, letter: letter)
            
            rack.set(tile: tile, at: idxs)
            
            if displayTiles {
                rack.create(tile: tile, at: idxs, interactable: isUser())
            }
            
            //broadcastTile(tile)
            return tile
        }
        
        return nil
    }
    
    func replenish(oldTiles: [Tile]) {
        for tile in oldTiles {
            tile.freezeInPlace()
            
            if let idxs = tile.rackIdxs {
                _ = setNewTile(at: idxs)
            }
        }
    }
    
    func addScore(_ score: Int) {
        self.score += score
    }
    
    func move() {}
    func isUser() -> Bool { return false }
    
    func broadcastSelf() {
        NotificationCenter.default.post(name: Notification.Name("player-changed"),
                                        object: nil,
                                        userInfo: ["player": self])
    }
    
    func broadcastTile(_ tile: Tile) {
        NotificationCenter.default.post(name: Notification.Name("tile-created"),
                                        object: nil,
                                        userInfo: ["tile": tile as AnyObject])
    }
    
}

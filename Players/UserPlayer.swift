//
//  UserPlayer.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/12/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class UserPlayer: Player {
    
    /*override func setNewTile(at idxs: [Int]) -> Tile? {
        let tile = super.setNewTile(at: idxs)
        
        if tile != nil {
            broadcastTile(tile!)
        }
        
        return tile
    }*/
    
    override func isUser() -> Bool {
        return true
    }

    override func move() {
        broadcastSelf()
        
        /*NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveSubmitted(_:)),
                                               name: Notification.Name("move-submitted"),
                                               object: nil)*/
    }
    
    /*@objc
    func moveSubmitted(_ notification: Notification) {
        if game.submitMove() {
            NotificationCenter.default.removeObserver(self)
        }
    }*/
    
}

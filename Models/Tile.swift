//
//  Tile.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/12/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Tile: NSObject {
    
    var container: TileContainer?
    var rackIdxs: [Int]? // gross :(
    var oldIdxs: [Int]
    private var _idxs: [Int]
    var idxs: [Int] {
        get {
            return _idxs
        }
        set {
            oldIdxs = idxs
            _idxs = newValue
        }
    }
    var letter: Character
    var text: String
    var view: TileView?

    init(container: TileContainer, indices: [Int], letter: Character) {
        self.container = container
        self.oldIdxs = indices
        self._idxs = indices
        self.letter = letter
        self.text = "\(letter)"
        
        if let _ = container as? Rack {
            self.rackIdxs = indices
        }
        
        super.init()
    }
    
    init(container: TileContainer, indices: [Int], text: String) {
        self.container = container
        self.oldIdxs = indices
        self._idxs = indices
        self.letter = "A" // gross :(
        self.text = text
        
        if let _ = container as? Rack {
            self.rackIdxs = indices
        }
        
        super.init()
    }
    
    func freezeInPlace() {
        view?.isUserInteractionEnabled = false
        view?.backgroundColor = UIColor.lightGray
    }
    
    func highlight() {
        view?.highlight()
    }
    
    func unhighlight() {
        view?.unhighlight()
    }
    
}

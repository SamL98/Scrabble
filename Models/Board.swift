//
//  Board.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/11/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

struct TileStart: Hashable {
    let idxs: [Int]
    let dir: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idxs)
        hasher.combine(dir)
    }
    
    func toTuple() -> ([Int], Int) {
        return (idxs, dir)
    }
}

class Board: TileContainer {
    
    var placedTiles: [Tile]
    var letterMultipliers: VarDimArray<Int>
    var wordMultipliers: VarDimArray<Int>
    
    init(boardView: BoardView) {
        self.placedTiles = []
        
        let dimensions = [Constants.NR, Constants.NC]
        
        self.letterMultipliers = VarDimArray<Int>(dimensions: dimensions, defaultValue: 1)
        self.wordMultipliers = VarDimArray<Int>(dimensions: dimensions, defaultValue: 1)
        
        for tileIdxs in Constants.TRIPLE_WORD_IDXS {
            self.wordMultipliers[tileIdxs] = 3
        }
        
        for tileIdxs in Constants.DOUBLE_WORD_IDXS {
            self.wordMultipliers[tileIdxs] = 2
        }
        
        for tileIdxs in Constants.TRIPLE_LETTER_IDXS {
            self.letterMultipliers[tileIdxs] = 3
        }
        
        for tileIdxs in Constants.DOUBLE_LETTER_IDXS {
            self.letterMultipliers[tileIdxs] = 2
        }
        
        super.init(dimensions: dimensions, view: boardView)
    }
    
    override func set(tile: Tile, at indices: [Int], place: Bool = true) {
        super.set(tile: tile, at: indices)
        
        if place {
            placedTiles.append(tile)
        }
    }
    
    override func nullify(at indices: [Int]) {
        super.nullify(at: indices)
        
        // This is a little tricky but in ViewController.snap, container.nullify is called when
        // the tile still has its old indices so we can search through the placedTiles for those indices.
        // We can do naive search since there's only gonna be at most 7 placedTiles.
        
        placedTiles.removeAll(where: { $0.idxs == indices })
    }
    
    func printBoard() {
        for row in 0..<dimensions[0] {
            var rowString = ""
            
            for col in 0..<dimensions[1] {
                let tile = tiles[[row, col]]
                
                if tile == nil {
                    rowString += "_ "
                }
                else {
                    rowString += "\(tile!.letter) "
                }
            }
            
            print(rowString)
        }
    }
    
    func setPlacedTiles(_ newTiles: [Tile]) {
        clearPlacedTiles()
        
        for tile in newTiles {
            set(tile: tile, at: tile.idxs)
        }
    }
    
    func clearPlacedTiles() {
        for tile in placedTiles {
            nullify(at: tile.idxs)
        }
        
        placedTiles = []
    }
    
    func isValid(firstMove: Bool) -> Bool {
        // Make sure that the placedTiles lie on a line and there are no gaps.
        if placedTiles.count == 0 {
            return false
        }
        else if placedTiles.count == 1 {
            for dir in 0..<2 {
                for delta in 0..<2 {
                    var tmpIxs = placedTiles[0].idxs
                    tmpIxs[dir] += 2 * delta - 1
                    
                    if indicesValidAndOccupied(tmpIxs) {
                        return true
                    }
                }
            }
        }
        
        var ix: Int
        
        // 1. Determine the direction and sort along that direction.
        if placedTiles[0].idxs[0] == placedTiles[1].idxs[0] {
            ix = 1
        }
        else if placedTiles[0].idxs[1] == placedTiles[1].idxs[1] {
            ix = 0
        }
        else {
            return false
        }
        
        let oc = placedTiles[0].idxs[1 - ix]
        placedTiles = placedTiles.sorted(by: { $0.idxs[ix] < $1.idxs[ix] })
        
        for (i, t1) in placedTiles.dropLast().enumerated() {
            let t2 = placedTiles[i + 1]

            if t2.idxs[1 - ix] != oc {
                return false
            }
            
            let c1 = t1.idxs[ix],
                c2 = t2.idxs[ix]
            
            for cp in (c1 + 1)..<c2 {
                var testIdxs = [0, 0]
                testIdxs[ix] = cp
                testIdxs[1 - ix] = oc
                
                if !indicesOccupied(testIdxs) {
                    return false
                }
            }
        }
        
        return !firstMove || indicesOccupied([7,7])
    }
    
    func getExtent(at idxs: [Int], direction: Int, going: Int) -> Int {
        var tmpIdxs = [idxs[0], idxs[1]]
        
        while indicesInBounds(tmpIdxs) && indicesOccupied(tmpIdxs) {
            tmpIdxs[direction] += going
        }
        
        tmpIdxs[direction] -= going
        return tmpIdxs[direction]
    }
    
    func getWord(at idxs: [Int], direction: Int) -> Word? {
        var wordTiles: [Tile] = [],
            lowerBound = getExtent(at: idxs, direction: direction, going: -1),
            upperBound = getExtent(at: idxs, direction: direction, going: 1)
        
        if lowerBound == upperBound {
            return nil
        }
        
        for i in lowerBound..<(upperBound + 1) {
            var tileIdxs = idxs
            tileIdxs[direction] = i
            
            wordTiles.append(tiles[tileIdxs]!)
        }
        
        return Word(tiles: wordTiles)
    }
    
    func getNewWords(dir: Int? = nil) -> [Word] {
        // Assume that the board has been validated before this is called.
        
        if placedTiles.count == 0 {
            return []
        }
        
        var dir = dir
        
        if dir == nil {
            if placedTiles.count == 1 {
                for d in 0..<2 {
                    for delta in 0..<2 {
                        var tmpIxs = placedTiles[0].idxs
                        tmpIxs[d] += 2 * delta - 1
                        
                        if indicesValidAndOccupied(tmpIxs) {
                            dir = d
                            break
                        }
                    }
                }
            }
            else if placedTiles[0].idxs[0] == placedTiles[1].idxs[0] {
                dir = 1
            }
            else if placedTiles[0].idxs[1] == placedTiles[1].idxs[1] {
                dir = 0
            }
            else {
                return [] // We shouldn't be here.
            }
        }
        
        placedTiles = placedTiles.sorted(by: { $0.idxs[dir!] < $1.idxs[dir!] })
        
        var words: [Word] = []
        
        // 1. Get the word in the placed direction.
        words.append(getWord(at: placedTiles[0].idxs, direction: dir!)!)
        
        for tile in placedTiles {
            if let word = getWord(at: tile.idxs, direction: 1 - dir!) {
                words.append(word)
            }
        }
        
        return words
    }
    
    func getValidStartingIndices() -> [([Int], Int)] {
        var idxs = Set<TileStart>()
        
        for row in 0..<dimensions[0] {
            for col in 0..<dimensions[1] {
                let ixs = [row, col]
                
                for dir in 0..<2 {
                    var prevIxs = ixs
                    prevIxs[dir] -= 1
                
                    // A starting tile has to have a blank before it.
                    if indicesValidAndOccupied(prevIxs) {
                        continue
                    }
                    
                    var tmpIxs = ixs
                    
                    // It must also be within NTILES spaces of a tile that is adjacent to an occupied tile.
                    for _ in 0..<Constants.NTILES {
                        var onDirIxs = tmpIxs,
                            offDirIxs = tmpIxs
                        
                        onDirIxs[dir] += 1
                        offDirIxs[1 - dir] += 1
                        
                        if indicesInBounds(tmpIxs) && (indicesOccupied(tmpIxs) || indicesValidAndOccupied(onDirIxs) || indicesValidAndOccupied(offDirIxs)) {
                            
                            idxs.insert(TileStart(idxs: ixs, dir: dir))
                            break
                        }
                        
                        tmpIxs[dir] += 1
                    }
                }
            }
        }
        
        return idxs.map({ $0.toTuple() })
    }
    
    func getConstraints(at idxs: [Int], _ direction: Int) -> [(Character?, Bool)] {
        // 1. Back up idxs so that any prefixes (in the direction of going) are included.
        // 2. Increment idxs until we've used up all the tiles and included any suffixes
        //      or reached a boundary.
        
        var ixs = idxs
        ixs[direction] -= 1
        
        while indicesInBounds(ixs) && indicesOccupied(ixs) {
            ixs[direction] -= 1
        }
        
        ixs[direction] += 1
        
        var constraints: [(Character?, Bool)] = [],
            lastLetter = tiles[ixs]?.letter,
            numBlank = lastLetter == nil ? 1 : 0,
            tileSeen = lastLetter != nil
        
        ixs[direction] += 1
        
        while numBlank <= Constants.NTILES && indicesInBounds(ixs) {
            constraints.append((lastLetter, !indicesOccupied(ixs) && tileSeen))
            
            lastLetter = tiles[ixs]?.letter
            numBlank += lastLetter == nil ? 1 : 0
            tileSeen = tileSeen || (lastLetter != nil)
            
            ixs[direction] += 1
        }
        
        if numBlank < Constants.NTILES {
            constraints.append((lastLetter, true))
        }
        
        return constraints
    }
    
    func getPlacedTiles(for word: String, startingAt idxs: [Int], _ direction: Int) -> [Tile] {
        var tmpIdxs = idxs,
            newTiles: [Tile] = []
        
        for c in word {
            if !indicesOccupied(tmpIdxs) {
                let tile = Tile(container: self, indices: tmpIdxs, letter: c)
                newTiles.append(tile)
            }
            
            tmpIdxs[direction] += 1
        }
        
        return newTiles
    }
    
    func score(_ word: Word) -> Int {
        var score = 0,
            wordMultiplier = 1
        
        for tile in word.tiles {
            score += Constants.LETTER_SCORES[tile.letter]! * letterMultipliers[tile.idxs]!
            wordMultiplier *= wordMultipliers[tile.idxs]!
        }
        
        return score * wordMultiplier
    }
    
    func score(_ words: [Word]) -> Int {
        var score = 0
        
        for word in words {
            score += self.score(word)
        }
        
        if placedTiles.count == Constants.NTILES {
            score += Constants.BONUS
        }
        
        return score
    }

}

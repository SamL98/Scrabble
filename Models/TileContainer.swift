//
//  TileContainer.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/8/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

protocol TileDelegate {
    func tilePan(pan: UIPanGestureRecognizer)
}

class TileContainer: NSObject {
    
    var dimensions: [Int]
    var orientation: Int
    var tiles: VarDimArray<Tile>
    var view: TileContainerView
    var delegate: TileDelegate?
    
    init(dimensions: [Int], view: TileContainerView, orientation: Int = 1) {
        self.dimensions = dimensions
        self.tiles = VarDimArray<Tile>(dimensions: dimensions)
        self.view = view
        self.orientation = orientation
        super.init()
        
        view.initialize(container: self)
    }
    
    func numTiles() -> Int {
        var count = 0
        
        for tile in tiles {
            if tile != nil {
                count += 1
            }
        }
        
        return count
    }
    
    func set(tile: Tile, at indices: [Int], place: Bool = true) {
        self.tiles[indices] = tile
    }
    
    func create(tile: Tile, at indices: [Int], interactable: Bool) {
        let absFrame = view.superview!.convert(view.squareViews[indices]!.frame, from: view)
        let tileView = TileView(container: view, tile: tile, frame: absFrame)
        
        view.superview?.addSubview(tileView)
        tile.view = tileView
        
        if interactable {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(tilePan(pan:)))
            pan.minimumNumberOfTouches = 1
            pan.maximumNumberOfTouches = 1
            tileView.addGestureRecognizer(pan)
        }
    }
    
    @objc func tilePan(pan: UIPanGestureRecognizer) {
        delegate?.tilePan(pan: pan)
    }
    
    func nullify(at indices: [Int]) {
        self.tiles[indices] = nil
    }
    
    func indicesInBounds(_ indices: [Int]) -> Bool {
        assert(indices.count == tiles.dimensions.count)
        
        for (idx, dim) in zip(indices, tiles.dimensions) {
            if (idx < 0) || (idx >= dim) {
                return false
            }
        }
        
        return true
    }
    
    func indicesOccupied(_ indices: [Int]) -> Bool {
        return tiles[indices] != nil
    }
    
    func indicesValidAndOccupied(_ indices: [Int]) -> Bool {
        return indicesInBounds(indices) && indicesOccupied(indices)
    }
    
    func getAvailableIndices() -> [[Int]] {
        var idxs: [[Int]] = []
        
        for i in 0..<tiles.count {
            let indices = tiles.calculateMultiIdx(linearIdx: i)
            
            if !indicesOccupied(indices) {
                idxs.append(indices)
            }
        }
        
        return idxs
    }
    
    func getOccupiedIndices() -> [[Int]] {
        var idxs: [[Int]] = []
        
        for i in 0..<tiles.count {
            let indices = tiles.calculateMultiIdx(linearIdx: i)
            
            if indicesOccupied(indices) {
                idxs.append(indices)
            }
        }
        
        return idxs
    }
    
    func getAvailableIndices(_ indices: [Int]) -> [[Int]] {
        assert(indices.count == tiles.dimensions.count)
        
        var idxs: [[Int]] = []
        
        for d in 0..<Int(pow(2.0, Double(indices.count))) {
            var testIndices = indices,
                dp = d;
            
            for i in 0..<indices.count {
                testIndices[i] += dp % 2
                dp = dp / 2
            }
            
            if indicesInBounds(testIndices) && !indicesOccupied(testIndices) {
                idxs.append(testIndices)
            }
        }
        
        return idxs
    }
    
    func getBestIndicesFor(_ rect: CGRect) -> ([Int]?, CGRect?) {
        /*
         This method only works for 1 and 2D TileContainer's since UI components are only 2D.
         */
        assert(dimensions.count <= 2)

        var indices: [Int] = []
        
        // Gross. Eh maybe not that gross.
        if dimensions.count == 2 {
            indices.append(Int(floor(rect.minY / view.tileSize)))
        }
        
        indices.append(Int(floor(rect.minX / view.tileSize)))
        
        var bestIndices: [Int]? = nil,
            bestInter: CGFloat = 0.0;
        
        let availableIdxs = getAvailableIndices(indices)
        
        // This means that all the (max) four squares the tile is hovering hover are occupied.
        guard availableIdxs.count > 0 else {
            print("No available squares :(")
            return (nil, nil)
        }
        
        for indices in availableIdxs {
            let interRect = view.squareViews[indices]!.frame.intersection(rect)
            let inter = interRect.width * interRect.height
            
            if interRect.width > 0 && interRect.height > 0 && inter >= bestInter {
                bestIndices = indices
                bestInter = inter
            }
        }
        
        if bestIndices == nil {
            return (nil, nil)
        }
        
        return (bestIndices, view.squareViews[bestIndices!]?.frame)
    }
    
    func highlight(_ idxs: [Int]) {
        if indicesOccupied(idxs) {
            tiles[idxs]?.highlight()
        }
        else {
            view.squareViews[idxs]?.highlight()
        }
    }
    
    func unhighlight(_ idxs: [Int]) {
        tiles[idxs]?.unhighlight()
        view.squareViews[idxs]?.unhighlight()
    }

}

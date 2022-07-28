//
//  TileContainerView.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/8/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class TileContainerView: UIScrollView {

    var dimensions: [Int]!
    var orientation: Int!
    var squareViews: VarDimArray<SquareView>!
    var tileSize: CGFloat!

    func initialize(container: TileContainer) -> Void {
        self.dimensions = container.tiles.dimensions
        self.orientation = container.orientation
        self.squareViews = VarDimArray<SquareView>(dimensions: dimensions)
        
        let size = orientation == 1 ? self.frame.width : self.frame.height
        self.tileSize = size / CGFloat(dimensions[0])
        
        for linearIdx in 0..<squareViews.count {
            let idxs = squareViews.calculateMultiIdx(linearIdx: linearIdx)
            makeSquare(at: idxs)
        }
    }
    
    func initialize(dimensions: [Int]) -> Void {
        self.dimensions = dimensions
        self.squareViews = VarDimArray<SquareView>(dimensions: dimensions)
        self.tileSize = self.frame.width / CGFloat(dimensions[0])
        
        for linearIdx in 0..<squareViews.count {
            let idxs = squareViews.calculateMultiIdx(linearIdx: linearIdx)
            makeSquare(at: idxs)
        }
    }
    
    func coordinates(for indices: [Int]) -> CGPoint {
        /*
         Again, this method is only valid for 1 or 2-dimensional TileContainer's.
         */
        assert(dimensions.count <= 2 && indices.count == dimensions.count)
        
        var x: CGFloat,
            y: CGFloat;
        
        if dimensions.count == 1 {
            if orientation == 0 {
                x = 0.0
                y = CGFloat(indices[0]) * tileSize
            }
            else {
                x = CGFloat(indices[0]) * tileSize
                y = 0.0
            }
        }
        else {
            x = CGFloat(indices[1]) * tileSize
            y = CGFloat(indices[0]) * tileSize
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func makeSquare(at indices: [Int]) {
        /*
         Again, this method is only valid for 1 or 2-dimensional TileContainer's.
         */
        assert(dimensions.count <= 2 && indices.count == dimensions.count)
        
        var x: CGFloat,
            y: CGFloat;
        
        if dimensions.count == 1 {
            if orientation == 0 {
                x = 0.0
                y = CGFloat(indices[0]) * tileSize
            }
            else {
                x = CGFloat(indices[0]) * tileSize
                y = 0.0
            }
        }
        else {
            x = CGFloat(indices[1]) * tileSize
            y = CGFloat(indices[0]) * tileSize
        }
        
        let tileFrame = CGRect(x: x,
                               y: y,
                               width: tileSize,
                               height: tileSize);

        let squareView = SquareView(frame: tileFrame)
        
        // NOTE: For this to make sense, makeSquareAt must be called with the current order.
        self.squareViews[indices] = squareView
        self.addSubview(squareView);
    }

}

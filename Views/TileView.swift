//
//  SquareView.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/5/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    var tile: Tile!
    var container: TileContainerView!
    
    var label: UILabel!
    
    var origContainer: TileContainerView!
    var origFrame: CGRect!
    var tileSize: CGFloat!

    init(container: TileContainerView, tile: Tile, frame: CGRect) {
        super.init(frame: frame)
        
        self.tile = tile
        self.tile.view = self
        
        self.container = container
        self.origContainer = container
        
        origFrame = frame
        tileSize = frame.width
        
        label = UILabel(frame: self.bounds)
        
        label.textAlignment = .center
        label.text = tile.text
        label.textColor = UIColor.black
        
        self.addSubview(label)
        
        backgroundColor = UIColor.green
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0;
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func translate(by vec: CGPoint) {
        move(to: CGPoint(x: origFrame.minX + vec.x,
                         y: origFrame.minY + vec.y))
    }
    
    func move(to pt: CGPoint) {
        self.frame = CGRect(x: pt.x,
                            y: pt.y,
                            width: self.frame.width,
                            height: self.frame.height)
    }
    
    func resize(to width: CGFloat) {
        let diff = self.frame.width - width
        
        self.frame = CGRect(x: self.frame.minX + diff / 2,
                            y: self.frame.minY + diff / 2,
                            width: width,
                            height: width)
        
        self.label.frame = self.bounds
    }
    
    func highlight() {
        self.layer.borderColor = UIColor.orange.cgColor
    }
    
    func unhighlight() {
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}

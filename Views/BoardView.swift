//
//  BoardView.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/1/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class BoardView: TileContainerView {
    
    override func initialize(container: TileContainer) {
        super.initialize(container: container)
        
        for tileIdxs in Constants.TRIPLE_WORD_IDXS {
            squareViews[tileIdxs]?.backgroundColor = UIColor.red
        }
        
        for tileIdxs in Constants.DOUBLE_WORD_IDXS {
            squareViews[tileIdxs]?.backgroundColor = UIColor.orange
        }
        
        for tileIdxs in Constants.TRIPLE_LETTER_IDXS {
            squareViews[tileIdxs]?.backgroundColor = UIColor.blue
        }
        
        for tileIdxs in Constants.DOUBLE_LETTER_IDXS {
            squareViews[tileIdxs]?.backgroundColor = UIColor.systemBlue
        }
    }
    
}

//
//  Rack.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/11/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class Rack: TileContainer {
    
    init(view: TileContainerView, displayTiles: Bool = false) {
        super.init(dimensions: [Constants.NTILES], view: view, displayTiles: displayTiles)
    }

}

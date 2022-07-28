//
//  SquareView.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/5/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class SquareView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 183/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func highlight() {
        self.layer.borderColor = UIColor.orange.cgColor
    }
    
    func unhighlight() {
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}

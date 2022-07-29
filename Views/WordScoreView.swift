//
//  WordScoreView.swift
//  Scrabble
//
//  Created by Sam Lerner on 7/29/22.
//  Copyright © 2022 Sam Lerner. All rights reserved.
//

import UIKit

class WordScoreView: UIView {
    
    static let SCORE_RATING_CAP = 50
    
    var blueH: CGFloat = 0
    var blueS: CGFloat = 0
    var blueV: CGFloat = 0
    
    var redH: CGFloat = 0
    var redS: CGFloat = 0
    var redV: CGFloat = 0
    
    var scoreLabel: UILabel!
    
    override init(frame: CGRect) {
        UIColor.blue.getHue(&blueH, saturation: &blueS, brightness: &blueV, alpha: nil)
        UIColor.red.getHue(&redH, saturation: &redS, brightness: &redV, alpha: nil)
        
        super.init(frame: frame)
        
        scoreLabel = UILabel(frame: self.bounds.insetBy(dx: 4.0, dy: 2.5))
        scoreLabel.textAlignment = NSTextAlignment.center
        
        addSubview(scoreLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayScore(_ score: Int) {
        let t: CGFloat = CGFloat(min(score, WordScoreView.SCORE_RATING_CAP)) / CGFloat(WordScoreView.SCORE_RATING_CAP)
        
        let h = blueH * (1 - t) + redH * t,
            s = blueS * (1 - t) + redS * t,
            v = blueV * (1 - t) + redV * t
        
        let fontSize = 12.0 * (1 - t) + 20.0 * t
        let fontWeight = 0.0 * (1 - t) + 1.0 * t
        
        scoreLabel.textColor = UIColor(hue: h, saturation: s, brightness: v, alpha: 1.0)
        scoreLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(fontWeight))
        scoreLabel.text = "\(score)"
        
        scoreLabel.sizeToFit()
        
        let dw = scoreLabel.frame.width + 8.0 - frame.width
        
        frame = CGRect(x: frame.minX - dw,
                       y: frame.minY,
                       width: scoreLabel.frame.width + 8.0,
                       height: scoreLabel.frame.height + 5.0)
    }
    
}

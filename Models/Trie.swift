//
//  Trie.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/21/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

class Trie: NSObject {
    
    var isValid: Bool
    var isTerminal: Bool
    var children: [Character:Trie]
    
    var prefix: Character?
    var parent: Trie?
    
    var word: String {
        get {
            if parent == nil || prefix == nil {
                return ""
            }
            else {
                return parent!.word + "\(prefix!)"
            }
        }
    }
    
    init(parent: Trie? = nil, prefix: Character? = nil) {
        self.isTerminal = true
        self.isValid = false
        
        self.parent = parent
        self.prefix = prefix
        self.children = [:]
        
        super.init()
    }
    
    func insert(_ word: String) {
        isTerminal = false
        
        if word.count == 0 {
            isValid = true
            return
        }
        
        if !children.keys.contains(word[0]) {
            children[word[0]] = Trie(parent: self, prefix: word[0])
        }

        children[word[0]]?.insert(String(word.dropFirst()))
    }
    
    func getChild(for prefix: String) -> Trie? {
        if prefix.count == 0 {
            return self
        }
        
        if !children.keys.contains(prefix[0]) {
            return nil
        }
        
        return children[prefix[0]]?.getChild(for: String(prefix.dropFirst()))
    }
    
    func contains(_ word: String) -> Bool {
        let wordTrie = getChild(for: word)
        return wordTrie?.isValid ?? false
    }
    
}

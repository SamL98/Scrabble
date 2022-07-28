//
//  ScrabbleDictionary.swift
//  Scrabble
//
//  Created by Sam Lerner on 4/21/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class ScrabbleDictionary: NSObject {
    
    static let shared = ScrabbleDictionary()
    
    var trie: Trie
    
    override init() {
        let words = (try! String(contentsOfFile: Bundle.main.path(forResource: "dictionary", ofType: "txt")!)).components(separatedBy: "\n")
        
        self.trie = Trie()
        
        for word in words {
            self.trie.insert(word)
        }
        
        super.init()
    }
    
    func contains(_ word: String) -> Bool {
        return trie.contains(word)
    }
    
    func _getWordsFromLetters(_ letters: [Character], constraints: [(Character?, Bool)], currTrie: Trie) -> [String] {
        var words: [String] = [],
            constraintsCpy = constraints,
            currTrieCpy = currTrie
        
        while constraintsCpy.count > 0 && constraintsCpy.first!.0 != nil {
            let (optFixedChar, canEnd) = constraintsCpy.remove(at: 0)
            let fixedChar = optFixedChar!.lowercased().first!
                
            // This means that no word begins with what we have so far + fixedChar.
            // Therefore, this is as far as we can go with this subtree.
            if !currTrieCpy.children.keys.contains(fixedChar) {
                return words
            }
            
            // Traverse the trie.
            currTrieCpy = currTrieCpy.children[fixedChar]!
            
            if canEnd && (currTrieCpy.isValid || currTrieCpy.isTerminal) {
                words.append(currTrieCpy.word.uppercased())
            }
        }
        
        if constraintsCpy.count > 0 {
            // In this case, the constraint is a slot, so we want to recurse on all valid letters we have left.
            // Also keep track of the letters we've already traversed so we don't do any repeats.
            
            let (_, canEnd) = constraintsCpy.remove(at: 0)
            var visitedLetters = Set<Character>()
            
            for (i, letter) in letters.enumerated() {
                let letterLower = letter.lowercased().first!
                
                if !currTrieCpy.children.keys.contains(letterLower) || visitedLetters.contains(letterLower) {
                    continue
                }
                
                visitedLetters.insert(letterLower)
                
                var newLetters = letters
                newLetters.remove(at: i)
                
                let subTrie = currTrieCpy.children[letterLower]!
                
                if canEnd && (subTrie.isValid || subTrie.isTerminal) {
                    words.append(subTrie.word.uppercased())
                }
                
                words.append(contentsOf: _getWordsFromLetters(newLetters, constraints: constraintsCpy, currTrie: subTrie))
            }
        }
        
        return words
    }
    
    func getWordsFromLetters(_ letters: [Character], constraints: [(Character?, Bool)]) -> [String] {
        // Here we have a sequence of fixed letters and slots for rack letters, e.g.
        //
        //      | b | a | r | x | e | x | #
        //
        // Say we have the letters { n, d, r, l ... } in the rack.
        // Then our constraints are:
        //                              (0, 'b'), (1, 'a'), (2, 'r'), (4, 'e')
        // while our slots are:
        //                              3, 5
        //
        // We can not use all of the constraints iff the slots we use are not
        // contiguous with the constraints.
        //
        // Therefore, I represent the combination of constraints and slots as:
        //                              (0, 'b', F), (1, 'a', F), (2, 'r', T),
        //                              (3, x, F), (4, 'e', T), (5, x, T)
        //
        // The third element in these tuples is now a boolean representing whether or not
        // the word can end at the index of the constraint.
        //
        // Since both the constraints and slots are now aggregated into the same list,
        // we can get rid of the index element of the tuple.
        
        return _getWordsFromLetters(letters, constraints: constraints, currTrie: trie)
    }

}

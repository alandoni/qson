//
//  StringExtension.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 01/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    
    func firstIndexOfChar(char : Character) -> Int {
        var index = -1
        for c in self {
            index++
            if c == char {
                return index
            }
        }
        index = -1
        return index
    }
    
    func indexOf(char : Character, after: Int) -> Int {
        var index = after
        for c in self {
            if c == char {
                return index
            }
            index++
        }
        index = -1
        return index
    }
    
    func countChar(char : Character) -> Int {
        var amount = 0
        for c in self {
            if c == char {
                amount++
            }
        }
        return amount
    }
}

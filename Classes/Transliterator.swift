//
//  Transliterator.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/12/15.
//
//

import Foundation

public protocol Transliterator {
    static var table: [Character: ArabicCharacter] { get }
}

public extension Transliterator {
    public static func toArabic(string: String, disabledCharacters: [ArabicCharacter] = [.Sukun]) -> String {
        return string.characters.reduce("", combine: { initial, current in
            if let character = self.table[current] where !disabledCharacters.contains(character) {
                return initial + String(character.rawValue)
            } else {
                return initial
            }
        })
    }
    
    public static func toTransliteratedCharacter(arabicCharacter: ArabicCharacter) -> Character {
        for (key, value) in self.table {
            if value == arabicCharacter {
                return key
            }
        }
        
        assertionFailure()
        return "A"
    }
}
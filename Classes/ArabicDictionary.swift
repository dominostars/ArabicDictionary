//
//  Dictionary.swift
//  ArabicDictionary
//
//  Created by Gilad Gurantz on 7/11/15.
//  Copyright (c) 2015 Lazy Arcade. All rights reserved.
//

import Foundation

public struct ArabicDictionary {
    public let stems: [Stem]
    
    public func stemWithLetters(stemLetters: String) -> Stem? {
        return self.stems.filter { $0.letters == stemLetters }.first
    }
    
    init(stems: [Stem]) {
        self.stems = stems
    }
    
    public init?(filePath: String) {
        if let dictionary = loadDictionaryFromFile(filePath) {
            self = dictionary
        } else {
            return nil
        }
    }
}

public struct Stem {
    public let letters: String
    public let lemmas: [Lemma]
}

public struct Lemma {
    public let title: String
    public let words: [Word]
}

public struct Word {
    public let withShortVowels: String
    public let withoutShortVowels: String
    public let morphologicalCategory: String
    public let definition: String
}
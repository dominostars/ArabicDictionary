//
//  BuckwalterParser.swift
//  ArabicDictionary
//
//  Created by Gilad Gurantz on 7/11/15.
//  Copyright (c) 2015 Lazy Arcade. All rights reserved.
//

import Foundation

enum BuckwalterMark: String {
    case Comment = ";"
    case Stem = ";---"
    case Lemma = ";;"
}

enum ParsedString {
    case Comment(String)
    case Stem(String)
    case Lemma(String)
    case Word(withVowels: String, withoutVowels: String, category: String, definition: String)
    case Unknown(String)
    
    init(line: String) {
        let result = line.componentsSeparatedByString(" ")
        let mark = BuckwalterMark(rawValue: result.first ?? "")
        let value = result.count > 1 ? result[1] : ""
        
        if let mark = mark {
            switch mark {
            case .Comment:
                self = .Comment(value)
            case .Stem:
                self = .Stem(value)
            case .Lemma:
                self = .Lemma(value)
            }
        } else {
            let attributes = line.componentsSeparatedByString("\t")
            if attributes.count > 3 {
                self = .Word(
                    withVowels: attributes[0],
                    withoutVowels: attributes[1],
                    category: attributes[2],
                    definition: attributes[3]
                    
                )
            } else {
                self = .Unknown(line)
            }
        }
    }
}

func loadDictionaryFromFileLines(lines: [String]) -> ArabicDictionary {
    var stems = [Stem]()
    var stemLetters = ""
    var lemmas = [Lemma]()
    var lemmaTitle = ""
    var words = [Word]()
    
    let completeLemma: () -> Void = {
        if count(lemmaTitle) > 0 {
            lemmas.append(Lemma(title: lemmaTitle, words: words))
            lemmaTitle = ""
            words = []
        }
    }
    
    for line in lines {
        switch (ParsedString(line: line)) {
        case let .Comment(comment):
            completeLemma()
            break
        case let .Stem(stem):
            if count(stemLetters) > 0 {
                stems.append(Stem(letters: stemLetters, lemmas: lemmas))
                lemmas = []
            }
            stemLetters = stem
            break
        case let .Lemma(lemma):
            completeLemma()
            lemmaTitle = lemma
            break
        case let .Word(withVowels, withoutVowels, category, definition):
            words.append(Word(
                withShortVowels: withVowels,
                withoutShortVowels: withoutVowels,
                morphologicalCategory: category,
                definition: definition))
            break
        case let .Unknown(line):
            break
        }
    }
    
    return ArabicDictionary(stems: stems)
}

func loadDictionaryFromFile(filePath: String) -> ArabicDictionary? {
    NSString(contentsOfFile: filePath, encoding: NSWindowsCP1252StringEncoding, error: nil)
    let file = NSString(contentsOfFile: filePath, encoding: NSWindowsCP1252StringEncoding, error: nil)
    let fileArray = file?.componentsSeparatedByString("\n") as? [String]
    return fileArray.map(loadDictionaryFromFileLines)
}

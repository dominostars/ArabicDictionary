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
        let result = split(line, maxSplit: 1, allowEmptySlices: true, isSeparator: { $0 == " " })
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
            let attributes = split(line, isSeparator: { $0 == "\t" })
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

func loadDictionaryFromStreamReader(streamReader: StreamReader) -> ArabicDictionary {
    var stems = [Stem]()
    var stemLetters = ""
    var lemmas = [Lemma]()
    var lemmaTitle = ""
    var words = [Word]()
    while let line = streamReader.nextLine() {
        switch (ParsedString(line: line)) {
        case let .Comment(comment):
            if count(lemmaTitle) > 0 {
                lemmas.append(Lemma(title: lemmaTitle, words: words))
                lemmaTitle = ""
                words = []
            }
            break
        case let .Stem(stem):
            if count(stemLetters) > 0 {
                stems.append(Stem(letters: stemLetters, lemmas: lemmas))
                lemmas = []
            }
            stemLetters = stem
            break
        case let .Lemma(lemma):
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
    if let streamReader = StreamReader(path: filePath) {
        let dictionary = loadDictionaryFromStreamReader(streamReader)
        streamReader.close()
        return dictionary
    } else {
        return nil
    }
}

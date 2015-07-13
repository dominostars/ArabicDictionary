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
    case Word(withVowels: String, withoutVowels: String, category: String, definition: String, pos: String?)
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
                let definitionComponents = attributes[3].componentsSeparatedByString("     ")
                self = .Word(
                    withVowels: attributes[1],
                    withoutVowels: attributes[0],
                    category: attributes[2],
                    definition: definitionComponents.first ?? attributes[3],
                    pos: definitionComponents.count > 1 ? definitionComponents.last : nil
                )
            } else {
                self = .Unknown(line)
            }
        }
    }
}

let posReplacement: [String: PartOfSpeech] = [
    "ADJ": .Adjective,
    "ADV": .Adverb,
    "ABBREV": .Abbreviation,
    "PREP": .Preposition,
    "NEG_PART": .NegativeParticle,
    "CONJ": .Conjunction,
    "INTERJ": .Interjection,
    "NOUN_PROP": .ProperNoun,
    "FUNC_WORD": .FunctionWord,
    "REL_PRON": .RelativePronoun,
    "DET": .Determiner,
    "DEM_PRON": .DemonstrativePronoun,
    "INTERROG_PART": .InterrogativePronoun,
    "FUT_PART": .FutureParticle,
]

func partOfSpeechFromMorphalogicalCategory(category: String) -> PartOfSpeech? {
    if category == "Nprop" {
        return .ProperNoun
    } else if category.hasPrefix("F") {
        return .FunctionWord
    } else if category.hasPrefix("IV") {
        return .ImperfectVerb
    } else if category.hasPrefix("PV") {
        return .PerfectVerb
    } else if category.hasPrefix("CV") {
        return .ImperativeVerb
    } else if category.hasPrefix("N") {
        return .Noun
    } else {
        return nil
    }
}

func partOfSpeechFromCategory(category: String, posAttribute: String?) -> PartOfSpeech {
    return partOfSpeechFromAttribute(posAttribute) ??
        partOfSpeechFromMorphalogicalCategory(category) ??
        .Unknown
}

func partOfSpeechFromAttribute(posAttribute: String?) -> PartOfSpeech? {
    if
        let posAttribute = posAttribute,
        let slashRange = posAttribute.rangeOfString("/"),
        let endArgumentRange = posAttribute.rangeOfString("</pos>")
    {
        let posRange = Range(start: slashRange.endIndex,
            end: endArgumentRange.startIndex)
        let key = posAttribute.substringWithRange(posRange)
        
        return posReplacement[key]
    } else {
        return nil
    }
}

func loadDictionaryFromFileLines(lines: [String]) -> ArabicDictionary {
    var stems = [Stem]()
    var stemLetters = ""
    var lemmas = [Lemma]()
    var lemmaTitle = ""
    var words = [Word]()
    
    let completeLemma: () -> Void = {
        if lemmaTitle.characters.count > 0 {
            lemmas.append(Lemma(title: lemmaTitle, words: words))
            lemmaTitle = ""
            words = []
        }
    }
    
    for line in lines {
        switch (ParsedString(line: line)) {
        case .Comment(_):
            completeLemma()
            break
        case let .Stem(stem):
            if stemLetters.characters.count > 0 {
                stems.append(Stem(letters: stemLetters, lemmas: lemmas))
                lemmas = []
            }
            stemLetters = stem
            break
        case let .Lemma(lemma):
            completeLemma()
            lemmaTitle = lemma
            break
        case let .Word(withVowels, withoutVowels, category, definition, posAttribute):
            words.append(Word(
                withShortVowels: withVowels,
                withoutShortVowels: withoutVowels,
                morphologicalCategory: category,
                definition: definition,
                partOfSpeech: partOfSpeechFromCategory(category, posAttribute: posAttribute))
            )
            break
        case .Unknown(_):
            break
        }
    }
    
    return ArabicDictionary(stems: stems)
}

func loadDictionaryFromFile(filePath: String) -> ArabicDictionary? {
    do {
        let file = try NSString(contentsOfFile: filePath, encoding:NSWindowsCP1252StringEncoding)
        let fileArray = file.componentsSeparatedByString("\n")
        return loadDictionaryFromFileLines(fileArray)
    } catch {
        return nil
    }
}

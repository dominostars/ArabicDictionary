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
    
    init?(filePath: String) {
        if let dictionary = loadDictionaryFromFile(filePath) {
            self = dictionary
        } else {
            return nil
        }
    }
    
    public init() {
        let bundle = NSBundle(forClass: StreamReader.self)
        let filePath = bundle.pathForResource("dictstems", ofType: nil)
        self = loadDictionaryFromFile(filePath!)!
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
    public let partOfSpeech: PartOfSpeech
}

public enum PartOfSpeech: CustomStringConvertible {
    case Adjective
    case Adverb
    case Abbreviation
    case Preposition
    case NegativeParticle
    case Conjunction
    case Interjection
    case ProperNoun
    case FunctionWord
    case RelativePronoun
    case Determiner
    case InterrogativePronoun
    case DemonstrativePronoun
    case FutureParticle
    case ImperfectVerb
    case PerfectVerb
    case ImperativeVerb
    case Noun
    case Unknown
    
    public var description: String {
        switch self {
        case Adjective: return "Adjective"
        case Adverb: return "Adverb"
        case Abbreviation: return "Abbreviation"
        case Preposition: return "Preposition"
        case NegativeParticle: return "Negative Particle"
        case Conjunction: return "Conjunction"
        case Interjection: return "Interjection"
        case ProperNoun: return "Proper Noun"
        case FunctionWord: return "Function Word"
        case RelativePronoun: return "Relative Pronoun"
        case Determiner: return "Determiner"
        case InterrogativePronoun: return "Interrogative Pronoun"
        case DemonstrativePronoun: return "Demonstrative Pronoun"
        case FutureParticle: return "Future Particle"
        case ImperfectVerb: return "Imperfect Verb"
        case PerfectVerb: return "Perfect Verb"
        case ImperativeVerb: return "Imperative Verb"
        case Noun: return "Noun"
        case Unknown: return "?"
        }
    }
}

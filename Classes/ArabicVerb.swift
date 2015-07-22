//
//  ArabicVerb.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/%@8/%@5.
//
//

import Foundation

public extension ArabicDictionary {
    public var verbCollections: [ArabicVerbCollection] {
        return self.stems.mapFilterNil{ $0.verbCollection }
    }
}

public extension Stem {
    public var verbCollection: ArabicVerbCollection? {
        let verbs = self.lemmas.mapFilterNil{ $0.verbAssumingRootLetters(self.letters) }
        if !verbs.isEmpty {
            return ArabicVerbCollection(stemLetters: self.letters, verbs: verbs)
        } else {
            return nil
        }
    }
}

public extension Lemma {
    public func verbAssumingRootLetters(rootLetters: String) -> ArabicVerb? {
        var perfect: String?
        var imperfect: String?
        var definition: String?
        
        for word in self.words {
            switch word.partOfSpeech {
            case .PerfectVerb:
                if (perfect == nil) {
                    perfect = word.withShortVowels
                    definition = word.definition
                }
                
            case .ImperfectVerb:
                imperfect = word.withShortVowels
                
            default:
                break
            }
        }
        
        if let
            perfect = perfect,
            imperfect = imperfect,
            definition = definition,
            form = ArabicVerbForm(rootLetters: rootLetters, perfectVerbConstruction: perfect)
        {
            return ArabicVerb(form: form, perfect: perfect, imperfect: imperfect, definition: definition)
        } else {
            return nil
        }
    }
}


public struct ArabicVerbCollection {
    public let stemLetters: String
    public let verbs: [ArabicVerb]
    
    public func verbWithForm(form: ArabicVerbForm) -> ArabicVerb? {
        return self.verbs.filter{ $0.form == form }.first
    }
}

public struct ArabicVerb {
    public let form: ArabicVerbForm
    public let perfect: String
    public let imperfect: String
    public let definition: String
    
    public var perfectInHeConstruction: String {
        return BuckwalterTransliterator.toArabic("\(self.perfect)a")
    }
}

extension String {
    func locationOfString(inputString: String) -> Int {
        if let range = self.rangeOfString(inputString) {
            return distance(self.startIndex, range.startIndex)
        } else {
            return NSNotFound
        }
    }
}

public enum ArabicVerbForm: Int {
    case I = 1
    case II = 2
    case III = 3
    case IV = 4
    case V = 5
    case VI = 6
    case VII = 7
    case VIII = 8
    case IX = 9
    case X = 10
    
    static let twoRootLetterFormMappings: [String: ArabicVerbForm] = [
        "%@A%@": .I,
        ">a%@A%@": .IV,
        "{ino%@A%@": .VII,
        "{i%@otA%@": .VIII,
        "{isota%@A%@": .X,
    ]
    
    static let threeRootLetterFormMappings: [String: ArabicVerbForm] = [
        "%@a%@a%@": .I,
        "%@a%@i%@": .I,
        "%@a%@u%@": .I,
        "%@a%@~a%@": .II,
        "%@A%@a%@": .III,
        ">a%@o%@a%@": .IV,
        "ta%@a%@~a%@": .V,
        "ta%@A%@a%@": .VI,
        "{ino%@a%@a%@": .VII,
        "{i%@ota%@a%@": .VIII,
        "{i%@o%@a%@~": .IX,
        "{isota%@o%@a%@": .X,
    ]
    
    static var transliteratedVowels: [Character] = {
        let vowels = [
            ArabicCharacter.Alef,
            ArabicCharacter.Fatha,
            ArabicCharacter.Yeh,
            ArabicCharacter.Kasra,
            ArabicCharacter.Waw,
            ArabicCharacter.Damma,
            ArabicCharacter.Shadda,
            ArabicCharacter.Sukun,
        ]
        
        return vowels.map(BuckwalterTransliterator.toTransliteratedCharacter)
    }()
    
    static func possibleFormsFromRootLetters(rootLetters: String) -> [String] {
        return []
    }
    
    init?(rootLetters: String, perfectVerbConstruction: String) {
        if rootLetters.characters.count != 3 {
            return nil
        }
        
        let wordLength = perfectVerbConstruction.characters.count
        if wordLength == 5 || (wordLength == 3 && perfectVerbConstruction.rangeOfString("A") != nil) {
            self = .I
        } else if wordLength == 6 && perfectVerbConstruction.locationOfString("~") == 3 {
            self = .II
        } else if wordLength == 6 && perfectVerbConstruction.locationOfString("A") == 1 {
            self = .III
        } else if perfectVerbConstruction.hasPrefix("ta") {
            if perfectVerbConstruction.locationOfString("~") == 5 {
                self = .V
            } else if perfectVerbConstruction.locationOfString("A") == 3 ||
                perfectVerbConstruction.locationOfString("|") == 2 {
                self = .VI
            } else {
                return nil
            }
        } else if perfectVerbConstruction.hasPrefix("{isota") {
            self = .X
        } else if perfectVerbConstruction.hasPrefix("{ino") {
            self = .VII
        } else if perfectVerbConstruction.hasPrefix("{i") {
            if perfectVerbConstruction[advance(perfectVerbConstruction.endIndex, -1)] == "~" {
                self = .IX
            } else {
                self = .VIII
            }
        } else if perfectVerbConstruction.hasPrefix(">a") &&
            (perfectVerbConstruction.locationOfString("o") == 3 ||
                perfectVerbConstruction.locationOfString("A") == 3) {
            self = .IV
        } else {
            return nil
        }
        
    }
    
    public var stringValue: String {
        switch self {
        case .I: return "I"
        case .II:  return "II"
        case .III:  return "III"
        case .IV:  return "IV"
        case .V:  return "V"
        case .VI:  return "VI"
        case .VII:  return "VII"
        case .VIII:  return "VIII"
        case .IX:  return "IX"
        case .X:  return "X"
        }
    }
}

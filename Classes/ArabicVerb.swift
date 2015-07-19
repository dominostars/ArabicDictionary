//
//  ArabicVerb.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/18/15.
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
        let verbs = self.lemmas.mapFilterNil{ $0.verb }
        if !verbs.isEmpty {
            return ArabicVerbCollection(stemLetters: self.letters, verbs: verbs)
        } else {
            return nil
        }
    }
}

public extension Lemma {
    public var verb: ArabicVerb? {
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
            form = ArabicVerbForm(perfectVerbConstruction: perfect)
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
        return "\(self.perfect)a"
    }
}

public enum ArabicVerbForm {
    case I
    case II
    case III
    case IV
    case V
    case VI
    case VII
    case VIII
    case IX
    case X
    
    /*
    ;--- ktb
    ;; katab-u_1
    ktb	katab	PV	write
    ktb	kotub	IV	write
    ktb	kutib	PV_Pass	be written;be fated;be destined
    ktb	kotab	IV_Pass_yu	be written;be fated;be destined
    ;; kAtab_1
    kAtb	kAtab	PV	correspond with
    */
    
    init?(perfectVerbConstruction: String) {
        let formMappings: [String: ArabicVerbForm] = [
            "1a2a3": .I,
            "1a2i3": .I,
            "1a2u3": .I,
            "1A2": .I,
            "1A2a3": .III,
        ]
        
        let vowels = [
            ArabicCharacter.Alef,
            ArabicCharacter.Fatha,
            ArabicCharacter.Yeh,
            ArabicCharacter.Kasra,
            ArabicCharacter.Waw,
            ArabicCharacter.Damma,
            ArabicCharacter.Shadda,
        ]
        
        let transliteratedVowels = vowels.map(BuckwalterTransliterator.toTransliteratedCharacter)
        var rootLetterIndex = 1
        let converted: [Character] = perfectVerbConstruction.characters.map { character in
            if transliteratedVowels.contains({ $0 == character }) {
                return character
            } else {
                return Character(String(rootLetterIndex++))
            }
        }
        
        if let form = formMappings[String(converted)]{
            self = form
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

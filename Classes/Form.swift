//
//  Form.swift
//  Pods
//
//  Created by Gilad Gurantz on 8/1/15.
//
//

import Foundation

public enum Form {
    private static let mapping: [Form: [String]] = [
        .VerbFormI: ["1a2a3", "1a2i3", "1a2u3"],
        .VerbFormII: ["1a2~a3"],
        .VerbFormIII: ["1A2a3"],
        .CaCiiC: ["1a2y3"],
        .CaaCiC: ["1A2i3"],
        .maCCuuC: ["ma12w3"]
    ]

    case VerbFormI
    case VerbFormII
    case VerbFormIII
    case CaCiiC
    case CaaCiC
    case maCCuuC

    case maCCaC
    case CuCuuC
    case CiCaaCah
    case taCaaCuC
    case CaC_aaC
    case muCaC_iC
    case CuCaCaa_

    public var description: String {
        switch self {
        case .VerbFormI:
            return "Expresses the general verbal meaning of the root"

        case .VerbFormII:
            return "Causative or intensive version of the form 1 verb"

        case .VerbFormIII:
            return "An associative meaning to the form 1 verb; describes someone doing the act in question" +
            "to or with someone else"

        case .CaCiiC:
            return "Common adjective pattern"

        case .CaaCiC:
            return "Expresses the idea of someone or something doing or carrying out the root meaning."

        case .maCCuuC:
            return "Expresses something or someone to which an action has been done, called a passive participle in English"

        case .maCCaC:
            return "Represents a place where the action of the root takes place"

        case .CuCuuC:
            return "Noun expressing the action of a verb, usually expressed in English by the ending -ing (e.g. do -> doing, think -> thinking. In English it is called the verbal noun. Also the plural of simple nouns whose singular shape is CvCC"

        case .CiCaaCah:
            return "Noun is derived from a word of the CaCiiC shape, which refers to a man. Its meaning is the place in which he operates. Sometimes used for nouns derived from verbs."

        case .taCaaCuC:
            return "Noun that carries the idea of doing something with someone else"

        case .CaC_aaC:
            return "Used for trades"

        case .muCaC_iC:
            return "Indicates the person or thing carrying out the action of Verb form II, known as the active participle."

        case .CuCaCaa_:
            return "Plural of certain male human beings that have the singular shape CaCiiC"
        }
    }

    public init?(stemLetters: String, arabicWordWithVowels: String) {
        let mappedString = Form.mappingFormForStem(stemLetters, arabicWordWithVowels: arabicWordWithVowels)
        for (key, value) in Form.mapping {
            if value.contains(mappedString) {
                self = key
                return
            }
        }

        return nil
    }

    private static func mappingFormForStem(stemLetters: String, arabicWordWithVowels: String) -> String {

        var stemLettersIndex = stemLetters.endIndex.predecessor()
        var indexCount = stemLetters.characters.count as Int
        var returnString = ""
        for character in arabicWordWithVowels.characters.reverse() {

            if indexCount > 0 && character == stemLetters[stemLettersIndex] {
                returnString = "\(String(indexCount))\(returnString)"

                if stemLettersIndex != stemLetters.startIndex {
                    stemLettersIndex = stemLettersIndex.predecessor()
                }
                indexCount--
            } else {
                returnString = "\(character)\(returnString)"
            }
        }

        return returnString
    }
}

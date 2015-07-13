//
//  BuckwalterTransliteration.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/12/15.
//
//

import Foundation

public struct BuckwalterTransliterator {
    public static let table: [Character: Character] = [
        "'": "\u{0621}", // ARABIC LETTER HAMZA
        "|": "\u{0622}", // ARABIC LETTER ALEF WITH MADDA ABOVE
        ">": "\u{0623}", // ARABIC LETTER ALEF WITH HAMZA ABOVE
        "&": "\u{0624}", // ARABIC LETTER WAW WITH HAMZA ABOVE
        "<": "\u{0625}", // ARABIC LETTER ALEF WITH HAMZA BELOW
        "}": "\u{0626}", // ARABIC LETTER YEH WITH HAMZA ABOVE
        "A": "\u{0627}", // ARABIC LETTER ALEF
        "b": "\u{0628}", // ARABIC LETTER BEH
        "p": "\u{0629}", // ARABIC LETTER TEH MARBUTA
        "t": "\u{062A}", // ARABIC LETTER TEH
        "v": "\u{062B}", // ARABIC LETTER THEH
        "j": "\u{062C}", // ARABIC LETTER JEEM
        "H": "\u{062D}", // ARABIC LETTER HAH
        "x": "\u{062E}", // ARABIC LETTER KHAH
        "d": "\u{062F}", // ARABIC LETTER DAL
        "*": "\u{0630}", // ARABIC LETTER THAL
        "r": "\u{0631}", // ARABIC LETTER REH
        "z": "\u{0632}", // ARABIC LETTER ZAIN
        "s": "\u{0633}", // ARABIC LETTER SEEN
        "$": "\u{0634}", // ARABIC LETTER SHEEN
        "S": "\u{0635}", // ARABIC LETTER SAD
        "D": "\u{0636}", // ARABIC LETTER DAD
        "T": "\u{0637}", // ARABIC LETTER TAH
        "Z": "\u{0638}", // ARABIC LETTER ZAH
        "E": "\u{0639}", // ARABIC LETTER AIN
        "g": "\u{063A}", // ARABIC LETTER GHAIN
        "_": "\u{0640}", // ARABIC TATWEEL
        "f": "\u{0641}", // ARABIC LETTER FEH
        "q": "\u{0642}", // ARABIC LETTER QAF
        "k": "\u{0643}", // ARABIC LETTER KAF
        "l": "\u{0644}", // ARABIC LETTER LAM
        "m": "\u{0645}", // ARABIC LETTER MEEM
        "n": "\u{0646}", // ARABIC LETTER NOON
        "h": "\u{0647}", // ARABIC LETTER HEH
        "w": "\u{0648}", // ARABIC LETTER WAW
        "Y": "\u{0649}", // ARABIC LETTER ALEF MAKSURA
        "y": "\u{064A}", // ARABIC LETTER YEH
        "F": "\u{064B}", // ARABIC FATHATAN
        "N": "\u{064C}", // ARABIC DAMMATAN
        "K": "\u{064D}", // ARABIC KASRATAN
        "a": "\u{064E}", // ARABIC FATHA
        "u": "\u{064F}", // ARABIC DAMMA
        "i": "\u{0650}", // ARABIC KASRA
        "~": "\u{0651}", // ARABIC SHADDA
        "o": "\u{0652}", // ARABIC SUKUN
        "`": "\u{0670}", // ARABIC LETTER SUPERSCRIPT ALEF
        "{": "\u{0671}", // ARABIC LETTER ALEF WASLA
        "P": "\u{067E}", // ARABIC LETTER PEH
        "J": "\u{0686}", // ARABIC LETTER TCHEH
        "V": "\u{06A4}", // ARABIC LETTER VEH
        "G": "\u{06AF}", // ARABIC LETTER GAF
    ]
    
    public static func toArabic(string: String) -> String {
        return String(map(string.generate()) {
            self.table[$0]!
        })
    }
}
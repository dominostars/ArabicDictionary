//
//  BuckwalterTransliteration.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/12/15.
//
//

import Foundation

public struct BuckwalterTransliterator: Transliterator {
    public static let table: [Character: ArabicCharacter] = [
        "'": .Hamza,
        "|": .AlefWithMaddaAbove,
        ">": .AlefWithHamzaAbove,
        "&": .WawWithHamzaAbove,
        "<": .AlefWithHamzaBelow,
        "}": .YehWithHamzaAbove,
        "A": .Alef,
        "b": .Beh,
        "p": .TehMarbuta,
        "t": .Teh,
        "v": .Theh,
        "j": .Jeem,
        "H": .Hah,
        "x": .Khah,
        "d": .Dal,
        "*": .Thal,
        "r": .Reh,
        "z": .Zain,
        "s": .Seen,
        "$": .Sheen,
        "S": .Sad,
        "D": .Dad,
        "T": .Tah,
        "Z": .Zah,
        "E": .Ain,
        "g": .Ghain,
        "_": .Tatweel,
        "f": .Feh,
        "q": .Qaf,
        "k": .Kaf,
        "l": .Lam,
        "m": .Meem,
        "n": .Noon,
        "h": .Heh,
        "w": .Waw,
        "Y": .AlefMaksura,
        "y": .Yeh,
        "F": .Fathatan,
        "N": .Dammatan,
        "K": .Kasratan,
        "a": .Fatha,
        "u": .Damma,
        "i": .Kasra,
        "~": .Shadda,
        "o": .Sukun,
        "`": .SuperscriptAlef,
        "{": .AlefWasla,
        "P": .Peh,
        "J": .Tcheh,
        "V": .Veh,
        "G": .Gaf,
    ]
}
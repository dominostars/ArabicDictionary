//
//  Letter.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/12/15.
//
//

import Foundation

public enum ArabicCharacter: Character {
    
    // Core alphabet
    case Alef = "\u{0627}"  // ا
    case Beh = "\u{0628}"   // ب
    case Teh = "\u{062A}"   // ت
    case Theh = "\u{062B}"  // ث
    case Jeem = "\u{062C}"  // ج
    case Hah = "\u{062D}"   // ح
    case Khah = "\u{062E}"  // خ
    case Dal = "\u{062F}"   // د
    case Thal = "\u{0630}"  // ذ
    case Reh = "\u{0631}"   // ر
    case Zain = "\u{0632}"  // ز
    case Seen = "\u{0633}"  // س
    case Sheen = "\u{0634}" // ش
    case Sad = "\u{0635}"   // ص
    case Dad = "\u{0636}"   // ض
    case Tah = "\u{0637}"   // ط
    case Zah = "\u{0638}"   // ظ
    case Ain = "\u{0639}"   // ع
    case Ghain = "\u{063A}" // غ
    case Feh = "\u{0641}"   // ف
    case Qaf = "\u{0642}"   // ق
    case Kaf = "\u{0643}"   // ك
    case Lam = "\u{0644}"   // ل
    case Meem = "\u{0645}"  // م
    case Noon = "\u{0646}"  // ن
    case Heh = "\u{0647}"   // ه
    case Waw = "\u{0648}"   // و
    case Yeh = "\u{064A}"   // ي
    
    // Hamza
    case Hamza = "\u{0621}"                 // ء
    case AlefWithMaddaAbove = "\u{0622}"    // آ
    case AlefWithHamzaAbove = "\u{0623}"    // أ
    case WawWithHamzaAbove = "\u{0624}"     // ؤ
    case AlefWithHamzaBelow = "\u{0625}"    // إ
    case YehWithHamzaAbove = "\u{0626}"     // ئ
    
    // Other special characters
    case TehMarbuta = "\u{0629}"            // ة
    case AlefMaksura = "\u{0649}"           // ى
    
    // Accents
    case Fathatan = "\u{064B}"              // ً
    case Dammatan = "\u{064C}"              // ٌ
    case Kasratan = "\u{064D}"              // ٍ
    case Fatha = "\u{064E}"                 // َ
    case Damma = "\u{064F}"                 // ُ
    case Kasra = "\u{0650}"                 // ِ
    case Shadda = "\u{0651}"                // ّ
    case Sukun = "\u{0652}"                 // ْ
    case Tatweel = "\u{0640}"               // ـ
    
    // Non-standard Arabic
    case SuperscriptAlef = "\u{0670}"       // ٰ
    case AlefWasla = "\u{0671}"             // ٱ
    case Peh = "\u{067E}"                   // پ
    case Tcheh = "\u{0686}"                 // چ
    case Veh = "\u{06A4}"                   // ڤ
    case Gaf = "\u{06AF}"                   // گ
}

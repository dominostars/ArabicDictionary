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
}

enum MorphologicalCategory: String {
    /*
    -------------------
    FUNCTION WORD STEMS
    
    Function words (i.e., "particles", pronouns, and other words that do not function as Nouns or Verbs) fall into two broad categories: those that accept only the prefix conjunctions wa- and fa- (e.g., wa-huwa, fa-min) and those that accept these conjunctions as well as the prepositions bi- and li- (e.g., wa-li->ay~, fa-bi-man). The mnemonic morphological categories we use to distinguish these two types of functions words are, respectively, "FW-Wa" and "FW-WaBi". A third category, "FW", is used for words that take no prefix at all, such as interjections and abbreviations, but also proper names that occur as the second word in multi-word names (e.g. laHom, the 2nd word in "bayot laHom).
    
    Note that the prefixes bi- and li- attach directly to pronoun suffixes -hu -hum, etc., with no intervening stem. These combinations are entered directly as Function Words in the lexicon of stems. Examples:
    
    bh	bihi	FW-Wa	with/by + it/him           <pos>bi/PREP+hi/PRON_3MS</pos>
    bhmA	bihimA	FW-Wa	with/by + them both        <pos>bi/PREP+himA/PRON_3D</pos>
    bhA	bihA	FW-Wa	with/by + it/them/her      <pos>bi/PREP+hA/PRON_3FS</pos>
    bhm	bihim	FW-Wa	with/by + them [masc.pl.]  <pos>bi/PREP+him/PRON_3MP</pos>
    
    lh	lahu	FW-Wa	to/for + it/him (it/he has)                   <pos>la/PREP+hu/PRON_3MS</pos>
    lhmA	lahumA	FW-Wa	to/for + them both (they both have)           <pos>la/PREP+humA/PRON_3D</pos>
    lhA	lahA	FW-Wa	to/for + it/them/her (it/she has, they have)  <pos>la/PREP+hA/PRON_3FS</pos>
    lhm	lahum	FW-Wa	to/for + them [masc.pl.] (they have)          <pos>la/PREP+hum/PRON_3MP</pos>
    */
    case FW = "FW"
    case FW_Wa = "FW-Wa"
    
    /*
    ----------
    NOUN STEMS
    
    The morphological categories assigned to noun stems are mnemonic notation representing the inflectional suffixation properties of the noun stem in question. "Ndu", for example, means that the noun stem takes the dual suffixes -Ani and -ayni, and "NAt", means that it takes the plural suffix -At. The following is a summary of the main noun stem morphological categories.
    */
    
    /*
    "Nall" denotes nouns whose base form is masculine singular, and that allow for all possible inflectional suffixes. Typically these are nisbah adjectives modifying rational entities (e.g., lugawiy~, lubonAniy~), and active participles of all triliteral and quadriliteral forms (occasionally excluding triliteral Form I) provided that these denote rational entities (e.g., murAsil, qAdir, mutarojim, muToma}in~).
    
    Summary: Noun stems with inflectional category "Nall" can take all noun inflectional suffixes:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    masc.pl. (-uwna, -iyna, -uw, -iy)
    fem.sg. (-ap)
    fem.du. (-atAni,-atayoni,-atA,-atayo)
    fem.pl. (-At)
    */
    case Nall = "Nall"
    
    /*
    "N/ap" denotes nouns whose base form is masculine singular, and that allow for all possible inflectional suffixes except for the masculine plural. This suffixation category is typical of nouns having the triliteral pattern faEiyl, which often is used attributively and applied to rational entities, and normally take a broken plural for the masculine and a feminine plural for the feminine. Examples: jadiyd (pl. judud, jadiyd-At), kariym (pl. kirAm, kariym-At).
    
    Summary: Noun stems with inflectional category "N/ap" can take all possible inflectional suffixes except for the masculine plural:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    fem.sg. (-ap)
    fem.du. (-atAni,-atayoni,-atA,-atayo)
    fem.pl. (-At)
    */
    case N1ap = "N/ap"
    
    /*
    "N-ap" denotes nouns whose base form is masculine singular, and that allow for all possible inflectional suffixes except for the masculine plural and the feminine plural. Typically these are nisbah adjectives--or nouns functioning as adjectives--modifying non-rational entities. Examples: mufahoras, taEoliymiy~.
    
    Summary: Noun stems with inflectional category "N-ap" can take all possible inflectional suffixes except for the masculine plural and the feminine plural:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    fem.sg. (-ap)
    fem.du. (-atAni,-atayoni,-atA,-atayo)
    */
    case N_ap = "N-ap"
    
    /*
    "NduAt" denotes nouns that are masculine singular in their base form, and that inflect for the dual masculine and feminine plural. Typically these are the countable verbal nouns of triliteral and quadriliteral derived forms. Examples: taloxiyS, liqA', AimotiHAn.
    
    Summary: Noun stems with inflectional category "NduAt" take only the inflectional suffixes of the masculine dual and the feminine plural:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    fem.pl. (-At)
    */
    case NduAt = "NduAt"
    
    /*
    "Ndu" denotes nouns whose base form is masculine singular, and that allow inflection for the dual. Nouns of this inflectional category take broken plurals. Examples: masokan, lafoZ, kitAb.
    
    Summary: Noun stems with inflectional category "Ndu" take only the inflectional suffixes of the masculine dual:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    */
    case Ndu = "Ndu"
    
    /*
    "N/At" denotes nouns that are masculine singular in their base form, and that inflect for the feminine plural but not for the masculine dual. Typically these are the "semi-countable" verbal nouns of triliteral and quadriliteral derived forms, and the so-called "plural-of-plural" forms. Examples: taSar~uf, taEAwun, buHuwv. (Note: by "semi-countable" we mean that their use as countable nouns is unattested and improbable.)
    
    Summary: Noun stems with inflectional category "N/At" take only the inflectional suffixes of the feminine plural:
    fem.pl. (-At)
    */
    case N1At = "N/At"
    
    /*
    "N" denotes nouns that do not inflect for number. Typically these are verbal nouns of verb form I (e.g., tarok, HuSuwl) and triptote broken plurals (e.g., suk~An, $uEuwb).
    
    Summary: Noun stems with inflectional category "N" do not take inflectional suffixes.
    */
    case N = "N"
    
    /*
    "NapAt" denotes nouns whose base form is feminine singular, and that allow inflection for the feminine dual and the feminine plural. Nouns of this inflectional category rarely take broken plurals. Examples: laHoZ-ap, >usor-ap, mubAdal-ap.
    
    Summary: Noun stems with inflectional category "NapAt" take only the inflectional suffixes of the feminine singular, dual and plural:
    fem.sg. (-ap)
    fem.du. (-atAni,-atayoni,-atA,-atayo)
    fem.pl. (-At)
    */
    case NapAt = "NapAt"
    
    /*
    "Napdu" denotes nouns whose base form is feminine singular, and that allow inflection for the dual, but not the feminine plural. Nouns of this inflectional category take broken plurals. Examples: <ujor-ap, maso>al-ap, gurof-ap.
    
    Summary: Noun stems with inflectional category "Napdu" take only the inflectional suffixes of the feminine singular and plural:
    fem.sg. (-ap)
    fem.pl. (-At)
    */
    case Napdu = "Napdu"
    
    /*
    "Nap" denotes nouns whose base form is feminine singular, and do not inflect for number. Typically they are verbal nouns of triliteral and quadriliteral verb form I (e.g., kitAb-ap, maEorif-ap, sayoTar-ap) and triptote broken plurals (e.g., >alobis-ap, EamAliq-ap).
    
    Summary: Noun stems with inflectional category "Nap" take only the inflectional suffixes of the feminine singular:
    fem.sg. (-ap)
    */
    case Nap = "Nap"
    
    /*
    "NAt" denotes nouns that are feminine plural in their base or dictionary citation form, and whose singular form is unattested. Examples: mutaTal~ab-At, muxAbar-At.
    
    Summary: Noun stems with inflectional category "NAt" take only the inflectional suffixes of the feminine plural:
    fem.pl. (-At)
    */
    case NAt = "NAt"
    
    /*
    "NF" denotes nouns that acquire an independent lexical meaning when they function as adverbs or interjections by means of the indefinite accusative case marker suffix -AF (fatoHatAn on an alif chair).
    
    Summary: Noun stems with inflectional category "NF" take only the indefinite accusative case marker suffix:
    indef.acc. (-AF)
    */
    case NF = "NF"
    
    /*
    "Npair" denotes nouns that acquire an independent lexical meaning when inflected for the dual. Hence, they could be said to be dual in their base form. Examples: Al-wAlid-An, Al-rAfid-An.
    
    Summary: Noun stems with inflectional category "Npair" take only the inflectional suffixes of the masculine dual:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    */
    case Npair = "Npair"
    
    /*
    "Nel" denotes the masculine elative noun, which typically inflects for the dual only. Examples: >akobar, >ajad~. (Note: all broken plurals are provided via their own entries in the lexicon.)
    
    Summary: Noun stems with inflectional category "Nel" take only the inflectional suffixes of the masculine dual:
    masc.du. (-Ani, -ayoni,-A, -ayo)
    */
    case Nel = "Nel"
    
    /*
    "Ndip" denotes diptote nouns. Noun stems associated with this suffixation category include mostly broken plural patterns, such as the triliteral patterns mafAEil (e.g., majAlis) and faEA}il (e.g., qabA}il), and the quadriliteral patterns faEAliyl (e.g., jamAhiyr) and faEAlil (e.g., jamArik).
    
    Summary: Noun stems with inflectional category "Ndip" do not take inflectional suffixes.
    */
    case Ndip = "Ndip"
    
    /*
    "Nprop" denotes proper names, which typically do not inflect nor take possessive pronoun suffixes (e.g., miSor, $ubAT, muHam~ad, jiyhAn). If the proper noun does have a suffix, the latter is concatenated with the stem in the lexicon entry: e.g., EarafAt, Hamozap, mAjidap, Eaboduh).
    
    Summary: Noun stems with inflectional category "Nprop" do not take inflectional suffixes.
    */
    case Nprop = "Nprop"
    
    /*
    "Numb" denotes the inflectional suffixation characteristics of a limited class of nouns associated exclusively with Arabic numerals 20 through 90 (in increments of 10). Examples: xamos-uwna, sit~-uwna.
    
    Summary: Noun stems with inflectional category "Numb" take two suffixes:
    nom. (-uwna)
    gen./acc. (-iyna)
    */
    case Numb = "Numb"
    
    /*
    -------------------------
    NOUN STEMS: SPECIAL CASES
    
    Noun stems require more detailed morphological categories in two cases:
    
    (1) Noun stems begins with "l" (lam) are compatible with a special subset of prefixes containing the preposition li- and the definite article Al-. These stems take the normal morphological categories outlined above but with an additional mnemonic notation: "N_L", "Ndu_L", "Ndip_L".
    
    (2) Noun stems that end with weak letters hamza or waw/ya' will undergo orthographic change depending on which inflectional suffixes are attached. Each orthographic variant is assigned a morphological category that denotes the set of suffixes allowed for that particular orthographic variant.
    
    ElmA'	EulamA'	N0_Nh	scholars;scientists
    ElmA&	EulamA&	Nh	scholars;scientists
    ElmA}	EulamA}	Nhy	scholars;scientists
    
    The list of actual suffixes that are compatible with each variant form can be obtained by extracting the suffix categories that are compatible with each stem category (in "tableBC") and looking up those suffix categories in the lexicon of suffixes. For example, a search for "N0_Nh" in "tableBC" extracts:
    
    N0_Nh Suff-0
    N0_Nh NSuff-u
    N0_Nh NSuff-a
    N0_Nh NSuff-i
    N0_Nh NSuff-h
    
    and a search for "Suff-0", "NSuff-u", "NSuff-a", etc. in "dictSuffixes" extracts:
    
    Suff-0
    ;	u	NSuff-u	[def.nom.]     <pos>+u/CASE_DEF_NOM</pos>
    ;	a	NSuff-a	[def.acc.]     <pos>+a/CASE_DEF_ACC</pos>
    ;	i	NSuff-i	[def.gen.]     <pos>+i/CASE_DEF_GEN</pos>
    h	h	NSuff-h	its/his          <pos>+hu/POSS_PRON_3MS</pos>
    hmA	hmA	NSuff-h	their            <pos>+humA/POSS_PRON_3D</pos>
    hm	hm	NSuff-h	their            <pos>+hum/POSS_PRON_3MP</pos>
    hA	hA	NSuff-h	its/their/her    <pos>+hA/POSS_PRON_3FS</pos>
    hn	hn~a	NSuff-h	their            <pos>+hun~a/POSS_PRON_3FP</pos>
    k	ka	NSuff-h	your             <pos>+ka/POSS_PRON_2MS</pos>
    k	ki	NSuff-h	your             <pos>+ki/POSS_PRON_2FS</pos>
    kmA	kumA	NSuff-h	your             <pos>+kumA/POSS_PRON_2D</pos>
    km	kum	NSuff-h	your             <pos>+kum/POSS_PRON_2MP</pos>
    kn	kun~a	NSuff-h	your             <pos>+kun~a/POSS_PRON_2FP</pos>
    nA	nA	NSuff-h	our              <pos>+nA/POSS_PRON_1P</pos>
    
    which means that the stem form EulamA' is compatible with the null suffix, case-ending suffixes -u, -i, -a (which are commented out in the lexicon of suffixes), and the full set of possessive pronoun suffixes, excluding the 1st pers.sg. -iy.
    */
    
    /*
    (1) Noun stems begins with "l" (lam) are compatible with a special subset of prefixes containing the preposition li- and the definite article Al-. These stems take the normal morphological categories outlined above but with an additional mnemonic notation: "N_L", "Ndu_L", "Ndip_L".
    */
    case N0 = "N0"
    case N0F = "N0F"
    case L = "L"
    case Nh = "Nh"
    case Nayn = "Nayn"
    case NK = "
    NK
    NAn
    
    /*
    ----------
    VERB STEMS
    
    Three morphological categories -- "PV" (Perfect Verb), "IV" (Imperfect Verb), and "CV" (Imperative, or Command Verb) -- denote regular verb stems, which are defined as those stems which undergo no orthographic variation and which combine with the full set of unmodified verbal prefixes and suffixes. The best example is the proverbial kataba: the "PV" stem combines with all PV suffixes (katab- -a, -A, -uwA, etc.) and the "IV" stem combines with all Imperfect Verbs prefixes and suffixes (ya-, ta-, na-, >a- -kotub- -Ani, -uwna, etc.). The stems for imperative verb forms have been entered only for a few imperatives in common use, such as xu* (xu*- -o, -iy, -uwA).
    */
    
    case PV = "PV"
    
    case IV = "IV"
    
    case CV = "CV"
    
    /*
    Verbs that do not take direct object pronoun suffixes are assigned PV and IV morphological categories with the text "_intr" added. Examples: "PV_intr", "IV_intr", and "CV_intr".
    */
    case Intr = "intr"
    
    /*
    Imperfect verbs that take prefixes with the short vowel "u" (yu-, tu-, nu-, >u-) for the active voice are assigned IV morphological categories with the text "_yu" added. Examples: "IV_yu" and "IV_intr_yu".
    */
    case Yu = "yu"
    
    /*
    Verb stems for the passive voice are assigned PV and IV morphological categories with the text "_Pass" added. Examples: "PV_Pass" and "IV_Pass_yu".
    */
    case Passive = "Pass"
    
    /*
    -------------------------
    VERB STEMS: SPECIAL CASES
    
    Perfect Verb stems require more detailed morphological categories in several cases:
    */

    /*
    PV stems ending in "n" (e.g. barohan-, {ixotazan-) combine with a special set of PV suffixes that begin with assimilated "n": barohan-~a (i.e., barohan-na), and barohan-~A (i.e., barohan-nA). The mnemonic notation for these stems is "PV-n".
    */
    case PV_n = "PV-n"
    case IV_n = "IV-n"
    
    /*
    PV stems ending in "t" (e.g. vab~at-, {ilotafat-) combine with a special set of PV suffixes that begin with assimilated "t": vab~at-~u (i.e., vab~at-tu), vab~at-~um (i.e., vab~at-tum), etc. The mnemonic notation for these stems is "PV-t".
    */
    case PV_t = "PV-t"
    
    /*
    Certain verb forms based on hollow and doubled roots have two PV stems: one that combines with PV suffixes that begin with a consonant ("PV_C") and one that combines with PV suffixes that begin with a vowel ("PV_V"). Examples of "PV_V: qAl-/>aHab~- -a, -at, -atA, -A, and -uwA. Examples of "PV_C: qul-/>aHabab- -tu/a/i, -tum, -tumA, tun~a, -na, and -nA.
    
    Stems that would be assigned the "PV_C" category but happen to end in "t" or "n" are assigned categories "PV_Ct" and "PV_Cn" instead. Examples include mut-~u (i.e., mut-tu, from mAt/yamuwt), and janan-~A (i.e., janan-nA).
    */
    case V = "V"
    case C = "C"
    case Ct = "Ct"
    case Cn = "Cn"
    
    /*
    PV stems ending in ">" (hamza on alif) combine with a reduced set of PV suffixes, and undergo orthographic change for the masc.du. and masc.pl. Note the dictionary entries for bada>-.
    
    bd>	bada>	PV->	start;begin
    bd|	bada|	PV-|	start;begin
    bd&	bada&	PV_w	start;begin
    
    The stem with category "PV->" combines with PV suffixes -a, -at, -na, -nA, -tu/a/i, and -uwA. (Purists will consider the spelling of bada>-uwA to be incorrect, but because it occurs frequently we consider it a valid orthographic variant.) The stem with category "PV-|" combines with an assimilated version of the masc.du. suffix.: bada|-(null) (i.e., bada>-A). The stem with category "PV-&" combines with the masc.pl. suffix.: bada&-uwA.
    */
    case PV_AlefHamzaAbove = "PV->"
    case PV_AlefMaddaAbove = "PV-|"
    case PV_WawHamzaAbove = "PV-&"
    case PV_w = "PV-w"
    
    case IV_AlefMaddaAbove = "IV-|"
    
    case No_Pref_A = "no-Pref-A"
    
    case Unknown = ""
}

/*

Perfect Verb stems for finally-weak verbs undergo orthographic changes, as seen in the following examples taken directly from the lexicon:

bnY	banaY	PV_0	build;erect
bnA	banA	PV_h	build;erect
bny	banay	PV_Atn	build;erect
bn	ban	PV_ttAw	build;erect

dEA	daEA	PV_0h	call;invite
dEw	daEaw	PV_Atn	call;invite
dE	daE	PV_ttAw	call;invite

x$y	xa$iy	PV_no-w	fear;be afraid
x$	xa$	PV_w	fear;be afraid

The morphological categories are represented via mnemonic notation for the various subsets of PV suffixes that are allowed. Stems with category "PV_0", for example, take the PV null suffix. Stems with category "PV_h" take the full set of direct object pronoun suffixs. Stems with category "PV_0h" combine the features of "PV_0" and "PV_h". The details about which PV suffix is compatible with which PV stem can be obtained by searching for the stem category in "tableBC" in order to extract the related suffix categories, and then searching for these suffix categories in the lexicon of suffixes. For example, a search for "PV_no-w" in "tableBC" extracts:

PV_no-w PVSuff-a
PV_no-w PVSuff-ah
PV_no-w PVSuff-A
PV_no-w PVSuff-Ah
PV_no-w PVSuff-at
PV_no-w PVSuff-ath
PV_no-w PVSuff-n
PV_no-w PVSuff-nh
PV_no-w PVSuff-t
PV_no-w PVSuff-th

and a search for "PVSuff-a", "PVSuff-ah", "PVSuff-A", etc. in "dictSuffixes" will extract the actual suffixes.

Imperfect Verb stems require require more detailed morphological categories (other than "IV") in several cases:

IV stems ending in "n" (e.g. barohan-, {ixotazan-) combine with a special set of IV suffixes that begin with assimilated "n": yu-barohin-~a (i.e., yu-barohin-na). The mnemonic notation for these stems is "IV-n".

IV stems for finally-weak verbs undergo orthographic changes, as seen in the following examples taken directly from the lexicon:

bny	boniy	IV_0hAnn	build;erect
bn	bon	IV_0hwnyn	build;erect

dEw	doEuw	IV_0hAnn	call;invite
dE	doE	IV_0hwnyn	call;invite

x$Y	xo$aY	IV_0	fear;be afraid
x$A	xo$A	IV_h	fear;be afraid
x$y	xo$ay	IV_Ann	fear;be afraid
x$	xo$a	IV_0hwnyn	fear;be afraid

The morphological categories denote the various subsets of IV suffixes that are allowed. Stems with category "IV_0", for example, take the IV null suffix. Stems with category "IV_h" take the full set of direct object pronoun suffixs. Stems with category "IV_0hAnn" combine the features of "IV_0" and "IV_h" and take the dual suffix (e.g. ya-boniy-Ani, ya-doEuw-Ani) and the fem.pl suffix (e.g. ya-boniy-na, ya-doEuw-na). The details about which IV suffix is compatible with which IV stem can be obtained by searching for the stem category in "tableBC" in order to extract the related suffix categories, and then searching for these suffix categories in the lexicon of suffixes. For example, a search for "IV_Ann" in "tableBC" extracts:

IV_Ann IVSuff-A
IV_Ann IVSuff-Ah
IV_Ann IVSuff-Ak
IV_Ann IVSuff-An
IV_Ann IVSuff-Anh
IV_Ann IVSuff-Ank
IV_Ann IVSuff-n
IV_Ann IVSuff-nh
IV_Ann IVSuff-nk

and a search for "IVSuff-A", "IVSuff-Ah", "IVSuff-Ak", etc. in "dictSuffixes" will extract the actual suffixes.
*/

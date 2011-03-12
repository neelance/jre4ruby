require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
module Java::Util
  module LocaleISODataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  class LocaleISOData 
    include_class_members LocaleISODataImports
    
    class_module.module_eval {
      # The 2- and 3-letter ISO 639 language codes.
      # Afar
      # Abkhazian
      # Avestan
      # Afrikaans
      # Akan
      # Amharic
      # Aragonese
      # Arabic
      # Assamese
      # Avaric
      # Aymara
      # Azerbaijani
      # Bashkir
      # Belarusian
      # Bulgarian
      # Bihari
      # Bislama
      # Bambara
      # Bengali
      # Tibetan
      # Breton
      # Bosnian
      # Catalan
      # Chechen
      # Chamorro
      # Corsican
      # Cree
      # Czech
      # Church Slavic
      # Chuvash
      # Welsh
      # Danish
      # German
      # Divehi
      # Dzongkha
      # Ewe
      # Greek
      # English
      # Esperanto
      # Spanish
      # Estonian
      # Basque
      # Persian
      # Fulah
      # Finnish
      # Fijian
      # Faroese
      # French
      # Frisian
      # Irish
      # Scottish Gaelic
      # Gallegan
      # Guarani
      # Gujarati
      # Manx
      # Hausa
      # Hebrew
      # Hindi
      # Hiri Motu
      # Croatian
      # Haitian
      # Hungarian
      # Armenian
      # Herero
      # Interlingua
      # Indonesian
      # Interlingue
      # Igbo
      # Sichuan Yi
      # Inupiaq
      # Indonesian (old)
      # Ido
      # Icelandic
      # Italian
      # Inuktitut
      # Hebrew (old)
      # Japanese
      # Yiddish (old)
      # Javanese
      # Georgian
      # Kongo
      # Kikuyu
      # Kwanyama
      # Kazakh
      # Greenlandic
      # Khmer
      # Kannada
      # Korean
      # Kanuri
      # Kashmiri
      # Kurdish
      # Komi
      # Cornish
      # Kirghiz
      # Latin
      # Luxembourgish
      # Ganda
      # Limburgish
      # Lingala
      # Lao
      # Lithuanian
      # Luba-Katanga
      # Latvian
      # Malagasy
      # Marshallese
      # Maori
      # Macedonian
      # Malayalam
      # Mongolian
      # Moldavian
      # Marathi
      # Malay
      # Maltese
      # Burmese
      # Nauru
      # Norwegian Bokm?l
      # North Ndebele
      # Nepali
      # Ndonga
      # Dutch
      # Norwegian Nynorsk
      # Norwegian
      # South Ndebele
      # Navajo
      # Nyanja
      # Occitan
      # Ojibwa
      # Oromo
      # Oriya
      # Ossetian
      # Panjabi
      # Pali
      # Polish
      # Pushto
      # Portuguese
      # Quechua
      # Raeto-Romance
      # Rundi
      # Romanian
      # Russian
      # Kinyarwanda
      # Sanskrit
      # Sardinian
      # Sindhi
      # Northern Sami
      # Sango
      # Sinhalese
      # Slovak
      # Slovenian
      # Samoan
      # Shona
      # Somali
      # Albanian
      # Serbian
      # Swati
      # Southern Sotho
      # Sundanese
      # Swedish
      # Swahili
      # Tamil
      # Telugu
      # Tajik
      # Thai
      # Tigrinya
      # Turkmen
      # Tagalog
      # Tswana
      # Tonga
      # Turkish
      # Tsonga
      # Tatar
      # Twi
      # Tahitian
      # Uighur
      # Ukrainian
      # Urdu
      # Uzbek
      # Venda
      # Vietnamese
      # Volap?k
      # Walloon
      # Wolof
      # Xhosa
      # Yiddish
      # Yoruba
      # Zhuang
      # Chinese
      const_set_lazy(:IsoLanguageTable) { "aa" + "aar" + "ab" + "abk" + "ae" + "ave" + "af" + "afr" + "ak" + "aka" + "am" + "amh" + "an" + "arg" + "ar" + "ara" + "as" + "asm" + "av" + "ava" + "ay" + "aym" + "az" + "aze" + "ba" + "bak" + "be" + "bel" + "bg" + "bul" + "bh" + "bih" + "bi" + "bis" + "bm" + "bam" + "bn" + "ben" + "bo" + "bod" + "br" + "bre" + "bs" + "bos" + "ca" + "cat" + "ce" + "che" + "ch" + "cha" + "co" + "cos" + "cr" + "cre" + "cs" + "ces" + "cu" + "chu" + "cv" + "chv" + "cy" + "cym" + "da" + "dan" + "de" + "deu" + "dv" + "div" + "dz" + "dzo" + "ee" + "ewe" + "el" + "ell" + "en" + "eng" + "eo" + "epo" + "es" + "spa" + "et" + "est" + "eu" + "eus" + "fa" + "fas" + "ff" + "ful" + "fi" + "fin" + "fj" + "fij" + "fo" + "fao" + "fr" + "fra" + "fy" + "fry" + "ga" + "gle" + "gd" + "gla" + "gl" + "glg" + "gn" + "grn" + "gu" + "guj" + "gv" + "glv" + "ha" + "hau" + "he" + "heb" + "hi" + "hin" + "ho" + "hmo" + "hr" + "hrv" + "ht" + "hat" + "hu" + "hun" + "hy" + "hye" + "hz" + "her" + "ia" + "ina" + "id" + "ind" + "ie" + "ile" + "ig" + "ibo" + "ii" + "iii" + "ik" + "ipk" + "in" + "ind" + "io" + "ido" + "is" + "isl" + "it" + "ita" + "iu" + "iku" + "iw" + "heb" + "ja" + "jpn" + "ji" + "yid" + "jv" + "jav" + "ka" + "kat" + "kg" + "kon" + "ki" + "kik" + "kj" + "kua" + "kk" + "kaz" + "kl" + "kal" + "km" + "khm" + "kn" + "kan" + "ko" + "kor" + "kr" + "kau" + "ks" + "kas" + "ku" + "kur" + "kv" + "kom" + "kw" + "cor" + "ky" + "kir" + "la" + "lat" + "lb" + "ltz" + "lg" + "lug" + "li" + "lim" + "ln" + "lin" + "lo" + "lao" + "lt" + "lit" + "lu" + "lub" + "lv" + "lav" + "mg" + "mlg" + "mh" + "mah" + "mi" + "mri" + "mk" + "mkd" + "ml" + "mal" + "mn" + "mon" + "mo" + "mol" + "mr" + "mar" + "ms" + "msa" + "mt" + "mlt" + "my" + "mya" + "na" + "nau" + "nb" + "nob" + "nd" + "nde" + "ne" + "nep" + "ng" + "ndo" + "nl" + "nld" + "nn" + "nno" + "no" + "nor" + "nr" + "nbl" + "nv" + "nav" + "ny" + "nya" + "oc" + "oci" + "oj" + "oji" + "om" + "orm" + "or" + "ori" + "os" + "oss" + "pa" + "pan" + "pi" + "pli" + "pl" + "pol" + "ps" + "pus" + "pt" + "por" + "qu" + "que" + "rm" + "roh" + "rn" + "run" + "ro" + "ron" + "ru" + "rus" + "rw" + "kin" + "sa" + "san" + "sc" + "srd" + "sd" + "snd" + "se" + "sme" + "sg" + "sag" + "si" + "sin" + "sk" + "slk" + "sl" + "slv" + "sm" + "smo" + "sn" + "sna" + "so" + "som" + "sq" + "sqi" + "sr" + "srp" + "ss" + "ssw" + "st" + "sot" + "su" + "sun" + "sv" + "swe" + "sw" + "swa" + "ta" + "tam" + "te" + "tel" + "tg" + "tgk" + "th" + "tha" + "ti" + "tir" + "tk" + "tuk" + "tl" + "tgl" + "tn" + "tsn" + "to" + "ton" + "tr" + "tur" + "ts" + "tso" + "tt" + "tat" + "tw" + "twi" + "ty" + "tah" + "ug" + "uig" + "uk" + "ukr" + "ur" + "urd" + "uz" + "uzb" + "ve" + "ven" + "vi" + "vie" + "vo" + "vol" + "wa" + "wln" + "wo" + "wol" + "xh" + "xho" + "yi" + "yid" + "yo" + "yor" + "za" + "zha" + "zh" + "zho" + "zu" + "zul" }
      const_attr_reader  :IsoLanguageTable
      
      # Zulu
      # The 2- and 3-letter ISO 3166 country codes.
      # Andorra, Principality of
      # United Arab Emirates
      # Afghanistan
      # Antigua and Barbuda
      # Anguilla
      # Albania, People's Socialist Republic of
      # Armenia
      # Netherlands Antilles
      # Angola, Republic of
      # Antarctica (the territory South of 60 deg S)
      # Argentina, Argentine Republic
      # American Samoa
      # Austria, Republic of
      # Australia, Commonwealth of
      # Aruba
      # \u00c5land Islands
      # Azerbaijan, Republic of
      # Bosnia and Herzegovina
      # Barbados
      # Bangladesh, People's Republic of
      # Belgium, Kingdom of
      # Burkina Faso
      # Bulgaria, People's Republic of
      # Bahrain, Kingdom of
      # Burundi, Republic of
      # Benin, People's Republic of
      # Bermuda
      # Brunei Darussalam
      # Bolivia, Republic of
      # Brazil, Federative Republic of
      # Bahamas, Commonwealth of the
      # Bhutan, Kingdom of
      # Bouvet Island (Bouvetoya)
      # Botswana, Republic of
      # Belarus
      # Belize
      # Canada
      # Cocos (Keeling) Islands
      # Congo, Democratic Republic of
      # Central African Republic
      # Congo, People's Republic of
      # Switzerland, Swiss Confederation
      # Cote D'Ivoire, Ivory Coast, Republic of the
      # Cook Islands
      # Chile, Republic of
      # Cameroon, United Republic of
      # China, People's Republic of
      # Colombia, Republic of
      # Costa Rica, Republic of
      # Serbia and Montenegro
      # Cuba, Republic of
      # Cape Verde, Republic of
      # Christmas Island
      # Cyprus, Republic of
      # Czech Republic
      # Germany
      # Djibouti, Republic of
      # Denmark, Kingdom of
      # Dominica, Commonwealth of
      # Dominican Republic
      # Algeria, People's Democratic Republic of
      # Ecuador, Republic of
      # Estonia
      # Egypt, Arab Republic of
      # Western Sahara
      # Eritrea
      # Spain, Spanish State
      # Ethiopia
      # Finland, Republic of
      # Fiji, Republic of the Fiji Islands
      # Falkland Islands (Malvinas)
      # Micronesia, Federated States of
      # Faeroe Islands
      # France, French Republic
      # Gabon, Gabonese Republic
      # United Kingdom of Great Britain & N. Ireland
      # Grenada
      # Georgia
      # French Guiana
      # Guernsey
      # Ghana, Republic of
      # Gibraltar
      # Greenland
      # Gambia, Republic of the
      # Guinea, Revolutionary People's Rep'c of
      # Guadaloupe
      # Equatorial Guinea, Republic of
      # Greece, Hellenic Republic
      # South Georgia and the South Sandwich Islands
      # Guatemala, Republic of
      # Guam
      # Guinea-Bissau, Republic of
      # Guyana, Republic of
      # Hong Kong, Special Administrative Region of China
      # Heard and McDonald Islands
      # Honduras, Republic of
      # Hrvatska (Croatia)
      # Haiti, Republic of
      # Hungary, Hungarian People's Republic
      # Indonesia, Republic of
      # Ireland
      # Israel, State of
      # Isle of Man
      # India, Republic of
      # British Indian Ocean Territory (Chagos Archipelago)
      # Iraq, Republic of
      # Iran, Islamic Republic of
      # Iceland, Republic of
      # Italy, Italian Republic
      # Jersey
      # Jamaica
      # Jordan, Hashemite Kingdom of
      # Japan
      # Kenya, Republic of
      # Kyrgyz Republic
      # Cambodia, Kingdom of
      # Kiribati, Republic of
      # Comoros, Union of the
      # St. Kitts and Nevis
      # Korea, Democratic People's Republic of
      # Korea, Republic of
      # Kuwait, State of
      # Cayman Islands
      # Kazakhstan, Republic of
      # Lao People's Democratic Republic
      # Lebanon, Lebanese Republic
      # St. Lucia
      # Liechtenstein, Principality of
      # Sri Lanka, Democratic Socialist Republic of
      # Liberia, Republic of
      # Lesotho, Kingdom of
      # Lithuania
      # Luxembourg, Grand Duchy of
      # Latvia
      # Libyan Arab Jamahiriya
      # Morocco, Kingdom of
      # Monaco, Principality of
      # Moldova, Republic of
      # Montenegro, Republic of
      # Madagascar, Republic of
      # Marshall Islands
      # Macedonia, the former Yugoslav Republic of
      # Mali, Republic of
      # Myanmar
      # Mongolia, Mongolian People's Republic
      # Macao, Special Administrative Region of China
      # Northern Mariana Islands
      # Martinique
      # Mauritania, Islamic Republic of
      # Montserrat
      # Malta, Republic of
      # Mauritius
      # Maldives, Republic of
      # Malawi, Republic of
      # Mexico, United Mexican States
      # Malaysia
      # Mozambique, People's Republic of
      # Namibia
      # New Caledonia
      # Niger, Republic of the
      # Norfolk Island
      # Nigeria, Federal Republic of
      # Nicaragua, Republic of
      # Netherlands, Kingdom of the
      # Norway, Kingdom of
      # Nepal, Kingdom of
      # Nauru, Republic of
      # Niue, Republic of
      # New Zealand
      # Oman, Sultanate of
      # Panama, Republic of
      # Peru, Republic of
      # French Polynesia
      # Papua New Guinea
      # Philippines, Republic of the
      # Pakistan, Islamic Republic of
      # Poland, Polish People's Republic
      # St. Pierre and Miquelon
      # Pitcairn Island
      # Puerto Rico
      # Palestinian Territory, Occupied
      # Portugal, Portuguese Republic
      # Palau
      # Paraguay, Republic of
      # Qatar, State of
      # Reunion
      # Romania, Socialist Republic of
      # Serbia, Republic of
      # Russian Federation
      # Rwanda, Rwandese Republic
      # Saudi Arabia, Kingdom of
      # Solomon Islands
      # Seychelles, Republic of
      # Sudan, Democratic Republic of the
      # Sweden, Kingdom of
      # Singapore, Republic of
      # St. Helena
      # Slovenia
      # Svalbard & Jan Mayen Islands
      # Slovakia (Slovak Republic)
      # Sierra Leone, Republic of
      # San Marino, Republic of
      # Senegal, Republic of
      # Somalia, Somali Republic
      # Suriname, Republic of
      # Sao Tome and Principe, Democratic Republic of
      # El Salvador, Republic of
      # Syrian Arab Republic
      # Swaziland, Kingdom of
      # Turks and Caicos Islands
      # Chad, Republic of
      # French Southern Territories
      # Togo, Togolese Republic
      # Thailand, Kingdom of
      # Tajikistan
      # Tokelau (Tokelau Islands)
      # Timor-Leste, Democratic Republic of
      # Turkmenistan
      # Tunisia, Republic of
      # Tonga, Kingdom of
      # Turkey, Republic of
      # Trinidad and Tobago, Republic of
      # Tuvalu
      # Taiwan, Province of China
      # Tanzania, United Republic of
      # Ukraine
      # Uganda, Republic of
      # United States Minor Outlying Islands
      # United States of America
      # Uruguay, Eastern Republic of
      # Uzbekistan
      # Holy See (Vatican City State)
      # St. Vincent and the Grenadines
      # Venezuela, Bolivarian Republic of
      # British Virgin Islands
      # US Virgin Islands
      # Viet Nam, Socialist Republic of
      # Vanuatu
      # Wallis and Futuna Islands
      # Samoa, Independent State of
      # Yemen
      # Mayotte
      # South Africa, Republic of
      # Zambia, Republic of
      const_set_lazy(:IsoCountryTable) { "AD" + "AND" + "AE" + "ARE" + "AF" + "AFG" + "AG" + "ATG" + "AI" + "AIA" + "AL" + "ALB" + "AM" + "ARM" + "AN" + "ANT" + "AO" + "AGO" + "AQ" + "ATA" + "AR" + "ARG" + "AS" + "ASM" + "AT" + "AUT" + "AU" + "AUS" + "AW" + "ABW" + "AX" + "ALA" + "AZ" + "AZE" + "BA" + "BIH" + "BB" + "BRB" + "BD" + "BGD" + "BE" + "BEL" + "BF" + "BFA" + "BG" + "BGR" + "BH" + "BHR" + "BI" + "BDI" + "BJ" + "BEN" + "BM" + "BMU" + "BN" + "BRN" + "BO" + "BOL" + "BR" + "BRA" + "BS" + "BHS" + "BT" + "BTN" + "BV" + "BVT" + "BW" + "BWA" + "BY" + "BLR" + "BZ" + "BLZ" + "CA" + "CAN" + "CC" + "CCK" + "CD" + "COD" + "CF" + "CAF" + "CG" + "COG" + "CH" + "CHE" + "CI" + "CIV" + "CK" + "COK" + "CL" + "CHL" + "CM" + "CMR" + "CN" + "CHN" + "CO" + "COL" + "CR" + "CRI" + "CS" + "SCG" + "CU" + "CUB" + "CV" + "CPV" + "CX" + "CXR" + "CY" + "CYP" + "CZ" + "CZE" + "DE" + "DEU" + "DJ" + "DJI" + "DK" + "DNK" + "DM" + "DMA" + "DO" + "DOM" + "DZ" + "DZA" + "EC" + "ECU" + "EE" + "EST" + "EG" + "EGY" + "EH" + "ESH" + "ER" + "ERI" + "ES" + "ESP" + "ET" + "ETH" + "FI" + "FIN" + "FJ" + "FJI" + "FK" + "FLK" + "FM" + "FSM" + "FO" + "FRO" + "FR" + "FRA" + "GA" + "GAB" + "GB" + "GBR" + "GD" + "GRD" + "GE" + "GEO" + "GF" + "GUF" + "GG" + "GGY" + "GH" + "GHA" + "GI" + "GIB" + "GL" + "GRL" + "GM" + "GMB" + "GN" + "GIN" + "GP" + "GLP" + "GQ" + "GNQ" + "GR" + "GRC" + "GS" + "SGS" + "GT" + "GTM" + "GU" + "GUM" + "GW" + "GNB" + "GY" + "GUY" + "HK" + "HKG" + "HM" + "HMD" + "HN" + "HND" + "HR" + "HRV" + "HT" + "HTI" + "HU" + "HUN" + "ID" + "IDN" + "IE" + "IRL" + "IL" + "ISR" + "IM" + "IMN" + "IN" + "IND" + "IO" + "IOT" + "IQ" + "IRQ" + "IR" + "IRN" + "IS" + "ISL" + "IT" + "ITA" + "JE" + "JEY" + "JM" + "JAM" + "JO" + "JOR" + "JP" + "JPN" + "KE" + "KEN" + "KG" + "KGZ" + "KH" + "KHM" + "KI" + "KIR" + "KM" + "COM" + "KN" + "KNA" + "KP" + "PRK" + "KR" + "KOR" + "KW" + "KWT" + "KY" + "CYM" + "KZ" + "KAZ" + "LA" + "LAO" + "LB" + "LBN" + "LC" + "LCA" + "LI" + "LIE" + "LK" + "LKA" + "LR" + "LBR" + "LS" + "LSO" + "LT" + "LTU" + "LU" + "LUX" + "LV" + "LVA" + "LY" + "LBY" + "MA" + "MAR" + "MC" + "MCO" + "MD" + "MDA" + "ME" + "MNE" + "MG" + "MDG" + "MH" + "MHL" + "MK" + "MKD" + "ML" + "MLI" + "MM" + "MMR" + "MN" + "MNG" + "MO" + "MAC" + "MP" + "MNP" + "MQ" + "MTQ" + "MR" + "MRT" + "MS" + "MSR" + "MT" + "MLT" + "MU" + "MUS" + "MV" + "MDV" + "MW" + "MWI" + "MX" + "MEX" + "MY" + "MYS" + "MZ" + "MOZ" + "NA" + "NAM" + "NC" + "NCL" + "NE" + "NER" + "NF" + "NFK" + "NG" + "NGA" + "NI" + "NIC" + "NL" + "NLD" + "NO" + "NOR" + "NP" + "NPL" + "NR" + "NRU" + "NU" + "NIU" + "NZ" + "NZL" + "OM" + "OMN" + "PA" + "PAN" + "PE" + "PER" + "PF" + "PYF" + "PG" + "PNG" + "PH" + "PHL" + "PK" + "PAK" + "PL" + "POL" + "PM" + "SPM" + "PN" + "PCN" + "PR" + "PRI" + "PS" + "PSE" + "PT" + "PRT" + "PW" + "PLW" + "PY" + "PRY" + "QA" + "QAT" + "RE" + "REU" + "RO" + "ROU" + "RS" + "SRB" + "RU" + "RUS" + "RW" + "RWA" + "SA" + "SAU" + "SB" + "SLB" + "SC" + "SYC" + "SD" + "SDN" + "SE" + "SWE" + "SG" + "SGP" + "SH" + "SHN" + "SI" + "SVN" + "SJ" + "SJM" + "SK" + "SVK" + "SL" + "SLE" + "SM" + "SMR" + "SN" + "SEN" + "SO" + "SOM" + "SR" + "SUR" + "ST" + "STP" + "SV" + "SLV" + "SY" + "SYR" + "SZ" + "SWZ" + "TC" + "TCA" + "TD" + "TCD" + "TF" + "ATF" + "TG" + "TGO" + "TH" + "THA" + "TJ" + "TJK" + "TK" + "TKL" + "TL" + "TLS" + "TM" + "TKM" + "TN" + "TUN" + "TO" + "TON" + "TR" + "TUR" + "TT" + "TTO" + "TV" + "TUV" + "TW" + "TWN" + "TZ" + "TZA" + "UA" + "UKR" + "UG" + "UGA" + "UM" + "UMI" + "US" + "USA" + "UY" + "URY" + "UZ" + "UZB" + "VA" + "VAT" + "VC" + "VCT" + "VE" + "VEN" + "VG" + "VGB" + "VI" + "VIR" + "VN" + "VNM" + "VU" + "VUT" + "WF" + "WLF" + "WS" + "WSM" + "YE" + "YEM" + "YT" + "MYT" + "ZA" + "ZAF" + "ZM" + "ZMB" + "ZW" + "ZWE" }
      const_attr_reader  :IsoCountryTable
    }
    
    typesig { [] }
    # Zimbabwe
    def initialize
    end
    
    private
    alias_method :initialize__locale_isodata, :initialize
  end
  
end

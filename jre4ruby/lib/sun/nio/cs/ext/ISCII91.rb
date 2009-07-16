require "rjava"

# 
# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs::Ext
  module ISCII91Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :Surrogate
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class ISCII91 < ISCII91Imports.const_get :Charset
    include_class_members ISCII91Imports
    include HistoricallyNamedCharset
    
    class_module.module_eval {
      const_set_lazy(:NUKTA_CHAR) { Character.new(0x093c) }
      const_attr_reader  :NUKTA_CHAR
      
      const_set_lazy(:HALANT_CHAR) { Character.new(0x094d) }
      const_attr_reader  :HALANT_CHAR
      
      const_set_lazy(:NO_CHAR) { 255 }
      const_attr_reader  :NO_CHAR
    }
    
    typesig { [] }
    def initialize
      super("x-ISCII91", ExtendedCharsets.aliases_for("x-ISCII91"))
    end
    
    typesig { [] }
    def historical_name
      return "ISCII91"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(ISCII91)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    class_module.module_eval {
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # '\u0027' control -- ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # '\u005c' -- ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # ascii character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # unknown character
      # a1 -- Vowel-modifier CHANDRABINDU
      # a2 -- Vowel-modifier ANUSWAR
      # a3 -- Vowel-modifier VISARG
      # a4 -- Vowel A
      # a5 -- Vowel AA
      # a6 -- Vowel I
      # a7 -- Vowel II
      # a8 -- Vowel U
      # a9 -- Vowel UU
      # aa -- Vowel RI
      # ab -- Vowel E ( Southern Scripts )
      # ac -- Vowel EY
      # ad -- Vowel AI
      # ae -- Vowel AYE ( Devanagari Script )
      # af -- Vowel O ( Southern Scripts )
      # b0 -- Vowel OW
      # b1 -- Vowel AU
      # b2 -- Vowel AWE ( Devanagari Script )
      # b3 -- Consonant KA
      # b4 -- Consonant KHA
      # b5 -- Consonant GA
      # b6 -- Consonant GHA
      # b7 -- Consonant NGA
      # b8 -- Consonant CHA
      # b9 -- Consonant CHHA
      # ba -- Consonant JA
      # bb -- Consonant JHA
      # bc -- Consonant JNA
      # bd -- Consonant Hard TA
      # be -- Consonant Hard THA
      # bf -- Consonant Hard DA
      # c0 -- Consonant Hard DHA
      # c1 -- Consonant Hard NA
      # c2 -- Consonant Soft TA
      # c3 -- Consonant Soft THA
      # c4 -- Consonant Soft DA
      # c5 -- Consonant Soft DHA
      # c6 -- Consonant Soft NA
      # c7 -- Consonant NA ( Tamil )
      # c8 -- Consonant PA
      # c9 -- Consonant PHA
      # ca -- Consonant BA
      # cb -- Consonant BHA
      # cc -- Consonant MA
      # cd -- Consonant YA
      # ce -- Consonant JYA ( Bengali, Assamese & Oriya )
      # cf -- Consonant RA
      # d0 -- Consonant Hard RA ( Southern Scripts )
      # d1 -- Consonant LA
      # d2 -- Consonant Hard LA
      # d3 -- Consonant ZHA ( Tamil & Malayalam )
      # d4 -- Consonant VA
      # d5 -- Consonant SHA
      # d6 -- Consonant Hard SHA
      # d7 -- Consonant SA
      # d8 -- Consonant HA
      # d9 -- Consonant INVISIBLE
      # da -- Vowel Sign AA
      # db -- Vowel Sign I
      # dc -- Vowel Sign II
      # dd -- Vowel Sign U
      # de -- Vowel Sign UU
      # df -- Vowel Sign RI
      # e0 -- Vowel Sign E ( Southern Scripts )
      # e1 -- Vowel Sign EY
      # e2 -- Vowel Sign AI
      # e3 -- Vowel Sign AYE ( Devanagari Script )
      # e4 -- Vowel Sign O ( Southern Scripts )
      # e5 -- Vowel Sign OW
      # e6 -- Vowel Sign AU
      # e7 -- Vowel Sign AWE ( Devanagari Script )
      # e8 -- Vowel Omission Sign ( Halant )
      # e9 -- Diacritic Sign ( Nukta )
      # ea -- Full Stop ( Viram, Northern Scripts )
      # eb -- This position shall not be used
      # ec -- This position shall not be used
      # ed -- This position shall not be used
      # ee -- This position shall not be used
      # ef -- Attribute Code ( ATR )
      # f0 -- Extension Code ( EXT )
      # f1 -- Digit 0
      # f2 -- Digit 1
      # f3 -- Digit 2
      # f4 -- Digit 3
      # f5 -- Digit 4
      # f6 -- Digit 5
      # f7 -- Digit 6
      # f8 -- Digit 7
      # f9 -- Digit 8
      # fa -- Digit 9
      # fb -- This position shall not be used
      # fc -- This position shall not be used
      # fd -- This position shall not be used
      # fe -- This position shall not be used
      # ff -- This position shall not be used
      const_set_lazy(:DirectMapTable) { Array.typed(::Java::Char).new([Character.new(0x0000), Character.new(0x0001), Character.new(0x0002), Character.new(0x0003), Character.new(0x0004), Character.new(0x0005), Character.new(0x0006), Character.new(0x0007), Character.new(0x0008), Character.new(0x0009), Character.new(?\012.ord), Character.new(0x000b), Character.new(0x000c), Character.new(?\015.ord), Character.new(0x000e), Character.new(0x000f), Character.new(0x0010), Character.new(0x0011), Character.new(0x0012), Character.new(0x0013), Character.new(0x0014), Character.new(0x0015), Character.new(0x0016), Character.new(0x0017), Character.new(0x0018), Character.new(0x0019), Character.new(0x001a), Character.new(0x001b), Character.new(0x001c), Character.new(0x001d), Character.new(0x001e), Character.new(0x001f), Character.new(0x0020), Character.new(0x0021), Character.new(0x0022), Character.new(0x0023), Character.new(0x0024), Character.new(0x0025), Character.new(0x0026), RJava.cast_to_char(0x27), Character.new(0x0028), Character.new(0x0029), Character.new(0x002a), Character.new(0x002b), Character.new(0x002c), Character.new(0x002d), Character.new(0x002e), Character.new(0x002f), Character.new(0x0030), Character.new(0x0031), Character.new(0x0032), Character.new(0x0033), Character.new(0x0034), Character.new(0x0035), Character.new(0x0036), Character.new(0x0037), Character.new(0x0038), Character.new(0x0039), Character.new(0x003a), Character.new(0x003b), Character.new(0x003c), Character.new(0x003d), Character.new(0x003e), Character.new(0x003f), Character.new(0x0040), Character.new(0x0041), Character.new(0x0042), Character.new(0x0043), Character.new(0x0044), Character.new(0x0045), Character.new(0x0046), Character.new(0x0047), Character.new(0x0048), Character.new(0x0049), Character.new(0x004a), Character.new(0x004b), Character.new(0x004c), Character.new(0x004d), Character.new(0x004e), Character.new(0x004f), Character.new(0x0050), Character.new(0x0051), Character.new(0x0052), Character.new(0x0053), Character.new(0x0054), Character.new(0x0055), Character.new(0x0056), Character.new(0x0057), Character.new(0x0058), Character.new(0x0059), Character.new(0x005a), Character.new(0x005b), Character.new(?\\.ord), Character.new(0x005d), Character.new(0x005e), Character.new(0x005f), Character.new(0x0060), Character.new(0x0061), Character.new(0x0062), Character.new(0x0063), Character.new(0x0064), Character.new(0x0065), Character.new(0x0066), Character.new(0x0067), Character.new(0x0068), Character.new(0x0069), Character.new(0x006a), Character.new(0x006b), Character.new(0x006c), Character.new(0x006d), Character.new(0x006e), Character.new(0x006f), Character.new(0x0070), Character.new(0x0071), Character.new(0x0072), Character.new(0x0073), Character.new(0x0074), Character.new(0x0075), Character.new(0x0076), Character.new(0x0077), Character.new(0x0078), Character.new(0x0079), Character.new(0x007a), Character.new(0x007b), Character.new(0x007c), Character.new(0x007d), Character.new(0x007e), Character.new(0x007f), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0x0901), Character.new(0x0902), Character.new(0x0903), Character.new(0x0905), Character.new(0x0906), Character.new(0x0907), Character.new(0x0908), Character.new(0x0909), Character.new(0x090a), Character.new(0x090b), Character.new(0x090e), Character.new(0x090f), Character.new(0x0910), Character.new(0x090d), Character.new(0x0912), Character.new(0x0913), Character.new(0x0914), Character.new(0x0911), Character.new(0x0915), Character.new(0x0916), Character.new(0x0917), Character.new(0x0918), Character.new(0x0919), Character.new(0x091a), Character.new(0x091b), Character.new(0x091c), Character.new(0x091d), Character.new(0x091e), Character.new(0x091f), Character.new(0x0920), Character.new(0x0921), Character.new(0x0922), Character.new(0x0923), Character.new(0x0924), Character.new(0x0925), Character.new(0x0926), Character.new(0x0927), Character.new(0x0928), Character.new(0x0929), Character.new(0x092a), Character.new(0x092b), Character.new(0x092c), Character.new(0x092d), Character.new(0x092e), Character.new(0x092f), Character.new(0x095f), Character.new(0x0930), Character.new(0x0931), Character.new(0x0932), Character.new(0x0933), Character.new(0x0934), Character.new(0x0935), Character.new(0x0936), Character.new(0x0937), Character.new(0x0938), Character.new(0x0939), Character.new(0x200d), Character.new(0x093e), Character.new(0x093f), Character.new(0x0940), Character.new(0x0941), Character.new(0x0942), Character.new(0x0943), Character.new(0x0946), Character.new(0x0947), Character.new(0x0948), Character.new(0x0945), Character.new(0x094a), Character.new(0x094b), Character.new(0x094c), Character.new(0x0949), Character.new(0x094d), Character.new(0x093c), Character.new(0x0964), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xfffd), Character.new(0xfffd), Character.new(0x0966), Character.new(0x0967), Character.new(0x0968), Character.new(0x0969), Character.new(0x096a), Character.new(0x096b), Character.new(0x096c), Character.new(0x096d), Character.new(0x096e), Character.new(0x096f), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff), Character.new(0xffff)]) }
      const_attr_reader  :DirectMapTable
      
      typesig { [] }
      # end of table definition
      # 
      # This accessor is temporarily supplied while sun.io
      # converters co-exist with the sun.nio.cs.{ext} charset coders
      # These facilitate sharing of conversion tables between the
      # two co-existing implementations. When sun.io converters
      # are made extinct these will be unnecessary and should be removed
      def get_direct_map_table
        return DirectMapTable
      end
      
      # 0900 <reserved>
      # 0901 -- DEVANAGARI SIGN CANDRABINDU = anunasika
      # 0902 -- DEVANAGARI SIGN ANUSVARA = bindu
      # 0903 -- DEVANAGARI SIGN VISARGA
      # 0904 <reserved>
      # 0905 -- DEVANAGARI LETTER A
      # 0906 -- DEVANAGARI LETTER AA
      # 0907 -- DEVANAGARI LETTER I
      # 0908 -- DEVANAGARI LETTER II
      # 0909 -- DEVANAGARI LETTER U
      # 090a -- DEVANAGARI LETTER UU
      # 090b -- DEVANAGARI LETTER VOCALIC R
      # 090c -- DEVANAGARI LETTER VOVALIC L
      # 090d -- DEVANAGARI LETTER CANDRA E
      # 090e -- DEVANAGARI LETTER SHORT E
      # 090f -- DEVANAGARI LETTER E
      # 0910 -- DEVANAGARI LETTER AI
      # 0911 -- DEVANAGARI LETTER CANDRA O
      # 0912 -- DEVANAGARI LETTER SHORT O
      # 0913 -- DEVANAGARI LETTER O
      # 0914 -- DEVANAGARI LETTER AU
      # 0915 -- DEVANAGARI LETTER KA
      # 0916 -- DEVANAGARI LETTER KHA
      # 0917 -- DEVANAGARI LETTER GA
      # 0918 -- DEVANAGARI LETTER GHA
      # 0919 -- DEVANAGARI LETTER NGA
      # 091a -- DEVANAGARI LETTER CA
      # 091b -- DEVANAGARI LETTER CHA
      # 091c -- DEVANAGARI LETTER JA
      # 091d -- DEVANAGARI LETTER JHA
      # 091e -- DEVANAGARI LETTER NYA
      # 091f -- DEVANAGARI LETTER TTA
      # 0920 -- DEVANAGARI LETTER TTHA
      # 0921 -- DEVANAGARI LETTER DDA
      # 0922 -- DEVANAGARI LETTER DDHA
      # 0923 -- DEVANAGARI LETTER NNA
      # 0924 -- DEVANAGARI LETTER TA
      # 0925 -- DEVANAGARI LETTER THA
      # 0926 -- DEVANAGARI LETTER DA
      # 0927 -- DEVANAGARI LETTER DHA
      # 0928 -- DEVANAGARI LETTER NA
      # 0929 -- DEVANAGARI LETTER NNNA <=> 0928 + 093C
      # 092a -- DEVANAGARI LETTER PA
      # 092b -- DEVANAGARI LETTER PHA
      # 092c -- DEVANAGARI LETTER BA
      # 092d -- DEVANAGARI LETTER BHA
      # 092e -- DEVANAGARI LETTER MA
      # 092f -- DEVANAGARI LETTER YA
      # 0930 -- DEVANAGARI LETTER RA
      # 0931 -- DEVANAGARI LETTER RRA <=> 0930 + 093C
      # 0932 -- DEVANAGARI LETTER LA
      # 0933 -- DEVANAGARI LETTER LLA
      # 0934 -- DEVANAGARI LETTER LLLA <=> 0933 + 093C
      # 0935 -- DEVANAGARI LETTER VA
      # 0936 -- DEVANAGARI LETTER SHA
      # 0937 -- DEVANAGARI LETTER SSA
      # 0938 -- DEVANAGARI LETTER SA
      # 0939 -- DEVANAGARI LETTER HA
      # 093a <reserved>
      # 093b <reserved>
      # 093c -- DEVANAGARI SIGN NUKTA
      # 093d -- DEVANAGARI SIGN AVAGRAHA
      # 093e -- DEVANAGARI VOWEL SIGN AA
      # 093f -- DEVANAGARI VOWEL SIGN I
      # 0940 -- DEVANAGARI VOWEL SIGN II
      # 0941 -- DEVANAGARI VOWEL SIGN U
      # 0942 -- DEVANAGARI VOWEL SIGN UU
      # 0943 -- DEVANAGARI VOWEL SIGN VOCALIC R
      # 0944 -- DEVANAGARI VOWEL SIGN VOCALIC RR
      # 0945 -- DEVANAGARI VOWEL SIGN CANDRA E
      # 0946 -- DEVANAGARI VOWEL SIGN SHORT E
      # 0947 -- DEVANAGARI VOWEL SIGN E
      # 0948 -- DEVANAGARI VOWEL SIGN AI
      # 0949 -- DEVANAGARI VOWEL SIGN CANDRA O
      # 094a -- DEVANAGARI VOWEL SIGN SHORT O
      # 094b -- DEVANAGARI VOWEL SIGN O
      # 094c -- DEVANAGARI VOWEL SIGN AU
      # 094d -- DEVANAGARI SIGN VIRAMA ( halant )
      # 094e <reserved>
      # 094f <reserved>
      # 0950 -- DEVANAGARI OM
      # 0951 -- DEVANAGARI STRESS SIGN UDATTA
      # 0952 -- DEVANAGARI STRESS SIGN ANUDATTA
      # 0953 -- DEVANAGARI GRAVE ACCENT || MISSING
      # 0954 -- DEVANAGARI ACUTE ACCENT || MISSING
      # 0955 <reserved>
      # 0956 <reserved>
      # 0957 <reserved>
      # 0958 -- DEVANAGARI LETTER QA <=> 0915 + 093C
      # 0959 -- DEVANAGARI LETTER KHHA <=> 0916 + 093C
      # 095a -- DEVANAGARI LETTER GHHA <=> 0917 + 093C
      # 095b -- DEVANAGARI LETTER ZA <=> 091C + 093C
      # 095c -- DEVANAGARI LETTER DDDHA <=> 0921 + 093C
      # 095d -- DEVANAGARI LETTER RHA <=> 0922 + 093C
      # 095e -- DEVANAGARI LETTER FA <=> 092B + 093C
      # 095f -- DEVANAGARI LETTER YYA <=> 092F + 093C
      # 0960 -- DEVANAGARI LETTER VOCALIC RR
      # 0961 -- DEVANAGARI LETTER VOCALIC LL
      # 0962 -- DEVANAGARI VOWEL SIGN VOCALIC L
      # 0963 -- DEVANAGARI VOWEL SIGN VOCALIC LL
      # 0964 -- DEVANAGARI DANDA ( phrase separator )
      # 0965 -- DEVANAGARI DOUBLE DANDA
      # 0966 -- DEVANAGARI DIGIT ZERO
      # 0967 -- DEVANAGARI DIGIT ONE
      # 0968 -- DEVANAGARI DIGIT TWO
      # 0969 -- DEVANAGARI DIGIT THREE
      # 096a -- DEVANAGARI DIGIT FOUR
      # 096b -- DEVANAGARI DIGIT FIVE
      # 096c -- DEVANAGARI DIGIT SIX
      # 096d -- DEVANAGARI DIGIT SEVEN
      # 096e -- DEVANAGARI DIGIT EIGHT
      # 096f -- DEVANAGARI DIGIT NINE
      # 0970 -- DEVANAGARI ABBREVIATION SIGN
      # 0971 -- reserved
      # 0972 -- reserved
      # 0973 -- reserved
      # 0974 -- reserved
      # 0975 -- reserved
      # 0976 -- reserved
      # 0977 -- reserved
      # 0978 -- reserved
      # 0979 -- reserved
      # 097a -- reserved
      # 097b -- reserved
      # 097c -- reserved
      # 097d -- reserved
      # 097e -- reserved
      # 097f -- reserved
      const_set_lazy(:EncoderMappingTable) { Array.typed(::Java::Byte).new([NO_CHAR, NO_CHAR, 161, NO_CHAR, 162, NO_CHAR, 163, NO_CHAR, NO_CHAR, NO_CHAR, 164, NO_CHAR, 165, NO_CHAR, 166, NO_CHAR, 167, NO_CHAR, 168, NO_CHAR, 169, NO_CHAR, 170, NO_CHAR, 166, 233, 174, NO_CHAR, 171, NO_CHAR, 172, NO_CHAR, 173, NO_CHAR, 178, NO_CHAR, 175, NO_CHAR, 176, NO_CHAR, 177, NO_CHAR, 179, NO_CHAR, 180, NO_CHAR, 181, NO_CHAR, 182, NO_CHAR, 183, NO_CHAR, 184, NO_CHAR, 185, NO_CHAR, 186, NO_CHAR, 187, NO_CHAR, 188, NO_CHAR, 189, NO_CHAR, 190, NO_CHAR, 191, NO_CHAR, 192, NO_CHAR, 193, NO_CHAR, 194, NO_CHAR, 195, NO_CHAR, 196, NO_CHAR, 197, NO_CHAR, 198, NO_CHAR, 199, NO_CHAR, 200, NO_CHAR, 201, NO_CHAR, 202, NO_CHAR, 203, NO_CHAR, 204, NO_CHAR, 205, NO_CHAR, 207, NO_CHAR, 208, NO_CHAR, 209, NO_CHAR, 210, NO_CHAR, 211, NO_CHAR, 212, NO_CHAR, 213, NO_CHAR, 214, NO_CHAR, 215, NO_CHAR, 216, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, 233, NO_CHAR, 234, 233, 218, NO_CHAR, 219, NO_CHAR, 220, NO_CHAR, 221, NO_CHAR, 222, NO_CHAR, 223, NO_CHAR, 223, 233, 227, NO_CHAR, 224, NO_CHAR, 225, NO_CHAR, 226, NO_CHAR, 231, NO_CHAR, 228, NO_CHAR, 229, NO_CHAR, 230, NO_CHAR, 232, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, 161, 233, 240, 181, 240, 184, 254, NO_CHAR, 254, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, 179, 233, 180, 233, 181, 233, 186, 233, 191, 233, 192, 233, 201, 233, 206, NO_CHAR, 170, 233, 167, 233, 219, 233, 220, 233, 234, NO_CHAR, 234, 234, 241, NO_CHAR, 242, NO_CHAR, 243, NO_CHAR, 244, NO_CHAR, 245, NO_CHAR, 246, NO_CHAR, 247, NO_CHAR, 248, NO_CHAR, 249, NO_CHAR, 250, NO_CHAR, 240, 191, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR, NO_CHAR]) }
      const_attr_reader  :EncoderMappingTable
      
      typesig { [] }
      # end of table definition
      # 
      # This accessor is temporarily supplied while sun.io
      # converters co-exist with the sun.nio.cs.{ext} charset coders
      # These facilitate sharing of conversion tables between the
      # two co-existing implementations. When sun.io converters
      # are made extinct these will be unnecessary and should be removed
      def get_encoder_mapping_table
        return EncoderMappingTable
      end
      
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members ISCII91
        
        class_module.module_eval {
          const_set_lazy(:ZWNJ_CHAR) { Character.new(0x200c) }
          const_attr_reader  :ZWNJ_CHAR
          
          const_set_lazy(:ZWJ_CHAR) { Character.new(0x200d) }
          const_attr_reader  :ZWJ_CHAR
          
          const_set_lazy(:INVALID_CHAR) { Character.new(0xffff) }
          const_attr_reader  :INVALID_CHAR
        }
        
        attr_accessor :context_char
        alias_method :attr_context_char, :context_char
        undef_method :context_char
        alias_method :attr_context_char=, :context_char=
        undef_method :context_char=
        
        attr_accessor :need_flushing
        alias_method :attr_need_flushing, :need_flushing
        undef_method :need_flushing
        alias_method :attr_need_flushing=, :need_flushing=
        undef_method :need_flushing=
        
        typesig { [Charset] }
        def initialize(cs)
          @context_char = 0
          @need_flushing = false
          super(cs, 1.0, 1.0)
          @context_char = self.class::INVALID_CHAR
          @need_flushing = false
        end
        
        typesig { [CharBuffer] }
        def impl_flush(out)
          if (@need_flushing)
            if (out.remaining < 1)
              return CoderResult::OVERFLOW
            else
              out.put(@context_char)
            end
          end
          @context_char = self.class::INVALID_CHAR
          @need_flushing = false
          return CoderResult::UNDERFLOW
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        # Rules:
        # 1)ATR,EXT,following character to be replaced with '\ufffd'
        # 2)Halant + Halant => '\u094d' (Virama) + '\u200c'(ZWNJ)
        # 3)Halant + Nukta => '\u094d' (Virama) + '\u200d'(ZWJ)
        def decode_array_loop(src, dst)
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          begin
            while (sp < sl)
              index = sa[sp]
              index = (index < 0) ? (index + 255) : index
              current_char = DirectMapTable[index]
              # if the contextChar is either ATR || EXT
              # set the output to '\ufffd'
              if ((@context_char).equal?(Character.new(0xfffd)))
                if (dl - dp < 1)
                  return CoderResult::OVERFLOW
                end
                da[((dp += 1) - 1)] = Character.new(0xfffd)
                @context_char = self.class::INVALID_CHAR
                @need_flushing = false
                ((sp += 1) - 1)
                next
              end
              catch(:break_case) do
                case (current_char)
                when Character.new(0x0901), Character.new(0x0907), Character.new(0x0908), Character.new(0x090b), Character.new(0x093f), Character.new(0x0940), Character.new(0x0943), Character.new(0x0964)
                  if (@need_flushing)
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    da[((dp += 1) - 1)] = @context_char
                    @context_char = current_char
                    ((sp += 1) - 1)
                    next
                  end
                  @context_char = current_char
                  @need_flushing = true
                  ((sp += 1) - 1)
                  next
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  case (@context_char)
                  when Character.new(0x0901)
                    da[((dp += 1) - 1)] = Character.new(0x0950)
                  when Character.new(0x0907)
                    da[((dp += 1) - 1)] = Character.new(0x090c)
                  when Character.new(0x0908)
                    da[((dp += 1) - 1)] = Character.new(0x0961)
                  when Character.new(0x090b)
                    da[((dp += 1) - 1)] = Character.new(0x0960)
                  when Character.new(0x093f)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                  when Character.new(0x0940)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                  when Character.new(0x0943)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                  when Character.new(0x0964)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                  when HALANT_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                  else
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  end
                when NUKTA_CHAR
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  case (@context_char)
                  when Character.new(0x0901)
                    da[((dp += 1) - 1)] = Character.new(0x0950)
                    da[((dp += 1) - 1)] = Character.new(0x090c)
                    da[((dp += 1) - 1)] = Character.new(0x0961)
                    da[((dp += 1) - 1)] = Character.new(0x0960)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x0907)
                    da[((dp += 1) - 1)] = Character.new(0x090c)
                    da[((dp += 1) - 1)] = Character.new(0x0961)
                    da[((dp += 1) - 1)] = Character.new(0x0960)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x0908)
                    da[((dp += 1) - 1)] = Character.new(0x0961)
                    da[((dp += 1) - 1)] = Character.new(0x0960)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x090b)
                    da[((dp += 1) - 1)] = Character.new(0x0960)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x093f)
                    da[((dp += 1) - 1)] = Character.new(0x0962)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x0940)
                    da[((dp += 1) - 1)] = Character.new(0x0963)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x0943)
                    da[((dp += 1) - 1)] = Character.new(0x0944)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when Character.new(0x0964)
                    da[((dp += 1) - 1)] = Character.new(0x093d)
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  when HALANT_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = self.class::ZWJ_CHAR
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  else
                    if (@need_flushing)
                      da[((dp += 1) - 1)] = @context_char
                      @context_char = current_char
                      ((sp += 1) - 1)
                      next
                    end
                    da[((dp += 1) - 1)] = NUKTA_CHAR
                  end
                when HALANT_CHAR
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (@need_flushing)
                    da[((dp += 1) - 1)] = @context_char
                    @context_char = current_char
                    ((sp += 1) - 1)
                    next
                  end
                  if ((@context_char).equal?(HALANT_CHAR))
                    da[((dp += 1) - 1)] = self.class::ZWNJ_CHAR
                    throw :break_case, :thrown
                  end
                  da[((dp += 1) - 1)] = HALANT_CHAR
                when self.class::INVALID_CHAR
                  if (@need_flushing)
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    da[((dp += 1) - 1)] = @context_char
                    @context_char = current_char
                    ((sp += 1) - 1)
                    next
                  end
                  return CoderResult.unmappable_for_length(1)
                else
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (@need_flushing)
                    da[((dp += 1) - 1)] = @context_char
                    @context_char = current_char
                    ((sp += 1) - 1)
                    next
                  end
                  da[((dp += 1) - 1)] = current_char
                end
              end == :thrown or break
              # end switch
              @context_char = current_char
              @need_flushing = false
              ((sp += 1) - 1)
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_buffer_loop(src, dst)
          mark = src.position
          begin
            while (src.has_remaining)
              index = src.get
              index = (index < 0) ? (index + 255) : index
              current_char = DirectMapTable[index]
              # if the contextChar is either ATR || EXT
              # set the output to '\ufffd'
              if ((@context_char).equal?(Character.new(0xfffd)))
                if (dst.remaining < 1)
                  return CoderResult::OVERFLOW
                end
                dst.put(Character.new(0xfffd))
                @context_char = self.class::INVALID_CHAR
                @need_flushing = false
                ((mark += 1) - 1)
                next
              end
              catch(:break_case) do
                case (current_char)
                when Character.new(0x0901), Character.new(0x0907), Character.new(0x0908), Character.new(0x090b), Character.new(0x093f), Character.new(0x0940), Character.new(0x0943), Character.new(0x0964)
                  if (@need_flushing)
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(@context_char)
                    @context_char = current_char
                    ((mark += 1) - 1)
                    next
                  end
                  @context_char = current_char
                  @need_flushing = true
                  ((mark += 1) - 1)
                  next
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  case (@context_char)
                  when Character.new(0x0901)
                    dst.put(Character.new(0x0950))
                  when Character.new(0x0907)
                    dst.put(Character.new(0x090c))
                  when Character.new(0x0908)
                    dst.put(Character.new(0x0961))
                  when Character.new(0x090b)
                    dst.put(Character.new(0x0960))
                  when Character.new(0x093f)
                    dst.put(Character.new(0x0962))
                  when Character.new(0x0940)
                    dst.put(Character.new(0x0963))
                  when Character.new(0x0943)
                    dst.put(Character.new(0x0944))
                  when Character.new(0x0964)
                    dst.put(Character.new(0x093d))
                  when HALANT_CHAR
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                  else
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  end
                when NUKTA_CHAR
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  case (@context_char)
                  when Character.new(0x0901)
                    dst.put(Character.new(0x0950))
                    dst.put(Character.new(0x090c))
                    dst.put(Character.new(0x0961))
                    dst.put(Character.new(0x0960))
                    dst.put(Character.new(0x0962))
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x0907)
                    dst.put(Character.new(0x090c))
                    dst.put(Character.new(0x0961))
                    dst.put(Character.new(0x0960))
                    dst.put(Character.new(0x0962))
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x0908)
                    dst.put(Character.new(0x0961))
                    dst.put(Character.new(0x0960))
                    dst.put(Character.new(0x0962))
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x090b)
                    dst.put(Character.new(0x0960))
                    dst.put(Character.new(0x0962))
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x093f)
                    dst.put(Character.new(0x0962))
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x0940)
                    dst.put(Character.new(0x0963))
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x0943)
                    dst.put(Character.new(0x0944))
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when Character.new(0x0964)
                    dst.put(Character.new(0x093d))
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  when HALANT_CHAR
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(self.class::ZWJ_CHAR)
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  else
                    if (@need_flushing)
                      dst.put(@context_char)
                      @context_char = current_char
                      ((mark += 1) - 1)
                      next
                    end
                    dst.put(NUKTA_CHAR)
                  end
                when HALANT_CHAR
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (@need_flushing)
                    dst.put(@context_char)
                    @context_char = current_char
                    ((mark += 1) - 1)
                    next
                  end
                  if ((@context_char).equal?(HALANT_CHAR))
                    dst.put(self.class::ZWNJ_CHAR)
                    throw :break_case, :thrown
                  end
                  dst.put(HALANT_CHAR)
                when self.class::INVALID_CHAR
                  if (@need_flushing)
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(@context_char)
                    @context_char = current_char
                    ((mark += 1) - 1)
                    next
                  end
                  return CoderResult.unmappable_for_length(1)
                else
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (@need_flushing)
                    dst.put(@context_char)
                    @context_char = current_char
                    ((mark += 1) - 1)
                    next
                  end
                  dst.put(current_char)
                end
              end == :thrown or break
              # end switch
              @context_char = current_char
              @need_flushing = false
              ((mark += 1) - 1)
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [ByteBuffer, CharBuffer] }
        def decode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return decode_array_loop(src, dst)
          else
            return decode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(CharsetEncoder) do
        include_class_members ISCII91
        
        class_module.module_eval {
          const_set_lazy(:NO_CHAR) { 255 }
          const_attr_reader  :NO_CHAR
        }
        
        # private static CharToByteISCII91 c2b = new CharToByteISCII91();
        # private static final byte[] directMapTable = c2b.getISCIIEncoderMap();
        attr_accessor :sgp
        alias_method :attr_sgp, :sgp
        undef_method :sgp
        alias_method :attr_sgp=, :sgp=
        undef_method :sgp=
        
        typesig { [Charset] }
        def initialize(cs)
          @sgp = nil
          super(cs, 2.0, 2.0)
          @sgp = Surrogate::Parser.new
        end
        
        typesig { [::Java::Char] }
        def can_encode(ch)
          # check for Devanagari range,ZWJ,ZWNJ and ASCII range.
          return ((ch >= Character.new(0x0900) && ch <= Character.new(0x097f) && !(EncoderMappingTable[2 * (ch - Character.new(0x0900))]).equal?(self.class::NO_CHAR)) || ((ch).equal?(Character.new(0x200d))) || ((ch).equal?(Character.new(0x200c))) || (ch <= Character.new(0x007f)))
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_array_loop(src, dst)
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          output_size = 0
          begin
            input_char = 0
            while (sp < sl)
              index = JavaInteger::MIN_VALUE
              input_char = sa[sp]
              if (input_char >= 0x0 && input_char <= 0x7f)
                if (dl - dp < 1)
                  return CoderResult::OVERFLOW
                end
                da[((dp += 1) - 1)] = input_char
                ((sp += 1) - 1)
                next
              end
              # if inputChar == ZWJ replace it with halant
              # if inputChar == ZWNJ replace it with Nukta
              if ((input_char).equal?(0x200c))
                input_char = HALANT_CHAR
              else
                if ((input_char).equal?(0x200d))
                  input_char = NUKTA_CHAR
                end
              end
              if (input_char >= 0x900 && input_char <= 0x97f)
                index = (RJava.cast_to_int((input_char)) - 0x900) * 2
              end
              if (Surrogate.is(input_char))
                if (@sgp.parse(input_char, sa, sp, sl) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              if ((index).equal?(JavaInteger::MIN_VALUE) || (EncoderMappingTable[index]).equal?(self.class::NO_CHAR))
                return CoderResult.unmappable_for_length(1)
              else
                if ((EncoderMappingTable[index + 1]).equal?(self.class::NO_CHAR))
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  da[((dp += 1) - 1)] = EncoderMappingTable[index]
                else
                  if (dl - dp < 2)
                    return CoderResult::OVERFLOW
                  end
                  da[((dp += 1) - 1)] = EncoderMappingTable[index]
                  da[((dp += 1) - 1)] = EncoderMappingTable[index + 1]
                end
                ((sp += 1) - 1)
              end
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_buffer_loop(src, dst)
          mark = src.position
          begin
            input_char = 0
            while (src.has_remaining)
              index = JavaInteger::MIN_VALUE
              input_char = src.get
              if (input_char >= 0x0 && input_char <= 0x7f)
                if (dst.remaining < 1)
                  return CoderResult::OVERFLOW
                end
                dst.put(input_char)
                ((mark += 1) - 1)
                next
              end
              # if inputChar == ZWJ replace it with halant
              # if inputChar == ZWNJ replace it with Nukta
              if ((input_char).equal?(0x200c))
                input_char = HALANT_CHAR
              else
                if ((input_char).equal?(0x200d))
                  input_char = NUKTA_CHAR
                end
              end
              if (input_char >= 0x900 && input_char <= 0x97f)
                index = (RJava.cast_to_int((input_char)) - 0x900) * 2
              end
              if (Surrogate.is(input_char))
                if (@sgp.parse(input_char, src) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              if ((index).equal?(JavaInteger::MIN_VALUE) || (EncoderMappingTable[index]).equal?(self.class::NO_CHAR))
                return CoderResult.unmappable_for_length(1)
              else
                if ((EncoderMappingTable[index + 1]).equal?(self.class::NO_CHAR))
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  dst.put(EncoderMappingTable[index])
                else
                  if (dst.remaining < 2)
                    return CoderResult::OVERFLOW
                  end
                  dst.put(EncoderMappingTable[index])
                  dst.put(EncoderMappingTable[index + 1])
                end
              end
              ((mark += 1) - 1)
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [CharBuffer, ByteBuffer] }
        def encode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return encode_array_loop(src, dst)
          else
            return encode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iscii91, :initialize
  end
  
end

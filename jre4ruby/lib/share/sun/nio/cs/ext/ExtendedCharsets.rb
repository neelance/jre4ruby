require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ExtendedCharsetsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset::Spi, :CharsetProvider
      include_const ::Sun::Nio::Cs, :AbstractCharsetProvider
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Provider for extended charsets.
  class ExtendedCharsets < ExtendedCharsetsImports.const_get :AbstractCharsetProvider
    include_class_members ExtendedCharsetsImports
    
    class_module.module_eval {
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
    }
    
    typesig { [] }
    def initialize
      @initialized = false
      super("sun.nio.cs.ext")
      @initialized = false # identify provider pkg name.
      # Traditional Chinese
      # IANA aliases
      charset("Big5", "Big5", Array.typed(String).new(["csBig5"])) # JDK historical;
      # IANA aliases
      charset("x-MS950-HKSCS", "MS950_HKSCS", Array.typed(String).new(["MS950_HKSCS"])) # JDK historical
      charset("x-windows-950", "MS950", Array.typed(String).new(["ms950", "windows-950"])) # JDK historical
      charset("x-windows-874", "MS874", Array.typed(String).new(["ms874", "ms-874", "windows-874"])) # JDK historical
      charset("x-EUC-TW", "EUC_TW", Array.typed(String).new(["euc_tw", "euctw", "cns11643", "EUC-TW"])) # JDK historical # Linux alias
      charset("Big5-HKSCS", "Big5_HKSCS", Array.typed(String).new(["Big5_HKSCS", "big5hk", "big5-hkscs", "big5-hkscs:unicode3.0", "big5hkscs"])) # JDK historical
      charset("x-Big5-Solaris", "Big5_Solaris", Array.typed(String).new(["Big5_Solaris"]))
      # Simplified Chinese
      charset("GBK", "GBK", Array.typed(String).new(["windows-936", "CP936"]))
      charset("GB18030", "GB18030", Array.typed(String).new(["gb18030-2000"])) # 1.4 compatability # JDK historical
      # IANA aliases
      charset("GB2312", "EUC_CN", Array.typed(String).new(["gb2312", "gb2312-80", "gb2312-1980", "euc-cn", "euccn", "x-EUC-CN", "EUC_CN"])) # historical
      # IANA aliases
      charset("x-mswin-936", "MS936", Array.typed(String).new(["ms936", "ms_936"])) # historical
      # The definition of this charset may be overridden by the init method,
      # below, if the sun.nio.cs.map property is defined.
      # 
      # IANA aliases
      charset("Shift_JIS", "SJIS", Array.typed(String).new(["sjis", "shift_jis", "shift-jis", "ms_kanji", "x-sjis", "csShiftJIS"])) # JDK historical
      # The definition of this charset may be overridden by the init method,
      # below, if the sun.nio.cs.map property is defined.
      # 
      charset("windows-31j", "MS932", Array.typed(String).new(["MS932", "windows-932", "csWindows31J"])) # JDK historical
      # IANA aliases
      charset("JIS_X0201", "JIS_X_0201", Array.typed(String).new(["JIS0201", "JIS_X0201", "X0201", "csHalfWidthKatakana"])) # JDK historical
      # IANA aliases
      charset("x-JIS0208", "JIS_X_0208", Array.typed(String).new(["JIS0208", "JIS_C6226-1983", "iso-ir-87", "x0208", "JIS_X0208-1983", "csISO87JISX0208"])) # JDK historical
      # IANA aliases
      charset("JIS_X0212-1990", "JIS_X_0212", Array.typed(String).new(["JIS0212", "jis_x0212-1990", "x0212", "iso-ir-159", "csISO159JISX02121990"])) # JDK historical
      # IANA aliases
      charset("EUC-JP", "EUC_JP", Array.typed(String).new(["euc_jp", "eucjis", "eucjp", "Extended_UNIX_Code_Packed_Format_for_Japanese", "csEUCPkdFmtjapanese", "x-euc-jp", "x-eucjp"])) # JDK historical
      charset("x-euc-jp-linux", "EUC_JP_LINUX", Array.typed(String).new(["euc_jp_linux", "euc-jp-linux"])) # JDK historical
      charset("x-eucjp-open", "EUC_JP_Open", Array.typed(String).new(["EUC_JP_Solaris", "eucJP-open"])) # historical
      # IANA aliases
      charset("x-PCK", "PCK", Array.typed(String).new(["pck"])) # historical
      # IANA aliases
      charset("ISO-2022-JP", "ISO2022_JP", Array.typed(String).new(["iso2022jp", "jis", "csISO2022JP", "jis_encoding", "csjisencoding"]))
      # IANA aliases
      charset("ISO-2022-JP-2", "ISO2022_JP_2", Array.typed(String).new(["csISO2022JP2", "iso2022jp2"])) # historical
      charset("x-windows-50221", "MS50221", Array.typed(String).new(["ms50221", "cp50221"])) # historical
      charset("x-windows-50220", "MS50220", Array.typed(String).new(["ms50220", "cp50220"])) # historical
      charset("x-windows-iso2022jp", "MSISO2022JP", Array.typed(String).new(["windows-iso2022jp"])) # historical
      charset("x-JISAutoDetect", "JISAutoDetect", Array.typed(String).new(["JISAutoDetect"])) # JDK historical
      # Korean
      # IANA aliases
      charset("EUC-KR", "EUC_KR", Array.typed(String).new(["euc_kr", "ksc5601", "euckr", "ks_c_5601-1987", "ksc5601-1987", "ksc5601_1987", "ksc_5601", "csEUCKR", "5601"])) # JDK historical
      # IANA aliases
      charset("x-windows-949", "MS949", Array.typed(String).new(["ms949", "windows949", "windows-949", "ms_949"])) # JDK historical
      charset("x-Johab", "Johab", Array.typed(String).new(["ksc5601-1992", "ksc5601_1992", "ms1361", "johab"])) # JDK historical
      charset("ISO-2022-KR", "ISO2022_KR", Array.typed(String).new(["ISO2022KR", "csISO2022KR"])) # JDK historical
      charset("ISO-2022-CN", "ISO2022_CN", Array.typed(String).new(["ISO2022CN", "csISO2022CN"])) # JDK historical
      charset("x-ISO-2022-CN-CNS", "ISO2022_CN_CNS", Array.typed(String).new(["ISO2022CN_CNS", "ISO-2022-CN-CNS"])) # JDK historical
      charset("x-ISO-2022-CN-GB", "ISO2022_CN_GB", Array.typed(String).new(["ISO2022CN_GB", "ISO-2022-CN-GB"])) # JDK historical
      charset("x-ISCII91", "ISCII91", Array.typed(String).new(["iscii", "ST_SEV_358-88", "iso-ir-153", "csISO153GOST1976874", "ISCII91"])) # JDK historical
      charset("ISO-8859-3", "ISO_8859_3", Array.typed(String).new(["iso8859_3", "8859_3", "ISO_8859-3:1988", "iso-ir-109", "ISO_8859-3", "ISO8859-3", "latin3", "l3", "ibm913", "ibm-913", "cp913", "913", "csISOLatin3"])) # JDK historical
      charset("ISO-8859-6", "ISO_8859_6", Array.typed(String).new(["iso8859_6", "8859_6", "iso-ir-127", "ISO_8859-6", "ISO_8859-6:1987", "ISO8859-6", "ECMA-114", "ASMO-708", "arabic", "ibm1089", "ibm-1089", "cp1089", "1089", "csISOLatinArabic"])) # JDK historical
      charset("ISO-8859-8", "ISO_8859_8", Array.typed(String).new(["iso8859_8", "8859_8", "iso-ir-138", "ISO_8859-8", "ISO_8859-8:1988", "ISO8859-8", "cp916", "916", "ibm916", "ibm-916", "hebrew", "csISOLatinHebrew"]))
      charset("x-ISO-8859-11", "ISO_8859_11", Array.typed(String).new(["iso-8859-11", "iso8859_11"])) # JDK historical
      charset("TIS-620", "TIS_620", Array.typed(String).new(["tis620", "tis620.2533"])) # JDK historical
      # Various Microsoft Windows international codepages
      charset("windows-1255", "MS1255", Array.typed(String).new(["cp1255"])) # JDK historical
      charset("windows-1256", "MS1256", Array.typed(String).new(["cp1256"])) # JDK historical
      charset("windows-1258", "MS1258", Array.typed(String).new(["cp1258"])) # JDK historical
      # IBM & PC/MSDOS encodings
      charset("x-IBM942", "IBM942", Array.typed(String).new(["cp942", "ibm942", "ibm-942", "942"])) # JDK historical
      charset("x-IBM942C", "IBM942C", Array.typed(String).new(["cp942C", "ibm942C", "ibm-942C", "942C"])) # JDK historical
      charset("x-IBM943", "IBM943", Array.typed(String).new(["cp943", "ibm943", "ibm-943", "943"])) # JDK historical
      charset("x-IBM943C", "IBM943C", Array.typed(String).new(["cp943C", "ibm943C", "ibm-943C", "943C"])) # JDK historical
      charset("x-IBM948", "IBM948", Array.typed(String).new(["cp948", "ibm948", "ibm-948", "948"])) # JDK historical
      charset("x-IBM950", "IBM950", Array.typed(String).new(["cp950", "ibm950", "ibm-950", "950"])) # JDK historical
      charset("x-IBM930", "IBM930", Array.typed(String).new(["cp930", "ibm930", "ibm-930", "930"])) # JDK historical
      charset("x-IBM935", "IBM935", Array.typed(String).new(["cp935", "ibm935", "ibm-935", "935"])) # JDK historical
      charset("x-IBM937", "IBM937", Array.typed(String).new(["cp937", "ibm937", "ibm-937", "937"])) # JDK historical
      charset("x-IBM856", "IBM856", Array.typed(String).new(["cp856", "ibm-856", "ibm856", "856"])) # JDK historical
      charset("IBM860", "IBM860", Array.typed(String).new(["cp860", "ibm860", "ibm-860", "860", "csIBM860"])) # JDK historical
      charset("IBM861", "IBM861", Array.typed(String).new(["cp861", "ibm861", "ibm-861", "861", "csIBM861", "cp-is"])) # JDK historical
      charset("IBM863", "IBM863", Array.typed(String).new(["cp863", "ibm863", "ibm-863", "863", "csIBM863"])) # JDK historical
      charset("IBM864", "IBM864", Array.typed(String).new(["cp864", "ibm864", "ibm-864", "864", "csIBM864"])) # JDK historical
      charset("IBM865", "IBM865", Array.typed(String).new(["cp865", "ibm865", "ibm-865", "865", "csIBM865"])) # JDK historical
      charset("IBM868", "IBM868", Array.typed(String).new(["cp868", "ibm868", "ibm-868", "868", "cp-ar", "csIBM868"])) # JDK historical
      charset("IBM869", "IBM869", Array.typed(String).new(["cp869", "ibm869", "ibm-869", "869", "cp-gr", "csIBM869"])) # JDK historical
      charset("x-IBM921", "IBM921", Array.typed(String).new(["cp921", "ibm921", "ibm-921", "921"])) # JDK historical
      charset("x-IBM1006", "IBM1006", Array.typed(String).new(["cp1006", "ibm1006", "ibm-1006", "1006"])) # JDK historical
      charset("x-IBM1046", "IBM1046", Array.typed(String).new(["cp1046", "ibm1046", "ibm-1046", "1046"])) # JDK historical
      charset("IBM1047", "IBM1047", Array.typed(String).new(["cp1047", "ibm-1047", "1047"])) # JDK historical
      charset("x-IBM1098", "IBM1098", Array.typed(String).new(["cp1098", "ibm1098", "ibm-1098", "1098"])) # JDK historical
      charset("IBM037", "IBM037", Array.typed(String).new(["cp037", "ibm037", "ebcdic-cp-us", "ebcdic-cp-ca", "ebcdic-cp-wt", "ebcdic-cp-nl", "csIBM037", "cs-ebcdic-cp-us", "cs-ebcdic-cp-ca", "cs-ebcdic-cp-wt", "cs-ebcdic-cp-nl", "ibm-037", "ibm-37", "cpibm37", "037"])) # JDK historical
      charset("x-IBM1025", "IBM1025", Array.typed(String).new(["cp1025", "ibm1025", "ibm-1025", "1025"])) # JDK historical
      charset("IBM1026", "IBM1026", Array.typed(String).new(["cp1026", "ibm1026", "ibm-1026", "1026"])) # JDK historical
      charset("x-IBM1112", "IBM1112", Array.typed(String).new(["cp1112", "ibm1112", "ibm-1112", "1112"])) # JDK historical
      charset("x-IBM1122", "IBM1122", Array.typed(String).new(["cp1122", "ibm1122", "ibm-1122", "1122"])) # JDK historical
      charset("x-IBM1123", "IBM1123", Array.typed(String).new(["cp1123", "ibm1123", "ibm-1123", "1123"])) # JDK historical
      charset("x-IBM1124", "IBM1124", Array.typed(String).new(["cp1124", "ibm1124", "ibm-1124", "1124"])) # JDK historical
      charset("IBM273", "IBM273", Array.typed(String).new(["cp273", "ibm273", "ibm-273", "273"])) # JDK historical
      charset("IBM277", "IBM277", Array.typed(String).new(["cp277", "ibm277", "ibm-277", "277"])) # JDK historical
      charset("IBM278", "IBM278", Array.typed(String).new(["cp278", "ibm278", "ibm-278", "278", "ebcdic-sv", "ebcdic-cp-se", "csIBM278"])) # JDK historical
      charset("IBM280", "IBM280", Array.typed(String).new(["cp280", "ibm280", "ibm-280", "280"])) # JDK historical
      charset("IBM284", "IBM284", Array.typed(String).new(["cp284", "ibm284", "ibm-284", "284", "csIBM284", "cpibm284"])) # JDK historical
      charset("IBM285", "IBM285", Array.typed(String).new(["cp285", "ibm285", "ibm-285", "285", "ebcdic-cp-gb", "ebcdic-gb", "csIBM285", "cpibm285"])) # JDK historical
      charset("IBM297", "IBM297", Array.typed(String).new(["cp297", "ibm297", "ibm-297", "297", "ebcdic-cp-fr", "cpibm297", "csIBM297"])) # JDK historical
      charset("IBM420", "IBM420", Array.typed(String).new(["cp420", "ibm420", "ibm-420", "ebcdic-cp-ar1", "420", "csIBM420"])) # JDK historical
      charset("IBM424", "IBM424", Array.typed(String).new(["cp424", "ibm424", "ibm-424", "424", "ebcdic-cp-he", "csIBM424"])) # JDK historical
      charset("IBM500", "IBM500", Array.typed(String).new(["cp500", "ibm500", "ibm-500", "500", "ebcdic-cp-ch", "ebcdic-cp-bh", "csIBM500"]))
      # EBCDIC DBCS-only Korean
      charset("x-IBM834", "IBM834", Array.typed(String).new(["cp834", "ibm834", "ibm-834"])) # JDK historical
      charset("IBM-Thai", "IBM838", Array.typed(String).new(["cp838", "ibm838", "ibm-838", "838"])) # JDK historical
      charset("IBM870", "IBM870", Array.typed(String).new(["cp870", "ibm870", "ibm-870", "870", "ebcdic-cp-roece", "ebcdic-cp-yu", "csIBM870"])) # JDK historical
      charset("IBM871", "IBM871", Array.typed(String).new(["cp871", "ibm871", "ibm-871", "871", "ebcdic-cp-is", "csIBM871"])) # JDK historical
      charset("x-IBM875", "IBM875", Array.typed(String).new(["cp875", "ibm875", "ibm-875", "875"])) # JDK historical
      charset("IBM918", "IBM918", Array.typed(String).new(["cp918", "ibm-918", "918", "ebcdic-cp-ar2"])) # JDK historical
      charset("x-IBM922", "IBM922", Array.typed(String).new(["cp922", "ibm922", "ibm-922", "922"])) # JDK historical
      charset("x-IBM1097", "IBM1097", Array.typed(String).new(["cp1097", "ibm1097", "ibm-1097", "1097"])) # JDK historical
      charset("x-IBM949", "IBM949", Array.typed(String).new(["cp949", "ibm949", "ibm-949", "949"])) # JDK historical
      charset("x-IBM949C", "IBM949C", Array.typed(String).new(["cp949C", "ibm949C", "ibm-949C", "949C"])) # JDK historical
      charset("x-IBM939", "IBM939", Array.typed(String).new(["cp939", "ibm939", "ibm-939", "939"])) # JDK historical
      charset("x-IBM933", "IBM933", Array.typed(String).new(["cp933", "ibm933", "ibm-933", "933"])) # JDK historical
      charset("x-IBM1381", "IBM1381", Array.typed(String).new(["cp1381", "ibm1381", "ibm-1381", "1381"])) # JDK historical
      charset("x-IBM1383", "IBM1383", Array.typed(String).new(["cp1383", "ibm1383", "ibm-1383", "1383"])) # JDK historical
      charset("x-IBM970", "IBM970", Array.typed(String).new(["cp970", "ibm970", "ibm-970", "ibm-eucKR", "970"])) # JDK historical
      charset("x-IBM964", "IBM964", Array.typed(String).new(["cp964", "ibm964", "ibm-964", "964"])) # JDK historical # from IBM alias list # from IBM alias list
      charset("x-IBM33722", "IBM33722", Array.typed(String).new(["cp33722", "ibm33722", "ibm-33722", "ibm-5050", "ibm-33722_vascii_vpua", "33722"])) # JDK historical
      # "ebcdic-us-037+euro"
      charset("IBM01140", "IBM1140", Array.typed(String).new(["cp1140", "ccsid01140", "cp01140", "1140"])) # JDK historical
      # "ebcdic-de-273+euro"
      charset("IBM01141", "IBM1141", Array.typed(String).new(["cp1141", "ccsid01141", "cp01141", "1141"])) # JDK historical
      # "ebcdic-no-277+euro",
      # "ebcdic-dk-277+euro"
      charset("IBM01142", "IBM1142", Array.typed(String).new(["cp1142", "ccsid01142", "cp01142", "1142"])) # JDK historical
      # "ebcdic-fi-278+euro",
      # "ebcdic-se-278+euro"
      charset("IBM01143", "IBM1143", Array.typed(String).new(["cp1143", "ccsid01143", "cp01143", "1143"])) # JDK historical
      # "ebcdic-it-280+euro"
      charset("IBM01144", "IBM1144", Array.typed(String).new(["cp1144", "ccsid01144", "cp01144", "1144"])) # JDK historical
      # "ebcdic-es-284+euro"
      charset("IBM01145", "IBM1145", Array.typed(String).new(["cp1145", "ccsid01145", "cp01145", "1145"])) # JDK historical
      # "ebcdic-gb-285+euro"
      charset("IBM01146", "IBM1146", Array.typed(String).new(["cp1146", "ccsid01146", "cp01146", "1146"])) # JDK historical
      # "ebcdic-fr-277+euro"
      charset("IBM01147", "IBM1147", Array.typed(String).new(["cp1147", "ccsid01147", "cp01147", "1147"])) # JDK historical
      # "ebcdic-international-500+euro"
      charset("IBM01148", "IBM1148", Array.typed(String).new(["cp1148", "ccsid01148", "cp01148", "1148"])) # JDK historical
      # "ebcdic-s-871+euro"
      charset("IBM01149", "IBM1149", Array.typed(String).new(["cp1149", "ccsid01149", "cp01149", "1149"])) # JDK historical
      # Macintosh MacOS/Apple char encodingd
      charset("x-MacRoman", "MacRoman", Array.typed(String).new(["MacRoman"])) # JDK historical
      charset("x-MacCentralEurope", "MacCentralEurope", Array.typed(String).new(["MacCentralEurope"])) # JDK historical
      charset("x-MacCroatian", "MacCroatian", Array.typed(String).new(["MacCroatian"])) # JDK historical
      charset("x-MacGreek", "MacGreek", Array.typed(String).new(["MacGreek"])) # JDK historical
      charset("x-MacCyrillic", "MacCyrillic", Array.typed(String).new(["MacCyrillic"])) # JDK historical
      charset("x-MacUkraine", "MacUkraine", Array.typed(String).new(["MacUkraine"])) # JDK historical
      charset("x-MacTurkish", "MacTurkish", Array.typed(String).new(["MacTurkish"])) # JDK historical
      charset("x-MacArabic", "MacArabic", Array.typed(String).new(["MacArabic"])) # JDK historical
      charset("x-MacHebrew", "MacHebrew", Array.typed(String).new(["MacHebrew"])) # JDK historical
      charset("x-MacIceland", "MacIceland", Array.typed(String).new(["MacIceland"])) # JDK historical
      charset("x-MacRomania", "MacRomania", Array.typed(String).new(["MacRomania"])) # JDK historical
      charset("x-MacThai", "MacThai", Array.typed(String).new(["MacThai"])) # JDK historical
      charset("x-MacSymbol", "MacSymbol", Array.typed(String).new(["MacSymbol"])) # JDK historical
      charset("x-MacDingbat", "MacDingbat", Array.typed(String).new(["MacDingbat"]))
      self.attr_instance = self
    end
    
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    typesig { [] }
    # If the sun.nio.cs.map property is defined on the command line we won't
    # see it in the system-properties table until after the charset subsystem
    # has been initialized.  We therefore delay the effect of this property
    # until after the JRE has completely booted.
    # 
    # At the moment following values for this property are supported, property
    # value string is case insensitive.
    # 
    # (1)"Windows-31J/Shift_JIS"
    # In 1.4.1 we added a correct implementation of the Shift_JIS charset
    # but in previous releases this charset name had been treated as an alias
    # for Windows-31J, aka MS932. Users who have existing code that depends
    # upon this alias can restore the previous behavior by defining this
    # property to have this value.
    # 
    # (2)"x-windows-50221/ISO-2022-JP"
    #    "x-windows-50220/ISO-2022-JP"
    #    "x-windows-iso2022jp/ISO-2022-JP"
    # The charset ISO-2022-JP is a "standard based" implementation by default,
    # which supports ASCII, JIS_X_0201 and JIS_X_0208 mappings based encoding
    # and decoding only.
    # There are three Microsoft iso-2022-jp variants, namely x-windows-50220,
    # x-windows-50221 and x-windows-iso2022jp which behaves "slightly" differently
    # compared to the "standard based" implementation. See ISO2022_JP.java for
    # detailed description. Users who prefer the behavior of MS iso-2022-jp
    # variants should use these names explicitly instead of using "ISO-2022-JP"
    # and its aliases. However for those who need the ISO-2022-JP charset behaves
    # exactly the same as MS variants do, above properties can be defined to
    # switch.
    # 
    # If we need to define other charset-alias mappings in the future then
    # this property could be further extended, the general idea being that its
    # value should be of the form
    # 
    #     new-charset-1/old-charset-1,new-charset-2/old-charset-2,...
    # 
    # where each charset named to the left of a slash is intended to replace
    # (most) uses of the charset named to the right of the slash.
    # 
    def init
      if (@initialized)
        return
      end
      if (!Sun::Misc::VM.is_booted)
        return
      end
      map = AccessController.do_privileged(GetPropertyAction.new("sun.nio.cs.map"))
      sjis_is_ms932 = false
      iso2022jp_is_ms50221 = false
      iso2022jp_is_ms50220 = false
      iso2022jp_is_msiso2022jp = false
      if (!(map).nil?)
        maps = map.split(Regexp.new(","))
        i = 0
        while i < maps.attr_length
          if (maps[i].equals_ignore_case("Windows-31J/Shift_JIS"))
            sjis_is_ms932 = true
          else
            if (maps[i].equals_ignore_case("x-windows-50221/ISO-2022-JP"))
              iso2022jp_is_ms50221 = true
            else
              if (maps[i].equals_ignore_case("x-windows-50220/ISO-2022-JP"))
                iso2022jp_is_ms50220 = true
              else
                if (maps[i].equals_ignore_case("x-windows-iso2022jp/ISO-2022-JP"))
                  iso2022jp_is_msiso2022jp = true
                end
              end
            end
          end
          i += 1
        end
      end
      if (sjis_is_ms932)
        # IANA aliases
        # historical
        delete_charset("Shift_JIS", Array.typed(String).new(["sjis", "shift_jis", "shift-jis", "ms_kanji", "x-sjis", "csShiftJIS"])) # JDK historical
        delete_charset("windows-31j", Array.typed(String).new(["MS932", "windows-932", "csWindows31J"])) # JDK historical
        # IANA aliases
        charset("Shift_JIS", "SJIS", Array.typed(String).new(["sjis"])) # JDK historical
        # This alias takes precedence over the actual
        # Shift_JIS charset itself since aliases are always
        # resolved first, before looking up canonical names.
        charset("windows-31j", "MS932", Array.typed(String).new(["MS932", "windows-932", "csWindows31J", "shift-jis", "ms_kanji", "x-sjis", "csShiftJIS", "shift_jis"]))
      end
      if (iso2022jp_is_ms50221 || iso2022jp_is_ms50220 || iso2022jp_is_msiso2022jp)
        delete_charset("ISO-2022-JP", Array.typed(String).new(["iso2022jp", "jis", "csISO2022JP", "jis_encoding", "csjisencoding"]))
        if (iso2022jp_is_ms50221)
          delete_charset("x-windows-50221", Array.typed(String).new(["cp50221", "ms50221"]))
          charset("x-windows-50221", "MS50221", Array.typed(String).new(["cp50221", "ms50221", "iso-2022-jp", "iso2022jp", "jis", "csISO2022JP", "jis_encoding", "csjisencoding"]))
        else
          if (iso2022jp_is_ms50220)
            delete_charset("x-windows-50220", Array.typed(String).new(["cp50220", "ms50220"]))
            charset("x-windows-50220", "MS50220", Array.typed(String).new(["cp50220", "ms50220", "iso-2022-jp", "iso2022jp", "jis", "csISO2022JP", "jis_encoding", "csjisencoding"]))
          else
            delete_charset("x-windows-iso2022jp", Array.typed(String).new(["windows-iso2022jp"]))
            charset("x-windows-iso2022jp", "MSISO2022JP", Array.typed(String).new(["windows-iso2022jp", "iso-2022-jp", "iso2022jp", "jis", "csISO2022JP", "jis_encoding", "csjisencoding"]))
          end
        end
      end
      os_name = AccessController.do_privileged(GetPropertyAction.new("os.name"))
      if (("SunOS" == os_name) || ("Linux" == os_name))
        # JDK historical
        charset("x-COMPOUND_TEXT", "COMPOUND_TEXT", Array.typed(String).new(["COMPOUND_TEXT", "x11-compound_text", "x-compound-text"]))
      end
      @initialized = true
    end
    
    class_module.module_eval {
      typesig { [String] }
      def aliases_for(charset_name)
        if ((self.attr_instance).nil?)
          return nil
        end
        return self.attr_instance.aliases(charset_name)
      end
    }
    
    private
    alias_method :initialize__extended_charsets, :initialize
  end
  
end

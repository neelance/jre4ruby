require "rjava"

# Copyright 2000 Sun Microsystems, Inc.  All Rights Reserved.
# 
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
# 
# 
# -- This file was mechanically generated: Do not edit! -- //
module Sun::Nio::Cs
  module StandardCharsetsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include ::Java::Nio::Charset
    }
  end
  
  class StandardCharsets < StandardCharsetsImports.const_get :FastCharsetProvider
    include_class_members StandardCharsetsImports
    
    class_module.module_eval {
      const_set_lazy(:Aliases_US_ASCII) { Array.typed(String).new(["iso-ir-6", "ANSI_X3.4-1986", "ISO_646.irv:1991", "ASCII", "ISO646-US", "us", "IBM367", "cp367", "csASCII", "default", "646", "iso_646.irv:1983", "ANSI_X3.4-1968", "ascii7", ]) }
      const_attr_reader  :Aliases_US_ASCII
      
      const_set_lazy(:Aliases_UTF_8) { Array.typed(String).new(["UTF8", "unicode-1-1-utf-8", ]) }
      const_attr_reader  :Aliases_UTF_8
      
      const_set_lazy(:Aliases_UTF_16) { Array.typed(String).new(["UTF_16", "utf16", "unicode", "UnicodeBig", ]) }
      const_attr_reader  :Aliases_UTF_16
      
      const_set_lazy(:Aliases_UTF_16BE) { Array.typed(String).new(["UTF_16BE", "ISO-10646-UCS-2", "X-UTF-16BE", "UnicodeBigUnmarked", ]) }
      const_attr_reader  :Aliases_UTF_16BE
      
      const_set_lazy(:Aliases_UTF_16LE) { Array.typed(String).new(["UTF_16LE", "X-UTF-16LE", "UnicodeLittleUnmarked", ]) }
      const_attr_reader  :Aliases_UTF_16LE
      
      const_set_lazy(:Aliases_UTF_16LE_BOM) { Array.typed(String).new(["UnicodeLittle", ]) }
      const_attr_reader  :Aliases_UTF_16LE_BOM
      
      const_set_lazy(:Aliases_UTF_32) { Array.typed(String).new(["UTF_32", "UTF32", ]) }
      const_attr_reader  :Aliases_UTF_32
      
      const_set_lazy(:Aliases_UTF_32LE) { Array.typed(String).new(["UTF_32LE", "X-UTF-32LE", ]) }
      const_attr_reader  :Aliases_UTF_32LE
      
      const_set_lazy(:Aliases_UTF_32BE) { Array.typed(String).new(["UTF_32BE", "X-UTF-32BE", ]) }
      const_attr_reader  :Aliases_UTF_32BE
      
      const_set_lazy(:Aliases_UTF_32LE_BOM) { Array.typed(String).new(["UTF_32LE_BOM", "UTF-32LE-BOM", ]) }
      const_attr_reader  :Aliases_UTF_32LE_BOM
      
      const_set_lazy(:Aliases_UTF_32BE_BOM) { Array.typed(String).new(["UTF_32BE_BOM", "UTF-32BE-BOM", ]) }
      const_attr_reader  :Aliases_UTF_32BE_BOM
      
      const_set_lazy(:Aliases_ISO_8859_1) { Array.typed(String).new(["iso-ir-100", "ISO_8859-1", "latin1", "l1", "IBM819", "cp819", "csISOLatin1", "819", "IBM-819", "ISO8859_1", "ISO_8859-1:1987", "ISO_8859_1", "8859_1", "ISO8859-1", ]) }
      const_attr_reader  :Aliases_ISO_8859_1
      
      const_set_lazy(:Aliases_ISO_8859_2) { Array.typed(String).new(["iso8859_2", "8859_2", "iso-ir-101", "ISO_8859-2", "ISO_8859-2:1987", "ISO8859-2", "latin2", "l2", "ibm912", "ibm-912", "cp912", "912", "csISOLatin2", ]) }
      const_attr_reader  :Aliases_ISO_8859_2
      
      const_set_lazy(:Aliases_ISO_8859_4) { Array.typed(String).new(["iso8859_4", "iso8859-4", "8859_4", "iso-ir-110", "ISO_8859-4", "ISO_8859-4:1988", "latin4", "l4", "ibm914", "ibm-914", "cp914", "914", "csISOLatin4", ]) }
      const_attr_reader  :Aliases_ISO_8859_4
      
      const_set_lazy(:Aliases_ISO_8859_5) { Array.typed(String).new(["iso8859_5", "8859_5", "iso-ir-144", "ISO_8859-5", "ISO_8859-5:1988", "ISO8859-5", "cyrillic", "ibm915", "ibm-915", "cp915", "915", "csISOLatinCyrillic", ]) }
      const_attr_reader  :Aliases_ISO_8859_5
      
      const_set_lazy(:Aliases_ISO_8859_7) { Array.typed(String).new(["iso8859_7", "8859_7", "iso-ir-126", "ISO_8859-7", "ISO_8859-7:1987", "ELOT_928", "ECMA-118", "greek", "greek8", "csISOLatinGreek", "sun_eu_greek", "ibm813", "ibm-813", "813", "cp813", "iso8859-7", ]) }
      const_attr_reader  :Aliases_ISO_8859_7
      
      const_set_lazy(:Aliases_ISO_8859_9) { Array.typed(String).new(["iso8859_9", "8859_9", "iso-ir-148", "ISO_8859-9", "ISO_8859-9:1989", "ISO8859-9", "latin5", "l5", "ibm920", "ibm-920", "920", "cp920", "csISOLatin5", ]) }
      const_attr_reader  :Aliases_ISO_8859_9
      
      const_set_lazy(:Aliases_ISO_8859_13) { Array.typed(String).new(["iso8859_13", "8859_13", "iso_8859-13", "ISO8859-13", ]) }
      const_attr_reader  :Aliases_ISO_8859_13
      
      const_set_lazy(:Aliases_ISO_8859_15) { Array.typed(String).new(["ISO_8859-15", "8859_15", "ISO-8859-15", "ISO8859_15", "ISO8859-15", "IBM923", "IBM-923", "cp923", "923", "LATIN0", "LATIN9", "L9", "csISOlatin0", "csISOlatin9", "ISO8859_15_FDIS", ]) }
      const_attr_reader  :Aliases_ISO_8859_15
      
      const_set_lazy(:Aliases_KOI8_R) { Array.typed(String).new(["koi8_r", "koi8", "cskoi8r", ]) }
      const_attr_reader  :Aliases_KOI8_R
      
      const_set_lazy(:Aliases_KOI8_U) { Array.typed(String).new(["koi8_u", ]) }
      const_attr_reader  :Aliases_KOI8_U
      
      const_set_lazy(:Aliases_MS1250) { Array.typed(String).new(["cp1250", "cp5346", ]) }
      const_attr_reader  :Aliases_MS1250
      
      const_set_lazy(:Aliases_MS1251) { Array.typed(String).new(["cp1251", "cp5347", "ansi-1251", ]) }
      const_attr_reader  :Aliases_MS1251
      
      const_set_lazy(:Aliases_MS1252) { Array.typed(String).new(["cp1252", "cp5348", ]) }
      const_attr_reader  :Aliases_MS1252
      
      const_set_lazy(:Aliases_MS1253) { Array.typed(String).new(["cp1253", "cp5349", ]) }
      const_attr_reader  :Aliases_MS1253
      
      const_set_lazy(:Aliases_MS1254) { Array.typed(String).new(["cp1254", "cp5350", ]) }
      const_attr_reader  :Aliases_MS1254
      
      const_set_lazy(:Aliases_MS1257) { Array.typed(String).new(["cp1257", "cp5353", ]) }
      const_attr_reader  :Aliases_MS1257
      
      const_set_lazy(:Aliases_IBM437) { Array.typed(String).new(["cp437", "ibm437", "ibm-437", "437", "cspc8codepage437", "windows-437", ]) }
      const_attr_reader  :Aliases_IBM437
      
      const_set_lazy(:Aliases_IBM737) { Array.typed(String).new(["cp737", "ibm737", "ibm-737", "737", ]) }
      const_attr_reader  :Aliases_IBM737
      
      const_set_lazy(:Aliases_IBM775) { Array.typed(String).new(["cp775", "ibm775", "ibm-775", "775", ]) }
      const_attr_reader  :Aliases_IBM775
      
      const_set_lazy(:Aliases_IBM850) { Array.typed(String).new(["cp850", "ibm-850", "ibm850", "850", "cspc850multilingual", ]) }
      const_attr_reader  :Aliases_IBM850
      
      const_set_lazy(:Aliases_IBM852) { Array.typed(String).new(["cp852", "ibm852", "ibm-852", "852", "csPCp852", ]) }
      const_attr_reader  :Aliases_IBM852
      
      const_set_lazy(:Aliases_IBM855) { Array.typed(String).new(["cp855", "ibm-855", "ibm855", "855", "cspcp855", ]) }
      const_attr_reader  :Aliases_IBM855
      
      const_set_lazy(:Aliases_IBM857) { Array.typed(String).new(["cp857", "ibm857", "ibm-857", "857", "csIBM857", ]) }
      const_attr_reader  :Aliases_IBM857
      
      const_set_lazy(:Aliases_IBM858) { Array.typed(String).new(["cp858", "ccsid00858", "cp00858", "858", ]) }
      const_attr_reader  :Aliases_IBM858
      
      const_set_lazy(:Aliases_IBM862) { Array.typed(String).new(["cp862", "ibm862", "ibm-862", "862", "csIBM862", "cspc862latinhebrew", ]) }
      const_attr_reader  :Aliases_IBM862
      
      const_set_lazy(:Aliases_IBM866) { Array.typed(String).new(["cp866", "ibm866", "ibm-866", "866", "csIBM866", ]) }
      const_attr_reader  :Aliases_IBM866
      
      const_set_lazy(:Aliases_IBM874) { Array.typed(String).new(["cp874", "ibm874", "ibm-874", "874", ]) }
      const_attr_reader  :Aliases_IBM874
      
      const_set_lazy(:Aliases) { Class.new(Sun::Util::PreHashedMap) do
        include_class_members StandardCharsets
        
        class_module.module_eval {
          const_set_lazy(:ROWS) { 1024 }
          const_attr_reader  :ROWS
          
          const_set_lazy(:SIZE) { 208 }
          const_attr_reader  :SIZE
          
          const_set_lazy(:SHIFT) { 0 }
          const_attr_reader  :SHIFT
          
          const_set_lazy(:MASK) { 0x3ff }
          const_attr_reader  :MASK
        }
        
        typesig { [] }
        def initialize
          super(self.class::ROWS, self.class::SIZE, self.class::SHIFT, self.class::MASK)
        end
        
        typesig { [Array.typed(Object)] }
        def init(ht)
          ht[1] = Array.typed(Object).new(["csisolatin0", "iso-8859-15"])
          ht[2] = Array.typed(Object).new(["csisolatin1", "iso-8859-1"])
          ht[3] = Array.typed(Object).new(["csisolatin2", "iso-8859-2"])
          ht[5] = Array.typed(Object).new(["csisolatin4", "iso-8859-4"])
          ht[6] = Array.typed(Object).new(["csisolatin5", "iso-8859-9"])
          ht[10] = Array.typed(Object).new(["csisolatin9", "iso-8859-15"])
          ht[19] = Array.typed(Object).new(["unicodelittle", "x-utf-16le-bom"])
          ht[24] = Array.typed(Object).new(["iso646-us", "us-ascii"])
          ht[25] = Array.typed(Object).new(["iso_8859-7:1987", "iso-8859-7"])
          ht[26] = Array.typed(Object).new(["912", "iso-8859-2"])
          ht[28] = Array.typed(Object).new(["914", "iso-8859-4"])
          ht[29] = Array.typed(Object).new(["915", "iso-8859-5"])
          ht[55] = Array.typed(Object).new(["920", "iso-8859-9"])
          ht[58] = Array.typed(Object).new(["923", "iso-8859-15"])
          ht[86] = Array.typed(Object).new(["csisolatincyrillic", "iso-8859-5", Array.typed(Object).new(["8859_1", "iso-8859-1"])])
          ht[87] = Array.typed(Object).new(["8859_2", "iso-8859-2"])
          ht[89] = Array.typed(Object).new(["8859_4", "iso-8859-4"])
          ht[90] = Array.typed(Object).new(["813", "iso-8859-7", Array.typed(Object).new(["8859_5", "iso-8859-5"])])
          ht[92] = Array.typed(Object).new(["8859_7", "iso-8859-7"])
          ht[94] = Array.typed(Object).new(["8859_9", "iso-8859-9"])
          ht[95] = Array.typed(Object).new(["iso_8859-1:1987", "iso-8859-1"])
          ht[96] = Array.typed(Object).new(["819", "iso-8859-1"])
          ht[106] = Array.typed(Object).new(["unicode-1-1-utf-8", "utf-8"])
          ht[121] = Array.typed(Object).new(["x-utf-16le", "utf-16le"])
          ht[125] = Array.typed(Object).new(["ecma-118", "iso-8859-7"])
          ht[134] = Array.typed(Object).new(["koi8_r", "koi8-r"])
          ht[137] = Array.typed(Object).new(["koi8_u", "koi8-u"])
          ht[141] = Array.typed(Object).new(["cp912", "iso-8859-2"])
          ht[143] = Array.typed(Object).new(["cp914", "iso-8859-4"])
          ht[144] = Array.typed(Object).new(["cp915", "iso-8859-5"])
          ht[170] = Array.typed(Object).new(["cp920", "iso-8859-9"])
          ht[173] = Array.typed(Object).new(["cp923", "iso-8859-15"])
          ht[177] = Array.typed(Object).new(["utf_32le_bom", "x-utf-32le-bom"])
          ht[192] = Array.typed(Object).new(["utf_16be", "utf-16be"])
          ht[199] = Array.typed(Object).new(["cspc8codepage437", "ibm437", Array.typed(Object).new(["ansi-1251", "windows-1251"])])
          ht[205] = Array.typed(Object).new(["cp813", "iso-8859-7"])
          ht[211] = Array.typed(Object).new(["850", "ibm850", Array.typed(Object).new(["cp819", "iso-8859-1"])])
          ht[213] = Array.typed(Object).new(["852", "ibm852"])
          ht[216] = Array.typed(Object).new(["855", "ibm855"])
          ht[218] = Array.typed(Object).new(["857", "ibm857", Array.typed(Object).new(["iso-ir-6", "us-ascii"])])
          ht[219] = Array.typed(Object).new(["858", "ibm00858", Array.typed(Object).new(["737", "x-ibm737"])])
          ht[225] = Array.typed(Object).new(["csascii", "us-ascii"])
          ht[244] = Array.typed(Object).new(["862", "ibm862"])
          ht[248] = Array.typed(Object).new(["866", "ibm866"])
          ht[253] = Array.typed(Object).new(["x-utf-32be", "utf-32be"])
          ht[254] = Array.typed(Object).new(["iso_8859-2:1987", "iso-8859-2"])
          ht[259] = Array.typed(Object).new(["unicodebig", "utf-16"])
          ht[269] = Array.typed(Object).new(["iso8859_15_fdis", "iso-8859-15"])
          ht[277] = Array.typed(Object).new(["874", "x-ibm874"])
          ht[280] = Array.typed(Object).new(["unicodelittleunmarked", "utf-16le"])
          ht[283] = Array.typed(Object).new(["iso8859_1", "iso-8859-1"])
          ht[284] = Array.typed(Object).new(["iso8859_2", "iso-8859-2"])
          ht[286] = Array.typed(Object).new(["iso8859_4", "iso-8859-4"])
          ht[287] = Array.typed(Object).new(["iso8859_5", "iso-8859-5"])
          ht[289] = Array.typed(Object).new(["iso8859_7", "iso-8859-7"])
          ht[291] = Array.typed(Object).new(["iso8859_9", "iso-8859-9"])
          ht[294] = Array.typed(Object).new(["ibm912", "iso-8859-2"])
          ht[296] = Array.typed(Object).new(["ibm914", "iso-8859-4"])
          ht[297] = Array.typed(Object).new(["ibm915", "iso-8859-5"])
          ht[305] = Array.typed(Object).new(["iso_8859-13", "iso-8859-13"])
          ht[307] = Array.typed(Object).new(["iso_8859-15", "iso-8859-15"])
          ht[312] = Array.typed(Object).new(["greek8", "iso-8859-7", Array.typed(Object).new(["646", "us-ascii"])])
          ht[321] = Array.typed(Object).new(["ibm-912", "iso-8859-2"])
          ht[323] = Array.typed(Object).new(["ibm920", "iso-8859-9", Array.typed(Object).new(["ibm-914", "iso-8859-4"])])
          ht[324] = Array.typed(Object).new(["ibm-915", "iso-8859-5"])
          ht[325] = Array.typed(Object).new(["l1", "iso-8859-1"])
          ht[326] = Array.typed(Object).new(["cp850", "ibm850", Array.typed(Object).new(["ibm923", "iso-8859-15", Array.typed(Object).new(["l2", "iso-8859-2"])])])
          ht[327] = Array.typed(Object).new(["cyrillic", "iso-8859-5"])
          ht[328] = Array.typed(Object).new(["cp852", "ibm852", Array.typed(Object).new(["l4", "iso-8859-4"])])
          ht[329] = Array.typed(Object).new(["l5", "iso-8859-9"])
          ht[331] = Array.typed(Object).new(["cp855", "ibm855"])
          ht[333] = Array.typed(Object).new(["cp857", "ibm857", Array.typed(Object).new(["l9", "iso-8859-15"])])
          ht[334] = Array.typed(Object).new(["cp858", "ibm00858", Array.typed(Object).new(["cp737", "x-ibm737"])])
          ht[336] = Array.typed(Object).new(["iso_8859_1", "iso-8859-1"])
          ht[339] = Array.typed(Object).new(["koi8", "koi8-r"])
          ht[341] = Array.typed(Object).new(["775", "ibm775"])
          ht[345] = Array.typed(Object).new(["iso_8859-9:1989", "iso-8859-9"])
          ht[350] = Array.typed(Object).new(["ibm-920", "iso-8859-9"])
          ht[353] = Array.typed(Object).new(["ibm-923", "iso-8859-15"])
          ht[358] = Array.typed(Object).new(["ibm813", "iso-8859-7"])
          ht[359] = Array.typed(Object).new(["cp862", "ibm862"])
          ht[363] = Array.typed(Object).new(["cp866", "ibm866"])
          ht[364] = Array.typed(Object).new(["ibm819", "iso-8859-1"])
          ht[378] = Array.typed(Object).new(["ansi_x3.4-1968", "us-ascii"])
          ht[385] = Array.typed(Object).new(["ibm-813", "iso-8859-7"])
          ht[391] = Array.typed(Object).new(["ibm-819", "iso-8859-1"])
          ht[392] = Array.typed(Object).new(["cp874", "x-ibm874"])
          ht[405] = Array.typed(Object).new(["iso-ir-100", "iso-8859-1"])
          ht[406] = Array.typed(Object).new(["iso-ir-101", "iso-8859-2"])
          ht[408] = Array.typed(Object).new(["437", "ibm437"])
          ht[421] = Array.typed(Object).new(["iso-8859-15", "iso-8859-15"])
          ht[428] = Array.typed(Object).new(["latin0", "iso-8859-15"])
          ht[429] = Array.typed(Object).new(["latin1", "iso-8859-1"])
          ht[430] = Array.typed(Object).new(["latin2", "iso-8859-2"])
          ht[432] = Array.typed(Object).new(["latin4", "iso-8859-4"])
          ht[433] = Array.typed(Object).new(["latin5", "iso-8859-9"])
          ht[436] = Array.typed(Object).new(["iso-ir-110", "iso-8859-4"])
          ht[437] = Array.typed(Object).new(["latin9", "iso-8859-15"])
          ht[438] = Array.typed(Object).new(["ansi_x3.4-1986", "us-ascii"])
          ht[443] = Array.typed(Object).new(["utf-32be-bom", "x-utf-32be-bom"])
          ht[456] = Array.typed(Object).new(["cp775", "ibm775"])
          ht[473] = Array.typed(Object).new(["iso-ir-126", "iso-8859-7"])
          ht[479] = Array.typed(Object).new(["ibm850", "ibm850"])
          ht[481] = Array.typed(Object).new(["ibm852", "ibm852"])
          ht[484] = Array.typed(Object).new(["ibm855", "ibm855"])
          ht[486] = Array.typed(Object).new(["ibm857", "ibm857"])
          ht[487] = Array.typed(Object).new(["ibm737", "x-ibm737"])
          ht[502] = Array.typed(Object).new(["utf_16le", "utf-16le"])
          ht[506] = Array.typed(Object).new(["ibm-850", "ibm850"])
          ht[508] = Array.typed(Object).new(["ibm-852", "ibm852"])
          ht[511] = Array.typed(Object).new(["ibm-855", "ibm855"])
          ht[512] = Array.typed(Object).new(["ibm862", "ibm862"])
          ht[513] = Array.typed(Object).new(["ibm-857", "ibm857"])
          ht[514] = Array.typed(Object).new(["ibm-737", "x-ibm737"])
          ht[516] = Array.typed(Object).new(["ibm866", "ibm866"])
          ht[520] = Array.typed(Object).new(["unicodebigunmarked", "utf-16be"])
          ht[523] = Array.typed(Object).new(["cp437", "ibm437"])
          ht[524] = Array.typed(Object).new(["utf16", "utf-16"])
          ht[533] = Array.typed(Object).new(["iso-ir-144", "iso-8859-5"])
          ht[537] = Array.typed(Object).new(["iso-ir-148", "iso-8859-9"])
          ht[539] = Array.typed(Object).new(["ibm-862", "ibm862"])
          ht[543] = Array.typed(Object).new(["ibm-866", "ibm866"])
          ht[545] = Array.typed(Object).new(["ibm874", "x-ibm874"])
          ht[563] = Array.typed(Object).new(["x-utf-32le", "utf-32le"])
          ht[572] = Array.typed(Object).new(["ibm-874", "x-ibm874"])
          ht[573] = Array.typed(Object).new(["iso_8859-4:1988", "iso-8859-4"])
          ht[577] = Array.typed(Object).new(["default", "us-ascii"])
          ht[582] = Array.typed(Object).new(["utf32", "utf-32"])
          ht[588] = Array.typed(Object).new(["elot_928", "iso-8859-7"])
          ht[593] = Array.typed(Object).new(["csisolatingreek", "iso-8859-7"])
          ht[598] = Array.typed(Object).new(["csibm857", "ibm857"])
          ht[609] = Array.typed(Object).new(["ibm775", "ibm775"])
          ht[617] = Array.typed(Object).new(["cp1250", "windows-1250"])
          ht[618] = Array.typed(Object).new(["cp1251", "windows-1251"])
          ht[619] = Array.typed(Object).new(["cp1252", "windows-1252"])
          ht[620] = Array.typed(Object).new(["cp1253", "windows-1253"])
          ht[621] = Array.typed(Object).new(["cp1254", "windows-1254"])
          ht[624] = Array.typed(Object).new(["csibm862", "ibm862", Array.typed(Object).new(["cp1257", "windows-1257"])])
          ht[628] = Array.typed(Object).new(["csibm866", "ibm866"])
          ht[632] = Array.typed(Object).new(["iso8859_13", "iso-8859-13"])
          ht[634] = Array.typed(Object).new(["iso8859_15", "iso-8859-15", Array.typed(Object).new(["utf_32be", "utf-32be"])])
          ht[635] = Array.typed(Object).new(["utf_32be_bom", "x-utf-32be-bom"])
          ht[636] = Array.typed(Object).new(["ibm-775", "ibm775"])
          ht[654] = Array.typed(Object).new(["cp00858", "ibm00858"])
          ht[669] = Array.typed(Object).new(["8859_13", "iso-8859-13"])
          ht[670] = Array.typed(Object).new(["us", "us-ascii"])
          ht[671] = Array.typed(Object).new(["8859_15", "iso-8859-15"])
          ht[676] = Array.typed(Object).new(["ibm437", "ibm437"])
          ht[679] = Array.typed(Object).new(["cp367", "us-ascii"])
          ht[686] = Array.typed(Object).new(["iso-10646-ucs-2", "utf-16be"])
          ht[703] = Array.typed(Object).new(["ibm-437", "ibm437"])
          ht[710] = Array.typed(Object).new(["iso8859-13", "iso-8859-13"])
          ht[712] = Array.typed(Object).new(["iso8859-15", "iso-8859-15"])
          ht[732] = Array.typed(Object).new(["iso_8859-5:1988", "iso-8859-5"])
          ht[733] = Array.typed(Object).new(["unicode", "utf-16"])
          ht[768] = Array.typed(Object).new(["greek", "iso-8859-7"])
          ht[774] = Array.typed(Object).new(["ascii7", "us-ascii"])
          ht[781] = Array.typed(Object).new(["iso8859-1", "iso-8859-1"])
          ht[782] = Array.typed(Object).new(["iso8859-2", "iso-8859-2"])
          ht[783] = Array.typed(Object).new(["cskoi8r", "koi8-r"])
          ht[784] = Array.typed(Object).new(["iso8859-4", "iso-8859-4"])
          ht[785] = Array.typed(Object).new(["iso8859-5", "iso-8859-5"])
          ht[787] = Array.typed(Object).new(["iso8859-7", "iso-8859-7"])
          ht[789] = Array.typed(Object).new(["iso8859-9", "iso-8859-9"])
          ht[813] = Array.typed(Object).new(["ccsid00858", "ibm00858"])
          ht[818] = Array.typed(Object).new(["cspc862latinhebrew", "ibm862"])
          ht[832] = Array.typed(Object).new(["ibm367", "us-ascii"])
          ht[834] = Array.typed(Object).new(["iso_8859-1", "iso-8859-1"])
          ht[835] = Array.typed(Object).new(["iso_8859-2", "iso-8859-2", Array.typed(Object).new(["x-utf-16be", "utf-16be"])])
          ht[836] = Array.typed(Object).new(["sun_eu_greek", "iso-8859-7"])
          ht[837] = Array.typed(Object).new(["iso_8859-4", "iso-8859-4"])
          ht[838] = Array.typed(Object).new(["iso_8859-5", "iso-8859-5"])
          ht[840] = Array.typed(Object).new(["cspcp852", "ibm852", Array.typed(Object).new(["iso_8859-7", "iso-8859-7"])])
          ht[842] = Array.typed(Object).new(["iso_8859-9", "iso-8859-9"])
          ht[843] = Array.typed(Object).new(["cspcp855", "ibm855"])
          ht[846] = Array.typed(Object).new(["windows-437", "ibm437"])
          ht[849] = Array.typed(Object).new(["ascii", "us-ascii"])
          ht[881] = Array.typed(Object).new(["utf8", "utf-8"])
          ht[896] = Array.typed(Object).new(["iso_646.irv:1983", "us-ascii"])
          ht[909] = Array.typed(Object).new(["cp5346", "windows-1250"])
          ht[910] = Array.typed(Object).new(["cp5347", "windows-1251"])
          ht[911] = Array.typed(Object).new(["cp5348", "windows-1252"])
          ht[912] = Array.typed(Object).new(["cp5349", "windows-1253"])
          ht[925] = Array.typed(Object).new(["iso_646.irv:1991", "us-ascii"])
          ht[934] = Array.typed(Object).new(["cp5350", "windows-1254"])
          ht[937] = Array.typed(Object).new(["cp5353", "windows-1257"])
          ht[944] = Array.typed(Object).new(["utf_32le", "utf-32le"])
          ht[957] = Array.typed(Object).new(["utf_16", "utf-16"])
          ht[993] = Array.typed(Object).new(["cspc850multilingual", "ibm850"])
          ht[1009] = Array.typed(Object).new(["utf-32le-bom", "x-utf-32le-bom"])
          ht[1015] = Array.typed(Object).new(["utf_32", "utf-32"])
        end
        
        private
        alias_method :initialize__aliases, :initialize
      end }
      
      const_set_lazy(:Classes) { Class.new(Sun::Util::PreHashedMap) do
        include_class_members StandardCharsets
        
        class_module.module_eval {
          const_set_lazy(:ROWS) { 32 }
          const_attr_reader  :ROWS
          
          const_set_lazy(:SIZE) { 38 }
          const_attr_reader  :SIZE
          
          const_set_lazy(:SHIFT) { 1 }
          const_attr_reader  :SHIFT
          
          const_set_lazy(:MASK) { 0x1f }
          const_attr_reader  :MASK
        }
        
        typesig { [] }
        def initialize
          super(self.class::ROWS, self.class::SIZE, self.class::SHIFT, self.class::MASK)
        end
        
        typesig { [Array.typed(Object)] }
        def init(ht)
          ht[0] = Array.typed(Object).new(["ibm862", "IBM862"])
          ht[2] = Array.typed(Object).new(["ibm866", "IBM866", Array.typed(Object).new(["utf-32", "UTF_32", Array.typed(Object).new(["utf-16le", "UTF_16LE"])])])
          ht[3] = Array.typed(Object).new(["windows-1251", "MS1251", Array.typed(Object).new(["windows-1250", "MS1250"])])
          ht[4] = Array.typed(Object).new(["windows-1253", "MS1253", Array.typed(Object).new(["windows-1252", "MS1252", Array.typed(Object).new(["utf-32be", "UTF_32BE"])])])
          ht[5] = Array.typed(Object).new(["windows-1254", "MS1254", Array.typed(Object).new(["utf-16", "UTF_16"])])
          ht[6] = Array.typed(Object).new(["windows-1257", "MS1257"])
          ht[7] = Array.typed(Object).new(["utf-16be", "UTF_16BE"])
          ht[8] = Array.typed(Object).new(["iso-8859-2", "ISO_8859_2", Array.typed(Object).new(["iso-8859-1", "ISO_8859_1"])])
          ht[9] = Array.typed(Object).new(["iso-8859-4", "ISO_8859_4", Array.typed(Object).new(["utf-8", "UTF_8"])])
          ht[10] = Array.typed(Object).new(["iso-8859-5", "ISO_8859_5"])
          ht[11] = Array.typed(Object).new(["x-ibm874", "IBM874", Array.typed(Object).new(["iso-8859-7", "ISO_8859_7"])])
          ht[12] = Array.typed(Object).new(["iso-8859-9", "ISO_8859_9"])
          ht[14] = Array.typed(Object).new(["x-ibm737", "IBM737"])
          ht[15] = Array.typed(Object).new(["ibm850", "IBM850"])
          ht[16] = Array.typed(Object).new(["ibm852", "IBM852", Array.typed(Object).new(["ibm775", "IBM775"])])
          ht[17] = Array.typed(Object).new(["iso-8859-13", "ISO_8859_13", Array.typed(Object).new(["us-ascii", "US_ASCII"])])
          ht[18] = Array.typed(Object).new(["ibm855", "IBM855", Array.typed(Object).new(["ibm437", "IBM437", Array.typed(Object).new(["iso-8859-15", "ISO_8859_15"])])])
          ht[19] = Array.typed(Object).new(["ibm00858", "IBM858", Array.typed(Object).new(["ibm857", "IBM857", Array.typed(Object).new(["x-utf-32le-bom", "UTF_32LE_BOM"])])])
          ht[22] = Array.typed(Object).new(["x-utf-16le-bom", "UTF_16LE_BOM"])
          ht[24] = Array.typed(Object).new(["x-utf-32be-bom", "UTF_32BE_BOM"])
          ht[28] = Array.typed(Object).new(["koi8-r", "KOI8_R"])
          ht[29] = Array.typed(Object).new(["koi8-u", "KOI8_U"])
          ht[31] = Array.typed(Object).new(["utf-32le", "UTF_32LE"])
        end
        
        private
        alias_method :initialize__classes, :initialize
      end }
      
      const_set_lazy(:Cache) { Class.new(Sun::Util::PreHashedMap) do
        include_class_members StandardCharsets
        
        class_module.module_eval {
          const_set_lazy(:ROWS) { 32 }
          const_attr_reader  :ROWS
          
          const_set_lazy(:SIZE) { 38 }
          const_attr_reader  :SIZE
          
          const_set_lazy(:SHIFT) { 1 }
          const_attr_reader  :SHIFT
          
          const_set_lazy(:MASK) { 0x1f }
          const_attr_reader  :MASK
        }
        
        typesig { [] }
        def initialize
          super(self.class::ROWS, self.class::SIZE, self.class::SHIFT, self.class::MASK)
        end
        
        typesig { [Array.typed(Object)] }
        def init(ht)
          ht[0] = Array.typed(Object).new(["ibm862", nil])
          ht[2] = Array.typed(Object).new(["ibm866", nil, Array.typed(Object).new(["utf-32", nil, Array.typed(Object).new(["utf-16le", nil])])])
          ht[3] = Array.typed(Object).new(["windows-1251", nil, Array.typed(Object).new(["windows-1250", nil])])
          ht[4] = Array.typed(Object).new(["windows-1253", nil, Array.typed(Object).new(["windows-1252", nil, Array.typed(Object).new(["utf-32be", nil])])])
          ht[5] = Array.typed(Object).new(["windows-1254", nil, Array.typed(Object).new(["utf-16", nil])])
          ht[6] = Array.typed(Object).new(["windows-1257", nil])
          ht[7] = Array.typed(Object).new(["utf-16be", nil])
          ht[8] = Array.typed(Object).new(["iso-8859-2", nil, Array.typed(Object).new(["iso-8859-1", nil])])
          ht[9] = Array.typed(Object).new(["iso-8859-4", nil, Array.typed(Object).new(["utf-8", nil])])
          ht[10] = Array.typed(Object).new(["iso-8859-5", nil])
          ht[11] = Array.typed(Object).new(["x-ibm874", nil, Array.typed(Object).new(["iso-8859-7", nil])])
          ht[12] = Array.typed(Object).new(["iso-8859-9", nil])
          ht[14] = Array.typed(Object).new(["x-ibm737", nil])
          ht[15] = Array.typed(Object).new(["ibm850", nil])
          ht[16] = Array.typed(Object).new(["ibm852", nil, Array.typed(Object).new(["ibm775", nil])])
          ht[17] = Array.typed(Object).new(["iso-8859-13", nil, Array.typed(Object).new(["us-ascii", nil])])
          ht[18] = Array.typed(Object).new(["ibm855", nil, Array.typed(Object).new(["ibm437", nil, Array.typed(Object).new(["iso-8859-15", nil])])])
          ht[19] = Array.typed(Object).new(["ibm00858", nil, Array.typed(Object).new(["ibm857", nil, Array.typed(Object).new(["x-utf-32le-bom", nil])])])
          ht[22] = Array.typed(Object).new(["x-utf-16le-bom", nil])
          ht[24] = Array.typed(Object).new(["x-utf-32be-bom", nil])
          ht[28] = Array.typed(Object).new(["koi8-r", nil])
          ht[29] = Array.typed(Object).new(["koi8-u", nil])
          ht[31] = Array.typed(Object).new(["utf-32le", nil])
        end
        
        private
        alias_method :initialize__cache, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
      super("sun.nio.cs", Aliases.new, Classes.new, Cache.new)
    end
    
    private
    alias_method :initialize__standard_charsets, :initialize
  end
  
end

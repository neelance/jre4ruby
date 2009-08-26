require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module ISO_8859_2Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnmappableCharacterException
      include_const ::Sun::Nio::Cs, :StandardCharsets
      include_const ::Sun::Nio::Cs, :SingleByteDecoder
      include_const ::Sun::Nio::Cs, :SingleByteEncoder
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class ISO_8859_2 < ISO_8859_2Imports.const_get :Charset
    include_class_members ISO_8859_2Imports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("ISO-8859-2", StandardCharsets.attr_aliases_iso_8859_2)
    end
    
    typesig { [] }
    def historical_name
      return "ISO8859_2"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(ISO_8859_2)))
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    typesig { [] }
    # These accessors are temporarily supplied while sun.io
    # converters co-exist with the sun.nio.cs.{ext} charset coders
    # These facilitate sharing of conversion tables between the
    # two co-existing implementations. When sun.io converters
    # are made extinct these will be unncessary and should be removed
    def get_decoder_single_byte_mappings
      return Decoder.attr_byte_to_char_table
    end
    
    typesig { [] }
    def get_encoder_index1
      return Encoder.attr_index1
    end
    
    typesig { [] }
    def get_encoder_index2
      return Encoder.attr_index2
    end
    
    class_module.module_eval {
      # 0x78 - 0x7F
      const_set_lazy(:Decoder) { Class.new(SingleByteDecoder) do
        include_class_members ISO_8859_2
        
        typesig { [self::Charset] }
        def initialize(cs)
          super(cs, self.class::ByteToCharTable)
        end
        
        class_module.module_eval {
          # 0x80 - 0x87
          # 0x88 - 0x8F
          # 0x90 - 0x97
          # 0x98 - 0x9F
          # 0xA0 - 0xA7
          # 0xA8 - 0xAF
          # 0xB0 - 0xB7
          # 0xB8 - 0xBF
          # 0xC0 - 0xC7
          # 0xC8 - 0xCF
          # 0xD0 - 0xD7
          # 0xD8 - 0xDF
          # 0xE0 - 0xE7
          # 0xE8 - 0xEF
          # 0xF0 - 0xF7
          # 0xF8 - 0xFF
          # 0x00 - 0x07
          # 0x08 - 0x0F
          # 0x10 - 0x17
          # 0x18 - 0x1F
          # 0x20 - 0x27
          # 0x28 - 0x2F
          # 0x30 - 0x37
          # 0x38 - 0x3F
          # 0x40 - 0x47
          # 0x48 - 0x4F
          # 0x50 - 0x57
          # 0x58 - 0x5F
          # 0x60 - 0x67
          # 0x68 - 0x6F
          # 0x70 - 0x77
          const_set_lazy(:ByteToCharTable) { ("".to_u << 0x0080 << "".to_u << 0x0081 << "".to_u << 0x0082 << "".to_u << 0x0083 << "".to_u << 0x0084 << "".to_u << 0x0085 << "".to_u << 0x0086 << "".to_u << 0x0087 << "") + ("".to_u << 0x0088 << "".to_u << 0x0089 << "".to_u << 0x008A << "".to_u << 0x008B << "".to_u << 0x008C << "".to_u << 0x008D << "".to_u << 0x008E << "".to_u << 0x008F << "") + ("".to_u << 0x0090 << "".to_u << 0x0091 << "".to_u << 0x0092 << "".to_u << 0x0093 << "".to_u << 0x0094 << "".to_u << 0x0095 << "".to_u << 0x0096 << "".to_u << 0x0097 << "") + ("".to_u << 0x0098 << "".to_u << 0x0099 << "".to_u << 0x009A << "".to_u << 0x009B << "".to_u << 0x009C << "".to_u << 0x009D << "".to_u << 0x009E << "".to_u << 0x009F << "") + ("".to_u << 0x00A0 << "".to_u << 0x0104 << "".to_u << 0x02D8 << "".to_u << 0x0141 << "".to_u << 0x00A4 << "".to_u << 0x013D << "".to_u << 0x015A << "".to_u << 0x00A7 << "") + ("".to_u << 0x00A8 << "".to_u << 0x0160 << "".to_u << 0x015E << "".to_u << 0x0164 << "".to_u << 0x0179 << "".to_u << 0x00AD << "".to_u << 0x017D << "".to_u << 0x017B << "") + ("".to_u << 0x00B0 << "".to_u << 0x0105 << "".to_u << 0x02DB << "".to_u << 0x0142 << "".to_u << 0x00B4 << "".to_u << 0x013E << "".to_u << 0x015B << "".to_u << 0x02C7 << "") + ("".to_u << 0x00B8 << "".to_u << 0x0161 << "".to_u << 0x015F << "".to_u << 0x0165 << "".to_u << 0x017A << "".to_u << 0x02DD << "".to_u << 0x017E << "".to_u << 0x017C << "") + ("".to_u << 0x0154 << "".to_u << 0x00C1 << "".to_u << 0x00C2 << "".to_u << 0x0102 << "".to_u << 0x00C4 << "".to_u << 0x0139 << "".to_u << 0x0106 << "".to_u << 0x00C7 << "") + ("".to_u << 0x010C << "".to_u << 0x00C9 << "".to_u << 0x0118 << "".to_u << 0x00CB << "".to_u << 0x011A << "".to_u << 0x00CD << "".to_u << 0x00CE << "".to_u << 0x010E << "") + ("".to_u << 0x0110 << "".to_u << 0x0143 << "".to_u << 0x0147 << "".to_u << 0x00D3 << "".to_u << 0x00D4 << "".to_u << 0x0150 << "".to_u << 0x00D6 << "".to_u << 0x00D7 << "") + ("".to_u << 0x0158 << "".to_u << 0x016E << "".to_u << 0x00DA << "".to_u << 0x0170 << "".to_u << 0x00DC << "".to_u << 0x00DD << "".to_u << 0x0162 << "".to_u << 0x00DF << "") + ("".to_u << 0x0155 << "".to_u << 0x00E1 << "".to_u << 0x00E2 << "".to_u << 0x0103 << "".to_u << 0x00E4 << "".to_u << 0x013A << "".to_u << 0x0107 << "".to_u << 0x00E7 << "") + ("".to_u << 0x010D << "".to_u << 0x00E9 << "".to_u << 0x0119 << "".to_u << 0x00EB << "".to_u << 0x011B << "".to_u << 0x00ED << "".to_u << 0x00EE << "".to_u << 0x010F << "") + ("".to_u << 0x0111 << "".to_u << 0x0144 << "".to_u << 0x0148 << "".to_u << 0x00F3 << "".to_u << 0x00F4 << "".to_u << 0x0151 << "".to_u << 0x00F6 << "".to_u << 0x00F7 << "") + ("".to_u << 0x0159 << "".to_u << 0x016F << "".to_u << 0x00FA << "".to_u << 0x0171 << "".to_u << 0x00FC << "".to_u << 0x00FD << "".to_u << 0x0163 << "".to_u << 0x02D9 << "") + ("".to_u << 0x0000 << "".to_u << 0x0001 << "".to_u << 0x0002 << "".to_u << 0x0003 << "".to_u << 0x0004 << "".to_u << 0x0005 << "".to_u << 0x0006 << "".to_u << 0x0007 << "") + ("\b\t\n".to_u << 0x000B << "\f\r".to_u << 0x000E << "".to_u << 0x000F << "") + ("".to_u << 0x0010 << "".to_u << 0x0011 << "".to_u << 0x0012 << "".to_u << 0x0013 << "".to_u << 0x0014 << "".to_u << 0x0015 << "".to_u << 0x0016 << "".to_u << 0x0017 << "") + ("".to_u << 0x0018 << "".to_u << 0x0019 << "".to_u << 0x001A << "".to_u << 0x001B << "".to_u << 0x001C << "".to_u << 0x001D << "".to_u << 0x001E << "".to_u << 0x001F << "") + ("".to_u << 0x0020 << "".to_u << 0x0021 << "\"".to_u << 0x0023 << "".to_u << 0x0024 << "".to_u << 0x0025 << "".to_u << 0x0026 << "\'") + ("".to_u << 0x0028 << "".to_u << 0x0029 << "".to_u << 0x002A << "".to_u << 0x002B << "".to_u << 0x002C << "".to_u << 0x002D << "".to_u << 0x002E << "".to_u << 0x002F << "") + ("".to_u << 0x0030 << "".to_u << 0x0031 << "".to_u << 0x0032 << "".to_u << 0x0033 << "".to_u << 0x0034 << "".to_u << 0x0035 << "".to_u << 0x0036 << "".to_u << 0x0037 << "") + ("".to_u << 0x0038 << "".to_u << 0x0039 << "".to_u << 0x003A << "".to_u << 0x003B << "".to_u << 0x003C << "".to_u << 0x003D << "".to_u << 0x003E << "".to_u << 0x003F << "") + ("".to_u << 0x0040 << "".to_u << 0x0041 << "".to_u << 0x0042 << "".to_u << 0x0043 << "".to_u << 0x0044 << "".to_u << 0x0045 << "".to_u << 0x0046 << "".to_u << 0x0047 << "") + ("".to_u << 0x0048 << "".to_u << 0x0049 << "".to_u << 0x004A << "".to_u << 0x004B << "".to_u << 0x004C << "".to_u << 0x004D << "".to_u << 0x004E << "".to_u << 0x004F << "") + ("".to_u << 0x0050 << "".to_u << 0x0051 << "".to_u << 0x0052 << "".to_u << 0x0053 << "".to_u << 0x0054 << "".to_u << 0x0055 << "".to_u << 0x0056 << "".to_u << 0x0057 << "") + ("".to_u << 0x0058 << "".to_u << 0x0059 << "".to_u << 0x005A << "".to_u << 0x005B << "\\\u005D".to_u << 0x005E << "".to_u << 0x005F << "") + ("".to_u << 0x0060 << "".to_u << 0x0061 << "".to_u << 0x0062 << "".to_u << 0x0063 << "".to_u << 0x0064 << "".to_u << 0x0065 << "".to_u << 0x0066 << "".to_u << 0x0067 << "") + ("".to_u << 0x0068 << "".to_u << 0x0069 << "".to_u << 0x006A << "".to_u << 0x006B << "".to_u << 0x006C << "".to_u << 0x006D << "".to_u << 0x006E << "".to_u << 0x006F << "") + ("".to_u << 0x0070 << "".to_u << 0x0071 << "".to_u << 0x0072 << "".to_u << 0x0073 << "".to_u << 0x0074 << "".to_u << 0x0075 << "".to_u << 0x0076 << "".to_u << 0x0077 << "") + ("".to_u << 0x0078 << "".to_u << 0x0079 << "".to_u << 0x007A << "".to_u << 0x007B << "".to_u << 0x007C << "".to_u << 0x007D << "".to_u << 0x007E << "".to_u << 0x007F << "") }
          const_attr_reader  :ByteToCharTable
        }
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(SingleByteEncoder) do
        include_class_members ISO_8859_2
        
        typesig { [self::Charset] }
        def initialize(cs)
          super(cs, self.class::Index1, self.class::Index2, 0xff00, 0xff, 8)
        end
        
        class_module.module_eval {
          const_set_lazy(:Index2) { ("".to_u << 0x0000 << "".to_u << 0x0001 << "".to_u << 0x0002 << "".to_u << 0x0003 << "".to_u << 0x0004 << "".to_u << 0x0005 << "".to_u << 0x0006 << "".to_u << 0x0007 << "") + ("\b\t\n".to_u << 0x000B << "\f\r".to_u << 0x000E << "".to_u << 0x000F << "") + ("".to_u << 0x0010 << "".to_u << 0x0011 << "".to_u << 0x0012 << "".to_u << 0x0013 << "".to_u << 0x0014 << "".to_u << 0x0015 << "".to_u << 0x0016 << "".to_u << 0x0017 << "") + ("".to_u << 0x0018 << "".to_u << 0x0019 << "".to_u << 0x001A << "".to_u << 0x001B << "".to_u << 0x001C << "".to_u << 0x001D << "".to_u << 0x001E << "".to_u << 0x001F << "") + ("".to_u << 0x0020 << "".to_u << 0x0021 << "\"".to_u << 0x0023 << "".to_u << 0x0024 << "".to_u << 0x0025 << "".to_u << 0x0026 << "\'") + ("".to_u << 0x0028 << "".to_u << 0x0029 << "".to_u << 0x002A << "".to_u << 0x002B << "".to_u << 0x002C << "".to_u << 0x002D << "".to_u << 0x002E << "".to_u << 0x002F << "") + ("".to_u << 0x0030 << "".to_u << 0x0031 << "".to_u << 0x0032 << "".to_u << 0x0033 << "".to_u << 0x0034 << "".to_u << 0x0035 << "".to_u << 0x0036 << "".to_u << 0x0037 << "") + ("".to_u << 0x0038 << "".to_u << 0x0039 << "".to_u << 0x003A << "".to_u << 0x003B << "".to_u << 0x003C << "".to_u << 0x003D << "".to_u << 0x003E << "".to_u << 0x003F << "") + ("".to_u << 0x0040 << "".to_u << 0x0041 << "".to_u << 0x0042 << "".to_u << 0x0043 << "".to_u << 0x0044 << "".to_u << 0x0045 << "".to_u << 0x0046 << "".to_u << 0x0047 << "") + ("".to_u << 0x0048 << "".to_u << 0x0049 << "".to_u << 0x004A << "".to_u << 0x004B << "".to_u << 0x004C << "".to_u << 0x004D << "".to_u << 0x004E << "".to_u << 0x004F << "") + ("".to_u << 0x0050 << "".to_u << 0x0051 << "".to_u << 0x0052 << "".to_u << 0x0053 << "".to_u << 0x0054 << "".to_u << 0x0055 << "".to_u << 0x0056 << "".to_u << 0x0057 << "") + ("".to_u << 0x0058 << "".to_u << 0x0059 << "".to_u << 0x005A << "".to_u << 0x005B << "\\\u005D".to_u << 0x005E << "".to_u << 0x005F << "") + ("".to_u << 0x0060 << "".to_u << 0x0061 << "".to_u << 0x0062 << "".to_u << 0x0063 << "".to_u << 0x0064 << "".to_u << 0x0065 << "".to_u << 0x0066 << "".to_u << 0x0067 << "") + ("".to_u << 0x0068 << "".to_u << 0x0069 << "".to_u << 0x006A << "".to_u << 0x006B << "".to_u << 0x006C << "".to_u << 0x006D << "".to_u << 0x006E << "".to_u << 0x006F << "") + ("".to_u << 0x0070 << "".to_u << 0x0071 << "".to_u << 0x0072 << "".to_u << 0x0073 << "".to_u << 0x0074 << "".to_u << 0x0075 << "".to_u << 0x0076 << "".to_u << 0x0077 << "") + ("".to_u << 0x0078 << "".to_u << 0x0079 << "".to_u << 0x007A << "".to_u << 0x007B << "".to_u << 0x007C << "".to_u << 0x007D << "".to_u << 0x007E << "".to_u << 0x007F << "") + ("".to_u << 0x0080 << "".to_u << 0x0081 << "".to_u << 0x0082 << "".to_u << 0x0083 << "".to_u << 0x0084 << "".to_u << 0x0085 << "".to_u << 0x0086 << "".to_u << 0x0087 << "") + ("".to_u << 0x0088 << "".to_u << 0x0089 << "".to_u << 0x008A << "".to_u << 0x008B << "".to_u << 0x008C << "".to_u << 0x008D << "".to_u << 0x008E << "".to_u << 0x008F << "") + ("".to_u << 0x0090 << "".to_u << 0x0091 << "".to_u << 0x0092 << "".to_u << 0x0093 << "".to_u << 0x0094 << "".to_u << 0x0095 << "".to_u << 0x0096 << "".to_u << 0x0097 << "") + ("".to_u << 0x0098 << "".to_u << 0x0099 << "".to_u << 0x009A << "".to_u << 0x009B << "".to_u << 0x009C << "".to_u << 0x009D << "".to_u << 0x009E << "".to_u << 0x009F << "") + ("".to_u << 0x00A0 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00A4 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00A7 << "") + ("".to_u << 0x00A8 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00AD << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x00B0 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00B4 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x00B8 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x00C1 << "".to_u << 0x00C2 << "".to_u << 0x0000 << "".to_u << 0x00C4 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00C7 << "") + ("".to_u << 0x0000 << "".to_u << 0x00C9 << "".to_u << 0x0000 << "".to_u << 0x00CB << "".to_u << 0x0000 << "".to_u << 0x00CD << "".to_u << 0x00CE << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00D3 << "".to_u << 0x00D4 << "".to_u << 0x0000 << "".to_u << 0x00D6 << "".to_u << 0x00D7 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00DA << "".to_u << 0x0000 << "".to_u << 0x00DC << "".to_u << 0x00DD << "".to_u << 0x0000 << "".to_u << 0x00DF << "") + ("".to_u << 0x0000 << "".to_u << 0x00E1 << "".to_u << 0x00E2 << "".to_u << 0x0000 << "".to_u << 0x00E4 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00E7 << "") + ("".to_u << 0x0000 << "".to_u << 0x00E9 << "".to_u << 0x0000 << "".to_u << 0x00EB << "".to_u << 0x0000 << "".to_u << 0x00ED << "".to_u << 0x00EE << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00F3 << "".to_u << 0x00F4 << "".to_u << 0x0000 << "".to_u << 0x00F6 << "".to_u << 0x00F7 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00FA << "".to_u << 0x0000 << "".to_u << 0x00FC << "".to_u << 0x00FD << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x00C3 << "".to_u << 0x00E3 << "".to_u << 0x00A1 << "".to_u << 0x00B1 << "".to_u << 0x00C6 << "".to_u << 0x00E6 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00C8 << "".to_u << 0x00E8 << "".to_u << 0x00CF << "".to_u << 0x00EF << "".to_u << 0x00D0 << "".to_u << 0x00F0 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00CA << "".to_u << 0x00EA << "") + ("".to_u << 0x00CC << "".to_u << 0x00EC << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00C5 << "") + ("".to_u << 0x00E5 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00A5 << "".to_u << 0x00B5 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00A3 << "") + ("".to_u << 0x00B3 << "".to_u << 0x00D1 << "".to_u << 0x00F1 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00D2 << "".to_u << 0x00F2 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00D5 << "".to_u << 0x00F5 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00C0 << "".to_u << 0x00E0 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00D8 << "".to_u << 0x00F8 << "") + ("".to_u << 0x00A6 << "".to_u << 0x00B6 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00AA << "".to_u << 0x00BA << "".to_u << 0x00A9 << "".to_u << 0x00B9 << "") + ("".to_u << 0x00DE << "".to_u << 0x00FE << "".to_u << 0x00AB << "".to_u << 0x00BB << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00D9 << "".to_u << 0x00F9 << "".to_u << 0x00DB << "".to_u << 0x00FB << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00AC << "") + ("".to_u << 0x00BC << "".to_u << 0x00AF << "".to_u << 0x00BF << "".to_u << 0x00AE << "".to_u << 0x00BE << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00B7 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00A2 << "".to_u << 0x00FF << "") + ("".to_u << 0x0000 << "".to_u << 0x00B2 << "".to_u << 0x0000 << "".to_u << 0x00BD << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") }
          const_attr_reader  :Index2
          
          const_set_lazy(:Index1) { Array.typed(::Java::Short).new([0, 254, 438, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, 381, ]) }
          const_attr_reader  :Index1
        }
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso_8859_2, :initialize
  end
  
end

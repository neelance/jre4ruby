require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MS874Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Sun::Nio::Cs, :SingleByteEncoder
      include_const ::Sun::Nio::Cs, :SingleByteDecoder
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  class MS874 < MS874Imports.const_get :Charset
    include_class_members MS874Imports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [] }
    def initialize
      super("x-windows-874", ExtendedCharsets.aliases_for("x-windows-874"))
    end
    
    typesig { [] }
    def historical_name
      return "MS874"
    end
    
    typesig { [Charset] }
    def contains(cs)
      return (((cs.name == "US-ASCII")) || (cs.is_a?(MS874)))
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
        include_class_members MS874
        
        typesig { [class_self::Charset] }
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
          const_set_lazy(:ByteToCharTable) { ("".to_u << 0x20AC << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0x2026 << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "") + ("".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "") + ("".to_u << 0xFFFD << "".to_u << 0x2018 << "".to_u << 0x2019 << "".to_u << 0x201C << "".to_u << 0x201D << "".to_u << 0x2022 << "".to_u << 0x2013 << "".to_u << 0x2014 << "") + ("".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "") + ("".to_u << 0x00A0 << "".to_u << 0x0E01 << "".to_u << 0x0E02 << "".to_u << 0x0E03 << "".to_u << 0x0E04 << "".to_u << 0x0E05 << "".to_u << 0x0E06 << "".to_u << 0x0E07 << "") + ("".to_u << 0x0E08 << "".to_u << 0x0E09 << "".to_u << 0x0E0A << "".to_u << 0x0E0B << "".to_u << 0x0E0C << "".to_u << 0x0E0D << "".to_u << 0x0E0E << "".to_u << 0x0E0F << "") + ("".to_u << 0x0E10 << "".to_u << 0x0E11 << "".to_u << 0x0E12 << "".to_u << 0x0E13 << "".to_u << 0x0E14 << "".to_u << 0x0E15 << "".to_u << 0x0E16 << "".to_u << 0x0E17 << "") + ("".to_u << 0x0E18 << "".to_u << 0x0E19 << "".to_u << 0x0E1A << "".to_u << 0x0E1B << "".to_u << 0x0E1C << "".to_u << 0x0E1D << "".to_u << 0x0E1E << "".to_u << 0x0E1F << "") + ("".to_u << 0x0E20 << "".to_u << 0x0E21 << "".to_u << 0x0E22 << "".to_u << 0x0E23 << "".to_u << 0x0E24 << "".to_u << 0x0E25 << "".to_u << 0x0E26 << "".to_u << 0x0E27 << "") + ("".to_u << 0x0E28 << "".to_u << 0x0E29 << "".to_u << 0x0E2A << "".to_u << 0x0E2B << "".to_u << 0x0E2C << "".to_u << 0x0E2D << "".to_u << 0x0E2E << "".to_u << 0x0E2F << "") + ("".to_u << 0x0E30 << "".to_u << 0x0E31 << "".to_u << 0x0E32 << "".to_u << 0x0E33 << "".to_u << 0x0E34 << "".to_u << 0x0E35 << "".to_u << 0x0E36 << "".to_u << 0x0E37 << "") + ("".to_u << 0x0E38 << "".to_u << 0x0E39 << "".to_u << 0x0E3A << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0x0E3F << "") + ("".to_u << 0x0E40 << "".to_u << 0x0E41 << "".to_u << 0x0E42 << "".to_u << 0x0E43 << "".to_u << 0x0E44 << "".to_u << 0x0E45 << "".to_u << 0x0E46 << "".to_u << 0x0E47 << "") + ("".to_u << 0x0E48 << "".to_u << 0x0E49 << "".to_u << 0x0E4A << "".to_u << 0x0E4B << "".to_u << 0x0E4C << "".to_u << 0x0E4D << "".to_u << 0x0E4E << "".to_u << 0x0E4F << "") + ("".to_u << 0x0E50 << "".to_u << 0x0E51 << "".to_u << 0x0E52 << "".to_u << 0x0E53 << "".to_u << 0x0E54 << "".to_u << 0x0E55 << "".to_u << 0x0E56 << "".to_u << 0x0E57 << "") + ("".to_u << 0x0E58 << "".to_u << 0x0E59 << "".to_u << 0x0E5A << "".to_u << 0x0E5B << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "".to_u << 0xFFFD << "") + ("".to_u << 0x0000 << "".to_u << 0x0001 << "".to_u << 0x0002 << "".to_u << 0x0003 << "".to_u << 0x0004 << "".to_u << 0x0005 << "".to_u << 0x0006 << "".to_u << 0x0007 << "") + ("\b\t\n".to_u << 0x000B << "\f\r".to_u << 0x000E << "".to_u << 0x000F << "") + ("".to_u << 0x0010 << "".to_u << 0x0011 << "".to_u << 0x0012 << "".to_u << 0x0013 << "".to_u << 0x0014 << "".to_u << 0x0015 << "".to_u << 0x0016 << "".to_u << 0x0017 << "") + ("".to_u << 0x0018 << "".to_u << 0x0019 << "".to_u << 0x001A << "".to_u << 0x001B << "".to_u << 0x001C << "".to_u << 0x001D << "".to_u << 0x001E << "".to_u << 0x001F << "") + ("".to_u << 0x0020 << "".to_u << 0x0021 << "\"".to_u << 0x0023 << "".to_u << 0x0024 << "".to_u << 0x0025 << "".to_u << 0x0026 << "\'") + ("".to_u << 0x0028 << "".to_u << 0x0029 << "".to_u << 0x002A << "".to_u << 0x002B << "".to_u << 0x002C << "".to_u << 0x002D << "".to_u << 0x002E << "".to_u << 0x002F << "") + ("".to_u << 0x0030 << "".to_u << 0x0031 << "".to_u << 0x0032 << "".to_u << 0x0033 << "".to_u << 0x0034 << "".to_u << 0x0035 << "".to_u << 0x0036 << "".to_u << 0x0037 << "") + ("".to_u << 0x0038 << "".to_u << 0x0039 << "".to_u << 0x003A << "".to_u << 0x003B << "".to_u << 0x003C << "".to_u << 0x003D << "".to_u << 0x003E << "".to_u << 0x003F << "") + ("".to_u << 0x0040 << "".to_u << 0x0041 << "".to_u << 0x0042 << "".to_u << 0x0043 << "".to_u << 0x0044 << "".to_u << 0x0045 << "".to_u << 0x0046 << "".to_u << 0x0047 << "") + ("".to_u << 0x0048 << "".to_u << 0x0049 << "".to_u << 0x004A << "".to_u << 0x004B << "".to_u << 0x004C << "".to_u << 0x004D << "".to_u << 0x004E << "".to_u << 0x004F << "") + ("".to_u << 0x0050 << "".to_u << 0x0051 << "".to_u << 0x0052 << "".to_u << 0x0053 << "".to_u << 0x0054 << "".to_u << 0x0055 << "".to_u << 0x0056 << "".to_u << 0x0057 << "") + ("".to_u << 0x0058 << "".to_u << 0x0059 << "".to_u << 0x005A << "".to_u << 0x005B << "\\\u005D".to_u << 0x005E << "".to_u << 0x005F << "") + ("".to_u << 0x0060 << "".to_u << 0x0061 << "".to_u << 0x0062 << "".to_u << 0x0063 << "".to_u << 0x0064 << "".to_u << 0x0065 << "".to_u << 0x0066 << "".to_u << 0x0067 << "") + ("".to_u << 0x0068 << "".to_u << 0x0069 << "".to_u << 0x006A << "".to_u << 0x006B << "".to_u << 0x006C << "".to_u << 0x006D << "".to_u << 0x006E << "".to_u << 0x006F << "") + ("".to_u << 0x0070 << "".to_u << 0x0071 << "".to_u << 0x0072 << "".to_u << 0x0073 << "".to_u << 0x0074 << "".to_u << 0x0075 << "".to_u << 0x0076 << "".to_u << 0x0077 << "") + ("".to_u << 0x0078 << "".to_u << 0x0079 << "".to_u << 0x007A << "".to_u << 0x007B << "".to_u << 0x007C << "".to_u << 0x007D << "".to_u << 0x007E << "".to_u << 0x007F << "") }
          const_attr_reader  :ByteToCharTable
        }
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(SingleByteEncoder) do
        include_class_members MS874
        
        typesig { [class_self::Charset] }
        def initialize(cs)
          super(cs, self.class::Index1, self.class::Index2, 0xff00, 0xff, 8)
        end
        
        class_module.module_eval {
          const_set_lazy(:Index2) { ("".to_u << 0x0000 << "".to_u << 0x0001 << "".to_u << 0x0002 << "".to_u << 0x0003 << "".to_u << 0x0004 << "".to_u << 0x0005 << "".to_u << 0x0006 << "".to_u << 0x0007 << "") + ("\b\t\n".to_u << 0x000B << "\f\r".to_u << 0x000E << "".to_u << 0x000F << "") + ("".to_u << 0x0010 << "".to_u << 0x0011 << "".to_u << 0x0012 << "".to_u << 0x0013 << "".to_u << 0x0014 << "".to_u << 0x0015 << "".to_u << 0x0016 << "".to_u << 0x0017 << "") + ("".to_u << 0x0018 << "".to_u << 0x0019 << "".to_u << 0x001A << "".to_u << 0x001B << "".to_u << 0x001C << "".to_u << 0x001D << "".to_u << 0x001E << "".to_u << 0x001F << "") + ("".to_u << 0x0020 << "".to_u << 0x0021 << "\"".to_u << 0x0023 << "".to_u << 0x0024 << "".to_u << 0x0025 << "".to_u << 0x0026 << "\'") + ("".to_u << 0x0028 << "".to_u << 0x0029 << "".to_u << 0x002A << "".to_u << 0x002B << "".to_u << 0x002C << "".to_u << 0x002D << "".to_u << 0x002E << "".to_u << 0x002F << "") + ("".to_u << 0x0030 << "".to_u << 0x0031 << "".to_u << 0x0032 << "".to_u << 0x0033 << "".to_u << 0x0034 << "".to_u << 0x0035 << "".to_u << 0x0036 << "".to_u << 0x0037 << "") + ("".to_u << 0x0038 << "".to_u << 0x0039 << "".to_u << 0x003A << "".to_u << 0x003B << "".to_u << 0x003C << "".to_u << 0x003D << "".to_u << 0x003E << "".to_u << 0x003F << "") + ("".to_u << 0x0040 << "".to_u << 0x0041 << "".to_u << 0x0042 << "".to_u << 0x0043 << "".to_u << 0x0044 << "".to_u << 0x0045 << "".to_u << 0x0046 << "".to_u << 0x0047 << "") + ("".to_u << 0x0048 << "".to_u << 0x0049 << "".to_u << 0x004A << "".to_u << 0x004B << "".to_u << 0x004C << "".to_u << 0x004D << "".to_u << 0x004E << "".to_u << 0x004F << "") + ("".to_u << 0x0050 << "".to_u << 0x0051 << "".to_u << 0x0052 << "".to_u << 0x0053 << "".to_u << 0x0054 << "".to_u << 0x0055 << "".to_u << 0x0056 << "".to_u << 0x0057 << "") + ("".to_u << 0x0058 << "".to_u << 0x0059 << "".to_u << 0x005A << "".to_u << 0x005B << "\\\u005D".to_u << 0x005E << "".to_u << 0x005F << "") + ("".to_u << 0x0060 << "".to_u << 0x0061 << "".to_u << 0x0062 << "".to_u << 0x0063 << "".to_u << 0x0064 << "".to_u << 0x0065 << "".to_u << 0x0066 << "".to_u << 0x0067 << "") + ("".to_u << 0x0068 << "".to_u << 0x0069 << "".to_u << 0x006A << "".to_u << 0x006B << "".to_u << 0x006C << "".to_u << 0x006D << "".to_u << 0x006E << "".to_u << 0x006F << "") + ("".to_u << 0x0070 << "".to_u << 0x0071 << "".to_u << 0x0072 << "".to_u << 0x0073 << "".to_u << 0x0074 << "".to_u << 0x0075 << "".to_u << 0x0076 << "".to_u << 0x0077 << "") + ("".to_u << 0x0078 << "".to_u << 0x0079 << "".to_u << 0x007A << "".to_u << 0x007B << "".to_u << 0x007C << "".to_u << 0x007D << "".to_u << 0x007E << "".to_u << 0x007F << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x00A0 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x00A1 << "".to_u << 0x00A2 << "".to_u << 0x00A3 << "".to_u << 0x00A4 << "".to_u << 0x00A5 << "".to_u << 0x00A6 << "".to_u << 0x00A7 << "") + ("".to_u << 0x00A8 << "".to_u << 0x00A9 << "".to_u << 0x00AA << "".to_u << 0x00AB << "".to_u << 0x00AC << "".to_u << 0x00AD << "".to_u << 0x00AE << "".to_u << 0x00AF << "") + ("".to_u << 0x00B0 << "".to_u << 0x00B1 << "".to_u << 0x00B2 << "".to_u << 0x00B3 << "".to_u << 0x00B4 << "".to_u << 0x00B5 << "".to_u << 0x00B6 << "".to_u << 0x00B7 << "") + ("".to_u << 0x00B8 << "".to_u << 0x00B9 << "".to_u << 0x00BA << "".to_u << 0x00BB << "".to_u << 0x00BC << "".to_u << 0x00BD << "".to_u << 0x00BE << "".to_u << 0x00BF << "") + ("".to_u << 0x00C0 << "".to_u << 0x00C1 << "".to_u << 0x00C2 << "".to_u << 0x00C3 << "".to_u << 0x00C4 << "".to_u << 0x00C5 << "".to_u << 0x00C6 << "".to_u << 0x00C7 << "") + ("".to_u << 0x00C8 << "".to_u << 0x00C9 << "".to_u << 0x00CA << "".to_u << 0x00CB << "".to_u << 0x00CC << "".to_u << 0x00CD << "".to_u << 0x00CE << "".to_u << 0x00CF << "") + ("".to_u << 0x00D0 << "".to_u << 0x00D1 << "".to_u << 0x00D2 << "".to_u << 0x00D3 << "".to_u << 0x00D4 << "".to_u << 0x00D5 << "".to_u << 0x00D6 << "".to_u << 0x00D7 << "") + ("".to_u << 0x00D8 << "".to_u << 0x00D9 << "".to_u << 0x00DA << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x00DF << "") + ("".to_u << 0x00E0 << "".to_u << 0x00E1 << "".to_u << 0x00E2 << "".to_u << 0x00E3 << "".to_u << 0x00E4 << "".to_u << 0x00E5 << "".to_u << 0x00E6 << "".to_u << 0x00E7 << "") + ("".to_u << 0x00E8 << "".to_u << 0x00E9 << "".to_u << 0x00EA << "".to_u << 0x00EB << "".to_u << 0x00EC << "".to_u << 0x00ED << "".to_u << 0x00EE << "".to_u << 0x00EF << "") + ("".to_u << 0x00F0 << "".to_u << 0x00F1 << "".to_u << 0x00F2 << "".to_u << 0x00F3 << "".to_u << 0x00F4 << "".to_u << 0x00F5 << "".to_u << 0x00F6 << "".to_u << 0x00F7 << "") + ("".to_u << 0x00F8 << "".to_u << 0x00F9 << "".to_u << 0x00FA << "".to_u << 0x00FB << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0096 << "".to_u << 0x0097 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0091 << "".to_u << 0x0092 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0093 << "".to_u << 0x0094 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0095 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0085 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0080 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") }
          const_attr_reader  :Index2
          
          const_set_lazy(:Index1) { Array.typed(::Java::Short).new([0, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 416, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 653, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161]) }
          const_attr_reader  :Index1
        }
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__ms874, :initialize
  end
  
end

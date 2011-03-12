require "rjava"

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
# /*
#  ******************************************************************************
#  * Copyright (C) 2003, International Business Machines Corporation and   *
#  * others. All Rights Reserved.                                               *
#  ******************************************************************************
#  *
#  * Created on May 2, 2003
#  *
#  * To change the template for this generated file go to
#  * Window>Preferences>Java>Code Generation>Code and Comments
# CHANGELOG
#      2005-05-19 Edward Wang
#          - copy this file from icu4jsrc_3_2/src/com/ibm/icu/impl/StringPrepDataReader.java
#          - move from package com.ibm.icu.impl to package sun.net.idn
# 
module Sun::Net::Idn
  module StringPrepDataReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Idn
      include_const ::Java::Io, :DataInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Sun::Text::Normalizer, :ICUBinary
    }
  end
  
  # @author ram
  # 
  # To change the template for this generated type comment go to
  # Window>Preferences>Java>Code Generation>Code and Comments
  class StringPrepDataReader 
    include_class_members StringPrepDataReaderImports
    include ICUBinary::Authenticate
    
    typesig { [InputStream] }
    # <p>private constructor.</p>
    # @param inputStream ICU uprop.dat file input stream
    # @exception IOException throw if data file fails authentication
    # @draft 2.1
    def initialize(input_stream)
      @data_input_stream = nil
      @unicode_version = nil
      @unicode_version = ICUBinary.read_header(input_stream, DATA_FORMAT_ID, self)
      @data_input_stream = DataInputStream.new(input_stream)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Char)] }
    def read(idna_bytes, mapping_table)
      # Read the bytes that make up the idnaTrie
      @data_input_stream.read(idna_bytes)
      # Read the extra data
      i = 0
      while i < mapping_table.attr_length
        mapping_table[i] = @data_input_stream.read_char
        i += 1
      end
    end
    
    typesig { [] }
    def get_data_format_version
      return DATA_FORMAT_VERSION
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def is_data_version_acceptable(version)
      return (version[0]).equal?(DATA_FORMAT_VERSION[0]) && (version[2]).equal?(DATA_FORMAT_VERSION[2]) && (version[3]).equal?(DATA_FORMAT_VERSION[3])
    end
    
    typesig { [::Java::Int] }
    def read_indexes(length)
      indexes = Array.typed(::Java::Int).new(length) { 0 }
      # Read the indexes
      i = 0
      while i < length
        indexes[i] = @data_input_stream.read_int
        i += 1
      end
      return indexes
    end
    
    typesig { [] }
    def get_unicode_version
      return @unicode_version
    end
    
    # private data members -------------------------------------------------
    # ICU data file input stream
    attr_accessor :data_input_stream
    alias_method :attr_data_input_stream, :data_input_stream
    undef_method :data_input_stream
    alias_method :attr_data_input_stream=, :data_input_stream=
    undef_method :data_input_stream=
    
    attr_accessor :unicode_version
    alias_method :attr_unicode_version, :unicode_version
    undef_method :unicode_version
    alias_method :attr_unicode_version=, :unicode_version=
    undef_method :unicode_version=
    
    class_module.module_eval {
      # File format version that this class understands.
      # No guarantees are made if a older version is used
      # see store.c of gennorm for more information and values
      # /* dataFormat="SPRP" 0x53, 0x50, 0x52, 0x50  */
      const_set_lazy(:DATA_FORMAT_ID) { Array.typed(::Java::Byte).new([0x53, 0x50, 0x52, 0x50]) }
      const_attr_reader  :DATA_FORMAT_ID
      
      const_set_lazy(:DATA_FORMAT_VERSION) { Array.typed(::Java::Byte).new([0x3, 0x2, 0x5, 0x2]) }
      const_attr_reader  :DATA_FORMAT_VERSION
    }
    
    private
    alias_method :initialize__string_prep_data_reader, :initialize
  end
  
end

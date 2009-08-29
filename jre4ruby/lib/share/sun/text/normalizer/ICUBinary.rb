require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module ICUBinaryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :DataInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Arrays
    }
  end
  
  class ICUBinary 
    include_class_members ICUBinaryImports
    
    class_module.module_eval {
      # public inner interface ------------------------------------------------
      # 
      # Special interface for data authentication
      const_set_lazy(:Authenticate) { Module.new do
        include_class_members ICUBinary
        
        typesig { [Array.typed(::Java::Byte)] }
        # Method used in ICUBinary.readHeader() to provide data format
        # authentication.
        # @param version version of the current data
        # @return true if dataformat is an acceptable version, false otherwise
        def is_data_version_acceptable(version)
          raise NotImplementedError
        end
      end }
      
      typesig { [InputStream, Array.typed(::Java::Byte), Authenticate] }
      # public methods --------------------------------------------------------
      # 
      # <p>ICU data header reader method.
      # Takes a ICU generated big-endian input stream, parse the ICU standard
      # file header and authenticates them.</p>
      # <p>Header format:
      # <ul>
      # <li> Header size (char)
      # <li> Magic number 1 (byte)
      # <li> Magic number 2 (byte)
      # <li> Rest of the header size (char)
      # <li> Reserved word (char)
      # <li> Big endian indicator (byte)
      # <li> Character set family indicator (byte)
      # <li> Size of a char (byte) for c++ and c use
      # <li> Reserved byte (byte)
      # <li> Data format identifier (4 bytes), each ICU data has its own
      # identifier to distinguish them. [0] major [1] minor
      # [2] milli [3] micro
      # <li> Data version (4 bytes), the change version of the ICU data
      # [0] major [1] minor [2] milli [3] micro
      # <li> Unicode version (4 bytes) this ICU is based on.
      # </ul>
      # </p>
      # <p>
      # Example of use:<br>
      # <pre>
      # try {
      # FileInputStream input = new FileInputStream(filename);
      # If (Utility.readICUDataHeader(input, dataformat, dataversion,
      # unicode) {
      # System.out.println("Verified file header, this is a ICU data file");
      # }
      # } catch (IOException e) {
      # System.out.println("This is not a ICU data file");
      # }
      # </pre>
      # </p>
      # @param inputStream input stream that contains the ICU data header
      # @param dataFormatIDExpected Data format expected. An array of 4 bytes
      # information about the data format.
      # E.g. data format ID 1.2.3.4. will became an array of
      # {1, 2, 3, 4}
      # @param authenticate user defined extra data authentication. This value
      # can be null, if no extra authentication is needed.
      # @exception IOException thrown if there is a read error or
      # when header authentication fails.
      # @draft 2.1
      def read_header(input_stream, data_format_idexpected, authenticate)
        input = DataInputStream.new(input_stream)
        headersize = input.read_char
        readcount = 2
        # reading the header format
        magic1 = input.read_byte
        readcount += 1
        magic2 = input.read_byte
        readcount += 1
        if (!(magic1).equal?(MAGIC1) || !(magic2).equal?(MAGIC2))
          raise IOException.new(MAGIC_NUMBER_AUTHENTICATION_FAILED_)
        end
        input.read_char # reading size
        readcount += 2
        input.read_char # reading reserved word
        readcount += 2
        bigendian = input.read_byte
        readcount += 1
        charset = input.read_byte
        readcount += 1
        charsize = input.read_byte
        readcount += 1
        input.read_byte # reading reserved byte
        readcount += 1
        data_format_id = Array.typed(::Java::Byte).new(4) { 0 }
        input.read_fully(data_format_id)
        readcount += 4
        data_version = Array.typed(::Java::Byte).new(4) { 0 }
        input.read_fully(data_version)
        readcount += 4
        unicode_version = Array.typed(::Java::Byte).new(4) { 0 }
        input.read_fully(unicode_version)
        readcount += 4
        if (headersize < readcount)
          raise IOException.new("Internal Error: Header size error")
        end
        input.skip_bytes(headersize - readcount)
        if (!(bigendian).equal?(BIG_ENDIAN_) || !(charset).equal?(CHAR_SET_) || !(charsize).equal?(CHAR_SIZE_) || !(Arrays == data_format_idexpected) || (!(authenticate).nil? && !authenticate.is_data_version_acceptable(data_version)))
          raise IOException.new(HEADER_AUTHENTICATION_FAILED_)
        end
        return unicode_version
      end
      
      # private variables -------------------------------------------------
      # 
      # Magic numbers to authenticate the data file
      const_set_lazy(:MAGIC1) { 0xda }
      const_attr_reader  :MAGIC1
      
      const_set_lazy(:MAGIC2) { 0x27 }
      const_attr_reader  :MAGIC2
      
      # File format authentication values
      const_set_lazy(:BIG_ENDIAN_) { 1 }
      const_attr_reader  :BIG_ENDIAN_
      
      const_set_lazy(:CHAR_SET_) { 0 }
      const_attr_reader  :CHAR_SET_
      
      const_set_lazy(:CHAR_SIZE_) { 2 }
      const_attr_reader  :CHAR_SIZE_
      
      # Error messages
      const_set_lazy(:MAGIC_NUMBER_AUTHENTICATION_FAILED_) { "ICU data file error: Not an ICU data file" }
      const_attr_reader  :MAGIC_NUMBER_AUTHENTICATION_FAILED_
      
      const_set_lazy(:HEADER_AUTHENTICATION_FAILED_) { "ICU data file error: Header authentication failed, please check if you have a valid ICU data file" }
      const_attr_reader  :HEADER_AUTHENTICATION_FAILED_
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__icubinary, :initialize
  end
  
end

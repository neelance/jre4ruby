require "rjava"

# Portions Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Util
  module KrbDataInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Util
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class implements a buffered input stream. It provides methods to read a chunck
  # of data from underlying data stream.
  # 
  # @author Yanni Zhang
  class KrbDataInputStream < KrbDataInputStreamImports.const_get :BufferedInputStream
    include_class_members KrbDataInputStreamImports
    
    attr_accessor :big_endian
    alias_method :attr_big_endian, :big_endian
    undef_method :big_endian
    alias_method :attr_big_endian=, :big_endian=
    undef_method :big_endian=
    
    typesig { [] }
    def set_native_byte_order
      if ((Java::Nio::ByteOrder.native_order == Java::Nio::ByteOrder::BIG_ENDIAN))
        @big_endian = true
      else
        @big_endian = false
      end
    end
    
    typesig { [InputStream] }
    def initialize(is)
      @big_endian = false
      super(is)
      @big_endian = true
    end
    
    typesig { [::Java::Int] }
    # Reads up to the specific number of bytes from this input stream.
    # @param num the number of bytes to be read.
    # @return the int value of this byte array.
    # @exception IOException.
    def read(num)
      bytes = Array.typed(::Java::Byte).new(num) { 0 }
      read(bytes, 0, num)
      result = 0
      i = 0
      while i < num
        if (@big_endian)
          result |= (bytes[i] & 0xff) << (num - i - 1) * 8
        else
          result |= (bytes[i] & 0xff) << i * 8
        end
        i += 1
      end
      return result
    end
    
    typesig { [] }
    def read_version
      # always read in big-endian mode
      result = (read & 0xff) << 8
      return result | (read & 0xff)
    end
    
    private
    alias_method :initialize__krb_data_input_stream, :initialize
  end
  
end

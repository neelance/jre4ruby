require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Zip
  module CRC32Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # A class that can be used to compute the CRC-32 of a data stream.
  # 
  # @see         Checksum
  # @author      David Connelly
  class CRC32 
    include_class_members CRC32Imports
    include Checksum
    
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    typesig { [] }
    # Creates a new CRC32 object.
    def initialize
      @crc = 0
    end
    
    typesig { [::Java::Int] }
    # Updates CRC-32 with specified byte.
    def update(b)
      @crc = update(@crc, b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates CRC-32 with specified array of bytes.
    def update(b, off, len)
      if ((b).nil?)
        raise NullPointerException.new
      end
      if (off < 0 || len < 0 || off > b.attr_length - len)
        raise ArrayIndexOutOfBoundsException.new
      end
      @crc = update_bytes(@crc, b, off, len)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Updates checksum with specified array of bytes.
    # 
    # @param b the array of bytes to update the checksum with
    def update(b)
      @crc = update_bytes(@crc, b, 0, b.attr_length)
    end
    
    typesig { [] }
    # Resets CRC-32 to initial value.
    def reset
      @crc = 0
    end
    
    typesig { [] }
    # Returns CRC-32 value.
    def get_value
      return @crc & 0xffffffff
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_CRC32_update, [:pointer, :long, :int32, :int32], :int32
      typesig { [::Java::Int, ::Java::Int] }
      def update(crc, b)
        JNI.__send__(:Java_java_util_zip_CRC32_update, JNI.env, self.jni_id, crc.to_int, b.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_CRC32_updateBytes, [:pointer, :long, :int32, :long, :int32, :int32], :int32
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def update_bytes(crc, b, off, len)
        JNI.__send__(:Java_java_util_zip_CRC32_updateBytes, JNI.env, self.jni_id, crc.to_int, b.jni_id, off.to_int, len.to_int)
      end
    }
    
    private
    alias_method :initialize__crc32, :initialize
  end
  
end

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
  module Adler32Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # A class that can be used to compute the Adler-32 checksum of a data
  # stream. An Adler-32 checksum is almost as reliable as a CRC-32 but
  # can be computed much faster.
  # 
  # @see         Checksum
  # @author      David Connelly
  class Adler32 
    include_class_members Adler32Imports
    include Checksum
    
    attr_accessor :adler
    alias_method :attr_adler, :adler
    undef_method :adler
    alias_method :attr_adler=, :adler=
    undef_method :adler=
    
    typesig { [] }
    # Creates a new Adler32 object.
    def initialize
      @adler = 1
    end
    
    typesig { [::Java::Int] }
    # Updates checksum with specified byte.
    # 
    # @param b an array of bytes
    def update(b)
      @adler = update(@adler, b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates checksum with specified array of bytes.
    def update(b, off, len)
      if ((b).nil?)
        raise NullPointerException.new
      end
      if (off < 0 || len < 0 || off > b.attr_length - len)
        raise ArrayIndexOutOfBoundsException.new
      end
      @adler = update_bytes(@adler, b, off, len)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Updates checksum with specified array of bytes.
    def update(b)
      @adler = update_bytes(@adler, b, 0, b.attr_length)
    end
    
    typesig { [] }
    # Resets checksum to initial value.
    def reset
      @adler = 1
    end
    
    typesig { [] }
    # Returns checksum value.
    def get_value
      return @adler & 0xffffffff
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_util_zip_Adler32_update, [:pointer, :long, :int32, :int32], :int32
      typesig { [::Java::Int, ::Java::Int] }
      def update(adler, b)
        JNI.call_native_method(:Java_java_util_zip_Adler32_update, JNI.env, self.jni_id, adler.to_int, b.to_int)
      end
      
      JNI.load_native_method :Java_java_util_zip_Adler32_updateBytes, [:pointer, :long, :int32, :long, :int32, :int32], :int32
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def update_bytes(adler, b, off, len)
        JNI.call_native_method(:Java_java_util_zip_Adler32_updateBytes, JNI.env, self.jni_id, adler.to_int, b.jni_id, off.to_int, len.to_int)
      end
    }
    
    private
    alias_method :initialize__adler32, :initialize
  end
  
end

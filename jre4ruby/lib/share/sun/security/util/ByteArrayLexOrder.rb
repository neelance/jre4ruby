require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module ByteArrayLexOrderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Util, :Comparator
    }
  end
  
  # Compare two byte arrays in lexicographical order.
  # 
  # @author D. N. Hoover
  class ByteArrayLexOrder 
    include_class_members ByteArrayLexOrderImports
    include Comparator
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # Perform lexicographical comparison of two byte arrays,
    # regarding each byte as unsigned.  That is, compare array entries
    # in order until they differ--the array with the smaller entry
    # is "smaller". If array entries are
    # equal till one array ends, then the longer array is "bigger".
    # 
    # @param  bytes1 first byte array to compare.
    # @param  bytes2 second byte array to compare.
    # @return negative number if bytes1 < bytes2, 0 if bytes1 == bytes2,
    # positive number if bytes1 > bytes2.
    # 
    # @exception <code>ClassCastException</code>
    # if either argument is not a byte array.
    def compare(bytes1, bytes2)
      diff = 0
      i = 0
      while i < bytes1.attr_length && i < bytes2.attr_length
        diff = (bytes1[i] & 0xff) - (bytes2[i] & 0xff)
        if (!(diff).equal?(0))
          return diff
        end
        i += 1
      end
      # if array entries are equal till the first ends, then the
      # longer is "bigger"
      return bytes1.attr_length - bytes2.attr_length
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__byte_array_lex_order, :initialize
  end
  
end

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
module Sun::Misc
  module ASCIICaseInsensitiveComparatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Comparator
    }
  end
  
  # Implements a locale and case insensitive comparator suitable for
  # strings that are known to only contain ASCII characters. Some
  # tables internal to the JDK contain only ASCII data and are using
  # the "generalized" java.lang.String case-insensitive comparator
  # which converts each character to both upper and lower case.
  class ASCIICaseInsensitiveComparator 
    include_class_members ASCIICaseInsensitiveComparatorImports
    include Comparator
    
    class_module.module_eval {
      const_set_lazy(:CASE_INSENSITIVE_ORDER) { ASCIICaseInsensitiveComparator.new }
      const_attr_reader  :CASE_INSENSITIVE_ORDER
    }
    
    typesig { [String, String] }
    def compare(s1, s2)
      n1 = s1.length
      n2 = s2.length
      min_len = n1 < n2 ? n1 : n2
      i = 0
      while i < min_len
        c1 = s1.char_at(i)
        c2 = s2.char_at(i)
        raise AssertError if not (c1 <= Character.new(0x007F) && c2 <= Character.new(0x007F))
        if (!(c1).equal?(c2))
          c1 = RJava.cast_to_char(to_lower(c1))
          c2 = RJava.cast_to_char(to_lower(c2))
          if (!(c1).equal?(c2))
            return c1 - c2
          end
        end
        i += 1
      end
      return n1 - n2
    end
    
    class_module.module_eval {
      typesig { [String] }
      # A case insensitive hash code method to go with the case insensitive
      # compare() method.
      # 
      # Returns a hash code for this ASCII string as if it were lower case.
      # 
      # returns same answer as:<p>
      # <code>s.toLowerCase(Locale.US).hashCode();</code><p>
      # but does not allocate memory (it does NOT have the special
      # case Turkish rules).
      # 
      # @param s a String to compute the hashcode on.
      # @return  a hash code value for this object.
      def lower_case_hash_code(s)
        h = 0
        len = s.length
        i = 0
        while i < len
          h = 31 * h + to_lower(s.char_at(i))
          i += 1
        end
        return h
      end
      
      typesig { [::Java::Int] }
      # If java.util.regex.ASCII ever becomes public or sun.*, use its code instead:
      def is_lower(ch)
        return ((ch - Character.new(?a.ord)) | (Character.new(?z.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def is_upper(ch)
        return ((ch - Character.new(?A.ord)) | (Character.new(?Z.ord) - ch)) >= 0
      end
      
      typesig { [::Java::Int] }
      def to_lower(ch)
        return is_upper(ch) ? (ch + 0x20) : ch
      end
      
      typesig { [::Java::Int] }
      def to_upper(ch)
        return is_lower(ch) ? (ch - 0x20) : ch
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__asciicase_insensitive_comparator, :initialize
  end
  
end

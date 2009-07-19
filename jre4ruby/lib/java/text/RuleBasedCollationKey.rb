require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module RuleBasedCollationKeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # A RuleBasedCollationKey is a concrete implementation of CollationKey class.
  # The RuleBasedCollationKey class is used by the RuleBasedCollator class.
  class RuleBasedCollationKey < RuleBasedCollationKeyImports.const_get :CollationKey
    include_class_members RuleBasedCollationKeyImports
    
    typesig { [CollationKey] }
    # Compare this RuleBasedCollationKey to target. The collation rules of the
    # Collator object which created these keys are applied. <strong>Note:</strong>
    # RuleBasedCollationKeys created by different Collators can not be compared.
    # @param target target RuleBasedCollationKey
    # @return Returns an integer value. Value is less than zero if this is less
    # than target, value is zero if this and target are equal and value is greater than
    # zero if this is greater than target.
    # @see java.text.Collator#compare
    def compare_to(target)
      result = (@key <=> ((target)).attr_key)
      if (result <= Collator::LESS)
        return Collator::LESS
      else
        if (result >= Collator::GREATER)
          return Collator::GREATER
        end
      end
      return Collator::EQUAL
    end
    
    typesig { [Object] }
    # Compare this RuleBasedCollationKey and the target for equality.
    # The collation rules of the Collator object which created these keys are applied.
    # <strong>Note:</strong> RuleBasedCollationKeys created by different Collators can not be
    # compared.
    # @param target the RuleBasedCollationKey to compare to.
    # @return Returns true if two objects are equal, false otherwise.
    def equals(target)
      if ((self).equal?(target))
        return true
      end
      if ((target).nil? || !(get_class == target.get_class))
        return false
      end
      other = target
      return (@key == other.attr_key)
    end
    
    typesig { [] }
    # Creates a hash code for this RuleBasedCollationKey. The hash value is calculated on the
    # key itself, not the String from which the key was created.  Thus
    # if x and y are RuleBasedCollationKeys, then x.hashCode(x) == y.hashCode() if
    # x.equals(y) is true.  This allows language-sensitive comparison in a hash table.
    # See the CollatinKey class description for an example.
    # @return the hash value based on the string's collation order.
    def hash_code
      return (@key.hash_code)
    end
    
    typesig { [] }
    # Converts the RuleBasedCollationKey to a sequence of bits. If two RuleBasedCollationKeys
    # could be legitimately compared, then one could compare the byte arrays
    # for each of those keys to obtain the same result.  Byte arrays are
    # organized most significant byte first.
    def to_byte_array
      src = @key.to_char_array
      dest = Array.typed(::Java::Byte).new(2 * src.attr_length) { 0 }
      j = 0
      i = 0
      while i < src.attr_length
        dest[((j += 1) - 1)] = (src[i] >> 8)
        dest[((j += 1) - 1)] = (src[i] & 0xff)
        ((i += 1) - 1)
      end
      return dest
    end
    
    typesig { [String, String] }
    # A RuleBasedCollationKey can only be generated by Collator objects.
    def initialize(source, key)
      @key = nil
      super(source)
      @key = nil
      @key = key
    end
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    private
    alias_method :initialize__rule_based_collation_key, :initialize
  end
  
end

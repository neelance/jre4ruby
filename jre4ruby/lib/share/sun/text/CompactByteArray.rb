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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Sun::Text
  module CompactByteArrayImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
    }
  end
  
  # class CompactATypeArray : use only on primitive data types
  # Provides a compact way to store information that is indexed by Unicode
  # values, such as character properties, types, keyboard values, etc.This
  # is very useful when you have a block of Unicode data that contains
  # significant values while the rest of the Unicode data is unused in the
  # application or when you have a lot of redundance, such as where all 21,000
  # Han ideographs have the same value.  However, lookup is much faster than a
  # hash table.
  # A compact array of any primitive data type serves two purposes:
  # <UL type = round>
  #     <LI>Fast access of the indexed values.
  #     <LI>Smaller memory footprint.
  # </UL>
  # A compact array is composed of a index array and value array.  The index
  # array contains the indicies of Unicode characters to the value array.
  # 
  # @see                CompactIntArray
  # @see                CompactShortArray
  # @author             Helena Shih
  class CompactByteArray 
    include_class_members CompactByteArrayImports
    include Cloneable
    
    class_module.module_eval {
      # The total number of Unicode characters.
      const_set_lazy(:UNICODECOUNT) { 65536 }
      const_attr_reader  :UNICODECOUNT
    }
    
    typesig { [::Java::Byte] }
    # Constructor for CompactByteArray.
    # @param defaultValue the default value of the compact array.
    def initialize(default_value)
      @values = nil
      @indices = nil
      @is_compact = false
      @hashes = nil
      i = 0
      @values = Array.typed(::Java::Byte).new(UNICODECOUNT) { 0 }
      @indices = Array.typed(::Java::Short).new(INDEXCOUNT) { 0 }
      @hashes = Array.typed(::Java::Int).new(INDEXCOUNT) { 0 }
      i = 0
      while i < UNICODECOUNT
        @values[i] = default_value
        (i += 1)
      end
      i = 0
      while i < INDEXCOUNT
        @indices[i] = RJava.cast_to_short((i << BLOCKSHIFT))
        @hashes[i] = 0
        (i += 1)
      end
      @is_compact = false
    end
    
    typesig { [Array.typed(::Java::Short), Array.typed(::Java::Byte)] }
    # Constructor for CompactByteArray.
    # @param indexArray the indicies of the compact array.
    # @param newValues the values of the compact array.
    # @exception IllegalArgumentException If index is out of range.
    def initialize(index_array, new_values)
      @values = nil
      @indices = nil
      @is_compact = false
      @hashes = nil
      i = 0
      if (!(index_array.attr_length).equal?(INDEXCOUNT))
        raise IllegalArgumentException.new("Index out of bounds!")
      end
      i = 0
      while i < INDEXCOUNT
        index = index_array[i]
        if ((index < 0) || (index >= new_values.attr_length + BLOCKCOUNT))
          raise IllegalArgumentException.new("Index out of bounds!")
        end
        (i += 1)
      end
      @indices = index_array
      @values = new_values
      @is_compact = true
    end
    
    typesig { [::Java::Char] }
    # Get the mapped value of a Unicode character.
    # @param index the character to get the mapped value with
    # @return the mapped value of the given character
    def element_at(index)
      return (@values[(@indices[index >> BLOCKSHIFT] & 0xffff) + (index & BLOCKMASK)])
    end
    
    typesig { [::Java::Char, ::Java::Byte] }
    # Set a new value for a Unicode character.
    # Set automatically expands the array if it is compacted.
    # @param index the character to set the mapped value with
    # @param value the new mapped value
    def set_element_at(index, value)
      if (@is_compact)
        expand
      end
      @values[(index).to_int] = value
      touch_block(index >> BLOCKSHIFT, value)
    end
    
    typesig { [::Java::Char, ::Java::Char, ::Java::Byte] }
    # Set new values for a range of Unicode character.
    # @param start the starting offset o of the range
    # @param end the ending offset of the range
    # @param value the new mapped value
    def set_element_at(start, end_, value)
      i = 0
      if (@is_compact)
        expand
      end
      i = start
      while i <= end_
        @values[i] = value
        touch_block(i >> BLOCKSHIFT, value)
        (i += 1)
      end
    end
    
    typesig { [] }
    # Compact the array.
    def compact
      if (!@is_compact)
        limit_compacted = 0
        i_block_start = 0
        i_untouched = -1
        i = 0
        while i < @indices.attr_length
          @indices[i] = -1
          touched = block_touched(i)
          if (!touched && !(i_untouched).equal?(-1))
            # If no values in this block were set, we can just set its
            # index to be the same as some other block with no values
            # set, assuming we've seen one yet.
            @indices[i] = i_untouched
          else
            j_block_start = 0
            j = 0
            j = 0
            while j < limit_compacted
              if ((@hashes[i]).equal?(@hashes[j]) && array_region_matches(@values, i_block_start, @values, j_block_start, BLOCKCOUNT))
                @indices[i] = RJava.cast_to_short(j_block_start)
                break
              end
              (j += 1)
              j_block_start += BLOCKCOUNT
            end
            if ((@indices[i]).equal?(-1))
              # we didn't match, so copy & update
              System.arraycopy(@values, i_block_start, @values, j_block_start, BLOCKCOUNT)
              @indices[i] = RJava.cast_to_short(j_block_start)
              @hashes[j] = @hashes[i]
              (limit_compacted += 1)
              if (!touched)
                # If this is the first untouched block we've seen,
                # remember its index.
                i_untouched = RJava.cast_to_short(j_block_start)
              end
            end
          end
          (i += 1)
          i_block_start += BLOCKCOUNT
        end
        # we are done compacting, so now make the array shorter
        new_size = limit_compacted * BLOCKCOUNT
        result = Array.typed(::Java::Byte).new(new_size) { 0 }
        System.arraycopy(@values, 0, result, 0, new_size)
        @values = result
        @is_compact = true
        @hashes = nil
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Convenience utility to compare two arrays of doubles.
      # @param len the length to compare.
      # The start indices and start+len must be valid.
      def array_region_matches(source, source_start, target, target_start, len)
        source_end = source_start + len
        delta = target_start - source_start
        i = source_start
        while i < source_end
          if (!(source[i]).equal?(target[i + delta]))
            return false
          end
          i += 1
        end
        return true
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Remember that a specified block was "touched", i.e. had a value set.
    # Untouched blocks can be skipped when compacting the array
    def touch_block(i, value)
      @hashes[i] = (@hashes[i] + (value << 1)) | 1
    end
    
    typesig { [::Java::Int] }
    # Query whether a specified block was "touched", i.e. had a value set.
    # Untouched blocks can be skipped when compacting the array
    def block_touched(i)
      return !(@hashes[i]).equal?(0)
    end
    
    typesig { [] }
    # For internal use only.  Do not modify the result, the behavior of
    # modified results are undefined.
    def get_index_array
      return @indices
    end
    
    typesig { [] }
    # For internal use only.  Do not modify the result, the behavior of
    # modified results are undefined.
    def get_string_array
      return @values
    end
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      begin
        other = super
        other.attr_values = @values.clone
        other.attr_indices = @indices.clone
        if (!(@hashes).nil?)
          other.attr_hashes = @hashes.clone
        end
        return other
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [Object] }
    # Compares the equality of two compact array objects.
    # @param obj the compact array object to be compared with this.
    # @return true if the current compact array object is the same
    # as the compact array object obj; false otherwise.
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      if ((self).equal?(obj))
        # quick check
        return true
      end
      if (!(get_class).equal?(obj.get_class))
        # same class?
        return false
      end
      other = obj
      i = 0
      while i < UNICODECOUNT
        # could be sped up later
        if (!(element_at(RJava.cast_to_char(i))).equal?(other.element_at(RJava.cast_to_char(i))))
          return false
        end
        i += 1
      end
      return true # we made it through the guantlet.
    end
    
    typesig { [] }
    # Generates the hash code for the compact array object
    def hash_code
      result = 0
      increment = Math.min(3, @values.attr_length / 16)
      i = 0
      while i < @values.attr_length
        result = result * 37 + @values[i]
        i += increment
      end
      return result
    end
    
    typesig { [] }
    # --------------------------------------------------------------
    # package private
    # --------------------------------------------------------------
    # Expanding takes the array back to a 65536 element array.
    def expand
      i = 0
      if (@is_compact)
        temp_array = nil
        @hashes = Array.typed(::Java::Int).new(INDEXCOUNT) { 0 }
        temp_array = Array.typed(::Java::Byte).new(UNICODECOUNT) { 0 }
        i = 0
        while i < UNICODECOUNT
          value = element_at(RJava.cast_to_char(i))
          temp_array[i] = value
          touch_block(i >> BLOCKSHIFT, value)
          (i += 1)
        end
        i = 0
        while i < INDEXCOUNT
          @indices[i] = RJava.cast_to_short((i << BLOCKSHIFT))
          (i += 1)
        end
        @values = nil
        @values = temp_array
        @is_compact = false
      end
    end
    
    typesig { [] }
    def get_array
      return @values
    end
    
    class_module.module_eval {
      const_set_lazy(:BLOCKSHIFT) { 7 }
      const_attr_reader  :BLOCKSHIFT
      
      const_set_lazy(:BLOCKCOUNT) { (1 << BLOCKSHIFT) }
      const_attr_reader  :BLOCKCOUNT
      
      const_set_lazy(:INDEXSHIFT) { (16 - BLOCKSHIFT) }
      const_attr_reader  :INDEXSHIFT
      
      const_set_lazy(:INDEXCOUNT) { (1 << INDEXSHIFT) }
      const_attr_reader  :INDEXCOUNT
      
      const_set_lazy(:BLOCKMASK) { BLOCKCOUNT - 1 }
      const_attr_reader  :BLOCKMASK
    }
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    # char -> short (char parameterized short)
    attr_accessor :indices
    alias_method :attr_indices, :indices
    undef_method :indices
    alias_method :attr_indices=, :indices=
    undef_method :indices=
    
    attr_accessor :is_compact
    alias_method :attr_is_compact, :is_compact
    undef_method :is_compact
    alias_method :attr_is_compact=, :is_compact=
    undef_method :is_compact=
    
    attr_accessor :hashes
    alias_method :attr_hashes, :hashes
    undef_method :hashes
    alias_method :attr_hashes=, :hashes=
    undef_method :hashes=
    
    private
    alias_method :initialize__compact_byte_array, :initialize
  end
  
end

require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Text
  module UCompactIntArrayImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
    }
  end
  
  class UCompactIntArray 
    include_class_members UCompactIntArrayImports
    include Cloneable
    
    typesig { [] }
    # Default constructor for UCompactIntArray, the default value of the
    # compact array is 0.
    def initialize
      @default_value = 0
      @values = nil
      @indices = nil
      @is_compact = false
      @block_touched = nil
      @plane_touched = nil
      @values = Array.typed(Array.typed(::Java::Int)).new(16) { nil }
      @indices = Array.typed(Array.typed(::Java::Short)).new(16) { nil }
      @block_touched = Array.typed(Array.typed(::Java::Boolean)).new(16) { nil }
      @plane_touched = Array.typed(::Java::Boolean).new(16) { false }
    end
    
    typesig { [::Java::Int] }
    def initialize(default_value)
      initialize__ucompact_int_array()
      @default_value = default_value
    end
    
    typesig { [::Java::Int] }
    # Get the mapped value of a Unicode character.
    # @param index the character to get the mapped value with
    # @return the mapped value of the given character
    def element_at(index)
      plane = (index & PLANEMASK) >> PLANESHIFT
      if (!@plane_touched[plane])
        return @default_value
      end
      index &= CODEPOINTMASK
      return @values[plane][(@indices[plane][index >> BLOCKSHIFT] & 0xffff) + (index & BLOCKMASK)]
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Set a new value for a Unicode character.
    # Set automatically expands the array if it is compacted.
    # @param index the character to set the mapped value with
    # @param value the new mapped value
    def set_element_at(index, value)
      if (@is_compact)
        expand
      end
      plane = (index & PLANEMASK) >> PLANESHIFT
      if (!@plane_touched[plane])
        init_plane(plane)
      end
      index &= CODEPOINTMASK
      @values[plane][index] = value
      @block_touched[plane][index >> BLOCKSHIFT] = true
    end
    
    typesig { [] }
    # Compact the array.
    def compact
      if (@is_compact)
        return
      end
      plane = 0
      while plane < PLANECOUNT
        if (!@plane_touched[plane])
          plane += 1
          next
        end
        limit_compacted = 0
        i_block_start = 0
        i_untouched = -1
        i = 0
        while i < @indices[plane].attr_length
          @indices[plane][i] = -1
          if (!@block_touched[plane][i] && !(i_untouched).equal?(-1))
            # If no values in this block were set, we can just set its
            # index to be the same as some other block with no values
            # set, assuming we've seen one yet.
            @indices[plane][i] = i_untouched
          else
            j_block_start = limit_compacted * BLOCKCOUNT
            if (i > limit_compacted)
              System.arraycopy(@values[plane], i_block_start, @values[plane], j_block_start, BLOCKCOUNT)
            end
            if (!@block_touched[plane][i])
              # If this is the first untouched block we've seen, remember it.
              i_untouched = RJava.cast_to_short(j_block_start)
            end
            @indices[plane][i] = RJava.cast_to_short(j_block_start)
            limit_compacted += 1
          end
          (i += 1)
          i_block_start += BLOCKCOUNT
        end
        # we are done compacting, so now make the array shorter
        new_size = limit_compacted * BLOCKCOUNT
        result = Array.typed(::Java::Int).new(new_size) { 0 }
        System.arraycopy(@values[plane], 0, result, 0, new_size)
        @values[plane] = result
        @block_touched[plane] = nil
        plane += 1
      end
      @is_compact = true
    end
    
    typesig { [] }
    # --------------------------------------------------------------
    # private
    # --------------------------------------------------------------
    # Expanded takes the array back to a 0x10ffff element array
    def expand
      i = 0
      if (@is_compact)
        temp_array = nil
        plane = 0
        while plane < PLANECOUNT
          if (!@plane_touched[plane])
            plane += 1
            next
          end
          @block_touched[plane] = Array.typed(::Java::Boolean).new(INDEXCOUNT) { false }
          temp_array = Array.typed(::Java::Int).new(UNICODECOUNT) { 0 }
          i = 0
          while i < UNICODECOUNT
            temp_array[i] = @values[plane][@indices[plane][i >> BLOCKSHIFT] & 0xffff + (i & BLOCKMASK)]
            @block_touched[plane][i >> BLOCKSHIFT] = true
            (i += 1)
          end
          i = 0
          while i < INDEXCOUNT
            @indices[plane][i] = RJava.cast_to_short((i << BLOCKSHIFT))
            (i += 1)
          end
          @values[plane] = temp_array
          plane += 1
        end
        @is_compact = false
      end
    end
    
    typesig { [::Java::Int] }
    def init_plane(plane)
      @values[plane] = Array.typed(::Java::Int).new(UNICODECOUNT) { 0 }
      @indices[plane] = Array.typed(::Java::Short).new(INDEXCOUNT) { 0 }
      @block_touched[plane] = Array.typed(::Java::Boolean).new(INDEXCOUNT) { false }
      @plane_touched[plane] = true
      if (@plane_touched[0] && !(plane).equal?(0))
        System.arraycopy(@indices[0], 0, @indices[plane], 0, INDEXCOUNT)
      else
        i = 0
        while i < INDEXCOUNT
          @indices[plane][i] = RJava.cast_to_short((i << BLOCKSHIFT))
          (i += 1)
        end
      end
      i = 0
      while i < UNICODECOUNT
        @values[plane][i] = @default_value
        (i += 1)
      end
    end
    
    typesig { [] }
    def get_ksize
      size = 0
      plane = 0
      while plane < PLANECOUNT
        if (@plane_touched[plane])
          size += (@values[plane].attr_length * 4 + @indices[plane].attr_length * 2)
        end
        plane += 1
      end
      return size / 1024
    end
    
    class_module.module_eval {
      const_set_lazy(:PLANEMASK) { 0x30000 }
      const_attr_reader  :PLANEMASK
      
      const_set_lazy(:PLANESHIFT) { 16 }
      const_attr_reader  :PLANESHIFT
      
      const_set_lazy(:PLANECOUNT) { 0x10 }
      const_attr_reader  :PLANECOUNT
      
      const_set_lazy(:CODEPOINTMASK) { 0xffff }
      const_attr_reader  :CODEPOINTMASK
      
      const_set_lazy(:UNICODECOUNT) { 0x10000 }
      const_attr_reader  :UNICODECOUNT
      
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
    
    attr_accessor :default_value
    alias_method :attr_default_value, :default_value
    undef_method :default_value
    alias_method :attr_default_value=, :default_value=
    undef_method :default_value=
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
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
    
    attr_accessor :block_touched
    alias_method :attr_block_touched, :block_touched
    undef_method :block_touched
    alias_method :attr_block_touched=, :block_touched=
    undef_method :block_touched=
    
    attr_accessor :plane_touched
    alias_method :attr_plane_touched, :plane_touched
    undef_method :plane_touched
    alias_method :attr_plane_touched=, :plane_touched=
    undef_method :plane_touched=
    
    private
    alias_method :initialize__ucompact_int_array, :initialize
  end
  
end

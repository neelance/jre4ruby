require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module BitSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :ByteOrder
      include_const ::Java::Nio, :LongBuffer
    }
  end
  
  # This class implements a vector of bits that grows as needed. Each
  # component of the bit set has a {@code boolean} value. The
  # bits of a {@code BitSet} are indexed by nonnegative integers.
  # Individual indexed bits can be examined, set, or cleared. One
  # {@code BitSet} may be used to modify the contents of another
  # {@code BitSet} through logical AND, logical inclusive OR, and
  # logical exclusive OR operations.
  # 
  # <p>By default, all bits in the set initially have the value
  # {@code false}.
  # 
  # <p>Every bit set has a current size, which is the number of bits
  # of space currently in use by the bit set. Note that the size is
  # related to the implementation of a bit set, so it may change with
  # implementation. The length of a bit set relates to logical length
  # of a bit set and is defined independently of implementation.
  # 
  # <p>Unless otherwise noted, passing a null parameter to any of the
  # methods in a {@code BitSet} will result in a
  # {@code NullPointerException}.
  # 
  # <p>A {@code BitSet} is not safe for multithreaded use without
  # external synchronization.
  # 
  # @author  Arthur van Hoff
  # @author  Michael McCloskey
  # @author  Martin Buchholz
  # @since   JDK1.0
  class BitSet 
    include_class_members BitSetImports
    include Cloneable
    include Java::Io::Serializable
    
    class_module.module_eval {
      # BitSets are packed into arrays of "words."  Currently a word is
      # a long, which consists of 64 bits, requiring 6 address bits.
      # The choice of word size is determined purely by performance concerns.
      const_set_lazy(:ADDRESS_BITS_PER_WORD) { 6 }
      const_attr_reader  :ADDRESS_BITS_PER_WORD
      
      const_set_lazy(:BITS_PER_WORD) { 1 << ADDRESS_BITS_PER_WORD }
      const_attr_reader  :BITS_PER_WORD
      
      const_set_lazy(:BIT_INDEX_MASK) { BITS_PER_WORD - 1 }
      const_attr_reader  :BIT_INDEX_MASK
      
      # Used to shift left or right for a partial word mask
      const_set_lazy(:WORD_MASK) { -0x1 }
      const_attr_reader  :WORD_MASK
      
      # @serialField bits long[]
      # 
      # The bits in this BitSet.  The ith bit is stored in bits[i/64] at
      # bit position i % 64 (where bit position 0 refers to the least
      # significant bit and 63 refers to the most significant bit).
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("bits", Array), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    # The internal field corresponding to the serialField "bits".
    attr_accessor :words
    alias_method :attr_words, :words
    undef_method :words
    alias_method :attr_words=, :words=
    undef_method :words=
    
    # The number of words in the logical size of this BitSet.
    attr_accessor :words_in_use
    alias_method :attr_words_in_use, :words_in_use
    undef_method :words_in_use
    alias_method :attr_words_in_use=, :words_in_use=
    undef_method :words_in_use=
    
    # Whether the size of "words" is user-specified.  If so, we assume
    # the user knows what he's doing and try harder to preserve it.
    attr_accessor :size_is_sticky
    alias_method :attr_size_is_sticky, :size_is_sticky
    undef_method :size_is_sticky
    alias_method :attr_size_is_sticky=, :size_is_sticky=
    undef_method :size_is_sticky=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 7997698588986878753 }
      const_attr_reader  :SerialVersionUID
      
      typesig { [::Java::Int] }
      # Given a bit index, return word index containing it.
      def word_index(bit_index)
        return bit_index >> ADDRESS_BITS_PER_WORD
      end
    }
    
    typesig { [] }
    # Every public method must preserve these invariants.
    def check_invariants
      raise AssertError if not (((@words_in_use).equal?(0) || !(@words[@words_in_use - 1]).equal?(0)))
      raise AssertError if not ((@words_in_use >= 0 && @words_in_use <= @words.attr_length))
      raise AssertError if not (((@words_in_use).equal?(@words.attr_length) || (@words[@words_in_use]).equal?(0)))
    end
    
    typesig { [] }
    # Sets the field wordsInUse to the logical size in words of the bit set.
    # WARNING:This method assumes that the number of words actually in use is
    # less than or equal to the current value of wordsInUse!
    def recalculate_words_in_use
      # Traverse the bitset until a used word is found
      i = 0
      i = @words_in_use - 1
      while i >= 0
        if (!(@words[i]).equal?(0))
          break
        end
        ((i -= 1) + 1)
      end
      @words_in_use = i + 1 # The new logical size
    end
    
    typesig { [] }
    # Creates a new bit set. All bits are initially {@code false}.
    def initialize
      @words = nil
      @words_in_use = 0
      @size_is_sticky = false
      init_words(BITS_PER_WORD)
      @size_is_sticky = false
    end
    
    typesig { [::Java::Int] }
    # Creates a bit set whose initial size is large enough to explicitly
    # represent bits with indices in the range {@code 0} through
    # {@code nbits-1}. All bits are initially {@code false}.
    # 
    # @param  nbits the initial size of the bit set
    # @throws NegativeArraySizeException if the specified initial size
    # is negative
    def initialize(nbits)
      @words = nil
      @words_in_use = 0
      @size_is_sticky = false
      # nbits can't be negative; size 0 is OK
      if (nbits < 0)
        raise NegativeArraySizeException.new("nbits < 0: " + (nbits).to_s)
      end
      init_words(nbits)
      @size_is_sticky = true
    end
    
    typesig { [::Java::Int] }
    def init_words(nbits)
      @words = Array.typed(::Java::Long).new(word_index(nbits - 1) + 1) { 0 }
    end
    
    typesig { [Array.typed(::Java::Long)] }
    # Creates a bit set using words as the internal representation.
    # The last word (if there is one) must be non-zero.
    def initialize(words)
      @words = nil
      @words_in_use = 0
      @size_is_sticky = false
      @words = words
      @words_in_use = words.attr_length
      check_invariants
    end
    
    typesig { [::Java::Int] }
    # Ensures that the BitSet can hold enough words.
    # @param wordsRequired the minimum acceptable number of words.
    def ensure_capacity(words_required)
      if (@words.attr_length < words_required)
        # Allocate larger of doubled size or required size
        request = Math.max(2 * @words.attr_length, words_required)
        @words = Arrays.copy_of(@words, request)
        @size_is_sticky = false
      end
    end
    
    typesig { [::Java::Int] }
    # Ensures that the BitSet can accommodate a given wordIndex,
    # temporarily violating the invariants.  The caller must
    # restore the invariants before returning to the user,
    # possibly using recalculateWordsInUse().
    # @param wordIndex the index to be accommodated.
    def expand_to(word_index_)
      words_required = word_index_ + 1
      if (@words_in_use < words_required)
        ensure_capacity(words_required)
        @words_in_use = words_required
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # Checks that fromIndex ... toIndex is a valid range of bit indices.
      def check_range(from_index, to_index)
        if (from_index < 0)
          raise IndexOutOfBoundsException.new("fromIndex < 0: " + (from_index).to_s)
        end
        if (to_index < 0)
          raise IndexOutOfBoundsException.new("toIndex < 0: " + (to_index).to_s)
        end
        if (from_index > to_index)
          raise IndexOutOfBoundsException.new("fromIndex: " + (from_index).to_s + " > toIndex: " + (to_index).to_s)
        end
      end
    }
    
    typesig { [::Java::Int] }
    # Sets the bit at the specified index to the complement of its
    # current value.
    # 
    # @param  bitIndex the index of the bit to flip
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  1.4
    def flip(bit_index)
      if (bit_index < 0)
        raise IndexOutOfBoundsException.new("bitIndex < 0: " + (bit_index).to_s)
      end
      word_index_ = word_index(bit_index)
      expand_to(word_index_)
      @words[word_index_] ^= (1 << bit_index)
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets each bit from the specified {@code fromIndex} (inclusive) to the
    # specified {@code toIndex} (exclusive) to the complement of its current
    # value.
    # 
    # @param  fromIndex index of the first bit to flip
    # @param  toIndex index after the last bit to flip
    # @throws IndexOutOfBoundsException if {@code fromIndex} is negative,
    # or {@code toIndex} is negative, or {@code fromIndex} is
    # larger than {@code toIndex}
    # @since  1.4
    def flip(from_index, to_index)
      check_range(from_index, to_index)
      if ((from_index).equal?(to_index))
        return
      end
      start_word_index = word_index(from_index)
      end_word_index = word_index(to_index - 1)
      expand_to(end_word_index)
      first_word_mask = WORD_MASK << from_index
      last_word_mask = WORD_MASK >> -to_index
      if ((start_word_index).equal?(end_word_index))
        # Case 1: One word
        @words[start_word_index] ^= (first_word_mask & last_word_mask)
      else
        # Case 2: Multiple words
        # Handle first word
        @words[start_word_index] ^= first_word_mask
        # Handle intermediate words, if any
        i = start_word_index + 1
        while i < end_word_index
          @words[i] ^= WORD_MASK
          ((i += 1) - 1)
        end
        # Handle last word
        @words[end_word_index] ^= last_word_mask
      end
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [::Java::Int] }
    # Sets the bit at the specified index to {@code true}.
    # 
    # @param  bitIndex a bit index
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  JDK1.0
    def set(bit_index)
      if (bit_index < 0)
        raise IndexOutOfBoundsException.new("bitIndex < 0: " + (bit_index).to_s)
      end
      word_index_ = word_index(bit_index)
      expand_to(word_index_)
      @words[word_index_] |= (1 << bit_index) # Restores invariants
      check_invariants
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Sets the bit at the specified index to the specified value.
    # 
    # @param  bitIndex a bit index
    # @param  value a boolean value to set
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  1.4
    def set(bit_index, value)
      if (value)
        set(bit_index)
      else
        clear(bit_index)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the bits from the specified {@code fromIndex} (inclusive) to the
    # specified {@code toIndex} (exclusive) to {@code true}.
    # 
    # @param  fromIndex index of the first bit to be set
    # @param  toIndex index after the last bit to be set
    # @throws IndexOutOfBoundsException if {@code fromIndex} is negative,
    # or {@code toIndex} is negative, or {@code fromIndex} is
    # larger than {@code toIndex}
    # @since  1.4
    def set(from_index, to_index)
      check_range(from_index, to_index)
      if ((from_index).equal?(to_index))
        return
      end
      # Increase capacity if necessary
      start_word_index = word_index(from_index)
      end_word_index = word_index(to_index - 1)
      expand_to(end_word_index)
      first_word_mask = WORD_MASK << from_index
      last_word_mask = WORD_MASK >> -to_index
      if ((start_word_index).equal?(end_word_index))
        # Case 1: One word
        @words[start_word_index] |= (first_word_mask & last_word_mask)
      else
        # Case 2: Multiple words
        # Handle first word
        @words[start_word_index] |= first_word_mask
        # Handle intermediate words, if any
        i = start_word_index + 1
        while i < end_word_index
          @words[i] = WORD_MASK
          ((i += 1) - 1)
        end
        # Handle last word (restores invariants)
        @words[end_word_index] |= last_word_mask
      end
      check_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Sets the bits from the specified {@code fromIndex} (inclusive) to the
    # specified {@code toIndex} (exclusive) to the specified value.
    # 
    # @param  fromIndex index of the first bit to be set
    # @param  toIndex index after the last bit to be set
    # @param  value value to set the selected bits to
    # @throws IndexOutOfBoundsException if {@code fromIndex} is negative,
    # or {@code toIndex} is negative, or {@code fromIndex} is
    # larger than {@code toIndex}
    # @since  1.4
    def set(from_index, to_index, value)
      if (value)
        set(from_index, to_index)
      else
        clear(from_index, to_index)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the bit specified by the index to {@code false}.
    # 
    # @param  bitIndex the index of the bit to be cleared
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  JDK1.0
    def clear(bit_index)
      if (bit_index < 0)
        raise IndexOutOfBoundsException.new("bitIndex < 0: " + (bit_index).to_s)
      end
      word_index_ = word_index(bit_index)
      if (word_index_ >= @words_in_use)
        return
      end
      @words[word_index_] &= ~(1 << bit_index)
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the bits from the specified {@code fromIndex} (inclusive) to the
    # specified {@code toIndex} (exclusive) to {@code false}.
    # 
    # @param  fromIndex index of the first bit to be cleared
    # @param  toIndex index after the last bit to be cleared
    # @throws IndexOutOfBoundsException if {@code fromIndex} is negative,
    # or {@code toIndex} is negative, or {@code fromIndex} is
    # larger than {@code toIndex}
    # @since  1.4
    def clear(from_index, to_index)
      check_range(from_index, to_index)
      if ((from_index).equal?(to_index))
        return
      end
      start_word_index = word_index(from_index)
      if (start_word_index >= @words_in_use)
        return
      end
      end_word_index = word_index(to_index - 1)
      if (end_word_index >= @words_in_use)
        to_index = length
        end_word_index = @words_in_use - 1
      end
      first_word_mask = WORD_MASK << from_index
      last_word_mask = WORD_MASK >> -to_index
      if ((start_word_index).equal?(end_word_index))
        # Case 1: One word
        @words[start_word_index] &= ~(first_word_mask & last_word_mask)
      else
        # Case 2: Multiple words
        # Handle first word
        @words[start_word_index] &= ~first_word_mask
        # Handle intermediate words, if any
        i = start_word_index + 1
        while i < end_word_index
          @words[i] = 0
          ((i += 1) - 1)
        end
        # Handle last word
        @words[end_word_index] &= ~last_word_mask
      end
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [] }
    # Sets all of the bits in this BitSet to {@code false}.
    # 
    # @since 1.4
    def clear
      while (@words_in_use > 0)
        @words[(@words_in_use -= 1)] = 0
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the value of the bit with the specified index. The value
    # is {@code true} if the bit with the index {@code bitIndex}
    # is currently set in this {@code BitSet}; otherwise, the result
    # is {@code false}.
    # 
    # @param  bitIndex   the bit index
    # @return the value of the bit with the specified index
    # @throws IndexOutOfBoundsException if the specified index is negative
    def get(bit_index)
      if (bit_index < 0)
        raise IndexOutOfBoundsException.new("bitIndex < 0: " + (bit_index).to_s)
      end
      check_invariants
      word_index_ = word_index(bit_index)
      return (word_index_ < @words_in_use) && (!((@words[word_index_] & (1 << bit_index))).equal?(0))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns a new {@code BitSet} composed of bits from this {@code BitSet}
    # from {@code fromIndex} (inclusive) to {@code toIndex} (exclusive).
    # 
    # @param  fromIndex index of the first bit to include
    # @param  toIndex index after the last bit to include
    # @return a new {@code BitSet} from a range of this {@code BitSet}
    # @throws IndexOutOfBoundsException if {@code fromIndex} is negative,
    # or {@code toIndex} is negative, or {@code fromIndex} is
    # larger than {@code toIndex}
    # @since  1.4
    def get(from_index, to_index)
      check_range(from_index, to_index)
      check_invariants
      len = length
      # If no set bits in range return empty bitset
      if (len <= from_index || (from_index).equal?(to_index))
        return BitSet.new(0)
      end
      # An optimization
      if (to_index > len)
        to_index = len
      end
      result = BitSet.new(to_index - from_index)
      target_words = word_index(to_index - from_index - 1) + 1
      source_index = word_index(from_index)
      word_aligned = (((from_index & BIT_INDEX_MASK)).equal?(0))
      # Process all words but the last word
      i = 0
      while i < target_words - 1
        result.attr_words[i] = word_aligned ? @words[source_index] : (@words[source_index] >> from_index) | (@words[source_index + 1] << -from_index)
        ((i += 1) - 1)
        ((source_index += 1) - 1)
      end
      # Process the last word
      last_word_mask = WORD_MASK >> -to_index
      # straddles source words
      result.attr_words[target_words - 1] = ((to_index - 1) & BIT_INDEX_MASK) < (from_index & BIT_INDEX_MASK) ? ((@words[source_index] >> from_index) | (@words[source_index + 1] & last_word_mask) << -from_index) : ((@words[source_index] & last_word_mask) >> from_index)
      # Set wordsInUse correctly
      result.attr_words_in_use = target_words
      result.recalculate_words_in_use
      result.check_invariants
      return result
    end
    
    typesig { [::Java::Int] }
    # Returns the index of the first bit that is set to {@code true}
    # that occurs on or after the specified starting index. If no such
    # bit exists then {@code -1} is returned.
    # 
    # <p>To iterate over the {@code true} bits in a {@code BitSet},
    # use the following loop:
    # 
    # <pre> {@code
    # for (int i = bs.nextSetBit(0); i >= 0; i = bs.nextSetBit(i+1)) {
    # // operate on index i here
    # }}</pre>
    # 
    # @param  fromIndex the index to start checking from (inclusive)
    # @return the index of the next set bit, or {@code -1} if there
    # is no such bit
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  1.4
    def next_set_bit(from_index)
      if (from_index < 0)
        raise IndexOutOfBoundsException.new("fromIndex < 0: " + (from_index).to_s)
      end
      check_invariants
      u = word_index(from_index)
      if (u >= @words_in_use)
        return -1
      end
      word = @words[u] & (WORD_MASK << from_index)
      while (true)
        if (!(word).equal?(0))
          return (u * BITS_PER_WORD) + Long.number_of_trailing_zeros(word)
        end
        if (((u += 1)).equal?(@words_in_use))
          return -1
        end
        word = @words[u]
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the index of the first bit that is set to {@code false}
    # that occurs on or after the specified starting index.
    # 
    # @param  fromIndex the index to start checking from (inclusive)
    # @return the index of the next clear bit
    # @throws IndexOutOfBoundsException if the specified index is negative
    # @since  1.4
    def next_clear_bit(from_index)
      # Neither spec nor implementation handle bitsets of maximal length.
      # See 4816253.
      if (from_index < 0)
        raise IndexOutOfBoundsException.new("fromIndex < 0: " + (from_index).to_s)
      end
      check_invariants
      u = word_index(from_index)
      if (u >= @words_in_use)
        return from_index
      end
      word = ~@words[u] & (WORD_MASK << from_index)
      while (true)
        if (!(word).equal?(0))
          return (u * BITS_PER_WORD) + Long.number_of_trailing_zeros(word)
        end
        if (((u += 1)).equal?(@words_in_use))
          return @words_in_use * BITS_PER_WORD
        end
        word = ~@words[u]
      end
    end
    
    typesig { [] }
    # Returns the "logical size" of this {@code BitSet}: the index of
    # the highest set bit in the {@code BitSet} plus one. Returns zero
    # if the {@code BitSet} contains no set bits.
    # 
    # @return the logical size of this {@code BitSet}
    # @since  1.2
    def length
      if ((@words_in_use).equal?(0))
        return 0
      end
      return BITS_PER_WORD * (@words_in_use - 1) + (BITS_PER_WORD - Long.number_of_leading_zeros(@words[@words_in_use - 1]))
    end
    
    typesig { [] }
    # Returns true if this {@code BitSet} contains no bits that are set
    # to {@code true}.
    # 
    # @return boolean indicating whether this {@code BitSet} is empty
    # @since  1.4
    def is_empty
      return (@words_in_use).equal?(0)
    end
    
    typesig { [BitSet] }
    # Returns true if the specified {@code BitSet} has any bits set to
    # {@code true} that are also set to {@code true} in this {@code BitSet}.
    # 
    # @param  set {@code BitSet} to intersect with
    # @return boolean indicating whether this {@code BitSet} intersects
    # the specified {@code BitSet}
    # @since  1.4
    def intersects(set_)
      i = Math.min(@words_in_use, set_.attr_words_in_use) - 1
      while i >= 0
        if (!((@words[i] & set_.attr_words[i])).equal?(0))
          return true
        end
        ((i -= 1) + 1)
      end
      return false
    end
    
    typesig { [] }
    # Returns the number of bits set to {@code true} in this {@code BitSet}.
    # 
    # @return the number of bits set to {@code true} in this {@code BitSet}
    # @since  1.4
    def cardinality
      sum = 0
      i = 0
      while i < @words_in_use
        sum += Long.bit_count(@words[i])
        ((i += 1) - 1)
      end
      return sum
    end
    
    typesig { [BitSet] }
    # Performs a logical <b>AND</b> of this target bit set with the
    # argument bit set. This bit set is modified so that each bit in it
    # has the value {@code true} if and only if it both initially
    # had the value {@code true} and the corresponding bit in the
    # bit set argument also had the value {@code true}.
    # 
    # @param set a bit set
    def and(set_)
      if ((self).equal?(set_))
        return
      end
      while (@words_in_use > set_.attr_words_in_use)
        @words[(@words_in_use -= 1)] = 0
      end
      # Perform logical AND on words in common
      i = 0
      while i < @words_in_use
        @words[i] &= set_.attr_words[i]
        ((i += 1) - 1)
      end
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [BitSet] }
    # Performs a logical <b>OR</b> of this bit set with the bit set
    # argument. This bit set is modified so that a bit in it has the
    # value {@code true} if and only if it either already had the
    # value {@code true} or the corresponding bit in the bit set
    # argument has the value {@code true}.
    # 
    # @param set a bit set
    def or(set_)
      if ((self).equal?(set_))
        return
      end
      words_in_common = Math.min(@words_in_use, set_.attr_words_in_use)
      if (@words_in_use < set_.attr_words_in_use)
        ensure_capacity(set_.attr_words_in_use)
        @words_in_use = set_.attr_words_in_use
      end
      # Perform logical OR on words in common
      i = 0
      while i < words_in_common
        @words[i] |= set_.attr_words[i]
        ((i += 1) - 1)
      end
      # Copy any remaining words
      if (words_in_common < set_.attr_words_in_use)
        System.arraycopy(set_.attr_words, words_in_common, @words, words_in_common, @words_in_use - words_in_common)
      end
      # recalculateWordsInUse() is unnecessary
      check_invariants
    end
    
    typesig { [BitSet] }
    # Performs a logical <b>XOR</b> of this bit set with the bit set
    # argument. This bit set is modified so that a bit in it has the
    # value {@code true} if and only if one of the following
    # statements holds:
    # <ul>
    # <li>The bit initially has the value {@code true}, and the
    # corresponding bit in the argument has the value {@code false}.
    # <li>The bit initially has the value {@code false}, and the
    # corresponding bit in the argument has the value {@code true}.
    # </ul>
    # 
    # @param  set a bit set
    def xor(set_)
      words_in_common = Math.min(@words_in_use, set_.attr_words_in_use)
      if (@words_in_use < set_.attr_words_in_use)
        ensure_capacity(set_.attr_words_in_use)
        @words_in_use = set_.attr_words_in_use
      end
      # Perform logical XOR on words in common
      i = 0
      while i < words_in_common
        @words[i] ^= set_.attr_words[i]
        ((i += 1) - 1)
      end
      # Copy any remaining words
      if (words_in_common < set_.attr_words_in_use)
        System.arraycopy(set_.attr_words, words_in_common, @words, words_in_common, set_.attr_words_in_use - words_in_common)
      end
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [BitSet] }
    # Clears all of the bits in this {@code BitSet} whose corresponding
    # bit is set in the specified {@code BitSet}.
    # 
    # @param  set the {@code BitSet} with which to mask this
    # {@code BitSet}
    # @since  1.2
    def and_not(set_)
      # Perform logical (a & !b) on words in common
      i = Math.min(@words_in_use, set_.attr_words_in_use) - 1
      while i >= 0
        @words[i] &= ~set_.attr_words[i]
        ((i -= 1) + 1)
      end
      recalculate_words_in_use
      check_invariants
    end
    
    typesig { [] }
    # Returns a hash code value for this bit set. The hash code
    # depends only on which bits have been set within this
    # <code>BitSet</code>. The algorithm used to compute it may
    # be described as follows.<p>
    # Suppose the bits in the <code>BitSet</code> were to be stored
    # in an array of <code>long</code> integers called, say,
    # <code>words</code>, in such a manner that bit <code>k</code> is
    # set in the <code>BitSet</code> (for nonnegative values of
    # <code>k</code>) if and only if the expression
    # <pre>((k&gt;&gt;6) &lt; words.length) && ((words[k&gt;&gt;6] & (1L &lt;&lt; (bit & 0x3F))) != 0)</pre>
    # is true. Then the following definition of the <code>hashCode</code>
    # method would be a correct implementation of the actual algorithm:
    # <pre>
    # public int hashCode() {
    # long h = 1234;
    # for (int i = words.length; --i &gt;= 0; ) {
    # h ^= words[i] * (i + 1);
    # }
    # return (int)((h &gt;&gt; 32) ^ h);
    # }</pre>
    # Note that the hash code values change if the set of bits is altered.
    # <p>Overrides the <code>hashCode</code> method of <code>Object</code>.
    # 
    # @return  a hash code value for this bit set.
    def hash_code
      h = 1234
      i = @words_in_use
      while (i -= 1) >= 0
        h ^= @words[i] * (i + 1)
      end
      return RJava.cast_to_int(((h >> 32) ^ h))
    end
    
    typesig { [] }
    # Returns the number of bits of space actually in use by this
    # {@code BitSet} to represent bit values.
    # The maximum element in the set is the size - 1st element.
    # 
    # @return the number of bits currently in this bit set
    def size
      return @words.attr_length * BITS_PER_WORD
    end
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is {@code true} if and only if the argument is
    # not {@code null} and is a {@code Bitset} object that has
    # exactly the same set of bits set to {@code true} as this bit
    # set. That is, for every nonnegative {@code int} index {@code k},
    # <pre>((BitSet)obj).get(k) == this.get(k)</pre>
    # must be true. The current sizes of the two bit sets are not compared.
    # 
    # @param  obj the object to compare with
    # @return {@code true} if the objects are the same;
    # {@code false} otherwise
    # @see    #size()
    def equals(obj)
      if (!(obj.is_a?(BitSet)))
        return false
      end
      if ((self).equal?(obj))
        return true
      end
      set_ = obj
      check_invariants
      set_.check_invariants
      if (!(@words_in_use).equal?(set_.attr_words_in_use))
        return false
      end
      # Check words in use by both BitSets
      i = 0
      while i < @words_in_use
        if (!(@words[i]).equal?(set_.attr_words[i]))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [] }
    # Cloning this {@code BitSet} produces a new {@code BitSet}
    # that is equal to it.
    # The clone of the bit set is another bit set that has exactly the
    # same bits set to {@code true} as this bit set.
    # 
    # @return a clone of this bit set
    # @see    #size()
    def clone
      if (!@size_is_sticky)
        trim_to_size
      end
      begin
        result = super
        result.attr_words = @words.clone
        result.check_invariants
        return result
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Attempts to reduce internal storage used for the bits in this bit set.
    # Calling this method may, but is not required to, affect the value
    # returned by a subsequent call to the {@link #size()} method.
    def trim_to_size
      if (!(@words_in_use).equal?(@words.attr_length))
        @words = Arrays.copy_of(@words, @words_in_use)
        check_invariants
      end
    end
    
    typesig { [ObjectOutputStream] }
    # Save the state of the {@code BitSet} instance to a stream (i.e.,
    # serialize it).
    def write_object(s)
      check_invariants
      if (!@size_is_sticky)
        trim_to_size
      end
      fields = s.put_fields
      fields.put("bits", @words)
      s.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reconstitute the {@code BitSet} instance from a stream (i.e.,
    # deserialize it).
    def read_object(s)
      fields = s.read_fields
      @words = fields.get("bits", nil)
      # Assume maximum length then find real length
      # because recalculateWordsInUse assumes maintenance
      # or reduction in logical size
      @words_in_use = @words.attr_length
      recalculate_words_in_use
      @size_is_sticky = (@words.attr_length > 0 && (@words[@words.attr_length - 1]).equal?(0)) # heuristic
      check_invariants
    end
    
    typesig { [] }
    # Returns a string representation of this bit set. For every index
    # for which this {@code BitSet} contains a bit in the set
    # state, the decimal representation of that index is included in
    # the result. Such indices are listed in order from lowest to
    # highest, separated by ",&nbsp;" (a comma and a space) and
    # surrounded by braces, resulting in the usual mathematical
    # notation for a set of integers.
    # 
    # <p>Example:
    # <pre>
    # BitSet drPepper = new BitSet();</pre>
    # Now {@code drPepper.toString()} returns "{@code {}}".<p>
    # <pre>
    # drPepper.set(2);</pre>
    # Now {@code drPepper.toString()} returns "{@code {2}}".<p>
    # <pre>
    # drPepper.set(4);
    # drPepper.set(10);</pre>
    # Now {@code drPepper.toString()} returns "{@code {2, 4, 10}}".
    # 
    # @return a string representation of this bit set
    def to_s
      check_invariants
      num_bits = (@words_in_use > 128) ? cardinality : @words_in_use * BITS_PER_WORD
      b = StringBuilder.new(6 * num_bits + 2)
      b.append(Character.new(?{.ord))
      i = next_set_bit(0)
      if (!(i).equal?(-1))
        b.append(i)
        i = next_set_bit(i + 1)
        while i >= 0
          end_of_run = next_clear_bit(i)
          begin
            b.append(", ").append(i)
          end while ((i += 1) < end_of_run)
          i = next_set_bit(i + 1)
        end
      end
      b.append(Character.new(?}.ord))
      return b.to_s
    end
    
    private
    alias_method :initialize__bit_set, :initialize
  end
  
end

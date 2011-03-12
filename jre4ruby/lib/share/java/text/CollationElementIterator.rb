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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module CollationElementIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Lang, :Character
      include_const ::Java::Util, :Vector
      include_const ::Sun::Text, :CollatorUtilities
      include_const ::Sun::Text::Normalizer, :NormalizerBase
    }
  end
  
  # The <code>CollationElementIterator</code> class is used as an iterator
  # to walk through each character of an international string. Use the iterator
  # to return the ordering priority of the positioned character. The ordering
  # priority of a character, which we refer to as a key, defines how a character
  # is collated in the given collation object.
  # 
  # <p>
  # For example, consider the following in Spanish:
  # <blockquote>
  # <pre>
  # "ca" -> the first key is key('c') and second key is key('a').
  # "cha" -> the first key is key('ch') and second key is key('a').
  # </pre>
  # </blockquote>
  # And in German,
  # <blockquote>
  # <pre>
  # "\u00e4b"-> the first key is key('a'), the second key is key('e'), and
  # the third key is key('b').
  # </pre>
  # </blockquote>
  # The key of a character is an integer composed of primary order(short),
  # secondary order(byte), and tertiary order(byte). Java strictly defines
  # the size and signedness of its primitive data types. Therefore, the static
  # functions <code>primaryOrder</code>, <code>secondaryOrder</code>, and
  # <code>tertiaryOrder</code> return <code>int</code>, <code>short</code>,
  # and <code>short</code> respectively to ensure the correctness of the key
  # value.
  # 
  # <p>
  # Example of the iterator usage,
  # <blockquote>
  # <pre>
  # 
  #  String testString = "This is a test";
  #  RuleBasedCollator ruleBasedCollator = (RuleBasedCollator)Collator.getInstance();
  #  CollationElementIterator collationElementIterator = ruleBasedCollator.getCollationElementIterator(testString);
  #  int primaryOrder = CollationElementIterator.primaryOrder(collationElementIterator.next());
  # </pre>
  # </blockquote>
  # 
  # <p>
  # <code>CollationElementIterator.next</code> returns the collation order
  # of the next character. A collation order consists of primary order,
  # secondary order and tertiary order. The data type of the collation
  # order is <strong>int</strong>. The first 16 bits of a collation order
  # is its primary order; the next 8 bits is the secondary order and the
  # last 8 bits is the tertiary order.
  # 
  # @see                Collator
  # @see                RuleBasedCollator
  # @author             Helena Shih, Laura Werner, Richard Gillam
  class CollationElementIterator 
    include_class_members CollationElementIteratorImports
    
    class_module.module_eval {
      # Null order which indicates the end of string is reached by the
      # cursor.
      const_set_lazy(:NULLORDER) { -0x1 }
      const_attr_reader  :NULLORDER
    }
    
    typesig { [String, RuleBasedCollator] }
    # CollationElementIterator constructor.  This takes the source string and
    # the collation object.  The cursor will walk thru the source string based
    # on the predefined collation rules.  If the source string is empty,
    # NULLORDER will be returned on the calls to next().
    # @param sourceText the source string.
    # @param order the collation object.
    def initialize(source_text, owner)
      @text = nil
      @buffer = nil
      @exp_index = 0
      @key = StringBuffer.new(5)
      @swap_order = 0
      @ordering = nil
      @owner = nil
      @owner = owner
      @ordering = owner.get_tables
      if (!(source_text.length).equal?(0))
        mode = CollatorUtilities.to_normalizer_mode(owner.get_decomposition)
        @text = NormalizerBase.new(source_text, mode)
      end
    end
    
    typesig { [CharacterIterator, RuleBasedCollator] }
    # CollationElementIterator constructor.  This takes the source string and
    # the collation object.  The cursor will walk thru the source string based
    # on the predefined collation rules.  If the source string is empty,
    # NULLORDER will be returned on the calls to next().
    # @param sourceText the source string.
    # @param order the collation object.
    def initialize(source_text, owner)
      @text = nil
      @buffer = nil
      @exp_index = 0
      @key = StringBuffer.new(5)
      @swap_order = 0
      @ordering = nil
      @owner = nil
      @owner = owner
      @ordering = owner.get_tables
      mode = CollatorUtilities.to_normalizer_mode(owner.get_decomposition)
      @text = NormalizerBase.new(source_text, mode)
    end
    
    typesig { [] }
    # Resets the cursor to the beginning of the string.  The next call
    # to next() will return the first collation element in the string.
    def reset
      if (!(@text).nil?)
        @text.reset
        mode = CollatorUtilities.to_normalizer_mode(@owner.get_decomposition)
        @text.set_mode(mode)
      end
      @buffer = nil
      @exp_index = 0
      @swap_order = 0
    end
    
    typesig { [] }
    # Get the next collation element in the string.  <p>This iterator iterates
    # over a sequence of collation elements that were built from the string.
    # Because there isn't necessarily a one-to-one mapping from characters to
    # collation elements, this doesn't mean the same thing as "return the
    # collation element [or ordering priority] of the next character in the
    # string".</p>
    # <p>This function returns the collation element that the iterator is currently
    # pointing to and then updates the internal pointer to point to the next element.
    # previous() updates the pointer first and then returns the element.  This
    # means that when you change direction while iterating (i.e., call next() and
    # then call previous(), or call previous() and then call next()), you'll get
    # back the same element twice.</p>
    def next_
      if ((@text).nil?)
        return NULLORDER
      end
      text_mode = @text.get_mode
      # convert the owner's mode to something the Normalizer understands
      owner_mode = CollatorUtilities.to_normalizer_mode(@owner.get_decomposition)
      if (!(text_mode).equal?(owner_mode))
        @text.set_mode(owner_mode)
      end
      # if buffer contains any decomposed char values
      # return their strength orders before continuing in
      # the Normalizer's CharacterIterator.
      if (!(@buffer).nil?)
        if (@exp_index < @buffer.attr_length)
          return strength_order(@buffer[((@exp_index += 1) - 1)])
        else
          @buffer = nil
          @exp_index = 0
        end
      else
        if (!(@swap_order).equal?(0))
          if (Character.is_supplementary_code_point(@swap_order))
            chars = Character.to_chars(@swap_order)
            @swap_order = chars[1]
            return chars[0] << 16
          end
          order = @swap_order << 16
          @swap_order = 0
          return order
        end
      end
      ch = @text.next_
      # are we at the end of Normalizer's text?
      if ((ch).equal?(NormalizerBase::DONE))
        return NULLORDER
      end
      value = @ordering.get_unicode_order(ch)
      if ((value).equal?(RuleBasedCollator::UNMAPPED))
        @swap_order = ch
        return UNMAPPEDCHARVALUE
      else
        if (value >= RuleBasedCollator::CONTRACTCHARINDEX)
          value = next_contract_char(ch)
        end
      end
      if (value >= RuleBasedCollator::EXPANDCHARINDEX)
        @buffer = @ordering.get_expand_value_list(value)
        @exp_index = 0
        value = @buffer[((@exp_index += 1) - 1)]
      end
      if (@ordering.is_seasian_swapping)
        consonant = 0
        if (is_thai_pre_vowel(ch))
          consonant = @text.next_
          if (is_thai_base_consonant(consonant))
            @buffer = make_reordered_buffer(consonant, value, @buffer, true)
            value = @buffer[0]
            @exp_index = 1
          else
            @text.previous
          end
        end
        if (is_lao_pre_vowel(ch))
          consonant = @text.next_
          if (is_lao_base_consonant(consonant))
            @buffer = make_reordered_buffer(consonant, value, @buffer, true)
            value = @buffer[0]
            @exp_index = 1
          else
            @text.previous
          end
        end
      end
      return strength_order(value)
    end
    
    typesig { [] }
    # Get the previous collation element in the string.  <p>This iterator iterates
    # over a sequence of collation elements that were built from the string.
    # Because there isn't necessarily a one-to-one mapping from characters to
    # collation elements, this doesn't mean the same thing as "return the
    # collation element [or ordering priority] of the previous character in the
    # string".</p>
    # <p>This function updates the iterator's internal pointer to point to the
    # collation element preceding the one it's currently pointing to and then
    # returns that element, while next() returns the current element and then
    # updates the pointer.  This means that when you change direction while
    # iterating (i.e., call next() and then call previous(), or call previous()
    # and then call next()), you'll get back the same element twice.</p>
    # @since 1.2
    def previous
      if ((@text).nil?)
        return NULLORDER
      end
      text_mode = @text.get_mode
      # convert the owner's mode to something the Normalizer understands
      owner_mode = CollatorUtilities.to_normalizer_mode(@owner.get_decomposition)
      if (!(text_mode).equal?(owner_mode))
        @text.set_mode(owner_mode)
      end
      if (!(@buffer).nil?)
        if (@exp_index > 0)
          return strength_order(@buffer[(@exp_index -= 1)])
        else
          @buffer = nil
          @exp_index = 0
        end
      else
        if (!(@swap_order).equal?(0))
          if (Character.is_supplementary_code_point(@swap_order))
            chars = Character.to_chars(@swap_order)
            @swap_order = chars[1]
            return chars[0] << 16
          end
          order = @swap_order << 16
          @swap_order = 0
          return order
        end
      end
      ch = @text.previous
      if ((ch).equal?(NormalizerBase::DONE))
        return NULLORDER
      end
      value = @ordering.get_unicode_order(ch)
      if ((value).equal?(RuleBasedCollator::UNMAPPED))
        @swap_order = UNMAPPEDCHARVALUE
        return ch
      else
        if (value >= RuleBasedCollator::CONTRACTCHARINDEX)
          value = prev_contract_char(ch)
        end
      end
      if (value >= RuleBasedCollator::EXPANDCHARINDEX)
        @buffer = @ordering.get_expand_value_list(value)
        @exp_index = @buffer.attr_length
        value = @buffer[(@exp_index -= 1)]
      end
      if (@ordering.is_seasian_swapping)
        vowel = 0
        if (is_thai_base_consonant(ch))
          vowel = @text.previous
          if (is_thai_pre_vowel(vowel))
            @buffer = make_reordered_buffer(vowel, value, @buffer, false)
            @exp_index = @buffer.attr_length - 1
            value = @buffer[@exp_index]
          else
            @text.next_
          end
        end
        if (is_lao_base_consonant(ch))
          vowel = @text.previous
          if (is_lao_pre_vowel(vowel))
            @buffer = make_reordered_buffer(vowel, value, @buffer, false)
            @exp_index = @buffer.attr_length - 1
            value = @buffer[@exp_index]
          else
            @text.next_
          end
        end
      end
      return strength_order(value)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Return the primary component of a collation element.
      # @param order the collation element
      # @return the element's primary component
      def primary_order(order)
        order &= RBCollationTables::PRIMARYORDERMASK
        return (order >> RBCollationTables::PRIMARYORDERSHIFT)
      end
      
      typesig { [::Java::Int] }
      # Return the secondary component of a collation element.
      # @param order the collation element
      # @return the element's secondary component
      def secondary_order(order)
        order = order & RBCollationTables::SECONDARYORDERMASK
        return (RJava.cast_to_short((order >> RBCollationTables::SECONDARYORDERSHIFT)))
      end
      
      typesig { [::Java::Int] }
      # Return the tertiary component of a collation element.
      # @param order the collation element
      # @return the element's tertiary component
      def tertiary_order(order)
        return (RJava.cast_to_short((order &= RBCollationTables::TERTIARYORDERMASK)))
      end
    }
    
    typesig { [::Java::Int] }
    # Get the comparison order in the desired strength.  Ignore the other
    # differences.
    # @param order The order value
    def strength_order(order)
      s = @owner.get_strength
      if ((s).equal?(Collator::PRIMARY))
        order &= RBCollationTables::PRIMARYDIFFERENCEONLY
      else
        if ((s).equal?(Collator::SECONDARY))
          order &= RBCollationTables::SECONDARYDIFFERENCEONLY
        end
      end
      return order
    end
    
    typesig { [::Java::Int] }
    # Sets the iterator to point to the collation element corresponding to
    # the specified character (the parameter is a CHARACTER offset in the
    # original string, not an offset into its corresponding sequence of
    # collation elements).  The value returned by the next call to next()
    # will be the collation element corresponding to the specified position
    # in the text.  If that position is in the middle of a contracting
    # character sequence, the result of the next call to next() is the
    # collation element for that sequence.  This means that getOffset()
    # is not guaranteed to return the same value as was passed to a preceding
    # call to setOffset().
    # 
    # @param newOffset The new character offset into the original text.
    # @since 1.2
    def set_offset(new_offset)
      if (!(@text).nil?)
        if (new_offset < @text.get_begin_index || new_offset >= @text.get_end_index)
          @text.set_index_only(new_offset)
        else
          c = @text.set_index(new_offset)
          # if the desired character isn't used in a contracting character
          # sequence, bypass all the backing-up logic-- we're sitting on
          # the right character already
          if (@ordering.used_in_contract_seq(c))
            # walk backwards through the string until we see a character
            # that DOESN'T participate in a contracting character sequence
            while (@ordering.used_in_contract_seq(c))
              c = @text.previous
            end
            # now walk forward using this object's next() method until
            # we pass the starting point and set our current position
            # to the beginning of the last "character" before or at
            # our starting position
            last = @text.get_index
            while (@text.get_index <= new_offset)
              last = @text.get_index
              next_
            end
            @text.set_index_only(last)
            # we don't need this, since last is the last index
            # that is the starting of the contraction which encompass
            # newOffset
            # text.previous();
          end
        end
      end
      @buffer = nil
      @exp_index = 0
      @swap_order = 0
    end
    
    typesig { [] }
    # Returns the character offset in the original text corresponding to the next
    # collation element.  (That is, getOffset() returns the position in the text
    # corresponding to the collation element that will be returned by the next
    # call to next().)  This value will always be the index of the FIRST character
    # corresponding to the collation element (a contracting character sequence is
    # when two or more characters all correspond to the same collation element).
    # This means if you do setOffset(x) followed immediately by getOffset(), getOffset()
    # won't necessarily return x.
    # 
    # @return The character offset in the original text corresponding to the collation
    # element that will be returned by the next call to next().
    # @since 1.2
    def get_offset
      return (!(@text).nil?) ? @text.get_index : 0
    end
    
    typesig { [::Java::Int] }
    # Return the maximum length of any expansion sequences that end
    # with the specified comparison order.
    # @param order a collation order returned by previous or next.
    # @return the maximum length of any expansion sequences ending
    #         with the specified order.
    # @since 1.2
    def get_max_expansion(order)
      return @ordering.get_max_expansion(order)
    end
    
    typesig { [String] }
    # Set a new string over which to iterate.
    # 
    # @param source  the new source text
    # @since 1.2
    def set_text(source)
      @buffer = nil
      @swap_order = 0
      @exp_index = 0
      mode = CollatorUtilities.to_normalizer_mode(@owner.get_decomposition)
      if ((@text).nil?)
        @text = NormalizerBase.new(source, mode)
      else
        @text.set_mode(mode)
        @text.set_text(source)
      end
    end
    
    typesig { [CharacterIterator] }
    # Set a new string over which to iterate.
    # 
    # @param source  the new source text.
    # @since 1.2
    def set_text(source)
      @buffer = nil
      @swap_order = 0
      @exp_index = 0
      mode = CollatorUtilities.to_normalizer_mode(@owner.get_decomposition)
      if ((@text).nil?)
        @text = NormalizerBase.new(source, mode)
      else
        @text.set_mode(mode)
        @text.set_text(source)
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # ============================================================
      # privates
      # ============================================================
      # Determine if a character is a Thai vowel (which sorts after
      # its base consonant).
      def is_thai_pre_vowel(ch)
        return (ch >= 0xe40) && (ch <= 0xe44)
      end
      
      typesig { [::Java::Int] }
      # Determine if a character is a Thai base consonant
      def is_thai_base_consonant(ch)
        return (ch >= 0xe01) && (ch <= 0xe2e)
      end
      
      typesig { [::Java::Int] }
      # Determine if a character is a Lao vowel (which sorts after
      # its base consonant).
      def is_lao_pre_vowel(ch)
        return (ch >= 0xec0) && (ch <= 0xec4)
      end
      
      typesig { [::Java::Int] }
      # Determine if a character is a Lao base consonant
      def is_lao_base_consonant(ch)
        return (ch >= 0xe81) && (ch <= 0xeae)
      end
    }
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Int), ::Java::Boolean] }
    # This method produces a buffer which contains the collation
    # elements for the two characters, with colFirst's values preceding
    # another character's.  Presumably, the other character precedes colFirst
    # in logical order (otherwise you wouldn't need this method would you?).
    # The assumption is that the other char's value(s) have already been
    # computed.  If this char has a single element it is passed to this
    # method as lastValue, and lastExpansion is null.  If it has an
    # expansion it is passed in lastExpansion, and colLastValue is ignored.
    def make_reordered_buffer(col_first, last_value, last_expansion, forward)
      result = nil
      first_value = @ordering.get_unicode_order(col_first)
      if (first_value >= RuleBasedCollator::CONTRACTCHARINDEX)
        first_value = forward ? next_contract_char(col_first) : prev_contract_char(col_first)
      end
      first_expansion = nil
      if (first_value >= RuleBasedCollator::EXPANDCHARINDEX)
        first_expansion = @ordering.get_expand_value_list(first_value)
      end
      if (!forward)
        temp1 = first_value
        first_value = last_value
        last_value = temp1
        temp2 = first_expansion
        first_expansion = last_expansion
        last_expansion = temp2
      end
      if ((first_expansion).nil? && (last_expansion).nil?)
        result = Array.typed(::Java::Int).new(2) { 0 }
        result[0] = first_value
        result[1] = last_value
      else
        first_length = (first_expansion).nil? ? 1 : first_expansion.attr_length
        last_length = (last_expansion).nil? ? 1 : last_expansion.attr_length
        result = Array.typed(::Java::Int).new(first_length + last_length) { 0 }
        if ((first_expansion).nil?)
          result[0] = first_value
        else
          System.arraycopy(first_expansion, 0, result, 0, first_length)
        end
        if ((last_expansion).nil?)
          result[first_length] = last_value
        else
          System.arraycopy(last_expansion, 0, result, first_length, last_length)
        end
      end
      return result
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Check if a comparison order is ignorable.
      # @return true if a character is ignorable, false otherwise.
      def is_ignorable(order)
        return (((primary_order(order)).equal?(0)) ? true : false)
      end
    }
    
    typesig { [::Java::Int] }
    # Get the ordering priority of the next contracting character in the
    # string.
    # @param ch the starting character of a contracting character token
    # @return the next contracting character's ordering.  Returns NULLORDER
    # if the end of string is reached.
    def next_contract_char(ch)
      # First get the ordering of this single character,
      # which is always the first element in the list
      list = @ordering.get_contract_values(ch)
      pair = list.first_element
      order = pair.attr_value
      # find out the length of the longest contracting character sequence in the list.
      # There's logic in the builder code to make sure the longest sequence is always
      # the last.
      pair = list.last_element
      max_length = pair.attr_entry_name.length
      # (the Normalizer is cloned here so that the seeking we do in the next loop
      # won't affect our real position in the text)
      temp_text = @text.clone
      # extract the next maxLength characters in the string (we have to do this using the
      # Normalizer to ensure that our offsets correspond to those the rest of the
      # iterator is using) and store it in "fragment".
      temp_text.previous
      @key.set_length(0)
      c = temp_text.next_
      while (max_length > 0 && !(c).equal?(NormalizerBase::DONE))
        if (Character.is_supplementary_code_point(c))
          @key.append(Character.to_chars(c))
          max_length -= 2
        else
          @key.append(RJava.cast_to_char(c))
          (max_length -= 1)
        end
        c = temp_text.next_
      end
      fragment = @key.to_s
      # now that we have that fragment, iterate through this list looking for the
      # longest sequence that matches the characters in the actual text.  (maxLength
      # is used here to keep track of the length of the longest sequence)
      # Upon exit from this loop, maxLength will contain the length of the matching
      # sequence and order will contain the collation-element value corresponding
      # to this sequence
      max_length = 1
      i = list.size - 1
      while i > 0
        pair = list.element_at(i)
        if (!pair.attr_fwd)
          i -= 1
          next
        end
        if (fragment.starts_with(pair.attr_entry_name) && pair.attr_entry_name.length > max_length)
          max_length = pair.attr_entry_name.length
          order = pair.attr_value
        end
        i -= 1
      end
      # seek our current iteration position to the end of the matching sequence
      # and return the appropriate collation-element value (if there was no matching
      # sequence, we're already seeked to the right position and order already contains
      # the correct collation-element value for the single character)
      while (max_length > 1)
        c = @text.next_
        max_length -= Character.char_count(c)
      end
      return order
    end
    
    typesig { [::Java::Int] }
    # Get the ordering priority of the previous contracting character in the
    # string.
    # @param ch the starting character of a contracting character token
    # @return the next contracting character's ordering.  Returns NULLORDER
    # if the end of string is reached.
    def prev_contract_char(ch)
      # This function is identical to nextContractChar(), except that we've
      # switched things so that the next() and previous() calls on the Normalizer
      # are switched and so that we skip entry pairs with the fwd flag turned on
      # rather than off.  Notice that we still use append() and startsWith() when
      # working on the fragment.  This is because the entry pairs that are used
      # in reverse iteration have their names reversed already.
      list = @ordering.get_contract_values(ch)
      pair = list.first_element
      order = pair.attr_value
      pair = list.last_element
      max_length = pair.attr_entry_name.length
      temp_text = @text.clone
      temp_text.next_
      @key.set_length(0)
      c = temp_text.previous
      while (max_length > 0 && !(c).equal?(NormalizerBase::DONE))
        if (Character.is_supplementary_code_point(c))
          @key.append(Character.to_chars(c))
          max_length -= 2
        else
          @key.append(RJava.cast_to_char(c))
          (max_length -= 1)
        end
        c = temp_text.previous
      end
      fragment = @key.to_s
      max_length = 1
      i = list.size - 1
      while i > 0
        pair = list.element_at(i)
        if (pair.attr_fwd)
          i -= 1
          next
        end
        if (fragment.starts_with(pair.attr_entry_name) && pair.attr_entry_name.length > max_length)
          max_length = pair.attr_entry_name.length
          order = pair.attr_value
        end
        i -= 1
      end
      while (max_length > 1)
        c = @text.previous
        max_length -= Character.char_count(c)
      end
      return order
    end
    
    class_module.module_eval {
      const_set_lazy(:UNMAPPEDCHARVALUE) { 0x7fff0000 }
      const_attr_reader  :UNMAPPEDCHARVALUE
    }
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    attr_accessor :exp_index
    alias_method :attr_exp_index, :exp_index
    undef_method :exp_index
    alias_method :attr_exp_index=, :exp_index=
    undef_method :exp_index=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :swap_order
    alias_method :attr_swap_order, :swap_order
    undef_method :swap_order
    alias_method :attr_swap_order=, :swap_order=
    undef_method :swap_order=
    
    attr_accessor :ordering
    alias_method :attr_ordering, :ordering
    undef_method :ordering
    alias_method :attr_ordering=, :ordering=
    undef_method :ordering=
    
    attr_accessor :owner
    alias_method :attr_owner, :owner
    undef_method :owner
    alias_method :attr_owner=, :owner=
    undef_method :owner=
    
    private
    alias_method :initialize__collation_element_iterator, :initialize
  end
  
end

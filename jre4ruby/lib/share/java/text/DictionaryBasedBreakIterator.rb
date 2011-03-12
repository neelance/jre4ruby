require "rjava"

# Copyright 1999-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996 - 2002 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module DictionaryBasedBreakIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Stack
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Text, :CharacterIterator
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # A subclass of RuleBasedBreakIterator that adds the ability to use a dictionary
  # to further subdivide ranges of text beyond what is possible using just the
  # state-table-based algorithm.  This is necessary, for example, to handle
  # word and line breaking in Thai, which doesn't use spaces between words.  The
  # state-table-based algorithm used by RuleBasedBreakIterator is used to divide
  # up text as far as possible, and then contiguous ranges of letters are
  # repeatedly compared against a list of known words (i.e., the dictionary)
  # to divide them up into words.
  # 
  # DictionaryBasedBreakIterator uses the same rule language as RuleBasedBreakIterator,
  # but adds one more special substitution name: &lt;dictionary&gt;.  This substitution
  # name is used to identify characters in words in the dictionary.  The idea is that
  # if the iterator passes over a chunk of text that includes two or more characters
  # in a row that are included in &lt;dictionary&gt;, it goes back through that range and
  # derives additional break positions (if possible) using the dictionary.
  # 
  # DictionaryBasedBreakIterator is also constructed with the filename of a dictionary
  # file.  It follows a prescribed search path to locate the dictionary (right now,
  # it looks for it in /com/ibm/text/resources in each directory in the classpath,
  # and won't find it in JAR files, but this location is likely to change).  The
  # dictionary file is in a serialized binary format.  We have a very primitive (and
  # slow) BuildDictionaryFile utility for creating dictionary files, but aren't
  # currently making it public.  Contact us for help.
  class DictionaryBasedBreakIterator < DictionaryBasedBreakIteratorImports.const_get :RuleBasedBreakIterator
    include_class_members DictionaryBasedBreakIteratorImports
    
    # a list of known words that is used to divide up contiguous ranges of letters,
    # stored in a compressed, indexed, format that offers fast access
    attr_accessor :dictionary
    alias_method :attr_dictionary, :dictionary
    undef_method :dictionary
    alias_method :attr_dictionary=, :dictionary=
    undef_method :dictionary=
    
    # a list of flags indicating which character categories are contained in
    # the dictionary file (this is used to determine which ranges of characters
    # to apply the dictionary to)
    attr_accessor :category_flags
    alias_method :attr_category_flags, :category_flags
    undef_method :category_flags
    alias_method :attr_category_flags=, :category_flags=
    undef_method :category_flags=
    
    # a temporary hiding place for the number of dictionary characters in the
    # last range passed over by next()
    attr_accessor :dictionary_char_count
    alias_method :attr_dictionary_char_count, :dictionary_char_count
    undef_method :dictionary_char_count
    alias_method :attr_dictionary_char_count=, :dictionary_char_count=
    undef_method :dictionary_char_count=
    
    # when a range of characters is divided up using the dictionary, the break
    # positions that are discovered are stored here, preventing us from having
    # to use either the dictionary or the state table again until the iterator
    # leaves this range of text
    attr_accessor :cached_break_positions
    alias_method :attr_cached_break_positions, :cached_break_positions
    undef_method :cached_break_positions
    alias_method :attr_cached_break_positions=, :cached_break_positions=
    undef_method :cached_break_positions=
    
    # if cachedBreakPositions is not null, this indicates which item in the
    # cache the current iteration position refers to
    attr_accessor :position_in_cache
    alias_method :attr_position_in_cache, :position_in_cache
    undef_method :position_in_cache
    alias_method :attr_position_in_cache=, :position_in_cache=
    undef_method :position_in_cache=
    
    typesig { [String, String] }
    # Constructs a DictionaryBasedBreakIterator.
    # @param description Same as the description parameter on RuleBasedBreakIterator,
    # except for the special meaning of "<dictionary>".  This parameter is just
    # passed through to RuleBasedBreakIterator's constructor.
    # @param dictionaryFilename The filename of the dictionary file to use
    def initialize(data_file, dictionary_file)
      @dictionary = nil
      @category_flags = nil
      @dictionary_char_count = 0
      @cached_break_positions = nil
      @position_in_cache = 0
      super(data_file)
      tmp = RuleBasedBreakIterator.instance_method(:get_additional_data).bind(self).call
      if (!(tmp).nil?)
        prepare_category_flags(tmp)
        RuleBasedBreakIterator.instance_method(:set_additional_data).bind(self).call(nil)
      end
      @dictionary = BreakDictionary.new(dictionary_file)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def prepare_category_flags(data)
      @category_flags = Array.typed(::Java::Boolean).new(data.attr_length) { false }
      i = 0
      while i < data.attr_length
        @category_flags[i] = ((data[i]).equal?(1)) ? true : false
        i += 1
      end
    end
    
    typesig { [CharacterIterator] }
    def set_text(new_text)
      super(new_text)
      @cached_break_positions = nil
      @dictionary_char_count = 0
      @position_in_cache = 0
    end
    
    typesig { [] }
    # Sets the current iteration position to the beginning of the text.
    # (i.e., the CharacterIterator's starting offset).
    # @return The offset of the beginning of the text.
    def first
      @cached_break_positions = nil
      @dictionary_char_count = 0
      @position_in_cache = 0
      return super
    end
    
    typesig { [] }
    # Sets the current iteration position to the end of the text.
    # (i.e., the CharacterIterator's ending offset).
    # @return The text's past-the-end offset.
    def last
      @cached_break_positions = nil
      @dictionary_char_count = 0
      @position_in_cache = 0
      return super
    end
    
    typesig { [] }
    # Advances the iterator one step backwards.
    # @return The position of the last boundary position before the
    # current iteration position
    def previous
      text = get_text
      # if we have cached break positions and we're still in the range
      # covered by them, just move one step backward in the cache
      if (!(@cached_break_positions).nil? && @position_in_cache > 0)
        (@position_in_cache -= 1)
        text.set_index(@cached_break_positions[@position_in_cache])
        return @cached_break_positions[@position_in_cache]
        # otherwise, dump the cache and use the inherited previous() method to move
        # backward.  This may fill up the cache with new break positions, in which
        # case we have to mark our position in the cache
      else
        @cached_break_positions = nil
        result = super
        if (!(@cached_break_positions).nil?)
          @position_in_cache = @cached_break_positions.attr_length - 2
        end
        return result
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the current iteration position to the last boundary position
    # before the specified position.
    # @param offset The position to begin searching from
    # @return The position of the last boundary before "offset"
    def preceding(offset)
      text = get_text
      check_offset(offset, text)
      # if we have no cached break positions, or "offset" is outside the
      # range covered by the cache, we can just call the inherited routine
      # (which will eventually call other routines in this class that may
      # refresh the cache)
      if ((@cached_break_positions).nil? || offset <= @cached_break_positions[0] || offset > @cached_break_positions[@cached_break_positions.attr_length - 1])
        @cached_break_positions = nil
        return super(offset)
        # on the other hand, if "offset" is within the range covered by the cache,
        # then all we have to do is search the cache for the last break position
        # before "offset"
      else
        @position_in_cache = 0
        while (@position_in_cache < @cached_break_positions.attr_length && offset > @cached_break_positions[@position_in_cache])
          (@position_in_cache += 1)
        end
        (@position_in_cache -= 1)
        text.set_index(@cached_break_positions[@position_in_cache])
        return text.get_index
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the current iteration position to the first boundary position after
    # the specified position.
    # @param offset The position to begin searching forward from
    # @return The position of the first boundary after "offset"
    def following(offset)
      text = get_text
      check_offset(offset, text)
      # if we have no cached break positions, or if "offset" is outside the
      # range covered by the cache, then dump the cache and call our
      # inherited following() method.  This will call other methods in this
      # class that may refresh the cache.
      if ((@cached_break_positions).nil? || offset < @cached_break_positions[0] || offset >= @cached_break_positions[@cached_break_positions.attr_length - 1])
        @cached_break_positions = nil
        return super(offset)
        # on the other hand, if "offset" is within the range covered by the
        # cache, then just search the cache for the first break position
        # after "offset"
      else
        @position_in_cache = 0
        while (@position_in_cache < @cached_break_positions.attr_length && offset >= @cached_break_positions[@position_in_cache])
          (@position_in_cache += 1)
        end
        text.set_index(@cached_break_positions[@position_in_cache])
        return text.get_index
      end
    end
    
    typesig { [] }
    # This is the implementation function for next().
    def handle_next
      text = get_text
      # if there are no cached break positions, or if we've just moved
      # off the end of the range covered by the cache, we have to dump
      # and possibly regenerate the cache
      if ((@cached_break_positions).nil? || (@position_in_cache).equal?(@cached_break_positions.attr_length - 1))
        # start by using the inherited handleNext() to find a tentative return
        # value.   dictionaryCharCount tells us how many dictionary characters
        # we passed over on our way to the tentative return value
        start_pos = text.get_index
        @dictionary_char_count = 0
        result = super
        # if we passed over more than one dictionary character, then we use
        # divideUpDictionaryRange() to regenerate the cached break positions
        # for the new range
        if (@dictionary_char_count > 1 && result - start_pos > 1)
          divide_up_dictionary_range(start_pos, result)
          # otherwise, the value we got back from the inherited fuction
          # is our return value, and we can dump the cache
        else
          @cached_break_positions = nil
          return result
        end
      end
      # if the cache of break positions has been regenerated (or existed all
      # along), then just advance to the next break position in the cache
      # and return it
      if (!(@cached_break_positions).nil?)
        (@position_in_cache += 1)
        text.set_index(@cached_break_positions[@position_in_cache])
        return @cached_break_positions[@position_in_cache]
      end
      return -9999 # SHOULD NEVER GET HERE!
    end
    
    typesig { [::Java::Int] }
    # Looks up a character category for a character.
    def lookup_category(c)
      # this override of lookupCategory() exists only to keep track of whether we've
      # passed over any dictionary characters.  It calls the inherited lookupCategory()
      # to do the real work, and then checks whether its return value is one of the
      # categories represented in the dictionary.  If it is, bump the dictionary-
      # character count.
      result = super(c)
      if (!(result).equal?(RuleBasedBreakIterator::IGNORE) && @category_flags[result])
        (@dictionary_char_count += 1)
      end
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # This is the function that actually implements the dictionary-based
    # algorithm.  Given the endpoints of a range of text, it uses the
    # dictionary to determine the positions of any boundaries in this
    # range.  It stores all the boundary positions it discovers in
    # cachedBreakPositions so that we only have to do this work once
    # for each time we enter the range.
    def divide_up_dictionary_range(start_pos, end_pos)
      text = get_text
      # the range we're dividing may begin or end with non-dictionary characters
      # (i.e., for line breaking, we may have leading or trailing punctuation
      # that needs to be kept with the word).  Seek from the beginning of the
      # range to the first dictionary character
      text.set_index(start_pos)
      c = get_current
      category = lookup_category(c)
      while ((category).equal?(IGNORE) || !@category_flags[category])
        c = get_next
        category = lookup_category(c)
      end
      # initialize.  We maintain two stacks: currentBreakPositions contains
      # the list of break positions that will be returned if we successfully
      # finish traversing the whole range now.  possibleBreakPositions lists
      # all other possible word ends we've passed along the way.  (Whenever
      # we reach an error [a sequence of characters that can't begin any word
      # in the dictionary], we back up, possibly delete some breaks from
      # currentBreakPositions, move a break from possibleBreakPositions
      # to currentBreakPositions, and start over from there.  This process
      # continues in this way until we either successfully make it all the way
      # across the range, or exhaust all of our combinations of break
      # positions.)
      current_break_positions = Stack.new
      possible_break_positions = Stack.new
      wrong_break_positions = Vector.new
      # the dictionary is implemented as a trie, which is treated as a state
      # machine.  -1 represents the end of a legal word.  Every word in the
      # dictionary is represented by a path from the root node to -1.  A path
      # that ends in state 0 is an illegal combination of characters.
      state = 0
      # these two variables are used for error handling.  We keep track of the
      # farthest we've gotten through the range being divided, and the combination
      # of breaks that got us that far.  If we use up all possible break
      # combinations, the text contains an error or a word that's not in the
      # dictionary.  In this case, we "bless" the break positions that got us the
      # farthest as real break positions, and then start over from scratch with
      # the character where the error occurred.
      farthest_end_point = text.get_index
      best_break_positions = nil
      # initialize (we always exit the loop with a break statement)
      c = get_current
      while (true)
        # if we can transition to state "-1" from our current state, we're
        # on the last character of a legal word.  Push that position onto
        # the possible-break-positions stack
        if ((@dictionary.get_next_state(state, 0)).equal?(-1))
          possible_break_positions.push(text.get_index)
        end
        # look up the new state to transition to in the dictionary
        state = @dictionary.get_next_state_from_character(state, c)
        # if the character we're sitting on causes us to transition to
        # the "end of word" state, then it was a non-dictionary character
        # and we've successfully traversed the whole range.  Drop out
        # of the loop.
        if ((state).equal?(-1))
          current_break_positions.push(text.get_index)
          break
          # if the character we're sitting on causes us to transition to
          # the error state, or if we've gone off the end of the range
          # without transitioning to the "end of word" state, we've hit
          # an error...
        else
          if ((state).equal?(0) || text.get_index >= end_pos)
            # if this is the farthest we've gotten, take note of it in
            # case there's an error in the text
            if (text.get_index > farthest_end_point)
              farthest_end_point = text.get_index
              best_break_positions = (current_break_positions.clone)
            end
            # wrongBreakPositions is a list of all break positions
            # we've tried starting that didn't allow us to traverse
            # all the way through the text.  Every time we pop a
            # break position off of currentBreakPositions, we put it
            # into wrongBreakPositions to avoid trying it again later.
            # If we make it to this spot, we're either going to back
            # up to a break in possibleBreakPositions and try starting
            # over from there, or we've exhausted all possible break
            # positions and are going to do the fallback procedure.
            # This loop prevents us from messing with anything in
            # possibleBreakPositions that didn't work as a starting
            # point the last time we tried it (this is to prevent a bunch of
            # repetitive checks from slowing down some extreme cases)
            new_starting_spot = nil
            while (!possible_break_positions.is_empty && wrong_break_positions.contains(possible_break_positions.peek))
              possible_break_positions.pop
            end
            # if we've used up all possible break-position combinations, there's
            # an error or an unknown word in the text.  In this case, we start
            # over, treating the farthest character we've reached as the beginning
            # of the range, and "blessing" the break positions that got us that
            # far as real break positions
            if (possible_break_positions.is_empty)
              if (!(best_break_positions).nil?)
                current_break_positions = best_break_positions
                if (farthest_end_point < end_pos)
                  text.set_index(farthest_end_point + 1)
                else
                  break
                end
              else
                if (((current_break_positions.size).equal?(0) || !(((current_break_positions.peek)).int_value).equal?(text.get_index)) && !(text.get_index).equal?(start_pos))
                  current_break_positions.push(text.get_index)
                end
                get_next
                current_break_positions.push(text.get_index)
              end
              # if we still have more break positions we can try, then promote the
              # last break in possibleBreakPositions into currentBreakPositions,
              # and get rid of all entries in currentBreakPositions that come after
              # it.  Then back up to that position and start over from there (i.e.,
              # treat that position as the beginning of a new word)
            else
              temp = possible_break_positions.pop
              temp2 = nil
              while (!current_break_positions.is_empty && temp.int_value < (current_break_positions.peek).int_value)
                temp2 = current_break_positions.pop
                wrong_break_positions.add_element(temp2)
              end
              current_break_positions.push(temp)
              text.set_index((current_break_positions.peek).int_value)
            end
            # re-sync "c" for the next go-round, and drop out of the loop if
            # we've made it off the end of the range
            c = get_current
            if (text.get_index >= end_pos)
              break
            end
            # if we didn't hit any exceptional conditions on this last iteration,
            # just advance to the next character and loop
          else
            c = get_next
          end
        end
      end
      # dump the last break position in the list, and replace it with the actual
      # end of the range (which may be the same character, or may be further on
      # because the range actually ended with non-dictionary characters we want to
      # keep with the word)
      if (!current_break_positions.is_empty)
        current_break_positions.pop
      end
      current_break_positions.push(end_pos)
      # create a regular array to hold the break positions and copy
      # the break positions from the stack to the array (in addition,
      # our starting position goes into this array as a break position).
      # This array becomes the cache of break positions used by next()
      # and previous(), so this is where we actually refresh the cache.
      @cached_break_positions = Array.typed(::Java::Int).new(current_break_positions.size + 1) { 0 }
      @cached_break_positions[0] = start_pos
      i = 0
      while i < current_break_positions.size
        @cached_break_positions[i + 1] = (current_break_positions.element_at(i)).int_value
        i += 1
      end
      @position_in_cache = 0
    end
    
    private
    alias_method :initialize__dictionary_based_break_iterator, :initialize
  end
  
end

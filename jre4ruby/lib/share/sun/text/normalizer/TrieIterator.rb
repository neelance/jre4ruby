require "rjava"

# Portions Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
#                                                                             *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module TrieIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
    }
  end
  
  # <p>Class enabling iteration of the values in a Trie.</p>
  # <p>Result of each iteration contains the interval of codepoints that have
  # the same value type and the value type itself.</p>
  # <p>The comparison of each codepoint value is done via extract(), which the
  # default implementation is to return the value as it is.</p>
  # <p>Method extract() can be overwritten to perform manipulations on
  # codepoint values in order to perform specialized comparison.</p>
  # <p>TrieIterator is designed to be a generic iterator for the CharTrie
  # and the IntTrie, hence to accommodate both types of data, the return
  # result will be in terms of int (32 bit) values.</p>
  # <p>See com.ibm.icu.text.UCharacterTypeIterator for examples of use.</p>
  # <p>Notes for porting utrie_enum from icu4c to icu4j:<br>
  # Internally, icu4c's utrie_enum performs all iterations in its body. In Java
  # sense, the caller will have to pass a object with a callback function
  # UTrieEnumRange(const void *context, UChar32 start, UChar32 limit,
  # uint32_t value) into utrie_enum. utrie_enum will then find ranges of
  # codepoints with the same value as determined by
  # UTrieEnumValue(const void *context, uint32_t value). for each range,
  # utrie_enum calls the callback function to perform a task. In this way,
  # icu4c performs the iteration within utrie_enum.
  # To follow the JDK model, icu4j is slightly different from icu4c.
  # Instead of requesting the caller to implement an object for a callback.
  # The caller will have to implement a subclass of TrieIterator, fleshing out
  # the method extract(int) (equivalent to UTrieEnumValue). Independent of icu4j,
  # the caller will have to code his own iteration and flesh out the task
  # (equivalent to UTrieEnumRange) to be performed in the iteration loop.
  # </p>
  # <p>There are basically 3 usage scenarios for porting:</p>
  # <p>1) UTrieEnumValue is the only implemented callback then just implement a
  # subclass of TrieIterator and override the extract(int) method. The
  # extract(int) method is analogus to UTrieEnumValue callback.
  # </p>
  # <p>2) UTrieEnumValue and UTrieEnumRange both are implemented then implement
  # a subclass of TrieIterator, override the extract method and iterate, e.g
  # </p>
  # <p>utrie_enum(&normTrie, _enumPropertyStartsValue, _enumPropertyStartsRange,
  #               set);<br>
  # In Java :<br>
  # <pre>
  # class TrieIteratorImpl extends TrieIterator{
  #     public TrieIteratorImpl(Trie data){
  #         super(data);
  #     }
  #     public int extract(int value){
  #         // port the implementation of _enumPropertyStartsValue here
  #     }
  # }
  # ....
  # TrieIterator fcdIter  = new TrieIteratorImpl(fcdTrieImpl.fcdTrie);
  # while(fcdIter.next(result)) {
  #     // port the implementation of _enumPropertyStartsRange
  # }
  # </pre>
  # </p>
  # <p>3) UTrieEnumRange is the only implemented callback then just implement
  # the while loop, when utrie_enum is called
  # <pre>
  # // utrie_enum(&fcdTrie, NULL, _enumPropertyStartsRange, set);
  # TrieIterator fcdIter  = new TrieIterator(fcdTrieImpl.fcdTrie);
  # while(fcdIter.next(result)){
  #     set.add(result.start);
  # }
  # </pre>
  # </p>
  # @author synwee
  # @see com.ibm.icu.impl.Trie
  # @see com.ibm.icu.lang.UCharacterTypeIterator
  # @since release 2.1, Jan 17 2002
  class TrieIterator 
    include_class_members TrieIteratorImports
    include RangeValueIterator
    
    typesig { [Trie] }
    # public constructor ---------------------------------------------
    # TrieEnumeration constructor
    # @param trie to be used
    # @exception IllegalArgumentException throw when argument is null.
    # @draft 2.1
    def initialize(trie)
      @m_trie_ = nil
      @m_initial_value_ = 0
      @m_current_codepoint_ = 0
      @m_next_codepoint_ = 0
      @m_next_value_ = 0
      @m_next_index_ = 0
      @m_next_block_ = 0
      @m_next_block_index_ = 0
      @m_next_trail_index_offset_ = 0
      @m_start_ = 0
      @m_limit_ = 0
      @m_value_ = 0
      if ((trie).nil?)
        raise IllegalArgumentException.new("Argument trie cannot be null")
      end
      @m_trie_ = trie
      # synwee: check that extract belongs to the child class
      @m_initial_value_ = extract(@m_trie_.get_initial_value)
      reset
    end
    
    typesig { [Element] }
    # public methods -------------------------------------------------
    # <p>Returns true if we are not at the end of the iteration, false
    # otherwise.</p>
    # <p>The next set of codepoints with the same value type will be
    # calculated during this call and returned in the arguement element.</p>
    # @param element return result
    # @return true if we are not at the end of the iteration, false otherwise.
    # @exception NoSuchElementException - if no more elements exist.
    # @see com.ibm.icu.util.RangeValueIterator.Element
    # @draft 2.1
    def next_(element)
      if (@m_next_codepoint_ > UCharacter::MAX_VALUE)
        return false
      end
      if (@m_next_codepoint_ < UCharacter::SUPPLEMENTARY_MIN_VALUE && calculate_next_bmpelement(element))
        return true
      end
      calculate_next_supplementary_element(element)
      return true
    end
    
    typesig { [] }
    # Resets the iterator to the beginning of the iteration
    # @draft 2.1
    def reset
      @m_current_codepoint_ = 0
      @m_next_codepoint_ = 0
      @m_next_index_ = 0
      @m_next_block_ = @m_trie_.attr_m_index_[0] << Trie::INDEX_STAGE_2_SHIFT_
      if ((@m_next_block_).equal?(0))
        @m_next_value_ = @m_initial_value_
      else
        @m_next_value_ = extract(@m_trie_.get_value(@m_next_block_))
      end
      @m_next_block_index_ = 0
      @m_next_trail_index_offset_ = TRAIL_SURROGATE_INDEX_BLOCK_LENGTH_
    end
    
    typesig { [::Java::Int] }
    # protected methods ----------------------------------------------
    # Called by next() to extracts a 32 bit value from a trie value
    # used for comparison.
    # This method is to be overwritten if special manipulation is to be done
    # to retrieve a relevant comparison.
    # The default function is to return the value as it is.
    # @param value a value from the trie
    # @return extracted value
    # @draft 2.1
    def extract(value)
      return value
    end
    
    typesig { [Element, ::Java::Int, ::Java::Int, ::Java::Int] }
    # private methods ------------------------------------------------
    # Set the result values
    # @param element return result object
    # @param start codepoint of range
    # @param limit (end + 1) codepoint of range
    # @param value common value of range
    def set_result(element, start, limit, value)
      element.attr_start = start
      element.attr_limit = limit
      element.attr_value = value
    end
    
    typesig { [Element] }
    # Finding the next element.
    # This method is called just before returning the result of
    # next().
    # We always store the next element before it is requested.
    # In the case that we have to continue calculations into the
    # supplementary planes, a false will be returned.
    # @param element return result object
    # @return true if the next range is found, false if we have to proceed to
    #         the supplementary range.
    def calculate_next_bmpelement(element)
      current_block = @m_next_block_
      current_value = @m_next_value_
      @m_current_codepoint_ = @m_next_codepoint_
      @m_next_codepoint_ += 1
      @m_next_block_index_ += 1
      if (!check_block_detail(current_value))
        set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
        return true
      end
      # synwee check that next block index == 0 here
      # enumerate BMP - the main loop enumerates data blocks
      while (@m_next_codepoint_ < UCharacter::SUPPLEMENTARY_MIN_VALUE)
        @m_next_index_ += 1
        # because of the way the character is split to form the index
        # the lead surrogate and trail surrogate can not be in the
        # mid of a block
        if ((@m_next_codepoint_).equal?(LEAD_SURROGATE_MIN_VALUE_))
          # skip lead surrogate code units,
          # go to lead surrogate codepoints
          @m_next_index_ = BMP_INDEX_LENGTH_
        else
          if ((@m_next_codepoint_).equal?(TRAIL_SURROGATE_MIN_VALUE_))
            # go back to regular BMP code points
            @m_next_index_ = @m_next_codepoint_ >> Trie::INDEX_STAGE_1_SHIFT_
          end
        end
        @m_next_block_index_ = 0
        if (!check_block(current_block, current_value))
          set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
          return true
        end
      end
      @m_next_codepoint_ -= 1 # step one back since this value has not been
      @m_next_block_index_ -= 1 # retrieved yet.
      return false
    end
    
    typesig { [Element] }
    # Finds the next supplementary element.
    # For each entry in the trie, the value to be delivered is passed through
    # extract().
    # We always store the next element before it is requested.
    # Called after calculateNextBMP() completes its round of BMP characters.
    # There is a slight difference in the usage of m_currentCodepoint_
    # here as compared to calculateNextBMP(). Though both represents the
    # lower bound of the next element, in calculateNextBMP() it gets set
    # at the start of any loop, where-else, in calculateNextSupplementary()
    # since m_currentCodepoint_ already contains the lower bound of the
    # next element (passed down from calculateNextBMP()), we keep it till
    # the end before resetting it to the new value.
    # Note, if there are no more iterations, it will never get to here.
    # Blocked out by next().
    # @param element return result object
    # @draft 2.1
    def calculate_next_supplementary_element(element)
      current_value = @m_next_value_
      current_block = @m_next_block_
      @m_next_codepoint_ += 1
      @m_next_block_index_ += 1
      if (!(UTF16.get_trail_surrogate(@m_next_codepoint_)).equal?(UTF16::TRAIL_SURROGATE_MIN_VALUE))
        # this piece is only called when we are in the middle of a lead
        # surrogate block
        if (!check_null_next_trail_index && !check_block_detail(current_value))
          set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
          @m_current_codepoint_ = @m_next_codepoint_
          return
        end
        # we have cleared one block
        @m_next_index_ += 1
        @m_next_trail_index_offset_ += 1
        if (!check_trail_block(current_block, current_value))
          set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
          @m_current_codepoint_ = @m_next_codepoint_
          return
        end
      end
      next_lead = UTF16.get_lead_surrogate(@m_next_codepoint_)
      # enumerate supplementary code points
      while (next_lead < TRAIL_SURROGATE_MIN_VALUE_)
        # lead surrogate access
        lead_block = @m_trie_.attr_m_index_[next_lead >> Trie::INDEX_STAGE_1_SHIFT_] << Trie::INDEX_STAGE_2_SHIFT_
        if ((lead_block).equal?(@m_trie_.attr_m_data_offset_))
          # no entries for a whole block of lead surrogates
          if (!(current_value).equal?(@m_initial_value_))
            @m_next_value_ = @m_initial_value_
            @m_next_block_ = 0
            @m_next_block_index_ = 0
            set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
            @m_current_codepoint_ = @m_next_codepoint_
            return
          end
          next_lead += DATA_BLOCK_LENGTH_
          # number of total affected supplementary codepoints in one
          # block
          # this is not a simple addition of
          # DATA_BLOCK_SUPPLEMENTARY_LENGTH since we need to consider
          # that we might have moved some of the codepoints
          @m_next_codepoint_ = UCharacterProperty.get_raw_supplementary(RJava.cast_to_char(next_lead), RJava.cast_to_char(UTF16::TRAIL_SURROGATE_MIN_VALUE))
          next
        end
        if ((@m_trie_.attr_m_data_manipulate_).nil?)
          raise NullPointerException.new("The field DataManipulate in this Trie is null")
        end
        # enumerate trail surrogates for this lead surrogate
        @m_next_index_ = @m_trie_.attr_m_data_manipulate_.get_folding_offset(@m_trie_.get_value(lead_block + (next_lead & Trie::INDEX_STAGE_3_MASK_)))
        if (@m_next_index_ <= 0)
          # no data for this lead surrogate
          if (!(current_value).equal?(@m_initial_value_))
            @m_next_value_ = @m_initial_value_
            @m_next_block_ = 0
            @m_next_block_index_ = 0
            set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
            @m_current_codepoint_ = @m_next_codepoint_
            return
          end
          @m_next_codepoint_ += TRAIL_SURROGATE_COUNT_
        else
          @m_next_trail_index_offset_ = 0
          if (!check_trail_block(current_block, current_value))
            set_result(element, @m_current_codepoint_, @m_next_codepoint_, current_value)
            @m_current_codepoint_ = @m_next_codepoint_
            return
          end
        end
        next_lead += 1
      end
      # deliver last range
      set_result(element, @m_current_codepoint_, UCharacter::MAX_VALUE + 1, current_value)
    end
    
    typesig { [::Java::Int] }
    # Internal block value calculations
    # Performs calculations on a data block to find codepoints in m_nextBlock_
    # after the index m_nextBlockIndex_ that has the same value.
    # Note m_*_ variables at this point is the next codepoint whose value
    # has not been calculated.
    # But when returned with false, it will be the last codepoint whose
    # value has been calculated.
    # @param currentValue the value which other codepoints are tested against
    # @return true if the whole block has the same value as currentValue or if
    #              the whole block has been calculated, false otherwise.
    def check_block_detail(current_value)
      while (@m_next_block_index_ < DATA_BLOCK_LENGTH_)
        @m_next_value_ = extract(@m_trie_.get_value(@m_next_block_ + @m_next_block_index_))
        if (!(@m_next_value_).equal?(current_value))
          return false
        end
        (@m_next_block_index_ += 1)
        (@m_next_codepoint_ += 1)
      end
      return true
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Internal block value calculations
    # Performs calculations on a data block to find codepoints in m_nextBlock_
    # that has the same value.
    # Will call checkBlockDetail() if highlevel check fails.
    # Note m_*_ variables at this point is the next codepoint whose value
    # has not been calculated.
    # @param currentBlock the initial block containing all currentValue
    # @param currentValue the value which other codepoints are tested against
    # @return true if the whole block has the same value as currentValue or if
    #              the whole block has been calculated, false otherwise.
    def check_block(current_block, current_value)
      @m_next_block_ = @m_trie_.attr_m_index_[@m_next_index_] << Trie::INDEX_STAGE_2_SHIFT_
      if ((@m_next_block_).equal?(current_block) && (@m_next_codepoint_ - @m_current_codepoint_) >= DATA_BLOCK_LENGTH_)
        # the block is the same as the previous one, filled with
        # currentValue
        @m_next_codepoint_ += DATA_BLOCK_LENGTH_
      else
        if ((@m_next_block_).equal?(0))
          # this is the all-initial-value block
          if (!(current_value).equal?(@m_initial_value_))
            @m_next_value_ = @m_initial_value_
            @m_next_block_index_ = 0
            return false
          end
          @m_next_codepoint_ += DATA_BLOCK_LENGTH_
        else
          if (!check_block_detail(current_value))
            return false
          end
        end
      end
      return true
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Internal block value calculations
    # Performs calculations on multiple data blocks for a set of trail
    # surrogates to find codepoints in m_nextBlock_ that has the same value.
    # Will call checkBlock() for internal block checks.
    # Note m_*_ variables at this point is the next codepoint whose value
    # has not been calculated.
    # @param currentBlock the initial block containing all currentValue
    # @param currentValue the value which other codepoints are tested against
    # @return true if the whole block has the same value as currentValue or if
    #              the whole block has been calculated, false otherwise.
    def check_trail_block(current_block, current_value)
      # enumerate code points for this lead surrogate
      while (@m_next_trail_index_offset_ < TRAIL_SURROGATE_INDEX_BLOCK_LENGTH_)
        # if we ever reach here, we are at the start of a new block
        @m_next_block_index_ = 0
        # copy of most of the body of the BMP loop
        if (!check_block(current_block, current_value))
          return false
        end
        @m_next_trail_index_offset_ += 1
        @m_next_index_ += 1
      end
      return true
    end
    
    typesig { [] }
    # Checks if we are beginning at the start of a initial block.
    # If we are then the rest of the codepoints in this initial block
    # has the same values.
    # We increment m_nextCodepoint_ and relevant data members if so.
    # This is used only in for the supplementary codepoints because
    # the offset to the trail indexes could be 0.
    # @return true if we are at the start of a initial block.
    def check_null_next_trail_index
      if (@m_next_index_ <= 0)
        @m_next_codepoint_ += TRAIL_SURROGATE_COUNT_ - 1
        next_lead = UTF16.get_lead_surrogate(@m_next_codepoint_)
        lead_block = @m_trie_.attr_m_index_[next_lead >> Trie::INDEX_STAGE_1_SHIFT_] << Trie::INDEX_STAGE_2_SHIFT_
        if ((@m_trie_.attr_m_data_manipulate_).nil?)
          raise NullPointerException.new("The field DataManipulate in this Trie is null")
        end
        @m_next_index_ = @m_trie_.attr_m_data_manipulate_.get_folding_offset(@m_trie_.get_value(lead_block + (next_lead & Trie::INDEX_STAGE_3_MASK_)))
        @m_next_index_ -= 1
        @m_next_block_index_ = DATA_BLOCK_LENGTH_
        return true
      end
      return false
    end
    
    class_module.module_eval {
      # private data members --------------------------------------------
      # Size of the stage 1 BMP indexes
      const_set_lazy(:BMP_INDEX_LENGTH_) { 0x10000 >> Trie::INDEX_STAGE_1_SHIFT_ }
      const_attr_reader  :BMP_INDEX_LENGTH_
      
      # Lead surrogate minimum value
      const_set_lazy(:LEAD_SURROGATE_MIN_VALUE_) { 0xd800 }
      const_attr_reader  :LEAD_SURROGATE_MIN_VALUE_
      
      # Trail surrogate minimum value
      const_set_lazy(:TRAIL_SURROGATE_MIN_VALUE_) { 0xdc00 }
      const_attr_reader  :TRAIL_SURROGATE_MIN_VALUE_
      
      # Trail surrogate maximum value
      const_set_lazy(:TRAIL_SURROGATE_MAX_VALUE_) { 0xdfff }
      const_attr_reader  :TRAIL_SURROGATE_MAX_VALUE_
      
      # Number of trail surrogate
      const_set_lazy(:TRAIL_SURROGATE_COUNT_) { 0x400 }
      const_attr_reader  :TRAIL_SURROGATE_COUNT_
      
      # Number of stage 1 indexes for supplementary calculations that maps to
      # each lead surrogate character.
      # See second pass into getRawOffset for the trail surrogate character.
      # 10 for significant number of bits for trail surrogates, 5 for what we
      # discard during shifting.
      const_set_lazy(:TRAIL_SURROGATE_INDEX_BLOCK_LENGTH_) { 1 << (10 - Trie::INDEX_STAGE_1_SHIFT_) }
      const_attr_reader  :TRAIL_SURROGATE_INDEX_BLOCK_LENGTH_
      
      # Number of data values in a stage 2 (data array) block.
      const_set_lazy(:DATA_BLOCK_LENGTH_) { 1 << Trie::INDEX_STAGE_1_SHIFT_ }
      const_attr_reader  :DATA_BLOCK_LENGTH_
      
      # Number of codepoints in a stage 2 block
      const_set_lazy(:DATA_BLOCK_SUPPLEMENTARY_LENGTH_) { DATA_BLOCK_LENGTH_ << 10 }
      const_attr_reader  :DATA_BLOCK_SUPPLEMENTARY_LENGTH_
    }
    
    # Trie instance
    attr_accessor :m_trie_
    alias_method :attr_m_trie_, :m_trie_
    undef_method :m_trie_
    alias_method :attr_m_trie_=, :m_trie_=
    undef_method :m_trie_=
    
    # Initial value for trie values
    attr_accessor :m_initial_value_
    alias_method :attr_m_initial_value_, :m_initial_value_
    undef_method :m_initial_value_
    alias_method :attr_m_initial_value_=, :m_initial_value_=
    undef_method :m_initial_value_=
    
    # Next element results and data.
    attr_accessor :m_current_codepoint_
    alias_method :attr_m_current_codepoint_, :m_current_codepoint_
    undef_method :m_current_codepoint_
    alias_method :attr_m_current_codepoint_=, :m_current_codepoint_=
    undef_method :m_current_codepoint_=
    
    attr_accessor :m_next_codepoint_
    alias_method :attr_m_next_codepoint_, :m_next_codepoint_
    undef_method :m_next_codepoint_
    alias_method :attr_m_next_codepoint_=, :m_next_codepoint_=
    undef_method :m_next_codepoint_=
    
    attr_accessor :m_next_value_
    alias_method :attr_m_next_value_, :m_next_value_
    undef_method :m_next_value_
    alias_method :attr_m_next_value_=, :m_next_value_=
    undef_method :m_next_value_=
    
    attr_accessor :m_next_index_
    alias_method :attr_m_next_index_, :m_next_index_
    undef_method :m_next_index_
    alias_method :attr_m_next_index_=, :m_next_index_=
    undef_method :m_next_index_=
    
    attr_accessor :m_next_block_
    alias_method :attr_m_next_block_, :m_next_block_
    undef_method :m_next_block_
    alias_method :attr_m_next_block_=, :m_next_block_=
    undef_method :m_next_block_=
    
    attr_accessor :m_next_block_index_
    alias_method :attr_m_next_block_index_, :m_next_block_index_
    undef_method :m_next_block_index_
    alias_method :attr_m_next_block_index_=, :m_next_block_index_=
    undef_method :m_next_block_index_=
    
    attr_accessor :m_next_trail_index_offset_
    alias_method :attr_m_next_trail_index_offset_, :m_next_trail_index_offset_
    undef_method :m_next_trail_index_offset_
    alias_method :attr_m_next_trail_index_offset_=, :m_next_trail_index_offset_=
    undef_method :m_next_trail_index_offset_=
    
    # This is the return result element
    attr_accessor :m_start_
    alias_method :attr_m_start_, :m_start_
    undef_method :m_start_
    alias_method :attr_m_start_=, :m_start_=
    undef_method :m_start_=
    
    attr_accessor :m_limit_
    alias_method :attr_m_limit_, :m_limit_
    undef_method :m_limit_
    alias_method :attr_m_limit_=, :m_limit_=
    undef_method :m_limit_=
    
    attr_accessor :m_value_
    alias_method :attr_m_value_, :m_value_
    undef_method :m_value_
    alias_method :attr_m_value_=, :m_value_=
    undef_method :m_value_=
    
    private
    alias_method :initialize__trie_iterator, :initialize
  end
  
end

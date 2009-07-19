require "rjava"

# Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module RBTableBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Util, :Vector
      include_const ::Sun::Text, :UCompactIntArray
      include_const ::Sun::Text, :IntHashtable
      include_const ::Sun::Text, :ComposedCharIter
      include_const ::Sun::Text, :CollatorUtilities
      include_const ::Sun::Text::Normalizer, :NormalizerImpl
    }
  end
  
  # This class contains all the code to parse a RuleBasedCollator pattern
  # and build a RBCollationTables object from it.  A particular instance
  # of tis class exists only during the actual build process-- once an
  # RBCollationTables object has been built, the RBTableBuilder object
  # goes away.  This object carries all of the state which is only needed
  # during the build process, plus a "shadow" copy of all of the state
  # that will go into the tables object itself.  This object communicates
  # with RBCollationTables through a separate class, RBCollationTables.BuildAPI,
  # this is an inner class of RBCollationTables and provides a separate
  # private API for communication with RBTableBuilder.
  # This class isn't just an inner class of RBCollationTables itself because
  # of its large size.  For source-code readability, it seemed better for the
  # builder to have its own source file.
  class RBTableBuilder 
    include_class_members RBTableBuilderImports
    
    typesig { [RBCollationTables::BuildAPI] }
    def initialize(tables)
      @tables = nil
      @m_pattern = nil
      @is_over_ignore = false
      @key_buf = CharArray.new(MAXKEYSIZE)
      @contract_flags = IntHashtable.new(100)
      @french_sec = false
      @se_asian_swapping = false
      @mapping = nil
      @contract_table = nil
      @expand_table = nil
      @max_sec_order = 0
      @max_ter_order = 0
      @tables = tables
    end
    
    typesig { [String, ::Java::Int] }
    # Create a table-based collation object with the given rules.
    # This is the main function that actually builds the tables and
    # stores them back in the RBCollationTables object.  It is called
    # ONLY by the RBCollationTables constructor.
    # @see java.util.RuleBasedCollator#RuleBasedCollator
    # @exception ParseException If the rules format is incorrect.
    def build(pattern, decmp)
      is_source = true
      i = 0
      exp_chars = nil
      group_chars = nil
      if ((pattern.length).equal?(0))
        raise ParseException.new("Build rules empty.", 0)
      end
      # This array maps Unicode characters to their collation ordering
      @mapping = UCompactIntArray.new(RJava.cast_to_int(RBCollationTables::UNMAPPED))
      # Normalize the build rules.  Find occurances of all decomposed characters
      # and normalize the rules before feeding into the builder.  By "normalize",
      # we mean that all precomposed Unicode characters must be converted into
      # a base character and one or more combining characters (such as accents).
      # When there are multiple combining characters attached to a base character,
      # the combining characters must be in their canonical order
      # 
      # sherman/Note:
      # (1)decmp will be NO_DECOMPOSITION only in ko locale to prevent decompose
      # hangual syllables to jamos, so we can actually just call decompose with
      # normalizer's IGNORE_HANGUL option turned on
      # 
      # (2)just call the "special version" in NormalizerImpl directly
      # pattern = Normalizer.decompose(pattern, false, Normalizer.IGNORE_HANGUL, true);
      # 
      # Normalizer.Mode mode = CollatorUtilities.toNormalizerMode(decmp);
      # pattern = Normalizer.normalize(pattern, mode, 0, true);
      pattern = (NormalizerImpl.canonical_decompose_with_single_quotation(pattern)).to_s
      # Build the merged collation entries
      # Since rules can be specified in any order in the string
      # (e.g. "c , C < d , D < e , E .... C < CH")
      # this splits all of the rules in the string out into separate
      # objects and then sorts them.  In the above example, it merges the
      # "C < CH" rule in just before the "C < D" rule.
      @m_pattern = MergeCollation.new(pattern)
      order = 0
      # Now walk though each entry and add it to my own tables
      i = 0
      while i < @m_pattern.get_count
        entry = @m_pattern.get_item_at(i)
        if (!(entry).nil?)
          group_chars = (entry.get_chars).to_s
          if (group_chars.length > 1)
            case (group_chars.char_at(group_chars.length - 1))
            when Character.new(?@.ord)
              @french_sec = true
              group_chars = (group_chars.substring(0, group_chars.length - 1)).to_s
            when Character.new(?!.ord)
              @se_asian_swapping = true
              group_chars = (group_chars.substring(0, group_chars.length - 1)).to_s
            end
          end
          order = increment(entry.get_strength, order)
          exp_chars = (entry.get_extension).to_s
          if (!(exp_chars.length).equal?(0))
            add_expand_order(group_chars, exp_chars, order)
          else
            if (group_chars.length > 1)
              ch = group_chars.char_at(0)
              if (Character.is_high_surrogate(ch) && (group_chars.length).equal?(2))
                add_order(Character.to_code_point(ch, group_chars.char_at(1)), order)
              else
                add_contract_order(group_chars, order)
              end
            else
              ch = group_chars.char_at(0)
              add_order(ch, order)
            end
          end
        end
        (i += 1)
      end
      add_composed_chars
      commit
      @mapping.compact
      # System.out.println("mappingSize=" + mapping.getKSize());
      # for (int j = 0; j < 0xffff; j++) {
      # int value = mapping.elementAt(j);
      # if (value != RBCollationTables.UNMAPPED)
      # System.out.println("index=" + Integer.toString(j, 16)
      # + ", value=" + Integer.toString(value, 16));
      # }
      @tables.fill_in_tables(@french_sec, @se_asian_swapping, @mapping, @contract_table, @expand_table, @contract_flags, @max_sec_order, @max_ter_order)
    end
    
    typesig { [] }
    # Add expanding entries for pre-composed unicode characters so that this
    # collator can be used reasonably well with decomposition turned off.
    def add_composed_chars
      # Iterate through all of the pre-composed characters in Unicode
      iter = ComposedCharIter.new
      c = 0
      while (!((c = iter.next)).equal?(ComposedCharIter::DONE))
        if ((get_char_order(c)).equal?(RBCollationTables::UNMAPPED))
          # We don't already have an ordering for this pre-composed character.
          # 
          # First, see if the decomposed string is already in our
          # tables as a single contracting-string ordering.
          # If so, just map the precomposed character to that order.
          # 
          # TODO: What we should really be doing here is trying to find the
          # longest initial substring of the decomposition that is present
          # in the tables as a contracting character sequence, and find its
          # ordering.  Then do this recursively with the remaining chars
          # so that we build a list of orderings, and add that list to
          # the expansion table.
          # That would be more correct but also significantly slower, so
          # I'm not totally sure it's worth doing.
          s = iter.decomposition
          # sherman/Note: if this is 1 character decomposed string, the
          # only thing need to do is to check if this decomposed character
          # has an entry in our order table, this order is not necessary
          # to be a contraction order, if it does have one, add an entry
          # for the precomposed character by using the same order, the
          # previous impl unnecessarily adds a single character expansion
          # entry.
          if ((s.length).equal?(1))
            order = get_char_order(s.char_at(0))
            if (!(order).equal?(RBCollationTables::UNMAPPED))
              add_order(c, order)
            end
            next
          else
            if ((s.length).equal?(2))
              ch0 = s.char_at(0)
              if (Character.is_high_surrogate(ch0))
                order = get_char_order(s.code_point_at(0))
                if (!(order).equal?(RBCollationTables::UNMAPPED))
                  add_order(c, order)
                end
                next
              end
            end
          end
          contract_order = get_contract_order(s)
          if (!(contract_order).equal?(RBCollationTables::UNMAPPED))
            add_order(c, contract_order)
          else
            # We don't have a contracting ordering for the entire string
            # that results from the decomposition, but if we have orders
            # for each individual character, we can add an expanding
            # table entry for the pre-composed character
            all_there = true
            i = 0
            while i < s.length
              if ((get_char_order(s.char_at(i))).equal?(RBCollationTables::UNMAPPED))
                all_there = false
                break
              end
              ((i += 1) - 1)
            end
            if (all_there)
              add_expand_order(c, s, RBCollationTables::UNMAPPED)
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Look up for unmapped values in the expanded character table.
    # 
    # When the expanding character tables are built by addExpandOrder,
    # it doesn't know what the final ordering of each character
    # in the expansion will be.  Instead, it just puts the raw character
    # code into the table, adding CHARINDEX as a flag.  Now that we've
    # finished building the mapping table, we can go back and look up
    # that character to see what its real collation order is and
    # stick that into the expansion table.  That lets us avoid doing
    # a two-stage lookup later.
    def commit
      if (!(@expand_table).nil?)
        i = 0
        while i < @expand_table.size
          value_list = @expand_table.element_at(i)
          j = 0
          while j < value_list.attr_length
            order = value_list[j]
            if (order < RBCollationTables::EXPANDCHARINDEX && order > CHARINDEX)
              # found a expanding character that isn't filled in yet
              ch = order - CHARINDEX
              # Get the real values for the non-filled entry
              real_value = get_char_order(ch)
              if ((real_value).equal?(RBCollationTables::UNMAPPED))
                # The real value is still unmapped, maybe it's ignorable
                value_list[j] = IGNORABLEMASK & ch
              else
                # just fill in the value
                value_list[j] = real_value
              end
            end
            ((j += 1) - 1)
          end
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Increment of the last order based on the comparison level.
    def increment(a_strength, last_value)
      case (a_strength)
      when Collator::PRIMARY
        # increment priamry order  and mask off secondary and tertiary difference
        last_value += PRIMARYORDERINCREMENT
        last_value &= RBCollationTables::PRIMARYORDERMASK
        @is_over_ignore = true
      when Collator::SECONDARY
        # increment secondary order and mask off tertiary difference
        last_value += SECONDARYORDERINCREMENT
        last_value &= RBCollationTables::SECONDARYDIFFERENCEONLY
        # record max # of ignorable chars with secondary difference
        if (!@is_over_ignore)
          ((@max_sec_order += 1) - 1)
        end
      when Collator::TERTIARY
        # increment tertiary order
        last_value += TERTIARYORDERINCREMENT
        # record max # of ignorable chars with tertiary difference
        if (!@is_over_ignore)
          ((@max_ter_order += 1) - 1)
        end
      end
      return last_value
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds a character and its designated order into the collation table.
    def add_order(ch, an_order)
      # See if the char already has an order in the mapping table
      order = @mapping.element_at(ch)
      if (order >= RBCollationTables::CONTRACTCHARINDEX)
        # There's already an entry for this character that points to a contracting
        # character table.  Instead of adding the character directly to the mapping
        # table, we must add it to the contract table instead.
        length_ = 1
        if (Character.is_supplementary_code_point(ch))
          length_ = Character.to_chars(ch, @key_buf, 0)
        else
          @key_buf[0] = RJava.cast_to_char(ch)
        end
        add_contract_order(String.new(@key_buf, 0, length_), an_order)
      else
        # add the entry to the mapping table,
        # the same later entry replaces the previous one
        @mapping.set_element_at(ch, an_order)
      end
    end
    
    typesig { [String, ::Java::Int] }
    def add_contract_order(group_chars, an_order)
      add_contract_order(group_chars, an_order, true)
    end
    
    typesig { [String, ::Java::Int, ::Java::Boolean] }
    # Adds the contracting string into the collation table.
    def add_contract_order(group_chars, an_order, fwd)
      if ((@contract_table).nil?)
        @contract_table = Vector.new(INITIALTABLESIZE)
      end
      # initial character
      ch = group_chars.code_point_at(0)
      # char ch0 = groupChars.charAt(0);
      # int ch = Character.isHighSurrogate(ch0)?
      # Character.toCodePoint(ch0, groupChars.charAt(1)):ch0;
      # 
      # See if the initial character of the string already has a contract table.
      entry = @mapping.element_at(ch)
      entry_table = get_contract_values_impl(entry - RBCollationTables::CONTRACTCHARINDEX)
      if ((entry_table).nil?)
        # We need to create a new table of contract entries for this base char
        table_index = RBCollationTables::CONTRACTCHARINDEX + @contract_table.size
        entry_table = Vector.new(INITIALTABLESIZE)
        @contract_table.add_element(entry_table)
        # Add the initial character's current ordering first. then
        # update its mapping to point to this contract table
        entry_table.add_element(EntryPair.new(group_chars.substring(0, Character.char_count(ch)), entry))
        @mapping.set_element_at(ch, table_index)
      end
      # Now add (or replace) this string in the table
      index = RBCollationTables.get_entry(entry_table, group_chars, fwd)
      if (!(index).equal?(RBCollationTables::UNMAPPED))
        pair = entry_table.element_at(index)
        pair.attr_value = an_order
      else
        pair = entry_table.last_element
        # NOTE:  This little bit of logic is here to speed CollationElementIterator
        # .nextContractChar().  This code ensures that the longest sequence in
        # this list is always the _last_ one in the list.  This keeps
        # nextContractChar() from having to search the entire list for the longest
        # sequence.
        if (group_chars.length > pair.attr_entry_name.length)
          entry_table.add_element(EntryPair.new(group_chars, an_order, fwd))
        else
          entry_table.insert_element_at(EntryPair.new(group_chars, an_order, fwd), entry_table.size - 1)
        end
      end
      # If this was a forward mapping for a contracting string, also add a
      # reverse mapping for it, so that CollationElementIterator.previous
      # can work right
      if (fwd && group_chars.length > 1)
        add_contract_flags(group_chars)
        add_contract_order(StringBuffer.new(group_chars).reverse.to_s, an_order, false)
      end
    end
    
    typesig { [String] }
    # If the given string has been specified as a contracting string
    # in this collation table, return its ordering.
    # Otherwise return UNMAPPED.
    def get_contract_order(group_chars)
      result = RBCollationTables::UNMAPPED
      if (!(@contract_table).nil?)
        ch = group_chars.code_point_at(0)
        # char ch0 = groupChars.charAt(0);
        # int ch = Character.isHighSurrogate(ch0)?
        # Character.toCodePoint(ch0, groupChars.charAt(1)):ch0;
        entry_table = get_contract_values(ch)
        if (!(entry_table).nil?)
          index = RBCollationTables.get_entry(entry_table, group_chars, true)
          if (!(index).equal?(RBCollationTables::UNMAPPED))
            pair = entry_table.element_at(index)
            result = pair.attr_value
          end
        end
      end
      return result
    end
    
    typesig { [::Java::Int] }
    def get_char_order(ch)
      order = @mapping.element_at(ch)
      if (order >= RBCollationTables::CONTRACTCHARINDEX)
        group_list = get_contract_values_impl(order - RBCollationTables::CONTRACTCHARINDEX)
        pair = group_list.first_element
        order = pair.attr_value
      end
      return order
    end
    
    typesig { [::Java::Int] }
    # Get the entry of hash table of the contracting string in the collation
    # table.
    # @param ch the starting character of the contracting string
    def get_contract_values(ch)
      index = @mapping.element_at(ch)
      return get_contract_values_impl(index - RBCollationTables::CONTRACTCHARINDEX)
    end
    
    typesig { [::Java::Int] }
    def get_contract_values_impl(index)
      if (index >= 0)
        return @contract_table.element_at(index)
      else
        # not found
        return nil
      end
    end
    
    typesig { [String, String, ::Java::Int] }
    # Adds the expanding string into the collation table.
    def add_expand_order(contract_chars, expand_chars, an_order)
      # Create an expansion table entry
      table_index = add_expansion(an_order, expand_chars)
      # And add its index into the main mapping table
      if (contract_chars.length > 1)
        ch = contract_chars.char_at(0)
        if (Character.is_high_surrogate(ch) && (contract_chars.length).equal?(2))
          ch2 = contract_chars.char_at(1)
          if (Character.is_low_surrogate(ch2))
            # only add into table when it is a legal surrogate
            add_order(Character.to_code_point(ch, ch2), table_index)
          end
        else
          add_contract_order(contract_chars, table_index)
        end
      else
        add_order(contract_chars.char_at(0), table_index)
      end
    end
    
    typesig { [::Java::Int, String, ::Java::Int] }
    def add_expand_order(ch, expand_chars, an_order)
      table_index = add_expansion(an_order, expand_chars)
      add_order(ch, table_index)
    end
    
    typesig { [::Java::Int, String] }
    # Create a new entry in the expansion table that contains the orderings
    # for the given characers.  If anOrder is valid, it is added to the
    # beginning of the expanded list of orders.
    def add_expansion(an_order, expand_chars)
      if ((@expand_table).nil?)
        @expand_table = Vector.new(INITIALTABLESIZE)
      end
      # If anOrder is valid, we want to add it at the beginning of the list
      offset = ((an_order).equal?(RBCollationTables::UNMAPPED)) ? 0 : 1
      value_list = Array.typed(::Java::Int).new(expand_chars.length + offset) { 0 }
      if ((offset).equal?(1))
        value_list[0] = an_order
      end
      j = offset
      i = 0
      while i < expand_chars.length
        ch0 = expand_chars.char_at(i)
        ch1 = 0
        ch = 0
        if (Character.is_high_surrogate(ch0))
          if (((i += 1)).equal?(expand_chars.length) || !Character.is_low_surrogate(ch1 = expand_chars.char_at(i)))
            # ether we are missing the low surrogate or the next char
            # is not a legal low surrogate, so stop loop
            break
          end
          ch = Character.to_code_point(ch0, ch1)
        else
          ch = ch0
        end
        map_value = get_char_order(ch)
        if (!(map_value).equal?(RBCollationTables::UNMAPPED))
          value_list[((j += 1) - 1)] = map_value
        else
          # can't find it in the table, will be filled in by commit().
          value_list[((j += 1) - 1)] = CHARINDEX + ch
        end
        ((i += 1) - 1)
      end
      if (j < value_list.attr_length)
        # we had at least one supplementary character, the size of valueList
        # is bigger than it really needs...
        tmp_buf = Array.typed(::Java::Int).new(j) { 0 }
        while ((j -= 1) >= 0)
          tmp_buf[j] = value_list[j]
        end
        value_list = tmp_buf
      end
      # Add the expanding char list into the expansion table.
      table_index = RBCollationTables::EXPANDCHARINDEX + @expand_table.size
      @expand_table.add_element(value_list)
      return table_index
    end
    
    typesig { [String] }
    def add_contract_flags(chars)
      c0 = 0
      c = 0
      len = chars.length
      i = 0
      while i < len
        c0 = chars.char_at(i)
        c = Character.is_high_surrogate(c0) ? Character.to_code_point(c0, chars.char_at((i += 1))) : c0
        @contract_flags.put(c, 1)
        ((i += 1) - 1)
      end
    end
    
    class_module.module_eval {
      # ==============================================================
      # constants
      # ==============================================================
      const_set_lazy(:CHARINDEX) { 0x70000000 }
      const_attr_reader  :CHARINDEX
      
      # need look up in .commit()
      const_set_lazy(:IGNORABLEMASK) { 0xffff }
      const_attr_reader  :IGNORABLEMASK
      
      const_set_lazy(:PRIMARYORDERINCREMENT) { 0x10000 }
      const_attr_reader  :PRIMARYORDERINCREMENT
      
      const_set_lazy(:SECONDARYORDERINCREMENT) { 0x100 }
      const_attr_reader  :SECONDARYORDERINCREMENT
      
      const_set_lazy(:TERTIARYORDERINCREMENT) { 0x1 }
      const_attr_reader  :TERTIARYORDERINCREMENT
      
      const_set_lazy(:INITIALTABLESIZE) { 20 }
      const_attr_reader  :INITIALTABLESIZE
      
      const_set_lazy(:MAXKEYSIZE) { 5 }
      const_attr_reader  :MAXKEYSIZE
    }
    
    # ==============================================================
    # instance variables
    # ==============================================================
    # variables used by the build process
    attr_accessor :tables
    alias_method :attr_tables, :tables
    undef_method :tables
    alias_method :attr_tables=, :tables=
    undef_method :tables=
    
    attr_accessor :m_pattern
    alias_method :attr_m_pattern, :m_pattern
    undef_method :m_pattern
    alias_method :attr_m_pattern=, :m_pattern=
    undef_method :m_pattern=
    
    attr_accessor :is_over_ignore
    alias_method :attr_is_over_ignore, :is_over_ignore
    undef_method :is_over_ignore
    alias_method :attr_is_over_ignore=, :is_over_ignore=
    undef_method :is_over_ignore=
    
    attr_accessor :key_buf
    alias_method :attr_key_buf, :key_buf
    undef_method :key_buf
    alias_method :attr_key_buf=, :key_buf=
    undef_method :key_buf=
    
    attr_accessor :contract_flags
    alias_method :attr_contract_flags, :contract_flags
    undef_method :contract_flags
    alias_method :attr_contract_flags=, :contract_flags=
    undef_method :contract_flags=
    
    # "shadow" copies of the instance variables in RBCollationTables
    # (the values in these variables are copied back into RBCollationTables
    # at the end of the build process)
    attr_accessor :french_sec
    alias_method :attr_french_sec, :french_sec
    undef_method :french_sec
    alias_method :attr_french_sec=, :french_sec=
    undef_method :french_sec=
    
    attr_accessor :se_asian_swapping
    alias_method :attr_se_asian_swapping, :se_asian_swapping
    undef_method :se_asian_swapping
    alias_method :attr_se_asian_swapping=, :se_asian_swapping=
    undef_method :se_asian_swapping=
    
    attr_accessor :mapping
    alias_method :attr_mapping, :mapping
    undef_method :mapping
    alias_method :attr_mapping=, :mapping=
    undef_method :mapping=
    
    attr_accessor :contract_table
    alias_method :attr_contract_table, :contract_table
    undef_method :contract_table
    alias_method :attr_contract_table=, :contract_table=
    undef_method :contract_table=
    
    attr_accessor :expand_table
    alias_method :attr_expand_table, :expand_table
    undef_method :expand_table
    alias_method :attr_expand_table=, :expand_table=
    undef_method :expand_table=
    
    attr_accessor :max_sec_order
    alias_method :attr_max_sec_order, :max_sec_order
    undef_method :max_sec_order
    alias_method :attr_max_sec_order=, :max_sec_order=
    undef_method :max_sec_order=
    
    attr_accessor :max_ter_order
    alias_method :attr_max_ter_order, :max_ter_order
    undef_method :max_ter_order
    alias_method :attr_max_ter_order=, :max_ter_order=
    undef_method :max_ter_order=
    
    private
    alias_method :initialize__rbtable_builder, :initialize
  end
  
end

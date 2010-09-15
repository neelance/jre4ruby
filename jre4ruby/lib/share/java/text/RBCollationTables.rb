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
  module RBCollationTablesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Util, :Vector
      include_const ::Sun::Text, :UCompactIntArray
      include_const ::Sun::Text, :IntHashtable
    }
  end
  
  # This class contains the static state of a RuleBasedCollator: The various
  # tables that are used by the collation routines.  Several RuleBasedCollators
  # can share a single RBCollationTables object, easing memory requirements and
  # improving performance.
  class RBCollationTables 
    include_class_members RBCollationTablesImports
    
    typesig { [String, ::Java::Int] }
    # ===========================================================================================
    # The following diagram shows the data structure of the RBCollationTables object.
    # Suppose we have the rule, where 'o-umlaut' is the unicode char 0x00F6.
    # "a, A < b, B < c, C, ch, cH, Ch, CH < d, D ... < o, O; 'o-umlaut'/E, 'O-umlaut'/E ...".
    # What the rule says is, sorts 'ch'ligatures and 'c' only with tertiary difference and
    # sorts 'o-umlaut' as if it's always expanded with 'e'.
    # 
    # mapping table                     contracting list           expanding list
    # (contains all unicode char
    # entries)                   ___    ____________       _________________________
    # ________                +>|_*_|->|'c' |v('c') |  +>|v('o')|v('umlaut')|v('e')|
    # |_\u0001_|-> v('\u0001') | |_:_|  |------------|  | |-------------------------|
    # |_\u0002_|-> v('\u0002') | |_:_|  |'ch'|v('ch')|  | |             :           |
    # |____:___|               | |_:_|  |------------|  | |-------------------------|
    # |____:___|               |        |'cH'|v('cH')|  | |             :           |
    # |__'a'___|-> v('a')      |        |------------|  | |-------------------------|
    # |__'b'___|-> v('b')      |        |'Ch'|v('Ch')|  | |             :           |
    # |____:___|               |        |------------|  | |-------------------------|
    # |____:___|               |        |'CH'|v('CH')|  | |             :           |
    # |___'c'__|----------------         ------------   | |-------------------------|
    # |____:___|                                        | |             :           |
    # |o-umlaut|----------------------------------------  |_________________________|
    # |____:___|
    # 
    # Noted by Helena Shih on 6/23/97
    # ============================================================================================
    def initialize(rules, decmp)
      @rules = nil
      @french_sec = false
      @se_asian_swapping = false
      @mapping = nil
      @contract_table = nil
      @expand_table = nil
      @contract_flags = nil
      @max_sec_order = 0
      @max_ter_order = 0
      @rules = rules
      builder = RBTableBuilder.new(BuildAPI.new_local(self))
      builder.build(rules, decmp) # this object is filled in through
      # the BuildAPI object
    end
    
    class_module.module_eval {
      const_set_lazy(:BuildAPI) { Class.new do
        local_class_in RBCollationTables
        include_class_members RBCollationTables
        
        typesig { [] }
        # Private constructor.  Prevents anyone else besides RBTableBuilder
        # from gaining direct access to the internals of this class.
        def initialize
        end
        
        typesig { [::Java::Boolean, ::Java::Boolean, class_self::UCompactIntArray, class_self::Vector, class_self::Vector, class_self::IntHashtable, ::Java::Short, ::Java::Short] }
        # This function is used by RBTableBuilder to fill in all the members of this
        # object.  (Effectively, the builder class functions as a "friend" of this
        # class, but to avoid changing too much of the logic, it carries around "shadow"
        # copies of all these variables until the end of the build process and then
        # copies them en masse into the actual tables object once all the construction
        # logic is complete.  This function does that "copying en masse".
        # @param f2ary The value for frenchSec (the French-secondary flag)
        # @param swap The value for SE Asian swapping rule
        # @param map The collator's character-mapping table (the value for mapping)
        # @param cTbl The collator's contracting-character table (the value for contractTable)
        # @param eTbl The collator's expanding-character table (the value for expandTable)
        # @param cFlgs The hash table of characters that participate in contracting-
        # character sequences (the value for contractFlags)
        # @param mso The value for maxSecOrder
        # @param mto The value for maxTerOrder
        def fill_in_tables(f2ary, swap, map, c_tbl, e_tbl, c_flgs, mso, mto)
          self.attr_french_sec = f2ary
          self.attr_se_asian_swapping = swap
          self.attr_mapping = map
          self.attr_contract_table = c_tbl
          self.attr_expand_table = e_tbl
          self.attr_contract_flags = c_flgs
          self.attr_max_sec_order = mso
          self.attr_max_ter_order = mto
        end
        
        private
        alias_method :initialize__build_api, :initialize
      end }
    }
    
    typesig { [] }
    # Gets the table-based rules for the collation object.
    # @return returns the collation rules that the table collation object
    # was created from.
    def get_rules
      return @rules
    end
    
    typesig { [] }
    def is_french_sec
      return @french_sec
    end
    
    typesig { [] }
    def is_seasian_swapping
      return @se_asian_swapping
    end
    
    typesig { [::Java::Int] }
    # ==============================================================
    # internal (for use by CollationElementIterator)
    # ==============================================================
    # 
    # Get the entry of hash table of the contracting string in the collation
    # table.
    # @param ch the starting character of the contracting string
    def get_contract_values(ch)
      index = @mapping.element_at(ch)
      return get_contract_values_impl(index - CONTRACTCHARINDEX)
    end
    
    typesig { [::Java::Int] }
    # get contract values from contractTable by index
    def get_contract_values_impl(index)
      if (index >= 0)
        return @contract_table.element_at(index)
      else
        # not found
        return nil
      end
    end
    
    typesig { [::Java::Int] }
    # Returns true if this character appears anywhere in a contracting
    # character sequence.  (Used by CollationElementIterator.setOffset().)
    def used_in_contract_seq(c)
      return (@contract_flags.get(c)).equal?(1)
    end
    
    typesig { [::Java::Int] }
    # Return the maximum length of any expansion sequences that end
    # with the specified comparison order.
    # 
    # @param order a collation order returned by previous or next.
    # @return the maximum length of any expansion seuences ending
    # with the specified order.
    # 
    # @see CollationElementIterator#getMaxExpansion
    def get_max_expansion(order)
      result = 1
      if (!(@expand_table).nil?)
        # Right now this does a linear search through the entire
        # expandsion table.  If a collator had a large number of expansions,
        # this could cause a performance problem, but in practise that
        # rarely happens
        i = 0
        while i < @expand_table.size
          value_list = @expand_table.element_at(i)
          length = value_list.attr_length
          if (length > result && (value_list[length - 1]).equal?(order))
            result = length
          end
          i += 1
        end
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # Get the entry of hash table of the expanding string in the collation
    # table.
    # @param idx the index of the expanding string value list
    def get_expand_value_list(order)
      return @expand_table.element_at(order - EXPANDCHARINDEX)
    end
    
    typesig { [::Java::Int] }
    # Get the comarison order of a character from the collation table.
    # @return the comparison order of a character.
    def get_unicode_order(ch)
      return @mapping.element_at(ch)
    end
    
    typesig { [] }
    def get_max_sec_order
      return @max_sec_order
    end
    
    typesig { [] }
    def get_max_ter_order
      return @max_ter_order
    end
    
    class_module.module_eval {
      typesig { [StringBuffer, ::Java::Int, ::Java::Int] }
      # Reverse a string.
      # 
      # shemran/Note: this is used for secondary order value reverse, no
      # need to consider supplementary pair.
      def reverse(result, from, to)
        i = from
        swap = 0
        j = to - 1
        while (i < j)
          swap = result.char_at(i)
          result.set_char_at(i, result.char_at(j))
          result.set_char_at(j, swap)
          i += 1
          j -= 1
        end
      end
      
      typesig { [Vector, String, ::Java::Boolean] }
      def get_entry(list, name, fwd)
        i = 0
        while i < list.size
          pair = list.element_at(i)
          if ((pair.attr_fwd).equal?(fwd) && (pair.attr_entry_name == name))
            return i
          end
          i += 1
        end
        return UNMAPPED
      end
      
      # ==============================================================
      # constants
      # ==============================================================
      # sherman/Todo: is the value big enough?????
      const_set_lazy(:EXPANDCHARINDEX) { 0x7e000000 }
      const_attr_reader  :EXPANDCHARINDEX
      
      # Expand index follows
      const_set_lazy(:CONTRACTCHARINDEX) { 0x7f000000 }
      const_attr_reader  :CONTRACTCHARINDEX
      
      # contract indexes follow
      const_set_lazy(:UNMAPPED) { -0x1 }
      const_attr_reader  :UNMAPPED
      
      const_set_lazy(:PRIMARYORDERMASK) { -0x10000 }
      const_attr_reader  :PRIMARYORDERMASK
      
      const_set_lazy(:SECONDARYORDERMASK) { 0xff00 }
      const_attr_reader  :SECONDARYORDERMASK
      
      const_set_lazy(:TERTIARYORDERMASK) { 0xff }
      const_attr_reader  :TERTIARYORDERMASK
      
      const_set_lazy(:PRIMARYDIFFERENCEONLY) { -0x10000 }
      const_attr_reader  :PRIMARYDIFFERENCEONLY
      
      const_set_lazy(:SECONDARYDIFFERENCEONLY) { -0x100 }
      const_attr_reader  :SECONDARYDIFFERENCEONLY
      
      const_set_lazy(:PRIMARYORDERSHIFT) { 16 }
      const_attr_reader  :PRIMARYORDERSHIFT
      
      const_set_lazy(:SECONDARYORDERSHIFT) { 8 }
      const_attr_reader  :SECONDARYORDERSHIFT
    }
    
    # ==============================================================
    # instance variables
    # ==============================================================
    attr_accessor :rules
    alias_method :attr_rules, :rules
    undef_method :rules
    alias_method :attr_rules=, :rules=
    undef_method :rules=
    
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
    
    attr_accessor :contract_flags
    alias_method :attr_contract_flags, :contract_flags
    undef_method :contract_flags
    alias_method :attr_contract_flags=, :contract_flags=
    undef_method :contract_flags=
    
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
    alias_method :initialize__rbcollation_tables, :initialize
  end
  
end

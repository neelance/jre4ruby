require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996, 1997 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module MergeCollationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # Utility class for normalizing and merging patterns for collation.
  # Patterns are strings of the form <entry>*, where <entry> has the
  # form:
  # <pattern> := <entry>*
  # <entry> := <separator><chars>{"/"<extension>}
  # <separator> := "=", ",", ";", "<", "&"
  # <chars>, and <extension> are both arbitrary strings.
  # unquoted whitespaces are ignored.
  # 'xxx' can be used to quote characters
  # One difference from Collator is that & is used to reset to a current
  # point. Or, in other words, it introduces a new sequence which is to
  # be added to the old.
  # That is: "a < b < c < d" is the same as "a < b & b < c & c < d" OR
  # "a < b < d & b < c"
  # XXX: make '' be a single quote.
  # @see PatternEntry
  # @author             Mark Davis, Helena Shih
  class MergeCollation 
    include_class_members MergeCollationImports
    
    typesig { [String] }
    # Creates from a pattern
    # @exception ParseException If the input pattern is incorrect.
    def initialize(pattern)
      @patterns = ArrayList.new
      @save_entry = nil
      @last_entry = nil
      @excess = StringBuffer.new
      @status_array = Array.typed(::Java::Byte).new(8192) { 0 }
      @bitarraymask = 0x1
      @bytepower = 3
      @bytemask = (1 << @bytepower) - 1
      i = 0
      while i < @status_array.attr_length
        @status_array[i] = 0
        i += 1
      end
      set_pattern(pattern)
    end
    
    typesig { [] }
    # recovers current pattern
    def get_pattern
      return get_pattern(true)
    end
    
    typesig { [::Java::Boolean] }
    # recovers current pattern.
    # @param withWhiteSpace puts spacing around the entries, and \n
    # before & and <
    def get_pattern(with_white_space)
      result = StringBuffer.new
      tmp = nil
      ext_list = nil
      i = 0
      i = 0
      while i < @patterns.size
        entry = @patterns.get(i)
        if (!(entry.attr_extension.length).equal?(0))
          if ((ext_list).nil?)
            ext_list = ArrayList.new
          end
          ext_list.add(entry)
        else
          if (!(ext_list).nil?)
            last = find_last_with_no_extension(i - 1)
            j = ext_list.size - 1
            while j >= 0
              tmp = (ext_list.get(j))
              tmp.add_to_buffer(result, false, with_white_space, last)
              j -= 1
            end
            ext_list = nil
          end
          entry.add_to_buffer(result, false, with_white_space, nil)
        end
        (i += 1)
      end
      if (!(ext_list).nil?)
        last = find_last_with_no_extension(i - 1)
        j = ext_list.size - 1
        while j >= 0
          tmp = (ext_list.get(j))
          tmp.add_to_buffer(result, false, with_white_space, last)
          j -= 1
        end
        ext_list = nil
      end
      return result.to_s
    end
    
    typesig { [::Java::Int] }
    def find_last_with_no_extension(i)
      (i -= 1)
      while i >= 0
        entry = @patterns.get(i)
        if ((entry.attr_extension.length).equal?(0))
          return entry
        end
        (i -= 1)
      end
      return nil
    end
    
    typesig { [] }
    # emits the pattern for collation builder.
    # @return emits the string in the format understable to the collation
    # builder.
    def emit_pattern
      return emit_pattern(true)
    end
    
    typesig { [::Java::Boolean] }
    # emits the pattern for collation builder.
    # @param withWhiteSpace puts spacing around the entries, and \n
    # before & and <
    # @return emits the string in the format understable to the collation
    # builder.
    def emit_pattern(with_white_space)
      result = StringBuffer.new
      i = 0
      while i < @patterns.size
        entry = @patterns.get(i)
        if (!(entry).nil?)
          entry.add_to_buffer(result, true, with_white_space, nil)
        end
        (i += 1)
      end
      return result.to_s
    end
    
    typesig { [String] }
    # sets the pattern.
    def set_pattern(pattern)
      @patterns.clear
      add_pattern(pattern)
    end
    
    typesig { [String] }
    # adds a pattern to the current one.
    # @param pattern the new pattern to be added
    def add_pattern(pattern)
      if ((pattern).nil?)
        return
      end
      parser = PatternEntry::Parser.new(pattern)
      entry = parser.next
      while (!(entry).nil?)
        fix_entry(entry)
        entry = parser.next
      end
    end
    
    typesig { [] }
    # gets count of separate entries
    # @return the size of pattern entries
    def get_count
      return @patterns.size
    end
    
    typesig { [::Java::Int] }
    # gets count of separate entries
    # @param index the offset of the desired pattern entry
    # @return the requested pattern entry
    def get_item_at(index)
      return @patterns.get(index)
    end
    
    # ============================================================
    # privates
    # ============================================================
    attr_accessor :patterns
    alias_method :attr_patterns, :patterns
    undef_method :patterns
    alias_method :attr_patterns=, :patterns=
    undef_method :patterns=
    
    # a list of PatternEntries
    attr_accessor :save_entry
    alias_method :attr_save_entry, :save_entry
    undef_method :save_entry
    alias_method :attr_save_entry=, :save_entry=
    undef_method :save_entry=
    
    attr_accessor :last_entry
    alias_method :attr_last_entry, :last_entry
    undef_method :last_entry
    alias_method :attr_last_entry=, :last_entry=
    undef_method :last_entry=
    
    # This is really used as a local variable inside fixEntry, but we cache
    # it here to avoid newing it up every time the method is called.
    attr_accessor :excess
    alias_method :attr_excess, :excess
    undef_method :excess
    alias_method :attr_excess=, :excess=
    undef_method :excess=
    
    # When building a MergeCollation, we need to do lots of searches to see
    # whether a given entry is already in the table.  Since we're using an
    # array, this would make the algorithm O(N*N).  To speed things up, we
    # use this bit array to remember whether the array contains any entries
    # starting with each Unicode character.  If not, we can avoid the search.
    # Using BitSet would make this easier, but it's significantly slower.
    attr_accessor :status_array
    alias_method :attr_status_array, :status_array
    undef_method :status_array
    alias_method :attr_status_array=, :status_array=
    undef_method :status_array=
    
    attr_accessor :bitarraymask
    alias_method :attr_bitarraymask, :bitarraymask
    undef_method :bitarraymask
    alias_method :attr_bitarraymask=, :bitarraymask=
    undef_method :bitarraymask=
    
    attr_accessor :bytepower
    alias_method :attr_bytepower, :bytepower
    undef_method :bytepower
    alias_method :attr_bytepower=, :bytepower=
    undef_method :bytepower=
    
    attr_accessor :bytemask
    alias_method :attr_bytemask, :bytemask
    undef_method :bytemask
    alias_method :attr_bytemask=, :bytemask=
    undef_method :bytemask=
    
    typesig { [PatternEntry] }
    # If the strength is RESET, then just change the lastEntry to
    # be the current. (If the current is not in patterns, signal an error).
    # If not, then remove the current entry, and add it after lastEntry
    # (which is usually at the end).
    def fix_entry(new_entry)
      # check to see whether the new entry has the same characters as the previous
      # entry did (this can happen when a pattern declaring a difference between two
      # strings that are canonically equivalent is normalized).  If so, and the strength
      # is anything other than IDENTICAL or RESET, throw an exception (you can't
      # declare a string to be unequal to itself).       --rtg 5/24/99
      if (!(@last_entry).nil? && (new_entry.attr_chars == @last_entry.attr_chars) && (new_entry.attr_extension == @last_entry.attr_extension))
        if (!(new_entry.attr_strength).equal?(Collator::IDENTICAL) && !(new_entry.attr_strength).equal?(PatternEntry::RESET))
          raise ParseException.new("The entries " + (@last_entry).to_s + " and " + (new_entry).to_s + " are adjacent in the rules, but have conflicting " + "strengths: A character can't be unequal to itself.", -1)
        else
          # otherwise, just skip this entry and behave as though you never saw it
          return
        end
      end
      change_last_entry = true
      if (!(new_entry.attr_strength).equal?(PatternEntry::RESET))
        old_index = -1
        if (((new_entry.attr_chars.length).equal?(1)))
          c = new_entry.attr_chars.char_at(0)
          status_index = c >> @bytepower
          bit_clump = @status_array[status_index]
          set_bit = (@bitarraymask << (c & @bytemask))
          if (!(bit_clump).equal?(0) && !((bit_clump & set_bit)).equal?(0))
            old_index = @patterns.last_index_of(new_entry)
          else
            # We're going to add an element that starts with this
            # character, so go ahead and set its bit.
            @status_array[status_index] = (bit_clump | set_bit)
          end
        else
          old_index = @patterns.last_index_of(new_entry)
        end
        if (!(old_index).equal?(-1))
          @patterns.remove(old_index)
        end
        @excess.set_length(0)
        last_index = find_last_entry(@last_entry, @excess)
        if (!(@excess.length).equal?(0))
          new_entry.attr_extension = @excess + new_entry.attr_extension
          if (!(last_index).equal?(@patterns.size))
            @last_entry = @save_entry
            change_last_entry = false
          end
        end
        if ((last_index).equal?(@patterns.size))
          @patterns.add(new_entry)
          @save_entry = new_entry
        else
          @patterns.add(last_index, new_entry)
        end
      end
      if (change_last_entry)
        @last_entry = new_entry
      end
    end
    
    typesig { [PatternEntry, StringBuffer] }
    def find_last_entry(entry, excess_chars)
      if ((entry).nil?)
        return 0
      end
      if (!(entry.attr_strength).equal?(PatternEntry::RESET))
        # Search backwards for string that contains this one;
        # most likely entry is last one
        old_index = -1
        if (((entry.attr_chars.length).equal?(1)))
          index = entry.attr_chars.char_at(0) >> @bytepower
          if (!((@status_array[index] & (@bitarraymask << (entry.attr_chars.char_at(0) & @bytemask)))).equal?(0))
            old_index = @patterns.last_index_of(entry)
          end
        else
          old_index = @patterns.last_index_of(entry)
        end
        if (((old_index).equal?(-1)))
          raise ParseException.new("couldn't find last entry: " + (entry).to_s, old_index)
        end
        return old_index + 1
      else
        i = 0
        i = @patterns.size - 1
        while i >= 0
          e = @patterns.get(i)
          if (e.attr_chars.region_matches(0, entry.attr_chars, 0, e.attr_chars.length))
            excess_chars.append(entry.attr_chars.substring(e.attr_chars.length, entry.attr_chars.length))
            break
          end
          (i -= 1)
        end
        if ((i).equal?(-1))
          raise ParseException.new("couldn't find: " + (entry).to_s, i)
        end
        return i + 1
      end
    end
    
    private
    alias_method :initialize__merge_collation, :initialize
  end
  
end

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
# 
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
  module BreakDictionaryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :MissingResourceException
      include_const ::Sun::Text, :CompactByteArray
      include_const ::Sun::Text, :SupplementaryCharacterData
    }
  end
  
  # This is the class that represents the list of known words used by
  # DictionaryBasedBreakIterator.  The conceptual data structure used
  # here is a trie: there is a node hanging off the root node for every
  # letter that can start a word.  Each of these nodes has a node hanging
  # off of it for every letter that can be the second letter of a word
  # if this node is the first letter, and so on.  The trie is represented
  # as a two-dimensional array that can be treated as a table of state
  # transitions.  Indexes are used to compress this array, taking
  # advantage of the fact that this array will always be very sparse.
  class BreakDictionary 
    include_class_members BreakDictionaryImports
    
    class_module.module_eval {
      # =========================================================================
      # data members
      # =========================================================================
      # 
      # The version of the dictionary that was read in.
      
      def supported_version
        defined?(@@supported_version) ? @@supported_version : @@supported_version= 1
      end
      alias_method :attr_supported_version, :supported_version
      
      def supported_version=(value)
        @@supported_version = value
      end
      alias_method :attr_supported_version=, :supported_version=
    }
    
    # Maps from characters to column numbers.  The main use of this is to
    # avoid making room in the array for empty columns.
    attr_accessor :column_map
    alias_method :attr_column_map, :column_map
    undef_method :column_map
    alias_method :attr_column_map=, :column_map=
    undef_method :column_map=
    
    attr_accessor :supplementary_char_column_map
    alias_method :attr_supplementary_char_column_map, :supplementary_char_column_map
    undef_method :supplementary_char_column_map
    alias_method :attr_supplementary_char_column_map=, :supplementary_char_column_map=
    undef_method :supplementary_char_column_map=
    
    # The number of actual columns in the table
    attr_accessor :num_cols
    alias_method :attr_num_cols, :num_cols
    undef_method :num_cols
    alias_method :attr_num_cols=, :num_cols=
    undef_method :num_cols=
    
    # Columns are organized into groups of 32.  This says how many
    # column groups.  (We could calculate this, but we store the
    # value to avoid having to repeatedly calculate it.)
    attr_accessor :num_col_groups
    alias_method :attr_num_col_groups, :num_col_groups
    undef_method :num_col_groups
    alias_method :attr_num_col_groups=, :num_col_groups=
    undef_method :num_col_groups=
    
    # The actual compressed state table.  Each conceptual row represents
    # a state, and the cells in it contain the row numbers of the states
    # to transition to for each possible letter.  0 is used to indicate
    # an illegal combination of letters (i.e., the error state).  The
    # table is compressed by eliminating all the unpopulated (i.e., zero)
    # cells.  Multiple conceptual rows can then be doubled up in a single
    # physical row by sliding them up and possibly shifting them to one
    # side or the other so the populated cells don't collide.  Indexes
    # are used to identify unpopulated cells and to locate populated cells.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # This index maps logical row numbers to physical row numbers
    attr_accessor :row_index
    alias_method :attr_row_index, :row_index
    undef_method :row_index
    alias_method :attr_row_index=, :row_index=
    undef_method :row_index=
    
    # A bitmap is used to tell which cells in the comceptual table are
    # populated.  This array contains all the unique bit combinations
    # in that bitmap.  If the table is more than 32 columns wide,
    # successive entries in this array are used for a single row.
    attr_accessor :row_index_flags
    alias_method :attr_row_index_flags, :row_index_flags
    undef_method :row_index_flags
    alias_method :attr_row_index_flags=, :row_index_flags=
    undef_method :row_index_flags=
    
    # This index maps from a logical row number into the bitmap table above.
    # (This keeps us from storing duplicate bitmap combinations.)  Since there
    # are a lot of rows with only one populated cell, instead of wasting space
    # in the bitmap table, we just store a negative number in this index for
    # rows with one populated cell.  The absolute value of that number is
    # the column number of the populated cell.
    attr_accessor :row_index_flags_index
    alias_method :attr_row_index_flags_index, :row_index_flags_index
    undef_method :row_index_flags_index
    alias_method :attr_row_index_flags_index=, :row_index_flags_index=
    undef_method :row_index_flags_index=
    
    # For each logical row, this index contains a constant that is added to
    # the logical column number to get the physical column number
    attr_accessor :row_index_shifts
    alias_method :attr_row_index_shifts, :row_index_shifts
    undef_method :row_index_shifts
    alias_method :attr_row_index_shifts=, :row_index_shifts=
    undef_method :row_index_shifts=
    
    typesig { [String] }
    # =========================================================================
    # deserialization
    # =========================================================================
    def initialize(dictionary_name)
      @column_map = nil
      @supplementary_char_column_map = nil
      @num_cols = 0
      @num_col_groups = 0
      @table = nil
      @row_index = nil
      @row_index_flags = nil
      @row_index_flags_index = nil
      @row_index_shifts = nil
      read_dictionary_file(dictionary_name)
    end
    
    typesig { [String] }
    def read_dictionary_file(dictionary_name)
      in_ = nil
      begin
        in_ = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          local_class_in BreakDictionary
          include_class_members BreakDictionary
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::BufferedInputStream.new(get_class.get_resource_as_stream("/sun/text/resources/" + dictionary_name))
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise InternalError.new(e.to_s)
      end
      buf = Array.typed(::Java::Byte).new(8) { 0 }
      if (!(in_.read(buf)).equal?(8))
        raise MissingResourceException.new("Wrong data length", dictionary_name, "")
      end
      # check vesion
      version = BreakIterator.get_int(buf, 0)
      if (!(version).equal?(self.attr_supported_version))
        raise MissingResourceException.new("Dictionary version(" + RJava.cast_to_string(version) + ") is unsupported", dictionary_name, "")
      end
      # get data size
      len = BreakIterator.get_int(buf, 4)
      buf = Array.typed(::Java::Byte).new(len) { 0 }
      if (!(in_.read(buf)).equal?(len))
        raise MissingResourceException.new("Wrong data length", dictionary_name, "")
      end
      # close the stream
      in_.close
      l = 0
      offset = 0
      # read in the column map for BMP characteres (this is serialized in
      # its internal form: an index array followed by a data array)
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      temp = Array.typed(::Java::Short).new(l) { 0 }
      i = 0
      while i < l
        temp[i] = BreakIterator.get_short(buf, offset)
        i += 1
        offset += 2
      end
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      temp2 = Array.typed(::Java::Byte).new(l) { 0 }
      i_ = 0
      while i_ < l
        temp2[i_] = buf[offset]
        i_ += 1
        offset += 1
      end
      @column_map = CompactByteArray.new(temp, temp2)
      # read in numCols and numColGroups
      @num_cols = BreakIterator.get_int(buf, offset)
      offset += 4
      @num_col_groups = BreakIterator.get_int(buf, offset)
      offset += 4
      # read in the row-number index
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      @row_index = Array.typed(::Java::Short).new(l) { 0 }
      i__ = 0
      while i__ < l
        @row_index[i__] = BreakIterator.get_short(buf, offset)
        i__ += 1
        offset += 2
      end
      # load in the populated-cells bitmap: index first, then bitmap list
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      @row_index_flags_index = Array.typed(::Java::Short).new(l) { 0 }
      i___ = 0
      while i___ < l
        @row_index_flags_index[i___] = BreakIterator.get_short(buf, offset)
        i___ += 1
        offset += 2
      end
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      @row_index_flags = Array.typed(::Java::Int).new(l) { 0 }
      i____ = 0
      while i____ < l
        @row_index_flags[i____] = BreakIterator.get_int(buf, offset)
        i____ += 1
        offset += 4
      end
      # load in the row-shift index
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      @row_index_shifts = Array.typed(::Java::Byte).new(l) { 0 }
      i_____ = 0
      while i_____ < l
        @row_index_shifts[i_____] = buf[offset]
        i_____ += 1
        offset += 1
      end
      # load in the actual state table
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      @table = Array.typed(::Java::Short).new(l) { 0 }
      i______ = 0
      while i______ < l
        @table[i______] = BreakIterator.get_short(buf, offset)
        i______ += 1
        offset += 2
      end
      # finally, prepare the column map for supplementary characters
      l = BreakIterator.get_int(buf, offset)
      offset += 4
      temp3 = Array.typed(::Java::Int).new(l) { 0 }
      i_______ = 0
      while i_______ < l
        temp3[i_______] = BreakIterator.get_int(buf, offset)
        i_______ += 1
        offset += 4
      end
      @supplementary_char_column_map = SupplementaryCharacterData.new(temp3)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # =========================================================================
    # access to the words
    # =========================================================================
    # 
    # Uses the column map to map the character to a column number, then
    # passes the row and column number to getNextState()
    # @param row The current state
    # @param ch The character whose column we're interested in
    # @return The new state to transition to
    def get_next_state_from_character(row, ch)
      col = 0
      if (ch < Character::MIN_SUPPLEMENTARY_CODE_POINT)
        col = @column_map.element_at(RJava.cast_to_char(ch))
      else
        col = @supplementary_char_column_map.get_value(ch)
      end
      return get_next_state(row, col)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the value in the cell with the specified (logical) row and
    # column numbers.  In DictionaryBasedBreakIterator, the row number is
    # a state number, the column number is an input, and the return value
    # is the row number of the new state to transition to.  (0 is the
    # "error" state, and -1 is the "end of word" state in a dictionary)
    # @param row The row number of the current state
    # @param col The column number of the input character (0 means "not a
    # dictionary character")
    # @return The row number of the new state to transition to
    def get_next_state(row, col)
      if (cell_is_populated(row, col))
        # we map from logical to physical row number by looking up the
        # mapping in rowIndex; we map from logical column number to
        # physical column number by looking up a shift value for this
        # logical row and offsetting the logical column number by
        # the shift amount.  Then we can use internalAt() to actually
        # get the value out of the table.
        return internal_at(@row_index[row], col + @row_index_shifts[row])
      else
        return 0
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Given (logical) row and column numbers, returns true if the
    # cell in that position is populated
    def cell_is_populated(row, col)
      # look up the entry in the bitmap index for the specified row.
      # If it's a negative number, it's the column number of the only
      # populated cell in the row
      if (@row_index_flags_index[row] < 0)
        return (col).equal?(-@row_index_flags_index[row])
      # if it's a positive number, it's the offset of an entry in the bitmap
      # list.  If the table is more than 32 columns wide, the bitmap is stored
      # successive entries in the bitmap list, so we have to divide the column
      # number by 32 and offset the number we got out of the index by the result.
      # Once we have the appropriate piece of the bitmap, test the appropriate
      # bit and return the result.
      else
        flags = @row_index_flags[@row_index_flags_index[row] + (col >> 5)]
        return !((flags & (1 << (col & 0x1f)))).equal?(0)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Implementation of getNextState() when we know the specified cell is
    # populated.
    # @param row The PHYSICAL row number of the cell
    # @param col The PHYSICAL column number of the cell
    # @return The value stored in the cell
    def internal_at(row, col)
      # the table is a one-dimensional array, so this just does the math necessary
      # to treat it as a two-dimensional array (we don't just use a two-dimensional
      # array because two-dimensional arrays are inefficient in Java)
      return @table[row * @num_cols + col]
    end
    
    private
    alias_method :initialize__break_dictionary, :initialize
  end
  
end

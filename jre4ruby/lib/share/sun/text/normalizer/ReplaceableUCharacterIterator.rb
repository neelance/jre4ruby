require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ReplaceableUCharacterIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
    }
  end
  
  # DLF docs must define behavior when Replaceable is mutated underneath
  # the iterator.
  # 
  # This and ICUCharacterIterator share some code, maybe they should share
  # an implementation, or the common state and implementation should be
  # moved up into UCharacterIterator.
  # 
  # What are first, last, and getBeginIndex doing here?!?!?!
  class ReplaceableUCharacterIterator < ReplaceableUCharacterIteratorImports.const_get :UCharacterIterator
    include_class_members ReplaceableUCharacterIteratorImports
    
    typesig { [String] }
    # public constructor ------------------------------------------------------
    # Public constructor
    # @param str text which the iterator will be based on
    def initialize(str)
      @replaceable = nil
      @current_index = 0
      super()
      if ((str).nil?)
        raise IllegalArgumentException.new
      end
      @replaceable = ReplaceableString.new(str)
      @current_index = 0
    end
    
    typesig { [StringBuffer] }
    # // for StringPrep
    # Public constructor
    # @param buf buffer of text on which the iterator will be based
    def initialize(buf)
      @replaceable = nil
      @current_index = 0
      super()
      if ((buf).nil?)
        raise IllegalArgumentException.new
      end
      @replaceable = ReplaceableString.new(buf)
      @current_index = 0
    end
    
    typesig { [] }
    # public methods ----------------------------------------------------------
    # Creates a copy of this iterator, does not clone the underlying
    # <code>Replaceable</code>object
    # @return copy of this iterator
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        return nil # never invoked
      end
    end
    
    typesig { [] }
    # Returns the current UTF16 character.
    # @return current UTF16 character
    def current
      if (@current_index < @replaceable.length)
        return @replaceable.char_at(@current_index)
      end
      return DONE
    end
    
    typesig { [] }
    # Returns the length of the text
    # @return length of the text
    def get_length
      return @replaceable.length
    end
    
    typesig { [] }
    # Gets the current currentIndex in text.
    # @return current currentIndex in text.
    def get_index
      return @current_index
    end
    
    typesig { [] }
    # Returns next UTF16 character and increments the iterator's currentIndex by 1.
    # If the resulting currentIndex is greater or equal to the text length, the
    # currentIndex is reset to the text length and a value of DONECODEPOINT is
    # returned.
    # @return next UTF16 character in text or DONE if the new currentIndex is off the
    #         end of the text range.
    def next_
      if (@current_index < @replaceable.length)
        return @replaceable.char_at(((@current_index += 1) - 1))
      end
      return DONE
    end
    
    typesig { [] }
    # Returns previous UTF16 character and decrements the iterator's currentIndex by
    # 1.
    # If the resulting currentIndex is less than 0, the currentIndex is reset to 0 and a
    # value of DONECODEPOINT is returned.
    # @return next UTF16 character in text or DONE if the new currentIndex is off the
    #         start of the text range.
    def previous
      if (@current_index > 0)
        return @replaceable.char_at((@current_index -= 1))
      end
      return DONE
    end
    
    typesig { [::Java::Int] }
    # <p>Sets the currentIndex to the specified currentIndex in the text and returns that
    # single UTF16 character at currentIndex.
    # This assumes the text is stored as 16-bit code units.</p>
    # @param currentIndex the currentIndex within the text.
    # @exception IllegalArgumentException is thrown if an invalid currentIndex is
    #            supplied. i.e. currentIndex is out of bounds.
    # @return the character at the specified currentIndex or DONE if the specified
    #         currentIndex is equal to the end of the text.
    def set_index(current_index)
      if (current_index < 0 || current_index > @replaceable.length)
        raise IllegalArgumentException.new
      end
      @current_index = current_index
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int] }
    # // for StringPrep
    def get_text(fill_in, offset)
      length_ = @replaceable.length
      if (offset < 0 || offset + length_ > fill_in.attr_length)
        raise IndexOutOfBoundsException.new(JavaInteger.to_s(length_))
      end
      @replaceable.get_chars(0, length_, fill_in, offset)
      return length_
    end
    
    # private data members ----------------------------------------------------
    # Replacable object
    attr_accessor :replaceable
    alias_method :attr_replaceable, :replaceable
    undef_method :replaceable
    alias_method :attr_replaceable=, :replaceable=
    undef_method :replaceable=
    
    # Current currentIndex
    attr_accessor :current_index
    alias_method :attr_current_index, :current_index
    undef_method :current_index
    alias_method :attr_current_index=, :current_index=
    undef_method :current_index=
    
    private
    alias_method :initialize__replaceable_ucharacter_iterator, :initialize
  end
  
end

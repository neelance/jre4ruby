require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
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
  module StringCharacterIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # <code>StringCharacterIterator</code> implements the
  # <code>CharacterIterator</code> protocol for a <code>String</code>.
  # The <code>StringCharacterIterator</code> class iterates over the
  # entire <code>String</code>.
  # 
  # @see CharacterIterator
  class StringCharacterIterator 
    include_class_members StringCharacterIteratorImports
    include CharacterIterator
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :begin
    alias_method :attr_begin, :begin
    undef_method :begin
    alias_method :attr_begin=, :begin=
    undef_method :begin=
    
    attr_accessor :end
    alias_method :attr_end, :end
    undef_method :end
    alias_method :attr_end=, :end=
    undef_method :end=
    
    # invariant: begin <= pos <= end
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    typesig { [String] }
    # Constructs an iterator with an initial index of 0.
    def initialize(text)
      initialize__string_character_iterator(text, 0)
    end
    
    typesig { [String, ::Java::Int] }
    # Constructs an iterator with the specified initial index.
    # 
    # @param  text   The String to be iterated over
    # @param  pos    Initial iterator position
    def initialize(text, pos)
      initialize__string_character_iterator(text, 0, text.length, pos)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs an iterator over the given range of the given string, with the
    # index set at the specified position.
    # 
    # @param  text   The String to be iterated over
    # @param  begin  Index of the first character
    # @param  end    Index of the character following the last character
    # @param  pos    Initial iterator position
    def initialize(text, begin_, end_, pos)
      @text = nil
      @begin = 0
      @end = 0
      @pos = 0
      if ((text).nil?)
        raise NullPointerException.new
      end
      @text = text
      if (begin_ < 0 || begin_ > end_ || end_ > text.length)
        raise IllegalArgumentException.new("Invalid substring range")
      end
      if (pos < begin_ || pos > end_)
        raise IllegalArgumentException.new("Invalid position")
      end
      @begin = begin_
      @end = end_
      @pos = pos
    end
    
    typesig { [String] }
    # Reset this iterator to point to a new string.  This package-visible
    # method is used by other java.text classes that want to avoid allocating
    # new StringCharacterIterator objects every time their setText method
    # is called.
    # 
    # @param  text   The String to be iterated over
    # @since 1.2
    def set_text(text)
      if ((text).nil?)
        raise NullPointerException.new
      end
      @text = text
      @begin = 0
      @end = text.length
      @pos = 0
    end
    
    typesig { [] }
    # Implements CharacterIterator.first() for String.
    # @see CharacterIterator#first
    def first
      @pos = @begin
      return current
    end
    
    typesig { [] }
    # Implements CharacterIterator.last() for String.
    # @see CharacterIterator#last
    def last
      if (!(@end).equal?(@begin))
        @pos = @end - 1
      else
        @pos = @end
      end
      return current
    end
    
    typesig { [::Java::Int] }
    # Implements CharacterIterator.setIndex() for String.
    # @see CharacterIterator#setIndex
    def set_index(p)
      if (p < @begin || p > @end)
        raise IllegalArgumentException.new("Invalid index")
      end
      @pos = p
      return current
    end
    
    typesig { [] }
    # Implements CharacterIterator.current() for String.
    # @see CharacterIterator#current
    def current
      if (@pos >= @begin && @pos < @end)
        return @text.char_at(@pos)
      else
        return DONE
      end
    end
    
    typesig { [] }
    # Implements CharacterIterator.next() for String.
    # @see CharacterIterator#next
    def next_
      if (@pos < @end - 1)
        @pos += 1
        return @text.char_at(@pos)
      else
        @pos = @end
        return DONE
      end
    end
    
    typesig { [] }
    # Implements CharacterIterator.previous() for String.
    # @see CharacterIterator#previous
    def previous
      if (@pos > @begin)
        @pos -= 1
        return @text.char_at(@pos)
      else
        return DONE
      end
    end
    
    typesig { [] }
    # Implements CharacterIterator.getBeginIndex() for String.
    # @see CharacterIterator#getBeginIndex
    def get_begin_index
      return @begin
    end
    
    typesig { [] }
    # Implements CharacterIterator.getEndIndex() for String.
    # @see CharacterIterator#getEndIndex
    def get_end_index
      return @end
    end
    
    typesig { [] }
    # Implements CharacterIterator.getIndex() for String.
    # @see CharacterIterator#getIndex
    def get_index
      return @pos
    end
    
    typesig { [Object] }
    # Compares the equality of two StringCharacterIterator objects.
    # @param obj the StringCharacterIterator object to be compared with.
    # @return true if the given obj is the same as this
    # StringCharacterIterator object; false otherwise.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(StringCharacterIterator)))
        return false
      end
      that = obj
      if (!(hash_code).equal?(that.hash_code))
        return false
      end
      if (!(@text == that.attr_text))
        return false
      end
      if (!(@pos).equal?(that.attr_pos) || !(@begin).equal?(that.attr_begin) || !(@end).equal?(that.attr_end))
        return false
      end
      return true
    end
    
    typesig { [] }
    # Computes a hashcode for this iterator.
    # @return A hash code
    def hash_code
      return @text.hash_code ^ @pos ^ @begin ^ @end
    end
    
    typesig { [] }
    # Creates a copy of this iterator.
    # @return A copy of this
    def clone
      begin
        other = super
        return other
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    private
    alias_method :initialize__string_character_iterator, :initialize
  end
  
end

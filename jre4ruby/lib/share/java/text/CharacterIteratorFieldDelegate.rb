require "rjava"

# Copyright 2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Text
  module CharacterIteratorFieldDelegateImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # CharacterIteratorFieldDelegate combines the notifications from a Format
  # into a resulting <code>AttributedCharacterIterator</code>. The resulting
  # <code>AttributedCharacterIterator</code> can be retrieved by way of
  # the <code>getIterator</code> method.
  class CharacterIteratorFieldDelegate 
    include_class_members CharacterIteratorFieldDelegateImports
    include Format::FieldDelegate
    
    # Array of AttributeStrings. Whenever <code>formatted</code> is invoked
    # for a region > size, a new instance of AttributedString is added to
    # attributedStrings. Subsequent invocations of <code>formatted</code>
    # for existing regions result in invoking addAttribute on the existing
    # AttributedStrings.
    attr_accessor :attributed_strings
    alias_method :attr_attributed_strings, :attributed_strings
    undef_method :attributed_strings
    alias_method :attr_attributed_strings=, :attributed_strings=
    undef_method :attributed_strings=
    
    # Running count of the number of characters that have
    # been encountered.
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [] }
    def initialize
      @attributed_strings = nil
      @size = 0
      @attributed_strings = ArrayList.new
    end
    
    typesig { [Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
    def formatted(attr, value, start, end_, buffer)
      if (!(start).equal?(end_))
        if (start < @size)
          # Adjust attributes of existing runs
          index = @size
          as_index = @attributed_strings.size - 1
          while (start < index)
            as = @attributed_strings.get(((as_index -= 1) + 1))
            new_index = index - as.length
            a_start = Math.max(0, start - new_index)
            as.add_attribute(attr, value, a_start, Math.min(end_ - start, as.length - a_start) + a_start)
            index = new_index
          end
        end
        if (@size < start)
          # Pad attributes
          @attributed_strings.add(AttributedString.new(buffer.substring(@size, start)))
          @size = start
        end
        if (@size < end_)
          # Add new string
          a_start = Math.max(start, @size)
          string = AttributedString.new(buffer.substring(a_start, end_))
          string.add_attribute(attr, value)
          @attributed_strings.add(string)
          @size = end_
        end
      end
    end
    
    typesig { [::Java::Int, Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
    def formatted(field_id, attr, value, start, end_, buffer)
      formatted(attr, value, start, end_, buffer)
    end
    
    typesig { [String] }
    # Returns an <code>AttributedCharacterIterator</code> that can be used
    # to iterate over the resulting formatted String.
    # 
    # @pararm string Result of formatting.
    def get_iterator(string)
      # Add the last AttributedCharacterIterator if necessary
      # assert(size <= string.length());
      if (string.length > @size)
        @attributed_strings.add(AttributedString.new(string.substring(@size)))
        @size = string.length
      end
      i_count = @attributed_strings.size
      iterators = Array.typed(AttributedCharacterIterator).new(i_count) { nil }
      counter = 0
      while counter < i_count
        iterators[counter] = (@attributed_strings.get(counter)).get_iterator
        counter += 1
      end
      return AttributedString.new(iterators).get_iterator
    end
    
    private
    alias_method :initialize__character_iterator_field_delegate, :initialize
  end
  
end

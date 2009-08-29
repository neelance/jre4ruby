require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 2003 - All Rights Reserved
# 
# The original version of this source code and documentation is
# copyrighted and owned by IBM. These materials are provided
# under terms of a License Agreement between IBM and Sun.
# This technology is protected by multiple US and International
# patents. This notice and attribution to IBM may not be removed.
module Sun::Text
  module CodePointIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
      include_const ::Java::Text, :CharacterIterator
    }
  end
  
  class CodePointIterator 
    include_class_members CodePointIteratorImports
    
    class_module.module_eval {
      const_set_lazy(:DONE) { -1 }
      const_attr_reader  :DONE
    }
    
    typesig { [] }
    def set_to_start
      raise NotImplementedError
    end
    
    typesig { [] }
    def set_to_limit
      raise NotImplementedError
    end
    
    typesig { [] }
    def next_
      raise NotImplementedError
    end
    
    typesig { [] }
    def prev
      raise NotImplementedError
    end
    
    typesig { [] }
    def char_index
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char)] }
      def create(text)
        return CharArrayCodePointIterator.new(text)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def create(text, start, limit)
        return CharArrayCodePointIterator.new(text, start, limit)
      end
      
      typesig { [CharSequence] }
      def create(text)
        return CharSequenceCodePointIterator.new(text)
      end
      
      typesig { [CharacterIterator] }
      def create(iter)
        return CharacterIteratorCodePointIterator.new(iter)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__code_point_iterator, :initialize
  end
  
  class CharArrayCodePointIterator < CodePointIteratorImports.const_get :CodePointIterator
    include_class_members CodePointIteratorImports
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :start
    alias_method :attr_start, :start
    undef_method :start
    alias_method :attr_start=, :start=
    undef_method :start=
    
    attr_accessor :limit
    alias_method :attr_limit, :limit
    undef_method :limit
    alias_method :attr_limit=, :limit=
    undef_method :limit=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    typesig { [Array.typed(::Java::Char)] }
    def initialize(text)
      @text = nil
      @start = 0
      @limit = 0
      @index = 0
      super()
      @text = text
      @limit = text.attr_length
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def initialize(text, start, limit)
      @text = nil
      @start = 0
      @limit = 0
      @index = 0
      super()
      if (start < 0 || limit < start || limit > text.attr_length)
        raise IllegalArgumentException.new
      end
      @text = text
      @start = @index = start
      @limit = limit
    end
    
    typesig { [] }
    def set_to_start
      @index = @start
    end
    
    typesig { [] }
    def set_to_limit
      @index = @limit
    end
    
    typesig { [] }
    def next_
      if (@index < @limit)
        cp1 = @text[((@index += 1) - 1)]
        if (Character.is_high_surrogate(cp1) && @index < @limit)
          cp2 = @text[@index]
          if (Character.is_low_surrogate(cp2))
            (@index += 1)
            return Character.to_code_point(cp1, cp2)
          end
        end
        return cp1
      end
      return DONE
    end
    
    typesig { [] }
    def prev
      if (@index > @start)
        cp2 = @text[(@index -= 1)]
        if (Character.is_low_surrogate(cp2) && @index > @start)
          cp1 = @text[@index - 1]
          if (Character.is_high_surrogate(cp1))
            (@index -= 1)
            return Character.to_code_point(cp1, cp2)
          end
        end
        return cp2
      end
      return DONE
    end
    
    typesig { [] }
    def char_index
      return @index
    end
    
    private
    alias_method :initialize__char_array_code_point_iterator, :initialize
  end
  
  class CharSequenceCodePointIterator < CodePointIteratorImports.const_get :CodePointIterator
    include_class_members CodePointIteratorImports
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    typesig { [CharSequence] }
    def initialize(text)
      @text = nil
      @index = 0
      super()
      @text = text
    end
    
    typesig { [] }
    def set_to_start
      @index = 0
    end
    
    typesig { [] }
    def set_to_limit
      @index = @text.length
    end
    
    typesig { [] }
    def next_
      if (@index < @text.length)
        cp1 = @text.char_at(((@index += 1) - 1))
        if (Character.is_high_surrogate(cp1) && @index < @text.length)
          cp2 = @text.char_at(@index + 1)
          if (Character.is_low_surrogate(cp2))
            (@index += 1)
            return Character.to_code_point(cp1, cp2)
          end
        end
        return cp1
      end
      return DONE
    end
    
    typesig { [] }
    def prev
      if (@index > 0)
        cp2 = @text.char_at((@index -= 1))
        if (Character.is_low_surrogate(cp2) && @index > 0)
          cp1 = @text.char_at(@index - 1)
          if (Character.is_high_surrogate(cp1))
            (@index -= 1)
            return Character.to_code_point(cp1, cp2)
          end
        end
        return cp2
      end
      return DONE
    end
    
    typesig { [] }
    def char_index
      return @index
    end
    
    private
    alias_method :initialize__char_sequence_code_point_iterator, :initialize
  end
  
  # note this has different iteration semantics than CharacterIterator
  class CharacterIteratorCodePointIterator < CodePointIteratorImports.const_get :CodePointIterator
    include_class_members CodePointIteratorImports
    
    attr_accessor :iter
    alias_method :attr_iter, :iter
    undef_method :iter
    alias_method :attr_iter=, :iter=
    undef_method :iter=
    
    typesig { [CharacterIterator] }
    def initialize(iter)
      @iter = nil
      super()
      @iter = iter
    end
    
    typesig { [] }
    def set_to_start
      @iter.set_index(@iter.get_begin_index)
    end
    
    typesig { [] }
    def set_to_limit
      @iter.set_index(@iter.get_end_index)
    end
    
    typesig { [] }
    def next_
      cp1 = @iter.current
      if (!(cp1).equal?(CharacterIterator::DONE))
        cp2 = @iter.next_
        if (Character.is_high_surrogate(cp1) && !(cp2).equal?(CharacterIterator::DONE))
          if (Character.is_low_surrogate(cp2))
            @iter.next_
            return Character.to_code_point(cp1, cp2)
          end
        end
        return cp1
      end
      return DONE
    end
    
    typesig { [] }
    def prev
      cp2 = @iter.previous
      if (!(cp2).equal?(CharacterIterator::DONE))
        if (Character.is_low_surrogate(cp2))
          cp1 = @iter.previous
          if (Character.is_high_surrogate(cp1))
            return Character.to_code_point(cp1, cp2)
          end
          @iter.next_
        end
        return cp2
      end
      return DONE
    end
    
    typesig { [] }
    def char_index
      return @iter.get_index
    end
    
    private
    alias_method :initialize__character_iterator_code_point_iterator, :initialize
  end
  
end

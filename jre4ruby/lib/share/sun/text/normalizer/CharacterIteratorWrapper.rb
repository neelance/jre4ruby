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
# 
# 
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module CharacterIteratorWrapperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Text, :CharacterIterator
    }
  end
  
  # This class is a wrapper around CharacterIterator and implements the
  # UCharacterIterator protocol
  # @author ram
  class CharacterIteratorWrapper < CharacterIteratorWrapperImports.const_get :UCharacterIterator
    include_class_members CharacterIteratorWrapperImports
    
    attr_accessor :iterator
    alias_method :attr_iterator, :iterator
    undef_method :iterator
    alias_method :attr_iterator=, :iterator=
    undef_method :iterator=
    
    typesig { [CharacterIterator] }
    def initialize(iter)
      @iterator = nil
      super()
      if ((iter).nil?)
        raise IllegalArgumentException.new
      end
      @iterator = iter
    end
    
    typesig { [] }
    # @see UCharacterIterator#current()
    def current
      c = @iterator.current
      if ((c).equal?(CharacterIterator::DONE))
        return DONE
      end
      return c
    end
    
    typesig { [] }
    # @see UCharacterIterator#getLength()
    def get_length
      return (@iterator.get_end_index - @iterator.get_begin_index)
    end
    
    typesig { [] }
    # @see UCharacterIterator#getIndex()
    def get_index
      return @iterator.get_index
    end
    
    typesig { [] }
    # @see UCharacterIterator#next()
    def next_
      i = @iterator.current
      @iterator.next_
      if ((i).equal?(CharacterIterator::DONE))
        return DONE
      end
      return i
    end
    
    typesig { [] }
    # @see UCharacterIterator#previous()
    def previous
      i = @iterator.previous
      if ((i).equal?(CharacterIterator::DONE))
        return DONE
      end
      return i
    end
    
    typesig { [::Java::Int] }
    # @see UCharacterIterator#setIndex(int)
    def set_index(index)
      @iterator.set_index(index)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int] }
    # // for StringPrep
    # 
    # @see UCharacterIterator#getText(char[])
    def get_text(fill_in, offset)
      length = @iterator.get_end_index - @iterator.get_begin_index
      current_index = @iterator.get_index
      if (offset < 0 || offset + length > fill_in.attr_length)
        raise IndexOutOfBoundsException.new(JavaInteger.to_s(length))
      end
      ch = @iterator.first
      while !(ch).equal?(CharacterIterator::DONE)
        fill_in[((offset += 1) - 1)] = ch
        ch = @iterator.next_
      end
      @iterator.set_index(current_index)
      return length
    end
    
    typesig { [] }
    # Creates a clone of this iterator.  Clones the underlying character iterator.
    # @see UCharacterIterator#clone()
    def clone
      begin
        result = super
        result.attr_iterator = @iterator.clone
        return result
      rescue CloneNotSupportedException => e
        return nil # only invoked if bad underlying character iterator
      end
    end
    
    private
    alias_method :initialize__character_iterator_wrapper, :initialize
  end
  
end

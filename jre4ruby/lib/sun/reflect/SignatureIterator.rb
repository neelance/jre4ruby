require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module SignatureIteratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  # Assists in iterating down a method's signature
  class SignatureIterator 
    include_class_members SignatureIteratorImports
    
    attr_accessor :sig
    alias_method :attr_sig, :sig
    undef_method :sig
    alias_method :attr_sig=, :sig=
    undef_method :sig=
    
    attr_accessor :idx
    alias_method :attr_idx, :idx
    undef_method :idx
    alias_method :attr_idx=, :idx=
    undef_method :idx=
    
    typesig { [String] }
    def initialize(sig)
      @sig = nil
      @idx = 0
      @sig = sig
      reset
    end
    
    typesig { [] }
    def reset
      @idx = 1
    end
    
    typesig { [] }
    def at_end
      return (@sig.char_at(@idx)).equal?(Character.new(?).ord))
    end
    
    typesig { [] }
    def next
      if (at_end)
        return nil
      end
      c = @sig.char_at(@idx)
      if (!(c).equal?(Character.new(?[.ord)) && !(c).equal?(Character.new(?L.ord)))
        (@idx += 1)
        return String.new(Array.typed(::Java::Char).new([c]))
      end
      # Walk forward to end of entry
      end_idx = @idx
      if ((c).equal?(Character.new(?[.ord)))
        while (((c = @sig.char_at(end_idx))).equal?(Character.new(?[.ord)))
          end_idx += 1
        end
      end
      if ((c).equal?(Character.new(?L.ord)))
        while (!(@sig.char_at(end_idx)).equal?(Character.new(?;.ord)))
          end_idx += 1
        end
      end
      begin_idx = @idx
      @idx = end_idx + 1
      return @sig.substring(begin_idx, @idx)
    end
    
    typesig { [] }
    # Should only be called when atEnd() is true. Does not change
    # state of iterator.
    def return_type
      if (!at_end)
        raise InternalError.new("Illegal use of SignatureIterator")
      end
      return @sig.substring(@idx + 1, @sig.length)
    end
    
    private
    alias_method :initialize__signature_iterator, :initialize
  end
  
end

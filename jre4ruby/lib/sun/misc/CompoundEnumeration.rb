require "rjava"

# Copyright 1998-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module CompoundEnumerationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # A useful utility class that will enumerate over an array of
  # enumerations.
  class CompoundEnumeration 
    include_class_members CompoundEnumerationImports
    include Enumeration
    
    attr_accessor :enums
    alias_method :attr_enums, :enums
    undef_method :enums
    alias_method :attr_enums=, :enums=
    undef_method :enums=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    typesig { [Array.typed(Enumeration)] }
    def initialize(enums)
      @enums = nil
      @index = 0
      @enums = enums
    end
    
    typesig { [] }
    def next
      while (@index < @enums.attr_length)
        if (!(@enums[@index]).nil? && @enums[@index].has_more_elements)
          return true
        end
        ((@index += 1) - 1)
      end
      return false
    end
    
    typesig { [] }
    def has_more_elements
      return next
    end
    
    typesig { [] }
    def next_element
      if (!next)
        raise NoSuchElementException.new
      end
      return @enums[@index].next_element
    end
    
    private
    alias_method :initialize__compound_enumeration, :initialize
  end
  
end

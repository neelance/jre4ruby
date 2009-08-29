require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module CharacterDataUndefinedImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The CharacterData class encapsulates the large tables found in
  # Java.lang.Character.
  class CharacterDataUndefined < CharacterDataUndefinedImports.const_get :CharacterData
    include_class_members CharacterDataUndefinedImports
    
    typesig { [::Java::Int] }
    def get_properties(ch)
      return 0
    end
    
    typesig { [::Java::Int] }
    def get_type(ch)
      return Character::UNASSIGNED
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_start(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_part(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_start(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_part(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def is_identifier_ignorable(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def to_lower_case(ch)
      return ch
    end
    
    typesig { [::Java::Int] }
    def to_upper_case(ch)
      return ch
    end
    
    typesig { [::Java::Int] }
    def to_title_case(ch)
      return ch
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def digit(ch, radix)
      return -1
    end
    
    typesig { [::Java::Int] }
    def get_numeric_value(ch)
      return -1
    end
    
    typesig { [::Java::Int] }
    def is_whitespace(ch)
      return false
    end
    
    typesig { [::Java::Int] }
    def get_directionality(ch)
      return Character::DIRECTIONALITY_UNDEFINED
    end
    
    typesig { [::Java::Int] }
    def is_mirrored(ch)
      return false
    end
    
    class_module.module_eval {
      const_set_lazy(:Instance) { CharacterDataUndefined.new }
      const_attr_reader  :Instance
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__character_data_undefined, :initialize
  end
  
end

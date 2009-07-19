require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CharacterDataImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  class CharacterData 
    include_class_members CharacterDataImports
    
    typesig { [::Java::Int] }
    def get_properties(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def get_type(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_whitespace(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_mirrored(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_start(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_java_identifier_part(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_start(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_unicode_identifier_part(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def is_identifier_ignorable(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def to_lower_case(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def to_upper_case(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def to_title_case(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def digit(ch, radix)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def get_numeric_value(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def get_directionality(ch)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # need to implement for JSR204
    def to_upper_case_ex(ch)
      return to_upper_case(ch)
    end
    
    typesig { [::Java::Int] }
    def to_upper_case_char_array(ch)
      return nil
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Character <= 0xff (basic latin) is handled by internal fast-path
      # to avoid initializing large tables.
      # Note: performance of this "fast-path" code may be sub-optimal
      # in negative cases for some accessors due to complicated ranges.
      # Should revisit after optimization of table initialization.
      def of(ch)
        if ((ch >> 8).equal?(0))
          # fast-path
          return CharacterDataLatin1.attr_instance
        else
          case (ch >> 16) # plane 00-16
          # Private Use
          when (0)
            return CharacterData00.attr_instance
          when (1)
            return CharacterData01.attr_instance
          when (2)
            return CharacterData02.attr_instance
          when (14)
            return CharacterData0E.attr_instance
          when (15), (16)
            # Private Use
            return CharacterDataPrivateUse.attr_instance
          else
            return CharacterDataUndefined.attr_instance
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__character_data, :initialize
  end
  
end

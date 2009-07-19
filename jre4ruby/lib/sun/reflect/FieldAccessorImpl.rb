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
  module FieldAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  # Package-private implementation of the FieldAccessor interface
  # which has access to all classes and all fields, regardless of
  # language restrictions. See MagicAccessorImpl.
  class FieldAccessorImpl < FieldAccessorImplImports.const_get :MagicAccessorImpl
    include_class_members FieldAccessorImplImports
    include FieldAccessor
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_boolean(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_byte(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_char(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_short(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_int(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_long(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_float(obj)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def get_double(obj)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set(obj, value)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_boolean(obj, z)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Byte] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_byte(obj, b)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Char] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_char(obj, c)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Short] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_short(obj, s)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Int] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_int(obj, i)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_long(obj, l)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Float] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_float(obj, f)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Double] }
    # Matches specification in {@link java.lang.reflect.Field}
    def set_double(obj, d)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__field_accessor_impl, :initialize
  end
  
end

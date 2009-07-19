require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UnsafeBooleanFieldAccessorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
    }
  end
  
  class UnsafeBooleanFieldAccessorImpl < UnsafeBooleanFieldAccessorImplImports.const_get :UnsafeFieldAccessorImpl
    include_class_members UnsafeBooleanFieldAccessorImplImports
    
    typesig { [Field] }
    def initialize(field)
      super(field)
    end
    
    typesig { [Object] }
    def get(obj)
      return Boolean.new(get_boolean(obj))
    end
    
    typesig { [Object] }
    def get_boolean(obj)
      ensure_obj(obj)
      return self.attr_unsafe.get_boolean(obj, self.attr_field_offset)
    end
    
    typesig { [Object] }
    def get_byte(obj)
      raise new_get_byte_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_char(obj)
      raise new_get_char_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_short(obj)
      raise new_get_short_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_int(obj)
      raise new_get_int_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_long(obj)
      raise new_get_long_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_float(obj)
      raise new_get_float_illegal_argument_exception
    end
    
    typesig { [Object] }
    def get_double(obj)
      raise new_get_double_illegal_argument_exception
    end
    
    typesig { [Object, Object] }
    def set(obj, value)
      ensure_obj(obj)
      if (self.attr_is_final)
        throw_final_field_illegal_access_exception(value)
      end
      if ((value).nil?)
        throw_set_illegal_argument_exception(value)
      end
      if (value.is_a?(Boolean))
        self.attr_unsafe.put_boolean(obj, self.attr_field_offset, (value).boolean_value)
        return
      end
      throw_set_illegal_argument_exception(value)
    end
    
    typesig { [Object, ::Java::Boolean] }
    def set_boolean(obj, z)
      ensure_obj(obj)
      if (self.attr_is_final)
        throw_final_field_illegal_access_exception(z)
      end
      self.attr_unsafe.put_boolean(obj, self.attr_field_offset, z)
    end
    
    typesig { [Object, ::Java::Byte] }
    def set_byte(obj, b)
      throw_set_illegal_argument_exception(b)
    end
    
    typesig { [Object, ::Java::Char] }
    def set_char(obj, c)
      throw_set_illegal_argument_exception(c)
    end
    
    typesig { [Object, ::Java::Short] }
    def set_short(obj, s)
      throw_set_illegal_argument_exception(s)
    end
    
    typesig { [Object, ::Java::Int] }
    def set_int(obj, i)
      throw_set_illegal_argument_exception(i)
    end
    
    typesig { [Object, ::Java::Long] }
    def set_long(obj, l)
      throw_set_illegal_argument_exception(l)
    end
    
    typesig { [Object, ::Java::Float] }
    def set_float(obj, f)
      throw_set_illegal_argument_exception(f)
    end
    
    typesig { [Object, ::Java::Double] }
    def set_double(obj, d)
      throw_set_illegal_argument_exception(d)
    end
    
    private
    alias_method :initialize__unsafe_boolean_field_accessor_impl, :initialize
  end
  
end

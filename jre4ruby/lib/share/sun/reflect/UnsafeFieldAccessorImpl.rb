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
  module UnsafeFieldAccessorImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Base class for sun.misc.Unsafe-based FieldAccessors. The
  # observation is that there are only nine types of fields from the
  # standpoint of reflection code: the eight primitive types and
  # Object. Using class Unsafe instead of generated bytecodes saves
  # memory and loading time for the dynamically-generated
  # FieldAccessors.
  class UnsafeFieldAccessorImpl < UnsafeFieldAccessorImplImports.const_get :FieldAccessorImpl
    include_class_members UnsafeFieldAccessorImplImports
    
    class_module.module_eval {
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
    }
    
    attr_accessor :field
    alias_method :attr_field, :field
    undef_method :field
    alias_method :attr_field=, :field=
    undef_method :field=
    
    attr_accessor :field_offset
    alias_method :attr_field_offset, :field_offset
    undef_method :field_offset
    alias_method :attr_field_offset=, :field_offset=
    undef_method :field_offset=
    
    attr_accessor :is_final
    alias_method :attr_is_final, :is_final
    undef_method :is_final
    alias_method :attr_is_final=, :is_final=
    undef_method :is_final=
    
    typesig { [Field] }
    def initialize(field)
      @field = nil
      @field_offset = 0
      @is_final = false
      super()
      @field = field
      @field_offset = UnsafeInstance.field_offset(field)
      @is_final = Modifier.is_final(field.get_modifiers)
    end
    
    typesig { [Object] }
    def ensure_obj(o)
      # NOTE: will throw NullPointerException, as specified, if o is null
      if (!@field.get_declaring_class.is_assignable_from(o.get_class))
        throw_set_illegal_argument_exception(o)
      end
    end
    
    typesig { [] }
    def get_qualified_field_name
      return RJava.cast_to_string(@field.get_declaring_class.get_name) + "." + RJava.cast_to_string(@field.get_name)
    end
    
    typesig { [String] }
    def new_get_illegal_argument_exception(type)
      return IllegalArgumentException.new("Attempt to get " + RJava.cast_to_string(@field.get_type.get_name) + " field \"" + RJava.cast_to_string(get_qualified_field_name) + "\" with illegal data type conversion to " + type)
    end
    
    typesig { [String, String] }
    def throw_final_field_illegal_access_exception(attempted_type, attempted_value)
      raise IllegalAccessException.new(get_set_message(attempted_type, attempted_value))
    end
    
    typesig { [Object] }
    def throw_final_field_illegal_access_exception(o)
      throw_final_field_illegal_access_exception(!(o).nil? ? o.get_class.get_name : "", "")
    end
    
    typesig { [::Java::Boolean] }
    def throw_final_field_illegal_access_exception(z)
      throw_final_field_illegal_access_exception("boolean", Boolean.to_s(z))
    end
    
    typesig { [::Java::Char] }
    def throw_final_field_illegal_access_exception(b)
      throw_final_field_illegal_access_exception("char", Character.to_s(b))
    end
    
    typesig { [::Java::Byte] }
    def throw_final_field_illegal_access_exception(b)
      throw_final_field_illegal_access_exception("byte", Byte.to_s(b))
    end
    
    typesig { [::Java::Short] }
    def throw_final_field_illegal_access_exception(b)
      throw_final_field_illegal_access_exception("short", Short.to_s(b))
    end
    
    typesig { [::Java::Int] }
    def throw_final_field_illegal_access_exception(i)
      throw_final_field_illegal_access_exception("int", JavaInteger.to_s(i))
    end
    
    typesig { [::Java::Long] }
    def throw_final_field_illegal_access_exception(i)
      throw_final_field_illegal_access_exception("long", Long.to_s(i))
    end
    
    typesig { [::Java::Float] }
    def throw_final_field_illegal_access_exception(f)
      throw_final_field_illegal_access_exception("float", Float.to_s(f))
    end
    
    typesig { [::Java::Double] }
    def throw_final_field_illegal_access_exception(f)
      throw_final_field_illegal_access_exception("double", Double.to_s(f))
    end
    
    typesig { [] }
    def new_get_boolean_illegal_argument_exception
      return new_get_illegal_argument_exception("boolean")
    end
    
    typesig { [] }
    def new_get_byte_illegal_argument_exception
      return new_get_illegal_argument_exception("byte")
    end
    
    typesig { [] }
    def new_get_char_illegal_argument_exception
      return new_get_illegal_argument_exception("char")
    end
    
    typesig { [] }
    def new_get_short_illegal_argument_exception
      return new_get_illegal_argument_exception("short")
    end
    
    typesig { [] }
    def new_get_int_illegal_argument_exception
      return new_get_illegal_argument_exception("int")
    end
    
    typesig { [] }
    def new_get_long_illegal_argument_exception
      return new_get_illegal_argument_exception("long")
    end
    
    typesig { [] }
    def new_get_float_illegal_argument_exception
      return new_get_illegal_argument_exception("float")
    end
    
    typesig { [] }
    def new_get_double_illegal_argument_exception
      return new_get_illegal_argument_exception("double")
    end
    
    typesig { [String, String] }
    def get_set_message(attempted_type, attempted_value)
      err = "Can not set"
      if (Modifier.is_static(@field.get_modifiers))
        err += " static"
      end
      if (@is_final)
        err += " final"
      end
      err += " " + RJava.cast_to_string(@field.get_type.get_name) + " field " + RJava.cast_to_string(get_qualified_field_name) + " to "
      if (attempted_value.length > 0)
        err += "(" + attempted_type + ")" + attempted_value
      else
        if (attempted_type.length > 0)
          err += attempted_type
        else
          err += "null value"
        end
      end
      return err
    end
    
    typesig { [String, String] }
    def throw_set_illegal_argument_exception(attempted_type, attempted_value)
      raise IllegalArgumentException.new(get_set_message(attempted_type, attempted_value))
    end
    
    typesig { [Object] }
    def throw_set_illegal_argument_exception(o)
      throw_set_illegal_argument_exception(!(o).nil? ? o.get_class.get_name : "", "")
    end
    
    typesig { [::Java::Boolean] }
    def throw_set_illegal_argument_exception(b)
      throw_set_illegal_argument_exception("boolean", Boolean.to_s(b))
    end
    
    typesig { [::Java::Byte] }
    def throw_set_illegal_argument_exception(b)
      throw_set_illegal_argument_exception("byte", Byte.to_s(b))
    end
    
    typesig { [::Java::Char] }
    def throw_set_illegal_argument_exception(c)
      throw_set_illegal_argument_exception("char", Character.to_s(c))
    end
    
    typesig { [::Java::Short] }
    def throw_set_illegal_argument_exception(s)
      throw_set_illegal_argument_exception("short", Short.to_s(s))
    end
    
    typesig { [::Java::Int] }
    def throw_set_illegal_argument_exception(i)
      throw_set_illegal_argument_exception("int", JavaInteger.to_s(i))
    end
    
    typesig { [::Java::Long] }
    def throw_set_illegal_argument_exception(l)
      throw_set_illegal_argument_exception("long", Long.to_s(l))
    end
    
    typesig { [::Java::Float] }
    def throw_set_illegal_argument_exception(f)
      throw_set_illegal_argument_exception("float", Float.to_s(f))
    end
    
    typesig { [::Java::Double] }
    def throw_set_illegal_argument_exception(d)
      throw_set_illegal_argument_exception("double", Double.to_s(d))
    end
    
    private
    alias_method :initialize__unsafe_field_accessor_impl, :initialize
  end
  
end

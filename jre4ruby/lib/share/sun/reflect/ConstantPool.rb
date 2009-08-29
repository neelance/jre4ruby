require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ConstantPoolImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
    }
  end
  
  # Provides reflective access to the constant pools of classes.
  # Currently this is needed to provide reflective access to annotations
  # but may be used by other internal subsystems in the future.
  class ConstantPool 
    include_class_members ConstantPoolImports
    
    typesig { [] }
    # Number of entries in this constant pool (= maximum valid constant pool index)
    def get_size
      return get_size0(@constant_pool_oop)
    end
    
    typesig { [::Java::Int] }
    def get_class_at(index)
      return get_class_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_class_at_if_loaded(index)
      return get_class_at_if_loaded0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    # Returns either a Method or Constructor.
    # Static initializers are returned as Method objects.
    def get_method_at(index)
      return get_method_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_method_at_if_loaded(index)
      return get_method_at_if_loaded0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_field_at(index)
      return get_field_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_field_at_if_loaded(index)
      return get_field_at_if_loaded0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    # Fetches the class name, member (field, method or interface
    # method) name, and type descriptor as an array of three Strings
    def get_member_ref_info_at(index)
      return get_member_ref_info_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_int_at(index)
      return get_int_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_long_at(index)
      return get_long_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_float_at(index)
      return get_float_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_double_at(index)
      return get_double_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_string_at(index)
      return get_string_at0(@constant_pool_oop, index)
    end
    
    typesig { [::Java::Int] }
    def get_utf8at(index)
      return get_utf8at0(@constant_pool_oop, index)
    end
    
    class_module.module_eval {
      # ---------------------------------------------------------------------------
      # Internals only below this point
      when_class_loaded do
        Reflection.register_fields_to_filter(ConstantPool, Array.typed(String).new(["constantPoolOop"]))
      end
    }
    
    # HotSpot-internal constant pool object (set by the VM, name known to the VM)
    attr_accessor :constant_pool_oop
    alias_method :attr_constant_pool_oop, :constant_pool_oop
    undef_method :constant_pool_oop
    alias_method :attr_constant_pool_oop=, :constant_pool_oop=
    undef_method :constant_pool_oop=
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getSize0, [:pointer, :long, :long], :int32
    typesig { [Object] }
    def get_size0(constant_pool_oop)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getSize0, JNI.env, self.jni_id, constant_pool_oop.jni_id)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getClassAt0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_class_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getClassAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getClassAtIfLoaded0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_class_at_if_loaded0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getClassAtIfLoaded0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getMethodAt0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_method_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getMethodAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getMethodAtIfLoaded0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_method_at_if_loaded0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getMethodAtIfLoaded0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getFieldAt0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_field_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getFieldAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getFieldAtIfLoaded0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_field_at_if_loaded0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getFieldAtIfLoaded0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getMemberRefInfoAt0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_member_ref_info_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getMemberRefInfoAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getIntAt0, [:pointer, :long, :long, :int32], :int32
    typesig { [Object, ::Java::Int] }
    def get_int_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getIntAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getLongAt0, [:pointer, :long, :long, :int32], :int64
    typesig { [Object, ::Java::Int] }
    def get_long_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getLongAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getFloatAt0, [:pointer, :long, :long, :int32], :float
    typesig { [Object, ::Java::Int] }
    def get_float_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getFloatAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getDoubleAt0, [:pointer, :long, :long, :int32], :double
    typesig { [Object, ::Java::Int] }
    def get_double_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getDoubleAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getStringAt0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_string_at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getStringAt0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    JNI.native_method :Java_sun_reflect_ConstantPool_getUTF8At0, [:pointer, :long, :long, :int32], :long
    typesig { [Object, ::Java::Int] }
    def get_utf8at0(constant_pool_oop, index)
      JNI.__send__(:Java_sun_reflect_ConstantPool_getUTF8At0, JNI.env, self.jni_id, constant_pool_oop.jni_id, index.to_int)
    end
    
    typesig { [] }
    def initialize
      @constant_pool_oop = nil
    end
    
    private
    alias_method :initialize__constant_pool, :initialize
  end
  
end

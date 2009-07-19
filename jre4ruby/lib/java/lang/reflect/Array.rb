require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Reflect
  module ArrayImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
    }
  end
  
  # The {@code Array} class provides static methods to dynamically create and
  # access Java arrays.
  # 
  # <p>{@code Array} permits widening conversions to occur during a get or set
  # operation, but throws an {@code IllegalArgumentException} if a narrowing
  # conversion would occur.
  # 
  # @author Nakul Saraiya
  class Array 
    include_class_members ArrayImports
    
    typesig { [] }
    # Constructor.  Class Array is not instantiable.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Class, ::Java::Int] }
      # Creates a new array with the specified component type and
      # length.
      # Invoking this method is equivalent to creating an array
      # as follows:
      # <blockquote>
      # <pre>
      # int[] x = {length};
      # Array.newInstance(componentType, x);
      # </pre>
      # </blockquote>
      # 
      # @param componentType the {@code Class} object representing the
      # component type of the new array
      # @param length the length of the new array
      # @return the new array
      # @exception NullPointerException if the specified
      # {@code componentType} parameter is null
      # @exception IllegalArgumentException if componentType is {@link Void#TYPE}
      # @exception NegativeArraySizeException if the specified {@code length}
      # is negative
      def new_instance(component_type, length)
        return new_array(component_type, length)
      end
      
      typesig { [Class, ::Java::Int] }
      # Creates a new array
      # with the specified component type and dimensions.
      # If {@code componentType}
      # represents a non-array class or interface, the new array
      # has {@code dimensions.length} dimensions and
      # {@code componentType} as its component type. If
      # {@code componentType} represents an array class, the
      # number of dimensions of the new array is equal to the sum
      # of {@code dimensions.length} and the number of
      # dimensions of {@code componentType}. In this case, the
      # component type of the new array is the component type of
      # {@code componentType}.
      # 
      # <p>The number of dimensions of the new array must not
      # exceed the number of array dimensions supported by the
      # implementation (typically 255).
      # 
      # @param componentType the {@code Class} object representing the component
      # type of the new array
      # @param dimensions an array of {@code int} representing the dimensions of
      # the new array
      # @return the new array
      # @exception NullPointerException if the specified
      # {@code componentType} argument is null
      # @exception IllegalArgumentException if the specified {@code dimensions}
      # argument is a zero-dimensional array, or if the number of
      # requested dimensions exceeds the limit on the number of array dimensions
      # supported by the implementation (typically 255), or if componentType
      # is {@link Void#TYPE}.
      # @exception NegativeArraySizeException if any of the components in
      # the specified {@code dimensions} argument is negative.
      def new_instance(component_type, *dimensions)
        return multi_new_array(component_type, dimensions)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getLength, [:pointer, :long, :long], :int32
      typesig { [Object] }
      # Returns the length of the specified array object, as an {@code int}.
      # 
      # @param array the array
      # @return the length of the array
      # @exception IllegalArgumentException if the object argument is not
      # an array
      def get_length(array)
        JNI.__send__(:Java_java_lang_reflect_Array_getLength, JNI.env, self.jni_id, array.jni_id)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_get, [:pointer, :long, :long, :int32], :long
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object.  The value is automatically wrapped in an object
      # if it has a primitive type.
      # 
      # @param array the array
      # @param index the index
      # @return the (possibly wrapped) value of the indexed component in
      # the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      def get(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_get, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getBoolean, [:pointer, :long, :long, :int32], :int8
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code boolean}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_boolean(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getBoolean, JNI.env, self.jni_id, array.jni_id, index.to_int) != 0
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getByte, [:pointer, :long, :long, :int32], :int8
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code byte}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_byte(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getByte, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getChar, [:pointer, :long, :long, :int32], :unknown
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code char}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_char(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getChar, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getShort, [:pointer, :long, :long, :int32], :int16
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code short}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_short(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getShort, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getInt, [:pointer, :long, :long, :int32], :int32
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as an {@code int}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_int(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getInt, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getLong, [:pointer, :long, :long, :int32], :int64
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code long}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_long(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getLong, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getFloat, [:pointer, :long, :long, :int32], :float
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code float}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_float(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getFloat, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_getDouble, [:pointer, :long, :long, :int32], :double
      typesig { [Object, ::Java::Int] }
      # Returns the value of the indexed component in the specified
      # array object, as a {@code double}.
      # 
      # @param array the array
      # @param index the index
      # @return the value of the indexed component in the specified array
      # @exception NullPointerException If the specified object is null
      # @exception IllegalArgumentException If the specified object is not
      # an array, or if the indexed element cannot be converted to the
      # return type by an identity or widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to the
      # length of the specified array
      # @see Array#get
      def get_double(array, index)
        JNI.__send__(:Java_java_lang_reflect_Array_getDouble, JNI.env, self.jni_id, array.jni_id, index.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_set, [:pointer, :long, :long, :int32, :long], :void
      typesig { [Object, ::Java::Int, Object] }
      # Sets the value of the indexed component of the specified array
      # object to the specified new value.  The new value is first
      # automatically unwrapped if the array has a primitive component
      # type.
      # @param array the array
      # @param index the index into the array
      # @param value the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the array component type is primitive and
      # an unwrapping conversion fails
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      def set(array, index, value)
        JNI.__send__(:Java_java_lang_reflect_Array_set, JNI.env, self.jni_id, array.jni_id, index.to_int, value.jni_id)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setBoolean, [:pointer, :long, :long, :int32, :int8], :void
      typesig { [Object, ::Java::Int, ::Java::Boolean] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code boolean} value.
      # @param array the array
      # @param index the index into the array
      # @param z the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_boolean(array, index, z)
        JNI.__send__(:Java_java_lang_reflect_Array_setBoolean, JNI.env, self.jni_id, array.jni_id, index.to_int, z ? 1 : 0)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setByte, [:pointer, :long, :long, :int32, :int8], :void
      typesig { [Object, ::Java::Int, ::Java::Byte] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code byte} value.
      # @param array the array
      # @param index the index into the array
      # @param b the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_byte(array, index, b)
        JNI.__send__(:Java_java_lang_reflect_Array_setByte, JNI.env, self.jni_id, array.jni_id, index.to_int, b.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setChar, [:pointer, :long, :long, :int32, :unknown], :void
      typesig { [Object, ::Java::Int, ::Java::Char] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code char} value.
      # @param array the array
      # @param index the index into the array
      # @param c the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_char(array, index, c)
        JNI.__send__(:Java_java_lang_reflect_Array_setChar, JNI.env, self.jni_id, array.jni_id, index.to_int, c.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setShort, [:pointer, :long, :long, :int32, :int16], :void
      typesig { [Object, ::Java::Int, ::Java::Short] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code short} value.
      # @param array the array
      # @param index the index into the array
      # @param s the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_short(array, index, s)
        JNI.__send__(:Java_java_lang_reflect_Array_setShort, JNI.env, self.jni_id, array.jni_id, index.to_int, s.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setInt, [:pointer, :long, :long, :int32, :int32], :void
      typesig { [Object, ::Java::Int, ::Java::Int] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code int} value.
      # @param array the array
      # @param index the index into the array
      # @param i the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_int(array, index, i)
        JNI.__send__(:Java_java_lang_reflect_Array_setInt, JNI.env, self.jni_id, array.jni_id, index.to_int, i.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setLong, [:pointer, :long, :long, :int32, :int64], :void
      typesig { [Object, ::Java::Int, ::Java::Long] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code long} value.
      # @param array the array
      # @param index the index into the array
      # @param l the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_long(array, index, l)
        JNI.__send__(:Java_java_lang_reflect_Array_setLong, JNI.env, self.jni_id, array.jni_id, index.to_int, l.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setFloat, [:pointer, :long, :long, :int32, :float], :void
      typesig { [Object, ::Java::Int, ::Java::Float] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code float} value.
      # @param array the array
      # @param index the index into the array
      # @param f the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_float(array, index, f)
        JNI.__send__(:Java_java_lang_reflect_Array_setFloat, JNI.env, self.jni_id, array.jni_id, index.to_int, f)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_setDouble, [:pointer, :long, :long, :int32, :double], :void
      typesig { [Object, ::Java::Int, ::Java::Double] }
      # Sets the value of the indexed component of the specified array
      # object to the specified {@code double} value.
      # @param array the array
      # @param index the index into the array
      # @param d the new value of the indexed component
      # @exception NullPointerException If the specified object argument
      # is null
      # @exception IllegalArgumentException If the specified object argument
      # is not an array, or if the specified value cannot be converted
      # to the underlying array's component type by an identity or a
      # primitive widening conversion
      # @exception ArrayIndexOutOfBoundsException If the specified {@code index}
      # argument is negative, or if it is greater than or equal to
      # the length of the specified array
      # @see Array#set
      def set_double(array, index, d)
        JNI.__send__(:Java_java_lang_reflect_Array_setDouble, JNI.env, self.jni_id, array.jni_id, index.to_int, d)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_newArray, [:pointer, :long, :long, :int32], :long
      typesig { [Class, ::Java::Int] }
      # Private
      def new_array(component_type, length)
        JNI.__send__(:Java_java_lang_reflect_Array_newArray, JNI.env, self.jni_id, component_type.jni_id, length.to_int)
      end
      
      JNI.native_method :Java_java_lang_reflect_Array_multiNewArray, [:pointer, :long, :long, :long], :long
      typesig { [Class, Array.typed(::Java::Int)] }
      def multi_new_array(component_type, dimensions)
        JNI.__send__(:Java_java_lang_reflect_Array_multiNewArray, JNI.env, self.jni_id, component_type.jni_id, dimensions.jni_id)
      end
    }
    
    private
    alias_method :initialize__array, :initialize
  end
  
end

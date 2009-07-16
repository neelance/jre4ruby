require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UnsafeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include ::Java::Security
      include ::Java::Lang::Reflect
    }
  end
  
  # 
  # A collection of methods for performing low-level, unsafe operations.
  # Although the class and all methods are public, use of this class is
  # limited because only trusted code can obtain instances of it.
  # 
  # @author John R. Rose
  # @see #getUnsafe
  class Unsafe 
    include_class_members UnsafeImports
    
    class_module.module_eval {
      JNI.native_method :Java_sun_misc_Unsafe_registerNatives, [:pointer, :long], :void
      typesig { [] }
      def register_natives
        JNI.__send__(:Java_sun_misc_Unsafe_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
        Sun::Reflect::Reflection.register_methods_to_filter(Unsafe.class, "getUnsafe")
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      const_set_lazy(:TheUnsafe) { Unsafe.new }
      const_attr_reader  :TheUnsafe
      
      typesig { [] }
      # 
      # Provides the caller with the capability of performing unsafe
      # operations.
      # 
      # <p> The returned <code>Unsafe</code> object should be carefully guarded
      # by the caller, since it can be used to read and write data at arbitrary
      # memory addresses.  It must never be passed to untrusted code.
      # 
      # <p> Most methods in this class are very low-level, and correspond to a
      # small number of hardware instructions (on typical machines).  Compilers
      # are encouraged to optimize these methods accordingly.
      # 
      # <p> Here is a suggested idiom for using unsafe operations:
      # 
      # <blockquote><pre>
      # class MyTrustedClass {
      # private static final Unsafe unsafe = Unsafe.getUnsafe();
      # ...
      # private long myCountAddress = ...;
      # public int getCount() { return unsafe.getByte(myCountAddress); }
      # }
      # </pre></blockquote>
      # 
      # (It may assist compilers to make the local variable be
      # <code>final</code>.)
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow
      # access to the system properties.
      def get_unsafe
        cc = Sun::Reflect::Reflection.get_caller_class(2)
        if (!(cc.get_class_loader).nil?)
          raise SecurityException.new("Unsafe")
        end
        return TheUnsafe
      end
    }
    
    JNI.native_method "Java_sun_misc_Unsafe_getInt__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :int32
    typesig { [Object, ::Java::Long] }
    # / peek and poke operations
    # / (compilers should optimize these to memory ops)
    # These work on object fields in the Java heap.
    # They will not work on elements of packed arrays.
    # 
    # Fetches a value from a given Java variable.
    # More specifically, fetches a field or array element within the given
    # object <code>o</code> at the given offset, or (if <code>o</code> is
    # null) from the memory address whose numerical value is the given
    # offset.
    # <p>
    # The results are undefined unless one of the following cases is true:
    # <ul>
    # <li>The offset was obtained from {@link #objectFieldOffset} on
    # the {@link java.lang.reflect.Field} of some Java field and the object
    # referred to by <code>o</code> is of a class compatible with that
    # field's class.
    # 
    # <li>The offset and object reference <code>o</code> (either null or
    # non-null) were both obtained via {@link #staticFieldOffset}
    # and {@link #staticFieldBase} (respectively) from the
    # reflective {@link Field} representation of some Java field.
    # 
    # <li>The object referred to by <code>o</code> is an array, and the offset
    # is an integer of the form <code>B+N*S</code>, where <code>N</code> is
    # a valid index into the array, and <code>B</code> and <code>S</code> are
    # the values obtained by {@link #arrayBaseOffset} and {@link
    # #arrayIndexScale} (respectively) from the array's class.  The value
    # referred to is the <code>N</code><em>th</em> element of the array.
    # 
    # </ul>
    # <p>
    # If one of the above cases is true, the call references a specific Java
    # variable (field or array element).  However, the results are undefined
    # if that variable is not in fact of the type returned by this method.
    # <p>
    # This method refers to a variable by means of two parameters, and so
    # it provides (in effect) a <em>double-register</em> addressing mode
    # for Java variables.  When the object reference is null, this method
    # uses its offset as an absolute address.  This is similar in operation
    # to methods such as {@link #getInt(long)}, which provide (in effect) a
    # <em>single-register</em> addressing mode for non-Java variables.
    # However, because Java variables may have a different layout in memory
    # from non-Java variables, programmers should not assume that these
    # two addressing modes are ever equivalent.  Also, programmers should
    # remember that offsets from the double-register addressing mode cannot
    # be portably confused with longs used in the single-register addressing
    # mode.
    # 
    # @param o Java heap object in which the variable resides, if any, else
    # null
    # @param offset indication of where the variable resides in a Java heap
    # object, if any, else a memory address locating the variable
    # statically
    # @return the value fetched from the indicated Java variable
    # @throws RuntimeException No defined exceptions are thrown, not even
    # {@link NullPointerException}
    def get_int(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getInt__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putInt__L#{Object.jni_name}_2JI".to_sym, [:pointer, :long, :long, :int64, :int32], :void
    typesig { [Object, ::Java::Long, ::Java::Int] }
    # 
    # Stores a value into a given Java variable.
    # <p>
    # The first two parameters are interpreted exactly as with
    # {@link #getInt(Object, long)} to refer to a specific
    # Java variable (field or array element).  The given value
    # is stored into that variable.
    # <p>
    # The variable must be of the same type as the method
    # parameter <code>x</code>.
    # 
    # @param o Java heap object in which the variable resides, if any, else
    # null
    # @param offset indication of where the variable resides in a Java heap
    # object, if any, else a memory address locating the variable
    # statically
    # @param x the value to store into the indicated Java variable
    # @throws RuntimeException No defined exceptions are thrown, not even
    # {@link NullPointerException}
    def put_int(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putInt__L#{Object.jni_name}_2JI".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getObject, [:pointer, :long, :long, :int64], :long
    typesig { [Object, ::Java::Long] }
    # 
    # Fetches a reference value from a given Java variable.
    # @see #getInt(Object, long)
    def get_object(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getObject, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putObject, [:pointer, :long, :long, :int64, :long], :void
    typesig { [Object, ::Java::Long, Object] }
    # 
    # Stores a reference value into a given Java variable.
    # <p>
    # Unless the reference <code>x</code> being stored is either null
    # or matches the field type, the results are undefined.
    # If the reference <code>o</code> is non-null, car marks or
    # other store barriers for that object (if the VM requires them)
    # are updated.
    # @see #putInt(Object, int, int)
    def put_object(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putObject, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getBoolean, [:pointer, :long, :long, :int64], :int8
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_boolean(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getBoolean, JNI.env, self.jni_id, o.jni_id, offset.to_int) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putBoolean, [:pointer, :long, :long, :int64, :int8], :void
    typesig { [Object, ::Java::Long, ::Java::Boolean] }
    # @see #putInt(Object, int, int)
    def put_boolean(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putBoolean, JNI.env, self.jni_id, o.jni_id, offset.to_int, x ? 1 : 0)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getByte__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :int8
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_byte(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getByte__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putByte__L#{Object.jni_name}_2JB".to_sym, [:pointer, :long, :long, :int64, :int8], :void
    typesig { [Object, ::Java::Long, ::Java::Byte] }
    # @see #putInt(Object, int, int)
    def put_byte(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putByte__L#{Object.jni_name}_2JB".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getShort__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :int16
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_short(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getShort__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putShort__L#{Object.jni_name}_2JS".to_sym, [:pointer, :long, :long, :int64, :int16], :void
    typesig { [Object, ::Java::Long, ::Java::Short] }
    # @see #putInt(Object, int, int)
    def put_short(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putShort__L#{Object.jni_name}_2JS".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getChar__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :unknown
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_char(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getChar__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putChar__L#{Object.jni_name}_2JC".to_sym, [:pointer, :long, :long, :int64, :unknown], :void
    typesig { [Object, ::Java::Long, ::Java::Char] }
    # @see #putInt(Object, int, int)
    def put_char(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putChar__L#{Object.jni_name}_2JC".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getLong__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :int64
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_long(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getLong__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putLong__L#{Object.jni_name}_2JJ".to_sym, [:pointer, :long, :long, :int64, :int64], :void
    typesig { [Object, ::Java::Long, ::Java::Long] }
    # @see #putInt(Object, int, int)
    def put_long(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putLong__L#{Object.jni_name}_2JJ".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getFloat__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :float
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_float(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getFloat__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putFloat__L#{Object.jni_name}_2JXfloatX".to_sym, [:pointer, :long, :long, :int64, :float], :void
    typesig { [Object, ::Java::Long, ::Java::Float] }
    # @see #putInt(Object, int, int)
    def put_float(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putFloat__L#{Object.jni_name}_2JXfloatX".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_getDouble__L#{Object.jni_name}_2J".to_sym, [:pointer, :long, :long, :int64], :double
    typesig { [Object, ::Java::Long] }
    # @see #getInt(Object, long)
    def get_double(o, offset)
      JNI.__send__("Java_sun_misc_Unsafe_getDouble__L#{Object.jni_name}_2J".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_putDouble__L#{Object.jni_name}_2JXdoubleX".to_sym, [:pointer, :long, :long, :int64, :double], :void
    typesig { [Object, ::Java::Long, ::Java::Double] }
    # @see #putInt(Object, int, int)
    def put_double(o, offset, x)
      JNI.__send__("Java_sun_misc_Unsafe_putDouble__L#{Object.jni_name}_2JXdoubleX".to_sym, JNI.env, self.jni_id, o.jni_id, offset.to_int, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # This method, like all others with 32-bit offsets, was native
    # in a previous release but is now a wrapper which simply casts
    # the offset to a long value.  It provides backward compatibility
    # with bytecodes compiled against 1.4.
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_int(o, offset)
      return get_int(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_int(o, offset, x)
      put_int(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_object(o, offset)
      return get_object(o, offset)
    end
    
    typesig { [Object, ::Java::Int, Object] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_object(o, offset, x)
      put_object(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_boolean(o, offset)
      return get_boolean(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Boolean] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_boolean(o, offset, x)
      put_boolean(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_byte(o, offset)
      return get_byte(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Byte] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_byte(o, offset, x)
      put_byte(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_short(o, offset)
      return get_short(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Short] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_short(o, offset, x)
      put_short(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_char(o, offset)
      return get_char(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Char] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_char(o, offset, x)
      put_char(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_long(o, offset)
      return get_long(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Long] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_long(o, offset, x)
      put_long(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_float(o, offset)
      return get_float(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Float] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_float(o, offset, x)
      put_float(o, offset, x)
    end
    
    typesig { [Object, ::Java::Int] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def get_double(o, offset)
      return get_double(o, offset)
    end
    
    typesig { [Object, ::Java::Int, ::Java::Double] }
    # 
    # @deprecated As of 1.4.1, cast the 32-bit offset argument to a long.
    # See {@link #staticFieldOffset}.
    def put_double(o, offset, x)
      put_double(o, offset, x)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getByte__J, [:pointer, :long, :int64], :int8
    typesig { [::Java::Long] }
    # These work on values in the C heap.
    # 
    # Fetches a value from a given memory address.  If the address is zero, or
    # does not point into a block obtained from {@link #allocateMemory}, the
    # results are undefined.
    # 
    # @see #allocateMemory
    def get_byte(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getByte__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putByte__JB, [:pointer, :long, :int64, :int8], :void
    typesig { [::Java::Long, ::Java::Byte] }
    # 
    # Stores a value into a given memory address.  If the address is zero, or
    # does not point into a block obtained from {@link #allocateMemory}, the
    # results are undefined.
    # 
    # @see #getByte(long)
    def put_byte(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putByte__JB, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getShort__J, [:pointer, :long, :int64], :int16
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_short(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getShort__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putShort__JS, [:pointer, :long, :int64, :int16], :void
    typesig { [::Java::Long, ::Java::Short] }
    # @see #putByte(long, byte)
    def put_short(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putShort__JS, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getChar__J, [:pointer, :long, :int64], :unknown
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_char(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getChar__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putChar__JC, [:pointer, :long, :int64, :unknown], :void
    typesig { [::Java::Long, ::Java::Char] }
    # @see #putByte(long, byte)
    def put_char(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putChar__JC, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getInt__J, [:pointer, :long, :int64], :int32
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_int(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getInt__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putInt__JI, [:pointer, :long, :int64, :int32], :void
    typesig { [::Java::Long, ::Java::Int] }
    # @see #putByte(long, byte)
    def put_int(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putInt__JI, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getLong__J, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_long(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getLong__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putLong__JJ, [:pointer, :long, :int64, :int64], :void
    typesig { [::Java::Long, ::Java::Long] }
    # @see #putByte(long, byte)
    def put_long(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putLong__JJ, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getFloat__J, [:pointer, :long, :int64], :float
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_float(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getFloat__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putFloat__JXfloatX, [:pointer, :long, :int64, :float], :void
    typesig { [::Java::Long, ::Java::Float] }
    # @see #putByte(long, byte)
    def put_float(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putFloat__JXfloatX, JNI.env, self.jni_id, address.to_int, x)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getDouble__J, [:pointer, :long, :int64], :double
    typesig { [::Java::Long] }
    # @see #getByte(long)
    def get_double(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getDouble__J, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putDouble__JXdoubleX, [:pointer, :long, :int64, :double], :void
    typesig { [::Java::Long, ::Java::Double] }
    # @see #putByte(long, byte)
    def put_double(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putDouble__JXdoubleX, JNI.env, self.jni_id, address.to_int, x)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getAddress, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    # 
    # Fetches a native pointer from a given memory address.  If the address is
    # zero, or does not point into a block obtained from {@link
    # #allocateMemory}, the results are undefined.
    # 
    # <p> If the native pointer is less than 64 bits wide, it is extended as
    # an unsigned number to a Java long.  The pointer may be indexed by any
    # given byte offset, simply by adding that offset (as a simple integer) to
    # the long representing the pointer.  The number of bytes actually read
    # from the target address maybe determined by consulting {@link
    # #addressSize}.
    # 
    # @see #allocateMemory
    def get_address(address)
      JNI.__send__(:Java_sun_misc_Unsafe_getAddress, JNI.env, self.jni_id, address.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putAddress, [:pointer, :long, :int64, :int64], :void
    typesig { [::Java::Long, ::Java::Long] }
    # 
    # Stores a native pointer into a given memory address.  If the address is
    # zero, or does not point into a block obtained from {@link
    # #allocateMemory}, the results are undefined.
    # 
    # <p> The number of bytes actually written at the target address maybe
    # determined by consulting {@link #addressSize}.
    # 
    # @see #getAddress(long)
    def put_address(address, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putAddress, JNI.env, self.jni_id, address.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_allocateMemory, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    # / wrappers for malloc, realloc, free:
    # 
    # Allocates a new block of native memory, of the given size in bytes.  The
    # contents of the memory are uninitialized; they will generally be
    # garbage.  The resulting native pointer will never be zero, and will be
    # aligned for all value types.  Dispose of this memory by calling {@link
    # #freeMemory}, or resize it with {@link #reallocateMemory}.
    # 
    # @throws IllegalArgumentException if the size is negative or too large
    # for the native size_t type
    # 
    # @throws OutOfMemoryError if the allocation is refused by the system
    # 
    # @see #getByte(long)
    # @see #putByte(long, byte)
    def allocate_memory(bytes)
      JNI.__send__(:Java_sun_misc_Unsafe_allocateMemory, JNI.env, self.jni_id, bytes.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_reallocateMemory, [:pointer, :long, :int64, :int64], :int64
    typesig { [::Java::Long, ::Java::Long] }
    # 
    # Resizes a new block of native memory, to the given size in bytes.  The
    # contents of the new block past the size of the old block are
    # uninitialized; they will generally be garbage.  The resulting native
    # pointer will be zero if and only if the requested size is zero.  The
    # resulting native pointer will be aligned for all value types.  Dispose
    # of this memory by calling {@link #freeMemory}, or resize it with {@link
    # #reallocateMemory}.  The address passed to this method may be null, in
    # which case an allocation will be performed.
    # 
    # @throws IllegalArgumentException if the size is negative or too large
    # for the native size_t type
    # 
    # @throws OutOfMemoryError if the allocation is refused by the system
    # 
    # @see #allocateMemory
    def reallocate_memory(address, bytes)
      JNI.__send__(:Java_sun_misc_Unsafe_reallocateMemory, JNI.env, self.jni_id, address.to_int, bytes.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_setMemory, [:pointer, :long, :int64, :int64, :int8], :void
    typesig { [::Java::Long, ::Java::Long, ::Java::Byte] }
    # 
    # Sets all bytes in a given block of memory to a fixed value
    # (usually zero).
    def set_memory(address, bytes, value)
      JNI.__send__(:Java_sun_misc_Unsafe_setMemory, JNI.env, self.jni_id, address.to_int, bytes.to_int, value.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_copyMemory, [:pointer, :long, :int64, :int64, :int64], :void
    typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
    # 
    # Sets all bytes in a given block of memory to a copy of another
    # block.
    def copy_memory(src_address, dest_address, bytes)
      JNI.__send__(:Java_sun_misc_Unsafe_copyMemory, JNI.env, self.jni_id, src_address.to_int, dest_address.to_int, bytes.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_freeMemory, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    # 
    # Disposes of a block of native memory, as obtained from {@link
    # #allocateMemory} or {@link #reallocateMemory}.  The address passed to
    # this method may be null, in which case no action is taken.
    # 
    # @see #allocateMemory
    def free_memory(address)
      JNI.__send__(:Java_sun_misc_Unsafe_freeMemory, JNI.env, self.jni_id, address.to_int)
    end
    
    class_module.module_eval {
      # / random queries
      # 
      # This constant differs from all results that will ever be returned from
      # {@link #staticFieldOffset}, {@link #objectFieldOffset},
      # or {@link #arrayBaseOffset}.
      const_set_lazy(:INVALID_FIELD_OFFSET) { -1 }
      const_attr_reader  :INVALID_FIELD_OFFSET
    }
    
    typesig { [Field] }
    # 
    # Returns the offset of a field, truncated to 32 bits.
    # This method is implemented as follows:
    # <blockquote><pre>
    # public int fieldOffset(Field f) {
    # if (Modifier.isStatic(f.getModifiers()))
    # return (int) staticFieldOffset(f);
    # else
    # return (int) objectFieldOffset(f);
    # }
    # </pre></blockquote>
    # @deprecated As of 1.4.1, use {@link #staticFieldOffset} for static
    # fields and {@link #objectFieldOffset} for non-static fields.
    def field_offset(f)
      if (Modifier.is_static(f.get_modifiers))
        return RJava.cast_to_int(static_field_offset(f))
      else
        return RJava.cast_to_int(object_field_offset(f))
      end
    end
    
    typesig { [Class] }
    # 
    # Returns the base address for accessing some static field
    # in the given class.  This method is implemented as follows:
    # <blockquote><pre>
    # public Object staticFieldBase(Class c) {
    # Field[] fields = c.getDeclaredFields();
    # for (int i = 0; i < fields.length; i++) {
    # if (Modifier.isStatic(fields[i].getModifiers())) {
    # return staticFieldBase(fields[i]);
    # }
    # }
    # return null;
    # }
    # </pre></blockquote>
    # @deprecated As of 1.4.1, use {@link #staticFieldBase(Field)}
    # to obtain the base pertaining to a specific {@link Field}.
    # This method works only for JVMs which store all statics
    # for a given class in one place.
    def static_field_base(c)
      fields = c.get_declared_fields
      i = 0
      while i < fields.attr_length
        if (Modifier.is_static(fields[i].get_modifiers))
          return static_field_base(fields[i])
        end
        ((i += 1) - 1)
      end
      return nil
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_staticFieldOffset, [:pointer, :long, :long], :int64
    typesig { [Field] }
    # 
    # Report the location of a given field in the storage allocation of its
    # class.  Do not expect to perform any sort of arithmetic on this offset;
    # it is just a cookie which is passed to the unsafe heap memory accessors.
    # 
    # <p>Any given field will always have the same offset and base, and no
    # two distinct fields of the same class will ever have the same offset
    # and base.
    # 
    # <p>As of 1.4.1, offsets for fields are represented as long values,
    # although the Sun JVM does not use the most significant 32 bits.
    # However, JVM implementations which store static fields at absolute
    # addresses can use long offsets and null base pointers to express
    # the field locations in a form usable by {@link #getInt(Object,long)}.
    # Therefore, code which will be ported to such JVMs on 64-bit platforms
    # must preserve all bits of static field offsets.
    # @see #getInt(Object, long)
    def static_field_offset(f)
      JNI.__send__(:Java_sun_misc_Unsafe_staticFieldOffset, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_objectFieldOffset, [:pointer, :long, :long], :int64
    typesig { [Field] }
    # 
    # Report the location of a given static field, in conjunction with {@link
    # #staticFieldBase}.
    # <p>Do not expect to perform any sort of arithmetic on this offset;
    # it is just a cookie which is passed to the unsafe heap memory accessors.
    # 
    # <p>Any given field will always have the same offset, and no two distinct
    # fields of the same class will ever have the same offset.
    # 
    # <p>As of 1.4.1, offsets for fields are represented as long values,
    # although the Sun JVM does not use the most significant 32 bits.
    # It is hard to imagine a JVM technology which needs more than
    # a few bits to encode an offset within a non-array object,
    # However, for consistency with other methods in this class,
    # this method reports its result as a long value.
    # @see #getInt(Object, long)
    def object_field_offset(f)
      JNI.__send__(:Java_sun_misc_Unsafe_objectFieldOffset, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_staticFieldBase, [:pointer, :long, :long], :long
    typesig { [Field] }
    # 
    # Report the location of a given static field, in conjunction with {@link
    # #staticFieldOffset}.
    # <p>Fetch the base "Object", if any, with which static fields of the
    # given class can be accessed via methods like {@link #getInt(Object,
    # long)}.  This value may be null.  This value may refer to an object
    # which is a "cookie", not guaranteed to be a real Object, and it should
    # not be used in any way except as argument to the get and put routines in
    # this class.
    def static_field_base(f)
      JNI.__send__(:Java_sun_misc_Unsafe_staticFieldBase, JNI.env, self.jni_id, f.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_ensureClassInitialized, [:pointer, :long, :long], :void
    typesig { [Class] }
    # 
    # Ensure the given class has been initialized. This is often
    # needed in conjunction with obtaining the static field base of a
    # class.
    def ensure_class_initialized(c)
      JNI.__send__(:Java_sun_misc_Unsafe_ensureClassInitialized, JNI.env, self.jni_id, c.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_arrayBaseOffset, [:pointer, :long, :long], :int32
    typesig { [Class] }
    # 
    # Report the offset of the first element in the storage allocation of a
    # given array class.  If {@link #arrayIndexScale} returns a non-zero value
    # for the same class, you may use that scale factor, together with this
    # base offset, to form new offsets to access elements of arrays of the
    # given class.
    # 
    # @see #getInt(Object, long)
    # @see #putInt(Object, long, int)
    def array_base_offset(array_class)
      JNI.__send__(:Java_sun_misc_Unsafe_arrayBaseOffset, JNI.env, self.jni_id, array_class.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_arrayIndexScale, [:pointer, :long, :long], :int32
    typesig { [Class] }
    # 
    # Report the scale factor for addressing elements in the storage
    # allocation of a given array class.  However, arrays of "narrow" types
    # will generally not work properly with accessors like {@link
    # #getByte(Object, int)}, so the scale factor for such classes is reported
    # as zero.
    # 
    # @see #arrayBaseOffset
    # @see #getInt(Object, long)
    # @see #putInt(Object, long, int)
    def array_index_scale(array_class)
      JNI.__send__(:Java_sun_misc_Unsafe_arrayIndexScale, JNI.env, self.jni_id, array_class.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_addressSize, [:pointer, :long], :int32
    typesig { [] }
    # 
    # Report the size in bytes of a native pointer, as stored via {@link
    # #putAddress}.  This value will be either 4 or 8.  Note that the sizes of
    # other primitive types (as stored in native memory blocks) is determined
    # fully by their information content.
    def address_size
      JNI.__send__(:Java_sun_misc_Unsafe_addressSize, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_pageSize, [:pointer, :long], :int32
    typesig { [] }
    # 
    # Report the size in bytes of a native memory page (whatever that is).
    # This value will always be a power of two.
    def page_size
      JNI.__send__(:Java_sun_misc_Unsafe_pageSize, JNI.env, self.jni_id)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_defineClass__L#{String.jni_name}_2_3BIIL#{ClassLoader.jni_name}_2L#{ProtectionDomain.jni_name}_2".to_sym, [:pointer, :long, :long, :long, :int32, :int32, :long, :long], :long
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ClassLoader, ProtectionDomain] }
    # / random trusted operations from JNI:
    # 
    # Tell the VM to define a class, without security checks.  By default, the
    # class loader and protection domain come from the caller's class.
    def define_class(name, b, off, len, loader, protection_domain)
      JNI.__send__("Java_sun_misc_Unsafe_defineClass__L#{String.jni_name}_2_3BIIL#{ClassLoader.jni_name}_2L#{ProtectionDomain.jni_name}_2".to_sym, JNI.env, self.jni_id, name.jni_id, b.jni_id, off.to_int, len.to_int, loader.jni_id, protection_domain.jni_id)
    end
    
    JNI.native_method "Java_sun_misc_Unsafe_defineClass__L#{String.jni_name}_2_3BII".to_sym, [:pointer, :long, :long, :long, :int32, :int32], :long
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def define_class(name, b, off, len)
      JNI.__send__("Java_sun_misc_Unsafe_defineClass__L#{String.jni_name}_2_3BII".to_sym, JNI.env, self.jni_id, name.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_allocateInstance, [:pointer, :long, :long], :long
    typesig { [Class] }
    # Allocate an instance but do not run any constructor.
    # Initializes the class if it has not yet been.
    def allocate_instance(cls)
      JNI.__send__(:Java_sun_misc_Unsafe_allocateInstance, JNI.env, self.jni_id, cls.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_monitorEnter, [:pointer, :long, :long], :void
    typesig { [Object] }
    # Lock the object.  It must get unlocked via {@link #monitorExit}.
    def monitor_enter(o)
      JNI.__send__(:Java_sun_misc_Unsafe_monitorEnter, JNI.env, self.jni_id, o.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_monitorExit, [:pointer, :long, :long], :void
    typesig { [Object] }
    # 
    # Unlock the object.  It must have been locked via {@link
    # #monitorEnter}.
    def monitor_exit(o)
      JNI.__send__(:Java_sun_misc_Unsafe_monitorExit, JNI.env, self.jni_id, o.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_tryMonitorEnter, [:pointer, :long, :long], :int8
    typesig { [Object] }
    # 
    # Tries to lock the object.  Returns true or false to indicate
    # whether the lock succeeded.  If it did, the object must be
    # unlocked via {@link #monitorExit}.
    def try_monitor_enter(o)
      JNI.__send__(:Java_sun_misc_Unsafe_tryMonitorEnter, JNI.env, self.jni_id, o.jni_id) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_throwException, [:pointer, :long, :long], :void
    typesig { [Exception] }
    # Throw the exception without telling the verifier.
    def throw_exception(ee)
      JNI.__send__(:Java_sun_misc_Unsafe_throwException, JNI.env, self.jni_id, ee.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_compareAndSwapObject, [:pointer, :long, :long, :int64, :long, :long], :int8
    typesig { [Object, ::Java::Long, Object, Object] }
    # 
    # Atomically update Java variable to <tt>x</tt> if it is currently
    # holding <tt>expected</tt>.
    # @return <tt>true</tt> if successful
    def compare_and_swap_object(o, offset, expected, x)
      JNI.__send__(:Java_sun_misc_Unsafe_compareAndSwapObject, JNI.env, self.jni_id, o.jni_id, offset.to_int, expected.jni_id, x.jni_id) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_compareAndSwapInt, [:pointer, :long, :long, :int64, :int32, :int32], :int8
    typesig { [Object, ::Java::Long, ::Java::Int, ::Java::Int] }
    # 
    # Atomically update Java variable to <tt>x</tt> if it is currently
    # holding <tt>expected</tt>.
    # @return <tt>true</tt> if successful
    def compare_and_swap_int(o, offset, expected, x)
      JNI.__send__(:Java_sun_misc_Unsafe_compareAndSwapInt, JNI.env, self.jni_id, o.jni_id, offset.to_int, expected.to_int, x.to_int) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_compareAndSwapLong, [:pointer, :long, :long, :int64, :int64, :int64], :int8
    typesig { [Object, ::Java::Long, ::Java::Long, ::Java::Long] }
    # 
    # Atomically update Java variable to <tt>x</tt> if it is currently
    # holding <tt>expected</tt>.
    # @return <tt>true</tt> if successful
    def compare_and_swap_long(o, offset, expected, x)
      JNI.__send__(:Java_sun_misc_Unsafe_compareAndSwapLong, JNI.env, self.jni_id, o.jni_id, offset.to_int, expected.to_int, x.to_int) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getObjectVolatile, [:pointer, :long, :long, :int64], :long
    typesig { [Object, ::Java::Long] }
    # 
    # Fetches a reference value from a given Java variable, with volatile
    # load semantics. Otherwise identical to {@link #getObject(Object, long)}
    def get_object_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getObjectVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putObjectVolatile, [:pointer, :long, :long, :int64, :long], :void
    typesig { [Object, ::Java::Long, Object] }
    # 
    # Stores a reference value into a given Java variable, with
    # volatile store semantics. Otherwise identical to {@link #putObject(Object, long, Object)}
    def put_object_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putObjectVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getIntVolatile, [:pointer, :long, :long, :int64], :int32
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getInt(Object, long)}
    def get_int_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getIntVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putIntVolatile, [:pointer, :long, :long, :int64, :int32], :void
    typesig { [Object, ::Java::Long, ::Java::Int] }
    # Volatile version of {@link #putInt(Object, long, int)}
    def put_int_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putIntVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getBooleanVolatile, [:pointer, :long, :long, :int64], :int8
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getBoolean(Object, long)}
    def get_boolean_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getBooleanVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int) != 0
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putBooleanVolatile, [:pointer, :long, :long, :int64, :int8], :void
    typesig { [Object, ::Java::Long, ::Java::Boolean] }
    # Volatile version of {@link #putBoolean(Object, long, boolean)}
    def put_boolean_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putBooleanVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x ? 1 : 0)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getByteVolatile, [:pointer, :long, :long, :int64], :int8
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getByte(Object, long)}
    def get_byte_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getByteVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putByteVolatile, [:pointer, :long, :long, :int64, :int8], :void
    typesig { [Object, ::Java::Long, ::Java::Byte] }
    # Volatile version of {@link #putByte(Object, long, byte)}
    def put_byte_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putByteVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getShortVolatile, [:pointer, :long, :long, :int64], :int16
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getShort(Object, long)}
    def get_short_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getShortVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putShortVolatile, [:pointer, :long, :long, :int64, :int16], :void
    typesig { [Object, ::Java::Long, ::Java::Short] }
    # Volatile version of {@link #putShort(Object, long, short)}
    def put_short_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putShortVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getCharVolatile, [:pointer, :long, :long, :int64], :unknown
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getChar(Object, long)}
    def get_char_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getCharVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putCharVolatile, [:pointer, :long, :long, :int64, :unknown], :void
    typesig { [Object, ::Java::Long, ::Java::Char] }
    # Volatile version of {@link #putChar(Object, long, char)}
    def put_char_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putCharVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getLongVolatile, [:pointer, :long, :long, :int64], :int64
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getLong(Object, long)}
    def get_long_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getLongVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putLongVolatile, [:pointer, :long, :long, :int64, :int64], :void
    typesig { [Object, ::Java::Long, ::Java::Long] }
    # Volatile version of {@link #putLong(Object, long, long)}
    def put_long_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putLongVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getFloatVolatile, [:pointer, :long, :long, :int64], :float
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getFloat(Object, long)}
    def get_float_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getFloatVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putFloatVolatile, [:pointer, :long, :long, :int64, :float], :void
    typesig { [Object, ::Java::Long, ::Java::Float] }
    # Volatile version of {@link #putFloat(Object, long, float)}
    def put_float_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putFloatVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getDoubleVolatile, [:pointer, :long, :long, :int64], :double
    typesig { [Object, ::Java::Long] }
    # Volatile version of {@link #getDouble(Object, long)}
    def get_double_volatile(o, offset)
      JNI.__send__(:Java_sun_misc_Unsafe_getDoubleVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putDoubleVolatile, [:pointer, :long, :long, :int64, :double], :void
    typesig { [Object, ::Java::Long, ::Java::Double] }
    # Volatile version of {@link #putDouble(Object, long, double)}
    def put_double_volatile(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putDoubleVolatile, JNI.env, self.jni_id, o.jni_id, offset.to_int, x)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putOrderedObject, [:pointer, :long, :long, :int64, :long], :void
    typesig { [Object, ::Java::Long, Object] }
    # 
    # Version of {@link #putObjectVolatile(Object, long, Object)}
    # that does not guarantee immediate visibility of the store to
    # other threads. This method is generally only useful if the
    # underlying field is a Java volatile (or if an array cell, one
    # that is otherwise only accessed using volatile accesses).
    def put_ordered_object(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putOrderedObject, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putOrderedInt, [:pointer, :long, :long, :int64, :int32], :void
    typesig { [Object, ::Java::Long, ::Java::Int] }
    # Ordered/Lazy version of {@link #putIntVolatile(Object, long, int)}
    def put_ordered_int(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putOrderedInt, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_putOrderedLong, [:pointer, :long, :long, :int64, :int64], :void
    typesig { [Object, ::Java::Long, ::Java::Long] }
    # Ordered/Lazy version of {@link #putLongVolatile(Object, long, long)}
    def put_ordered_long(o, offset, x)
      JNI.__send__(:Java_sun_misc_Unsafe_putOrderedLong, JNI.env, self.jni_id, o.jni_id, offset.to_int, x.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_unpark, [:pointer, :long, :long], :void
    typesig { [Object] }
    # 
    # Unblock the given thread blocked on <tt>park</tt>, or, if it is
    # not blocked, cause the subsequent call to <tt>park</tt> not to
    # block.  Note: this operation is "unsafe" solely because the
    # caller must somehow ensure that the thread has not been
    # destroyed. Nothing special is usually required to ensure this
    # when called from Java (in which there will ordinarily be a live
    # reference to the thread) but this is not nearly-automatically
    # so when calling from native code.
    # @param thread the thread to unpark.
    def unpark(thread)
      JNI.__send__(:Java_sun_misc_Unsafe_unpark, JNI.env, self.jni_id, thread.jni_id)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_park, [:pointer, :long, :int8, :int64], :void
    typesig { [::Java::Boolean, ::Java::Long] }
    # 
    # Block current thread, returning when a balancing
    # <tt>unpark</tt> occurs, or a balancing <tt>unpark</tt> has
    # already occurred, or the thread is interrupted, or, if not
    # absolute and time is not zero, the given time nanoseconds have
    # elapsed, or if absolute, the given deadline in milliseconds
    # since Epoch has passed, or spuriously (i.e., returning for no
    # "reason"). Note: This operation is in the Unsafe class only
    # because <tt>unpark</tt> is, so it would be strange to place it
    # elsewhere.
    def park(is_absolute, time)
      JNI.__send__(:Java_sun_misc_Unsafe_park, JNI.env, self.jni_id, is_absolute ? 1 : 0, time.to_int)
    end
    
    JNI.native_method :Java_sun_misc_Unsafe_getLoadAverage, [:pointer, :long, :long, :int32], :int32
    typesig { [Array.typed(::Java::Double), ::Java::Int] }
    # 
    # Gets the load average in the system run queue assigned
    # to the available processors averaged over various periods of time.
    # This method retrieves the given <tt>nelem</tt> samples and
    # assigns to the elements of the given <tt>loadavg</tt> array.
    # The system imposes a maximum of 3 samples, representing
    # averages over the last 1,  5,  and  15 minutes, respectively.
    # 
    # @params loadavg an array of double of size nelems
    # @params nelems the number of samples to be retrieved and
    # must be 1 to 3.
    # 
    # @return the number of samples actually retrieved; or -1
    # if the load average is unobtainable.
    def get_load_average(loadavg, nelems)
      JNI.__send__(:Java_sun_misc_Unsafe_getLoadAverage, JNI.env, self.jni_id, loadavg.jni_id, nelems.to_int)
    end
    
    private
    alias_method :initialize__unsafe, :initialize
  end
  
end

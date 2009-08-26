require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module NativeObjectImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Nio, :ByteOrder
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Formerly in sun.misc
  # ## In the fullness of time, this class will be eliminated
  # 
  # Proxies for objects that reside in native memory.
  class NativeObject 
    include_class_members NativeObjectImports
    
    class_module.module_eval {
      # package-private
      const_set_lazy(:Unsafe) { Unsafe.get_unsafe }
      const_attr_reader  :Unsafe
    }
    
    # Native allocation address;
    # may be smaller than the base address due to page-size rounding
    attr_accessor :allocation_address
    alias_method :attr_allocation_address, :allocation_address
    undef_method :allocation_address
    alias_method :attr_allocation_address=, :allocation_address=
    undef_method :allocation_address=
    
    # Native base address
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    typesig { [::Java::Long] }
    # Creates a new native object that is based at the given native address.
    def initialize(address)
      @allocation_address = 0
      @address = 0
      @allocation_address = address
      @address = address
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Creates a new native object allocated at the given native address but
    # whose base is at the additional offset.
    def initialize(address, offset)
      @allocation_address = 0
      @address = 0
      @allocation_address = address
      @address = address + offset
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Invoked only by AllocatedNativeObject
    def initialize(size, page_aligned)
      @allocation_address = 0
      @address = 0
      if (!page_aligned)
        @allocation_address = Unsafe.allocate_memory(size)
        @address = @allocation_address
      else
        ps = page_size
        a = Unsafe.allocate_memory(size + ps)
        @allocation_address = a
        @address = a + ps - (a & (ps - 1))
      end
    end
    
    typesig { [] }
    # Returns the native base address of this native object.
    # 
    # @return The native base address
    def address
      return @address
    end
    
    typesig { [] }
    def allocation_address
      return @allocation_address
    end
    
    typesig { [::Java::Int] }
    # Creates a new native object starting at the given offset from the base
    # of this native object.
    # 
    # @param  offset
    # The offset from the base of this native object that is to be
    # the base of the new native object
    # 
    # @return The newly created native object
    def sub_object(offset)
      return NativeObject.new(offset + @address)
    end
    
    typesig { [::Java::Int] }
    # Reads an address from this native object at the given offset and
    # constructs a native object using that address.
    # 
    # @param  offset
    # The offset of the address to be read.  Note that the size of an
    # address is implementation-dependent.
    # 
    # @return The native object created using the address read from the
    # given offset
    def get_object(offset)
      new_address = 0
      case (address_size)
      when 8
        new_address = Unsafe.get_long(offset + @address)
      when 4
        new_address = Unsafe.get_int(offset + @address) & -0x1
      else
        raise InternalError.new("Address size not supported")
      end
      return NativeObject.new(new_address)
    end
    
    typesig { [::Java::Int, NativeObject] }
    # Writes the base address of the given native object at the given offset
    # of this native object.
    # 
    # @param  offset
    # The offset at which the address is to be written.  Note that the
    # size of an address is implementation-dependent.
    # 
    # @param  ob
    # The native object whose address is to be written
    def put_object(offset, ob)
      case (address_size)
      when 8
        put_long(offset, ob.attr_address)
      when 4
        put_int(offset, RJava.cast_to_int((ob.attr_address & -0x1)))
      else
        raise InternalError.new("Address size not supported")
      end
    end
    
    typesig { [::Java::Int] }
    # -- Value accessors: No range checking! --
    # 
    # Reads a byte starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the byte
    # 
    # @return The byte value read
    def get_byte(offset)
      return Unsafe.get_byte(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    # Writes a byte at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the byte
    # 
    # @param  value
    # The byte value to be written
    def put_byte(offset, value)
      Unsafe.put_byte(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads a short starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the short
    # 
    # @return The short value read
    def get_short(offset)
      return Unsafe.get_short(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Short] }
    # Writes a short at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the short
    # 
    # @param  value
    # The short value to be written
    def put_short(offset, value)
      Unsafe.put_short(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads a char starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the char
    # 
    # @return The char value read
    def get_char(offset)
      return Unsafe.get_char(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # Writes a char at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the char
    # 
    # @param  value
    # The char value to be written
    def put_char(offset, value)
      Unsafe.put_char(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads an int starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the int
    # 
    # @return The int value read
    def get_int(offset)
      return Unsafe.get_int(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Writes an int at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the int
    # 
    # @param  value
    # The int value to be written
    def put_int(offset, value)
      Unsafe.put_int(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads a long starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the long
    # 
    # @return The long value read
    def get_long(offset)
      return Unsafe.get_long(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Writes a long at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the long
    # 
    # @param  value
    # The long value to be written
    def put_long(offset, value)
      Unsafe.put_long(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads a float starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the float
    # 
    # @return The float value read
    def get_float(offset)
      return Unsafe.get_float(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Writes a float at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the float
    # 
    # @param  value
    # The float value to be written
    def put_float(offset, value)
      Unsafe.put_float(offset + @address, value)
    end
    
    typesig { [::Java::Int] }
    # Reads a double starting at the given offset from base of this native
    # object.
    # 
    # @param  offset
    # The offset at which to read the double
    # 
    # @return The double value read
    def get_double(offset)
      return Unsafe.get_double(offset + @address)
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    # Writes a double at the specified offset from this native object's
    # base address.
    # 
    # @param  offset
    # The offset at which to write the double
    # 
    # @param  value
    # The double value to be written
    def put_double(offset, value)
      Unsafe.put_double(offset + @address, value)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the native architecture's address size in bytes.
      # 
      # @return The address size of the native architecture
      def address_size
        return Unsafe.address_size
      end
      
      # Cache for byte order
      
      def byte_order
        defined?(@@byte_order) ? @@byte_order : @@byte_order= nil
      end
      alias_method :attr_byte_order, :byte_order
      
      def byte_order=(value)
        @@byte_order = value
      end
      alias_method :attr_byte_order=, :byte_order=
      
      typesig { [] }
      # Returns the byte order of the underlying hardware.
      # 
      # @return  An instance of {@link java.nio.ByteOrder}
      def byte_order
        if (!(self.attr_byte_order).nil?)
          return self.attr_byte_order
        end
        a = Unsafe.allocate_memory(8)
        begin
          Unsafe.put_long(a, 0x102030405060708)
          b = Unsafe.get_byte(a)
          case (b)
          when 0x1
            self.attr_byte_order = ByteOrder::BIG_ENDIAN
          when 0x8
            self.attr_byte_order = ByteOrder::LITTLE_ENDIAN
          else
            raise AssertError if not (false)
          end
        ensure
          Unsafe.free_memory(a)
        end
        return self.attr_byte_order
      end
      
      # Cache for page size
      
      def page_size
        defined?(@@page_size) ? @@page_size : @@page_size= -1
      end
      alias_method :attr_page_size, :page_size
      
      def page_size=(value)
        @@page_size = value
      end
      alias_method :attr_page_size=, :page_size=
      
      typesig { [] }
      # Returns the page size of the underlying hardware.
      # 
      # @return  The page size, in bytes
      def page_size
        if ((self.attr_page_size).equal?(-1))
          self.attr_page_size = Unsafe.page_size
        end
        return self.attr_page_size
      end
    }
    
    private
    alias_method :initialize__native_object, :initialize
  end
  
end

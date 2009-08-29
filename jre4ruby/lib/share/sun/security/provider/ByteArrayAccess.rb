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
module Sun::Security::Provider
  module ByteArrayAccessImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Lang::JavaInteger, :ReverseBytes
      include_const ::Java::Lang::Long, :ReverseBytes
      include_const ::Java::Nio, :ByteOrder
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Optimized methods for converting between byte[] and int[]/long[], both for
  # big endian and little endian byte orders.
  # 
  # Currently, it includes a default code path plus two optimized code paths.
  # One is for little endian architectures that support full speed int/long
  # access at unaligned addresses (i.e. x86/amd64). The second is for big endian
  # architectures (that only support correctly aligned access), such as SPARC.
  # These are the only platforms we currently support, but other optimized
  # variants could be added as needed.
  # 
  # NOTE that because this code performs unchecked direct memory access, it
  # MUST be restricted to trusted code. It is imperative that the caller protects
  # against out of bounds memory access by performing the necessary bounds
  # checks before calling methods in this class.
  # 
  # This class may also be helpful in improving the performance of the
  # crypto code in the SunJCE provider. However, for now it is only accessible by
  # the message digest implementation in the SUN provider.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ByteArrayAccess 
    include_class_members ByteArrayAccessImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      const_set_lazy(:ByteArrayOfs) { UnsafeInstance.array_base_offset(Array) }
      const_attr_reader  :ByteArrayOfs
      
      when_class_loaded do
        scale_ok = (((UnsafeInstance.array_index_scale(Array)).equal?(1)) && ((UnsafeInstance.array_index_scale(Array)).equal?(4)) && ((UnsafeInstance.array_index_scale(Array)).equal?(8)) && (((ByteArrayOfs & 3)).equal?(0)))
        byte_order = ByteOrder.native_order
        const_set :LittleEndianUnaligned, scale_ok && unaligned && ((byte_order).equal?(ByteOrder::LITTLE_ENDIAN))
        const_set :BigEndian, scale_ok && ((byte_order).equal?(ByteOrder::BIG_ENDIAN))
      end
      
      typesig { [] }
      # Return whether this platform supports full speed int/long memory access
      # at unaligned addresses.
      # This code was copied from java.nio.Bits because there is no equivalent
      # public API.
      def unaligned
        arch = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("os.arch", ""))
        return (arch == "i386") || (arch == "x86") || (arch == "amd64")
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # byte[] to int[] conversion, little endian byte order.
      def b2i_little(in_, in_ofs, out, out_ofs, len)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          len += in_ofs
          while (in_ofs < len)
            out[((out_ofs += 1) - 1)] = UnsafeInstance.get_int(in_, in_ofs)
            in_ofs += 4
          end
        else
          if (BigEndian && (((in_ofs & 3)).equal?(0)))
            in_ofs += ByteArrayOfs
            len += in_ofs
            while (in_ofs < len)
              out[((out_ofs += 1) - 1)] = reverse_bytes(UnsafeInstance.get_int(in_, in_ofs))
              in_ofs += 4
            end
          else
            len += in_ofs
            while (in_ofs < len)
              out[((out_ofs += 1) - 1)] = ((in_[in_ofs] & 0xff)) | ((in_[in_ofs + 1] & 0xff) << 8) | ((in_[in_ofs + 2] & 0xff) << 16) | ((in_[in_ofs + 3]) << 24)
              in_ofs += 4
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Int)] }
      # Special optimization of b2iLittle(in, inOfs, out, 0, 64)
      def b2i_little64(in_, in_ofs, out)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          out[0] = UnsafeInstance.get_int(in_, (in_ofs))
          out[1] = UnsafeInstance.get_int(in_, (in_ofs + 4))
          out[2] = UnsafeInstance.get_int(in_, (in_ofs + 8))
          out[3] = UnsafeInstance.get_int(in_, (in_ofs + 12))
          out[4] = UnsafeInstance.get_int(in_, (in_ofs + 16))
          out[5] = UnsafeInstance.get_int(in_, (in_ofs + 20))
          out[6] = UnsafeInstance.get_int(in_, (in_ofs + 24))
          out[7] = UnsafeInstance.get_int(in_, (in_ofs + 28))
          out[8] = UnsafeInstance.get_int(in_, (in_ofs + 32))
          out[9] = UnsafeInstance.get_int(in_, (in_ofs + 36))
          out[10] = UnsafeInstance.get_int(in_, (in_ofs + 40))
          out[11] = UnsafeInstance.get_int(in_, (in_ofs + 44))
          out[12] = UnsafeInstance.get_int(in_, (in_ofs + 48))
          out[13] = UnsafeInstance.get_int(in_, (in_ofs + 52))
          out[14] = UnsafeInstance.get_int(in_, (in_ofs + 56))
          out[15] = UnsafeInstance.get_int(in_, (in_ofs + 60))
        else
          if (BigEndian && (((in_ofs & 3)).equal?(0)))
            in_ofs += ByteArrayOfs
            out[0] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs)))
            out[1] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 4)))
            out[2] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 8)))
            out[3] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 12)))
            out[4] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 16)))
            out[5] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 20)))
            out[6] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 24)))
            out[7] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 28)))
            out[8] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 32)))
            out[9] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 36)))
            out[10] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 40)))
            out[11] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 44)))
            out[12] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 48)))
            out[13] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 52)))
            out[14] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 56)))
            out[15] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 60)))
          else
            b2i_little(in_, in_ofs, out, 0, 64)
          end
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # int[] to byte[] conversion, little endian byte order.
      def i2b_little(in_, in_ofs, out, out_ofs, len)
        if (LittleEndianUnaligned)
          out_ofs += ByteArrayOfs
          len += out_ofs
          while (out_ofs < len)
            UnsafeInstance.put_int(out, out_ofs, in_[((in_ofs += 1) - 1)])
            out_ofs += 4
          end
        else
          if (BigEndian && (((out_ofs & 3)).equal?(0)))
            out_ofs += ByteArrayOfs
            len += out_ofs
            while (out_ofs < len)
              UnsafeInstance.put_int(out, out_ofs, reverse_bytes(in_[((in_ofs += 1) - 1)]))
              out_ofs += 4
            end
          else
            len += out_ofs
            while (out_ofs < len)
              i = in_[((in_ofs += 1) - 1)]
              out[((out_ofs += 1) - 1)] = (i)
              out[((out_ofs += 1) - 1)] = (i >> 8)
              out[((out_ofs += 1) - 1)] = (i >> 16)
              out[((out_ofs += 1) - 1)] = (i >> 24)
            end
          end
        end
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Store one 32-bit value into out[outOfs..outOfs+3] in little endian order.
      def i2b_little4(val, out, out_ofs)
        if (LittleEndianUnaligned)
          UnsafeInstance.put_int(out, (ByteArrayOfs + out_ofs), val)
        else
          if (BigEndian && (((out_ofs & 3)).equal?(0)))
            UnsafeInstance.put_int(out, (ByteArrayOfs + out_ofs), reverse_bytes(val))
          else
            out[out_ofs] = (val)
            out[out_ofs + 1] = (val >> 8)
            out[out_ofs + 2] = (val >> 16)
            out[out_ofs + 3] = (val >> 24)
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # byte[] to int[] conversion, big endian byte order.
      def b2i_big(in_, in_ofs, out, out_ofs, len)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          len += in_ofs
          while (in_ofs < len)
            out[((out_ofs += 1) - 1)] = reverse_bytes(UnsafeInstance.get_int(in_, in_ofs))
            in_ofs += 4
          end
        else
          if (BigEndian && (((in_ofs & 3)).equal?(0)))
            in_ofs += ByteArrayOfs
            len += in_ofs
            while (in_ofs < len)
              out[((out_ofs += 1) - 1)] = UnsafeInstance.get_int(in_, in_ofs)
              in_ofs += 4
            end
          else
            len += in_ofs
            while (in_ofs < len)
              out[((out_ofs += 1) - 1)] = ((in_[in_ofs + 3] & 0xff)) | ((in_[in_ofs + 2] & 0xff) << 8) | ((in_[in_ofs + 1] & 0xff) << 16) | ((in_[in_ofs]) << 24)
              in_ofs += 4
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Int)] }
      # Special optimization of b2iBig(in, inOfs, out, 0, 64)
      def b2i_big64(in_, in_ofs, out)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          out[0] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs)))
          out[1] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 4)))
          out[2] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 8)))
          out[3] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 12)))
          out[4] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 16)))
          out[5] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 20)))
          out[6] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 24)))
          out[7] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 28)))
          out[8] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 32)))
          out[9] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 36)))
          out[10] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 40)))
          out[11] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 44)))
          out[12] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 48)))
          out[13] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 52)))
          out[14] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 56)))
          out[15] = reverse_bytes(UnsafeInstance.get_int(in_, (in_ofs + 60)))
        else
          if (BigEndian && (((in_ofs & 3)).equal?(0)))
            in_ofs += ByteArrayOfs
            out[0] = UnsafeInstance.get_int(in_, (in_ofs))
            out[1] = UnsafeInstance.get_int(in_, (in_ofs + 4))
            out[2] = UnsafeInstance.get_int(in_, (in_ofs + 8))
            out[3] = UnsafeInstance.get_int(in_, (in_ofs + 12))
            out[4] = UnsafeInstance.get_int(in_, (in_ofs + 16))
            out[5] = UnsafeInstance.get_int(in_, (in_ofs + 20))
            out[6] = UnsafeInstance.get_int(in_, (in_ofs + 24))
            out[7] = UnsafeInstance.get_int(in_, (in_ofs + 28))
            out[8] = UnsafeInstance.get_int(in_, (in_ofs + 32))
            out[9] = UnsafeInstance.get_int(in_, (in_ofs + 36))
            out[10] = UnsafeInstance.get_int(in_, (in_ofs + 40))
            out[11] = UnsafeInstance.get_int(in_, (in_ofs + 44))
            out[12] = UnsafeInstance.get_int(in_, (in_ofs + 48))
            out[13] = UnsafeInstance.get_int(in_, (in_ofs + 52))
            out[14] = UnsafeInstance.get_int(in_, (in_ofs + 56))
            out[15] = UnsafeInstance.get_int(in_, (in_ofs + 60))
          else
            b2i_big(in_, in_ofs, out, 0, 64)
          end
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # int[] to byte[] conversion, big endian byte order.
      def i2b_big(in_, in_ofs, out, out_ofs, len)
        if (LittleEndianUnaligned)
          out_ofs += ByteArrayOfs
          len += out_ofs
          while (out_ofs < len)
            UnsafeInstance.put_int(out, out_ofs, reverse_bytes(in_[((in_ofs += 1) - 1)]))
            out_ofs += 4
          end
        else
          if (BigEndian && (((out_ofs & 3)).equal?(0)))
            out_ofs += ByteArrayOfs
            len += out_ofs
            while (out_ofs < len)
              UnsafeInstance.put_int(out, out_ofs, in_[((in_ofs += 1) - 1)])
              out_ofs += 4
            end
          else
            len += out_ofs
            while (out_ofs < len)
              i = in_[((in_ofs += 1) - 1)]
              out[((out_ofs += 1) - 1)] = (i >> 24)
              out[((out_ofs += 1) - 1)] = (i >> 16)
              out[((out_ofs += 1) - 1)] = (i >> 8)
              out[((out_ofs += 1) - 1)] = (i)
            end
          end
        end
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Store one 32-bit value into out[outOfs..outOfs+3] in big endian order.
      def i2b_big4(val, out, out_ofs)
        if (LittleEndianUnaligned)
          UnsafeInstance.put_int(out, (ByteArrayOfs + out_ofs), reverse_bytes(val))
        else
          if (BigEndian && (((out_ofs & 3)).equal?(0)))
            UnsafeInstance.put_int(out, (ByteArrayOfs + out_ofs), val)
          else
            out[out_ofs] = (val >> 24)
            out[out_ofs + 1] = (val >> 16)
            out[out_ofs + 2] = (val >> 8)
            out[out_ofs + 3] = (val)
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
      # byte[] to long[] conversion, big endian byte order.
      def b2l_big(in_, in_ofs, out, out_ofs, len)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          len += in_ofs
          while (in_ofs < len)
            out[((out_ofs += 1) - 1)] = reverse_bytes(UnsafeInstance.get_long(in_, in_ofs))
            in_ofs += 8
          end
        else
          if (BigEndian && (((in_ofs & 3)).equal?(0)))
            # In the current HotSpot memory layout, the first element of a
            # byte[] is only 32-bit aligned, not 64-bit.
            # That means we could use getLong() only for offset 4, 12, etc.,
            # which would rarely occur in practice. Instead, we use an
            # optimization that uses getInt() so that it works for offset 0.
            in_ofs += ByteArrayOfs
            len += in_ofs
            while (in_ofs < len)
              out[((out_ofs += 1) - 1)] = (UnsafeInstance.get_int(in_, in_ofs) << 32) | (UnsafeInstance.get_int(in_, (in_ofs + 4)) & 0xffffffff)
              in_ofs += 8
            end
          else
            len += in_ofs
            while (in_ofs < len)
              i1 = ((in_[in_ofs + 3] & 0xff)) | ((in_[in_ofs + 2] & 0xff) << 8) | ((in_[in_ofs + 1] & 0xff) << 16) | ((in_[in_ofs]) << 24)
              in_ofs += 4
              i2 = ((in_[in_ofs + 3] & 0xff)) | ((in_[in_ofs + 2] & 0xff) << 8) | ((in_[in_ofs + 1] & 0xff) << 16) | ((in_[in_ofs]) << 24)
              out[((out_ofs += 1) - 1)] = (i1 << 32) | (i2 & 0xffffffff)
              in_ofs += 4
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Long)] }
      # Special optimization of b2lBig(in, inOfs, out, 0, 128)
      def b2l_big128(in_, in_ofs, out)
        if (LittleEndianUnaligned)
          in_ofs += ByteArrayOfs
          out[0] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs)))
          out[1] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 8)))
          out[2] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 16)))
          out[3] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 24)))
          out[4] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 32)))
          out[5] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 40)))
          out[6] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 48)))
          out[7] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 56)))
          out[8] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 64)))
          out[9] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 72)))
          out[10] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 80)))
          out[11] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 88)))
          out[12] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 96)))
          out[13] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 104)))
          out[14] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 112)))
          out[15] = reverse_bytes(UnsafeInstance.get_long(in_, (in_ofs + 120)))
        else
          # no optimization for big endian, see comments in b2lBig
          b2l_big(in_, in_ofs, out, 0, 128)
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # long[] to byte[] conversion, big endian byte order.
      def l2b_big(in_, in_ofs, out, out_ofs, len)
        len += out_ofs
        while (out_ofs < len)
          i = in_[((in_ofs += 1) - 1)]
          out[((out_ofs += 1) - 1)] = (i >> 56)
          out[((out_ofs += 1) - 1)] = (i >> 48)
          out[((out_ofs += 1) - 1)] = (i >> 40)
          out[((out_ofs += 1) - 1)] = (i >> 32)
          out[((out_ofs += 1) - 1)] = (i >> 24)
          out[((out_ofs += 1) - 1)] = (i >> 16)
          out[((out_ofs += 1) - 1)] = (i >> 8)
          out[((out_ofs += 1) - 1)] = (i)
        end
      end
    }
    
    private
    alias_method :initialize__byte_array_access, :initialize
  end
  
end

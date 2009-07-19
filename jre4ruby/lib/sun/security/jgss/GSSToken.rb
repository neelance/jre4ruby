require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss
  module GSSTokenImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include ::Sun::Security::Util
    }
  end
  
  # Utilities for processing GSS Tokens.
  class GSSToken 
    include_class_members GSSTokenImports
    
    class_module.module_eval {
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # Copies an integer value to a byte array in little endian form.
      # @param value the integer value to write
      # @param array the byte array into which the integer must be copied. It
      # is assumed that the array will be large enough to hold the 4 bytes of
      # the integer.
      def write_little_endian(value, array)
        write_little_endian(value, array, 0)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Copies an integer value to a byte array in little endian form.
      # @param value the integer value to write
      # @param array the byte array into which the integer must be copied. It
      # is assumed that the array will be large enough to hold the 4 bytes of
      # the integer.
      # @param pos the position at which to start writing
      def write_little_endian(value, array, pos)
        array[((pos += 1) - 1)] = (value)
        array[((pos += 1) - 1)] = ((value >> 8))
        array[((pos += 1) - 1)] = ((value >> 16))
        array[((pos += 1) - 1)] = ((value >> 24))
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      def write_big_endian(value, array)
        write_big_endian(value, array, 0)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      def write_big_endian(value, array, pos)
        array[((pos += 1) - 1)] = ((value >> 24))
        array[((pos += 1) - 1)] = ((value >> 16))
        array[((pos += 1) - 1)] = ((value >> 8))
        array[((pos += 1) - 1)] = (value)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Reads an integer value from a byte array in little endian form. This
      # method allows the reading of two byte values as well as four bytes
      # values both of which are needed in the Kerberos v5 GSS-API mechanism.
      # 
      # @param data the array containing the bytes of the integer value
      # @param pos the offset in the array
      # @size the number of bytes to read from the array.
      # @return the integer value
      def read_little_endian(data, pos, size)
        ret_val = 0
        shifter = 0
        while (size > 0)
          ret_val += (data[pos] & 0xff) << shifter
          shifter += 8
          ((pos += 1) - 1)
          ((size -= 1) + 1)
        end
        return ret_val
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def read_big_endian(data, pos, size)
        ret_val = 0
        shifter = (size - 1) * 8
        while (size > 0)
          ret_val += (data[pos] & 0xff) << shifter
          shifter -= 8
          ((pos += 1) - 1)
          ((size -= 1) + 1)
        end
        return ret_val
      end
      
      typesig { [::Java::Int, OutputStream] }
      # Writes a two byte integer value to a OutputStream.
      # 
      # @param val the integer value. It will lose the high-order two bytes.
      # @param os the OutputStream to write to
      # @throws IOException if an error occurs while writing to the OutputStream
      def write_int(val, os)
        os.write(val >> 8)
        os.write(val)
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
      # Writes a two byte integer value to a byte array.
      # 
      # @param val the integer value. It will lose the high-order two bytes.
      # @param dest the byte array to write to
      # @param pos the offset to start writing to
      def write_int(val, dest, pos)
        dest[((pos += 1) - 1)] = (val >> 8)
        dest[((pos += 1) - 1)] = val
        return pos
      end
      
      typesig { [InputStream] }
      # Reads a two byte integer value from an InputStream.
      # 
      # @param is the InputStream to read from
      # @returns the integer value
      # @throws IOException if some errors occurs while reading the integer
      # bytes.
      def read_int(is)
        return (((0xff & is.read) << 8) | (0xff & is.read))
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Reads a two byte integer value from a byte array.
      # 
      # @param src the byte arra to read from
      # @param pos the offset to start reading from
      # @returns the integer value
      def read_int(src, pos)
        return ((0xff & src[pos]) << 8 | (0xff & src[pos + 1]))
      end
      
      typesig { [InputStream, Array.typed(::Java::Byte)] }
      # Blocks till the required number of bytes have been read from the
      # input stream.
      # 
      # @param is the InputStream to read from
      # @param buffer the buffer to store the bytes into
      # @param throws EOFException if EOF is reached before all bytes are
      # read.
      # @throws IOException is an error occurs while reading
      def read_fully(is, buffer)
        read_fully(is, buffer, 0, buffer.attr_length)
      end
      
      typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Blocks till the required number of bytes have been read from the
      # input stream.
      # 
      # @param is the InputStream to read from
      # @param buffer the buffer to store the bytes into
      # @param offset the offset to start storing at
      # @param len the number of bytes to read
      # @param throws EOFException if EOF is reached before all bytes are
      # read.
      # @throws IOException is an error occurs while reading
      def read_fully(is, buffer, offset, len)
        temp = 0
        while (len > 0)
          temp = is.read(buffer, offset, len)
          if ((temp).equal?(-1))
            raise EOFException.new("Cannot read all " + (len).to_s + " bytes needed to form this token!")
          end
          offset += temp
          len -= temp
        end
      end
      
      typesig { [String] }
      def debug(str)
        System.err.print(str)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def get_hex_bytes(bytes)
        return get_hex_bytes(bytes, 0, bytes.attr_length)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_hex_bytes(bytes, len)
        return get_hex_bytes(bytes, 0, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def get_hex_bytes(bytes, pos, len)
        sb = StringBuffer.new
        i = pos
        while i < (pos + len)
          b1 = (bytes[i] >> 4) & 0xf
          b2 = bytes[i] & 0xf
          sb.append(JavaInteger.to_hex_string(b1))
          sb.append(JavaInteger.to_hex_string(b2))
          sb.append(Character.new(?\s.ord))
          ((i += 1) - 1)
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__gsstoken, :initialize
  end
  
end

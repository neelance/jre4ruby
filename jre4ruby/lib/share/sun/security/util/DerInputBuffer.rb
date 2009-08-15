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
module Sun::Security::Util
  module DerInputBufferImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Date
      include_const ::Sun::Util::Calendar, :CalendarDate
      include_const ::Sun::Util::Calendar, :CalendarSystem
    }
  end
  
  # DER input buffer ... this is the main abstraction in the DER library
  # which actively works with the "untyped byte stream" abstraction.  It
  # does so with impunity, since it's not intended to be exposed to
  # anyone who could violate the "typed value stream" DER model and hence
  # corrupt the input stream of DER values.
  # 
  # @author David Brownell
  class DerInputBuffer < DerInputBufferImports.const_get :ByteArrayInputStream
    include_class_members DerInputBufferImports
    overload_protected {
      include Cloneable
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(buf)
      super(buf)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def initialize(buf, offset, len)
      super(buf, offset, len)
    end
    
    typesig { [] }
    def dup
      begin
        retval = clone
        retval.mark(JavaInteger::MAX_VALUE)
        return retval
      rescue CloneNotSupportedException => e
        raise IllegalArgumentException.new(e.to_s)
      end
    end
    
    typesig { [] }
    def to_byte_array
      len = available
      if (len <= 0)
        return nil
      end
      retval = Array.typed(::Java::Byte).new(len) { 0 }
      System.arraycopy(self.attr_buf, self.attr_pos, retval, 0, len)
      return retval
    end
    
    typesig { [] }
    def peek
      if (self.attr_pos >= self.attr_count)
        raise IOException.new("out of data")
      else
        return self.attr_buf[self.attr_pos]
      end
    end
    
    typesig { [Object] }
    # Compares this DerInputBuffer for equality with the specified
    # object.
    def ==(other)
      if (other.is_a?(DerInputBuffer))
        return self.==(other)
      else
        return false
      end
    end
    
    typesig { [DerInputBuffer] }
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      max = self.available
      if (!(other.available).equal?(max))
        return false
      end
      i = 0
      while i < max
        if (!(self.attr_buf[self.attr_pos + i]).equal?(other.attr_buf[other.attr_pos + i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns a hashcode for this DerInputBuffer.
    # 
    # @return a hashcode for this DerInputBuffer.
    def hash_code
      retval = 0
      len = available
      p = self.attr_pos
      i = 0
      while i < len
        retval += self.attr_buf[p + i] * i
        i += 1
      end
      return retval
    end
    
    typesig { [::Java::Int] }
    def truncate(len)
      if (len > available)
        raise IOException.new("insufficient data")
      end
      self.attr_count = self.attr_pos + len
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Returns the integer which takes up the specified number
    # of bytes in this buffer as a BigInteger.
    # @param len the number of bytes to use.
    # @param makePositive whether to always return a positive value,
    # irrespective of actual encoding
    # @return the integer as a BigInteger.
    def get_big_integer(len, make_positive)
      if (len > available)
        raise IOException.new("short read of integer")
      end
      if ((len).equal?(0))
        raise IOException.new("Invalid encoding: zero length Int value")
      end
      bytes = Array.typed(::Java::Byte).new(len) { 0 }
      System.arraycopy(self.attr_buf, self.attr_pos, bytes, 0, len)
      skip(len)
      if (make_positive)
        return BigInteger.new(1, bytes)
      else
        return BigInteger.new(bytes)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the integer which takes up the specified number
    # of bytes in this buffer.
    # @throws IOException if the result is not within the valid
    # range for integer, i.e. between Integer.MIN_VALUE and
    # Integer.MAX_VALUE.
    # @param len the number of bytes to use.
    # @return the integer.
    def get_integer(len)
      result = get_big_integer(len, false)
      if ((result <=> BigInteger.value_of(JavaInteger::MIN_VALUE)) < 0)
        raise IOException.new("Integer below minimum valid value")
      end
      if ((result <=> BigInteger.value_of(JavaInteger::MAX_VALUE)) > 0)
        raise IOException.new("Integer exceeds maximum valid value")
      end
      return result.int_value
    end
    
    typesig { [::Java::Int] }
    # Returns the bit string which takes up the specified
    # number of bytes in this buffer.
    def get_bit_string(len)
      if (len > available)
        raise IOException.new("short read of bit string")
      end
      if ((len).equal?(0))
        raise IOException.new("Invalid encoding: zero length bit string")
      end
      num_of_pad_bits = self.attr_buf[self.attr_pos]
      if ((num_of_pad_bits < 0) || (num_of_pad_bits > 7))
        raise IOException.new("Invalid number of padding bits")
      end
      # minus the first byte which indicates the number of padding bits
      retval = Array.typed(::Java::Byte).new(len - 1) { 0 }
      System.arraycopy(self.attr_buf, self.attr_pos + 1, retval, 0, len - 1)
      if (!(num_of_pad_bits).equal?(0))
        # get rid of the padding bits
        retval[len - 2] &= (0xff << num_of_pad_bits)
      end
      skip(len)
      return retval
    end
    
    typesig { [] }
    # Returns the bit string which takes up the rest of this buffer.
    def get_bit_string
      return get_bit_string(available)
    end
    
    typesig { [] }
    # Returns the bit string which takes up the rest of this buffer.
    # The bit string need not be byte-aligned.
    def get_unaligned_bit_string
      if (self.attr_pos >= self.attr_count)
        return nil
      end
      # Just copy the data into an aligned, padded octet buffer,
      # and consume the rest of the buffer.
      len = available
      unused_bits = self.attr_buf[self.attr_pos] & 0xff
      if (unused_bits > 7)
        raise IOException.new("Invalid value for unused bits: " + RJava.cast_to_string(unused_bits))
      end
      bits = Array.typed(::Java::Byte).new(len - 1) { 0 }
      # number of valid bits
      length = ((bits.attr_length).equal?(0)) ? 0 : bits.attr_length * 8 - unused_bits
      System.arraycopy(self.attr_buf, self.attr_pos + 1, bits, 0, len - 1)
      bit_array = BitArray.new(length, bits)
      self.attr_pos = self.attr_count
      return bit_array
    end
    
    typesig { [::Java::Int] }
    # Returns the UTC Time value that takes up the specified number
    # of bytes in this buffer.
    # @param len the number of bytes to use
    def get_utctime(len)
      if (len > available)
        raise IOException.new("short read of DER UTC Time")
      end
      if (len < 11 || len > 17)
        raise IOException.new("DER UTC Time length error")
      end
      return get_time(len, false)
    end
    
    typesig { [::Java::Int] }
    # Returns the Generalized Time value that takes up the specified
    # number of bytes in this buffer.
    # @param len the number of bytes to use
    def get_generalized_time(len)
      if (len > available)
        raise IOException.new("short read of DER Generalized Time")
      end
      if (len < 13 || len > 23)
        raise IOException.new("DER Generalized Time length error")
      end
      return get_time(len, true)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Private helper routine to extract time from the der value.
    # @param len the number of bytes to use
    # @param generalized true if Generalized Time is to be read, false
    # if UTC Time is to be read.
    def get_time(len, generalized)
      # UTC time encoded as ASCII chars:
      # YYMMDDhhmmZ
      # YYMMDDhhmmssZ
      # YYMMDDhhmm+hhmm
      # YYMMDDhhmm-hhmm
      # YYMMDDhhmmss+hhmm
      # YYMMDDhhmmss-hhmm
      # UTC Time is broken in storing only two digits of year.
      # If YY < 50, we assume 20YY;
      # if YY >= 50, we assume 19YY, as per RFC 3280.
      # 
      # Generalized time has a four-digit year and allows any
      # precision specified in ISO 8601. However, for our purposes,
      # we will only allow the same format as UTC time, except that
      # fractional seconds (millisecond precision) are supported.
      year = 0
      month = 0
      day = 0
      hour = 0
      minute = 0
      second = 0
      millis = 0
      type = nil
      if (generalized)
        type = "Generalized"
        year = 1000 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        year += 100 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        year += 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        year += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        len -= 2 # For the two extra YY
      else
        type = "UTC"
        year = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        year += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        if (year < 50)
          # origin 2000
          year += 2000
        else
          year += 1900
        end # origin 1900
      end
      month = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      month += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      day = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      day += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      hour = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      hour += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      minute = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      minute += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
      len -= 10 # YYMMDDhhmm
      # We allow for non-encoded seconds, even though the
      # IETF-PKIX specification says that the seconds should
      # always be encoded even if it is zero.
      millis = 0
      if (len > 2 && len < 12)
        second = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        second += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        len -= 2
        # handle fractional seconds (if present)
        if ((self.attr_buf[self.attr_pos]).equal?(Character.new(?..ord)) || (self.attr_buf[self.attr_pos]).equal?(Character.new(?,.ord)))
          len -= 1
          self.attr_pos += 1
          # handle upto milisecond precision only
          precision = 0
          peek = self.attr_pos
          while (!(self.attr_buf[peek]).equal?(Character.new(?Z.ord)) && !(self.attr_buf[peek]).equal?(Character.new(?+.ord)) && !(self.attr_buf[peek]).equal?(Character.new(?-.ord)))
            peek += 1
            precision += 1
          end
          case (precision)
          when 3
            millis += 100 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
            millis += 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
            millis += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
          when 2
            millis += 100 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
            millis += 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
          when 1
            millis += 100 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
          else
            raise IOException.new("Parse " + type + " time, unsupported precision for seconds value")
          end
          len -= precision
        end
      else
        second = 0
      end
      if ((month).equal?(0) || (day).equal?(0) || month > 12 || day > 31 || hour >= 24 || minute >= 60 || second >= 60)
        raise IOException.new("Parse " + type + " time, invalid format")
      end
      # Generalized time can theoretically allow any precision,
      # but we're not supporting that.
      gcal = CalendarSystem.get_gregorian_calendar
      date = gcal.new_calendar_date(nil) # no time zone
      date.set_date(year, month, day)
      date.set_time_of_day(hour, minute, second, millis)
      time = gcal.get_time(date)
      # Finally, "Z" or "+hhmm" or "-hhmm" ... offsets change hhmm
      if (!((len).equal?(1) || (len).equal?(5)))
        raise IOException.new("Parse " + type + " time, invalid offset")
      end
      hr = 0
      min = 0
      case (self.attr_buf[((self.attr_pos += 1) - 1)])
      when Character.new(?+.ord)
        hr = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        hr += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        min = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        min += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        if (hr >= 24 || min >= 60)
          raise IOException.new("Parse " + type + " time, +hhmm")
        end
        time -= ((hr * 60) + min) * 60 * 1000
      when Character.new(?-.ord)
        hr = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        hr += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        min = 10 * Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        min += Character.digit(RJava.cast_to_char(self.attr_buf[((self.attr_pos += 1) - 1)]), 10)
        if (hr >= 24 || min >= 60)
          raise IOException.new("Parse " + type + " time, -hhmm")
        end
        time += ((hr * 60) + min) * 60 * 1000
      when Character.new(?Z.ord)
      else
        raise IOException.new("Parse " + type + " time, garbage offset")
      end
      return Date.new(time)
    end
    
    private
    alias_method :initialize__der_input_buffer, :initialize
  end
  
end

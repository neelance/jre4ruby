require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DerIndefLenConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # A package private utility class to convert indefinite length DER
  # encoded byte arrays to definite length DER encoded byte arrays.
  # 
  # This assumes that the basic data structure is "tag, length, value"
  # triplet. In the case where the length is "indefinite", terminating
  # end-of-contents bytes are expected.
  # 
  # @author Hemma Prafullchandra
  class DerIndefLenConverter 
    include_class_members DerIndefLenConverterImports
    
    class_module.module_eval {
      const_set_lazy(:TAG_MASK) { 0x1f }
      const_attr_reader  :TAG_MASK
      
      # bits 5-1
      const_set_lazy(:FORM_MASK) { 0x20 }
      const_attr_reader  :FORM_MASK
      
      # bits 6
      const_set_lazy(:CLASS_MASK) { 0xc0 }
      const_attr_reader  :CLASS_MASK
      
      # bits 8 and 7
      const_set_lazy(:LEN_LONG) { 0x80 }
      const_attr_reader  :LEN_LONG
      
      # bit 8 set
      const_set_lazy(:LEN_MASK) { 0x7f }
      const_attr_reader  :LEN_MASK
      
      # bits 7 - 1
      const_set_lazy(:SKIP_EOC_BYTES) { 2 }
      const_attr_reader  :SKIP_EOC_BYTES
    }
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    attr_accessor :new_data
    alias_method :attr_new_data, :new_data
    undef_method :new_data
    alias_method :attr_new_data=, :new_data=
    undef_method :new_data=
    
    attr_accessor :new_data_pos
    alias_method :attr_new_data_pos, :new_data_pos
    undef_method :new_data_pos
    alias_method :attr_new_data_pos=, :new_data_pos=
    undef_method :new_data_pos=
    
    attr_accessor :data_pos
    alias_method :attr_data_pos, :data_pos
    undef_method :data_pos
    alias_method :attr_data_pos=, :data_pos=
    undef_method :data_pos=
    
    attr_accessor :data_size
    alias_method :attr_data_size, :data_size
    undef_method :data_size
    alias_method :attr_data_size=, :data_size=
    undef_method :data_size=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :ndefs_list
    alias_method :attr_ndefs_list, :ndefs_list
    undef_method :ndefs_list
    alias_method :attr_ndefs_list=, :ndefs_list=
    undef_method :ndefs_list=
    
    attr_accessor :num_of_total_len_bytes
    alias_method :attr_num_of_total_len_bytes, :num_of_total_len_bytes
    undef_method :num_of_total_len_bytes
    alias_method :attr_num_of_total_len_bytes=, :num_of_total_len_bytes=
    undef_method :num_of_total_len_bytes=
    
    typesig { [::Java::Int] }
    def is_eoc(tag)
      # EOC
      # primitive
      return ((((tag & TAG_MASK)).equal?(0x0)) && (((tag & FORM_MASK)).equal?(0x0)) && (((tag & CLASS_MASK)).equal?(0x0))) # universal
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # if bit 8 is set then it implies either indefinite length or long form
      def is_long_form(length_byte)
        return (((length_byte & LEN_LONG)).equal?(LEN_LONG))
      end
    }
    
    typesig { [] }
    # Default package private constructor
    def initialize
      @data = nil
      @new_data = nil
      @new_data_pos = 0
      @data_pos = 0
      @data_size = 0
      @index = 0
      @ndefs_list = ArrayList.new
      @num_of_total_len_bytes = 0
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Checks whether the given length byte is of the form
      # <em>Indefinite</em>.
      # 
      # @param lengthByte the length byte from a DER encoded
      # object.
      # @return true if the byte is of Indefinite form otherwise
      # returns false.
      def is_indefinite(length_byte)
        return (is_long_form(length_byte) && (((length_byte & LEN_MASK)).equal?(0)))
      end
    }
    
    typesig { [] }
    # Parse the tag and if it is an end-of-contents tag then
    # add the current position to the <code>eocList</code> vector.
    def parse_tag
      if ((@data_pos).equal?(@data_size))
        return
      end
      if (is_eoc(@data[@data_pos]) && ((@data[@data_pos + 1]).equal?(0)))
        num_of_encapsulated_len_bytes = 0
        elem = nil
        index = 0
        index = @ndefs_list.size - 1
        while index >= 0
          # Determine the first element in the vector that does not
          # have a matching EOC
          elem = @ndefs_list.get(index)
          if (elem.is_a?(JavaInteger))
            break
          else
            num_of_encapsulated_len_bytes += (elem).attr_length - 3
          end
          index -= 1
        end
        if (index < 0)
          raise IOException.new("EOC does not have matching " + "indefinite-length tag")
        end
        section_len = @data_pos - (elem).int_value + num_of_encapsulated_len_bytes
        section_len_bytes = get_length_bytes(section_len)
        @ndefs_list.set(index, section_len_bytes)
        # Add the number of bytes required to represent this section
        # to the total number of length bytes,
        # and subtract the indefinite-length tag (1 byte) and
        # EOC bytes (2 bytes) for this section
        @num_of_total_len_bytes += (section_len_bytes.attr_length - 3)
      end
      @data_pos += 1
    end
    
    typesig { [] }
    # Write the tag and if it is an end-of-contents tag
    # then skip the tag and its 1 byte length of zero.
    def write_tag
      if ((@data_pos).equal?(@data_size))
        return
      end
      tag = @data[((@data_pos += 1) - 1)]
      if (is_eoc(tag) && ((@data[@data_pos]).equal?(0)))
        @data_pos += 1 # skip length
        write_tag
      else
        @new_data[((@new_data_pos += 1) - 1)] = tag
      end
    end
    
    typesig { [] }
    # Parse the length and if it is an indefinite length then add
    # the current position to the <code>ndefsList</code> vector.
    def parse_length
      cur_len = 0
      if ((@data_pos).equal?(@data_size))
        return cur_len
      end
      len_byte = @data[((@data_pos += 1) - 1)] & 0xff
      if (is_indefinite(len_byte))
        @ndefs_list.add(@data_pos)
        return cur_len
      end
      if (is_long_form(len_byte))
        len_byte &= LEN_MASK
        if (len_byte > 4)
          raise IOException.new("Too much data")
        end
        if ((@data_size - @data_pos) < (len_byte + 1))
          raise IOException.new("Too little data")
        end
        i = 0
        while i < len_byte
          cur_len = (cur_len << 8) + (@data[((@data_pos += 1) - 1)] & 0xff)
          i += 1
        end
      else
        cur_len = (len_byte & LEN_MASK)
      end
      return cur_len
    end
    
    typesig { [] }
    # Write the length and if it is an indefinite length
    # then calculate the definite length from the positions
    # of the indefinite length and its matching EOC terminator.
    # Then, write the value.
    def write_length_and_value
      if ((@data_pos).equal?(@data_size))
        return
      end
      cur_len = 0
      len_byte = @data[((@data_pos += 1) - 1)] & 0xff
      if (is_indefinite(len_byte))
        len_bytes = @ndefs_list.get(((@index += 1) - 1))
        System.arraycopy(len_bytes, 0, @new_data, @new_data_pos, len_bytes.attr_length)
        @new_data_pos += len_bytes.attr_length
        return
      end
      if (is_long_form(len_byte))
        len_byte &= LEN_MASK
        i = 0
        while i < len_byte
          cur_len = (cur_len << 8) + (@data[((@data_pos += 1) - 1)] & 0xff)
          i += 1
        end
      else
        cur_len = (len_byte & LEN_MASK)
      end
      write_length(cur_len)
      write_value(cur_len)
    end
    
    typesig { [::Java::Int] }
    def write_length(cur_len)
      if (cur_len < 128)
        @new_data[((@new_data_pos += 1) - 1)] = cur_len
      else
        if (cur_len < (1 << 8))
          @new_data[((@new_data_pos += 1) - 1)] = 0x81
          @new_data[((@new_data_pos += 1) - 1)] = cur_len
        else
          if (cur_len < (1 << 16))
            @new_data[((@new_data_pos += 1) - 1)] = 0x82
            @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 8)
            @new_data[((@new_data_pos += 1) - 1)] = cur_len
          else
            if (cur_len < (1 << 24))
              @new_data[((@new_data_pos += 1) - 1)] = 0x83
              @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 16)
              @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 8)
              @new_data[((@new_data_pos += 1) - 1)] = cur_len
            else
              @new_data[((@new_data_pos += 1) - 1)] = 0x84
              @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 24)
              @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 16)
              @new_data[((@new_data_pos += 1) - 1)] = (cur_len >> 8)
              @new_data[((@new_data_pos += 1) - 1)] = cur_len
            end
          end
        end
      end
    end
    
    typesig { [::Java::Int] }
    def get_length_bytes(cur_len)
      len_bytes = nil
      index = 0
      if (cur_len < 128)
        len_bytes = Array.typed(::Java::Byte).new(1) { 0 }
        len_bytes[((index += 1) - 1)] = cur_len
      else
        if (cur_len < (1 << 8))
          len_bytes = Array.typed(::Java::Byte).new(2) { 0 }
          len_bytes[((index += 1) - 1)] = 0x81
          len_bytes[((index += 1) - 1)] = cur_len
        else
          if (cur_len < (1 << 16))
            len_bytes = Array.typed(::Java::Byte).new(3) { 0 }
            len_bytes[((index += 1) - 1)] = 0x82
            len_bytes[((index += 1) - 1)] = (cur_len >> 8)
            len_bytes[((index += 1) - 1)] = cur_len
          else
            if (cur_len < (1 << 24))
              len_bytes = Array.typed(::Java::Byte).new(4) { 0 }
              len_bytes[((index += 1) - 1)] = 0x83
              len_bytes[((index += 1) - 1)] = (cur_len >> 16)
              len_bytes[((index += 1) - 1)] = (cur_len >> 8)
              len_bytes[((index += 1) - 1)] = cur_len
            else
              len_bytes = Array.typed(::Java::Byte).new(5) { 0 }
              len_bytes[((index += 1) - 1)] = 0x84
              len_bytes[((index += 1) - 1)] = (cur_len >> 24)
              len_bytes[((index += 1) - 1)] = (cur_len >> 16)
              len_bytes[((index += 1) - 1)] = (cur_len >> 8)
              len_bytes[((index += 1) - 1)] = cur_len
            end
          end
        end
      end
      return len_bytes
    end
    
    typesig { [::Java::Int] }
    # Returns the number of bytes needed to represent the given length
    # in ASN.1 notation
    def get_num_of_len_bytes(len)
      num_of_len_bytes = 0
      if (len < 128)
        num_of_len_bytes = 1
      else
        if (len < (1 << 8))
          num_of_len_bytes = 2
        else
          if (len < (1 << 16))
            num_of_len_bytes = 3
          else
            if (len < (1 << 24))
              num_of_len_bytes = 4
            else
              num_of_len_bytes = 5
            end
          end
        end
      end
      return num_of_len_bytes
    end
    
    typesig { [::Java::Int] }
    # Parse the value;
    def parse_value(cur_len)
      @data_pos += cur_len
    end
    
    typesig { [::Java::Int] }
    # Write the value;
    def write_value(cur_len)
      i = 0
      while i < cur_len
        @new_data[((@new_data_pos += 1) - 1)] = @data[((@data_pos += 1) - 1)]
        i += 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Converts a indefinite length DER encoded byte array to
    # a definte length DER encoding.
    # 
    # @param indefData the byte array holding the indefinite
    # length encoding.
    # @return the byte array containing the definite length
    # DER encoding.
    # @exception IOException on parsing or re-writing errors.
    def convert(indef_data)
      @data = indef_data
      @data_pos = 0
      @index = 0
      @data_size = @data.attr_length
      len = 0
      # parse and set up the vectors of all the indefinite-lengths
      while (@data_pos < @data_size)
        parse_tag
        len = parse_length
        parse_value(len)
      end
      @new_data = Array.typed(::Java::Byte).new(@data_size + @num_of_total_len_bytes) { 0 }
      @data_pos = 0
      @new_data_pos = 0
      @index = 0
      # write out the new byte array replacing all the indefinite-lengths
      # and EOCs
      while (@data_pos < @data_size)
        write_tag
        write_length_and_value
      end
      return @new_data
    end
    
    private
    alias_method :initialize__der_indef_len_converter, :initialize
  end
  
end

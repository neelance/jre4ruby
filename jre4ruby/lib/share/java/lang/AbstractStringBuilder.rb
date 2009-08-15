require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module AbstractStringBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Sun::Misc, :FloatingDecimal
      include_const ::Java::Util, :Arrays
    }
  end
  
  # A mutable sequence of characters.
  # <p>
  # Implements a modifiable string. At any point in time it contains some
  # particular sequence of characters, but the length and content of the
  # sequence can be changed through certain method calls.
  # 
  # @author      Michael McCloskey
  # @since       1.5
  class AbstractStringBuilder 
    include_class_members AbstractStringBuilderImports
    include Appendable
    include CharSequence
    
    # The value is used for character storage.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # The count is the number of characters used.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [] }
    # This no-arg constructor is necessary for serialization of subclasses.
    def initialize
      @value = nil
      @count = 0
    end
    
    typesig { [::Java::Int] }
    # Creates an AbstractStringBuilder of the specified capacity.
    def initialize(capacity)
      @value = nil
      @count = 0
      @value = CharArray.new(capacity)
    end
    
    typesig { [] }
    # Returns the length (character count).
    # 
    # @return  the length of the sequence of characters currently
    # represented by this object
    def length
      return @count
    end
    
    typesig { [] }
    # Returns the current capacity. The capacity is the amount of storage
    # available for newly inserted characters, beyond which an allocation
    # will occur.
    # 
    # @return  the current capacity
    def capacity
      return @value.attr_length
    end
    
    typesig { [::Java::Int] }
    # Ensures that the capacity is at least equal to the specified minimum.
    # If the current capacity is less than the argument, then a new internal
    # array is allocated with greater capacity. The new capacity is the
    # larger of:
    # <ul>
    # <li>The <code>minimumCapacity</code> argument.
    # <li>Twice the old capacity, plus <code>2</code>.
    # </ul>
    # If the <code>minimumCapacity</code> argument is nonpositive, this
    # method takes no action and simply returns.
    # 
    # @param   minimumCapacity   the minimum desired capacity.
    def ensure_capacity(minimum_capacity)
      if (minimum_capacity > @value.attr_length)
        expand_capacity(minimum_capacity)
      end
    end
    
    typesig { [::Java::Int] }
    # This implements the expansion semantics of ensureCapacity with no
    # size check or synchronization.
    def expand_capacity(minimum_capacity)
      new_capacity = (@value.attr_length + 1) * 2
      if (new_capacity < 0)
        new_capacity = JavaInteger::MAX_VALUE
      else
        if (minimum_capacity > new_capacity)
          new_capacity = minimum_capacity
        end
      end
      @value = Arrays.copy_of(@value, new_capacity)
    end
    
    typesig { [] }
    # Attempts to reduce storage used for the character sequence.
    # If the buffer is larger than necessary to hold its current sequence of
    # characters, then it may be resized to become more space efficient.
    # Calling this method may, but is not required to, affect the value
    # returned by a subsequent call to the {@link #capacity()} method.
    def trim_to_size
      if (@count < @value.attr_length)
        @value = Arrays.copy_of(@value, @count)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the length of the character sequence.
    # The sequence is changed to a new character sequence
    # whose length is specified by the argument. For every nonnegative
    # index <i>k</i> less than <code>newLength</code>, the character at
    # index <i>k</i> in the new character sequence is the same as the
    # character at index <i>k</i> in the old sequence if <i>k</i> is less
    # than the length of the old character sequence; otherwise, it is the
    # null character <code>'&#92;u0000'</code>.
    # 
    # In other words, if the <code>newLength</code> argument is less than
    # the current length, the length is changed to the specified length.
    # <p>
    # If the <code>newLength</code> argument is greater than or equal
    # to the current length, sufficient null characters
    # (<code>'&#92;u0000'</code>) are appended so that
    # length becomes the <code>newLength</code> argument.
    # <p>
    # The <code>newLength</code> argument must be greater than or equal
    # to <code>0</code>.
    # 
    # @param      newLength   the new length
    # @throws     IndexOutOfBoundsException  if the
    # <code>newLength</code> argument is negative.
    def set_length(new_length)
      if (new_length < 0)
        raise StringIndexOutOfBoundsException.new(new_length)
      end
      if (new_length > @value.attr_length)
        expand_capacity(new_length)
      end
      if (@count < new_length)
        while @count < new_length
          @value[@count] = Character.new(?\0.ord)
          @count += 1
        end
      else
        @count = new_length
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the <code>char</code> value in this sequence at the specified index.
    # The first <code>char</code> value is at index <code>0</code>, the next at index
    # <code>1</code>, and so on, as in array indexing.
    # <p>
    # The index argument must be greater than or equal to
    # <code>0</code>, and less than the length of this sequence.
    # 
    # <p>If the <code>char</code> value specified by the index is a
    # <a href="Character.html#unicode">surrogate</a>, the surrogate
    # value is returned.
    # 
    # @param      index   the index of the desired <code>char</code> value.
    # @return     the <code>char</code> value at the specified index.
    # @throws     IndexOutOfBoundsException  if <code>index</code> is
    # negative or greater than or equal to <code>length()</code>.
    def char_at(index)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return @value[index]
    end
    
    typesig { [::Java::Int] }
    # Returns the character (Unicode code point) at the specified
    # index. The index refers to <code>char</code> values
    # (Unicode code units) and ranges from <code>0</code> to
    # {@link #length()}<code> - 1</code>.
    # 
    # <p> If the <code>char</code> value specified at the given index
    # is in the high-surrogate range, the following index is less
    # than the length of this sequence, and the
    # <code>char</code> value at the following index is in the
    # low-surrogate range, then the supplementary code point
    # corresponding to this surrogate pair is returned. Otherwise,
    # the <code>char</code> value at the given index is returned.
    # 
    # @param      index the index to the <code>char</code> values
    # @return     the code point value of the character at the
    # <code>index</code>
    # @exception  IndexOutOfBoundsException  if the <code>index</code>
    # argument is negative or not less than the length of this
    # sequence.
    def code_point_at(index)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return Character.code_point_at(@value, index)
    end
    
    typesig { [::Java::Int] }
    # Returns the character (Unicode code point) before the specified
    # index. The index refers to <code>char</code> values
    # (Unicode code units) and ranges from <code>1</code> to {@link
    # #length()}.
    # 
    # <p> If the <code>char</code> value at <code>(index - 1)</code>
    # is in the low-surrogate range, <code>(index - 2)</code> is not
    # negative, and the <code>char</code> value at <code>(index -
    # 2)</code> is in the high-surrogate range, then the
    # supplementary code point value of the surrogate pair is
    # returned. If the <code>char</code> value at <code>index -
    # 1</code> is an unpaired low-surrogate or a high-surrogate, the
    # surrogate value is returned.
    # 
    # @param     index the index following the code point that should be returned
    # @return    the Unicode code point value before the given index.
    # @exception IndexOutOfBoundsException if the <code>index</code>
    # argument is less than 1 or greater than the length
    # of this sequence.
    def code_point_before(index)
      i = index - 1
      if ((i < 0) || (i >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return Character.code_point_before(@value, index)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the number of Unicode code points in the specified text
    # range of this sequence. The text range begins at the specified
    # <code>beginIndex</code> and extends to the <code>char</code> at
    # index <code>endIndex - 1</code>. Thus the length (in
    # <code>char</code>s) of the text range is
    # <code>endIndex-beginIndex</code>. Unpaired surrogates within
    # this sequence count as one code point each.
    # 
    # @param beginIndex the index to the first <code>char</code> of
    # the text range.
    # @param endIndex the index after the last <code>char</code> of
    # the text range.
    # @return the number of Unicode code points in the specified text
    # range
    # @exception IndexOutOfBoundsException if the
    # <code>beginIndex</code> is negative, or <code>endIndex</code>
    # is larger than the length of this sequence, or
    # <code>beginIndex</code> is larger than <code>endIndex</code>.
    def code_point_count(begin_index, end_index)
      if (begin_index < 0 || end_index > @count || begin_index > end_index)
        raise IndexOutOfBoundsException.new
      end
      return Character.code_point_count_impl(@value, begin_index, end_index - begin_index)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the index within this sequence that is offset from the
    # given <code>index</code> by <code>codePointOffset</code> code
    # points. Unpaired surrogates within the text range given by
    # <code>index</code> and <code>codePointOffset</code> count as
    # one code point each.
    # 
    # @param index the index to be offset
    # @param codePointOffset the offset in code points
    # @return the index within this sequence
    # @exception IndexOutOfBoundsException if <code>index</code>
    # is negative or larger then the length of this sequence,
    # or if <code>codePointOffset</code> is positive and the subsequence
    # starting with <code>index</code> has fewer than
    # <code>codePointOffset</code> code points,
    # or if <code>codePointOffset</code> is negative and the subsequence
    # before <code>index</code> has fewer than the absolute value of
    # <code>codePointOffset</code> code points.
    def offset_by_code_points(index, code_point_offset)
      if (index < 0 || index > @count)
        raise IndexOutOfBoundsException.new
      end
      return Character.offset_by_code_points_impl(@value, 0, @count, index, code_point_offset)
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
    # Characters are copied from this sequence into the
    # destination character array <code>dst</code>. The first character to
    # be copied is at index <code>srcBegin</code>; the last character to
    # be copied is at index <code>srcEnd-1</code>. The total number of
    # characters to be copied is <code>srcEnd-srcBegin</code>. The
    # characters are copied into the subarray of <code>dst</code> starting
    # at index <code>dstBegin</code> and ending at index:
    # <p><blockquote><pre>
    # dstbegin + (srcEnd-srcBegin) - 1
    # </pre></blockquote>
    # 
    # @param      srcBegin   start copying at this offset.
    # @param      srcEnd     stop copying at this offset.
    # @param      dst        the array to copy the data into.
    # @param      dstBegin   offset into <code>dst</code>.
    # @throws     NullPointerException if <code>dst</code> is
    # <code>null</code>.
    # @throws     IndexOutOfBoundsException  if any of the following is true:
    # <ul>
    # <li><code>srcBegin</code> is negative
    # <li><code>dstBegin</code> is negative
    # <li>the <code>srcBegin</code> argument is greater than
    # the <code>srcEnd</code> argument.
    # <li><code>srcEnd</code> is greater than
    # <code>this.length()</code>.
    # <li><code>dstBegin+srcEnd-srcBegin</code> is greater than
    # <code>dst.length</code>
    # </ul>
    def get_chars(src_begin, src_end, dst, dst_begin)
      if (src_begin < 0)
        raise StringIndexOutOfBoundsException.new(src_begin)
      end
      if ((src_end < 0) || (src_end > @count))
        raise StringIndexOutOfBoundsException.new(src_end)
      end
      if (src_begin > src_end)
        raise StringIndexOutOfBoundsException.new("srcBegin > srcEnd")
      end
      System.arraycopy(@value, src_begin, dst, dst_begin, src_end - src_begin)
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # The character at the specified index is set to <code>ch</code>. This
    # sequence is altered to represent a new character sequence that is
    # identical to the old character sequence, except that it contains the
    # character <code>ch</code> at position <code>index</code>.
    # <p>
    # The index argument must be greater than or equal to
    # <code>0</code>, and less than the length of this sequence.
    # 
    # @param      index   the index of the character to modify.
    # @param      ch      the new character.
    # @throws     IndexOutOfBoundsException  if <code>index</code> is
    # negative or greater than or equal to <code>length()</code>.
    def set_char_at(index, ch)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      @value[index] = ch
    end
    
    typesig { [Object] }
    # Appends the string representation of the <code>Object</code>
    # argument.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this sequence.
    # 
    # @param   obj   an <code>Object</code>.
    # @return  a reference to this object.
    def append(obj)
      return append(String.value_of(obj))
    end
    
    typesig { [String] }
    # Appends the specified string to this character sequence.
    # <p>
    # The characters of the <code>String</code> argument are appended, in
    # order, increasing the length of this sequence by the length of the
    # argument. If <code>str</code> is <code>null</code>, then the four
    # characters <code>"null"</code> are appended.
    # <p>
    # Let <i>n</i> be the length of this character sequence just prior to
    # execution of the <code>append</code> method. Then the character at
    # index <i>k</i> in the new character sequence is equal to the character
    # at index <i>k</i> in the old character sequence, if <i>k</i> is less
    # than <i>n</i>; otherwise, it is equal to the character at index
    # <i>k-n</i> in the argument <code>str</code>.
    # 
    # @param   str   a string.
    # @return  a reference to this object.
    def append(str)
      if ((str).nil?)
        str = "null"
      end
      len = str.length
      if ((len).equal?(0))
        return self
      end
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      str.get_chars(0, len, @value, @count)
      @count = new_count
      return self
    end
    
    typesig { [StringBuffer] }
    # Documentation in subclasses because of synchro difference
    def append(sb)
      if ((sb).nil?)
        return append("null")
      end
      len = sb.length
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      sb.get_chars(0, len, @value, @count)
      @count = new_count
      return self
    end
    
    typesig { [CharSequence] }
    # Documentation in subclasses because of synchro difference
    def append(s)
      if ((s).nil?)
        s = "null"
      end
      if (s.is_a?(String))
        return self.append(s)
      end
      if (s.is_a?(StringBuffer))
        return self.append(s)
      end
      return self.append(s, 0, s.length)
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # Appends a subsequence of the specified <code>CharSequence</code> to this
    # sequence.
    # <p>
    # Characters of the argument <code>s</code>, starting at
    # index <code>start</code>, are appended, in order, to the contents of
    # this sequence up to the (exclusive) index <code>end</code>. The length
    # of this sequence is increased by the value of <code>end - start</code>.
    # <p>
    # Let <i>n</i> be the length of this character sequence just prior to
    # execution of the <code>append</code> method. Then the character at
    # index <i>k</i> in this character sequence becomes equal to the
    # character at index <i>k</i> in this sequence, if <i>k</i> is less than
    # <i>n</i>; otherwise, it is equal to the character at index
    # <i>k+start-n</i> in the argument <code>s</code>.
    # <p>
    # If <code>s</code> is <code>null</code>, then this method appends
    # characters as if the s parameter was a sequence containing the four
    # characters <code>"null"</code>.
    # 
    # @param   s the sequence to append.
    # @param   start   the starting index of the subsequence to be appended.
    # @param   end     the end index of the subsequence to be appended.
    # @return  a reference to this object.
    # @throws     IndexOutOfBoundsException if
    # <code>start</code> or <code>end</code> are negative, or
    # <code>start</code> is greater than <code>end</code> or
    # <code>end</code> is greater than <code>s.length()</code>
    def append(s, start, end_)
      if ((s).nil?)
        s = "null"
      end
      if ((start < 0) || (end_ < 0) || (start > end_) || (end_ > s.length))
        raise IndexOutOfBoundsException.new("start " + RJava.cast_to_string(start) + ", end " + RJava.cast_to_string(end_) + ", s.length() " + RJava.cast_to_string(s.length))
      end
      len = end_ - start
      if ((len).equal?(0))
        return self
      end
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      i = start
      while i < end_
        @value[((@count += 1) - 1)] = s.char_at(i)
        i += 1
      end
      @count = new_count
      return self
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Appends the string representation of the <code>char</code> array
    # argument to this sequence.
    # <p>
    # The characters of the array argument are appended, in order, to
    # the contents of this sequence. The length of this sequence
    # increases by the length of the argument.
    # <p>
    # The overall effect is exactly as if the argument were converted to
    # a string by the method {@link String#valueOf(char[])} and the
    # characters of that string were then {@link #append(String) appended}
    # to this character sequence.
    # 
    # @param   str   the characters to be appended.
    # @return  a reference to this object.
    def append(str)
      new_count = @count + str.attr_length
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(str, 0, @value, @count, str.attr_length)
      @count = new_count
      return self
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Appends the string representation of a subarray of the
    # <code>char</code> array argument to this sequence.
    # <p>
    # Characters of the <code>char</code> array <code>str</code>, starting at
    # index <code>offset</code>, are appended, in order, to the contents
    # of this sequence. The length of this sequence increases
    # by the value of <code>len</code>.
    # <p>
    # The overall effect is exactly as if the arguments were converted to
    # a string by the method {@link String#valueOf(char[],int,int)} and the
    # characters of that string were then {@link #append(String) appended}
    # to this character sequence.
    # 
    # @param   str      the characters to be appended.
    # @param   offset   the index of the first <code>char</code> to append.
    # @param   len      the number of <code>char</code>s to append.
    # @return  a reference to this object.
    def append(str, offset, len)
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(str, offset, @value, @count, len)
      @count = new_count
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Appends the string representation of the <code>boolean</code>
    # argument to the sequence.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this sequence.
    # 
    # @param   b   a <code>boolean</code>.
    # @return  a reference to this object.
    def append(b)
      if (b)
        new_count = @count + 4
        if (new_count > @value.attr_length)
          expand_capacity(new_count)
        end
        @value[((@count += 1) - 1)] = Character.new(?t.ord)
        @value[((@count += 1) - 1)] = Character.new(?r.ord)
        @value[((@count += 1) - 1)] = Character.new(?u.ord)
        @value[((@count += 1) - 1)] = Character.new(?e.ord)
      else
        new_count = @count + 5
        if (new_count > @value.attr_length)
          expand_capacity(new_count)
        end
        @value[((@count += 1) - 1)] = Character.new(?f.ord)
        @value[((@count += 1) - 1)] = Character.new(?a.ord)
        @value[((@count += 1) - 1)] = Character.new(?l.ord)
        @value[((@count += 1) - 1)] = Character.new(?s.ord)
        @value[((@count += 1) - 1)] = Character.new(?e.ord)
      end
      return self
    end
    
    typesig { [::Java::Char] }
    # Appends the string representation of the <code>char</code>
    # argument to this sequence.
    # <p>
    # The argument is appended to the contents of this sequence.
    # The length of this sequence increases by <code>1</code>.
    # <p>
    # The overall effect is exactly as if the argument were converted to
    # a string by the method {@link String#valueOf(char)} and the character
    # in that string were then {@link #append(String) appended} to this
    # character sequence.
    # 
    # @param   c   a <code>char</code>.
    # @return  a reference to this object.
    def append(c)
      new_count = @count + 1
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      @value[((@count += 1) - 1)] = c
      return self
    end
    
    typesig { [::Java::Int] }
    # Appends the string representation of the <code>int</code>
    # argument to this sequence.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this sequence.
    # 
    # @param   i   an <code>int</code>.
    # @return  a reference to this object.
    def append(i)
      if ((i).equal?(JavaInteger::MIN_VALUE))
        append("-2147483648")
        return self
      end
      appended_length = (i < 0) ? JavaInteger.string_size(-i) + 1 : JavaInteger.string_size(i)
      space_needed = @count + appended_length
      if (space_needed > @value.attr_length)
        expand_capacity(space_needed)
      end
      JavaInteger.get_chars(i, space_needed, @value)
      @count = space_needed
      return self
    end
    
    typesig { [::Java::Long] }
    # Appends the string representation of the <code>long</code>
    # argument to this sequence.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this sequence.
    # 
    # @param   l   a <code>long</code>.
    # @return  a reference to this object.
    def append(l)
      if ((l).equal?(Long::MIN_VALUE))
        append("-9223372036854775808")
        return self
      end
      appended_length = (l < 0) ? Long.string_size(-l) + 1 : Long.string_size(l)
      space_needed = @count + appended_length
      if (space_needed > @value.attr_length)
        expand_capacity(space_needed)
      end
      Long.get_chars(l, space_needed, @value)
      @count = space_needed
      return self
    end
    
    typesig { [::Java::Float] }
    # Appends the string representation of the <code>float</code>
    # argument to this sequence.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this string sequence.
    # 
    # @param   f   a <code>float</code>.
    # @return  a reference to this object.
    def append(f)
      FloatingDecimal.new(f).append_to(self)
      return self
    end
    
    typesig { [::Java::Double] }
    # Appends the string representation of the <code>double</code>
    # argument to this sequence.
    # <p>
    # The argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then appended to this sequence.
    # 
    # @param   d   a <code>double</code>.
    # @return  a reference to this object.
    def append(d)
      FloatingDecimal.new(d).append_to(self)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes the characters in a substring of this sequence.
    # The substring begins at the specified <code>start</code> and extends to
    # the character at index <code>end - 1</code> or to the end of the
    # sequence if no such character exists. If
    # <code>start</code> is equal to <code>end</code>, no changes are made.
    # 
    # @param      start  The beginning index, inclusive.
    # @param      end    The ending index, exclusive.
    # @return     This object.
    # @throws     StringIndexOutOfBoundsException  if <code>start</code>
    # is negative, greater than <code>length()</code>, or
    # greater than <code>end</code>.
    def delete(start, end_)
      if (start < 0)
        raise StringIndexOutOfBoundsException.new(start)
      end
      if (end_ > @count)
        end_ = @count
      end
      if (start > end_)
        raise StringIndexOutOfBoundsException.new
      end
      len = end_ - start
      if (len > 0)
        System.arraycopy(@value, start + len, @value, start, @count - end_)
        @count -= len
      end
      return self
    end
    
    typesig { [::Java::Int] }
    # Appends the string representation of the <code>codePoint</code>
    # argument to this sequence.
    # 
    # <p> The argument is appended to the contents of this sequence.
    # The length of this sequence increases by
    # {@link Character#charCount(int) Character.charCount(codePoint)}.
    # 
    # <p> The overall effect is exactly as if the argument were
    # converted to a <code>char</code> array by the method {@link
    # Character#toChars(int)} and the character in that array were
    # then {@link #append(char[]) appended} to this character
    # sequence.
    # 
    # @param   codePoint   a Unicode code point
    # @return  a reference to this object.
    # @exception IllegalArgumentException if the specified
    # <code>codePoint</code> isn't a valid Unicode code point
    def append_code_point(code_point)
      if (!Character.is_valid_code_point(code_point))
        raise IllegalArgumentException.new
      end
      n = 1
      if (code_point >= Character::MIN_SUPPLEMENTARY_CODE_POINT)
        n += 1
      end
      new_count = @count + n
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      if ((n).equal?(1))
        @value[((@count += 1) - 1)] = RJava.cast_to_char(code_point)
      else
        Character.to_surrogates(code_point, @value, @count)
        @count += n
      end
      return self
    end
    
    typesig { [::Java::Int] }
    # Removes the <code>char</code> at the specified position in this
    # sequence. This sequence is shortened by one <code>char</code>.
    # 
    # <p>Note: If the character at the given index is a supplementary
    # character, this method does not remove the entire character. If
    # correct handling of supplementary characters is required,
    # determine the number of <code>char</code>s to remove by calling
    # <code>Character.charCount(thisSequence.codePointAt(index))</code>,
    # where <code>thisSequence</code> is this sequence.
    # 
    # @param       index  Index of <code>char</code> to remove
    # @return      This object.
    # @throws      StringIndexOutOfBoundsException  if the <code>index</code>
    # is negative or greater than or equal to
    # <code>length()</code>.
    def delete_char_at(index)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      System.arraycopy(@value, index + 1, @value, index, @count - index - 1)
      @count -= 1
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Replaces the characters in a substring of this sequence
    # with characters in the specified <code>String</code>. The substring
    # begins at the specified <code>start</code> and extends to the character
    # at index <code>end - 1</code> or to the end of the
    # sequence if no such character exists. First the
    # characters in the substring are removed and then the specified
    # <code>String</code> is inserted at <code>start</code>. (This
    # sequence will be lengthened to accommodate the
    # specified String if necessary.)
    # 
    # @param      start    The beginning index, inclusive.
    # @param      end      The ending index, exclusive.
    # @param      str   String that will replace previous contents.
    # @return     This object.
    # @throws     StringIndexOutOfBoundsException  if <code>start</code>
    # is negative, greater than <code>length()</code>, or
    # greater than <code>end</code>.
    def replace(start, end_, str)
      if (start < 0)
        raise StringIndexOutOfBoundsException.new(start)
      end
      if (start > @count)
        raise StringIndexOutOfBoundsException.new("start > length()")
      end
      if (start > end_)
        raise StringIndexOutOfBoundsException.new("start > end")
      end
      if (end_ > @count)
        end_ = @count
      end
      len = str.length
      new_count = @count + len - (end_ - start)
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, end_, @value, start + len, @count - end_)
      str.get_chars(@value, start)
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int] }
    # Returns a new <code>String</code> that contains a subsequence of
    # characters currently contained in this character sequence. The
    # substring begins at the specified index and extends to the end of
    # this sequence.
    # 
    # @param      start    The beginning index, inclusive.
    # @return     The new string.
    # @throws     StringIndexOutOfBoundsException  if <code>start</code> is
    # less than zero, or greater than the length of this object.
    def substring(start)
      return substring(start, @count)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns a new character sequence that is a subsequence of this sequence.
    # 
    # <p> An invocation of this method of the form
    # 
    # <blockquote><pre>
    # sb.subSequence(begin,&nbsp;end)</pre></blockquote>
    # 
    # behaves in exactly the same way as the invocation
    # 
    # <blockquote><pre>
    # sb.substring(begin,&nbsp;end)</pre></blockquote>
    # 
    # This method is provided so that this class can
    # implement the {@link CharSequence} interface. </p>
    # 
    # @param      start   the start index, inclusive.
    # @param      end     the end index, exclusive.
    # @return     the specified subsequence.
    # 
    # @throws  IndexOutOfBoundsException
    # if <tt>start</tt> or <tt>end</tt> are negative,
    # if <tt>end</tt> is greater than <tt>length()</tt>,
    # or if <tt>start</tt> is greater than <tt>end</tt>
    # @spec JSR-51
    def sub_sequence(start, end_)
      return substring(start, end_)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns a new <code>String</code> that contains a subsequence of
    # characters currently contained in this sequence. The
    # substring begins at the specified <code>start</code> and
    # extends to the character at index <code>end - 1</code>.
    # 
    # @param      start    The beginning index, inclusive.
    # @param      end      The ending index, exclusive.
    # @return     The new string.
    # @throws     StringIndexOutOfBoundsException  if <code>start</code>
    # or <code>end</code> are negative or greater than
    # <code>length()</code>, or <code>start</code> is
    # greater than <code>end</code>.
    def substring(start, end_)
      if (start < 0)
        raise StringIndexOutOfBoundsException.new(start)
      end
      if (end_ > @count)
        raise StringIndexOutOfBoundsException.new(end_)
      end
      if (start > end_)
        raise StringIndexOutOfBoundsException.new(end_ - start)
      end
      return String.new(@value, start, end_ - start)
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # Inserts the string representation of a subarray of the <code>str</code>
    # array argument into this sequence. The subarray begins at the
    # specified <code>offset</code> and extends <code>len</code> <code>char</code>s.
    # The characters of the subarray are inserted into this sequence at
    # the position indicated by <code>index</code>. The length of this
    # sequence increases by <code>len</code> <code>char</code>s.
    # 
    # @param      index    position at which to insert subarray.
    # @param      str       A <code>char</code> array.
    # @param      offset   the index of the first <code>char</code> in subarray to
    # be inserted.
    # @param      len      the number of <code>char</code>s in the subarray to
    # be inserted.
    # @return     This object
    # @throws     StringIndexOutOfBoundsException  if <code>index</code>
    # is negative or greater than <code>length()</code>, or
    # <code>offset</code> or <code>len</code> are negative, or
    # <code>(offset+len)</code> is greater than
    # <code>str.length</code>.
    def insert(index, str, offset, len)
      if ((index < 0) || (index > length))
        raise StringIndexOutOfBoundsException.new(index)
      end
      if ((offset < 0) || (len < 0) || (offset > str.attr_length - len))
        raise StringIndexOutOfBoundsException.new("offset " + RJava.cast_to_string(offset) + ", len " + RJava.cast_to_string(len) + ", str.length " + RJava.cast_to_string(str.attr_length))
      end
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, index, @value, index + len, @count - index)
      System.arraycopy(str, offset, @value, index, len)
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int, Object] }
    # Inserts the string representation of the <code>Object</code>
    # argument into this character sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the indicated
    # offset.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      obj      an <code>Object</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, obj)
      return insert(offset, String.value_of(obj))
    end
    
    typesig { [::Java::Int, String] }
    # Inserts the string into this character sequence.
    # <p>
    # The characters of the <code>String</code> argument are inserted, in
    # order, into this sequence at the indicated offset, moving up any
    # characters originally above that position and increasing the length
    # of this sequence by the length of the argument. If
    # <code>str</code> is <code>null</code>, then the four characters
    # <code>"null"</code> are inserted into this sequence.
    # <p>
    # The character at index <i>k</i> in the new character sequence is
    # equal to:
    # <ul>
    # <li>the character at index <i>k</i> in the old character sequence, if
    # <i>k</i> is less than <code>offset</code>
    # <li>the character at index <i>k</i><code>-offset</code> in the
    # argument <code>str</code>, if <i>k</i> is not less than
    # <code>offset</code> but is less than <code>offset+str.length()</code>
    # <li>the character at index <i>k</i><code>-str.length()</code> in the
    # old character sequence, if <i>k</i> is not less than
    # <code>offset+str.length()</code>
    # </ul><p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      str      a string.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, str)
      if ((offset < 0) || (offset > length))
        raise StringIndexOutOfBoundsException.new(offset)
      end
      if ((str).nil?)
        str = "null"
      end
      len = str.length
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, offset, @value, offset + len, @count - offset)
      str.get_chars(@value, offset)
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char)] }
    # Inserts the string representation of the <code>char</code> array
    # argument into this sequence.
    # <p>
    # The characters of the array argument are inserted into the
    # contents of this sequence at the position indicated by
    # <code>offset</code>. The length of this sequence increases by
    # the length of the argument.
    # <p>
    # The overall effect is exactly as if the argument were converted to
    # a string by the method {@link String#valueOf(char[])} and the
    # characters of that string were then
    # {@link #insert(int,String) inserted} into this
    # character sequence at the position indicated by
    # <code>offset</code>.
    # 
    # @param      offset   the offset.
    # @param      str      a character array.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, str)
      if ((offset < 0) || (offset > length))
        raise StringIndexOutOfBoundsException.new(offset)
      end
      len = str.attr_length
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, offset, @value, offset + len, @count - offset)
      System.arraycopy(str, 0, @value, offset, len)
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int, CharSequence] }
    # Inserts the specified <code>CharSequence</code> into this sequence.
    # <p>
    # The characters of the <code>CharSequence</code> argument are inserted,
    # in order, into this sequence at the indicated offset, moving up
    # any characters originally above that position and increasing the length
    # of this sequence by the length of the argument s.
    # <p>
    # The result of this method is exactly the same as if it were an
    # invocation of this object's insert(dstOffset, s, 0, s.length()) method.
    # 
    # <p>If <code>s</code> is <code>null</code>, then the four characters
    # <code>"null"</code> are inserted into this sequence.
    # 
    # @param      dstOffset   the offset.
    # @param      s the sequence to be inserted
    # @return     a reference to this object.
    # @throws     IndexOutOfBoundsException  if the offset is invalid.
    def insert(dst_offset, s)
      if ((s).nil?)
        s = "null"
      end
      if (s.is_a?(String))
        return self.insert(dst_offset, s)
      end
      return self.insert(dst_offset, s, 0, s.length)
    end
    
    typesig { [::Java::Int, CharSequence, ::Java::Int, ::Java::Int] }
    # Inserts a subsequence of the specified <code>CharSequence</code> into
    # this sequence.
    # <p>
    # The subsequence of the argument <code>s</code> specified by
    # <code>start</code> and <code>end</code> are inserted,
    # in order, into this sequence at the specified destination offset, moving
    # up any characters originally above that position. The length of this
    # sequence is increased by <code>end - start</code>.
    # <p>
    # The character at index <i>k</i> in this sequence becomes equal to:
    # <ul>
    # <li>the character at index <i>k</i> in this sequence, if
    # <i>k</i> is less than <code>dstOffset</code>
    # <li>the character at index <i>k</i><code>+start-dstOffset</code> in
    # the argument <code>s</code>, if <i>k</i> is greater than or equal to
    # <code>dstOffset</code> but is less than <code>dstOffset+end-start</code>
    # <li>the character at index <i>k</i><code>-(end-start)</code> in this
    # sequence, if <i>k</i> is greater than or equal to
    # <code>dstOffset+end-start</code>
    # </ul><p>
    # The dstOffset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # <p>The start argument must be nonnegative, and not greater than
    # <code>end</code>.
    # <p>The end argument must be greater than or equal to
    # <code>start</code>, and less than or equal to the length of s.
    # 
    # <p>If <code>s</code> is <code>null</code>, then this method inserts
    # characters as if the s parameter was a sequence containing the four
    # characters <code>"null"</code>.
    # 
    # @param      dstOffset   the offset in this sequence.
    # @param      s       the sequence to be inserted.
    # @param      start   the starting index of the subsequence to be inserted.
    # @param      end     the end index of the subsequence to be inserted.
    # @return     a reference to this object.
    # @throws     IndexOutOfBoundsException  if <code>dstOffset</code>
    # is negative or greater than <code>this.length()</code>, or
    # <code>start</code> or <code>end</code> are negative, or
    # <code>start</code> is greater than <code>end</code> or
    # <code>end</code> is greater than <code>s.length()</code>
    def insert(dst_offset, s, start, end_)
      if ((s).nil?)
        s = "null"
      end
      if ((dst_offset < 0) || (dst_offset > self.length))
        raise IndexOutOfBoundsException.new("dstOffset " + RJava.cast_to_string(dst_offset))
      end
      if ((start < 0) || (end_ < 0) || (start > end_) || (end_ > s.length))
        raise IndexOutOfBoundsException.new("start " + RJava.cast_to_string(start) + ", end " + RJava.cast_to_string(end_) + ", s.length() " + RJava.cast_to_string(s.length))
      end
      len = end_ - start
      if ((len).equal?(0))
        return self
      end
      new_count = @count + len
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, dst_offset, @value, dst_offset + len, @count - dst_offset)
      i = start
      while i < end_
        @value[((dst_offset += 1) - 1)] = s.char_at(i)
        i += 1
      end
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Inserts the string representation of the <code>boolean</code>
    # argument into this sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the indicated
    # offset.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      b        a <code>boolean</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, b)
      return insert(offset, String.value_of(b))
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # Inserts the string representation of the <code>char</code>
    # argument into this sequence.
    # <p>
    # The second argument is inserted into the contents of this sequence
    # at the position indicated by <code>offset</code>. The length
    # of this sequence increases by one.
    # <p>
    # The overall effect is exactly as if the argument were converted to
    # a string by the method {@link String#valueOf(char)} and the character
    # in that string were then {@link #insert(int, String) inserted} into
    # this character sequence at the position indicated by
    # <code>offset</code>.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      c        a <code>char</code>.
    # @return     a reference to this object.
    # @throws     IndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, c)
      new_count = @count + 1
      if (new_count > @value.attr_length)
        expand_capacity(new_count)
      end
      System.arraycopy(@value, offset, @value, offset + 1, @count - offset)
      @value[offset] = c
      @count = new_count
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Inserts the string representation of the second <code>int</code>
    # argument into this sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the indicated
    # offset.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      i        an <code>int</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, i)
      return insert(offset, String.value_of(i))
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Inserts the string representation of the <code>long</code>
    # argument into this sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the position
    # indicated by <code>offset</code>.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      l        a <code>long</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, l)
      return insert(offset, String.value_of(l))
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # Inserts the string representation of the <code>float</code>
    # argument into this sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the indicated
    # offset.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      f        a <code>float</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, f)
      return insert(offset, String.value_of(f))
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    # Inserts the string representation of the <code>double</code>
    # argument into this sequence.
    # <p>
    # The second argument is converted to a string as if by the method
    # <code>String.valueOf</code>, and the characters of that
    # string are then inserted into this sequence at the indicated
    # offset.
    # <p>
    # The offset argument must be greater than or equal to
    # <code>0</code>, and less than or equal to the length of this
    # sequence.
    # 
    # @param      offset   the offset.
    # @param      d        a <code>double</code>.
    # @return     a reference to this object.
    # @throws     StringIndexOutOfBoundsException  if the offset is invalid.
    def insert(offset, d)
      return insert(offset, String.value_of(d))
    end
    
    typesig { [String] }
    # Returns the index within this string of the first occurrence of the
    # specified substring. The integer returned is the smallest value
    # <i>k</i> such that:
    # <blockquote><pre>
    # this.toString().startsWith(str, <i>k</i>)
    # </pre></blockquote>
    # is <code>true</code>.
    # 
    # @param   str   any string.
    # @return  if the string argument occurs as a substring within this
    # object, then the index of the first character of the first
    # such substring is returned; if it does not occur as a
    # substring, <code>-1</code> is returned.
    # @throws  java.lang.NullPointerException if <code>str</code> is
    # <code>null</code>.
    def index_of(str)
      return index_of(str, 0)
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the index within this string of the first occurrence of the
    # specified substring, starting at the specified index.  The integer
    # returned is the smallest value <tt>k</tt> for which:
    # <blockquote><pre>
    # k >= Math.min(fromIndex, str.length()) &&
    # this.toString().startsWith(str, k)
    # </pre></blockquote>
    # If no such value of <i>k</i> exists, then -1 is returned.
    # 
    # @param   str         the substring for which to search.
    # @param   fromIndex   the index from which to start the search.
    # @return  the index within this string of the first occurrence of the
    # specified substring, starting at the specified index.
    # @throws  java.lang.NullPointerException if <code>str</code> is
    # <code>null</code>.
    def index_of(str, from_index)
      return String.index_of(@value, 0, @count, str.to_char_array, 0, str.length, from_index)
    end
    
    typesig { [String] }
    # Returns the index within this string of the rightmost occurrence
    # of the specified substring.  The rightmost empty string "" is
    # considered to occur at the index value <code>this.length()</code>.
    # The returned index is the largest value <i>k</i> such that
    # <blockquote><pre>
    # this.toString().startsWith(str, k)
    # </pre></blockquote>
    # is true.
    # 
    # @param   str   the substring to search for.
    # @return  if the string argument occurs one or more times as a substring
    # within this object, then the index of the first character of
    # the last such substring is returned. If it does not occur as
    # a substring, <code>-1</code> is returned.
    # @throws  java.lang.NullPointerException  if <code>str</code> is
    # <code>null</code>.
    def last_index_of(str)
      return last_index_of(str, @count)
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the index within this string of the last occurrence of the
    # specified substring. The integer returned is the largest value <i>k</i>
    # such that:
    # <blockquote><pre>
    # k <= Math.min(fromIndex, str.length()) &&
    # this.toString().startsWith(str, k)
    # </pre></blockquote>
    # If no such value of <i>k</i> exists, then -1 is returned.
    # 
    # @param   str         the substring to search for.
    # @param   fromIndex   the index to start the search from.
    # @return  the index within this sequence of the last occurrence of the
    # specified substring.
    # @throws  java.lang.NullPointerException if <code>str</code> is
    # <code>null</code>.
    def last_index_of(str, from_index)
      return String.last_index_of(@value, 0, @count, str.to_char_array, 0, str.length, from_index)
    end
    
    typesig { [] }
    # Causes this character sequence to be replaced by the reverse of
    # the sequence. If there are any surrogate pairs included in the
    # sequence, these are treated as single characters for the
    # reverse operation. Thus, the order of the high-low surrogates
    # is never reversed.
    # 
    # Let <i>n</i> be the character length of this character sequence
    # (not the length in <code>char</code> values) just prior to
    # execution of the <code>reverse</code> method. Then the
    # character at index <i>k</i> in the new character sequence is
    # equal to the character at index <i>n-k-1</i> in the old
    # character sequence.
    # 
    # <p>Note that the reverse operation may result in producing
    # surrogate pairs that were unpaired low-surrogates and
    # high-surrogates before the operation. For example, reversing
    # "&#92;uDC00&#92;uD800" produces "&#92;uD800&#92;uDC00" which is
    # a valid surrogate pair.
    # 
    # @return  a reference to this object.
    def reverse
      has_surrogate = false
      n = @count - 1
      j = (n - 1) >> 1
      while j >= 0
        temp = @value[j]
        temp2 = @value[n - j]
        if (!has_surrogate)
          has_surrogate = (temp >= Character::MIN_SURROGATE && temp <= Character::MAX_SURROGATE) || (temp2 >= Character::MIN_SURROGATE && temp2 <= Character::MAX_SURROGATE)
        end
        @value[j] = temp2
        @value[n - j] = temp
        (j -= 1)
      end
      if (has_surrogate)
        # Reverse back all valid surrogate pairs
        i = 0
        while i < @count - 1
          c2 = @value[i]
          if (Character.is_low_surrogate(c2))
            c1 = @value[i + 1]
            if (Character.is_high_surrogate(c1))
              @value[((i += 1) - 1)] = c1
              @value[i] = c2
            end
          end
          i += 1
        end
      end
      return self
    end
    
    typesig { [] }
    # Returns a string representing the data in this sequence.
    # A new <code>String</code> object is allocated and initialized to
    # contain the character sequence currently represented by this
    # object. This <code>String</code> is then returned. Subsequent
    # changes to this sequence do not affect the contents of the
    # <code>String</code>.
    # 
    # @return  a string representation of this sequence of characters.
    def to_s
      raise NotImplementedError
    end
    
    typesig { [] }
    # Needed by <tt>String</tt> for the contentEquals method.
    def get_value
      return @value
    end
    
    private
    alias_method :initialize__abstract_string_builder, :initialize
  end
  
end

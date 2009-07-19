require "rjava"

# Copyright 1994-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module StringBufferImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # A thread-safe, mutable sequence of characters.
  # A string buffer is like a {@link String}, but can be modified. At any
  # point in time it contains some particular sequence of characters, but
  # the length and content of the sequence can be changed through certain
  # method calls.
  # <p>
  # String buffers are safe for use by multiple threads. The methods
  # are synchronized where necessary so that all the operations on any
  # particular instance behave as if they occur in some serial order
  # that is consistent with the order of the method calls made by each of
  # the individual threads involved.
  # <p>
  # The principal operations on a <code>StringBuffer</code> are the
  # <code>append</code> and <code>insert</code> methods, which are
  # overloaded so as to accept data of any type. Each effectively
  # converts a given datum to a string and then appends or inserts the
  # characters of that string to the string buffer. The
  # <code>append</code> method always adds these characters at the end
  # of the buffer; the <code>insert</code> method adds the characters at
  # a specified point.
  # <p>
  # For example, if <code>z</code> refers to a string buffer object
  # whose current contents are "<code>start</code>", then
  # the method call <code>z.append("le")</code> would cause the string
  # buffer to contain "<code>startle</code>", whereas
  # <code>z.insert(4, "le")</code> would alter the string buffer to
  # contain "<code>starlet</code>".
  # <p>
  # In general, if sb refers to an instance of a <code>StringBuffer</code>,
  # then <code>sb.append(x)</code> has the same effect as
  # <code>sb.insert(sb.length(),&nbsp;x)</code>.
  # <p>
  # Whenever an operation occurs involving a source sequence (such as
  # appending or inserting from a source sequence) this class synchronizes
  # only on the string buffer performing the operation, not on the source.
  # <p>
  # Every string buffer has a capacity. As long as the length of the
  # character sequence contained in the string buffer does not exceed
  # the capacity, it is not necessary to allocate a new internal
  # buffer array. If the internal buffer overflows, it is
  # automatically made larger.
  # 
  # As of  release JDK 5, this class has been supplemented with an equivalent
  # class designed for use by a single thread, {@link StringBuilder}.  The
  # <tt>StringBuilder</tt> class should generally be used in preference to
  # this one, as it supports all of the same operations but it is faster, as
  # it performs no synchronization.
  # 
  # @author      Arthur van Hoff
  # @see     java.lang.StringBuilder
  # @see     java.lang.String
  # @since   JDK1.0
  class StringBuffer < StringBufferImports.const_get :AbstractStringBuilder
    include_class_members StringBufferImports
    include Java::Io::Serializable
    include CharSequence
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 3388685877147921107 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a string buffer with no characters in it and an
    # initial capacity of 16 characters.
    def initialize
      super(16)
    end
    
    typesig { [::Java::Int] }
    # Constructs a string buffer with no characters in it and
    # the specified initial capacity.
    # 
    # @param      capacity  the initial capacity.
    # @exception  NegativeArraySizeException  if the <code>capacity</code>
    # argument is less than <code>0</code>.
    def initialize(capacity)
      super(capacity)
    end
    
    typesig { [String] }
    # Constructs a string buffer initialized to the contents of the
    # specified string. The initial capacity of the string buffer is
    # <code>16</code> plus the length of the string argument.
    # 
    # @param   str   the initial contents of the buffer.
    # @exception NullPointerException if <code>str</code> is <code>null</code>
    def initialize(str)
      super(str.length + 16)
      append(str)
    end
    
    typesig { [CharSequence] }
    # Constructs a string buffer that contains the same characters
    # as the specified <code>CharSequence</code>. The initial capacity of
    # the string buffer is <code>16</code> plus the length of the
    # <code>CharSequence</code> argument.
    # <p>
    # If the length of the specified <code>CharSequence</code> is
    # less than or equal to zero, then an empty buffer of capacity
    # <code>16</code> is returned.
    # 
    # @param      seq   the sequence to copy.
    # @exception NullPointerException if <code>seq</code> is <code>null</code>
    # @since 1.5
    def initialize(seq)
      initialize__string_buffer(seq.length + 16)
      append(seq)
    end
    
    typesig { [] }
    def length
      synchronized(self) do
        return self.attr_count
      end
    end
    
    typesig { [] }
    def capacity
      synchronized(self) do
        return self.attr_value.attr_length
      end
    end
    
    typesig { [::Java::Int] }
    def ensure_capacity(minimum_capacity)
      synchronized(self) do
        if (minimum_capacity > self.attr_value.attr_length)
          expand_capacity(minimum_capacity)
        end
      end
    end
    
    typesig { [] }
    # @since      1.5
    def trim_to_size
      synchronized(self) do
        super
      end
    end
    
    typesig { [::Java::Int] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def set_length(new_length)
      synchronized(self) do
        super(new_length)
      end
    end
    
    typesig { [::Java::Int] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def char_at(index)
      synchronized(self) do
        if ((index < 0) || (index >= self.attr_count))
          raise StringIndexOutOfBoundsException.new(index)
        end
        return self.attr_value[index]
      end
    end
    
    typesig { [::Java::Int] }
    # @since      1.5
    def code_point_at(index)
      synchronized(self) do
        return super(index)
      end
    end
    
    typesig { [::Java::Int] }
    # @since     1.5
    def code_point_before(index)
      synchronized(self) do
        return super(index)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @since     1.5
    def code_point_count(begin_index, end_index)
      synchronized(self) do
        return super(begin_index, end_index)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @since     1.5
    def offset_by_code_points(index, code_point_offset)
      synchronized(self) do
        return super(index, code_point_offset)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
    # @throws NullPointerException {@inheritDoc}
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def get_chars(src_begin, src_end, dst, dst_begin)
      synchronized(self) do
        super(src_begin, src_end, dst, dst_begin)
      end
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def set_char_at(index, ch)
      synchronized(self) do
        if ((index < 0) || (index >= self.attr_count))
          raise StringIndexOutOfBoundsException.new(index)
        end
        self.attr_value[index] = ch
      end
    end
    
    typesig { [Object] }
    # @see     java.lang.String#valueOf(java.lang.Object)
    # @see     #append(java.lang.String)
    def append(obj)
      synchronized(self) do
        super(String.value_of(obj))
        return self
      end
    end
    
    typesig { [String] }
    def append(str)
      synchronized(self) do
        super(str)
        return self
      end
    end
    
    typesig { [StringBuffer] }
    # Appends the specified <tt>StringBuffer</tt> to this sequence.
    # <p>
    # The characters of the <tt>StringBuffer</tt> argument are appended,
    # in order, to the contents of this <tt>StringBuffer</tt>, increasing the
    # length of this <tt>StringBuffer</tt> by the length of the argument.
    # If <tt>sb</tt> is <tt>null</tt>, then the four characters
    # <tt>"null"</tt> are appended to this <tt>StringBuffer</tt>.
    # <p>
    # Let <i>n</i> be the length of the old character sequence, the one
    # contained in the <tt>StringBuffer</tt> just prior to execution of the
    # <tt>append</tt> method. Then the character at index <i>k</i> in
    # the new character sequence is equal to the character at index <i>k</i>
    # in the old character sequence, if <i>k</i> is less than <i>n</i>;
    # otherwise, it is equal to the character at index <i>k-n</i> in the
    # argument <code>sb</code>.
    # <p>
    # This method synchronizes on <code>this</code> (the destination)
    # object but does not synchronize on the source (<code>sb</code>).
    # 
    # @param   sb   the <tt>StringBuffer</tt> to append.
    # @return  a reference to this object.
    # @since 1.4
    def append(sb)
      synchronized(self) do
        super(sb)
        return self
      end
    end
    
    typesig { [CharSequence] }
    # Appends the specified <code>CharSequence</code> to this
    # sequence.
    # <p>
    # The characters of the <code>CharSequence</code> argument are appended,
    # in order, increasing the length of this sequence by the length of the
    # argument.
    # 
    # <p>The result of this method is exactly the same as if it were an
    # invocation of this.append(s, 0, s.length());
    # 
    # <p>This method synchronizes on this (the destination)
    # object but does not synchronize on the source (<code>s</code>).
    # 
    # <p>If <code>s</code> is <code>null</code>, then the four characters
    # <code>"null"</code> are appended.
    # 
    # @param   s the <code>CharSequence</code> to append.
    # @return  a reference to this object.
    # @since 1.5
    def append(s)
      # Note, synchronization achieved via other invocations
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
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @since      1.5
    def append(s, start, end_)
      synchronized(self) do
        super(s, start, end_)
        return self
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    def append(str)
      synchronized(self) do
        super(str)
        return self
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def append(str, offset, len)
      synchronized(self) do
        super(str, offset, len)
        return self
      end
    end
    
    typesig { [::Java::Boolean] }
    # @see     java.lang.String#valueOf(boolean)
    # @see     #append(java.lang.String)
    def append(b)
      synchronized(self) do
        super(b)
        return self
      end
    end
    
    typesig { [::Java::Char] }
    def append(c)
      synchronized(self) do
        super(c)
        return self
      end
    end
    
    typesig { [::Java::Int] }
    # @see     java.lang.String#valueOf(int)
    # @see     #append(java.lang.String)
    def append(i)
      synchronized(self) do
        super(i)
        return self
      end
    end
    
    typesig { [::Java::Int] }
    # @since 1.5
    def append_code_point(code_point)
      synchronized(self) do
        super(code_point)
        return self
      end
    end
    
    typesig { [::Java::Long] }
    # @see     java.lang.String#valueOf(long)
    # @see     #append(java.lang.String)
    def append(lng)
      synchronized(self) do
        super(lng)
        return self
      end
    end
    
    typesig { [::Java::Float] }
    # @see     java.lang.String#valueOf(float)
    # @see     #append(java.lang.String)
    def append(f)
      synchronized(self) do
        super(f)
        return self
      end
    end
    
    typesig { [::Java::Double] }
    # @see     java.lang.String#valueOf(double)
    # @see     #append(java.lang.String)
    def append(d)
      synchronized(self) do
        super(d)
        return self
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def delete(start, end_)
      synchronized(self) do
        super(start, end_)
        return self
      end
    end
    
    typesig { [::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def delete_char_at(index)
      synchronized(self) do
        super(index)
        return self
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def replace(start, end_, str)
      synchronized(self) do
        super(start, end_, str)
        return self
      end
    end
    
    typesig { [::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def substring(start)
      synchronized(self) do
        return substring(start, self.attr_count)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @since      1.4
    def sub_sequence(start, end_)
      synchronized(self) do
        return AbstractStringBuilder.instance_method(:substring).bind(self).call(start, end_)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def substring(start, end_)
      synchronized(self) do
        return super(start, end_)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @since      1.2
    def insert(index, str, offset, len)
      synchronized(self) do
        super(index, str, offset, len)
        return self
      end
    end
    
    typesig { [::Java::Int, Object] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(java.lang.Object)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, obj)
      synchronized(self) do
        super(offset, String.value_of(obj))
        return self
      end
    end
    
    typesig { [::Java::Int, String] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def insert(offset, str)
      synchronized(self) do
        super(offset, str)
        return self
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char)] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def insert(offset, str)
      synchronized(self) do
        super(offset, str)
        return self
      end
    end
    
    typesig { [::Java::Int, CharSequence] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @since      1.5
    def insert(dst_offset, s)
      # Note, synchronization achieved via other invocations
      if ((s).nil?)
        s = "null"
      end
      if (s.is_a?(String))
        return self.insert(dst_offset, s)
      end
      return self.insert(dst_offset, s, 0, s.length)
    end
    
    typesig { [::Java::Int, CharSequence, ::Java::Int, ::Java::Int] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @since      1.5
    def insert(dst_offset, s, start, end_)
      synchronized(self) do
        super(dst_offset, s, start, end_)
        return self
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(boolean)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, b)
      return insert(offset, String.value_of(b))
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def insert(offset, c)
      synchronized(self) do
        super(offset, c)
        return self
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(int)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, i)
      return insert(offset, String.value_of(i))
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(long)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, l)
      return insert(offset, String.value_of(l))
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(float)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, f)
      return insert(offset, String.value_of(f))
    end
    
    typesig { [::Java::Int, ::Java::Double] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(double)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, d)
      return insert(offset, String.value_of(d))
    end
    
    typesig { [String] }
    # @throws NullPointerException {@inheritDoc}
    # @since      1.4
    def index_of(str)
      return index_of(str, 0)
    end
    
    typesig { [String, ::Java::Int] }
    # @throws NullPointerException {@inheritDoc}
    # @since      1.4
    def index_of(str, from_index)
      synchronized(self) do
        return String.index_of(self.attr_value, 0, self.attr_count, str.to_char_array, 0, str.length, from_index)
      end
    end
    
    typesig { [String] }
    # @throws NullPointerException {@inheritDoc}
    # @since      1.4
    def last_index_of(str)
      # Note, synchronization achieved via other invocations
      return last_index_of(str, self.attr_count)
    end
    
    typesig { [String, ::Java::Int] }
    # @throws NullPointerException {@inheritDoc}
    # @since      1.4
    def last_index_of(str, from_index)
      synchronized(self) do
        return String.last_index_of(self.attr_value, 0, self.attr_count, str.to_char_array, 0, str.length, from_index)
      end
    end
    
    typesig { [] }
    # @since   JDK1.0.2
    def reverse
      synchronized(self) do
        super
        return self
      end
    end
    
    typesig { [] }
    def to_s
      synchronized(self) do
        return String.new(self.attr_value, 0, self.attr_count)
      end
    end
    
    class_module.module_eval {
      # Serializable fields for StringBuffer.
      # 
      # @serialField value  char[]
      # The backing character array of this StringBuffer.
      # @serialField count int
      # The number of characters in this StringBuffer.
      # @serialField shared  boolean
      # A flag indicating whether the backing array is shared.
      # The value is ignored upon deserialization.
      const_set_lazy(:SerialPersistentFields) { Array.typed(Java::Io::ObjectStreamField).new([Java::Io::ObjectStreamField.new("value", Array), Java::Io::ObjectStreamField.new("count", JavaInteger::TYPE), Java::Io::ObjectStreamField.new("shared", Boolean::TYPE), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # readObject is called to restore the state of the StringBuffer from
    # a stream.
    def write_object(s)
      synchronized(self) do
        fields = s.put_fields
        fields.put("value", self.attr_value)
        fields.put("count", self.attr_count)
        fields.put("shared", false)
        s.write_fields
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the StringBuffer from
    # a stream.
    def read_object(s)
      fields = s.read_fields
      self.attr_value = fields.get("value", nil)
      self.attr_count = fields.get("count", 0)
    end
    
    private
    alias_method :initialize__string_buffer, :initialize
  end
  
end

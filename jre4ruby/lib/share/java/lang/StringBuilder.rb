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
module Java::Lang
  module StringBuilderImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # A mutable sequence of characters.  This class provides an API compatible
  # with <code>StringBuffer</code>, but with no guarantee of synchronization.
  # This class is designed for use as a drop-in replacement for
  # <code>StringBuffer</code> in places where the string buffer was being
  # used by a single thread (as is generally the case).   Where possible,
  # it is recommended that this class be used in preference to
  # <code>StringBuffer</code> as it will be faster under most implementations.
  # 
  # <p>The principal operations on a <code>StringBuilder</code> are the
  # <code>append</code> and <code>insert</code> methods, which are
  # overloaded so as to accept data of any type. Each effectively
  # converts a given datum to a string and then appends or inserts the
  # characters of that string to the string builder. The
  # <code>append</code> method always adds these characters at the end
  # of the builder; the <code>insert</code> method adds the characters at
  # a specified point.
  # <p>
  # For example, if <code>z</code> refers to a string builder object
  # whose current contents are "<code>start</code>", then
  # the method call <code>z.append("le")</code> would cause the string
  # builder to contain "<code>startle</code>", whereas
  # <code>z.insert(4, "le")</code> would alter the string builder to
  # contain "<code>starlet</code>".
  # <p>
  # In general, if sb refers to an instance of a <code>StringBuilder</code>,
  # then <code>sb.append(x)</code> has the same effect as
  # <code>sb.insert(sb.length(),&nbsp;x)</code>.
  # 
  # Every string builder has a capacity. As long as the length of the
  # character sequence contained in the string builder does not exceed
  # the capacity, it is not necessary to allocate a new internal
  # buffer. If the internal buffer overflows, it is automatically made larger.
  # 
  # <p>Instances of <code>StringBuilder</code> are not safe for
  # use by multiple threads. If such synchronization is required then it is
  # recommended that {@link java.lang.StringBuffer} be used.
  # 
  # @author      Michael McCloskey
  # @see         java.lang.StringBuffer
  # @see         java.lang.String
  # @since       1.5
  class StringBuilder < StringBuilderImports.const_get :AbstractStringBuilder
    include_class_members StringBuilderImports
    overload_protected {
      include Java::Io::Serializable
      include CharSequence
    }
    
    class_module.module_eval {
      # use serialVersionUID for interoperability
      const_set_lazy(:SerialVersionUID) { 4383685877147921099 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a string builder with no characters in it and an
    # initial capacity of 16 characters.
    def initialize
      super(16)
    end
    
    typesig { [::Java::Int] }
    # Constructs a string builder with no characters in it and an
    # initial capacity specified by the <code>capacity</code> argument.
    # 
    # @param      capacity  the initial capacity.
    # @throws     NegativeArraySizeException  if the <code>capacity</code>
    # argument is less than <code>0</code>.
    def initialize(capacity)
      super(capacity)
    end
    
    typesig { [String] }
    # Constructs a string builder initialized to the contents of the
    # specified string. The initial capacity of the string builder is
    # <code>16</code> plus the length of the string argument.
    # 
    # @param   str   the initial contents of the buffer.
    # @throws    NullPointerException if <code>str</code> is <code>null</code>
    def initialize(str)
      super(str.length + 16)
      append(str)
    end
    
    typesig { [CharSequence] }
    # Constructs a string builder that contains the same characters
    # as the specified <code>CharSequence</code>. The initial capacity of
    # the string builder is <code>16</code> plus the length of the
    # <code>CharSequence</code> argument.
    # 
    # @param      seq   the sequence to copy.
    # @throws    NullPointerException if <code>seq</code> is <code>null</code>
    def initialize(seq)
      initialize__string_builder(seq.length + 16)
      append(seq)
    end
    
    typesig { [Object] }
    # @see     java.lang.String#valueOf(java.lang.Object)
    # @see     #append(java.lang.String)
    def append(obj)
      return append(String.value_of(obj))
    end
    
    typesig { [String] }
    def append(str)
      super(str)
      return self
    end
    
    typesig { [StringBuilder] }
    # Appends the specified string builder to this sequence.
    def append(sb)
      if ((sb).nil?)
        return append("null")
      end
      len = sb.length
      newcount = self.attr_count + len
      if (newcount > self.attr_value.attr_length)
        expand_capacity(newcount)
      end
      sb.get_chars(0, len, self.attr_value, self.attr_count)
      self.attr_count = newcount
      return self
    end
    
    typesig { [StringBuffer] }
    # Appends the specified <tt>StringBuffer</tt> to this sequence.
    # <p>
    # The characters of the <tt>StringBuffer</tt> argument are appended,
    # in order, to this sequence, increasing the
    # length of this sequence by the length of the argument.
    # If <tt>sb</tt> is <tt>null</tt>, then the four characters
    # <tt>"null"</tt> are appended to this sequence.
    # <p>
    # Let <i>n</i> be the length of this character sequence just prior to
    # execution of the <tt>append</tt> method. Then the character at index
    # <i>k</i> in the new character sequence is equal to the character at
    # index <i>k</i> in the old character sequence, if <i>k</i> is less than
    # <i>n</i>; otherwise, it is equal to the character at index <i>k-n</i>
    # in the argument <code>sb</code>.
    # 
    # @param   sb   the <tt>StringBuffer</tt> to append.
    # @return  a reference to this object.
    def append(sb)
      super(sb)
      return self
    end
    
    typesig { [CharSequence] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
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
      if (s.is_a?(StringBuilder))
        return self.append(s)
      end
      return self.append(s, 0, s.length)
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # @throws     IndexOutOfBoundsException {@inheritDoc}
    def append(s, start, end_)
      super(s, start, end_)
      return self
    end
    
    typesig { [Array.typed(::Java::Char)] }
    def append(str)
      super(str)
      return self
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    def append(str, offset, len)
      super(str, offset, len)
      return self
    end
    
    typesig { [::Java::Boolean] }
    # @see     java.lang.String#valueOf(boolean)
    # @see     #append(java.lang.String)
    def append(b)
      super(b)
      return self
    end
    
    typesig { [::Java::Char] }
    def append(c)
      super(c)
      return self
    end
    
    typesig { [::Java::Int] }
    # @see     java.lang.String#valueOf(int)
    # @see     #append(java.lang.String)
    def append(i)
      super(i)
      return self
    end
    
    typesig { [::Java::Long] }
    # @see     java.lang.String#valueOf(long)
    # @see     #append(java.lang.String)
    def append(lng)
      super(lng)
      return self
    end
    
    typesig { [::Java::Float] }
    # @see     java.lang.String#valueOf(float)
    # @see     #append(java.lang.String)
    def append(f)
      super(f)
      return self
    end
    
    typesig { [::Java::Double] }
    # @see     java.lang.String#valueOf(double)
    # @see     #append(java.lang.String)
    def append(d)
      super(d)
      return self
    end
    
    typesig { [::Java::Int] }
    # @since 1.5
    def append_code_point(code_point)
      super(code_point)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def delete(start, end_)
      super(start, end_)
      return self
    end
    
    typesig { [::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def delete_char_at(index)
      super(index)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def replace(start, end_, str)
      super(start, end_, str)
      return self
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def insert(index, str, offset, len)
      super(index, str, offset, len)
      return self
    end
    
    typesig { [::Java::Int, Object] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(java.lang.Object)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, obj)
      return insert(offset, String.value_of(obj))
    end
    
    typesig { [::Java::Int, String] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def insert(offset, str)
      super(offset, str)
      return self
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Char)] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    def insert(offset, str)
      super(offset, str)
      return self
    end
    
    typesig { [::Java::Int, CharSequence] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
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
    # @throws IndexOutOfBoundsException {@inheritDoc}
    def insert(dst_offset, s, start, end_)
      super(dst_offset, s, start, end_)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # @throws StringIndexOutOfBoundsException {@inheritDoc}
    # @see        java.lang.String#valueOf(boolean)
    # @see        #insert(int, java.lang.String)
    # @see        #length()
    def insert(offset, b)
      super(offset, b)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # @throws IndexOutOfBoundsException {@inheritDoc}
    # @see        #length()
    def insert(offset, c)
      super(offset, c)
      return self
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
    def index_of(str)
      return index_of(str, 0)
    end
    
    typesig { [String, ::Java::Int] }
    # @throws NullPointerException {@inheritDoc}
    def index_of(str, from_index)
      return String.index_of(self.attr_value, 0, self.attr_count, str.to_char_array, 0, str.length, from_index)
    end
    
    typesig { [String] }
    # @throws NullPointerException {@inheritDoc}
    def last_index_of(str)
      return last_index_of(str, self.attr_count)
    end
    
    typesig { [String, ::Java::Int] }
    # @throws NullPointerException {@inheritDoc}
    def last_index_of(str, from_index)
      return String.last_index_of(self.attr_value, 0, self.attr_count, str.to_char_array, 0, str.length, from_index)
    end
    
    typesig { [] }
    def reverse
      super
      return self
    end
    
    typesig { [] }
    def to_s
      # Create a copy, don't share the array
      return String.new(self.attr_value, 0, self.attr_count)
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state of the <tt>StringBuilder</tt> instance to a stream
    # (that is, serialize it).
    # 
    # @serialData the number of characters currently stored in the string
    # builder (<tt>int</tt>), followed by the characters in the
    # string builder (<tt>char[]</tt>).   The length of the
    # <tt>char</tt> array may be greater than the number of
    # characters currently stored in the string builder, in which
    # case extra characters are ignored.
    def write_object(s)
      s.default_write_object
      s.write_int(self.attr_count)
      s.write_object(self.attr_value)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the StringBuffer from
    # a stream.
    def read_object(s)
      s.default_read_object
      self.attr_count = s.read_int
      self.attr_value = s.read_object
    end
    
    private
    alias_method :initialize__string_builder, :initialize
  end
  
end

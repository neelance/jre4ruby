require "rjava"

# 
# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module StringImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :ObjectStreamClass
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Formatter
      include_const ::Java::Util, :Locale
      include_const ::Java::Util::Regex, :Matcher
      include_const ::Java::Util::Regex, :Pattern
      include_const ::Java::Util::Regex, :PatternSyntaxException
    }
  end
  
  # 
  # The <code>String</code> class represents character strings. All
  # string literals in Java programs, such as <code>"abc"</code>, are
  # implemented as instances of this class.
  # <p>
  # Strings are constant; their values cannot be changed after they
  # are created. String buffers support mutable strings.
  # Because String objects are immutable they can be shared. For example:
  # <p><blockquote><pre>
  # String str = "abc";
  # </pre></blockquote><p>
  # is equivalent to:
  # <p><blockquote><pre>
  # char data[] = {'a', 'b', 'c'};
  # String str = new String(data);
  # </pre></blockquote><p>
  # Here are some more examples of how strings can be used:
  # <p><blockquote><pre>
  # System.out.println("abc");
  # String cde = "cde";
  # System.out.println("abc" + cde);
  # String c = "abc".substring(2,3);
  # String d = cde.substring(1, 2);
  # </pre></blockquote>
  # <p>
  # The class <code>String</code> includes methods for examining
  # individual characters of the sequence, for comparing strings, for
  # searching strings, for extracting substrings, and for creating a
  # copy of a string with all characters translated to uppercase or to
  # lowercase. Case mapping is based on the Unicode Standard version
  # specified by the {@link java.lang.Character Character} class.
  # <p>
  # The Java language provides special support for the string
  # concatenation operator (&nbsp;+&nbsp;), and for conversion of
  # other objects to strings. String concatenation is implemented
  # through the <code>StringBuilder</code>(or <code>StringBuffer</code>)
  # class and its <code>append</code> method.
  # String conversions are implemented through the method
  # <code>toString</code>, defined by <code>Object</code> and
  # inherited by all classes in Java. For additional information on
  # string concatenation and conversion, see Gosling, Joy, and Steele,
  # <i>The Java Language Specification</i>.
  # 
  # <p> Unless otherwise noted, passing a <tt>null</tt> argument to a constructor
  # or method in this class will cause a {@link NullPointerException} to be
  # thrown.
  # 
  # <p>A <code>String</code> represents a string in the UTF-16 format
  # in which <em>supplementary characters</em> are represented by <em>surrogate
  # pairs</em> (see the section <a href="Character.html#unicode">Unicode
  # Character Representations</a> in the <code>Character</code> class for
  # more information).
  # Index values refer to <code>char</code> code units, so a supplementary
  # character uses two positions in a <code>String</code>.
  # <p>The <code>String</code> class provides methods for dealing with
  # Unicode code points (i.e., characters), in addition to those for
  # dealing with Unicode code units (i.e., <code>char</code> values).
  # 
  # @author  Lee Boynton
  # @author  Arthur van Hoff
  # @see     java.lang.Object#toString()
  # @see     java.lang.StringBuffer
  # @see     java.lang.StringBuilder
  # @see     java.nio.charset.Charset
  # @since   JDK1.0
  class String 
    include_class_members StringImports
    include Java::Io::Serializable
    include JavaComparable
    include CharSequence
    
    # The value is used for character storage.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # The offset is the first index of the storage that is used.
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    # The count is the number of characters in the String.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # Cache the hash code for the string
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    class_module.module_eval {
      # Default to 0
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -6849794470754667710 }
      const_attr_reader  :SerialVersionUID
      
      # 
      # Class String is special cased within the Serialization Stream Protocol.
      # 
      # A String instance is written initially into an ObjectOutputStream in the
      # following format:
      # <pre>
      # <code>TC_STRING</code> (utf String)
      # </pre>
      # The String is written by method <code>DataOutput.writeUTF</code>.
      # A new handle is generated to  refer to all future references to the
      # string instance within the stream.
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new(0) { nil } }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [] }
    # 
    # Initializes a newly created {@code String} object so that it represents
    # an empty character sequence.  Note that use of this constructor is
    # unnecessary since Strings are immutable.
    def initialize
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      @offset = 0
      @count = 0
      @value = CharArray.new(0)
    end
    
    typesig { [String] }
    # 
    # Initializes a newly created {@code String} object so that it represents
    # the same sequence of characters as the argument; in other words, the
    # newly created string is a copy of the argument string. Unless an
    # explicit copy of {@code original} is needed, use of this constructor is
    # unnecessary since Strings are immutable.
    # 
    # @param  original
    # A {@code String}
    def initialize(original)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      size = original.attr_count
      original_value = original.attr_value
      v = nil
      if (original_value.attr_length > size)
        # The array representing the String is bigger than the new
        # String itself.  Perhaps this constructor is being called
        # in order to trim the baggage, so make a copy of the array.
        off = original.attr_offset
        v = Arrays.copy_of_range(original_value, off, off + size)
      else
        # The array representing the String is the same
        # size as the String, so no point in making a copy.
        v = original_value
      end
      @offset = 0
      @count = size
      @value = v
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # 
    # Allocates a new {@code String} so that it represents the sequence of
    # characters currently contained in the character array argument. The
    # contents of the character array are copied; subsequent modification of
    # the character array does not affect the newly created string.
    # 
    # @param  value
    # The initial value of the string
    def initialize(value)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      size = value.attr_length
      @offset = 0
      @count = size
      @value = Arrays.copy_of(value, size)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Allocates a new {@code String} that contains characters from a subarray
    # of the character array argument. The {@code offset} argument is the
    # index of the first character of the subarray and the {@code count}
    # argument specifies the length of the subarray. The contents of the
    # subarray are copied; subsequent modification of the character array does
    # not affect the newly created string.
    # 
    # @param  value
    # Array that is the source of characters
    # 
    # @param  offset
    # The initial offset
    # 
    # @param  count
    # The length
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} and {@code count} arguments index
    # characters outside the bounds of the {@code value} array
    def initialize(value, offset, count)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      if (offset < 0)
        raise StringIndexOutOfBoundsException.new(offset)
      end
      if (count < 0)
        raise StringIndexOutOfBoundsException.new(count)
      end
      # Note: offset or count might be near -1>>>1.
      if (offset > value.attr_length - count)
        raise StringIndexOutOfBoundsException.new(offset + count)
      end
      @offset = 0
      @count = count
      @value = Arrays.copy_of_range(value, offset, offset + count)
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
    # 
    # Allocates a new {@code String} that contains characters from a subarray
    # of the <a href="Character.html#unicode">Unicode code point</a> array
    # argument.  The {@code offset} argument is the index of the first code
    # point of the subarray and the {@code count} argument specifies the
    # length of the subarray.  The contents of the subarray are converted to
    # {@code char}s; subsequent modification of the {@code int} array does not
    # affect the newly created string.
    # 
    # @param  codePoints
    # Array that is the source of Unicode code points
    # 
    # @param  offset
    # The initial offset
    # 
    # @param  count
    # The length
    # 
    # @throws  IllegalArgumentException
    # If any invalid Unicode code point is found in {@code
    # codePoints}
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} and {@code count} arguments index
    # characters outside the bounds of the {@code codePoints} array
    # 
    # @since  1.5
    def initialize(code_points, offset, count)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      if (offset < 0)
        raise StringIndexOutOfBoundsException.new(offset)
      end
      if (count < 0)
        raise StringIndexOutOfBoundsException.new(count)
      end
      # Note: offset or count might be near -1>>>1.
      if (offset > code_points.attr_length - count)
        raise StringIndexOutOfBoundsException.new(offset + count)
      end
      # Pass 1: Compute precise size of char[]
      n = 0
      i = offset
      while i < offset + count
        c = code_points[i]
        if (c >= Character::MIN_CODE_POINT && c < Character::MIN_SUPPLEMENTARY_CODE_POINT)
          n += 1
        else
          if (Character.is_supplementary_code_point(c))
            n += 2
          else
            raise IllegalArgumentException.new(JavaInteger.to_s(c))
          end
        end
        ((i += 1) - 1)
      end
      # Pass 2: Allocate and fill in char[]
      v = CharArray.new(n)
      i_ = offset
      j = 0
      while i_ < offset + count
        c_ = code_points[i_]
        if (c_ < Character::MIN_SUPPLEMENTARY_CODE_POINT)
          v[((j += 1) - 1)] = RJava.cast_to_char(c_)
        else
          Character.to_surrogates(c_, v, j)
          j += 2
        end
        ((i_ += 1) - 1)
      end
      @value = v
      @count = v.attr_length
      @offset = 0
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    # 
    # Allocates a new {@code String} constructed from a subarray of an array
    # of 8-bit integer values.
    # 
    # <p> The {@code offset} argument is the index of the first byte of the
    # subarray, and the {@code count} argument specifies the length of the
    # subarray.
    # 
    # <p> Each {@code byte} in the subarray is converted to a {@code char} as
    # specified in the method above.
    # 
    # @deprecated This method does not properly convert bytes into characters.
    # As of JDK&nbsp;1.1, the preferred way to do this is via the
    # {@code String} constructors that take a {@link
    # java.nio.charset.Charset}, charset name, or that use the platform's
    # default charset.
    # 
    # @param  ascii
    # The bytes to be converted to characters
    # 
    # @param  hibyte
    # The top 8 bits of each 16-bit Unicode code unit
    # 
    # @param  offset
    # The initial offset
    # @param  count
    # The length
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} or {@code count} argument is invalid
    # 
    # @see  #String(byte[], int)
    # @see  #String(byte[], int, int, java.lang.String)
    # @see  #String(byte[], int, int, java.nio.charset.Charset)
    # @see  #String(byte[], int, int)
    # @see  #String(byte[], java.lang.String)
    # @see  #String(byte[], java.nio.charset.Charset)
    # @see  #String(byte[])
    def initialize(ascii, hibyte, offset, count)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      check_bounds(ascii, offset, count)
      value = CharArray.new(count)
      if ((hibyte).equal?(0))
        i = count
        while ((i -= 1) + 1) > 0
          value[i] = RJava.cast_to_char((ascii[i + offset] & 0xff))
        end
      else
        hibyte <<= 8
        i_ = count
        while ((i_ -= 1) + 1) > 0
          value[i_] = RJava.cast_to_char((hibyte | (ascii[i_ + offset] & 0xff)))
        end
      end
      @offset = 0
      @count = count
      @value = value
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Allocates a new {@code String} containing characters constructed from
    # an array of 8-bit integer values. Each character <i>c</i>in the
    # resulting string is constructed from the corresponding component
    # <i>b</i> in the byte array such that:
    # 
    # <blockquote><pre>
    # <b><i>c</i></b> == (char)(((hibyte &amp; 0xff) &lt;&lt; 8)
    # | (<b><i>b</i></b> &amp; 0xff))
    # </pre></blockquote>
    # 
    # @deprecated  This method does not properly convert bytes into
    # characters.  As of JDK&nbsp;1.1, the preferred way to do this is via the
    # {@code String} constructors that take a {@link
    # java.nio.charset.Charset}, charset name, or that use the platform's
    # default charset.
    # 
    # @param  ascii
    # The bytes to be converted to characters
    # 
    # @param  hibyte
    # The top 8 bits of each 16-bit Unicode code unit
    # 
    # @see  #String(byte[], int, int, java.lang.String)
    # @see  #String(byte[], int, int, java.nio.charset.Charset)
    # @see  #String(byte[], int, int)
    # @see  #String(byte[], java.lang.String)
    # @see  #String(byte[], java.nio.charset.Charset)
    # @see  #String(byte[])
    def initialize(ascii, hibyte)
      initialize__string(ascii, hibyte, 0, ascii.attr_length)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Common private utility method used to bounds check the byte array
      # and requested offset & length values used by the String(byte[],..)
      # constructors.
      def check_bounds(bytes, offset, length)
        if (length < 0)
          raise StringIndexOutOfBoundsException.new(length)
        end
        if (offset < 0)
          raise StringIndexOutOfBoundsException.new(offset)
        end
        if (offset > bytes.attr_length - length)
          raise StringIndexOutOfBoundsException.new(offset + length)
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, String] }
    # 
    # Constructs a new {@code String} by decoding the specified subarray of
    # bytes using the specified charset.  The length of the new {@code String}
    # is a function of the charset, and hence may not be equal to the length
    # of the subarray.
    # 
    # <p> The behavior of this constructor when the given bytes are not valid
    # in the given charset is unspecified.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @param  offset
    # The index of the first byte to decode
    # 
    # @param  length
    # The number of bytes to decode
    # 
    # @param  charsetName
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} and {@code length} arguments index
    # characters outside the bounds of the {@code bytes} array
    # 
    # @since  JDK1.1
    def initialize(bytes, offset, length, charset_name)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      if ((charset_name).nil?)
        raise NullPointerException.new("charsetName")
      end
      check_bounds(bytes, offset, length)
      v = StringCoding.decode(charset_name, bytes, offset, length)
      @offset = 0
      @count = v.attr_length
      @value = v
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Charset] }
    # 
    # Constructs a new {@code String} by decoding the specified subarray of
    # bytes using the specified {@linkplain java.nio.charset.Charset charset}.
    # The length of the new {@code String} is a function of the charset, and
    # hence may not be equal to the length of the subarray.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement string.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @param  offset
    # The index of the first byte to decode
    # 
    # @param  length
    # The number of bytes to decode
    # 
    # @param  charset
    # The {@linkplain java.nio.charset.Charset charset} to be used to
    # decode the {@code bytes}
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} and {@code length} arguments index
    # characters outside the bounds of the {@code bytes} array
    # 
    # @since  1.6
    def initialize(bytes, offset, length, charset)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      if ((charset).nil?)
        raise NullPointerException.new("charset")
      end
      check_bounds(bytes, offset, length)
      v = StringCoding.decode(charset, bytes, offset, length)
      @offset = 0
      @count = v.attr_length
      @value = v
    end
    
    typesig { [Array.typed(::Java::Byte), String] }
    # 
    # Constructs a new {@code String} by decoding the specified array of bytes
    # using the specified {@linkplain java.nio.charset.Charset charset}.  The
    # length of the new {@code String} is a function of the charset, and hence
    # may not be equal to the length of the byte array.
    # 
    # <p> The behavior of this constructor when the given bytes are not valid
    # in the given charset is unspecified.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @param  charsetName
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @since  JDK1.1
    def initialize(bytes, charset_name)
      initialize__string(bytes, 0, bytes.attr_length, charset_name)
    end
    
    typesig { [Array.typed(::Java::Byte), Charset] }
    # 
    # Constructs a new {@code String} by decoding the specified array of
    # bytes using the specified {@linkplain java.nio.charset.Charset charset}.
    # The length of the new {@code String} is a function of the charset, and
    # hence may not be equal to the length of the byte array.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement string.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @param  charset
    # The {@linkplain java.nio.charset.Charset charset} to be used to
    # decode the {@code bytes}
    # 
    # @since  1.6
    def initialize(bytes, charset)
      initialize__string(bytes, 0, bytes.attr_length, charset)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Constructs a new {@code String} by decoding the specified subarray of
    # bytes using the platform's default charset.  The length of the new
    # {@code String} is a function of the charset, and hence may not be equal
    # to the length of the subarray.
    # 
    # <p> The behavior of this constructor when the given bytes are not valid
    # in the default charset is unspecified.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @param  offset
    # The index of the first byte to decode
    # 
    # @param  length
    # The number of bytes to decode
    # 
    # @throws  IndexOutOfBoundsException
    # If the {@code offset} and the {@code length} arguments index
    # characters outside the bounds of the {@code bytes} array
    # 
    # @since  JDK1.1
    def initialize(bytes, offset, length)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      check_bounds(bytes, offset, length)
      v = StringCoding.decode(bytes, offset, length)
      @offset = 0
      @count = v.attr_length
      @value = v
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Constructs a new {@code String} by decoding the specified array of bytes
    # using the platform's default charset.  The length of the new {@code
    # String} is a function of the charset, and hence may not be equal to the
    # length of the byte array.
    # 
    # <p> The behavior of this constructor when the given bytes are not valid
    # in the default charset is unspecified.  The {@link
    # java.nio.charset.CharsetDecoder} class should be used when more control
    # over the decoding process is required.
    # 
    # @param  bytes
    # The bytes to be decoded into characters
    # 
    # @since  JDK1.1
    def initialize(bytes)
      initialize__string(bytes, 0, bytes.attr_length)
    end
    
    typesig { [StringBuffer] }
    # 
    # Allocates a new string that contains the sequence of characters
    # currently contained in the string buffer argument. The contents of the
    # string buffer are copied; subsequent modification of the string buffer
    # does not affect the newly created string.
    # 
    # @param  buffer
    # A {@code StringBuffer}
    def initialize(buffer)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      result = buffer.to_s
      @value = result.attr_value
      @count = result.attr_count
      @offset = result.attr_offset
    end
    
    typesig { [StringBuilder] }
    # 
    # Allocates a new string that contains the sequence of characters
    # currently contained in the string builder argument. The contents of the
    # string builder are copied; subsequent modification of the string builder
    # does not affect the newly created string.
    # 
    # <p> This constructor is provided to ease migration to {@code
    # StringBuilder}. Obtaining a string from a string builder via the {@code
    # toString} method is likely to run faster and is generally preferred.
    # 
    # @param   builder
    # A {@code StringBuilder}
    # 
    # @since  1.5
    def initialize(builder)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      result = builder.to_s
      @value = result.attr_value
      @count = result.attr_count
      @offset = result.attr_offset
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
    # Package private constructor which shares value array for speed.
    def initialize(offset, count, value)
      @value = nil
      @offset = 0
      @count = 0
      @hash = 0
      @value = value
      @offset = offset
      @count = count
    end
    
    typesig { [] }
    # 
    # Returns the length of this string.
    # The length is equal to the number of <a href="Character.html#unicode">Unicode
    # code units</a> in the string.
    # 
    # @return  the length of the sequence of characters represented by this
    # object.
    def length
      return @count
    end
    
    typesig { [] }
    # 
    # Returns <tt>true</tt> if, and only if, {@link #length()} is <tt>0</tt>.
    # 
    # @return <tt>true</tt> if {@link #length()} is <tt>0</tt>, otherwise
    # <tt>false</tt>
    # 
    # @since 1.6
    def is_empty
      return (@count).equal?(0)
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the <code>char</code> value at the
    # specified index. An index ranges from <code>0</code> to
    # <code>length() - 1</code>. The first <code>char</code> value of the sequence
    # is at index <code>0</code>, the next at index <code>1</code>,
    # and so on, as for array indexing.
    # 
    # <p>If the <code>char</code> value specified by the index is a
    # <a href="Character.html#unicode">surrogate</a>, the surrogate
    # value is returned.
    # 
    # @param      index   the index of the <code>char</code> value.
    # @return     the <code>char</code> value at the specified index of this string.
    # The first <code>char</code> value is at index <code>0</code>.
    # @exception  IndexOutOfBoundsException  if the <code>index</code>
    # argument is negative or not less than the length of this
    # string.
    def char_at(index)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return @value[index + @offset]
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the character (Unicode code point) at the specified
    # index. The index refers to <code>char</code> values
    # (Unicode code units) and ranges from <code>0</code> to
    # {@link #length()}<code> - 1</code>.
    # 
    # <p> If the <code>char</code> value specified at the given index
    # is in the high-surrogate range, the following index is less
    # than the length of this <code>String</code>, and the
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
    # string.
    # @since      1.5
    def code_point_at(index)
      if ((index < 0) || (index >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return Character.code_point_at_impl(@value, @offset + index, @offset + @count)
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the character (Unicode code point) before the specified
    # index. The index refers to <code>char</code> values
    # (Unicode code units) and ranges from <code>1</code> to {@link
    # CharSequence#length() length}.
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
    # of this string.
    # @since     1.5
    def code_point_before(index)
      i = index - 1
      if ((i < 0) || (i >= @count))
        raise StringIndexOutOfBoundsException.new(index)
      end
      return Character.code_point_before_impl(@value, @offset + index, @offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns the number of Unicode code points in the specified text
    # range of this <code>String</code>. The text range begins at the
    # specified <code>beginIndex</code> and extends to the
    # <code>char</code> at index <code>endIndex - 1</code>. Thus the
    # length (in <code>char</code>s) of the text range is
    # <code>endIndex-beginIndex</code>. Unpaired surrogates within
    # the text range count as one code point each.
    # 
    # @param beginIndex the index to the first <code>char</code> of
    # the text range.
    # @param endIndex the index after the last <code>char</code> of
    # the text range.
    # @return the number of Unicode code points in the specified text
    # range
    # @exception IndexOutOfBoundsException if the
    # <code>beginIndex</code> is negative, or <code>endIndex</code>
    # is larger than the length of this <code>String</code>, or
    # <code>beginIndex</code> is larger than <code>endIndex</code>.
    # @since  1.5
    def code_point_count(begin_index, end_index)
      if (begin_index < 0 || end_index > @count || begin_index > end_index)
        raise IndexOutOfBoundsException.new
      end
      return Character.code_point_count_impl(@value, @offset + begin_index, end_index - begin_index)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns the index within this <code>String</code> that is
    # offset from the given <code>index</code> by
    # <code>codePointOffset</code> code points. Unpaired surrogates
    # within the text range given by <code>index</code> and
    # <code>codePointOffset</code> count as one code point each.
    # 
    # @param index the index to be offset
    # @param codePointOffset the offset in code points
    # @return the index within this <code>String</code>
    # @exception IndexOutOfBoundsException if <code>index</code>
    # is negative or larger then the length of this
    # <code>String</code>, or if <code>codePointOffset</code> is positive
    # and the substring starting with <code>index</code> has fewer
    # than <code>codePointOffset</code> code points,
    # or if <code>codePointOffset</code> is negative and the substring
    # before <code>index</code> has fewer than the absolute value
    # of <code>codePointOffset</code> code points.
    # @since 1.5
    def offset_by_code_points(index, code_point_offset)
      if (index < 0 || index > @count)
        raise IndexOutOfBoundsException.new
      end
      return Character.offset_by_code_points_impl(@value, @offset, @count, @offset + index, code_point_offset) - @offset
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int] }
    # 
    # Copy characters from this string into dst starting at dstBegin.
    # This method doesn't perform any range checking.
    def get_chars(dst, dst_begin)
      System.arraycopy(@value, @offset, dst, dst_begin, @count)
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
    # 
    # Copies characters from this string into the destination character
    # array.
    # <p>
    # The first character to be copied is at index <code>srcBegin</code>;
    # the last character to be copied is at index <code>srcEnd-1</code>
    # (thus the total number of characters to be copied is
    # <code>srcEnd-srcBegin</code>). The characters are copied into the
    # subarray of <code>dst</code> starting at index <code>dstBegin</code>
    # and ending at index:
    # <p><blockquote><pre>
    # dstbegin + (srcEnd-srcBegin) - 1
    # </pre></blockquote>
    # 
    # @param      srcBegin   index of the first character in the string
    # to copy.
    # @param      srcEnd     index after the last character in the string
    # to copy.
    # @param      dst        the destination array.
    # @param      dstBegin   the start offset in the destination array.
    # @exception IndexOutOfBoundsException If any of the following
    # is true:
    # <ul><li><code>srcBegin</code> is negative.
    # <li><code>srcBegin</code> is greater than <code>srcEnd</code>
    # <li><code>srcEnd</code> is greater than the length of this
    # string
    # <li><code>dstBegin</code> is negative
    # <li><code>dstBegin+(srcEnd-srcBegin)</code> is larger than
    # <code>dst.length</code></ul>
    def get_chars(src_begin, src_end, dst, dst_begin)
      if (src_begin < 0)
        raise StringIndexOutOfBoundsException.new(src_begin)
      end
      if (src_end > @count)
        raise StringIndexOutOfBoundsException.new(src_end)
      end
      if (src_begin > src_end)
        raise StringIndexOutOfBoundsException.new(src_end - src_begin)
      end
      System.arraycopy(@value, @offset + src_begin, dst, dst_begin, src_end - src_begin)
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Copies characters from this string into the destination byte array. Each
    # byte receives the 8 low-order bits of the corresponding character. The
    # eight high-order bits of each character are not copied and do not
    # participate in the transfer in any way.
    # 
    # <p> The first character to be copied is at index {@code srcBegin}; the
    # last character to be copied is at index {@code srcEnd-1}.  The total
    # number of characters to be copied is {@code srcEnd-srcBegin}. The
    # characters, converted to bytes, are copied into the subarray of {@code
    # dst} starting at index {@code dstBegin} and ending at index:
    # 
    # <blockquote><pre>
    # dstbegin + (srcEnd-srcBegin) - 1
    # </pre></blockquote>
    # 
    # @deprecated  This method does not properly convert characters into
    # bytes.  As of JDK&nbsp;1.1, the preferred way to do this is via the
    # {@link #getBytes()} method, which uses the platform's default charset.
    # 
    # @param  srcBegin
    # Index of the first character in the string to copy
    # 
    # @param  srcEnd
    # Index after the last character in the string to copy
    # 
    # @param  dst
    # The destination array
    # 
    # @param  dstBegin
    # The start offset in the destination array
    # 
    # @throws  IndexOutOfBoundsException
    # If any of the following is true:
    # <ul>
    # <li> {@code srcBegin} is negative
    # <li> {@code srcBegin} is greater than {@code srcEnd}
    # <li> {@code srcEnd} is greater than the length of this String
    # <li> {@code dstBegin} is negative
    # <li> {@code dstBegin+(srcEnd-srcBegin)} is larger than {@code
    # dst.length}
    # </ul>
    def get_bytes(src_begin, src_end, dst, dst_begin)
      if (src_begin < 0)
        raise StringIndexOutOfBoundsException.new(src_begin)
      end
      if (src_end > @count)
        raise StringIndexOutOfBoundsException.new(src_end)
      end
      if (src_begin > src_end)
        raise StringIndexOutOfBoundsException.new(src_end - src_begin)
      end
      j = dst_begin
      n = @offset + src_end
      i = @offset + src_begin
      val = @value
      # avoid getfield opcode
      while (i < n)
        dst[((j += 1) - 1)] = val[((i += 1) - 1)]
      end
    end
    
    typesig { [String] }
    # 
    # Encodes this {@code String} into a sequence of bytes using the named
    # charset, storing the result into a new byte array.
    # 
    # <p> The behavior of this method when this string cannot be encoded in
    # the given charset is unspecified.  The {@link
    # java.nio.charset.CharsetEncoder} class should be used when more control
    # over the encoding process is required.
    # 
    # @param  charsetName
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @return  The resultant byte array
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @since  JDK1.1
    def get_bytes(charset_name)
      if ((charset_name).nil?)
        raise NullPointerException.new
      end
      return StringCoding.encode(charset_name, @value, @offset, @count)
    end
    
    typesig { [Charset] }
    # 
    # Encodes this {@code String} into a sequence of bytes using the given
    # {@linkplain java.nio.charset.Charset charset}, storing the result into a
    # new byte array.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement byte array.  The
    # {@link java.nio.charset.CharsetEncoder} class should be used when more
    # control over the encoding process is required.
    # 
    # @param  charset
    # The {@linkplain java.nio.charset.Charset} to be used to encode
    # the {@code String}
    # 
    # @return  The resultant byte array
    # 
    # @since  1.6
    def get_bytes(charset)
      if ((charset).nil?)
        raise NullPointerException.new
      end
      return StringCoding.encode(charset, @value, @offset, @count)
    end
    
    typesig { [] }
    # 
    # Encodes this {@code String} into a sequence of bytes using the
    # platform's default charset, storing the result into a new byte array.
    # 
    # <p> The behavior of this method when this string cannot be encoded in
    # the default charset is unspecified.  The {@link
    # java.nio.charset.CharsetEncoder} class should be used when more control
    # over the encoding process is required.
    # 
    # @return  The resultant byte array
    # 
    # @since      JDK1.1
    def get_bytes
      return StringCoding.encode(@value, @offset, @count)
    end
    
    typesig { [Object] }
    # 
    # Compares this string to the specified object.  The result is {@code
    # true} if and only if the argument is not {@code null} and is a {@code
    # String} object that represents the same sequence of characters as this
    # object.
    # 
    # @param  anObject
    # The object to compare this {@code String} against
    # 
    # @return  {@code true} if the given object represents a {@code String}
    # equivalent to this string, {@code false} otherwise
    # 
    # @see  #compareTo(String)
    # @see  #equalsIgnoreCase(String)
    def equals(an_object)
      if ((self).equal?(an_object))
        return true
      end
      if (an_object.is_a?(String))
        another_string = an_object
        n = @count
        if ((n).equal?(another_string.attr_count))
          v1 = @value
          v2 = another_string.attr_value
          i = @offset
          j = another_string.attr_offset
          while (!(((n -= 1) + 1)).equal?(0))
            if (!(v1[((i += 1) - 1)]).equal?(v2[((j += 1) - 1)]))
              return false
            end
          end
          return true
        end
      end
      return false
    end
    
    typesig { [StringBuffer] }
    # 
    # Compares this string to the specified {@code StringBuffer}.  The result
    # is {@code true} if and only if this {@code String} represents the same
    # sequence of characters as the specified {@code StringBuffer}.
    # 
    # @param  sb
    # The {@code StringBuffer} to compare this {@code String} against
    # 
    # @return  {@code true} if this {@code String} represents the same
    # sequence of characters as the specified {@code StringBuffer},
    # {@code false} otherwise
    # 
    # @since  1.4
    def content_equals(sb)
      synchronized((sb)) do
        return content_equals(sb)
      end
    end
    
    typesig { [CharSequence] }
    # 
    # Compares this string to the specified {@code CharSequence}.  The result
    # is {@code true} if and only if this {@code String} represents the same
    # sequence of char values as the specified sequence.
    # 
    # @param  cs
    # The sequence to compare this {@code String} against
    # 
    # @return  {@code true} if this {@code String} represents the same
    # sequence of char values as the specified sequence, {@code
    # false} otherwise
    # 
    # @since  1.5
    def content_equals(cs)
      if (!(@count).equal?(cs.length))
        return false
      end
      # Argument is a StringBuffer, StringBuilder
      if (cs.is_a?(AbstractStringBuilder))
        v1 = @value
        v2 = (cs).get_value
        i = @offset
        j = 0
        n = @count
        while (!(((n -= 1) + 1)).equal?(0))
          if (!(v1[((i += 1) - 1)]).equal?(v2[((j += 1) - 1)]))
            return false
          end
        end
        return true
      end
      # Argument is a String
      if ((cs == self))
        return true
      end
      # Argument is a generic CharSequence
      v1_ = @value
      i_ = @offset
      j_ = 0
      n_ = @count
      while (!(((n_ -= 1) + 1)).equal?(0))
        if (!(v1_[((i_ += 1) - 1)]).equal?(cs.char_at(((j_ += 1) - 1))))
          return false
        end
      end
      return true
    end
    
    typesig { [String] }
    # 
    # Compares this {@code String} to another {@code String}, ignoring case
    # considerations.  Two strings are considered equal ignoring case if they
    # are of the same length and corresponding characters in the two strings
    # are equal ignoring case.
    # 
    # <p> Two characters {@code c1} and {@code c2} are considered the same
    # ignoring case if at least one of the following is true:
    # <ul>
    # <li> The two characters are the same (as compared by the
    # {@code ==} operator)
    # <li> Applying the method {@link
    # java.lang.Character#toUpperCase(char)} to each character
    # produces the same result
    # <li> Applying the method {@link
    # java.lang.Character#toLowerCase(char)} to each character
    # produces the same result
    # </ul>
    # 
    # @param  anotherString
    # The {@code String} to compare this {@code String} against
    # 
    # @return  {@code true} if the argument is not {@code null} and it
    # represents an equivalent {@code String} ignoring case; {@code
    # false} otherwise
    # 
    # @see  #equals(Object)
    def equals_ignore_case(another_string)
      return ((self).equal?(another_string)) ? true : (!(another_string).nil?) && ((another_string.attr_count).equal?(@count)) && region_matches(true, 0, another_string, 0, @count)
    end
    
    typesig { [String] }
    # 
    # Compares two strings lexicographically.
    # The comparison is based on the Unicode value of each character in
    # the strings. The character sequence represented by this
    # <code>String</code> object is compared lexicographically to the
    # character sequence represented by the argument string. The result is
    # a negative integer if this <code>String</code> object
    # lexicographically precedes the argument string. The result is a
    # positive integer if this <code>String</code> object lexicographically
    # follows the argument string. The result is zero if the strings
    # are equal; <code>compareTo</code> returns <code>0</code> exactly when
    # the {@link #equals(Object)} method would return <code>true</code>.
    # <p>
    # This is the definition of lexicographic ordering. If two strings are
    # different, then either they have different characters at some index
    # that is a valid index for both strings, or their lengths are different,
    # or both. If they have different characters at one or more index
    # positions, let <i>k</i> be the smallest such index; then the string
    # whose character at position <i>k</i> has the smaller value, as
    # determined by using the &lt; operator, lexicographically precedes the
    # other string. In this case, <code>compareTo</code> returns the
    # difference of the two character values at position <code>k</code> in
    # the two string -- that is, the value:
    # <blockquote><pre>
    # this.charAt(k)-anotherString.charAt(k)
    # </pre></blockquote>
    # If there is no index position at which they differ, then the shorter
    # string lexicographically precedes the longer string. In this case,
    # <code>compareTo</code> returns the difference of the lengths of the
    # strings -- that is, the value:
    # <blockquote><pre>
    # this.length()-anotherString.length()
    # </pre></blockquote>
    # 
    # @param   anotherString   the <code>String</code> to be compared.
    # @return  the value <code>0</code> if the argument string is equal to
    # this string; a value less than <code>0</code> if this string
    # is lexicographically less than the string argument; and a
    # value greater than <code>0</code> if this string is
    # lexicographically greater than the string argument.
    def compare_to(another_string)
      len1 = @count
      len2 = another_string.attr_count
      n = Math.min(len1, len2)
      v1 = @value
      v2 = another_string.attr_value
      i = @offset
      j = another_string.attr_offset
      if ((i).equal?(j))
        k = i
        lim = n + i
        while (k < lim)
          c1 = v1[k]
          c2 = v2[k]
          if (!(c1).equal?(c2))
            return c1 - c2
          end
          ((k += 1) - 1)
        end
      else
        while (!(((n -= 1) + 1)).equal?(0))
          c1_ = v1[((i += 1) - 1)]
          c2_ = v2[((j += 1) - 1)]
          if (!(c1_).equal?(c2_))
            return c1_ - c2_
          end
        end
      end
      return len1 - len2
    end
    
    class_module.module_eval {
      # 
      # A Comparator that orders <code>String</code> objects as by
      # <code>compareToIgnoreCase</code>. This comparator is serializable.
      # <p>
      # Note that this Comparator does <em>not</em> take locale into account,
      # and will result in an unsatisfactory ordering for certain locales.
      # The java.text package provides <em>Collators</em> to allow
      # locale-sensitive ordering.
      # 
      # @see     java.text.Collator#compare(String, String)
      # @since   1.2
      const_set_lazy(:CASE_INSENSITIVE_ORDER) { CaseInsensitiveComparator.new }
      const_attr_reader  :CASE_INSENSITIVE_ORDER
      
      const_set_lazy(:CaseInsensitiveComparator) { Class.new do
        include_class_members String
        include Comparator
        include Java::Io::Serializable
        
        class_module.module_eval {
          # use serialVersionUID from JDK 1.2.2 for interoperability
          const_set_lazy(:SerialVersionUID) { 8575799808933029326 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [String, String] }
        def compare(s1, s2)
          n1 = s1.length
          n2 = s2.length
          min_ = Math.min(n1, n2)
          i = 0
          while i < min_
            c1 = s1.char_at(i)
            c2 = s2.char_at(i)
            if (!(c1).equal?(c2))
              c1 = Character.to_upper_case(c1)
              c2 = Character.to_upper_case(c2)
              if (!(c1).equal?(c2))
                c1 = Character.to_lower_case(c1)
                c2 = Character.to_lower_case(c2)
                if (!(c1).equal?(c2))
                  # No overflow because of numeric promotion
                  return c1 - c2
                end
              end
            end
            ((i += 1) - 1)
          end
          return n1 - n2
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__case_insensitive_comparator, :initialize
      end }
    }
    
    typesig { [String] }
    # 
    # Compares two strings lexicographically, ignoring case
    # differences. This method returns an integer whose sign is that of
    # calling <code>compareTo</code> with normalized versions of the strings
    # where case differences have been eliminated by calling
    # <code>Character.toLowerCase(Character.toUpperCase(character))</code> on
    # each character.
    # <p>
    # Note that this method does <em>not</em> take locale into account,
    # and will result in an unsatisfactory ordering for certain locales.
    # The java.text package provides <em>collators</em> to allow
    # locale-sensitive ordering.
    # 
    # @param   str   the <code>String</code> to be compared.
    # @return  a negative integer, zero, or a positive integer as the
    # specified String is greater than, equal to, or less
    # than this String, ignoring case considerations.
    # @see     java.text.Collator#compare(String, String)
    # @since   1.2
    def compare_to_ignore_case(str)
      return CASE_INSENSITIVE_ORDER.compare(self, str)
    end
    
    typesig { [::Java::Int, String, ::Java::Int, ::Java::Int] }
    # 
    # Tests if two string regions are equal.
    # <p>
    # A substring of this <tt>String</tt> object is compared to a substring
    # of the argument other. The result is true if these substrings
    # represent identical character sequences. The substring of this
    # <tt>String</tt> object to be compared begins at index <tt>toffset</tt>
    # and has length <tt>len</tt>. The substring of other to be compared
    # begins at index <tt>ooffset</tt> and has length <tt>len</tt>. The
    # result is <tt>false</tt> if and only if at least one of the following
    # is true:
    # <ul><li><tt>toffset</tt> is negative.
    # <li><tt>ooffset</tt> is negative.
    # <li><tt>toffset+len</tt> is greater than the length of this
    # <tt>String</tt> object.
    # <li><tt>ooffset+len</tt> is greater than the length of the other
    # argument.
    # <li>There is some nonnegative integer <i>k</i> less than <tt>len</tt>
    # such that:
    # <tt>this.charAt(toffset+<i>k</i>)&nbsp;!=&nbsp;other.charAt(ooffset+<i>k</i>)</tt>
    # </ul>
    # 
    # @param   toffset   the starting offset of the subregion in this string.
    # @param   other     the string argument.
    # @param   ooffset   the starting offset of the subregion in the string
    # argument.
    # @param   len       the number of characters to compare.
    # @return  <code>true</code> if the specified subregion of this string
    # exactly matches the specified subregion of the string argument;
    # <code>false</code> otherwise.
    def region_matches(toffset, other, ooffset, len)
      ta = @value
      to = @offset + toffset
      pa = other.attr_value
      po = other.attr_offset + ooffset
      # Note: toffset, ooffset, or len might be near -1>>>1.
      if ((ooffset < 0) || (toffset < 0) || (toffset > @count - len) || (ooffset > other.attr_count - len))
        return false
      end
      while (((len -= 1) + 1) > 0)
        if (!(ta[((to += 1) - 1)]).equal?(pa[((po += 1) - 1)]))
          return false
        end
      end
      return true
    end
    
    typesig { [::Java::Boolean, ::Java::Int, String, ::Java::Int, ::Java::Int] }
    # 
    # Tests if two string regions are equal.
    # <p>
    # A substring of this <tt>String</tt> object is compared to a substring
    # of the argument <tt>other</tt>. The result is <tt>true</tt> if these
    # substrings represent character sequences that are the same, ignoring
    # case if and only if <tt>ignoreCase</tt> is true. The substring of
    # this <tt>String</tt> object to be compared begins at index
    # <tt>toffset</tt> and has length <tt>len</tt>. The substring of
    # <tt>other</tt> to be compared begins at index <tt>ooffset</tt> and
    # has length <tt>len</tt>. The result is <tt>false</tt> if and only if
    # at least one of the following is true:
    # <ul><li><tt>toffset</tt> is negative.
    # <li><tt>ooffset</tt> is negative.
    # <li><tt>toffset+len</tt> is greater than the length of this
    # <tt>String</tt> object.
    # <li><tt>ooffset+len</tt> is greater than the length of the other
    # argument.
    # <li><tt>ignoreCase</tt> is <tt>false</tt> and there is some nonnegative
    # integer <i>k</i> less than <tt>len</tt> such that:
    # <blockquote><pre>
    # this.charAt(toffset+k) != other.charAt(ooffset+k)
    # </pre></blockquote>
    # <li><tt>ignoreCase</tt> is <tt>true</tt> and there is some nonnegative
    # integer <i>k</i> less than <tt>len</tt> such that:
    # <blockquote><pre>
    # Character.toLowerCase(this.charAt(toffset+k)) !=
    # Character.toLowerCase(other.charAt(ooffset+k))
    # </pre></blockquote>
    # and:
    # <blockquote><pre>
    # Character.toUpperCase(this.charAt(toffset+k)) !=
    # Character.toUpperCase(other.charAt(ooffset+k))
    # </pre></blockquote>
    # </ul>
    # 
    # @param   ignoreCase   if <code>true</code>, ignore case when comparing
    # characters.
    # @param   toffset      the starting offset of the subregion in this
    # string.
    # @param   other        the string argument.
    # @param   ooffset      the starting offset of the subregion in the string
    # argument.
    # @param   len          the number of characters to compare.
    # @return  <code>true</code> if the specified subregion of this string
    # matches the specified subregion of the string argument;
    # <code>false</code> otherwise. Whether the matching is exact
    # or case insensitive depends on the <code>ignoreCase</code>
    # argument.
    def region_matches(ignore_case, toffset, other, ooffset, len)
      ta = @value
      to = @offset + toffset
      pa = other.attr_value
      po = other.attr_offset + ooffset
      # Note: toffset, ooffset, or len might be near -1>>>1.
      if ((ooffset < 0) || (toffset < 0) || (toffset > @count - len) || (ooffset > other.attr_count - len))
        return false
      end
      while (((len -= 1) + 1) > 0)
        c1 = ta[((to += 1) - 1)]
        c2 = pa[((po += 1) - 1)]
        if ((c1).equal?(c2))
          next
        end
        if (ignore_case)
          # If characters don't match but case may be ignored,
          # try converting both characters to uppercase.
          # If the results match, then the comparison scan should
          # continue.
          u1 = Character.to_upper_case(c1)
          u2 = Character.to_upper_case(c2)
          if ((u1).equal?(u2))
            next
          end
          # Unfortunately, conversion to uppercase does not work properly
          # for the Georgian alphabet, which has strange rules about case
          # conversion.  So we need to make one last check before
          # exiting.
          if ((Character.to_lower_case(u1)).equal?(Character.to_lower_case(u2)))
            next
          end
        end
        return false
      end
      return true
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Tests if the substring of this string beginning at the
    # specified index starts with the specified prefix.
    # 
    # @param   prefix    the prefix.
    # @param   toffset   where to begin looking in this string.
    # @return  <code>true</code> if the character sequence represented by the
    # argument is a prefix of the substring of this object starting
    # at index <code>toffset</code>; <code>false</code> otherwise.
    # The result is <code>false</code> if <code>toffset</code> is
    # negative or greater than the length of this
    # <code>String</code> object; otherwise the result is the same
    # as the result of the expression
    # <pre>
    # this.substring(toffset).startsWith(prefix)
    # </pre>
    def starts_with(prefix, toffset)
      ta = @value
      to = @offset + toffset
      pa = prefix.attr_value
      po = prefix.attr_offset
      pc = prefix.attr_count
      # Note: toffset might be near -1>>>1.
      if ((toffset < 0) || (toffset > @count - pc))
        return false
      end
      while ((pc -= 1) >= 0)
        if (!(ta[((to += 1) - 1)]).equal?(pa[((po += 1) - 1)]))
          return false
        end
      end
      return true
    end
    
    typesig { [String] }
    # 
    # Tests if this string starts with the specified prefix.
    # 
    # @param   prefix   the prefix.
    # @return  <code>true</code> if the character sequence represented by the
    # argument is a prefix of the character sequence represented by
    # this string; <code>false</code> otherwise.
    # Note also that <code>true</code> will be returned if the
    # argument is an empty string or is equal to this
    # <code>String</code> object as determined by the
    # {@link #equals(Object)} method.
    # @since   1. 0
    def starts_with(prefix)
      return starts_with(prefix, 0)
    end
    
    typesig { [String] }
    # 
    # Tests if this string ends with the specified suffix.
    # 
    # @param   suffix   the suffix.
    # @return  <code>true</code> if the character sequence represented by the
    # argument is a suffix of the character sequence represented by
    # this object; <code>false</code> otherwise. Note that the
    # result will be <code>true</code> if the argument is the
    # empty string or is equal to this <code>String</code> object
    # as determined by the {@link #equals(Object)} method.
    def ends_with(suffix)
      return starts_with(suffix, @count - suffix.attr_count)
    end
    
    typesig { [] }
    # 
    # Returns a hash code for this string. The hash code for a
    # <code>String</code> object is computed as
    # <blockquote><pre>
    # s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]
    # </pre></blockquote>
    # using <code>int</code> arithmetic, where <code>s[i]</code> is the
    # <i>i</i>th character of the string, <code>n</code> is the length of
    # the string, and <code>^</code> indicates exponentiation.
    # (The hash value of the empty string is zero.)
    # 
    # @return  a hash code value for this object.
    def hash_code
      h = @hash
      if ((h).equal?(0))
        off = @offset
        val = @value
        len = @count
        i = 0
        while i < len
          h = 31 * h + val[((off += 1) - 1)]
          ((i += 1) - 1)
        end
        @hash = h
      end
      return h
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the index within this string of the first occurrence of
    # the specified character. If a character with value
    # <code>ch</code> occurs in the character sequence represented by
    # this <code>String</code> object, then the index (in Unicode
    # code units) of the first such occurrence is returned. For
    # values of <code>ch</code> in the range from 0 to 0xFFFF
    # (inclusive), this is the smallest value <i>k</i> such that:
    # <blockquote><pre>
    # this.charAt(<i>k</i>) == ch
    # </pre></blockquote>
    # is true. For other values of <code>ch</code>, it is the
    # smallest value <i>k</i> such that:
    # <blockquote><pre>
    # this.codePointAt(<i>k</i>) == ch
    # </pre></blockquote>
    # is true. In either case, if no such character occurs in this
    # string, then <code>-1</code> is returned.
    # 
    # @param   ch   a character (Unicode code point).
    # @return  the index of the first occurrence of the character in the
    # character sequence represented by this object, or
    # <code>-1</code> if the character does not occur.
    def index_of(ch)
      return index_of(ch, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns the index within this string of the first occurrence of the
    # specified character, starting the search at the specified index.
    # <p>
    # If a character with value <code>ch</code> occurs in the
    # character sequence represented by this <code>String</code>
    # object at an index no smaller than <code>fromIndex</code>, then
    # the index of the first such occurrence is returned. For values
    # of <code>ch</code> in the range from 0 to 0xFFFF (inclusive),
    # this is the smallest value <i>k</i> such that:
    # <blockquote><pre>
    # (this.charAt(<i>k</i>) == ch) && (<i>k</i> &gt;= fromIndex)
    # </pre></blockquote>
    # is true. For other values of <code>ch</code>, it is the
    # smallest value <i>k</i> such that:
    # <blockquote><pre>
    # (this.codePointAt(<i>k</i>) == ch) && (<i>k</i> &gt;= fromIndex)
    # </pre></blockquote>
    # is true. In either case, if no such character occurs in this
    # string at or after position <code>fromIndex</code>, then
    # <code>-1</code> is returned.
    # 
    # <p>
    # There is no restriction on the value of <code>fromIndex</code>. If it
    # is negative, it has the same effect as if it were zero: this entire
    # string may be searched. If it is greater than the length of this
    # string, it has the same effect as if it were equal to the length of
    # this string: <code>-1</code> is returned.
    # 
    # <p>All indices are specified in <code>char</code> values
    # (Unicode code units).
    # 
    # @param   ch          a character (Unicode code point).
    # @param   fromIndex   the index to start the search from.
    # @return  the index of the first occurrence of the character in the
    # character sequence represented by this object that is greater
    # than or equal to <code>fromIndex</code>, or <code>-1</code>
    # if the character does not occur.
    def index_of(ch, from_index)
      max = @offset + @count
      v = @value
      if (from_index < 0)
        from_index = 0
      else
        if (from_index >= @count)
          # Note: fromIndex might be near -1>>>1.
          return -1
        end
      end
      i = @offset + from_index
      if (ch < Character::MIN_SUPPLEMENTARY_CODE_POINT)
        # handle most cases here (ch is a BMP code point or a
        # negative value (invalid code point))
        while i < max
          if ((v[i]).equal?(ch))
            return i - @offset
          end
          ((i += 1) - 1)
        end
        return -1
      end
      if (ch <= Character::MAX_CODE_POINT)
        # handle supplementary characters here
        surrogates = Character.to_chars(ch)
        while i < max
          if ((v[i]).equal?(surrogates[0]))
            if ((i + 1).equal?(max))
              break
            end
            if ((v[i + 1]).equal?(surrogates[1]))
              return i - @offset
            end
          end
          ((i += 1) - 1)
        end
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the index within this string of the last occurrence of
    # the specified character. For values of <code>ch</code> in the
    # range from 0 to 0xFFFF (inclusive), the index (in Unicode code
    # units) returned is the largest value <i>k</i> such that:
    # <blockquote><pre>
    # this.charAt(<i>k</i>) == ch
    # </pre></blockquote>
    # is true. For other values of <code>ch</code>, it is the
    # largest value <i>k</i> such that:
    # <blockquote><pre>
    # this.codePointAt(<i>k</i>) == ch
    # </pre></blockquote>
    # is true.  In either case, if no such character occurs in this
    # string, then <code>-1</code> is returned.  The
    # <code>String</code> is searched backwards starting at the last
    # character.
    # 
    # @param   ch   a character (Unicode code point).
    # @return  the index of the last occurrence of the character in the
    # character sequence represented by this object, or
    # <code>-1</code> if the character does not occur.
    def last_index_of(ch)
      return last_index_of(ch, @count - 1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns the index within this string of the last occurrence of
    # the specified character, searching backward starting at the
    # specified index. For values of <code>ch</code> in the range
    # from 0 to 0xFFFF (inclusive), the index returned is the largest
    # value <i>k</i> such that:
    # <blockquote><pre>
    # (this.charAt(<i>k</i>) == ch) && (<i>k</i> &lt;= fromIndex)
    # </pre></blockquote>
    # is true. For other values of <code>ch</code>, it is the
    # largest value <i>k</i> such that:
    # <blockquote><pre>
    # (this.codePointAt(<i>k</i>) == ch) && (<i>k</i> &lt;= fromIndex)
    # </pre></blockquote>
    # is true. In either case, if no such character occurs in this
    # string at or before position <code>fromIndex</code>, then
    # <code>-1</code> is returned.
    # 
    # <p>All indices are specified in <code>char</code> values
    # (Unicode code units).
    # 
    # @param   ch          a character (Unicode code point).
    # @param   fromIndex   the index to start the search from. There is no
    # restriction on the value of <code>fromIndex</code>. If it is
    # greater than or equal to the length of this string, it has
    # the same effect as if it were equal to one less than the
    # length of this string: this entire string may be searched.
    # If it is negative, it has the same effect as if it were -1:
    # -1 is returned.
    # @return  the index of the last occurrence of the character in the
    # character sequence represented by this object that is less
    # than or equal to <code>fromIndex</code>, or <code>-1</code>
    # if the character does not occur before that point.
    def last_index_of(ch, from_index)
      min_ = @offset
      v = @value
      i = @offset + ((from_index >= @count) ? @count - 1 : from_index)
      if (ch < Character::MIN_SUPPLEMENTARY_CODE_POINT)
        # handle most cases here (ch is a BMP code point or a
        # negative value (invalid code point))
        while i >= min_
          if ((v[i]).equal?(ch))
            return i - @offset
          end
          ((i -= 1) + 1)
        end
        return -1
      end
      max = @offset + @count
      if (ch <= Character::MAX_CODE_POINT)
        # handle supplementary characters here
        surrogates = Character.to_chars(ch)
        while i >= min_
          if ((v[i]).equal?(surrogates[0]))
            if ((i + 1).equal?(max))
              break
            end
            if ((v[i + 1]).equal?(surrogates[1]))
              return i - @offset
            end
          end
          ((i -= 1) + 1)
        end
      end
      return -1
    end
    
    typesig { [String] }
    # 
    # Returns the index within this string of the first occurrence of the
    # specified substring. The integer returned is the smallest value
    # <i>k</i> such that:
    # <blockquote><pre>
    # this.startsWith(str, <i>k</i>)
    # </pre></blockquote>
    # is <code>true</code>.
    # 
    # @param   str   any string.
    # @return  if the string argument occurs as a substring within this
    # object, then the index of the first character of the first
    # such substring is returned; if it does not occur as a
    # substring, <code>-1</code> is returned.
    def index_of(str)
      return index_of(str, 0)
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Returns the index within this string of the first occurrence of the
    # specified substring, starting at the specified index.  The integer
    # returned is the smallest value <tt>k</tt> for which:
    # <blockquote><pre>
    # k &gt;= Math.min(fromIndex, this.length()) && this.startsWith(str, k)
    # </pre></blockquote>
    # If no such value of <i>k</i> exists, then -1 is returned.
    # 
    # @param   str         the substring for which to search.
    # @param   fromIndex   the index from which to start the search.
    # @return  the index within this string of the first occurrence of the
    # specified substring, starting at the specified index.
    def index_of(str, from_index)
      return index_of(@value, @offset, @count, str.attr_value, str.attr_offset, str.attr_count, from_index)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
      # 
      # Code shared by String and StringBuffer to do searches. The
      # source is the character array being searched, and the target
      # is the string being searched for.
      # 
      # @param   source       the characters being searched.
      # @param   sourceOffset offset of the source string.
      # @param   sourceCount  count of the source string.
      # @param   target       the characters being searched for.
      # @param   targetOffset offset of the target string.
      # @param   targetCount  count of the target string.
      # @param   fromIndex    the index to begin searching from.
      def index_of(source, source_offset, source_count, target, target_offset, target_count, from_index)
        if (from_index >= source_count)
          return ((target_count).equal?(0) ? source_count : -1)
        end
        if (from_index < 0)
          from_index = 0
        end
        if ((target_count).equal?(0))
          return from_index
        end
        first = target[target_offset]
        max = source_offset + (source_count - target_count)
        i = source_offset + from_index
        while i <= max
          # Look for first character.
          if (!(source[i]).equal?(first))
            while ((i += 1) <= max && !(source[i]).equal?(first))
            end
          end
          # Found first character, now look at the rest of v2
          if (i <= max)
            j = i + 1
            end_ = j + target_count - 1
            k = target_offset + 1
            while j < end_ && (source[j]).equal?(target[k])
              ((j += 1) - 1)
              ((k += 1) - 1)
            end
            if ((j).equal?(end_))
              # Found whole string.
              return i - source_offset
            end
          end
          ((i += 1) - 1)
        end
        return -1
      end
    }
    
    typesig { [String] }
    # 
    # Returns the index within this string of the rightmost occurrence
    # of the specified substring.  The rightmost empty string "" is
    # considered to occur at the index value <code>this.length()</code>.
    # The returned index is the largest value <i>k</i> such that
    # <blockquote><pre>
    # this.startsWith(str, k)
    # </pre></blockquote>
    # is true.
    # 
    # @param   str   the substring to search for.
    # @return  if the string argument occurs one or more times as a substring
    # within this object, then the index of the first character of
    # the last such substring is returned. If it does not occur as
    # a substring, <code>-1</code> is returned.
    def last_index_of(str)
      return last_index_of(str, @count)
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Returns the index within this string of the last occurrence of the
    # specified substring, searching backward starting at the specified index.
    # The integer returned is the largest value <i>k</i> such that:
    # <blockquote><pre>
    # k &lt;= Math.min(fromIndex, this.length()) && this.startsWith(str, k)
    # </pre></blockquote>
    # If no such value of <i>k</i> exists, then -1 is returned.
    # 
    # @param   str         the substring to search for.
    # @param   fromIndex   the index to start the search from.
    # @return  the index within this string of the last occurrence of the
    # specified substring.
    def last_index_of(str, from_index)
      return last_index_of(@value, @offset, @count, str.attr_value, str.attr_offset, str.attr_count, from_index)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
      # 
      # Code shared by String and StringBuffer to do searches. The
      # source is the character array being searched, and the target
      # is the string being searched for.
      # 
      # @param   source       the characters being searched.
      # @param   sourceOffset offset of the source string.
      # @param   sourceCount  count of the source string.
      # @param   target       the characters being searched for.
      # @param   targetOffset offset of the target string.
      # @param   targetCount  count of the target string.
      # @param   fromIndex    the index to begin searching from.
      def last_index_of(source, source_offset, source_count, target, target_offset, target_count, from_index)
        # 
        # Check arguments; return immediately where possible. For
        # consistency, don't check for null str.
        right_index = source_count - target_count
        if (from_index < 0)
          return -1
        end
        if (from_index > right_index)
          from_index = right_index
        end
        # Empty string always matches.
        if ((target_count).equal?(0))
          return from_index
        end
        str_last_index = target_offset + target_count - 1
        str_last_char = target[str_last_index]
        min_ = source_offset + target_count - 1
        i = min_ + from_index
        while (true)
          catch(:next_start_search_for_last_char) do
            while (i >= min_ && !(source[i]).equal?(str_last_char))
              ((i -= 1) + 1)
            end
            if (i < min_)
              return -1
            end
            j = i - 1
            start = j - (target_count - 1)
            k = str_last_index - 1
            while (j > start)
              if (!(source[((j -= 1) + 1)]).equal?(target[((k -= 1) + 1)]))
                ((i -= 1) + 1)
                throw :next_start_search_for_last_char, :thrown
              end
            end
            return start - source_offset + 1
          end == :thrown or break
        end
      end
    }
    
    typesig { [::Java::Int] }
    # 
    # Returns a new string that is a substring of this string. The
    # substring begins with the character at the specified index and
    # extends to the end of this string. <p>
    # Examples:
    # <blockquote><pre>
    # "unhappy".substring(2) returns "happy"
    # "Harbison".substring(3) returns "bison"
    # "emptiness".substring(9) returns "" (an empty string)
    # </pre></blockquote>
    # 
    # @param      beginIndex   the beginning index, inclusive.
    # @return     the specified substring.
    # @exception  IndexOutOfBoundsException  if
    # <code>beginIndex</code> is negative or larger than the
    # length of this <code>String</code> object.
    def substring(begin_index)
      return substring(begin_index, @count)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns a new string that is a substring of this string. The
    # substring begins at the specified <code>beginIndex</code> and
    # extends to the character at index <code>endIndex - 1</code>.
    # Thus the length of the substring is <code>endIndex-beginIndex</code>.
    # <p>
    # Examples:
    # <blockquote><pre>
    # "hamburger".substring(4, 8) returns "urge"
    # "smiles".substring(1, 5) returns "mile"
    # </pre></blockquote>
    # 
    # @param      beginIndex   the beginning index, inclusive.
    # @param      endIndex     the ending index, exclusive.
    # @return     the specified substring.
    # @exception  IndexOutOfBoundsException  if the
    # <code>beginIndex</code> is negative, or
    # <code>endIndex</code> is larger than the length of
    # this <code>String</code> object, or
    # <code>beginIndex</code> is larger than
    # <code>endIndex</code>.
    def substring(begin_index, end_index)
      if (begin_index < 0)
        raise StringIndexOutOfBoundsException.new(begin_index)
      end
      if (end_index > @count)
        raise StringIndexOutOfBoundsException.new(end_index)
      end
      if (begin_index > end_index)
        raise StringIndexOutOfBoundsException.new(end_index - begin_index)
      end
      return (((begin_index).equal?(0)) && ((end_index).equal?(@count))) ? self : String.new(@offset + begin_index, end_index - begin_index, @value)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Returns a new character sequence that is a subsequence of this sequence.
    # 
    # <p> An invocation of this method of the form
    # 
    # <blockquote><pre>
    # str.subSequence(begin,&nbsp;end)</pre></blockquote>
    # 
    # behaves in exactly the same way as the invocation
    # 
    # <blockquote><pre>
    # str.substring(begin,&nbsp;end)</pre></blockquote>
    # 
    # This method is defined so that the <tt>String</tt> class can implement
    # the {@link CharSequence} interface. </p>
    # 
    # @param      beginIndex   the begin index, inclusive.
    # @param      endIndex     the end index, exclusive.
    # @return     the specified subsequence.
    # 
    # @throws  IndexOutOfBoundsException
    # if <tt>beginIndex</tt> or <tt>endIndex</tt> are negative,
    # if <tt>endIndex</tt> is greater than <tt>length()</tt>,
    # or if <tt>beginIndex</tt> is greater than <tt>startIndex</tt>
    # 
    # @since 1.4
    # @spec JSR-51
    def sub_sequence(begin_index, end_index)
      return self.substring(begin_index, end_index)
    end
    
    typesig { [String] }
    # 
    # Concatenates the specified string to the end of this string.
    # <p>
    # If the length of the argument string is <code>0</code>, then this
    # <code>String</code> object is returned. Otherwise, a new
    # <code>String</code> object is created, representing a character
    # sequence that is the concatenation of the character sequence
    # represented by this <code>String</code> object and the character
    # sequence represented by the argument string.<p>
    # Examples:
    # <blockquote><pre>
    # "cares".concat("s") returns "caress"
    # "to".concat("get").concat("her") returns "together"
    # </pre></blockquote>
    # 
    # @param   str   the <code>String</code> that is concatenated to the end
    # of this <code>String</code>.
    # @return  a string that represents the concatenation of this object's
    # characters followed by the string argument's characters.
    def concat(str)
      other_len = str.length
      if ((other_len).equal?(0))
        return self
      end
      buf = CharArray.new(@count + other_len)
      get_chars(0, @count, buf, 0)
      str.get_chars(0, other_len, buf, @count)
      return String.new(0, @count + other_len, buf)
    end
    
    typesig { [::Java::Char, ::Java::Char] }
    # 
    # Returns a new string resulting from replacing all occurrences of
    # <code>oldChar</code> in this string with <code>newChar</code>.
    # <p>
    # If the character <code>oldChar</code> does not occur in the
    # character sequence represented by this <code>String</code> object,
    # then a reference to this <code>String</code> object is returned.
    # Otherwise, a new <code>String</code> object is created that
    # represents a character sequence identical to the character sequence
    # represented by this <code>String</code> object, except that every
    # occurrence of <code>oldChar</code> is replaced by an occurrence
    # of <code>newChar</code>.
    # <p>
    # Examples:
    # <blockquote><pre>
    # "mesquite in your cellar".replace('e', 'o')
    # returns "mosquito in your collar"
    # "the war of baronets".replace('r', 'y')
    # returns "the way of bayonets"
    # "sparring with a purple porpoise".replace('p', 't')
    # returns "starring with a turtle tortoise"
    # "JonL".replace('q', 'x') returns "JonL" (no change)
    # </pre></blockquote>
    # 
    # @param   oldChar   the old character.
    # @param   newChar   the new character.
    # @return  a string derived from this string by replacing every
    # occurrence of <code>oldChar</code> with <code>newChar</code>.
    def replace(old_char, new_char)
      if (!(old_char).equal?(new_char))
        len = @count
        i = -1
        val = @value
        # avoid getfield opcode
        off = @offset
        # avoid getfield opcode
        while ((i += 1) < len)
          if ((val[off + i]).equal?(old_char))
            break
          end
        end
        if (i < len)
          buf = CharArray.new(len)
          j = 0
          while j < i
            buf[j] = val[off + j]
            ((j += 1) - 1)
          end
          while (i < len)
            c = val[off + i]
            buf[i] = ((c).equal?(old_char)) ? new_char : c
            ((i += 1) - 1)
          end
          return String.new(0, len, buf)
        end
      end
      return self
    end
    
    typesig { [String] }
    # 
    # Tells whether or not this string matches the given <a
    # href="../util/regex/Pattern.html#sum">regular expression</a>.
    # 
    # <p> An invocation of this method of the form
    # <i>str</i><tt>.matches(</tt><i>regex</i><tt>)</tt> yields exactly the
    # same result as the expression
    # 
    # <blockquote><tt> {@link java.util.regex.Pattern}.{@link
    # java.util.regex.Pattern#matches(String,CharSequence)
    # matches}(</tt><i>regex</i><tt>,</tt> <i>str</i><tt>)</tt></blockquote>
    # 
    # @param   regex
    # the regular expression to which this string is to be matched
    # 
    # @return  <tt>true</tt> if, and only if, this string matches the
    # given regular expression
    # 
    # @throws  PatternSyntaxException
    # if the regular expression's syntax is invalid
    # 
    # @see java.util.regex.Pattern
    # 
    # @since 1.4
    # @spec JSR-51
    def matches(regex)
      return Pattern.matches(regex, self)
    end
    
    typesig { [CharSequence] }
    # 
    # Returns true if and only if this string contains the specified
    # sequence of char values.
    # 
    # @param s the sequence to search for
    # @return true if this string contains <code>s</code>, false otherwise
    # @throws NullPointerException if <code>s</code> is <code>null</code>
    # @since 1.5
    def contains(s)
      return index_of(s.to_s) > -1
    end
    
    typesig { [String, String] }
    # 
    # Replaces the first substring of this string that matches the given <a
    # href="../util/regex/Pattern.html#sum">regular expression</a> with the
    # given replacement.
    # 
    # <p> An invocation of this method of the form
    # <i>str</i><tt>.replaceFirst(</tt><i>regex</i><tt>,</tt> <i>repl</i><tt>)</tt>
    # yields exactly the same result as the expression
    # 
    # <blockquote><tt>
    # {@link java.util.regex.Pattern}.{@link java.util.regex.Pattern#compile
    # compile}(</tt><i>regex</i><tt>).{@link
    # java.util.regex.Pattern#matcher(java.lang.CharSequence)
    # matcher}(</tt><i>str</i><tt>).{@link java.util.regex.Matcher#replaceFirst
    # replaceFirst}(</tt><i>repl</i><tt>)</tt></blockquote>
    # 
    # <p>
    # Note that backslashes (<tt>\</tt>) and dollar signs (<tt>$</tt>) in the
    # replacement string may cause the results to be different than if it were
    # being treated as a literal replacement string; see
    # {@link java.util.regex.Matcher#replaceFirst}.
    # Use {@link java.util.regex.Matcher#quoteReplacement} to suppress the special
    # meaning of these characters, if desired.
    # 
    # @param   regex
    # the regular expression to which this string is to be matched
    # @param   replacement
    # the string to be substituted for the first match
    # 
    # @return  The resulting <tt>String</tt>
    # 
    # @throws  PatternSyntaxException
    # if the regular expression's syntax is invalid
    # 
    # @see java.util.regex.Pattern
    # 
    # @since 1.4
    # @spec JSR-51
    def replace_first(regex, replacement)
      return Pattern.compile(regex).matcher(self).replace_first(replacement)
    end
    
    typesig { [String, String] }
    # 
    # Replaces each substring of this string that matches the given <a
    # href="../util/regex/Pattern.html#sum">regular expression</a> with the
    # given replacement.
    # 
    # <p> An invocation of this method of the form
    # <i>str</i><tt>.replaceAll(</tt><i>regex</i><tt>,</tt> <i>repl</i><tt>)</tt>
    # yields exactly the same result as the expression
    # 
    # <blockquote><tt>
    # {@link java.util.regex.Pattern}.{@link java.util.regex.Pattern#compile
    # compile}(</tt><i>regex</i><tt>).{@link
    # java.util.regex.Pattern#matcher(java.lang.CharSequence)
    # matcher}(</tt><i>str</i><tt>).{@link java.util.regex.Matcher#replaceAll
    # replaceAll}(</tt><i>repl</i><tt>)</tt></blockquote>
    # 
    # <p>
    # Note that backslashes (<tt>\</tt>) and dollar signs (<tt>$</tt>) in the
    # replacement string may cause the results to be different than if it were
    # being treated as a literal replacement string; see
    # {@link java.util.regex.Matcher#replaceAll Matcher.replaceAll}.
    # Use {@link java.util.regex.Matcher#quoteReplacement} to suppress the special
    # meaning of these characters, if desired.
    # 
    # @param   regex
    # the regular expression to which this string is to be matched
    # @param   replacement
    # the string to be substituted for each match
    # 
    # @return  The resulting <tt>String</tt>
    # 
    # @throws  PatternSyntaxException
    # if the regular expression's syntax is invalid
    # 
    # @see java.util.regex.Pattern
    # 
    # @since 1.4
    # @spec JSR-51
    def replace_all(regex, replacement)
      return Pattern.compile(regex).matcher(self).replace_all(replacement)
    end
    
    typesig { [CharSequence, CharSequence] }
    # 
    # Replaces each substring of this string that matches the literal target
    # sequence with the specified literal replacement sequence. The
    # replacement proceeds from the beginning of the string to the end, for
    # example, replacing "aa" with "b" in the string "aaa" will result in
    # "ba" rather than "ab".
    # 
    # @param  target The sequence of char values to be replaced
    # @param  replacement The replacement sequence of char values
    # @return  The resulting string
    # @throws NullPointerException if <code>target</code> or
    # <code>replacement</code> is <code>null</code>.
    # @since 1.5
    def replace(target, replacement)
      return Pattern.compile(target.to_s, Pattern::LITERAL).matcher(self).replace_all(Matcher.quote_replacement(replacement.to_s))
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Splits this string around matches of the given
    # <a href="../util/regex/Pattern.html#sum">regular expression</a>.
    # 
    # <p> The array returned by this method contains each substring of this
    # string that is terminated by another substring that matches the given
    # expression or is terminated by the end of the string.  The substrings in
    # the array are in the order in which they occur in this string.  If the
    # expression does not match any part of the input then the resulting array
    # has just one element, namely this string.
    # 
    # <p> The <tt>limit</tt> parameter controls the number of times the
    # pattern is applied and therefore affects the length of the resulting
    # array.  If the limit <i>n</i> is greater than zero then the pattern
    # will be applied at most <i>n</i>&nbsp;-&nbsp;1 times, the array's
    # length will be no greater than <i>n</i>, and the array's last entry
    # will contain all input beyond the last matched delimiter.  If <i>n</i>
    # is non-positive then the pattern will be applied as many times as
    # possible and the array can have any length.  If <i>n</i> is zero then
    # the pattern will be applied as many times as possible, the array can
    # have any length, and trailing empty strings will be discarded.
    # 
    # <p> The string <tt>"boo:and:foo"</tt>, for example, yields the
    # following results with these parameters:
    # 
    # <blockquote><table cellpadding=1 cellspacing=0 summary="Split example showing regex, limit, and result">
    # <tr>
    # <th>Regex</th>
    # <th>Limit</th>
    # <th>Result</th>
    # </tr>
    # <tr><td align=center>:</td>
    # <td align=center>2</td>
    # <td><tt>{ "boo", "and:foo" }</tt></td></tr>
    # <tr><td align=center>:</td>
    # <td align=center>5</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>:</td>
    # <td align=center>-2</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>5</td>
    # <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>-2</td>
    # <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>0</td>
    # <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
    # </table></blockquote>
    # 
    # <p> An invocation of this method of the form
    # <i>str.</i><tt>split(</tt><i>regex</i><tt>,</tt>&nbsp;<i>n</i><tt>)</tt>
    # yields the same result as the expression
    # 
    # <blockquote>
    # {@link java.util.regex.Pattern}.{@link java.util.regex.Pattern#compile
    # compile}<tt>(</tt><i>regex</i><tt>)</tt>.{@link
    # java.util.regex.Pattern#split(java.lang.CharSequence,int)
    # split}<tt>(</tt><i>str</i><tt>,</tt>&nbsp;<i>n</i><tt>)</tt>
    # </blockquote>
    # 
    # 
    # @param  regex
    # the delimiting regular expression
    # 
    # @param  limit
    # the result threshold, as described above
    # 
    # @return  the array of strings computed by splitting this string
    # around matches of the given regular expression
    # 
    # @throws  PatternSyntaxException
    # if the regular expression's syntax is invalid
    # 
    # @see java.util.regex.Pattern
    # 
    # @since 1.4
    # @spec JSR-51
    def split(regex, limit)
      return Pattern.compile(regex).split(Regexp.new(self))
    end
    
    typesig { [String] }
    # 
    # Splits this string around matches of the given <a
    # href="../util/regex/Pattern.html#sum">regular expression</a>.
    # 
    # <p> This method works as if by invoking the two-argument {@link
    # #split(String, int) split} method with the given expression and a limit
    # argument of zero.  Trailing empty strings are therefore not included in
    # the resulting array.
    # 
    # <p> The string <tt>"boo:and:foo"</tt>, for example, yields the following
    # results with these expressions:
    # 
    # <blockquote><table cellpadding=1 cellspacing=0 summary="Split examples showing regex and result">
    # <tr>
    # <th>Regex</th>
    # <th>Result</th>
    # </tr>
    # <tr><td align=center>:</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
    # </table></blockquote>
    # 
    # 
    # @param  regex
    # the delimiting regular expression
    # 
    # @return  the array of strings computed by splitting this string
    # around matches of the given regular expression
    # 
    # @throws  PatternSyntaxException
    # if the regular expression's syntax is invalid
    # 
    # @see java.util.regex.Pattern
    # 
    # @since 1.4
    # @spec JSR-51
    def split(regex)
      return split(regex, 0)
    end
    
    typesig { [Locale] }
    # 
    # Converts all of the characters in this <code>String</code> to lower
    # case using the rules of the given <code>Locale</code>.  Case mapping is based
    # on the Unicode Standard version specified by the {@link java.lang.Character Character}
    # class. Since case mappings are not always 1:1 char mappings, the resulting
    # <code>String</code> may be a different length than the original <code>String</code>.
    # <p>
    # Examples of lowercase  mappings are in the following table:
    # <table border="1" summary="Lowercase mapping examples showing language code of locale, upper case, lower case, and description">
    # <tr>
    # <th>Language Code of Locale</th>
    # <th>Upper Case</th>
    # <th>Lower Case</th>
    # <th>Description</th>
    # </tr>
    # <tr>
    # <td>tr (Turkish)</td>
    # <td>&#92;u0130</td>
    # <td>&#92;u0069</td>
    # <td>capital letter I with dot above -&gt; small letter i</td>
    # </tr>
    # <tr>
    # <td>tr (Turkish)</td>
    # <td>&#92;u0049</td>
    # <td>&#92;u0131</td>
    # <td>capital letter I -&gt; small letter dotless i </td>
    # </tr>
    # <tr>
    # <td>(all)</td>
    # <td>French Fries</td>
    # <td>french fries</td>
    # <td>lowercased all chars in String</td>
    # </tr>
    # <tr>
    # <td>(all)</td>
    # <td><img src="doc-files/capiota.gif" alt="capiota"><img src="doc-files/capchi.gif" alt="capchi">
    # <img src="doc-files/captheta.gif" alt="captheta"><img src="doc-files/capupsil.gif" alt="capupsil">
    # <img src="doc-files/capsigma.gif" alt="capsigma"></td>
    # <td><img src="doc-files/iota.gif" alt="iota"><img src="doc-files/chi.gif" alt="chi">
    # <img src="doc-files/theta.gif" alt="theta"><img src="doc-files/upsilon.gif" alt="upsilon">
    # <img src="doc-files/sigma1.gif" alt="sigma"></td>
    # <td>lowercased all chars in String</td>
    # </tr>
    # </table>
    # 
    # @param locale use the case transformation rules for this locale
    # @return the <code>String</code>, converted to lowercase.
    # @see     java.lang.String#toLowerCase()
    # @see     java.lang.String#toUpperCase()
    # @see     java.lang.String#toUpperCase(Locale)
    # @since   1.1
    def to_lower_case(locale)
      if ((locale).nil?)
        raise NullPointerException.new
      end
      first_upper = 0
      catch(:break_scan) do
        # Now check if there are any characters that need to be changed.
        first_upper = 0
        while first_upper < @count
          c = @value[@offset + first_upper]
          if ((c >= Character::MIN_HIGH_SURROGATE) && (c <= Character::MAX_HIGH_SURROGATE))
            suppl_char = code_point_at(first_upper)
            if (!(suppl_char).equal?(Character.to_lower_case(suppl_char)))
              throw :break_scan, :thrown
            end
            first_upper += Character.char_count(suppl_char)
          else
            if (!(c).equal?(Character.to_lower_case(c)))
              throw :break_scan, :thrown
            end
            ((first_upper += 1) - 1)
          end
        end
        return self
      end
      result = CharArray.new(@count)
      result_offset = 0
      # result may grow, so i+resultOffset
      # is the write location in result
      # Just copy the first few lowerCase characters.
      System.arraycopy(@value, @offset, result, 0, first_upper)
      lang = locale.get_language
      locale_dependent = ((lang).equal?("tr") || (lang).equal?("az") || (lang).equal?("lt"))
      lower_char_array = nil
      lower_char = 0
      src_char = 0
      src_count = 0
      i = first_upper
      while i < @count
        src_char = RJava.cast_to_int(@value[@offset + i])
        if (RJava.cast_to_char(src_char) >= Character::MIN_HIGH_SURROGATE && RJava.cast_to_char(src_char) <= Character::MAX_HIGH_SURROGATE)
          src_char = code_point_at(i)
          src_count = Character.char_count(src_char)
        else
          src_count = 1
        end
        if (locale_dependent || (src_char).equal?(Character.new(0x03A3)))
          # GREEK CAPITAL LETTER SIGMA
          lower_char = ConditionalSpecialCasing.to_lower_case_ex(self, i, locale)
        else
          lower_char = Character.to_lower_case(src_char)
        end
        if (((lower_char).equal?(Character::ERROR)) || (lower_char >= Character::MIN_SUPPLEMENTARY_CODE_POINT))
          if ((lower_char).equal?(Character::ERROR))
            lower_char_array = ConditionalSpecialCasing.to_lower_case_char_array(self, i, locale)
          else
            if ((src_count).equal?(2))
              result_offset += Character.to_chars(lower_char, result, i + result_offset) - src_count
              i += src_count
              next
            else
              lower_char_array = Character.to_chars(lower_char)
            end
          end
          # Grow result if needed
          map_len = lower_char_array.attr_length
          if (map_len > src_count)
            result2 = CharArray.new(result.attr_length + map_len - src_count)
            System.arraycopy(result, 0, result2, 0, i + result_offset)
            result = result2
          end
          x = 0
          while x < map_len
            result[i + result_offset + x] = lower_char_array[x]
            (x += 1)
          end
          result_offset += (map_len - src_count)
        else
          result[i + result_offset] = RJava.cast_to_char(lower_char)
        end
        i += src_count
      end
      return String.new(0, @count + result_offset, result)
    end
    
    typesig { [] }
    # 
    # Converts all of the characters in this <code>String</code> to lower
    # case using the rules of the default locale. This is equivalent to calling
    # <code>toLowerCase(Locale.getDefault())</code>.
    # <p>
    # <b>Note:</b> This method is locale sensitive, and may produce unexpected
    # results if used for strings that are intended to be interpreted locale
    # independently.
    # Examples are programming language identifiers, protocol keys, and HTML
    # tags.
    # For instance, <code>"TITLE".toLowerCase()</code> in a Turkish locale
    # returns <code>"t\u0131tle"</code>, where '\u0131' is the LATIN SMALL
    # LETTER DOTLESS I character.
    # To obtain correct results for locale insensitive strings, use
    # <code>toLowerCase(Locale.ENGLISH)</code>.
    # <p>
    # @return  the <code>String</code>, converted to lowercase.
    # @see     java.lang.String#toLowerCase(Locale)
    def to_lower_case
      return to_lower_case(Locale.get_default)
    end
    
    typesig { [Locale] }
    # 
    # Converts all of the characters in this <code>String</code> to upper
    # case using the rules of the given <code>Locale</code>. Case mapping is based
    # on the Unicode Standard version specified by the {@link java.lang.Character Character}
    # class. Since case mappings are not always 1:1 char mappings, the resulting
    # <code>String</code> may be a different length than the original <code>String</code>.
    # <p>
    # Examples of locale-sensitive and 1:M case mappings are in the following table.
    # <p>
    # <table border="1" summary="Examples of locale-sensitive and 1:M case mappings. Shows Language code of locale, lower case, upper case, and description.">
    # <tr>
    # <th>Language Code of Locale</th>
    # <th>Lower Case</th>
    # <th>Upper Case</th>
    # <th>Description</th>
    # </tr>
    # <tr>
    # <td>tr (Turkish)</td>
    # <td>&#92;u0069</td>
    # <td>&#92;u0130</td>
    # <td>small letter i -&gt; capital letter I with dot above</td>
    # </tr>
    # <tr>
    # <td>tr (Turkish)</td>
    # <td>&#92;u0131</td>
    # <td>&#92;u0049</td>
    # <td>small letter dotless i -&gt; capital letter I</td>
    # </tr>
    # <tr>
    # <td>(all)</td>
    # <td>&#92;u00df</td>
    # <td>&#92;u0053 &#92;u0053</td>
    # <td>small letter sharp s -&gt; two letters: SS</td>
    # </tr>
    # <tr>
    # <td>(all)</td>
    # <td>Fahrvergn&uuml;gen</td>
    # <td>FAHRVERGN&Uuml;GEN</td>
    # <td></td>
    # </tr>
    # </table>
    # @param locale use the case transformation rules for this locale
    # @return the <code>String</code>, converted to uppercase.
    # @see     java.lang.String#toUpperCase()
    # @see     java.lang.String#toLowerCase()
    # @see     java.lang.String#toLowerCase(Locale)
    # @since   1.1
    def to_upper_case(locale)
      if ((locale).nil?)
        raise NullPointerException.new
      end
      first_lower = 0
      catch(:break_scan) do
        # Now check if there are any characters that need to be changed.
        first_lower = 0
        while first_lower < @count
          c = RJava.cast_to_int(@value[@offset + first_lower])
          src_count = 0
          if ((c >= Character::MIN_HIGH_SURROGATE) && (c <= Character::MAX_HIGH_SURROGATE))
            c = code_point_at(first_lower)
            src_count = Character.char_count(c)
          else
            src_count = 1
          end
          upper_case_char = Character.to_upper_case_ex(c)
          if (((upper_case_char).equal?(Character::ERROR)) || (!(c).equal?(upper_case_char)))
            throw :break_scan, :thrown
          end
          first_lower += src_count
        end
        return self
      end
      result = CharArray.new(@count)
      # may grow
      result_offset = 0
      # result may grow, so i+resultOffset
      # is the write location in result
      # Just copy the first few upperCase characters.
      System.arraycopy(@value, @offset, result, 0, first_lower)
      lang = locale.get_language
      locale_dependent = ((lang).equal?("tr") || (lang).equal?("az") || (lang).equal?("lt"))
      upper_char_array = nil
      upper_char = 0
      src_char = 0
      src_count_ = 0
      i = first_lower
      while i < @count
        src_char = RJava.cast_to_int(@value[@offset + i])
        if (RJava.cast_to_char(src_char) >= Character::MIN_HIGH_SURROGATE && RJava.cast_to_char(src_char) <= Character::MAX_HIGH_SURROGATE)
          src_char = code_point_at(i)
          src_count_ = Character.char_count(src_char)
        else
          src_count_ = 1
        end
        if (locale_dependent)
          upper_char = ConditionalSpecialCasing.to_upper_case_ex(self, i, locale)
        else
          upper_char = Character.to_upper_case_ex(src_char)
        end
        if (((upper_char).equal?(Character::ERROR)) || (upper_char >= Character::MIN_SUPPLEMENTARY_CODE_POINT))
          if ((upper_char).equal?(Character::ERROR))
            if (locale_dependent)
              upper_char_array = ConditionalSpecialCasing.to_upper_case_char_array(self, i, locale)
            else
              upper_char_array = Character.to_upper_case_char_array(src_char)
            end
          else
            if ((src_count_).equal?(2))
              result_offset += Character.to_chars(upper_char, result, i + result_offset) - src_count_
              i += src_count_
              next
            else
              upper_char_array = Character.to_chars(upper_char)
            end
          end
          # Grow result if needed
          map_len = upper_char_array.attr_length
          if (map_len > src_count_)
            result2 = CharArray.new(result.attr_length + map_len - src_count_)
            System.arraycopy(result, 0, result2, 0, i + result_offset)
            result = result2
          end
          x = 0
          while x < map_len
            result[i + result_offset + x] = upper_char_array[x]
            (x += 1)
          end
          result_offset += (map_len - src_count_)
        else
          result[i + result_offset] = RJava.cast_to_char(upper_char)
        end
        i += src_count_
      end
      return String.new(0, @count + result_offset, result)
    end
    
    typesig { [] }
    # 
    # Converts all of the characters in this <code>String</code> to upper
    # case using the rules of the default locale. This method is equivalent to
    # <code>toUpperCase(Locale.getDefault())</code>.
    # <p>
    # <b>Note:</b> This method is locale sensitive, and may produce unexpected
    # results if used for strings that are intended to be interpreted locale
    # independently.
    # Examples are programming language identifiers, protocol keys, and HTML
    # tags.
    # For instance, <code>"title".toUpperCase()</code> in a Turkish locale
    # returns <code>"T\u0130TLE"</code>, where '\u0130' is the LATIN CAPITAL
    # LETTER I WITH DOT ABOVE character.
    # To obtain correct results for locale insensitive strings, use
    # <code>toUpperCase(Locale.ENGLISH)</code>.
    # <p>
    # @return  the <code>String</code>, converted to uppercase.
    # @see     java.lang.String#toUpperCase(Locale)
    def to_upper_case
      return to_upper_case(Locale.get_default)
    end
    
    typesig { [] }
    # 
    # Returns a copy of the string, with leading and trailing whitespace
    # omitted.
    # <p>
    # If this <code>String</code> object represents an empty character
    # sequence, or the first and last characters of character sequence
    # represented by this <code>String</code> object both have codes
    # greater than <code>'&#92;u0020'</code> (the space character), then a
    # reference to this <code>String</code> object is returned.
    # <p>
    # Otherwise, if there is no character with a code greater than
    # <code>'&#92;u0020'</code> in the string, then a new
    # <code>String</code> object representing an empty string is created
    # and returned.
    # <p>
    # Otherwise, let <i>k</i> be the index of the first character in the
    # string whose code is greater than <code>'&#92;u0020'</code>, and let
    # <i>m</i> be the index of the last character in the string whose code
    # is greater than <code>'&#92;u0020'</code>. A new <code>String</code>
    # object is created, representing the substring of this string that
    # begins with the character at index <i>k</i> and ends with the
    # character at index <i>m</i>-that is, the result of
    # <code>this.substring(<i>k</i>,&nbsp;<i>m</i>+1)</code>.
    # <p>
    # This method may be used to trim whitespace (as defined above) from
    # the beginning and end of a string.
    # 
    # @return  A copy of this string with leading and trailing white
    # space removed, or this string if it has no leading or
    # trailing white space.
    def trim
      len = @count
      st = 0
      off = @offset
      # avoid getfield opcode
      val = @value
      # avoid getfield opcode
      while ((st < len) && (val[off + st] <= Character.new(?\s.ord)))
        ((st += 1) - 1)
      end
      while ((st < len) && (val[off + len - 1] <= Character.new(?\s.ord)))
        ((len -= 1) + 1)
      end
      return ((st > 0) || (len < @count)) ? substring(st, len) : self
    end
    
    typesig { [] }
    # 
    # This object (which is already a string!) is itself returned.
    # 
    # @return  the string itself.
    def to_s
      return self
    end
    
    typesig { [] }
    # 
    # Converts this string to a new character array.
    # 
    # @return  a newly allocated character array whose length is the length
    # of this string and whose contents are initialized to contain
    # the character sequence represented by this string.
    def to_char_array
      result = CharArray.new(@count)
      get_chars(0, @count, result, 0)
      return result
    end
    
    class_module.module_eval {
      typesig { [String, Object] }
      # 
      # Returns a formatted string using the specified format string and
      # arguments.
      # 
      # <p> The locale always used is the one returned by {@link
      # java.util.Locale#getDefault() Locale.getDefault()}.
      # 
      # @param  format
      # A <a href="../util/Formatter.html#syntax">format string</a>
      # 
      # @param  args
      # Arguments referenced by the format specifiers in the format
      # string.  If there are more arguments than format specifiers, the
      # extra arguments are ignored.  The number of arguments is
      # variable and may be zero.  The maximum number of arguments is
      # limited by the maximum dimension of a Java array as defined by
      # the <a href="http://java.sun.com/docs/books/vmspec/">Java
      # Virtual Machine Specification</a>.  The behaviour on a
      # <tt>null</tt> argument depends on the <a
      # href="../util/Formatter.html#syntax">conversion</a>.
      # 
      # @throws  IllegalFormatException
      # If a format string contains an illegal syntax, a format
      # specifier that is incompatible with the given arguments,
      # insufficient arguments given the format string, or other
      # illegal conditions.  For specification of all possible
      # formatting errors, see the <a
      # href="../util/Formatter.html#detail">Details</a> section of the
      # formatter class specification.
      # 
      # @throws  NullPointerException
      # If the <tt>format</tt> is <tt>null</tt>
      # 
      # @return  A formatted string
      # 
      # @see  java.util.Formatter
      # @since  1.5
      def format(format, *args)
        return Formatter.new.format(format, args).to_s
      end
      
      typesig { [Locale, String, Object] }
      # 
      # Returns a formatted string using the specified locale, format string,
      # and arguments.
      # 
      # @param  l
      # The {@linkplain java.util.Locale locale} to apply during
      # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
      # is applied.
      # 
      # @param  format
      # A <a href="../util/Formatter.html#syntax">format string</a>
      # 
      # @param  args
      # Arguments referenced by the format specifiers in the format
      # string.  If there are more arguments than format specifiers, the
      # extra arguments are ignored.  The number of arguments is
      # variable and may be zero.  The maximum number of arguments is
      # limited by the maximum dimension of a Java array as defined by
      # the <a href="http://java.sun.com/docs/books/vmspec/">Java
      # Virtual Machine Specification</a>.  The behaviour on a
      # <tt>null</tt> argument depends on the <a
      # href="../util/Formatter.html#syntax">conversion</a>.
      # 
      # @throws  IllegalFormatException
      # If a format string contains an illegal syntax, a format
      # specifier that is incompatible with the given arguments,
      # insufficient arguments given the format string, or other
      # illegal conditions.  For specification of all possible
      # formatting errors, see the <a
      # href="../util/Formatter.html#detail">Details</a> section of the
      # formatter class specification
      # 
      # @throws  NullPointerException
      # If the <tt>format</tt> is <tt>null</tt>
      # 
      # @return  A formatted string
      # 
      # @see  java.util.Formatter
      # @since  1.5
      def format(l, format, *args)
        return Formatter.new(l).format(format, args).to_s
      end
      
      typesig { [Object] }
      # 
      # Returns the string representation of the <code>Object</code> argument.
      # 
      # @param   obj   an <code>Object</code>.
      # @return  if the argument is <code>null</code>, then a string equal to
      # <code>"null"</code>; otherwise, the value of
      # <code>obj.toString()</code> is returned.
      # @see     java.lang.Object#toString()
      def value_of(obj)
        return ((obj).nil?) ? "null" : obj.to_s
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # 
      # Returns the string representation of the <code>char</code> array
      # argument. The contents of the character array are copied; subsequent
      # modification of the character array does not affect the newly
      # created string.
      # 
      # @param   data   a <code>char</code> array.
      # @return  a newly allocated string representing the same sequence of
      # characters contained in the character array argument.
      def value_of(data)
        return String.new(data)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # 
      # Returns the string representation of a specific subarray of the
      # <code>char</code> array argument.
      # <p>
      # The <code>offset</code> argument is the index of the first
      # character of the subarray. The <code>count</code> argument
      # specifies the length of the subarray. The contents of the subarray
      # are copied; subsequent modification of the character array does not
      # affect the newly created string.
      # 
      # @param   data     the character array.
      # @param   offset   the initial offset into the value of the
      # <code>String</code>.
      # @param   count    the length of the value of the <code>String</code>.
      # @return  a string representing the sequence of characters contained
      # in the subarray of the character array argument.
      # @exception IndexOutOfBoundsException if <code>offset</code> is
      # negative, or <code>count</code> is negative, or
      # <code>offset+count</code> is larger than
      # <code>data.length</code>.
      def value_of(data, offset, count)
        return String.new(data, offset, count)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # 
      # Returns a String that represents the character sequence in the
      # array specified.
      # 
      # @param   data     the character array.
      # @param   offset   initial offset of the subarray.
      # @param   count    length of the subarray.
      # @return  a <code>String</code> that contains the characters of the
      # specified subarray of the character array.
      def copy_value_of(data, offset, count)
        # All public String constructors now copy the data.
        return String.new(data, offset, count)
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # 
      # Returns a String that represents the character sequence in the
      # array specified.
      # 
      # @param   data   the character array.
      # @return  a <code>String</code> that contains the characters of the
      # character array.
      def copy_value_of(data)
        return copy_value_of(data, 0, data.attr_length)
      end
      
      typesig { [::Java::Boolean] }
      # 
      # Returns the string representation of the <code>boolean</code> argument.
      # 
      # @param   b   a <code>boolean</code>.
      # @return  if the argument is <code>true</code>, a string equal to
      # <code>"true"</code> is returned; otherwise, a string equal to
      # <code>"false"</code> is returned.
      def value_of(b)
        return b ? "true" : "false"
      end
      
      typesig { [::Java::Char] }
      # 
      # Returns the string representation of the <code>char</code>
      # argument.
      # 
      # @param   c   a <code>char</code>.
      # @return  a string of length <code>1</code> containing
      # as its single character the argument <code>c</code>.
      def value_of(c)
        data = Array.typed(::Java::Char).new([c])
        return String.new(0, 1, data)
      end
      
      typesig { [::Java::Int] }
      # 
      # Returns the string representation of the <code>int</code> argument.
      # <p>
      # The representation is exactly the one returned by the
      # <code>Integer.toString</code> method of one argument.
      # 
      # @param   i   an <code>int</code>.
      # @return  a string representation of the <code>int</code> argument.
      # @see     java.lang.Integer#toString(int, int)
      def value_of(i)
        return JavaInteger.to_s(i, 10)
      end
      
      typesig { [::Java::Long] }
      # 
      # Returns the string representation of the <code>long</code> argument.
      # <p>
      # The representation is exactly the one returned by the
      # <code>Long.toString</code> method of one argument.
      # 
      # @param   l   a <code>long</code>.
      # @return  a string representation of the <code>long</code> argument.
      # @see     java.lang.Long#toString(long)
      def value_of(l)
        return Long.to_s(l, 10)
      end
      
      typesig { [::Java::Float] }
      # 
      # Returns the string representation of the <code>float</code> argument.
      # <p>
      # The representation is exactly the one returned by the
      # <code>Float.toString</code> method of one argument.
      # 
      # @param   f   a <code>float</code>.
      # @return  a string representation of the <code>float</code> argument.
      # @see     java.lang.Float#toString(float)
      def value_of(f)
        return Float.to_s(f)
      end
      
      typesig { [::Java::Double] }
      # 
      # Returns the string representation of the <code>double</code> argument.
      # <p>
      # The representation is exactly the one returned by the
      # <code>Double.toString</code> method of one argument.
      # 
      # @param   d   a <code>double</code>.
      # @return  a  string representation of the <code>double</code> argument.
      # @see     java.lang.Double#toString(double)
      def value_of(d)
        return Double.to_s(d)
      end
    }
    
    JNI.native_method :Java_java_lang_String_intern, [:pointer, :long], :long
    typesig { [] }
    # 
    # Returns a canonical representation for the string object.
    # <p>
    # A pool of strings, initially empty, is maintained privately by the
    # class <code>String</code>.
    # <p>
    # When the intern method is invoked, if the pool already contains a
    # string equal to this <code>String</code> object as determined by
    # the {@link #equals(Object)} method, then the string from the pool is
    # returned. Otherwise, this <code>String</code> object is added to the
    # pool and a reference to this <code>String</code> object is returned.
    # <p>
    # It follows that for any two strings <code>s</code> and <code>t</code>,
    # <code>s.intern()&nbsp;==&nbsp;t.intern()</code> is <code>true</code>
    # if and only if <code>s.equals(t)</code> is <code>true</code>.
    # <p>
    # All literal strings and string-valued constant expressions are
    # interned. String literals are defined in &sect;3.10.5 of the
    # <a href="http://java.sun.com/docs/books/jls/html/">Java Language
    # Specification</a>
    # 
    # @return  a string that has the same contents as this string, but is
    # guaranteed to be from a pool of unique strings.
    def intern
      JNI.__send__(:Java_java_lang_String_intern, JNI.env, self.jni_id)
    end
    
    private
    alias_method :initialize__string, :initialize
  end
  
end

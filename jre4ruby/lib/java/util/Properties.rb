require "rjava"

# 
# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module PropertiesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :PrintWriter
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :Writer
      include_const ::Java::Io, :OutputStreamWriter
      include_const ::Java::Io, :BufferedWriter
    }
  end
  
  # 
  # The <code>Properties</code> class represents a persistent set of
  # properties. The <code>Properties</code> can be saved to a stream
  # or loaded from a stream. Each key and its corresponding value in
  # the property list is a string.
  # <p>
  # A property list can contain another property list as its
  # "defaults"; this second property list is searched if
  # the property key is not found in the original property list.
  # <p>
  # Because <code>Properties</code> inherits from <code>Hashtable</code>, the
  # <code>put</code> and <code>putAll</code> methods can be applied to a
  # <code>Properties</code> object.  Their use is strongly discouraged as they
  # allow the caller to insert entries whose keys or values are not
  # <code>Strings</code>.  The <code>setProperty</code> method should be used
  # instead.  If the <code>store</code> or <code>save</code> method is called
  # on a "compromised" <code>Properties</code> object that contains a
  # non-<code>String</code> key or value, the call will fail. Similarly,
  # the call to the <code>propertyNames</code> or <code>list</code> method
  # will fail if it is called on a "compromised" <code>Properties</code>
  # object that contains a non-<code>String</code> key.
  # 
  # <p>
  # The {@link #load(java.io.Reader) load(Reader)} <tt>/</tt>
  # {@link #store(java.io.Writer, java.lang.String) store(Writer, String)}
  # methods load and store properties from and to a character based stream
  # in a simple line-oriented format specified below.
  # 
  # The {@link #load(java.io.InputStream) load(InputStream)} <tt>/</tt>
  # {@link #store(java.io.OutputStream, java.lang.String) store(OutputStream, String)}
  # methods work the same way as the load(Reader)/store(Writer, String) pair, except
  # the input/output stream is encoded in ISO 8859-1 character encoding.
  # Characters that cannot be directly represented in this encoding can be written using
  # <a href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.3">Unicode escapes</a>
  # ; only a single 'u' character is allowed in an escape
  # sequence. The native2ascii tool can be used to convert property files to and
  # from other character encodings.
  # 
  # <p> The {@link #loadFromXML(InputStream)} and {@link
  # #storeToXML(OutputStream, String, String)} methods load and store properties
  # in a simple XML format.  By default the UTF-8 character encoding is used,
  # however a specific encoding may be specified if required.  An XML properties
  # document has the following DOCTYPE declaration:
  # 
  # <pre>
  # &lt;!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd"&gt;
  # </pre>
  # Note that the system URI (http://java.sun.com/dtd/properties.dtd) is
  # <i>not</i> accessed when exporting or importing properties; it merely
  # serves as a string to uniquely identify the DTD, which is:
  # <pre>
  # &lt;?xml version="1.0" encoding="UTF-8"?&gt;
  # 
  # &lt;!-- DTD for properties --&gt;
  # 
  # &lt;!ELEMENT properties ( comment?, entry* ) &gt;
  # 
  # &lt;!ATTLIST properties version CDATA #FIXED "1.0"&gt;
  # 
  # &lt;!ELEMENT comment (#PCDATA) &gt;
  # 
  # &lt;!ELEMENT entry (#PCDATA) &gt;
  # 
  # &lt;!ATTLIST entry key CDATA #REQUIRED&gt;
  # </pre>
  # 
  # @see <a href="../../../technotes/tools/solaris/native2ascii.html">native2ascii tool for Solaris</a>
  # @see <a href="../../../technotes/tools/windows/native2ascii.html">native2ascii tool for Windows</a>
  # 
  # <p>This class is thread-safe: multiple threads can share a single
  # <tt>Properties</tt> object without the need for external synchronization.
  # 
  # @author  Arthur van Hoff
  # @author  Michael McCloskey
  # @author  Xueming Shen
  # @since   JDK1.0
  class Properties < PropertiesImports.const_get :Hashtable
    include_class_members PropertiesImports
    
    class_module.module_eval {
      # 
      # use serialVersionUID from JDK 1.1.X for interoperability
      const_set_lazy(:SerialVersionUID) { 4112578634029874840 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # A property list that contains default values for any keys not
    # found in this property list.
    # 
    # @serial
    attr_accessor :defaults
    alias_method :attr_defaults, :defaults
    undef_method :defaults
    alias_method :attr_defaults=, :defaults=
    undef_method :defaults=
    
    typesig { [] }
    # 
    # Creates an empty property list with no default values.
    def initialize
      initialize__properties(nil)
    end
    
    typesig { [Properties] }
    # 
    # Creates an empty property list with the specified defaults.
    # 
    # @param   defaults   the defaults.
    def initialize(defaults)
      @defaults = nil
      super()
      @defaults = defaults
    end
    
    typesig { [String, String] }
    # 
    # Calls the <tt>Hashtable</tt> method <code>put</code>. Provided for
    # parallelism with the <tt>getProperty</tt> method. Enforces use of
    # strings for property keys and values. The value returned is the
    # result of the <tt>Hashtable</tt> call to <code>put</code>.
    # 
    # @param key the key to be placed into this property list.
    # @param value the value corresponding to <tt>key</tt>.
    # @return     the previous value of the specified key in this property
    # list, or <code>null</code> if it did not have one.
    # @see #getProperty
    # @since    1.2
    def set_property(key, value)
      synchronized(self) do
        return put(key, value)
      end
    end
    
    typesig { [Reader] }
    # 
    # Reads a property list (key and element pairs) from the input
    # character stream in a simple line-oriented format.
    # <p>
    # Properties are processed in terms of lines. There are two
    # kinds of line, <i>natural lines</i> and <i>logical lines</i>.
    # A natural line is defined as a line of
    # characters that is terminated either by a set of line terminator
    # characters (<code>\n</code> or <code>\r</code> or <code>\r\n</code>)
    # or by the end of the stream. A natural line may be either a blank line,
    # a comment line, or hold all or some of a key-element pair. A logical
    # line holds all the data of a key-element pair, which may be spread
    # out across several adjacent natural lines by escaping
    # the line terminator sequence with a backslash character
    # <code>\</code>.  Note that a comment line cannot be extended
    # in this manner; every natural line that is a comment must have
    # its own comment indicator, as described below. Lines are read from
    # input until the end of the stream is reached.
    # 
    # <p>
    # A natural line that contains only white space characters is
    # considered blank and is ignored.  A comment line has an ASCII
    # <code>'#'</code> or <code>'!'</code> as its first non-white
    # space character; comment lines are also ignored and do not
    # encode key-element information.  In addition to line
    # terminators, this format considers the characters space
    # (<code>' '</code>, <code>'&#92;u0020'</code>), tab
    # (<code>'\t'</code>, <code>'&#92;u0009'</code>), and form feed
    # (<code>'\f'</code>, <code>'&#92;u000C'</code>) to be white
    # space.
    # 
    # <p>
    # If a logical line is spread across several natural lines, the
    # backslash escaping the line terminator sequence, the line
    # terminator sequence, and any white space at the start of the
    # following line have no affect on the key or element values.
    # The remainder of the discussion of key and element parsing
    # (when loading) will assume all the characters constituting
    # the key and element appear on a single natural line after
    # line continuation characters have been removed.  Note that
    # it is <i>not</i> sufficient to only examine the character
    # preceding a line terminator sequence to decide if the line
    # terminator is escaped; there must be an odd number of
    # contiguous backslashes for the line terminator to be escaped.
    # Since the input is processed from left to right, a
    # non-zero even number of 2<i>n</i> contiguous backslashes
    # before a line terminator (or elsewhere) encodes <i>n</i>
    # backslashes after escape processing.
    # 
    # <p>
    # The key contains all of the characters in the line starting
    # with the first non-white space character and up to, but not
    # including, the first unescaped <code>'='</code>,
    # <code>':'</code>, or white space character other than a line
    # terminator. All of these key termination characters may be
    # included in the key by escaping them with a preceding backslash
    # character; for example,<p>
    # 
    # <code>\:\=</code><p>
    # 
    # would be the two-character key <code>":="</code>.  Line
    # terminator characters can be included using <code>\r</code> and
    # <code>\n</code> escape sequences.  Any white space after the
    # key is skipped; if the first non-white space character after
    # the key is <code>'='</code> or <code>':'</code>, then it is
    # ignored and any white space characters after it are also
    # skipped.  All remaining characters on the line become part of
    # the associated element string; if there are no remaining
    # characters, the element is the empty string
    # <code>&quot;&quot;</code>.  Once the raw character sequences
    # constituting the key and element are identified, escape
    # processing is performed as described above.
    # 
    # <p>
    # As an example, each of the following three lines specifies the key
    # <code>"Truth"</code> and the associated element value
    # <code>"Beauty"</code>:
    # <p>
    # <pre>
    # Truth = Beauty
    # Truth:Beauty
    # Truth                    :Beauty
    # </pre>
    # As another example, the following three lines specify a single
    # property:
    # <p>
    # <pre>
    # fruits                           apple, banana, pear, \
    # cantaloupe, watermelon, \
    # kiwi, mango
    # </pre>
    # The key is <code>"fruits"</code> and the associated element is:
    # <p>
    # <pre>"apple, banana, pear, cantaloupe, watermelon, kiwi, mango"</pre>
    # Note that a space appears before each <code>\</code> so that a space
    # will appear after each comma in the final result; the <code>\</code>,
    # line terminator, and leading white space on the continuation line are
    # merely discarded and are <i>not</i> replaced by one or more other
    # characters.
    # <p>
    # As a third example, the line:
    # <p>
    # <pre>cheeses
    # </pre>
    # specifies that the key is <code>"cheeses"</code> and the associated
    # element is the empty string <code>""</code>.<p>
    # <p>
    # 
    # <a name="unicodeescapes"></a>
    # Characters in keys and elements can be represented in escape
    # sequences similar to those used for character and string literals
    # (see <a
    # href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.3">&sect;3.3</a>
    # and <a
    # href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.10.6">&sect;3.10.6</a>
    # of the <i>Java Language Specification</i>).
    # 
    # The differences from the character escape sequences and Unicode
    # escapes used for characters and strings are:
    # 
    # <ul>
    # <li> Octal escapes are not recognized.
    # 
    # <li> The character sequence <code>\b</code> does <i>not</i>
    # represent a backspace character.
    # 
    # <li> The method does not treat a backslash character,
    # <code>\</code>, before a non-valid escape character as an
    # error; the backslash is silently dropped.  For example, in a
    # Java string the sequence <code>"\z"</code> would cause a
    # compile time error.  In contrast, this method silently drops
    # the backslash.  Therefore, this method treats the two character
    # sequence <code>"\b"</code> as equivalent to the single
    # character <code>'b'</code>.
    # 
    # <li> Escapes are not necessary for single and double quotes;
    # however, by the rule above, single and double quote characters
    # preceded by a backslash still yield single and double quote
    # characters, respectively.
    # 
    # <li> Only a single 'u' character is allowed in a Uniocde escape
    # sequence.
    # 
    # </ul>
    # <p>
    # The specified stream remains open after this method returns.
    # 
    # @param   reader   the input character stream.
    # @throws  IOException  if an error occurred when reading from the
    # input stream.
    # @throws  IllegalArgumentException if a malformed Unicode escape
    # appears in the input.
    # @since   1.6
    def load(reader)
      synchronized(self) do
        load0(LineReader.new_local(self, reader))
      end
    end
    
    typesig { [InputStream] }
    # 
    # Reads a property list (key and element pairs) from the input
    # byte stream. The input stream is in a simple line-oriented
    # format as specified in
    # {@link #load(java.io.Reader) load(Reader)} and is assumed to use
    # the ISO 8859-1 character encoding; that is each byte is one Latin1
    # character. Characters not in Latin1, and certain special characters,
    # are represented in keys and elements using
    # <a href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.3">Unicode escapes</a>.
    # <p>
    # The specified stream remains open after this method returns.
    # 
    # @param      inStream   the input stream.
    # @exception  IOException  if an error occurred when reading from the
    # input stream.
    # @throws     IllegalArgumentException if the input stream contains a
    # malformed Unicode escape sequence.
    # @since 1.2
    def load(in_stream)
      synchronized(self) do
        load0(LineReader.new_local(self, in_stream))
      end
    end
    
    typesig { [LineReader] }
    def load0(lr)
      convt_buf = CharArray.new(1024)
      limit = 0
      key_len = 0
      value_start = 0
      c = 0
      has_sep = false
      preceding_backslash = false
      while ((limit = lr.read_line) >= 0)
        c = 0
        key_len = 0
        value_start = limit
        has_sep = false
        # System.out.println("line=<" + new String(lineBuf, 0, limit) + ">");
        preceding_backslash = false
        while (key_len < limit)
          c = lr.attr_line_buf[key_len]
          # need check if escaped.
          if (((c).equal?(Character.new(?=.ord)) || (c).equal?(Character.new(?:.ord))) && !preceding_backslash)
            value_start = key_len + 1
            has_sep = true
            break
          else
            if (((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\t.ord)) || (c).equal?(Character.new(?\f.ord))) && !preceding_backslash)
              value_start = key_len + 1
              break
            end
          end
          if ((c).equal?(Character.new(?\\.ord)))
            preceding_backslash = !preceding_backslash
          else
            preceding_backslash = false
          end
          ((key_len += 1) - 1)
        end
        while (value_start < limit)
          c = lr.attr_line_buf[value_start]
          if (!(c).equal?(Character.new(?\s.ord)) && !(c).equal?(Character.new(?\t.ord)) && !(c).equal?(Character.new(?\f.ord)))
            if (!has_sep && ((c).equal?(Character.new(?=.ord)) || (c).equal?(Character.new(?:.ord))))
              has_sep = true
            else
              break
            end
          end
          ((value_start += 1) - 1)
        end
        key = load_convert(lr.attr_line_buf, 0, key_len, convt_buf)
        value = load_convert(lr.attr_line_buf, value_start, limit - value_start, convt_buf)
        put(key, value)
      end
    end
    
    class_module.module_eval {
      # Read in a "logical line" from an InputStream/Reader, skip all comment
      # and blank lines and filter out those leading whitespace characters
      # (\u0020, \u0009 and \u000c) from the beginning of a "natural line".
      # Method returns the char length of the "logical line" and stores
      # the line in "lineBuf".
      const_set_lazy(:LineReader) { Class.new do
        extend LocalClass
        include_class_members Properties
        
        typesig { [InputStream] }
        def initialize(in_stream)
          @in_byte_buf = nil
          @in_char_buf = nil
          @line_buf = CharArray.new(1024)
          @in_limit = 0
          @in_off = 0
          @in_stream = nil
          @reader = nil
          @in_stream = in_stream
          @in_byte_buf = Array.typed(::Java::Byte).new(8192) { 0 }
        end
        
        typesig { [Reader] }
        def initialize(reader)
          @in_byte_buf = nil
          @in_char_buf = nil
          @line_buf = CharArray.new(1024)
          @in_limit = 0
          @in_off = 0
          @in_stream = nil
          @reader = nil
          @reader = reader
          @in_char_buf = CharArray.new(8192)
        end
        
        attr_accessor :in_byte_buf
        alias_method :attr_in_byte_buf, :in_byte_buf
        undef_method :in_byte_buf
        alias_method :attr_in_byte_buf=, :in_byte_buf=
        undef_method :in_byte_buf=
        
        attr_accessor :in_char_buf
        alias_method :attr_in_char_buf, :in_char_buf
        undef_method :in_char_buf
        alias_method :attr_in_char_buf=, :in_char_buf=
        undef_method :in_char_buf=
        
        attr_accessor :line_buf
        alias_method :attr_line_buf, :line_buf
        undef_method :line_buf
        alias_method :attr_line_buf=, :line_buf=
        undef_method :line_buf=
        
        attr_accessor :in_limit
        alias_method :attr_in_limit, :in_limit
        undef_method :in_limit
        alias_method :attr_in_limit=, :in_limit=
        undef_method :in_limit=
        
        attr_accessor :in_off
        alias_method :attr_in_off, :in_off
        undef_method :in_off
        alias_method :attr_in_off=, :in_off=
        undef_method :in_off=
        
        attr_accessor :in_stream
        alias_method :attr_in_stream, :in_stream
        undef_method :in_stream
        alias_method :attr_in_stream=, :in_stream=
        undef_method :in_stream=
        
        attr_accessor :reader
        alias_method :attr_reader, :reader
        undef_method :reader
        alias_method :attr_reader=, :reader=
        undef_method :reader=
        
        typesig { [] }
        def read_line
          len = 0
          c = 0
          skip_white_space = true
          is_comment_line = false
          is_new_line = true
          appended_line_begin = false
          preceding_backslash = false
          skip_lf = false
          while (true)
            if (@in_off >= @in_limit)
              @in_limit = ((@in_stream).nil?) ? @reader.read(@in_char_buf) : @in_stream.read(@in_byte_buf)
              @in_off = 0
              if (@in_limit <= 0)
                if ((len).equal?(0) || is_comment_line)
                  return -1
                end
                return len
              end
            end
            if (!(@in_stream).nil?)
              # The line below is equivalent to calling a
              # ISO8859-1 decoder.
              c = RJava.cast_to_char((0xff & @in_byte_buf[((@in_off += 1) - 1)]))
            else
              c = @in_char_buf[((@in_off += 1) - 1)]
            end
            if (skip_lf)
              skip_lf = false
              if ((c).equal?(Character.new(?\n.ord)))
                next
              end
            end
            if (skip_white_space)
              if ((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\t.ord)) || (c).equal?(Character.new(?\f.ord)))
                next
              end
              if (!appended_line_begin && ((c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord))))
                next
              end
              skip_white_space = false
              appended_line_begin = false
            end
            if (is_new_line)
              is_new_line = false
              if ((c).equal?(Character.new(?#.ord)) || (c).equal?(Character.new(?!.ord)))
                is_comment_line = true
                next
              end
            end
            if (!(c).equal?(Character.new(?\n.ord)) && !(c).equal?(Character.new(?\r.ord)))
              @line_buf[((len += 1) - 1)] = c
              if ((len).equal?(@line_buf.attr_length))
                new_length = @line_buf.attr_length * 2
                if (new_length < 0)
                  new_length = JavaInteger::MAX_VALUE
                end
                buf = CharArray.new(new_length)
                System.arraycopy(@line_buf, 0, buf, 0, @line_buf.attr_length)
                @line_buf = buf
              end
              # flip the preceding backslash flag
              if ((c).equal?(Character.new(?\\.ord)))
                preceding_backslash = !preceding_backslash
              else
                preceding_backslash = false
              end
            else
              # reached EOL
              if (is_comment_line || (len).equal?(0))
                is_comment_line = false
                is_new_line = true
                skip_white_space = true
                len = 0
                next
              end
              if (@in_off >= @in_limit)
                @in_limit = ((@in_stream).nil?) ? @reader.read(@in_char_buf) : @in_stream.read(@in_byte_buf)
                @in_off = 0
                if (@in_limit <= 0)
                  return len
                end
              end
              if (preceding_backslash)
                len -= 1
                # skip the leading whitespace characters in following line
                skip_white_space = true
                appended_line_begin = true
                preceding_backslash = false
                if ((c).equal?(Character.new(?\r.ord)))
                  skip_lf = true
                end
              else
                return len
              end
            end
          end
        end
        
        private
        alias_method :initialize__line_reader, :initialize
      end }
    }
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, Array.typed(::Java::Char)] }
    # 
    # Converts encoded &#92;uxxxx to unicode chars
    # and changes special saved chars to their original forms
    def load_convert(in_, off, len, convt_buf)
      if (convt_buf.attr_length < len)
        new_len = len * 2
        if (new_len < 0)
          new_len = JavaInteger::MAX_VALUE
        end
        convt_buf = CharArray.new(new_len)
      end
      a_char = 0
      out = convt_buf
      out_len = 0
      end_ = off + len
      while (off < end_)
        a_char = in_[((off += 1) - 1)]
        if ((a_char).equal?(Character.new(?\\.ord)))
          a_char = in_[((off += 1) - 1)]
          if ((a_char).equal?(Character.new(?u.ord)))
            # Read the xxxx
            value = 0
            i = 0
            while i < 4
              a_char = in_[((off += 1) - 1)]
              case (a_char)
              when Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
                value = (value << 4) + a_char - Character.new(?0.ord)
              when Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord)
                value = (value << 4) + 10 + a_char - Character.new(?a.ord)
              when Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord)
                value = (value << 4) + 10 + a_char - Character.new(?A.ord)
              else
                raise IllegalArgumentException.new("Malformed \\uxxxx encoding.")
              end
              ((i += 1) - 1)
            end
            out[((out_len += 1) - 1)] = RJava.cast_to_char(value)
          else
            if ((a_char).equal?(Character.new(?t.ord)))
              a_char = Character.new(?\t.ord)
            else
              if ((a_char).equal?(Character.new(?r.ord)))
                a_char = Character.new(?\r.ord)
              else
                if ((a_char).equal?(Character.new(?n.ord)))
                  a_char = Character.new(?\n.ord)
                else
                  if ((a_char).equal?(Character.new(?f.ord)))
                    a_char = Character.new(?\f.ord)
                  end
                end
              end
            end
            out[((out_len += 1) - 1)] = a_char
          end
        else
          out[((out_len += 1) - 1)] = a_char
        end
      end
      return String.new(out, 0, out_len)
    end
    
    typesig { [String, ::Java::Boolean, ::Java::Boolean] }
    # 
    # Converts unicodes to encoded &#92;uxxxx and escapes
    # special characters with a preceding slash
    def save_convert(the_string, escape_space, escape_unicode)
      len = the_string.length
      buf_len = len * 2
      if (buf_len < 0)
        buf_len = JavaInteger::MAX_VALUE
      end
      out_buffer = StringBuffer.new(buf_len)
      x = 0
      while x < len
        a_char = the_string.char_at(x)
        # Handle common case first, selecting largest block that
        # avoids the specials below
        if ((a_char > 61) && (a_char < 127))
          if ((a_char).equal?(Character.new(?\\.ord)))
            out_buffer.append(Character.new(?\\.ord))
            out_buffer.append(Character.new(?\\.ord))
            ((x += 1) - 1)
            next
          end
          out_buffer.append(a_char)
          ((x += 1) - 1)
          next
        end
        case (a_char)
        # Fall through
        # Fall through
        # Fall through
        when Character.new(?\s.ord)
          if ((x).equal?(0) || escape_space)
            out_buffer.append(Character.new(?\\.ord))
          end
          out_buffer.append(Character.new(?\s.ord))
        when Character.new(?\t.ord)
          out_buffer.append(Character.new(?\\.ord))
          out_buffer.append(Character.new(?t.ord))
        when Character.new(?\n.ord)
          out_buffer.append(Character.new(?\\.ord))
          out_buffer.append(Character.new(?n.ord))
        when Character.new(?\r.ord)
          out_buffer.append(Character.new(?\\.ord))
          out_buffer.append(Character.new(?r.ord))
        when Character.new(?\f.ord)
          out_buffer.append(Character.new(?\\.ord))
          out_buffer.append(Character.new(?f.ord))
        when Character.new(?=.ord), Character.new(?:.ord), Character.new(?#.ord), Character.new(?!.ord)
          out_buffer.append(Character.new(?\\.ord))
          out_buffer.append(a_char)
        else
          if (((a_char < 0x20) || (a_char > 0x7e)) & escape_unicode)
            out_buffer.append(Character.new(?\\.ord))
            out_buffer.append(Character.new(?u.ord))
            out_buffer.append(to_hex((a_char >> 12) & 0xf))
            out_buffer.append(to_hex((a_char >> 8) & 0xf))
            out_buffer.append(to_hex((a_char >> 4) & 0xf))
            out_buffer.append(to_hex(a_char & 0xf))
          else
            out_buffer.append(a_char)
          end
        end
        ((x += 1) - 1)
      end
      return out_buffer.to_s
    end
    
    class_module.module_eval {
      typesig { [BufferedWriter, String] }
      def write_comments(bw, comments)
        bw.write("#")
        len = comments.length
        current = 0
        last = 0
        uu = CharArray.new(6)
        uu[0] = Character.new(?\\.ord)
        uu[1] = Character.new(?u.ord)
        while (current < len)
          c = comments.char_at(current)
          if (c > Character.new(0x00ff) || (c).equal?(Character.new(?\n.ord)) || (c).equal?(Character.new(?\r.ord)))
            if (!(last).equal?(current))
              bw.write(comments.substring(last, current))
            end
            if (c > Character.new(0x00ff))
              uu[2] = to_hex((c >> 12) & 0xf)
              uu[3] = to_hex((c >> 8) & 0xf)
              uu[4] = to_hex((c >> 4) & 0xf)
              uu[5] = to_hex(c & 0xf)
              bw.write(String.new(uu))
            else
              bw.new_line
              if ((c).equal?(Character.new(?\r.ord)) && !(current).equal?(len - 1) && (comments.char_at(current + 1)).equal?(Character.new(?\n.ord)))
                ((current += 1) - 1)
              end
              if ((current).equal?(len - 1) || (!(comments.char_at(current + 1)).equal?(Character.new(?#.ord)) && !(comments.char_at(current + 1)).equal?(Character.new(?!.ord))))
                bw.write("#")
              end
            end
            last = current + 1
          end
          ((current += 1) - 1)
        end
        if (!(last).equal?(current))
          bw.write(comments.substring(last, current))
        end
        bw.new_line
      end
    }
    
    typesig { [OutputStream, String] }
    # 
    # Calls the <code>store(OutputStream out, String comments)</code> method
    # and suppresses IOExceptions that were thrown.
    # 
    # @deprecated This method does not throw an IOException if an I/O error
    # occurs while saving the property list.  The preferred way to save a
    # properties list is via the <code>store(OutputStream out,
    # String comments)</code> method or the
    # <code>storeToXML(OutputStream os, String comment)</code> method.
    # 
    # @param   out      an output stream.
    # @param   comments   a description of the property list.
    # @exception  ClassCastException  if this <code>Properties</code> object
    # contains any keys or values that are not
    # <code>Strings</code>.
    def save(out, comments)
      synchronized(self) do
        begin
          store(out, comments)
        rescue IOException => e
        end
      end
    end
    
    typesig { [Writer, String] }
    # 
    # Writes this property list (key and element pairs) in this
    # <code>Properties</code> table to the output character stream in a
    # format suitable for using the {@link #load(java.io.Reader) load(Reader)}
    # method.
    # <p>
    # Properties from the defaults table of this <code>Properties</code>
    # table (if any) are <i>not</i> written out by this method.
    # <p>
    # If the comments argument is not null, then an ASCII <code>#</code>
    # character, the comments string, and a line separator are first written
    # to the output stream. Thus, the <code>comments</code> can serve as an
    # identifying comment. Any one of a line feed ('\n'), a carriage
    # return ('\r'), or a carriage return followed immediately by a line feed
    # in comments is replaced by a line separator generated by the <code>Writer</code>
    # and if the next character in comments is not character <code>#</code> or
    # character <code>!</code> then an ASCII <code>#</code> is written out
    # after that line separator.
    # <p>
    # Next, a comment line is always written, consisting of an ASCII
    # <code>#</code> character, the current date and time (as if produced
    # by the <code>toString</code> method of <code>Date</code> for the
    # current time), and a line separator as generated by the <code>Writer</code>.
    # <p>
    # Then every entry in this <code>Properties</code> table is
    # written out, one per line. For each entry the key string is
    # written, then an ASCII <code>=</code>, then the associated
    # element string. For the key, all space characters are
    # written with a preceding <code>\</code> character.  For the
    # element, leading space characters, but not embedded or trailing
    # space characters, are written with a preceding <code>\</code>
    # character. The key and element characters <code>#</code>,
    # <code>!</code>, <code>=</code>, and <code>:</code> are written
    # with a preceding backslash to ensure that they are properly loaded.
    # <p>
    # After the entries have been written, the output stream is flushed.
    # The output stream remains open after this method returns.
    # <p>
    # 
    # @param   writer      an output character stream writer.
    # @param   comments   a description of the property list.
    # @exception  IOException if writing this property list to the specified
    # output stream throws an <tt>IOException</tt>.
    # @exception  ClassCastException  if this <code>Properties</code> object
    # contains any keys or values that are not <code>Strings</code>.
    # @exception  NullPointerException  if <code>writer</code> is null.
    # @since 1.6
    def store(writer, comments)
      store0((writer.is_a?(BufferedWriter)) ? writer : BufferedWriter.new(writer), comments, false)
    end
    
    typesig { [OutputStream, String] }
    # 
    # Writes this property list (key and element pairs) in this
    # <code>Properties</code> table to the output stream in a format suitable
    # for loading into a <code>Properties</code> table using the
    # {@link #load(InputStream) load(InputStream)} method.
    # <p>
    # Properties from the defaults table of this <code>Properties</code>
    # table (if any) are <i>not</i> written out by this method.
    # <p>
    # This method outputs the comments, properties keys and values in
    # the same format as specified in
    # {@link #store(java.io.Writer, java.lang.String) store(Writer)},
    # with the following differences:
    # <ul>
    # <li>The stream is written using the ISO 8859-1 character encoding.
    # 
    # <li>Characters not in Latin-1 in the comments are written as
    # <code>&#92;u</code><i>xxxx</i> for their appropriate unicode
    # hexadecimal value <i>xxxx</i>.
    # 
    # <li>Characters less than <code>&#92;u0020</code> and characters greater
    # than <code>&#92;u007E</code> in property keys or values are written
    # as <code>&#92;u</code><i>xxxx</i> for the appropriate hexadecimal
    # value <i>xxxx</i>.
    # </ul>
    # <p>
    # After the entries have been written, the output stream is flushed.
    # The output stream remains open after this method returns.
    # <p>
    # @param   out      an output stream.
    # @param   comments   a description of the property list.
    # @exception  IOException if writing this property list to the specified
    # output stream throws an <tt>IOException</tt>.
    # @exception  ClassCastException  if this <code>Properties</code> object
    # contains any keys or values that are not <code>Strings</code>.
    # @exception  NullPointerException  if <code>out</code> is null.
    # @since 1.2
    def store(out, comments)
      store0(BufferedWriter.new(OutputStreamWriter.new(out, "8859_1")), comments, true)
    end
    
    typesig { [BufferedWriter, String, ::Java::Boolean] }
    def store0(bw, comments, esc_unicode)
      if (!(comments).nil?)
        write_comments(bw, comments)
      end
      bw.write("#" + (Date.new.to_s).to_s)
      bw.new_line
      synchronized((self)) do
        e = keys
        while e.has_more_elements
          key = e.next_element
          val = get(key)
          key = (save_convert(key, true, esc_unicode)).to_s
          # No need to escape embedded and trailing spaces for value, hence
          # pass false to flag.
          val = (save_convert(val, false, esc_unicode)).to_s
          bw.write(key + "=" + val)
          bw.new_line
        end
      end
      bw.flush
    end
    
    typesig { [InputStream] }
    # 
    # Loads all of the properties represented by the XML document on the
    # specified input stream into this properties table.
    # 
    # <p>The XML document must have the following DOCTYPE declaration:
    # <pre>
    # &lt;!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd"&gt;
    # </pre>
    # Furthermore, the document must satisfy the properties DTD described
    # above.
    # 
    # <p>The specified stream is closed after this method returns.
    # 
    # @param in the input stream from which to read the XML document.
    # @throws IOException if reading from the specified input stream
    # results in an <tt>IOException</tt>.
    # @throws InvalidPropertiesFormatException Data on input stream does not
    # constitute a valid XML document with the mandated document type.
    # @throws NullPointerException if <code>in</code> is null.
    # @see    #storeToXML(OutputStream, String, String)
    # @since 1.5
    def load_from_xml(in_)
      synchronized(self) do
        if ((in_).nil?)
          raise NullPointerException.new
        end
        XMLUtils.load(self, in_)
        in_.close
      end
    end
    
    typesig { [OutputStream, String] }
    # 
    # Emits an XML document representing all of the properties contained
    # in this table.
    # 
    # <p> An invocation of this method of the form <tt>props.storeToXML(os,
    # comment)</tt> behaves in exactly the same way as the invocation
    # <tt>props.storeToXML(os, comment, "UTF-8");</tt>.
    # 
    # @param os the output stream on which to emit the XML document.
    # @param comment a description of the property list, or <code>null</code>
    # if no comment is desired.
    # @throws IOException if writing to the specified output stream
    # results in an <tt>IOException</tt>.
    # @throws NullPointerException if <code>os</code> is null.
    # @throws ClassCastException  if this <code>Properties</code> object
    # contains any keys or values that are not
    # <code>Strings</code>.
    # @see    #loadFromXML(InputStream)
    # @since 1.5
    def store_to_xml(os, comment)
      synchronized(self) do
        if ((os).nil?)
          raise NullPointerException.new
        end
        store_to_xml(os, comment, "UTF-8")
      end
    end
    
    typesig { [OutputStream, String, String] }
    # 
    # Emits an XML document representing all of the properties contained
    # in this table, using the specified encoding.
    # 
    # <p>The XML document will have the following DOCTYPE declaration:
    # <pre>
    # &lt;!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd"&gt;
    # </pre>
    # 
    # <p>If the specified comment is <code>null</code> then no comment
    # will be stored in the document.
    # 
    # <p>The specified stream remains open after this method returns.
    # 
    # @param os the output stream on which to emit the XML document.
    # @param comment a description of the property list, or <code>null</code>
    # if no comment is desired.
    # @throws IOException if writing to the specified output stream
    # results in an <tt>IOException</tt>.
    # @throws NullPointerException if <code>os</code> is <code>null</code>,
    # or if <code>encoding</code> is <code>null</code>.
    # @throws ClassCastException  if this <code>Properties</code> object
    # contains any keys or values that are not
    # <code>Strings</code>.
    # @see    #loadFromXML(InputStream)
    # @since 1.5
    def store_to_xml(os, comment, encoding)
      synchronized(self) do
        if ((os).nil?)
          raise NullPointerException.new
        end
        XMLUtils.save(self, os, comment, encoding)
      end
    end
    
    typesig { [String] }
    # 
    # Searches for the property with the specified key in this property list.
    # If the key is not found in this property list, the default property list,
    # and its defaults, recursively, are then checked. The method returns
    # <code>null</code> if the property is not found.
    # 
    # @param   key   the property key.
    # @return  the value in this property list with the specified key value.
    # @see     #setProperty
    # @see     #defaults
    def get_property(key)
      oval = Hashtable.instance_method(:get).bind(self).call(key)
      sval = (oval.is_a?(String)) ? oval : nil
      return (((sval).nil?) && (!(@defaults).nil?)) ? @defaults.get_property(key) : sval
    end
    
    typesig { [String, String] }
    # 
    # Searches for the property with the specified key in this property list.
    # If the key is not found in this property list, the default property list,
    # and its defaults, recursively, are then checked. The method returns the
    # default value argument if the property is not found.
    # 
    # @param   key            the hashtable key.
    # @param   defaultValue   a default value.
    # 
    # @return  the value in this property list with the specified key value.
    # @see     #setProperty
    # @see     #defaults
    def get_property(key, default_value)
      val = get_property(key)
      return ((val).nil?) ? default_value : val
    end
    
    typesig { [] }
    # 
    # Returns an enumeration of all the keys in this property list,
    # including distinct keys in the default property list if a key
    # of the same name has not already been found from the main
    # properties list.
    # 
    # @return  an enumeration of all the keys in this property list, including
    # the keys in the default property list.
    # @throws  ClassCastException if any key in this property list
    # is not a string.
    # @see     java.util.Enumeration
    # @see     java.util.Properties#defaults
    # @see     #stringPropertyNames
    def property_names
      h = Hashtable.new
      enumerate(h)
      return h.keys
    end
    
    typesig { [] }
    # 
    # Returns a set of keys in this property list where
    # the key and its corresponding value are strings,
    # including distinct keys in the default property list if a key
    # of the same name has not already been found from the main
    # properties list.  Properties whose key or value is not
    # of type <tt>String</tt> are omitted.
    # <p>
    # The returned set is not backed by the <tt>Properties</tt> object.
    # Changes to this <tt>Properties</tt> are not reflected in the set,
    # or vice versa.
    # 
    # @return  a set of keys in this property list where
    # the key and its corresponding value are strings,
    # including the keys in the default property list.
    # @see     java.util.Properties#defaults
    # @since   1.6
    def string_property_names
      h = Hashtable.new
      enumerate_string_properties(h)
      return h.key_set
    end
    
    typesig { [PrintStream] }
    # 
    # Prints this property list out to the specified output stream.
    # This method is useful for debugging.
    # 
    # @param   out   an output stream.
    # @throws  ClassCastException if any key in this property list
    # is not a string.
    def list(out)
      out.println("-- listing properties --")
      h = Hashtable.new
      enumerate(h)
      e = h.keys
      while e.has_more_elements
        key = e.next_element
        val = h.get(key)
        if (val.length > 40)
          val = (val.substring(0, 37)).to_s + "..."
        end
        out.println(key + "=" + val)
      end
    end
    
    typesig { [PrintWriter] }
    # 
    # Prints this property list out to the specified output stream.
    # This method is useful for debugging.
    # 
    # @param   out   an output stream.
    # @throws  ClassCastException if any key in this property list
    # is not a string.
    # @since   JDK1.1
    # 
    # 
    # Rather than use an anonymous inner class to share common code, this
    # method is duplicated in order to ensure that a non-1.1 compiler can
    # compile this file.
    def list(out)
      out.println("-- listing properties --")
      h = Hashtable.new
      enumerate(h)
      e = h.keys
      while e.has_more_elements
        key = e.next_element
        val = h.get(key)
        if (val.length > 40)
          val = (val.substring(0, 37)).to_s + "..."
        end
        out.println(key + "=" + val)
      end
    end
    
    typesig { [Hashtable] }
    # 
    # Enumerates all key/value pairs in the specified hashtable.
    # @param h the hashtable
    # @throws ClassCastException if any of the property keys
    # is not of String type.
    def enumerate(h)
      synchronized(self) do
        if (!(@defaults).nil?)
          @defaults.enumerate(h)
        end
        e = keys
        while e.has_more_elements
          key = e.next_element
          h.put(key, get(key))
        end
      end
    end
    
    typesig { [Hashtable] }
    # 
    # Enumerates all key/value pairs in the specified hashtable
    # and omits the property if the key or value is not a string.
    # @param h the hashtable
    def enumerate_string_properties(h)
      synchronized(self) do
        if (!(@defaults).nil?)
          @defaults.enumerate_string_properties(h)
        end
        e = keys
        while e.has_more_elements
          k = e.next_element
          v = get(k)
          if (k.is_a?(String) && v.is_a?(String))
            h.put(k, v)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # 
      # Convert a nibble to a hex character
      # @param   nibble  the nibble to convert.
      def to_hex(nibble)
        return HexDigit[(nibble & 0xf)]
      end
      
      # A table of hex digits
      const_set_lazy(:HexDigit) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord)]) }
      const_attr_reader  :HexDigit
    }
    
    private
    alias_method :initialize__properties, :initialize
  end
  
end

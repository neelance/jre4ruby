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
module Java::Util
  module StringTokenizerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Lang
    }
  end
  
  # The string tokenizer class allows an application to break a
  # string into tokens. The tokenization method is much simpler than
  # the one used by the <code>StreamTokenizer</code> class. The
  # <code>StringTokenizer</code> methods do not distinguish among
  # identifiers, numbers, and quoted strings, nor do they recognize
  # and skip comments.
  # <p>
  # The set of delimiters (the characters that separate tokens) may
  # be specified either at creation time or on a per-token basis.
  # <p>
  # An instance of <code>StringTokenizer</code> behaves in one of two
  # ways, depending on whether it was created with the
  # <code>returnDelims</code> flag having the value <code>true</code>
  # or <code>false</code>:
  # <ul>
  # <li>If the flag is <code>false</code>, delimiter characters serve to
  # separate tokens. A token is a maximal sequence of consecutive
  # characters that are not delimiters.
  # <li>If the flag is <code>true</code>, delimiter characters are themselves
  # considered to be tokens. A token is thus either one delimiter
  # character, or a maximal sequence of consecutive characters that are
  # not delimiters.
  # </ul><p>
  # A <tt>StringTokenizer</tt> object internally maintains a current
  # position within the string to be tokenized. Some operations advance this
  # current position past the characters processed.<p>
  # A token is returned by taking a substring of the string that was used to
  # create the <tt>StringTokenizer</tt> object.
  # <p>
  # The following is one example of the use of the tokenizer. The code:
  # <blockquote><pre>
  # StringTokenizer st = new StringTokenizer("this is a test");
  # while (st.hasMoreTokens()) {
  # System.out.println(st.nextToken());
  # }
  # </pre></blockquote>
  # <p>
  # prints the following output:
  # <blockquote><pre>
  # this
  # is
  # a
  # test
  # </pre></blockquote>
  # 
  # <p>
  # <tt>StringTokenizer</tt> is a legacy class that is retained for
  # compatibility reasons although its use is discouraged in new code. It is
  # recommended that anyone seeking this functionality use the <tt>split</tt>
  # method of <tt>String</tt> or the java.util.regex package instead.
  # <p>
  # The following example illustrates how the <tt>String.split</tt>
  # method can be used to break up a string into its basic tokens:
  # <blockquote><pre>
  # String[] result = "this is a test".split("\\s");
  # for (int x=0; x&lt;result.length; x++)
  # System.out.println(result[x]);
  # </pre></blockquote>
  # <p>
  # prints the following output:
  # <blockquote><pre>
  # this
  # is
  # a
  # test
  # </pre></blockquote>
  # 
  # @author  unascribed
  # @see     java.io.StreamTokenizer
  # @since   JDK1.0
  class StringTokenizer 
    include_class_members StringTokenizerImports
    include Enumeration
    
    attr_accessor :current_position
    alias_method :attr_current_position, :current_position
    undef_method :current_position
    alias_method :attr_current_position=, :current_position=
    undef_method :current_position=
    
    attr_accessor :new_position
    alias_method :attr_new_position, :new_position
    undef_method :new_position
    alias_method :attr_new_position=, :new_position=
    undef_method :new_position=
    
    attr_accessor :max_position
    alias_method :attr_max_position, :max_position
    undef_method :max_position
    alias_method :attr_max_position=, :max_position=
    undef_method :max_position=
    
    attr_accessor :str
    alias_method :attr_str, :str
    undef_method :str
    alias_method :attr_str=, :str=
    undef_method :str=
    
    attr_accessor :delimiters
    alias_method :attr_delimiters, :delimiters
    undef_method :delimiters
    alias_method :attr_delimiters=, :delimiters=
    undef_method :delimiters=
    
    attr_accessor :ret_delims
    alias_method :attr_ret_delims, :ret_delims
    undef_method :ret_delims
    alias_method :attr_ret_delims=, :ret_delims=
    undef_method :ret_delims=
    
    attr_accessor :delims_changed
    alias_method :attr_delims_changed, :delims_changed
    undef_method :delims_changed
    alias_method :attr_delims_changed=, :delims_changed=
    undef_method :delims_changed=
    
    # maxDelimCodePoint stores the value of the delimiter character with the
    # highest value. It is used to optimize the detection of delimiter
    # characters.
    # 
    # It is unlikely to provide any optimization benefit in the
    # hasSurrogates case because most string characters will be
    # smaller than the limit, but we keep it so that the two code
    # paths remain similar.
    attr_accessor :max_delim_code_point
    alias_method :attr_max_delim_code_point, :max_delim_code_point
    undef_method :max_delim_code_point
    alias_method :attr_max_delim_code_point=, :max_delim_code_point=
    undef_method :max_delim_code_point=
    
    # If delimiters include any surrogates (including surrogate
    # pairs), hasSurrogates is true and the tokenizer uses the
    # different code path. This is because String.indexOf(int)
    # doesn't handle unpaired surrogates as a single character.
    attr_accessor :has_surrogates
    alias_method :attr_has_surrogates, :has_surrogates
    undef_method :has_surrogates
    alias_method :attr_has_surrogates=, :has_surrogates=
    undef_method :has_surrogates=
    
    # When hasSurrogates is true, delimiters are converted to code
    # points and isDelimiter(int) is used to determine if the given
    # codepoint is a delimiter.
    attr_accessor :delimiter_code_points
    alias_method :attr_delimiter_code_points, :delimiter_code_points
    undef_method :delimiter_code_points
    alias_method :attr_delimiter_code_points=, :delimiter_code_points=
    undef_method :delimiter_code_points=
    
    typesig { [] }
    # Set maxDelimCodePoint to the highest char in the delimiter set.
    def set_max_delim_code_point
      if ((@delimiters).nil?)
        @max_delim_code_point = 0
        return
      end
      m = 0
      c = 0
      count = 0
      i = 0
      while i < @delimiters.length
        c = @delimiters.char_at(i)
        if (c >= Character::MIN_HIGH_SURROGATE && c <= Character::MAX_LOW_SURROGATE)
          c = @delimiters.code_point_at(i)
          @has_surrogates = true
        end
        if (m < c)
          m = c
        end
        count += 1
        i += Character.char_count(c)
      end
      @max_delim_code_point = m
      if (@has_surrogates)
        @delimiter_code_points = Array.typed(::Java::Int).new(count) { 0 }
        i_ = 0
        j = 0
        while i_ < count
          c = @delimiters.code_point_at(j)
          @delimiter_code_points[i_] = c
          i_ += 1
          j += Character.char_count(c)
        end
      end
    end
    
    typesig { [String, String, ::Java::Boolean] }
    # Constructs a string tokenizer for the specified string. All
    # characters in the <code>delim</code> argument are the delimiters
    # for separating tokens.
    # <p>
    # If the <code>returnDelims</code> flag is <code>true</code>, then
    # the delimiter characters are also returned as tokens. Each
    # delimiter is returned as a string of length one. If the flag is
    # <code>false</code>, the delimiter characters are skipped and only
    # serve as separators between tokens.
    # <p>
    # Note that if <tt>delim</tt> is <tt>null</tt>, this constructor does
    # not throw an exception. However, trying to invoke other methods on the
    # resulting <tt>StringTokenizer</tt> may result in a
    # <tt>NullPointerException</tt>.
    # 
    # @param   str            a string to be parsed.
    # @param   delim          the delimiters.
    # @param   returnDelims   flag indicating whether to return the delimiters
    # as tokens.
    # @exception NullPointerException if str is <CODE>null</CODE>
    def initialize(str, delim, return_delims)
      @current_position = 0
      @new_position = 0
      @max_position = 0
      @str = nil
      @delimiters = nil
      @ret_delims = false
      @delims_changed = false
      @max_delim_code_point = 0
      @has_surrogates = false
      @delimiter_code_points = nil
      @current_position = 0
      @new_position = -1
      @delims_changed = false
      @str = str
      @max_position = str.length
      @delimiters = delim
      @ret_delims = return_delims
      set_max_delim_code_point
    end
    
    typesig { [String, String] }
    # Constructs a string tokenizer for the specified string. The
    # characters in the <code>delim</code> argument are the delimiters
    # for separating tokens. Delimiter characters themselves will not
    # be treated as tokens.
    # <p>
    # Note that if <tt>delim</tt> is <tt>null</tt>, this constructor does
    # not throw an exception. However, trying to invoke other methods on the
    # resulting <tt>StringTokenizer</tt> may result in a
    # <tt>NullPointerException</tt>.
    # 
    # @param   str     a string to be parsed.
    # @param   delim   the delimiters.
    # @exception NullPointerException if str is <CODE>null</CODE>
    def initialize(str, delim)
      initialize__string_tokenizer(str, delim, false)
    end
    
    typesig { [String] }
    # Constructs a string tokenizer for the specified string. The
    # tokenizer uses the default delimiter set, which is
    # <code>"&nbsp;&#92;t&#92;n&#92;r&#92;f"</code>: the space character,
    # the tab character, the newline character, the carriage-return character,
    # and the form-feed character. Delimiter characters themselves will
    # not be treated as tokens.
    # 
    # @param   str   a string to be parsed.
    # @exception NullPointerException if str is <CODE>null</CODE>
    def initialize(str)
      initialize__string_tokenizer(str, " \t\n\r\f", false)
    end
    
    typesig { [::Java::Int] }
    # Skips delimiters starting from the specified position. If retDelims
    # is false, returns the index of the first non-delimiter character at or
    # after startPos. If retDelims is true, startPos is returned.
    def skip_delimiters(start_pos)
      if ((@delimiters).nil?)
        raise NullPointerException.new
      end
      position = start_pos
      while (!@ret_delims && position < @max_position)
        if (!@has_surrogates)
          c = @str.char_at(position)
          if ((c > @max_delim_code_point) || (@delimiters.index_of(c) < 0))
            break
          end
          position += 1
        else
          c = @str.code_point_at(position)
          if ((c > @max_delim_code_point) || !is_delimiter(c))
            break
          end
          position += Character.char_count(c)
        end
      end
      return position
    end
    
    typesig { [::Java::Int] }
    # Skips ahead from startPos and returns the index of the next delimiter
    # character encountered, or maxPosition if no such delimiter is found.
    def scan_token(start_pos)
      position = start_pos
      while (position < @max_position)
        if (!@has_surrogates)
          c = @str.char_at(position)
          if ((c <= @max_delim_code_point) && (@delimiters.index_of(c) >= 0))
            break
          end
          position += 1
        else
          c = @str.code_point_at(position)
          if ((c <= @max_delim_code_point) && is_delimiter(c))
            break
          end
          position += Character.char_count(c)
        end
      end
      if (@ret_delims && ((start_pos).equal?(position)))
        if (!@has_surrogates)
          c = @str.char_at(position)
          if ((c <= @max_delim_code_point) && (@delimiters.index_of(c) >= 0))
            position += 1
          end
        else
          c = @str.code_point_at(position)
          if ((c <= @max_delim_code_point) && is_delimiter(c))
            position += Character.char_count(c)
          end
        end
      end
      return position
    end
    
    typesig { [::Java::Int] }
    def is_delimiter(code_point)
      i = 0
      while i < @delimiter_code_points.attr_length
        if ((@delimiter_code_points[i]).equal?(code_point))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [] }
    # Tests if there are more tokens available from this tokenizer's string.
    # If this method returns <tt>true</tt>, then a subsequent call to
    # <tt>nextToken</tt> with no argument will successfully return a token.
    # 
    # @return  <code>true</code> if and only if there is at least one token
    # in the string after the current position; <code>false</code>
    # otherwise.
    def has_more_tokens
      # Temporarily store this position and use it in the following
      # nextToken() method only if the delimiters haven't been changed in
      # that nextToken() invocation.
      @new_position = skip_delimiters(@current_position)
      return (@new_position < @max_position)
    end
    
    typesig { [] }
    # Returns the next token from this string tokenizer.
    # 
    # @return     the next token from this string tokenizer.
    # @exception  NoSuchElementException  if there are no more tokens in this
    # tokenizer's string.
    def next_token
      # If next position already computed in hasMoreElements() and
      # delimiters have changed between the computation and this invocation,
      # then use the computed value.
      @current_position = (@new_position >= 0 && !@delims_changed) ? @new_position : skip_delimiters(@current_position)
      # Reset these anyway
      @delims_changed = false
      @new_position = -1
      if (@current_position >= @max_position)
        raise NoSuchElementException.new
      end
      start = @current_position
      @current_position = scan_token(@current_position)
      return @str.substring(start, @current_position)
    end
    
    typesig { [String] }
    # Returns the next token in this string tokenizer's string. First,
    # the set of characters considered to be delimiters by this
    # <tt>StringTokenizer</tt> object is changed to be the characters in
    # the string <tt>delim</tt>. Then the next token in the string
    # after the current position is returned. The current position is
    # advanced beyond the recognized token.  The new delimiter set
    # remains the default after this call.
    # 
    # @param      delim   the new delimiters.
    # @return     the next token, after switching to the new delimiter set.
    # @exception  NoSuchElementException  if there are no more tokens in this
    # tokenizer's string.
    # @exception NullPointerException if delim is <CODE>null</CODE>
    def next_token(delim)
      @delimiters = delim
      # delimiter string specified, so set the appropriate flag.
      @delims_changed = true
      set_max_delim_code_point
      return next_token
    end
    
    typesig { [] }
    # Returns the same value as the <code>hasMoreTokens</code>
    # method. It exists so that this class can implement the
    # <code>Enumeration</code> interface.
    # 
    # @return  <code>true</code> if there are more tokens;
    # <code>false</code> otherwise.
    # @see     java.util.Enumeration
    # @see     java.util.StringTokenizer#hasMoreTokens()
    def has_more_elements
      return has_more_tokens
    end
    
    typesig { [] }
    # Returns the same value as the <code>nextToken</code> method,
    # except that its declared return value is <code>Object</code> rather than
    # <code>String</code>. It exists so that this class can implement the
    # <code>Enumeration</code> interface.
    # 
    # @return     the next token in the string.
    # @exception  NoSuchElementException  if there are no more tokens in this
    # tokenizer's string.
    # @see        java.util.Enumeration
    # @see        java.util.StringTokenizer#nextToken()
    def next_element
      return next_token
    end
    
    typesig { [] }
    # Calculates the number of times that this tokenizer's
    # <code>nextToken</code> method can be called before it generates an
    # exception. The current position is not advanced.
    # 
    # @return  the number of tokens remaining in the string using the current
    # delimiter set.
    # @see     java.util.StringTokenizer#nextToken()
    def count_tokens
      count = 0
      currpos = @current_position
      while (currpos < @max_position)
        currpos = skip_delimiters(currpos)
        if (currpos >= @max_position)
          break
        end
        currpos = scan_token(currpos)
        count += 1
      end
      return count
    end
    
    private
    alias_method :initialize__string_tokenizer, :initialize
  end
  
end

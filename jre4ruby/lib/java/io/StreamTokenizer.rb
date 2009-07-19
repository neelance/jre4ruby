require "rjava"

# Copyright 1995-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module StreamTokenizerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Arrays
    }
  end
  
  # The <code>StreamTokenizer</code> class takes an input stream and
  # parses it into "tokens", allowing the tokens to be
  # read one at a time. The parsing process is controlled by a table
  # and a number of flags that can be set to various states. The
  # stream tokenizer can recognize identifiers, numbers, quoted
  # strings, and various comment styles.
  # <p>
  # Each byte read from the input stream is regarded as a character
  # in the range <code>'&#92;u0000'</code> through <code>'&#92;u00FF'</code>.
  # The character value is used to look up five possible attributes of
  # the character: <i>white space</i>, <i>alphabetic</i>,
  # <i>numeric</i>, <i>string quote</i>, and <i>comment character</i>.
  # Each character can have zero or more of these attributes.
  # <p>
  # In addition, an instance has four flags. These flags indicate:
  # <ul>
  # <li>Whether line terminators are to be returned as tokens or treated
  # as white space that merely separates tokens.
  # <li>Whether C-style comments are to be recognized and skipped.
  # <li>Whether C++-style comments are to be recognized and skipped.
  # <li>Whether the characters of identifiers are converted to lowercase.
  # </ul>
  # <p>
  # A typical application first constructs an instance of this class,
  # sets up the syntax tables, and then repeatedly loops calling the
  # <code>nextToken</code> method in each iteration of the loop until
  # it returns the value <code>TT_EOF</code>.
  # 
  # @author  James Gosling
  # @see     java.io.StreamTokenizer#nextToken()
  # @see     java.io.StreamTokenizer#TT_EOF
  # @since   JDK1.0
  class StreamTokenizer 
    include_class_members StreamTokenizerImports
    
    # Only one of these will be non-null
    attr_accessor :reader
    alias_method :attr_reader, :reader
    undef_method :reader
    alias_method :attr_reader=, :reader=
    undef_method :reader=
    
    attr_accessor :input
    alias_method :attr_input, :input
    undef_method :input
    alias_method :attr_input=, :input=
    undef_method :input=
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # The next character to be considered by the nextToken method.  May also
    # be NEED_CHAR to indicate that a new character should be read, or SKIP_LF
    # to indicate that a new character should be read and, if it is a '\n'
    # character, it should be discarded and a second new character should be
    # read.
    attr_accessor :peekc
    alias_method :attr_peekc, :peekc
    undef_method :peekc
    alias_method :attr_peekc=, :peekc=
    undef_method :peekc=
    
    class_module.module_eval {
      const_set_lazy(:NEED_CHAR) { JavaInteger::MAX_VALUE }
      const_attr_reader  :NEED_CHAR
      
      const_set_lazy(:SKIP_LF) { JavaInteger::MAX_VALUE - 1 }
      const_attr_reader  :SKIP_LF
    }
    
    attr_accessor :pushed_back
    alias_method :attr_pushed_back, :pushed_back
    undef_method :pushed_back
    alias_method :attr_pushed_back=, :pushed_back=
    undef_method :pushed_back=
    
    attr_accessor :force_lower
    alias_method :attr_force_lower, :force_lower
    undef_method :force_lower
    alias_method :attr_force_lower=, :force_lower=
    undef_method :force_lower=
    
    # The line number of the last token read
    attr_accessor :lineno
    alias_method :attr_lineno, :lineno
    undef_method :lineno
    alias_method :attr_lineno=, :lineno=
    undef_method :lineno=
    
    attr_accessor :eol_is_significant_p
    alias_method :attr_eol_is_significant_p, :eol_is_significant_p
    undef_method :eol_is_significant_p
    alias_method :attr_eol_is_significant_p=, :eol_is_significant_p=
    undef_method :eol_is_significant_p=
    
    attr_accessor :slash_slash_comments_p
    alias_method :attr_slash_slash_comments_p, :slash_slash_comments_p
    undef_method :slash_slash_comments_p
    alias_method :attr_slash_slash_comments_p=, :slash_slash_comments_p=
    undef_method :slash_slash_comments_p=
    
    attr_accessor :slash_star_comments_p
    alias_method :attr_slash_star_comments_p, :slash_star_comments_p
    undef_method :slash_star_comments_p
    alias_method :attr_slash_star_comments_p=, :slash_star_comments_p=
    undef_method :slash_star_comments_p=
    
    attr_accessor :ctype
    alias_method :attr_ctype, :ctype
    undef_method :ctype
    alias_method :attr_ctype=, :ctype=
    undef_method :ctype=
    
    class_module.module_eval {
      const_set_lazy(:CT_WHITESPACE) { 1 }
      const_attr_reader  :CT_WHITESPACE
      
      const_set_lazy(:CT_DIGIT) { 2 }
      const_attr_reader  :CT_DIGIT
      
      const_set_lazy(:CT_ALPHA) { 4 }
      const_attr_reader  :CT_ALPHA
      
      const_set_lazy(:CT_QUOTE) { 8 }
      const_attr_reader  :CT_QUOTE
      
      const_set_lazy(:CT_COMMENT) { 16 }
      const_attr_reader  :CT_COMMENT
    }
    
    # After a call to the <code>nextToken</code> method, this field
    # contains the type of the token just read. For a single character
    # token, its value is the single character, converted to an integer.
    # For a quoted string token, its value is the quote character.
    # Otherwise, its value is one of the following:
    # <ul>
    # <li><code>TT_WORD</code> indicates that the token is a word.
    # <li><code>TT_NUMBER</code> indicates that the token is a number.
    # <li><code>TT_EOL</code> indicates that the end of line has been read.
    # The field can only have this value if the
    # <code>eolIsSignificant</code> method has been called with the
    # argument <code>true</code>.
    # <li><code>TT_EOF</code> indicates that the end of the input stream
    # has been reached.
    # </ul>
    # <p>
    # The initial value of this field is -4.
    # 
    # @see     java.io.StreamTokenizer#eolIsSignificant(boolean)
    # @see     java.io.StreamTokenizer#nextToken()
    # @see     java.io.StreamTokenizer#quoteChar(int)
    # @see     java.io.StreamTokenizer#TT_EOF
    # @see     java.io.StreamTokenizer#TT_EOL
    # @see     java.io.StreamTokenizer#TT_NUMBER
    # @see     java.io.StreamTokenizer#TT_WORD
    attr_accessor :ttype
    alias_method :attr_ttype, :ttype
    undef_method :ttype
    alias_method :attr_ttype=, :ttype=
    undef_method :ttype=
    
    class_module.module_eval {
      # A constant indicating that the end of the stream has been read.
      const_set_lazy(:TT_EOF) { -1 }
      const_attr_reader  :TT_EOF
      
      # A constant indicating that the end of the line has been read.
      const_set_lazy(:TT_EOL) { Character.new(?\n.ord) }
      const_attr_reader  :TT_EOL
      
      # A constant indicating that a number token has been read.
      const_set_lazy(:TT_NUMBER) { -2 }
      const_attr_reader  :TT_NUMBER
      
      # A constant indicating that a word token has been read.
      const_set_lazy(:TT_WORD) { -3 }
      const_attr_reader  :TT_WORD
      
      # A constant indicating that no token has been read, used for
      # initializing ttype.  FIXME This could be made public and
      # made available as the part of the API in a future release.
      const_set_lazy(:TT_NOTHING) { -4 }
      const_attr_reader  :TT_NOTHING
    }
    
    # If the current token is a word token, this field contains a
    # string giving the characters of the word token. When the current
    # token is a quoted string token, this field contains the body of
    # the string.
    # <p>
    # The current token is a word when the value of the
    # <code>ttype</code> field is <code>TT_WORD</code>. The current token is
    # a quoted string token when the value of the <code>ttype</code> field is
    # a quote character.
    # <p>
    # The initial value of this field is null.
    # 
    # @see     java.io.StreamTokenizer#quoteChar(int)
    # @see     java.io.StreamTokenizer#TT_WORD
    # @see     java.io.StreamTokenizer#ttype
    attr_accessor :sval
    alias_method :attr_sval, :sval
    undef_method :sval
    alias_method :attr_sval=, :sval=
    undef_method :sval=
    
    # If the current token is a number, this field contains the value
    # of that number. The current token is a number when the value of
    # the <code>ttype</code> field is <code>TT_NUMBER</code>.
    # <p>
    # The initial value of this field is 0.0.
    # 
    # @see     java.io.StreamTokenizer#TT_NUMBER
    # @see     java.io.StreamTokenizer#ttype
    attr_accessor :nval
    alias_method :attr_nval, :nval
    undef_method :nval
    alias_method :attr_nval=, :nval=
    undef_method :nval=
    
    typesig { [] }
    # Private constructor that initializes everything except the streams.
    def initialize
      @reader = nil
      @input = nil
      @buf = CharArray.new(20)
      @peekc = NEED_CHAR
      @pushed_back = false
      @force_lower = false
      @lineno = 1
      @eol_is_significant_p = false
      @slash_slash_comments_p = false
      @slash_star_comments_p = false
      @ctype = Array.typed(::Java::Byte).new(256) { 0 }
      @ttype = TT_NOTHING
      @sval = nil
      @nval = 0.0
      word_chars(Character.new(?a.ord), Character.new(?z.ord))
      word_chars(Character.new(?A.ord), Character.new(?Z.ord))
      word_chars(128 + 32, 255)
      whitespace_chars(0, Character.new(?\s.ord))
      comment_char(Character.new(?/.ord))
      quote_char(Character.new(?".ord))
      quote_char(Character.new(?\'.ord))
      parse_numbers
    end
    
    typesig { [InputStream] }
    # Creates a stream tokenizer that parses the specified input
    # stream. The stream tokenizer is initialized to the following
    # default state:
    # <ul>
    # <li>All byte values <code>'A'</code> through <code>'Z'</code>,
    # <code>'a'</code> through <code>'z'</code>, and
    # <code>'&#92;u00A0'</code> through <code>'&#92;u00FF'</code> are
    # considered to be alphabetic.
    # <li>All byte values <code>'&#92;u0000'</code> through
    # <code>'&#92;u0020'</code> are considered to be white space.
    # <li><code>'/'</code> is a comment character.
    # <li>Single quote <code>'&#92;''</code> and double quote <code>'"'</code>
    # are string quote characters.
    # <li>Numbers are parsed.
    # <li>Ends of lines are treated as white space, not as separate tokens.
    # <li>C-style and C++-style comments are not recognized.
    # </ul>
    # 
    # @deprecated As of JDK version 1.1, the preferred way to tokenize an
    # input stream is to convert it into a character stream, for example:
    # <blockquote><pre>
    # Reader r = new BufferedReader(new InputStreamReader(is));
    # StreamTokenizer st = new StreamTokenizer(r);
    # </pre></blockquote>
    # 
    # @param      is        an input stream.
    # @see        java.io.BufferedReader
    # @see        java.io.InputStreamReader
    # @see        java.io.StreamTokenizer#StreamTokenizer(java.io.Reader)
    def initialize(is)
      initialize__stream_tokenizer()
      if ((is).nil?)
        raise NullPointerException.new
      end
      @input = is
    end
    
    typesig { [Reader] }
    # Create a tokenizer that parses the given character stream.
    # 
    # @param r  a Reader object providing the input stream.
    # @since   JDK1.1
    def initialize(r)
      initialize__stream_tokenizer()
      if ((r).nil?)
        raise NullPointerException.new
      end
      @reader = r
    end
    
    typesig { [] }
    # Resets this tokenizer's syntax table so that all characters are
    # "ordinary." See the <code>ordinaryChar</code> method
    # for more information on a character being ordinary.
    # 
    # @see     java.io.StreamTokenizer#ordinaryChar(int)
    def reset_syntax
      i = @ctype.attr_length
      while (i -= 1) >= 0
        @ctype[i] = 0
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Specifies that all characters <i>c</i> in the range
    # <code>low&nbsp;&lt;=&nbsp;<i>c</i>&nbsp;&lt;=&nbsp;high</code>
    # are word constituents. A word token consists of a word constituent
    # followed by zero or more word constituents or number constituents.
    # 
    # @param   low   the low end of the range.
    # @param   hi    the high end of the range.
    def word_chars(low, hi)
      if (low < 0)
        low = 0
      end
      if (hi >= @ctype.attr_length)
        hi = @ctype.attr_length - 1
      end
      while (low <= hi)
        @ctype[((low += 1) - 1)] |= CT_ALPHA
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Specifies that all characters <i>c</i> in the range
    # <code>low&nbsp;&lt;=&nbsp;<i>c</i>&nbsp;&lt;=&nbsp;high</code>
    # are white space characters. White space characters serve only to
    # separate tokens in the input stream.
    # 
    # <p>Any other attribute settings for the characters in the specified
    # range are cleared.
    # 
    # @param   low   the low end of the range.
    # @param   hi    the high end of the range.
    def whitespace_chars(low, hi)
      if (low < 0)
        low = 0
      end
      if (hi >= @ctype.attr_length)
        hi = @ctype.attr_length - 1
      end
      while (low <= hi)
        @ctype[((low += 1) - 1)] = CT_WHITESPACE
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Specifies that all characters <i>c</i> in the range
    # <code>low&nbsp;&lt;=&nbsp;<i>c</i>&nbsp;&lt;=&nbsp;high</code>
    # are "ordinary" in this tokenizer. See the
    # <code>ordinaryChar</code> method for more information on a
    # character being ordinary.
    # 
    # @param   low   the low end of the range.
    # @param   hi    the high end of the range.
    # @see     java.io.StreamTokenizer#ordinaryChar(int)
    def ordinary_chars(low, hi)
      if (low < 0)
        low = 0
      end
      if (hi >= @ctype.attr_length)
        hi = @ctype.attr_length - 1
      end
      while (low <= hi)
        @ctype[((low += 1) - 1)] = 0
      end
    end
    
    typesig { [::Java::Int] }
    # Specifies that the character argument is "ordinary"
    # in this tokenizer. It removes any special significance the
    # character has as a comment character, word component, string
    # delimiter, white space, or number character. When such a character
    # is encountered by the parser, the parser treats it as a
    # single-character token and sets <code>ttype</code> field to the
    # character value.
    # 
    # <p>Making a line terminator character "ordinary" may interfere
    # with the ability of a <code>StreamTokenizer</code> to count
    # lines. The <code>lineno</code> method may no longer reflect
    # the presence of such terminator characters in its line count.
    # 
    # @param   ch   the character.
    # @see     java.io.StreamTokenizer#ttype
    def ordinary_char(ch)
      if (ch >= 0 && ch < @ctype.attr_length)
        @ctype[ch] = 0
      end
    end
    
    typesig { [::Java::Int] }
    # Specified that the character argument starts a single-line
    # comment. All characters from the comment character to the end of
    # the line are ignored by this stream tokenizer.
    # 
    # <p>Any other attribute settings for the specified character are cleared.
    # 
    # @param   ch   the character.
    def comment_char(ch)
      if (ch >= 0 && ch < @ctype.attr_length)
        @ctype[ch] = CT_COMMENT
      end
    end
    
    typesig { [::Java::Int] }
    # Specifies that matching pairs of this character delimit string
    # constants in this tokenizer.
    # <p>
    # When the <code>nextToken</code> method encounters a string
    # constant, the <code>ttype</code> field is set to the string
    # delimiter and the <code>sval</code> field is set to the body of
    # the string.
    # <p>
    # If a string quote character is encountered, then a string is
    # recognized, consisting of all characters after (but not including)
    # the string quote character, up to (but not including) the next
    # occurrence of that same string quote character, or a line
    # terminator, or end of file. The usual escape sequences such as
    # <code>"&#92;n"</code> and <code>"&#92;t"</code> are recognized and
    # converted to single characters as the string is parsed.
    # 
    # <p>Any other attribute settings for the specified character are cleared.
    # 
    # @param   ch   the character.
    # @see     java.io.StreamTokenizer#nextToken()
    # @see     java.io.StreamTokenizer#sval
    # @see     java.io.StreamTokenizer#ttype
    def quote_char(ch)
      if (ch >= 0 && ch < @ctype.attr_length)
        @ctype[ch] = CT_QUOTE
      end
    end
    
    typesig { [] }
    # Specifies that numbers should be parsed by this tokenizer. The
    # syntax table of this tokenizer is modified so that each of the twelve
    # characters:
    # <blockquote><pre>
    # 0 1 2 3 4 5 6 7 8 9 . -
    # </pre></blockquote>
    # <p>
    # has the "numeric" attribute.
    # <p>
    # When the parser encounters a word token that has the format of a
    # double precision floating-point number, it treats the token as a
    # number rather than a word, by setting the <code>ttype</code>
    # field to the value <code>TT_NUMBER</code> and putting the numeric
    # value of the token into the <code>nval</code> field.
    # 
    # @see     java.io.StreamTokenizer#nval
    # @see     java.io.StreamTokenizer#TT_NUMBER
    # @see     java.io.StreamTokenizer#ttype
    def parse_numbers
      i = Character.new(?0.ord)
      while i <= Character.new(?9.ord)
        @ctype[i] |= CT_DIGIT
        ((i += 1) - 1)
      end
      @ctype[Character.new(?..ord)] |= CT_DIGIT
      @ctype[Character.new(?-.ord)] |= CT_DIGIT
    end
    
    typesig { [::Java::Boolean] }
    # Determines whether or not ends of line are treated as tokens.
    # If the flag argument is true, this tokenizer treats end of lines
    # as tokens; the <code>nextToken</code> method returns
    # <code>TT_EOL</code> and also sets the <code>ttype</code> field to
    # this value when an end of line is read.
    # <p>
    # A line is a sequence of characters ending with either a
    # carriage-return character (<code>'&#92;r'</code>) or a newline
    # character (<code>'&#92;n'</code>). In addition, a carriage-return
    # character followed immediately by a newline character is treated
    # as a single end-of-line token.
    # <p>
    # If the <code>flag</code> is false, end-of-line characters are
    # treated as white space and serve only to separate tokens.
    # 
    # @param   flag   <code>true</code> indicates that end-of-line characters
    # are separate tokens; <code>false</code> indicates that
    # end-of-line characters are white space.
    # @see     java.io.StreamTokenizer#nextToken()
    # @see     java.io.StreamTokenizer#ttype
    # @see     java.io.StreamTokenizer#TT_EOL
    def eol_is_significant(flag)
      @eol_is_significant_p = flag
    end
    
    typesig { [::Java::Boolean] }
    # Determines whether or not the tokenizer recognizes C-style comments.
    # If the flag argument is <code>true</code>, this stream tokenizer
    # recognizes C-style comments. All text between successive
    # occurrences of <code>/*</code> and <code>*&#47;</code> are discarded.
    # <p>
    # If the flag argument is <code>false</code>, then C-style comments
    # are not treated specially.
    # 
    # @param   flag   <code>true</code> indicates to recognize and ignore
    # C-style comments.
    def slash_star_comments(flag)
      @slash_star_comments_p = flag
    end
    
    typesig { [::Java::Boolean] }
    # Determines whether or not the tokenizer recognizes C++-style comments.
    # If the flag argument is <code>true</code>, this stream tokenizer
    # recognizes C++-style comments. Any occurrence of two consecutive
    # slash characters (<code>'/'</code>) is treated as the beginning of
    # a comment that extends to the end of the line.
    # <p>
    # If the flag argument is <code>false</code>, then C++-style
    # comments are not treated specially.
    # 
    # @param   flag   <code>true</code> indicates to recognize and ignore
    # C++-style comments.
    def slash_slash_comments(flag)
      @slash_slash_comments_p = flag
    end
    
    typesig { [::Java::Boolean] }
    # Determines whether or not word token are automatically lowercased.
    # If the flag argument is <code>true</code>, then the value in the
    # <code>sval</code> field is lowercased whenever a word token is
    # returned (the <code>ttype</code> field has the
    # value <code>TT_WORD</code> by the <code>nextToken</code> method
    # of this tokenizer.
    # <p>
    # If the flag argument is <code>false</code>, then the
    # <code>sval</code> field is not modified.
    # 
    # @param   fl   <code>true</code> indicates that all word tokens should
    # be lowercased.
    # @see     java.io.StreamTokenizer#nextToken()
    # @see     java.io.StreamTokenizer#ttype
    # @see     java.io.StreamTokenizer#TT_WORD
    def lower_case_mode(fl)
      @force_lower = fl
    end
    
    typesig { [] }
    # Read the next character
    def read
      if (!(@reader).nil?)
        return @reader.read
      else
        if (!(@input).nil?)
          return @input.read
        else
          raise IllegalStateException.new
        end
      end
    end
    
    typesig { [] }
    # Parses the next token from the input stream of this tokenizer.
    # The type of the next token is returned in the <code>ttype</code>
    # field. Additional information about the token may be in the
    # <code>nval</code> field or the <code>sval</code> field of this
    # tokenizer.
    # <p>
    # Typical clients of this
    # class first set up the syntax tables and then sit in a loop
    # calling nextToken to parse successive tokens until TT_EOF
    # is returned.
    # 
    # @return     the value of the <code>ttype</code> field.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.StreamTokenizer#nval
    # @see        java.io.StreamTokenizer#sval
    # @see        java.io.StreamTokenizer#ttype
    def next_token
      if (@pushed_back)
        @pushed_back = false
        return @ttype
      end
      ct = @ctype
      @sval = (nil).to_s
      c = @peekc
      if (c < 0)
        c = NEED_CHAR
      end
      if ((c).equal?(SKIP_LF))
        c = read
        if (c < 0)
          return @ttype = TT_EOF
        end
        if ((c).equal?(Character.new(?\n.ord)))
          c = NEED_CHAR
        end
      end
      if ((c).equal?(NEED_CHAR))
        c = read
        if (c < 0)
          return @ttype = TT_EOF
        end
      end
      @ttype = c
      # Just to be safe
      # Set peekc so that the next invocation of nextToken will read
      # another character unless peekc is reset in this invocation
      @peekc = NEED_CHAR
      ctype = c < 256 ? ct[c] : CT_ALPHA
      while (!((ctype & CT_WHITESPACE)).equal?(0))
        if ((c).equal?(Character.new(?\r.ord)))
          ((@lineno += 1) - 1)
          if (@eol_is_significant_p)
            @peekc = SKIP_LF
            return @ttype = TT_EOL
          end
          c = read
          if ((c).equal?(Character.new(?\n.ord)))
            c = read
          end
        else
          if ((c).equal?(Character.new(?\n.ord)))
            ((@lineno += 1) - 1)
            if (@eol_is_significant_p)
              return @ttype = TT_EOL
            end
          end
          c = read
        end
        if (c < 0)
          return @ttype = TT_EOF
        end
        ctype = c < 256 ? ct[c] : CT_ALPHA
      end
      if (!((ctype & CT_DIGIT)).equal?(0))
        neg = false
        if ((c).equal?(Character.new(?-.ord)))
          c = read
          if (!(c).equal?(Character.new(?..ord)) && (c < Character.new(?0.ord) || c > Character.new(?9.ord)))
            @peekc = c
            return @ttype = Character.new(?-.ord)
          end
          neg = true
        end
        v = 0
        decexp = 0
        seendot = 0
        while (true)
          if ((c).equal?(Character.new(?..ord)) && (seendot).equal?(0))
            seendot = 1
          else
            if (Character.new(?0.ord) <= c && c <= Character.new(?9.ord))
              v = v * 10 + (c - Character.new(?0.ord))
              decexp += seendot
            else
              break
            end
          end
          c = read
        end
        @peekc = c
        if (!(decexp).equal?(0))
          denom = 10
          ((decexp -= 1) + 1)
          while (decexp > 0)
            denom *= 10
            ((decexp -= 1) + 1)
          end
          # Do one division of a likely-to-be-more-accurate number
          v = v / denom
        end
        @nval = neg ? -v : v
        return @ttype = TT_NUMBER
      end
      if (!((ctype & CT_ALPHA)).equal?(0))
        i = 0
        begin
          if (i >= @buf.attr_length)
            @buf = Arrays.copy_of(@buf, @buf.attr_length * 2)
          end
          @buf[((i += 1) - 1)] = RJava.cast_to_char(c)
          c = read
          ctype = c < 0 ? CT_WHITESPACE : c < 256 ? ct[c] : CT_ALPHA
        end while (!((ctype & (CT_ALPHA | CT_DIGIT))).equal?(0))
        @peekc = c
        @sval = (String.copy_value_of(@buf, 0, i)).to_s
        if (@force_lower)
          @sval = (@sval.to_lower_case).to_s
        end
        return @ttype = TT_WORD
      end
      if (!((ctype & CT_QUOTE)).equal?(0))
        @ttype = c
        i = 0
        # Invariants (because \Octal needs a lookahead):
        # (i)  c contains char value
        # (ii) d contains the lookahead
        d = read
        while (d >= 0 && !(d).equal?(@ttype) && !(d).equal?(Character.new(?\n.ord)) && !(d).equal?(Character.new(?\r.ord)))
          if ((d).equal?(Character.new(?\\.ord)))
            c = read
            first = c
            # To allow \377, but not \477
            if (c >= Character.new(?0.ord) && c <= Character.new(?7.ord))
              c = c - Character.new(?0.ord)
              c2 = read
              if (Character.new(?0.ord) <= c2 && c2 <= Character.new(?7.ord))
                c = (c << 3) + (c2 - Character.new(?0.ord))
                c2 = read
                if (Character.new(?0.ord) <= c2 && c2 <= Character.new(?7.ord) && first <= Character.new(?3.ord))
                  c = (c << 3) + (c2 - Character.new(?0.ord))
                  d = read
                else
                  d = c2
                end
              else
                d = c2
              end
            else
              case (c)
              when Character.new(?a.ord)
                c = 0x7
              when Character.new(?b.ord)
                c = Character.new(?\b.ord)
              when Character.new(?f.ord)
                c = 0xc
              when Character.new(?n.ord)
                c = Character.new(?\n.ord)
              when Character.new(?r.ord)
                c = Character.new(?\r.ord)
              when Character.new(?t.ord)
                c = Character.new(?\t.ord)
              when Character.new(?v.ord)
                c = 0xb
              end
              d = read
            end
          else
            c = d
            d = read
          end
          if (i >= @buf.attr_length)
            @buf = Arrays.copy_of(@buf, @buf.attr_length * 2)
          end
          @buf[((i += 1) - 1)] = RJava.cast_to_char(c)
        end
        # If we broke out of the loop because we found a matching quote
        # character then arrange to read a new character next time
        # around; otherwise, save the character.
        @peekc = ((d).equal?(@ttype)) ? NEED_CHAR : d
        @sval = (String.copy_value_of(@buf, 0, i)).to_s
        return @ttype
      end
      if ((c).equal?(Character.new(?/.ord)) && (@slash_slash_comments_p || @slash_star_comments_p))
        c = read
        if ((c).equal?(Character.new(?*.ord)) && @slash_star_comments_p)
          prevc = 0
          while (!((c = read)).equal?(Character.new(?/.ord)) || !(prevc).equal?(Character.new(?*.ord)))
            if ((c).equal?(Character.new(?\r.ord)))
              ((@lineno += 1) - 1)
              c = read
              if ((c).equal?(Character.new(?\n.ord)))
                c = read
              end
            else
              if ((c).equal?(Character.new(?\n.ord)))
                ((@lineno += 1) - 1)
                c = read
              end
            end
            if (c < 0)
              return @ttype = TT_EOF
            end
            prevc = c
          end
          return next_token
        else
          if ((c).equal?(Character.new(?/.ord)) && @slash_slash_comments_p)
            while (!((c = read)).equal?(Character.new(?\n.ord)) && !(c).equal?(Character.new(?\r.ord)) && c >= 0)
            end
            @peekc = c
            return next_token
          else
            # Now see if it is still a single line comment
            if (!((ct[Character.new(?/.ord)] & CT_COMMENT)).equal?(0))
              while (!((c = read)).equal?(Character.new(?\n.ord)) && !(c).equal?(Character.new(?\r.ord)) && c >= 0)
              end
              @peekc = c
              return next_token
            else
              @peekc = c
              return @ttype = Character.new(?/.ord)
            end
          end
        end
      end
      if (!((ctype & CT_COMMENT)).equal?(0))
        while (!((c = read)).equal?(Character.new(?\n.ord)) && !(c).equal?(Character.new(?\r.ord)) && c >= 0)
        end
        @peekc = c
        return next_token
      end
      return @ttype = c
    end
    
    typesig { [] }
    # Causes the next call to the <code>nextToken</code> method of this
    # tokenizer to return the current value in the <code>ttype</code>
    # field, and not to modify the value in the <code>nval</code> or
    # <code>sval</code> field.
    # 
    # @see     java.io.StreamTokenizer#nextToken()
    # @see     java.io.StreamTokenizer#nval
    # @see     java.io.StreamTokenizer#sval
    # @see     java.io.StreamTokenizer#ttype
    def push_back
      if (!(@ttype).equal?(TT_NOTHING))
        # No-op if nextToken() not called
        @pushed_back = true
      end
    end
    
    typesig { [] }
    # Return the current line number.
    # 
    # @return  the current line number of this stream tokenizer.
    def lineno
      return @lineno
    end
    
    typesig { [] }
    # Returns the string representation of the current stream token and
    # the line number it occurs on.
    # 
    # <p>The precise string returned is unspecified, although the following
    # example can be considered typical:
    # 
    # <blockquote><pre>Token['a'], line 10</pre></blockquote>
    # 
    # @return  a string representation of the token
    # @see     java.io.StreamTokenizer#nval
    # @see     java.io.StreamTokenizer#sval
    # @see     java.io.StreamTokenizer#ttype
    def to_s
      ret = nil
      catch(:break_case) do
        case (@ttype)
        when TT_EOF
          ret = "EOF"
        when TT_EOL
          ret = "EOL"
        when TT_WORD
          ret = @sval
        when TT_NUMBER
          ret = "n=" + (@nval).to_s
        when TT_NOTHING
          ret = "NOTHING"
        else
          # ttype is the first character of either a quoted string or
          # is an ordinary character. ttype can definitely not be less
          # than 0, since those are reserved values used in the previous
          # case statements
          if (@ttype < 256 && (!((@ctype[@ttype] & CT_QUOTE)).equal?(0)))
            ret = @sval
            throw :break_case, :thrown
          end
          s = CharArray.new(3)
          s[0] = s[2] = Character.new(?\'.ord)
          s[1] = RJava.cast_to_char(@ttype)
          ret = (String.new(s)).to_s
        end
      end
      return "Token[" + ret + "], line " + (@lineno).to_s
    end
    
    private
    alias_method :initialize__stream_tokenizer, :initialize
  end
  
end

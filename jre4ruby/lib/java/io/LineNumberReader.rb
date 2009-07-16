require "rjava"

# 
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
module Java::Io
  module LineNumberReaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # A buffered character-input stream that keeps track of line numbers.  This
  # class defines methods {@link #setLineNumber(int)} and {@link
  # #getLineNumber()} for setting and getting the current line number
  # respectively.
  # 
  # <p> By default, line numbering begins at 0. This number increments at every
  # <a href="#lt">line terminator</a> as the data is read, and can be changed
  # with a call to <tt>setLineNumber(int)</tt>.  Note however, that
  # <tt>setLineNumber(int)</tt> does not actually change the current position in
  # the stream; it only changes the value that will be returned by
  # <tt>getLineNumber()</tt>.
  # 
  # <p> A line is considered to be <a name="lt">terminated</a> by any one of a
  # line feed ('\n'), a carriage return ('\r'), or a carriage return followed
  # immediately by a linefeed.
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class LineNumberReader < LineNumberReaderImports.const_get :BufferedReader
    include_class_members LineNumberReaderImports
    
    # The current line number
    attr_accessor :line_number
    alias_method :attr_line_number, :line_number
    undef_method :line_number
    alias_method :attr_line_number=, :line_number=
    undef_method :line_number=
    
    # The line number of the mark, if any
    attr_accessor :marked_line_number
    alias_method :attr_marked_line_number, :marked_line_number
    undef_method :marked_line_number
    alias_method :attr_marked_line_number=, :marked_line_number=
    undef_method :marked_line_number=
    
    # Defaults to 0
    # If the next character is a line feed, skip it
    attr_accessor :skip_lf
    alias_method :attr_skip_lf, :skip_lf
    undef_method :skip_lf
    alias_method :attr_skip_lf=, :skip_lf=
    undef_method :skip_lf=
    
    # The skipLF flag when the mark was set
    attr_accessor :marked_skip_lf
    alias_method :attr_marked_skip_lf, :marked_skip_lf
    undef_method :marked_skip_lf
    alias_method :attr_marked_skip_lf=, :marked_skip_lf=
    undef_method :marked_skip_lf=
    
    typesig { [Reader] }
    # 
    # Create a new line-numbering reader, using the default input-buffer
    # size.
    # 
    # @param  in
    # A Reader object to provide the underlying stream
    def initialize(in_)
      @line_number = 0
      @marked_line_number = 0
      @skip_lf = false
      @marked_skip_lf = false
      @skip_buffer = nil
      super(in_)
      @line_number = 0
      @skip_buffer = nil
    end
    
    typesig { [Reader, ::Java::Int] }
    # 
    # Create a new line-numbering reader, reading characters into a buffer of
    # the given size.
    # 
    # @param  in
    # A Reader object to provide the underlying stream
    # 
    # @param  sz
    # An int specifying the size of the buffer
    def initialize(in_, sz)
      @line_number = 0
      @marked_line_number = 0
      @skip_lf = false
      @marked_skip_lf = false
      @skip_buffer = nil
      super(in_, sz)
      @line_number = 0
      @skip_buffer = nil
    end
    
    typesig { [::Java::Int] }
    # 
    # Set the current line number.
    # 
    # @param  lineNumber
    # An int specifying the line number
    # 
    # @see #getLineNumber
    def set_line_number(line_number)
      @line_number = line_number
    end
    
    typesig { [] }
    # 
    # Get the current line number.
    # 
    # @return  The current line number
    # 
    # @see #setLineNumber
    def get_line_number
      return @line_number
    end
    
    typesig { [] }
    # 
    # Read a single character.  <a href="#lt">Line terminators</a> are
    # compressed into single newline ('\n') characters.  Whenever a line
    # terminator is read the current line number is incremented.
    # 
    # @return  The character read, or -1 if the end of the stream has been
    # reached
    # 
    # @throws  IOException
    # If an I/O error occurs
    def read
      synchronized((self.attr_lock)) do
        c = super
        if (@skip_lf)
          if ((c).equal?(Character.new(?\n.ord)))
            c = super
          end
          @skip_lf = false
        end
        case (c)
        when Character.new(?\r.ord)
          @skip_lf = true
          # Fall through
          ((@line_number += 1) - 1)
          return Character.new(?\n.ord)
        when Character.new(?\n.ord)
          # Fall through
          ((@line_number += 1) - 1)
          return Character.new(?\n.ord)
        end
        return c
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Read characters into a portion of an array.  Whenever a <a
    # href="#lt">line terminator</a> is read the current line number is
    # incremented.
    # 
    # @param  cbuf
    # Destination buffer
    # 
    # @param  off
    # Offset at which to start storing characters
    # 
    # @param  len
    # Maximum number of characters to read
    # 
    # @return  The number of bytes read, or -1 if the end of the stream has
    # already been reached
    # 
    # @throws  IOException
    # If an I/O error occurs
    def read(cbuf, off, len)
      synchronized((self.attr_lock)) do
        n = super(cbuf, off, len)
        i = off
        while i < off + n
          c = cbuf[i]
          if (@skip_lf)
            @skip_lf = false
            if ((c).equal?(Character.new(?\n.ord)))
              ((i += 1) - 1)
              next
            end
          end
          case (c)
          when Character.new(?\r.ord)
            @skip_lf = true
            # Fall through
            ((@line_number += 1) - 1)
          when Character.new(?\n.ord)
            # Fall through
            ((@line_number += 1) - 1)
          end
          ((i += 1) - 1)
        end
        return n
      end
    end
    
    typesig { [] }
    # 
    # Read a line of text.  Whenever a <a href="#lt">line terminator</a> is
    # read the current line number is incremented.
    # 
    # @return  A String containing the contents of the line, not including
    # any <a href="#lt">line termination characters</a>, or
    # <tt>null</tt> if the end of the stream has been reached
    # 
    # @throws  IOException
    # If an I/O error occurs
    def read_line
      synchronized((self.attr_lock)) do
        l = super(@skip_lf)
        @skip_lf = false
        if (!(l).nil?)
          ((@line_number += 1) - 1)
        end
        return l
      end
    end
    
    class_module.module_eval {
      # Maximum skip-buffer size
      const_set_lazy(:MaxSkipBufferSize) { 8192 }
      const_attr_reader  :MaxSkipBufferSize
    }
    
    # Skip buffer, null until allocated
    attr_accessor :skip_buffer
    alias_method :attr_skip_buffer, :skip_buffer
    undef_method :skip_buffer
    alias_method :attr_skip_buffer=, :skip_buffer=
    undef_method :skip_buffer=
    
    typesig { [::Java::Long] }
    # 
    # Skip characters.
    # 
    # @param  n
    # The number of characters to skip
    # 
    # @return  The number of characters actually skipped
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  IllegalArgumentException
    # If <tt>n</tt> is negative
    def skip(n)
      if (n < 0)
        raise IllegalArgumentException.new("skip() value is negative")
      end
      nn = RJava.cast_to_int(Math.min(n, MaxSkipBufferSize))
      synchronized((self.attr_lock)) do
        if (((@skip_buffer).nil?) || (@skip_buffer.attr_length < nn))
          @skip_buffer = CharArray.new(nn)
        end
        r = n
        while (r > 0)
          nc = read(@skip_buffer, 0, RJava.cast_to_int(Math.min(r, nn)))
          if ((nc).equal?(-1))
            break
          end
          r -= nc
        end
        return n - r
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Mark the present position in the stream.  Subsequent calls to reset()
    # will attempt to reposition the stream to this point, and will also reset
    # the line number appropriately.
    # 
    # @param  readAheadLimit
    # Limit on the number of characters that may be read while still
    # preserving the mark.  After reading this many characters,
    # attempting to reset the stream may fail.
    # 
    # @throws  IOException
    # If an I/O error occurs
    def mark(read_ahead_limit)
      synchronized((self.attr_lock)) do
        super(read_ahead_limit)
        @marked_line_number = @line_number
        @marked_skip_lf = @skip_lf
      end
    end
    
    typesig { [] }
    # 
    # Reset the stream to the most recent mark.
    # 
    # @throws  IOException
    # If the stream has not been marked, or if the mark has been
    # invalidated
    def reset
      synchronized((self.attr_lock)) do
        super
        @line_number = @marked_line_number
        @skip_lf = @marked_skip_lf
      end
    end
    
    private
    alias_method :initialize__line_number_reader, :initialize
  end
  
end

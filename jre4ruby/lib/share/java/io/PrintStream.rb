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
module Java::Io
  module PrintStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Formatter
      include_const ::Java::Util, :Locale
    }
  end
  
  # A <code>PrintStream</code> adds functionality to another output stream,
  # namely the ability to print representations of various data values
  # conveniently.  Two other features are provided as well.  Unlike other output
  # streams, a <code>PrintStream</code> never throws an
  # <code>IOException</code>; instead, exceptional situations merely set an
  # internal flag that can be tested via the <code>checkError</code> method.
  # Optionally, a <code>PrintStream</code> can be created so as to flush
  # automatically; this means that the <code>flush</code> method is
  # automatically invoked after a byte array is written, one of the
  # <code>println</code> methods is invoked, or a newline character or byte
  # (<code>'\n'</code>) is written.
  # 
  # <p> All characters printed by a <code>PrintStream</code> are converted into
  # bytes using the platform's default character encoding.  The <code>{@link
  # PrintWriter}</code> class should be used in situations that require writing
  # characters rather than bytes.
  # 
  # @author     Frank Yellin
  # @author     Mark Reinhold
  # @since      JDK1.0
  class PrintStream < PrintStreamImports.const_get :FilterOutputStream
    include_class_members PrintStreamImports
    overload_protected {
      include Appendable
      include Closeable
    }
    
    attr_accessor :auto_flush
    alias_method :attr_auto_flush, :auto_flush
    undef_method :auto_flush
    alias_method :attr_auto_flush=, :auto_flush=
    undef_method :auto_flush=
    
    attr_accessor :trouble
    alias_method :attr_trouble, :trouble
    undef_method :trouble
    alias_method :attr_trouble=, :trouble=
    undef_method :trouble=
    
    attr_accessor :formatter
    alias_method :attr_formatter, :formatter
    undef_method :formatter
    alias_method :attr_formatter=, :formatter=
    undef_method :formatter=
    
    # Track both the text- and character-output streams, so that their buffers
    # can be flushed without flushing the entire stream.
    attr_accessor :text_out
    alias_method :attr_text_out, :text_out
    undef_method :text_out
    alias_method :attr_text_out=, :text_out=
    undef_method :text_out=
    
    attr_accessor :char_out
    alias_method :attr_char_out, :char_out
    undef_method :char_out
    alias_method :attr_char_out=, :char_out=
    undef_method :char_out=
    
    typesig { [OutputStream] }
    # Creates a new print stream.  This stream will not flush automatically.
    # 
    # @param  out        The output stream to which values and objects will be
    # printed
    # 
    # @see java.io.PrintWriter#PrintWriter(java.io.OutputStream)
    def initialize(out)
      initialize__print_stream(out, false)
    end
    
    typesig { [::Java::Boolean, OutputStream] }
    # Initialization is factored into a private constructor (note the swapped
    # parameters so that this one isn't confused with the public one) and a
    # separate init method so that the following two public constructors can
    # share code.  We use a separate init method so that the constructor that
    # takes an encoding will throw an NPE for a null stream before it throws
    # an UnsupportedEncodingException for an unsupported encoding.
    def initialize(auto_flush, out)
      @auto_flush = false
      @trouble = false
      @formatter = nil
      @text_out = nil
      @char_out = nil
      @closing = false
      super(out)
      @auto_flush = false
      @trouble = false
      @closing = false
      if ((out).nil?)
        raise NullPointerException.new("Null output stream")
      end
      @auto_flush = auto_flush
    end
    
    typesig { [OutputStreamWriter] }
    def init(osw)
      @char_out = osw
      @text_out = BufferedWriter.new(osw)
    end
    
    typesig { [OutputStream, ::Java::Boolean] }
    # Creates a new print stream.
    # 
    # @param  out        The output stream to which values and objects will be
    # printed
    # @param  autoFlush  A boolean; if true, the output buffer will be flushed
    # whenever a byte array is written, one of the
    # <code>println</code> methods is invoked, or a newline
    # character or byte (<code>'\n'</code>) is written
    # 
    # @see java.io.PrintWriter#PrintWriter(java.io.OutputStream, boolean)
    def initialize(out, auto_flush)
      initialize__print_stream(auto_flush, out)
      init(OutputStreamWriter.new(self))
    end
    
    typesig { [OutputStream, ::Java::Boolean, String] }
    # Creates a new print stream.
    # 
    # @param  out        The output stream to which values and objects will be
    # printed
    # @param  autoFlush  A boolean; if true, the output buffer will be flushed
    # whenever a byte array is written, one of the
    # <code>println</code> methods is invoked, or a newline
    # character or byte (<code>'\n'</code>) is written
    # @param  encoding   The name of a supported
    # <a href="../lang/package-summary.html#charenc">
    # character encoding</a>
    # 
    # @throws  UnsupportedEncodingException
    # If the named encoding is not supported
    # 
    # @since  1.4
    def initialize(out, auto_flush, encoding)
      initialize__print_stream(auto_flush, out)
      init(OutputStreamWriter.new(self, encoding))
    end
    
    typesig { [String] }
    # Creates a new print stream, without automatic line flushing, with the
    # specified file name.  This convenience constructor creates
    # the necessary intermediate {@link java.io.OutputStreamWriter
    # OutputStreamWriter}, which will encode characters using the
    # {@linkplain java.nio.charset.Charset#defaultCharset() default charset}
    # for this instance of the Java virtual machine.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this print
    # stream.  If the file exists, then it will be truncated to
    # zero size; otherwise, a new file will be created.  The output
    # will be written to the file and is buffered.
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(fileName)} denies write
    # access to the file
    # 
    # @since  1.5
    def initialize(file_name)
      initialize__print_stream(false, FileOutputStream.new(file_name))
      init(OutputStreamWriter.new(self))
    end
    
    typesig { [String, String] }
    # Creates a new print stream, without automatic line flushing, with the
    # specified file name and charset.  This convenience constructor creates
    # the necessary intermediate {@link java.io.OutputStreamWriter
    # OutputStreamWriter}, which will encode characters using the provided
    # charset.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this print
    # stream.  If the file exists, then it will be truncated to
    # zero size; otherwise, a new file will be created.  The output
    # will be written to the file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(fileName)} denies write
    # access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @since  1.5
    def initialize(file_name, csn)
      initialize__print_stream(false, FileOutputStream.new(file_name))
      init(OutputStreamWriter.new(self, csn))
    end
    
    typesig { [JavaFile] }
    # Creates a new print stream, without automatic line flushing, with the
    # specified file.  This convenience constructor creates the necessary
    # intermediate {@link java.io.OutputStreamWriter OutputStreamWriter},
    # which will encode characters using the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # @param  file
    # The file to use as the destination of this print stream.  If the
    # file exists, then it will be truncated to zero size; otherwise,
    # a new file will be created.  The output will be written to the
    # file and is buffered.
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(file.getPath())}
    # denies write access to the file
    # 
    # @since  1.5
    def initialize(file)
      initialize__print_stream(false, FileOutputStream.new(file))
      init(OutputStreamWriter.new(self))
    end
    
    typesig { [JavaFile, String] }
    # Creates a new print stream, without automatic line flushing, with the
    # specified file and charset.  This convenience constructor creates
    # the necessary intermediate {@link java.io.OutputStreamWriter
    # OutputStreamWriter}, which will encode characters using the provided
    # charset.
    # 
    # @param  file
    # The file to use as the destination of this print stream.  If the
    # file exists, then it will be truncated to zero size; otherwise,
    # a new file will be created.  The output will be written to the
    # file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is presentand {@link
    # SecurityManager#checkWrite checkWrite(file.getPath())}
    # denies write access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @since  1.5
    def initialize(file, csn)
      initialize__print_stream(false, FileOutputStream.new(file))
      init(OutputStreamWriter.new(self, csn))
    end
    
    typesig { [] }
    # Check to make sure that the stream has not been closed
    def ensure_open
      if ((self.attr_out).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # Flushes the stream.  This is done by writing any buffered output bytes to
    # the underlying output stream and then flushing that stream.
    # 
    # @see        java.io.OutputStream#flush()
    def flush
      synchronized((self)) do
        begin
          ensure_open
          self.attr_out.flush
        rescue IOException => x
          @trouble = true
        end
      end
    end
    
    attr_accessor :closing
    alias_method :attr_closing, :closing
    undef_method :closing
    alias_method :attr_closing=, :closing=
    undef_method :closing=
    
    typesig { [] }
    # To avoid recursive closing
    # 
    # Closes the stream.  This is done by flushing the stream and then closing
    # the underlying output stream.
    # 
    # @see        java.io.OutputStream#close()
    def close
      synchronized((self)) do
        if (!@closing)
          @closing = true
          begin
            @text_out.close
            self.attr_out.close
          rescue IOException => x
            @trouble = true
          end
          @text_out = nil
          @char_out = nil
          self.attr_out = nil
        end
      end
    end
    
    typesig { [] }
    # Flushes the stream and checks its error state. The internal error state
    # is set to <code>true</code> when the underlying output stream throws an
    # <code>IOException</code> other than <code>InterruptedIOException</code>,
    # and when the <code>setError</code> method is invoked.  If an operation
    # on the underlying output stream throws an
    # <code>InterruptedIOException</code>, then the <code>PrintStream</code>
    # converts the exception back into an interrupt by doing:
    # <pre>
    # Thread.currentThread().interrupt();
    # </pre>
    # or the equivalent.
    # 
    # @return <code>true</code> if and only if this stream has encountered an
    # <code>IOException</code> other than
    # <code>InterruptedIOException</code>, or the
    # <code>setError</code> method has been invoked
    def check_error
      if (!(self.attr_out).nil?)
        flush
      end
      if (self.attr_out.is_a?(Java::Io::PrintStream))
        ps = self.attr_out
        return ps.check_error
      end
      return @trouble
    end
    
    typesig { [] }
    # Sets the error state of the stream to <code>true</code>.
    # 
    # <p> This method will cause subsequent invocations of {@link
    # #checkError()} to return <tt>true</tt> until {@link
    # #clearError()} is invoked.
    # 
    # @since JDK1.1
    def set_error
      @trouble = true
    end
    
    typesig { [] }
    # Clears the internal error state of this stream.
    # 
    # <p> This method will cause subsequent invocations of {@link
    # #checkError()} to return <tt>false</tt> until another write
    # operation fails and invokes {@link #setError()}.
    # 
    # @since 1.6
    def clear_error
      @trouble = false
    end
    
    typesig { [::Java::Int] }
    # Exception-catching, synchronized output operations,
    # which also implement the write() methods of OutputStream
    # 
    # 
    # Writes the specified byte to this stream.  If the byte is a newline and
    # automatic flushing is enabled then the <code>flush</code> method will be
    # invoked.
    # 
    # <p> Note that the byte is written as given; to write a character that
    # will be translated according to the platform's default character
    # encoding, use the <code>print(char)</code> or <code>println(char)</code>
    # methods.
    # 
    # @param  b  The byte to be written
    # @see #print(char)
    # @see #println(char)
    def write(b)
      begin
        synchronized((self)) do
          ensure_open
          self.attr_out.write(b)
          if (((b).equal?(Character.new(?\n.ord))) && @auto_flush)
            self.attr_out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified byte array starting at
    # offset <code>off</code> to this stream.  If automatic flushing is
    # enabled then the <code>flush</code> method will be invoked.
    # 
    # <p> Note that the bytes will be written as given; to write characters
    # that will be translated according to the platform's default character
    # encoding, use the <code>print(char)</code> or <code>println(char)</code>
    # methods.
    # 
    # @param  buf   A byte array
    # @param  off   Offset from which to start taking bytes
    # @param  len   Number of bytes to write
    def write(buf, off, len)
      begin
        synchronized((self)) do
          ensure_open
          self.attr_out.write(buf, off, len)
          if (@auto_flush)
            self.attr_out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # The following private methods on the text- and character-output streams
    # always flush the stream buffers, so that writes to the underlying byte
    # stream occur as promptly as with the original PrintStream.
    def write(buf)
      begin
        synchronized((self)) do
          ensure_open
          @text_out.write(buf)
          @text_out.flush_buffer
          @char_out.flush_buffer
          if (@auto_flush)
            i = 0
            while i < buf.attr_length
              if ((buf[i]).equal?(Character.new(?\n.ord)))
                self.attr_out.flush
              end
              i += 1
            end
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [String] }
    def write(s)
      begin
        synchronized((self)) do
          ensure_open
          @text_out.write(s)
          @text_out.flush_buffer
          @char_out.flush_buffer
          if (@auto_flush && (s.index_of(Character.new(?\n.ord)) >= 0))
            self.attr_out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [] }
    def new_line
      begin
        synchronized((self)) do
          ensure_open
          @text_out.new_line
          @text_out.flush_buffer
          @char_out.flush_buffer
          if (@auto_flush)
            self.attr_out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [::Java::Boolean] }
    # Methods that do not terminate lines
    # 
    # Prints a boolean value.  The string produced by <code>{@link
    # java.lang.String#valueOf(boolean)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      b   The <code>boolean</code> to be printed
    def print(b)
      write(b ? "true" : "false")
    end
    
    typesig { [::Java::Char] }
    # Prints a character.  The character is translated into one or more bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      c   The <code>char</code> to be printed
    def print(c)
      write(String.value_of(c))
    end
    
    typesig { [::Java::Int] }
    # Prints an integer.  The string produced by <code>{@link
    # java.lang.String#valueOf(int)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      i   The <code>int</code> to be printed
    # @see        java.lang.Integer#toString(int)
    def print(i)
      write(String.value_of(i))
    end
    
    typesig { [::Java::Long] }
    # Prints a long integer.  The string produced by <code>{@link
    # java.lang.String#valueOf(long)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      l   The <code>long</code> to be printed
    # @see        java.lang.Long#toString(long)
    def print(l)
      write(String.value_of(l))
    end
    
    typesig { [::Java::Float] }
    # Prints a floating-point number.  The string produced by <code>{@link
    # java.lang.String#valueOf(float)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      f   The <code>float</code> to be printed
    # @see        java.lang.Float#toString(float)
    def print(f)
      write(String.value_of(f))
    end
    
    typesig { [::Java::Double] }
    # Prints a double-precision floating-point number.  The string produced by
    # <code>{@link java.lang.String#valueOf(double)}</code> is translated into
    # bytes according to the platform's default character encoding, and these
    # bytes are written in exactly the manner of the <code>{@link
    # #write(int)}</code> method.
    # 
    # @param      d   The <code>double</code> to be printed
    # @see        java.lang.Double#toString(double)
    def print(d)
      write(String.value_of(d))
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Prints an array of characters.  The characters are converted into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      s   The array of chars to be printed
    # 
    # @throws  NullPointerException  If <code>s</code> is <code>null</code>
    def print(s)
      write(s)
    end
    
    typesig { [String] }
    # Prints a string.  If the argument is <code>null</code> then the string
    # <code>"null"</code> is printed.  Otherwise, the string's characters are
    # converted into bytes according to the platform's default character
    # encoding, and these bytes are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      s   The <code>String</code> to be printed
    def print(s)
      if ((s).nil?)
        s = "null"
      end
      write(s)
    end
    
    typesig { [Object] }
    # Prints an object.  The string produced by the <code>{@link
    # java.lang.String#valueOf(Object)}</code> method is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the
    # <code>{@link #write(int)}</code> method.
    # 
    # @param      obj   The <code>Object</code> to be printed
    # @see        java.lang.Object#toString()
    def print(obj)
      write(String.value_of(obj))
    end
    
    typesig { [] }
    # Methods that do terminate lines
    # 
    # Terminates the current line by writing the line separator string.  The
    # line separator string is defined by the system property
    # <code>line.separator</code>, and is not necessarily a single newline
    # character (<code>'\n'</code>).
    def println
      new_line
    end
    
    typesig { [::Java::Boolean] }
    # Prints a boolean and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(boolean)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>boolean</code> to be printed
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [::Java::Char] }
    # Prints a character and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(char)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>char</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [::Java::Int] }
    # Prints an integer and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(int)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>int</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [::Java::Long] }
    # Prints a long and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(long)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  a The <code>long</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [::Java::Float] }
    # Prints a float and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(float)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>float</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [::Java::Double] }
    # Prints a double and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(double)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>double</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Prints an array of characters and then terminate the line.  This method
    # behaves as though it invokes <code>{@link #print(char[])}</code> and
    # then <code>{@link #println()}</code>.
    # 
    # @param x  an array of chars to print.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [String] }
    # Prints a String and then terminate the line.  This method behaves as
    # though it invokes <code>{@link #print(String)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>String</code> to be printed.
    def println(x)
      synchronized((self)) do
        print(x)
        new_line
      end
    end
    
    typesig { [Object] }
    # Prints an Object and then terminate the line.  This method calls
    # at first String.valueOf(x) to get the printed object's string value,
    # then behaves as
    # though it invokes <code>{@link #print(String)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>Object</code> to be printed.
    def println(x)
      s = String.value_of(x)
      synchronized((self)) do
        print(s)
        new_line
      end
    end
    
    typesig { [String, Object] }
    # A convenience method to write a formatted string to this output stream
    # using the specified format string and arguments.
    # 
    # <p> An invocation of this method of the form <tt>out.printf(format,
    # args)</tt> behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.format(format, args) </pre>
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>
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
    # @return  This output stream
    # 
    # @since  1.5
    def printf(format, *args)
      return format(format, args)
    end
    
    typesig { [Locale, String, Object] }
    # A convenience method to write a formatted string to this output stream
    # using the specified format string and arguments.
    # 
    # <p> An invocation of this method of the form <tt>out.printf(l, format,
    # args)</tt> behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.format(l, format, args) </pre>
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>
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
    # @return  This output stream
    # 
    # @since  1.5
    def printf(l, format_, *args)
      return format(l, format_, args)
    end
    
    typesig { [String, Object] }
    # Writes a formatted string to this output stream using the specified
    # format string and arguments.
    # 
    # <p> The locale always used is the one returned by {@link
    # java.util.Locale#getDefault() Locale.getDefault()}, regardless of any
    # previous invocations of other formatting methods on this object.
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>
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
    # @return  This output stream
    # 
    # @since  1.5
    def format(format_, *args)
      begin
        synchronized((self)) do
          ensure_open
          if (((@formatter).nil?) || (!(@formatter.locale).equal?(Locale.get_default)))
            @formatter = Formatter.new(self)
          end
          @formatter.format(Locale.get_default, format_, args)
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
      return self
    end
    
    typesig { [Locale, String, Object] }
    # Writes a formatted string to this output stream using the specified
    # format string and arguments.
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>
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
    # @return  This output stream
    # 
    # @since  1.5
    def format(l, format_, *args)
      begin
        synchronized((self)) do
          ensure_open
          if (((@formatter).nil?) || (!(@formatter.locale).equal?(l)))
            @formatter = Formatter.new(self, l)
          end
          @formatter.format(l, format_, args)
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
      return self
    end
    
    typesig { [CharSequence] }
    # Appends the specified character sequence to this output stream.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.print(csq.toString()) </pre>
    # 
    # <p> Depending on the specification of <tt>toString</tt> for the
    # character sequence <tt>csq</tt>, the entire sequence may not be
    # appended.  For instance, invoking then <tt>toString</tt> method of a
    # character buffer will return a subsequence whose content depends upon
    # the buffer's position and limit.
    # 
    # @param  csq
    # The character sequence to append.  If <tt>csq</tt> is
    # <tt>null</tt>, then the four characters <tt>"null"</tt> are
    # appended to this output stream.
    # 
    # @return  This output stream
    # 
    # @since  1.5
    def append(csq)
      if ((csq).nil?)
        print("null")
      else
        print(csq.to_s)
      end
      return self
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # Appends a subsequence of the specified character sequence to this output
    # stream.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq, start,
    # end)</tt> when <tt>csq</tt> is not <tt>null</tt>, behaves in
    # exactly the same way as the invocation
    # 
    # <pre>
    # out.print(csq.subSequence(start, end).toString()) </pre>
    # 
    # @param  csq
    # The character sequence from which a subsequence will be
    # appended.  If <tt>csq</tt> is <tt>null</tt>, then characters
    # will be appended as if <tt>csq</tt> contained the four
    # characters <tt>"null"</tt>.
    # 
    # @param  start
    # The index of the first character in the subsequence
    # 
    # @param  end
    # The index of the character following the last character in the
    # subsequence
    # 
    # @return  This output stream
    # 
    # @throws  IndexOutOfBoundsException
    # If <tt>start</tt> or <tt>end</tt> are negative, <tt>start</tt>
    # is greater than <tt>end</tt>, or <tt>end</tt> is greater than
    # <tt>csq.length()</tt>
    # 
    # @since  1.5
    def append(csq, start, end_)
      cs = ((csq).nil? ? "null" : csq)
      write(cs.sub_sequence(start, end_).to_s)
      return self
    end
    
    typesig { [::Java::Char] }
    # Appends the specified character to this output stream.
    # 
    # <p> An invocation of this method of the form <tt>out.append(c)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.print(c) </pre>
    # 
    # @param  c
    # The 16-bit character to append
    # 
    # @return  This output stream
    # 
    # @since  1.5
    def append(c)
      print(c)
      return self
    end
    
    private
    alias_method :initialize__print_stream, :initialize
  end
  
end

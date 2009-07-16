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
  module PrintWriterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Formatter
      include_const ::Java::Util, :Locale
    }
  end
  
  # 
  # Prints formatted representations of objects to a text-output stream.  This
  # class implements all of the <tt>print</tt> methods found in {@link
  # PrintStream}.  It does not contain methods for writing raw bytes, for which
  # a program should use unencoded byte streams.
  # 
  # <p> Unlike the {@link PrintStream} class, if automatic flushing is enabled
  # it will be done only when one of the <tt>println</tt>, <tt>printf</tt>, or
  # <tt>format</tt> methods is invoked, rather than whenever a newline character
  # happens to be output.  These methods use the platform's own notion of line
  # separator rather than the newline character.
  # 
  # <p> Methods in this class never throw I/O exceptions, although some of its
  # constructors may.  The client may inquire as to whether any errors have
  # occurred by invoking {@link #checkError checkError()}.
  # 
  # @author      Frank Yellin
  # @author      Mark Reinhold
  # @since       JDK1.1
  class PrintWriter < PrintWriterImports.const_get :Writer
    include_class_members PrintWriterImports
    
    # 
    # The underlying character-output stream of this
    # <code>PrintWriter</code>.
    # 
    # @since 1.2
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
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
    
    attr_accessor :ps_out
    alias_method :attr_ps_out, :ps_out
    undef_method :ps_out
    alias_method :attr_ps_out=, :ps_out=
    undef_method :ps_out=
    
    # 
    # Line separator string.  This is the value of the line.separator
    # property at the moment that the stream was created.
    attr_accessor :line_separator
    alias_method :attr_line_separator, :line_separator
    undef_method :line_separator
    alias_method :attr_line_separator=, :line_separator=
    undef_method :line_separator=
    
    typesig { [Writer] }
    # 
    # Creates a new PrintWriter, without automatic line flushing.
    # 
    # @param  out        A character-output stream
    def initialize(out)
      initialize__print_writer(out, false)
    end
    
    typesig { [Writer, ::Java::Boolean] }
    # 
    # Creates a new PrintWriter.
    # 
    # @param  out        A character-output stream
    # @param  autoFlush  A boolean; if true, the <tt>println</tt>,
    # <tt>printf</tt>, or <tt>format</tt> methods will
    # flush the output buffer
    def initialize(out, auto_flush)
      @out = nil
      @auto_flush = false
      @trouble = false
      @formatter = nil
      @ps_out = nil
      @line_separator = nil
      super(out)
      @auto_flush = false
      @trouble = false
      @ps_out = nil
      @out = out
      @auto_flush = auto_flush
      @line_separator = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("line.separator"))).to_s
    end
    
    typesig { [OutputStream] }
    # 
    # Creates a new PrintWriter, without automatic line flushing, from an
    # existing OutputStream.  This convenience constructor creates the
    # necessary intermediate OutputStreamWriter, which will convert characters
    # into bytes using the default character encoding.
    # 
    # @param  out        An output stream
    # 
    # @see java.io.OutputStreamWriter#OutputStreamWriter(java.io.OutputStream)
    def initialize(out)
      initialize__print_writer(out, false)
    end
    
    typesig { [OutputStream, ::Java::Boolean] }
    # 
    # Creates a new PrintWriter from an existing OutputStream.  This
    # convenience constructor creates the necessary intermediate
    # OutputStreamWriter, which will convert characters into bytes using the
    # default character encoding.
    # 
    # @param  out        An output stream
    # @param  autoFlush  A boolean; if true, the <tt>println</tt>,
    # <tt>printf</tt>, or <tt>format</tt> methods will
    # flush the output buffer
    # 
    # @see java.io.OutputStreamWriter#OutputStreamWriter(java.io.OutputStream)
    def initialize(out, auto_flush)
      initialize__print_writer(BufferedWriter.new(OutputStreamWriter.new(out)), auto_flush)
      # save print stream for error propagation
      if (out.is_a?(Java::Io::PrintStream))
        @ps_out = out
      end
    end
    
    typesig { [String] }
    # 
    # Creates a new PrintWriter, without automatic line flushing, with the
    # specified file name.  This convenience constructor creates the necessary
    # intermediate {@link java.io.OutputStreamWriter OutputStreamWriter},
    # which will encode characters using the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this writer.
    # If the file exists then it will be truncated to zero size;
    # otherwise, a new file will be created.  The output will be
    # written to the file and is buffered.
    # 
    # @throws  FileNotFoundException
    # If the given string does not denote an existing, writable
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
      initialize__print_writer(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file_name))), false)
    end
    
    typesig { [String, String] }
    # 
    # Creates a new PrintWriter, without automatic line flushing, with the
    # specified file name and charset.  This convenience constructor creates
    # the necessary intermediate {@link java.io.OutputStreamWriter
    # OutputStreamWriter}, which will encode characters using the provided
    # charset.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this writer.
    # If the file exists then it will be truncated to zero size;
    # otherwise, a new file will be created.  The output will be
    # written to the file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  FileNotFoundException
    # If the given string does not denote an existing, writable
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
      initialize__print_writer(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file_name), csn)), false)
    end
    
    typesig { [JavaFile] }
    # 
    # Creates a new PrintWriter, without automatic line flushing, with the
    # specified file.  This convenience constructor creates the necessary
    # intermediate {@link java.io.OutputStreamWriter OutputStreamWriter},
    # which will encode characters using the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # @param  file
    # The file to use as the destination of this writer.  If the file
    # exists then it will be truncated to zero size; otherwise, a new
    # file will be created.  The output will be written to the file
    # and is buffered.
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
      initialize__print_writer(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file))), false)
    end
    
    typesig { [JavaFile, String] }
    # 
    # Creates a new PrintWriter, without automatic line flushing, with the
    # specified file and charset.  This convenience constructor creates the
    # necessary intermediate {@link java.io.OutputStreamWriter
    # OutputStreamWriter}, which will encode characters using the provided
    # charset.
    # 
    # @param  file
    # The file to use as the destination of this writer.  If the file
    # exists then it will be truncated to zero size; otherwise, a new
    # file will be created.  The output will be written to the file
    # and is buffered.
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
    # SecurityManager#checkWrite checkWrite(file.getPath())}
    # denies write access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    # 
    # @since  1.5
    def initialize(file, csn)
      initialize__print_writer(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file), csn)), false)
    end
    
    typesig { [] }
    # Checks to make sure that the stream has not been closed
    def ensure_open
      if ((@out).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [] }
    # 
    # Flushes the stream.
    # @see #checkError()
    def flush
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          @out.flush
        end
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [] }
    # 
    # Closes the stream and releases any system resources associated
    # with it. Closing a previously closed stream has no effect.
    # 
    # @see #checkError()
    def close
      begin
        synchronized((self.attr_lock)) do
          if ((@out).nil?)
            return
          end
          @out.close
          @out = nil
        end
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [] }
    # 
    # Flushes the stream if it's not closed and checks its error state.
    # 
    # @return <code>true</code> if the print stream has encountered an error,
    # either on the underlying output stream or during a format
    # conversion.
    def check_error
      if (!(@out).nil?)
        flush
      end
      if (@out.is_a?(Java::Io::PrintWriter))
        pw = @out
        return pw.check_error
      else
        if (!(@ps_out).nil?)
          return @ps_out.check_error
        end
      end
      return @trouble
    end
    
    typesig { [] }
    # 
    # Indicates that an error has occurred.
    # 
    # <p> This method will cause subsequent invocations of {@link
    # #checkError()} to return <tt>true</tt> until {@link
    # #clearError()} is invoked.
    def set_error
      @trouble = true
    end
    
    typesig { [] }
    # 
    # Clears the error state of this stream.
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
    # 
    # Exception-catching, synchronized output operations,
    # which also implement the write() methods of Writer
    # 
    # 
    # Writes a single character.
    # @param c int specifying a character to be written.
    def write(c)
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          @out.write(c)
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # 
    # Writes A Portion of an array of characters.
    # @param buf Array of characters
    # @param off Offset from which to start writing characters
    # @param len Number of characters to write
    def write(buf, off, len)
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          @out.write(buf, off, len)
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # 
    # Writes an array of characters.  This method cannot be inherited from the
    # Writer class because it must suppress I/O exceptions.
    # @param buf Array of characters to be written
    def write(buf)
      write(buf, 0, buf.attr_length)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # 
    # Writes a portion of a string.
    # @param s A String
    # @param off Offset from which to start writing characters
    # @param len Number of characters to write
    def write(s, off, len)
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          @out.write(s, off, len)
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
    end
    
    typesig { [String] }
    # 
    # Writes a string.  This method cannot be inherited from the Writer class
    # because it must suppress I/O exceptions.
    # @param s String to be written
    def write(s)
      write(s, 0, s.length)
    end
    
    typesig { [] }
    def new_line
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          @out.write(@line_separator)
          if (@auto_flush)
            @out.flush
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
    # are written in exactly the manner of the <code>{@link
    # #write(int)}</code> method.
    # 
    # @param      b   The <code>boolean</code> to be printed
    def print(b)
      write(b ? "true" : "false")
    end
    
    typesig { [::Java::Char] }
    # 
    # Prints a character.  The character is translated into one or more bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the <code>{@link
    # #write(int)}</code> method.
    # 
    # @param      c   The <code>char</code> to be printed
    def print(c)
      write(c)
    end
    
    typesig { [::Java::Int] }
    # 
    # Prints an integer.  The string produced by <code>{@link
    # java.lang.String#valueOf(int)}</code> is translated into bytes according
    # to the platform's default character encoding, and these bytes are
    # written in exactly the manner of the <code>{@link #write(int)}</code>
    # method.
    # 
    # @param      i   The <code>int</code> to be printed
    # @see        java.lang.Integer#toString(int)
    def print(i)
      write(String.value_of(i))
    end
    
    typesig { [::Java::Long] }
    # 
    # Prints a long integer.  The string produced by <code>{@link
    # java.lang.String#valueOf(long)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the <code>{@link #write(int)}</code>
    # method.
    # 
    # @param      l   The <code>long</code> to be printed
    # @see        java.lang.Long#toString(long)
    def print(l)
      write(String.value_of(l))
    end
    
    typesig { [::Java::Float] }
    # 
    # Prints a floating-point number.  The string produced by <code>{@link
    # java.lang.String#valueOf(float)}</code> is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the <code>{@link #write(int)}</code>
    # method.
    # 
    # @param      f   The <code>float</code> to be printed
    # @see        java.lang.Float#toString(float)
    def print(f)
      write(String.value_of(f))
    end
    
    typesig { [::Java::Double] }
    # 
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
    # 
    # Prints an array of characters.  The characters are converted into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the <code>{@link #write(int)}</code>
    # method.
    # 
    # @param      s   The array of chars to be printed
    # 
    # @throws  NullPointerException  If <code>s</code> is <code>null</code>
    def print(s)
      write(s)
    end
    
    typesig { [String] }
    # 
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
    # 
    # Prints an object.  The string produced by the <code>{@link
    # java.lang.String#valueOf(Object)}</code> method is translated into bytes
    # according to the platform's default character encoding, and these bytes
    # are written in exactly the manner of the <code>{@link #write(int)}</code>
    # method.
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
    # 
    # Prints a boolean value and then terminates the line.  This method behaves
    # as though it invokes <code>{@link #print(boolean)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x the <code>boolean</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [::Java::Char] }
    # 
    # Prints a character and then terminates the line.  This method behaves as
    # though it invokes <code>{@link #print(char)}</code> and then <code>{@link
    # #println()}</code>.
    # 
    # @param x the <code>char</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [::Java::Int] }
    # 
    # Prints an integer and then terminates the line.  This method behaves as
    # though it invokes <code>{@link #print(int)}</code> and then <code>{@link
    # #println()}</code>.
    # 
    # @param x the <code>int</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [::Java::Long] }
    # 
    # Prints a long integer and then terminates the line.  This method behaves
    # as though it invokes <code>{@link #print(long)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x the <code>long</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [::Java::Float] }
    # 
    # Prints a floating-point number and then terminates the line.  This method
    # behaves as though it invokes <code>{@link #print(float)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x the <code>float</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [::Java::Double] }
    # 
    # Prints a double-precision floating-point number and then terminates the
    # line.  This method behaves as though it invokes <code>{@link
    # #print(double)}</code> and then <code>{@link #println()}</code>.
    # 
    # @param x the <code>double</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # 
    # Prints an array of characters and then terminates the line.  This method
    # behaves as though it invokes <code>{@link #print(char[])}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x the array of <code>char</code> values to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [String] }
    # 
    # Prints a String and then terminates the line.  This method behaves as
    # though it invokes <code>{@link #print(String)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x the <code>String</code> value to be printed
    def println(x)
      synchronized((self.attr_lock)) do
        print(x)
        println
      end
    end
    
    typesig { [Object] }
    # 
    # Prints an Object and then terminates the line.  This method calls
    # at first String.valueOf(x) to get the printed object's string value,
    # then behaves as
    # though it invokes <code>{@link #print(String)}</code> and then
    # <code>{@link #println()}</code>.
    # 
    # @param x  The <code>Object</code> to be printed.
    def println(x)
      s = String.value_of(x)
      synchronized((self.attr_lock)) do
        print(s)
        println
      end
    end
    
    typesig { [String, Object] }
    # 
    # A convenience method to write a formatted string to this writer using
    # the specified format string and arguments.  If automatic flushing is
    # enabled, calls to this method will flush the output buffer.
    # 
    # <p> An invocation of this method of the form <tt>out.printf(format,
    # args)</tt> behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.format(format, args) </pre>
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>.
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
    # @return  This writer
    # 
    # @since  1.5
    def printf(format, *args)
      return format(format, args)
    end
    
    typesig { [Locale, String, Object] }
    # 
    # A convenience method to write a formatted string to this writer using
    # the specified format string and arguments.  If automatic flushing is
    # enabled, calls to this method will flush the output buffer.
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
    # href="../util/Formatter.html#syntax">Format string syntax</a>.
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
    # @return  This writer
    # 
    # @since  1.5
    def printf(l, format_, *args)
      return format(l, format_, args)
    end
    
    typesig { [String, Object] }
    # 
    # Writes a formatted string to this writer using the specified format
    # string and arguments.  If automatic flushing is enabled, calls to this
    # method will flush the output buffer.
    # 
    # <p> The locale always used is the one returned by {@link
    # java.util.Locale#getDefault() Locale.getDefault()}, regardless of any
    # previous invocations of other formatting methods on this object.
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>.
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
    # Formatter class specification.
    # 
    # @throws  NullPointerException
    # If the <tt>format</tt> is <tt>null</tt>
    # 
    # @return  This writer
    # 
    # @since  1.5
    def format(format_, *args)
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          if (((@formatter).nil?) || (!(@formatter.locale).equal?(Locale.get_default)))
            @formatter = Formatter.new(self)
          end
          @formatter.format(Locale.get_default, format_, args)
          if (@auto_flush)
            @out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
      return self
    end
    
    typesig { [Locale, String, Object] }
    # 
    # Writes a formatted string to this writer using the specified format
    # string and arguments.  If automatic flushing is enabled, calls to this
    # method will flush the output buffer.
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @param  format
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>.
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
    # @return  This writer
    # 
    # @since  1.5
    def format(l, format_, *args)
      begin
        synchronized((self.attr_lock)) do
          ensure_open
          if (((@formatter).nil?) || (!(@formatter.locale).equal?(l)))
            @formatter = Formatter.new(self, l)
          end
          @formatter.format(l, format_, args)
          if (@auto_flush)
            @out.flush
          end
        end
      rescue InterruptedIOException => x
        JavaThread.current_thread.interrupt
      rescue IOException => x
        @trouble = true
      end
      return self
    end
    
    typesig { [CharSequence] }
    # 
    # Appends the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.toString()) </pre>
    # 
    # <p> Depending on the specification of <tt>toString</tt> for the
    # character sequence <tt>csq</tt>, the entire sequence may not be
    # appended. For instance, invoking the <tt>toString</tt> method of a
    # character buffer will return a subsequence whose content depends upon
    # the buffer's position and limit.
    # 
    # @param  csq
    # The character sequence to append.  If <tt>csq</tt> is
    # <tt>null</tt>, then the four characters <tt>"null"</tt> are
    # appended to this writer.
    # 
    # @return  This writer
    # 
    # @since  1.5
    def append(csq)
      if ((csq).nil?)
        write("null")
      else
        write(csq.to_s)
      end
      return self
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    # 
    # Appends a subsequence of the specified character sequence to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(csq, start,
    # end)</tt> when <tt>csq</tt> is not <tt>null</tt>, behaves in
    # exactly the same way as the invocation
    # 
    # <pre>
    # out.write(csq.subSequence(start, end).toString()) </pre>
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
    # @return  This writer
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
    # 
    # Appends the specified character to this writer.
    # 
    # <p> An invocation of this method of the form <tt>out.append(c)</tt>
    # behaves in exactly the same way as the invocation
    # 
    # <pre>
    # out.write(c) </pre>
    # 
    # @param  c
    # The 16-bit character to append
    # 
    # @return  This writer
    # 
    # @since 1.5
    def append(c)
      write(c)
      return self
    end
    
    private
    alias_method :initialize__print_writer, :initialize
  end
  
end

require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ConsoleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Sun::Nio::Cs, :StreamDecoder
      include_const ::Sun::Nio::Cs, :StreamEncoder
    }
  end
  
  # Methods to access the character-based console device, if any, associated
  # with the current Java virtual machine.
  # 
  # <p> Whether a virtual machine has a console is dependent upon the
  # underlying platform and also upon the manner in which the virtual
  # machine is invoked.  If the virtual machine is started from an
  # interactive command line without redirecting the standard input and
  # output streams then its console will exist and will typically be
  # connected to the keyboard and display from which the virtual machine
  # was launched.  If the virtual machine is started automatically, for
  # example by a background job scheduler, then it will typically not
  # have a console.
  # <p>
  # If this virtual machine has a console then it is represented by a
  # unique instance of this class which can be obtained by invoking the
  # {@link java.lang.System#console()} method.  If no console device is
  # available then an invocation of that method will return <tt>null</tt>.
  # <p>
  # Read and write operations are synchronized to guarantee the atomic
  # completion of critical operations; therefore invoking methods
  # {@link #readLine()}, {@link #readPassword()}, {@link #format format()},
  # {@link #printf printf()} as well as the read, format and write operations
  # on the objects returned by {@link #reader()} and {@link #writer()} may
  # block in multithreaded scenarios.
  # <p>
  # Invoking <tt>close()</tt> on the objects returned by the {@link #reader()}
  # and the {@link #writer()} will not close the underlying stream of those
  # objects.
  # <p>
  # The console-read methods return <tt>null</tt> when the end of the
  # console input stream is reached, for example by typing control-D on
  # Unix or control-Z on Windows.  Subsequent read operations will succeed
  # if additional characters are later entered on the console's input
  # device.
  # <p>
  # Unless otherwise specified, passing a <tt>null</tt> argument to any method
  # in this class will cause a {@link NullPointerException} to be thrown.
  # <p>
  # <b>Security note:</b>
  # If an application needs to read a password or other secure data, it should
  # use {@link #readPassword()} or {@link #readPassword(String, Object...)} and
  # manually zero the returned character array after processing to minimize the
  # lifetime of sensitive data in memory.
  # 
  # <blockquote><pre>
  # Console cons;
  # char[] passwd;
  # if ((cons = System.console()) != null &&
  # (passwd = cons.readPassword("[%s]", "Password:")) != null) {
  # ...
  # java.util.Arrays.fill(passwd, ' ');
  # }
  # </pre></blockquote>
  # 
  # @author  Xueming Shen
  # @since   1.6
  class Console 
    include_class_members ConsoleImports
    include Flushable
    
    typesig { [] }
    # Retrieves the unique {@link java.io.PrintWriter PrintWriter} object
    # associated with this console.
    # 
    # @return  The printwriter associated with this console
    def writer
      return @pw
    end
    
    typesig { [] }
    # Retrieves the unique {@link java.io.Reader Reader} object associated
    # with this console.
    # <p>
    # This method is intended to be used by sophisticated applications, for
    # example, a {@link java.util.Scanner} object which utilizes the rich
    # parsing/scanning functionality provided by the <tt>Scanner</tt>:
    # <blockquote><pre>
    # Console con = System.console();
    # if (con != null) {
    # Scanner sc = new Scanner(con.reader());
    # ...
    # }
    # </pre></blockquote>
    # <p>
    # For simple applications requiring only line-oriented reading, use
    # <tt>{@link #readLine}</tt>.
    # <p>
    # The bulk read operations {@link java.io.Reader#read(char[]) read(char[]) },
    # {@link java.io.Reader#read(char[], int, int) read(char[], int, int) } and
    # {@link java.io.Reader#read(java.nio.CharBuffer) read(java.nio.CharBuffer)}
    # on the returned object will not read in characters beyond the line
    # bound for each invocation, even if the destination buffer has space for
    # more characters. A line bound is considered to be any one of a line feed
    # (<tt>'\n'</tt>), a carriage return (<tt>'\r'</tt>), a carriage return
    # followed immediately by a linefeed, or an end of stream.
    # 
    # @return  The reader associated with this console
    def reader
      return @reader
    end
    
    typesig { [String, Vararg.new(Object)] }
    # Writes a formatted string to this console's output stream using
    # the specified format string and arguments.
    # 
    # @param  fmt
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
    # href="../util/Formatter.html#detail">Details</a> section
    # of the formatter class specification.
    # 
    # @return  This console
    def format(fmt, *args)
      @formatter.format(fmt, args).flush
      return self
    end
    
    typesig { [String, Array.typed(Object)] }
    def format(fmt, args)
      format(fmt, *args)
    end
    
    typesig { [String, Vararg.new(Object)] }
    # A convenience method to write a formatted string to this console's
    # output stream using the specified format string and arguments.
    # 
    # <p> An invocation of this method of the form <tt>con.printf(format,
    # args)</tt> behaves in exactly the same way as the invocation of
    # <pre>con.format(format, args)</pre>.
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
    # @return  This console
    def printf(format_, *args)
      return format(format_, args)
    end
    
    typesig { [String, Array.typed(Object)] }
    def printf(format_, args)
      printf(format_, *args)
    end
    
    typesig { [String, Vararg.new(Object)] }
    # Provides a formatted prompt, then reads a single line of text from the
    # console.
    # 
    # @param  fmt
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>.
    # 
    # @param  args
    # Arguments referenced by the format specifiers in the format
    # string.  If there are more arguments than format specifiers, the
    # extra arguments are ignored.  The maximum number of arguments is
    # limited by the maximum dimension of a Java array as defined by
    # the <a href="http://java.sun.com/docs/books/vmspec/">Java
    # Virtual Machine Specification</a>.
    # 
    # @throws  IllegalFormatException
    # If a format string contains an illegal syntax, a format
    # specifier that is incompatible with the given arguments,
    # insufficient arguments given the format string, or other
    # illegal conditions.  For specification of all possible
    # formatting errors, see the <a
    # href="../util/Formatter.html#detail">Details</a> section
    # of the formatter class specification.
    # 
    # @throws IOError
    # If an I/O error occurs.
    # 
    # @return  A string containing the line read from the console, not
    # including any line-termination characters, or <tt>null</tt>
    # if an end of stream has been reached.
    def read_line(fmt, *args)
      line = nil
      synchronized((@write_lock)) do
        synchronized((@read_lock)) do
          if (!(fmt.length).equal?(0))
            @pw.format(fmt, args)
          end
          begin
            ca = readline(false)
            if (!(ca).nil?)
              line = RJava.cast_to_string(String.new(ca))
            end
          rescue IOException => x
            raise IOError.new(x)
          end
        end
      end
      return line
    end
    
    typesig { [String, Array.typed(Object)] }
    def read_line(fmt, args)
      read_line(fmt, *args)
    end
    
    typesig { [] }
    # Reads a single line of text from the console.
    # 
    # @throws IOError
    # If an I/O error occurs.
    # 
    # @return  A string containing the line read from the console, not
    # including any line-termination characters, or <tt>null</tt>
    # if an end of stream has been reached.
    def read_line
      return read_line("")
    end
    
    typesig { [String, Vararg.new(Object)] }
    # Provides a formatted prompt, then reads a password or passphrase from
    # the console with echoing disabled.
    # 
    # @param  fmt
    # A format string as described in <a
    # href="../util/Formatter.html#syntax">Format string syntax</a>
    # for the prompt text.
    # 
    # @param  args
    # Arguments referenced by the format specifiers in the format
    # string.  If there are more arguments than format specifiers, the
    # extra arguments are ignored.  The maximum number of arguments is
    # limited by the maximum dimension of a Java array as defined by
    # the <a href="http://java.sun.com/docs/books/vmspec/">Java
    # Virtual Machine Specification</a>.
    # 
    # @throws  IllegalFormatException
    # If a format string contains an illegal syntax, a format
    # specifier that is incompatible with the given arguments,
    # insufficient arguments given the format string, or other
    # illegal conditions.  For specification of all possible
    # formatting errors, see the <a
    # href="../util/Formatter.html#detail">Details</a>
    # section of the formatter class specification.
    # 
    # @throws IOError
    # If an I/O error occurs.
    # 
    # @return  A character array containing the password or passphrase read
    # from the console, not including any line-termination characters,
    # or <tt>null</tt> if an end of stream has been reached.
    def read_password(fmt, *args)
      passwd = nil
      synchronized((@write_lock)) do
        synchronized((@read_lock)) do
          if (!(fmt.length).equal?(0))
            @pw.format(fmt, args)
          end
          begin
            self.attr_echo_off = echo(false)
            passwd = readline(true)
          rescue IOException => x
            raise IOError.new(x)
          ensure
            begin
              self.attr_echo_off = echo(true)
            rescue IOException => xx
            end
          end
          @pw.println
        end
      end
      return passwd
    end
    
    typesig { [String, Array.typed(Object)] }
    def read_password(fmt, args)
      read_password(fmt, *args)
    end
    
    typesig { [] }
    # Reads a password or passphrase from the console with echoing disabled
    # 
    # @throws IOError
    # If an I/O error occurs.
    # 
    # @return  A character array containing the password or passphrase read
    # from the console, not including any line-termination characters,
    # or <tt>null</tt> if an end of stream has been reached.
    def read_password
      return read_password("")
    end
    
    typesig { [] }
    # Flushes the console and forces any buffered output to be written
    # immediately .
    def flush
      @pw.flush
    end
    
    attr_accessor :read_lock
    alias_method :attr_read_lock, :read_lock
    undef_method :read_lock
    alias_method :attr_read_lock=, :read_lock=
    undef_method :read_lock=
    
    attr_accessor :write_lock
    alias_method :attr_write_lock, :write_lock
    undef_method :write_lock
    alias_method :attr_write_lock=, :write_lock=
    undef_method :write_lock=
    
    attr_accessor :reader
    alias_method :attr_reader, :reader
    undef_method :reader
    alias_method :attr_reader=, :reader=
    undef_method :reader=
    
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    attr_accessor :pw
    alias_method :attr_pw, :pw
    undef_method :pw
    alias_method :attr_pw=, :pw=
    undef_method :pw=
    
    attr_accessor :formatter
    alias_method :attr_formatter, :formatter
    undef_method :formatter
    alias_method :attr_formatter=, :formatter=
    undef_method :formatter=
    
    attr_accessor :cs
    alias_method :attr_cs, :cs
    undef_method :cs
    alias_method :attr_cs=, :cs=
    undef_method :cs=
    
    attr_accessor :rcb
    alias_method :attr_rcb, :rcb
    undef_method :rcb
    alias_method :attr_rcb=, :rcb=
    undef_method :rcb=
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_io_Console_encoding, [:pointer, :long], :long
      typesig { [] }
      def encoding
        JNI.call_native_method(:Java_java_io_Console_encoding, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_java_io_Console_echo, [:pointer, :long, :int8], :int8
      typesig { [::Java::Boolean] }
      def echo(on)
        JNI.call_native_method(:Java_java_io_Console_echo, JNI.env, self.jni_id, on ? 1 : 0) != 0
      end
      
      
      def echo_off
        defined?(@@echo_off) ? @@echo_off : @@echo_off= false
      end
      alias_method :attr_echo_off, :echo_off
      
      def echo_off=(value)
        @@echo_off = value
      end
      alias_method :attr_echo_off=, :echo_off=
    }
    
    typesig { [::Java::Boolean] }
    def readline(zero_out)
      len = @reader.read(@rcb, 0, @rcb.attr_length)
      if (len < 0)
        return nil
      end # EOL
      if ((@rcb[len - 1]).equal?(Character.new(?\r.ord)))
        len -= 1
         # remove CR at end;
      else
        if ((@rcb[len - 1]).equal?(Character.new(?\n.ord)))
          len -= 1 # remove LF at end;
          if (len > 0 && (@rcb[len - 1]).equal?(Character.new(?\r.ord)))
            len -= 1
          end # remove the CR, if there is one
        end
      end
      b = CharArray.new(len)
      if (len > 0)
        System.arraycopy(@rcb, 0, b, 0, len)
        if (zero_out)
          Arrays.fill(@rcb, 0, len, Character.new(?\s.ord))
        end
      end
      return b
    end
    
    typesig { [] }
    def grow
      raise AssertError if not (JavaThread.holds_lock(@read_lock))
      t = CharArray.new(@rcb.attr_length * 2)
      System.arraycopy(@rcb, 0, t, 0, @rcb.attr_length)
      @rcb = t
      return @rcb
    end
    
    class_module.module_eval {
      const_set_lazy(:LineReader) { Class.new(Reader) do
        extend LocalClass
        include_class_members Console
        
        attr_accessor :in
        alias_method :attr_in, :in
        undef_method :in
        alias_method :attr_in=, :in=
        undef_method :in=
        
        attr_accessor :cb
        alias_method :attr_cb, :cb
        undef_method :cb
        alias_method :attr_cb=, :cb=
        undef_method :cb=
        
        attr_accessor :n_chars
        alias_method :attr_n_chars, :n_chars
        undef_method :n_chars
        alias_method :attr_n_chars=, :n_chars=
        undef_method :n_chars=
        
        attr_accessor :next_char
        alias_method :attr_next_char, :next_char
        undef_method :next_char
        alias_method :attr_next_char=, :next_char=
        undef_method :next_char=
        
        attr_accessor :leftover_lf
        alias_method :attr_leftover_lf, :leftover_lf
        undef_method :leftover_lf
        alias_method :attr_leftover_lf=, :leftover_lf=
        undef_method :leftover_lf=
        
        typesig { [class_self::Reader] }
        def initialize(in_)
          @in = nil
          @cb = nil
          @n_chars = 0
          @next_char = 0
          @leftover_lf = false
          super()
          @in = in_
          @cb = CharArray.new(1024)
          @next_char = @n_chars = 0
          @leftover_lf = false
        end
        
        typesig { [] }
        def close
        end
        
        typesig { [] }
        def ready
          # in.ready synchronizes on readLock already
          return @in.ready
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        def read(cbuf, offset, length)
          off = offset
          end_ = offset + length
          if (offset < 0 || offset > cbuf.attr_length || length < 0 || end_ < 0 || end_ > cbuf.attr_length)
            raise self.class::IndexOutOfBoundsException.new
          end
          synchronized((self.attr_read_lock)) do
            eof = false
            c = 0
            loop do
              if (@next_char >= @n_chars)
                # fill
                n = 0
                begin
                  n = @in.read(@cb, 0, @cb.attr_length)
                end while ((n).equal?(0))
                if (n > 0)
                  @n_chars = n
                  @next_char = 0
                  if (n < @cb.attr_length && !(@cb[n - 1]).equal?(Character.new(?\n.ord)) && !(@cb[n - 1]).equal?(Character.new(?\r.ord)))
                    # we're in canonical mode so each "fill" should
                    # come back with an eol. if there no lf or nl at
                    # the end of returned bytes we reached an eof.
                    eof = true
                  end
                else
                  # EOF
                  if ((off - offset).equal?(0))
                    return -1
                  end
                  return off - offset
                end
              end
              if (@leftover_lf && (cbuf).equal?(self.attr_rcb) && (@cb[@next_char]).equal?(Character.new(?\n.ord)))
                # if invoked by our readline, skip the leftover, otherwise
                # return the LF.
                @next_char += 1
              end
              @leftover_lf = false
              while (@next_char < @n_chars)
                c = cbuf[((off += 1) - 1)] = @cb[@next_char]
                @cb[((@next_char += 1) - 1)] = 0
                if ((c).equal?(Character.new(?\n.ord)))
                  return off - offset
                else
                  if ((c).equal?(Character.new(?\r.ord)))
                    if ((off).equal?(end_))
                      # no space left even the next is LF, so return
                      # whatever we have if the invoker is not our
                      # readLine()
                      if ((cbuf).equal?(self.attr_rcb))
                        cbuf = grow
                        end_ = cbuf.attr_length
                      else
                        @leftover_lf = true
                        return off - offset
                      end
                    end
                    if ((@next_char).equal?(@n_chars) && @in.ready)
                      # we have a CR and we reached the end of
                      # the read in buffer, fill to make sure we
                      # don't miss a LF, if there is one, it's possible
                      # that it got cut off during last round reading
                      # simply because the read in buffer was full.
                      @n_chars = @in.read(@cb, 0, @cb.attr_length)
                      @next_char = 0
                    end
                    if (@next_char < @n_chars && (@cb[@next_char]).equal?(Character.new(?\n.ord)))
                      cbuf[((off += 1) - 1)] = Character.new(?\n.ord)
                      @next_char += 1
                    end
                    return off - offset
                  else
                    if ((off).equal?(end_))
                      if ((cbuf).equal?(self.attr_rcb))
                        cbuf = grow
                        end_ = cbuf.attr_length
                      else
                        return off - offset
                      end
                    end
                  end
                end
              end
              if (eof)
                return off - offset
              end
            end
          end
        end
        
        private
        alias_method :initialize__line_reader, :initialize
      end }
      
      # Set up JavaIOAccess in SharedSecrets
      when_class_loaded do
        Sun::Misc::SharedSecrets.set_java_ioaccess(Class.new(Sun::Misc::JavaIOAccess.class == Class ? Sun::Misc::JavaIOAccess : Object) do
          extend LocalClass
          include_class_members Console
          include Sun::Misc::JavaIOAccess if Sun::Misc::JavaIOAccess.class == Module
          
          typesig { [] }
          define_method :console do
            if (istty)
              if ((self.attr_cons).nil?)
                self.attr_cons = self.class::Console.new
              end
              return self.attr_cons
            end
            return nil
          end
          
          typesig { [] }
          # Add a shutdown hook to restore console's echo state should
          # it be necessary.
          define_method :console_restore_hook do
            java_ioaccess_class = self.class
            return Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members java_ioaccess_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                begin
                  if (self.attr_echo_off)
                    echo(true)
                  end
                rescue self.class::IOException => x
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          
          typesig { [] }
          define_method :charset do
            # This method is called in sun.security.util.Password,
            # cons already exists when this method is called
            return self.attr_cons.attr_cs
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      
      def cons
        defined?(@@cons) ? @@cons : @@cons= nil
      end
      alias_method :attr_cons, :cons
      
      def cons=(value)
        @@cons = value
      end
      alias_method :attr_cons=, :cons=
      
      JNI.load_native_method :Java_java_io_Console_istty, [:pointer, :long], :int8
      typesig { [] }
      def istty
        JNI.call_native_method(:Java_java_io_Console_istty, JNI.env, self.jni_id) != 0
      end
    }
    
    typesig { [] }
    def initialize
      @read_lock = nil
      @write_lock = nil
      @reader = nil
      @out = nil
      @pw = nil
      @formatter = nil
      @cs = nil
      @rcb = nil
      @read_lock = Object.new
      @write_lock = Object.new
      csname = encoding
      if (!(csname).nil?)
        begin
          @cs = Charset.for_name(csname)
        rescue JavaException => x
        end
      end
      if ((@cs).nil?)
        @cs = Charset.default_charset
      end
      @out = StreamEncoder.for_output_stream_writer(FileOutputStream.new(FileDescriptor.attr_out), @write_lock, @cs)
      @pw = Class.new(PrintWriter.class == Class ? PrintWriter : Object) do
        extend LocalClass
        include_class_members Console
        include PrintWriter if PrintWriter.class == Module
        
        typesig { [] }
        define_method :close do
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, @out, true)
      @formatter = Formatter.new(@out)
      @reader = LineReader.new_local(self, StreamDecoder.for_input_stream_reader(FileInputStream.new(FileDescriptor.attr_in), @read_lock, @cs))
      @rcb = CharArray.new(1024)
    end
    
    private
    alias_method :initialize__console, :initialize
  end
  
end

require "rjava"

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
module Java::Io
  module PushbackInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # A <code>PushbackInputStream</code> adds
  # functionality to another input stream, namely
  # the  ability to "push back" or "unread"
  # one byte. This is useful in situations where
  # it is  convenient for a fragment of code
  # to read an indefinite number of data bytes
  # that  are delimited by a particular byte
  # value; after reading the terminating byte,
  # the  code fragment can "unread" it, so that
  # the next read operation on the input stream
  # will reread the byte that was pushed back.
  # For example, bytes representing the  characters
  # constituting an identifier might be terminated
  # by a byte representing an  operator character;
  # a method whose job is to read just an identifier
  # can read until it  sees the operator and
  # then push the operator back to be re-read.
  # 
  # @author  David Connelly
  # @author  Jonathan Payne
  # @since   JDK1.0
  class PushbackInputStream < PushbackInputStreamImports.const_get :FilterInputStream
    include_class_members PushbackInputStreamImports
    
    # The pushback buffer.
    # @since   JDK1.1
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # The position within the pushback buffer from which the next byte will
    # be read.  When the buffer is empty, <code>pos</code> is equal to
    # <code>buf.length</code>; when the buffer is full, <code>pos</code> is
    # equal to zero.
    # 
    # @since   JDK1.1
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    typesig { [] }
    # Check to make sure that this stream has not been closed
    def ensure_open
      if ((self.attr_in).nil?)
        raise IOException.new("Stream closed")
      end
    end
    
    typesig { [InputStream, ::Java::Int] }
    # Creates a <code>PushbackInputStream</code>
    # with a pushback buffer of the specified <code>size</code>,
    # and saves its  argument, the input stream
    # <code>in</code>, for later use. Initially,
    # there is no pushed-back byte  (the field
    # <code>pushBack</code> is initialized to
    # <code>-1</code>).
    # 
    # @param  in    the input stream from which bytes will be read.
    # @param  size  the size of the pushback buffer.
    # @exception IllegalArgumentException if size is <= 0
    # @since  JDK1.1
    def initialize(in_, size)
      @buf = nil
      @pos = 0
      super(in_)
      if (size <= 0)
        raise IllegalArgumentException.new("size <= 0")
      end
      @buf = Array.typed(::Java::Byte).new(size) { 0 }
      @pos = size
    end
    
    typesig { [InputStream] }
    # Creates a <code>PushbackInputStream</code>
    # and saves its  argument, the input stream
    # <code>in</code>, for later use. Initially,
    # there is no pushed-back byte  (the field
    # <code>pushBack</code> is initialized to
    # <code>-1</code>).
    # 
    # @param   in   the input stream from which bytes will be read.
    def initialize(in_)
      initialize__pushback_input_stream(in_, 1)
    end
    
    typesig { [] }
    # Reads the next byte of data from this input stream. The value
    # byte is returned as an <code>int</code> in the range
    # <code>0</code> to <code>255</code>. If no byte is available
    # because the end of the stream has been reached, the value
    # <code>-1</code> is returned. This method blocks until input data
    # is available, the end of the stream is detected, or an exception
    # is thrown.
    # 
    # <p> This method returns the most recently pushed-back byte, if there is
    # one, and otherwise calls the <code>read</code> method of its underlying
    # input stream and returns whatever value that method returns.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # stream has been reached.
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    # @see        java.io.InputStream#read()
    def read
      ensure_open
      if (@pos < @buf.attr_length)
        return @buf[((@pos += 1) - 1)] & 0xff
      end
      return super
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads up to <code>len</code> bytes of data from this input stream into
    # an array of bytes.  This method first reads any pushed-back bytes; after
    # that, if fewer than <code>len</code> bytes have been read then it
    # reads from the underlying input stream. If <code>len</code> is not zero, the method
    # blocks until at least 1 byte of input is available; otherwise, no
    # bytes are read and <code>0</code> is returned.
    # 
    # @param      b     the buffer into which the data is read.
    # @param      off   the start offset in the destination array <code>b</code>
    # @param      len   the maximum number of bytes read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the stream has been reached.
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    # @see        java.io.InputStream#read(byte[], int, int)
    def read(b, off, len)
      ensure_open
      if ((b).nil?)
        raise NullPointerException.new
      else
        if (off < 0 || len < 0 || len > b.attr_length - off)
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
      end
      avail = @buf.attr_length - @pos
      if (avail > 0)
        if (len < avail)
          avail = len
        end
        System.arraycopy(@buf, @pos, b, off, avail)
        @pos += avail
        off += avail
        len -= avail
      end
      if (len > 0)
        len = super(b, off, len)
        if ((len).equal?(-1))
          return (avail).equal?(0) ? -1 : avail
        end
        return avail + len
      end
      return avail
    end
    
    typesig { [::Java::Int] }
    # Pushes back a byte by copying it to the front of the pushback buffer.
    # After this method returns, the next byte to be read will have the value
    # <code>(byte)b</code>.
    # 
    # @param      b   the <code>int</code> value whose low-order
    # byte is to be pushed back.
    # @exception IOException If there is not enough room in the pushback
    # buffer for the byte, or this input stream has been closed by
    # invoking its {@link #close()} method.
    def unread(b)
      ensure_open
      if ((@pos).equal?(0))
        raise IOException.new("Push back buffer is full")
      end
      @buf[(@pos -= 1)] = b
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Pushes back a portion of an array of bytes by copying it to the front
    # of the pushback buffer.  After this method returns, the next byte to be
    # read will have the value <code>b[off]</code>, the byte after that will
    # have the value <code>b[off+1]</code>, and so forth.
    # 
    # @param b the byte array to push back.
    # @param off the start offset of the data.
    # @param len the number of bytes to push back.
    # @exception IOException If there is not enough room in the pushback
    # buffer for the specified number of bytes,
    # or this input stream has been closed by
    # invoking its {@link #close()} method.
    # @since     JDK1.1
    def unread(b, off, len)
      ensure_open
      if (len > @pos)
        raise IOException.new("Push back buffer is full")
      end
      @pos -= len
      System.arraycopy(b, off, @buf, @pos, len)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Pushes back an array of bytes by copying it to the front of the
    # pushback buffer.  After this method returns, the next byte to be read
    # will have the value <code>b[0]</code>, the byte after that will have the
    # value <code>b[1]</code>, and so forth.
    # 
    # @param b the byte array to push back
    # @exception IOException If there is not enough room in the pushback
    # buffer for the specified number of bytes,
    # or this input stream has been closed by
    # invoking its {@link #close()} method.
    # @since     JDK1.1
    def unread(b)
      unread(b, 0, b.attr_length)
    end
    
    typesig { [] }
    # Returns an estimate of the number of bytes that can be read (or
    # skipped over) from this input stream without blocking by the next
    # invocation of a method for this input stream. The next invocation might be
    # the same thread or another thread.  A single read or skip of this
    # many bytes will not block, but may read or skip fewer bytes.
    # 
    # <p> The method returns the sum of the number of bytes that have been
    # pushed back and the value returned by {@link
    # java.io.FilterInputStream#available available}.
    # 
    # @return     the number of bytes that can be read (or skipped over) from
    # the input stream without blocking.
    # @exception  IOException  if this input stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    # @see        java.io.FilterInputStream#in
    # @see        java.io.InputStream#available()
    def available
      ensure_open
      return (@buf.attr_length - @pos) + super
    end
    
    typesig { [::Java::Long] }
    # Skips over and discards <code>n</code> bytes of data from this
    # input stream. The <code>skip</code> method may, for a variety of
    # reasons, end up skipping over some smaller number of bytes,
    # possibly zero.  If <code>n</code> is negative, no bytes are skipped.
    # 
    # <p> The <code>skip</code> method of <code>PushbackInputStream</code>
    # first skips over the bytes in the pushback buffer, if any.  It then
    # calls the <code>skip</code> method of the underlying input stream if
    # more bytes need to be skipped.  The actual number of bytes skipped
    # is returned.
    # 
    # @param      n  {@inheritDoc}
    # @return     {@inheritDoc}
    # @exception  IOException  if the stream does not support seek,
    # or the stream has been closed by
    # invoking its {@link #close()} method,
    # or an I/O error occurs.
    # @see        java.io.FilterInputStream#in
    # @see        java.io.InputStream#skip(long n)
    # @since      1.2
    def skip(n)
      ensure_open
      if (n <= 0)
        return 0
      end
      pskip = @buf.attr_length - @pos
      if (pskip > 0)
        if (n < pskip)
          pskip = n
        end
        @pos += pskip
        n -= pskip
      end
      if (n > 0)
        pskip += super(n)
      end
      return pskip
    end
    
    typesig { [] }
    # Tests if this input stream supports the <code>mark</code> and
    # <code>reset</code> methods, which it does not.
    # 
    # @return   <code>false</code>, since this class does not support the
    # <code>mark</code> and <code>reset</code> methods.
    # @see     java.io.InputStream#mark(int)
    # @see     java.io.InputStream#reset()
    def mark_supported
      return false
    end
    
    typesig { [::Java::Int] }
    # Marks the current position in this input stream.
    # 
    # <p> The <code>mark</code> method of <code>PushbackInputStream</code>
    # does nothing.
    # 
    # @param   readlimit   the maximum limit of bytes that can be read before
    # the mark position becomes invalid.
    # @see     java.io.InputStream#reset()
    def mark(readlimit)
      synchronized(self) do
      end
    end
    
    typesig { [] }
    # Repositions this stream to the position at the time the
    # <code>mark</code> method was last called on this input stream.
    # 
    # <p> The method <code>reset</code> for class
    # <code>PushbackInputStream</code> does nothing except throw an
    # <code>IOException</code>.
    # 
    # @exception  IOException  if this method is invoked.
    # @see     java.io.InputStream#mark(int)
    # @see     java.io.IOException
    def reset
      synchronized(self) do
        raise IOException.new("mark/reset not supported")
      end
    end
    
    typesig { [] }
    # Closes this input stream and releases any system resources
    # associated with the stream.
    # Once the stream has been closed, further read(), unread(),
    # available(), reset(), or skip() invocations will throw an IOException.
    # Closing a previously closed stream has no effect.
    # 
    # @exception  IOException  if an I/O error occurs.
    def close
      synchronized(self) do
        if ((self.attr_in).nil?)
          return
        end
        self.attr_in.close
        self.attr_in = nil
        @buf = nil
      end
    end
    
    private
    alias_method :initialize__pushback_input_stream, :initialize
  end
  
end

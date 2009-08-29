require "rjava"

# Copyright 1994-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Nio::Channels, :FileChannel
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  # A <code>FileInputStream</code> obtains input bytes
  # from a file in a file system. What files
  # are  available depends on the host environment.
  # 
  # <p><code>FileInputStream</code> is meant for reading streams of raw bytes
  # such as image data. For reading streams of characters, consider using
  # <code>FileReader</code>.
  # 
  # @author  Arthur van Hoff
  # @see     java.io.File
  # @see     java.io.FileDescriptor
  # @see     java.io.FileOutputStream
  # @since   JDK1.0
  class FileInputStream < FileInputStreamImports.const_get :InputStream
    include_class_members FileInputStreamImports
    
    # File Descriptor - handle to the open file
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    attr_accessor :channel
    alias_method :attr_channel, :channel
    undef_method :channel
    alias_method :attr_channel=, :channel=
    undef_method :channel=
    
    attr_accessor :close_lock
    alias_method :attr_close_lock, :close_lock
    undef_method :close_lock
    alias_method :attr_close_lock=, :close_lock=
    undef_method :close_lock=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    class_module.module_eval {
      
      def running_finalize
        defined?(@@running_finalize) ? @@running_finalize : @@running_finalize= ThreadLocal.new
      end
      alias_method :attr_running_finalize, :running_finalize
      
      def running_finalize=(value)
        @@running_finalize = value
      end
      alias_method :attr_running_finalize=, :running_finalize=
      
      typesig { [] }
      def is_running_finalize
        val = nil
        if (!((val = self.attr_running_finalize.get)).nil?)
          return val.boolean_value
        end
        return false
      end
    }
    
    typesig { [String] }
    # Creates a <code>FileInputStream</code> by
    # opening a connection to an actual file,
    # the file named by the path name <code>name</code>
    # in the file system.  A new <code>FileDescriptor</code>
    # object is created to represent this file
    # connection.
    # <p>
    # First, if there is a security
    # manager, its <code>checkRead</code> method
    # is called with the <code>name</code> argument
    # as its argument.
    # <p>
    # If the named file does not exist, is a directory rather than a regular
    # file, or for some other reason cannot be opened for reading then a
    # <code>FileNotFoundException</code> is thrown.
    # 
    # @param      name   the system-dependent file name.
    # @exception  FileNotFoundException  if the file does not exist,
    # is a directory rather than a regular file,
    # or for some other reason cannot be opened for
    # reading.
    # @exception  SecurityException      if a security manager exists and its
    # <code>checkRead</code> method denies read access
    # to the file.
    # @see        java.lang.SecurityManager#checkRead(java.lang.String)
    def initialize(name)
      initialize__file_input_stream(!(name).nil? ? JavaFile.new(name) : nil)
    end
    
    typesig { [JavaFile] }
    # Creates a <code>FileInputStream</code> by
    # opening a connection to an actual file,
    # the file named by the <code>File</code>
    # object <code>file</code> in the file system.
    # A new <code>FileDescriptor</code> object
    # is created to represent this file connection.
    # <p>
    # First, if there is a security manager,
    # its <code>checkRead</code> method  is called
    # with the path represented by the <code>file</code>
    # argument as its argument.
    # <p>
    # If the named file does not exist, is a directory rather than a regular
    # file, or for some other reason cannot be opened for reading then a
    # <code>FileNotFoundException</code> is thrown.
    # 
    # @param      file   the file to be opened for reading.
    # @exception  FileNotFoundException  if the file does not exist,
    # is a directory rather than a regular file,
    # or for some other reason cannot be opened for
    # reading.
    # @exception  SecurityException      if a security manager exists and its
    # <code>checkRead</code> method denies read access to the file.
    # @see        java.io.File#getPath()
    # @see        java.lang.SecurityManager#checkRead(java.lang.String)
    def initialize(file)
      @fd = nil
      @channel = nil
      @close_lock = nil
      @closed = false
      super()
      @channel = nil
      @close_lock = Object.new
      @closed = false
      name = (!(file).nil? ? file.get_path : nil)
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_read(name)
      end
      if ((name).nil?)
        raise NullPointerException.new
      end
      @fd = FileDescriptor.new
      @fd.increment_and_get_use_count
      open(name)
    end
    
    typesig { [FileDescriptor] }
    # Creates a <code>FileInputStream</code> by using the file descriptor
    # <code>fdObj</code>, which represents an existing connection to an
    # actual file in the file system.
    # <p>
    # If there is a security manager, its <code>checkRead</code> method is
    # called with the file descriptor <code>fdObj</code> as its argument to
    # see if it's ok to read the file descriptor. If read access is denied
    # to the file descriptor a <code>SecurityException</code> is thrown.
    # <p>
    # If <code>fdObj</code> is null then a <code>NullPointerException</code>
    # is thrown.
    # 
    # @param      fdObj   the file descriptor to be opened for reading.
    # @throws     SecurityException      if a security manager exists and its
    # <code>checkRead</code> method denies read access to the
    # file descriptor.
    # @see        SecurityManager#checkRead(java.io.FileDescriptor)
    def initialize(fd_obj)
      @fd = nil
      @channel = nil
      @close_lock = nil
      @closed = false
      super()
      @channel = nil
      @close_lock = Object.new
      @closed = false
      security = System.get_security_manager
      if ((fd_obj).nil?)
        raise NullPointerException.new
      end
      if (!(security).nil?)
        security.check_read(fd_obj)
      end
      @fd = fd_obj
      # FileDescriptor is being shared by streams.
      # Ensure that it's GC'ed only when all the streams/channels are done
      # using it.
      @fd.increment_and_get_use_count
    end
    
    JNI.native_method :Java_java_io_FileInputStream_open, [:pointer, :long, :long], :void
    typesig { [String] }
    # Opens the specified file for reading.
    # @param name the name of the file
    def open(name)
      JNI.__send__(:Java_java_io_FileInputStream_open, JNI.env, self.jni_id, name.jni_id)
    end
    
    JNI.native_method :Java_java_io_FileInputStream_read, [:pointer, :long], :int32
    typesig { [] }
    # Reads a byte of data from this input stream. This method blocks
    # if no input is yet available.
    # 
    # @return     the next byte of data, or <code>-1</code> if the end of the
    # file is reached.
    # @exception  IOException  if an I/O error occurs.
    def read
      JNI.__send__(:Java_java_io_FileInputStream_read, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_io_FileInputStream_readBytes, [:pointer, :long, :long, :int32, :int32], :int32
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads a subarray as a sequence of bytes.
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception IOException If an I/O error has occurred.
    def read_bytes(b, off, len)
      JNI.__send__(:Java_java_io_FileInputStream_readBytes, JNI.env, self.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reads up to <code>b.length</code> bytes of data from this input
    # stream into an array of bytes. This method blocks until some input
    # is available.
    # 
    # @param      b   the buffer into which the data is read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the file has been reached.
    # @exception  IOException  if an I/O error occurs.
    def read(b)
      return read_bytes(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads up to <code>len</code> bytes of data from this input stream
    # into an array of bytes. If <code>len</code> is not zero, the method
    # blocks until some input is available; otherwise, no
    # bytes are read and <code>0</code> is returned.
    # 
    # @param      b     the buffer into which the data is read.
    # @param      off   the start offset in the destination array <code>b</code>
    # @param      len   the maximum number of bytes read.
    # @return     the total number of bytes read into the buffer, or
    # <code>-1</code> if there is no more data because the end of
    # the file has been reached.
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception  IOException  if an I/O error occurs.
    def read(b, off, len)
      return read_bytes(b, off, len)
    end
    
    JNI.native_method :Java_java_io_FileInputStream_skip, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    # Skips over and discards <code>n</code> bytes of data from the
    # input stream.
    # 
    # <p>The <code>skip</code> method may, for a variety of
    # reasons, end up skipping over some smaller number of bytes,
    # possibly <code>0</code>. If <code>n</code> is negative, an
    # <code>IOException</code> is thrown, even though the <code>skip</code>
    # method of the {@link InputStream} superclass does nothing in this case.
    # The actual number of bytes skipped is returned.
    # 
    # <p>This method may skip more bytes than are remaining in the backing
    # file. This produces no exception and the number of bytes skipped
    # may include some number of bytes that were beyond the EOF of the
    # backing file. Attempting to read from the stream after skipping past
    # the end will result in -1 indicating the end of the file.
    # 
    # @param      n   the number of bytes to be skipped.
    # @return     the actual number of bytes skipped.
    # @exception  IOException  if n is negative, if the stream does not
    # support seek, or if an I/O error occurs.
    def skip(n)
      JNI.__send__(:Java_java_io_FileInputStream_skip, JNI.env, self.jni_id, n.to_int)
    end
    
    JNI.native_method :Java_java_io_FileInputStream_available, [:pointer, :long], :int32
    typesig { [] }
    # Returns an estimate of the number of remaining bytes that can be read (or
    # skipped over) from this input stream without blocking by the next
    # invocation of a method for this input stream. The next invocation might be
    # the same thread or another thread.  A single read or skip of this
    # many bytes will not block, but may read or skip fewer bytes.
    # 
    # <p> In some cases, a non-blocking read (or skip) may appear to be
    # blocked when it is merely slow, for example when reading large
    # files over slow networks.
    # 
    # @return     an estimate of the number of remaining bytes that can be read
    # (or skipped over) from this input stream without blocking.
    # @exception  IOException  if this file input stream has been closed by calling
    # {@code close} or an I/O error occurs.
    def available
      JNI.__send__(:Java_java_io_FileInputStream_available, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Closes this file input stream and releases any system resources
    # associated with the stream.
    # 
    # <p> If this stream has an associated channel then the channel is closed
    # as well.
    # 
    # @exception  IOException  if an I/O error occurs.
    # 
    # @revised 1.4
    # @spec JSR-51
    def close
      synchronized((@close_lock)) do
        if (@closed)
          return
        end
        @closed = true
      end
      if (!(@channel).nil?)
        # Decrement the FD use count associated with the channel
        # The use count is incremented whenever a new channel
        # is obtained from this stream.
        @fd.decrement_and_get_use_count
        @channel.close
      end
      # Decrement the FD use count associated with this stream
      use_count = @fd.decrement_and_get_use_count
      # If FileDescriptor is still in use by another stream, the finalizer
      # will not close it.
      if ((use_count <= 0) || !is_running_finalize)
        close0
      end
    end
    
    typesig { [] }
    # Returns the <code>FileDescriptor</code>
    # object  that represents the connection to
    # the actual file in the file system being
    # used by this <code>FileInputStream</code>.
    # 
    # @return     the file descriptor object associated with this stream.
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FileDescriptor
    def get_fd
      if (!(@fd).nil?)
        return @fd
      end
      raise IOException.new
    end
    
    typesig { [] }
    # Returns the unique {@link java.nio.channels.FileChannel FileChannel}
    # object associated with this file input stream.
    # 
    # <p> The initial {@link java.nio.channels.FileChannel#position()
    # </code>position<code>} of the returned channel will be equal to the
    # number of bytes read from the file so far.  Reading bytes from this
    # stream will increment the channel's position.  Changing the channel's
    # position, either explicitly or by reading, will change this stream's
    # file position.
    # 
    # @return  the file channel associated with this file input stream
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      synchronized((self)) do
        if ((@channel).nil?)
          @channel = FileChannelImpl.open(@fd, true, false, self)
          # Increment fd's use count. Invoking the channel's close()
          # method will result in decrementing the use count set for
          # the channel.
          @fd.increment_and_get_use_count
        end
        return @channel
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_FileInputStream_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_io_FileInputStream_initIDs, JNI.env, self.jni_id)
      end
    }
    
    JNI.native_method :Java_java_io_FileInputStream_close0, [:pointer, :long], :void
    typesig { [] }
    def close0
      JNI.__send__(:Java_java_io_FileInputStream_close0, JNI.env, self.jni_id)
    end
    
    class_module.module_eval {
      when_class_loaded do
        init_ids
      end
    }
    
    typesig { [] }
    # Ensures that the <code>close</code> method of this file input stream is
    # called when there are no more references to it.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FileInputStream#close()
    def finalize
      if ((!(@fd).nil?) && (!(@fd).equal?(@fd.attr_in)))
        # Finalizer should not release the FileDescriptor if another
        # stream is still using it. If the user directly invokes
        # close() then the FileDescriptor is also released.
        self.attr_running_finalize.set(Boolean::TRUE)
        begin
          close
        ensure
          self.attr_running_finalize.set(Boolean::FALSE)
        end
      end
    end
    
    private
    alias_method :initialize__file_input_stream, :initialize
  end
  
end

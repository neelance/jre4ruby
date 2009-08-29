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
  module FileOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Nio::Channels, :FileChannel
      include_const ::Sun::Nio::Ch, :FileChannelImpl
    }
  end
  
  # A file output stream is an output stream for writing data to a
  # <code>File</code> or to a <code>FileDescriptor</code>. Whether or not
  # a file is available or may be created depends upon the underlying
  # platform.  Some platforms, in particular, allow a file to be opened
  # for writing by only one <tt>FileOutputStream</tt> (or other
  # file-writing object) at a time.  In such situations the constructors in
  # this class will fail if the file involved is already open.
  # 
  # <p><code>FileOutputStream</code> is meant for writing streams of raw bytes
  # such as image data. For writing streams of characters, consider using
  # <code>FileWriter</code>.
  # 
  # @author  Arthur van Hoff
  # @see     java.io.File
  # @see     java.io.FileDescriptor
  # @see     java.io.FileInputStream
  # @since   JDK1.0
  class FileOutputStream < FileOutputStreamImports.const_get :OutputStream
    include_class_members FileOutputStreamImports
    
    # The system dependent file descriptor. The value is
    # 1 more than actual file descriptor. This means that
    # the default value 0 indicates that the file is not open.
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
    
    attr_accessor :append
    alias_method :attr_append, :append
    undef_method :append
    alias_method :attr_append=, :append=
    undef_method :append=
    
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
    # Creates an output file stream to write to the file with the
    # specified name. A new <code>FileDescriptor</code> object is
    # created to represent this file connection.
    # <p>
    # First, if there is a security manager, its <code>checkWrite</code>
    # method is called with <code>name</code> as its argument.
    # <p>
    # If the file exists but is a directory rather than a regular file, does
    # not exist but cannot be created, or cannot be opened for any other
    # reason then a <code>FileNotFoundException</code> is thrown.
    # 
    # @param      name   the system-dependent filename
    # @exception  FileNotFoundException  if the file exists but is a directory
    # rather than a regular file, does not exist but cannot
    # be created, or cannot be opened for any other reason
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkWrite</code> method denies write access
    # to the file.
    # @see        java.lang.SecurityManager#checkWrite(java.lang.String)
    def initialize(name)
      initialize__file_output_stream(!(name).nil? ? JavaFile.new(name) : nil, false)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Creates an output file stream to write to the file with the specified
    # <code>name</code>.  If the second argument is <code>true</code>, then
    # bytes will be written to the end of the file rather than the beginning.
    # A new <code>FileDescriptor</code> object is created to represent this
    # file connection.
    # <p>
    # First, if there is a security manager, its <code>checkWrite</code>
    # method is called with <code>name</code> as its argument.
    # <p>
    # If the file exists but is a directory rather than a regular file, does
    # not exist but cannot be created, or cannot be opened for any other
    # reason then a <code>FileNotFoundException</code> is thrown.
    # 
    # @param     name        the system-dependent file name
    # @param     append      if <code>true</code>, then bytes will be written
    # to the end of the file rather than the beginning
    # @exception  FileNotFoundException  if the file exists but is a directory
    # rather than a regular file, does not exist but cannot
    # be created, or cannot be opened for any other reason.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkWrite</code> method denies write access
    # to the file.
    # @see        java.lang.SecurityManager#checkWrite(java.lang.String)
    # @since     JDK1.1
    def initialize(name, append)
      initialize__file_output_stream(!(name).nil? ? JavaFile.new(name) : nil, append)
    end
    
    typesig { [JavaFile] }
    # Creates a file output stream to write to the file represented by
    # the specified <code>File</code> object. A new
    # <code>FileDescriptor</code> object is created to represent this
    # file connection.
    # <p>
    # First, if there is a security manager, its <code>checkWrite</code>
    # method is called with the path represented by the <code>file</code>
    # argument as its argument.
    # <p>
    # If the file exists but is a directory rather than a regular file, does
    # not exist but cannot be created, or cannot be opened for any other
    # reason then a <code>FileNotFoundException</code> is thrown.
    # 
    # @param      file               the file to be opened for writing.
    # @exception  FileNotFoundException  if the file exists but is a directory
    # rather than a regular file, does not exist but cannot
    # be created, or cannot be opened for any other reason
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkWrite</code> method denies write access
    # to the file.
    # @see        java.io.File#getPath()
    # @see        java.lang.SecurityException
    # @see        java.lang.SecurityManager#checkWrite(java.lang.String)
    def initialize(file)
      initialize__file_output_stream(file, false)
    end
    
    typesig { [JavaFile, ::Java::Boolean] }
    # Creates a file output stream to write to the file represented by
    # the specified <code>File</code> object. If the second argument is
    # <code>true</code>, then bytes will be written to the end of the file
    # rather than the beginning. A new <code>FileDescriptor</code> object is
    # created to represent this file connection.
    # <p>
    # First, if there is a security manager, its <code>checkWrite</code>
    # method is called with the path represented by the <code>file</code>
    # argument as its argument.
    # <p>
    # If the file exists but is a directory rather than a regular file, does
    # not exist but cannot be created, or cannot be opened for any other
    # reason then a <code>FileNotFoundException</code> is thrown.
    # 
    # @param      file               the file to be opened for writing.
    # @param     append      if <code>true</code>, then bytes will be written
    # to the end of the file rather than the beginning
    # @exception  FileNotFoundException  if the file exists but is a directory
    # rather than a regular file, does not exist but cannot
    # be created, or cannot be opened for any other reason
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkWrite</code> method denies write access
    # to the file.
    # @see        java.io.File#getPath()
    # @see        java.lang.SecurityException
    # @see        java.lang.SecurityManager#checkWrite(java.lang.String)
    # @since 1.4
    def initialize(file, append)
      @fd = nil
      @channel = nil
      @append = false
      @close_lock = nil
      @closed = false
      super()
      @channel = nil
      @append = false
      @close_lock = Object.new
      @closed = false
      name = (!(file).nil? ? file.get_path : nil)
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_write(name)
      end
      if ((name).nil?)
        raise NullPointerException.new
      end
      @fd = FileDescriptor.new
      @fd.increment_and_get_use_count
      @append = append
      if (append)
        open_append(name)
      else
        open(name)
      end
    end
    
    typesig { [FileDescriptor] }
    # Creates an output file stream to write to the specified file
    # descriptor, which represents an existing connection to an actual
    # file in the file system.
    # <p>
    # First, if there is a security manager, its <code>checkWrite</code>
    # method is called with the file descriptor <code>fdObj</code>
    # argument as its argument.
    # 
    # @param      fdObj   the file descriptor to be opened for writing
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkWrite</code> method denies
    # write access to the file descriptor
    # @see        java.lang.SecurityManager#checkWrite(java.io.FileDescriptor)
    def initialize(fd_obj)
      @fd = nil
      @channel = nil
      @append = false
      @close_lock = nil
      @closed = false
      super()
      @channel = nil
      @append = false
      @close_lock = Object.new
      @closed = false
      security = System.get_security_manager
      if ((fd_obj).nil?)
        raise NullPointerException.new
      end
      if (!(security).nil?)
        security.check_write(fd_obj)
      end
      @fd = fd_obj
      # FileDescriptor is being shared by streams.
      # Ensure that it's GC'ed only when all the streams/channels are done
      # using it.
      @fd.increment_and_get_use_count
    end
    
    JNI.native_method :Java_java_io_FileOutputStream_open, [:pointer, :long, :long], :void
    typesig { [String] }
    # Opens a file, with the specified name, for writing.
    # @param name name of file to be opened
    def open(name)
      JNI.__send__(:Java_java_io_FileOutputStream_open, JNI.env, self.jni_id, name.jni_id)
    end
    
    JNI.native_method :Java_java_io_FileOutputStream_openAppend, [:pointer, :long, :long], :void
    typesig { [String] }
    # Opens a file, with the specified name, for appending.
    # @param name name of file to be opened
    def open_append(name)
      JNI.__send__(:Java_java_io_FileOutputStream_openAppend, JNI.env, self.jni_id, name.jni_id)
    end
    
    JNI.native_method :Java_java_io_FileOutputStream_write, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    # Writes the specified byte to this file output stream. Implements
    # the <code>write</code> method of <code>OutputStream</code>.
    # 
    # @param      b   the byte to be written.
    # @exception  IOException  if an I/O error occurs.
    def write(b)
      JNI.__send__(:Java_java_io_FileOutputStream_write, JNI.env, self.jni_id, b.to_int)
    end
    
    JNI.native_method :Java_java_io_FileOutputStream_writeBytes, [:pointer, :long, :long, :int32, :int32], :void
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes a sub array as a sequence of bytes.
    # @param b the data to be written
    # @param off the start offset in the data
    # @param len the number of bytes that are written
    # @exception IOException If an I/O error has occurred.
    def write_bytes(b, off, len)
      JNI.__send__(:Java_java_io_FileOutputStream_writeBytes, JNI.env, self.jni_id, b.jni_id, off.to_int, len.to_int)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Writes <code>b.length</code> bytes from the specified byte array
    # to this file output stream.
    # 
    # @param      b   the data.
    # @exception  IOException  if an I/O error occurs.
    def write(b)
      write_bytes(b, 0, b.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes <code>len</code> bytes from the specified byte array
    # starting at offset <code>off</code> to this file output stream.
    # 
    # @param      b     the data.
    # @param      off   the start offset in the data.
    # @param      len   the number of bytes to write.
    # @exception  IOException  if an I/O error occurs.
    def write(b, off, len)
      write_bytes(b, off, len)
    end
    
    typesig { [] }
    # Closes this file output stream and releases any system resources
    # associated with this stream. This file output stream may no longer
    # be used for writing bytes.
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
        # Decrement FD use count associated with the channel
        # The use count is incremented whenever a new channel
        # is obtained from this stream.
        @fd.decrement_and_get_use_count
        @channel.close
      end
      # Decrement FD use count associated with this stream
      use_count = @fd.decrement_and_get_use_count
      # If FileDescriptor is still in use by another stream, the finalizer
      # will not close it.
      if ((use_count <= 0) || !is_running_finalize)
        close0
      end
    end
    
    typesig { [] }
    # Returns the file descriptor associated with this stream.
    # 
    # @return  the <code>FileDescriptor</code> object that represents
    # the connection to the file in the file system being used
    # by this <code>FileOutputStream</code> object.
    # 
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
    # object associated with this file output stream. </p>
    # 
    # <p> The initial {@link java.nio.channels.FileChannel#position()
    # </code>position<code>} of the returned channel will be equal to the
    # number of bytes written to the file so far unless this stream is in
    # append mode, in which case it will be equal to the size of the file.
    # Writing bytes to this stream will increment the channel's position
    # accordingly.  Changing the channel's position, either explicitly or by
    # writing, will change this stream's file position.
    # 
    # @return  the file channel associated with this file output stream
    # 
    # @since 1.4
    # @spec JSR-51
    def get_channel
      synchronized((self)) do
        if ((@channel).nil?)
          @channel = FileChannelImpl.open(@fd, false, true, self, @append)
          # Increment fd's use count. Invoking the channel's close()
          # method will result in decrementing the use count set for
          # the channel.
          @fd.increment_and_get_use_count
        end
        return @channel
      end
    end
    
    typesig { [] }
    # Cleans up the connection to the file, and ensures that the
    # <code>close</code> method of this file output stream is
    # called when there are no more references to this stream.
    # 
    # @exception  IOException  if an I/O error occurs.
    # @see        java.io.FileInputStream#close()
    def finalize
      if (!(@fd).nil?)
        if ((@fd).equal?(@fd.attr_out) || (@fd).equal?(@fd.attr_err))
          flush
        else
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
    end
    
    JNI.native_method :Java_java_io_FileOutputStream_close0, [:pointer, :long], :void
    typesig { [] }
    def close0
      JNI.__send__(:Java_java_io_FileOutputStream_close0, JNI.env, self.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_FileOutputStream_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_io_FileOutputStream_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    private
    alias_method :initialize__file_output_stream, :initialize
  end
  
end

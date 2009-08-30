require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
    }
  end
  
  # Instances of the file descriptor class serve as an opaque handle
  # to the underlying machine-specific structure representing an open
  # file, an open socket, or another source or sink of bytes. The
  # main practical use for a file descriptor is to create a
  # <code>FileInputStream</code> or <code>FileOutputStream</code> to
  # contain it.
  # <p>
  # Applications should not create their own file descriptors.
  # 
  # @author  Pavani Diwanji
  # @see     java.io.FileInputStream
  # @see     java.io.FileOutputStream
  # @since   JDK1.0
  class FileDescriptor 
    include_class_members FileDescriptorImports
    
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    # A counter for tracking the FIS/FOS/RAF instances that
    # use this FileDescriptor. The FIS/FOS.finalize() will not release
    # the FileDescriptor if it is still under user by a stream.
    attr_accessor :use_count
    alias_method :attr_use_count, :use_count
    undef_method :use_count
    alias_method :attr_use_count=, :use_count=
    undef_method :use_count=
    
    typesig { [] }
    # Constructs an (invalid) FileDescriptor
    # object.
    def initialize
      @fd = 0
      @use_count = nil
      @fd = -1
      @use_count = AtomicInteger.new
    end
    
    typesig { [::Java::Int] }
    def initialize(fd)
      @fd = 0
      @use_count = nil
      @fd = fd
      @use_count = AtomicInteger.new
    end
    
    class_module.module_eval {
      # A handle to the standard input stream. Usually, this file
      # descriptor is not used directly, but rather via the input stream
      # known as <code>System.in</code>.
      # 
      # @see     java.lang.System#in
      const_set_lazy(:In) { FileDescriptor.new(0) }
      const_attr_reader  :In
      
      # A handle to the standard output stream. Usually, this file
      # descriptor is not used directly, but rather via the output stream
      # known as <code>System.out</code>.
      # @see     java.lang.System#out
      const_set_lazy(:Out) { FileDescriptor.new(1) }
      const_attr_reader  :Out
      
      # A handle to the standard error stream. Usually, this file
      # descriptor is not used directly, but rather via the output stream
      # known as <code>System.err</code>.
      # 
      # @see     java.lang.System#err
      const_set_lazy(:Err) { FileDescriptor.new(2) }
      const_attr_reader  :Err
    }
    
    typesig { [] }
    # Tests if this file descriptor object is valid.
    # 
    # @return  <code>true</code> if the file descriptor object represents a
    # valid, open file, socket, or other active I/O connection;
    # <code>false</code> otherwise.
    def valid
      return !(@fd).equal?(-1)
    end
    
    JNI.native_method :Java_java_io_FileDescriptor_sync, [:pointer, :long], :void
    typesig { [] }
    # Force all system buffers to synchronize with the underlying
    # device.  This method returns after all modified data and
    # attributes of this FileDescriptor have been written to the
    # relevant device(s).  In particular, if this FileDescriptor
    # refers to a physical storage medium, such as a file in a file
    # system, sync will not return until all in-memory modified copies
    # of buffers associated with this FileDescriptor have been
    # written to the physical medium.
    # 
    # sync is meant to be used by code that requires physical
    # storage (such as a file) to be in a known state  For
    # example, a class that provided a simple transaction facility
    # might use sync to ensure that all changes to a file caused
    # by a given transaction were recorded on a storage medium.
    # 
    # sync only affects buffers downstream of this FileDescriptor.  If
    # any in-memory buffering is being done by the application (for
    # example, by a BufferedOutputStream object), those buffers must
    # be flushed into the FileDescriptor (for example, by invoking
    # OutputStream.flush) before that data will be affected by sync.
    # 
    # @exception SyncFailedException
    # Thrown when the buffers cannot be flushed,
    # or because the system cannot guarantee that all the
    # buffers have been synchronized with physical media.
    # @since     JDK1.1
    def sync
      JNI.__send__(:Java_java_io_FileDescriptor_sync, JNI.env, self.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_FileDescriptor_initIDs, [:pointer, :long], :void
      typesig { [] }
      # This routine initializes JNI field offsets for the class
      def init_ids
        JNI.__send__(:Java_java_io_FileDescriptor_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
      
      # Set up JavaIOFileDescriptorAccess in SharedSecrets
      when_class_loaded do
        Sun::Misc::SharedSecrets.set_java_iofile_descriptor_access(Class.new(Sun::Misc::JavaIOFileDescriptorAccess.class == Class ? Sun::Misc::JavaIOFileDescriptorAccess : Object) do
          extend LocalClass
          include_class_members FileDescriptor
          include Sun::Misc::JavaIOFileDescriptorAccess if Sun::Misc::JavaIOFileDescriptorAccess.class == Module
          
          typesig { [FileDescriptor, ::Java::Int] }
          define_method :set do |obj, fd|
            obj.attr_fd = fd
          end
          
          typesig { [FileDescriptor] }
          define_method :get do |obj|
            return obj.attr_fd
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    typesig { [] }
    # pacakge private methods used by FIS,FOS and RAF
    def increment_and_get_use_count
      return @use_count.increment_and_get
    end
    
    typesig { [] }
    def decrement_and_get_use_count
      return @use_count.decrement_and_get
    end
    
    private
    alias_method :initialize__file_descriptor, :initialize
  end
  
end

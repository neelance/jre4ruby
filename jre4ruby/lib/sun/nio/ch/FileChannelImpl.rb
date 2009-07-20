require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module FileChannelImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :RandomAccessFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :MappedByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  class FileChannelImpl < FileChannelImplImports.const_get :FileChannel
    include_class_members FileChannelImplImports
    
    class_module.module_eval {
      # Used to make native read and write calls
      
      def nd
        defined?(@@nd) ? @@nd : @@nd= nil
      end
      alias_method :attr_nd, :nd
      
      def nd=(value)
        @@nd = value
      end
      alias_method :attr_nd=, :nd=
      
      # Memory allocation size for mapping buffers
      
      def allocation_granularity
        defined?(@@allocation_granularity) ? @@allocation_granularity : @@allocation_granularity= 0
      end
      alias_method :attr_allocation_granularity, :allocation_granularity
      
      def allocation_granularity=(value)
        @@allocation_granularity = value
      end
      alias_method :attr_allocation_granularity=, :allocation_granularity=
      
      # Cached field for MappedByteBuffer.isAMappedBuffer
      
      def is_amapped_buffer_field
        defined?(@@is_amapped_buffer_field) ? @@is_amapped_buffer_field : @@is_amapped_buffer_field= nil
      end
      alias_method :attr_is_amapped_buffer_field, :is_amapped_buffer_field
      
      def is_amapped_buffer_field=(value)
        @@is_amapped_buffer_field = value
      end
      alias_method :attr_is_amapped_buffer_field=, :is_amapped_buffer_field=
    }
    
    # File descriptor
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    # File access mode (immutable)
    attr_accessor :writable
    alias_method :attr_writable, :writable
    undef_method :writable
    alias_method :attr_writable=, :writable=
    undef_method :writable=
    
    attr_accessor :readable
    alias_method :attr_readable, :readable
    undef_method :readable
    alias_method :attr_readable=, :readable=
    undef_method :readable=
    
    attr_accessor :appending
    alias_method :attr_appending, :appending
    undef_method :appending
    alias_method :attr_appending=, :appending=
    undef_method :appending=
    
    # Required to prevent finalization of creating stream (immutable)
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # Thread-safe set of IDs of native threads, for signalling
    attr_accessor :threads
    alias_method :attr_threads, :threads
    undef_method :threads
    alias_method :attr_threads=, :threads=
    undef_method :threads=
    
    # Lock for operations involving position and size
    attr_accessor :position_lock
    alias_method :attr_position_lock, :position_lock
    undef_method :position_lock
    alias_method :attr_position_lock=, :position_lock=
    undef_method :position_lock=
    
    typesig { [FileDescriptor, ::Java::Boolean, ::Java::Boolean, Object, ::Java::Boolean] }
    def initialize(fd, readable, writable, parent, append)
      @fd = nil
      @writable = false
      @readable = false
      @appending = false
      @parent = nil
      @threads = nil
      @position_lock = nil
      @file_lock_table = nil
      super()
      @threads = NativeThreadSet.new(2)
      @position_lock = Object.new
      @fd = fd
      @readable = readable
      @writable = writable
      @parent = parent
      @appending = append
    end
    
    class_module.module_eval {
      typesig { [FileDescriptor, ::Java::Boolean, ::Java::Boolean, Object] }
      # Invoked by getChannel() methods
      # of java.io.File{Input,Output}Stream and RandomAccessFile
      def open(fd, readable, writable, parent)
        return FileChannelImpl.new(fd, readable, writable, parent, false)
      end
      
      typesig { [FileDescriptor, ::Java::Boolean, ::Java::Boolean, Object, ::Java::Boolean] }
      def open(fd, readable, writable, parent, append)
        return FileChannelImpl.new(fd, readable, writable, parent, append)
      end
    }
    
    typesig { [] }
    def ensure_open
      if (!is_open)
        raise ClosedChannelException.new
      end
    end
    
    typesig { [] }
    # -- Standard channel operations --
    def impl_close_channel
      self.attr_nd.pre_close(@fd)
      @threads.signal
      # Invalidate and release any locks that we still hold
      if (!(@file_lock_table).nil?)
        @file_lock_table.remove_all(Class.new(FileLockTable::Releaser.class == Class ? FileLockTable::Releaser : Object) do
          extend LocalClass
          include_class_members FileChannelImpl
          include FileLockTable::Releaser if FileLockTable::Releaser.class == Module
          
          typesig { [FileLock] }
          define_method :release do |fl|
            (fl).invalidate
            release0(self.attr_fd, fl.position, fl.size)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      if (!(@parent).nil?)
        # Close the fd via the parent stream's close method.  The parent
        # will reinvoke our close method, which is defined in the
        # superclass AbstractInterruptibleChannel, but the isOpen logic in
        # that method will prevent this method from being reinvoked.
        if (@parent.is_a?(FileInputStream))
          (@parent).close
        else
          if (@parent.is_a?(FileOutputStream))
            (@parent).close
          else
            if (@parent.is_a?(RandomAccessFile))
              (@parent).close
            else
              raise AssertError if not (false)
            end
          end
        end
      else
        self.attr_nd.close(@fd)
      end
    end
    
    typesig { [ByteBuffer] }
    def read(dst)
      ensure_open
      if (!@readable)
        raise NonReadableChannelException.new
      end
      synchronized((@position_lock)) do
        n = 0
        ti = -1
        begin
          begin
          if (!is_open)
            return 0
          end
          ti = @threads.add
          begin
            n = IOUtil.read(@fd, dst, -1, self.attr_nd, @position_lock)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @threads.remove(ti)
          end(n > 0)
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def read0(dsts)
      ensure_open
      if (!@readable)
        raise NonReadableChannelException.new
      end
      synchronized((@position_lock)) do
        n = 0
        ti = -1
        begin
          begin
          if (!is_open)
            return 0
          end
          ti = @threads.add
          begin
            n = IOUtil.read(@fd, dsts, self.attr_nd)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @threads.remove(ti)
          end(n > 0)
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    def read(dsts, offset, length)
      if ((offset < 0) || (length < 0) || (offset > dsts.attr_length - length))
        raise IndexOutOfBoundsException.new
      end
      # ## Fix IOUtil.write so that we can avoid this array copy
      return read0(Util.subsequence(dsts, offset, length))
    end
    
    typesig { [ByteBuffer] }
    def write(src)
      ensure_open
      if (!@writable)
        raise NonWritableChannelException.new
      end
      synchronized((@position_lock)) do
        n = 0
        ti = -1
        begin
          begin
          if (!is_open)
            return 0
          end
          ti = @threads.add
          if (@appending)
            position(size)
          end
          begin
            n = IOUtil.write(@fd, src, -1, self.attr_nd, @position_lock)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @threads.remove(ti)
          end(n > 0)
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def write0(srcs)
      ensure_open
      if (!@writable)
        raise NonWritableChannelException.new
      end
      synchronized((@position_lock)) do
        n = 0
        ti = -1
        begin
          begin
          if (!is_open)
            return 0
          end
          ti = @threads.add
          if (@appending)
            position(size)
          end
          begin
            n = IOUtil.write(@fd, srcs, self.attr_nd)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @threads.remove(ti)
          end(n > 0)
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    def write(srcs, offset, length)
      if ((offset < 0) || (length < 0) || (offset > srcs.attr_length - length))
        raise IndexOutOfBoundsException.new
      end
      # ## Fix IOUtil.write so that we can avoid this array copy
      return write0(Util.subsequence(srcs, offset, length))
    end
    
    typesig { [] }
    # -- Other operations --
    def position
      ensure_open
      synchronized((@position_lock)) do
        p = -1
        ti = -1
        begin
          begin
          if (!is_open)
            return 0
          end
          ti = @threads.add
          begin
            p = position0(@fd, -1)
          end while (((p).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(p)
        ensure
          @threads.remove(ti)
          end(p > -1)
          raise AssertError if not (IOStatus.check(p))
        end
      end
    end
    
    typesig { [::Java::Long] }
    def position(new_position)
      ensure_open
      if (new_position < 0)
        raise IllegalArgumentException.new
      end
      synchronized((@position_lock)) do
        p = -1
        ti = -1
        begin
          begin
          if (!is_open)
            return nil
          end
          ti = @threads.add
          begin
            p = position0(@fd, new_position)
          end while (((p).equal?(IOStatus::INTERRUPTED)) && is_open)
          return self
        ensure
          @threads.remove(ti)
          end(p > -1)
          raise AssertError if not (IOStatus.check(p))
        end
      end
    end
    
    typesig { [] }
    def size
      ensure_open
      synchronized((@position_lock)) do
        s = -1
        ti = -1
        begin
          begin
          if (!is_open)
            return -1
          end
          ti = @threads.add
          begin
            s = size0(@fd)
          end while (((s).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(s)
        ensure
          @threads.remove(ti)
          end(s > -1)
          raise AssertError if not (IOStatus.check(s))
        end
      end
    end
    
    typesig { [::Java::Long] }
    def truncate(size_)
      ensure_open
      if (size_ < 0)
        raise IllegalArgumentException.new
      end
      if (size_ > size)
        return self
      end
      if (!@writable)
        raise NonWritableChannelException.new
      end
      synchronized((@position_lock)) do
        rv = -1
        p = -1
        ti = -1
        begin
          begin
          if (!is_open)
            return nil
          end
          ti = @threads.add
          # get current position
          begin
            p = position0(@fd, -1)
          end while (((p).equal?(IOStatus::INTERRUPTED)) && is_open)
          if (!is_open)
            return nil
          end
          raise AssertError if not (p >= 0)
          # truncate file
          begin
            rv = truncate0(@fd, size_)
          end while (((rv).equal?(IOStatus::INTERRUPTED)) && is_open)
          if (!is_open)
            return nil
          end
          # set position to size if greater than size
          if (p > size_)
            p = size_
          end
          begin
            rv = RJava.cast_to_int(position0(@fd, p))
          end while (((rv).equal?(IOStatus::INTERRUPTED)) && is_open)
          return self
        ensure
          @threads.remove(ti)
          end(rv > -1)
          raise AssertError if not (IOStatus.check(rv))
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    def force(meta_data)
      ensure_open
      rv = -1
      ti = -1
      begin
        begin
        if (!is_open)
          return
        end
        ti = @threads.add
        begin
          rv = force0(@fd, meta_data)
        end while (((rv).equal?(IOStatus::INTERRUPTED)) && is_open)
      ensure
        @threads.remove(ti)
        end(rv > -1)
        raise AssertError if not (IOStatus.check(rv))
      end
    end
    
    class_module.module_eval {
      # Assume at first that the underlying kernel supports sendfile();
      # set this to false if we find out later that it doesn't
      
      def transfer_supported
        defined?(@@transfer_supported) ? @@transfer_supported : @@transfer_supported= true
      end
      alias_method :attr_transfer_supported, :transfer_supported
      
      def transfer_supported=(value)
        @@transfer_supported = value
      end
      alias_method :attr_transfer_supported=, :transfer_supported=
      
      # Assume that the underlying kernel sendfile() will work if the target
      # fd is a pipe; set this to false if we find out later that it doesn't
      
      def pipe_supported
        defined?(@@pipe_supported) ? @@pipe_supported : @@pipe_supported= true
      end
      alias_method :attr_pipe_supported, :pipe_supported
      
      def pipe_supported=(value)
        @@pipe_supported = value
      end
      alias_method :attr_pipe_supported=, :pipe_supported=
      
      # Assume that the underlying kernel sendfile() will work if the target
      # fd is a file; set this to false if we find out later that it doesn't
      
      def file_supported
        defined?(@@file_supported) ? @@file_supported : @@file_supported= true
      end
      alias_method :attr_file_supported, :file_supported
      
      def file_supported=(value)
        @@file_supported = value
      end
      alias_method :attr_file_supported=, :file_supported=
    }
    
    typesig { [::Java::Long, ::Java::Int, WritableByteChannel] }
    def transfer_to_directly(position_, icount, target)
      if (!self.attr_transfer_supported)
        return IOStatus::UNSUPPORTED
      end
      target_fd = nil
      if (target.is_a?(FileChannelImpl))
        if (!self.attr_file_supported)
          return IOStatus::UNSUPPORTED_CASE
        end
        target_fd = (target).attr_fd
      else
        if (target.is_a?(SelChImpl))
          # Direct transfer to pipe causes EINVAL on some configurations
          if ((target.is_a?(SinkChannelImpl)) && !self.attr_pipe_supported)
            return IOStatus::UNSUPPORTED_CASE
          end
          target_fd = (target).get_fd
        end
      end
      if ((target_fd).nil?)
        return IOStatus::UNSUPPORTED
      end
      this_fdval = IOUtil.fd_val(@fd)
      target_fdval = IOUtil.fd_val(target_fd)
      if ((this_fdval).equal?(target_fdval))
        # Not supported on some configurations
        return IOStatus::UNSUPPORTED
      end
      n = -1
      ti = -1
      begin
        begin
        if (!is_open)
          return -1
        end
        ti = @threads.add
        begin
          n = transfer_to0(this_fdval, position_, icount, target_fdval)
        end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
        if ((n).equal?(IOStatus::UNSUPPORTED_CASE))
          if (target.is_a?(SinkChannelImpl))
            self.attr_pipe_supported = false
          end
          if (target.is_a?(FileChannelImpl))
            self.attr_file_supported = false
          end
          return IOStatus::UNSUPPORTED_CASE
        end
        if ((n).equal?(IOStatus::UNSUPPORTED))
          # Don't bother trying again
          self.attr_transfer_supported = false
          return IOStatus::UNSUPPORTED
        end
        return IOStatus.normalize(n)
      ensure
        @threads.remove(ti)
        end(n > -1)
      end
    end
    
    typesig { [::Java::Long, ::Java::Int, WritableByteChannel] }
    def transfer_to_trusted_channel(position_, icount, target)
      if (!((target.is_a?(FileChannelImpl)) || (target.is_a?(SelChImpl))))
        return IOStatus::UNSUPPORTED
      end
      # Trusted target: Use a mapped buffer
      dbb = nil
      begin
        dbb = map(MapMode::READ_ONLY, position_, icount)
        # ## Bug: Closing this channel will not terminate the write
        return target.write(dbb)
      ensure
        if (!(dbb).nil?)
          unmap(dbb)
        end
      end
    end
    
    typesig { [::Java::Long, ::Java::Int, WritableByteChannel] }
    def transfer_to_arbitrary_channel(position_, icount, target)
      # Untrusted target: Use a newly-erased buffer
      c = Math.min(icount, TRANSFER_SIZE)
      bb = Util.get_temporary_direct_buffer(c)
      tw = 0 # Total bytes written
      pos = position_
      begin
        Util.erase(bb)
        while (tw < icount)
          bb.limit(Math.min(RJava.cast_to_int((icount - tw)), TRANSFER_SIZE))
          nr = read(bb, pos)
          if (nr <= 0)
            break
          end
          bb.flip
          # ## Bug: Will block writing target if this channel
          # ##      is asynchronously closed
          nw = target.write(bb)
          tw += nw
          if (!(nw).equal?(nr))
            break
          end
          pos += nw
          bb.clear
        end
        return tw
      rescue IOException => x
        if (tw > 0)
          return tw
        end
        raise x
      ensure
        Util.release_temporary_direct_buffer(bb)
      end
    end
    
    typesig { [::Java::Long, ::Java::Long, WritableByteChannel] }
    def transfer_to(position_, count, target)
      ensure_open
      if (!target.is_open)
        raise ClosedChannelException.new
      end
      if (!@readable)
        raise NonReadableChannelException.new
      end
      if (target.is_a?(FileChannelImpl) && !(target).attr_writable)
        raise NonWritableChannelException.new
      end
      if ((position_ < 0) || (count < 0))
        raise IllegalArgumentException.new
      end
      sz = size
      if (position_ > sz)
        return 0
      end
      icount = RJava.cast_to_int(Math.min(count, JavaInteger::MAX_VALUE))
      if ((sz - position_) < icount)
        icount = RJava.cast_to_int((sz - position_))
      end
      n = 0
      # Attempt a direct transfer, if the kernel supports it
      if ((n = transfer_to_directly(position_, icount, target)) >= 0)
        return n
      end
      # Attempt a mapped transfer, but only to trusted channel types
      if ((n = transfer_to_trusted_channel(position_, icount, target)) >= 0)
        return n
      end
      # Slow path for untrusted targets
      return transfer_to_arbitrary_channel(position_, icount, target)
    end
    
    typesig { [FileChannelImpl, ::Java::Long, ::Java::Long] }
    def transfer_from_file_channel(src, position_, count)
      # Note we could loop here to accumulate more at once
      synchronized((src.attr_position_lock)) do
        p = src.position
        icount = RJava.cast_to_int(Math.min(Math.min(count, JavaInteger::MAX_VALUE), src.size - p))
        # ## Bug: Closing this channel will not terminate the write
        bb = src.map(MapMode::READ_ONLY, p, icount)
        begin
          n = write(bb, position_)
          src.position(p + n)
          return n
        ensure
          unmap(bb)
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:TRANSFER_SIZE) { 8192 }
      const_attr_reader  :TRANSFER_SIZE
    }
    
    typesig { [ReadableByteChannel, ::Java::Long, ::Java::Long] }
    def transfer_from_arbitrary_channel(src, position_, count)
      # Untrusted target: Use a newly-erased buffer
      c = RJava.cast_to_int(Math.min(count, TRANSFER_SIZE))
      bb = Util.get_temporary_direct_buffer(c)
      tw = 0 # Total bytes written
      pos = position_
      begin
        Util.erase(bb)
        while (tw < count)
          bb.limit(RJava.cast_to_int(Math.min((count - tw), TRANSFER_SIZE)))
          # ## Bug: Will block reading src if this channel
          # ##      is asynchronously closed
          nr = src.read(bb)
          if (nr <= 0)
            break
          end
          bb.flip
          nw = write(bb, pos)
          tw += nw
          if (!(nw).equal?(nr))
            break
          end
          pos += nw
          bb.clear
        end
        return tw
      rescue IOException => x
        if (tw > 0)
          return tw
        end
        raise x
      ensure
        Util.release_temporary_direct_buffer(bb)
      end
    end
    
    typesig { [ReadableByteChannel, ::Java::Long, ::Java::Long] }
    def transfer_from(src, position_, count)
      ensure_open
      if (!src.is_open)
        raise ClosedChannelException.new
      end
      if (!@writable)
        raise NonWritableChannelException.new
      end
      if ((position_ < 0) || (count < 0))
        raise IllegalArgumentException.new
      end
      if (position_ > size)
        return 0
      end
      if (src.is_a?(FileChannelImpl))
        return transfer_from_file_channel(src, position_, count)
      end
      return transfer_from_arbitrary_channel(src, position_, count)
    end
    
    typesig { [ByteBuffer, ::Java::Long] }
    def read(dst, position_)
      if ((dst).nil?)
        raise NullPointerException.new
      end
      if (position_ < 0)
        raise IllegalArgumentException.new("Negative position")
      end
      if (!@readable)
        raise NonReadableChannelException.new
      end
      ensure_open
      n = 0
      ti = -1
      begin
        begin
        if (!is_open)
          return -1
        end
        ti = @threads.add
        begin
          n = IOUtil.read(@fd, dst, position_, self.attr_nd, @position_lock)
        end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
        return IOStatus.normalize(n)
      ensure
        @threads.remove(ti)
        end(n > 0)
        raise AssertError if not (IOStatus.check(n))
      end
    end
    
    typesig { [ByteBuffer, ::Java::Long] }
    def write(src, position_)
      if ((src).nil?)
        raise NullPointerException.new
      end
      if (position_ < 0)
        raise IllegalArgumentException.new("Negative position")
      end
      if (!@writable)
        raise NonWritableChannelException.new
      end
      ensure_open
      n = 0
      ti = -1
      begin
        begin
        if (!is_open)
          return -1
        end
        ti = @threads.add
        begin
          n = IOUtil.write(@fd, src, position_, self.attr_nd, @position_lock)
        end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
        return IOStatus.normalize(n)
      ensure
        @threads.remove(ti)
        end(n > 0)
        raise AssertError if not (IOStatus.check(n))
      end
    end
    
    class_module.module_eval {
      # -- Memory-mapped buffers --
      const_set_lazy(:Unmapper) { Class.new do
        include_class_members FileChannelImpl
        include Runnable
        
        attr_accessor :address
        alias_method :attr_address, :address
        undef_method :address
        alias_method :attr_address=, :address=
        undef_method :address=
        
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [::Java::Long, ::Java::Long] }
        def initialize(address, size)
          @address = 0
          @size = 0
          raise AssertError if not ((!(address).equal?(0)))
          @address = address
          @size = size
        end
        
        typesig { [] }
        def run
          if ((@address).equal?(0))
            return
          end
          unmap0(@address, @size)
          @address = 0
        end
        
        private
        alias_method :initialize__unmapper, :initialize
      end }
      
      typesig { [MappedByteBuffer] }
      def unmap(bb)
        cl = (bb).cleaner
        if (!(cl).nil?)
          cl.clean
        end
      end
      
      const_set_lazy(:MAP_RO) { 0 }
      const_attr_reader  :MAP_RO
      
      const_set_lazy(:MAP_RW) { 1 }
      const_attr_reader  :MAP_RW
      
      const_set_lazy(:MAP_PV) { 2 }
      const_attr_reader  :MAP_PV
    }
    
    typesig { [MapMode, ::Java::Long, ::Java::Long] }
    def map(mode, position_, size_)
      ensure_open
      if (position_ < 0)
        raise IllegalArgumentException.new("Negative position")
      end
      if (size_ < 0)
        raise IllegalArgumentException.new("Negative size")
      end
      if (position_ + size_ < 0)
        raise IllegalArgumentException.new("Position + size overflow")
      end
      if (size_ > JavaInteger::MAX_VALUE)
        raise IllegalArgumentException.new("Size exceeds Integer.MAX_VALUE")
      end
      imode = -1
      if ((mode).equal?(MapMode::READ_ONLY))
        imode = MAP_RO
      else
        if ((mode).equal?(MapMode::READ_WRITE))
          imode = MAP_RW
        else
          if ((mode).equal?(MapMode::PRIVATE))
            imode = MAP_PV
          end
        end
      end
      raise AssertError if not ((imode >= 0))
      if ((!(mode).equal?(MapMode::READ_ONLY)) && !@writable)
        raise NonWritableChannelException.new
      end
      if (!@readable)
        raise NonReadableChannelException.new
      end
      addr = -1
      ti = -1
      begin
        begin
        if (!is_open)
          return nil
        end
        ti = @threads.add
        if (size < position_ + size_)
          # Extend file size
          if (!@writable)
            raise IOException.new("Channel not open for writing " + "- cannot extend file to required size")
          end
          rv = 0
          begin
            rv = truncate0(@fd, position_ + size_)
          end while (((rv).equal?(IOStatus::INTERRUPTED)) && is_open)
        end
        if ((size_).equal?(0))
          addr = 0
          if ((!@writable) || ((imode).equal?(MAP_RO)))
            return Util.new_mapped_byte_buffer_r(0, 0, nil)
          else
            return Util.new_mapped_byte_buffer(0, 0, nil)
          end
        end
        page_position = RJava.cast_to_int((position_ % self.attr_allocation_granularity))
        map_position = position_ - page_position
        map_size = size_ + page_position
        begin
          # If no exception was thrown from map0, the address is valid
          addr = map0(imode, map_position, map_size)
        rescue OutOfMemoryError => x
          # An OutOfMemoryError may indicate that we've exhausted memory
          # so force gc and re-attempt map
          System.gc
          begin
            JavaThread.sleep(100)
          rescue InterruptedException => y
            JavaThread.current_thread.interrupt
          end
          begin
            addr = map0(imode, map_position, map_size)
          rescue OutOfMemoryError => y
            # After a second OOME, fail
            raise IOException.new("Map failed", y)
          end
        end
        raise AssertError if not ((IOStatus.check_all(addr)))
        raise AssertError if not (((addr % self.attr_allocation_granularity).equal?(0)))
        isize = RJava.cast_to_int(size_)
        um = Unmapper.new(addr, size_ + page_position)
        if ((!@writable) || ((imode).equal?(MAP_RO)))
          return Util.new_mapped_byte_buffer_r(isize, addr + page_position, um)
        else
          return Util.new_mapped_byte_buffer(isize, addr + page_position, um)
        end
      ensure
        @threads.remove(ti)
        end(IOStatus.check_all(addr))
      end
    end
    
    class_module.module_eval {
      # -- Locks --
      const_set_lazy(:NO_LOCK) { -1 }
      const_attr_reader  :NO_LOCK
      
      # Failed to lock
      const_set_lazy(:LOCKED) { 0 }
      const_attr_reader  :LOCKED
      
      # Obtained requested lock
      const_set_lazy(:RET_EX_LOCK) { 1 }
      const_attr_reader  :RET_EX_LOCK
      
      # Obtained exclusive lock
      const_set_lazy(:INTERRUPTED) { 2 }
      const_attr_reader  :INTERRUPTED
    }
    
    # Request interrupted
    # keeps track of locks on this file
    attr_accessor :file_lock_table
    alias_method :attr_file_lock_table, :file_lock_table
    undef_method :file_lock_table
    alias_method :attr_file_lock_table=, :file_lock_table=
    undef_method :file_lock_table=
    
    class_module.module_eval {
      # indicates if file locks are maintained system-wide (as per spec)
      
      def is_shared_file_lock_table
        defined?(@@is_shared_file_lock_table) ? @@is_shared_file_lock_table : @@is_shared_file_lock_table= false
      end
      alias_method :attr_is_shared_file_lock_table, :is_shared_file_lock_table
      
      def is_shared_file_lock_table=(value)
        @@is_shared_file_lock_table = value
      end
      alias_method :attr_is_shared_file_lock_table=, :is_shared_file_lock_table=
      
      # indicates if the disableSystemWideOverlappingFileLockCheck property
      # has been checked
      
      def property_checked
        defined?(@@property_checked) ? @@property_checked : @@property_checked= false
      end
      alias_method :attr_property_checked, :property_checked
      
      def property_checked=(value)
        @@property_checked = value
      end
      alias_method :attr_property_checked=, :property_checked=
      
      typesig { [] }
      # The lock list in J2SE 1.4/5.0 was local to each FileChannel instance so
      # the overlap check wasn't system wide when there were multiple channels to
      # the same file. This property is used to get 1.4/5.0 behavior if desired.
      def is_shared_file_lock_table
        if (!self.attr_property_checked)
          synchronized((FileChannelImpl.class)) do
            if (!self.attr_property_checked)
              value = AccessController.do_privileged(GetPropertyAction.new("sun.nio.ch.disableSystemWideOverlappingFileLockCheck"))
              self.attr_is_shared_file_lock_table = (((value).nil?) || (value == "false"))
              self.attr_property_checked = true
            end
          end
        end
        return self.attr_is_shared_file_lock_table
      end
    }
    
    typesig { [] }
    def file_lock_table
      if ((@file_lock_table).nil?)
        synchronized((self)) do
          if ((@file_lock_table).nil?)
            @file_lock_table = is_shared_file_lock_table ? SharedFileLockTable.new(self) : SimpleFileLockTable.new
          end
        end
      end
      return @file_lock_table
    end
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Boolean] }
    def lock(position_, size_, shared)
      ensure_open
      if (shared && !@readable)
        raise NonReadableChannelException.new
      end
      if (!shared && !@writable)
        raise NonWritableChannelException.new
      end
      fli = FileLockImpl.new(self, position_, size_, shared)
      flt = file_lock_table
      flt.add(fli)
      i = true
      ti = -1
      begin
        begin
        if (!is_open)
          return nil
        end
        ti = @threads.add
        result = lock0(@fd, true, position_, size_, shared)
        if ((result).equal?(RET_EX_LOCK))
          raise AssertError if not (shared)
          fli2 = FileLockImpl.new(self, position_, size_, false)
          flt.replace(fli, fli2)
          return fli2
        end
        if ((result).equal?(INTERRUPTED) || (result).equal?(NO_LOCK))
          flt.remove(fli)
          i = false
        end
      rescue IOException => e
        flt.remove(fli)
        raise e
      ensure
        @threads.remove(ti)
        begin
          end(i)
        rescue ClosedByInterruptException => e
          raise FileLockInterruptionException.new
        end
      end
      return fli
    end
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Boolean] }
    def try_lock(position_, size_, shared)
      ensure_open
      if (shared && !@readable)
        raise NonReadableChannelException.new
      end
      if (!shared && !@writable)
        raise NonWritableChannelException.new
      end
      fli = FileLockImpl.new(self, position_, size_, shared)
      flt = file_lock_table
      flt.add(fli)
      result = lock0(@fd, false, position_, size_, shared)
      if ((result).equal?(NO_LOCK))
        flt.remove(fli)
        return nil
      end
      if ((result).equal?(RET_EX_LOCK))
        raise AssertError if not (shared)
        fli2 = FileLockImpl.new(self, position_, size_, false)
        flt.replace(fli, fli2)
        return fli2
      end
      return fli
    end
    
    typesig { [FileLockImpl] }
    def release(fli)
      ensure_open
      release0(@fd, fli.position, fli.size)
      raise AssertError if not (!(@file_lock_table).nil?)
      @file_lock_table.remove(fli)
    end
    
    class_module.module_eval {
      # -- File lock support  --
      # 
      # A table of FileLocks.
      const_set_lazy(:FileLockTable) { Module.new do
        include_class_members FileChannelImpl
        
        typesig { [FileLock] }
        # Adds a file lock to the table.
        # 
        # @throws OverlappingFileLockException if the file lock overlaps
        # with an existing file lock in the table
        def add(fl)
          raise NotImplementedError
        end
        
        typesig { [FileLock] }
        # Remove an existing file lock from the table.
        def remove(fl)
          raise NotImplementedError
        end
        
        class_module.module_eval {
          # An implementation of this interface releases a given file lock.
          # Used with removeAll.
          const_set_lazy(:Releaser) { Module.new do
            include_class_members FileLockTable
            
            typesig { [FileLock] }
            def release(fl)
              raise NotImplementedError
            end
          end }
        }
        
        typesig { [Releaser] }
        # Removes all file locks from the table.
        # <p>
        # The Releaser#release method is invoked for each file lock before
        # it is removed.
        # 
        # @throws IOException if the release method throws IOException
        def remove_all(r)
          raise NotImplementedError
        end
        
        typesig { [FileLock, FileLock] }
        # Replaces an existing file lock in the table.
        def replace(fl1, fl2)
          raise NotImplementedError
        end
      end }
      
      # A simple file lock table that maintains a list of FileLocks obtained by a
      # FileChannel. Use to get 1.4/5.0 behaviour.
      const_set_lazy(:SimpleFileLockTable) { Class.new do
        include_class_members FileChannelImpl
        include FileLockTable
        
        # synchronize on list for access
        attr_accessor :lock_list
        alias_method :attr_lock_list, :lock_list
        undef_method :lock_list
        alias_method :attr_lock_list=, :lock_list=
        undef_method :lock_list=
        
        typesig { [] }
        def initialize
          @lock_list = ArrayList.new(2)
        end
        
        typesig { [::Java::Long, ::Java::Long] }
        def check_list(position, size)
          raise AssertError if not (JavaThread.holds_lock(@lock_list))
          @lock_list.each do |fl|
            if (fl.overlaps(position, size))
              raise OverlappingFileLockException.new
            end
          end
        end
        
        typesig { [FileLock] }
        def add(fl)
          synchronized((@lock_list)) do
            check_list(fl.position, fl.size)
            @lock_list.add(fl)
          end
        end
        
        typesig { [FileLock] }
        def remove(fl)
          synchronized((@lock_list)) do
            @lock_list.remove(fl)
          end
        end
        
        typesig { [Releaser] }
        def remove_all(releaser)
          synchronized((@lock_list)) do
            i = @lock_list.iterator
            while (i.has_next)
              fl = i.next
              releaser.release(fl)
              i.remove
            end
          end
        end
        
        typesig { [FileLock, FileLock] }
        def replace(fl1, fl2)
          synchronized((@lock_list)) do
            @lock_list.remove(fl1)
            @lock_list.add(fl2)
          end
        end
        
        private
        alias_method :initialize__simple_file_lock_table, :initialize
      end }
      
      # A weak reference to a FileLock.
      # <p>
      # SharedFileLockTable uses a list of file lock references to avoid keeping the
      # FileLock (and FileChannel) alive.
      const_set_lazy(:FileLockReference) { Class.new(WeakReference) do
        include_class_members FileChannelImpl
        
        attr_accessor :file_key
        alias_method :attr_file_key, :file_key
        undef_method :file_key
        alias_method :attr_file_key=, :file_key=
        undef_method :file_key=
        
        typesig { [FileLock, ReferenceQueue, FileKey] }
        def initialize(referent, queue, key)
          @file_key = nil
          super(referent, queue)
          @file_key = key
        end
        
        typesig { [] }
        def file_key
          return @file_key
        end
        
        private
        alias_method :initialize__file_lock_reference, :initialize
      end }
      
      # A file lock table that is over a system-wide map of all file locks.
      const_set_lazy(:SharedFileLockTable) { Class.new do
        include_class_members FileChannelImpl
        include FileLockTable
        
        class_module.module_eval {
          # The system-wide map is a ConcurrentHashMap that is keyed on the FileKey.
          # The map value is a list of file locks represented by FileLockReferences.
          # All access to the list must be synchronized on the list.
          
          def lock_map
            defined?(@@lock_map) ? @@lock_map : @@lock_map= ConcurrentHashMap.new
          end
          alias_method :attr_lock_map, :lock_map
          
          def lock_map=(value)
            @@lock_map = value
          end
          alias_method :attr_lock_map=, :lock_map=
          
          # reference queue for cleared refs
          
          def queue
            defined?(@@queue) ? @@queue : @@queue= ReferenceQueue.new
          end
          alias_method :attr_queue, :queue
          
          def queue=(value)
            @@queue = value
          end
          alias_method :attr_queue=, :queue=
        }
        
        # the enclosing file channel
        attr_accessor :fci
        alias_method :attr_fci, :fci
        undef_method :fci
        alias_method :attr_fci=, :fci=
        undef_method :fci=
        
        # File key for the file that this channel is connected to
        attr_accessor :file_key
        alias_method :attr_file_key, :file_key
        undef_method :file_key
        alias_method :attr_file_key=, :file_key=
        undef_method :file_key=
        
        typesig { [FileChannelImpl] }
        def initialize(fci)
          @fci = nil
          @file_key = nil
          @fci = fci
          @file_key = FileKey.create(fci.attr_fd)
        end
        
        typesig { [FileLock] }
        def add(fl)
          list = self.attr_lock_map.get(@file_key)
          loop do
            # The key isn't in the map so we try to create it atomically
            if ((list).nil?)
              list = ArrayList.new(2)
              prev = nil
              synchronized((list)) do
                prev = self.attr_lock_map.put_if_absent(@file_key, list)
                if ((prev).nil?)
                  # we successfully created the key so we add the file lock
                  list.add(FileLockReference.new(fl, self.attr_queue, @file_key))
                  break
                end
              end
              # someone else got there first
              list = prev
            end
            # There is already a key. It is possible that some other thread
            # is removing it so we re-fetch the value from the map. If it
            # hasn't changed then we check the list for overlapping locks
            # and add the new lock to the list.
            synchronized((list)) do
              current = self.attr_lock_map.get(@file_key)
              if ((list).equal?(current))
                check_list(list, fl.position, fl.size)
                list.add(FileLockReference.new(fl, self.attr_queue, @file_key))
                break
              end
              list = current
            end
          end
          # process any stale entries pending in the reference queue
          remove_stale_entries
        end
        
        typesig { [FileKey, ArrayList] }
        def remove_key_if_empty(fk, list)
          raise AssertError if not (JavaThread.holds_lock(list))
          raise AssertError if not ((self.attr_lock_map.get(fk)).equal?(list))
          if (list.is_empty)
            self.attr_lock_map.remove(fk)
          end
        end
        
        typesig { [FileLock] }
        def remove(fl)
          raise AssertError if not (!(fl).nil?)
          # the lock must exist so the list of locks must be present
          list = self.attr_lock_map.get(@file_key)
          raise AssertError if not (!(list).nil?)
          synchronized((list)) do
            index = 0
            while (index < list.size)
              ref = list.get(index)
              lock = ref.get
              if ((lock).equal?(fl))
                raise AssertError if not ((!(lock).nil?) && ((lock.channel).equal?(@fci)))
                ref.clear
                list.remove(index)
                break
              end
              index += 1
            end
          end
        end
        
        typesig { [Releaser] }
        def remove_all(releaser)
          list = self.attr_lock_map.get(@file_key)
          if (!(list).nil?)
            synchronized((list)) do
              index = 0
              while (index < list.size)
                ref = list.get(index)
                lock = ref.get
                # remove locks obtained by this channel
                if (!(lock).nil? && (lock.channel).equal?(@fci))
                  # invoke the releaser to invalidate/release the lock
                  releaser.release(lock)
                  # remove the lock from the list
                  ref.clear
                  list.remove(index)
                else
                  index += 1
                end
              end
              # once the lock list is empty we remove it from the map
              remove_key_if_empty(@file_key, list)
            end
          end
        end
        
        typesig { [FileLock, FileLock] }
        def replace(from_lock, to_lock)
          # the lock must exist so there must be a list
          list = self.attr_lock_map.get(@file_key)
          raise AssertError if not (!(list).nil?)
          synchronized((list)) do
            index = 0
            while index < list.size
              ref = list.get(index)
              lock = ref.get
              if ((lock).equal?(from_lock))
                ref.clear
                list.set(index, FileLockReference.new(to_lock, self.attr_queue, @file_key))
                break
              end
              index += 1
            end
          end
        end
        
        typesig { [JavaList, ::Java::Long, ::Java::Long] }
        # Check for overlapping file locks
        def check_list(list, position_, size_)
          raise AssertError if not (JavaThread.holds_lock(list))
          list.each do |ref|
            fl = ref.get
            if (!(fl).nil? && fl.overlaps(position_, size_))
              raise OverlappingFileLockException.new
            end
          end
        end
        
        typesig { [] }
        # Process the reference queue
        def remove_stale_entries
          ref = nil
          while (!((ref = self.attr_queue.poll)).nil?)
            fk = ref.file_key
            list = self.attr_lock_map.get(fk)
            if (!(list).nil?)
              synchronized((list)) do
                list.remove(ref)
                remove_key_if_empty(fk, list)
              end
            end
          end
        end
        
        private
        alias_method :initialize__shared_file_lock_table, :initialize
      end }
    }
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_lock0, [:pointer, :long, :long, :int8, :int64, :int64, :int8], :int32
    typesig { [FileDescriptor, ::Java::Boolean, ::Java::Long, ::Java::Long, ::Java::Boolean] }
    # -- Native methods --
    # Grabs a file lock
    def lock0(fd, blocking, pos, size_, shared)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_lock0, JNI.env, self.jni_id, fd.jni_id, blocking ? 1 : 0, pos.to_int, size_.to_int, shared ? 1 : 0)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_release0, [:pointer, :long, :long, :int64, :int64], :void
    typesig { [FileDescriptor, ::Java::Long, ::Java::Long] }
    # Releases a file lock
    def release0(fd, pos, size_)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_release0, JNI.env, self.jni_id, fd.jni_id, pos.to_int, size_.to_int)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_map0, [:pointer, :long, :int32, :int64, :int64], :int64
    typesig { [::Java::Int, ::Java::Long, ::Java::Long] }
    # Creates a new mapping
    def map0(prot, position_, length)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_map0, JNI.env, self.jni_id, prot.to_int, position_.to_int, length.to_int)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_FileChannelImpl_unmap0, [:pointer, :long, :int64, :int64], :int32
      typesig { [::Java::Long, ::Java::Long] }
      # Removes an existing mapping
      def unmap0(address, length)
        JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_unmap0, JNI.env, self.jni_id, address.to_int, length.to_int)
      end
    }
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_force0, [:pointer, :long, :long, :int8], :int32
    typesig { [FileDescriptor, ::Java::Boolean] }
    # Forces output to device
    def force0(fd, meta_data)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_force0, JNI.env, self.jni_id, fd.jni_id, meta_data ? 1 : 0)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_truncate0, [:pointer, :long, :long, :int64], :int32
    typesig { [FileDescriptor, ::Java::Long] }
    # Truncates a file
    def truncate0(fd, size_)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_truncate0, JNI.env, self.jni_id, fd.jni_id, size_.to_int)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_transferTo0, [:pointer, :long, :int32, :int64, :int64, :int32], :int64
    typesig { [::Java::Int, ::Java::Long, ::Java::Long, ::Java::Int] }
    # Transfers from src to dst, or returns -2 if kernel can't do that
    def transfer_to0(src, position_, count, dst)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_transferTo0, JNI.env, self.jni_id, src.to_int, position_.to_int, count.to_int, dst.to_int)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_position0, [:pointer, :long, :long, :int64], :int64
    typesig { [FileDescriptor, ::Java::Long] }
    # Sets or reports this file's position
    # If offset is -1, the current position is returned
    # otherwise the position is set to offset
    def position0(fd, offset)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_position0, JNI.env, self.jni_id, fd.jni_id, offset.to_int)
    end
    
    JNI.native_method :Java_sun_nio_ch_FileChannelImpl_size0, [:pointer, :long, :long], :int64
    typesig { [FileDescriptor] }
    # Reports this file's size
    def size0(fd)
      JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_size0, JNI.env, self.jni_id, fd.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_FileChannelImpl_initIDs, [:pointer, :long], :int64
      typesig { [] }
      # Caches fieldIDs
      def init_ids
        JNI.__send__(:Java_sun_nio_ch_FileChannelImpl_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Util.load
        self.attr_allocation_granularity = init_ids
        self.attr_nd = FileDispatcher.new
        self.attr_is_amapped_buffer_field = Reflect.lookup_field("java.nio.MappedByteBuffer", "isAMappedBuffer")
      end
    }
    
    private
    alias_method :initialize__file_channel_impl, :initialize
  end
  
end

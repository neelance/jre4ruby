require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IOUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include ::Java::Net
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # File-descriptor based I/O utilities that are shared by NIO classes.
  class IOUtil 
    include_class_members IOUtilImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Array.typed(ByteBuffer)] }
      # No instantiation
      # 
      # Returns the index of first buffer in bufs with remaining,
      # or -1 if there is nothing left
      def remaining(bufs)
        num_bufs = bufs.attr_length
        remaining = false
        i = 0
        while i < num_bufs
          if (bufs[i].has_remaining)
            return i
          end
          i += 1
        end
        return -1
      end
      
      typesig { [Array.typed(ByteBuffer), ::Java::Int] }
      # Returns a new ByteBuffer array with only unfinished buffers in it
      def skip_bufs(bufs, next_with_remaining)
        new_size = bufs.attr_length - next_with_remaining
        temp = Array.typed(ByteBuffer).new(new_size) { nil }
        i = 0
        while i < new_size
          temp[i] = bufs[i + next_with_remaining]
          i += 1
        end
        return temp
      end
      
      typesig { [FileDescriptor, ByteBuffer, ::Java::Long, NativeDispatcher, Object] }
      def write(fd, src, position, nd, lock)
        if (src.is_a?(DirectBuffer))
          return write_from_native_buffer(fd, src, position, nd, lock)
        end
        # Substitute a native buffer
        pos = src.position
        lim = src.limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        bb = nil
        begin
          bb = Util.get_temporary_direct_buffer(rem)
          bb.put(src)
          bb.flip
          # Do not update src until we see how many bytes were written
          src.position(pos)
          n = write_from_native_buffer(fd, bb, position, nd, lock)
          if (n > 0)
            # now update src
            src.position(pos + n)
          end
          return n
        ensure
          Util.release_temporary_direct_buffer(bb)
        end
      end
      
      typesig { [FileDescriptor, ByteBuffer, ::Java::Long, NativeDispatcher, Object] }
      def write_from_native_buffer(fd, bb, position_, nd, lock)
        pos = bb.position
        lim = bb.limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        written = 0
        if ((rem).equal?(0))
          return 0
        end
        if (!(position_).equal?(-1))
          written = nd.pwrite(fd, (bb).address + pos, rem, position_, lock)
        else
          written = nd.write(fd, (bb).address + pos, rem)
        end
        if (written > 0)
          bb.position(pos + written)
        end
        return written
      end
      
      typesig { [FileDescriptor, Array.typed(ByteBuffer), NativeDispatcher] }
      def write(fd, bufs, nd)
        next_with_remaining = remaining(bufs)
        # if all bufs are empty we should return immediately
        if (next_with_remaining < 0)
          return 0
        end
        # If some bufs are empty we should skip them
        if (next_with_remaining > 0)
          bufs = skip_bufs(bufs, next_with_remaining)
        end
        num_bufs = bufs.attr_length
        bytes_ready_to_write = 0
        # Create shadow to ensure DirectByteBuffers are used
        shadow = Array.typed(ByteBuffer).new(num_bufs) { nil }
        i = 0
        while i < num_bufs
          if (!(bufs[i].is_a?(DirectBuffer)))
            pos = bufs[i].position
            lim = bufs[i].limit
            raise AssertError if not ((pos <= lim))
            rem = (pos <= lim ? lim - pos : 0)
            bb = ByteBuffer.allocate_direct(rem)
            shadow[i] = bb
            # Leave slow buffer position untouched; it will be updated
            # after we see how many bytes were really written out
            bb.put(bufs[i])
            bufs[i].position(pos)
            bb.flip
          else
            shadow[i] = bufs[i]
          end
          i += 1
        end
        vec = nil
        bytes_written = 0
        begin
          # Create a native iovec array
          vec = IOVecWrapper.new(num_bufs)
          # Fill in the iovec array with appropriate data
          i_ = 0
          while i_ < num_bufs
            next_buffer = shadow[i_]
            # put in the buffer addresses
            pos = next_buffer.position
            len = next_buffer.limit - pos
            bytes_ready_to_write += len
            vec.put_base(i_, (next_buffer).address + pos)
            vec.put_len(i_, len)
            i_ += 1
          end
          # Invoke native call to fill the buffers
          bytes_written = nd.writev(fd, vec.attr_address, num_bufs)
        ensure
          vec.free
        end
        return_val = bytes_written
        # Notify the buffers how many bytes were taken
        i__ = 0
        while i__ < num_bufs
          next_buffer = bufs[i__]
          pos = next_buffer.position
          lim = next_buffer.limit
          raise AssertError if not ((pos <= lim))
          len = (pos <= lim ? lim - pos : lim)
          if (bytes_written >= len)
            bytes_written -= len
            new_position = pos + len
            next_buffer.position(new_position)
          else
            # Buffers not completely filled
            if (bytes_written > 0)
              raise AssertError if not ((pos + bytes_written < JavaInteger::MAX_VALUE))
              new_position = RJava.cast_to_int((pos + bytes_written))
              next_buffer.position(new_position)
            end
            break
          end
          i__ += 1
        end
        return return_val
      end
      
      typesig { [FileDescriptor, ByteBuffer, ::Java::Long, NativeDispatcher, Object] }
      def read(fd, dst, position_, nd, lock)
        if (dst.is_read_only)
          raise IllegalArgumentException.new("Read-only buffer")
        end
        if (dst.is_a?(DirectBuffer))
          return read_into_native_buffer(fd, dst, position_, nd, lock)
        end
        # Substitute a native buffer
        bb = nil
        begin
          bb = Util.get_temporary_direct_buffer(dst.remaining)
          n = read_into_native_buffer(fd, bb, position_, nd, lock)
          bb.flip
          if (n > 0)
            dst.put(bb)
          end
          return n
        ensure
          Util.release_temporary_direct_buffer(bb)
        end
      end
      
      typesig { [FileDescriptor, ByteBuffer, ::Java::Long, NativeDispatcher, Object] }
      def read_into_native_buffer(fd, bb, position_, nd, lock)
        pos = bb.position
        lim = bb.limit
        raise AssertError if not ((pos <= lim))
        rem = (pos <= lim ? lim - pos : 0)
        if ((rem).equal?(0))
          return 0
        end
        n = 0
        if (!(position_).equal?(-1))
          n = nd.pread(fd, (bb).address + pos, rem, position_, lock)
        else
          n = nd.read(fd, (bb).address + pos, rem)
        end
        if (n > 0)
          bb.position(pos + n)
        end
        return n
      end
      
      typesig { [FileDescriptor, Array.typed(ByteBuffer), NativeDispatcher] }
      def read(fd, bufs, nd)
        next_with_remaining = remaining(bufs)
        # if all bufs are empty we should return immediately
        if (next_with_remaining < 0)
          return 0
        end
        # If some bufs are empty we should skip them
        if (next_with_remaining > 0)
          bufs = skip_bufs(bufs, next_with_remaining)
        end
        num_bufs = bufs.attr_length
        # Read into the shadow to ensure DirectByteBuffers are used
        shadow = Array.typed(ByteBuffer).new(num_bufs) { nil }
        i = 0
        while i < num_bufs
          if (bufs[i].is_read_only)
            raise IllegalArgumentException.new("Read-only buffer")
          end
          if (!(bufs[i].is_a?(DirectBuffer)))
            shadow[i] = ByteBuffer.allocate_direct(bufs[i].remaining)
          else
            shadow[i] = bufs[i]
          end
          i += 1
        end
        vec = nil
        bytes_read = 0
        begin
          # Create a native iovec array
          vec = IOVecWrapper.new(num_bufs)
          # Fill in the iovec array with appropriate data
          i_ = 0
          while i_ < num_bufs
            next_buffer = shadow[i_]
            # put in the buffer addresses
            pos = next_buffer.position
            len = next_buffer.remaining
            vec.put_base(i_, (next_buffer).address + pos)
            vec.put_len(i_, len)
            i_ += 1
          end
          # Invoke native call to fill the buffers
          bytes_read = nd.readv(fd, vec.attr_address, num_bufs)
        ensure
          vec.free
        end
        return_val = bytes_read
        # Notify the buffers how many bytes were read
        i__ = 0
        while i__ < num_bufs
          next_buffer = shadow[i__]
          # Note: should this have been cached from above?
          pos = next_buffer.position
          len = next_buffer.remaining
          if (bytes_read >= len)
            bytes_read -= len
            new_position = pos + len
            next_buffer.position(new_position)
          else
            # Buffers not completely filled
            if (bytes_read > 0)
              raise AssertError if not ((pos + bytes_read < JavaInteger::MAX_VALUE))
              new_position = RJava.cast_to_int((pos + bytes_read))
              next_buffer.position(new_position)
            end
            break
          end
          i__ += 1
        end
        # Put results from shadow into the slow buffers
        i___ = 0
        while i___ < num_bufs
          if (!(bufs[i___].is_a?(DirectBuffer)))
            shadow[i___].flip
            bufs[i___].put(shadow[i___])
          end
          i___ += 1
        end
        return return_val
      end
      
      typesig { [::Java::Int] }
      def new_fd(i)
        fd = FileDescriptor.new
        setfd_val(fd, i)
        return fd
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_randomBytes, [:pointer, :long, :long], :int8
      typesig { [Array.typed(::Java::Byte)] }
      def random_bytes(some_bytes)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_randomBytes, JNI.env, self.jni_id, some_bytes.jni_id) != 0
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_initPipe, [:pointer, :long, :long, :int8], :void
      typesig { [Array.typed(::Java::Int), ::Java::Boolean] }
      def init_pipe(fda, blocking)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_initPipe, JNI.env, self.jni_id, fda.jni_id, blocking ? 1 : 0)
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_drain, [:pointer, :long, :int32], :int8
      typesig { [::Java::Int] }
      def drain(fd)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_drain, JNI.env, self.jni_id, fd.to_int) != 0
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_configureBlocking, [:pointer, :long, :long, :int8], :void
      typesig { [FileDescriptor, ::Java::Boolean] }
      def configure_blocking(fd, blocking)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_configureBlocking, JNI.env, self.jni_id, fd.jni_id, blocking ? 1 : 0)
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_fdVal, [:pointer, :long, :long], :int32
      typesig { [FileDescriptor] }
      def fd_val(fd)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_fdVal, JNI.env, self.jni_id, fd.jni_id)
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_setfdVal, [:pointer, :long, :long, :int32], :void
      typesig { [FileDescriptor, ::Java::Int] }
      def setfd_val(fd, value)
        JNI.__send__(:Java_sun_nio_ch_IOUtil_setfdVal, JNI.env, self.jni_id, fd.jni_id, value.to_int)
      end
      
      JNI.native_method :Java_sun_nio_ch_IOUtil_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_sun_nio_ch_IOUtil_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        # Note that IOUtil.initIDs is called from within Util.load.
        Util.load
      end
    }
    
    private
    alias_method :initialize__ioutil, :initialize
  end
  
end

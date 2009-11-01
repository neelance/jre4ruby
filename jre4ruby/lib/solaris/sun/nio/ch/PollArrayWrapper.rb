require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PollArrayWrapperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Sun::Misc
    }
  end
  
  # Manipulates a native array of pollfd structs on Solaris:
  # 
  # typedef struct pollfd {
  # int fd;
  # short events;
  # short revents;
  # } pollfd_t;
  # 
  # @author Mike McCloskey
  # @since 1.4
  class PollArrayWrapper < PollArrayWrapperImports.const_get :AbstractPollArrayWrapper
    include_class_members PollArrayWrapperImports
    
    class_module.module_eval {
      const_set_lazy(:POLLCONN) { POLLOUT }
      const_attr_reader  :POLLCONN
    }
    
    # File descriptor to write for interrupt
    attr_accessor :interrupt_fd
    alias_method :attr_interrupt_fd, :interrupt_fd
    undef_method :interrupt_fd
    alias_method :attr_interrupt_fd=, :interrupt_fd=
    undef_method :interrupt_fd=
    
    typesig { [::Java::Int] }
    def initialize(new_size)
      @interrupt_fd = 0
      super()
      new_size = (new_size + 1) * SIZE_POLLFD
      self.attr_poll_array = AllocatedNativeObject.new(new_size, false)
      self.attr_poll_array_address = self.attr_poll_array.address
      self.attr_total_channels = 1
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def init_interrupt(fd0, fd1)
      @interrupt_fd = fd1
      put_descriptor(0, fd0)
      put_event_ops(0, POLLIN)
      put_revent_ops(0, 0)
    end
    
    typesig { [::Java::Int] }
    def release(i)
      return
    end
    
    typesig { [] }
    def free
      self.attr_poll_array.free
    end
    
    typesig { [SelChImpl] }
    # Prepare another pollfd struct for use.
    def add_entry(sc)
      put_descriptor(self.attr_total_channels, IOUtil.fd_val(sc.get_fd))
      put_event_ops(self.attr_total_channels, 0)
      put_revent_ops(self.attr_total_channels, 0)
      self.attr_total_channels += 1
    end
    
    class_module.module_eval {
      typesig { [PollArrayWrapper, ::Java::Int, PollArrayWrapper, ::Java::Int] }
      # Writes the pollfd entry from the source wrapper at the source index
      # over the entry in the target wrapper at the target index. The source
      # array remains unchanged unless the source array and the target are
      # the same array.
      def replace_entry(source, sindex, target, tindex)
        target.put_descriptor(tindex, source.get_descriptor(sindex))
        target.put_event_ops(tindex, source.get_event_ops(sindex))
        target.put_revent_ops(tindex, source.get_revent_ops(sindex))
      end
    }
    
    typesig { [::Java::Int] }
    # Grows the pollfd array to a size that will accommodate newSize
    # pollfd entries. This method does no checking of the newSize
    # to determine if it is in fact bigger than the old size: it
    # always reallocates an array of the new size.
    def grow(new_size)
      # create new array
      temp = PollArrayWrapper.new(new_size)
      # Copy over existing entries
      i = 0
      while i < self.attr_total_channels
        replace_entry(self, i, temp, i)
        i += 1
      end
      # Swap new array into pollArray field
      self.attr_poll_array.free
      self.attr_poll_array = temp.attr_poll_array
      self.attr_poll_array_address = self.attr_poll_array.address
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Long] }
    def poll(numfds, offset, timeout)
      return poll0(self.attr_poll_array_address + (offset * SIZE_POLLFD), numfds, timeout)
    end
    
    typesig { [] }
    def interrupt
      interrupt(@interrupt_fd)
    end
    
    JNI.load_native_method :Java_sun_nio_ch_PollArrayWrapper_poll0, [:pointer, :long, :int64, :int32, :int64], :int32
    typesig { [::Java::Long, ::Java::Int, ::Java::Long] }
    def poll0(poll_address, numfds, timeout)
      JNI.call_native_method(:Java_sun_nio_ch_PollArrayWrapper_poll0, JNI.env, self.jni_id, poll_address.to_int, numfds.to_int, timeout.to_int)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_nio_ch_PollArrayWrapper_interrupt, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def interrupt(fd)
        JNI.call_native_method(:Java_sun_nio_ch_PollArrayWrapper_interrupt, JNI.env, self.jni_id, fd.to_int)
      end
    }
    
    private
    alias_method :initialize__poll_array_wrapper, :initialize
  end
  
end

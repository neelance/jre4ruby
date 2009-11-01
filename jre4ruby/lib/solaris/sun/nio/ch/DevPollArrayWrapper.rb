require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DevPollArrayWrapperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Sun::Misc
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :LinkedList
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
  class DevPollArrayWrapper 
    include_class_members DevPollArrayWrapperImports
    
    class_module.module_eval {
      # Event masks
      const_set_lazy(:POLLIN) { 0x1 }
      const_attr_reader  :POLLIN
      
      const_set_lazy(:POLLPRI) { 0x2 }
      const_attr_reader  :POLLPRI
      
      const_set_lazy(:POLLOUT) { 0x4 }
      const_attr_reader  :POLLOUT
      
      const_set_lazy(:POLLRDNORM) { 0x40 }
      const_attr_reader  :POLLRDNORM
      
      const_set_lazy(:POLLWRNORM) { POLLOUT }
      const_attr_reader  :POLLWRNORM
      
      const_set_lazy(:POLLRDBAND) { 0x80 }
      const_attr_reader  :POLLRDBAND
      
      const_set_lazy(:POLLWRBAND) { 0x100 }
      const_attr_reader  :POLLWRBAND
      
      const_set_lazy(:POLLNORM) { POLLRDNORM }
      const_attr_reader  :POLLNORM
      
      const_set_lazy(:POLLERR) { 0x8 }
      const_attr_reader  :POLLERR
      
      const_set_lazy(:POLLHUP) { 0x10 }
      const_attr_reader  :POLLHUP
      
      const_set_lazy(:POLLNVAL) { 0x20 }
      const_attr_reader  :POLLNVAL
      
      const_set_lazy(:POLLREMOVE) { 0x800 }
      const_attr_reader  :POLLREMOVE
      
      const_set_lazy(:POLLCONN) { POLLOUT }
      const_attr_reader  :POLLCONN
      
      # Miscellaneous constants
      const_set_lazy(:SIZE_POLLFD) { 8 }
      const_attr_reader  :SIZE_POLLFD
      
      const_set_lazy(:FD_OFFSET) { 0 }
      const_attr_reader  :FD_OFFSET
      
      const_set_lazy(:EVENT_OFFSET) { 4 }
      const_attr_reader  :EVENT_OFFSET
      
      const_set_lazy(:REVENT_OFFSET) { 6 }
      const_attr_reader  :REVENT_OFFSET
      
      # Maximum number of open file descriptors
      const_set_lazy(:OPEN_MAX) { fd_limit }
      const_attr_reader  :OPEN_MAX
      
      # Number of pollfd structures to create.
      # DP_POLL ioctl allows up to OPEN_MAX-1
      const_set_lazy(:NUM_POLLFDS) { Math.min(OPEN_MAX - 1, 8192) }
      const_attr_reader  :NUM_POLLFDS
    }
    
    # Base address of the native pollArray
    attr_accessor :poll_array_address
    alias_method :attr_poll_array_address, :poll_array_address
    undef_method :poll_array_address
    alias_method :attr_poll_array_address=, :poll_array_address=
    undef_method :poll_array_address=
    
    # Maximum number of POLL_FD structs to update at once
    attr_accessor :max_update_size
    alias_method :attr_max_update_size, :max_update_size
    undef_method :max_update_size
    alias_method :attr_max_update_size=, :max_update_size=
    undef_method :max_update_size=
    
    typesig { [] }
    def initialize
      @poll_array_address = 0
      @max_update_size = 10000
      @update_list = LinkedList.new
      @poll_array = nil
      @wfd = 0
      @outgoing_interrupt_fd = 0
      @incoming_interrupt_fd = 0
      @interrupted_index = 0
      @updated = 0
      @interrupted = false
      allocation_size = NUM_POLLFDS * SIZE_POLLFD
      @poll_array = AllocatedNativeObject.new(allocation_size, true)
      @poll_array_address = @poll_array.address
      @wfd = init
      i = 0
      while i < NUM_POLLFDS
        put_descriptor(i, 0)
        put_event_ops(i, 0)
        put_revent_ops(i, 0)
        i += 1
      end
    end
    
    class_module.module_eval {
      # Machinery for remembering fd registration changes
      # A hashmap could be used but the number of changes pending
      # is expected to be small
      const_set_lazy(:Updator) { Class.new do
        include_class_members DevPollArrayWrapper
        
        attr_accessor :fd
        alias_method :attr_fd, :fd
        undef_method :fd
        alias_method :attr_fd=, :fd=
        undef_method :fd=
        
        attr_accessor :mask
        alias_method :attr_mask, :mask
        undef_method :mask
        alias_method :attr_mask=, :mask=
        undef_method :mask=
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(fd, mask)
          @fd = 0
          @mask = 0
          @fd = fd
          @mask = mask
        end
        
        private
        alias_method :initialize__updator, :initialize
      end }
    }
    
    attr_accessor :update_list
    alias_method :attr_update_list, :update_list
    undef_method :update_list
    alias_method :attr_update_list=, :update_list=
    undef_method :update_list=
    
    # The pollfd array for results from devpoll driver
    attr_accessor :poll_array
    alias_method :attr_poll_array, :poll_array
    undef_method :poll_array
    alias_method :attr_poll_array=, :poll_array=
    undef_method :poll_array=
    
    # The fd of the devpoll driver
    attr_accessor :wfd
    alias_method :attr_wfd, :wfd
    undef_method :wfd
    alias_method :attr_wfd=, :wfd=
    undef_method :wfd=
    
    # The fd of the interrupt line going out
    attr_accessor :outgoing_interrupt_fd
    alias_method :attr_outgoing_interrupt_fd, :outgoing_interrupt_fd
    undef_method :outgoing_interrupt_fd
    alias_method :attr_outgoing_interrupt_fd=, :outgoing_interrupt_fd=
    undef_method :outgoing_interrupt_fd=
    
    # The fd of the interrupt line coming in
    attr_accessor :incoming_interrupt_fd
    alias_method :attr_incoming_interrupt_fd, :incoming_interrupt_fd
    undef_method :incoming_interrupt_fd
    alias_method :attr_incoming_interrupt_fd=, :incoming_interrupt_fd=
    undef_method :incoming_interrupt_fd=
    
    # The index of the interrupt FD
    attr_accessor :interrupted_index
    alias_method :attr_interrupted_index, :interrupted_index
    undef_method :interrupted_index
    alias_method :attr_interrupted_index=, :interrupted_index=
    undef_method :interrupted_index=
    
    # Number of updated pollfd entries
    attr_accessor :updated
    alias_method :attr_updated, :updated
    undef_method :updated
    alias_method :attr_updated=, :updated=
    undef_method :updated=
    
    typesig { [::Java::Int, ::Java::Int] }
    def init_interrupt(fd0, fd1)
      @outgoing_interrupt_fd = fd1
      @incoming_interrupt_fd = fd0
      register(@wfd, fd0, POLLIN)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_event_ops(i, event)
      offset = SIZE_POLLFD * i + EVENT_OFFSET
      @poll_array.put_short(offset, RJava.cast_to_short(event))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_revent_ops(i, revent)
      offset = SIZE_POLLFD * i + REVENT_OFFSET
      @poll_array.put_short(offset, RJava.cast_to_short(revent))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_descriptor(i, fd)
      offset = SIZE_POLLFD * i + FD_OFFSET
      @poll_array.put_int(offset, fd)
    end
    
    typesig { [::Java::Int] }
    def get_event_ops(i)
      offset = SIZE_POLLFD * i + EVENT_OFFSET
      return @poll_array.get_short(offset)
    end
    
    typesig { [::Java::Int] }
    def get_revent_ops(i)
      offset = SIZE_POLLFD * i + REVENT_OFFSET
      return @poll_array.get_short(offset)
    end
    
    typesig { [::Java::Int] }
    def get_descriptor(i)
      offset = SIZE_POLLFD * i + FD_OFFSET
      return @poll_array.get_int(offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def set_interest(fd, mask)
      synchronized((@update_list)) do
        @update_list.add(Updator.new(fd, mask))
      end
    end
    
    typesig { [::Java::Int] }
    def release(fd)
      synchronized((@update_list)) do
        @update_list.add(Updator.new(fd, POLLREMOVE))
      end
    end
    
    typesig { [] }
    def close_dev_poll_fd
      FileDispatcher.close_int_fd(@wfd)
      @poll_array.free
    end
    
    typesig { [::Java::Long] }
    def poll(timeout)
      update_registrations
      @updated = poll0(@poll_array_address, NUM_POLLFDS, timeout, @wfd)
      i = 0
      while i < @updated
        if ((get_descriptor(i)).equal?(@incoming_interrupt_fd))
          @interrupted_index = i
          @interrupted = true
          break
        end
        i += 1
      end
      return @updated
    end
    
    typesig { [] }
    def update_registrations
      # take snapshot of the updateList size to see if there are
      # any registrations to update
      update_size = 0
      synchronized((@update_list)) do
        update_size = @update_list.size
      end
      if (update_size > 0)
        # Construct a pollfd array with updated masks; we may overallocate
        # by some amount because if the events are already POLLREMOVE
        # then the second pollfd of that pair will not be needed. The
        # number of entries is limited to a reasonable number to avoid
        # allocating a lot of memory.
        max_updates = Math.min(update_size * 2, @max_update_size)
        allocation_size = max_updates * SIZE_POLLFD
        update_poll_array = AllocatedNativeObject.new(allocation_size, true)
        begin
          synchronized((@update_list)) do
            while (@update_list.size > 0)
              # We have to insert a dummy node in between each
              # real update to use POLLREMOVE on the fd first because
              # otherwise the changes are simply OR'd together
              index = 0
              u = nil
              while (!((u = @update_list.poll)).nil?)
                # First add pollfd struct to clear out this fd
                put_poll_fd(update_poll_array, index, u.attr_fd, RJava.cast_to_short(POLLREMOVE))
                index += 1
                # Now add pollfd to update this fd, if necessary
                if (!(u.attr_mask).equal?(POLLREMOVE))
                  put_poll_fd(update_poll_array, index, u.attr_fd, RJava.cast_to_short(u.attr_mask))
                  index += 1
                end
                # Check against the max allocation size; these are
                # all we will process. Valid index ranges from 0 to
                # (maxUpdates - 1) and we can use up to 2 per loop
                if (index > max_updates - 2)
                  break
                end
              end
              # Register the changes with /dev/poll
              register_multiple(@wfd, update_poll_array.address, index)
            end
          end
        ensure
          # Free the native array
          update_poll_array.free
          # BUG: If an exception was thrown then the selector now believes
          # that the last set of changes was updated but it probably
          # was not. This should not be a likely occurrence.
        end
      end
    end
    
    typesig { [AllocatedNativeObject, ::Java::Int, ::Java::Int, ::Java::Short] }
    def put_poll_fd(array, index, fd, event)
      struct_index = SIZE_POLLFD * index
      array.put_int(struct_index + FD_OFFSET, fd)
      array.put_short(struct_index + EVENT_OFFSET, event)
      array.put_short(struct_index + REVENT_OFFSET, RJava.cast_to_short(0))
    end
    
    attr_accessor :interrupted
    alias_method :attr_interrupted, :interrupted
    undef_method :interrupted
    alias_method :attr_interrupted=, :interrupted=
    undef_method :interrupted=
    
    typesig { [] }
    def interrupt
      interrupt(@outgoing_interrupt_fd)
    end
    
    typesig { [] }
    def interrupted_index
      return @interrupted_index
    end
    
    typesig { [] }
    def interrupted
      return @interrupted
    end
    
    typesig { [] }
    def clear_interrupted
      @interrupted = false
    end
    
    JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_init, [:pointer, :long], :int32
    typesig { [] }
    def init
      JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_init, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_register, [:pointer, :long, :int32, :int32, :int32], :void
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def register(wfd, fd, mask)
      JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_register, JNI.env, self.jni_id, wfd.to_int, fd.to_int, mask.to_int)
    end
    
    JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_registerMultiple, [:pointer, :long, :int32, :int64, :int32], :void
    typesig { [::Java::Int, ::Java::Long, ::Java::Int] }
    def register_multiple(wfd, address_, len)
      JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_registerMultiple, JNI.env, self.jni_id, wfd.to_int, address_.to_int, len.to_int)
    end
    
    JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_poll0, [:pointer, :long, :int64, :int32, :int64, :int32], :int32
    typesig { [::Java::Long, ::Java::Int, ::Java::Long, ::Java::Int] }
    def poll0(poll_address, numfds, timeout, wfd)
      JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_poll0, JNI.env, self.jni_id, poll_address.to_int, numfds.to_int, timeout.to_int, wfd.to_int)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_interrupt, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def interrupt(fd)
        JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_interrupt, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_DevPollArrayWrapper_fdLimit, [:pointer, :long], :int32
      typesig { [] }
      def fd_limit
        JNI.call_native_method(:Java_sun_nio_ch_DevPollArrayWrapper_fdLimit, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__dev_poll_array_wrapper, :initialize
  end
  
end

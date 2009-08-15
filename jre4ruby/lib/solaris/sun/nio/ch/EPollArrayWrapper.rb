require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EPollArrayWrapperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :HashSet
    }
  end
  
  # Manipulates a native array of epoll_event structs on Linux:
  # 
  # typedef union epoll_data {
  # void *ptr;
  # int fd;
  # __uint32_t u32;
  # __uint64_t u64;
  # } epoll_data_t;
  # 
  # struct epoll_event {
  # __uint32_t events;
  # epoll_data_t data;
  # };
  # 
  # The system call to wait for I/O events is epoll_wait(2). It populates an
  # array of epoll_event structures that are passed to the call. The data
  # member of the epoll_event structure contains the same data as was set
  # when the file descriptor was registered to epoll via epoll_ctl(2). In
  # this implementation we set data.fd to be the file descriptor that we
  # register. That way, we have the file descriptor available when we
  # process the events.
  # 
  # All file descriptors registered with epoll have the POLLHUP and POLLERR
  # events enabled even when registered with an event set of 0. To ensure
  # that epoll_wait doesn't poll an idle file descriptor when the underlying
  # connection is closed or reset then its registration is deleted from
  # epoll (it will be re-added again if the event set is changed)
  class EPollArrayWrapper 
    include_class_members EPollArrayWrapperImports
    
    class_module.module_eval {
      # EPOLL_EVENTS
      const_set_lazy(:EPOLLIN) { 0x1 }
      const_attr_reader  :EPOLLIN
      
      # opcodes
      const_set_lazy(:EPOLL_CTL_ADD) { 1 }
      const_attr_reader  :EPOLL_CTL_ADD
      
      const_set_lazy(:EPOLL_CTL_DEL) { 2 }
      const_attr_reader  :EPOLL_CTL_DEL
      
      const_set_lazy(:EPOLL_CTL_MOD) { 3 }
      const_attr_reader  :EPOLL_CTL_MOD
      
      # Miscellaneous constants
      const_set_lazy(:SIZE_EPOLLEVENT) { 12 }
      const_attr_reader  :SIZE_EPOLLEVENT
      
      const_set_lazy(:EVENT_OFFSET) { 0 }
      const_attr_reader  :EVENT_OFFSET
      
      const_set_lazy(:DATA_OFFSET) { 4 }
      const_attr_reader  :DATA_OFFSET
      
      const_set_lazy(:FD_OFFSET) { 4 }
      const_attr_reader  :FD_OFFSET
      
      const_set_lazy(:NUM_EPOLLEVENTS) { Math.min(fd_limit, 8192) }
      const_attr_reader  :NUM_EPOLLEVENTS
    }
    
    # Base address of the native pollArray
    attr_accessor :poll_array_address
    alias_method :attr_poll_array_address, :poll_array_address
    undef_method :poll_array_address
    alias_method :attr_poll_array_address=, :poll_array_address=
    undef_method :poll_array_address=
    
    # Set of "idle" file descriptors
    attr_accessor :idle_set
    alias_method :attr_idle_set, :idle_set
    undef_method :idle_set
    alias_method :attr_idle_set=, :idle_set=
    undef_method :idle_set=
    
    typesig { [] }
    def initialize
      @poll_array_address = 0
      @idle_set = nil
      @update_list = LinkedList.new
      @poll_array = nil
      @epfd = 0
      @outgoing_interrupt_fd = 0
      @incoming_interrupt_fd = 0
      @interrupted_index = 0
      @updated = 0
      @interrupted = false
      # creates the epoll file descriptor
      @epfd = epoll_create
      # the epoll_event array passed to epoll_wait
      allocation_size = NUM_EPOLLEVENTS * SIZE_EPOLLEVENT
      @poll_array = AllocatedNativeObject.new(allocation_size, true)
      @poll_array_address = @poll_array.address
      i = 0
      while i < NUM_EPOLLEVENTS
        put_event_ops(i, 0)
        put_data(i, 0)
        i += 1
      end
      # create idle set
      @idle_set = HashSet.new
    end
    
    class_module.module_eval {
      # Used to update file description registrations
      const_set_lazy(:Updator) { Class.new do
        include_class_members EPollArrayWrapper
        
        attr_accessor :opcode
        alias_method :attr_opcode, :opcode
        undef_method :opcode
        alias_method :attr_opcode=, :opcode=
        undef_method :opcode=
        
        attr_accessor :fd
        alias_method :attr_fd, :fd
        undef_method :fd
        alias_method :attr_fd=, :fd=
        undef_method :fd=
        
        attr_accessor :events
        alias_method :attr_events, :events
        undef_method :events
        alias_method :attr_events=, :events=
        undef_method :events=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(opcode, fd, events)
          @opcode = 0
          @fd = 0
          @events = 0
          @opcode = opcode
          @fd = fd
          @events = events
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
    
    # The epoll_event array for results from epoll_wait
    attr_accessor :poll_array
    alias_method :attr_poll_array, :poll_array
    undef_method :poll_array
    alias_method :attr_poll_array=, :poll_array=
    undef_method :poll_array=
    
    # The fd of the epoll driver
    attr_accessor :epfd
    alias_method :attr_epfd, :epfd
    undef_method :epfd
    alias_method :attr_epfd=, :epfd=
    undef_method :epfd=
    
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
      epoll_ctl(@epfd, EPOLL_CTL_ADD, fd0, EPOLLIN)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_event_ops(i, event)
      offset = SIZE_EPOLLEVENT * i + EVENT_OFFSET
      @poll_array.put_int(offset, event)
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_data(i, value)
      offset = SIZE_EPOLLEVENT * i + DATA_OFFSET
      @poll_array.put_long(offset, value)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_descriptor(i, fd)
      offset = SIZE_EPOLLEVENT * i + FD_OFFSET
      @poll_array.put_int(offset, fd)
    end
    
    typesig { [::Java::Int] }
    def get_event_ops(i)
      offset = SIZE_EPOLLEVENT * i + EVENT_OFFSET
      return @poll_array.get_int(offset)
    end
    
    typesig { [::Java::Int] }
    def get_descriptor(i)
      offset = SIZE_EPOLLEVENT * i + FD_OFFSET
      return @poll_array.get_int(offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Update the events for a given file descriptor.
    def set_interest(fd, mask)
      synchronized((@update_list)) do
        # if the interest events are 0 then add to idle set, and delete
        # from epoll if registered (or pending)
        if ((mask).equal?(0))
          if (@idle_set.add(fd))
            @update_list.add(Updator.new(EPOLL_CTL_DEL, fd, 0))
          end
          return
        end
        # if file descriptor is idle then add to epoll
        if (!@idle_set.is_empty && @idle_set.remove(fd))
          @update_list.add(Updator.new(EPOLL_CTL_ADD, fd, mask))
          return
        end
        # if the previous pending operation is to add this file descriptor
        # to epoll then update its event set
        if (@update_list.size > 0)
          last = @update_list.get_last
          if ((last.attr_fd).equal?(fd) && (last.attr_opcode).equal?(EPOLL_CTL_ADD))
            last.attr_events = mask
            return
          end
        end
        # update existing registration
        @update_list.add(Updator.new(EPOLL_CTL_MOD, fd, mask))
      end
    end
    
    typesig { [::Java::Int] }
    # Add a new file descriptor to epoll
    def add(fd)
      synchronized((@update_list)) do
        @update_list.add(Updator.new(EPOLL_CTL_ADD, fd, 0))
      end
    end
    
    typesig { [::Java::Int] }
    # Remove a file descriptor from epoll
    def release(fd)
      synchronized((@update_list)) do
        # if file descriptor is idle then remove from idle set, otherwise
        # delete from epoll
        if (!@idle_set.remove(fd))
          @update_list.add(Updator.new(EPOLL_CTL_DEL, fd, 0))
        end
      end
    end
    
    typesig { [] }
    # Close epoll file descriptor and free poll array
    def close_epoll_fd
      FileDispatcher.close_int_fd(@epfd)
      @poll_array.free
    end
    
    typesig { [::Java::Long] }
    def poll(timeout)
      update_registrations
      @updated = epoll_wait(@poll_array_address, NUM_EPOLLEVENTS, timeout, @epfd)
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
    # Update the pending registrations.
    def update_registrations
      synchronized((@update_list)) do
        u = nil
        while (!((u = @update_list.poll)).nil?)
          epoll_ctl(@epfd, u.attr_opcode, u.attr_fd, u.attr_events)
        end
      end
    end
    
    # interrupt support
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
    
    class_module.module_eval {
      when_class_loaded do
        init
      end
    }
    
    JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_epollCreate, [:pointer, :long], :int32
    typesig { [] }
    def epoll_create
      JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_epollCreate, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_epollCtl, [:pointer, :long, :int32, :int32, :int32, :int32], :void
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def epoll_ctl(epfd, opcode, fd, events)
      JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_epollCtl, JNI.env, self.jni_id, epfd.to_int, opcode.to_int, fd.to_int, events.to_int)
    end
    
    JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_epollWait, [:pointer, :long, :int64, :int32, :int64, :int32], :int32
    typesig { [::Java::Long, ::Java::Int, ::Java::Long, ::Java::Int] }
    def epoll_wait(poll_address, numfds, timeout, epfd)
      JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_epollWait, JNI.env, self.jni_id, poll_address.to_int, numfds.to_int, timeout.to_int, epfd.to_int)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_fdLimit, [:pointer, :long], :int32
      typesig { [] }
      def fd_limit
        JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_fdLimit, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_interrupt, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def interrupt(fd)
        JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_interrupt, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.native_method :Java_sun_nio_ch_EPollArrayWrapper_init, [:pointer, :long], :void
      typesig { [] }
      def init
        JNI.__send__(:Java_sun_nio_ch_EPollArrayWrapper_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__epoll_array_wrapper, :initialize
  end
  
end

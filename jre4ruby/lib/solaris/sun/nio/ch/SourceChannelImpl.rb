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
  module SourceChannelImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  class SourceChannelImpl < SourceChannelImplImports.const_get :Pipe::SourceChannel
    include_class_members SourceChannelImplImports
    overload_protected {
      include SelChImpl
    }
    
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
    }
    
    # The file descriptor associated with this channel
    attr_accessor :fd
    alias_method :attr_fd, :fd
    undef_method :fd
    alias_method :attr_fd=, :fd=
    undef_method :fd=
    
    # fd value needed for dev/poll. This value will remain valid
    # even after the value in the file descriptor object has been set to -1
    attr_accessor :fd_val
    alias_method :attr_fd_val, :fd_val
    undef_method :fd_val
    alias_method :attr_fd_val=, :fd_val=
    undef_method :fd_val=
    
    # ID of native thread doing read, for signalling
    attr_accessor :thread
    alias_method :attr_thread, :thread
    undef_method :thread
    alias_method :attr_thread=, :thread=
    undef_method :thread=
    
    # Lock held by current reading thread
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # Lock held by any thread that modifies the state fields declared below
    # DO NOT invoke a blocking I/O operation while holding this lock!
    attr_accessor :state_lock
    alias_method :attr_state_lock, :state_lock
    undef_method :state_lock
    alias_method :attr_state_lock=, :state_lock=
    undef_method :state_lock=
    
    class_module.module_eval {
      # -- The following fields are protected by stateLock
      # Channel state
      const_set_lazy(:ST_UNINITIALIZED) { -1 }
      const_attr_reader  :ST_UNINITIALIZED
      
      const_set_lazy(:ST_INUSE) { 0 }
      const_attr_reader  :ST_INUSE
      
      const_set_lazy(:ST_KILLED) { 1 }
      const_attr_reader  :ST_KILLED
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [] }
    # -- End of fields protected by stateLock
    def get_fd
      return @fd
    end
    
    typesig { [] }
    def get_fdval
      return @fd_val
    end
    
    typesig { [SelectorProvider, FileDescriptor] }
    def initialize(sp, fd)
      @fd = nil
      @fd_val = 0
      @thread = 0
      @lock = nil
      @state_lock = nil
      @state = 0
      super(sp)
      @thread = 0
      @lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @fd = fd
      @fd_val = IOUtil.fd_val(fd)
      @state = ST_INUSE
    end
    
    typesig { [] }
    def impl_close_selectable_channel
      synchronized((@state_lock)) do
        self.attr_nd.pre_close(@fd)
        th = @thread
        if (!(th).equal?(0))
          NativeThread.signal(th)
        end
        if (!is_registered)
          kill
        end
      end
    end
    
    typesig { [] }
    def kill
      synchronized((@state_lock)) do
        if ((@state).equal?(ST_KILLED))
          return
        end
        if ((@state).equal?(ST_UNINITIALIZED))
          @state = ST_KILLED
          return
        end
        raise AssertError if not (!is_open && !is_registered)
        self.attr_nd.close(@fd)
        @state = ST_KILLED
      end
    end
    
    typesig { [::Java::Boolean] }
    def impl_configure_blocking(block)
      IOUtil.configure_blocking(@fd, block)
    end
    
    typesig { [::Java::Int, ::Java::Int, SelectionKeyImpl] }
    def translate_ready_ops(ops, initial_ops, sk)
      int_ops = sk.nio_interest_ops # Do this just once, it synchronizes
      old_ops = sk.nio_ready_ops
      new_ops = initial_ops
      if (!((ops & PollArrayWrapper::POLLNVAL)).equal?(0))
        raise JavaError.new("POLLNVAL detected")
      end
      if (!((ops & (PollArrayWrapper::POLLERR | PollArrayWrapper::POLLHUP))).equal?(0))
        new_ops = int_ops
        sk.nio_ready_ops(new_ops)
        return !((new_ops & ~old_ops)).equal?(0)
      end
      if ((!((ops & PollArrayWrapper::POLLIN)).equal?(0)) && (!((int_ops & SelectionKey::OP_READ)).equal?(0)))
        new_ops |= SelectionKey::OP_READ
      end
      sk.nio_ready_ops(new_ops)
      return !((new_ops & ~old_ops)).equal?(0)
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    def translate_and_update_ready_ops(ops, sk)
      return translate_ready_ops(ops, sk.nio_ready_ops, sk)
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    def translate_and_set_ready_ops(ops, sk)
      return translate_ready_ops(ops, 0, sk)
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    def translate_and_set_interest_ops(ops, sk)
      if ((ops).equal?(SelectionKey::OP_READ))
        ops = PollArrayWrapper::POLLIN
      end
      sk.attr_selector.put_event_ops(sk, ops)
    end
    
    typesig { [] }
    def ensure_open
      if (!is_open)
        raise ClosedChannelException.new
      end
    end
    
    typesig { [ByteBuffer] }
    def read(dst)
      ensure_open
      synchronized((@lock)) do
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @thread = NativeThread.current
          begin
            n = IOUtil.read(@fd, dst, -1, self.attr_nd, @lock)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    def read(dsts, offset, length)
      if ((offset < 0) || (length < 0) || (offset > dsts.attr_length - length))
        raise IndexOutOfBoundsException.new
      end
      return read(Util.subsequence(dsts, offset, length))
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def read(dsts)
      if ((dsts).nil?)
        raise NullPointerException.new
      end
      ensure_open
      synchronized((@lock)) do
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @thread = NativeThread.current
          begin
            n = IOUtil.read(@fd, dsts, self.attr_nd)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
        self.attr_nd = FileDispatcher.new
      end
    }
    
    private
    alias_method :initialize__source_channel_impl, :initialize
  end
  
end

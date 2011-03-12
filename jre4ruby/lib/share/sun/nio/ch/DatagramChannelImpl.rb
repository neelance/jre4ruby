require "rjava"

# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DatagramChannelImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include ::Java::Net
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Lang::Ref, :SoftReference
    }
  end
  
  # An implementation of DatagramChannels.
  class DatagramChannelImpl < DatagramChannelImplImports.const_get :DatagramChannel
    include_class_members DatagramChannelImplImports
    overload_protected {
      include SelChImpl
    }
    
    class_module.module_eval {
      # Used to make native read and write calls
      
      def nd
        defined?(@@nd) ? @@nd : @@nd= DatagramDispatcher.new
      end
      alias_method :attr_nd, :nd
      
      def nd=(value)
        @@nd = value
      end
      alias_method :attr_nd=, :nd=
    }
    
    # Our file descriptor
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
    
    # IDs of native threads doing reads and writes, for signalling
    attr_accessor :reader_thread
    alias_method :attr_reader_thread, :reader_thread
    undef_method :reader_thread
    alias_method :attr_reader_thread=, :reader_thread=
    undef_method :reader_thread=
    
    attr_accessor :writer_thread
    alias_method :attr_writer_thread, :writer_thread
    undef_method :writer_thread
    alias_method :attr_writer_thread=, :writer_thread=
    undef_method :writer_thread=
    
    # Cached InetAddress and port for unconnected DatagramChannels
    # used by receive0
    attr_accessor :cached_sender_inet_address
    alias_method :attr_cached_sender_inet_address, :cached_sender_inet_address
    undef_method :cached_sender_inet_address
    alias_method :attr_cached_sender_inet_address=, :cached_sender_inet_address=
    undef_method :cached_sender_inet_address=
    
    attr_accessor :cached_sender_port
    alias_method :attr_cached_sender_port, :cached_sender_port
    undef_method :cached_sender_port
    alias_method :attr_cached_sender_port=, :cached_sender_port=
    undef_method :cached_sender_port=
    
    # Lock held by current reading or connecting thread
    attr_accessor :read_lock
    alias_method :attr_read_lock, :read_lock
    undef_method :read_lock
    alias_method :attr_read_lock=, :read_lock=
    undef_method :read_lock=
    
    # Lock held by current writing or connecting thread
    attr_accessor :write_lock
    alias_method :attr_write_lock, :write_lock
    undef_method :write_lock
    alias_method :attr_write_lock=, :write_lock=
    undef_method :write_lock=
    
    # Lock held by any thread that modifies the state fields declared below
    # DO NOT invoke a blocking I/O operation while holding this lock!
    attr_accessor :state_lock
    alias_method :attr_state_lock, :state_lock
    undef_method :state_lock
    alias_method :attr_state_lock=, :state_lock=
    undef_method :state_lock=
    
    class_module.module_eval {
      # -- The following fields are protected by stateLock
      # State (does not necessarily increase monotonically)
      const_set_lazy(:ST_UNINITIALIZED) { -1 }
      const_attr_reader  :ST_UNINITIALIZED
      
      
      def st_unconnected
        defined?(@@st_unconnected) ? @@st_unconnected : @@st_unconnected= 0
      end
      alias_method :attr_st_unconnected, :st_unconnected
      
      def st_unconnected=(value)
        @@st_unconnected = value
      end
      alias_method :attr_st_unconnected=, :st_unconnected=
      
      
      def st_connected
        defined?(@@st_connected) ? @@st_connected : @@st_connected= 1
      end
      alias_method :attr_st_connected, :st_connected
      
      def st_connected=(value)
        @@st_connected = value
      end
      alias_method :attr_st_connected=, :st_connected=
      
      const_set_lazy(:ST_KILLED) { 2 }
      const_attr_reader  :ST_KILLED
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # Binding
    attr_accessor :local_address
    alias_method :attr_local_address, :local_address
    undef_method :local_address
    alias_method :attr_local_address=, :local_address=
    undef_method :local_address=
    
    attr_accessor :remote_address
    alias_method :attr_remote_address, :remote_address
    undef_method :remote_address
    alias_method :attr_remote_address=, :remote_address=
    undef_method :remote_address=
    
    # Options
    attr_accessor :options
    alias_method :attr_options, :options
    undef_method :options
    alias_method :attr_options=, :options=
    undef_method :options=
    
    # Our socket adaptor, if any
    attr_accessor :socket
    alias_method :attr_socket, :socket
    undef_method :socket
    alias_method :attr_socket=, :socket=
    undef_method :socket=
    
    typesig { [SelectorProvider] }
    # -- End of fields protected by stateLock
    def initialize(sp)
      @fd = nil
      @fd_val = 0
      @reader_thread = 0
      @writer_thread = 0
      @cached_sender_inet_address = nil
      @cached_sender_port = 0
      @read_lock = nil
      @write_lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @remote_address = nil
      @options = nil
      @socket = nil
      @sender = nil
      super(sp)
      @fd = nil
      @reader_thread = 0
      @writer_thread = 0
      @cached_sender_inet_address = nil
      @cached_sender_port = 0
      @read_lock = Object.new
      @write_lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @remote_address = nil
      @options = nil
      @socket = nil
      @fd = Net.socket(false)
      @fd_val = IOUtil.fd_val(@fd)
      @state = self.attr_st_unconnected
    end
    
    typesig { [SelectorProvider, FileDescriptor] }
    def initialize(sp, fd)
      @fd = nil
      @fd_val = 0
      @reader_thread = 0
      @writer_thread = 0
      @cached_sender_inet_address = nil
      @cached_sender_port = 0
      @read_lock = nil
      @write_lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @remote_address = nil
      @options = nil
      @socket = nil
      @sender = nil
      super(sp)
      @fd = nil
      @reader_thread = 0
      @writer_thread = 0
      @cached_sender_inet_address = nil
      @cached_sender_port = 0
      @read_lock = Object.new
      @write_lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @remote_address = nil
      @options = nil
      @socket = nil
      @fd = fd
      @fd_val = IOUtil.fd_val(fd)
      @state = self.attr_st_unconnected
    end
    
    typesig { [] }
    def socket
      synchronized((@state_lock)) do
        if ((@socket).nil?)
          @socket = DatagramSocketAdaptor.create(self)
        end
        return @socket
      end
    end
    
    typesig { [] }
    def ensure_open
      if (!is_open)
        raise ClosedChannelException.new
      end
    end
    
    attr_accessor :sender
    alias_method :attr_sender, :sender
    undef_method :sender
    alias_method :attr_sender=, :sender=
    undef_method :sender=
    
    typesig { [ByteBuffer] }
    # Set by receive0 (## ugh)
    def receive(dst)
      if (dst.is_read_only)
        raise IllegalArgumentException.new("Read-only buffer")
      end
      if ((dst).nil?)
        raise NullPointerException.new
      end
      synchronized((@read_lock)) do
        ensure_open
        # If socket is not bound then behave as if nothing received
        if (!is_bound)
          # ## NotYetBoundException ??
          return nil
        end
        n = 0
        bb = nil
        begin
          begin_
          if (!is_open)
            return nil
          end
          security = System.get_security_manager
          @reader_thread = NativeThread.current
          if (is_connected || ((security).nil?))
            begin
              n = receive(@fd, dst)
            end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
            if ((n).equal?(IOStatus::UNAVAILABLE))
              return nil
            end
          else
            bb = Util.get_temporary_direct_buffer(dst.remaining)
            loop do
              begin
                n = receive(@fd, bb)
              end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              if ((n).equal?(IOStatus::UNAVAILABLE))
                return nil
              end
              isa = @sender
              begin
                security.check_accept(isa.get_address.get_host_address, isa.get_port)
              rescue SecurityException => se
                # Ignore packet
                bb.clear
                n = 0
                next
              end
              bb.flip
              dst.put(bb)
              break
            end
          end
          return @sender
        ensure
          if (!(bb).nil?)
            Util.release_temporary_direct_buffer(bb)
          end
          @reader_thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [FileDescriptor, ByteBuffer] }
    def receive(fd, dst)
      pos = dst.position
      lim = dst.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      if (dst.is_a?(DirectBuffer) && rem > 0)
        return receive_into_native_buffer(fd, dst, rem, pos)
      end
      # Substitute a native buffer. If the supplied buffer is empty
      # we must instead use a nonempty buffer, otherwise the call
      # will not block waiting for a datagram on some platforms.
      new_size = Math.max(rem, 1)
      bb = nil
      begin
        bb = Util.get_temporary_direct_buffer(new_size)
        n = receive_into_native_buffer(fd, bb, new_size, 0)
        bb.flip
        if (n > 0 && rem > 0)
          dst.put(bb)
        end
        return n
      ensure
        Util.release_temporary_direct_buffer(bb)
      end
    end
    
    typesig { [FileDescriptor, ByteBuffer, ::Java::Int, ::Java::Int] }
    def receive_into_native_buffer(fd, bb, rem, pos)
      n = receive0(fd, (bb).address + pos, rem, is_connected)
      if (n > 0)
        bb.position(pos + n)
      end
      return n
    end
    
    typesig { [ByteBuffer, SocketAddress] }
    def send(src, target)
      if ((src).nil?)
        raise NullPointerException.new
      end
      synchronized((@write_lock)) do
        ensure_open
        isa = target
        ia = isa.get_address
        if ((ia).nil?)
          raise IOException.new("Target address not resolved")
        end
        synchronized((@state_lock)) do
          if (!is_connected)
            if ((target).nil?)
              raise NullPointerException.new
            end
            sm = System.get_security_manager
            if (!(sm).nil?)
              if (ia.is_multicast_address)
                sm.check_multicast(isa.get_address)
              else
                sm.check_connect(isa.get_address.get_host_address, isa.get_port)
              end
            end
          else
            # Connected case; Check address then write
            if (!(target == @remote_address))
              raise IllegalArgumentException.new("Connected address not equal to target address")
            end
            return write(src)
          end
        end
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @writer_thread = NativeThread.current
          begin
            n = send(@fd, src, target)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @writer_thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [FileDescriptor, ByteBuffer, SocketAddress] }
    def send(fd, src, target)
      if (src.is_a?(DirectBuffer))
        return send_from_native_buffer(fd, src, target)
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
        n = send_from_native_buffer(fd, bb, target)
        if (n > 0)
          # now update src
          src.position(pos + n)
        end
        return n
      ensure
        Util.release_temporary_direct_buffer(bb)
      end
    end
    
    typesig { [FileDescriptor, ByteBuffer, SocketAddress] }
    def send_from_native_buffer(fd, bb, target)
      pos = bb.position
      lim = bb.limit
      raise AssertError if not ((pos <= lim))
      rem = (pos <= lim ? lim - pos : 0)
      written = send0(fd, (bb).address + pos, rem, target)
      if (written > 0)
        bb.position(pos + written)
      end
      return written
    end
    
    typesig { [ByteBuffer] }
    def read(buf)
      if ((buf).nil?)
        raise NullPointerException.new
      end
      synchronized((@read_lock)) do
        synchronized((@state_lock)) do
          ensure_open
          if (!is_connected)
            raise NotYetConnectedException.new
          end
        end
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @reader_thread = NativeThread.current
          begin
            n = IOUtil.read(@fd, buf, -1, self.attr_nd, @read_lock)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @reader_thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def read0(bufs)
      if ((bufs).nil?)
        raise NullPointerException.new
      end
      synchronized((@read_lock)) do
        synchronized((@state_lock)) do
          ensure_open
          if (!is_connected)
            raise NotYetConnectedException.new
          end
        end
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @reader_thread = NativeThread.current
          begin
            n = IOUtil.read(@fd, bufs, self.attr_nd)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @reader_thread = 0
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
      # ## Fix IOUtil.write so that we can avoid this array copy
      return read0(Util.subsequence(dsts, offset, length))
    end
    
    typesig { [ByteBuffer] }
    def write(buf)
      if ((buf).nil?)
        raise NullPointerException.new
      end
      synchronized((@write_lock)) do
        synchronized((@state_lock)) do
          ensure_open
          if (!is_connected)
            raise NotYetConnectedException.new
          end
        end
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @writer_thread = NativeThread.current
          begin
            n = IOUtil.write(@fd, buf, -1, self.attr_nd, @write_lock)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @writer_thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          raise AssertError if not (IOStatus.check(n))
        end
      end
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def write0(bufs)
      if ((bufs).nil?)
        raise NullPointerException.new
      end
      synchronized((@write_lock)) do
        synchronized((@state_lock)) do
          ensure_open
          if (!is_connected)
            raise NotYetConnectedException.new
          end
        end
        n = 0
        begin
          begin_
          if (!is_open)
            return 0
          end
          @writer_thread = NativeThread.current
          begin
            n = IOUtil.write(@fd, bufs, self.attr_nd)
          end while (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
          return IOStatus.normalize(n)
        ensure
          @writer_thread = 0
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
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
    
    typesig { [::Java::Boolean] }
    def impl_configure_blocking(block)
      IOUtil.configure_blocking(@fd, block)
    end
    
    typesig { [] }
    def options
      synchronized((@state_lock)) do
        if ((@options).nil?)
          d = Class.new(SocketOptsImpl::Dispatcher.class == Class ? SocketOptsImpl::Dispatcher : Object) do
            local_class_in DatagramChannelImpl
            include_class_members DatagramChannelImpl
            include SocketOptsImpl::Dispatcher if SocketOptsImpl::Dispatcher.class == Module
            
            typesig { [::Java::Int] }
            define_method :get_int do |opt|
              return Net.get_int_option(self.attr_fd, opt)
            end
            
            typesig { [::Java::Int, ::Java::Int] }
            define_method :set_int do |opt, arg|
              Net.set_int_option(self.attr_fd, opt, arg)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @options = SocketOptsImpl::IP.new(d)
        end
        return @options
      end
    end
    
    typesig { [] }
    def is_bound
      return !(Net.local_port_number(@fd)).equal?(0)
    end
    
    typesig { [] }
    def local_address
      synchronized((@state_lock)) do
        if (is_connected && ((@local_address).nil?))
          # Socket was not bound before connecting,
          # so ask what the address turned out to be
          @local_address = Net.local_address(@fd)
        end
        sm = System.get_security_manager
        if (!(sm).nil?)
          isa = @local_address
          sm.check_connect(isa.get_address.get_host_address, -1)
        end
        return @local_address
      end
    end
    
    typesig { [] }
    def remote_address
      synchronized((@state_lock)) do
        return @remote_address
      end
    end
    
    typesig { [SocketAddress] }
    def bind(local)
      synchronized((@read_lock)) do
        synchronized((@write_lock)) do
          synchronized((@state_lock)) do
            ensure_open
            if (is_bound)
              raise AlreadyBoundException.new
            end
            isa = Net.check_address(local)
            sm = System.get_security_manager
            if (!(sm).nil?)
              sm.check_listen(isa.get_port)
            end
            Net.bind(@fd, isa.get_address, isa.get_port)
            @local_address = Net.local_address(@fd)
          end
        end
      end
    end
    
    typesig { [] }
    def is_connected
      synchronized((@state_lock)) do
        return ((@state).equal?(self.attr_st_connected))
      end
    end
    
    typesig { [] }
    def ensure_open_and_unconnected
      # package-private
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if (!(@state).equal?(self.attr_st_unconnected))
          raise IllegalStateException.new("Connect already invoked")
        end
      end
    end
    
    typesig { [SocketAddress] }
    def connect(sa)
      traffic_class = 0
      local_port = 0
      synchronized((@read_lock)) do
        synchronized((@write_lock)) do
          synchronized((@state_lock)) do
            ensure_open_and_unconnected
            isa = Net.check_address(sa)
            sm = System.get_security_manager
            if (!(sm).nil?)
              sm.check_connect(isa.get_address.get_host_address, isa.get_port)
            end
            n = Net.connect(@fd, isa.get_address, isa.get_port, traffic_class)
            if (n <= 0)
              raise JavaError.new
            end # Can't happen
            # Connection succeeded; disallow further invocation
            @state = self.attr_st_connected
            @remote_address = sa
            @sender = isa
            @cached_sender_inet_address = isa.get_address
            @cached_sender_port = isa.get_port
          end
        end
      end
      return self
    end
    
    typesig { [] }
    def disconnect
      synchronized((@read_lock)) do
        synchronized((@write_lock)) do
          synchronized((@state_lock)) do
            if (!is_connected || !is_open)
              return self
            end
            isa = @remote_address
            sm = System.get_security_manager
            if (!(sm).nil?)
              sm.check_connect(isa.get_address.get_host_address, isa.get_port)
            end
            disconnect0(@fd)
            @remote_address = nil
            @state = self.attr_st_unconnected
          end
        end
      end
      return self
    end
    
    typesig { [] }
    def impl_close_selectable_channel
      synchronized((@state_lock)) do
        self.attr_nd.pre_close(@fd)
        th = 0
        if (!((th = @reader_thread)).equal?(0))
          NativeThread.signal(th)
        end
        if (!((th = @writer_thread)).equal?(0))
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
    
    typesig { [] }
    def finalize
      # fd is null if constructor threw exception
      if (!(@fd).nil?)
        close
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, SelectionKeyImpl] }
    # Translates native poll revent set into a ready operation set
    def translate_ready_ops(ops, initial_ops, sk)
      int_ops = sk.nio_interest_ops # Do this just once, it synchronizes
      old_ops = sk.nio_ready_ops
      new_ops = initial_ops
      if (!((ops & PollArrayWrapper::POLLNVAL)).equal?(0))
        # This should only happen if this channel is pre-closed while a
        # selection operation is in progress
        # ## Throw an error if this channel has not been pre-closed
        return false
      end
      if (!((ops & (PollArrayWrapper::POLLERR | PollArrayWrapper::POLLHUP))).equal?(0))
        new_ops = int_ops
        sk.nio_ready_ops(new_ops)
        return !((new_ops & ~old_ops)).equal?(0)
      end
      if ((!((ops & PollArrayWrapper::POLLIN)).equal?(0)) && (!((int_ops & SelectionKey::OP_READ)).equal?(0)))
        new_ops |= SelectionKey::OP_READ
      end
      if ((!((ops & PollArrayWrapper::POLLOUT)).equal?(0)) && (!((int_ops & SelectionKey::OP_WRITE)).equal?(0)))
        new_ops |= SelectionKey::OP_WRITE
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
    # Translates an interest operation set into a native poll event set
    def translate_and_set_interest_ops(ops, sk)
      new_ops = 0
      if (!((ops & SelectionKey::OP_READ)).equal?(0))
        new_ops |= PollArrayWrapper::POLLIN
      end
      if (!((ops & SelectionKey::OP_WRITE)).equal?(0))
        new_ops |= PollArrayWrapper::POLLOUT
      end
      if (!((ops & SelectionKey::OP_CONNECT)).equal?(0))
        new_ops |= PollArrayWrapper::POLLIN
      end
      sk.attr_selector.put_event_ops(sk, new_ops)
    end
    
    typesig { [] }
    def get_fd
      return @fd
    end
    
    typesig { [] }
    def get_fdval
      return @fd_val
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_nio_ch_DatagramChannelImpl_initIDs, [:pointer, :long], :void
      typesig { [] }
      # -- Native methods --
      def init_ids
        JNI.call_native_method(:Java_sun_nio_ch_DatagramChannelImpl_initIDs, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_DatagramChannelImpl_disconnect0, [:pointer, :long, :long], :void
      typesig { [FileDescriptor] }
      def disconnect0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_DatagramChannelImpl_disconnect0, JNI.env, self.jni_id, fd.jni_id)
      end
    }
    
    JNI.load_native_method :Java_sun_nio_ch_DatagramChannelImpl_receive0, [:pointer, :long, :long, :int64, :int32, :int8], :int32
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int, ::Java::Boolean] }
    def receive0(fd, address_, len, connected)
      JNI.call_native_method(:Java_sun_nio_ch_DatagramChannelImpl_receive0, JNI.env, self.jni_id, fd.jni_id, address_.to_int, len.to_int, connected ? 1 : 0)
    end
    
    JNI.load_native_method :Java_sun_nio_ch_DatagramChannelImpl_send0, [:pointer, :long, :long, :int64, :int32, :long], :int32
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int, SocketAddress] }
    def send0(fd, address_, len, sa)
      JNI.call_native_method(:Java_sun_nio_ch_DatagramChannelImpl_send0, JNI.env, self.jni_id, fd.jni_id, address_.to_int, len.to_int, sa.jni_id)
    end
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
        init_ids
      end
    }
    
    private
    alias_method :initialize__datagram_channel_impl, :initialize
  end
  
end

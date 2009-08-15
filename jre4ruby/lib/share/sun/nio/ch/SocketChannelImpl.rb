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
  module SocketChannelImplImports
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
  
  # An implementation of SocketChannels
  class SocketChannelImpl < SocketChannelImplImports.const_get :SocketChannel
    include_class_members SocketChannelImplImports
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
    
    # Our file descriptor object
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
      # State, increases monotonically
      const_set_lazy(:ST_UNINITIALIZED) { -1 }
      const_attr_reader  :ST_UNINITIALIZED
      
      const_set_lazy(:ST_UNCONNECTED) { 0 }
      const_attr_reader  :ST_UNCONNECTED
      
      const_set_lazy(:ST_PENDING) { 1 }
      const_attr_reader  :ST_PENDING
      
      const_set_lazy(:ST_CONNECTED) { 2 }
      const_attr_reader  :ST_CONNECTED
      
      const_set_lazy(:ST_KILLPENDING) { 3 }
      const_attr_reader  :ST_KILLPENDING
      
      const_set_lazy(:ST_KILLED) { 4 }
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
    
    # Input/Output open
    attr_accessor :is_input_open
    alias_method :attr_is_input_open, :is_input_open
    undef_method :is_input_open
    alias_method :attr_is_input_open=, :is_input_open=
    undef_method :is_input_open=
    
    attr_accessor :is_output_open
    alias_method :attr_is_output_open, :is_output_open
    undef_method :is_output_open
    alias_method :attr_is_output_open=, :is_output_open=
    undef_method :is_output_open=
    
    attr_accessor :ready_to_connect
    alias_method :attr_ready_to_connect, :ready_to_connect
    undef_method :ready_to_connect
    alias_method :attr_ready_to_connect=, :ready_to_connect=
    undef_method :ready_to_connect=
    
    # Options, created on demand
    attr_accessor :options
    alias_method :attr_options, :options
    undef_method :options
    alias_method :attr_options=, :options=
    undef_method :options=
    
    # Socket adaptor, created on demand
    attr_accessor :socket
    alias_method :attr_socket, :socket
    undef_method :socket
    alias_method :attr_socket=, :socket=
    undef_method :socket=
    
    typesig { [SelectorProvider] }
    # -- End of fields protected by stateLock
    # Constructor for normal connecting sockets
    def initialize(sp)
      @fd = nil
      @fd_val = 0
      @reader_thread = 0
      @writer_thread = 0
      @read_lock = nil
      @write_lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @remote_address = nil
      @is_input_open = false
      @is_output_open = false
      @ready_to_connect = false
      @options = nil
      @socket = nil
      super(sp)
      @reader_thread = 0
      @writer_thread = 0
      @read_lock = Object.new
      @write_lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @remote_address = nil
      @is_input_open = true
      @is_output_open = true
      @ready_to_connect = false
      @options = nil
      @socket = nil
      @fd = Net.socket(true)
      @fd_val = IOUtil.fd_val(@fd)
      @state = ST_UNCONNECTED
    end
    
    typesig { [SelectorProvider, FileDescriptor, InetSocketAddress] }
    # Constructor for sockets obtained from server sockets
    def initialize(sp, fd, remote)
      @fd = nil
      @fd_val = 0
      @reader_thread = 0
      @writer_thread = 0
      @read_lock = nil
      @write_lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @remote_address = nil
      @is_input_open = false
      @is_output_open = false
      @ready_to_connect = false
      @options = nil
      @socket = nil
      super(sp)
      @reader_thread = 0
      @writer_thread = 0
      @read_lock = Object.new
      @write_lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @remote_address = nil
      @is_input_open = true
      @is_output_open = true
      @ready_to_connect = false
      @options = nil
      @socket = nil
      @fd = fd
      @fd_val = IOUtil.fd_val(fd)
      @state = ST_CONNECTED
      @remote_address = remote
    end
    
    typesig { [] }
    def socket
      synchronized((@state_lock)) do
        if ((@socket).nil?)
          @socket = SocketAdaptor.create(self)
        end
        return @socket
      end
    end
    
    typesig { [] }
    def ensure_read_open
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if (!is_connected)
          raise NotYetConnectedException.new
        end
        if (!@is_input_open)
          return false
        else
          return true
        end
      end
    end
    
    typesig { [] }
    def ensure_write_open
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if (!@is_output_open)
          raise ClosedChannelException.new
        end
        if (!is_connected)
          raise NotYetConnectedException.new
        end
      end
    end
    
    typesig { [] }
    def reader_cleanup
      synchronized((@state_lock)) do
        @reader_thread = 0
        if ((@state).equal?(ST_KILLPENDING))
          kill
        end
      end
    end
    
    typesig { [] }
    def writer_cleanup
      synchronized((@state_lock)) do
        @writer_thread = 0
        if ((@state).equal?(ST_KILLPENDING))
          kill
        end
      end
    end
    
    typesig { [ByteBuffer] }
    def read(buf)
      if ((buf).nil?)
        raise NullPointerException.new
      end
      synchronized((@read_lock)) do
        if (!ensure_read_open)
          return -1
        end
        n = 0
        begin
          # Set up the interruption machinery; see
          # AbstractInterruptibleChannel for details
          begin_
          synchronized((@state_lock)) do
            if (!is_open)
              # Either the current thread is already interrupted, so
              # begin() closed the channel, or another thread closed the
              # channel since we checked it a few bytecodes ago.  In
              # either case the value returned here is irrelevant since
              # the invocation of end() in the finally block will throw
              # an appropriate exception.
              return 0
            end
            # Save this thread so that it can be signalled on those
            # platforms that require it
            @reader_thread = NativeThread.current
          end
          # Between the previous test of isOpen() and the return of the
          # IOUtil.read invocation below, this channel might be closed
          # or this thread might be interrupted.  We rely upon the
          # implicit synchronization point in the kernel read() call to
          # make sure that the right thing happens.  In either case the
          # implCloseSelectableChannel method is ultimately invoked in
          # some other thread, so there are three possibilities:
          # 
          # - implCloseSelectableChannel() invokes nd.preClose()
          # before this thread invokes read(), in which case the
          # read returns immediately with either EOF or an error,
          # the latter of which will cause an IOException to be
          # thrown.
          # 
          # - implCloseSelectableChannel() invokes nd.preClose() after
          # this thread is blocked in read().  On some operating
          # systems (e.g., Solaris and Windows) this causes the read
          # to return immediately with either EOF or an error
          # indication.
          # 
          # - implCloseSelectableChannel() invokes nd.preClose() after
          # this thread is blocked in read() but the operating
          # system (e.g., Linux) doesn't support preemptive close,
          # so implCloseSelectableChannel() proceeds to signal this
          # thread, thereby causing the read to return immediately
          # with IOStatus.INTERRUPTED.
          # 
          # In all three cases the invocation of end() in the finally
          # clause will notice that the channel has been closed and
          # throw an appropriate exception (AsynchronousCloseException
          # or ClosedByInterruptException) if necessary.
          # 
          # *There is A fourth possibility. implCloseSelectableChannel()
          # invokes nd.preClose(), signals reader/writer thred and quickly
          # moves on to nd.close() in kill(), which does a real close.
          # Then a third thread accepts a new connection, opens file or
          # whatever that causes the released "fd" to be recycled. All
          # above happens just between our last isOpen() check and the
          # next kernel read reached, with the recycled "fd". The solution
          # is to postpone the real kill() if there is a reader or/and
          # writer thread(s) over there "waiting", leave the cleanup/kill
          # to the reader or writer thread. (the preClose() still happens
          # so the connection gets cut off as usual).
          # 
          # For socket channels there is the additional wrinkle that
          # asynchronous shutdown works much like asynchronous close,
          # except that the channel is shutdown rather than completely
          # closed.  This is analogous to the first two cases above,
          # except that the shutdown operation plays the role of
          # nd.preClose().
          loop do
            n = IOUtil.read(@fd, buf, -1, self.attr_nd, @read_lock)
            if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              # The system call was interrupted but the channel
              # is still open, so retry
              next
            end
            return IOStatus.normalize(n)
          end
        ensure
          reader_cleanup # Clear reader thread
          # The end method, which is defined in our superclass
          # AbstractInterruptibleChannel, resets the interruption
          # machinery.  If its argument is true then it returns
          # normally; otherwise it checks the interrupt and open state
          # of this channel and throws an appropriate exception if
          # necessary.
          # 
          # So, if we actually managed to do any I/O in the above try
          # block then we pass true to the end method.  We also pass
          # true if the channel was in non-blocking mode when the I/O
          # operation was initiated but no data could be transferred;
          # this prevents spurious exceptions from being thrown in the
          # rare event that a channel is closed or a thread is
          # interrupted at the exact moment that a non-blocking I/O
          # request is made.
          end_(n > 0 || ((n).equal?(IOStatus::UNAVAILABLE)))
          # Extra case for socket channels: Asynchronous shutdown
          synchronized((@state_lock)) do
            if ((n <= 0) && (!@is_input_open))
              return IOStatus::EOF
            end
          end
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
        if (!ensure_read_open)
          return -1
        end
        n = 0
        begin
          begin_
          synchronized((@state_lock)) do
            if (!is_open)
              return 0
            end
            @reader_thread = NativeThread.current
          end
          loop do
            n = IOUtil.read(@fd, bufs, self.attr_nd)
            if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              next
            end
            return IOStatus.normalize(n)
          end
        ensure
          reader_cleanup
          end_(n > 0 || ((n).equal?(IOStatus::UNAVAILABLE)))
          synchronized((@state_lock)) do
            if ((n <= 0) && (!@is_input_open))
              return IOStatus::EOF
            end
          end
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
        ensure_write_open
        n = 0
        begin
          begin_
          synchronized((@state_lock)) do
            if (!is_open)
              return 0
            end
            @writer_thread = NativeThread.current
          end
          loop do
            n = IOUtil.write(@fd, buf, -1, self.attr_nd, @write_lock)
            if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              next
            end
            return IOStatus.normalize(n)
          end
        ensure
          writer_cleanup
          end_(n > 0 || ((n).equal?(IOStatus::UNAVAILABLE)))
          synchronized((@state_lock)) do
            if ((n <= 0) && (!@is_output_open))
              raise AsynchronousCloseException.new
            end
          end
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
        ensure_write_open
        n = 0
        begin
          begin_
          synchronized((@state_lock)) do
            if (!is_open)
              return 0
            end
            @writer_thread = NativeThread.current
          end
          loop do
            n = IOUtil.write(@fd, bufs, self.attr_nd)
            if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              next
            end
            return IOStatus.normalize(n)
          end
        ensure
          writer_cleanup
          end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
          synchronized((@state_lock)) do
            if ((n <= 0) && (!@is_output_open))
              raise AsynchronousCloseException.new
            end
          end
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
            extend LocalClass
            include_class_members SocketChannelImpl
            include SocketOptsImpl::Dispatcher if SocketOptsImpl::Dispatcher.class == Module
            
            typesig { [::Java::Int] }
            define_method :get_int do |opt|
              return Net.get_int_option(self.attr_fd, opt)
            end
            
            typesig { [::Java::Int, ::Java::Int] }
            define_method :set_int do |opt, arg|
              Net.set_int_option(self.attr_fd, opt, arg)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @options = SocketOptsImpl::IP::TCP.new(d)
        end
        return @options
      end
    end
    
    typesig { [] }
    def is_bound
      synchronized((@state_lock)) do
        if ((@state).equal?(ST_CONNECTED))
          return true
        end
        return !(@local_address).nil?
      end
    end
    
    typesig { [] }
    def local_address
      synchronized((@state_lock)) do
        if ((@state).equal?(ST_CONNECTED) && ((@local_address).nil? || (@local_address).get_address.is_any_local_address))
          # Socket was not bound before connecting or
          # Socket was bound with an "anyLocalAddress"
          @local_address = Net.local_address(@fd)
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
            ensure_open_and_unconnected
            if (!(@local_address).nil?)
              raise AlreadyBoundException.new
            end
            isa = Net.check_address(local)
            Net.bind(@fd, isa.get_address, isa.get_port)
            @local_address = Net.local_address(@fd)
          end
        end
      end
    end
    
    typesig { [] }
    def is_connected
      synchronized((@state_lock)) do
        return ((@state).equal?(ST_CONNECTED))
      end
    end
    
    typesig { [] }
    def is_connection_pending
      synchronized((@state_lock)) do
        return ((@state).equal?(ST_PENDING))
      end
    end
    
    typesig { [] }
    def ensure_open_and_unconnected
      # package-private
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if ((@state).equal?(ST_CONNECTED))
          raise AlreadyConnectedException.new
        end
        if ((@state).equal?(ST_PENDING))
          raise ConnectionPendingException.new
        end
      end
    end
    
    typesig { [SocketAddress] }
    def connect(sa)
      traffic_class = 0 # ## Pick up from options
      local_port = 0
      synchronized((@read_lock)) do
        synchronized((@write_lock)) do
          ensure_open_and_unconnected
          isa = Net.check_address(sa)
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_connect(isa.get_address.get_host_address, isa.get_port)
          end
          synchronized((blocking_lock)) do
            n = 0
            begin
              begin
                begin_
                synchronized((@state_lock)) do
                  if (!is_open)
                    return false
                  end
                  @reader_thread = NativeThread.current
                end
                loop do
                  ia = isa.get_address
                  if (ia.is_any_local_address)
                    ia = InetAddress.get_local_host
                  end
                  n = Net.connect(@fd, ia, isa.get_port, traffic_class)
                  if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
                    next
                  end
                  break
                end
              ensure
                reader_cleanup
                end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
                raise AssertError if not (IOStatus.check(n))
              end
            rescue IOException => x
              # If an exception was thrown, close the channel after
              # invoking end() so as to avoid bogus
              # AsynchronousCloseExceptions
              close
              raise x
            end
            synchronized((@state_lock)) do
              @remote_address = isa
              if (n > 0)
                # Connection succeeded; disallow further
                # invocation
                @state = ST_CONNECTED
                return true
              end
              # If nonblocking and no exception then connection
              # pending; disallow another invocation
              if (!is_blocking)
                @state = ST_PENDING
              else
                raise AssertError if not (false)
              end
            end
          end
          return false
        end
      end
    end
    
    typesig { [] }
    def finish_connect
      synchronized((@read_lock)) do
        synchronized((@write_lock)) do
          synchronized((@state_lock)) do
            if (!is_open)
              raise ClosedChannelException.new
            end
            if ((@state).equal?(ST_CONNECTED))
              return true
            end
            if (!(@state).equal?(ST_PENDING))
              raise NoConnectionPendingException.new
            end
          end
          n = 0
          begin
            begin
              begin_
              synchronized((blocking_lock)) do
                synchronized((@state_lock)) do
                  if (!is_open)
                    return false
                  end
                  @reader_thread = NativeThread.current
                end
                if (!is_blocking)
                  loop do
                    n = check_connect(@fd, false, @ready_to_connect)
                    if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
                      next
                    end
                    break
                  end
                else
                  loop do
                    n = check_connect(@fd, true, @ready_to_connect)
                    if ((n).equal?(0))
                      # Loop in case of
                      # spurious notifications
                      next
                    end
                    if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
                      next
                    end
                    break
                  end
                end
              end
            ensure
              synchronized((@state_lock)) do
                @reader_thread = 0
                if ((@state).equal?(ST_KILLPENDING))
                  kill
                  # poll()/getsockopt() does not report
                  # error (throws exception, with n = 0)
                  # on Linux platform after dup2 and
                  # signal-wakeup. Force n to 0 so the
                  # end() can throw appropriate exception
                  n = 0
                end
              end
              end_((n > 0) || ((n).equal?(IOStatus::UNAVAILABLE)))
              raise AssertError if not (IOStatus.check(n))
            end
          rescue IOException => x
            # If an exception was thrown, close the channel after
            # invoking end() so as to avoid bogus
            # AsynchronousCloseExceptions
            close
            raise x
          end
          if (n > 0)
            synchronized((@state_lock)) do
              @state = ST_CONNECTED
            end
            return true
          end
          return false
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SHUT_RD) { 0 }
      const_attr_reader  :SHUT_RD
      
      const_set_lazy(:SHUT_WR) { 1 }
      const_attr_reader  :SHUT_WR
      
      const_set_lazy(:SHUT_RDWR) { 2 }
      const_attr_reader  :SHUT_RDWR
    }
    
    typesig { [] }
    def shutdown_input
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        @is_input_open = false
        shutdown(@fd, SHUT_RD)
        if (!(@reader_thread).equal?(0))
          NativeThread.signal(@reader_thread)
        end
      end
    end
    
    typesig { [] }
    def shutdown_output
      synchronized((@state_lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        @is_output_open = false
        shutdown(@fd, SHUT_WR)
        if (!(@writer_thread).equal?(0))
          NativeThread.signal(@writer_thread)
        end
      end
    end
    
    typesig { [] }
    def is_input_open
      synchronized((@state_lock)) do
        return @is_input_open
      end
    end
    
    typesig { [] }
    def is_output_open
      synchronized((@state_lock)) do
        return @is_output_open
      end
    end
    
    typesig { [] }
    # AbstractInterruptibleChannel synchronizes invocations of this method
    # using AbstractInterruptibleChannel.closeLock, and also ensures that this
    # method is only ever invoked once.  Before we get to this method, isOpen
    # (which is volatile) will have been set to false.
    def impl_close_selectable_channel
      synchronized((@state_lock)) do
        @is_input_open = false
        @is_output_open = false
        # Close the underlying file descriptor and dup it to a known fd
        # that's already closed.  This prevents other operations on this
        # channel from using the old fd, which might be recycled in the
        # meantime and allocated to an entirely different channel.
        self.attr_nd.pre_close(@fd)
        # Signal native threads, if needed.  If a target thread is not
        # currently blocked in an I/O operation then no harm is done since
        # the signal handler doesn't actually do anything.
        if (!(@reader_thread).equal?(0))
          NativeThread.signal(@reader_thread)
        end
        if (!(@writer_thread).equal?(0))
          NativeThread.signal(@writer_thread)
        end
        # If this channel is not registered then it's safe to close the fd
        # immediately since we know at this point that no thread is
        # blocked in an I/O operation upon the channel and, since the
        # channel is marked closed, no thread will start another such
        # operation.  If this channel is registered then we don't close
        # the fd since it might be in use by a selector.  In that case
        # closing this channel caused its keys to be cancelled, so the
        # last selector to deregister a key for this channel will invoke
        # kill() to close the fd.
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
        # Postpone the kill if there is a waiting reader
        # or writer thread. See the comments in read() for
        # more detailed explanation.
        if ((@reader_thread).equal?(0) && (@writer_thread).equal?(0))
          self.attr_nd.close(@fd)
          @state = ST_KILLED
        else
          @state = ST_KILLPENDING
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, SelectionKeyImpl] }
    # Translates native poll revent ops into a ready operation ops
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
        # No need to poll again in checkConnect,
        # the error will be detected there
        @ready_to_connect = true
        return !((new_ops & ~old_ops)).equal?(0)
      end
      if ((!((ops & PollArrayWrapper::POLLIN)).equal?(0)) && (!((int_ops & SelectionKey::OP_READ)).equal?(0)) && ((@state).equal?(ST_CONNECTED)))
        new_ops |= SelectionKey::OP_READ
      end
      if ((!((ops & PollArrayWrapper::POLLCONN)).equal?(0)) && (!((int_ops & SelectionKey::OP_CONNECT)).equal?(0)) && (((@state).equal?(ST_UNCONNECTED)) || ((@state).equal?(ST_PENDING))))
        new_ops |= SelectionKey::OP_CONNECT
        @ready_to_connect = true
      end
      if ((!((ops & PollArrayWrapper::POLLOUT)).equal?(0)) && (!((int_ops & SelectionKey::OP_WRITE)).equal?(0)) && ((@state).equal?(ST_CONNECTED)))
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
        new_ops |= PollArrayWrapper::POLLCONN
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
    
    typesig { [] }
    def to_s
      sb = StringBuffer.new
      sb.append(self.get_class.get_superclass.get_name)
      sb.append(Character.new(?[.ord))
      if (!is_open)
        sb.append("closed")
      else
        synchronized((@state_lock)) do
          case (@state)
          when ST_UNCONNECTED
            sb.append("unconnected")
          when ST_PENDING
            sb.append("connection-pending")
          when ST_CONNECTED
            sb.append("connected")
            if (!@is_input_open)
              sb.append(" ishut")
            end
            if (!@is_output_open)
              sb.append(" oshut")
            end
          end
          if (!(local_address).nil?)
            sb.append(" local=")
            sb.append(local_address.to_s)
          end
          if (!(remote_address).nil?)
            sb.append(" remote=")
            sb.append(remote_address.to_s)
          end
        end
      end
      sb.append(Character.new(?].ord))
      return sb.to_s
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_SocketChannelImpl_checkConnect, [:pointer, :long, :long, :int8, :int8], :int32
      typesig { [FileDescriptor, ::Java::Boolean, ::Java::Boolean] }
      # -- Native methods --
      def check_connect(fd, block, ready)
        JNI.__send__(:Java_sun_nio_ch_SocketChannelImpl_checkConnect, JNI.env, self.jni_id, fd.jni_id, block ? 1 : 0, ready ? 1 : 0)
      end
      
      JNI.native_method :Java_sun_nio_ch_SocketChannelImpl_shutdown, [:pointer, :long, :long, :int32], :void
      typesig { [FileDescriptor, ::Java::Int] }
      def shutdown(fd, how)
        JNI.__send__(:Java_sun_nio_ch_SocketChannelImpl_shutdown, JNI.env, self.jni_id, fd.jni_id, how.to_int)
      end
      
      when_class_loaded do
        Util.load
        self.attr_nd = SocketDispatcher.new
      end
    }
    
    private
    alias_method :initialize__socket_channel_impl, :initialize
  end
  
end

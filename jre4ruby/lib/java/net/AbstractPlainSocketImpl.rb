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
module Java::Net
  module AbstractPlainSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Sun::Net, :ConnectionResetException
    }
  end
  
  # Default Socket Implementation. This implementation does
  # not implement any security checks.
  # Note this class should <b>NOT</b> be public.
  # 
  # @author  Steven B. Byrne
  class AbstractPlainSocketImpl < AbstractPlainSocketImplImports.const_get :SocketImpl
    include_class_members AbstractPlainSocketImplImports
    
    # instance variable for SO_TIMEOUT
    attr_accessor :timeout
    alias_method :attr_timeout, :timeout
    undef_method :timeout
    alias_method :attr_timeout=, :timeout=
    undef_method :timeout=
    
    # timeout in millisec
    # traffic class
    attr_accessor :traffic_class
    alias_method :attr_traffic_class, :traffic_class
    undef_method :traffic_class
    alias_method :attr_traffic_class=, :traffic_class=
    undef_method :traffic_class=
    
    attr_accessor :shut_rd
    alias_method :attr_shut_rd, :shut_rd
    undef_method :shut_rd
    alias_method :attr_shut_rd=, :shut_rd=
    undef_method :shut_rd=
    
    attr_accessor :shut_wr
    alias_method :attr_shut_wr, :shut_wr
    undef_method :shut_wr
    alias_method :attr_shut_wr=, :shut_wr=
    undef_method :shut_wr=
    
    attr_accessor :socket_input_stream
    alias_method :attr_socket_input_stream, :socket_input_stream
    undef_method :socket_input_stream
    alias_method :attr_socket_input_stream=, :socket_input_stream=
    undef_method :socket_input_stream=
    
    # number of threads using the FileDescriptor
    attr_accessor :fd_use_count
    alias_method :attr_fd_use_count, :fd_use_count
    undef_method :fd_use_count
    alias_method :attr_fd_use_count=, :fd_use_count=
    undef_method :fd_use_count=
    
    # lock when increment/decrementing fdUseCount
    attr_accessor :fd_lock
    alias_method :attr_fd_lock, :fd_lock
    undef_method :fd_lock
    alias_method :attr_fd_lock=, :fd_lock=
    undef_method :fd_lock=
    
    # indicates a close is pending on the file descriptor
    attr_accessor :close_pending
    alias_method :attr_close_pending, :close_pending
    undef_method :close_pending
    alias_method :attr_close_pending=, :close_pending=
    undef_method :close_pending=
    
    # indicates connection reset state
    attr_accessor :connection_not_reset
    alias_method :attr_connection_not_reset, :connection_not_reset
    undef_method :connection_not_reset
    alias_method :attr_connection_not_reset=, :connection_not_reset=
    undef_method :connection_not_reset=
    
    attr_accessor :connection_reset_pending
    alias_method :attr_connection_reset_pending, :connection_reset_pending
    undef_method :connection_reset_pending
    alias_method :attr_connection_reset_pending=, :connection_reset_pending=
    undef_method :connection_reset_pending=
    
    attr_accessor :connection_reset
    alias_method :attr_connection_reset, :connection_reset
    undef_method :connection_reset
    alias_method :attr_connection_reset=, :connection_reset=
    undef_method :connection_reset=
    
    attr_accessor :reset_state
    alias_method :attr_reset_state, :reset_state
    undef_method :reset_state
    alias_method :attr_reset_state=, :reset_state=
    undef_method :reset_state=
    
    attr_accessor :reset_lock
    alias_method :attr_reset_lock, :reset_lock
    undef_method :reset_lock
    alias_method :attr_reset_lock=, :reset_lock=
    undef_method :reset_lock=
    
    class_module.module_eval {
      # Load net library into runtime.
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
      end
    }
    
    typesig { [::Java::Boolean] }
    # Creates a socket with a boolean that specifies whether this
    # is a stream socket (true) or an unconnected UDP socket (false).
    def create(stream)
      synchronized(self) do
        self.attr_fd = FileDescriptor.new
        socket_create(stream)
        if (!(self.attr_socket).nil?)
          self.attr_socket.set_created
        end
        if (!(self.attr_server_socket).nil?)
          self.attr_server_socket.set_created
        end
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a socket and connects it to the specified port on
    # the specified host.
    # @param host the specified host
    # @param port the specified port
    def connect(host, port)
      pending = nil
      begin
        address = InetAddress.get_by_name(host)
        self.attr_port = port
        self.attr_address = address
        begin
          connect_to_address(address, port, @timeout)
          return
        rescue IOException => e
          pending = e
        end
      rescue UnknownHostException => e
        pending = e
      end
      # everything failed
      close
      raise pending
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Creates a socket and connects it to the specified address on
    # the specified port.
    # @param address the address
    # @param port the specified port
    def connect(address, port)
      self.attr_port = port
      self.attr_address = address
      begin
        connect_to_address(address, port, @timeout)
        return
      rescue IOException => e
        # everything failed
        close
        raise e
      end
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    # Creates a socket and connects it to the specified address on
    # the specified port.
    # @param address the address
    # @param timeout the timeout value in milliseconds, or zero for no timeout.
    # @throws IOException if connection fails
    # @throws  IllegalArgumentException if address is null or is a
    # SocketAddress subclass not supported by this socket
    # @since 1.4
    def connect(address, timeout)
      if ((address).nil? || !(address.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("unsupported address type")
      end
      addr = address
      if (addr.is_unresolved)
        raise UnknownHostException.new(addr.get_host_name)
      end
      self.attr_port = addr.get_port
      self.attr_address = addr.get_address
      begin
        connect_to_address(self.attr_address, self.attr_port, timeout)
        return
      rescue IOException => e
        # everything failed
        close
        raise e
      end
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def connect_to_address(address, port, timeout)
      if (address.is_any_local_address)
        do_connect(InetAddress.get_local_host, port, timeout)
      else
        do_connect(address, port, timeout)
      end
    end
    
    typesig { [::Java::Int, Object] }
    def set_option(opt, val)
      if (is_closed_or_pending)
        raise SocketException.new("Socket Closed")
      end
      on = true
      case (opt)
      # check type safety b4 going native.  These should never
      # fail, since only java.Socket* has access to
      # PlainSocketImpl.setOption().
      when SO_LINGER
        if ((val).nil? || (!(val.is_a?(JavaInteger)) && !(val.is_a?(Boolean))))
          raise SocketException.new("Bad parameter for option")
        end
        if (val.is_a?(Boolean))
          # true only if disabling - enabling should be Integer
          on = false
        end
      when SO_TIMEOUT
        if ((val).nil? || (!(val.is_a?(JavaInteger))))
          raise SocketException.new("Bad parameter for SO_TIMEOUT")
        end
        tmp = (val).int_value
        if (tmp < 0)
          raise IllegalArgumentException.new("timeout < 0")
        end
        @timeout = tmp
      when IP_TOS
        if ((val).nil? || !(val.is_a?(JavaInteger)))
          raise SocketException.new("bad argument for IP_TOS")
        end
        @traffic_class = (val).int_value
      when SO_BINDADDR
        raise SocketException.new("Cannot re-bind socket")
      when TCP_NODELAY
        if ((val).nil? || !(val.is_a?(Boolean)))
          raise SocketException.new("bad parameter for TCP_NODELAY")
        end
        on = (val).boolean_value
      when SO_SNDBUF, SO_RCVBUF
        if ((val).nil? || !(val.is_a?(JavaInteger)) || !((val).int_value > 0))
          raise SocketException.new("bad parameter for SO_SNDBUF " + "or SO_RCVBUF")
        end
      when SO_KEEPALIVE
        if ((val).nil? || !(val.is_a?(Boolean)))
          raise SocketException.new("bad parameter for SO_KEEPALIVE")
        end
        on = (val).boolean_value
      when SO_OOBINLINE
        if ((val).nil? || !(val.is_a?(Boolean)))
          raise SocketException.new("bad parameter for SO_OOBINLINE")
        end
        on = (val).boolean_value
      when SO_REUSEADDR
        if ((val).nil? || !(val.is_a?(Boolean)))
          raise SocketException.new("bad parameter for SO_REUSEADDR")
        end
        on = (val).boolean_value
      else
        raise SocketException.new("unrecognized TCP option: " + (opt).to_s)
      end
      socket_set_option(opt, on, val)
    end
    
    typesig { [::Java::Int] }
    def get_option(opt)
      if (is_closed_or_pending)
        raise SocketException.new("Socket Closed")
      end
      if ((opt).equal?(SO_TIMEOUT))
        return @timeout
      end
      ret = 0
      # The native socketGetOption() knows about 3 options.
      # The 32 bit value it returns will be interpreted according
      # to what we're asking.  A return of -1 means it understands
      # the option but its turned off.  It will raise a SocketException
      # if "opt" isn't one it understands.
      case (opt)
      # should never get here
      when TCP_NODELAY
        ret = socket_get_option(opt, nil)
        return Boolean.value_of(!(ret).equal?(-1))
      when SO_OOBINLINE
        ret = socket_get_option(opt, nil)
        return Boolean.value_of(!(ret).equal?(-1))
      when SO_LINGER
        ret = socket_get_option(opt, nil)
        return ((ret).equal?(-1)) ? Boolean::FALSE : (ret)
      when SO_REUSEADDR
        ret = socket_get_option(opt, nil)
        return Boolean.value_of(!(ret).equal?(-1))
      when SO_BINDADDR
        in_ = InetAddressContainer.new
        ret = socket_get_option(opt, in_)
        return in_.attr_addr
      when SO_SNDBUF, SO_RCVBUF
        ret = socket_get_option(opt, nil)
        return ret
      when IP_TOS
        ret = socket_get_option(opt, nil)
        if ((ret).equal?(-1))
          # ipv6 tos
          return @traffic_class
        else
          return ret
        end
      when SO_KEEPALIVE
        ret = socket_get_option(opt, nil)
        return Boolean.value_of(!(ret).equal?(-1))
      else
        return nil
      end
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    # The workhorse of the connection operation.  Tries several times to
    # establish a connection to the given <host, port>.  If unsuccessful,
    # throws an IOException indicating what went wrong.
    def do_connect(address, port, timeout)
      synchronized(self) do
        begin
          fd = acquire_fd
          begin
            socket_connect(address, port, timeout)
            # If we have a ref. to the Socket, then sets the flags
            # created, bound & connected to true.
            # This is normally done in Socket.connect() but some
            # subclasses of Socket may call impl.connect() directly!
            if (!(self.attr_socket).nil?)
              self.attr_socket.set_bound
              self.attr_socket.set_connected
            end
          ensure
            release_fd
          end
        rescue IOException => e
          close
          raise e
        end
      end
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Binds the socket to the specified address of the specified local port.
    # @param address the address
    # @param port the port
    def bind(address, lport)
      synchronized(self) do
        socket_bind(address, lport)
        if (!(self.attr_socket).nil?)
          self.attr_socket.set_bound
        end
        if (!(self.attr_server_socket).nil?)
          self.attr_server_socket.set_bound
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Listens, for a specified amount of time, for connections.
    # @param count the amount of time to listen for connections
    def listen(count)
      synchronized(self) do
        socket_listen(count)
      end
    end
    
    typesig { [SocketImpl] }
    # Accepts connections.
    # @param s the connection
    def accept(s)
      fd = acquire_fd
      begin
        socket_accept(s)
      ensure
        release_fd
      end
    end
    
    typesig { [] }
    # Gets an InputStream for this socket.
    def get_input_stream
      synchronized(self) do
        if (is_closed_or_pending)
          raise IOException.new("Socket Closed")
        end
        if (@shut_rd)
          raise IOException.new("Socket input is shutdown")
        end
        if ((@socket_input_stream).nil?)
          @socket_input_stream = SocketInputStream.new(self)
        end
        return @socket_input_stream
      end
    end
    
    typesig { [SocketInputStream] }
    def set_input_stream(in_)
      @socket_input_stream = in_
    end
    
    typesig { [] }
    # Gets an OutputStream for this socket.
    def get_output_stream
      synchronized(self) do
        if (is_closed_or_pending)
          raise IOException.new("Socket Closed")
        end
        if (@shut_wr)
          raise IOException.new("Socket output is shutdown")
        end
        return SocketOutputStream.new(self)
      end
    end
    
    typesig { [FileDescriptor] }
    def set_file_descriptor(fd)
      self.attr_fd = fd
    end
    
    typesig { [InetAddress] }
    def set_address(address)
      self.attr_address = address
    end
    
    typesig { [::Java::Int] }
    def set_port(port)
      self.attr_port = port
    end
    
    typesig { [::Java::Int] }
    def set_local_port(localport)
      self.attr_localport = localport
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read without blocking.
    def available
      synchronized(self) do
        if (is_closed_or_pending)
          raise IOException.new("Stream closed.")
        end
        # If connection has been reset then return 0 to indicate
        # there are no buffered bytes.
        if (is_connection_reset)
          return 0
        end
        # If no bytes available and we were previously notified
        # of a connection reset then we move to the reset state.
        # 
        # If are notified of a connection reset then check
        # again if there are bytes buffered on the socket.
        n = 0
        begin
          n = socket_available
          if ((n).equal?(0) && is_connection_reset_pending)
            set_connection_reset
          end
        rescue ConnectionResetException => exc1
          set_connection_reset_pending
          begin
            n = socket_available
            if ((n).equal?(0))
              set_connection_reset
            end
          rescue ConnectionResetException => exc2
          end
        end
        return n
      end
    end
    
    typesig { [] }
    # Closes the socket.
    def close
      synchronized((@fd_lock)) do
        if (!(self.attr_fd).nil?)
          if ((@fd_use_count).equal?(0))
            if (@close_pending)
              return
            end
            @close_pending = true
            # We close the FileDescriptor in two-steps - first the
            # "pre-close" which closes the socket but doesn't
            # release the underlying file descriptor. This operation
            # may be lengthy due to untransmitted data and a long
            # linger interval. Once the pre-close is done we do the
            # actual socket to release the fd.
            begin
              socket_pre_close
            ensure
              socket_close
            end
            self.attr_fd = nil
            return
          else
            # If a thread has acquired the fd and a close
            # isn't pending then use a deferred close.
            # Also decrement fdUseCount to signal the last
            # thread that releases the fd to close it.
            if (!@close_pending)
              @close_pending = true
              @fd_use_count -= 1
              socket_pre_close
            end
          end
        end
      end
    end
    
    typesig { [] }
    def reset
      if (!(self.attr_fd).nil?)
        socket_close
      end
      self.attr_fd = nil
      super
    end
    
    typesig { [] }
    # Shutdown read-half of the socket connection;
    def shutdown_input
      if (!(self.attr_fd).nil?)
        socket_shutdown(SHUT_RD)
        if (!(@socket_input_stream).nil?)
          @socket_input_stream.set_eof(true)
        end
        @shut_rd = true
      end
    end
    
    typesig { [] }
    # Shutdown write-half of the socket connection;
    def shutdown_output
      if (!(self.attr_fd).nil?)
        socket_shutdown(SHUT_WR)
        @shut_wr = true
      end
    end
    
    typesig { [] }
    def supports_urgent_data
      return true
    end
    
    typesig { [::Java::Int] }
    def send_urgent_data(data)
      if ((self.attr_fd).nil?)
        raise IOException.new("Socket Closed")
      end
      socket_send_urgent_data(data)
    end
    
    typesig { [] }
    # Cleans up if the user forgets to close it.
    def finalize
      close
    end
    
    typesig { [] }
    # "Acquires" and returns the FileDescriptor for this impl
    # 
    # A corresponding releaseFD is required to "release" the
    # FileDescriptor.
    def acquire_fd
      synchronized((@fd_lock)) do
        @fd_use_count += 1
        return self.attr_fd
      end
    end
    
    typesig { [] }
    # "Release" the FileDescriptor for this impl.
    # 
    # If the use count goes to -1 then the socket is closed.
    def release_fd
      synchronized((@fd_lock)) do
        @fd_use_count -= 1
        if ((@fd_use_count).equal?(-1))
          if (!(self.attr_fd).nil?)
            begin
              socket_close
            rescue IOException => e
            ensure
              self.attr_fd = nil
            end
          end
        end
      end
    end
    
    typesig { [] }
    def is_connection_reset
      synchronized((@reset_lock)) do
        return ((@reset_state).equal?(@connection_reset))
      end
    end
    
    typesig { [] }
    def is_connection_reset_pending
      synchronized((@reset_lock)) do
        return ((@reset_state).equal?(@connection_reset_pending))
      end
    end
    
    typesig { [] }
    def set_connection_reset
      synchronized((@reset_lock)) do
        @reset_state = @connection_reset
      end
    end
    
    typesig { [] }
    def set_connection_reset_pending
      synchronized((@reset_lock)) do
        if ((@reset_state).equal?(@connection_not_reset))
          @reset_state = @connection_reset_pending
        end
      end
    end
    
    typesig { [] }
    # Return true if already closed or close is pending
    def is_closed_or_pending
      # Lock on fdLock to ensure that we wait if a
      # close is in progress.
      synchronized((@fd_lock)) do
        if (@close_pending || ((self.attr_fd).nil?))
          return true
        else
          return false
        end
      end
    end
    
    typesig { [] }
    # Return the current value of SO_TIMEOUT
    def get_timeout
      return @timeout
    end
    
    typesig { [] }
    # "Pre-close" a socket by dup'ing the file descriptor - this enables
    # the socket to be closed without releasing the file descriptor.
    def socket_pre_close
      socket_close0(true)
    end
    
    typesig { [] }
    # Close the socket (and release the file descriptor).
    def socket_close
      socket_close0(false)
    end
    
    typesig { [::Java::Boolean] }
    def socket_create(is_server)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int, ::Java::Int] }
    def socket_connect(address, port, timeout)
      raise NotImplementedError
    end
    
    typesig { [InetAddress, ::Java::Int] }
    def socket_bind(address, port)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def socket_listen(count)
      raise NotImplementedError
    end
    
    typesig { [SocketImpl] }
    def socket_accept(s)
      raise NotImplementedError
    end
    
    typesig { [] }
    def socket_available
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    def socket_close0(use_deferred_close)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def socket_shutdown(howto)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Boolean, Object] }
    def socket_set_option(cmd, on, value)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Object] }
    def socket_get_option(opt, ia_container_obj)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, Object, FileDescriptor] }
    def socket_get_option1(opt, ia_container_obj, fd)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def socket_send_urgent_data(data)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      const_set_lazy(:SHUT_RD) { 0 }
      const_attr_reader  :SHUT_RD
      
      const_set_lazy(:SHUT_WR) { 1 }
      const_attr_reader  :SHUT_WR
    }
    
    typesig { [] }
    def initialize
      @timeout = 0
      @traffic_class = 0
      @shut_rd = false
      @shut_wr = false
      @socket_input_stream = nil
      @fd_use_count = 0
      @fd_lock = nil
      @close_pending = false
      @connection_not_reset = 0
      @connection_reset_pending = 0
      @connection_reset = 0
      @reset_state = 0
      @reset_lock = nil
      super()
      @shut_rd = false
      @shut_wr = false
      @socket_input_stream = nil
      @fd_use_count = 0
      @fd_lock = Object.new
      @close_pending = false
      @connection_not_reset = 0
      @connection_reset_pending = 1
      @connection_reset = 2
      @reset_lock = Object.new
    end
    
    private
    alias_method :initialize__abstract_plain_socket_impl, :initialize
  end
  
  class InetAddressContainer 
    include_class_members AbstractPlainSocketImplImports
    
    attr_accessor :addr
    alias_method :attr_addr, :addr
    undef_method :addr
    alias_method :attr_addr=, :addr=
    undef_method :addr=
    
    typesig { [] }
    def initialize
      @addr = nil
    end
    
    private
    alias_method :initialize__inet_address_container, :initialize
  end
  
end

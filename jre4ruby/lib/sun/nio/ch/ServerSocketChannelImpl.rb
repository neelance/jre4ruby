require "rjava"

# 
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
  module ServerSocketChannelImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include ::Java::Lang::Reflect
      include ::Java::Net
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
    }
  end
  
  # 
  # An implementation of ServerSocketChannels
  class ServerSocketChannelImpl < ServerSocketChannelImplImports.const_get :ServerSocketChannel
    include_class_members ServerSocketChannelImplImports
    include SelChImpl
    
    class_module.module_eval {
      # Used to make native close and configure calls
      
      def nd
        defined?(@@nd) ? @@nd : @@nd= nil
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
    
    # ID of native thread currently blocked in this channel, for signalling
    attr_accessor :thread
    alias_method :attr_thread, :thread
    undef_method :thread
    alias_method :attr_thread=, :thread=
    undef_method :thread=
    
    # Lock held by thread currently blocked in this channel
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
      # Channel state, increases monotonically
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
    
    # Binding
    attr_accessor :local_address
    alias_method :attr_local_address, :local_address
    undef_method :local_address
    alias_method :attr_local_address=, :local_address=
    undef_method :local_address=
    
    # null => unbound
    # Options, created on demand
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
      @thread = 0
      @lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @options = nil
      @socket = nil
      super(sp)
      @thread = 0
      @lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @options = nil
      @fd = Net.server_socket(true)
      @fd_val = IOUtil.fd_val(@fd)
      @state = ST_INUSE
    end
    
    typesig { [SelectorProvider, FileDescriptor] }
    def initialize(sp, fd)
      @fd = nil
      @fd_val = 0
      @thread = 0
      @lock = nil
      @state_lock = nil
      @state = 0
      @local_address = nil
      @options = nil
      @socket = nil
      super(sp)
      @thread = 0
      @lock = Object.new
      @state_lock = Object.new
      @state = ST_UNINITIALIZED
      @local_address = nil
      @options = nil
      @fd = fd
      @fd_val = IOUtil.fd_val(fd)
      @state = ST_INUSE
      @local_address = Net.local_address(fd)
    end
    
    typesig { [] }
    def socket
      synchronized((@state_lock)) do
        if ((@socket).nil?)
          @socket = ServerSocketAdaptor.create(self)
        end
        return @socket
      end
    end
    
    typesig { [] }
    def is_bound
      synchronized((@state_lock)) do
        return !(@local_address).nil?
      end
    end
    
    typesig { [] }
    def local_address
      synchronized((@state_lock)) do
        return @local_address
      end
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    def bind(local, backlog)
      synchronized((@lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if (is_bound)
          raise AlreadyBoundException.new
        end
        isa = Net.check_address(local)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_listen(isa.get_port)
        end
        Net.bind(@fd, isa.get_address, isa.get_port)
        listen(@fd, backlog < 1 ? 50 : backlog)
        synchronized((@state_lock)) do
          @local_address = Net.local_address(@fd)
        end
      end
    end
    
    typesig { [] }
    def accept
      synchronized((@lock)) do
        if (!is_open)
          raise ClosedChannelException.new
        end
        if (!is_bound)
          raise NotYetBoundException.new
        end
        sc = nil
        n = 0
        newfd = FileDescriptor.new
        isaa = Array.typed(InetSocketAddress).new(1) { nil }
        begin
          begin
          if (!is_open)
            return nil
          end
          @thread = NativeThread.current
          loop do
            n = accept0(@fd, newfd, isaa)
            if (((n).equal?(IOStatus::INTERRUPTED)) && is_open)
              next
            end
            break
          end
        ensure
          @thread = 0
          end(n > 0)
          raise AssertError if not (IOStatus.check(n))
        end
        if (n < 1)
          return nil
        end
        IOUtil.configure_blocking(newfd, true)
        isa = isaa[0]
        sc = SocketChannelImpl.new(provider, newfd, isa)
        sm = System.get_security_manager
        if (!(sm).nil?)
          begin
            sm.check_accept(isa.get_address.get_host_address, isa.get_port)
          rescue SecurityException => x
            sc.close
            raise x
          end
        end
        return sc
      end
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
            include_class_members ServerSocketChannelImpl
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
    
    typesig { [::Java::Int, ::Java::Int, SelectionKeyImpl] }
    # 
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
      if ((!((ops & PollArrayWrapper::POLLIN)).equal?(0)) && (!((int_ops & SelectionKey::OP_ACCEPT)).equal?(0)))
        new_ops |= SelectionKey::OP_ACCEPT
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
    # 
    # Translates an interest operation set into a native poll event set
    def translate_and_set_interest_ops(ops, sk)
      new_ops = 0
      # Translate ops
      if (!((ops & SelectionKey::OP_ACCEPT)).equal?(0))
        new_ops |= PollArrayWrapper::POLLIN
      end
      # Place ops into pollfd array
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
      sb.append(self.get_class.get_name)
      sb.append(Character.new(?[.ord))
      if (!is_open)
        sb.append("closed")
      else
        synchronized((@state_lock)) do
          if ((local_address).nil?)
            sb.append("unbound")
          else
            sb.append(local_address.to_s)
          end
        end
      end
      sb.append(Character.new(?].ord))
      return sb.to_s
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_ServerSocketChannelImpl_listen, [:pointer, :long, :long, :int32], :void
      typesig { [FileDescriptor, ::Java::Int] }
      # -- Native methods --
      def listen(fd, backlog)
        JNI.__send__(:Java_sun_nio_ch_ServerSocketChannelImpl_listen, JNI.env, self.jni_id, fd.jni_id, backlog.to_int)
      end
    }
    
    JNI.native_method :Java_sun_nio_ch_ServerSocketChannelImpl_accept0, [:pointer, :long, :long, :long, :long], :int32
    typesig { [FileDescriptor, FileDescriptor, Array.typed(InetSocketAddress)] }
    # Accepts a new connection, setting the given file descriptor to refer to
    # the new socket and setting isaa[0] to the socket's remote address.
    # Returns 1 on success, or IOStatus.UNAVAILABLE (if non-blocking and no
    # connections are pending) or IOStatus.INTERRUPTED.
    def accept0(ssfd, newfd, isaa)
      JNI.__send__(:Java_sun_nio_ch_ServerSocketChannelImpl_accept0, JNI.env, self.jni_id, ssfd.jni_id, newfd.jni_id, isaa.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_ServerSocketChannelImpl_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_sun_nio_ch_ServerSocketChannelImpl_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Util.load
        init_ids
        self.attr_nd = SocketDispatcher.new
      end
    }
    
    private
    alias_method :initialize__server_socket_channel_impl, :initialize
  end
  
end

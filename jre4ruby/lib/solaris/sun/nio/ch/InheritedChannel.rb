require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InheritedChannelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Nio::Channels, :Channel
      include_const ::Java::Nio::Channels, :SocketChannel
      include_const ::Java::Nio::Channels, :ServerSocketChannel
      include_const ::Java::Nio::Channels, :DatagramChannel
      include_const ::Java::Nio::Channels::Spi, :SelectorProvider
    }
  end
  
  class InheritedChannel 
    include_class_members InheritedChannelImports
    
    class_module.module_eval {
      # the "types" of socket returned by soType0
      const_set_lazy(:UNKNOWN) { -1 }
      const_attr_reader  :UNKNOWN
      
      const_set_lazy(:SOCK_STREAM) { 1 }
      const_attr_reader  :SOCK_STREAM
      
      const_set_lazy(:SOCK_DGRAM) { 2 }
      const_attr_reader  :SOCK_DGRAM
      
      # oflag values when opening a file
      const_set_lazy(:O_RDONLY) { 0 }
      const_attr_reader  :O_RDONLY
      
      const_set_lazy(:O_WRONLY) { 1 }
      const_attr_reader  :O_WRONLY
      
      const_set_lazy(:O_RDWR) { 2 }
      const_attr_reader  :O_RDWR
      
      # In order to "detach" the standard streams we dup them to /dev/null.
      # In order to reduce the possibility of an error at close time we
      # open /dev/null early - that way we know we won't run out of file
      # descriptors at close time. This makes the close operation a
      # simple dup2 operation for each of the standard streams.
      
      def devnull
        defined?(@@devnull) ? @@devnull : @@devnull= -1
      end
      alias_method :attr_devnull, :devnull
      
      def devnull=(value)
        @@devnull = value
      end
      alias_method :attr_devnull=, :devnull=
      
      typesig { [] }
      def detach_iostreams
        begin
          dup2(self.attr_devnull, 0)
          dup2(self.attr_devnull, 1)
          dup2(self.attr_devnull, 2)
        rescue IOException => ioe
          # this shouldn't happen
          raise InternalError.new
        end
      end
      
      # Override the implCloseSelectableChannel for each channel type - this
      # allows us to "detach" the standard streams after closing and ensures
      # that the underlying socket really closes.
      const_set_lazy(:InheritedSocketChannelImpl) { Class.new(SocketChannelImpl) do
        include_class_members InheritedChannel
        
        typesig { [class_self::SelectorProvider, class_self::FileDescriptor, class_self::InetSocketAddress] }
        def initialize(sp, fd, remote)
          super(sp, fd, remote)
        end
        
        typesig { [] }
        def impl_close_selectable_channel
          super
          detach_iostreams
        end
        
        private
        alias_method :initialize__inherited_socket_channel_impl, :initialize
      end }
      
      const_set_lazy(:InheritedServerSocketChannelImpl) { Class.new(ServerSocketChannelImpl) do
        include_class_members InheritedChannel
        
        typesig { [class_self::SelectorProvider, class_self::FileDescriptor] }
        def initialize(sp, fd)
          super(sp, fd)
        end
        
        typesig { [] }
        def impl_close_selectable_channel
          super
          detach_iostreams
        end
        
        private
        alias_method :initialize__inherited_server_socket_channel_impl, :initialize
      end }
      
      const_set_lazy(:InheritedDatagramChannelImpl) { Class.new(DatagramChannelImpl) do
        include_class_members InheritedChannel
        
        typesig { [class_self::SelectorProvider, class_self::FileDescriptor] }
        def initialize(sp, fd)
          super(sp, fd)
        end
        
        typesig { [] }
        def impl_close_selectable_channel
          super
          detach_iostreams
        end
        
        private
        alias_method :initialize__inherited_datagram_channel_impl, :initialize
      end }
      
      typesig { [Channel] }
      # If there's a SecurityManager then check for the appropriate
      # RuntimePermission.
      def check_access(c)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(RuntimePermission.new("inheritedChannel"))
        end
      end
      
      typesig { [] }
      # If standard inherited channel is connected to a socket then return a Channel
      # of the appropriate type based standard input.
      def create_channel
        # dup the file descriptor - we do this so that for two reasons :-
        # 1. Avoids any timing issues with FileDescriptor.in being closed
        #    or redirected while we create the channel.
        # 2. Allows streams based on file descriptor 0 to co-exist with
        #    the channel (closing one doesn't impact the other)
        fd_val = dup(0)
        # Examine the file descriptor - if it's not a socket then we don't
        # create a channel so we release the file descriptor.
        st = 0
        st = so_type0(fd_val)
        if (!(st).equal?(SOCK_STREAM) && !(st).equal?(SOCK_DGRAM))
          close0(fd_val)
          return nil
        end
        # Next we create a FileDescriptor for the dup'ed file descriptor
        # Have to use reflection and also make assumption on how FD
        # is implemented.
        param_types = Array.typed(Class).new([Array])
        ctr = Reflect.lookup_constructor("java.io.FileDescriptor", param_types)
        args = Array.typed(Object).new([fd_val])
        fd = Reflect.invoke(ctr, args)
        # Now create the channel. If the socket is a streams socket then
        # we see if tthere is a peer (ie: connected). If so, then we
        # create a SocketChannel, otherwise a ServerSocketChannel.
        # If the socket is a datagram socket then create a DatagramChannel
        provider_ = SelectorProvider.provider
        raise AssertError if not (provider_.is_a?(Sun::Nio::Ch::SelectorProviderImpl))
        c = nil
        if ((st).equal?(SOCK_STREAM))
          ia = peer_address0(fd_val)
          if ((ia).nil?)
            c = InheritedServerSocketChannelImpl.new(provider_, fd)
          else
            port = peer_port0(fd_val)
            raise AssertError if not (port > 0)
            isa = InetSocketAddress.new(ia, port)
            c = InheritedSocketChannelImpl.new(provider_, fd, isa)
          end
        else
          c = InheritedDatagramChannelImpl.new(provider_, fd)
        end
        return c
      end
      
      
      def have_channel
        defined?(@@have_channel) ? @@have_channel : @@have_channel= false
      end
      alias_method :attr_have_channel, :have_channel
      
      def have_channel=(value)
        @@have_channel = value
      end
      alias_method :attr_have_channel=, :have_channel=
      
      
      def channel
        defined?(@@channel) ? @@channel : @@channel= nil
      end
      alias_method :attr_channel, :channel
      
      def channel=(value)
        @@channel = value
      end
      alias_method :attr_channel=, :channel=
      
      typesig { [] }
      # Returns a Channel representing the inherited channel if the
      # inherited channel is a stream connected to a network socket.
      def get_channel
        synchronized(self) do
          if (self.attr_devnull < 0)
            self.attr_devnull = open0("/dev/null", O_RDWR)
          end
          # If we don't have the channel try to create it
          if (!self.attr_have_channel)
            self.attr_channel = create_channel
            self.attr_have_channel = true
          end
          # if there is a channel then do the security check before
          # returning it.
          if (!(self.attr_channel).nil?)
            check_access(self.attr_channel)
          end
          return self.attr_channel
        end
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_dup, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      # -- Native methods --
      def dup(fd)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_dup, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_dup2, [:pointer, :long, :int32, :int32], :void
      typesig { [::Java::Int, ::Java::Int] }
      def dup2(fd, fd2)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_dup2, JNI.env, self.jni_id, fd.to_int, fd2.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_open0, [:pointer, :long, :long, :int32], :int32
      typesig { [String, ::Java::Int] }
      def open0(path, oflag)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_open0, JNI.env, self.jni_id, path.jni_id, oflag.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_close0, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def close0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_close0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_soType0, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      def so_type0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_soType0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_peerAddress0, [:pointer, :long, :int32], :long
      typesig { [::Java::Int] }
      def peer_address0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_peerAddress0, JNI.env, self.jni_id, fd.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_InheritedChannel_peerPort0, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      def peer_port0(fd)
        JNI.call_native_method(:Java_sun_nio_ch_InheritedChannel_peerPort0, JNI.env, self.jni_id, fd.to_int)
      end
      
      when_class_loaded do
        Util.load
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__inherited_channel, :initialize
  end
  
end

require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Channels
  module SocketChannelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :Socket
      include_const ::Java::Net, :SocketAddress
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # A selectable channel for stream-oriented connecting sockets.
  # 
  # <p> Socket channels are not a complete abstraction of connecting network
  # sockets.  Binding, shutdown, and the manipulation of socket options must be
  # done through an associated {@link java.net.Socket} object obtained by
  # invoking the {@link #socket() socket} method.  It is not possible to create
  # a channel for an arbitrary, pre-existing socket, nor is it possible to
  # specify the {@link java.net.SocketImpl} object to be used by a socket
  # associated with a socket channel.
  # 
  # <p> A socket channel is created by invoking one of the {@link #open open}
  # methods of this class.  A newly-created socket channel is open but not yet
  # connected.  An attempt to invoke an I/O operation upon an unconnected
  # channel will cause a {@link NotYetConnectedException} to be thrown.  A
  # socket channel can be connected by invoking its {@link #connect connect}
  # method; once connected, a socket channel remains connected until it is
  # closed.  Whether or not a socket channel is connected may be determined by
  # invoking its {@link #isConnected isConnected} method.
  # 
  # <p> Socket channels support <i>non-blocking connection:</i>&nbsp;A socket
  # channel may be created and the process of establishing the link to the
  # remote socket may be initiated via the {@link #connect connect} method for
  # later completion by the {@link #finishConnect finishConnect} method.
  # Whether or not a connection operation is in progress may be determined by
  # invoking the {@link #isConnectionPending isConnectionPending} method.
  # 
  # <p> The input and output sides of a socket channel may independently be
  # <i>shut down</i> without actually closing the channel.  Shutting down the
  # input side of a channel by invoking the {@link java.net.Socket#shutdownInput
  # shutdownInput} method of an associated socket object will cause further
  # reads on the channel to return <tt>-1</tt>, the end-of-stream indication.
  # Shutting down the output side of the channel by invoking the {@link
  # java.net.Socket#shutdownOutput shutdownOutput} method of an associated
  # socket object will cause further writes on the channel to throw a {@link
  # ClosedChannelException}.
  # 
  # <p> Socket channels support <i>asynchronous shutdown,</i> which is similar
  # to the asynchronous close operation specified in the {@link Channel} class.
  # If the input side of a socket is shut down by one thread while another
  # thread is blocked in a read operation on the socket's channel, then the read
  # operation in the blocked thread will complete without reading any bytes and
  # will return <tt>-1</tt>.  If the output side of a socket is shut down by one
  # thread while another thread is blocked in a write operation on the socket's
  # channel, then the blocked thread will receive an {@link
  # AsynchronousCloseException}.
  # 
  # <p> Socket channels are safe for use by multiple concurrent threads.  They
  # support concurrent reading and writing, though at most one thread may be
  # reading and at most one thread may be writing at any given time.  The {@link
  # #connect connect} and {@link #finishConnect finishConnect} methods are
  # mutually synchronized against each other, and an attempt to initiate a read
  # or write operation while an invocation of one of these methods is in
  # progress will block until that invocation is complete.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class SocketChannel < SocketChannelImports.const_get :AbstractSelectableChannel
    include_class_members SocketChannelImports
    overload_protected {
      include ByteChannel
      include ScatteringByteChannel
      include GatheringByteChannel
    }
    
    typesig { [SelectorProvider] }
    # Initializes a new instance of this class.
    def initialize(provider)
      super(provider)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Opens a socket channel.
      # 
      # <p> The new channel is created by invoking the {@link
      # java.nio.channels.spi.SelectorProvider#openSocketChannel
      # openSocketChannel} method of the system-wide default {@link
      # java.nio.channels.spi.SelectorProvider} object.  </p>
      # 
      # @return  A new socket channel
      # 
      # @throws  IOException
      #          If an I/O error occurs
      def open
        return SelectorProvider.provider.open_socket_channel
      end
      
      typesig { [SocketAddress] }
      # Opens a socket channel and connects it to a remote address.
      # 
      # <p> This convenience method works as if by invoking the {@link #open()}
      # method, invoking the {@link #connect(SocketAddress) connect} method upon
      # the resulting socket channel, passing it <tt>remote</tt>, and then
      # returning that channel.  </p>
      # 
      # @param  remote
      #         The remote address to which the new channel is to be connected
      # 
      # @throws  AsynchronousCloseException
      #          If another thread closes this channel
      #          while the connect operation is in progress
      # 
      # @throws  ClosedByInterruptException
      #          If another thread interrupts the current thread
      #          while the connect operation is in progress, thereby
      #          closing the channel and setting the current thread's
      #          interrupt status
      # 
      # @throws  UnresolvedAddressException
      #          If the given remote address is not fully resolved
      # 
      # @throws  UnsupportedAddressTypeException
      #          If the type of the given remote address is not supported
      # 
      # @throws  SecurityException
      #          If a security manager has been installed
      #          and it does not permit access to the given remote endpoint
      # 
      # @throws  IOException
      #          If some other I/O error occurs
      def open(remote)
        sc = open
        begin
          sc.connect(remote)
        ensure
          if (!sc.is_connected)
            begin
              sc.close
            rescue IOException => x
            end
          end
        end
        raise AssertError if not (sc.is_connected)
        return sc
      end
    }
    
    typesig { [] }
    # Returns an operation set identifying this channel's supported
    # operations.
    # 
    # <p> Socket channels support connecting, reading, and writing, so this
    # method returns <tt>(</tt>{@link SelectionKey#OP_CONNECT}
    # <tt>|</tt>&nbsp;{@link SelectionKey#OP_READ} <tt>|</tt>&nbsp;{@link
    # SelectionKey#OP_WRITE}<tt>)</tt>.  </p>
    # 
    # @return  The valid-operation set
    def valid_ops
      return (SelectionKey::OP_READ | SelectionKey::OP_WRITE | SelectionKey::OP_CONNECT)
    end
    
    typesig { [] }
    # -- Socket-specific operations --
    # Retrieves a socket associated with this channel.
    # 
    # <p> The returned object will not declare any public methods that are not
    # declared in the {@link java.net.Socket} class.  </p>
    # 
    # @return  A socket associated with this channel
    def socket
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether or not this channel's network socket is connected.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this channel's network socket
    #          is connected
    def is_connected
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether or not a connection operation is in progress on this
    # channel.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, a connection operation has been
    #          initiated on this channel but not yet completed by invoking the
    #          {@link #finishConnect finishConnect} method
    def is_connection_pending
      raise NotImplementedError
    end
    
    typesig { [SocketAddress] }
    # Connects this channel's socket.
    # 
    # <p> If this channel is in non-blocking mode then an invocation of this
    # method initiates a non-blocking connection operation.  If the connection
    # is established immediately, as can happen with a local connection, then
    # this method returns <tt>true</tt>.  Otherwise this method returns
    # <tt>false</tt> and the connection operation must later be completed by
    # invoking the {@link #finishConnect finishConnect} method.
    # 
    # <p> If this channel is in blocking mode then an invocation of this
    # method will block until the connection is established or an I/O error
    # occurs.
    # 
    # <p> This method performs exactly the same security checks as the {@link
    # java.net.Socket} class.  That is, if a security manager has been
    # installed then this method verifies that its {@link
    # java.lang.SecurityManager#checkConnect checkConnect} method permits
    # connecting to the address and port number of the given remote endpoint.
    # 
    # <p> This method may be invoked at any time.  If a read or write
    # operation upon this channel is invoked while an invocation of this
    # method is in progress then that operation will first block until this
    # invocation is complete.  If a connection attempt is initiated but fails,
    # that is, if an invocation of this method throws a checked exception,
    # then the channel will be closed.  </p>
    # 
    # @param  remote
    #         The remote address to which this channel is to be connected
    # 
    # @return  <tt>true</tt> if a connection was established,
    #          <tt>false</tt> if this channel is in non-blocking mode
    #          and the connection operation is in progress
    # 
    # @throws  AlreadyConnectedException
    #          If this channel is already connected
    # 
    # @throws  ConnectionPendingException
    #          If a non-blocking connection operation is already in progress
    #          on this channel
    # 
    # @throws  ClosedChannelException
    #          If this channel is closed
    # 
    # @throws  AsynchronousCloseException
    #          If another thread closes this channel
    #          while the connect operation is in progress
    # 
    # @throws  ClosedByInterruptException
    #          If another thread interrupts the current thread
    #          while the connect operation is in progress, thereby
    #          closing the channel and setting the current thread's
    #          interrupt status
    # 
    # @throws  UnresolvedAddressException
    #          If the given remote address is not fully resolved
    # 
    # @throws  UnsupportedAddressTypeException
    #          If the type of the given remote address is not supported
    # 
    # @throws  SecurityException
    #          If a security manager has been installed
    #          and it does not permit access to the given remote endpoint
    # 
    # @throws  IOException
    #          If some other I/O error occurs
    def connect(remote)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Finishes the process of connecting a socket channel.
    # 
    # <p> A non-blocking connection operation is initiated by placing a socket
    # channel in non-blocking mode and then invoking its {@link #connect
    # connect} method.  Once the connection is established, or the attempt has
    # failed, the socket channel will become connectable and this method may
    # be invoked to complete the connection sequence.  If the connection
    # operation failed then invoking this method will cause an appropriate
    # {@link java.io.IOException} to be thrown.
    # 
    # <p> If this channel is already connected then this method will not block
    # and will immediately return <tt>true</tt>.  If this channel is in
    # non-blocking mode then this method will return <tt>false</tt> if the
    # connection process is not yet complete.  If this channel is in blocking
    # mode then this method will block until the connection either completes
    # or fails, and will always either return <tt>true</tt> or throw a checked
    # exception describing the failure.
    # 
    # <p> This method may be invoked at any time.  If a read or write
    # operation upon this channel is invoked while an invocation of this
    # method is in progress then that operation will first block until this
    # invocation is complete.  If a connection attempt fails, that is, if an
    # invocation of this method throws a checked exception, then the channel
    # will be closed.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this channel's socket is now
    #          connected
    # 
    # @throws  NoConnectionPendingException
    #          If this channel is not connected and a connection operation
    #          has not been initiated
    # 
    # @throws  ClosedChannelException
    #          If this channel is closed
    # 
    # @throws  AsynchronousCloseException
    #          If another thread closes this channel
    #          while the connect operation is in progress
    # 
    # @throws  ClosedByInterruptException
    #          If another thread interrupts the current thread
    #          while the connect operation is in progress, thereby
    #          closing the channel and setting the current thread's
    #          interrupt status
    # 
    # @throws  IOException
    #          If some other I/O error occurs
    def finish_connect
      raise NotImplementedError
    end
    
    typesig { [ByteBuffer] }
    # -- ByteChannel operations --
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def read(dst)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def read(dsts, offset, length)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def read(dsts)
      return read(dsts, 0, dsts.attr_length)
    end
    
    typesig { [ByteBuffer] }
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def write(src)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def write(srcs, offset, length)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    # @throws  NotYetConnectedException
    #          If this channel is not yet connected
    def write(srcs)
      return write(srcs, 0, srcs.attr_length)
    end
    
    private
    alias_method :initialize__socket_channel, :initialize
  end
  
end

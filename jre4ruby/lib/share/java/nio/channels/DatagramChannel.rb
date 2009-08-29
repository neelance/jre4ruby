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
  module DatagramChannelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :DatagramSocket
      include_const ::Java::Net, :SocketAddress
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # A selectable channel for datagram-oriented sockets.
  # 
  # 
  # <p> Datagram channels are not a complete abstraction of network datagram
  # sockets.  Binding and the manipulation of socket options must be done
  # through an associated {@link java.net.DatagramSocket} object obtained by
  # invoking the {@link #socket() socket} method.  It is not possible to create
  # a channel for an arbitrary, pre-existing datagram socket, nor is it possible
  # to specify the {@link java.net.DatagramSocketImpl} object to be used by a
  # datagram socket associated with a datagram channel.
  # 
  # <p> A datagram channel is created by invoking the {@link #open open} method
  # of this class.  A newly-created datagram channel is open but not connected.
  # A datagram channel need not be connected in order for the {@link #send send}
  # and {@link #receive receive} methods to be used.  A datagram channel may be
  # connected, by invoking its {@link #connect connect} method, in order to
  # avoid the overhead of the security checks are otherwise performed as part of
  # every send and receive operation.  A datagram channel must be connected in
  # order to use the {@link #read(java.nio.ByteBuffer) read} and {@link
  # #write(java.nio.ByteBuffer) write} methods, since those methods do not
  # accept or return socket addresses.
  # 
  # <p> Once connected, a datagram channel remains connected until it is
  # disconnected or closed.  Whether or not a datagram channel is connected may
  # be determined by invoking its {@link #isConnected isConnected} method.
  # 
  # <p> Datagram channels are safe for use by multiple concurrent threads.  They
  # support concurrent reading and writing, though at most one thread may be
  # reading and at most one thread may be writing at any given time.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class DatagramChannel < DatagramChannelImports.const_get :AbstractSelectableChannel
    include_class_members DatagramChannelImports
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
      # Opens a datagram channel.
      # 
      # <p> The new channel is created by invoking the {@link
      # java.nio.channels.spi.SelectorProvider#openDatagramChannel()
      # openDatagramChannel} method of the system-wide default {@link
      # java.nio.channels.spi.SelectorProvider} object.  The channel will not be
      # connected.  </p>
      # 
      # @return  A new datagram channel
      # 
      # @throws  IOException
      # If an I/O error occurs
      def open
        return SelectorProvider.provider.open_datagram_channel
      end
    }
    
    typesig { [] }
    # Returns an operation set identifying this channel's supported
    # operations.
    # 
    # <p> Datagram channels support reading and writing, so this method
    # returns <tt>(</tt>{@link SelectionKey#OP_READ} <tt>|</tt>&nbsp;{@link
    # SelectionKey#OP_WRITE}<tt>)</tt>.  </p>
    # 
    # @return  The valid-operation set
    def valid_ops
      return (SelectionKey::OP_READ | SelectionKey::OP_WRITE)
    end
    
    typesig { [] }
    # -- Socket-specific operations --
    # 
    # Retrieves a datagram socket associated with this channel.
    # 
    # <p> The returned object will not declare any public methods that are not
    # declared in the {@link java.net.DatagramSocket} class.  </p>
    # 
    # @return  A datagram socket associated with this channel
    def socket
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether or not this channel's socket is connected.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this channel's socket
    # is connected
    def is_connected
      raise NotImplementedError
    end
    
    typesig { [SocketAddress] }
    # Connects this channel's socket.
    # 
    # <p> The channel's socket is configured so that it only receives
    # datagrams from, and sends datagrams to, the given remote <i>peer</i>
    # address.  Once connected, datagrams may not be received from or sent to
    # any other address.  A datagram socket remains connected until it is
    # explicitly disconnected or until it is closed.
    # 
    # <p> This method performs exactly the same security checks as the {@link
    # java.net.DatagramSocket#connect connect} method of the {@link
    # java.net.DatagramSocket} class.  That is, if a security manager has been
    # installed then this method verifies that its {@link
    # java.lang.SecurityManager#checkAccept checkAccept} and {@link
    # java.lang.SecurityManager#checkConnect checkConnect} methods permit
    # datagrams to be received from and sent to, respectively, the given
    # remote address.
    # 
    # <p> This method may be invoked at any time.  It will not have any effect
    # on read or write operations that are already in progress at the moment
    # that it is invoked.  </p>
    # 
    # @param  remote
    # The remote address to which this channel is to be connected
    # 
    # @return  This datagram channel
    # 
    # @throws  ClosedChannelException
    # If this channel is closed
    # 
    # @throws  AsynchronousCloseException
    # If another thread closes this channel
    # while the connect operation is in progress
    # 
    # @throws  ClosedByInterruptException
    # If another thread interrupts the current thread
    # while the connect operation is in progress, thereby
    # closing the channel and setting the current thread's
    # interrupt status
    # 
    # @throws  SecurityException
    # If a security manager has been installed
    # and it does not permit access to the given remote address
    # 
    # @throws  IOException
    # If some other I/O error occurs
    def connect(remote)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disconnects this channel's socket.
    # 
    # <p> The channel's socket is configured so that it can receive datagrams
    # from, and sends datagrams to, any remote address so long as the security
    # manager, if installed, permits it.
    # 
    # <p> This method may be invoked at any time.  It will not have any effect
    # on read or write operations that are already in progress at the moment
    # that it is invoked.
    # 
    # <p> If this channel's socket is not connected, or if the channel is
    # closed, then invoking this method has no effect.  </p>
    # 
    # @return  This datagram channel
    # 
    # @throws  IOException
    # If some other I/O error occurs
    def disconnect
      raise NotImplementedError
    end
    
    typesig { [ByteBuffer] }
    # Receives a datagram via this channel.
    # 
    # <p> If a datagram is immediately available, or if this channel is in
    # blocking mode and one eventually becomes available, then the datagram is
    # copied into the given byte buffer and its source address is returned.
    # If this channel is in non-blocking mode and a datagram is not
    # immediately available then this method immediately returns
    # <tt>null</tt>.
    # 
    # <p> The datagram is transferred into the given byte buffer starting at
    # its current position, as if by a regular {@link
    # ReadableByteChannel#read(java.nio.ByteBuffer) read} operation.  If there
    # are fewer bytes remaining in the buffer than are required to hold the
    # datagram then the remainder of the datagram is silently discarded.
    # 
    # <p> This method performs exactly the same security checks as the {@link
    # java.net.DatagramSocket#receive receive} method of the {@link
    # java.net.DatagramSocket} class.  That is, if the socket is not connected
    # to a specific remote address and a security manager has been installed
    # then for each datagram received this method verifies that the source's
    # address and port number are permitted by the security manager's {@link
    # java.lang.SecurityManager#checkAccept checkAccept} method.  The overhead
    # of this security check can be avoided by first connecting the socket via
    # the {@link #connect connect} method.
    # 
    # <p> This method may be invoked at any time.  If another thread has
    # already initiated a read operation upon this channel, however, then an
    # invocation of this method will block until the first operation is
    # complete. </p>
    # 
    # @param  dst
    # The buffer into which the datagram is to be transferred
    # 
    # @return  The datagram's source address,
    # or <tt>null</tt> if this channel is in non-blocking mode
    # and no datagram was immediately available
    # 
    # @throws  ClosedChannelException
    # If this channel is closed
    # 
    # @throws  AsynchronousCloseException
    # If another thread closes this channel
    # while the read operation is in progress
    # 
    # @throws  ClosedByInterruptException
    # If another thread interrupts the current thread
    # while the read operation is in progress, thereby
    # closing the channel and setting the current thread's
    # interrupt status
    # 
    # @throws  SecurityException
    # If a security manager has been installed
    # and it does not permit datagrams to be accepted
    # from the datagram's sender
    # 
    # @throws  IOException
    # If some other I/O error occurs
    def receive(dst)
      raise NotImplementedError
    end
    
    typesig { [ByteBuffer, SocketAddress] }
    # Sends a datagram via this channel.
    # 
    # <p> If this channel is in non-blocking mode and there is sufficient room
    # in the underlying output buffer, or if this channel is in blocking mode
    # and sufficient room becomes available, then the remaining bytes in the
    # given buffer are transmitted as a single datagram to the given target
    # address.
    # 
    # <p> The datagram is transferred from the byte buffer as if by a regular
    # {@link WritableByteChannel#write(java.nio.ByteBuffer) write} operation.
    # 
    # <p> This method performs exactly the same security checks as the {@link
    # java.net.DatagramSocket#send send} method of the {@link
    # java.net.DatagramSocket} class.  That is, if the socket is not connected
    # to a specific remote address and a security manager has been installed
    # then for each datagram sent this method verifies that the target address
    # and port number are permitted by the security manager's {@link
    # java.lang.SecurityManager#checkConnect checkConnect} method.  The
    # overhead of this security check can be avoided by first connecting the
    # socket via the {@link #connect connect} method.
    # 
    # <p> This method may be invoked at any time.  If another thread has
    # already initiated a write operation upon this channel, however, then an
    # invocation of this method will block until the first operation is
    # complete. </p>
    # 
    # @param  src
    # The buffer containing the datagram to be sent
    # 
    # @param  target
    # The address to which the datagram is to be sent
    # 
    # @return   The number of bytes sent, which will be either the number
    # of bytes that were remaining in the source buffer when this
    # method was invoked or, if this channel is non-blocking, may be
    # zero if there was insufficient room for the datagram in the
    # underlying output buffer
    # 
    # @throws  ClosedChannelException
    # If this channel is closed
    # 
    # @throws  AsynchronousCloseException
    # If another thread closes this channel
    # while the read operation is in progress
    # 
    # @throws  ClosedByInterruptException
    # If another thread interrupts the current thread
    # while the read operation is in progress, thereby
    # closing the channel and setting the current thread's
    # interrupt status
    # 
    # @throws  SecurityException
    # If a security manager has been installed
    # and it does not permit datagrams to be sent
    # to the given address
    # 
    # @throws  IOException
    # If some other I/O error occurs
    def send(src, target)
      raise NotImplementedError
    end
    
    typesig { [ByteBuffer] }
    # -- ByteChannel operations --
    # 
    # Reads a datagram from this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, and it only accepts datagrams from the socket's peer.  If
    # there are more bytes in the datagram than remain in the given buffer
    # then the remainder of the datagram is silently discarded.  Otherwise
    # this method behaves exactly as specified in the {@link
    # ReadableByteChannel} interface.  </p>
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def read(dst)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # Reads a datagram from this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, and it only accepts datagrams from the socket's peer.  If
    # there are more bytes in the datagram than remain in the given buffers
    # then the remainder of the datagram is silently discarded.  Otherwise
    # this method behaves exactly as specified in the {@link
    # ScatteringByteChannel} interface.  </p>
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def read(dsts, offset, length)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    # Reads a datagram from this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, and it only accepts datagrams from the socket's peer.  If
    # there are more bytes in the datagram than remain in the given buffers
    # then the remainder of the datagram is silently discarded.  Otherwise
    # this method behaves exactly as specified in the {@link
    # ScatteringByteChannel} interface.  </p>
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def read(dsts)
      return read(dsts, 0, dsts.attr_length)
    end
    
    typesig { [ByteBuffer] }
    # Writes a datagram to this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, in which case it sends datagrams directly to the socket's
    # peer.  Otherwise it behaves exactly as specified in the {@link
    # WritableByteChannel} interface.  </p>
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def write(src)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # Writes a datagram to this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, in which case it sends datagrams directly to the socket's
    # peer.  Otherwise it behaves exactly as specified in the {@link
    # GatheringByteChannel} interface.  </p>
    # 
    # @return   The number of bytes sent, which will be either the number
    # of bytes that were remaining in the source buffer when this
    # method was invoked or, if this channel is non-blocking, may be
    # zero if there was insufficient room for the datagram in the
    # underlying output buffer
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def write(srcs, offset, length)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    # Writes a datagram to this channel.
    # 
    # <p> This method may only be invoked if this channel's socket is
    # connected, in which case it sends datagrams directly to the socket's
    # peer.  Otherwise it behaves exactly as specified in the {@link
    # GatheringByteChannel} interface.  </p>
    # 
    # @return   The number of bytes sent, which will be either the number
    # of bytes that were remaining in the source buffer when this
    # method was invoked or, if this channel is non-blocking, may be
    # zero if there was insufficient room for the datagram in the
    # underlying output buffer
    # 
    # @throws  NotYetConnectedException
    # If this channel's socket is not connected
    def write(srcs)
      return write(srcs, 0, srcs.attr_length)
    end
    
    private
    alias_method :initialize__datagram_channel, :initialize
  end
  
end

require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SinkChannelImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # Pipe.SinkChannel implementation based on socket connection.
  class SinkChannelImpl < SinkChannelImplImports.const_get :Pipe::SinkChannel
    include_class_members SinkChannelImplImports
    overload_protected {
      include SelChImpl
    }
    
    # The SocketChannel assoicated with this pipe
    attr_accessor :sc
    alias_method :attr_sc, :sc
    undef_method :sc
    alias_method :attr_sc=, :sc=
    undef_method :sc=
    
    typesig { [] }
    def get_fd
      return (@sc).get_fd
    end
    
    typesig { [] }
    def get_fdval
      return (@sc).get_fdval
    end
    
    typesig { [SelectorProvider, SocketChannel] }
    def initialize(sp, sc)
      @sc = nil
      super(sp)
      @sc = sc
    end
    
    typesig { [] }
    def impl_close_selectable_channel
      if (!is_registered)
        kill
      end
    end
    
    typesig { [] }
    def kill
      @sc.close
    end
    
    typesig { [::Java::Boolean] }
    def impl_configure_blocking(block)
      @sc.configure_blocking(block)
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
    def translate_and_set_interest_ops(ops, sk)
      if (!((ops & SelectionKey::OP_WRITE)).equal?(0))
        ops = PollArrayWrapper::POLLOUT
      end
      sk.attr_selector.put_event_ops(sk, ops)
    end
    
    typesig { [ByteBuffer] }
    def write(src)
      begin
        return @sc.write(src)
      rescue AsynchronousCloseException => x
        close
        raise x
      end
    end
    
    typesig { [Array.typed(ByteBuffer)] }
    def write(srcs)
      begin
        return @sc.write(srcs)
      rescue AsynchronousCloseException => x
        close
        raise x
      end
    end
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    def write(srcs, offset, length)
      if ((offset < 0) || (length < 0) || (offset > srcs.attr_length - length))
        raise IndexOutOfBoundsException.new
      end
      begin
        return write(Util.subsequence(srcs, offset, length))
      rescue AsynchronousCloseException => x
        close
        raise x
      end
    end
    
    private
    alias_method :initialize__sink_channel_impl, :initialize
  end
  
end

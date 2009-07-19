require "rjava"

# Copyright 2001-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ChannelInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # This class is defined here rather than in java.nio.channels.Channels
  # so that code can be shared with SocketAdaptor.
  # 
  # @author Mike McCloskey
  # @author Mark Reinhold
  # @since 1.4
  class ChannelInputStream < ChannelInputStreamImports.const_get :InputStream
    include_class_members ChannelInputStreamImports
    
    class_module.module_eval {
      typesig { [ReadableByteChannel, ByteBuffer, ::Java::Boolean] }
      def read(ch, bb, block)
        if (ch.is_a?(SelectableChannel))
          sc = ch
          synchronized((sc.blocking_lock)) do
            bm = sc.is_blocking
            if (!bm)
              raise IllegalBlockingModeException.new
            end
            if (!(bm).equal?(block))
              sc.configure_blocking(block)
            end
            n = ch.read(bb)
            if (!(bm).equal?(block))
              sc.configure_blocking(bm)
            end
            return n
          end
        else
          return ch.read(bb)
        end
      end
    }
    
    attr_accessor :ch
    alias_method :attr_ch, :ch
    undef_method :ch
    alias_method :attr_ch=, :ch=
    undef_method :ch=
    
    attr_accessor :bb
    alias_method :attr_bb, :bb
    undef_method :bb
    alias_method :attr_bb=, :bb=
    undef_method :bb=
    
    attr_accessor :bs
    alias_method :attr_bs, :bs
    undef_method :bs
    alias_method :attr_bs=, :bs=
    undef_method :bs=
    
    # Invoker's previous array
    attr_accessor :b1
    alias_method :attr_b1, :b1
    undef_method :b1
    alias_method :attr_b1=, :b1=
    undef_method :b1=
    
    typesig { [ReadableByteChannel] }
    def initialize(ch)
      @ch = nil
      @bb = nil
      @bs = nil
      @b1 = nil
      super()
      @bb = nil
      @bs = nil
      @b1 = nil
      @ch = ch
    end
    
    typesig { [] }
    def read
      synchronized(self) do
        if ((@b1).nil?)
          @b1 = Array.typed(::Java::Byte).new(1) { 0 }
        end
        n = self.read(@b1)
        if ((n).equal?(1))
          return @b1[0] & 0xff
        end
        return -1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read(bs, off, len)
      synchronized(self) do
        if ((off < 0) || (off > bs.attr_length) || (len < 0) || ((off + len) > bs.attr_length) || ((off + len) < 0))
          raise IndexOutOfBoundsException.new
        else
          if ((len).equal?(0))
            return 0
          end
        end
        bb = (((@bs).equal?(bs)) ? @bb : ByteBuffer.wrap(bs))
        bb.limit(Math.min(off + len, bb.capacity))
        bb.position(off)
        @bb = bb
        @bs = bs
        return read(bb)
      end
    end
    
    typesig { [ByteBuffer] }
    def read(bb)
      return ChannelInputStream.read(@ch, bb, true)
    end
    
    typesig { [] }
    def close
      @ch.close
    end
    
    private
    alias_method :initialize__channel_input_stream, :initialize
  end
  
end

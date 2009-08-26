require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ChannelsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :Writer
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio, :BufferOverflowException
      include_const ::Java::Nio, :BufferUnderflowException
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :UnsupportedCharsetException
      include_const ::Java::Nio::Channels::Spi, :AbstractInterruptibleChannel
      include_const ::Sun::Nio::Ch, :ChannelInputStream
      include_const ::Sun::Nio::Cs, :StreamDecoder
      include_const ::Sun::Nio::Cs, :StreamEncoder
    }
  end
  
  # Utility methods for channels and streams.
  # 
  # <p> This class defines static methods that support the interoperation of the
  # stream classes of the <tt>{@link java.io}</tt> package with the channel
  # classes of this package.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author Mike McCloskey
  # @author JSR-51 Expert Group
  # @since 1.4
  class Channels 
    include_class_members ChannelsImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [WritableByteChannel, ByteBuffer] }
      # No instantiation
      def write(ch, bb)
        if (ch.is_a?(SelectableChannel))
          sc = ch
          synchronized((sc.blocking_lock)) do
            if (!sc.is_blocking)
              raise IllegalBlockingModeException.new
            end
            return ch.write(bb)
          end
        else
          return ch.write(bb)
        end
      end
      
      typesig { [ReadableByteChannel] }
      # -- Byte streams from channels --
      # 
      # Constructs a stream that reads bytes from the given channel.
      # 
      # <p> The <tt>read</tt> methods of the resulting stream will throw an
      # {@link IllegalBlockingModeException} if invoked while the underlying
      # channel is in non-blocking mode.  The stream will not be buffered, and
      # it will not support the {@link InputStream#mark mark} or {@link
      # InputStream#reset reset} methods.  The stream will be safe for access by
      # multiple concurrent threads.  Closing the stream will in turn cause the
      # channel to be closed.  </p>
      # 
      # @param  ch
      # The channel from which bytes will be read
      # 
      # @return  A new input stream
      def new_input_stream(ch)
        return Sun::Nio::Ch::ChannelInputStream.new(ch)
      end
      
      typesig { [WritableByteChannel] }
      # Constructs a stream that writes bytes to the given channel.
      # 
      # <p> The <tt>write</tt> methods of the resulting stream will throw an
      # {@link IllegalBlockingModeException} if invoked while the underlying
      # channel is in non-blocking mode.  The stream will not be buffered.  The
      # stream will be safe for access by multiple concurrent threads.  Closing
      # the stream will in turn cause the channel to be closed.  </p>
      # 
      # @param  ch
      # The channel to which bytes will be written
      # 
      # @return  A new output stream
      def new_output_stream(ch)
        return Class.new(OutputStream.class == Class ? OutputStream : Object) do
          extend LocalClass
          include_class_members Channels
          include OutputStream if OutputStream.class == Module
          
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
          
          typesig { [::Java::Int] }
          define_method :write do |b|
            synchronized(self) do
              if ((@b1).nil?)
                @b1 = Array.typed(::Java::Byte).new(1) { 0 }
              end
              @b1[0] = b
              self.write(@b1)
            end
          end
          
          typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
          define_method :write do |bs, off, len|
            synchronized(self) do
              if ((off < 0) || (off > bs.attr_length) || (len < 0) || ((off + len) > bs.attr_length) || ((off + len) < 0))
                raise self.class::IndexOutOfBoundsException.new
              else
                if ((len).equal?(0))
                  return
                end
              end
              bb = (((@bs).equal?(bs)) ? @bb : ByteBuffer.wrap(bs))
              bb.limit(Math.min(off + len, bb.capacity))
              bb.position(off)
              @bb = bb
              @bs = bs
              Channels.write(ch, bb)
            end
          end
          
          typesig { [] }
          define_method :close do
            ch.close
          end
          
          typesig { [] }
          define_method :initialize do
            @bb = nil
            @bs = nil
            @b1 = nil
            super()
            @bb = nil
            @bs = nil
            @b1 = nil
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [InputStream] }
      # -- Channels from streams --
      # 
      # Constructs a channel that reads bytes from the given stream.
      # 
      # <p> The resulting channel will not be buffered; it will simply redirect
      # its I/O operations to the given stream.  Closing the channel will in
      # turn cause the stream to be closed.  </p>
      # 
      # @param  in
      # The stream from which bytes are to be read
      # 
      # @return  A new readable byte channel
      def new_channel(in_)
        if ((in_).nil?)
          raise NullPointerException.new
        end
        if (in_.is_a?(FileInputStream) && (FileInputStream == in_.get_class))
          return (in_).get_channel
        end
        return ReadableByteChannelImpl.new(in_)
      end
      
      const_set_lazy(:ReadableByteChannelImpl) { Class.new(AbstractInterruptibleChannel) do
        include_class_members Channels
        overload_protected {
          include ReadableByteChannel
        }
        
        attr_accessor :in
        alias_method :attr_in, :in
        undef_method :in
        alias_method :attr_in=, :in=
        undef_method :in=
        
        class_module.module_eval {
          const_set_lazy(:TRANSFER_SIZE) { 8192 }
          const_attr_reader  :TRANSFER_SIZE
        }
        
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        attr_accessor :open
        alias_method :attr_open, :open
        undef_method :open
        alias_method :attr_open=, :open=
        undef_method :open=
        
        attr_accessor :read_lock
        alias_method :attr_read_lock, :read_lock
        undef_method :read_lock
        alias_method :attr_read_lock=, :read_lock=
        undef_method :read_lock=
        
        typesig { [class_self::InputStream] }
        def initialize(in_)
          @in = nil
          @buf = nil
          @open = false
          @read_lock = nil
          super()
          @buf = Array.typed(::Java::Byte).new(0) { 0 }
          @open = true
          @read_lock = Object.new
          @in = in_
        end
        
        typesig { [class_self::ByteBuffer] }
        def read(dst)
          len = dst.remaining
          total_read = 0
          bytes_read = 0
          synchronized((@read_lock)) do
            while (total_read < len)
              bytes_to_read = Math.min((len - total_read), self.class::TRANSFER_SIZE)
              if (@buf.attr_length < bytes_to_read)
                @buf = Array.typed(::Java::Byte).new(bytes_to_read) { 0 }
              end
              if ((total_read > 0) && !(@in.available > 0))
                break
              end # block at most once
              begin
                begin_
                bytes_read = @in.read(@buf, 0, bytes_to_read)
              ensure
                end_(bytes_read > 0)
              end
              if (bytes_read < 0)
                break
              else
                total_read += bytes_read
              end
              dst.put(@buf, 0, bytes_read)
            end
            if ((bytes_read < 0) && ((total_read).equal?(0)))
              return -1
            end
            return total_read
          end
        end
        
        typesig { [] }
        def impl_close_channel
          @in.close
          @open = false
        end
        
        private
        alias_method :initialize__readable_byte_channel_impl, :initialize
      end }
      
      typesig { [OutputStream] }
      # Not really interruptible
      # 
      # Constructs a channel that writes bytes to the given stream.
      # 
      # <p> The resulting channel will not be buffered; it will simply redirect
      # its I/O operations to the given stream.  Closing the channel will in
      # turn cause the stream to be closed.  </p>
      # 
      # @param  out
      # The stream to which bytes are to be written
      # 
      # @return  A new writable byte channel
      def new_channel(out)
        if ((out).nil?)
          raise NullPointerException.new
        end
        if (out.is_a?(FileOutputStream) && (FileOutputStream == out.get_class))
          return (out).get_channel
        end
        return WritableByteChannelImpl.new(out)
      end
      
      const_set_lazy(:WritableByteChannelImpl) { Class.new(AbstractInterruptibleChannel) do
        include_class_members Channels
        overload_protected {
          include WritableByteChannel
        }
        
        attr_accessor :out
        alias_method :attr_out, :out
        undef_method :out
        alias_method :attr_out=, :out=
        undef_method :out=
        
        class_module.module_eval {
          const_set_lazy(:TRANSFER_SIZE) { 8192 }
          const_attr_reader  :TRANSFER_SIZE
        }
        
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        attr_accessor :open
        alias_method :attr_open, :open
        undef_method :open
        alias_method :attr_open=, :open=
        undef_method :open=
        
        attr_accessor :write_lock
        alias_method :attr_write_lock, :write_lock
        undef_method :write_lock
        alias_method :attr_write_lock=, :write_lock=
        undef_method :write_lock=
        
        typesig { [class_self::OutputStream] }
        def initialize(out)
          @out = nil
          @buf = nil
          @open = false
          @write_lock = nil
          super()
          @buf = Array.typed(::Java::Byte).new(0) { 0 }
          @open = true
          @write_lock = Object.new
          @out = out
        end
        
        typesig { [class_self::ByteBuffer] }
        def write(src)
          len = src.remaining
          total_written = 0
          synchronized((@write_lock)) do
            while (total_written < len)
              bytes_to_write = Math.min((len - total_written), self.class::TRANSFER_SIZE)
              if (@buf.attr_length < bytes_to_write)
                @buf = Array.typed(::Java::Byte).new(bytes_to_write) { 0 }
              end
              src.get(@buf, 0, bytes_to_write)
              begin
                begin_
                @out.write(@buf, 0, bytes_to_write)
              ensure
                end_(bytes_to_write > 0)
              end
              total_written += bytes_to_write
            end
            return total_written
          end
        end
        
        typesig { [] }
        def impl_close_channel
          @out.close
          @open = false
        end
        
        private
        alias_method :initialize__writable_byte_channel_impl, :initialize
      end }
      
      typesig { [ReadableByteChannel, CharsetDecoder, ::Java::Int] }
      # Not really interruptible
      # -- Character streams from channels --
      # 
      # Constructs a reader that decodes bytes from the given channel using the
      # given decoder.
      # 
      # <p> The resulting stream will contain an internal input buffer of at
      # least <tt>minBufferCap</tt> bytes.  The stream's <tt>read</tt> methods
      # will, as needed, fill the buffer by reading bytes from the underlying
      # channel; if the channel is in non-blocking mode when bytes are to be
      # read then an {@link IllegalBlockingModeException} will be thrown.  The
      # resulting stream will not otherwise be buffered, and it will not support
      # the {@link Reader#mark mark} or {@link Reader#reset reset} methods.
      # Closing the stream will in turn cause the channel to be closed.  </p>
      # 
      # @param  ch
      # The channel from which bytes will be read
      # 
      # @param  dec
      # The charset decoder to be used
      # 
      # @param  minBufferCap
      # The minimum capacity of the internal byte buffer,
      # or <tt>-1</tt> if an implementation-dependent
      # default capacity is to be used
      # 
      # @return  A new reader
      def new_reader(ch, dec, min_buffer_cap)
        dec.reset
        return StreamDecoder.for_decoder(ch, dec, min_buffer_cap)
      end
      
      typesig { [ReadableByteChannel, String] }
      # Constructs a reader that decodes bytes from the given channel according
      # to the named charset.
      # 
      # <p> An invocation of this method of the form
      # 
      # <blockquote><pre>
      # Channels.newReader(ch, csname)</pre></blockquote>
      # 
      # behaves in exactly the same way as the expression
      # 
      # <blockquote><pre>
      # Channels.newReader(ch,
      # Charset.forName(csName)
      # .newDecoder(),
      # -1);</pre></blockquote>
      # 
      # @param  ch
      # The channel from which bytes will be read
      # 
      # @param  csName
      # The name of the charset to be used
      # 
      # @return  A new reader
      # 
      # @throws  UnsupportedCharsetException
      # If no support for the named charset is available
      # in this instance of the Java virtual machine
      def new_reader(ch, cs_name)
        return new_reader(ch, Charset.for_name(cs_name).new_decoder, -1)
      end
      
      typesig { [WritableByteChannel, CharsetEncoder, ::Java::Int] }
      # Constructs a writer that encodes characters using the given encoder and
      # writes the resulting bytes to the given channel.
      # 
      # <p> The resulting stream will contain an internal output buffer of at
      # least <tt>minBufferCap</tt> bytes.  The stream's <tt>write</tt> methods
      # will, as needed, flush the buffer by writing bytes to the underlying
      # channel; if the channel is in non-blocking mode when bytes are to be
      # written then an {@link IllegalBlockingModeException} will be thrown.
      # The resulting stream will not otherwise be buffered.  Closing the stream
      # will in turn cause the channel to be closed.  </p>
      # 
      # @param  ch
      # The channel to which bytes will be written
      # 
      # @param  enc
      # The charset encoder to be used
      # 
      # @param  minBufferCap
      # The minimum capacity of the internal byte buffer,
      # or <tt>-1</tt> if an implementation-dependent
      # default capacity is to be used
      # 
      # @return  A new writer
      def new_writer(ch, enc, min_buffer_cap)
        enc.reset
        return StreamEncoder.for_encoder(ch, enc, min_buffer_cap)
      end
      
      typesig { [WritableByteChannel, String] }
      # Constructs a writer that encodes characters according to the named
      # charset and writes the resulting bytes to the given channel.
      # 
      # <p> An invocation of this method of the form
      # 
      # <blockquote><pre>
      # Channels.newWriter(ch, csname)</pre></blockquote>
      # 
      # behaves in exactly the same way as the expression
      # 
      # <blockquote><pre>
      # Channels.newWriter(ch,
      # Charset.forName(csName)
      # .newEncoder(),
      # -1);</pre></blockquote>
      # 
      # @param  ch
      # The channel to which bytes will be written
      # 
      # @param  csName
      # The name of the charset to be used
      # 
      # @return  A new writer
      # 
      # @throws  UnsupportedCharsetException
      # If no support for the named charset is available
      # in this instance of the Java virtual machine
      def new_writer(ch, cs_name)
        return new_writer(ch, Charset.for_name(cs_name).new_encoder, -1)
      end
    }
    
    private
    alias_method :initialize__channels, :initialize
  end
  
end

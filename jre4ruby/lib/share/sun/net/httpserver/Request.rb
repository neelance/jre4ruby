require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Httpserver
  module RequestImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Util
      include ::Java::Nio
      include ::Java::Net
      include ::Java::Io
      include ::Java::Nio::Channels
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class Request 
    include_class_members RequestImports
    
    class_module.module_eval {
      const_set_lazy(:BUF_LEN) { 2048 }
      const_attr_reader  :BUF_LEN
      
      const_set_lazy(:CR) { 13 }
      const_attr_reader  :CR
      
      const_set_lazy(:LF) { 10 }
      const_attr_reader  :LF
    }
    
    attr_accessor :start_line
    alias_method :attr_start_line, :start_line
    undef_method :start_line
    alias_method :attr_start_line=, :start_line=
    undef_method :start_line=
    
    attr_accessor :chan
    alias_method :attr_chan, :chan
    undef_method :chan
    alias_method :attr_chan=, :chan=
    undef_method :chan=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :os
    alias_method :attr_os, :os
    undef_method :os
    alias_method :attr_os=, :os=
    undef_method :os=
    
    typesig { [InputStream, OutputStream] }
    def initialize(raw_input_stream, rawout)
      @start_line = nil
      @chan = nil
      @is = nil
      @os = nil
      @buf = CharArray.new(BUF_LEN)
      @pos = 0
      @line_buf = nil
      @hdrs = nil
      @chan = @chan
      @is = raw_input_stream
      @os = rawout
      begin
        @start_line = RJava.cast_to_string(read_line)
        if ((@start_line).nil?)
          return
        end
      end while ((@start_line == ""))
    end
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    attr_accessor :line_buf
    alias_method :attr_line_buf, :line_buf
    undef_method :line_buf
    alias_method :attr_line_buf=, :line_buf=
    undef_method :line_buf=
    
    typesig { [] }
    def input_stream
      return @is
    end
    
    typesig { [] }
    def output_stream
      return @os
    end
    
    typesig { [] }
    # read a line from the stream returning as a String.
    # Not used for reading headers.
    def read_line
      got_cr = false
      got_lf = false
      @pos = 0
      @line_buf = StringBuffer.new
      while (!got_lf)
        c = @is.read
        if ((c).equal?(-1))
          return nil
        end
        if (got_cr)
          if ((c).equal?(LF))
            got_lf = true
          else
            got_cr = false
            consume(CR)
            consume(c)
          end
        else
          if ((c).equal?(CR))
            got_cr = true
          else
            consume(c)
          end
        end
      end
      @line_buf.append(@buf, 0, @pos)
      return String.new(@line_buf)
    end
    
    typesig { [::Java::Int] }
    def consume(c)
      if ((@pos).equal?(BUF_LEN))
        @line_buf.append(@buf)
        @pos = 0
      end
      @buf[((@pos += 1) - 1)] = RJava.cast_to_char(c)
    end
    
    typesig { [] }
    # returns the request line (first line of a request)
    def request_line
      return @start_line
    end
    
    attr_accessor :hdrs
    alias_method :attr_hdrs, :hdrs
    undef_method :hdrs
    alias_method :attr_hdrs=, :hdrs=
    undef_method :hdrs=
    
    typesig { [] }
    def headers
      if (!(@hdrs).nil?)
        return @hdrs
      end
      @hdrs = Headers.new
      s = CharArray.new(10)
      firstc = @is.read
      while (!(firstc).equal?(LF) && !(firstc).equal?(CR) && firstc >= 0)
        len = 0
        keyend = -1
        c = 0
        in_key = firstc > Character.new(?\s.ord)
        s[((len += 1) - 1)] = RJava.cast_to_char(firstc)
        catch(:break_parseloop) do
          while ((c = @is.read) >= 0)
            case (c)
            when Character.new(?:.ord)
              if (in_key && len > 0)
                keyend = len
              end
              in_key = false
            when Character.new(?\t.ord)
              c = Character.new(?\s.ord)
              in_key = false
            when Character.new(?\s.ord)
              in_key = false
            when CR, LF
              firstc = @is.read
              if ((c).equal?(CR) && (firstc).equal?(LF))
                firstc = @is.read
                if ((firstc).equal?(CR))
                  firstc = @is.read
                end
              end
              if ((firstc).equal?(LF) || (firstc).equal?(CR) || firstc > Character.new(?\s.ord))
                throw :break_parseloop, :thrown
              end
              # continuation
              c = Character.new(?\s.ord)
            end
            if (len >= s.attr_length)
              ns = CharArray.new(s.attr_length * 2)
              System.arraycopy(s, 0, ns, 0, len)
              s = ns
            end
            s[((len += 1) - 1)] = RJava.cast_to_char(c)
          end
          firstc = -1
        end == :thrown or break
        while (len > 0 && s[len - 1] <= Character.new(?\s.ord))
          len -= 1
        end
        k = nil
        if (keyend <= 0)
          k = RJava.cast_to_string(nil)
          keyend = 0
        else
          k = RJava.cast_to_string(String.copy_value_of(s, 0, keyend))
          if (keyend < len && (s[keyend]).equal?(Character.new(?:.ord)))
            keyend += 1
          end
          while (keyend < len && s[keyend] <= Character.new(?\s.ord))
            keyend += 1
          end
        end
        v = nil
        if (keyend >= len)
          v = RJava.cast_to_string(String.new)
        else
          v = RJava.cast_to_string(String.copy_value_of(s, keyend, len - keyend))
        end
        @hdrs.add(k, v)
      end
      return @hdrs
    end
    
    class_module.module_eval {
      # Implements blocking reading semantics on top of a non-blocking channel
      const_set_lazy(:ReadStream) { Class.new(InputStream) do
        include_class_members Request
        
        attr_accessor :channel
        alias_method :attr_channel, :channel
        undef_method :channel
        alias_method :attr_channel=, :channel=
        undef_method :channel=
        
        attr_accessor :sc
        alias_method :attr_sc, :sc
        undef_method :sc
        alias_method :attr_sc=, :sc=
        undef_method :sc=
        
        attr_accessor :selector
        alias_method :attr_selector, :selector
        undef_method :selector
        alias_method :attr_selector=, :selector=
        undef_method :selector=
        
        attr_accessor :chanbuf
        alias_method :attr_chanbuf, :chanbuf
        undef_method :chanbuf
        alias_method :attr_chanbuf=, :chanbuf=
        undef_method :chanbuf=
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :available
        alias_method :attr_available, :available
        undef_method :available
        alias_method :attr_available=, :available=
        undef_method :available=
        
        attr_accessor :one
        alias_method :attr_one, :one
        undef_method :one
        alias_method :attr_one=, :one=
        undef_method :one=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        attr_accessor :eof
        alias_method :attr_eof, :eof
        undef_method :eof
        alias_method :attr_eof=, :eof=
        undef_method :eof=
        
        attr_accessor :mark_buf
        alias_method :attr_mark_buf, :mark_buf
        undef_method :mark_buf
        alias_method :attr_mark_buf=, :mark_buf=
        undef_method :mark_buf=
        
        # reads may be satisifed from this buffer
        attr_accessor :marked
        alias_method :attr_marked, :marked
        undef_method :marked
        alias_method :attr_marked=, :marked=
        undef_method :marked=
        
        attr_accessor :reset
        alias_method :attr_reset, :reset
        undef_method :reset
        alias_method :attr_reset=, :reset=
        undef_method :reset=
        
        attr_accessor :readlimit
        alias_method :attr_readlimit, :readlimit
        undef_method :readlimit
        alias_method :attr_readlimit=, :readlimit=
        undef_method :readlimit=
        
        class_module.module_eval {
          
          def read_timeout
            defined?(@@read_timeout) ? @@read_timeout : @@read_timeout= 0
          end
          alias_method :attr_read_timeout, :read_timeout
          
          def read_timeout=(value)
            @@read_timeout = value
          end
          alias_method :attr_read_timeout=, :read_timeout=
        }
        
        attr_accessor :server
        alias_method :attr_server, :server
        undef_method :server
        alias_method :attr_server=, :server=
        undef_method :server=
        
        class_module.module_eval {
          when_class_loaded do
            self.attr_read_timeout = ServerConfig.get_read_timeout
          end
        }
        
        typesig { [class_self::ServerImpl, class_self::SocketChannel] }
        def initialize(server, chan)
          @channel = nil
          @sc = nil
          @selector = nil
          @chanbuf = nil
          @key = nil
          @available = 0
          @one = nil
          @closed = false
          @eof = false
          @mark_buf = nil
          @marked = false
          @reset = false
          @readlimit = 0
          @server = nil
          super()
          @closed = false
          @eof = false
          @channel = chan
          @server = server
          @sc = SelectorCache.get_selector_cache
          @selector = @sc.get_selector
          @chanbuf = ByteBuffer.allocate(8 * 1024)
          @key = chan.register(@selector, SelectionKey::OP_READ)
          @available = 0
          @one = Array.typed(::Java::Byte).new(1) { 0 }
          @closed = @marked = @reset = false
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read(b)
          synchronized(self) do
            return read(b, 0, b.attr_length)
          end
        end
        
        typesig { [] }
        def read
          synchronized(self) do
            result = read(@one, 0, 1)
            if ((result).equal?(1))
              return @one[0] & 0xff
            else
              return -1
            end
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, srclen)
          synchronized(self) do
            canreturn = 0
            willreturn = 0
            if (@closed)
              raise self.class::IOException.new("Stream closed")
            end
            if (@eof)
              return -1
            end
            if (@reset)
              # satisfy from markBuf
              canreturn = @mark_buf.remaining
              willreturn = canreturn > srclen ? srclen : canreturn
              @mark_buf.get(b, off, willreturn)
              if ((canreturn).equal?(willreturn))
                @reset = false
              end
            else
              # satisfy from channel
              canreturn = available
              while ((canreturn).equal?(0) && !@eof)
                block
                canreturn = available
              end
              if (@eof)
                return -1
              end
              willreturn = canreturn > srclen ? srclen : canreturn
              @chanbuf.get(b, off, willreturn)
              @available -= willreturn
              if (@marked)
                # copy into markBuf
                begin
                  @mark_buf.put(b, off, willreturn)
                rescue self.class::BufferOverflowException => e
                  @marked = false
                end
              end
            end
            return willreturn
          end
        end
        
        typesig { [] }
        def available
          synchronized(self) do
            if (@closed)
              raise self.class::IOException.new("Stream is closed")
            end
            if (@eof)
              return -1
            end
            if (@reset)
              return @mark_buf.remaining
            end
            if (@available > 0)
              return @available
            end
            @chanbuf.clear
            @available = @channel.read(@chanbuf)
            if (@available > 0)
              @chanbuf.flip
            else
              if ((@available).equal?(-1))
                @eof = true
                @available = 0
              end
            end
            return @available
          end
        end
        
        typesig { [] }
        # block() only called when available==0 and buf is empty
        def block
          synchronized(self) do
            currtime = @server.get_time
            maxtime = currtime + self.attr_read_timeout
            while (currtime < maxtime)
              if ((@selector.select(self.attr_read_timeout)).equal?(1))
                @selector.selected_keys.clear
                available
                return
              end
              currtime = @server.get_time
            end
            raise self.class::SocketTimeoutException.new("no data received")
          end
        end
        
        typesig { [] }
        def close
          if (@closed)
            return
          end
          @channel.close
          @selector.select_now
          @sc.free_selector(@selector)
          @closed = true
        end
        
        typesig { [::Java::Int] }
        def mark(readlimit)
          synchronized(self) do
            if (@closed)
              return
            end
            @readlimit = readlimit
            @mark_buf = ByteBuffer.allocate(readlimit)
            @marked = true
            @reset = false
          end
        end
        
        typesig { [] }
        def reset
          synchronized(self) do
            if (@closed)
              return
            end
            if (!@marked)
              raise self.class::IOException.new("Stream not marked")
            end
            @marked = false
            @reset = true
            @mark_buf.flip
          end
        end
        
        private
        alias_method :initialize__read_stream, :initialize
      end }
      
      const_set_lazy(:WriteStream) { Class.new(Java::Io::OutputStream) do
        include_class_members Request
        
        attr_accessor :channel
        alias_method :attr_channel, :channel
        undef_method :channel
        alias_method :attr_channel=, :channel=
        undef_method :channel=
        
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :sc
        alias_method :attr_sc, :sc
        undef_method :sc
        alias_method :attr_sc=, :sc=
        undef_method :sc=
        
        attr_accessor :selector
        alias_method :attr_selector, :selector
        undef_method :selector
        alias_method :attr_selector=, :selector=
        undef_method :selector=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        attr_accessor :one
        alias_method :attr_one, :one
        undef_method :one
        alias_method :attr_one=, :one=
        undef_method :one=
        
        attr_accessor :server
        alias_method :attr_server, :server
        undef_method :server
        alias_method :attr_server=, :server=
        undef_method :server=
        
        class_module.module_eval {
          
          def write_timeout
            defined?(@@write_timeout) ? @@write_timeout : @@write_timeout= 0
          end
          alias_method :attr_write_timeout, :write_timeout
          
          def write_timeout=(value)
            @@write_timeout = value
          end
          alias_method :attr_write_timeout=, :write_timeout=
          
          when_class_loaded do
            self.attr_write_timeout = ServerConfig.get_write_timeout
          end
        }
        
        typesig { [class_self::ServerImpl, class_self::SocketChannel] }
        def initialize(server, channel)
          @channel = nil
          @buf = nil
          @key = nil
          @sc = nil
          @selector = nil
          @closed = false
          @one = nil
          @server = nil
          super()
          @channel = channel
          @server = server
          @sc = SelectorCache.get_selector_cache
          @selector = @sc.get_selector
          @key = channel.register(@selector, SelectionKey::OP_WRITE)
          @closed = false
          @one = Array.typed(::Java::Byte).new(1) { 0 }
          @buf = ByteBuffer.allocate(4096)
        end
        
        typesig { [::Java::Int] }
        def write(b)
          synchronized(self) do
            @one[0] = b
            write(@one, 0, 1)
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def write(b)
          synchronized(self) do
            write(b, 0, b.attr_length)
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def write(b, off, len)
          synchronized(self) do
            l = len
            if (@closed)
              raise self.class::IOException.new("stream is closed")
            end
            cap = @buf.capacity
            if (cap < len)
              diff = len - cap
              @buf = ByteBuffer.allocate(2 * (cap + diff))
            end
            @buf.clear
            @buf.put(b, off, len)
            @buf.flip
            n = 0
            while ((n = @channel.write(@buf)) < l)
              l -= n
              if ((l).equal?(0))
                return
              end
              block
            end
          end
        end
        
        typesig { [] }
        def block
          currtime = @server.get_time
          maxtime = currtime + self.attr_write_timeout
          while (currtime < maxtime)
            if ((@selector.select(self.attr_write_timeout)).equal?(1))
              @selector.selected_keys.clear
              return
            end
            currtime = @server.get_time
          end
          raise self.class::SocketTimeoutException.new("write blocked too long")
        end
        
        typesig { [] }
        def close
          if (@closed)
            return
          end
          @channel.close
          @selector.select_now
          @sc.free_selector(@selector)
          @closed = true
        end
        
        private
        alias_method :initialize__write_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__request, :initialize
  end
  
end

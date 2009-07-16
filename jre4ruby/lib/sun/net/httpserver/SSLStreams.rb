require "rjava"

# 
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
  module SSLStreamsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Net
      include ::Java::Nio
      include ::Java::Io
      include ::Java::Nio::Channels
      include ::Java::Util
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Javax::Net::Ssl
      include ::Javax::Net::Ssl::SSLEngineResult
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # 
  # given a non-blocking SocketChannel, it produces
  # (blocking) streams which encrypt/decrypt the SSL content
  # and handle the SSL handshaking automatically.
  class SSLStreams 
    include_class_members SSLStreamsImports
    
    attr_accessor :sslctx
    alias_method :attr_sslctx, :sslctx
    undef_method :sslctx
    alias_method :attr_sslctx=, :sslctx=
    undef_method :sslctx=
    
    attr_accessor :chan
    alias_method :attr_chan, :chan
    undef_method :chan
    alias_method :attr_chan=, :chan=
    undef_method :chan=
    
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    attr_accessor :engine
    alias_method :attr_engine, :engine
    undef_method :engine
    alias_method :attr_engine=, :engine=
    undef_method :engine=
    
    attr_accessor :wrapper
    alias_method :attr_wrapper, :wrapper
    undef_method :wrapper
    alias_method :attr_wrapper=, :wrapper=
    undef_method :wrapper=
    
    attr_accessor :os
    alias_method :attr_os, :os
    undef_method :os
    alias_method :attr_os=, :os=
    undef_method :os=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    class_module.module_eval {
      
      def read_timeout
        defined?(@@read_timeout) ? @@read_timeout : @@read_timeout= ServerConfig.get_read_timeout
      end
      alias_method :attr_read_timeout, :read_timeout
      
      def read_timeout=(value)
        @@read_timeout = value
      end
      alias_method :attr_read_timeout=, :read_timeout=
      
      
      def write_timeout
        defined?(@@write_timeout) ? @@write_timeout : @@write_timeout= ServerConfig.get_write_timeout
      end
      alias_method :attr_write_timeout, :write_timeout
      
      def write_timeout=(value)
        @@write_timeout = value
      end
      alias_method :attr_write_timeout=, :write_timeout=
    }
    
    # held by thread doing the hand-shake on this connection
    attr_accessor :handshaking
    alias_method :attr_handshaking, :handshaking
    undef_method :handshaking
    alias_method :attr_handshaking=, :handshaking=
    undef_method :handshaking=
    
    typesig { [ServerImpl, SSLContext, SocketChannel] }
    def initialize(server, sslctx, chan)
      @sslctx = nil
      @chan = nil
      @time = nil
      @server = nil
      @engine = nil
      @wrapper = nil
      @os = nil
      @is = nil
      @handshaking = ReentrantLock.new
      @app_buf_size = 0
      @packet_buf_size = 0
      @server = server
      @time = server
      @sslctx = sslctx
      @chan = chan
      addr = chan.socket.get_remote_socket_address
      @engine = sslctx.create_sslengine(addr.get_host_name, addr.get_port)
      @engine.set_use_client_mode(false)
      cfg = server.get_https_configurator
      configure_engine(cfg, addr)
      @wrapper = EngineWrapper.new_local(self, chan, @engine)
    end
    
    typesig { [HttpsConfigurator, InetSocketAddress] }
    def configure_engine(cfg, addr)
      if (!(cfg).nil?)
        params = Parameters.new_local(self, cfg, addr)
        cfg.configure(params)
        ssl_params = params.get_sslparameters
        if (!(ssl_params).nil?)
          @engine.set_sslparameters(ssl_params)
        else
          # tiger compatibility
          if (!(params.get_cipher_suites).nil?)
            begin
              @engine.set_enabled_cipher_suites(params.get_cipher_suites)
            rescue IllegalArgumentException => e
              # LOG
            end
          end
          @engine.set_need_client_auth(params.get_need_client_auth)
          @engine.set_want_client_auth(params.get_want_client_auth)
          if (!(params.get_protocols).nil?)
            begin
              @engine.set_enabled_protocols(params.get_protocols)
            rescue IllegalArgumentException => e
              # LOG
            end
          end
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:Parameters) { Class.new(HttpsParameters) do
        extend LocalClass
        include_class_members SSLStreams
        
        attr_accessor :addr
        alias_method :attr_addr, :addr
        undef_method :addr
        alias_method :attr_addr=, :addr=
        undef_method :addr=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :cfg
        alias_method :attr_cfg, :cfg
        undef_method :cfg
        alias_method :attr_cfg=, :cfg=
        undef_method :cfg=
        
        typesig { [HttpsConfigurator, InetSocketAddress] }
        def initialize(cfg, addr)
          @addr = nil
          @params = nil
          @cfg = nil
          super()
          @addr = addr
          @cfg = cfg
        end
        
        typesig { [] }
        def get_client_address
          return @addr
        end
        
        typesig { [] }
        def get_https_configurator
          return @cfg
        end
        
        typesig { [SSLParameters] }
        def set_sslparameters(p)
          @params = p
        end
        
        typesig { [] }
        def get_sslparameters
          return @params
        end
        
        private
        alias_method :initialize__parameters, :initialize
      end }
    }
    
    typesig { [] }
    # 
    # cleanup resources allocated inside this object
    def close
      @wrapper.close
    end
    
    typesig { [] }
    # 
    # return the SSL InputStream
    def get_input_stream
      if ((@is).nil?)
        @is = InputStream.new_local(self)
      end
      return @is
    end
    
    typesig { [] }
    # 
    # return the SSL OutputStream
    def get_output_stream
      if ((@os).nil?)
        @os = OutputStream.new_local(self)
      end
      return @os
    end
    
    typesig { [] }
    def get_sslengine
      return @engine
    end
    
    typesig { [] }
    # 
    # request the engine to repeat the handshake on this session
    # the handshake must be driven by reads/writes on the streams
    # Normally, not necessary to call this.
    def begin_handshake
      @engine.begin_handshake
    end
    
    class_module.module_eval {
      const_set_lazy(:WrapperResult) { Class.new do
        extend LocalClass
        include_class_members SSLStreams
        
        attr_accessor :result
        alias_method :attr_result, :result
        undef_method :result
        alias_method :attr_result=, :result=
        undef_method :result=
        
        # if passed in buffer was not big enough then the
        # a reallocated buffer is returned here
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        typesig { [] }
        def initialize
          @result = nil
          @buf = nil
        end
        
        private
        alias_method :initialize__wrapper_result, :initialize
      end }
    }
    
    attr_accessor :app_buf_size
    alias_method :attr_app_buf_size, :app_buf_size
    undef_method :app_buf_size
    alias_method :attr_app_buf_size=, :app_buf_size=
    undef_method :app_buf_size=
    
    attr_accessor :packet_buf_size
    alias_method :attr_packet_buf_size, :packet_buf_size
    undef_method :packet_buf_size
    alias_method :attr_packet_buf_size=, :packet_buf_size=
    undef_method :packet_buf_size=
    
    class_module.module_eval {
      const_set_lazy(:PACKET) { BufType::PACKET }
      const_attr_reader  :PACKET
      
      const_set_lazy(:APPLICATION) { BufType::APPLICATION }
      const_attr_reader  :APPLICATION
      
      class BufType 
        include_class_members SSLStreams
        
        class_module.module_eval {
          const_set_lazy(:PACKET) { BufType.new.set_value_name("PACKET") }
          const_attr_reader  :PACKET
          
          const_set_lazy(:APPLICATION) { BufType.new.set_value_name("APPLICATION") }
          const_attr_reader  :APPLICATION
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [PACKET, APPLICATION]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__buf_type, :initialize
      end
    }
    
    typesig { [BufType] }
    def allocate(type)
      return allocate(type, -1)
    end
    
    typesig { [BufType, ::Java::Int] }
    def allocate(type, len)
      raise AssertError if not (!(@engine).nil?)
      synchronized((self)) do
        size = 0
        if ((type).equal?(BufType::PACKET))
          if ((@packet_buf_size).equal?(0))
            sess = @engine.get_session
            @packet_buf_size = sess.get_packet_buffer_size
          end
          if (len > @packet_buf_size)
            @packet_buf_size = len
          end
          size = @packet_buf_size
        else
          if ((@app_buf_size).equal?(0))
            sess_ = @engine.get_session
            @app_buf_size = sess_.get_application_buffer_size
          end
          if (len > @app_buf_size)
            @app_buf_size = len
          end
          size = @app_buf_size
        end
        return ByteBuffer.allocate(size)
      end
    end
    
    typesig { [ByteBuffer, ::Java::Boolean, BufType] }
    # reallocates the buffer by :-
    # 1. creating a new buffer double the size of the old one
    # 2. putting the contents of the old buffer into the new one
    # 3. set xx_buf_size to the new size if it was smaller than new size
    # 
    # flip is set to true if the old buffer needs to be flipped
    # before it is copied.
    def realloc(b, flip, type)
      synchronized((self)) do
        nsize = 2 * b.capacity
        n = allocate(type, nsize)
        if (flip)
          b.flip
        end
        n.put(b)
        b = n
      end
      return b
    end
    
    class_module.module_eval {
      # 
      # This is a thin wrapper over SSLEngine and the SocketChannel,
      # which guarantees the ordering of wraps/unwraps with respect to the underlying
      # channel read/writes. It handles the UNDER/OVERFLOW status codes
      # It does not handle the handshaking status codes, or the CLOSED status code
      # though once the engine is closed, any attempt to read/write to it
      # will get an exception.  The overall result is returned.
      # It functions synchronously/blocking
      const_set_lazy(:EngineWrapper) { Class.new do
        extend LocalClass
        include_class_members SSLStreams
        
        attr_accessor :chan
        alias_method :attr_chan, :chan
        undef_method :chan
        alias_method :attr_chan=, :chan=
        undef_method :chan=
        
        attr_accessor :engine
        alias_method :attr_engine, :engine
        undef_method :engine
        alias_method :attr_engine=, :engine=
        undef_method :engine=
        
        attr_accessor :sc
        alias_method :attr_sc, :sc
        undef_method :sc
        alias_method :attr_sc=, :sc=
        undef_method :sc=
        
        attr_accessor :write_selector
        alias_method :attr_write_selector, :write_selector
        undef_method :write_selector
        alias_method :attr_write_selector=, :write_selector=
        undef_method :write_selector=
        
        attr_accessor :read_selector
        alias_method :attr_read_selector, :read_selector
        undef_method :read_selector
        alias_method :attr_read_selector=, :read_selector=
        undef_method :read_selector=
        
        attr_accessor :wkey
        alias_method :attr_wkey, :wkey
        undef_method :wkey
        alias_method :attr_wkey=, :wkey=
        undef_method :wkey=
        
        attr_accessor :rkey
        alias_method :attr_rkey, :rkey
        undef_method :rkey
        alias_method :attr_rkey=, :rkey=
        undef_method :rkey=
        
        attr_accessor :wrap_lock
        alias_method :attr_wrap_lock, :wrap_lock
        undef_method :wrap_lock
        alias_method :attr_wrap_lock=, :wrap_lock=
        undef_method :wrap_lock=
        
        attr_accessor :unwrap_lock
        alias_method :attr_unwrap_lock, :unwrap_lock
        undef_method :unwrap_lock
        alias_method :attr_unwrap_lock=, :unwrap_lock=
        undef_method :unwrap_lock=
        
        attr_accessor :unwrap_src
        alias_method :attr_unwrap_src, :unwrap_src
        undef_method :unwrap_src
        alias_method :attr_unwrap_src=, :unwrap_src=
        undef_method :unwrap_src=
        
        attr_accessor :wrap_dst
        alias_method :attr_wrap_dst, :wrap_dst
        undef_method :wrap_dst
        alias_method :attr_wrap_dst=, :wrap_dst=
        undef_method :wrap_dst=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        attr_accessor :u_remaining
        alias_method :attr_u_remaining, :u_remaining
        undef_method :u_remaining
        alias_method :attr_u_remaining=, :u_remaining=
        undef_method :u_remaining=
        
        typesig { [SocketChannel, SSLEngine] }
        # the number of bytes left in unwrap_src after an unwrap()
        def initialize(chan, engine)
          @chan = nil
          @engine = nil
          @sc = nil
          @write_selector = nil
          @read_selector = nil
          @wkey = nil
          @rkey = nil
          @wrap_lock = nil
          @unwrap_lock = nil
          @unwrap_src = nil
          @wrap_dst = nil
          @closed = false
          @u_remaining = 0
          @chan = chan
          @engine = engine
          @wrap_lock = Object.new
          @unwrap_lock = Object.new
          @unwrap_src = allocate(BufType::PACKET)
          @wrap_dst = allocate(BufType::PACKET)
          @sc = SelectorCache.get_selector_cache
          @write_selector = @sc.get_selector
          @wkey = chan.register(@write_selector, SelectionKey::OP_WRITE)
          @read_selector = @sc.get_selector
          @wkey = chan.register(@read_selector, SelectionKey::OP_READ)
        end
        
        typesig { [] }
        def close
          @sc.free_selector(@write_selector)
          @sc.free_selector(@read_selector)
        end
        
        typesig { [ByteBuffer] }
        # try to wrap and send the data in src. Handles OVERFLOW.
        # Might block if there is an outbound blockage or if another
        # thread is calling wrap(). Also, might not send any data
        # if an unwrap is needed.
        def wrap_and_send(src)
          return wrap_and_send_x(src, false)
        end
        
        typesig { [ByteBuffer, ::Java::Boolean] }
        def wrap_and_send_x(src, ignore_close)
          if (@closed && !ignore_close)
            raise IOException.new("Engine is closed")
          end
          status = nil
          r = WrapperResult.new
          synchronized((@wrap_lock)) do
            @wrap_dst.clear
            begin
              r.attr_result = @engine.wrap(src, @wrap_dst)
              status = r.attr_result.get_status
              if ((status).equal?(Status::BUFFER_OVERFLOW))
                @wrap_dst = realloc(@wrap_dst, true, BufType::PACKET)
              end
            end while ((status).equal?(Status::BUFFER_OVERFLOW))
            if ((status).equal?(Status::CLOSED) && !ignore_close)
              @closed = true
              return r
            end
            if (r.attr_result.bytes_produced > 0)
              @wrap_dst.flip
              l = @wrap_dst.remaining
              raise AssertError if not ((l).equal?(r.attr_result.bytes_produced))
              currtime = self.attr_time.get_time
              maxtime = currtime + self.attr_write_timeout
              while (l > 0)
                @write_selector.select(self.attr_write_timeout) # timeout
                currtime = self.attr_time.get_time
                if (currtime > maxtime)
                  raise SocketTimeoutException.new("write timed out")
                end
                @write_selector.selected_keys.clear
                l -= @chan.write(@wrap_dst)
              end
            end
          end
          return r
        end
        
        typesig { [ByteBuffer] }
        # block until a complete message is available and return it
        # in dst, together with the Result. dst may have been re-allocated
        # so caller should check the returned value in Result
        # If handshaking is in progress then, possibly no data is returned
        def recv_and_unwrap(dst)
          status = Status::OK
          r = WrapperResult.new
          r.attr_buf = dst
          if (@closed)
            raise IOException.new("Engine is closed")
          end
          need_data = false
          if (@u_remaining > 0)
            @unwrap_src.compact
            @unwrap_src.flip
            need_data = false
          else
            @unwrap_src.clear
            need_data = true
          end
          synchronized((@unwrap_lock)) do
            x = 0
            y = 0
            begin
              if (need_data)
                curr_time = self.attr_time.get_time
                maxtime = curr_time + self.attr_read_timeout
                begin
                  if (curr_time > maxtime)
                    raise SocketTimeoutException.new("read timedout")
                  end
                  y = @read_selector.select(self.attr_read_timeout)
                  curr_time = self.attr_time.get_time
                end while (!(y).equal?(1))
                @read_selector.selected_keys.clear
                x = @chan.read(@unwrap_src)
                if ((x).equal?(-1))
                  raise IOException.new("connection closed for reading")
                end
                @unwrap_src.flip
              end
              r.attr_result = @engine.unwrap(@unwrap_src, r.attr_buf)
              status = r.attr_result.get_status
              if ((status).equal?(Status::BUFFER_UNDERFLOW))
                if ((@unwrap_src.limit).equal?(@unwrap_src.capacity))
                  # buffer not big enough
                  @unwrap_src = realloc(@unwrap_src, false, BufType::PACKET)
                else
                  # Buffer not full, just need to read more
                  # data off the channel. Reset pointers
                  # for reading off SocketChannel
                  @unwrap_src.position(@unwrap_src.limit)
                  @unwrap_src.limit(@unwrap_src.capacity)
                end
                need_data = true
              else
                if ((status).equal?(Status::BUFFER_OVERFLOW))
                  r.attr_buf = realloc(r.attr_buf, true, BufType::APPLICATION)
                  need_data = false
                else
                  if ((status).equal?(Status::CLOSED))
                    @closed = true
                    r.attr_buf.flip
                    return r
                  end
                end
              end
            end while (!(status).equal?(Status::OK))
          end
          @u_remaining = @unwrap_src.remaining
          return r
        end
        
        private
        alias_method :initialize__engine_wrapper, :initialize
      end }
    }
    
    typesig { [ByteBuffer] }
    # 
    # send the data in the given ByteBuffer. If a handshake is needed
    # then this is handled within this method. When this call returns,
    # all of the given user data has been sent and any handshake has been
    # completed. Caller should check if engine has been closed.
    def send_data(src)
      r = nil
      while (src.remaining > 0)
        r = @wrapper.wrap_and_send(src)
        status = r.attr_result.get_status
        if ((status).equal?(Status::CLOSED))
          do_closure
          return r
        end
        hs_status = r.attr_result.get_handshake_status
        if (!(hs_status).equal?(HandshakeStatus::FINISHED) && !(hs_status).equal?(HandshakeStatus::NOT_HANDSHAKING))
          do_handshake(hs_status)
        end
      end
      return r
    end
    
    typesig { [ByteBuffer] }
    # 
    # read data thru the engine into the given ByteBuffer. If the
    # given buffer was not large enough, a new one is allocated
    # and returned. This call handles handshaking automatically.
    # Caller should check if engine has been closed.
    def recv_data(dst)
      # we wait until some user data arrives
      r = nil
      raise AssertError if not ((dst.position).equal?(0))
      while ((dst.position).equal?(0))
        r = @wrapper.recv_and_unwrap(dst)
        dst = (!(r.attr_buf).equal?(dst)) ? r.attr_buf : dst
        status = r.attr_result.get_status
        if ((status).equal?(Status::CLOSED))
          do_closure
          return r
        end
        hs_status = r.attr_result.get_handshake_status
        if (!(hs_status).equal?(HandshakeStatus::FINISHED) && !(hs_status).equal?(HandshakeStatus::NOT_HANDSHAKING))
          do_handshake(hs_status)
        end
      end
      dst.flip
      return r
    end
    
    typesig { [] }
    # we've received a close notify. Need to call wrap to send
    # the response
    def do_closure
      begin
        @handshaking.lock
        tmp = allocate(BufType::APPLICATION)
        r = nil
        begin
          tmp.clear
          tmp.flip
          r = @wrapper.wrap_and_send_x(tmp, true)
        end while (!(r.attr_result.get_status).equal?(Status::CLOSED))
      ensure
        @handshaking.unlock
      end
    end
    
    typesig { [HandshakeStatus] }
    # do the (complete) handshake after acquiring the handshake lock.
    # If two threads call this at the same time, then we depend
    # on the wrapper methods being idempotent. eg. if wrapAndSend()
    # is called with no data to send then there must be no problem
    def do_handshake(hs_status)
      begin
        @handshaking.lock
        tmp = allocate(BufType::APPLICATION)
        while (!(hs_status).equal?(HandshakeStatus::FINISHED) && !(hs_status).equal?(HandshakeStatus::NOT_HANDSHAKING))
          r = nil
          case (hs_status)
          # fall thru - call wrap again
          when NEED_TASK
            task = nil
            while (!((task = @engine.get_delegated_task)).nil?)
              # run in current thread, because we are already
              # running an external Executor
              task.run
            end
            tmp.clear
            tmp.flip
            r = @wrapper.wrap_and_send(tmp)
          when NEED_WRAP
            tmp.clear
            tmp.flip
            r = @wrapper.wrap_and_send(tmp)
          when NEED_UNWRAP
            tmp.clear
            r = @wrapper.recv_and_unwrap(tmp)
            if (!(r.attr_buf).equal?(tmp))
              tmp = r.attr_buf
            end
            raise AssertError if not ((tmp.position).equal?(0))
          end
          hs_status = r.attr_result.get_handshake_status
        end
      ensure
        @handshaking.unlock
      end
    end
    
    class_module.module_eval {
      # 
      # represents an SSL input stream. Multiple https requests can
      # be sent over one stream. closing this stream causes an SSL close
      # input.
      const_set_lazy(:InputStream) { Class.new(Java::Io::InputStream) do
        extend LocalClass
        include_class_members SSLStreams
        
        attr_accessor :bbuf
        alias_method :attr_bbuf, :bbuf
        undef_method :bbuf
        alias_method :attr_bbuf=, :bbuf=
        undef_method :bbuf=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        # this stream eof
        attr_accessor :eof
        alias_method :attr_eof, :eof
        undef_method :eof
        alias_method :attr_eof=, :eof=
        undef_method :eof=
        
        attr_accessor :need_data
        alias_method :attr_need_data, :need_data
        undef_method :need_data
        alias_method :attr_need_data=, :need_data=
        undef_method :need_data=
        
        typesig { [] }
        def initialize
          @bbuf = nil
          @closed = false
          @eof = false
          @need_data = false
          @single = nil
          super()
          @closed = false
          @eof = false
          @need_data = true
          @single = Array.typed(::Java::Byte).new(1) { 0 }
          @bbuf = allocate(BufType::APPLICATION)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(buf, off, len)
          if (@closed)
            raise IOException.new("SSL stream is closed")
          end
          if (@eof)
            return 0
          end
          available = 0
          if (!@need_data)
            available = @bbuf.remaining
            @need_data = ((available).equal?(0))
          end
          if (@need_data)
            @bbuf.clear
            r = recv_data(@bbuf)
            @bbuf = (r.attr_buf).equal?(@bbuf) ? @bbuf : r.attr_buf
            if (((available = @bbuf.remaining)).equal?(0))
              @eof = true
              return 0
            else
              @need_data = false
            end
          end
          # copy as much as possible from buf into users buf
          if (len > available)
            len = available
          end
          @bbuf.get(buf, off, len)
          return len
        end
        
        typesig { [] }
        def available
          return @bbuf.remaining
        end
        
        typesig { [] }
        def mark_supported
          return false
          # not possible with SSLEngine
        end
        
        typesig { [] }
        def reset
          raise IOException.new("mark/reset not supported")
        end
        
        typesig { [::Java::Long] }
        def skip(s)
          n = RJava.cast_to_int(s)
          if (@closed)
            raise IOException.new("SSL stream is closed")
          end
          if (@eof)
            return 0
          end
          ret = n
          while (n > 0)
            if (@bbuf.remaining >= n)
              @bbuf.position(@bbuf.position + n)
              return ret
            else
              n -= @bbuf.remaining
              @bbuf.clear
              r = recv_data(@bbuf)
              @bbuf = (r.attr_buf).equal?(@bbuf) ? @bbuf : r.attr_buf
            end
          end
          return ret
          # not reached
        end
        
        typesig { [] }
        # 
        # close the SSL connection. All data must have been consumed
        # before this is called. Otherwise an exception will be thrown.
        # [Note. May need to revisit this. not quite the normal close() symantics
        def close
          @eof = true
          self.attr_engine.close_inbound
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read(buf)
          return read(buf, 0, buf.attr_length)
        end
        
        attr_accessor :single
        alias_method :attr_single, :single
        undef_method :single
        alias_method :attr_single=, :single=
        undef_method :single=
        
        typesig { [] }
        def read
          n = read(@single, 0, 1)
          if ((n).equal?(0))
            return -1
          else
            return @single[0] & 0xff
          end
        end
        
        private
        alias_method :initialize__input_stream, :initialize
      end }
      
      # 
      # represents an SSL output stream. plain text data written to this stream
      # is encrypted by the stream. Multiple HTTPS responses can be sent on
      # one stream. closing this stream initiates an SSL closure
      const_set_lazy(:OutputStream) { Class.new(Java::Io::OutputStream) do
        extend LocalClass
        include_class_members SSLStreams
        
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        attr_accessor :closed
        alias_method :attr_closed, :closed
        undef_method :closed
        alias_method :attr_closed=, :closed=
        undef_method :closed=
        
        attr_accessor :single
        alias_method :attr_single, :single
        undef_method :single
        alias_method :attr_single=, :single=
        undef_method :single=
        
        typesig { [] }
        def initialize
          @buf = nil
          @closed = false
          @single = nil
          super()
          @closed = false
          @single = Array.typed(::Java::Byte).new(1) { 0 }
          @buf = allocate(BufType::APPLICATION)
        end
        
        typesig { [::Java::Int] }
        def write(b)
          @single[0] = b
          write(@single, 0, 1)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def write(b)
          write(b, 0, b.attr_length)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def write(b, off, len)
          if (@closed)
            raise IOException.new("output stream is closed")
          end
          while (len > 0)
            l = len > @buf.capacity ? @buf.capacity : len
            @buf.clear
            @buf.put(b, off, l)
            len -= l
            off += l
            @buf.flip
            r = send_data(@buf)
            if ((r.attr_result.get_status).equal?(Status::CLOSED))
              @closed = true
              if (len > 0)
                raise IOException.new("output stream is closed")
              end
            end
          end
        end
        
        typesig { [] }
        def flush
          # no-op
        end
        
        typesig { [] }
        def close
          r = nil
          self.attr_engine.close_outbound
          @closed = true
          stat = HandshakeStatus::NEED_WRAP
          @buf.clear
          while ((stat).equal?(HandshakeStatus::NEED_WRAP))
            r = self.attr_wrapper.wrap_and_send(@buf)
            stat = r.attr_result.get_handshake_status
          end
          raise AssertError if not ((r.attr_result.get_status).equal?(Status::CLOSED))
        end
        
        private
        alias_method :initialize__output_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__sslstreams, :initialize
  end
  
end

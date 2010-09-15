require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ServerImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Net
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Security
      include ::Java::Nio::Channels
      include ::Java::Util
      include ::Java::Util::Concurrent
      include_const ::Java::Util::Logging, :Logger
      include_const ::Java::Util::Logging, :Level
      include ::Javax::Net::Ssl
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # Provides implementation for both HTTP and HTTPS
  class ServerImpl 
    include_class_members ServerImplImports
    include TimeSource
    
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    attr_accessor :https
    alias_method :attr_https, :https
    undef_method :https
    alias_method :attr_https=, :https=
    undef_method :https=
    
    attr_accessor :executor
    alias_method :attr_executor, :executor
    undef_method :executor
    alias_method :attr_executor=, :executor=
    undef_method :executor=
    
    attr_accessor :https_config
    alias_method :attr_https_config, :https_config
    undef_method :https_config
    alias_method :attr_https_config=, :https_config=
    undef_method :https_config=
    
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    attr_accessor :contexts
    alias_method :attr_contexts, :contexts
    undef_method :contexts
    alias_method :attr_contexts=, :contexts=
    undef_method :contexts=
    
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    attr_accessor :schan
    alias_method :attr_schan, :schan
    undef_method :schan
    alias_method :attr_schan=, :schan=
    undef_method :schan=
    
    attr_accessor :selector
    alias_method :attr_selector, :selector
    undef_method :selector
    alias_method :attr_selector=, :selector=
    undef_method :selector=
    
    attr_accessor :listener_key
    alias_method :attr_listener_key, :listener_key
    undef_method :listener_key
    alias_method :attr_listener_key=, :listener_key=
    undef_method :listener_key=
    
    attr_accessor :idle_connections
    alias_method :attr_idle_connections, :idle_connections
    undef_method :idle_connections
    alias_method :attr_idle_connections=, :idle_connections=
    undef_method :idle_connections=
    
    attr_accessor :all_connections
    alias_method :attr_all_connections, :all_connections
    undef_method :all_connections
    alias_method :attr_all_connections=, :all_connections=
    undef_method :all_connections=
    
    attr_accessor :events
    alias_method :attr_events, :events
    undef_method :events
    alias_method :attr_events=, :events=
    undef_method :events=
    
    attr_accessor :lolock
    alias_method :attr_lolock, :lolock
    undef_method :lolock
    alias_method :attr_lolock=, :lolock=
    undef_method :lolock=
    
    attr_accessor :finished
    alias_method :attr_finished, :finished
    undef_method :finished
    alias_method :attr_finished=, :finished=
    undef_method :finished=
    
    attr_accessor :terminating
    alias_method :attr_terminating, :terminating
    undef_method :terminating
    alias_method :attr_terminating=, :terminating=
    undef_method :terminating=
    
    attr_accessor :bound
    alias_method :attr_bound, :bound
    undef_method :bound
    alias_method :attr_bound=, :bound=
    undef_method :bound=
    
    attr_accessor :started
    alias_method :attr_started, :started
    undef_method :started
    alias_method :attr_started=, :started=
    undef_method :started=
    
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    # current time
    attr_accessor :ticks
    alias_method :attr_ticks, :ticks
    undef_method :ticks
    alias_method :attr_ticks=, :ticks=
    undef_method :ticks=
    
    # number of clock ticks since server started
    attr_accessor :wrapper
    alias_method :attr_wrapper, :wrapper
    undef_method :wrapper
    alias_method :attr_wrapper=, :wrapper=
    undef_method :wrapper=
    
    class_module.module_eval {
      const_set_lazy(:CLOCK_TICK) { ServerConfig.get_clock_tick }
      const_attr_reader  :CLOCK_TICK
      
      const_set_lazy(:IDLE_INTERVAL) { ServerConfig.get_idle_interval }
      const_attr_reader  :IDLE_INTERVAL
      
      const_set_lazy(:MAX_IDLE_CONNECTIONS) { ServerConfig.get_max_idle_connections }
      const_attr_reader  :MAX_IDLE_CONNECTIONS
    }
    
    attr_accessor :timer
    alias_method :attr_timer, :timer
    undef_method :timer
    alias_method :attr_timer=, :timer=
    undef_method :timer=
    
    attr_accessor :logger
    alias_method :attr_logger, :logger
    undef_method :logger
    alias_method :attr_logger=, :logger=
    undef_method :logger=
    
    typesig { [HttpServer, String, InetSocketAddress, ::Java::Int] }
    def initialize(wrapper, protocol, addr, backlog)
      @protocol = nil
      @https = false
      @executor = nil
      @https_config = nil
      @ssl_context = nil
      @contexts = nil
      @address = nil
      @schan = nil
      @selector = nil
      @listener_key = nil
      @idle_connections = nil
      @all_connections = nil
      @events = nil
      @lolock = Object.new
      @finished = false
      @terminating = false
      @bound = false
      @started = false
      @time = 0
      @ticks = 0
      @wrapper = nil
      @timer = nil
      @logger = nil
      @dispatcher = nil
      @exchange_count = 0
      @protocol = protocol
      @wrapper = wrapper
      @logger = Logger.get_logger("com.sun.net.httpserver")
      @https = protocol.equals_ignore_case("https")
      @address = addr
      @contexts = ContextList.new
      @schan = ServerSocketChannel.open
      if (!(addr).nil?)
        socket_ = @schan.socket
        socket_.bind(addr, backlog)
        @bound = true
      end
      @selector = Selector.open
      @schan.configure_blocking(false)
      @listener_key = @schan.register(@selector, SelectionKey::OP_ACCEPT)
      @dispatcher = Dispatcher.new_local(self)
      @idle_connections = Collections.synchronized_set(HashSet.new)
      @all_connections = Collections.synchronized_set(HashSet.new)
      @time = System.current_time_millis
      @timer = Timer.new("server-timer", true)
      @timer.schedule(ServerTimerTask.new_local(self), CLOCK_TICK, CLOCK_TICK)
      @events = LinkedList.new
      @logger.config("HttpServer created " + protocol + " " + RJava.cast_to_string(addr))
    end
    
    typesig { [InetSocketAddress, ::Java::Int] }
    def bind(addr, backlog)
      if (@bound)
        raise BindException.new("HttpServer already bound")
      end
      if ((addr).nil?)
        raise NullPointerException.new("null address")
      end
      socket_ = @schan.socket
      socket_.bind(addr, backlog)
      @bound = true
    end
    
    typesig { [] }
    def start
      if (!@bound || @started || @finished)
        raise IllegalStateException.new("server in wrong state")
      end
      if ((@executor).nil?)
        @executor = DefaultExecutor.new
      end
      t = JavaThread.new(@dispatcher)
      @started = true
      t.start
    end
    
    typesig { [Executor] }
    def set_executor(executor)
      if (@started)
        raise IllegalStateException.new("server already started")
      end
      @executor = executor
    end
    
    class_module.module_eval {
      const_set_lazy(:DefaultExecutor) { Class.new do
        include_class_members ServerImpl
        include Executor
        
        typesig { [class_self::Runnable] }
        def execute(task)
          task.run
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__default_executor, :initialize
      end }
    }
    
    typesig { [] }
    def get_executor
      return @executor
    end
    
    typesig { [HttpsConfigurator] }
    def set_https_configurator(config_)
      if ((config_).nil?)
        raise NullPointerException.new("null HttpsConfigurator")
      end
      if (@started)
        raise IllegalStateException.new("server already started")
      end
      @https_config = config_
      @ssl_context = config_.get_sslcontext
    end
    
    typesig { [] }
    def get_https_configurator
      return @https_config
    end
    
    typesig { [::Java::Int] }
    def stop(delay)
      if (delay < 0)
        raise IllegalArgumentException.new("negative delay parameter")
      end
      @terminating = true
      begin
        @schan.close
      rescue IOException => e
      end
      @selector.wakeup
      latest = System.current_time_millis + delay * 1000
      while (System.current_time_millis < latest)
        delay
        if (@finished)
          break
        end
      end
      @finished = true
      @selector.wakeup
      synchronized((@all_connections)) do
        @all_connections.each do |c|
          c.close
        end
      end
      @all_connections.clear
      @idle_connections.clear
      @timer.cancel
    end
    
    attr_accessor :dispatcher
    alias_method :attr_dispatcher, :dispatcher
    undef_method :dispatcher
    alias_method :attr_dispatcher=, :dispatcher=
    undef_method :dispatcher=
    
    typesig { [String, HttpHandler] }
    def create_context(path, handler)
      synchronized(self) do
        if ((handler).nil? || (path).nil?)
          raise NullPointerException.new("null handler, or path parameter")
        end
        context = HttpContextImpl.new(@protocol, path, handler, self)
        @contexts.add(context)
        @logger.config("context created: " + path)
        return context
      end
    end
    
    typesig { [String] }
    def create_context(path)
      synchronized(self) do
        if ((path).nil?)
          raise NullPointerException.new("null path parameter")
        end
        context = HttpContextImpl.new(@protocol, path, nil, self)
        @contexts.add(context)
        @logger.config("context created: " + path)
        return context
      end
    end
    
    typesig { [String] }
    def remove_context(path)
      synchronized(self) do
        if ((path).nil?)
          raise NullPointerException.new("null path parameter")
        end
        @contexts.remove(@protocol, path)
        @logger.config("context removed: " + path)
      end
    end
    
    typesig { [HttpContext] }
    def remove_context(context)
      synchronized(self) do
        if (!(context.is_a?(HttpContextImpl)))
          raise IllegalArgumentException.new("wrong HttpContext type")
        end
        @contexts.remove(context)
        @logger.config("context removed: " + RJava.cast_to_string(context.get_path))
      end
    end
    
    typesig { [] }
    def get_address
      return @schan.socket.get_local_socket_address
    end
    
    typesig { [] }
    def get_selector
      return @selector
    end
    
    typesig { [Event] }
    def add_event(r)
      synchronized((@lolock)) do
        @events.add(r)
        @selector.wakeup
      end
    end
    
    typesig { [] }
    def result_size
      synchronized((@lolock)) do
        return @events.size
      end
    end
    
    class_module.module_eval {
      # main server listener task
      const_set_lazy(:Dispatcher) { Class.new do
        local_class_in ServerImpl
        include_class_members ServerImpl
        include Runnable
        
        typesig { [class_self::Event] }
        def handle_event(r)
          t = r.attr_exchange
          c = t.get_connection
          begin
            if (r.is_a?(self.class::WriteFinishedEvent))
              exchanges = end_exchange
              if (self.attr_terminating && (exchanges).equal?(0))
                self.attr_finished = true
              end
              chan = c.get_channel
              is = t.get_original_input_stream
              if (!is.is_eof)
                t.attr_close = true
              end
              if (t.attr_close || self.attr_idle_connections.size >= MAX_IDLE_CONNECTIONS)
                c.close
                self.attr_all_connections.remove(c)
              else
                if (is.is_data_buffered)
                  # don't re-enable the interestops, just handle it
                  handle(c.get_channel, c)
                else
                  # re-enable interestops
                  key = c.get_selection_key
                  if (key.is_valid)
                    key.interest_ops(key.interest_ops | SelectionKey::OP_READ)
                  end
                  c.attr_time = get_time + IDLE_INTERVAL
                  self.attr_idle_connections.add(c)
                end
              end
            end
          rescue self.class::IOException => e
            self.attr_logger.log(Level::FINER, "Dispatcher (1)", e)
            c.close
          end
        end
        
        typesig { [] }
        def run
          while (!self.attr_finished)
            begin
              # process the events list first
              while (result_size > 0)
                r = nil
                synchronized((self.attr_lolock)) do
                  r = self.attr_events.remove(0)
                  handle_event(r)
                end
              end
              self.attr_selector.select(1000)
              # process the selected list now
              selected = self.attr_selector.selected_keys
              iter = selected.iterator
              while (iter.has_next)
                key = iter.next_
                iter.remove
                if ((key == self.attr_listener_key))
                  if (self.attr_terminating)
                    next
                  end
                  chan = self.attr_schan.accept
                  if ((chan).nil?)
                    next
                    # cancel something ?
                  end
                  chan.configure_blocking(false)
                  newkey = chan.register(self.attr_selector, SelectionKey::OP_READ)
                  c = self.class::HttpConnection.new
                  c.attr_selection_key = newkey
                  c.set_channel(chan)
                  newkey.attach(c)
                  self.attr_all_connections.add(c)
                else
                  begin
                    if (key.is_readable)
                      closed = false
                      chan = key.channel
                      conn = key.attachment
                      # interestOps will be restored at end of read
                      key.interest_ops(0)
                      handle(chan, conn)
                    else
                      raise AssertError if not (false)
                    end
                  rescue self.class::IOException => e
                    conn = key.attachment
                    self.attr_logger.log(Level::FINER, "Dispatcher (2)", e)
                    conn.close
                  end
                end
              end
            rescue self.class::CancelledKeyException => e
              self.attr_logger.log(Level::FINER, "Dispatcher (3)", e)
            rescue self.class::IOException => e
              self.attr_logger.log(Level::FINER, "Dispatcher (4)", e)
            rescue self.class::JavaException => e
              self.attr_logger.log(Level::FINER, "Dispatcher (7)", e)
            end
          end
        end
        
        typesig { [class_self::SocketChannel, class_self::HttpConnection] }
        def handle(chan, conn)
          begin
            t = self.class::Exchange.new(chan, self.attr_protocol, conn)
            self.attr_executor.execute(t)
          rescue self.class::HttpError => e1
            self.attr_logger.log(Level::FINER, "Dispatcher (5)", e1)
            conn.close
          rescue self.class::IOException => e
            self.attr_logger.log(Level::FINER, "Dispatcher (6)", e)
            conn.close
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__dispatcher, :initialize
      end }
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= ServerConfig.debug_enabled
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [String] }
      def dprint(s)
        synchronized(self) do
          if (self.attr_debug)
            System.out.println(s)
          end
        end
      end
      
      typesig { [JavaException] }
      def dprint(e)
        synchronized(self) do
          if (self.attr_debug)
            System.out.println(e)
            e.print_stack_trace
          end
        end
      end
    }
    
    typesig { [] }
    def get_logger
      return @logger
    end
    
    class_module.module_eval {
      # per exchange task
      const_set_lazy(:Exchange) { Class.new do
        local_class_in ServerImpl
        include_class_members ServerImpl
        include Runnable
        
        attr_accessor :chan
        alias_method :attr_chan, :chan
        undef_method :chan
        alias_method :attr_chan=, :chan=
        undef_method :chan=
        
        attr_accessor :connection
        alias_method :attr_connection, :connection
        undef_method :connection
        alias_method :attr_connection=, :connection=
        undef_method :connection=
        
        attr_accessor :context
        alias_method :attr_context, :context
        undef_method :context
        alias_method :attr_context=, :context=
        undef_method :context=
        
        attr_accessor :rawin
        alias_method :attr_rawin, :rawin
        undef_method :rawin
        alias_method :attr_rawin=, :rawin=
        undef_method :rawin=
        
        attr_accessor :rawout
        alias_method :attr_rawout, :rawout
        undef_method :rawout
        alias_method :attr_rawout=, :rawout=
        undef_method :rawout=
        
        attr_accessor :protocol
        alias_method :attr_protocol, :protocol
        undef_method :protocol
        alias_method :attr_protocol=, :protocol=
        undef_method :protocol=
        
        attr_accessor :tx
        alias_method :attr_tx, :tx
        undef_method :tx
        alias_method :attr_tx=, :tx=
        undef_method :tx=
        
        attr_accessor :ctx
        alias_method :attr_ctx, :ctx
        undef_method :ctx
        alias_method :attr_ctx=, :ctx=
        undef_method :ctx=
        
        attr_accessor :rejected
        alias_method :attr_rejected, :rejected
        undef_method :rejected
        alias_method :attr_rejected=, :rejected=
        undef_method :rejected=
        
        typesig { [class_self::SocketChannel, String, class_self::HttpConnection] }
        def initialize(chan, protocol, conn)
          @chan = nil
          @connection = nil
          @context = nil
          @rawin = nil
          @rawout = nil
          @protocol = nil
          @tx = nil
          @ctx = nil
          @rejected = false
          @chan = chan
          @connection = conn
          @protocol = protocol
        end
        
        typesig { [] }
        def run
          # context will be null for new connections
          @context = @connection.get_http_context
          newconnection = false
          engine = nil
          request_line = nil
          ssl_streams = nil
          begin
            if (!(@context).nil?)
              @rawin = @connection.get_input_stream
              @rawout = @connection.get_raw_output_stream
              newconnection = false
            else
              # figure out what kind of connection this is
              newconnection = true
              if (self.attr_https)
                if ((self.attr_ssl_context).nil?)
                  self.attr_logger.warning("SSL connection received. No https contxt created")
                  raise self.class::HttpError.new("No SSL context established")
                end
                ssl_streams = self.class::SSLStreams.new(@local_class_parent, self.attr_ssl_context, @chan)
                @rawin = ssl_streams.get_input_stream
                @rawout = ssl_streams.get_output_stream
                engine = ssl_streams.get_sslengine
                @connection.attr_ssl_streams = ssl_streams
              else
                @rawin = self.class::BufferedInputStream.new(self.class::Request::ReadStream.new(@local_class_parent, @chan))
                @rawout = self.class::Request::WriteStream.new(@local_class_parent, @chan)
              end
              @connection.attr_raw = @rawin
              @connection.attr_rawout = @rawout
            end
            req = self.class::Request.new(@rawin, @rawout)
            request_line = RJava.cast_to_string(req.request_line)
            if ((request_line).nil?)
              # connection closed
              @connection.close
              return
            end
            space = request_line.index_of(Character.new(?\s.ord))
            if ((space).equal?(-1))
              reject(Code::HTTP_BAD_REQUEST, request_line, "Bad request line")
              return
            end
            method = request_line.substring(0, space)
            start = space + 1
            space = request_line.index_of(Character.new(?\s.ord), start)
            if ((space).equal?(-1))
              reject(Code::HTTP_BAD_REQUEST, request_line, "Bad request line")
              return
            end
            uri_str = request_line.substring(start, space)
            uri = self.class::URI.new(uri_str)
            start = space + 1
            version = request_line.substring(start)
            headers_ = req.headers
            s = headers_.get_first("Transfer-encoding")
            clen = 0
            if (!(s).nil? && s.equals_ignore_case("chunked"))
              clen = -1
            else
              s = RJava.cast_to_string(headers_.get_first("Content-Length"))
              if (!(s).nil?)
                clen = JavaInteger.parse_int(s)
              end
            end
            @ctx = self.attr_contexts.find_context(@protocol, uri.get_path)
            if ((@ctx).nil?)
              reject(Code::HTTP_NOT_FOUND, request_line, "No context found for request")
              return
            end
            @connection.set_context(@ctx)
            if ((@ctx.get_handler).nil?)
              reject(Code::HTTP_INTERNAL_ERROR, request_line, "No handler for context")
              return
            end
            @tx = self.class::ExchangeImpl.new(method, uri, req, clen, @connection)
            chdr = headers_.get_first("Connection")
            rheaders = @tx.get_response_headers
            if (!(chdr).nil? && chdr.equals_ignore_case("close"))
              @tx.attr_close = true
            end
            if (version.equals_ignore_case("http/1.0"))
              @tx.attr_http10 = true
              if ((chdr).nil?)
                @tx.attr_close = true
                rheaders.set("Connection", "close")
              else
                if (chdr.equals_ignore_case("keep-alive"))
                  rheaders.set("Connection", "keep-alive")
                  idle = RJava.cast_to_int(ServerConfig.get_idle_interval) / 1000
                  max = RJava.cast_to_int(ServerConfig.get_max_idle_connections)
                  val = "timeout=" + RJava.cast_to_string(idle) + ", max=" + RJava.cast_to_string(max)
                  rheaders.set("Keep-Alive", val)
                end
              end
            end
            if (newconnection)
              @connection.set_parameters(@rawin, @rawout, @chan, engine, ssl_streams, self.attr_ssl_context, @protocol, @ctx, @rawin)
            end
            # check if client sent an Expect 100 Continue.
            # In that case, need to send an interim response.
            # In future API may be modified to allow app to
            # be involved in this process.
            exp = headers_.get_first("Expect")
            if (!(exp).nil? && exp.equals_ignore_case("100-continue"))
              log_reply(100, request_line, nil)
              send_reply(Code::HTTP_CONTINUE, false, nil)
            end
            # uf is the list of filters seen/set by the user.
            # sf is the list of filters established internally
            # and which are not visible to the user. uc and sc
            # are the corresponding Filter.Chains.
            # They are linked together by a LinkHandler
            # so that they can both be invoked in one call.
            sf = @ctx.get_system_filters
            uf = @ctx.get_filters
            sc = self.class::Filter::Chain.new(sf, @ctx.get_handler)
            uc = self.class::Filter::Chain.new(uf, self.class::LinkHandler.new_local(self, sc))
            # set up the two stream references
            @tx.get_request_body
            @tx.get_response_body
            if (self.attr_https)
              uc.do_filter(self.class::HttpsExchangeImpl.new(@tx))
            else
              uc.do_filter(self.class::HttpExchangeImpl.new(@tx))
            end
          rescue self.class::IOException => e1
            self.attr_logger.log(Level::FINER, "ServerImpl.Exchange (1)", e1)
            @connection.close
          rescue self.class::NumberFormatException => e3
            reject(Code::HTTP_BAD_REQUEST, request_line, "NumberFormatException thrown")
          rescue self.class::URISyntaxException => e
            reject(Code::HTTP_BAD_REQUEST, request_line, "URISyntaxException thrown")
          rescue self.class::JavaException => e4
            self.attr_logger.log(Level::FINER, "ServerImpl.Exchange (2)", e4)
            @connection.close
          end
        end
        
        class_module.module_eval {
          # used to link to 2 or more Filter.Chains together
          const_set_lazy(:LinkHandler) { Class.new do
            local_class_in Exchange
            include_class_members Exchange
            include class_self::HttpHandler
            
            attr_accessor :next_chain
            alias_method :attr_next_chain, :next_chain
            undef_method :next_chain
            alias_method :attr_next_chain=, :next_chain=
            undef_method :next_chain=
            
            typesig { [class_self::Filter::Chain] }
            def initialize(next_chain)
              @next_chain = nil
              @next_chain = next_chain
            end
            
            typesig { [class_self::HttpExchange] }
            def handle(exchange)
              @next_chain.do_filter(exchange)
            end
            
            private
            alias_method :initialize__link_handler, :initialize
          end }
        }
        
        typesig { [::Java::Int, String, String] }
        def reject(code, request_str, message)
          @rejected = true
          log_reply(code, request_str, message)
          send_reply(code, true, "<h1>" + RJava.cast_to_string(code) + RJava.cast_to_string(Code.msg(code)) + "</h1>" + message)
        end
        
        typesig { [::Java::Int, ::Java::Boolean, String] }
        def send_reply(code, close_now, text)
          begin
            s = "HTTP/1.1 " + RJava.cast_to_string(code) + RJava.cast_to_string(Code.msg(code)) + "\r\n"
            if (!(text).nil? && !(text.length).equal?(0))
              s = s + "Content-Length: " + RJava.cast_to_string(text.length) + "\r\n"
              s = s + "Content-Type: text/html\r\n"
            else
              s = s + "Content-Length: 0\r\n"
              text = ""
            end
            if (close_now)
              s = s + "Connection: close\r\n"
            end
            s = s + "\r\n" + text
            b = s.get_bytes("ISO8859_1")
            @rawout.write(b)
            @rawout.flush
            if (close_now)
              @connection.close
            end
          rescue self.class::IOException => e
            self.attr_logger.log(Level::FINER, "ServerImpl.sendReply", e)
            @connection.close
          end
        end
        
        private
        alias_method :initialize__exchange, :initialize
      end }
    }
    
    typesig { [::Java::Int, String, String] }
    def log_reply(code, request_str, text)
      if ((text).nil?)
        text = ""
      end
      message = request_str + " [" + RJava.cast_to_string(code) + " " + RJava.cast_to_string(Code.msg(code)) + "] (" + text + ")"
      @logger.fine(message)
    end
    
    typesig { [] }
    def get_ticks
      return @ticks
    end
    
    typesig { [] }
    def get_time
      return @time
    end
    
    typesig { [] }
    def delay
      JavaThread.yield_
      begin
        JavaThread.sleep(200)
      rescue InterruptedException => e
      end
    end
    
    attr_accessor :exchange_count
    alias_method :attr_exchange_count, :exchange_count
    undef_method :exchange_count
    alias_method :attr_exchange_count=, :exchange_count=
    undef_method :exchange_count=
    
    typesig { [] }
    def start_exchange
      synchronized(self) do
        @exchange_count += 1
      end
    end
    
    typesig { [] }
    def end_exchange
      synchronized(self) do
        @exchange_count -= 1
        raise AssertError if not (@exchange_count >= 0)
        return @exchange_count
      end
    end
    
    typesig { [] }
    def get_wrapper
      return @wrapper
    end
    
    class_module.module_eval {
      # TimerTask run every CLOCK_TICK ms
      const_set_lazy(:ServerTimerTask) { Class.new(TimerTask) do
        local_class_in ServerImpl
        include_class_members ServerImpl
        
        typesig { [] }
        def run
          to_close = self.class::LinkedList.new
          self.attr_time = System.current_time_millis
          self.attr_ticks += 1
          synchronized((self.attr_idle_connections)) do
            self.attr_idle_connections.each do |c|
              if (c.attr_time <= self.attr_time)
                to_close.add(c)
              end
            end
            to_close.each do |c|
              self.attr_idle_connections.remove(c)
              self.attr_all_connections.remove(c)
              c.close
            end
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__server_timer_task, :initialize
      end }
    }
    
    private
    alias_method :initialize__server_impl, :initialize
  end
  
end

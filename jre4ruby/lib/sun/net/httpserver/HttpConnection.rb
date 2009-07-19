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
  module HttpConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Javax::Net::Ssl
      include ::Java::Nio::Channels
      include_const ::Java::Util::Logging, :Logger
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # encapsulates all the connection specific state for a HTTP/S connection
  # one of these is hung from the selector attachment and is used to locate
  # everything from that.
  class HttpConnection 
    include_class_members HttpConnectionImports
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    attr_accessor :engine
    alias_method :attr_engine, :engine
    undef_method :engine
    alias_method :attr_engine=, :engine=
    undef_method :engine=
    
    attr_accessor :ssl_context
    alias_method :attr_ssl_context, :ssl_context
    undef_method :ssl_context
    alias_method :attr_ssl_context=, :ssl_context=
    undef_method :ssl_context=
    
    attr_accessor :ssl_streams
    alias_method :attr_ssl_streams, :ssl_streams
    undef_method :ssl_streams
    alias_method :attr_ssl_streams=, :ssl_streams=
    undef_method :ssl_streams=
    
    # high level streams returned to application
    attr_accessor :i
    alias_method :attr_i, :i
    undef_method :i
    alias_method :attr_i=, :i=
    undef_method :i=
    
    # low level stream that sits directly over channel
    attr_accessor :raw
    alias_method :attr_raw, :raw
    undef_method :raw
    alias_method :attr_raw=, :raw=
    undef_method :raw=
    
    attr_accessor :rawout
    alias_method :attr_rawout, :rawout
    undef_method :rawout
    alias_method :attr_rawout=, :rawout=
    undef_method :rawout=
    
    attr_accessor :chan
    alias_method :attr_chan, :chan
    undef_method :chan
    alias_method :attr_chan=, :chan=
    undef_method :chan=
    
    attr_accessor :selection_key
    alias_method :attr_selection_key, :selection_key
    undef_method :selection_key
    alias_method :attr_selection_key=, :selection_key=
    undef_method :selection_key=
    
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    attr_accessor :remaining
    alias_method :attr_remaining, :remaining
    undef_method :remaining
    alias_method :attr_remaining=, :remaining=
    undef_method :remaining=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :logger
    alias_method :attr_logger, :logger
    undef_method :logger
    alias_method :attr_logger=, :logger=
    undef_method :logger=
    
    typesig { [] }
    def to_s
      s = nil
      if (!(@chan).nil?)
        s = (@chan.to_s).to_s
      end
      return s
    end
    
    typesig { [] }
    def initialize
      @context = nil
      @engine = nil
      @ssl_context = nil
      @ssl_streams = nil
      @i = nil
      @raw = nil
      @rawout = nil
      @chan = nil
      @selection_key = nil
      @protocol = nil
      @time = 0
      @remaining = 0
      @closed = false
      @logger = nil
    end
    
    typesig { [SocketChannel] }
    def set_channel(c)
      @chan = c
    end
    
    typesig { [HttpContextImpl] }
    def set_context(ctx)
      @context = ctx
    end
    
    typesig { [InputStream, OutputStream, SocketChannel, SSLEngine, SSLStreams, SSLContext, String, HttpContextImpl, InputStream] }
    def set_parameters(in_, rawout, chan, engine, ssl_streams, ssl_context, protocol, context, raw)
      @context = context
      @i = in_
      @rawout = rawout
      @raw = raw
      @protocol = protocol
      @engine = engine
      @chan = chan
      @ssl_context = ssl_context
      @ssl_streams = ssl_streams
      @logger = context.get_logger
    end
    
    typesig { [] }
    def get_channel
      return @chan
    end
    
    typesig { [] }
    def close
      synchronized(self) do
        if (@closed)
          return
        end
        @closed = true
        if (!(@logger).nil? && !(@chan).nil?)
          @logger.finest("Closing connection: " + (@chan.to_s).to_s)
        end
        if (!@chan.is_open)
          ServerImpl.dprint("Channel already closed")
          return
        end
        begin
          # need to ensure temporary selectors are closed
          if (!(@raw).nil?)
            @raw.close
          end
        rescue IOException => e
          ServerImpl.dprint(e)
        end
        begin
          if (!(@rawout).nil?)
            @rawout.close
          end
        rescue IOException => e
          ServerImpl.dprint(e)
        end
        begin
          if (!(@ssl_streams).nil?)
            @ssl_streams.close
          end
        rescue IOException => e
          ServerImpl.dprint(e)
        end
        begin
          @chan.close
        rescue IOException => e
          ServerImpl.dprint(e)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # remaining is the number of bytes left on the lowest level inputstream
    # after the exchange is finished
    def set_remaining(r)
      @remaining = r
    end
    
    typesig { [] }
    def get_remaining
      return @remaining
    end
    
    typesig { [] }
    def get_selection_key
      return @selection_key
    end
    
    typesig { [] }
    def get_input_stream
      return @i
    end
    
    typesig { [] }
    def get_raw_output_stream
      return @rawout
    end
    
    typesig { [] }
    def get_protocol
      return @protocol
    end
    
    typesig { [] }
    def get_sslengine
      return @engine
    end
    
    typesig { [] }
    def get_sslcontext
      return @ssl_context
    end
    
    typesig { [] }
    def get_http_context
      return @context
    end
    
    private
    alias_method :initialize__http_connection, :initialize
  end
  
end

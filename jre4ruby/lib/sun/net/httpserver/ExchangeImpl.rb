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
  module ExchangeImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Net
      include ::Javax::Net::Ssl
      include ::Java::Util
      include ::Java::Text
      include_const ::Sun::Net::Www, :MessageHeader
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class ExchangeImpl 
    include_class_members ExchangeImplImports
    
    attr_accessor :req_hdrs
    alias_method :attr_req_hdrs, :req_hdrs
    undef_method :req_hdrs
    alias_method :attr_req_hdrs=, :req_hdrs=
    undef_method :req_hdrs=
    
    attr_accessor :rsp_hdrs
    alias_method :attr_rsp_hdrs, :rsp_hdrs
    undef_method :rsp_hdrs
    alias_method :attr_rsp_hdrs=, :rsp_hdrs=
    undef_method :rsp_hdrs=
    
    attr_accessor :req
    alias_method :attr_req, :req
    undef_method :req
    alias_method :attr_req=, :req=
    undef_method :req=
    
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    attr_accessor :uri
    alias_method :attr_uri, :uri
    undef_method :uri
    alias_method :attr_uri=, :uri=
    undef_method :uri=
    
    attr_accessor :connection
    alias_method :attr_connection, :connection
    undef_method :connection
    alias_method :attr_connection=, :connection=
    undef_method :connection=
    
    attr_accessor :req_content_len
    alias_method :attr_req_content_len, :req_content_len
    undef_method :req_content_len
    alias_method :attr_req_content_len=, :req_content_len=
    undef_method :req_content_len=
    
    attr_accessor :rsp_content_len
    alias_method :attr_rsp_content_len, :rsp_content_len
    undef_method :rsp_content_len
    alias_method :attr_rsp_content_len=, :rsp_content_len=
    undef_method :rsp_content_len=
    
    # raw streams which access the socket directly
    attr_accessor :ris
    alias_method :attr_ris, :ris
    undef_method :ris
    alias_method :attr_ris=, :ris=
    undef_method :ris=
    
    attr_accessor :ros
    alias_method :attr_ros, :ros
    undef_method :ros
    alias_method :attr_ros=, :ros=
    undef_method :ros=
    
    attr_accessor :thread
    alias_method :attr_thread, :thread
    undef_method :thread
    alias_method :attr_thread=, :thread=
    undef_method :thread=
    
    # close the underlying connection when this exchange finished
    attr_accessor :close
    alias_method :attr_close, :close
    undef_method :close
    alias_method :attr_close=, :close=
    undef_method :close=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :http10
    alias_method :attr_http10, :http10
    undef_method :http10
    alias_method :attr_http10=, :http10=
    undef_method :http10=
    
    class_module.module_eval {
      # for formatting the Date: header
      
      def tz
        defined?(@@tz) ? @@tz : @@tz= nil
      end
      alias_method :attr_tz, :tz
      
      def tz=(value)
        @@tz = value
      end
      alias_method :attr_tz=, :tz=
      
      
      def df
        defined?(@@df) ? @@df : @@df= nil
      end
      alias_method :attr_df, :df
      
      def df=(value)
        @@df = value
      end
      alias_method :attr_df=, :df=
      
      when_class_loaded do
        pattern = "EEE, dd MMM yyyy HH:mm:ss zzz"
        self.attr_tz = TimeZone.get_time_zone("GMT")
        self.attr_df = SimpleDateFormat.new(pattern, Locale::US)
        self.attr_df.set_time_zone(self.attr_tz)
      end
    }
    
    # streams which take care of the HTTP protocol framing
    # and are passed up to higher layers
    attr_accessor :uis
    alias_method :attr_uis, :uis
    undef_method :uis
    alias_method :attr_uis=, :uis=
    undef_method :uis=
    
    attr_accessor :uos
    alias_method :attr_uos, :uos
    undef_method :uos
    alias_method :attr_uos=, :uos=
    undef_method :uos=
    
    attr_accessor :uis_orig
    alias_method :attr_uis_orig, :uis_orig
    undef_method :uis_orig
    alias_method :attr_uis_orig=, :uis_orig=
    undef_method :uis_orig=
    
    # uis may have be a user supplied wrapper
    attr_accessor :uos_orig
    alias_method :attr_uos_orig, :uos_orig
    undef_method :uos_orig
    alias_method :attr_uos_orig=, :uos_orig=
    undef_method :uos_orig=
    
    attr_accessor :sent_headers
    alias_method :attr_sent_headers, :sent_headers
    undef_method :sent_headers
    alias_method :attr_sent_headers=, :sent_headers=
    undef_method :sent_headers=
    
    # true after response headers sent
    attr_accessor :attributes
    alias_method :attr_attributes, :attributes
    undef_method :attributes
    alias_method :attr_attributes=, :attributes=
    undef_method :attributes=
    
    attr_accessor :rcode
    alias_method :attr_rcode, :rcode
    undef_method :rcode
    alias_method :attr_rcode=, :rcode=
    undef_method :rcode=
    
    attr_accessor :principal
    alias_method :attr_principal, :principal
    undef_method :principal
    alias_method :attr_principal=, :principal=
    undef_method :principal=
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    typesig { [String, URI, Request, ::Java::Int, HttpConnection] }
    def initialize(m, u, req, len, connection)
      @req_hdrs = nil
      @rsp_hdrs = nil
      @req = nil
      @method = nil
      @uri = nil
      @connection = nil
      @req_content_len = 0
      @rsp_content_len = 0
      @ris = nil
      @ros = nil
      @thread = nil
      @close = false
      @closed = false
      @http10 = false
      @uis = nil
      @uos = nil
      @uis_orig = nil
      @uos_orig = nil
      @sent_headers = false
      @attributes = nil
      @rcode = -1
      @principal = nil
      @server = nil
      @rspbuf = Array.typed(::Java::Byte).new(128) { 0 }
      @req = req
      @req_hdrs = req.headers
      @rsp_hdrs = Headers.new
      @method = m
      @uri = u
      @connection = connection
      @req_content_len = len
      # ros only used for headers, body written directly to stream
      @ros = req.output_stream
      @ris = req.input_stream
      @server = get_server_impl
      @server.start_exchange
    end
    
    typesig { [] }
    def get_request_headers
      return UnmodifiableHeaders.new(@req_hdrs)
    end
    
    typesig { [] }
    def get_response_headers
      return @rsp_hdrs
    end
    
    typesig { [] }
    def get_request_uri
      return @uri
    end
    
    typesig { [] }
    def get_request_method
      return @method
    end
    
    typesig { [] }
    def get_http_context
      return @connection.get_http_context
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      @closed = true
      # close the underlying connection if,
      # a) the streams not set up yet, no response can be sent, or
      # b) if the wrapper output stream is not set up, or
      # c) if the close of the input/outpu stream fails
      begin
        if ((@uis_orig).nil? || (@uos).nil?)
          @connection.close
          return
        end
        if (!@uos_orig.is_wrapped)
          @connection.close
          return
        end
        if (!@uis_orig.is_closed)
          @uis_orig.close
        end
        @uos.close
      rescue IOException => e
        @connection.close
      end
    end
    
    typesig { [] }
    def get_request_body
      if (!(@uis).nil?)
        return @uis
      end
      if ((@req_content_len).equal?(-1))
        @uis_orig = ChunkedInputStream.new(self, @ris)
        @uis = @uis_orig
      else
        @uis_orig = FixedLengthInputStream.new(self, @ris, @req_content_len)
        @uis = @uis_orig
      end
      return @uis
    end
    
    typesig { [] }
    def get_original_input_stream
      return @uis_orig
    end
    
    typesig { [] }
    def get_response_code
      return @rcode
    end
    
    typesig { [] }
    def get_response_body
      # TODO. Change spec to remove restriction below. Filters
      # cannot work with this restriction
      # 
      # if (!sentHeaders) {
      # throw new IllegalStateException ("headers not sent");
      # }
      if ((@uos).nil?)
        @uos_orig = PlaceholderOutputStream.new(nil)
        @uos = @uos_orig
      end
      return @uos
    end
    
    typesig { [] }
    # returns the place holder stream, which is the stream
    # returned from the 1st call to getResponseBody()
    # The "real" ouputstream is then placed inside this
    def get_placeholder_response_body
      get_response_body
      return @uos_orig
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def send_response_headers(r_code, content_len)
      if (@sent_headers)
        raise IOException.new("headers already sent")
      end
      @rcode = r_code
      status_line = "HTTP/1.1 " + (r_code).to_s + (Code.msg(r_code)).to_s + "\r\n"
      tmpout = BufferedOutputStream.new(@ros)
      o = get_placeholder_response_body
      tmpout.write(bytes(status_line, 0), 0, status_line.length)
      no_content_to_send = false # assume there is content
      @rsp_hdrs.set("Date", self.attr_df.format(Date.new))
      if ((content_len).equal?(0))
        if (@http10)
          o.set_wrapped_stream(UndefLengthOutputStream.new(self, @ros))
          @close = true
        else
          @rsp_hdrs.set("Transfer-encoding", "chunked")
          o.set_wrapped_stream(ChunkedOutputStream.new(self, @ros))
        end
      else
        if ((content_len).equal?(-1))
          no_content_to_send = true
          content_len = 0
        end
        # content len might already be set, eg to implement HEAD resp
        if ((@rsp_hdrs.get_first("Content-length")).nil?)
          @rsp_hdrs.set("Content-length", Long.to_s(content_len))
        end
        o.set_wrapped_stream(FixedLengthOutputStream.new(self, @ros, content_len))
      end
      write(@rsp_hdrs, tmpout)
      @rsp_content_len = content_len
      tmpout.flush
      tmpout = nil
      @sent_headers = true
      if (no_content_to_send)
        e = WriteFinishedEvent.new(self)
        @server.add_event(e)
        @closed = true
      end
      @server.log_reply(r_code, @req.request_line, nil)
    end
    
    typesig { [Headers, OutputStream] }
    def write(map, os)
      entries = map.entry_set
      entries.each do |entry|
        key = entry.get_key
        buf = nil
        values = entry.get_value
        values.each do |val|
          i = key.length
          buf = bytes(key, 2)
          buf[((i += 1) - 1)] = Character.new(?:.ord)
          buf[((i += 1) - 1)] = Character.new(?\s.ord)
          os.write(buf, 0, i)
          buf = bytes(val, 2)
          i = val.length
          buf[((i += 1) - 1)] = Character.new(?\r.ord)
          buf[((i += 1) - 1)] = Character.new(?\n.ord)
          os.write(buf, 0, i)
        end
      end
      os.write(Character.new(?\r.ord))
      os.write(Character.new(?\n.ord))
    end
    
    attr_accessor :rspbuf
    alias_method :attr_rspbuf, :rspbuf
    undef_method :rspbuf
    alias_method :attr_rspbuf=, :rspbuf=
    undef_method :rspbuf=
    
    typesig { [String, ::Java::Int] }
    # used by bytes()
    # 
    # convert string to byte[], using rspbuf
    # Make sure that at least "extra" bytes are free at end
    # of rspbuf. Reallocate rspbuf if not big enough.
    # caller must check return value to see if rspbuf moved
    def bytes(s, extra)
      slen = s.length
      if (slen + extra > @rspbuf.attr_length)
        diff = slen + extra - @rspbuf.attr_length
        @rspbuf = Array.typed(::Java::Byte).new(2 * (@rspbuf.attr_length + diff)) { 0 }
      end
      c = s.to_char_array
      i = 0
      while i < c.attr_length
        @rspbuf[i] = c[i]
        i += 1
      end
      return @rspbuf
    end
    
    typesig { [] }
    def get_remote_address
      s = @connection.get_channel.socket
      ia = s.get_inet_address
      port = s.get_port
      return InetSocketAddress.new(ia, port)
    end
    
    typesig { [] }
    def get_local_address
      s = @connection.get_channel.socket
      ia = s.get_local_address
      port = s.get_local_port
      return InetSocketAddress.new(ia, port)
    end
    
    typesig { [] }
    def get_protocol
      reqline = @req.request_line
      index = reqline.last_index_of(Character.new(?\s.ord))
      return reqline.substring(index + 1)
    end
    
    typesig { [] }
    def get_sslsession
      e = @connection.get_sslengine
      if ((e).nil?)
        return nil
      end
      return e.get_session
    end
    
    typesig { [String] }
    def get_attribute(name)
      if ((name).nil?)
        raise NullPointerException.new("null name parameter")
      end
      if ((@attributes).nil?)
        @attributes = get_http_context.get_attributes
      end
      return @attributes.get(name)
    end
    
    typesig { [String, Object] }
    def set_attribute(name, value)
      if ((name).nil?)
        raise NullPointerException.new("null name parameter")
      end
      if ((@attributes).nil?)
        @attributes = get_http_context.get_attributes
      end
      @attributes.put(name, value)
    end
    
    typesig { [InputStream, OutputStream] }
    def set_streams(i, o)
      raise AssertError if not (!(@uis).nil?)
      if (!(i).nil?)
        @uis = i
      end
      if (!(o).nil?)
        @uos = o
      end
    end
    
    typesig { [] }
    # PP
    def get_connection
      return @connection
    end
    
    typesig { [] }
    def get_server_impl
      return get_http_context.get_server_impl
    end
    
    typesig { [] }
    def get_principal
      return @principal
    end
    
    typesig { [HttpPrincipal] }
    def set_principal(principal)
      @principal = principal
    end
    
    class_module.module_eval {
      typesig { [HttpExchange] }
      def get(t)
        if (t.is_a?(HttpExchangeImpl))
          return (t).get_exchange_impl
        else
          raise AssertError if not (t.is_a?(HttpsExchangeImpl))
          return (t).get_exchange_impl
        end
      end
    }
    
    private
    alias_method :initialize__exchange_impl, :initialize
  end
  
  # An OutputStream which wraps another stream
  # which is supplied either at creation time, or sometime later.
  # If a caller/user tries to write to this stream before
  # the wrapped stream has been provided, then an IOException will
  # be thrown.
  class PlaceholderOutputStream < Java::Io::OutputStream
    include_class_members ExchangeImplImports
    
    attr_accessor :wrapped
    alias_method :attr_wrapped, :wrapped
    undef_method :wrapped
    alias_method :attr_wrapped=, :wrapped=
    undef_method :wrapped=
    
    typesig { [OutputStream] }
    def initialize(os)
      @wrapped = nil
      super()
      @wrapped = os
    end
    
    typesig { [OutputStream] }
    def set_wrapped_stream(os)
      @wrapped = os
    end
    
    typesig { [] }
    def is_wrapped
      return !(@wrapped).nil?
    end
    
    typesig { [] }
    def check_wrap
      if ((@wrapped).nil?)
        raise IOException.new("response headers not sent yet")
      end
    end
    
    typesig { [::Java::Int] }
    def write(b)
      check_wrap
      @wrapped.write(b)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def write(b)
      check_wrap
      @wrapped.write(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      check_wrap
      @wrapped.write(b, off, len)
    end
    
    typesig { [] }
    def flush
      check_wrap
      @wrapped.flush
    end
    
    typesig { [] }
    def close
      check_wrap
      @wrapped.close
    end
    
    private
    alias_method :initialize__placeholder_output_stream, :initialize
  end
  
end

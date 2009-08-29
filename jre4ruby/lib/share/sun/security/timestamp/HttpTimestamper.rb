require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Timestamp
  module HttpTimestamperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Timestamp
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :DataOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :HttpURLConnection
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaSet
      include ::Sun::Security::Pkcs
    }
  end
  
  # A timestamper that communicates with a Timestamping Authority (TSA)
  # over HTTP.
  # It supports the Time-Stamp Protocol defined in:
  # <a href="http://www.ietf.org/rfc/rfc3161.txt">RFC 3161</a>.
  # 
  # @since 1.5
  # @author Vincent Ryan
  class HttpTimestamper 
    include_class_members HttpTimestamperImports
    include Timestamper
    
    class_module.module_eval {
      const_set_lazy(:CONNECT_TIMEOUT) { 15000 }
      const_attr_reader  :CONNECT_TIMEOUT
      
      # 15 seconds
      # The MIME type for a timestamp query
      const_set_lazy(:TS_QUERY_MIME_TYPE) { "application/timestamp-query" }
      const_attr_reader  :TS_QUERY_MIME_TYPE
      
      # The MIME type for a timestamp reply
      const_set_lazy(:TS_REPLY_MIME_TYPE) { "application/timestamp-reply" }
      const_attr_reader  :TS_REPLY_MIME_TYPE
      
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
    }
    
    # HTTP URL identifying the location of the TSA
    attr_accessor :tsa_url
    alias_method :attr_tsa_url, :tsa_url
    undef_method :tsa_url
    alias_method :attr_tsa_url=, :tsa_url=
    undef_method :tsa_url=
    
    typesig { [String] }
    # Creates a timestamper that connects to the specified TSA.
    # 
    # @param tsa The location of the TSA. It must be an HTTP URL.
    def initialize(tsa_url)
      @tsa_url = nil
      @tsa_url = tsa_url
    end
    
    typesig { [TSRequest] }
    # Connects to the TSA and requests a timestamp.
    # 
    # @param tsQuery The timestamp query.
    # @return The result of the timestamp query.
    # @throws IOException The exception is thrown if a problem occurs while
    # communicating with the TSA.
    def generate_timestamp(ts_query)
      connection = URL.new(@tsa_url).open_connection
      connection.set_do_output(true)
      connection.set_use_caches(false) # ignore cache
      connection.set_request_property("Content-Type", TS_QUERY_MIME_TYPE)
      connection.set_request_method("POST")
      # Avoids the "hang" when a proxy is required but none has been set.
      connection.set_connect_timeout(CONNECT_TIMEOUT)
      if (DEBUG)
        headers = connection.get_request_properties.entry_set
        System.out.println(RJava.cast_to_string(connection.get_request_method) + " " + @tsa_url + " HTTP/1.1")
        i = headers.iterator
        while i.has_next
          System.out.println("  " + RJava.cast_to_string(i.next_))
        end
        System.out.println
      end
      connection.connect # No HTTP authentication is performed
      # Send the request
      output = nil
      begin
        output = DataOutputStream.new(connection.get_output_stream)
        request = ts_query.encode
        output.write(request, 0, request.attr_length)
        output.flush
        if (DEBUG)
          System.out.println("sent timestamp query (length=" + RJava.cast_to_string(request.attr_length) + ")")
        end
      ensure
        if (!(output).nil?)
          output.close
        end
      end
      # Receive the reply
      input = nil
      reply_buffer = nil
      begin
        input = BufferedInputStream.new(connection.get_input_stream)
        if (DEBUG)
          header = connection.get_header_field(0)
          System.out.println(header)
          i = 1
          while (!((header = RJava.cast_to_string(connection.get_header_field(i)))).nil?)
            key = connection.get_header_field_key(i)
            System.out.println("  " + RJava.cast_to_string((((key).nil?) ? "" : key + ": ")) + header)
            i += 1
          end
          System.out.println
        end
        content_length = connection.get_content_length
        if ((content_length).equal?(-1))
          content_length = JavaInteger::MAX_VALUE
        end
        verify_mime_type(connection.get_content_type)
        reply_buffer = Array.typed(::Java::Byte).new(content_length) { 0 }
        total = 0
        count = 0
        while (!(count).equal?(-1) && total < content_length)
          count = input.read(reply_buffer, total, reply_buffer.attr_length - total)
          total += count
        end
        if (DEBUG)
          System.out.println("received timestamp response (length=" + RJava.cast_to_string(reply_buffer.attr_length) + ")")
        end
      ensure
        if (!(input).nil?)
          input.close
        end
      end
      return TSResponse.new(reply_buffer)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Checks that the MIME content type is a timestamp reply.
      # 
      # @param contentType The MIME content type to be checked.
      # @throws IOException The exception is thrown if a mismatch occurs.
      def verify_mime_type(content_type)
        if (!TS_REPLY_MIME_TYPE.equals_ignore_case(content_type))
          raise IOException.new("MIME Content-Type is not " + TS_REPLY_MIME_TYPE)
        end
      end
    }
    
    private
    alias_method :initialize__http_timestamper, :initialize
  end
  
end

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
  module HttpsExchangeImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Net
      include ::Javax::Net::Ssl
      include ::Java::Util
      include_const ::Sun::Net::Www, :MessageHeader
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class HttpsExchangeImpl < HttpsExchangeImplImports.const_get :HttpsExchange
    include_class_members HttpsExchangeImplImports
    
    attr_accessor :impl
    alias_method :attr_impl, :impl
    undef_method :impl
    alias_method :attr_impl=, :impl=
    undef_method :impl=
    
    typesig { [ExchangeImpl] }
    def initialize(impl)
      @impl = nil
      super()
      @impl = impl
    end
    
    typesig { [] }
    def get_request_headers
      return @impl.get_request_headers
    end
    
    typesig { [] }
    def get_response_headers
      return @impl.get_response_headers
    end
    
    typesig { [] }
    def get_request_uri
      return @impl.get_request_uri
    end
    
    typesig { [] }
    def get_request_method
      return @impl.get_request_method
    end
    
    typesig { [] }
    def get_http_context
      return @impl.get_http_context
    end
    
    typesig { [] }
    def close
      @impl.close
    end
    
    typesig { [] }
    def get_request_body
      return @impl.get_request_body
    end
    
    typesig { [] }
    def get_response_code
      return @impl.get_response_code
    end
    
    typesig { [] }
    def get_response_body
      return @impl.get_response_body
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def send_response_headers(r_code, content_len)
      @impl.send_response_headers(r_code, content_len)
    end
    
    typesig { [] }
    def get_remote_address
      return @impl.get_remote_address
    end
    
    typesig { [] }
    def get_local_address
      return @impl.get_local_address
    end
    
    typesig { [] }
    def get_protocol
      return @impl.get_protocol
    end
    
    typesig { [] }
    def get_sslsession
      return @impl.get_sslsession
    end
    
    typesig { [String] }
    def get_attribute(name)
      return @impl.get_attribute(name)
    end
    
    typesig { [String, Object] }
    def set_attribute(name, value)
      @impl.set_attribute(name, value)
    end
    
    typesig { [InputStream, OutputStream] }
    def set_streams(i, o)
      @impl.set_streams(i, o)
    end
    
    typesig { [] }
    def get_principal
      return @impl.get_principal
    end
    
    typesig { [] }
    def get_exchange_impl
      return @impl
    end
    
    private
    alias_method :initialize__https_exchange_impl, :initialize
  end
  
end

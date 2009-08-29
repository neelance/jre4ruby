require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Https
  module DelegateHttpsURLConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Https
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class was introduced to provide an additional level of
  # abstraction between javax.net.ssl.HttpURLConnection and
  # com.sun.net.ssl.HttpURLConnection objects. <p>
  # 
  # javax.net.ssl.HttpURLConnection is used in the new sun.net version
  # of protocol implementation (this one)
  # com.sun.net.ssl.HttpURLConnection is used in the com.sun version.
  class DelegateHttpsURLConnection < DelegateHttpsURLConnectionImports.const_get :AbstractDelegateHttpsURLConnection
    include_class_members DelegateHttpsURLConnectionImports
    
    # we need a reference to the HttpsURLConnection to get
    # the properties set there
    # we also need it to be public so that it can be referenced
    # from sun.net.www.protocol.http.HttpURLConnection
    # this is for ResponseCache.put(URI, URLConnection)
    # second parameter needs to be cast to javax.net.ssl.HttpsURLConnection
    # instead of AbstractDelegateHttpsURLConnection
    attr_accessor :https_urlconnection
    alias_method :attr_https_urlconnection, :https_urlconnection
    undef_method :https_urlconnection
    alias_method :attr_https_urlconnection=, :https_urlconnection=
    undef_method :https_urlconnection=
    
    typesig { [URL, Sun::Net::Www::Protocol::Http::Handler, Javax::Net::Ssl::HttpsURLConnection] }
    def initialize(url, handler, https_urlconnection)
      initialize__delegate_https_urlconnection(url, nil, handler, https_urlconnection)
    end
    
    typesig { [URL, Proxy, Sun::Net::Www::Protocol::Http::Handler, Javax::Net::Ssl::HttpsURLConnection] }
    def initialize(url, p, handler, https_urlconnection)
      @https_urlconnection = nil
      super(url, p, handler)
      @https_urlconnection = https_urlconnection
    end
    
    typesig { [] }
    def get_sslsocket_factory
      return @https_urlconnection.get_sslsocket_factory
    end
    
    typesig { [] }
    def get_hostname_verifier
      return @https_urlconnection.get_hostname_verifier
    end
    
    typesig { [] }
    # Called by layered delegator's finalize() method to handle closing
    # the underlying object.
    def dispose
      AbstractDelegateHttpsURLConnection.instance_method(:finalize).bind(self).call
    end
    
    private
    alias_method :initialize__delegate_https_urlconnection, :initialize
  end
  
end

require "rjava"

# Copyright 1995-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Gopher
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Gopher
      include ::Java::Io
      include ::Java::Util
      include_const ::Sun::Net, :NetworkClient
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Security, :Permission
      include_const ::Sun::Net::Www::Protocol::Http, :HttpURLConnection
    }
  end
  
  # A class to handle the gopher protocol.
  class Handler < Java::Net::URLStreamHandler
    include_class_members HandlerImports
    
    typesig { [] }
    def get_default_port
      return 70
    end
    
    typesig { [URL] }
    def open_connection(u)
      return open_connection(u, nil)
    end
    
    typesig { [URL, Proxy] }
    def open_connection(u, p)
      # if set for proxy usage then go through the http code to get
      # the url connection.
      if ((p).nil? && GopherClient.get_use_gopher_proxy)
        host = GopherClient.get_gopher_proxy_host
        if (!(host).nil?)
          saddr = InetSocketAddress.create_unresolved(host, GopherClient.get_gopher_proxy_port)
          p = Proxy.new(Proxy::Type::HTTP, saddr)
        end
      end
      if (!(p).nil?)
        return HttpURLConnection.new(u, p)
      end
      return GopherURLConnection.new(u)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
  class GopherURLConnection < Sun::Net::Www::URLConnection
    include_class_members HandlerImports
    
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    typesig { [URL] }
    def initialize(u)
      @permission = nil
      super(u)
    end
    
    typesig { [] }
    def connect
    end
    
    typesig { [] }
    def get_input_stream
      return GopherClient.new(self).open_stream(self.attr_url)
    end
    
    typesig { [] }
    def get_permission
      if ((@permission).nil?)
        port = self.attr_url.get_port
        port = port < 0 ? 70 : port
        host = RJava.cast_to_string(self.attr_url.get_host) + ":" + RJava.cast_to_string(self.attr_url.get_port)
        @permission = SocketPermission.new(host, "connect")
      end
      return @permission
    end
    
    private
    alias_method :initialize__gopher_urlconnection, :initialize
  end
  
end

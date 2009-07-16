require "rjava"

# 
# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HttpServerImplImports
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
      include ::Javax::Net::Ssl
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class HttpServerImpl < HttpServerImplImports.const_get :HttpServer
    include_class_members HttpServerImplImports
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    typesig { [] }
    def initialize
      initialize__http_server_impl(InetSocketAddress.new(80), 0)
    end
    
    typesig { [InetSocketAddress, ::Java::Int] }
    def initialize(addr, backlog)
      @server = nil
      super()
      @server = ServerImpl.new(self, "http", addr, backlog)
    end
    
    typesig { [InetSocketAddress, ::Java::Int] }
    def bind(addr, backlog)
      @server.bind(addr, backlog)
    end
    
    typesig { [] }
    def start
      @server.start
    end
    
    typesig { [Executor] }
    def set_executor(executor)
      @server.set_executor(executor)
    end
    
    typesig { [] }
    def get_executor
      return @server.get_executor
    end
    
    typesig { [::Java::Int] }
    def stop(delay)
      @server.stop(delay)
    end
    
    typesig { [String, HttpHandler] }
    def create_context(path, handler)
      return @server.create_context(path, handler)
    end
    
    typesig { [String] }
    def create_context(path)
      return @server.create_context(path)
    end
    
    typesig { [String] }
    def remove_context(path)
      @server.remove_context(path)
    end
    
    typesig { [HttpContext] }
    def remove_context(context)
      @server.remove_context(context)
    end
    
    typesig { [] }
    def get_address
      return @server.get_address
    end
    
    private
    alias_method :initialize__http_server_impl, :initialize
  end
  
end

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
  module HttpContextImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Util::Logging, :Logger
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # 
  # HttpContext represents a mapping between a protocol (http or https) together with a root URI path
  # to a {@link HttpHandler} which is invoked to handle requests destined
  # for the protocol/path on the associated HttpServer.
  # <p>
  # HttpContext instances are created by {@link HttpServer#createContext(String,String,HttpHandler,Object)}
  # <p>
  class HttpContextImpl < HttpContextImplImports.const_get :HttpContext
    include_class_members HttpContextImplImports
    
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    attr_accessor :attributes
    alias_method :attr_attributes, :attributes
    undef_method :attributes
    alias_method :attr_attributes=, :attributes=
    undef_method :attributes=
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    # system filters, not visible to applications
    attr_accessor :sfilters
    alias_method :attr_sfilters, :sfilters
    undef_method :sfilters
    alias_method :attr_sfilters=, :sfilters=
    undef_method :sfilters=
    
    # user filters, set by applications
    attr_accessor :ufilters
    alias_method :attr_ufilters, :ufilters
    undef_method :ufilters
    alias_method :attr_ufilters=, :ufilters=
    undef_method :ufilters=
    
    attr_accessor :authenticator
    alias_method :attr_authenticator, :authenticator
    undef_method :authenticator
    alias_method :attr_authenticator=, :authenticator=
    undef_method :authenticator=
    
    attr_accessor :authfilter
    alias_method :attr_authfilter, :authfilter
    undef_method :authfilter
    alias_method :attr_authfilter=, :authfilter=
    undef_method :authfilter=
    
    typesig { [String, String, HttpHandler, ServerImpl] }
    # 
    # constructor is package private.
    def initialize(protocol, path, cb, server)
      @path = nil
      @protocol = nil
      @handler = nil
      @attributes = nil
      @server = nil
      @sfilters = nil
      @ufilters = nil
      @authenticator = nil
      @authfilter = nil
      super()
      @attributes = HashMap.new
      @sfilters = LinkedList.new
      @ufilters = LinkedList.new
      if ((path).nil? || (protocol).nil? || path.length < 1 || !(path.char_at(0)).equal?(Character.new(?/.ord)))
        raise IllegalArgumentException.new("Illegal value for path or protocol")
      end
      @protocol = protocol.to_lower_case
      @path = path
      if (!(@protocol == "http") && !(@protocol == "https"))
        raise IllegalArgumentException.new("Illegal value for protocol")
      end
      @handler = cb
      @server = server
      @authfilter = AuthFilter.new(nil)
      @sfilters.add(@authfilter)
    end
    
    typesig { [] }
    # 
    # returns the handler for this context
    # @return the HttpHandler for this context
    def get_handler
      return @handler
    end
    
    typesig { [HttpHandler] }
    def set_handler(h)
      if ((h).nil?)
        raise NullPointerException.new("Null handler parameter")
      end
      if (!(@handler).nil?)
        raise IllegalArgumentException.new("handler already set")
      end
      @handler = h
    end
    
    typesig { [] }
    # 
    # returns the path this context was created with
    # @return this context's path
    def get_path
      return @path
    end
    
    typesig { [] }
    # 
    # returns the server this context was created with
    # @return this context's server
    def get_server
      return @server.get_wrapper
    end
    
    typesig { [] }
    def get_server_impl
      return @server
    end
    
    typesig { [] }
    # 
    # returns the protocol this context was created with
    # @return this context's path
    def get_protocol
      return @protocol
    end
    
    typesig { [] }
    # 
    # returns a mutable Map, which can be used to pass
    # configuration and other data to Filter modules
    # and to the context's exchange handler.
    # <p>
    # Every attribute stored in this Map will be visible to
    # every HttpExchange processed by this context
    def get_attributes
      return @attributes
    end
    
    typesig { [] }
    def get_filters
      return @ufilters
    end
    
    typesig { [] }
    def get_system_filters
      return @sfilters
    end
    
    typesig { [Authenticator] }
    def set_authenticator(auth)
      old = @authenticator
      @authenticator = auth
      @authfilter.set_authenticator(auth)
      return old
    end
    
    typesig { [] }
    def get_authenticator
      return @authenticator
    end
    
    typesig { [] }
    def get_logger
      return @server.get_logger
    end
    
    private
    alias_method :initialize__http_context_impl, :initialize
  end
  
end

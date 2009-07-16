require "rjava"

# 
# Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# -
# HTTP stream opener
module Sun::Net::Www::Protocol::Http
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
    }
  end
  
  # open an http input stream given a URL
  class Handler < Java::Net::URLStreamHandler
    include_class_members HandlerImports
    
    attr_accessor :proxy
    alias_method :attr_proxy, :proxy
    undef_method :proxy
    alias_method :attr_proxy=, :proxy=
    undef_method :proxy=
    
    attr_accessor :proxy_port
    alias_method :attr_proxy_port, :proxy_port
    undef_method :proxy_port
    alias_method :attr_proxy_port=, :proxy_port=
    undef_method :proxy_port=
    
    typesig { [] }
    def get_default_port
      return 80
    end
    
    typesig { [] }
    def initialize
      @proxy = nil
      @proxy_port = 0
      super()
      @proxy = (nil).to_s
      @proxy_port = -1
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(proxy, port)
      @proxy = nil
      @proxy_port = 0
      super()
      @proxy = proxy
      @proxy_port = port
    end
    
    typesig { [URL] }
    def open_connection(u)
      return open_connection(u, nil)
    end
    
    typesig { [URL, Proxy] }
    def open_connection(u, p)
      return HttpURLConnection.new(u, p, self)
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end

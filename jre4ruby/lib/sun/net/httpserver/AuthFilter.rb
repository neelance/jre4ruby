require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AuthFilterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Channels
      include_const ::Sun::Net::Www, :MessageHeader
      include ::Java::Util
      include ::Javax::Security::Auth
      include ::Javax::Security::Auth::Callback
      include ::Javax::Security::Auth::Login
    }
  end
  
  class AuthFilter < AuthFilterImports.const_get :Filter
    include_class_members AuthFilterImports
    
    attr_accessor :authenticator
    alias_method :attr_authenticator, :authenticator
    undef_method :authenticator
    alias_method :attr_authenticator=, :authenticator=
    undef_method :authenticator=
    
    typesig { [Authenticator] }
    def initialize(authenticator)
      @authenticator = nil
      super()
      @authenticator = authenticator
    end
    
    typesig { [] }
    def description
      return "Authentication filter"
    end
    
    typesig { [Authenticator] }
    def set_authenticator(a)
      @authenticator = a
    end
    
    typesig { [HttpExchange] }
    def consume_input(t)
      i = t.get_request_body
      b = Array.typed(::Java::Byte).new(4096) { 0 }
      while (!(i.read(b)).equal?(-1))
      end
      i.close
    end
    
    typesig { [HttpExchange, Filter::Chain] }
    # The filter's implementation, which is invoked by the server
    def do_filter(t, chain)
      if (!(@authenticator).nil?)
        r = @authenticator.authenticate(t)
        if (r.is_a?(Authenticator::Success))
          s = r
          e = ExchangeImpl.get(t)
          e.set_principal(s.get_principal)
          chain.do_filter(t)
        else
          if (r.is_a?(Authenticator::Retry))
            ry = r
            consume_input(t)
            t.send_response_headers(ry.get_response_code, -1)
          else
            if (r.is_a?(Authenticator::Failure))
              f = r
              consume_input(t)
              t.send_response_headers(f.get_response_code, -1)
            end
          end
        end
      else
        chain.do_filter(t)
      end
    end
    
    private
    alias_method :initialize__auth_filter, :initialize
  end
  
end

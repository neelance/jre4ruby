require "rjava"

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
module Sun::Net::Www::Protocol::Http
  module NegotiateCallbackHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :Authenticator
      include_const ::Java::Net, :PasswordAuthentication
      include_const ::Java::Util, :Arrays
      include_const ::Javax::Security::Auth::Callback, :Callback
      include_const ::Javax::Security::Auth::Callback, :CallbackHandler
      include_const ::Javax::Security::Auth::Callback, :NameCallback
      include_const ::Javax::Security::Auth::Callback, :PasswordCallback
      include_const ::Javax::Security::Auth::Callback, :UnsupportedCallbackException
    }
  end
  
  # @since 1.6
  class NegotiateCallbackHandler 
    include_class_members NegotiateCallbackHandlerImports
    include CallbackHandler
    
    attr_accessor :username
    alias_method :attr_username, :username
    undef_method :username
    alias_method :attr_username=, :username=
    undef_method :username=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    typesig { [Array.typed(Callback)] }
    def handle(callbacks)
      i = 0
      while i < callbacks.attr_length
        call_back = callbacks[i]
        if (call_back.is_a?(NameCallback))
          if ((@username).nil?)
            pass_auth = Authenticator.request_password_authentication(nil, nil, 0, nil, nil, "Negotiate")
            @username = RJava.cast_to_string(pass_auth.get_user_name)
            @password = pass_auth.get_password
          end
          name_callback = call_back
          name_callback.set_name(@username)
        else
          if (call_back.is_a?(PasswordCallback))
            password_callback = call_back
            if ((@password).nil?)
              pass_auth = Authenticator.request_password_authentication(nil, nil, 0, nil, nil, "Negotiate")
              @username = RJava.cast_to_string(pass_auth.get_user_name)
              @password = pass_auth.get_password
            end
            password_callback.set_password(@password)
            Arrays.fill(@password, Character.new(?\s.ord))
          else
            raise UnsupportedCallbackException.new(call_back, "Call back not supported")
          end
        end # else
        i += 1
      end # for
    end
    
    typesig { [] }
    def initialize
      @username = nil
      @password = nil
    end
    
    private
    alias_method :initialize__negotiate_callback_handler, :initialize
  end
  
end

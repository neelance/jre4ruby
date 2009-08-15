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
module Java::Net
  module CookieHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # A CookieHandler object provides a callback mechanism to hook up a
  # HTTP state management policy implementation into the HTTP protocol
  # handler. The HTTP state management mechanism specifies a way to
  # create a stateful session with HTTP requests and responses.
  # 
  # <p>A system-wide CookieHandler that to used by the HTTP protocol
  # handler can be registered by doing a
  # CookieHandler.setDefault(CookieHandler). The currently registered
  # CookieHandler can be retrieved by calling
  # CookieHandler.getDefault().
  # 
  # For more information on HTTP state management, see <a
  # href="http://www.ietf.org/rfc/rfc2965.txt""><i>RFC&nbsp;2965: HTTP
  # State Management Mechanism</i></a>
  # 
  # @author Yingxian Wang
  # @since 1.5
  class CookieHandler 
    include_class_members CookieHandlerImports
    
    class_module.module_eval {
      # The system-wide cookie handler that will apply cookies to the
      # request headers and manage cookies from the response headers.
      # 
      # @see setDefault(CookieHandler)
      # @see getDefault()
      
      def cookie_handler
        defined?(@@cookie_handler) ? @@cookie_handler : @@cookie_handler= nil
      end
      alias_method :attr_cookie_handler, :cookie_handler
      
      def cookie_handler=(value)
        @@cookie_handler = value
      end
      alias_method :attr_cookie_handler=, :cookie_handler=
      
      typesig { [] }
      # Gets the system-wide cookie handler.
      # 
      # @return the system-wide cookie handler; A null return means
      # there is no system-wide cookie handler currently set.
      # @throws SecurityException
      # If a security manager has been installed and it denies
      # {@link NetPermission}<tt>("getCookieHandler")</tt>
      # @see #setDefault(CookieHandler)
      def get_default
        synchronized(self) do
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_permission(SecurityConstants::GET_COOKIEHANDLER_PERMISSION)
          end
          return self.attr_cookie_handler
        end
      end
      
      typesig { [CookieHandler] }
      # Sets (or unsets) the system-wide cookie handler.
      # 
      # Note: non-standard http protocol handlers may ignore this setting.
      # 
      # @param cHandler The HTTP cookie handler, or
      # <code>null</code> to unset.
      # @throws SecurityException
      # If a security manager has been installed and it denies
      # {@link NetPermission}<tt>("setCookieHandler")</tt>
      # @see #getDefault()
      def set_default(c_handler)
        synchronized(self) do
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_permission(SecurityConstants::SET_COOKIEHANDLER_PERMISSION)
          end
          self.attr_cookie_handler = c_handler
        end
      end
    }
    
    typesig { [URI, Map] }
    # Gets all the applicable cookies from a cookie cache for the
    # specified uri in the request header.
    # 
    # HTTP protocol implementers should make sure that this method is
    # called after all request headers related to choosing cookies
    # are added, and before the request is sent.
    # 
    # @param uri a <code>URI</code> to send cookies to in a request
    # @param requestHeaders - a Map from request header
    # field names to lists of field values representing
    # the current request headers
    # @return an immutable map from state management headers, with
    # field names "Cookie" or "Cookie2" to a list of
    # cookies containing state information
    # 
    # @throws IOException if an I/O error occurs
    # @throws IllegalArgumentException if either argument is null
    # @see #put(URI, Map)
    def get(uri, request_headers)
      raise NotImplementedError
    end
    
    typesig { [URI, Map] }
    # Sets all the applicable cookies, examples are response header
    # fields that are named Set-Cookie2, present in the response
    # headers into a cookie cache.
    # 
    # @param uri a <code>URI</code> where the cookies come from
    # @param responseHeaders an immutable map from field names to
    # lists of field values representing the response
    # header fields returned
    # @throws  IOException if an I/O error occurs
    # @throws  IllegalArgumentException if either argument is null
    # @see #get(URI, Map)
    def put(uri, response_headers)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__cookie_handler, :initialize
  end
  
end

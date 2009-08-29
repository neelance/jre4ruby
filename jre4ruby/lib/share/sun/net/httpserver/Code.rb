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
  module CodeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
    }
  end
  
  class Code 
    include_class_members CodeImports
    
    class_module.module_eval {
      const_set_lazy(:HTTP_CONTINUE) { 100 }
      const_attr_reader  :HTTP_CONTINUE
      
      const_set_lazy(:HTTP_OK) { 200 }
      const_attr_reader  :HTTP_OK
      
      const_set_lazy(:HTTP_CREATED) { 201 }
      const_attr_reader  :HTTP_CREATED
      
      const_set_lazy(:HTTP_ACCEPTED) { 202 }
      const_attr_reader  :HTTP_ACCEPTED
      
      const_set_lazy(:HTTP_NOT_AUTHORITATIVE) { 203 }
      const_attr_reader  :HTTP_NOT_AUTHORITATIVE
      
      const_set_lazy(:HTTP_NO_CONTENT) { 204 }
      const_attr_reader  :HTTP_NO_CONTENT
      
      const_set_lazy(:HTTP_RESET) { 205 }
      const_attr_reader  :HTTP_RESET
      
      const_set_lazy(:HTTP_PARTIAL) { 206 }
      const_attr_reader  :HTTP_PARTIAL
      
      const_set_lazy(:HTTP_MULT_CHOICE) { 300 }
      const_attr_reader  :HTTP_MULT_CHOICE
      
      const_set_lazy(:HTTP_MOVED_PERM) { 301 }
      const_attr_reader  :HTTP_MOVED_PERM
      
      const_set_lazy(:HTTP_MOVED_TEMP) { 302 }
      const_attr_reader  :HTTP_MOVED_TEMP
      
      const_set_lazy(:HTTP_SEE_OTHER) { 303 }
      const_attr_reader  :HTTP_SEE_OTHER
      
      const_set_lazy(:HTTP_NOT_MODIFIED) { 304 }
      const_attr_reader  :HTTP_NOT_MODIFIED
      
      const_set_lazy(:HTTP_USE_PROXY) { 305 }
      const_attr_reader  :HTTP_USE_PROXY
      
      const_set_lazy(:HTTP_BAD_REQUEST) { 400 }
      const_attr_reader  :HTTP_BAD_REQUEST
      
      const_set_lazy(:HTTP_UNAUTHORIZED) { 401 }
      const_attr_reader  :HTTP_UNAUTHORIZED
      
      const_set_lazy(:HTTP_PAYMENT_REQUIRED) { 402 }
      const_attr_reader  :HTTP_PAYMENT_REQUIRED
      
      const_set_lazy(:HTTP_FORBIDDEN) { 403 }
      const_attr_reader  :HTTP_FORBIDDEN
      
      const_set_lazy(:HTTP_NOT_FOUND) { 404 }
      const_attr_reader  :HTTP_NOT_FOUND
      
      const_set_lazy(:HTTP_BAD_METHOD) { 405 }
      const_attr_reader  :HTTP_BAD_METHOD
      
      const_set_lazy(:HTTP_NOT_ACCEPTABLE) { 406 }
      const_attr_reader  :HTTP_NOT_ACCEPTABLE
      
      const_set_lazy(:HTTP_PROXY_AUTH) { 407 }
      const_attr_reader  :HTTP_PROXY_AUTH
      
      const_set_lazy(:HTTP_CLIENT_TIMEOUT) { 408 }
      const_attr_reader  :HTTP_CLIENT_TIMEOUT
      
      const_set_lazy(:HTTP_CONFLICT) { 409 }
      const_attr_reader  :HTTP_CONFLICT
      
      const_set_lazy(:HTTP_GONE) { 410 }
      const_attr_reader  :HTTP_GONE
      
      const_set_lazy(:HTTP_LENGTH_REQUIRED) { 411 }
      const_attr_reader  :HTTP_LENGTH_REQUIRED
      
      const_set_lazy(:HTTP_PRECON_FAILED) { 412 }
      const_attr_reader  :HTTP_PRECON_FAILED
      
      const_set_lazy(:HTTP_ENTITY_TOO_LARGE) { 413 }
      const_attr_reader  :HTTP_ENTITY_TOO_LARGE
      
      const_set_lazy(:HTTP_REQ_TOO_LONG) { 414 }
      const_attr_reader  :HTTP_REQ_TOO_LONG
      
      const_set_lazy(:HTTP_UNSUPPORTED_TYPE) { 415 }
      const_attr_reader  :HTTP_UNSUPPORTED_TYPE
      
      const_set_lazy(:HTTP_INTERNAL_ERROR) { 500 }
      const_attr_reader  :HTTP_INTERNAL_ERROR
      
      const_set_lazy(:HTTP_NOT_IMPLEMENTED) { 501 }
      const_attr_reader  :HTTP_NOT_IMPLEMENTED
      
      const_set_lazy(:HTTP_BAD_GATEWAY) { 502 }
      const_attr_reader  :HTTP_BAD_GATEWAY
      
      const_set_lazy(:HTTP_UNAVAILABLE) { 503 }
      const_attr_reader  :HTTP_UNAVAILABLE
      
      const_set_lazy(:HTTP_GATEWAY_TIMEOUT) { 504 }
      const_attr_reader  :HTTP_GATEWAY_TIMEOUT
      
      const_set_lazy(:HTTP_VERSION) { 505 }
      const_attr_reader  :HTTP_VERSION
      
      typesig { [::Java::Int] }
      def msg(code)
        case (code)
        when HTTP_OK
          return " OK"
        when HTTP_CONTINUE
          return " Continue"
        when HTTP_CREATED
          return " Created"
        when HTTP_ACCEPTED
          return " Accepted"
        when HTTP_NOT_AUTHORITATIVE
          return " Non-Authoritative Information"
        when HTTP_NO_CONTENT
          return " No Content"
        when HTTP_RESET
          return " Reset Content"
        when HTTP_PARTIAL
          return " Partial Content"
        when HTTP_MULT_CHOICE
          return " Multiple Choices"
        when HTTP_MOVED_PERM
          return " Moved Permanently"
        when HTTP_MOVED_TEMP
          return " Temporary Redirect"
        when HTTP_SEE_OTHER
          return " See Other"
        when HTTP_NOT_MODIFIED
          return " Not Modified"
        when HTTP_USE_PROXY
          return " Use Proxy"
        when HTTP_BAD_REQUEST
          return " Bad Request"
        when HTTP_UNAUTHORIZED
          return " Unauthorized"
        when HTTP_PAYMENT_REQUIRED
          return " Payment Required"
        when HTTP_FORBIDDEN
          return " Forbidden"
        when HTTP_NOT_FOUND
          return " Not Found"
        when HTTP_BAD_METHOD
          return " Method Not Allowed"
        when HTTP_NOT_ACCEPTABLE
          return " Not Acceptable"
        when HTTP_PROXY_AUTH
          return " Proxy Authentication Required"
        when HTTP_CLIENT_TIMEOUT
          return " Request Time-Out"
        when HTTP_CONFLICT
          return " Conflict"
        when HTTP_GONE
          return " Gone"
        when HTTP_LENGTH_REQUIRED
          return " Length Required"
        when HTTP_PRECON_FAILED
          return " Precondition Failed"
        when HTTP_ENTITY_TOO_LARGE
          return " Request Entity Too Large"
        when HTTP_REQ_TOO_LONG
          return " Request-URI Too Large"
        when HTTP_UNSUPPORTED_TYPE
          return " Unsupported Media Type"
        when HTTP_INTERNAL_ERROR
          return " Internal Server Error"
        when HTTP_NOT_IMPLEMENTED
          return " Not Implemented"
        when HTTP_BAD_GATEWAY
          return " Bad Gateway"
        when HTTP_UNAVAILABLE
          return " Service Unavailable"
        when HTTP_GATEWAY_TIMEOUT
          return " Gateway Timeout"
        when HTTP_VERSION
          return " HTTP Version Not Supported"
        else
          return ""
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__code, :initialize
  end
  
end

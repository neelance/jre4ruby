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
module Java::Net
  module CookiePolicyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # CookiePolicy implementations decide which cookies should be accepted
  # and which should be rejected. Three pre-defined policy implementations
  # are provided, namely ACCEPT_ALL, ACCEPT_NONE and ACCEPT_ORIGINAL_SERVER.
  # 
  # <p>See RFC 2965 sec. 3.3 & 7 for more detail.
  # 
  # @author Edward Wang
  # @since 1.6
  module CookiePolicy
    include_class_members CookiePolicyImports
    
    class_module.module_eval {
      const_set_lazy(:ACCEPT_ALL) { # One pre-defined policy which accepts all cookies.
      Class.new(CookiePolicy.class == Class ? CookiePolicy : Object) do
        extend LocalClass
        include_class_members CookiePolicy
        include CookiePolicy if CookiePolicy.class == Module
        
        typesig { [URI, HttpCookie] }
        define_method :should_accept do |uri, cookie|
          return true
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :ACCEPT_ALL
      
      const_set_lazy(:ACCEPT_NONE) { # One pre-defined policy which accepts no cookies.
      Class.new(CookiePolicy.class == Class ? CookiePolicy : Object) do
        extend LocalClass
        include_class_members CookiePolicy
        include CookiePolicy if CookiePolicy.class == Module
        
        typesig { [URI, HttpCookie] }
        define_method :should_accept do |uri, cookie|
          return false
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :ACCEPT_NONE
      
      const_set_lazy(:ACCEPT_ORIGINAL_SERVER) { # One pre-defined policy which only accepts cookies from original server.
      Class.new(CookiePolicy.class == Class ? CookiePolicy : Object) do
        extend LocalClass
        include_class_members CookiePolicy
        include CookiePolicy if CookiePolicy.class == Module
        
        typesig { [URI, HttpCookie] }
        define_method :should_accept do |uri, cookie|
          return HttpCookie.domain_matches(cookie.get_domain, uri.get_host)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :ACCEPT_ORIGINAL_SERVER
    }
    
    typesig { [URI, HttpCookie] }
    # Will be called to see whether or not this cookie should be accepted.
    # 
    # @param uri       the URI to consult accept policy with
    # @param cookie    the HttpCookie object in question
    # @return          <tt>true</tt> if this cookie should be accepted;
    # otherwise, <tt>false</tt>
    def should_accept(uri, cookie)
      raise NotImplementedError
    end
  end
  
end

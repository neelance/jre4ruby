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
  module CookieStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
    }
  end
  
  # A CookieStore object represents a storage for cookie. Can store and retrieve
  # cookies.
  # 
  # <p>{@link CookieManager} will call <tt>CookieStore.add</tt> to save cookies
  # for every incoming HTTP response, and call <tt>CookieStore.get</tt> to
  # retrieve cookie for every outgoing HTTP request. A CookieStore
  # is responsible for removing HttpCookie instances which have expired.
  # 
  # @author Edward Wang
  # @since 1.6
  module CookieStore
    include_class_members CookieStoreImports
    
    typesig { [URI, HttpCookie] }
    # Adds one HTTP cookie to the store. This is called for every
    # incoming HTTP response.
    # 
    # <p>A cookie to store may or may not be associated with an URI. If it
    # is not associated with an URI, the cookie's domain and path attribute
    # will indicate where it comes from. If it is associated with an URI and
    # its domain and path attribute are not speicifed, given URI will indicate
    # where this cookie comes from.
    # 
    # <p>If a cookie corresponding to the given URI already exists,
    # then it is replaced with the new one.
    # 
    # @param uri       the uri this cookie associated with.
    # if <tt>null</tt>, this cookie will not be associated
    # with an URI
    # @param cookie    the cookie to store
    # 
    # @throws NullPointerException if <tt>cookie</tt> is <tt>null</tt>
    # 
    # @see #get
    def add(uri, cookie)
      raise NotImplementedError
    end
    
    typesig { [URI] }
    # Retrieve cookies associated with given URI, or whose domain matches the
    # given URI. Only cookies that have not expired are returned.
    # This is called for every outgoing HTTP request.
    # 
    # @return          an immutable list of HttpCookie,
    # return empty list if no cookies match the given URI
    # 
    # @throws NullPointerException if <tt>uri</tt> is <tt>null</tt>
    # 
    # @see #add
    def get(uri)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get all not-expired cookies in cookie store.
    # 
    # @return          an immutable list of http cookies;
    # return empty list if there's no http cookie in store
    def get_cookies
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get all URIs which identify the cookies in this cookie store.
    # 
    # @return          an immutable list of URIs;
    # return empty list if no cookie in this cookie store
    # is associated with an URI
    def get_uris
      raise NotImplementedError
    end
    
    typesig { [URI, HttpCookie] }
    # Remove a cookie from store.
    # 
    # @param uri       the uri this cookie associated with.
    # if <tt>null</tt>, the cookie to be removed is not associated
    # with an URI when added; if not <tt>null</tt>, the cookie
    # to be removed is associated with the given URI when added.
    # @param cookie    the cookie to remove
    # 
    # @return          <tt>true</tt> if this store contained the specified cookie
    # 
    # @throws NullPointerException if <tt>cookie</tt> is <tt>null</tt>
    def remove(uri, cookie)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Remove all cookies in this cookie store.
    # 
    # @return          <tt>true</tt> if this store changed as a result of the call
    def remove_all
      raise NotImplementedError
    end
  end
  
end

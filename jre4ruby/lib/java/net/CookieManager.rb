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
  module CookieManagerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Io, :IOException
    }
  end
  
  # CookieManager provides a concrete implementation of {@link CookieHandler},
  # which separates the storage of cookies from the policy surrounding accepting
  # and rejecting cookies. A CookieManager is initialized with a {@link CookieStore}
  # which manages storage, and a {@link CookiePolicy} object, which makes
  # policy decisions on cookie acceptance/rejection.
  # 
  # <p> The HTTP cookie management in java.net package looks like:
  # <blockquote>
  # <pre>
  # use
  # CookieHandler <------- HttpURLConnection
  # ^
  # | impl
  # |         use
  # CookieManager -------> CookiePolicy
  # |   use
  # |--------> HttpCookie
  # |              ^
  # |              | use
  # |   use        |
  # |--------> CookieStore
  # ^
  # | impl
  # |
  # Internal in-memory implementation
  # </pre>
  # <ul>
  # <li>
  # CookieHandler is at the core of cookie management. User can call
  # CookieHandler.setDefault to set a concrete CookieHanlder implementation
  # to be used.
  # </li>
  # <li>
  # CookiePolicy.shouldAccept will be called by CookieManager.put to see whether
  # or not one cookie should be accepted and put into cookie store. User can use
  # any of three pre-defined CookiePolicy, namely ACCEPT_ALL, ACCEPT_NONE and
  # ACCEPT_ORIGINAL_SERVER, or user can define his own CookiePolicy implementation
  # and tell CookieManager to use it.
  # </li>
  # <li>
  # CookieStore is the place where any accepted HTTP cookie is stored in.
  # If not specified when created, a CookieManager instance will use an internal
  # in-memory implementation. Or user can implements one and tell CookieManager
  # to use it.
  # </li>
  # <li>
  # Currently, only CookieStore.add(URI, HttpCookie) and CookieStore.get(URI)
  # are used by CookieManager. Others are for completeness and might be needed
  # by a more sophisticated CookieStore implementation, e.g. a NetscapeCookieSotre.
  # </li>
  # </ul>
  # </blockquote>
  # 
  # <p>There're various ways user can hook up his own HTTP cookie management behavior, e.g.
  # <blockquote>
  # <ul>
  # <li>Use CookieHandler.setDefault to set a brand new {@link CookieHandler} implementation
  # <li>Let CookieManager be the default {@link CookieHandler} implementation,
  # but implement user's own {@link CookieStore} and {@link CookiePolicy}
  # and tell default CookieManager to use them:
  # <blockquote><pre>
  # // this should be done at the beginning of an HTTP session
  # CookieHandler.setDefault(new CookieManager(new MyCookieStore(), new MyCookiePolicy()));
  # </pre></blockquote>
  # <li>Let CookieManager be the default {@link CookieHandler} implementation, but
  # use customized {@link CookiePolicy}:
  # <blockquote><pre>
  # // this should be done at the beginning of an HTTP session
  # CookieHandler.setDefault(new CookieManager());
  # // this can be done at any point of an HTTP session
  # ((CookieManager)CookieHandler.getDefault()).setCookiePolicy(new MyCookiePolicy());
  # </pre></blockquote>
  # </ul>
  # </blockquote>
  # 
  # <p>The implementation conforms to RFC 2965, section 3.3.
  # 
  # @author Edward Wang
  # @since 1.6
  class CookieManager < CookieManagerImports.const_get :CookieHandler
    include_class_members CookieManagerImports
    
    # ---------------- Fields --------------
    attr_accessor :policy_callback
    alias_method :attr_policy_callback, :policy_callback
    undef_method :policy_callback
    alias_method :attr_policy_callback=, :policy_callback=
    undef_method :policy_callback=
    
    attr_accessor :cookie_jar
    alias_method :attr_cookie_jar, :cookie_jar
    undef_method :cookie_jar
    alias_method :attr_cookie_jar=, :cookie_jar=
    undef_method :cookie_jar=
    
    typesig { [] }
    # ---------------- Ctors --------------
    # 
    # Create a new cookie manager.
    # 
    # <p>This constructor will create new cookie manager with default
    # cookie store and accept policy. The effect is same as
    # <tt>CookieManager(null, null)</tt>.
    def initialize
      initialize__cookie_manager(nil, nil)
    end
    
    typesig { [CookieStore, CookiePolicy] }
    # Create a new cookie manager with specified cookie store and cookie policy.
    # 
    # @param store     a <tt>CookieStore</tt> to be used by cookie manager.
    # if <tt>null</tt>, cookie manager will use a default one,
    # which is an in-memory CookieStore implmentation.
    # @param cookiePolicy      a <tt>CookiePolicy</tt> instance
    # to be used by cookie manager as policy callback.
    # if <tt>null</tt>, ACCEPT_ORIGINAL_SERVER will
    # be used.
    def initialize(store, cookie_policy)
      @policy_callback = nil
      @cookie_jar = nil
      super()
      @cookie_jar = nil
      # use default cookie policy if not specify one
      @policy_callback = ((cookie_policy).nil?) ? CookiePolicy::ACCEPT_ORIGINAL_SERVER : cookie_policy
      # if not specify CookieStore to use, use default one
      if ((store).nil?)
        @cookie_jar = Sun::Net::Www::Protocol::Http::InMemoryCookieStore.new
      else
        @cookie_jar = store
      end
    end
    
    typesig { [CookiePolicy] }
    # ---------------- Public operations --------------
    # 
    # To set the cookie policy of this cookie manager.
    # 
    # <p> A instance of <tt>CookieManager</tt> will have
    # cookie policy ACCEPT_ORIGINAL_SERVER by default. Users always
    # can call this method to set another cookie policy.
    # 
    # @param cookiePolicy      the cookie policy. Can be <tt>null</tt>, which
    # has no effects on current cookie policy.
    def set_cookie_policy(cookie_policy)
      if (!(cookie_policy).nil?)
        @policy_callback = cookie_policy
      end
    end
    
    typesig { [] }
    # To retrieve current cookie store.
    # 
    # @return  the cookie store currently used by cookie manager.
    def get_cookie_store
      return @cookie_jar
    end
    
    typesig { [URI, Map] }
    def get(uri, request_headers)
      # pre-condition check
      if ((uri).nil? || (request_headers).nil?)
        raise IllegalArgumentException.new("Argument is null")
      end
      cookie_map = Java::Util::HashMap.new
      # if there's no default CookieStore, no way for us to get any cookie
      if ((@cookie_jar).nil?)
        return Collections.unmodifiable_map(cookie_map)
      end
      cookies = Java::Util::ArrayList.new
      @cookie_jar.get(uri).each do |cookie|
        # apply path-matches rule (RFC 2965 sec. 3.3.4)
        if (path_matches(uri.get_path, cookie.get_path))
          cookies.add(cookie)
        end
      end
      # apply sort rule (RFC 2965 sec. 3.3.4)
      cookie_header = sort_by_path(cookies)
      cookie_map.put("Cookie", cookie_header)
      return Collections.unmodifiable_map(cookie_map)
    end
    
    typesig { [URI, Map] }
    def put(uri, response_headers)
      # pre-condition check
      if ((uri).nil? || (response_headers).nil?)
        raise IllegalArgumentException.new("Argument is null")
      end
      # if there's no default CookieStore, no need to remember any cookie
      if ((@cookie_jar).nil?)
        return
      end
      response_headers.key_set.each do |headerKey|
        # RFC 2965 3.2.2, key must be 'Set-Cookie2'
        # we also accept 'Set-Cookie' here for backward compatibility
        if ((header_key).nil? || !(header_key.equals_ignore_case("Set-Cookie2") || header_key.equals_ignore_case("Set-Cookie")))
          next
        end
        response_headers.get(header_key).each do |headerValue|
          begin
            cookies = HttpCookie.parse(header_value)
            cookies.each do |cookie|
              if (should_accept_internal(uri, cookie))
                @cookie_jar.add(uri, cookie)
              end
            end
          rescue IllegalArgumentException => e
            # invalid set-cookie header string
            # no-op
          end
        end
      end
    end
    
    typesig { [URI, HttpCookie] }
    # ---------------- Private operations --------------
    # to determine whether or not accept this cookie
    def should_accept_internal(uri, cookie)
      begin
        return @policy_callback.should_accept(uri, cookie)
      rescue Exception => ignored
        # pretect against malicious callback
        return false
      end
    end
    
    typesig { [String, String] }
    # path-matches algorithm, as defined by RFC 2965
    def path_matches(path, path_to_match_with)
      if ((path).equal?(path_to_match_with))
        return true
      end
      if ((path).nil? || (path_to_match_with).nil?)
        return false
      end
      if (path.starts_with(path_to_match_with))
        return true
      end
      return false
    end
    
    typesig { [JavaList] }
    # sort cookies with respect to their path: those with more specific Path attributes
    # precede those with less specific, as defined in RFC 2965 sec. 3.3.4
    def sort_by_path(cookies)
      Collections.sort(cookies, CookiePathComparator.new)
      cookie_header = Java::Util::ArrayList.new
      cookies.each do |cookie|
        # Netscape cookie spec and RFC 2965 have different format of Cookie
        # header; RFC 2965 requires a leading $Version="1" string while Netscape
        # does not.
        # The workaround here is to add a $Version="1" string in advance
        if ((cookies.index_of(cookie)).equal?(0) && cookie.get_version > 0)
          cookie_header.add("$Version=\"1\"")
        end
        cookie_header.add(cookie.to_s)
      end
      return cookie_header
    end
    
    class_module.module_eval {
      const_set_lazy(:CookiePathComparator) { Class.new do
        include_class_members CookieManager
        include Comparator
        
        typesig { [HttpCookie, HttpCookie] }
        def compare(c1, c2)
          if ((c1).equal?(c2))
            return 0
          end
          if ((c1).nil?)
            return -1
          end
          if ((c2).nil?)
            return 1
          end
          # path rule only applies to the cookies with same name
          if (!(c1.get_name == c2.get_name))
            return 0
          end
          # those with more specific Path attributes precede those with less specific
          if (c1.get_path.starts_with(c2.get_path))
            return -1
          else
            if (c2.get_path.starts_with(c1.get_path))
              return 1
            else
              return 0
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__cookie_path_comparator, :initialize
      end }
    }
    
    private
    alias_method :initialize__cookie_manager, :initialize
  end
  
end

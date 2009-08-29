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
  module InMemoryCookieStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :CookieStore
      include_const ::Java::Net, :HttpCookie
      include_const ::Java::Net, :URISyntaxException
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util::Concurrent::Locks, :ReentrantLock
    }
  end
  
  # A simple in-memory java.net.CookieStore implementation
  # 
  # @author Edward Wang
  # @since 1.6
  class InMemoryCookieStore 
    include_class_members InMemoryCookieStoreImports
    include CookieStore
    
    # the in-memory representation of cookies
    attr_accessor :cookie_jar
    alias_method :attr_cookie_jar, :cookie_jar
    undef_method :cookie_jar
    alias_method :attr_cookie_jar=, :cookie_jar=
    undef_method :cookie_jar=
    
    # the cookies are indexed by its domain and associated uri (if present)
    # CAUTION: when a cookie removed from main data structure (i.e. cookieJar),
    # it won't be cleared in domainIndex & uriIndex. Double-check the
    # presence of cookie when retrieve one form index store.
    attr_accessor :domain_index
    alias_method :attr_domain_index, :domain_index
    undef_method :domain_index
    alias_method :attr_domain_index=, :domain_index=
    undef_method :domain_index=
    
    attr_accessor :uri_index
    alias_method :attr_uri_index, :uri_index
    undef_method :uri_index
    alias_method :attr_uri_index=, :uri_index=
    undef_method :uri_index=
    
    # use ReentrantLock instead of syncronized for scalability
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    typesig { [] }
    # The default ctor
    def initialize
      @cookie_jar = nil
      @domain_index = nil
      @uri_index = nil
      @lock = nil
      @cookie_jar = ArrayList.new
      @domain_index = HashMap.new
      @uri_index = HashMap.new
      @lock = ReentrantLock.new(false)
    end
    
    typesig { [URI, HttpCookie] }
    # Add one cookie into cookie store.
    def add(uri, cookie)
      # pre-condition : argument can't be null
      if ((cookie).nil?)
        raise NullPointerException.new("cookie is null")
      end
      @lock.lock
      begin
        # remove the ole cookie if there has had one
        @cookie_jar.remove(cookie)
        # add new cookie if it has a non-zero max-age
        if (!(cookie.get_max_age).equal?(0))
          @cookie_jar.add(cookie)
          # and add it to domain index
          add_index(@domain_index, cookie.get_domain, cookie)
          # add it to uri index, too
          add_index(@uri_index, get_effective_uri(uri), cookie)
        end
      ensure
        @lock.unlock
      end
    end
    
    typesig { [URI] }
    # Get all cookies, which:
    # 1) given uri domain-matches with, or, associated with
    # given uri when added to the cookie store.
    # 3) not expired.
    # See RFC 2965 sec. 3.3.4 for more detail.
    def get(uri)
      # argument can't be null
      if ((uri).nil?)
        raise NullPointerException.new("uri is null")
      end
      cookies = ArrayList.new
      @lock.lock
      begin
        # check domainIndex first
        get_internal(cookies, @domain_index, DomainComparator.new(uri.get_host))
        # check uriIndex then
        get_internal(cookies, @uri_index, get_effective_uri(uri))
      ensure
        @lock.unlock
      end
      return cookies
    end
    
    typesig { [] }
    # Get all cookies in cookie store, except those have expired
    def get_cookies
      rt = nil
      @lock.lock
      begin
        it = @cookie_jar.iterator
        while (it.has_next)
          if (it.next_.has_expired)
            it.remove
          end
        end
      ensure
        rt = Collections.unmodifiable_list(@cookie_jar)
        @lock.unlock
      end
      return rt
    end
    
    typesig { [] }
    # Get all URIs, which are associated with at least one cookie
    # of this cookie store.
    def get_uris
      uris = ArrayList.new
      @lock.lock
      begin
        it = @uri_index.key_set.iterator
        while (it.has_next)
          uri = it.next_
          cookies = @uri_index.get(uri)
          if ((cookies).nil? || (cookies.size).equal?(0))
            # no cookies list or an empty list associated with
            # this uri entry, delete it
            it.remove
          end
        end
      ensure
        uris.add_all(@uri_index.key_set)
        @lock.unlock
      end
      return uris
    end
    
    typesig { [URI, HttpCookie] }
    # Remove a cookie from store
    def remove(uri, ck)
      # argument can't be null
      if ((ck).nil?)
        raise NullPointerException.new("cookie is null")
      end
      modified = false
      @lock.lock
      begin
        modified = @cookie_jar.remove(ck)
      ensure
        @lock.unlock
      end
      return modified
    end
    
    typesig { [] }
    # Remove all cookies in this cookie store.
    def remove_all
      @lock.lock
      begin
        @cookie_jar.clear
        @domain_index.clear
        @uri_index.clear
      ensure
        @lock.unlock
      end
      return true
    end
    
    class_module.module_eval {
      # ---------------- Private operations --------------
      const_set_lazy(:DomainComparator) { Class.new do
        include_class_members InMemoryCookieStore
        include JavaComparable
        
        attr_accessor :host
        alias_method :attr_host, :host
        undef_method :host
        alias_method :attr_host=, :host=
        undef_method :host=
        
        typesig { [String] }
        def initialize(host)
          @host = nil
          @host = host
        end
        
        typesig { [String] }
        def compare_to(domain)
          if (HttpCookie.domain_matches(domain, @host))
            return 0
          else
            return -1
          end
        end
        
        private
        alias_method :initialize__domain_comparator, :initialize
      end }
    }
    
    typesig { [JavaList, Map, JavaComparable] }
    # @param cookies           [OUT] contains the found cookies
    # @param cookieIndex       the index
    # @param comparator        the prediction to decide whether or not
    # a cookie in index should be returned
    def get_internal(cookies, cookie_index, comparator)
      cookie_index.key_set.each do |index|
        if (((comparator <=> index)).equal?(0))
          indexed_cookies = cookie_index.get(index)
          # check the list of cookies associated with this domain
          if (!(indexed_cookies).nil?)
            it = indexed_cookies.iterator
            while (it.has_next)
              ck = it.next_
              if (!(@cookie_jar.index_of(ck)).equal?(-1))
                # the cookie still in main cookie store
                if (!ck.has_expired)
                  # don't add twice
                  if (!cookies.contains(ck))
                    cookies.add(ck)
                  end
                else
                  it.remove
                  @cookie_jar.remove(ck)
                end
              else
                # the cookie has beed removed from main store,
                # so also remove it from domain indexed store
                it.remove
              end
            end
          end # end of indexedCookies != null
        end # end of comparator.compareTo(index) == 0
      end # end of cookieIndex iteration
    end
    
    typesig { [Map, T, HttpCookie] }
    # add 'cookie' indexed by 'index' into 'indexStore'
    def add_index(index_store, index, cookie)
      if (!(index).nil?)
        cookies = index_store.get(index)
        if (!(cookies).nil?)
          # there may already have the same cookie, so remove it first
          cookies.remove(cookie)
          cookies.add(cookie)
        else
          cookies = ArrayList.new
          cookies.add(cookie)
          index_store.put(index, cookies)
        end
      end
    end
    
    typesig { [URI] }
    # for cookie purpose, the effective uri should only be scheme://authority
    # the path will be taken into account when path-match algorithm applied
    def get_effective_uri(uri)
      effective_uri = nil
      begin
        # path component
        # query component
        # fragment component
        effective_uri = URI.new(uri.get_scheme, uri.get_authority, nil, nil, nil)
      rescue URISyntaxException => ignored
        effective_uri = uri
      end
      return effective_uri
    end
    
    private
    alias_method :initialize__in_memory_cookie_store, :initialize
  end
  
end

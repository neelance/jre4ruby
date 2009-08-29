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
  module HttpCookieImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Text, :SimpleDateFormat
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Lang, :NullPointerException
    }
  end
  
  # for javadoc
  # 
  # An HttpCookie object represents an http cookie, which carries state
  # information between server and user agent. Cookie is widely adopted
  # to create stateful sessions.
  # 
  # <p>There are 3 http cookie specifications:
  # <blockquote>
  # Netscape draft<br>
  # RFC 2109 - <a href="http://www.ietf.org/rfc/rfc2109.txt">
  # <i>http://www.ietf.org/rfc/rfc2109.txt</i></a><br>
  # RFC 2965 - <a href="http://www.ietf.org/rfc/rfc2965.txt">
  # <i>http://www.ietf.org/rfc/rfc2965.txt</i></a>
  # </blockquote>
  # 
  # <p>HttpCookie class can accept all these 3 forms of syntax.
  # 
  # @author Edward Wang
  # @since 1.6
  class HttpCookie 
    include_class_members HttpCookieImports
    include Cloneable
    
    # ---------------- Fields --------------
    # 
    # The value of the cookie itself.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # NAME= ... "$Name" style is reserved
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # value of NAME
    # 
    # Attributes encoded in the header's cookie fields.
    attr_accessor :comment
    alias_method :attr_comment, :comment
    undef_method :comment
    alias_method :attr_comment=, :comment=
    undef_method :comment=
    
    # Comment=VALUE ... describes cookie's use
    attr_accessor :comment_url
    alias_method :attr_comment_url, :comment_url
    undef_method :comment_url
    alias_method :attr_comment_url=, :comment_url=
    undef_method :comment_url=
    
    # CommentURL="http URL" ... describes cookie's use
    attr_accessor :to_discard
    alias_method :attr_to_discard, :to_discard
    undef_method :to_discard
    alias_method :attr_to_discard=, :to_discard=
    undef_method :to_discard=
    
    # Discard ... discard cookie unconditionally
    attr_accessor :domain
    alias_method :attr_domain, :domain
    undef_method :domain
    alias_method :attr_domain=, :domain=
    undef_method :domain=
    
    # Domain=VALUE ... domain that sees cookie
    attr_accessor :max_age
    alias_method :attr_max_age, :max_age
    undef_method :max_age
    alias_method :attr_max_age=, :max_age=
    undef_method :max_age=
    
    # Max-Age=VALUE ... cookies auto-expire
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    # Path=VALUE ... URLs that see the cookie
    attr_accessor :portlist
    alias_method :attr_portlist, :portlist
    undef_method :portlist
    alias_method :attr_portlist=, :portlist=
    undef_method :portlist=
    
    # Port[="portlist"] ... the port cookie may be returned to
    attr_accessor :secure
    alias_method :attr_secure, :secure
    undef_method :secure
    alias_method :attr_secure=, :secure=
    undef_method :secure=
    
    # Secure ... e.g. use SSL
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    # Version=1 ... RFC 2965 style
    # 
    # Hold the creation time (in seconds) of the http cookie for later
    # expiration calculation
    attr_accessor :when_created
    alias_method :attr_when_created, :when_created
    undef_method :when_created
    alias_method :attr_when_created=, :when_created=
    undef_method :when_created=
    
    class_module.module_eval {
      # Since the positive and zero max-age have their meanings,
      # this value serves as a hint as 'not specify max-age'
      const_set_lazy(:MAX_AGE_UNSPECIFIED) { -1 }
      const_attr_reader  :MAX_AGE_UNSPECIFIED
      
      # date format used by Netscape's cookie draft
      const_set_lazy(:NETSCAPE_COOKIE_DATE_FORMAT) { "EEE',' dd-MMM-yyyy HH:mm:ss 'GMT'" }
      const_attr_reader  :NETSCAPE_COOKIE_DATE_FORMAT
      
      # constant strings represent set-cookie header token
      const_set_lazy(:SET_COOKIE) { "set-cookie:" }
      const_attr_reader  :SET_COOKIE
      
      const_set_lazy(:SET_COOKIE2) { "set-cookie2:" }
      const_attr_reader  :SET_COOKIE2
    }
    
    typesig { [String, String] }
    # ---------------- Ctors --------------
    # 
    # Constructs a cookie with a specified name and value.
    # 
    # <p>The name must conform to RFC 2965. That means it can contain
    # only ASCII alphanumeric characters and cannot contain commas,
    # semicolons, or white space or begin with a $ character. The cookie's
    # name cannot be changed after creation.
    # 
    # <p>The value can be anything the server chooses to send. Its
    # value is probably of interest only to the server. The cookie's
    # value can be changed after creation with the
    # <code>setValue</code> method.
    # 
    # <p>By default, cookies are created according to the RFC 2965
    # cookie specification. The version can be changed with the
    # <code>setVersion</code> method.
    # 
    # 
    # @param name                      a <code>String</code> specifying the name of the cookie
    # 
    # @param value                     a <code>String</code> specifying the value of the cookie
    # 
    # @throws IllegalArgumentException if the cookie name contains illegal characters
    # or it is one of the tokens reserved for use
    # by the cookie protocol
    # @throws NullPointerException     if <tt>name</tt> is <tt>null</tt>
    # @see #setValue
    # @see #setVersion
    def initialize(name, value)
      @name = nil
      @value = nil
      @comment = nil
      @comment_url = nil
      @to_discard = false
      @domain = nil
      @max_age = MAX_AGE_UNSPECIFIED
      @path = nil
      @portlist = nil
      @secure = false
      @version = 1
      @when_created = 0
      name = RJava.cast_to_string(name.trim)
      if ((name.length).equal?(0) || !is_token(name) || is_reserved(name))
        raise IllegalArgumentException.new("Illegal cookie name")
      end
      @name = name
      @value = value
      @to_discard = false
      @secure = false
      @when_created = System.current_time_millis
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Constructs cookies from set-cookie or set-cookie2 header string.
      # RFC 2965 section 3.2.2 set-cookie2 syntax indicates that one header line
      # may contain more than one cookie definitions, so this is a static
      # utility method instead of another constructor.
      # 
      # @param header    a <tt>String</tt> specifying the set-cookie header.
      # The header should start with "set-cookie", or "set-cookie2"
      # token; or it should have no leading token at all.
      # @return          a List of cookie parsed from header line string
      # @throws IllegalArgumentException if header string violates the cookie
      # specification's syntax, or the cookie
      # name contains llegal characters, or
      # the cookie name is one of the tokens
      # reserved for use by the cookie protocol
      # @throws NullPointerException     if the header string is <tt>null</tt>
      def parse(header)
        version = guess_cookie_version(header)
        # if header start with set-cookie or set-cookie2, strip it off
        if (starts_with_ignore_case(header, SET_COOKIE2))
          header = RJava.cast_to_string(header.substring(SET_COOKIE2.length))
        else
          if (starts_with_ignore_case(header, SET_COOKIE))
            header = RJava.cast_to_string(header.substring(SET_COOKIE.length))
          end
        end
        cookies = Java::Util::ArrayList.new
        # The Netscape cookie may have a comma in its expires attribute,
        # while the comma is the delimiter in rfc 2965/2109 cookie header string.
        # so the parse logic is slightly different
        if ((version).equal?(0))
          # Netscape draft cookie
          cookie = parse_internal(header)
          cookie.set_version(0)
          cookies.add(cookie)
        else
          # rfc2965/2109 cookie
          # if header string contains more than one cookie,
          # it'll separate them with comma
          cookie_strings = split_multi_cookies(header)
          cookie_strings.each do |cookieStr|
            cookie = parse_internal(cookie_str)
            cookie.set_version(1)
            cookies.add(cookie)
          end
        end
        return cookies
      end
    }
    
    typesig { [] }
    # ---------------- Public operations --------------
    # 
    # Reports whether this http cookie has expired or not.
    # 
    # @return  <tt>true</tt> to indicate this http cookie has expired;
    # otherwise, <tt>false</tt>
    def has_expired
      if ((@max_age).equal?(0))
        return true
      end
      # if not specify max-age, this cookie should be
      # discarded when user agent is to be closed, but
      # it is not expired.
      if ((@max_age).equal?(MAX_AGE_UNSPECIFIED))
        return false
      end
      delta_second = (System.current_time_millis - @when_created) / 1000
      if (delta_second > @max_age)
        return true
      else
        return false
      end
    end
    
    typesig { [String] }
    # Specifies a comment that describes a cookie's purpose.
    # The comment is useful if the browser presents the cookie
    # to the user. Comments
    # are not supported by Netscape Version 0 cookies.
    # 
    # @param purpose           a <code>String</code> specifying the comment
    # to display to the user
    # 
    # @see #getComment
    def set_comment(purpose)
      @comment = purpose
    end
    
    typesig { [] }
    # Returns the comment describing the purpose of this cookie, or
    # <code>null</code> if the cookie has no comment.
    # 
    # @return                  a <code>String</code> containing the comment,
    # or <code>null</code> if none
    # 
    # @see #setComment
    def get_comment
      return @comment
    end
    
    typesig { [String] }
    # Specifies a comment url that describes a cookie's purpose.
    # The comment url is useful if the browser presents the cookie
    # to the user. Comment url is RFC 2965 only.
    # 
    # @param purpose           a <code>String</code> specifying the comment url
    # to display to the user
    # 
    # @see #getCommentURL
    def set_comment_url(purpose)
      @comment_url = purpose
    end
    
    typesig { [] }
    # Returns the comment url describing the purpose of this cookie, or
    # <code>null</code> if the cookie has no comment url.
    # 
    # @return                  a <code>String</code> containing the comment url,
    # or <code>null</code> if none
    # 
    # @see #setCommentURL
    def get_comment_url
      return @comment_url
    end
    
    typesig { [::Java::Boolean] }
    # Specify whether user agent should discard the cookie unconditionally.
    # This is RFC 2965 only attribute.
    # 
    # @param discard   <tt>true</tt> indicates to discard cookie unconditionally
    # 
    # @see #getDiscard
    def set_discard(discard)
      @to_discard = discard
    end
    
    typesig { [] }
    # Return the discard attribute of the cookie
    # 
    # @return  a <tt>boolean</tt> to represent this cookie's discard attribute
    # 
    # @see #setDiscard
    def get_discard
      return @to_discard
    end
    
    typesig { [String] }
    # Specify the portlist of the cookie, which restricts the port(s)
    # to which a cookie may be sent back in a Cookie header.
    # 
    # @param ports     a <tt>String</tt> specify the port list, which is
    # comma seperated series of digits
    # @see #getPortlist
    def set_portlist(ports)
      @portlist = ports
    end
    
    typesig { [] }
    # Return the port list attribute of the cookie
    # 
    # @return  a <tt>String</tt> contains the port list
    # or <tt>null</tt> if none
    # @see #setPortlist
    def get_portlist
      return @portlist
    end
    
    typesig { [String] }
    # Specifies the domain within which this cookie should be presented.
    # 
    # <p>The form of the domain name is specified by RFC 2965. A domain
    # name begins with a dot (<code>.foo.com</code>) and means that
    # the cookie is visible to servers in a specified Domain Name System
    # (DNS) zone (for example, <code>www.foo.com</code>, but not
    # <code>a.b.foo.com</code>). By default, cookies are only returned
    # to the server that sent them.
    # 
    # 
    # @param pattern           a <code>String</code> containing the domain name
    # within which this cookie is visible;
    # form is according to RFC 2965
    # 
    # @see #getDomain
    def set_domain(pattern)
      if (!(pattern).nil?)
        @domain = RJava.cast_to_string(pattern.to_lower_case)
      else
        @domain = pattern
      end
    end
    
    typesig { [] }
    # Returns the domain name set for this cookie. The form of
    # the domain name is set by RFC 2965.
    # 
    # @return                  a <code>String</code> containing the domain name
    # 
    # @see #setDomain
    def get_domain
      return @domain
    end
    
    typesig { [::Java::Long] }
    # Sets the maximum age of the cookie in seconds.
    # 
    # <p>A positive value indicates that the cookie will expire
    # after that many seconds have passed. Note that the value is
    # the <i>maximum</i> age when the cookie will expire, not the cookie's
    # current age.
    # 
    # <p>A negative value means
    # that the cookie is not stored persistently and will be deleted
    # when the Web browser exits. A zero value causes the cookie
    # to be deleted.
    # 
    # @param expiry            an integer specifying the maximum age of the
    # cookie in seconds; if zero, the cookie
    # should be discarded immediately;
    # otherwise, the cookie's max age is unspecified.
    # 
    # @see #getMaxAge
    def set_max_age(expiry)
      @max_age = expiry
    end
    
    typesig { [] }
    # Returns the maximum age of the cookie, specified in seconds.
    # By default, <code>-1</code> indicating the cookie will persist
    # until browser shutdown.
    # 
    # 
    # @return                  an integer specifying the maximum age of the
    # cookie in seconds
    # 
    # 
    # @see #setMaxAge
    def get_max_age
      return @max_age
    end
    
    typesig { [String] }
    # Specifies a path for the cookie
    # to which the client should return the cookie.
    # 
    # <p>The cookie is visible to all the pages in the directory
    # you specify, and all the pages in that directory's subdirectories.
    # A cookie's path must include the servlet that set the cookie,
    # for example, <i>/catalog</i>, which makes the cookie
    # visible to all directories on the server under <i>/catalog</i>.
    # 
    # <p>Consult RFC 2965 (available on the Internet) for more
    # information on setting path names for cookies.
    # 
    # 
    # @param uri               a <code>String</code> specifying a path
    # 
    # 
    # @see #getPath
    def set_path(uri)
      @path = uri
    end
    
    typesig { [] }
    # Returns the path on the server
    # to which the browser returns this cookie. The
    # cookie is visible to all subpaths on the server.
    # 
    # 
    # @return          a <code>String</code> specifying a path that contains
    # a servlet name, for example, <i>/catalog</i>
    # 
    # @see #setPath
    def get_path
      return @path
    end
    
    typesig { [::Java::Boolean] }
    # Indicates to the browser whether the cookie should only be sent
    # using a secure protocol, such as HTTPS or SSL.
    # 
    # <p>The default value is <code>false</code>.
    # 
    # @param flag      if <code>true</code>, sends the cookie from the browser
    # to the server using only when using a secure protocol;
    # if <code>false</code>, sent on any protocol
    # 
    # @see #getSecure
    def set_secure(flag)
      @secure = flag
    end
    
    typesig { [] }
    # Returns <code>true</code> if the browser is sending cookies
    # only over a secure protocol, or <code>false</code> if the
    # browser can send cookies using any protocol.
    # 
    # @return          <code>true</code> if the browser can use
    # any standard protocol; otherwise, <code>false</code>
    # 
    # @see #setSecure
    def get_secure
      return @secure
    end
    
    typesig { [] }
    # Returns the name of the cookie. The name cannot be changed after
    # creation.
    # 
    # @return          a <code>String</code> specifying the cookie's name
    def get_name
      return @name
    end
    
    typesig { [String] }
    # Assigns a new value to a cookie after the cookie is created.
    # If you use a binary value, you may want to use BASE64 encoding.
    # 
    # <p>With Version 0 cookies, values should not contain white
    # space, brackets, parentheses, equals signs, commas,
    # double quotes, slashes, question marks, at signs, colons,
    # and semicolons. Empty values may not behave the same way
    # on all browsers.
    # 
    # @param newValue          a <code>String</code> specifying the new value
    # 
    # 
    # @see #getValue
    def set_value(new_value)
      @value = new_value
    end
    
    typesig { [] }
    # Returns the value of the cookie.
    # 
    # @return                  a <code>String</code> containing the cookie's
    # present value
    # 
    # @see #setValue
    def get_value
      return @value
    end
    
    typesig { [] }
    # Returns the version of the protocol this cookie complies
    # with. Version 1 complies with RFC 2965/2109,
    # and version 0 complies with the original
    # cookie specification drafted by Netscape. Cookies provided
    # by a browser use and identify the browser's cookie version.
    # 
    # 
    # @return                  0 if the cookie complies with the
    # original Netscape specification; 1
    # if the cookie complies with RFC 2965/2109
    # 
    # @see #setVersion
    def get_version
      return @version
    end
    
    typesig { [::Java::Int] }
    # Sets the version of the cookie protocol this cookie complies
    # with. Version 0 complies with the original Netscape cookie
    # specification. Version 1 complies with RFC 2965/2109.
    # 
    # 
    # @param v                 0 if the cookie should comply with
    # the original Netscape specification;
    # 1 if the cookie should comply with RFC 2965/2109
    # 
    # @throws IllegalArgumentException if <tt>v</tt> is neither 0 nor 1
    # 
    # @see #getVersion
    def set_version(v)
      if (!(v).equal?(0) && !(v).equal?(1))
        raise IllegalArgumentException.new("cookie version should be 0 or 1")
      end
      @version = v
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # The utility method to check whether a host name is in a domain
      # or not.
      # 
      # <p>This concept is described in the cookie specification.
      # To understand the concept, some terminologies need to be defined first:
      # <blockquote>
      # effective host name = hostname if host name contains dot<br>
      # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or = hostname.local if not
      # </blockquote>
      # <p>Host A's name domain-matches host B's if:
      # <blockquote><ul>
      # <li>their host name strings string-compare equal; or</li>
      # <li>A is a HDN string and has the form NB, where N is a non-empty
      # name string, B has the form .B', and B' is a HDN string.  (So,
      # x.y.com domain-matches .Y.com but not Y.com.)</li>
      # </ul></blockquote>
      # 
      # <p>A host isn't in a domain (RFC 2965 sec. 3.3.2) if:
      # <blockquote><ul>
      # <li>The value for the Domain attribute contains no embedded dots,
      # and the value is not .local.</li>
      # <li>The effective host name that derives from the request-host does
      # not domain-match the Domain attribute.</li>
      # <li>The request-host is a HDN (not IP address) and has the form HD,
      # where D is the value of the Domain attribute, and H is a string
      # that contains one or more dots.</li>
      # </ul></blockquote>
      # 
      # <p>Examples:
      # <blockquote><ul>
      # <li>A Set-Cookie2 from request-host y.x.foo.com for Domain=.foo.com
      # would be rejected, because H is y.x and contains a dot.</li>
      # <li>A Set-Cookie2 from request-host x.foo.com for Domain=.foo.com
      # would be accepted.</li>
      # <li>A Set-Cookie2 with Domain=.com or Domain=.com., will always be
      # rejected, because there is no embedded dot.</li>
      # <li>A Set-Cookie2 with Domain=ajax.com will be accepted, and the
      # value for Domain will be taken to be .ajax.com, because a dot
      # gets prepended to the value.</li>
      # <li>A Set-Cookie2 from request-host example for Domain=.local will
      # be accepted, because the effective host name for the request-
      # host is example.local, and example.local domain-matches .local.</li>
      # </ul></blockquote>
      # 
      # @param domain    the domain name to check host name with
      # @param host      the host name in question
      # @return          <tt>true</tt> if they domain-matches; <tt>false</tt> if not
      def domain_matches(domain, host)
        if ((domain).nil? || (host).nil?)
          return false
        end
        # if there's no embedded dot in domain and domain is not .local
        is_local_domain = ".local".equals_ignore_case(domain)
        embedded_dot_in_domain = domain.index_of(Character.new(?..ord))
        if ((embedded_dot_in_domain).equal?(0))
          embedded_dot_in_domain = domain.index_of(Character.new(?..ord), 1)
        end
        if (!is_local_domain && ((embedded_dot_in_domain).equal?(-1) || (embedded_dot_in_domain).equal?(domain.length - 1)))
          return false
        end
        # if the host name contains no dot and the domain name is .local
        first_dot_in_host = host.index_of(Character.new(?..ord))
        if ((first_dot_in_host).equal?(-1) && is_local_domain)
          return true
        end
        domain_length = domain.length
        length_diff = host.length - domain_length
        if ((length_diff).equal?(0))
          # if the host name and the domain name are just string-compare euqal
          return host.equals_ignore_case(domain)
        else
          if (length_diff > 0)
            # need to check H & D component
            h = host.substring(0, length_diff)
            d = host.substring(length_diff)
            return ((h.index_of(Character.new(?..ord))).equal?(-1) && d.equals_ignore_case(domain))
          else
            if ((length_diff).equal?(-1))
              # if domain is actually .host
              return ((domain.char_at(0)).equal?(Character.new(?..ord)) && host.equals_ignore_case(domain.substring(1)))
            end
          end
        end
        return false
      end
    }
    
    typesig { [] }
    # Constructs a cookie header string representation of this cookie,
    # which is in the format defined by corresponding cookie specification,
    # but without the leading "Cookie:" token.
    # 
    # @return  a string form of the cookie. The string has the defined format
    def to_s
      if (get_version > 0)
        return to_rfc2965header_string
      else
        return to_netscape_header_string
      end
    end
    
    typesig { [Object] }
    # Test the equality of two http cookies.
    # 
    # <p> The result is <tt>true</tt> only if two cookies
    # come from same domain (case-insensitive),
    # have same name (case-insensitive),
    # and have same path (case-sensitive).
    # 
    # @return          <tt>true</tt> if 2 http cookies equal to each other;
    # otherwise, <tt>false</tt>
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(HttpCookie)))
        return false
      end
      other = obj
      # One http cookie equals to another cookie (RFC 2965 sec. 3.3.3) if:
      # 1. they come from same domain (case-insensitive),
      # 2. have same name (case-insensitive),
      # 3. and have same path (case-sensitive).
      return equals_ignore_case(get_name, other.get_name) && equals_ignore_case(get_domain, other.get_domain) && self.==(get_path, other.get_path)
    end
    
    typesig { [] }
    # Return hash code of this http cookie. The result is the sum of
    # hash code value of three significant components of this cookie:
    # name, domain, and path.
    # That is, the hash code is the value of the expression:
    # <blockquote>
    # getName().toLowerCase().hashCode()<br>
    # + getDomain().toLowerCase().hashCode()<br>
    # + getPath().hashCode()
    # </blockquote>
    # 
    # @return          this http cookie's hash code
    def hash_code
      h1 = @name.to_lower_case.hash_code
      h2 = (!(@domain).nil?) ? @domain.to_lower_case.hash_code : 0
      h3 = (!(@path).nil?) ? @path.hash_code : 0
      return h1 + h2 + h3
    end
    
    typesig { [] }
    # Create and return a copy of this object.
    # 
    # @return          a clone of this http cookie
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        raise RuntimeException.new(e.get_message)
      end
    end
    
    class_module.module_eval {
      # ---------------- Private operations --------------
      # Note -- disabled for now to allow full Netscape compatibility
      # from RFC 2068, token special case characters
      # 
      # private static final String tspecials = "()<>@,;:\\\"/[]?={} \t";
      const_set_lazy(:Tspecials) { ",;" }
      const_attr_reader  :Tspecials
      
      typesig { [String] }
      # Tests a string and returns true if the string counts as a
      # token.
      # 
      # @param value             the <code>String</code> to be tested
      # 
      # @return                  <code>true</code> if the <code>String</code> is
      # a token; <code>false</code> if it is not
      def is_token(value)
        len = value.length
        i = 0
        while i < len
          c = value.char_at(i)
          if (c < 0x20 || c >= 0x7f || !(Tspecials.index_of(c)).equal?(-1))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [String] }
      # @param name      the name to be tested
      # @return          <tt>true</tt> if the name is reserved by cookie
      # specification, <tt>false</tt> if it is not
      def is_reserved(name)
        # rfc2965 only
        # rfc2965 only
        # netscape draft only
        # rfc2965 only
        if (name.equals_ignore_case("Comment") || name.equals_ignore_case("CommentURL") || name.equals_ignore_case("Discard") || name.equals_ignore_case("Domain") || name.equals_ignore_case("Expires") || name.equals_ignore_case("Max-Age") || name.equals_ignore_case("Path") || name.equals_ignore_case("Port") || name.equals_ignore_case("Secure") || name.equals_ignore_case("Version") || (name.char_at(0)).equal?(Character.new(?$.ord)))
          return true
        end
        return false
      end
      
      typesig { [String] }
      # Parse header string to cookie object.
      # 
      # @param header    header string; should contain only one NAME=VALUE pair
      # 
      # @return          an HttpCookie being extracted
      # 
      # @throws IllegalArgumentException if header string violates the cookie
      # specification
      def parse_internal(header)
        cookie = nil
        namevalue_pair = nil
        tokenizer = StringTokenizer.new(header, ";")
        # there should always have at least on name-value pair;
        # it's cookie's name
        begin
          namevalue_pair = RJava.cast_to_string(tokenizer.next_token)
          index = namevalue_pair.index_of(Character.new(?=.ord))
          if (!(index).equal?(-1))
            name = namevalue_pair.substring(0, index).trim
            value = namevalue_pair.substring(index + 1).trim
            cookie = HttpCookie.new(name, strip_off_surrounding_quote(value))
          else
            # no "=" in name-value pair; it's an error
            raise IllegalArgumentException.new("Invalid cookie name-value pair")
          end
        rescue NoSuchElementException => ignored
          raise IllegalArgumentException.new("Empty cookie header string")
        end
        # remaining name-value pairs are cookie's attributes
        while (tokenizer.has_more_tokens)
          namevalue_pair = RJava.cast_to_string(tokenizer.next_token)
          index_ = namevalue_pair.index_of(Character.new(?=.ord))
          name = nil
          value = nil
          if (!(index_).equal?(-1))
            name = RJava.cast_to_string(namevalue_pair.substring(0, index_).trim)
            value = RJava.cast_to_string(namevalue_pair.substring(index_ + 1).trim)
          else
            name = RJava.cast_to_string(namevalue_pair.trim)
            value = RJava.cast_to_string(nil)
          end
          # assign attribute to cookie
          assign_attribute(cookie, name, value)
        end
        return cookie
      end
      
      # assign cookie attribute value to attribute name;
      # use a map to simulate method dispatch
      const_set_lazy(:CookieAttributeAssignor) { Module.new do
        include_class_members HttpCookie
        
        typesig { [HttpCookie, String, String] }
        def assign(cookie, attr_name, attr_value)
          raise NotImplementedError
        end
      end }
      
      
      def assignors
        defined?(@@assignors) ? @@assignors : @@assignors= nil
      end
      alias_method :attr_assignors, :assignors
      
      def assignors=(value)
        @@assignors = value
      end
      alias_method :attr_assignors=, :assignors=
      
      when_class_loaded do
        self.attr_assignors = Java::Util::HashMap.new
        self.attr_assignors.put("comment", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_comment).nil?)
              cookie.set_comment(attr_value)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("commenturl", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_comment_url).nil?)
              cookie.set_comment_url(attr_value)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("discard", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            cookie.set_discard(true)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("domain", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_domain).nil?)
              cookie.set_domain(attr_value)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("max-age", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            begin
              maxage = Long.parse_long(attr_value)
              if ((cookie.get_max_age).equal?(MAX_AGE_UNSPECIFIED))
                cookie.set_max_age(maxage)
              end
            rescue self.class::NumberFormatException => ignored
              raise self.class::IllegalArgumentException.new("Illegal cookie max-age attribute")
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("path", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_path).nil?)
              cookie.set_path(attr_value)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("port", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_portlist).nil?)
              cookie.set_portlist(attr_value)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("secure", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            cookie.set_secure(true)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("version", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          define_method :assign do |cookie, attr_name, attr_value|
            begin
              version = JavaInteger.parse_int(attr_value)
              cookie.set_version(version)
            rescue self.class::NumberFormatException => ignored
              raise self.class::IllegalArgumentException.new("Illegal cookie version attribute")
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_assignors.put("expires", Class.new(CookieAttributeAssignor.class == Class ? CookieAttributeAssignor : Object) do
          extend LocalClass
          include_class_members HttpCookie
          include CookieAttributeAssignor if CookieAttributeAssignor.class == Module
          
          typesig { [HttpCookie, String, String] }
          # Netscape only
          define_method :assign do |cookie, attr_name, attr_value|
            if ((cookie.get_max_age).equal?(MAX_AGE_UNSPECIFIED))
              cookie.set_max_age(cookie.expiry_date2delta_seconds(attr_value))
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [HttpCookie, String, String] }
      def assign_attribute(cookie, attr_name, attr_value)
        # strip off the surrounding "-sign if there's any
        attr_value = RJava.cast_to_string(strip_off_surrounding_quote(attr_value))
        assignor = self.attr_assignors.get(attr_name.to_lower_case)
        if (!(assignor).nil?)
          assignor.assign(cookie, attr_name, attr_value)
        else
          # must be an error
          raise IllegalArgumentException.new("Illegal cookie attribute")
        end
      end
    }
    
    typesig { [] }
    # Constructs a string representation of this cookie. The string format is
    # as Netscape spec, but without leading "Cookie:" token.
    def to_netscape_header_string
      sb = StringBuilder.new
      sb.append(RJava.cast_to_string(get_name) + "=" + RJava.cast_to_string(get_value))
      return sb.to_s
    end
    
    typesig { [] }
    # Constructs a string representation of this cookie. The string format is
    # as RFC 2965/2109, but without leading "Cookie:" token.
    def to_rfc2965header_string
      sb = StringBuilder.new
      sb.append(get_name).append("=\"").append(get_value).append(Character.new(?".ord))
      if (!(get_path).nil?)
        sb.append(";$Path=\"").append(get_path).append(Character.new(?".ord))
      end
      if (!(get_domain).nil?)
        sb.append(";$Domain=\"").append(get_domain).append(Character.new(?".ord))
      end
      if (!(get_portlist).nil?)
        sb.append(";$Port=\"").append(get_portlist).append(Character.new(?".ord))
      end
      return sb.to_s
    end
    
    typesig { [String] }
    # @param dateString        a date string in format of
    # "EEE',' dd-MMM-yyyy HH:mm:ss 'GMT'",
    # which defined in Netscape cookie spec
    # 
    # @return                  delta seconds between this cookie's creation
    # time and the time specified by dateString
    def expiry_date2delta_seconds(date_string)
      df = SimpleDateFormat.new(NETSCAPE_COOKIE_DATE_FORMAT)
      df.set_time_zone(TimeZone.get_time_zone("GMT"))
      begin
        date = df.parse(date_string)
        return (date.get_time - @when_created) / 1000
      rescue JavaException => e
        return 0
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # try to guess the cookie version through set-cookie header string
      def guess_cookie_version(header)
        version = 0
        header = RJava.cast_to_string(header.to_lower_case)
        if (!(header.index_of("expires=")).equal?(-1))
          # only netscape cookie using 'expires'
          version = 0
        else
          if (!(header.index_of("version=")).equal?(-1))
            # version is mandatory for rfc 2965/2109 cookie
            version = 1
          else
            if (!(header.index_of("max-age")).equal?(-1))
              # rfc 2965/2109 use 'max-age'
              version = 1
            else
              if (starts_with_ignore_case(header, SET_COOKIE2))
                # only rfc 2965 cookie starts with 'set-cookie2'
                version = 1
              end
            end
          end
        end
        return version
      end
      
      typesig { [String] }
      def strip_off_surrounding_quote(str)
        if (!(str).nil? && str.length > 0 && (str.char_at(0)).equal?(Character.new(?".ord)) && (str.char_at(str.length - 1)).equal?(Character.new(?".ord)))
          return str.substring(1, str.length - 1)
        else
          return str
        end
      end
      
      typesig { [String, String] }
      def equals_ignore_case(s, t)
        if ((s).equal?(t))
          return true
        end
        if ((!(s).nil?) && (!(t).nil?))
          return s.equals_ignore_case(t)
        end
        return false
      end
      
      typesig { [String, String] }
      def ==(s, t)
        if ((s).equal?(t))
          return true
        end
        if ((!(s).nil?) && (!(t).nil?))
          return (s == t)
        end
        return false
      end
      
      typesig { [String, String] }
      def starts_with_ignore_case(s, start)
        if ((s).nil? || (start).nil?)
          return false
        end
        if (s.length >= start.length && start.equals_ignore_case(s.substring(0, start.length)))
          return true
        end
        return false
      end
      
      typesig { [String] }
      # Split cookie header string according to rfc 2965:
      # 1) split where it is a comma;
      # 2) but not the comma surrounding by double-quotes, which is the comma
      # inside port list or embeded URIs.
      # 
      # @param header            the cookie header string to split
      # 
      # @return                  list of strings; never null
      def split_multi_cookies(header)
        cookies = Java::Util::ArrayList.new
        quote_count = 0
        p = 0
        q = 0
        p = 0
        q = 0
        while p < header.length
          c = header.char_at(p)
          if ((c).equal?(Character.new(?".ord)))
            quote_count += 1
          end
          if ((c).equal?(Character.new(?,.ord)) && ((quote_count % 2).equal?(0)))
            # it is comma and not surrounding by double-quotes
            cookies.add(header.substring(q, p))
            q = p + 1
          end
          p += 1
        end
        cookies.add(header.substring(q))
        return cookies
      end
    }
    
    private
    alias_method :initialize__http_cookie, :initialize
  end
  
end

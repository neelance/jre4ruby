require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URLImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :StringTokenizer
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # Class <code>URL</code> represents a Uniform Resource
  # Locator, a pointer to a "resource" on the World
  # Wide Web. A resource can be something as simple as a file or a
  # directory, or it can be a reference to a more complicated object,
  # such as a query to a database or to a search engine. More
  # information on the types of URLs and their formats can be found at:
  # <blockquote>
  # <a href="http://www.socs.uts.edu.au/MosaicDocs-old/url-primer.html">
  # <i>http://www.socs.uts.edu.au/MosaicDocs-old/url-primer.html</i></a>
  # </blockquote>
  # <p>
  # In general, a URL can be broken into several parts. The previous
  # example of a URL indicates that the protocol to use is
  # <code>http</code> (HyperText Transfer Protocol) and that the
  # information resides on a host machine named
  # <code>www.socs.uts.edu.au</code>. The information on that host
  # machine is named <code>/MosaicDocs-old/url-primer.html</code>. The exact
  # meaning of this name on the host machine is both protocol
  # dependent and host dependent. The information normally resides in
  # a file, but it could be generated on the fly. This component of
  # the URL is called the <i>path</i> component.
  # <p>
  # A URL can optionally specify a "port", which is the
  # port number to which the TCP connection is made on the remote host
  # machine. If the port is not specified, the default port for
  # the protocol is used instead. For example, the default port for
  # <code>http</code> is <code>80</code>. An alternative port could be
  # specified as:
  # <blockquote><pre>
  # http://www.socs.uts.edu.au:80/MosaicDocs-old/url-primer.html
  # </pre></blockquote>
  # <p>
  # The syntax of <code>URL</code> is defined by  <a
  # href="http://www.ietf.org/rfc/rfc2396.txt""><i>RFC&nbsp;2396: Uniform
  # Resource Identifiers (URI): Generic Syntax</i></a>, amended by <a
  # href="http://www.ietf.org/rfc/rfc2732.txt"><i>RFC&nbsp;2732: Format for
  # Literal IPv6 Addresses in URLs</i></a>. The Literal IPv6 address format
  # also supports scope_ids. The syntax and usage of scope_ids is described
  # <a href="Inet6Address.html#scoped">here</a>.
  # <p>
  # A URL may have appended to it a "fragment", also known
  # as a "ref" or a "reference". The fragment is indicated by the sharp
  # sign character "#" followed by more characters. For example,
  # <blockquote><pre>
  # http://java.sun.com/index.html#chapter1
  # </pre></blockquote>
  # <p>
  # This fragment is not technically part of the URL. Rather, it
  # indicates that after the specified resource is retrieved, the
  # application is specifically interested in that part of the
  # document that has the tag <code>chapter1</code> attached to it. The
  # meaning of a tag is resource specific.
  # <p>
  # An application can also specify a "relative URL",
  # which contains only enough information to reach the resource
  # relative to another URL. Relative URLs are frequently used within
  # HTML pages. For example, if the contents of the URL:
  # <blockquote><pre>
  # http://java.sun.com/index.html
  # </pre></blockquote>
  # contained within it the relative URL:
  # <blockquote><pre>
  # FAQ.html
  # </pre></blockquote>
  # it would be a shorthand for:
  # <blockquote><pre>
  # http://java.sun.com/FAQ.html
  # </pre></blockquote>
  # <p>
  # The relative URL need not specify all the components of a URL. If
  # the protocol, host name, or port number is missing, the value is
  # inherited from the fully specified URL. The file component must be
  # specified. The optional fragment is not inherited.
  # <p>
  # The URL class does not itself encode or decode any URL components
  # according to the escaping mechanism defined in RFC2396. It is the
  # responsibility of the caller to encode any fields, which need to be
  # escaped prior to calling URL, and also to decode any escaped fields,
  # that are returned from URL. Furthermore, because URL has no knowledge
  # of URL escaping, it does not recognise equivalence between the encoded
  # or decoded form of the same URL. For example, the two URLs:<br>
  # <pre>    http://foo.com/hello world/ and http://foo.com/hello%20world</pre>
  # would be considered not equal to each other.
  # <p>
  # Note, the {@link java.net.URI} class does perform escaping of its
  # component fields in certain circumstances. The recommended way
  # to manage the encoding and decoding of URLs is to use {@link java.net.URI},
  # and to convert between these two classes using {@link #toURI()} and
  # {@link URI#toURL()}.
  # <p>
  # The {@link URLEncoder} and {@link URLDecoder} classes can also be
  # used, but only for HTML form encoding, which is not the same
  # as the encoding scheme defined in RFC2396.
  # 
  # @author  James Gosling
  # @since JDK1.0
  class URL 
    include_class_members URLImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7627629688361524110 }
      const_attr_reader  :SerialVersionUID
      
      # The property which specifies the package prefix list to be scanned
      # for protocol handlers.  The value of this property (if any) should
      # be a vertical bar delimited list of package names to search through
      # for a protocol handler to load.  The policy of this class is that
      # all protocol handlers will be in a class called <protocolname>.Handler,
      # and each package in the list is examined in turn for a matching
      # handler.  If none are found (or the property is not specified), the
      # default package prefix, sun.net.www.protocol, is used.  The search
      # proceeds from the first package in the list to the last and stops
      # when a match is found.
      const_set_lazy(:ProtocolPathProp) { "java.protocol.handler.pkgs" }
      const_attr_reader  :ProtocolPathProp
    }
    
    # The protocol to use (ftp, http, nntp, ... etc.) .
    # @serial
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    # The host name to connect to.
    # @serial
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    # The protocol port to connect to.
    # @serial
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    # The specified file name on that host. <code>file</code> is
    # defined as <code>path[?query]</code>
    # @serial
    attr_accessor :file
    alias_method :attr_file, :file
    undef_method :file
    alias_method :attr_file=, :file=
    undef_method :file=
    
    # The query part of this URL.
    attr_accessor :query
    alias_method :attr_query, :query
    undef_method :query
    alias_method :attr_query=, :query=
    undef_method :query=
    
    # The authority part of this URL.
    # @serial
    attr_accessor :authority
    alias_method :attr_authority, :authority
    undef_method :authority
    alias_method :attr_authority=, :authority=
    undef_method :authority=
    
    # The path part of this URL.
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    # The userinfo part of this URL.
    attr_accessor :user_info
    alias_method :attr_user_info, :user_info
    undef_method :user_info
    alias_method :attr_user_info=, :user_info=
    undef_method :user_info=
    
    # # reference.
    # @serial
    attr_accessor :ref
    alias_method :attr_ref, :ref
    undef_method :ref
    alias_method :attr_ref=, :ref=
    undef_method :ref=
    
    # The host's IP address, used in equals and hashCode.
    # Computed on demand. An uninitialized or unknown hostAddress is null.
    attr_accessor :host_address
    alias_method :attr_host_address, :host_address
    undef_method :host_address
    alias_method :attr_host_address=, :host_address=
    undef_method :host_address=
    
    # The URLStreamHandler for this URL.
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    # Our hash code.
    # @serial
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    typesig { [String, String, ::Java::Int, String] }
    # Creates a <code>URL</code> object from the specified
    # <code>protocol</code>, <code>host</code>, <code>port</code>
    # number, and <code>file</code>.<p>
    # 
    # <code>host</code> can be expressed as a host name or a literal
    # IP address. If IPv6 literal address is used, it should be
    # enclosed in square brackets (<tt>'['</tt> and <tt>']'</tt>), as
    # specified by <a
    # href="http://www.ietf.org/rfc/rfc2732.txt">RFC&nbsp;2732</a>;
    # However, the literal IPv6 address format defined in <a
    # href="http://www.ietf.org/rfc/rfc2373.txt"><i>RFC&nbsp;2373: IP
    # Version 6 Addressing Architecture</i></a> is also accepted.<p>
    # 
    # Specifying a <code>port</code> number of <code>-1</code>
    # indicates that the URL should use the default port for the
    # protocol.<p>
    # 
    # If this is the first URL object being created with the specified
    # protocol, a <i>stream protocol handler</i> object, an instance of
    # class <code>URLStreamHandler</code>, is created for that protocol:
    # <ol>
    # <li>If the application has previously set up an instance of
    # <code>URLStreamHandlerFactory</code> as the stream handler factory,
    # then the <code>createURLStreamHandler</code> method of that instance
    # is called with the protocol string as an argument to create the
    # stream protocol handler.
    # <li>If no <code>URLStreamHandlerFactory</code> has yet been set up,
    # or if the factory's <code>createURLStreamHandler</code> method
    # returns <code>null</code>, then the constructor finds the
    # value of the system property:
    # <blockquote><pre>
    # java.protocol.handler.pkgs
    # </pre></blockquote>
    # If the value of that system property is not <code>null</code>,
    # it is interpreted as a list of packages separated by a vertical
    # slash character '<code>|</code>'. The constructor tries to load
    # the class named:
    # <blockquote><pre>
    # &lt;<i>package</i>&gt;.&lt;<i>protocol</i>&gt;.Handler
    # </pre></blockquote>
    # where &lt;<i>package</i>&gt; is replaced by the name of the package
    # and &lt;<i>protocol</i>&gt; is replaced by the name of the protocol.
    # If this class does not exist, or if the class exists but it is not
    # a subclass of <code>URLStreamHandler</code>, then the next package
    # in the list is tried.
    # <li>If the previous step fails to find a protocol handler, then the
    # constructor tries to load from a system default package.
    # <blockquote><pre>
    # &lt;<i>system default package</i>&gt;.&lt;<i>protocol</i>&gt;.Handler
    # </pre></blockquote>
    # If this class does not exist, or if the class exists but it is not a
    # subclass of <code>URLStreamHandler</code>, then a
    # <code>MalformedURLException</code> is thrown.
    # </ol>
    # 
    # <p>Protocol handlers for the following protocols are guaranteed
    # to exist on the search path :-
    # <blockquote><pre>
    # http, https, ftp, file, and jar
    # </pre></blockquote>
    # Protocol handlers for additional protocols may also be
    # available.
    # 
    # <p>No validation of the inputs is performed by this constructor.
    # 
    # @param      protocol   the name of the protocol to use.
    # @param      host       the name of the host.
    # @param      port       the port number on the host.
    # @param      file       the file on the host
    # @exception  MalformedURLException  if an unknown protocol is specified.
    # @see        java.lang.System#getProperty(java.lang.String)
    # @see        java.net.URL#setURLStreamHandlerFactory(
    # java.net.URLStreamHandlerFactory)
    # @see        java.net.URLStreamHandler
    # @see        java.net.URLStreamHandlerFactory#createURLStreamHandler(
    # java.lang.String)
    def initialize(protocol, host, port, file)
      initialize__url(protocol, host, port, file, nil)
    end
    
    typesig { [String, String, String] }
    # Creates a URL from the specified <code>protocol</code>
    # name, <code>host</code> name, and <code>file</code> name. The
    # default port for the specified protocol is used.
    # <p>
    # This method is equivalent to calling the four-argument
    # constructor with the arguments being <code>protocol</code>,
    # <code>host</code>, <code>-1</code>, and <code>file</code>.
    # 
    # No validation of the inputs is performed by this constructor.
    # 
    # @param      protocol   the name of the protocol to use.
    # @param      host       the name of the host.
    # @param      file       the file on the host.
    # @exception  MalformedURLException  if an unknown protocol is specified.
    # @see        java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    def initialize(protocol, host, file)
      initialize__url(protocol, host, -1, file)
    end
    
    typesig { [String, String, ::Java::Int, String, URLStreamHandler] }
    # Creates a <code>URL</code> object from the specified
    # <code>protocol</code>, <code>host</code>, <code>port</code>
    # number, <code>file</code>, and <code>handler</code>. Specifying
    # a <code>port</code> number of <code>-1</code> indicates that
    # the URL should use the default port for the protocol. Specifying
    # a <code>handler</code> of <code>null</code> indicates that the URL
    # should use a default stream handler for the protocol, as outlined
    # for:
    # java.net.URL#URL(java.lang.String, java.lang.String, int,
    # java.lang.String)
    # 
    # <p>If the handler is not null and there is a security manager,
    # the security manager's <code>checkPermission</code>
    # method is called with a
    # <code>NetPermission("specifyStreamHandler")</code> permission.
    # This may result in a SecurityException.
    # 
    # No validation of the inputs is performed by this constructor.
    # 
    # @param      protocol   the name of the protocol to use.
    # @param      host       the name of the host.
    # @param      port       the port number on the host.
    # @param      file       the file on the host
    # @param      handler    the stream handler for the URL.
    # @exception  MalformedURLException  if an unknown protocol is specified.
    # @exception  SecurityException
    # if a security manager exists and its
    # <code>checkPermission</code> method doesn't allow
    # specifying a stream handler explicitly.
    # @see        java.lang.System#getProperty(java.lang.String)
    # @see        java.net.URL#setURLStreamHandlerFactory(
    # java.net.URLStreamHandlerFactory)
    # @see        java.net.URLStreamHandler
    # @see        java.net.URLStreamHandlerFactory#createURLStreamHandler(
    # java.lang.String)
    # @see        SecurityManager#checkPermission
    # @see        java.net.NetPermission
    def initialize(protocol, host, port, file, handler)
      @protocol = nil
      @host = nil
      @port = -1
      @file = nil
      @query = nil
      @authority = nil
      @path = nil
      @user_info = nil
      @ref = nil
      @host_address = nil
      @handler = nil
      @hash_code = -1
      if (!(handler).nil?)
        sm = System.get_security_manager
        if (!(sm).nil?)
          # check for permission to specify a handler
          check_specify_handler(sm)
        end
      end
      protocol = (protocol.to_lower_case).to_s
      @protocol = protocol
      if (!(host).nil?)
        # if host is a literal IPv6 address,
        # we will make it conform to RFC 2732
        if (host.index_of(Character.new(?:.ord)) >= 0 && !host.starts_with("["))
          host = "[" + host + "]"
        end
        @host = host
        if (port < -1)
          raise MalformedURLException.new("Invalid port number :" + (port).to_s)
        end
        @port = port
        @authority = (((port).equal?(-1)) ? host : host + ":" + (port).to_s).to_s
      end
      parts = Parts.new(file)
      @path = (parts.get_path).to_s
      @query = (parts.get_query).to_s
      if (!(@query).nil?)
        @file = @path + "?" + @query
      else
        @file = @path
      end
      @ref = (parts.get_ref).to_s
      # Note: we don't do validation of the URL here. Too risky to change
      # right now, but worth considering for future reference. -br
      if ((handler).nil? && ((handler = get_urlstream_handler(protocol))).nil?)
        raise MalformedURLException.new("unknown protocol: " + protocol)
      end
      @handler = handler
    end
    
    typesig { [String] }
    # Creates a <code>URL</code> object from the <code>String</code>
    # representation.
    # <p>
    # This constructor is equivalent to a call to the two-argument
    # constructor with a <code>null</code> first argument.
    # 
    # @param      spec   the <code>String</code> to parse as a URL.
    # @exception  MalformedURLException  If the string specifies an
    # unknown protocol.
    # @see        java.net.URL#URL(java.net.URL, java.lang.String)
    def initialize(spec)
      initialize__url(nil, spec)
    end
    
    typesig { [URL, String] }
    # Creates a URL by parsing the given spec within a specified context.
    # 
    # The new URL is created from the given context URL and the spec
    # argument as described in
    # RFC2396 &quot;Uniform Resource Identifiers : Generic * Syntax&quot; :
    # <blockquote><pre>
    # &lt;scheme&gt;://&lt;authority&gt;&lt;path&gt;?&lt;query&gt;#&lt;fragment&gt;
    # </pre></blockquote>
    # The reference is parsed into the scheme, authority, path, query and
    # fragment parts. If the path component is empty and the scheme,
    # authority, and query components are undefined, then the new URL is a
    # reference to the current document. Otherwise, the fragment and query
    # parts present in the spec are used in the new URL.
    # <p>
    # If the scheme component is defined in the given spec and does not match
    # the scheme of the context, then the new URL is created as an absolute
    # URL based on the spec alone. Otherwise the scheme component is inherited
    # from the context URL.
    # <p>
    # If the authority component is present in the spec then the spec is
    # treated as absolute and the spec authority and path will replace the
    # context authority and path. If the authority component is absent in the
    # spec then the authority of the new URL will be inherited from the
    # context.
    # <p>
    # If the spec's path component begins with a slash character
    # &quot;/&quot; then the
    # path is treated as absolute and the spec path replaces the context path.
    # <p>
    # Otherwise, the path is treated as a relative path and is appended to the
    # context path, as described in RFC2396. Also, in this case,
    # the path is canonicalized through the removal of directory
    # changes made by occurences of &quot;..&quot; and &quot;.&quot;.
    # <p>
    # For a more detailed description of URL parsing, refer to RFC2396.
    # 
    # @param      context   the context in which to parse the specification.
    # @param      spec      the <code>String</code> to parse as a URL.
    # @exception  MalformedURLException  if no protocol is specified, or an
    # unknown protocol is found.
    # @see        java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    # @see        java.net.URLStreamHandler
    # @see        java.net.URLStreamHandler#parseURL(java.net.URL,
    # java.lang.String, int, int)
    def initialize(context, spec)
      initialize__url(context, spec, nil)
    end
    
    typesig { [URL, String, URLStreamHandler] }
    # Creates a URL by parsing the given spec with the specified handler
    # within a specified context. If the handler is null, the parsing
    # occurs as with the two argument constructor.
    # 
    # @param      context   the context in which to parse the specification.
    # @param      spec      the <code>String</code> to parse as a URL.
    # @param      handler   the stream handler for the URL.
    # @exception  MalformedURLException  if no protocol is specified, or an
    # unknown protocol is found.
    # @exception  SecurityException
    # if a security manager exists and its
    # <code>checkPermission</code> method doesn't allow
    # specifying a stream handler.
    # @see        java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    # @see        java.net.URLStreamHandler
    # @see        java.net.URLStreamHandler#parseURL(java.net.URL,
    # java.lang.String, int, int)
    def initialize(context, spec, handler)
      @protocol = nil
      @host = nil
      @port = -1
      @file = nil
      @query = nil
      @authority = nil
      @path = nil
      @user_info = nil
      @ref = nil
      @host_address = nil
      @handler = nil
      @hash_code = -1
      original = spec
      i = 0
      limit = 0
      c = 0
      start = 0
      new_protocol = nil
      a_ref = false
      is_relative = false
      # Check for permission to specify a handler
      if (!(handler).nil?)
        sm = System.get_security_manager
        if (!(sm).nil?)
          check_specify_handler(sm)
        end
      end
      begin
        limit = spec.length
        while ((limit > 0) && (spec.char_at(limit - 1) <= Character.new(?\s.ord)))
          ((limit -= 1) + 1) # eliminate trailing whitespace
        end
        while ((start < limit) && (spec.char_at(start) <= Character.new(?\s.ord)))
          ((start += 1) - 1) # eliminate leading whitespace
        end
        if (spec.region_matches(true, start, "url:", 0, 4))
          start += 4
        end
        if (start < spec.length && (spec.char_at(start)).equal?(Character.new(?#.ord)))
          # we're assuming this is a ref relative to the context URL.
          # This means protocols cannot start w/ '#', but we must parse
          # ref URL's like: "hello:there" w/ a ':' in them.
          a_ref = true
        end
        i = start
        while !a_ref && (i < limit) && (!((c = spec.char_at(i))).equal?(Character.new(?/.ord)))
          if ((c).equal?(Character.new(?:.ord)))
            s = spec.substring(start, i).to_lower_case
            if (is_valid_protocol(s))
              new_protocol = s
              start = i + 1
            end
            break
          end
          ((i += 1) - 1)
        end
        # Only use our context if the protocols match.
        @protocol = new_protocol
        if ((!(context).nil?) && (((new_protocol).nil?) || new_protocol.equals_ignore_case(context.attr_protocol)))
          # inherit the protocol handler from the context
          # if not specified to the constructor
          if ((handler).nil?)
            handler = context.attr_handler
          end
          # If the context is a hierarchical URL scheme and the spec
          # contains a matching scheme then maintain backwards
          # compatibility and treat it as if the spec didn't contain
          # the scheme; see 5.2.3 of RFC2396
          if (!(context.attr_path).nil? && context.attr_path.starts_with("/"))
            new_protocol = (nil).to_s
          end
          if ((new_protocol).nil?)
            @protocol = (context.attr_protocol).to_s
            @authority = (context.attr_authority).to_s
            @user_info = (context.attr_user_info).to_s
            @host = (context.attr_host).to_s
            @port = context.attr_port
            @file = (context.attr_file).to_s
            @path = (context.attr_path).to_s
            is_relative = true
          end
        end
        if ((@protocol).nil?)
          raise MalformedURLException.new("no protocol: " + original)
        end
        # Get the protocol handler if not specified or the protocol
        # of the context could not be used
        if ((handler).nil? && ((handler = get_urlstream_handler(@protocol))).nil?)
          raise MalformedURLException.new("unknown protocol: " + @protocol)
        end
        @handler = handler
        i = spec.index_of(Character.new(?#.ord), start)
        if (i >= 0)
          @ref = (spec.substring(i + 1, limit)).to_s
          limit = i
        end
        # Handle special case inheritance of query and fragment
        # implied by RFC2396 section 5.2.2.
        if (is_relative && (start).equal?(limit))
          @query = (context.attr_query).to_s
          if ((@ref).nil?)
            @ref = (context.attr_ref).to_s
          end
        end
        handler.parse_url(self, spec, start, limit)
      rescue MalformedURLException => e
        raise e
      rescue Exception => e
        exception = MalformedURLException.new(e.get_message)
        exception.init_cause(e)
        raise exception
      end
    end
    
    typesig { [String] }
    # Returns true if specified string is a valid protocol name.
    def is_valid_protocol(protocol)
      len = protocol.length
      if (len < 1)
        return false
      end
      c = protocol.char_at(0)
      if (!Character.is_letter(c))
        return false
      end
      i = 1
      while i < len
        c = protocol.char_at(i)
        if (!Character.is_letter_or_digit(c) && !(c).equal?(Character.new(?..ord)) && !(c).equal?(Character.new(?+.ord)) && !(c).equal?(Character.new(?-.ord)))
          return false
        end
        ((i += 1) - 1)
      end
      return true
    end
    
    typesig { [SecurityManager] }
    # Checks for permission to specify a stream handler.
    def check_specify_handler(sm)
      sm.check_permission(SecurityConstants::SPECIFY_HANDLER_PERMISSION)
    end
    
    typesig { [String, String, ::Java::Int, String, String] }
    # Sets the fields of the URL. This is not a public method so that
    # only URLStreamHandlers can modify URL fields. URLs are
    # otherwise constant.
    # 
    # @param protocol the name of the protocol to use
    # @param host the name of the host
    # @param port the port number on the host
    # @param file the file on the host
    # @param ref the internal reference in the URL
    def set(protocol, host, port, file, ref)
      synchronized((self)) do
        @protocol = protocol
        @host = host
        @authority = ((port).equal?(-1) ? host : host + ":" + (port).to_s).to_s
        @port = port
        @file = file
        @ref = ref
        # This is very important. We must recompute this after the
        # URL has been changed.
        @hash_code = -1
        @host_address = nil
        q = file.last_index_of(Character.new(??.ord))
        if (!(q).equal?(-1))
          @query = (file.substring(q + 1)).to_s
          @path = (file.substring(0, q)).to_s
        else
          @path = file
        end
      end
    end
    
    typesig { [String, String, ::Java::Int, String, String, String, String, String] }
    # Sets the specified 8 fields of the URL. This is not a public method so
    # that only URLStreamHandlers can modify URL fields. URLs are otherwise
    # constant.
    # 
    # @param protocol the name of the protocol to use
    # @param host the name of the host
    # @param port the port number on the host
    # @param authority the authority part for the url
    # @param userInfo the username and password
    # @param path the file on the host
    # @param ref the internal reference in the URL
    # @param query the query part of this URL
    # @since 1.3
    def set(protocol, host, port, authority, user_info, path, query, ref)
      synchronized((self)) do
        @protocol = protocol
        @host = host
        @port = port
        @file = (query).nil? ? path : path + "?" + query
        @user_info = user_info
        @path = path
        @ref = ref
        # This is very important. We must recompute this after the
        # URL has been changed.
        @hash_code = -1
        @host_address = nil
        @query = query
        @authority = authority
      end
    end
    
    typesig { [] }
    # Gets the query part of this <code>URL</code>.
    # 
    # @return  the query part of this <code>URL</code>,
    # or <CODE>null</CODE> if one does not exist
    # @since 1.3
    def get_query
      return @query
    end
    
    typesig { [] }
    # Gets the path part of this <code>URL</code>.
    # 
    # @return  the path part of this <code>URL</code>, or an
    # empty string if one does not exist
    # @since 1.3
    def get_path
      return @path
    end
    
    typesig { [] }
    # Gets the userInfo part of this <code>URL</code>.
    # 
    # @return  the userInfo part of this <code>URL</code>, or
    # <CODE>null</CODE> if one does not exist
    # @since 1.3
    def get_user_info
      return @user_info
    end
    
    typesig { [] }
    # Gets the authority part of this <code>URL</code>.
    # 
    # @return  the authority part of this <code>URL</code>
    # @since 1.3
    def get_authority
      return @authority
    end
    
    typesig { [] }
    # Gets the port number of this <code>URL</code>.
    # 
    # @return  the port number, or -1 if the port is not set
    def get_port
      return @port
    end
    
    typesig { [] }
    # Gets the default port number of the protocol associated
    # with this <code>URL</code>. If the URL scheme or the URLStreamHandler
    # for the URL do not define a default port number,
    # then -1 is returned.
    # 
    # @return  the port number
    # @since 1.4
    def get_default_port
      return @handler.get_default_port
    end
    
    typesig { [] }
    # Gets the protocol name of this <code>URL</code>.
    # 
    # @return  the protocol of this <code>URL</code>.
    def get_protocol
      return @protocol
    end
    
    typesig { [] }
    # Gets the host name of this <code>URL</code>, if applicable.
    # The format of the host conforms to RFC 2732, i.e. for a
    # literal IPv6 address, this method will return the IPv6 address
    # enclosed in square brackets (<tt>'['</tt> and <tt>']'</tt>).
    # 
    # @return  the host name of this <code>URL</code>.
    def get_host
      return @host
    end
    
    typesig { [] }
    # Gets the file name of this <code>URL</code>.
    # The returned file portion will be
    # the same as <CODE>getPath()</CODE>, plus the concatenation of
    # the value of <CODE>getQuery()</CODE>, if any. If there is
    # no query portion, this method and <CODE>getPath()</CODE> will
    # return identical results.
    # 
    # @return  the file name of this <code>URL</code>,
    # or an empty string if one does not exist
    def get_file
      return @file
    end
    
    typesig { [] }
    # Gets the anchor (also known as the "reference") of this
    # <code>URL</code>.
    # 
    # @return  the anchor (also known as the "reference") of this
    # <code>URL</code>, or <CODE>null</CODE> if one does not exist
    def get_ref
      return @ref
    end
    
    typesig { [Object] }
    # Compares this URL for equality with another object.<p>
    # 
    # If the given object is not a URL then this method immediately returns
    # <code>false</code>.<p>
    # 
    # Two URL objects are equal if they have the same protocol, reference
    # equivalent hosts, have the same port number on the host, and the same
    # file and fragment of the file.<p>
    # 
    # Two hosts are considered equivalent if both host names can be resolved
    # into the same IP addresses; else if either host name can't be
    # resolved, the host names must be equal without regard to case; or both
    # host names equal to null.<p>
    # 
    # Since hosts comparison requires name resolution, this operation is a
    # blocking operation. <p>
    # 
    # Note: The defined behavior for <code>equals</code> is known to
    # be inconsistent with virtual hosting in HTTP.
    # 
    # @param   obj   the URL to compare against.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    def equals(obj)
      if (!(obj.is_a?(URL)))
        return false
      end
      u2 = obj
      return (@handler == self)
    end
    
    typesig { [] }
    # Creates an integer suitable for hash table indexing.<p>
    # 
    # The hash code is based upon all the URL components relevant for URL
    # comparison. As such, this operation is a blocking operation.<p>
    # 
    # @return  a hash code for this <code>URL</code>.
    def hash_code
      synchronized(self) do
        if (!(@hash_code).equal?(-1))
          return @hash_code
        end
        @hash_code = @handler.hash_code(self)
        return @hash_code
      end
    end
    
    typesig { [URL] }
    # Compares two URLs, excluding the fragment component.<p>
    # 
    # Returns <code>true</code> if this <code>URL</code> and the
    # <code>other</code> argument are equal without taking the
    # fragment component into consideration.
    # 
    # @param   other   the <code>URL</code> to compare against.
    # @return  <code>true</code> if they reference the same remote object;
    # <code>false</code> otherwise.
    def same_file(other)
      return @handler.same_file(self, other)
    end
    
    typesig { [] }
    # Constructs a string representation of this <code>URL</code>. The
    # string is created by calling the <code>toExternalForm</code>
    # method of the stream protocol handler for this object.
    # 
    # @return  a string representation of this object.
    # @see     java.net.URL#URL(java.lang.String, java.lang.String, int,
    # java.lang.String)
    # @see     java.net.URLStreamHandler#toExternalForm(java.net.URL)
    def to_s
      return to_external_form
    end
    
    typesig { [] }
    # Constructs a string representation of this <code>URL</code>. The
    # string is created by calling the <code>toExternalForm</code>
    # method of the stream protocol handler for this object.
    # 
    # @return  a string representation of this object.
    # @see     java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    # @see     java.net.URLStreamHandler#toExternalForm(java.net.URL)
    def to_external_form
      return @handler.to_external_form(self)
    end
    
    typesig { [] }
    # Returns a {@link java.net.URI} equivalent to this URL.
    # This method functions in the same way as <code>new URI (this.toString())</code>.
    # <p>Note, any URL instance that complies with RFC 2396 can be converted
    # to a URI. However, some URLs that are not strictly in compliance
    # can not be converted to a URI.
    # 
    # @exception URISyntaxException if this URL is not formatted strictly according to
    # to RFC2396 and cannot be converted to a URI.
    # 
    # @return    a URI instance equivalent to this URL.
    # @since 1.5
    def to_uri
      return URI.new(to_s)
    end
    
    typesig { [] }
    # Returns a <code>URLConnection</code> object that represents a
    # connection to the remote object referred to by the <code>URL</code>.
    # 
    # <p>A new connection is opened every time by calling the
    # <code>openConnection</code> method of the protocol handler for
    # this URL.
    # 
    # <p>If for the URL's protocol (such as HTTP or JAR), there
    # exists a public, specialized URLConnection subclass belonging
    # to one of the following packages or one of their subpackages:
    # java.lang, java.io, java.util, java.net, the connection
    # returned will be of that subclass. For example, for HTTP an
    # HttpURLConnection will be returned, and for JAR a
    # JarURLConnection will be returned.
    # 
    # @return     a <code>URLConnection</code> to the URL.
    # @exception  IOException  if an I/O exception occurs.
    # @see        java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    # @see        java.net.URLConnection
    # @see java.net.URLStreamHandler#openConnection(java.net.URL)
    def open_connection
      return @handler.open_connection(self)
    end
    
    typesig { [Proxy] }
    # Same as openConnection(), except that the connection will be
    # made through the specified proxy; Protocol handlers that do not
    # support proxing will ignore the proxy parameter and make a
    # normal connection.
    # 
    # Calling this method preempts the system's default ProxySelector
    # settings.
    # 
    # @param      proxy the Proxy through which this connection
    # will be made. If direct connection is desired,
    # Proxy.NO_PROXY should be specified.
    # @return     a <code>URLConnection</code> to the URL.
    # @exception  IOException  if an I/O exception occurs.
    # @exception  SecurityException if a security manager is present
    # and the caller doesn't have permission to connect
    # to the proxy.
    # @exception  IllegalArgumentException will be thrown if proxy is null,
    # or proxy has the wrong type
    # @exception  UnsupportedOperationException if the subclass that
    # implements the protocol handler doesn't support
    # this method.
    # @see        java.net.URL#URL(java.lang.String, java.lang.String,
    # int, java.lang.String)
    # @see        java.net.URLConnection
    # @see        java.net.URLStreamHandler#openConnection(java.net.URL,
    # java.net.Proxy)
    # @since      1.5
    def open_connection(proxy)
      if ((proxy).nil?)
        raise IllegalArgumentException.new("proxy can not be null")
      end
      sm = System.get_security_manager
      if (!(proxy.type).equal?(Proxy::Type::DIRECT) && !(sm).nil?)
        epoint = proxy.address
        if (epoint.is_unresolved)
          sm.check_connect(epoint.get_host_name, epoint.get_port)
        else
          sm.check_connect(epoint.get_address.get_host_address, epoint.get_port)
        end
      end
      return @handler.open_connection(self, proxy)
    end
    
    typesig { [] }
    # Opens a connection to this <code>URL</code> and returns an
    # <code>InputStream</code> for reading from that connection. This
    # method is a shorthand for:
    # <blockquote><pre>
    # openConnection().getInputStream()
    # </pre></blockquote>
    # 
    # @return     an input stream for reading from the URL connection.
    # @exception  IOException  if an I/O exception occurs.
    # @see        java.net.URL#openConnection()
    # @see        java.net.URLConnection#getInputStream()
    def open_stream
      return open_connection.get_input_stream
    end
    
    typesig { [] }
    # Gets the contents of this URL. This method is a shorthand for:
    # <blockquote><pre>
    # openConnection().getContent()
    # </pre></blockquote>
    # 
    # @return     the contents of this URL.
    # @exception  IOException  if an I/O exception occurs.
    # @see        java.net.URLConnection#getContent()
    def get_content
      return open_connection.get_content
    end
    
    typesig { [Array.typed(Class)] }
    # Gets the contents of this URL. This method is a shorthand for:
    # <blockquote><pre>
    # openConnection().getContent(Class[])
    # </pre></blockquote>
    # 
    # @param classes an array of Java types
    # @return     the content object of this URL that is the first match of
    # the types specified in the classes array.
    # null if none of the requested types are supported.
    # @exception  IOException  if an I/O exception occurs.
    # @see        java.net.URLConnection#getContent(Class[])
    # @since 1.3
    def get_content(classes)
      return open_connection.get_content(classes)
    end
    
    class_module.module_eval {
      # The URLStreamHandler factory.
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= nil
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
      
      typesig { [URLStreamHandlerFactory] }
      # Sets an application's <code>URLStreamHandlerFactory</code>.
      # This method can be called at most once in a given Java Virtual
      # Machine.
      # 
      # <p> The <code>URLStreamHandlerFactory</code> instance is used to
      # construct a stream protocol handler from a protocol name.
      # 
      # <p> If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param      fac   the desired factory.
      # @exception  Error  if the application has already set a factory.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't allow
      # the operation.
      # @see        java.net.URL#URL(java.lang.String, java.lang.String,
      # int, java.lang.String)
      # @see        java.net.URLStreamHandlerFactory
      # @see        SecurityManager#checkSetFactory
      def set_urlstream_handler_factory(fac)
        synchronized((self.attr_stream_handler_lock)) do
          if (!(self.attr_factory).nil?)
            raise JavaError.new("factory already defined")
          end
          security = System.get_security_manager
          if (!(security).nil?)
            security.check_set_factory
          end
          self.attr_handlers.clear
          self.attr_factory = fac
        end
      end
      
      # A table of protocol handlers.
      
      def handlers
        defined?(@@handlers) ? @@handlers : @@handlers= Hashtable.new
      end
      alias_method :attr_handlers, :handlers
      
      def handlers=(value)
        @@handlers = value
      end
      alias_method :attr_handlers=, :handlers=
      
      
      def stream_handler_lock
        defined?(@@stream_handler_lock) ? @@stream_handler_lock : @@stream_handler_lock= Object.new
      end
      alias_method :attr_stream_handler_lock, :stream_handler_lock
      
      def stream_handler_lock=(value)
        @@stream_handler_lock = value
      end
      alias_method :attr_stream_handler_lock=, :stream_handler_lock=
      
      typesig { [String] }
      # Returns the Stream Handler.
      # @param protocol the protocol to use
      def get_urlstream_handler(protocol)
        handler = self.attr_handlers.get(protocol)
        if ((handler).nil?)
          checked_with_factory = false
          # Use the factory (if any)
          if (!(self.attr_factory).nil?)
            handler = self.attr_factory.create_urlstream_handler(protocol)
            checked_with_factory = true
          end
          # Try java protocol handler
          if ((handler).nil?)
            package_prefix_list = nil
            package_prefix_list = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new(ProtocolPathProp, ""))).to_s
            if (!(package_prefix_list).equal?(""))
              package_prefix_list += "|"
            end
            # REMIND: decide whether to allow the "null" class prefix
            # or not.
            package_prefix_list += "sun.net.www.protocol"
            package_prefix_iter = StringTokenizer.new(package_prefix_list, "|")
            while ((handler).nil? && package_prefix_iter.has_more_tokens)
              package_prefix = package_prefix_iter.next_token.trim
              begin
                cls_name = package_prefix + "." + protocol + ".Handler"
                cls = nil
                begin
                  cls = Class.for_name(cls_name)
                rescue ClassNotFoundException => e
                  cl = ClassLoader.get_system_class_loader
                  if (!(cl).nil?)
                    cls = cl.load_class(cls_name)
                  end
                end
                if (!(cls).nil?)
                  handler = cls.new_instance
                end
              rescue Exception => e
                # any number of exceptions can get thrown here
              end
            end
          end
          synchronized((self.attr_stream_handler_lock)) do
            handler2 = nil
            # Check again with hashtable just in case another
            # thread created a handler since we last checked
            handler2 = self.attr_handlers.get(protocol)
            if (!(handler2).nil?)
              return handler2
            end
            # Check with factory if another thread set a
            # factory since our last check
            if (!checked_with_factory && !(self.attr_factory).nil?)
              handler2 = self.attr_factory.create_urlstream_handler(protocol)
            end
            if (!(handler2).nil?)
              # The handler from the factory must be given more
              # importance. Discard the default handler that
              # this thread created.
              handler = handler2
            end
            # Insert this handler into the hashtable
            if (!(handler).nil?)
              self.attr_handlers.put(protocol, handler)
            end
          end
        end
        return handler
      end
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # WriteObject is called to save the state of the URL to an
    # ObjectOutputStream. The handler is not saved since it is
    # specific to this system.
    # 
    # @serialData the default write object value. When read back in,
    # the reader must ensure that calling getURLStreamHandler with
    # the protocol variable returns a valid URLStreamHandler and
    # throw an IOException if it does not.
    def write_object(s)
      synchronized(self) do
        s.default_write_object
      end # write the fields
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the URL from the
    # stream.  It reads the components of the URL and finds the local
    # stream handler.
    def read_object(s)
      synchronized(self) do
        s.default_read_object # read the fields
        if (((@handler = get_urlstream_handler(@protocol))).nil?)
          raise IOException.new("unknown protocol: " + @protocol)
        end
        # Construct authority part
        if ((@authority).nil? && ((!(@host).nil? && @host.length > 0) || !(@port).equal?(-1)))
          if ((@host).nil?)
            @host = ""
          end
          @authority = (((@port).equal?(-1)) ? @host : @host + ":" + (@port).to_s).to_s
          # Handle hosts with userInfo in them
          at = @host.last_index_of(Character.new(?@.ord))
          if (!(at).equal?(-1))
            @user_info = (@host.substring(0, at)).to_s
            @host = (@host.substring(at + 1)).to_s
          end
        else
          if (!(@authority).nil?)
            # Construct user info part
            ind = @authority.index_of(Character.new(?@.ord))
            if (!(ind).equal?(-1))
              @user_info = (@authority.substring(0, ind)).to_s
            end
          end
        end
        # Construct path and query part
        @path = (nil).to_s
        @query = (nil).to_s
        if (!(@file).nil?)
          # Fix: only do this if hierarchical?
          q = @file.last_index_of(Character.new(??.ord))
          if (!(q).equal?(-1))
            @query = (@file.substring(q + 1)).to_s
            @path = (@file.substring(0, q)).to_s
          else
            @path = @file
          end
        end
      end
    end
    
    private
    alias_method :initialize__url, :initialize
  end
  
  class Parts 
    include_class_members URLImports
    
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    attr_accessor :query
    alias_method :attr_query, :query
    undef_method :query
    alias_method :attr_query=, :query=
    undef_method :query=
    
    attr_accessor :ref
    alias_method :attr_ref, :ref
    undef_method :ref
    alias_method :attr_ref=, :ref=
    undef_method :ref=
    
    typesig { [String] }
    def initialize(file)
      @path = nil
      @query = nil
      @ref = nil
      ind = file.index_of(Character.new(?#.ord))
      @ref = (ind < 0 ? nil : file.substring(ind + 1)).to_s
      file = (ind < 0 ? file : file.substring(0, ind)).to_s
      q = file.last_index_of(Character.new(??.ord))
      if (!(q).equal?(-1))
        @query = (file.substring(q + 1)).to_s
        @path = (file.substring(0, q)).to_s
      else
        @path = file
      end
    end
    
    typesig { [] }
    def get_path
      return @path
    end
    
    typesig { [] }
    def get_query
      return @query
    end
    
    typesig { [] }
    def get_ref
      return @ref
    end
    
    private
    alias_method :initialize__parts, :initialize
  end
  
end

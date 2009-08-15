require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Security, :Permission
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Sun::Net::Www, :MessageHeader
    }
  end
  
  # The abstract class <code>URLConnection</code> is the superclass
  # of all classes that represent a communications link between the
  # application and a URL. Instances of this class can be used both to
  # read from and to write to the resource referenced by the URL. In
  # general, creating a connection to a URL is a multistep process:
  # <p>
  # <center><table border=2 summary="Describes the process of creating a connection to a URL: openConnection() and connect() over time.">
  # <tr><th><code>openConnection()</code></th>
  # <th><code>connect()</code></th></tr>
  # <tr><td>Manipulate parameters that affect the connection to the remote
  # resource.</td>
  # <td>Interact with the resource; query header fields and
  # contents.</td></tr>
  # </table>
  # ----------------------------&gt;
  # <br>time</center>
  # 
  # <ol>
  # <li>The connection object is created by invoking the
  # <code>openConnection</code> method on a URL.
  # <li>The setup parameters and general request properties are manipulated.
  # <li>The actual connection to the remote object is made, using the
  # <code>connect</code> method.
  # <li>The remote object becomes available. The header fields and the contents
  # of the remote object can be accessed.
  # </ol>
  # <p>
  # The setup parameters are modified using the following methods:
  # <ul>
  # <li><code>setAllowUserInteraction</code>
  # <li><code>setDoInput</code>
  # <li><code>setDoOutput</code>
  # <li><code>setIfModifiedSince</code>
  # <li><code>setUseCaches</code>
  # </ul>
  # <p>
  # and the general request properties are modified using the method:
  # <ul>
  # <li><code>setRequestProperty</code>
  # </ul>
  # <p>
  # Default values for the <code>AllowUserInteraction</code> and
  # <code>UseCaches</code> parameters can be set using the methods
  # <code>setDefaultAllowUserInteraction</code> and
  # <code>setDefaultUseCaches</code>.
  # <p>
  # Each of the above <code>set</code> methods has a corresponding
  # <code>get</code> method to retrieve the value of the parameter or
  # general request property. The specific parameters and general
  # request properties that are applicable are protocol specific.
  # <p>
  # The following methods are used to access the header fields and
  # the contents after the connection is made to the remote object:
  # <ul>
  # <li><code>getContent</code>
  # <li><code>getHeaderField</code>
  # <li><code>getInputStream</code>
  # <li><code>getOutputStream</code>
  # </ul>
  # <p>
  # Certain header fields are accessed frequently. The methods:
  # <ul>
  # <li><code>getContentEncoding</code>
  # <li><code>getContentLength</code>
  # <li><code>getContentType</code>
  # <li><code>getDate</code>
  # <li><code>getExpiration</code>
  # <li><code>getLastModifed</code>
  # </ul>
  # <p>
  # provide convenient access to these fields. The
  # <code>getContentType</code> method is used by the
  # <code>getContent</code> method to determine the type of the remote
  # object; subclasses may find it convenient to override the
  # <code>getContentType</code> method.
  # <p>
  # In the common case, all of the pre-connection parameters and
  # general request properties can be ignored: the pre-connection
  # parameters and request properties default to sensible values. For
  # most clients of this interface, there are only two interesting
  # methods: <code>getInputStream</code> and <code>getContent</code>,
  # which are mirrored in the <code>URL</code> class by convenience methods.
  # <p>
  # More information on the request properties and header fields of
  # an <code>http</code> connection can be found at:
  # <blockquote><pre>
  # <a href="http://www.ietf.org/rfc/rfc2616.txt">http://www.ietf.org/rfc/rfc2616.txt</a>
  # </pre></blockquote>
  # 
  # Note about <code>fileNameMap</code>: In versions prior to JDK 1.1.6,
  # field <code>fileNameMap</code> of <code>URLConnection</code> was public.
  # In JDK 1.1.6 and later, <code>fileNameMap</code> is private; accessor
  # and mutator methods {@link #getFileNameMap() getFileNameMap} and
  # {@link #setFileNameMap(java.net.FileNameMap) setFileNameMap} are added
  # to access it.  This change is also described on the <a href=
  # "http://java.sun.com/products/jdk/1.2/compatibility.html">
  # Compatibility</a> page.
  # 
  # Invoking the <tt>close()</tt> methods on the <tt>InputStream</tt> or <tt>OutputStream</tt> of an
  # <tt>URLConnection</tt> after a request may free network resources associated with this
  # instance, unless particular protocol specifications specify different behaviours
  # for it.
  # 
  # @author  James Gosling
  # @see     java.net.URL#openConnection()
  # @see     java.net.URLConnection#connect()
  # @see     java.net.URLConnection#getContent()
  # @see     java.net.URLConnection#getContentEncoding()
  # @see     java.net.URLConnection#getContentLength()
  # @see     java.net.URLConnection#getContentType()
  # @see     java.net.URLConnection#getDate()
  # @see     java.net.URLConnection#getExpiration()
  # @see     java.net.URLConnection#getHeaderField(int)
  # @see     java.net.URLConnection#getHeaderField(java.lang.String)
  # @see     java.net.URLConnection#getInputStream()
  # @see     java.net.URLConnection#getLastModified()
  # @see     java.net.URLConnection#getOutputStream()
  # @see     java.net.URLConnection#setAllowUserInteraction(boolean)
  # @see     java.net.URLConnection#setDefaultUseCaches(boolean)
  # @see     java.net.URLConnection#setDoInput(boolean)
  # @see     java.net.URLConnection#setDoOutput(boolean)
  # @see     java.net.URLConnection#setIfModifiedSince(long)
  # @see     java.net.URLConnection#setRequestProperty(java.lang.String, java.lang.String)
  # @see     java.net.URLConnection#setUseCaches(boolean)
  # @since   JDK1.0
  class URLConnection 
    include_class_members URLConnectionImports
    
    # The URL represents the remote object on the World Wide Web to
    # which this connection is opened.
    # <p>
    # The value of this field can be accessed by the
    # <code>getURL</code> method.
    # <p>
    # The default value of this variable is the value of the URL
    # argument in the <code>URLConnection</code> constructor.
    # 
    # @see     java.net.URLConnection#getURL()
    # @see     java.net.URLConnection#url
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    # This variable is set by the <code>setDoInput</code> method. Its
    # value is returned by the <code>getDoInput</code> method.
    # <p>
    # A URL connection can be used for input and/or output. Setting the
    # <code>doInput</code> flag to <code>true</code> indicates that
    # the application intends to read data from the URL connection.
    # <p>
    # The default value of this field is <code>true</code>.
    # 
    # @see     java.net.URLConnection#getDoInput()
    # @see     java.net.URLConnection#setDoInput(boolean)
    attr_accessor :do_input
    alias_method :attr_do_input, :do_input
    undef_method :do_input
    alias_method :attr_do_input=, :do_input=
    undef_method :do_input=
    
    # This variable is set by the <code>setDoOutput</code> method. Its
    # value is returned by the <code>getDoOutput</code> method.
    # <p>
    # A URL connection can be used for input and/or output. Setting the
    # <code>doOutput</code> flag to <code>true</code> indicates
    # that the application intends to write data to the URL connection.
    # <p>
    # The default value of this field is <code>false</code>.
    # 
    # @see     java.net.URLConnection#getDoOutput()
    # @see     java.net.URLConnection#setDoOutput(boolean)
    attr_accessor :do_output
    alias_method :attr_do_output, :do_output
    undef_method :do_output
    alias_method :attr_do_output=, :do_output=
    undef_method :do_output=
    
    class_module.module_eval {
      
      def default_allow_user_interaction
        defined?(@@default_allow_user_interaction) ? @@default_allow_user_interaction : @@default_allow_user_interaction= false
      end
      alias_method :attr_default_allow_user_interaction, :default_allow_user_interaction
      
      def default_allow_user_interaction=(value)
        @@default_allow_user_interaction = value
      end
      alias_method :attr_default_allow_user_interaction=, :default_allow_user_interaction=
    }
    
    # If <code>true</code>, this <code>URL</code> is being examined in
    # a context in which it makes sense to allow user interactions such
    # as popping up an authentication dialog. If <code>false</code>,
    # then no user interaction is allowed.
    # <p>
    # The value of this field can be set by the
    # <code>setAllowUserInteraction</code> method.
    # Its value is returned by the
    # <code>getAllowUserInteraction</code> method.
    # Its default value is the value of the argument in the last invocation
    # of the <code>setDefaultAllowUserInteraction</code> method.
    # 
    # @see     java.net.URLConnection#getAllowUserInteraction()
    # @see     java.net.URLConnection#setAllowUserInteraction(boolean)
    # @see     java.net.URLConnection#setDefaultAllowUserInteraction(boolean)
    attr_accessor :allow_user_interaction
    alias_method :attr_allow_user_interaction, :allow_user_interaction
    undef_method :allow_user_interaction
    alias_method :attr_allow_user_interaction=, :allow_user_interaction=
    undef_method :allow_user_interaction=
    
    class_module.module_eval {
      
      def default_use_caches
        defined?(@@default_use_caches) ? @@default_use_caches : @@default_use_caches= true
      end
      alias_method :attr_default_use_caches, :default_use_caches
      
      def default_use_caches=(value)
        @@default_use_caches = value
      end
      alias_method :attr_default_use_caches=, :default_use_caches=
    }
    
    # If <code>true</code>, the protocol is allowed to use caching
    # whenever it can. If <code>false</code>, the protocol must always
    # try to get a fresh copy of the object.
    # <p>
    # This field is set by the <code>setUseCaches</code> method. Its
    # value is returned by the <code>getUseCaches</code> method.
    # <p>
    # Its default value is the value given in the last invocation of the
    # <code>setDefaultUseCaches</code> method.
    # 
    # @see     java.net.URLConnection#setUseCaches(boolean)
    # @see     java.net.URLConnection#getUseCaches()
    # @see     java.net.URLConnection#setDefaultUseCaches(boolean)
    attr_accessor :use_caches
    alias_method :attr_use_caches, :use_caches
    undef_method :use_caches
    alias_method :attr_use_caches=, :use_caches=
    undef_method :use_caches=
    
    # Some protocols support skipping the fetching of the object unless
    # the object has been modified more recently than a certain time.
    # <p>
    # A nonzero value gives a time as the number of milliseconds since
    # January 1, 1970, GMT. The object is fetched only if it has been
    # modified more recently than that time.
    # <p>
    # This variable is set by the <code>setIfModifiedSince</code>
    # method. Its value is returned by the
    # <code>getIfModifiedSince</code> method.
    # <p>
    # The default value of this field is <code>0</code>, indicating
    # that the fetching must always occur.
    # 
    # @see     java.net.URLConnection#getIfModifiedSince()
    # @see     java.net.URLConnection#setIfModifiedSince(long)
    attr_accessor :if_modified_since
    alias_method :attr_if_modified_since, :if_modified_since
    undef_method :if_modified_since
    alias_method :attr_if_modified_since=, :if_modified_since=
    undef_method :if_modified_since=
    
    # If <code>false</code>, this connection object has not created a
    # communications link to the specified URL. If <code>true</code>,
    # the communications link has been established.
    attr_accessor :connected
    alias_method :attr_connected, :connected
    undef_method :connected
    alias_method :attr_connected=, :connected=
    undef_method :connected=
    
    # @since 1.5
    attr_accessor :connect_timeout
    alias_method :attr_connect_timeout, :connect_timeout
    undef_method :connect_timeout
    alias_method :attr_connect_timeout=, :connect_timeout=
    undef_method :connect_timeout=
    
    attr_accessor :read_timeout
    alias_method :attr_read_timeout, :read_timeout
    undef_method :read_timeout
    alias_method :attr_read_timeout=, :read_timeout=
    undef_method :read_timeout=
    
    # @since 1.6
    attr_accessor :requests
    alias_method :attr_requests, :requests
    undef_method :requests
    alias_method :attr_requests=, :requests=
    undef_method :requests=
    
    class_module.module_eval {
      # @since   JDK1.1
      
      def file_name_map
        defined?(@@file_name_map) ? @@file_name_map : @@file_name_map= nil
      end
      alias_method :attr_file_name_map, :file_name_map
      
      def file_name_map=(value)
        @@file_name_map = value
      end
      alias_method :attr_file_name_map=, :file_name_map=
      
      # @since 1.2.2
      
      def file_name_map_loaded
        defined?(@@file_name_map_loaded) ? @@file_name_map_loaded : @@file_name_map_loaded= false
      end
      alias_method :attr_file_name_map_loaded, :file_name_map_loaded
      
      def file_name_map_loaded=(value)
        @@file_name_map_loaded = value
      end
      alias_method :attr_file_name_map_loaded=, :file_name_map_loaded=
      
      typesig { [] }
      # Loads filename map (a mimetable) from a data file. It will
      # first try to load the user-specific table, defined
      # by &quot;content.types.user.table&quot; property. If that fails,
      # it tries to load the default built-in table at
      # lib/content-types.properties under java home.
      # 
      # @return the FileNameMap
      # @since 1.2
      # @see #setFileNameMap(java.net.FileNameMap)
      def get_file_name_map
        synchronized(self) do
          if (((self.attr_file_name_map).nil?) && !self.attr_file_name_map_loaded)
            self.attr_file_name_map = Sun::Net::Www::MimeTable.load_table
            self.attr_file_name_map_loaded = true
          end
          return Class.new(FileNameMap.class == Class ? FileNameMap : Object) do
            extend LocalClass
            include_class_members URLConnection
            include FileNameMap if FileNameMap.class == Module
            
            attr_accessor :map
            alias_method :attr_map, :map
            undef_method :map
            alias_method :attr_map=, :map=
            undef_method :map=
            
            typesig { [String] }
            define_method :get_content_type_for do |file_name|
              return @map.get_content_type_for(file_name)
            end
            
            typesig { [] }
            define_method :initialize do
              @map = nil
              super()
              @map = self.attr_file_name_map
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
      end
      
      typesig { [FileNameMap] }
      # Sets the FileNameMap.
      # <p>
      # If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param map the FileNameMap to be set
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't allow the operation.
      # @see        SecurityManager#checkSetFactory
      # @see #getFileNameMap()
      # @since 1.2
      def set_file_name_map(map)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_set_factory
        end
        self.attr_file_name_map = map
      end
    }
    
    typesig { [] }
    # Opens a communications link to the resource referenced by this
    # URL, if such a connection has not already been established.
    # <p>
    # If the <code>connect</code> method is called when the connection
    # has already been opened (indicated by the <code>connected</code>
    # field having the value <code>true</code>), the call is ignored.
    # <p>
    # URLConnection objects go through two phases: first they are
    # created, then they are connected.  After being created, and
    # before being connected, various options can be specified
    # (e.g., doInput and UseCaches).  After connecting, it is an
    # error to try to set them.  Operations that depend on being
    # connected, like getContentLength, will implicitly perform the
    # connection, if necessary.
    # 
    # @throws SocketTimeoutException if the timeout expires before
    # the connection can be established
    # @exception  IOException  if an I/O error occurs while opening the
    # connection.
    # @see java.net.URLConnection#connected
    # @see #getConnectTimeout()
    # @see #setConnectTimeout(int)
    def connect
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets a specified timeout value, in milliseconds, to be used
    # when opening a communications link to the resource referenced
    # by this URLConnection.  If the timeout expires before the
    # connection can be established, a
    # java.net.SocketTimeoutException is raised. A timeout of zero is
    # interpreted as an infinite timeout.
    # 
    # <p> Some non-standard implmentation of this method may ignore
    # the specified timeout. To see the connect timeout set, please
    # call getConnectTimeout().
    # 
    # @param timeout an <code>int</code> that specifies the connect
    # timeout value in milliseconds
    # @throws IllegalArgumentException if the timeout parameter is negative
    # 
    # @see #getConnectTimeout()
    # @see #connect()
    # @since 1.5
    def set_connect_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeout can not be negative")
      end
      @connect_timeout = timeout
    end
    
    typesig { [] }
    # Returns setting for connect timeout.
    # <p>
    # 0 return implies that the option is disabled
    # (i.e., timeout of infinity).
    # 
    # @return an <code>int</code> that indicates the connect timeout
    # value in milliseconds
    # @see #setConnectTimeout(int)
    # @see #connect()
    # @since 1.5
    def get_connect_timeout
      return @connect_timeout
    end
    
    typesig { [::Java::Int] }
    # Sets the read timeout to a specified timeout, in
    # milliseconds. A non-zero value specifies the timeout when
    # reading from Input stream when a connection is established to a
    # resource. If the timeout expires before there is data available
    # for read, a java.net.SocketTimeoutException is raised. A
    # timeout of zero is interpreted as an infinite timeout.
    # 
    # <p> Some non-standard implementation of this method ignores the
    # specified timeout. To see the read timeout set, please call
    # getReadTimeout().
    # 
    # @param timeout an <code>int</code> that specifies the timeout
    # value to be used in milliseconds
    # @throws IllegalArgumentException if the timeout parameter is negative
    # 
    # @see #getReadTimeout()
    # @see InputStream#read()
    # @since 1.5
    def set_read_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeout can not be negative")
      end
      @read_timeout = timeout
    end
    
    typesig { [] }
    # Returns setting for read timeout. 0 return implies that the
    # option is disabled (i.e., timeout of infinity).
    # 
    # @return an <code>int</code> that indicates the read timeout
    # value in milliseconds
    # 
    # @see #setReadTimeout(int)
    # @see InputStream#read()
    # @since 1.5
    def get_read_timeout
      return @read_timeout
    end
    
    typesig { [URL] }
    # Constructs a URL connection to the specified URL. A connection to
    # the object referenced by the URL is not created.
    # 
    # @param   url   the specified URL.
    def initialize(url)
      @url = nil
      @do_input = true
      @do_output = false
      @allow_user_interaction = self.attr_default_allow_user_interaction
      @use_caches = self.attr_default_use_caches
      @if_modified_since = 0
      @connected = false
      @connect_timeout = 0
      @read_timeout = 0
      @requests = nil
      @url = url
    end
    
    typesig { [] }
    # Returns the value of this <code>URLConnection</code>'s <code>URL</code>
    # field.
    # 
    # @return  the value of this <code>URLConnection</code>'s <code>URL</code>
    # field.
    # @see     java.net.URLConnection#url
    def get_url
      return @url
    end
    
    typesig { [] }
    # Returns the value of the <code>content-length</code> header field.
    # 
    # @return  the content length of the resource that this connection's URL
    # references, or <code>-1</code> if the content length is
    # not known.
    def get_content_length
      return get_header_field_int("content-length", -1)
    end
    
    typesig { [] }
    # Returns the value of the <code>content-type</code> header field.
    # 
    # @return  the content type of the resource that the URL references,
    # or <code>null</code> if not known.
    # @see     java.net.URLConnection#getHeaderField(java.lang.String)
    def get_content_type
      return get_header_field("content-type")
    end
    
    typesig { [] }
    # Returns the value of the <code>content-encoding</code> header field.
    # 
    # @return  the content encoding of the resource that the URL references,
    # or <code>null</code> if not known.
    # @see     java.net.URLConnection#getHeaderField(java.lang.String)
    def get_content_encoding
      return get_header_field("content-encoding")
    end
    
    typesig { [] }
    # Returns the value of the <code>expires</code> header field.
    # 
    # @return  the expiration date of the resource that this URL references,
    # or 0 if not known. The value is the number of milliseconds since
    # January 1, 1970 GMT.
    # @see     java.net.URLConnection#getHeaderField(java.lang.String)
    def get_expiration
      return get_header_field_date("expires", 0)
    end
    
    typesig { [] }
    # Returns the value of the <code>date</code> header field.
    # 
    # @return  the sending date of the resource that the URL references,
    # or <code>0</code> if not known. The value returned is the
    # number of milliseconds since January 1, 1970 GMT.
    # @see     java.net.URLConnection#getHeaderField(java.lang.String)
    def get_date
      return get_header_field_date("date", 0)
    end
    
    typesig { [] }
    # Returns the value of the <code>last-modified</code> header field.
    # The result is the number of milliseconds since January 1, 1970 GMT.
    # 
    # @return  the date the resource referenced by this
    # <code>URLConnection</code> was last modified, or 0 if not known.
    # @see     java.net.URLConnection#getHeaderField(java.lang.String)
    def get_last_modified
      return get_header_field_date("last-modified", 0)
    end
    
    typesig { [String] }
    # Returns the value of the named header field.
    # <p>
    # If called on a connection that sets the same header multiple times
    # with possibly different values, only the last value is returned.
    # 
    # 
    # @param   name   the name of a header field.
    # @return  the value of the named header field, or <code>null</code>
    # if there is no such field in the header.
    def get_header_field(name)
      return nil
    end
    
    typesig { [] }
    # Returns an unmodifiable Map of the header fields.
    # The Map keys are Strings that represent the
    # response-header field names. Each Map value is an
    # unmodifiable List of Strings that represents
    # the corresponding field values.
    # 
    # @return a Map of header fields
    # @since 1.4
    def get_header_fields
      return Collections::EMPTY_MAP
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the value of the named field parsed as a number.
    # <p>
    # This form of <code>getHeaderField</code> exists because some
    # connection types (e.g., <code>http-ng</code>) have pre-parsed
    # headers. Classes for that connection type can override this method
    # and short-circuit the parsing.
    # 
    # @param   name      the name of the header field.
    # @param   Default   the default value.
    # @return  the value of the named field, parsed as an integer. The
    # <code>Default</code> value is returned if the field is
    # missing or malformed.
    def get_header_field_int(name, default)
      value = get_header_field(name)
      begin
        return JavaInteger.parse_int(value)
      rescue JavaException => e
      end
      return default
    end
    
    typesig { [String, ::Java::Long] }
    # Returns the value of the named field parsed as date.
    # The result is the number of milliseconds since January 1, 1970 GMT
    # represented by the named field.
    # <p>
    # This form of <code>getHeaderField</code> exists because some
    # connection types (e.g., <code>http-ng</code>) have pre-parsed
    # headers. Classes for that connection type can override this method
    # and short-circuit the parsing.
    # 
    # @param   name     the name of the header field.
    # @param   Default   a default value.
    # @return  the value of the field, parsed as a date. The value of the
    # <code>Default</code> argument is returned if the field is
    # missing or malformed.
    def get_header_field_date(name, default)
      value = get_header_field(name)
      begin
        return Date.parse(value)
      rescue JavaException => e
      end
      return default
    end
    
    typesig { [::Java::Int] }
    # Returns the key for the <code>n</code><sup>th</sup> header field.
    # It returns <code>null</code> if there are fewer than <code>n+1</code> fields.
    # 
    # @param   n   an index, where n>=0
    # @return  the key for the <code>n</code><sup>th</sup> header field,
    # or <code>null</code> if there are fewer than <code>n+1</code>
    # fields.
    def get_header_field_key(n)
      return nil
    end
    
    typesig { [::Java::Int] }
    # Returns the value for the <code>n</code><sup>th</sup> header field.
    # It returns <code>null</code> if there are fewer than
    # <code>n+1</code>fields.
    # <p>
    # This method can be used in conjunction with the
    # {@link #getHeaderFieldKey(int) getHeaderFieldKey} method to iterate through all
    # the headers in the message.
    # 
    # @param   n   an index, where n>=0
    # @return  the value of the <code>n</code><sup>th</sup> header field
    # or <code>null</code> if there are fewer than <code>n+1</code> fields
    # @see     java.net.URLConnection#getHeaderFieldKey(int)
    def get_header_field(n)
      return nil
    end
    
    typesig { [] }
    # Retrieves the contents of this URL connection.
    # <p>
    # This method first determines the content type of the object by
    # calling the <code>getContentType</code> method. If this is
    # the first time that the application has seen that specific content
    # type, a content handler for that content type is created:
    # <ol>
    # <li>If the application has set up a content handler factory instance
    # using the <code>setContentHandlerFactory</code> method, the
    # <code>createContentHandler</code> method of that instance is called
    # with the content type as an argument; the result is a content
    # handler for that content type.
    # <li>If no content handler factory has yet been set up, or if the
    # factory's <code>createContentHandler</code> method returns
    # <code>null</code>, then the application loads the class named:
    # <blockquote><pre>
    # sun.net.www.content.&lt;<i>contentType</i>&gt;
    # </pre></blockquote>
    # where &lt;<i>contentType</i>&gt; is formed by taking the
    # content-type string, replacing all slash characters with a
    # <code>period</code> ('.'), and all other non-alphanumeric characters
    # with the underscore character '<code>_</code>'. The alphanumeric
    # characters are specifically the 26 uppercase ASCII letters
    # '<code>A</code>' through '<code>Z</code>', the 26 lowercase ASCII
    # letters '<code>a</code>' through '<code>z</code>', and the 10 ASCII
    # digits '<code>0</code>' through '<code>9</code>'. If the specified
    # class does not exist, or is not a subclass of
    # <code>ContentHandler</code>, then an
    # <code>UnknownServiceException</code> is thrown.
    # </ol>
    # 
    # @return     the object fetched. The <code>instanceof</code> operator
    # should be used to determine the specific kind of object
    # returned.
    # @exception  IOException              if an I/O error occurs while
    # getting the content.
    # @exception  UnknownServiceException  if the protocol does not support
    # the content type.
    # @see        java.net.ContentHandlerFactory#createContentHandler(java.lang.String)
    # @see        java.net.URLConnection#getContentType()
    # @see        java.net.URLConnection#setContentHandlerFactory(java.net.ContentHandlerFactory)
    def get_content
      # Must call getInputStream before GetHeaderField gets called
      # so that FileNotFoundException has a chance to be thrown up
      # from here without being caught.
      get_input_stream
      return get_content_handler.get_content(self)
    end
    
    typesig { [Array.typed(Class)] }
    # Retrieves the contents of this URL connection.
    # 
    # @param classes the <code>Class</code> array
    # indicating the requested types
    # @return     the object fetched that is the first match of the type
    # specified in the classes array. null if none of
    # the requested types are supported.
    # The <code>instanceof</code> operator should be used to
    # determine the specific kind of object returned.
    # @exception  IOException              if an I/O error occurs while
    # getting the content.
    # @exception  UnknownServiceException  if the protocol does not support
    # the content type.
    # @see        java.net.URLConnection#getContent()
    # @see        java.net.ContentHandlerFactory#createContentHandler(java.lang.String)
    # @see        java.net.URLConnection#getContent(java.lang.Class[])
    # @see        java.net.URLConnection#setContentHandlerFactory(java.net.ContentHandlerFactory)
    # @since 1.3
    def get_content(classes)
      # Must call getInputStream before GetHeaderField gets called
      # so that FileNotFoundException has a chance to be thrown up
      # from here without being caught.
      get_input_stream
      return get_content_handler.get_content(self, classes)
    end
    
    typesig { [] }
    # Returns a permission object representing the permission
    # necessary to make the connection represented by this
    # object. This method returns null if no permission is
    # required to make the connection. By default, this method
    # returns <code>java.security.AllPermission</code>. Subclasses
    # should override this method and return the permission
    # that best represents the permission required to make a
    # a connection to the URL. For example, a <code>URLConnection</code>
    # representing a <code>file:</code> URL would return a
    # <code>java.io.FilePermission</code> object.
    # 
    # <p>The permission returned may dependent upon the state of the
    # connection. For example, the permission before connecting may be
    # different from that after connecting. For example, an HTTP
    # sever, say foo.com, may redirect the connection to a different
    # host, say bar.com. Before connecting the permission returned by
    # the connection will represent the permission needed to connect
    # to foo.com, while the permission returned after connecting will
    # be to bar.com.
    # 
    # <p>Permissions are generally used for two purposes: to protect
    # caches of objects obtained through URLConnections, and to check
    # the right of a recipient to learn about a particular URL. In
    # the first case, the permission should be obtained
    # <em>after</em> the object has been obtained. For example, in an
    # HTTP connection, this will represent the permission to connect
    # to the host from which the data was ultimately fetched. In the
    # second case, the permission should be obtained and tested
    # <em>before</em> connecting.
    # 
    # @return the permission object representing the permission
    # necessary to make the connection represented by this
    # URLConnection.
    # 
    # @exception IOException if the computation of the permission
    # requires network or file I/O and an exception occurs while
    # computing it.
    def get_permission
      return SecurityConstants::ALL_PERMISSION
    end
    
    typesig { [] }
    # Returns an input stream that reads from this open connection.
    # 
    # A SocketTimeoutException can be thrown when reading from the
    # returned input stream if the read timeout expires before data
    # is available for read.
    # 
    # @return     an input stream that reads from this open connection.
    # @exception  IOException              if an I/O error occurs while
    # creating the input stream.
    # @exception  UnknownServiceException  if the protocol does not support
    # input.
    # @see #setReadTimeout(int)
    # @see #getReadTimeout()
    def get_input_stream
      raise UnknownServiceException.new("protocol doesn't support input")
    end
    
    typesig { [] }
    # Returns an output stream that writes to this connection.
    # 
    # @return     an output stream that writes to this connection.
    # @exception  IOException              if an I/O error occurs while
    # creating the output stream.
    # @exception  UnknownServiceException  if the protocol does not support
    # output.
    def get_output_stream
      raise UnknownServiceException.new("protocol doesn't support output")
    end
    
    typesig { [] }
    # Returns a <code>String</code> representation of this URL connection.
    # 
    # @return  a string representation of this <code>URLConnection</code>.
    def to_s
      return RJava.cast_to_string(self.get_class.get_name) + ":" + RJava.cast_to_string(@url)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the value of the <code>doInput</code> field for this
    # <code>URLConnection</code> to the specified value.
    # <p>
    # A URL connection can be used for input and/or output.  Set the DoInput
    # flag to true if you intend to use the URL connection for input,
    # false if not.  The default is true.
    # 
    # @param   doinput   the new value.
    # @throws IllegalStateException if already connected
    # @see     java.net.URLConnection#doInput
    # @see #getDoInput()
    def set_do_input(doinput)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      @do_input = doinput
    end
    
    typesig { [] }
    # Returns the value of this <code>URLConnection</code>'s
    # <code>doInput</code> flag.
    # 
    # @return  the value of this <code>URLConnection</code>'s
    # <code>doInput</code> flag.
    # @see     #setDoInput(boolean)
    def get_do_input
      return @do_input
    end
    
    typesig { [::Java::Boolean] }
    # Sets the value of the <code>doOutput</code> field for this
    # <code>URLConnection</code> to the specified value.
    # <p>
    # A URL connection can be used for input and/or output.  Set the DoOutput
    # flag to true if you intend to use the URL connection for output,
    # false if not.  The default is false.
    # 
    # @param   dooutput   the new value.
    # @throws IllegalStateException if already connected
    # @see #getDoOutput()
    def set_do_output(dooutput)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      @do_output = dooutput
    end
    
    typesig { [] }
    # Returns the value of this <code>URLConnection</code>'s
    # <code>doOutput</code> flag.
    # 
    # @return  the value of this <code>URLConnection</code>'s
    # <code>doOutput</code> flag.
    # @see     #setDoOutput(boolean)
    def get_do_output
      return @do_output
    end
    
    typesig { [::Java::Boolean] }
    # Set the value of the <code>allowUserInteraction</code> field of
    # this <code>URLConnection</code>.
    # 
    # @param   allowuserinteraction   the new value.
    # @throws IllegalStateException if already connected
    # @see     #getAllowUserInteraction()
    def set_allow_user_interaction(allowuserinteraction)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      @allow_user_interaction = allowuserinteraction
    end
    
    typesig { [] }
    # Returns the value of the <code>allowUserInteraction</code> field for
    # this object.
    # 
    # @return  the value of the <code>allowUserInteraction</code> field for
    # this object.
    # @see     #setAllowUserInteraction(boolean)
    def get_allow_user_interaction
      return @allow_user_interaction
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Sets the default value of the
      # <code>allowUserInteraction</code> field for all future
      # <code>URLConnection</code> objects to the specified value.
      # 
      # @param   defaultallowuserinteraction   the new value.
      # @see     #getDefaultAllowUserInteraction()
      def set_default_allow_user_interaction(defaultallowuserinteraction)
        self.attr_default_allow_user_interaction = defaultallowuserinteraction
      end
      
      typesig { [] }
      # Returns the default value of the <code>allowUserInteraction</code>
      # field.
      # <p>
      # Ths default is "sticky", being a part of the static state of all
      # URLConnections.  This flag applies to the next, and all following
      # URLConnections that are created.
      # 
      # @return  the default value of the <code>allowUserInteraction</code>
      # field.
      # @see     #setDefaultAllowUserInteraction(boolean)
      def get_default_allow_user_interaction
        return self.attr_default_allow_user_interaction
      end
    }
    
    typesig { [::Java::Boolean] }
    # Sets the value of the <code>useCaches</code> field of this
    # <code>URLConnection</code> to the specified value.
    # <p>
    # Some protocols do caching of documents.  Occasionally, it is important
    # to be able to "tunnel through" and ignore the caches (e.g., the
    # "reload" button in a browser).  If the UseCaches flag on a connection
    # is true, the connection is allowed to use whatever caches it can.
    # If false, caches are to be ignored.
    # The default value comes from DefaultUseCaches, which defaults to
    # true.
    # 
    # @param usecaches a <code>boolean</code> indicating whether
    # or not to allow caching
    # @throws IllegalStateException if already connected
    # @see #getUseCaches()
    def set_use_caches(usecaches)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      @use_caches = usecaches
    end
    
    typesig { [] }
    # Returns the value of this <code>URLConnection</code>'s
    # <code>useCaches</code> field.
    # 
    # @return  the value of this <code>URLConnection</code>'s
    # <code>useCaches</code> field.
    # @see #setUseCaches(boolean)
    def get_use_caches
      return @use_caches
    end
    
    typesig { [::Java::Long] }
    # Sets the value of the <code>ifModifiedSince</code> field of
    # this <code>URLConnection</code> to the specified value.
    # 
    # @param   ifmodifiedsince   the new value.
    # @throws IllegalStateException if already connected
    # @see     #getIfModifiedSince()
    def set_if_modified_since(ifmodifiedsince)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      @if_modified_since = ifmodifiedsince
    end
    
    typesig { [] }
    # Returns the value of this object's <code>ifModifiedSince</code> field.
    # 
    # @return  the value of this object's <code>ifModifiedSince</code> field.
    # @see #setIfModifiedSince(long)
    def get_if_modified_since
      return @if_modified_since
    end
    
    typesig { [] }
    # Returns the default value of a <code>URLConnection</code>'s
    # <code>useCaches</code> flag.
    # <p>
    # Ths default is "sticky", being a part of the static state of all
    # URLConnections.  This flag applies to the next, and all following
    # URLConnections that are created.
    # 
    # @return  the default value of a <code>URLConnection</code>'s
    # <code>useCaches</code> flag.
    # @see     #setDefaultUseCaches(boolean)
    def get_default_use_caches
      return self.attr_default_use_caches
    end
    
    typesig { [::Java::Boolean] }
    # Sets the default value of the <code>useCaches</code> field to the
    # specified value.
    # 
    # @param   defaultusecaches   the new value.
    # @see     #getDefaultUseCaches()
    def set_default_use_caches(defaultusecaches)
      self.attr_default_use_caches = defaultusecaches
    end
    
    typesig { [String, String] }
    # Sets the general request property. If a property with the key already
    # exists, overwrite its value with the new value.
    # 
    # <p> NOTE: HTTP requires all request properties which can
    # legally have multiple instances with the same key
    # to use a comma-seperated list syntax which enables multiple
    # properties to be appended into a single property.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value   the value associated with it.
    # @throws IllegalStateException if already connected
    # @throws NullPointerException if key is <CODE>null</CODE>
    # @see #getRequestProperty(java.lang.String)
    def set_request_property(key, value)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key is null")
      end
      if ((@requests).nil?)
        @requests = MessageHeader.new
      end
      @requests.set(key, value)
    end
    
    typesig { [String, String] }
    # Adds a general request property specified by a
    # key-value pair.  This method will not overwrite
    # existing values associated with the same key.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value  the value associated with it.
    # @throws IllegalStateException if already connected
    # @throws NullPointerException if key is null
    # @see #getRequestProperties()
    # @since 1.4
    def add_request_property(key, value)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key is null")
      end
      if ((@requests).nil?)
        @requests = MessageHeader.new
      end
      @requests.add(key, value)
    end
    
    typesig { [String] }
    # Returns the value of the named general request property for this
    # connection.
    # 
    # @param key the keyword by which the request is known (e.g., "accept").
    # @return  the value of the named general request property for this
    # connection. If key is null, then null is returned.
    # @throws IllegalStateException if already connected
    # @see #setRequestProperty(java.lang.String, java.lang.String)
    def get_request_property(key)
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((@requests).nil?)
        return nil
      end
      return @requests.find_value(key)
    end
    
    typesig { [] }
    # Returns an unmodifiable Map of general request
    # properties for this connection. The Map keys
    # are Strings that represent the request-header
    # field names. Each Map value is a unmodifiable List
    # of Strings that represents the corresponding
    # field values.
    # 
    # @return  a Map of the general request properties for this connection.
    # @throws IllegalStateException if already connected
    # @since 1.4
    def get_request_properties
      if (@connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((@requests).nil?)
        return Collections::EMPTY_MAP
      end
      return @requests.get_headers(nil)
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # Sets the default value of a general request property. When a
      # <code>URLConnection</code> is created, it is initialized with
      # these properties.
      # 
      # @param   key     the keyword by which the request is known
      # (e.g., "<code>accept</code>").
      # @param   value   the value associated with the key.
      # 
      # @see java.net.URLConnection#setRequestProperty(java.lang.String,java.lang.String)
      # 
      # @deprecated The instance specific setRequestProperty method
      # should be used after an appropriate instance of URLConnection
      # is obtained. Invoking this method will have no effect.
      # 
      # @see #getDefaultRequestProperty(java.lang.String)
      def set_default_request_property(key, value)
      end
      
      typesig { [String] }
      # Returns the value of the default request property. Default request
      # properties are set for every connection.
      # 
      # @param key the keyword by which the request is known (e.g., "accept").
      # @return  the value of the default request property
      # for the specified key.
      # 
      # @see java.net.URLConnection#getRequestProperty(java.lang.String)
      # 
      # @deprecated The instance specific getRequestProperty method
      # should be used after an appropriate instance of URLConnection
      # is obtained.
      # 
      # @see #setDefaultRequestProperty(java.lang.String, java.lang.String)
      def get_default_request_property(key)
        return nil
      end
      
      # The ContentHandler factory.
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= nil
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
      
      typesig { [ContentHandlerFactory] }
      # Sets the <code>ContentHandlerFactory</code> of an
      # application. It can be called at most once by an application.
      # <p>
      # The <code>ContentHandlerFactory</code> instance is used to
      # construct a content handler from a content type
      # <p>
      # If there is a security manager, this method first calls
      # the security manager's <code>checkSetFactory</code> method
      # to ensure the operation is allowed.
      # This could result in a SecurityException.
      # 
      # @param      fac   the desired factory.
      # @exception  Error  if the factory has already been defined.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSetFactory</code> method doesn't allow the operation.
      # @see        java.net.ContentHandlerFactory
      # @see        java.net.URLConnection#getContent()
      # @see        SecurityManager#checkSetFactory
      def set_content_handler_factory(fac)
        synchronized(self) do
          if (!(self.attr_factory).nil?)
            raise JavaError.new("factory already defined")
          end
          security = System.get_security_manager
          if (!(security).nil?)
            security.check_set_factory
          end
          self.attr_factory = fac
        end
      end
      
      
      def handlers
        defined?(@@handlers) ? @@handlers : @@handlers= Hashtable.new
      end
      alias_method :attr_handlers, :handlers
      
      def handlers=(value)
        @@handlers = value
      end
      alias_method :attr_handlers=, :handlers=
      
      const_set_lazy(:UnknownContentHandlerP) { UnknownContentHandler.new }
      const_attr_reader  :UnknownContentHandlerP
    }
    
    typesig { [] }
    # Gets the Content Handler appropriate for this connection.
    # @param connection the connection to use.
    def get_content_handler
      synchronized(self) do
        content_type = strip_off_parameters(get_content_type)
        handler = nil
        if ((content_type).nil?)
          raise UnknownServiceException.new("no content-type")
        end
        begin
          handler = self.attr_handlers.get(content_type)
          if (!(handler).nil?)
            return handler
          end
        rescue JavaException => e
        end
        if (!(self.attr_factory).nil?)
          handler = self.attr_factory.create_content_handler(content_type)
        end
        if ((handler).nil?)
          begin
            handler = lookup_content_handler_class_for(content_type)
          rescue JavaException => e
            e.print_stack_trace
            handler = UnknownContentHandlerP
          end
          self.attr_handlers.put(content_type, handler)
        end
        return handler
      end
    end
    
    typesig { [String] }
    # Media types are in the format: type/subtype*(; parameter).
    # For looking up the content handler, we should ignore those
    # parameters.
    def strip_off_parameters(content_type)
      if ((content_type).nil?)
        return nil
      end
      index = content_type.index_of(Character.new(?;.ord))
      if (index > 0)
        return content_type.substring(0, index)
      else
        return content_type
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:ContentClassPrefix) { "sun.net.www.content" }
      const_attr_reader  :ContentClassPrefix
      
      const_set_lazy(:ContentPathProp) { "java.content.handler.pkgs" }
      const_attr_reader  :ContentPathProp
    }
    
    typesig { [String] }
    # Looks for a content handler in a user-defineable set of places.
    # By default it looks in sun.net.www.content, but users can define a
    # vertical-bar delimited set of class prefixes to search through in
    # addition by defining the java.content.handler.pkgs property.
    # The class name must be of the form:
    # <pre>
    # {package-prefix}.{major}.{minor}
    # e.g.
    # YoyoDyne.experimental.text.plain
    # </pre>
    def lookup_content_handler_class_for(content_type)
      content_handler_class_name = type_to_package_name(content_type)
      content_handler_pkg_prefixes = get_content_handler_pkg_prefixes
      package_prefix_iter = StringTokenizer.new(content_handler_pkg_prefixes, "|")
      while (package_prefix_iter.has_more_tokens)
        package_prefix = package_prefix_iter.next_token.trim
        begin
          cls_name = package_prefix + "." + content_handler_class_name
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
            return handler
          end
        rescue JavaException => e
        end
      end
      return UnknownContentHandlerP
    end
    
    typesig { [String] }
    # Utility function to map a MIME content type into an equivalent
    # pair of class name components.  For example: "text/html" would
    # be returned as "text.html"
    def type_to_package_name(content_type)
      # make sure we canonicalize the class name: all lower case
      content_type = RJava.cast_to_string(content_type.to_lower_case)
      len = content_type.length
      nm = CharArray.new(len)
      content_type.get_chars(0, len, nm, 0)
      i = 0
      while i < len
        c = nm[i]
        if ((c).equal?(Character.new(?/.ord)))
          nm[i] = Character.new(?..ord)
        else
          if (!(Character.new(?A.ord) <= c && c <= Character.new(?Z.ord) || Character.new(?a.ord) <= c && c <= Character.new(?z.ord) || Character.new(?0.ord) <= c && c <= Character.new(?9.ord)))
            nm[i] = Character.new(?_.ord)
          end
        end
        i += 1
      end
      return String.new(nm)
    end
    
    typesig { [] }
    # Returns a vertical bar separated list of package prefixes for potential
    # content handlers.  Tries to get the java.content.handler.pkgs property
    # to use as a set of package prefixes to search.  Whether or not
    # that property has been defined, the sun.net.www.content is always
    # the last one on the returned package list.
    def get_content_handler_pkg_prefixes
      package_prefix_list = AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new(ContentPathProp, ""))
      if (!(package_prefix_list).equal?(""))
        package_prefix_list += "|"
      end
      return package_prefix_list + ContentClassPrefix
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Tries to determine the content type of an object, based
      # on the specified "file" component of a URL.
      # This is a convenience method that can be used by
      # subclasses that override the <code>getContentType</code> method.
      # 
      # @param   fname   a filename.
      # @return  a guess as to what the content type of the object is,
      # based upon its file name.
      # @see     java.net.URLConnection#getContentType()
      def guess_content_type_from_name(fname)
        return get_file_name_map.get_content_type_for(fname)
      end
      
      typesig { [InputStream] }
      # Tries to determine the type of an input stream based on the
      # characters at the beginning of the input stream. This method can
      # be used by subclasses that override the
      # <code>getContentType</code> method.
      # <p>
      # Ideally, this routine would not be needed. But many
      # <code>http</code> servers return the incorrect content type; in
      # addition, there are many nonstandard extensions. Direct inspection
      # of the bytes to determine the content type is often more accurate
      # than believing the content type claimed by the <code>http</code> server.
      # 
      # @param      is   an input stream that supports marks.
      # @return     a guess at the content type, or <code>null</code> if none
      # can be determined.
      # @exception  IOException  if an I/O error occurs while reading the
      # input stream.
      # @see        java.io.InputStream#mark(int)
      # @see        java.io.InputStream#markSupported()
      # @see        java.net.URLConnection#getContentType()
      def guess_content_type_from_stream(is)
        # If we can't read ahead safely, just give up on guessing
        if (!is.mark_supported)
          return nil
        end
        is.mark(12)
        c1 = is.read
        c2 = is.read
        c3 = is.read
        c4 = is.read
        c5 = is.read
        c6 = is.read
        c7 = is.read
        c8 = is.read
        c9 = is.read
        c10 = is.read
        c11 = is.read
        is.reset
        if ((c1).equal?(0xca) && (c2).equal?(0xfe) && (c3).equal?(0xba) && (c4).equal?(0xbe))
          return "application/java-vm"
        end
        if ((c1).equal?(0xac) && (c2).equal?(0xed))
          # next two bytes are version number, currently 0x00 0x05
          return "application/x-java-serialized-object"
        end
        if ((c1).equal?(Character.new(?<.ord)))
          if ((c2).equal?(Character.new(?!.ord)) || (((c2).equal?(Character.new(?h.ord)) && ((c3).equal?(Character.new(?t.ord)) && (c4).equal?(Character.new(?m.ord)) && (c5).equal?(Character.new(?l.ord)) || (c3).equal?(Character.new(?e.ord)) && (c4).equal?(Character.new(?a.ord)) && (c5).equal?(Character.new(?d.ord))) || ((c2).equal?(Character.new(?b.ord)) && (c3).equal?(Character.new(?o.ord)) && (c4).equal?(Character.new(?d.ord)) && (c5).equal?(Character.new(?y.ord))))) || (((c2).equal?(Character.new(?H.ord)) && ((c3).equal?(Character.new(?T.ord)) && (c4).equal?(Character.new(?M.ord)) && (c5).equal?(Character.new(?L.ord)) || (c3).equal?(Character.new(?E.ord)) && (c4).equal?(Character.new(?A.ord)) && (c5).equal?(Character.new(?D.ord))) || ((c2).equal?(Character.new(?B.ord)) && (c3).equal?(Character.new(?O.ord)) && (c4).equal?(Character.new(?D.ord)) && (c5).equal?(Character.new(?Y.ord))))))
            return "text/html"
          end
          if ((c2).equal?(Character.new(??.ord)) && (c3).equal?(Character.new(?x.ord)) && (c4).equal?(Character.new(?m.ord)) && (c5).equal?(Character.new(?l.ord)) && (c6).equal?(Character.new(?\s.ord)))
            return "application/xml"
          end
        end
        # big and little endian UTF-16 encodings, with byte order mark
        if ((c1).equal?(0xfe) && (c2).equal?(0xff))
          if ((c3).equal?(0) && (c4).equal?(Character.new(?<.ord)) && (c5).equal?(0) && (c6).equal?(Character.new(??.ord)) && (c7).equal?(0) && (c8).equal?(Character.new(?x.ord)))
            return "application/xml"
          end
        end
        if ((c1).equal?(0xff) && (c2).equal?(0xfe))
          if ((c3).equal?(Character.new(?<.ord)) && (c4).equal?(0) && (c5).equal?(Character.new(??.ord)) && (c6).equal?(0) && (c7).equal?(Character.new(?x.ord)) && (c8).equal?(0))
            return "application/xml"
          end
        end
        if ((c1).equal?(Character.new(?G.ord)) && (c2).equal?(Character.new(?I.ord)) && (c3).equal?(Character.new(?F.ord)) && (c4).equal?(Character.new(?8.ord)))
          return "image/gif"
        end
        if ((c1).equal?(Character.new(?#.ord)) && (c2).equal?(Character.new(?d.ord)) && (c3).equal?(Character.new(?e.ord)) && (c4).equal?(Character.new(?f.ord)))
          return "image/x-bitmap"
        end
        if ((c1).equal?(Character.new(?!.ord)) && (c2).equal?(Character.new(?\s.ord)) && (c3).equal?(Character.new(?X.ord)) && (c4).equal?(Character.new(?P.ord)) && (c5).equal?(Character.new(?M.ord)) && (c6).equal?(Character.new(?2.ord)))
          return "image/x-pixmap"
        end
        if ((c1).equal?(137) && (c2).equal?(80) && (c3).equal?(78) && (c4).equal?(71) && (c5).equal?(13) && (c6).equal?(10) && (c7).equal?(26) && (c8).equal?(10))
          return "image/png"
        end
        if ((c1).equal?(0xff) && (c2).equal?(0xd8) && (c3).equal?(0xff))
          if ((c4).equal?(0xe0))
            return "image/jpeg"
          end
          # File format used by digital cameras to store images.
          # Exif Format can be read by any application supporting
          # JPEG. Exif Spec can be found at:
          # http://www.pima.net/standards/it10/PIMA15740/Exif_2-1.PDF
          if (((c4).equal?(0xe1)) && ((c7).equal?(Character.new(?E.ord)) && (c8).equal?(Character.new(?x.ord)) && (c9).equal?(Character.new(?i.ord)) && (c10).equal?(Character.new(?f.ord)) && (c11).equal?(0)))
            return "image/jpeg"
          end
          if ((c4).equal?(0xee))
            return "image/jpg"
          end
        end
        if ((c1).equal?(0xd0) && (c2).equal?(0xcf) && (c3).equal?(0x11) && (c4).equal?(0xe0) && (c5).equal?(0xa1) && (c6).equal?(0xb1) && (c7).equal?(0x1a) && (c8).equal?(0xe1))
          # Above is signature of Microsoft Structured Storage.
          # Below this, could have tests for various SS entities.
          # For now, just test for FlashPix.
          if (checkfpx(is))
            return "image/vnd.fpx"
          end
        end
        if ((c1).equal?(0x2e) && (c2).equal?(0x73) && (c3).equal?(0x6e) && (c4).equal?(0x64))
          return "audio/basic" # .au format, big endian
        end
        if ((c1).equal?(0x64) && (c2).equal?(0x6e) && (c3).equal?(0x73) && (c4).equal?(0x2e))
          return "audio/basic" # .au format, little endian
        end
        if ((c1).equal?(Character.new(?R.ord)) && (c2).equal?(Character.new(?I.ord)) && (c3).equal?(Character.new(?F.ord)) && (c4).equal?(Character.new(?F.ord)))
          # I don't know if this is official but evidence
          # suggests that .wav files start with "RIFF" - brown
          return "audio/x-wav"
        end
        return nil
      end
      
      typesig { [InputStream] }
      # Check for FlashPix image data in InputStream is.  Return true if
      # the stream has FlashPix data, false otherwise.  Before calling this
      # method, the stream should have already been checked to be sure it
      # contains Microsoft Structured Storage data.
      def checkfpx(is)
        # Test for FlashPix image data in Microsoft Structured Storage format.
        # In general, should do this with calls to an SS implementation.
        # Lacking that, need to dig via offsets to get to the FlashPix
        # ClassID.  Details:
        # 
        # Offset to Fpx ClsID from beginning of stream should be:
        # 
        # FpxClsidOffset = rootEntryOffset + clsidOffset
        # 
        # where: clsidOffset = 0x50.
        # rootEntryOffset = headerSize + sectorSize*sectDirStart
        # + 128*rootEntryDirectory
        # 
        # where:  headerSize = 0x200 (always)
        # sectorSize = 2 raised to power of uSectorShift,
        # which is found in the header at
        # offset 0x1E.
        # sectDirStart = found in the header at offset 0x30.
        # rootEntryDirectory = in general, should search for
        # directory labelled as root.
        # We will assume value of 0 (i.e.,
        # rootEntry is in first directory)
        # 
        # Mark the stream so we can reset it. 0x100 is enough for the first
        # few reads, but the mark will have to be reset and set again once
        # the offset to the root directory entry is computed. That offset
        # can be very large and isn't know until the stream has been read from
        is.mark(0x100)
        # Get the byte ordering located at 0x1E. 0xFE is Intel,
        # 0xFF is other
        to_skip = 0x1c
        posn = 0
        if ((posn = skip_forward(is, to_skip)) < to_skip)
          is.reset
          return false
        end
        c = Array.typed(::Java::Int).new(16) { 0 }
        if (read_bytes(c, 2, is) < 0)
          is.reset
          return false
        end
        byte_order = c[0]
        posn += 2
        u_sector_shift = 0
        if (read_bytes(c, 2, is) < 0)
          is.reset
          return false
        end
        if ((byte_order).equal?(0xfe))
          u_sector_shift = c[0]
          u_sector_shift += c[1] << 8
        else
          u_sector_shift = c[0] << 8
          u_sector_shift += c[1]
        end
        posn += 2
        to_skip = 0x30 - posn
        skipped = 0
        if ((skipped = skip_forward(is, to_skip)) < to_skip)
          is.reset
          return false
        end
        posn += skipped
        if (read_bytes(c, 4, is) < 0)
          is.reset
          return false
        end
        sect_dir_start = 0
        if ((byte_order).equal?(0xfe))
          sect_dir_start = c[0]
          sect_dir_start += c[1] << 8
          sect_dir_start += c[2] << 16
          sect_dir_start += c[3] << 24
        else
          sect_dir_start = c[0] << 24
          sect_dir_start += c[1] << 16
          sect_dir_start += c[2] << 8
          sect_dir_start += c[3]
        end
        posn += 4
        is.reset # Reset back to the beginning
        to_skip = 0x200 + (1 << u_sector_shift) * sect_dir_start + 0x50
        # Sanity check!
        if (to_skip < 0)
          return false
        end
        # How far can we skip? Is there any performance problem here?
        # This skip can be fairly long, at least 0x4c650 in at least
        # one case. Have to assume that the skip will fit in an int.
        # Leave room to read whole root dir
        is.mark(RJava.cast_to_int(to_skip) + 0x30)
        if ((skip_forward(is, to_skip)) < to_skip)
          is.reset
          return false
        end
        # should be at beginning of ClassID, which is as follows
        # (in Intel byte order):
        # 00 67 61 56 54 C1 CE 11 85 53 00 AA 00 A1 F9 5B
        # 
        # This is stored from Windows as long,short,short,char[8]
        # so for byte order changes, the order only changes for
        # the first 8 bytes in the ClassID.
        # 
        # Test against this, ignoring second byte (Intel) since
        # this could change depending on part of Fpx file we have.
        if (read_bytes(c, 16, is) < 0)
          is.reset
          return false
        end
        # intel byte order
        if ((byte_order).equal?(0xfe) && (c[0]).equal?(0x0) && (c[2]).equal?(0x61) && (c[3]).equal?(0x56) && (c[4]).equal?(0x54) && (c[5]).equal?(0xc1) && (c[6]).equal?(0xce) && (c[7]).equal?(0x11) && (c[8]).equal?(0x85) && (c[9]).equal?(0x53) && (c[10]).equal?(0x0) && (c[11]).equal?(0xaa) && (c[12]).equal?(0x0) && (c[13]).equal?(0xa1) && (c[14]).equal?(0xf9) && (c[15]).equal?(0x5b))
          is.reset
          return true
        # non-intel byte order
        else
          if ((c[3]).equal?(0x0) && (c[1]).equal?(0x61) && (c[0]).equal?(0x56) && (c[5]).equal?(0x54) && (c[4]).equal?(0xc1) && (c[7]).equal?(0xce) && (c[6]).equal?(0x11) && (c[8]).equal?(0x85) && (c[9]).equal?(0x53) && (c[10]).equal?(0x0) && (c[11]).equal?(0xaa) && (c[12]).equal?(0x0) && (c[13]).equal?(0xa1) && (c[14]).equal?(0xf9) && (c[15]).equal?(0x5b))
            is.reset
            return true
          end
        end
        is.reset
        return false
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, InputStream] }
      # Tries to read the specified number of bytes from the stream
      # Returns -1, If EOF is reached before len bytes are read, returns 0
      # otherwise
      def read_bytes(c, len, is)
        buf = Array.typed(::Java::Byte).new(len) { 0 }
        if (is.read(buf, 0, len) < len)
          return -1
        end
        # fill the passed in int array
        i = 0
        while i < len
          c[i] = buf[i] & 0xff
          i += 1
        end
        return 0
      end
      
      typesig { [InputStream, ::Java::Long] }
      # Skips through the specified number of bytes from the stream
      # until either EOF is reached, or the specified
      # number of bytes have been skipped
      def skip_forward(is, to_skip)
        each_skip = 0
        skipped = 0
        while (!(skipped).equal?(to_skip))
          each_skip = is.skip(to_skip - skipped)
          # check if EOF is reached
          if (each_skip <= 0)
            if ((is.read).equal?(-1))
              return skipped
            else
              skipped += 1
            end
          end
          skipped += each_skip
        end
        return skipped
      end
    }
    
    private
    alias_method :initialize__urlconnection, :initialize
  end
  
  class UnknownContentHandler < URLConnectionImports.const_get :ContentHandler
    include_class_members URLConnectionImports
    
    typesig { [URLConnection] }
    def get_content(uc)
      return uc.get_input_stream
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__unknown_content_handler, :initialize
  end
  
end

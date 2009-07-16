require "rjava"

# 
# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# FTP stream opener.
module Sun::Net::Www::Protocol::Ftp
  module FtpURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Ftp
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :InetSocketAddress
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :ProxySelector
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security, :Permission
      include_const ::Sun::Net::Www, :MessageHeader
      include_const ::Sun::Net::Www, :MeteredStream
      include_const ::Sun::Net::Www, :URLConnection
      include_const ::Sun::Net::Www::Protocol::Http, :HttpURLConnection
      include_const ::Sun::Net::Ftp, :FtpClient
      include_const ::Sun::Net::Ftp, :FtpProtocolException
      include_const ::Sun::Net, :ProgressSource
      include_const ::Sun::Net, :ProgressMonitor
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # 
  # This class Opens an FTP input (or output) stream given a URL.
  # It works as a one shot FTP transfer :
  # <UL>
  # <LI>Login</LI>
  # <LI>Get (or Put) the file</LI>
  # <LI>Disconnect</LI>
  # </UL>
  # You should not have to use it directly in most cases because all will be handled
  # in a abstract layer. Here is an example of how to use the class :
  # <P>
  # <code>URL url = new URL("ftp://ftp.sun.com/pub/test.txt");<p>
  # UrlConnection con = url.openConnection();<p>
  # InputStream is = con.getInputStream();<p>
  # ...<p>
  # is.close();</code>
  # 
  # @see sun.net.ftp.FtpClient
  class FtpURLConnection < FtpURLConnectionImports.const_get :URLConnection
    include_class_members FtpURLConnectionImports
    
    # In case we have to use proxies, we use HttpURLConnection
    attr_accessor :http
    alias_method :attr_http, :http
    undef_method :http
    alias_method :attr_http=, :http=
    undef_method :http=
    
    attr_accessor :inst_proxy
    alias_method :attr_inst_proxy, :inst_proxy
    undef_method :inst_proxy
    alias_method :attr_inst_proxy=, :inst_proxy=
    undef_method :inst_proxy=
    
    attr_accessor :proxy
    alias_method :attr_proxy, :proxy
    undef_method :proxy
    alias_method :attr_proxy=, :proxy=
    undef_method :proxy=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :os
    alias_method :attr_os, :os
    undef_method :os
    alias_method :attr_os=, :os=
    undef_method :os=
    
    attr_accessor :ftp
    alias_method :attr_ftp, :ftp
    undef_method :ftp
    alias_method :attr_ftp=, :ftp=
    undef_method :ftp=
    
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    attr_accessor :user
    alias_method :attr_user, :user
    undef_method :user
    alias_method :attr_user=, :user=
    undef_method :user=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :pathname
    alias_method :attr_pathname, :pathname
    undef_method :pathname
    alias_method :attr_pathname=, :pathname=
    undef_method :pathname=
    
    attr_accessor :filename
    alias_method :attr_filename, :filename
    undef_method :filename
    alias_method :attr_filename=, :filename=
    undef_method :filename=
    
    attr_accessor :fullpath
    alias_method :attr_fullpath, :fullpath
    undef_method :fullpath
    alias_method :attr_fullpath=, :fullpath=
    undef_method :fullpath=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    class_module.module_eval {
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      const_set_lazy(:ASCII) { 1 }
      const_attr_reader  :ASCII
      
      const_set_lazy(:BIN) { 2 }
      const_attr_reader  :BIN
      
      const_set_lazy(:DIR) { 3 }
      const_attr_reader  :DIR
    }
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # Redefine timeouts from java.net.URLConnection as we nee -1 to mean
    # not set. This is to ensure backward compatibility.
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
    
    class_module.module_eval {
      # 
      # For FTP URLs we need to have a special InputStream because we
      # need to close 2 sockets after we're done with it :
      # - The Data socket (for the file).
      # - The command socket (FtpClient).
      # Since that's the only class that needs to see that, it is an inner class.
      const_set_lazy(:FtpInputStream) { Class.new(FilterInputStream) do
        extend LocalClass
        include_class_members FtpURLConnection
        
        attr_accessor :ftp
        alias_method :attr_ftp, :ftp
        undef_method :ftp
        alias_method :attr_ftp=, :ftp=
        undef_method :ftp=
        
        typesig { [FtpClient, InputStream] }
        def initialize(cl, fd)
          @ftp = nil
          super(BufferedInputStream.new(fd))
          @ftp = cl
        end
        
        typesig { [] }
        def close
          super
          begin
            if (!(@ftp).nil?)
              @ftp.close_server
            end
          rescue IOException => ex
          end
        end
        
        private
        alias_method :initialize__ftp_input_stream, :initialize
      end }
      
      # 
      # For FTP URLs we need to have a special OutputStream because we
      # need to close 2 sockets after we're done with it :
      # - The Data socket (for the file).
      # - The command socket (FtpClient).
      # Since that's the only class that needs to see that, it is an inner class.
      const_set_lazy(:FtpOutputStream) { Class.new(FilterOutputStream) do
        extend LocalClass
        include_class_members FtpURLConnection
        
        attr_accessor :ftp
        alias_method :attr_ftp, :ftp
        undef_method :ftp
        alias_method :attr_ftp=, :ftp=
        undef_method :ftp=
        
        typesig { [FtpClient, OutputStream] }
        def initialize(cl, fd)
          @ftp = nil
          super(fd)
          @ftp = cl
        end
        
        typesig { [] }
        def close
          super
          begin
            if (!(@ftp).nil?)
              @ftp.close_server
            end
          rescue IOException => ex
          end
        end
        
        private
        alias_method :initialize__ftp_output_stream, :initialize
      end }
    }
    
    typesig { [URL] }
    # 
    # Creates an FtpURLConnection from a URL.
    # 
    # @param   url     The <code>URL</code> to retrieve or store.
    def initialize(url)
      initialize__ftp_urlconnection(url, nil)
    end
    
    typesig { [URL, Proxy] }
    # 
    # Same as FtpURLconnection(URL) with a per connection proxy specified
    def initialize(url, p)
      @http = nil
      @inst_proxy = nil
      @proxy = nil
      @is = nil
      @os = nil
      @ftp = nil
      @permission = nil
      @password = nil
      @user = nil
      @host = nil
      @pathname = nil
      @filename = nil
      @fullpath = nil
      @port = 0
      @type = 0
      @connect_timeout = 0
      @read_timeout = 0
      super(url)
      @http = nil
      @proxy = nil
      @is = nil
      @os = nil
      @ftp = nil
      @type = NONE
      @connect_timeout = -1
      @read_timeout = -1
      @inst_proxy = p
      @host = (url.get_host).to_s
      @port = url.get_port
      user_info = url.get_user_info
      if (!(user_info).nil?)
        # get the user and password
        delimiter = user_info.index_of(Character.new(?:.ord))
        if ((delimiter).equal?(-1))
          @user = (ParseUtil.decode(user_info)).to_s
          @password = (nil).to_s
        else
          @user = (ParseUtil.decode(user_info.substring(0, ((delimiter += 1) - 1)))).to_s
          @password = (ParseUtil.decode(user_info.substring(delimiter))).to_s
        end
      end
    end
    
    typesig { [] }
    def set_timeouts
      if (!(@ftp).nil?)
        if (@connect_timeout >= 0)
          @ftp.set_connect_timeout(@connect_timeout)
        end
        if (@read_timeout >= 0)
          @ftp.set_read_timeout(@read_timeout)
        end
      end
    end
    
    typesig { [] }
    # 
    # Connects to the FTP server and logs in.
    # 
    # @throws  FtpLoginException if the login is unsuccessful
    # @throws  FtpProtocolException if an error occurs
    # @throws  UnknownHostException if trying to connect to an unknown host
    def connect
      synchronized(self) do
        if (self.attr_connected)
          return
        end
        p = nil
        if ((@inst_proxy).nil?)
          sel = Java::Security::AccessController.do_privileged(# no per connection proxy specified
          # 
          # Do we have to use a proxie?
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members FtpURLConnection
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return ProxySelector.get_default
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if (!(sel).nil?)
            uri = Sun::Net::Www::ParseUtil.to_uri(self.attr_url)
            it = sel.select(uri).iterator
            while (it.has_next)
              p = it.next
              if ((p).nil? || (p).equal?(Proxy::NO_PROXY) || (p.type).equal?(Proxy::Type::SOCKS))
                break
              end
              if (!(p.type).equal?(Proxy::Type::HTTP) || !(p.address.is_a?(InetSocketAddress)))
                sel.connect_failed(uri, p.address, IOException.new("Wrong proxy type"))
                next
              end
              # OK, we have an http proxy
              paddr = p.address
              begin
                @http = HttpURLConnection.new(self.attr_url, p)
                if (@connect_timeout >= 0)
                  @http.set_connect_timeout(@connect_timeout)
                end
                if (@read_timeout >= 0)
                  @http.set_read_timeout(@read_timeout)
                end
                @http.connect
                self.attr_connected = true
                return
              rescue IOException => ioe
                sel.connect_failed(uri, paddr, ioe)
                @http = nil
              end
            end
          end
        else
          # per connection proxy specified
          p = @inst_proxy
          if ((p.type).equal?(Proxy::Type::HTTP))
            @http = HttpURLConnection.new(self.attr_url, @inst_proxy)
            if (@connect_timeout >= 0)
              @http.set_connect_timeout(@connect_timeout)
            end
            if (@read_timeout >= 0)
              @http.set_read_timeout(@read_timeout)
            end
            @http.connect
            self.attr_connected = true
            return
          end
        end
        if ((@user).nil?)
          @user = "anonymous"
          vers = Java::Security::AccessController.do_privileged(GetPropertyAction.new("java.version"))
          @password = (Java::Security::AccessController.do_privileged(GetPropertyAction.new("ftp.protocol.user", "Java" + vers + "@"))).to_s
        end
        begin
          if (!(p).nil?)
            @ftp = FtpClient.new(p)
          else
            @ftp = FtpClient.new
          end
          set_timeouts
          if (!(@port).equal?(-1))
            @ftp.open_server(@host, @port)
          else
            @ftp.open_server(@host)
          end
        rescue UnknownHostException => e
          # Maybe do something smart here, like use a proxy like iftp.
          # Just keep throwing for now.
          raise e
        end
        begin
          @ftp.login(@user, @password)
        rescue Sun::Net::Ftp::FtpLoginException => e
          @ftp.close_server
          raise e_
        end
        self.attr_connected = true
      end
    end
    
    typesig { [String] }
    # 
    # Decodes the path as per the RFC-1738 specifications.
    def decode_path(path)
      i = path.index_of(";type=")
      if (i >= 0)
        s1 = path.substring(i + 6, path.length)
        if ("i".equals_ignore_case(s1))
          @type = BIN
        end
        if ("a".equals_ignore_case(s1))
          @type = ASCII
        end
        if ("d".equals_ignore_case(s1))
          @type = DIR
        end
        path = (path.substring(0, i)).to_s
      end
      if (!(path).nil? && path.length > 1 && (path.char_at(0)).equal?(Character.new(?/.ord)))
        path = (path.substring(1)).to_s
      end
      if ((path).nil? || (path.length).equal?(0))
        path = "./"
      end
      if (!path.ends_with("/"))
        i = path.last_index_of(Character.new(?/.ord))
        if (i > 0)
          @filename = (path.substring(i + 1, path.length)).to_s
          @filename = (ParseUtil.decode(@filename)).to_s
          @pathname = (path.substring(0, i)).to_s
        else
          @filename = (ParseUtil.decode(path)).to_s
          @pathname = (nil).to_s
        end
      else
        @pathname = (path.substring(0, path.length - 1)).to_s
        @filename = (nil).to_s
      end
      if (!(@pathname).nil?)
        @fullpath = @pathname + "/" + ((!(@filename).nil? ? @filename : "")).to_s
      else
        @fullpath = @filename
      end
    end
    
    typesig { [String] }
    # 
    # As part of RFC-1738 it is specified that the path should be
    # interpreted as a series of FTP CWD commands.
    # This is because, '/' is not necessarly the directory delimiter
    # on every systems.
    def cd(path)
      if ((path).nil? || ("" == path))
        return
      end
      if ((path.index_of(Character.new(?/.ord))).equal?(-1))
        @ftp.cd(ParseUtil.decode(path))
        return
      end
      token = StringTokenizer.new(path, "/")
      while (token.has_more_tokens)
        @ftp.cd(ParseUtil.decode(token.next_token))
      end
    end
    
    typesig { [] }
    # 
    # Get the InputStream to retreive the remote file. It will issue the
    # "get" (or "dir") command to the ftp server.
    # 
    # @return  the <code>InputStream</code> to the connection.
    # 
    # @throws  IOException if already opened for output
    # @throws  FtpProtocolException if errors occur during the transfert.
    def get_input_stream
      if (!self.attr_connected)
        connect
      end
      if (!(@http).nil?)
        return @http.get_input_stream
      end
      if (!(@os).nil?)
        raise IOException.new("Already opened for output")
      end
      if (!(@is).nil?)
        return @is
      end
      msgh = MessageHeader.new
      begin
        decode_path(self.attr_url.get_path)
        if ((@filename).nil? || (@type).equal?(DIR))
          @ftp.ascii
          cd(@pathname)
          if ((@filename).nil?)
            @is = FtpInputStream.new_local(self, @ftp, @ftp.list)
          else
            @is = FtpInputStream.new_local(self, @ftp, @ftp.name_list(@filename))
          end
        else
          if ((@type).equal?(ASCII))
            @ftp.ascii
          else
            @ftp.binary
          end
          cd(@pathname)
          @is = FtpInputStream.new_local(self, @ftp, @ftp.get(@filename))
        end
        # Try to get the size of the file in bytes.  If that is
        # successful, then create a MeteredStream.
        begin
          response = @ftp.get_response_string
          offset = 0
          if (!((offset = response.index_of(" bytes)"))).equal?(-1))
            i = offset
            c = 0
            while ((i -= 1) >= 0 && ((c = response.char_at(i)) >= Character.new(?0.ord) && c <= Character.new(?9.ord)))
            end
            i = JavaInteger.parse_int(response.substring(i + 1, offset))
            msgh.add("content-length", "" + (i).to_s)
            if (i > 0)
              # Wrap input stream with MeteredStream to ensure read() will always return -1
              # at expected length.
              # Check if URL should be metered
              metered_input = ProgressMonitor.get_default.should_meter_input(self.attr_url, "GET")
              pi = nil
              if (metered_input)
                pi = ProgressSource.new(self.attr_url, "GET", i)
                pi.begin_tracking
              end
              @is = MeteredStream.new(@is, pi, i)
            end
          end
        rescue Exception => e
          e.print_stack_trace
          # do nothing, since all we were doing was trying to
          # get the size in bytes of the file
        end
        type_ = guess_content_type_from_name(@fullpath)
        if ((type_).nil? && @is.mark_supported)
          type_ = (guess_content_type_from_stream(@is)).to_s
        end
        if (!(type_).nil?)
          msgh.add("content-type", type_)
        end
      rescue FileNotFoundException => e
        begin
          cd(@fullpath)
          # if that worked, then make a directory listing
          # and build an html stream with all the files in
          # the directory
          @ftp.ascii
          @is = FtpInputStream.new_local(self, @ftp, @ftp.list)
          msgh.add("content-type", "text/plain")
        rescue IOException => ex
          raise FileNotFoundException.new(@fullpath)
        end
      end
      set_properties(msgh)
      return @is
    end
    
    typesig { [] }
    # 
    # Get the OutputStream to store the remote file. It will issue the
    # "put" command to the ftp server.
    # 
    # @return  the <code>OutputStream</code> to the connection.
    # 
    # @throws  IOException if already opened for input or the URL
    # points to a directory
    # @throws  FtpProtocolException if errors occur during the transfert.
    def get_output_stream
      if (!self.attr_connected)
        connect
      end
      if (!(@http).nil?)
        return @http.get_output_stream
      end
      if (!(@is).nil?)
        raise IOException.new("Already opened for input")
      end
      if (!(@os).nil?)
        return @os
      end
      decode_path(self.attr_url.get_path)
      if ((@filename).nil? || (@filename.length).equal?(0))
        raise IOException.new("illegal filename for a PUT")
      end
      if (!(@pathname).nil?)
        cd(@pathname)
      end
      if ((@type).equal?(ASCII))
        @ftp.ascii
      else
        @ftp.binary
      end
      @os = FtpOutputStream.new_local(self, @ftp, @ftp.put(@filename))
      return @os
    end
    
    typesig { [String] }
    def guess_content_type_from_filename(fname)
      return guess_content_type_from_name(fname)
    end
    
    typesig { [] }
    # 
    # Gets the <code>Permission</code> associated with the host & port.
    # 
    # @return  The <code>Permission</code> object.
    def get_permission
      if ((@permission).nil?)
        port = self.attr_url.get_port
        port = port < 0 ? FtpClient::FTP_PORT : port
        host = (@host).to_s + ":" + (port).to_s
        @permission = SocketPermission.new(host, "connect")
      end
      return @permission
    end
    
    typesig { [String, String] }
    # 
    # Sets the general request property. If a property with the key already
    # exists, overwrite its value with the new value.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value   the value associated with it.
    # @throws IllegalStateException if already connected
    # @see #getRequestProperty(java.lang.String)
    def set_request_property(key, value)
      super(key, value)
      if (("type" == key))
        if ("i".equals_ignore_case(value))
          @type = BIN
        else
          if ("a".equals_ignore_case(value))
            @type = ASCII
          else
            if ("d".equals_ignore_case(value))
              @type = DIR
            else
              raise IllegalArgumentException.new("Value of '" + key + "' request property was '" + value + "' when it must be either 'i', 'a' or 'd'")
            end
          end
        end
      end
    end
    
    typesig { [String] }
    # 
    # Returns the value of the named general request property for this
    # connection.
    # 
    # @param key the keyword by which the request is known (e.g., "accept").
    # @return  the value of the named general request property for this
    # connection.
    # @throws IllegalStateException if already connected
    # @see #setRequestProperty(java.lang.String, java.lang.String)
    def get_request_property(key)
      value = super(key)
      if ((value).nil?)
        if (("type" == key))
          value = (((@type).equal?(ASCII) ? "a" : (@type).equal?(DIR) ? "d" : "i")).to_s
        end
      end
      return value
    end
    
    typesig { [::Java::Int] }
    def set_connect_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @connect_timeout = timeout
    end
    
    typesig { [] }
    def get_connect_timeout
      return (@connect_timeout < 0 ? 0 : @connect_timeout)
    end
    
    typesig { [::Java::Int] }
    def set_read_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @read_timeout = timeout
    end
    
    typesig { [] }
    def get_read_timeout
      return @read_timeout < 0 ? 0 : @read_timeout
    end
    
    private
    alias_method :initialize__ftp_urlconnection, :initialize
  end
  
end

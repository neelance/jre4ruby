require "rjava"

# Copyright 1994-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Ftp
  module FtpClientImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Ftp
      include_const ::Java::Util, :StringTokenizer
      include ::Java::Util::Regex
      include ::Java::Io
      include ::Java::Net
      include_const ::Sun::Net, :TransferProtocolClient
      include_const ::Sun::Net, :TelnetInputStream
      include_const ::Sun::Net, :TelnetOutputStream
      include_const ::Sun::Misc, :RegexpPool
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class implements the FTP client.
  # 
  # @author      Jonathan Payne
  class FtpClient < FtpClientImports.const_get :TransferProtocolClient
    include_class_members FtpClientImports
    
    class_module.module_eval {
      const_set_lazy(:FTP_PORT) { 21 }
      const_attr_reader  :FTP_PORT
      
      
      def ftp_success
        defined?(@@ftp_success) ? @@ftp_success : @@ftp_success= 1
      end
      alias_method :attr_ftp_success, :ftp_success
      
      def ftp_success=(value)
        @@ftp_success = value
      end
      alias_method :attr_ftp_success=, :ftp_success=
      
      
      def ftp_try_again
        defined?(@@ftp_try_again) ? @@ftp_try_again : @@ftp_try_again= 2
      end
      alias_method :attr_ftp_try_again, :ftp_try_again
      
      def ftp_try_again=(value)
        @@ftp_try_again = value
      end
      alias_method :attr_ftp_try_again=, :ftp_try_again=
      
      
      def ftp_error
        defined?(@@ftp_error) ? @@ftp_error : @@ftp_error= 3
      end
      alias_method :attr_ftp_error, :ftp_error
      
      def ftp_error=(value)
        @@ftp_error = value
      end
      alias_method :attr_ftp_error=, :ftp_error=
    }
    
    # remember the ftp server name because we may need it
    attr_accessor :server_name
    alias_method :attr_server_name, :server_name
    undef_method :server_name
    alias_method :attr_server_name=, :server_name=
    undef_method :server_name=
    
    # socket for data transfer
    attr_accessor :reply_pending
    alias_method :attr_reply_pending, :reply_pending
    undef_method :reply_pending
    alias_method :attr_reply_pending=, :reply_pending=
    undef_method :reply_pending=
    
    attr_accessor :binary_mode
    alias_method :attr_binary_mode, :binary_mode
    undef_method :binary_mode
    alias_method :attr_binary_mode=, :binary_mode=
    undef_method :binary_mode=
    
    attr_accessor :logged_in
    alias_method :attr_logged_in, :logged_in
    undef_method :logged_in
    alias_method :attr_logged_in=, :logged_in=
    undef_method :logged_in=
    
    class_module.module_eval {
      # regexp pool of hosts for which we should connect directly, not Proxy
      # these are intialized from a property.
      
      def non_proxy_hosts_pool
        defined?(@@non_proxy_hosts_pool) ? @@non_proxy_hosts_pool : @@non_proxy_hosts_pool= nil
      end
      alias_method :attr_non_proxy_hosts_pool, :non_proxy_hosts_pool
      
      def non_proxy_hosts_pool=(value)
        @@non_proxy_hosts_pool = value
      end
      alias_method :attr_non_proxy_hosts_pool=, :non_proxy_hosts_pool=
      
      # The string soucre of nonProxyHostsPool
      
      def non_proxy_hosts_source
        defined?(@@non_proxy_hosts_source) ? @@non_proxy_hosts_source : @@non_proxy_hosts_source= nil
      end
      alias_method :attr_non_proxy_hosts_source, :non_proxy_hosts_source
      
      def non_proxy_hosts_source=(value)
        @@non_proxy_hosts_source = value
      end
      alias_method :attr_non_proxy_hosts_source=, :non_proxy_hosts_source=
    }
    
    # last command issued
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    # The last reply code from the ftp daemon.
    attr_accessor :last_reply_code
    alias_method :attr_last_reply_code, :last_reply_code
    undef_method :last_reply_code
    alias_method :attr_last_reply_code=, :last_reply_code=
    undef_method :last_reply_code=
    
    # Welcome message from the server, if any.
    attr_accessor :welcome_msg
    alias_method :attr_welcome_msg, :welcome_msg
    undef_method :welcome_msg
    alias_method :attr_welcome_msg=, :welcome_msg=
    undef_method :welcome_msg=
    
    class_module.module_eval {
      typesig { [] }
      # these methods are used to determine whether ftp urls are sent to
      # an http server instead of using a direct connection to the
      # host. They aren't used directly here.
      # 
      # @return if the networking layer should send ftp connections through
      # a proxy
      def get_use_ftp_proxy
        # if the ftp.proxyHost is set, use it!
        return (!(get_ftp_proxy_host).nil?)
      end
      
      typesig { [] }
      # @return the host to use, or null if none has been specified
      def get_ftp_proxy_host
        return Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members FtpClient
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            result = System.get_property("ftp.proxyHost")
            if ((result).nil?)
              result = (System.get_property("ftpProxyHost")).to_s
            end
            if ((result).nil?)
              # as a last resort we use the general one if ftp.useProxy
              # is true
              if (Boolean.get_boolean("ftp.useProxy"))
                result = (System.get_property("proxyHost")).to_s
              end
            end
            return result
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      # @return the proxy port to use.  Will default reasonably if not set.
      def get_ftp_proxy_port
        result = Array.typed(::Java::Int).new([80])
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members FtpClient
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            tmp = System.get_property("ftp.proxyPort")
            if ((tmp).nil?)
              # for compatibility with 1.0.2
              tmp = (System.get_property("ftpProxyPort")).to_s
            end
            if ((tmp).nil?)
              # as a last resort we use the general one if ftp.useProxy
              # is true
              if (Boolean.get_boolean("ftp.useProxy"))
                tmp = (System.get_property("proxyPort")).to_s
              end
            end
            if (!(tmp).nil?)
              result[0] = JavaInteger.parse_int(tmp)
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return result[0]
      end
      
      typesig { [String] }
      def match_non_proxy_hosts(host)
        synchronized((FtpClient.class)) do
          raw_list = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("ftp.nonProxyHosts"))
          if ((raw_list).nil?)
            self.attr_non_proxy_hosts_pool = nil
          else
            if (!(raw_list == self.attr_non_proxy_hosts_source))
              pool = RegexpPool.new
              st = StringTokenizer.new(raw_list, "|", false)
              begin
                while (st.has_more_tokens)
                  pool.add(st.next_token.to_lower_case, Boolean::TRUE)
                end
              rescue Sun::Misc::REException => ex
                System.err.println("Error in http.nonProxyHosts system property: " + (ex).to_s)
              end
              self.attr_non_proxy_hosts_pool = pool
            end
          end
          self.attr_non_proxy_hosts_source = raw_list
        end
        if ((self.attr_non_proxy_hosts_pool).nil?)
          return false
        end
        if (!(self.attr_non_proxy_hosts_pool.match(host)).nil?)
          return true
        else
          return false
        end
      end
    }
    
    typesig { [] }
    # issue the QUIT command to the FTP server and close the connection.
    # 
    # @exception       FtpProtocolException if an error occured
    def close_server
      if (server_is_open)
        issue_command("QUIT")
        super
      end
    end
    
    typesig { [String] }
    # Send a command to the FTP server.
    # 
    # @param   cmd     String containing the command
    # @return          reply code
    # 
    # @exception       FtpProtocolException if an error occured
    def issue_command(cmd)
      @command = cmd
      reply = 0
      while (@reply_pending)
        @reply_pending = false
        if ((read_reply).equal?(self.attr_ftp_error))
          raise FtpProtocolException.new("Error reading FTP pending reply\n")
        end
      end
      begin
        send_server(cmd + "\r\n")
        reply = read_reply
      end while ((reply).equal?(self.attr_ftp_try_again))
      return reply
    end
    
    typesig { [String] }
    # Send a command to the FTP server and check for success.
    # 
    # @param   cmd     String containing the command
    # 
    # @exception       FtpProtocolException if an error occured
    def issue_command_check(cmd)
      if (!(issue_command(cmd)).equal?(self.attr_ftp_success))
        raise FtpProtocolException.new(cmd + ":" + (get_response_string).to_s)
      end
    end
    
    typesig { [] }
    # Read the reply from the FTP server.
    # 
    # @return          FTP_SUCCESS or FTP_ERROR depending on success
    # @exception       FtpProtocolException if an error occured
    def read_reply
      @last_reply_code = read_server_response
      case (@last_reply_code / 100)
      # falls into ...
      when 1
        @reply_pending = true
        return self.attr_ftp_success
      when 2, 3
        return self.attr_ftp_success
      when 5
        if ((@last_reply_code).equal?(530))
          if (!@logged_in)
            raise FtpLoginException.new("Not logged in")
          end
          return self.attr_ftp_error
        end
        if ((@last_reply_code).equal?(550))
          raise FileNotFoundException.new(@command + ": " + (get_response_string).to_s)
        end
      end
      # this statement is not reached
      return self.attr_ftp_error
    end
    
    typesig { [] }
    # Tries to open a Data Connection in "PASSIVE" mode by issuing a EPSV or
    # PASV command then opening a Socket to the specified address & port
    # 
    # @return          the opened socket
    # @exception       FtpProtocolException if an error occurs when issuing the
    # PASV command to the ftp server.
    def open_passive_data_connection
      server_answer = nil
      port = 0
      dest = nil
      # Here is the idea:
      # 
      # - First we want to try the new (and IPv6 compatible) EPSV command
      # But since we want to be nice with NAT software, we'll issue the
      # EPSV ALL cmd first.
      # EPSV is documented in RFC2428
      # - If EPSV fails, then we fall back to the older, yet OK PASV command
      # - If PASV fails as well, then we throw an exception and the calling method
      # will have to try the EPRT or PORT command
      if ((issue_command("EPSV ALL")).equal?(self.attr_ftp_success))
        # We can safely use EPSV commands
        if ((issue_command("EPSV")).equal?(self.attr_ftp_error))
          raise FtpProtocolException.new("EPSV Failed: " + (get_response_string).to_s)
        end
        server_answer = (get_response_string).to_s
        # The response string from a EPSV command will contain the port number
        # the format will be :
        # 229 Entering Extended Passive Mode (|||58210|)
        # 
        # So we'll use the regular expresions package to parse the output.
        p = Pattern.compile("^229 .* \\(\\|\\|\\|(\\d+)\\|\\)")
        m = p.matcher(server_answer)
        if (!m.find)
          raise FtpProtocolException.new("EPSV failed : " + server_answer)
        end
        # Yay! Let's extract the port number
        s = m.group(1)
        port = JavaInteger.parse_int(s)
        add_ = self.attr_server_socket.get_inet_address
        if (!(add_).nil?)
          dest = InetSocketAddress.new(add_, port)
        else
          # This means we used an Unresolved address to connect in
          # the first place. Most likely because the proxy is doing
          # the name resolution for us, so let's keep using unresolved
          # address.
          dest = InetSocketAddress.create_unresolved(@server_name, port)
        end
      else
        # EPSV ALL failed, so Let's try the regular PASV cmd
        if ((issue_command("PASV")).equal?(self.attr_ftp_error))
          raise FtpProtocolException.new("PASV failed: " + (get_response_string).to_s)
        end
        server_answer = (get_response_string).to_s
        # Let's parse the response String to get the IP & port to connect to
        # the String should be in the following format :
        # 
        # 227 Entering Passive Mode (A1,A2,A3,A4,p1,p2)
        # 
        # Note that the two parenthesis are optional
        # 
        # The IP address is A1.A2.A3.A4 and the port is p1 * 256 + p2
        # 
        # The regular expression is a bit more complex this time, because the
        # parenthesis are optionals and we have to use 3 groups.
        p = Pattern.compile("227 .* \\(?(\\d{1,3},\\d{1,3},\\d{1,3},\\d{1,3}),(\\d{1,3}),(\\d{1,3})\\)?")
        m = p.matcher(server_answer)
        if (!m.find)
          raise FtpProtocolException.new("PASV failed : " + server_answer)
        end
        # Get port number out of group 2 & 3
        port = JavaInteger.parse_int(m.group(3)) + (JavaInteger.parse_int(m.group(2)) << 8)
        # IP address is simple
        s = m.group(1).replace(Character.new(?,.ord), Character.new(?..ord))
        dest = InetSocketAddress.new(s, port)
      end
      # Got everything, let's open the socket!
      s = nil
      if (!(self.attr_proxy).nil?)
        if ((self.attr_proxy.type).equal?(Proxy::Type::SOCKS))
          s = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members FtpClient
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Socket.new(self.attr_proxy)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        else
          s = Socket.new(Proxy::NO_PROXY)
        end
      else
        s = Socket.new
      end
      if (self.attr_connect_timeout >= 0)
        s.connect(dest, self.attr_connect_timeout)
      else
        if (self.attr_default_connect_timeout > 0)
          s.connect(dest, self.attr_default_connect_timeout)
        else
          s.connect(dest)
        end
      end
      if (self.attr_read_timeout >= 0)
        s.set_so_timeout(self.attr_read_timeout)
      else
        if (self.attr_default_so_timeout > 0)
          s.set_so_timeout(self.attr_default_so_timeout)
        end
      end
      return s
    end
    
    typesig { [String] }
    # Tries to open a Data Connection with the server. It will first try a passive
    # mode connection, then, if it fails, a more traditional PORT command
    # 
    # @param   cmd     the command to execute (RETR, STOR, etc...)
    # @return          the opened socket
    # 
    # @exception       FtpProtocolException if an error occurs when issuing the
    # PORT command to the ftp server.
    def open_data_connection(cmd)
      port_socket = nil
      client_socket = nil
      port_cmd = nil
      my_address = nil
      e = nil
      # Let's try passive mode first
      begin
        client_socket = open_passive_data_connection
      rescue IOException => ex
        client_socket = nil
      end
      if (!(client_socket).nil?)
        # We did get a clientSocket, so the passive mode worked
        # Let's issue the command (GET, DIR, ...)
        begin
          if ((issue_command(cmd)).equal?(self.attr_ftp_error))
            client_socket.close
            raise FtpProtocolException.new(get_response_string)
          else
            return client_socket
          end
        rescue IOException => ioe
          client_socket.close
          raise ioe
        end
      end
      raise AssertError if not (((client_socket).nil?))
      # Passive mode failed, let's fall back to the good old "PORT"
      if (!(self.attr_proxy).nil? && (self.attr_proxy.type).equal?(Proxy::Type::SOCKS))
        # We're behind a firewall and the passive mode fail,
        # since we can't accept a connection through SOCKS (yet)
        # throw an exception
        raise FtpProtocolException.new("Passive mode failed")
      else
        port_socket = ServerSocket.new(0, 1)
      end
      begin
        my_address = port_socket.get_inet_address
        if (my_address.is_any_local_address)
          my_address = get_local_address
        end
        # Let's try the new, IPv6 compatible EPRT command
        # See RFC2428 for specifics
        # Some FTP servers (like the one on Solaris) are bugged, they
        # will accept the EPRT command but then, the subsequent command
        # (e.g. RETR) will fail, so we have to check BOTH results (the
        # EPRT cmd then the actual command) to decide wether we should
        # fall back on the older PORT command.
        port_cmd = "EPRT |" + (((my_address.is_a?(Inet6Address)) ? "2" : "1")).to_s + "|" + (my_address.get_host_address).to_s + "|" + (port_socket.get_local_port).to_s + "|"
        if ((issue_command(port_cmd)).equal?(self.attr_ftp_error) || (issue_command(cmd)).equal?(self.attr_ftp_error))
          # The EPRT command failed, let's fall back to good old PORT
          port_cmd = "PORT "
          addr = my_address.get_address
          # append host addr
          i = 0
          while i < addr.attr_length
            port_cmd = port_cmd + ((addr[i] & 0xff)).to_s + ","
            i += 1
          end
          # append port number
          port_cmd = port_cmd + (((port_socket.get_local_port >> 8) & 0xff)).to_s + "," + ((port_socket.get_local_port & 0xff)).to_s
          if ((issue_command(port_cmd)).equal?(self.attr_ftp_error))
            e = FtpProtocolException.new("PORT :" + (get_response_string).to_s)
            raise e
          end
          if ((issue_command(cmd)).equal?(self.attr_ftp_error))
            e = FtpProtocolException.new(cmd + ":" + (get_response_string).to_s)
            raise e
          end
        end
        # Either the EPRT or the PORT command was successful
        # Let's create the client socket
        if (self.attr_connect_timeout >= 0)
          port_socket.set_so_timeout(self.attr_connect_timeout)
        else
          if (self.attr_default_connect_timeout > 0)
            port_socket.set_so_timeout(self.attr_default_connect_timeout)
          end
        end
        client_socket = port_socket.accept
        if (self.attr_read_timeout >= 0)
          client_socket.set_so_timeout(self.attr_read_timeout)
        else
          if (self.attr_default_so_timeout > 0)
            client_socket.set_so_timeout(self.attr_default_so_timeout)
          end
        end
      ensure
        port_socket.close
      end
      return client_socket
    end
    
    typesig { [String] }
    # public methods
    # 
    # Open a FTP connection to host <i>host</i>.
    # 
    # @param   host    The hostname of the ftp server
    # 
    # @exception       FtpProtocolException if connection fails
    def open_server(host)
      open_server(host, FTP_PORT)
    end
    
    typesig { [String, ::Java::Int] }
    # Open a FTP connection to host <i>host</i> on port <i>port</i>.
    # 
    # @param   host    the hostname of the ftp server
    # @param   port    the port to connect to (usually 21)
    # 
    # @exception       FtpProtocolException if connection fails
    def open_server(host, port)
      @server_name = host
      super(host, port)
      if ((read_reply).equal?(self.attr_ftp_error))
        raise FtpProtocolException.new("Welcome message: " + (get_response_string).to_s)
      end
    end
    
    typesig { [String, String] }
    # login user to a host with username <i>user</i> and password
    # <i>password</i>
    # 
    # @param   user            Username to use at login
    # @param   password        Password to use at login or null of none is needed
    # 
    # @exception       FtpLoginException if login is unsuccesful
    def login(user, password)
      if (!server_is_open)
        raise FtpLoginException.new("not connected to host")
      end
      if ((user).nil? || (user.length).equal?(0))
        return
      end
      if ((issue_command("USER " + user)).equal?(self.attr_ftp_error))
        raise FtpLoginException.new("user " + user + " : " + (get_response_string).to_s)
      end
      # Checks for "331 User name okay, need password." answer
      if ((@last_reply_code).equal?(331))
        if (((password).nil?) || ((password.length).equal?(0)) || ((issue_command("PASS " + password)).equal?(self.attr_ftp_error)))
          raise FtpLoginException.new("password: " + (get_response_string).to_s)
        end
      end
      # keep the welcome message around so we can
      # put it in the resulting HTML page.
      l = nil
      sb = StringBuffer.new
      i = 0
      while i < self.attr_server_response.size
        l = (self.attr_server_response.element_at(i)).to_s
        if (!(l).nil?)
          if (l.length >= 4 && l.starts_with("230"))
            # get rid of the "230-" prefix
            l = (l.substring(4)).to_s
          end
          sb.append(l)
        end
        i += 1
      end
      @welcome_msg = (sb.to_s).to_s
      @logged_in = true
    end
    
    typesig { [String] }
    # GET a file from the FTP server
    # 
    # @param   filename        name of the file to retrieve
    # @return  the <code>InputStream</code> to read the file from
    # 
    # @exception       FileNotFoundException if the file can't be opened
    def get(filename)
      s = nil
      begin
        s = open_data_connection("RETR " + filename)
      rescue FileNotFoundException => file_exception
        # Well, "/" might not be the file delimitor for this
        # particular ftp server, so let's try a series of
        # "cd" commands to get to the right place.
        # But don't try this if there are no '/' in the path
        if ((filename.index_of(Character.new(?/.ord))).equal?(-1))
          raise file_exception
        end
        t = StringTokenizer.new(filename, "/")
        path_element = nil
        while (t.has_more_elements)
          path_element = (t.next_token).to_s
          if (!t.has_more_elements)
            # This is the file component.  Look it up now.
            break
          end
          begin
            cd(path_element)
          rescue FtpProtocolException => e
            # Giving up.
            raise file_exception
          end
        end
        if (!(path_element).nil?)
          s = open_data_connection("RETR " + path_element)
        else
          raise file_exception
        end
      end
      return TelnetInputStream.new(s.get_input_stream, @binary_mode)
    end
    
    typesig { [String] }
    # PUT a file to the FTP server
    # 
    # @param   filename        name of the file to store
    # @return  the <code>OutputStream</code> to write the file to
    def put(filename)
      s = open_data_connection("STOR " + filename)
      out = TelnetOutputStream.new(s.get_output_stream, @binary_mode)
      if (!@binary_mode)
        out.set_sticky_crlf(true)
      end
      return out
    end
    
    typesig { [String] }
    # Append to a file on the FTP server
    # 
    # @param   filename        name of the file to append to
    # @return  the <code>OutputStream</code> to write the file to
    def append(filename)
      s = open_data_connection("APPE " + filename)
      out = TelnetOutputStream.new(s.get_output_stream, @binary_mode)
      if (!@binary_mode)
        out.set_sticky_crlf(true)
      end
      return out
    end
    
    typesig { [] }
    # LIST files in the current directory on a remote FTP server
    # 
    # @return  the <code>InputStream</code> to read the list from
    def list
      s = open_data_connection("LIST")
      return TelnetInputStream.new(s.get_input_stream, @binary_mode)
    end
    
    typesig { [String] }
    # List (NLST) file names on a remote FTP server
    # 
    # @param   path    pathname to the directory to list, null for current
    # directory
    # @return  the <code>InputStream</code> to read the list from
    # @exception       <code>FtpProtocolException</code>
    def name_list(path)
      s = nil
      if (!(path).nil?)
        s = open_data_connection("NLST " + path)
      else
        s = open_data_connection("NLST")
      end
      return TelnetInputStream.new(s.get_input_stream, @binary_mode)
    end
    
    typesig { [String] }
    # CD to a specific directory on a remote FTP server
    # 
    # @param   remoteDirectory path of the directory to CD to
    # 
    # @exception       <code>FtpProtocolException</code>
    def cd(remote_directory)
      if ((remote_directory).nil? || ("" == remote_directory))
        return
      end
      issue_command_check("CWD " + remote_directory)
    end
    
    typesig { [] }
    # CD to the parent directory on a remote FTP server
    def cd_up
      issue_command_check("CDUP")
    end
    
    typesig { [] }
    # Print working directory of remote FTP server
    # 
    # @exception FtpProtocolException if the command fails
    def pwd
      answ = nil
      issue_command_check("PWD")
      # answer will be of the following format :
      # 
      # 257 "/" is current directory.
      answ = (get_response_string).to_s
      if (!answ.starts_with("257"))
        raise FtpProtocolException.new("PWD failed. " + answ)
      end
      return answ.substring(5, answ.last_index_of(Character.new(?".ord)))
    end
    
    typesig { [] }
    # Set transfer type to 'I'
    # 
    # @exception FtpProtocolException if the command fails
    def binary
      issue_command_check("TYPE I")
      @binary_mode = true
    end
    
    typesig { [] }
    # Set transfer type to 'A'
    # 
    # @exception FtpProtocolException if the command fails
    def ascii
      issue_command_check("TYPE A")
      @binary_mode = false
    end
    
    typesig { [String, String] }
    # Rename a file on the ftp server
    # 
    # @exception FtpProtocolException if the command fails
    def rename(from, to)
      issue_command_check("RNFR " + from)
      issue_command_check("RNTO " + to)
    end
    
    typesig { [] }
    # Get the "System string" from the FTP server
    # 
    # @exception       FtpProtocolException if it fails
    def system
      answ = nil
      issue_command_check("SYST")
      answ = (get_response_string).to_s
      if (!answ.starts_with("215"))
        raise FtpProtocolException.new("SYST failed." + answ)
      end
      return answ.substring(4) # Skip "215 "
    end
    
    typesig { [] }
    # Send a No-operation command. It's usefull for testing the connection status
    # 
    # @exception FtpProtocolException if the command fails
    def noop
      issue_command_check("NOOP")
    end
    
    typesig { [] }
    # Reinitialize the USER parameters on the FTp server
    # 
    # @exception FtpProtocolException if the command fails
    def re_init
      issue_command_check("REIN")
      @logged_in = false
    end
    
    typesig { [String] }
    # New FTP client connected to host <i>host</i>.
    # 
    # @param   host    Hostname of the FTP server
    # 
    # @exception FtpProtocolException if the connection fails
    def initialize(host)
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      @command = nil
      @last_reply_code = 0
      @welcome_msg = nil
      super()
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      open_server(host, FTP_PORT)
    end
    
    typesig { [String, ::Java::Int] }
    # New FTP client connected to host <i>host</i>, port <i>port</i>.
    # 
    # @param   host    Hostname of the FTP server
    # @param   port    port number to connect to (usually 21)
    # 
    # @exception FtpProtocolException if the connection fails
    def initialize(host, port)
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      @command = nil
      @last_reply_code = 0
      @welcome_msg = nil
      super()
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      open_server(host, port)
    end
    
    typesig { [] }
    # Create an uninitialized FTP client.
    def initialize
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      @command = nil
      @last_reply_code = 0
      @welcome_msg = nil
      super()
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
    end
    
    typesig { [Proxy] }
    def initialize(p)
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      @command = nil
      @last_reply_code = 0
      @welcome_msg = nil
      super()
      @server_name = nil
      @reply_pending = false
      @binary_mode = false
      @logged_in = false
      self.attr_proxy = p
    end
    
    typesig { [] }
    def finalize
      # Do not call the "normal" closeServer() as we want finalization
      # to be as efficient as possible
      if (server_is_open)
        TransferProtocolClient.instance_method(:close_server).bind(self).call
      end
    end
    
    private
    alias_method :initialize__ftp_client, :initialize
  end
  
end

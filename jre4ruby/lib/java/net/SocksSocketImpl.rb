require "rjava"

# 
# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SocksSocketImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :BufferedOutputStream
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util::Prefs, :Preferences
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # import org.ietf.jgss.*;
  # 
  # SOCKS (V4 & V5) TCP socket implementation (RFC 1928).
  # This is a subclass of PlainSocketImpl.
  # Note this class should <b>NOT</b> be public.
  class SocksSocketImpl < SocksSocketImplImports.const_get :PlainSocketImpl
    include_class_members SocksSocketImplImports
    include SocksConsts
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    attr_accessor :external_address
    alias_method :attr_external_address, :external_address
    undef_method :external_address
    alias_method :attr_external_address=, :external_address=
    undef_method :external_address=
    
    attr_accessor :use_v4
    alias_method :attr_use_v4, :use_v4
    undef_method :use_v4
    alias_method :attr_use_v4=, :use_v4=
    undef_method :use_v4=
    
    attr_accessor :cmdsock
    alias_method :attr_cmdsock, :cmdsock
    undef_method :cmdsock
    alias_method :attr_cmdsock=, :cmdsock=
    undef_method :cmdsock=
    
    attr_accessor :cmd_in
    alias_method :attr_cmd_in, :cmd_in
    undef_method :cmd_in
    alias_method :attr_cmd_in=, :cmd_in=
    undef_method :cmd_in=
    
    attr_accessor :cmd_out
    alias_method :attr_cmd_out, :cmd_out
    undef_method :cmd_out
    alias_method :attr_cmd_out=, :cmd_out=
    undef_method :cmd_out=
    
    typesig { [] }
    def initialize
      @server = nil
      @port = 0
      @external_address = nil
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      super()
      @server = nil
      @port = DEFAULT_PORT
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      # Nothing needed
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(server, port)
      @server = nil
      @port = 0
      @external_address = nil
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      super()
      @server = nil
      @port = DEFAULT_PORT
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      @server = server
      @port = ((port).equal?(-1) ? DEFAULT_PORT : port)
    end
    
    typesig { [Proxy] }
    def initialize(proxy)
      @server = nil
      @port = 0
      @external_address = nil
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      super()
      @server = nil
      @port = DEFAULT_PORT
      @use_v4 = false
      @cmdsock = nil
      @cmd_in = nil
      @cmd_out = nil
      a = proxy.address
      if (a.is_a?(InetSocketAddress))
        ad = a
        # Use getHostString() to avoid reverse lookups
        @server = (ad.get_host_string).to_s
        @port = ad.get_port
      end
    end
    
    typesig { [] }
    def set_v4
      @use_v4 = true
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def privileged_connect(host, port, timeout)
      synchronized(self) do
        begin
          AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members SocksSocketImpl
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              super_connect_server(host, port, timeout)
              self.attr_cmd_in = get_input_stream
              self.attr_cmd_out = get_output_stream
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => pae
          raise pae.get_exception
        end
      end
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def super_connect_server(host, port, timeout)
      PlainSocketImpl.instance_method(:connect).bind(self).call(InetSocketAddress.new(host, port), timeout)
    end
    
    typesig { [InputStream, Array.typed(::Java::Byte)] }
    def read_socks_reply(in_, data)
      len = data.attr_length
      received = 0
      attempts = 0
      while received < len && attempts < 3
        count = in_.read(data, received, len - received)
        if (count < 0)
          raise SocketException.new("Malformed reply from SOCKS server")
        end
        received += count
        ((attempts += 1) - 1)
      end
      return received
    end
    
    typesig { [::Java::Byte, InputStream, BufferedOutputStream] }
    # 
    # Provides the authentication machanism required by the proxy.
    def authenticate(method, in_, out)
      data = nil
      i = 0
      # No Authentication required. We're done then!
      if ((method).equal?(NO_AUTH))
        return true
      end
      # 
      # User/Password authentication. Try, in that order :
      # - The application provided Authenticator, if any
      # - The user preferences java.net.socks.username &
      # java.net.socks.password
      # - the user.name & no password (backward compatibility behavior).
      if ((method).equal?(USER_PASSW))
        user_name = nil
        password = nil
        addr = InetAddress.get_by_name(@server)
        pw = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SocksSocketImpl
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Authenticator.request_password_authentication(self.attr_server, addr, self.attr_port, "SOCKS5", "SOCKS authentication", nil)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (!(pw).nil?)
          user_name = (pw.get_user_name).to_s
          password = (String.new(pw.get_password)).to_s
        else
          prefs = Preferences.user_root.node("/java/net/socks")
          begin
            user_name = (AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members SocksSocketImpl
              include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                return prefs.get("username", nil)
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))).to_s
          rescue Java::Security::PrivilegedActionException => pae
            raise pae.get_exception
          end
          if (!(user_name).nil?)
            begin
              password = (AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members SocksSocketImpl
                include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  return prefs.get("password", nil)
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))).to_s
            rescue Java::Security::PrivilegedActionException => pae
              raise pae_.get_exception
            end
          else
            user_name = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.name"))).to_s
          end
        end
        if ((user_name).nil?)
          return false
        end
        out.write(1)
        out.write(user_name.length)
        begin
          out.write(user_name.get_bytes("ISO-8859-1"))
        rescue Java::Io::UnsupportedEncodingException => uee
          raise AssertError if not (false)
        end
        if (!(password).nil?)
          out.write(password.length)
          begin
            out.write(password.get_bytes("ISO-8859-1"))
          rescue Java::Io::UnsupportedEncodingException => uee
            raise AssertError if not (false)
          end
        else
          out.write(0)
        end
        out.flush
        data = Array.typed(::Java::Byte).new(2) { 0 }
        i = read_socks_reply(in_, data)
        if (!(i).equal?(2) || !(data[1]).equal?(0))
          # RFC 1929 specifies that the connection MUST be closed if
          # authentication fails
          out.close
          in_.close
          return false
        end
        # Authentication succeeded
        return true
      end
      # 
      # GSSAPI authentication mechanism.
      # Unfortunately the RFC seems out of sync with the Reference
      # implementation. I'll leave this in for future completion.
      # 
      # if (method == GSSAPI) {
      # try {
      # GSSManager manager = GSSManager.getInstance();
      # GSSName name = manager.createName("SERVICE:socks@"+server,
      # null);
      # GSSContext context = manager.createContext(name, null, null,
      # GSSContext.DEFAULT_LIFETIME);
      # context.requestMutualAuth(true);
      # context.requestReplayDet(true);
      # context.requestSequenceDet(true);
      # context.requestCredDeleg(true);
      # byte []inToken = new byte[0];
      # while (!context.isEstablished()) {
      # byte[] outToken
      # = context.initSecContext(inToken, 0, inToken.length);
      # // send the output token if generated
      # if (outToken != null) {
      # out.write(1);
      # out.write(1);
      # out.writeShort(outToken.length);
      # out.write(outToken);
      # out.flush();
      # data = new byte[2];
      # i = readSocksReply(in, data);
      # if (i != 2 || data[1] == 0xff) {
      # in.close();
      # out.close();
      # return false;
      # }
      # i = readSocksReply(in, data);
      # int len = 0;
      # len = ((int)data[0] & 0xff) << 8;
      # len += data[1];
      # data = new byte[len];
      # i = readSocksReply(in, data);
      # if (i == len)
      # return true;
      # in.close();
      # out.close();
      # }
      # }
      # } catch (GSSException e) {
      # /* RFC 1961 states that if Context initialisation fails the connection
      # MUST be closed */
      # e.printStackTrace();
      # in.close();
      # out.close();
      # }
      # }
      return false
    end
    
    typesig { [InputStream, OutputStream, InetSocketAddress] }
    def connect_v4(in_, out, endpoint)
      if (!(endpoint.get_address.is_a?(Inet4Address)))
        raise SocketException.new("SOCKS V4 requires IPv4 only addresses")
      end
      out.write(PROTO_VERS4)
      out.write(CONNECT)
      out.write((endpoint.get_port >> 8) & 0xff)
      out.write((endpoint.get_port >> 0) & 0xff)
      out.write(endpoint.get_address.get_address)
      user_name = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.name"))
      begin
        out.write(user_name.get_bytes("ISO-8859-1"))
      rescue Java::Io::UnsupportedEncodingException => uee
        raise AssertError if not (false)
      end
      out.write(0)
      out.flush
      data = Array.typed(::Java::Byte).new(8) { 0 }
      n = read_socks_reply(in_, data)
      if (!(n).equal?(8))
        raise SocketException.new("Reply from SOCKS server has bad length: " + (n).to_s)
      end
      if (!(data[0]).equal?(0) && !(data[0]).equal?(4))
        raise SocketException.new("Reply from SOCKS server has bad version")
      end
      ex = nil
      case (data[1])
      when 90
        # Success!
        @external_address = endpoint
      when 91
        ex = SocketException.new("SOCKS request rejected")
      when 92
        ex = SocketException.new("SOCKS server couldn't reach destination")
      when 93
        ex = SocketException.new("SOCKS authentication failed")
      else
        ex = SocketException.new("Reply from SOCKS server contains bad status")
      end
      if (!(ex).nil?)
        in_.close
        out.close
        raise ex
      end
    end
    
    typesig { [SocketAddress, ::Java::Int] }
    # 
    # Connects the Socks Socket to the specified endpoint. It will first
    # connect to the SOCKS proxy and negotiate the access. If the proxy
    # grants the connections, then the connect is successful and all
    # further traffic will go to the "real" endpoint.
    # 
    # @param   endpoint        the <code>SocketAddress</code> to connect to.
    # @param   timeout         the timeout value in milliseconds
    # @throws  IOException     if the connection can't be established.
    # @throws  SecurityException if there is a security manager and it
    # doesn't allow the connection
    # @throws  IllegalArgumentException if endpoint is null or a
    # SocketAddress subclass not supported by this socket
    def connect(endpoint, timeout)
      security = System.get_security_manager
      if ((endpoint).nil? || !(endpoint.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("Unsupported address type")
      end
      epoint = endpoint
      if (!(security).nil?)
        if (epoint.is_unresolved)
          security.check_connect(epoint.get_host_name, epoint.get_port)
        else
          security.check_connect(epoint.get_address.get_host_address, epoint.get_port)
        end
      end
      if ((@server).nil?)
        sel = Java::Security::AccessController.do_privileged(# This is the general case
        # server is not null only when the socket was created with a
        # specified proxy in which case it does bypass the ProxySelector
        Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SocksSocketImpl
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
        if ((sel).nil?)
          # 
          # No default proxySelector --> direct connection
          super(epoint, timeout)
          return
        end
        uri = nil
        # Use getHostString() to avoid reverse lookups
        host = epoint.get_host_string
        # IPv6 litteral?
        if (epoint.get_address.is_a?(Inet6Address) && (!host.starts_with("[")) && (host.index_of(":") >= 0))
          host = "[" + host + "]"
        end
        begin
          uri = URI.new("socket://" + (ParseUtil.encode_path(host)).to_s + ":" + (epoint.get_port).to_s)
        rescue URISyntaxException => e
          # This shouldn't happen
          raise AssertError, (e).to_s if not (false)
        end
        p = nil
        saved_exc = nil
        i_proxy = nil
        i_proxy = sel.select(uri).iterator
        if ((i_proxy).nil? || !(i_proxy.has_next))
          super(epoint, timeout)
          return
        end
        while (i_proxy.has_next)
          p = i_proxy.next
          if ((p).nil? || (p).equal?(Proxy::NO_PROXY))
            super(epoint, timeout)
            return
          end
          if (!(p.type).equal?(Proxy::Type::SOCKS))
            raise SocketException.new("Unknown proxy type : " + (p.type).to_s)
          end
          if (!(p.address.is_a?(InetSocketAddress)))
            raise SocketException.new("Unknow address type for proxy: " + (p).to_s)
          end
          # Use getHostString() to avoid reverse lookups
          @server = ((p.address).get_host_string).to_s
          @port = (p.address).get_port
          # Connects to the SOCKS server
          begin
            privileged_connect(@server, @port, timeout)
            # Worked, let's get outta here
            break
          rescue IOException => e
            # Ooops, let's notify the ProxySelector
            sel.connect_failed(uri, p.address, e_)
            @server = (nil).to_s
            @port = -1
            saved_exc = e_
            # Will continue the while loop and try the next proxy
          end
        end
        # 
        # If server is still null at this point, none of the proxy
        # worked
        if ((@server).nil?)
          raise SocketException.new("Can't connect to SOCKS proxy:" + (saved_exc.get_message).to_s)
        end
      else
        # Connects to the SOCKS server
        begin
          privileged_connect(@server, @port, timeout)
        rescue IOException => e
          raise SocketException.new(e__.get_message)
        end
      end
      # cmdIn & cmdOut were intialized during the privilegedConnect() call
      out = BufferedOutputStream.new(@cmd_out, 512)
      in_ = @cmd_in
      if (@use_v4)
        # SOCKS Protocol version 4 doesn't know how to deal with
        # DOMAIN type of addresses (unresolved addresses here)
        if (epoint.is_unresolved)
          raise UnknownHostException.new(epoint.to_s)
        end
        connect_v4(in_, out, epoint)
        return
      end
      # This is SOCKS V5
      out.write(PROTO_VERS)
      out.write(2)
      out.write(NO_AUTH)
      out.write(USER_PASSW)
      out.flush
      data = Array.typed(::Java::Byte).new(2) { 0 }
      i = read_socks_reply(in_, data)
      if (!(i).equal?(2) || !((RJava.cast_to_int(data[0]))).equal?(PROTO_VERS))
        # Maybe it's not a V5 sever after all
        # Let's try V4 before we give up
        # SOCKS Protocol version 4 doesn't know how to deal with
        # DOMAIN type of addresses (unresolved addresses here)
        if (epoint.is_unresolved)
          raise UnknownHostException.new(epoint.to_s)
        end
        connect_v4(in_, out, epoint)
        return
      end
      if (((RJava.cast_to_int(data[1]))).equal?(NO_METHODS))
        raise SocketException.new("SOCKS : No acceptable methods")
      end
      if (!authenticate(data[1], in_, out))
        raise SocketException.new("SOCKS : authentication failed")
      end
      out.write(PROTO_VERS)
      out.write(CONNECT)
      out.write(0)
      # Test for IPV4/IPV6/Unresolved
      if (epoint.is_unresolved)
        out.write(DOMAIN_NAME)
        out.write(epoint.get_host_name.length)
        begin
          out.write(epoint.get_host_name.get_bytes("ISO-8859-1"))
        rescue Java::Io::UnsupportedEncodingException => uee
          raise AssertError if not (false)
        end
        out.write((epoint.get_port >> 8) & 0xff)
        out.write((epoint.get_port >> 0) & 0xff)
      else
        if (epoint.get_address.is_a?(Inet6Address))
          out.write(IPV6)
          out.write(epoint.get_address.get_address)
          out.write((epoint.get_port >> 8) & 0xff)
          out.write((epoint.get_port >> 0) & 0xff)
        else
          out.write(IPV4)
          out.write(epoint.get_address.get_address)
          out.write((epoint.get_port >> 8) & 0xff)
          out.write((epoint.get_port >> 0) & 0xff)
        end
      end
      out.flush
      data = Array.typed(::Java::Byte).new(4) { 0 }
      i = read_socks_reply(in_, data)
      if (!(i).equal?(4))
        raise SocketException.new("Reply from SOCKS server has bad length")
      end
      ex = nil
      nport = 0
      len = 0
      addr = nil
      case (data[1])
      when REQUEST_OK
        # success!
        case (data[3])
        when IPV4
          addr = Array.typed(::Java::Byte).new(4) { 0 }
          i = read_socks_reply(in_, addr)
          if (!(i).equal?(4))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          data = Array.typed(::Java::Byte).new(2) { 0 }
          i = read_socks_reply(in_, data)
          if (!(i).equal?(2))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
          nport += (RJava.cast_to_int(data[1]) & 0xff)
        when DOMAIN_NAME
          len = data[1]
          host_ = Array.typed(::Java::Byte).new(len) { 0 }
          i = read_socks_reply(in_, host_)
          if (!(i).equal?(len))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          data = Array.typed(::Java::Byte).new(2) { 0 }
          i = read_socks_reply(in_, data)
          if (!(i).equal?(2))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
          nport += (RJava.cast_to_int(data[1]) & 0xff)
        when IPV6
          len = data[1]
          addr = Array.typed(::Java::Byte).new(len) { 0 }
          i = read_socks_reply(in_, addr)
          if (!(i).equal?(len))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          data = Array.typed(::Java::Byte).new(2) { 0 }
          i = read_socks_reply(in_, data)
          if (!(i).equal?(2))
            raise SocketException.new("Reply from SOCKS server badly formatted")
          end
          nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
          nport += (RJava.cast_to_int(data[1]) & 0xff)
        else
          ex = SocketException.new("Reply from SOCKS server contains wrong code")
        end
      when GENERAL_FAILURE
        ex = SocketException.new("SOCKS server general failure")
      when NOT_ALLOWED
        ex = SocketException.new("SOCKS: Connection not allowed by ruleset")
      when NET_UNREACHABLE
        ex = SocketException.new("SOCKS: Network unreachable")
      when HOST_UNREACHABLE
        ex = SocketException.new("SOCKS: Host unreachable")
      when CONN_REFUSED
        ex = SocketException.new("SOCKS: Connection refused")
      when TTL_EXPIRED
        ex = SocketException.new("SOCKS: TTL expired")
      when CMD_NOT_SUPPORTED
        ex = SocketException.new("SOCKS: Command not supported")
      when ADDR_TYPE_NOT_SUP
        ex = SocketException.new("SOCKS: address type not supported")
      end
      if (!(ex).nil?)
        in_.close
        out.close
        raise ex
      end
      @external_address = epoint
    end
    
    typesig { [InputStream, OutputStream, InetAddress, ::Java::Int] }
    def bind_v4(in_, out, baddr, lport)
      if (!(baddr.is_a?(Inet4Address)))
        raise SocketException.new("SOCKS V4 requires IPv4 only addresses")
      end
      PlainSocketImpl.instance_method(:bind).bind(self).call(baddr, lport)
      addr1 = baddr.get_address
      # Test for AnyLocal
      naddr = baddr
      if (naddr.is_any_local_address)
        naddr = @cmdsock.get_local_address
        addr1 = naddr.get_address
      end
      out.write(PROTO_VERS4)
      out.write(BIND)
      out.write((PlainSocketImpl.instance_method(:get_local_port).bind(self).call >> 8) & 0xff)
      out.write((PlainSocketImpl.instance_method(:get_local_port).bind(self).call >> 0) & 0xff)
      out.write(addr1)
      user_name = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.name"))
      begin
        out.write(user_name.get_bytes("ISO-8859-1"))
      rescue Java::Io::UnsupportedEncodingException => uee
        raise AssertError if not (false)
      end
      out.write(0)
      out.flush
      data = Array.typed(::Java::Byte).new(8) { 0 }
      n = read_socks_reply(in_, data)
      if (!(n).equal?(8))
        raise SocketException.new("Reply from SOCKS server has bad length: " + (n).to_s)
      end
      if (!(data[0]).equal?(0) && !(data[0]).equal?(4))
        raise SocketException.new("Reply from SOCKS server has bad version")
      end
      ex = nil
      case (data[1])
      when 90
        # Success!
        @external_address = InetSocketAddress.new(baddr, lport)
      when 91
        ex = SocketException.new("SOCKS request rejected")
      when 92
        ex = SocketException.new("SOCKS server couldn't reach destination")
      when 93
        ex = SocketException.new("SOCKS authentication failed")
      else
        ex = SocketException.new("Reply from SOCKS server contains bad status")
      end
      if (!(ex).nil?)
        in_.close
        out.close
        raise ex
      end
    end
    
    typesig { [InetSocketAddress] }
    # 
    # Sends the Bind request to the SOCKS proxy. In the SOCKS protocol, bind
    # means "accept incoming connection from", so the SocketAddress is the
    # the one of the host we do accept connection from.
    # 
    # @param      addr   the Socket address of the remote host.
    # @exception  IOException  if an I/O error occurs when binding this socket.
    def socks_bind(saddr)
      synchronized(self) do
        if (!(self.attr_socket).nil?)
          # this is a client socket, not a server socket, don't
          # call the SOCKS proxy for a bind!
          return
        end
        # Connects to the SOCKS server
        if ((@server).nil?)
          sel = Java::Security::AccessController.do_privileged(# This is the general case
          # server is not null only when the socket was created with a
          # specified proxy in which case it does bypass the ProxySelector
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members SocksSocketImpl
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
          if ((sel).nil?)
            # 
            # No default proxySelector --> direct connection
            return
          end
          uri = nil
          # Use getHostString() to avoid reverse lookups
          host = saddr.get_host_string
          # IPv6 litteral?
          if (saddr.get_address.is_a?(Inet6Address) && (!host.starts_with("[")) && (host.index_of(":") >= 0))
            host = "[" + host + "]"
          end
          begin
            uri = URI.new("serversocket://" + (ParseUtil.encode_path(host)).to_s + ":" + (saddr.get_port).to_s)
          rescue URISyntaxException => e
            # This shouldn't happen
            raise AssertError, (e).to_s if not (false)
          end
          p = nil
          saved_exc = nil
          i_proxy = nil
          i_proxy = sel.select(uri).iterator
          if ((i_proxy).nil? || !(i_proxy.has_next))
            return
          end
          while (i_proxy.has_next)
            p = i_proxy.next
            if ((p).nil? || (p).equal?(Proxy::NO_PROXY))
              return
            end
            if (!(p.type).equal?(Proxy::Type::SOCKS))
              raise SocketException.new("Unknown proxy type : " + (p.type).to_s)
            end
            if (!(p.address.is_a?(InetSocketAddress)))
              raise SocketException.new("Unknow address type for proxy: " + (p).to_s)
            end
            # Use getHostString() to avoid reverse lookups
            @server = ((p.address).get_host_string).to_s
            @port = (p.address).get_port
            # Connects to the SOCKS server
            begin
              AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members SocksSocketImpl
                include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  self.attr_cmdsock = Socket.new(PlainSocketImpl.new)
                  self.attr_cmdsock.connect(InetSocketAddress.new(self.attr_server, self.attr_port))
                  self.attr_cmd_in = self.attr_cmdsock.get_input_stream
                  self.attr_cmd_out = self.attr_cmdsock.get_output_stream
                  return nil
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue Exception => e
              # Ooops, let's notify the ProxySelector
              sel.connect_failed(uri, p.address, SocketException.new(e_.get_message))
              @server = (nil).to_s
              @port = -1
              @cmdsock = nil
              saved_exc = e_
              # Will continue the while loop and try the next proxy
            end
          end
          # 
          # If server is still null at this point, none of the proxy
          # worked
          if ((@server).nil? || (@cmdsock).nil?)
            raise SocketException.new("Can't connect to SOCKS proxy:" + (saved_exc.get_message).to_s)
          end
        else
          begin
            AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members SocksSocketImpl
              include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                self.attr_cmdsock = Socket.new(PlainSocketImpl.new)
                self.attr_cmdsock.connect(InetSocketAddress.new(self.attr_server, self.attr_port))
                self.attr_cmd_in = self.attr_cmdsock.get_input_stream
                self.attr_cmd_out = self.attr_cmdsock.get_output_stream
                return nil
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          rescue Exception => e
            raise SocketException.new(e__.get_message)
          end
        end
        out = BufferedOutputStream.new(@cmd_out, 512)
        in_ = @cmd_in
        if (@use_v4)
          bind_v4(in_, out, saddr.get_address, saddr.get_port)
          return
        end
        out.write(PROTO_VERS)
        out.write(2)
        out.write(NO_AUTH)
        out.write(USER_PASSW)
        out.flush
        data = Array.typed(::Java::Byte).new(2) { 0 }
        i = read_socks_reply(in_, data)
        if (!(i).equal?(2) || !((RJava.cast_to_int(data[0]))).equal?(PROTO_VERS))
          # Maybe it's not a V5 sever after all
          # Let's try V4 before we give up
          bind_v4(in_, out, saddr.get_address, saddr.get_port)
          return
        end
        if (((RJava.cast_to_int(data[1]))).equal?(NO_METHODS))
          raise SocketException.new("SOCKS : No acceptable methods")
        end
        if (!authenticate(data[1], in_, out))
          raise SocketException.new("SOCKS : authentication failed")
        end
        # We're OK. Let's issue the BIND command.
        out.write(PROTO_VERS)
        out.write(BIND)
        out.write(0)
        lport = saddr.get_port
        if (saddr.is_unresolved)
          out.write(DOMAIN_NAME)
          out.write(saddr.get_host_name.length)
          begin
            out.write(saddr.get_host_name.get_bytes("ISO-8859-1"))
          rescue Java::Io::UnsupportedEncodingException => uee
            raise AssertError if not (false)
          end
          out.write((lport >> 8) & 0xff)
          out.write((lport >> 0) & 0xff)
        else
          if (saddr.get_address.is_a?(Inet4Address))
            addr1 = saddr.get_address.get_address
            out.write(IPV4)
            out.write(addr1)
            out.write((lport >> 8) & 0xff)
            out.write((lport >> 0) & 0xff)
            out.flush
          else
            if (saddr.get_address.is_a?(Inet6Address))
              addr1_ = saddr.get_address.get_address
              out.write(IPV6)
              out.write(addr1_)
              out.write((lport >> 8) & 0xff)
              out.write((lport >> 0) & 0xff)
              out.flush
            else
              @cmdsock.close
              raise SocketException.new("unsupported address type : " + (saddr).to_s)
            end
          end
        end
        data = Array.typed(::Java::Byte).new(4) { 0 }
        i = read_socks_reply(in_, data)
        ex = nil
        len = 0
        nport = 0
        addr = nil
        case (data[1])
        when REQUEST_OK
          # success!
          real_end = nil
          case (data[3])
          when IPV4
            addr = Array.typed(::Java::Byte).new(4) { 0 }
            i = read_socks_reply(in_, addr)
            if (!(i).equal?(4))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            data = Array.typed(::Java::Byte).new(2) { 0 }
            i = read_socks_reply(in_, data)
            if (!(i).equal?(2))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
            nport += (RJava.cast_to_int(data[1]) & 0xff)
            @external_address = InetSocketAddress.new(Inet4Address.new("", addr), nport)
          when DOMAIN_NAME
            len = data[1]
            host_ = Array.typed(::Java::Byte).new(len) { 0 }
            i = read_socks_reply(in_, host_)
            if (!(i).equal?(len))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            data = Array.typed(::Java::Byte).new(2) { 0 }
            i = read_socks_reply(in_, data)
            if (!(i).equal?(2))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
            nport += (RJava.cast_to_int(data[1]) & 0xff)
            @external_address = InetSocketAddress.new(String.new(host_), nport)
          when IPV6
            len = data[1]
            addr = Array.typed(::Java::Byte).new(len) { 0 }
            i = read_socks_reply(in_, addr)
            if (!(i).equal?(len))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            data = Array.typed(::Java::Byte).new(2) { 0 }
            i = read_socks_reply(in_, data)
            if (!(i).equal?(2))
              raise SocketException.new("Reply from SOCKS server badly formatted")
            end
            nport = (RJava.cast_to_int(data[0]) & 0xff) << 8
            nport += (RJava.cast_to_int(data[1]) & 0xff)
            @external_address = InetSocketAddress.new(Inet6Address.new("", addr), nport)
          end
        when GENERAL_FAILURE
          ex = SocketException.new("SOCKS server general failure")
        when NOT_ALLOWED
          ex = SocketException.new("SOCKS: Bind not allowed by ruleset")
        when NET_UNREACHABLE
          ex = SocketException.new("SOCKS: Network unreachable")
        when HOST_UNREACHABLE
          ex = SocketException.new("SOCKS: Host unreachable")
        when CONN_REFUSED
          ex = SocketException.new("SOCKS: Connection refused")
        when TTL_EXPIRED
          ex = SocketException.new("SOCKS: TTL expired")
        when CMD_NOT_SUPPORTED
          ex = SocketException.new("SOCKS: Command not supported")
        when ADDR_TYPE_NOT_SUP
          ex = SocketException.new("SOCKS: address type not supported")
        end
        if (!(ex).nil?)
          in_.close
          out.close
          @cmdsock.close
          @cmdsock = nil
          raise ex
        end
        @cmd_in = in_
        @cmd_out = out
      end
    end
    
    typesig { [SocketImpl, InetSocketAddress] }
    # 
    # Accepts a connection from a specific host.
    # 
    # @param      s   the accepted connection.
    # @param      saddr the socket address of the host we do accept
    # connection from
    # @exception  IOException  if an I/O error occurs when accepting the
    # connection.
    def accept_from(s, saddr)
      if ((@cmdsock).nil?)
        # Not a Socks ServerSocket.
        return
      end
      in_ = @cmd_in
      # Sends the "SOCKS BIND" request.
      socks_bind(saddr)
      in_.read
      i = in_.read
      in_.read
      ex = nil
      nport = 0
      addr = nil
      real_end = nil
      case (i)
      when REQUEST_OK
        # success!
        i = in_.read
        case (i)
        when IPV4
          addr = Array.typed(::Java::Byte).new(4) { 0 }
          read_socks_reply(in_, addr)
          nport = in_.read << 8
          nport += in_.read
          real_end = InetSocketAddress.new(Inet4Address.new("", addr), nport)
        when DOMAIN_NAME
          len = in_.read
          addr = Array.typed(::Java::Byte).new(len) { 0 }
          read_socks_reply(in_, addr)
          nport = in_.read << 8
          nport += in_.read
          real_end = InetSocketAddress.new(String.new(addr), nport)
        when IPV6
          addr = Array.typed(::Java::Byte).new(16) { 0 }
          read_socks_reply(in_, addr)
          nport = in_.read << 8
          nport += in_.read
          real_end = InetSocketAddress.new(Inet6Address.new("", addr), nport)
        end
      when GENERAL_FAILURE
        ex = SocketException.new("SOCKS server general failure")
      when NOT_ALLOWED
        ex = SocketException.new("SOCKS: Accept not allowed by ruleset")
      when NET_UNREACHABLE
        ex = SocketException.new("SOCKS: Network unreachable")
      when HOST_UNREACHABLE
        ex = SocketException.new("SOCKS: Host unreachable")
      when CONN_REFUSED
        ex = SocketException.new("SOCKS: Connection refused")
      when TTL_EXPIRED
        ex = SocketException.new("SOCKS: TTL expired")
      when CMD_NOT_SUPPORTED
        ex = SocketException.new("SOCKS: Command not supported")
      when ADDR_TYPE_NOT_SUP
        ex = SocketException.new("SOCKS: address type not supported")
      end
      if (!(ex).nil?)
        @cmd_in.close
        @cmd_out.close
        @cmdsock.close
        @cmdsock = nil
        raise ex
      end
      # 
      # This is where we have to do some fancy stuff.
      # The datastream from the socket "accepted" by the proxy will
      # come through the cmdSocket. So we have to swap the socketImpls
      if (s.is_a?(SocksSocketImpl))
        (s).attr_external_address = real_end
      end
      if (s.is_a?(PlainSocketImpl))
        psi = s
        psi.set_input_stream(in_)
        psi.set_file_descriptor(@cmdsock.get_impl.get_file_descriptor)
        psi.set_address(@cmdsock.get_impl.get_inet_address)
        psi.set_port(@cmdsock.get_impl.get_port)
        psi.set_local_port(@cmdsock.get_impl.get_local_port)
      else
        s.attr_fd = @cmdsock.get_impl.attr_fd
        s.attr_address = @cmdsock.get_impl.attr_address
        s.attr_port = @cmdsock.get_impl.attr_port
        s.attr_localport = @cmdsock.get_impl.attr_localport
      end
      # Need to do that so that the socket won't be closed
      # when the ServerSocket is closed by the user.
      # It kinds of detaches the Socket because it is now
      # used elsewhere.
      @cmdsock = nil
    end
    
    typesig { [] }
    # 
    # Returns the value of this socket's <code>address</code> field.
    # 
    # @return  the value of this socket's <code>address</code> field.
    # @see     java.net.SocketImpl#address
    def get_inet_address
      if (!(@external_address).nil?)
        return @external_address.get_address
      else
        return super
      end
    end
    
    typesig { [] }
    # 
    # Returns the value of this socket's <code>port</code> field.
    # 
    # @return  the value of this socket's <code>port</code> field.
    # @see     java.net.SocketImpl#port
    def get_port
      if (!(@external_address).nil?)
        return @external_address.get_port
      else
        return super
      end
    end
    
    typesig { [] }
    def get_local_port
      if (!(self.attr_socket).nil?)
        return super
      end
      if (!(@external_address).nil?)
        return @external_address.get_port
      else
        return super
      end
    end
    
    typesig { [] }
    def close
      if (!(@cmdsock).nil?)
        @cmdsock.close
      end
      @cmdsock = nil
      super
    end
    
    private
    alias_method :initialize__socks_socket_impl, :initialize
  end
  
end

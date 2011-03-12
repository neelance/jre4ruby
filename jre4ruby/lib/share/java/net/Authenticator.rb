require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AuthenticatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # The class Authenticator represents an object that knows how to obtain
  # authentication for a network connection.  Usually, it will do this
  # by prompting the user for information.
  # <p>
  # Applications use this class by overriding {@link
  # #getPasswordAuthentication()} in a sub-class. This method will
  # typically use the various getXXX() accessor methods to get information
  # about the entity requesting authentication. It must then acquire a
  # username and password either by interacting with the user or through
  # some other non-interactive means. The credentials are then returned
  # as a {@link PasswordAuthentication} return value.
  # <p>
  # An instance of this concrete sub-class is then registered
  # with the system by calling {@link #setDefault(Authenticator)}.
  # When authentication is required, the system will invoke one of the
  # requestPasswordAuthentication() methods which in turn will call the
  # getPasswordAuthentication() method of the registered object.
  # <p>
  # All methods that request authentication have a default implementation
  # that fails.
  # 
  # @see java.net.Authenticator#setDefault(java.net.Authenticator)
  # @see java.net.Authenticator#getPasswordAuthentication()
  # 
  # @author  Bill Foote
  # @since   1.2
  # There are no abstract methods, but to be useful the user must
  # subclass.
  class Authenticator 
    include_class_members AuthenticatorImports
    
    class_module.module_eval {
      # The system-wide authenticator object.  See setDefault().
      
      def the_authenticator
        defined?(@@the_authenticator) ? @@the_authenticator : @@the_authenticator= nil
      end
      alias_method :attr_the_authenticator, :the_authenticator
      
      def the_authenticator=(value)
        @@the_authenticator = value
      end
      alias_method :attr_the_authenticator=, :the_authenticator=
    }
    
    attr_accessor :requesting_host
    alias_method :attr_requesting_host, :requesting_host
    undef_method :requesting_host
    alias_method :attr_requesting_host=, :requesting_host=
    undef_method :requesting_host=
    
    attr_accessor :requesting_site
    alias_method :attr_requesting_site, :requesting_site
    undef_method :requesting_site
    alias_method :attr_requesting_site=, :requesting_site=
    undef_method :requesting_site=
    
    attr_accessor :requesting_port
    alias_method :attr_requesting_port, :requesting_port
    undef_method :requesting_port
    alias_method :attr_requesting_port=, :requesting_port=
    undef_method :requesting_port=
    
    attr_accessor :requesting_protocol
    alias_method :attr_requesting_protocol, :requesting_protocol
    undef_method :requesting_protocol
    alias_method :attr_requesting_protocol=, :requesting_protocol=
    undef_method :requesting_protocol=
    
    attr_accessor :requesting_prompt
    alias_method :attr_requesting_prompt, :requesting_prompt
    undef_method :requesting_prompt
    alias_method :attr_requesting_prompt=, :requesting_prompt=
    undef_method :requesting_prompt=
    
    attr_accessor :requesting_scheme
    alias_method :attr_requesting_scheme, :requesting_scheme
    undef_method :requesting_scheme
    alias_method :attr_requesting_scheme=, :requesting_scheme=
    undef_method :requesting_scheme=
    
    attr_accessor :requesting_url
    alias_method :attr_requesting_url, :requesting_url
    undef_method :requesting_url
    alias_method :attr_requesting_url=, :requesting_url=
    undef_method :requesting_url=
    
    attr_accessor :requesting_auth_type
    alias_method :attr_requesting_auth_type, :requesting_auth_type
    undef_method :requesting_auth_type
    alias_method :attr_requesting_auth_type=, :requesting_auth_type=
    undef_method :requesting_auth_type=
    
    class_module.module_eval {
      const_set_lazy(:PROXY) { RequestorType::PROXY }
      const_attr_reader  :PROXY
      
      const_set_lazy(:SERVER) { RequestorType::SERVER }
      const_attr_reader  :SERVER
      
      # The type of the entity requesting authentication.
      # 
      # @since 1.5
      class RequestorType 
        include_class_members Authenticator
        
        class_module.module_eval {
          # Entity requesting authentication is a HTTP proxy server.
          const_set_lazy(:PROXY) { RequestorType.new.set_value_name("PROXY") }
          const_attr_reader  :PROXY
          
          # Entity requesting authentication is a HTTP origin server.
          const_set_lazy(:SERVER) { RequestorType.new.set_value_name("SERVER") }
          const_attr_reader  :SERVER
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [PROXY, SERVER]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__requestor_type, :initialize
      end
    }
    
    typesig { [] }
    def reset
      @requesting_host = RJava.cast_to_string(nil)
      @requesting_site = nil
      @requesting_port = -1
      @requesting_protocol = RJava.cast_to_string(nil)
      @requesting_prompt = RJava.cast_to_string(nil)
      @requesting_scheme = RJava.cast_to_string(nil)
      @requesting_url = nil
      @requesting_auth_type = RequestorType::SERVER
    end
    
    class_module.module_eval {
      typesig { [Authenticator] }
      # Sets the authenticator that will be used by the networking code
      # when a proxy or an HTTP server asks for authentication.
      # <p>
      # First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a
      # <code>NetPermission("setDefaultAuthenticator")</code> permission.
      # This may result in a java.lang.SecurityException.
      # 
      # @param   a       The authenticator to be set. If a is <code>null</code> then
      #                  any previously set authenticator is removed.
      # 
      # @throws SecurityException
      #        if a security manager exists and its
      #        <code>checkPermission</code> method doesn't allow
      #        setting the default authenticator.
      # 
      # @see SecurityManager#checkPermission
      # @see java.net.NetPermission
      def set_default(a)
        synchronized(self) do
          sm = System.get_security_manager
          if (!(sm).nil?)
            set_default_permission = NetPermission.new("setDefaultAuthenticator")
            sm.check_permission(set_default_permission)
          end
          self.attr_the_authenticator = a
        end
      end
      
      typesig { [InetAddress, ::Java::Int, String, String, String] }
      # Ask the authenticator that has been registered with the system
      # for a password.
      # <p>
      # First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a
      # <code>NetPermission("requestPasswordAuthentication")</code> permission.
      # This may result in a java.lang.SecurityException.
      # 
      # @param addr The InetAddress of the site requesting authorization,
      #             or null if not known.
      # @param port the port for the requested connection
      # @param protocol The protocol that's requesting the connection
      #          ({@link java.net.Authenticator#getRequestingProtocol()})
      # @param prompt A prompt string for the user
      # @param scheme The authentication scheme
      # 
      # @return The username/password, or null if one can't be gotten.
      # 
      # @throws SecurityException
      #        if a security manager exists and its
      #        <code>checkPermission</code> method doesn't allow
      #        the password authentication request.
      # 
      # @see SecurityManager#checkPermission
      # @see java.net.NetPermission
      def request_password_authentication(addr, port, protocol, prompt, scheme)
        sm = System.get_security_manager
        if (!(sm).nil?)
          request_permission = NetPermission.new("requestPasswordAuthentication")
          sm.check_permission(request_permission)
        end
        a = self.attr_the_authenticator
        if ((a).nil?)
          return nil
        else
          synchronized((a)) do
            a.reset
            a.attr_requesting_site = addr
            a.attr_requesting_port = port
            a.attr_requesting_protocol = protocol
            a.attr_requesting_prompt = prompt
            a.attr_requesting_scheme = scheme
            return a.get_password_authentication
          end
        end
      end
      
      typesig { [String, InetAddress, ::Java::Int, String, String, String] }
      # Ask the authenticator that has been registered with the system
      # for a password. This is the preferred method for requesting a password
      # because the hostname can be provided in cases where the InetAddress
      # is not available.
      # <p>
      # First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a
      # <code>NetPermission("requestPasswordAuthentication")</code> permission.
      # This may result in a java.lang.SecurityException.
      # 
      # @param host The hostname of the site requesting authentication.
      # @param addr The InetAddress of the site requesting authentication,
      #             or null if not known.
      # @param port the port for the requested connection.
      # @param protocol The protocol that's requesting the connection
      #          ({@link java.net.Authenticator#getRequestingProtocol()})
      # @param prompt A prompt string for the user which identifies the authentication realm.
      # @param scheme The authentication scheme
      # 
      # @return The username/password, or null if one can't be gotten.
      # 
      # @throws SecurityException
      #        if a security manager exists and its
      #        <code>checkPermission</code> method doesn't allow
      #        the password authentication request.
      # 
      # @see SecurityManager#checkPermission
      # @see java.net.NetPermission
      # @since 1.4
      def request_password_authentication(host, addr, port, protocol, prompt, scheme)
        sm = System.get_security_manager
        if (!(sm).nil?)
          request_permission = NetPermission.new("requestPasswordAuthentication")
          sm.check_permission(request_permission)
        end
        a = self.attr_the_authenticator
        if ((a).nil?)
          return nil
        else
          synchronized((a)) do
            a.reset
            a.attr_requesting_host = host
            a.attr_requesting_site = addr
            a.attr_requesting_port = port
            a.attr_requesting_protocol = protocol
            a.attr_requesting_prompt = prompt
            a.attr_requesting_scheme = scheme
            return a.get_password_authentication
          end
        end
      end
      
      typesig { [String, InetAddress, ::Java::Int, String, String, String, URL, RequestorType] }
      # Ask the authenticator that has been registered with the system
      # for a password.
      # <p>
      # First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a
      # <code>NetPermission("requestPasswordAuthentication")</code> permission.
      # This may result in a java.lang.SecurityException.
      # 
      # @param host The hostname of the site requesting authentication.
      # @param addr The InetAddress of the site requesting authorization,
      #             or null if not known.
      # @param port the port for the requested connection
      # @param protocol The protocol that's requesting the connection
      #          ({@link java.net.Authenticator#getRequestingProtocol()})
      # @param prompt A prompt string for the user
      # @param scheme The authentication scheme
      # @param url The requesting URL that caused the authentication
      # @param reqType The type (server or proxy) of the entity requesting
      #              authentication.
      # 
      # @return The username/password, or null if one can't be gotten.
      # 
      # @throws SecurityException
      #        if a security manager exists and its
      #        <code>checkPermission</code> method doesn't allow
      #        the password authentication request.
      # 
      # @see SecurityManager#checkPermission
      # @see java.net.NetPermission
      # 
      # @since 1.5
      def request_password_authentication(host, addr, port, protocol, prompt, scheme, url, req_type)
        sm = System.get_security_manager
        if (!(sm).nil?)
          request_permission = NetPermission.new("requestPasswordAuthentication")
          sm.check_permission(request_permission)
        end
        a = self.attr_the_authenticator
        if ((a).nil?)
          return nil
        else
          synchronized((a)) do
            a.reset
            a.attr_requesting_host = host
            a.attr_requesting_site = addr
            a.attr_requesting_port = port
            a.attr_requesting_protocol = protocol
            a.attr_requesting_prompt = prompt
            a.attr_requesting_scheme = scheme
            a.attr_requesting_url = url
            a.attr_requesting_auth_type = req_type
            return a.get_password_authentication
          end
        end
      end
    }
    
    typesig { [] }
    # Gets the <code>hostname</code> of the
    # site or proxy requesting authentication, or <code>null</code>
    # if not available.
    # 
    # @return the hostname of the connection requiring authentication, or null
    #          if it's not available.
    # @since 1.4
    def get_requesting_host
      return @requesting_host
    end
    
    typesig { [] }
    # Gets the <code>InetAddress</code> of the
    # site requesting authorization, or <code>null</code>
    # if not available.
    # 
    # @return the InetAddress of the site requesting authorization, or null
    #          if it's not available.
    def get_requesting_site
      return @requesting_site
    end
    
    typesig { [] }
    # Gets the port number for the requested connection.
    # @return an <code>int</code> indicating the
    # port for the requested connection.
    def get_requesting_port
      return @requesting_port
    end
    
    typesig { [] }
    # Give the protocol that's requesting the connection.  Often this
    # will be based on a URL, but in a future JDK it could be, for
    # example, "SOCKS" for a password-protected SOCKS5 firewall.
    # 
    # @return the protcol, optionally followed by "/version", where
    #          version is a version number.
    # 
    # @see java.net.URL#getProtocol()
    def get_requesting_protocol
      return @requesting_protocol
    end
    
    typesig { [] }
    # Gets the prompt string given by the requestor.
    # 
    # @return the prompt string given by the requestor (realm for
    #          http requests)
    def get_requesting_prompt
      return @requesting_prompt
    end
    
    typesig { [] }
    # Gets the scheme of the requestor (the HTTP scheme
    # for an HTTP firewall, for example).
    # 
    # @return the scheme of the requestor
    def get_requesting_scheme
      return @requesting_scheme
    end
    
    typesig { [] }
    # Called when password authorization is needed.  Subclasses should
    # override the default implementation, which returns null.
    # @return The PasswordAuthentication collected from the
    #          user, or null if none is provided.
    def get_password_authentication
      return nil
    end
    
    typesig { [] }
    # Returns the URL that resulted in this
    # request for authentication.
    # 
    # @since 1.5
    # 
    # @return the requesting URL
    def get_requesting_url
      return @requesting_url
    end
    
    typesig { [] }
    # Returns whether the requestor is a Proxy or a Server.
    # 
    # @since 1.5
    # 
    # @return the authentication type of the requestor
    def get_requestor_type
      return @requesting_auth_type
    end
    
    typesig { [] }
    def initialize
      @requesting_host = nil
      @requesting_site = nil
      @requesting_port = 0
      @requesting_protocol = nil
      @requesting_prompt = nil
      @requesting_scheme = nil
      @requesting_url = nil
      @requesting_auth_type = nil
    end
    
    private
    alias_method :initialize__authenticator, :initialize
  end
  
end

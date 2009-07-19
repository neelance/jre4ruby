require "rjava"

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
  module InetSocketAddressImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InvalidObjectException
    }
  end
  
  # This class implements an IP Socket Address (IP address + port number)
  # It can also be a pair (hostname + port number), in which case an attempt
  # will be made to resolve the hostname. If resolution fails then the address
  # is said to be <I>unresolved</I> but can still be used on some circumstances
  # like connecting through a proxy.
  # <p>
  # It provides an immutable object used by sockets for binding, connecting, or
  # as returned values.
  # <p>
  # The <i>wildcard</i> is a special local IP address. It usually means "any"
  # and can only be used for <code>bind</code> operations.
  # 
  # @see java.net.Socket
  # @see java.net.ServerSocket
  # @since 1.4
  class InetSocketAddress < InetSocketAddressImports.const_get :SocketAddress
    include_class_members InetSocketAddressImports
    
    # The hostname of the Socket Address
    # @serial
    attr_accessor :hostname
    alias_method :attr_hostname, :hostname
    undef_method :hostname
    alias_method :attr_hostname=, :hostname=
    undef_method :hostname=
    
    # The IP address of the Socket Address
    # @serial
    attr_accessor :addr
    alias_method :attr_addr, :addr
    undef_method :addr
    alias_method :attr_addr=, :addr=
    undef_method :addr=
    
    # The port number of the Socket Address
    # @serial
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5076001401234631237 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    def initialize
      @hostname = nil
      @addr = nil
      @port = 0
      super()
      @hostname = nil
      @addr = nil
    end
    
    typesig { [::Java::Int] }
    # Creates a socket address where the IP address is the wildcard address
    # and the port number a specified value.
    # <p>
    # A valid port value is between 0 and 65535.
    # A port number of <code>zero</code> will let the system pick up an
    # ephemeral port in a <code>bind</code> operation.
    # <p>
    # @param   port    The port number
    # @throws IllegalArgumentException if the port parameter is outside the specified
    # range of valid port values.
    def initialize(port)
      initialize__inet_socket_address(InetAddress.any_local_address, port)
    end
    
    typesig { [InetAddress, ::Java::Int] }
    # Creates a socket address from an IP address and a port number.
    # <p>
    # A valid port value is between 0 and 65535.
    # A port number of <code>zero</code> will let the system pick up an
    # ephemeral port in a <code>bind</code> operation.
    # <P>
    # A <code>null</code> address will assign the <i>wildcard</i> address.
    # <p>
    # @param   addr    The IP address
    # @param   port    The port number
    # @throws IllegalArgumentException if the port parameter is outside the specified
    # range of valid port values.
    def initialize(addr, port)
      @hostname = nil
      @addr = nil
      @port = 0
      super()
      @hostname = nil
      @addr = nil
      if (port < 0 || port > 0xffff)
        raise IllegalArgumentException.new("port out of range:" + (port).to_s)
      end
      @port = port
      if ((addr).nil?)
        @addr = InetAddress.any_local_address
      else
        @addr = addr
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a socket address from a hostname and a port number.
    # <p>
    # An attempt will be made to resolve the hostname into an InetAddress.
    # If that attempt fails, the address will be flagged as <I>unresolved</I>.
    # <p>
    # If there is a security manager, its <code>checkConnect</code> method
    # is called with the host name as its argument to check the permissiom
    # to resolve it. This could result in a SecurityException.
    # <P>
    # A valid port value is between 0 and 65535.
    # A port number of <code>zero</code> will let the system pick up an
    # ephemeral port in a <code>bind</code> operation.
    # <P>
    # @param   hostname the Host name
    # @param   port    The port number
    # @throws IllegalArgumentException if the port parameter is outside the range
    # of valid port values, or if the hostname parameter is <TT>null</TT>.
    # @throws SecurityException if a security manager is present and
    # permission to resolve the host name is
    # denied.
    # @see     #isUnresolved()
    def initialize(hostname, port)
      @hostname = nil
      @addr = nil
      @port = 0
      super()
      @hostname = nil
      @addr = nil
      if (port < 0 || port > 0xffff)
        raise IllegalArgumentException.new("port out of range:" + (port).to_s)
      end
      if ((hostname).nil?)
        raise IllegalArgumentException.new("hostname can't be null")
      end
      begin
        @addr = InetAddress.get_by_name(hostname)
      rescue UnknownHostException => e
        @hostname = hostname
        @addr = nil
      end
      @port = port
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # Creates an unresolved socket address from a hostname and a port number.
      # <p>
      # No attempt will be made to resolve the hostname into an InetAddress.
      # The address will be flagged as <I>unresolved</I>.
      # <p>
      # A valid port value is between 0 and 65535.
      # A port number of <code>zero</code> will let the system pick up an
      # ephemeral port in a <code>bind</code> operation.
      # <P>
      # @param   host    the Host name
      # @param   port    The port number
      # @throws IllegalArgumentException if the port parameter is outside
      # the range of valid port values, or if the hostname
      # parameter is <TT>null</TT>.
      # @see     #isUnresolved()
      # @return  a <code>InetSocketAddress</code> representing the unresolved
      # socket address
      # @since 1.5
      def create_unresolved(host, port)
        if (port < 0 || port > 0xffff)
          raise IllegalArgumentException.new("port out of range:" + (port).to_s)
        end
        if ((host).nil?)
          raise IllegalArgumentException.new("hostname can't be null")
        end
        s = InetSocketAddress.new
        s.attr_port = port
        s.attr_hostname = host
        s.attr_addr = nil
        return s
      end
    }
    
    typesig { [ObjectInputStream] }
    def read_object(s)
      s.default_read_object
      # Check that our invariants are satisfied
      if (@port < 0 || @port > 0xffff)
        raise InvalidObjectException.new("port out of range:" + (@port).to_s)
      end
      if ((@hostname).nil? && (@addr).nil?)
        raise InvalidObjectException.new("hostname and addr " + "can't both be null")
      end
    end
    
    typesig { [] }
    # Gets the port number.
    # 
    # @return the port number.
    def get_port
      return @port
    end
    
    typesig { [] }
    # Gets the <code>InetAddress</code>.
    # 
    # @return the InetAdress or <code>null</code> if it is unresolved.
    def get_address
      return @addr
    end
    
    typesig { [] }
    # Gets the <code>hostname</code>.
    # 
    # @return  the hostname part of the address.
    def get_host_name
      if (!(@hostname).nil?)
        return @hostname
      end
      if (!(@addr).nil?)
        return @addr.get_host_name
      end
      return nil
    end
    
    typesig { [] }
    # Returns the hostname, or the String form of the address if it
    # doesn't have a hostname (it was created using a literal).
    # This has the benefit of <b>not</b> attemptimg a reverse lookup.
    # 
    # @return the hostname, or String representation of the address.
    # @since 1.6
    def get_host_string
      if (!(@hostname).nil?)
        return @hostname
      end
      if (!(@addr).nil?)
        if (!(@addr.attr_host_name).nil?)
          return @addr.attr_host_name
        else
          return @addr.get_host_address
        end
      end
      return nil
    end
    
    typesig { [] }
    # Checks whether the address has been resolved or not.
    # 
    # @return <code>true</code> if the hostname couldn't be resolved into
    # an <code>InetAddress</code>.
    def is_unresolved
      return (@addr).nil?
    end
    
    typesig { [] }
    # Constructs a string representation of this InetSocketAddress.
    # This String is constructed by calling toString() on the InetAddress
    # and concatenating the port number (with a colon). If the address
    # is unresolved then the part before the colon will only contain the hostname.
    # 
    # @return  a string representation of this object.
    def to_s
      if (is_unresolved)
        return @hostname + ":" + (@port).to_s
      else
        return (@addr.to_s).to_s + ":" + (@port).to_s
      end
    end
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is <code>true</code> if and only if the argument is
    # not <code>null</code> and it represents the same address as
    # this object.
    # <p>
    # Two instances of <code>InetSocketAddress</code> represent the same
    # address if both the InetAddresses (or hostnames if it is unresolved) and port
    # numbers are equal.
    # If both addresses are unresolved, then the hostname & the port number
    # are compared.
    # 
    # @param   obj   the object to compare against.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    # @see java.net.InetAddress#equals(java.lang.Object)
    def equals(obj)
      if ((obj).nil? || !(obj.is_a?(InetSocketAddress)))
        return false
      end
      sock_addr = obj
      same_ip = false
      if (!(@addr).nil?)
        same_ip = (@addr == sock_addr.attr_addr)
      else
        if (!(@hostname).nil?)
          same_ip = ((sock_addr.attr_addr).nil?) && (@hostname == sock_addr.attr_hostname)
        else
          same_ip = ((sock_addr.attr_addr).nil?) && ((sock_addr.attr_hostname).nil?)
        end
      end
      return same_ip && ((@port).equal?(sock_addr.attr_port))
    end
    
    typesig { [] }
    # Returns a hashcode for this socket address.
    # 
    # @return  a hash code value for this socket address.
    def hash_code
      if (!(@addr).nil?)
        return @addr.hash_code + @port
      end
      if (!(@hostname).nil?)
        return @hostname.hash_code + @port
      end
      return @port
    end
    
    private
    alias_method :initialize__inet_socket_address, :initialize
  end
  
end

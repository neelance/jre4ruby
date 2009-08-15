require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ProxyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # This class represents a proxy setting, typically a type (http, socks) and
  # a socket address.
  # A <code>Proxy</code> is an immutable object.
  # 
  # @see     java.net.ProxySelector
  # @author Yingxian Wang
  # @author Jean-Christophe Collet
  # @since   1.5
  class Proxy 
    include_class_members ProxyImports
    
    class_module.module_eval {
      const_set_lazy(:DIRECT) { Type::DIRECT }
      const_attr_reader  :DIRECT
      
      const_set_lazy(:HTTP) { Type::HTTP }
      const_attr_reader  :HTTP
      
      const_set_lazy(:SOCKS) { Type::SOCKS }
      const_attr_reader  :SOCKS
      
      # Represents the proxy type.
      # 
      # @since 1.5
      class Type 
        include_class_members Proxy
        
        class_module.module_eval {
          # Represents a direct connection, or the absence of a proxy.
          const_set_lazy(:DIRECT) { Type.new.set_value_name("DIRECT") }
          const_attr_reader  :DIRECT
          
          # Represents proxy for high level protocols such as HTTP or FTP.
          const_set_lazy(:HTTP) { Type.new.set_value_name("HTTP") }
          const_attr_reader  :HTTP
          
          # Represents a SOCKS (V4 or V5) proxy.
          const_set_lazy(:SOCKS) { Type.new.set_value_name("SOCKS") }
          const_attr_reader  :SOCKS
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
            [DIRECT, HTTP, SOCKS]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__type, :initialize
      end
    }
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    attr_accessor :sa
    alias_method :attr_sa, :sa
    undef_method :sa
    alias_method :attr_sa=, :sa=
    undef_method :sa=
    
    class_module.module_eval {
      # A proxy setting that represents a <code>DIRECT</code> connection,
      # basically telling the protocol handler not to use any proxying.
      # Used, for instance, to create sockets bypassing any other global
      # proxy settings (like SOCKS):
      # <P>
      # <code>Socket s = new Socket(Proxy.NO_PROXY);</code><br>
      # <P>
      const_set_lazy(:NO_PROXY) { Proxy.new }
      const_attr_reader  :NO_PROXY
    }
    
    typesig { [] }
    # Creates the proxy that represents a <code>DIRECT</code> connection.
    def initialize
      @type = nil
      @sa = nil
      @type = @type.attr_direct
      @sa = nil
    end
    
    typesig { [Type, SocketAddress] }
    # Creates an entry representing a PROXY connection.
    # Certain combinations are illegal. For instance, for types Http, and
    # Socks, a SocketAddress <b>must</b> be provided.
    # <P>
    # Use the <code>Proxy.NO_PROXY</code> constant
    # for representing a direct connection.
    # 
    # @param type the <code>Type</code> of the proxy
    # @param sa the <code>SocketAddress</code> for that proxy
    # @throws IllegalArgumentException when the type and the address are
    # incompatible
    def initialize(type, sa)
      @type = nil
      @sa = nil
      if (((type).equal?(Type::DIRECT)) || !(sa.is_a?(InetSocketAddress)))
        raise IllegalArgumentException.new("type " + RJava.cast_to_string(type) + " is not compatible with address " + RJava.cast_to_string(sa))
      end
      @type = type
      @sa = sa
    end
    
    typesig { [] }
    # Returns the proxy type.
    # 
    # @return a Type representing the proxy type
    def type
      return @type
    end
    
    typesig { [] }
    # Returns the socket address of the proxy, or
    # <code>null</code> if its a direct connection.
    # 
    # @return a <code>SocketAddress</code> representing the socket end
    # point of the proxy
    def address
      return @sa
    end
    
    typesig { [] }
    # Constructs a string representation of this Proxy.
    # This String is constructed by calling toString() on its type
    # and concatenating " @ " and the toString() result from its address
    # if its type is not <code>DIRECT</code>.
    # 
    # @return  a string representation of this object.
    def to_s
      if ((type).equal?(Type::DIRECT))
        return "DIRECT"
      end
      return RJava.cast_to_string(type) + " @ " + RJava.cast_to_string(address)
    end
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is <code>true</code> if and only if the argument is
    # not <code>null</code> and it represents the same proxy as
    # this object.
    # <p>
    # Two instances of <code>Proxy</code> represent the same
    # address if both the SocketAddresses and type are equal.
    # 
    # @param   obj   the object to compare against.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    # @see java.net.InetSocketAddress#equals(java.lang.Object)
    def ==(obj)
      if ((obj).nil? || !(obj.is_a?(Proxy)))
        return false
      end
      p = obj
      if ((p.type).equal?(type))
        if ((address).nil?)
          return ((p.address).nil?)
        else
          return (address == p.address)
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns a hashcode for this Proxy.
    # 
    # @return  a hash code value for this Proxy.
    def hash_code
      if ((address).nil?)
        return type.hash_code
      end
      return type.hash_code + address.hash_code
    end
    
    private
    alias_method :initialize__proxy, :initialize
  end
  
end

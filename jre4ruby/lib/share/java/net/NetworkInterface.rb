require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NetworkInterfaceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Net, :SocketException
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
      include ::Sun::Security::Action
      include_const ::Java::Security, :AccessController
    }
  end
  
  # This class represents a Network Interface made up of a name,
  # and a list of IP addresses assigned to this interface.
  # It is used to identify the local interface on which a multicast group
  # is joined.
  # 
  # Interfaces are normally known by names such as "le0".
  # 
  # @since 1.4
  class NetworkInterface 
    include_class_members NetworkInterfaceImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :display_name
    alias_method :attr_display_name, :display_name
    undef_method :display_name
    alias_method :attr_display_name=, :display_name=
    undef_method :display_name=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :addrs
    alias_method :attr_addrs, :addrs
    undef_method :addrs
    alias_method :attr_addrs=, :addrs=
    undef_method :addrs=
    
    attr_accessor :bindings
    alias_method :attr_bindings, :bindings
    undef_method :bindings
    alias_method :attr_bindings=, :bindings=
    undef_method :bindings=
    
    attr_accessor :childs
    alias_method :attr_childs, :childs
    undef_method :childs
    alias_method :attr_childs=, :childs=
    undef_method :childs=
    
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    attr_accessor :virtual
    alias_method :attr_virtual, :virtual
    undef_method :virtual
    alias_method :attr_virtual=, :virtual=
    undef_method :virtual=
    
    class_module.module_eval {
      when_class_loaded do
        AccessController.do_privileged(LoadLibraryAction.new("net"))
        init
      end
    }
    
    typesig { [] }
    # Returns an NetworkInterface object with index set to 0 and name to null.
    # Setting such an interface on a MulticastSocket will cause the
    # kernel to choose one interface for sending multicast packets.
    def initialize
      @name = nil
      @display_name = nil
      @index = 0
      @addrs = nil
      @bindings = nil
      @childs = nil
      @parent = nil
      @virtual = false
    end
    
    typesig { [String, ::Java::Int, Array.typed(InetAddress)] }
    def initialize(name, index, addrs)
      @name = nil
      @display_name = nil
      @index = 0
      @addrs = nil
      @bindings = nil
      @childs = nil
      @parent = nil
      @virtual = false
      @name = name
      @index = index
      @addrs = addrs
    end
    
    typesig { [] }
    # Get the name of this network interface.
    # 
    # @return the name of this network interface
    def get_name
      return @name
    end
    
    typesig { [] }
    # Convenience method to return an Enumeration with all or a
    # subset of the InetAddresses bound to this network interface.
    # <p>
    # If there is a security manager, its <code>checkConnect</code>
    # method is called for each InetAddress. Only InetAddresses where
    # the <code>checkConnect</code> doesn't throw a SecurityException
    # will be returned in the Enumeration.
    # @return an Enumeration object with all or a subset of the InetAddresses
    # bound to this network interface
    def get_inet_addresses
      checked_addresses_class = Class.new do
        local_class_in NetworkInterface
        include_class_members NetworkInterface
        include Enumeration
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        attr_accessor :local_addrs
        alias_method :attr_local_addrs, :local_addrs
        undef_method :local_addrs
        alias_method :attr_local_addrs=, :local_addrs=
        undef_method :local_addrs=
        
        typesig { [] }
        define_method :initialize do
          @i = 0
          @count = 0
          @local_addrs = nil
          @local_addrs = Array.typed(self.class::InetAddress).new(self.attr_addrs.attr_length) { nil }
          sec = System.get_security_manager
          j = 0
          while j < self.attr_addrs.attr_length
            begin
              if (!(sec).nil?)
                sec.check_connect(self.attr_addrs[j].get_host_address, -1)
              end
              @local_addrs[((@count += 1) - 1)] = self.attr_addrs[j]
            rescue self.class::SecurityException => e
            end
            j += 1
          end
        end
        
        typesig { [] }
        define_method :next_element do
          if (@i < @count)
            return @local_addrs[((@i += 1) - 1)]
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        typesig { [] }
        define_method :has_more_elements do
          return (@i < @count)
        end
        
        private
        alias_method :initialize_checked_addresses, :initialize
      end
      return checked_addresses_class.new
    end
    
    typesig { [] }
    # Get a List of all or a subset of the <code>InterfaceAddresses</code>
    # of this network interface.
    # <p>
    # If there is a security manager, its <code>checkConnect</code>
    # method is called with the InetAddress for each InterfaceAddress.
    # Only InterfaceAddresses where the <code>checkConnect</code> doesn't throw
    # a SecurityException will be returned in the List.
    # 
    # @return a <code>List</code> object with all or a subset of the
    # InterfaceAddresss of this network interface
    # @since 1.6
    def get_interface_addresses
      lst = Java::Util::ArrayList.new(1)
      sec = System.get_security_manager
      j = 0
      while j < @bindings.attr_length
        begin
          if (!(sec).nil?)
            sec.check_connect(@bindings[j].get_address.get_host_address, -1)
          end
          lst.add(@bindings[j])
        rescue SecurityException => e
        end
        j += 1
      end
      return lst
    end
    
    typesig { [] }
    # Get an Enumeration with all the subinterfaces (also known as virtual
    # interfaces) attached to this network interface.
    # <p>
    # For instance eth0:1 will be a subinterface to eth0.
    # 
    # @return an Enumeration object with all of the subinterfaces
    # of this network interface
    # @since 1.6
    def get_sub_interfaces
      sub_ifs_class = Class.new do
        local_class_in NetworkInterface
        include_class_members NetworkInterface
        include Enumeration
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        typesig { [] }
        define_method :initialize do
          @i = 0
        end
        
        typesig { [] }
        define_method :next_element do
          if (@i < self.attr_childs.attr_length)
            return self.attr_childs[((@i += 1) - 1)]
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        typesig { [] }
        define_method :has_more_elements do
          return (@i < self.attr_childs.attr_length)
        end
        
        private
        alias_method :initialize_sub_ifs, :initialize
      end
      return sub_ifs_class.new
    end
    
    typesig { [] }
    # Returns the parent NetworkInterface of this interface if this is
    # a subinterface, or <code>null</code> if it is a physical
    # (non virtual) interface or has no parent.
    # 
    # @return The <code>NetworkInterface</code> this interface is attached to.
    # @since 1.6
    def get_parent
      return @parent
    end
    
    typesig { [] }
    # Get the index of this network interface.
    # 
    # @return the index of this network interface
    def get_index
      return @index
    end
    
    typesig { [] }
    # Get the display name of this network interface.
    # A display name is a human readable String describing the network
    # device.
    # 
    # @return the display name of this network interface,
    # or null if no display name is available.
    def get_display_name
      return @display_name
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Searches for the network interface with the specified name.
      # 
      # @param   name
      # The name of the network interface.
      # 
      # @return  A <tt>NetworkInterface</tt> with the specified name,
      # or <tt>null</tt> if there is no network interface
      # with the specified name.
      # 
      # @throws  SocketException
      # If an I/O error occurs.
      # 
      # @throws  NullPointerException
      # If the specified name is <tt>null</tt>.
      def get_by_name(name)
        if ((name).nil?)
          raise NullPointerException.new
        end
        return get_by_name0(name)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getByIndex, [:pointer, :long, :int32], :long
      typesig { [::Java::Int] }
      # Get a network interface given its index.
      # 
      # @param index an integer, the index of the interface
      # @return the NetworkInterface obtained from its index
      # @exception  SocketException  if an I/O error occurs.
      def get_by_index(index)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getByIndex, JNI.env, self.jni_id, index.to_int)
      end
      
      typesig { [InetAddress] }
      # Convenience method to search for a network interface that
      # has the specified Internet Protocol (IP) address bound to
      # it.
      # <p>
      # If the specified IP address is bound to multiple network
      # interfaces it is not defined which network interface is
      # returned.
      # 
      # @param   addr
      # The <tt>InetAddress</tt> to search with.
      # 
      # @return  A <tt>NetworkInterface</tt>
      # or <tt>null</tt> if there is no network interface
      # with the specified IP address.
      # 
      # @throws  SocketException
      # If an I/O error occurs.
      # 
      # @throws  NullPointerException
      # If the specified address is <tt>null</tt>.
      def get_by_inet_address(addr)
        if ((addr).nil?)
          raise NullPointerException.new
        end
        return get_by_inet_address0(addr)
      end
      
      typesig { [] }
      # Returns all the interfaces on this machine. Returns null if no
      # network interfaces could be found on this machine.
      # 
      # NOTE: can use getNetworkInterfaces()+getInetAddresses()
      # to obtain all IP addresses for this node
      # 
      # @return an Enumeration of NetworkInterfaces found on this machine
      # @exception  SocketException  if an I/O error occurs.
      def get_network_interfaces
        netifs = get_all
        # specified to return null if no network interfaces
        if ((netifs).nil?)
          return nil
        end
        return Class.new(Enumeration.class == Class ? Enumeration : Object) do
          local_class_in NetworkInterface
          include_class_members NetworkInterface
          include Enumeration if Enumeration.class == Module
          
          attr_accessor :i
          alias_method :attr_i, :i
          undef_method :i
          alias_method :attr_i=, :i=
          undef_method :i=
          
          typesig { [] }
          define_method :next_element do
            if (!(netifs).nil? && @i < netifs.attr_length)
              netif = netifs[((@i += 1) - 1)]
              return netif
            else
              raise self.class::NoSuchElementException.new
            end
          end
          
          typesig { [] }
          define_method :has_more_elements do
            return (!(netifs).nil? && @i < netifs.attr_length)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            @i = 0
            super(*args)
            @i = 0
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getAll, [:pointer, :long], :long
      typesig { [] }
      def get_all
        JNI.call_native_method(:Java_java_net_NetworkInterface_getAll, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getByName0, [:pointer, :long, :long], :long
      typesig { [String] }
      def get_by_name0(name)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getByName0, JNI.env, self.jni_id, name.jni_id)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getByInetAddress0, [:pointer, :long, :long], :long
      typesig { [InetAddress] }
      def get_by_inet_address0(addr)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getByInetAddress0, JNI.env, self.jni_id, addr.jni_id)
      end
    }
    
    typesig { [] }
    # Returns whether a network interface is up and running.
    # 
    # @return  <code>true</code> if the interface is up and running.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def is_up
      return is_up0(@name, @index)
    end
    
    typesig { [] }
    # Returns whether a network interface is a loopback interface.
    # 
    # @return  <code>true</code> if the interface is a loopback interface.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def is_loopback
      return is_loopback0(@name, @index)
    end
    
    typesig { [] }
    # Returns whether a network interface is a point to point interface.
    # A typical point to point interface would be a PPP connection through
    # a modem.
    # 
    # @return  <code>true</code> if the interface is a point to point
    # interface.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def is_point_to_point
      return is_p2p0(@name, @index)
    end
    
    typesig { [] }
    # Returns whether a network interface supports multicasting or not.
    # 
    # @return  <code>true</code> if the interface supports Multicasting.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def supports_multicast
      return supports_multicast0(@name, @index)
    end
    
    typesig { [] }
    # Returns the hardware address (usually MAC) of the interface if it
    # has one and if it can be accessed given the current privileges.
    # 
    # @return  a byte array containing the address or <code>null</code> if
    # the address doesn't exist or is not accessible.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def get_hardware_address
      @addrs.each do |addr|
        if (addr.is_a?(Inet4Address))
          return get_mac_addr0((addr).get_address, @name, @index)
        end
      end
      return get_mac_addr0(nil, @name, @index)
    end
    
    typesig { [] }
    # Returns the Maximum Transmission Unit (MTU) of this interface.
    # 
    # @return the value of the MTU for that interface.
    # @exception       SocketException if an I/O error occurs.
    # @since 1.6
    def get_mtu
      return get_mtu0(@name, @index)
    end
    
    typesig { [] }
    # Returns whether this interface is a virtual interface (also called
    # subinterface).
    # Virtual interfaces are, on some systems, interfaces created as a child
    # of a physical interface and given different settings (like address or
    # MTU). Usually the name of the interface will the name of the parent
    # followed by a colon (:) and a number identifying the child since there
    # can be several virtual interfaces attached to a single physical
    # interface.
    # 
    # @return <code>true</code> if this interface is a virtual interface.
    # @since 1.6
    def is_virtual
      return @virtual
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_NetworkInterface_getSubnet0, [:pointer, :long, :long, :int32], :int64
      typesig { [String, ::Java::Int] }
      def get_subnet0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getSubnet0, JNI.env, self.jni_id, name.jni_id, ind.to_int)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getBroadcast0, [:pointer, :long, :long, :int32], :long
      typesig { [String, ::Java::Int] }
      def get_broadcast0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getBroadcast0, JNI.env, self.jni_id, name.jni_id, ind.to_int)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_isUp0, [:pointer, :long, :long, :int32], :int8
      typesig { [String, ::Java::Int] }
      def is_up0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_isUp0, JNI.env, self.jni_id, name.jni_id, ind.to_int) != 0
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_isLoopback0, [:pointer, :long, :long, :int32], :int8
      typesig { [String, ::Java::Int] }
      def is_loopback0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_isLoopback0, JNI.env, self.jni_id, name.jni_id, ind.to_int) != 0
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_supportsMulticast0, [:pointer, :long, :long, :int32], :int8
      typesig { [String, ::Java::Int] }
      def supports_multicast0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_supportsMulticast0, JNI.env, self.jni_id, name.jni_id, ind.to_int) != 0
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_isP2P0, [:pointer, :long, :long, :int32], :int8
      typesig { [String, ::Java::Int] }
      def is_p2p0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_isP2P0, JNI.env, self.jni_id, name.jni_id, ind.to_int) != 0
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getMacAddr0, [:pointer, :long, :long, :long, :int32], :long
      typesig { [Array.typed(::Java::Byte), String, ::Java::Int] }
      def get_mac_addr0(in_addr, name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getMacAddr0, JNI.env, self.jni_id, in_addr.jni_id, name.jni_id, ind.to_int)
      end
      
      JNI.load_native_method :Java_java_net_NetworkInterface_getMTU0, [:pointer, :long, :long, :int32], :int32
      typesig { [String, ::Java::Int] }
      def get_mtu0(name, ind)
        JNI.call_native_method(:Java_java_net_NetworkInterface_getMTU0, JNI.env, self.jni_id, name.jni_id, ind.to_int)
      end
    }
    
    typesig { [Object] }
    # Compares this object against the specified object.
    # The result is <code>true</code> if and only if the argument is
    # not <code>null</code> and it represents the same NetworkInterface
    # as this object.
    # <p>
    # Two instances of <code>NetworkInterface</code> represent the same
    # NetworkInterface if both name and addrs are the same for both.
    # 
    # @param   obj   the object to compare against.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    # @see     java.net.InetAddress#getAddress()
    def ==(obj)
      if (((obj).nil?) || !(obj.is_a?(NetworkInterface)))
        return false
      end
      net_if = obj
      if (!(@name).nil?)
        if (!(net_if.get_name).nil?)
          if (!(@name == net_if.get_name))
            return false
          end
        else
          return false
        end
      else
        if (!(net_if.get_name).nil?)
          return false
        end
      end
      new_addrs = net_if.get_inet_addresses
      i = 0
      i = 0
      while new_addrs.has_more_elements
        new_addrs.next_element
        i += 1
      end
      if ((@addrs).nil?)
        if (!(i).equal?(0))
          return false
        end
      else
        # Compare number of addresses (in the checked subset)
        count = 0
        e = get_inet_addresses
        while e.has_more_elements
          e.next_element
          count += 1
        end
        if (!(i).equal?(count))
          return false
        end
      end
      new_addrs = net_if.get_inet_addresses
      while new_addrs.has_more_elements
        equal = false
        this_addrs = get_inet_addresses
        new_addr = new_addrs.next_element
        while this_addrs.has_more_elements
          this_addr = this_addrs.next_element
          if ((this_addr == new_addr))
            equal = true
          end
        end
        if (!equal)
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    def hash_code
      count = 0
      if (!(@addrs).nil?)
        i = 0
        while i < @addrs.attr_length
          count += @addrs[i].hash_code
          i += 1
        end
      end
      return count
    end
    
    typesig { [] }
    def to_s
      result = "name:"
      result += RJava.cast_to_string((@name).nil? ? "null" : @name)
      if (!(@display_name).nil?)
        result += " (" + @display_name + ")"
      end
      result += " index: " + RJava.cast_to_string(@index) + " addresses:\n"
      e = get_inet_addresses
      while e.has_more_elements
        addr = e.next_element
        result += RJava.cast_to_string(addr) + ";\n"
      end
      return result
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_net_NetworkInterface_init, [:pointer, :long], :void
      typesig { [] }
      def init
        JNI.call_native_method(:Java_java_net_NetworkInterface_init, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__network_interface, :initialize
  end
  
end

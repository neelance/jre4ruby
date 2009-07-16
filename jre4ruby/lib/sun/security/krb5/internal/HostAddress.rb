require "rjava"

# 
# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module HostAddressImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include ::Sun::Security::Util
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :Inet4Address
      include_const ::Java::Net, :Inet6Address
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # Implements the ASN.1 HostAddress type.
  # 
  # <xmp>
  # HostAddress     ::= SEQUENCE  {
  # addr-type       [0] Int32,
  # address         [1] OCTET STRING
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class HostAddress 
    include_class_members HostAddressImports
    include Cloneable
    
    attr_accessor :addr_type
    alias_method :attr_addr_type, :addr_type
    undef_method :addr_type
    alias_method :attr_addr_type=, :addr_type=
    undef_method :addr_type=
    
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    class_module.module_eval {
      
      def local_inet_address
        defined?(@@local_inet_address) ? @@local_inet_address : @@local_inet_address= nil
      end
      alias_method :attr_local_inet_address, :local_inet_address
      
      def local_inet_address=(value)
        @@local_inet_address = value
      end
      alias_method :attr_local_inet_address=, :local_inet_address=
      
      # caches local inet address
      const_set_lazy(:DEBUG) { Sun::Security::Krb5::Internal::Krb5::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    typesig { [::Java::Int] }
    def initialize(dummy)
      @addr_type = 0
      @address = nil
      @hash_code = 0
    end
    
    typesig { [] }
    def clone
      new_host_address = HostAddress.new(0)
      new_host_address.attr_addr_type = @addr_type
      if (!(@address).nil?)
        new_host_address.attr_address = @address.clone
      end
      return new_host_address
    end
    
    typesig { [] }
    def hash_code
      if ((@hash_code).equal?(0))
        result = 17
        result = 37 * result + @addr_type
        if (!(@address).nil?)
          i = 0
          while i < @address.attr_length
            result = 37 * result + @address[i]
            ((i += 1) - 1)
          end
        end
        @hash_code = result
      end
      return @hash_code
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(HostAddress)))
        return false
      end
      h = obj
      if (!(@addr_type).equal?(h.attr_addr_type) || (!(@address).nil? && (h.attr_address).nil?) || ((@address).nil? && !(h.attr_address).nil?))
        return false
      end
      if (!(@address).nil? && !(h.attr_address).nil?)
        if (!(@address.attr_length).equal?(h.attr_address.attr_length))
          return false
        end
        i = 0
        while i < @address.attr_length
          if (!(@address[i]).equal?(h.attr_address[i]))
            return false
          end
          ((i += 1) - 1)
        end
      end
      return true
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_local_inet_address
        synchronized(self) do
          if ((self.attr_local_inet_address).nil?)
            self.attr_local_inet_address = InetAddress.get_local_host
          end
          if ((self.attr_local_inet_address).nil?)
            raise UnknownHostException.new
          end
          return (self.attr_local_inet_address)
        end
      end
    }
    
    typesig { [] }
    # 
    # Gets the InetAddress of this HostAddress.
    # @return the IP address for this specified host.
    # @exception if no IP address for the host could be found.
    def get_inet_address
      # the type of internet addresses is 2.
      if ((@addr_type).equal?(Krb5::ADDRTYPE_INET) || (@addr_type).equal?(Krb5::ADDRTYPE_INET6))
        return (InetAddress.get_by_address(@address))
      else
        # if it is other type (ISO address, XNS address, etc)
        return nil
      end
    end
    
    typesig { [InetAddress] }
    def get_addr_type(inet_address)
      address_type = 0
      if (inet_address.is_a?(Inet4Address))
        address_type = Krb5::ADDRTYPE_INET
      else
        if (inet_address.is_a?(Inet6Address))
          address_type = Krb5::ADDRTYPE_INET6
        end
      end
      return (address_type)
    end
    
    typesig { [] }
    # implicit default not in Config.java
    def initialize
      @addr_type = 0
      @address = nil
      @hash_code = 0
      inet_address = get_local_inet_address
      @addr_type = get_addr_type(inet_address)
      @address = inet_address.get_address
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    # 
    # Creates a HostAddress from the specified address and address type.
    # 
    # @param new_addrType the value of the address type which matches the defined
    # address family constants in the Berkeley Standard
    # Distributions of Unix.
    # @param new_address network address.
    # @exception KrbApErrException if address type and address length do not match defined value.
    def initialize(new_addr_type, new_address)
      @addr_type = 0
      @address = nil
      @hash_code = 0
      case (new_addr_type)
      when Krb5::ADDRTYPE_INET
        # Internet address
        if (!(new_address.attr_length).equal?(4))
          raise KrbApErrException.new(0, "Invalid Internet address")
        end
      when Krb5::ADDRTYPE_CHAOS
        if (!(new_address.attr_length).equal?(2))
          # CHAOSnet address
          raise KrbApErrException.new(0, "Invalid CHAOSnet address")
        end
      when Krb5::ADDRTYPE_ISO
        # ISO address
      when Krb5::ADDRTYPE_IPX
        # XNS address
        if (!(new_address.attr_length).equal?(6))
          raise KrbApErrException.new(0, "Invalid XNS address")
        end
      when Krb5::ADDRTYPE_APPLETALK
        # AppleTalk DDP address
        if (!(new_address.attr_length).equal?(3))
          raise KrbApErrException.new(0, "Invalid DDP address")
        end
      when Krb5::ADDRTYPE_DECNET
        # DECnet Phase IV address
        if (!(new_address.attr_length).equal?(2))
          raise KrbApErrException.new(0, "Invalid DECnet Phase IV address")
        end
      when Krb5::ADDRTYPE_INET6
        # Internet IPv6 address
        if (!(new_address.attr_length).equal?(16))
          raise KrbApErrException.new(0, "Invalid Internet IPv6 address")
        end
      end
      @addr_type = new_addr_type
      if (!(new_address).nil?)
        @address = new_address.clone
      end
      if (DEBUG)
        if ((@addr_type).equal?(Krb5::ADDRTYPE_INET) || (@addr_type).equal?(Krb5::ADDRTYPE_INET6))
          System.out.println("Host address is " + (InetAddress.get_by_address(@address)).to_s)
        end
      end
    end
    
    typesig { [InetAddress] }
    def initialize(inet_address)
      @addr_type = 0
      @address = nil
      @hash_code = 0
      @addr_type = get_addr_type(inet_address)
      @address = inet_address.get_address
    end
    
    typesig { [DerValue] }
    # 
    # Constructs a host address from a single DER-encoded value.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @addr_type = 0
      @address = nil
      @hash_code = 0
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        @addr_type = der.get_data.get_big_integer.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        @address = der.get_data.get_octet_string
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # 
    # Encodes a HostAddress object.
    # @return a byte array of encoded HostAddress object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      temp.put_integer(@addr_type)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      temp.put_octet_string(@address)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # 
      # Parses (unmarshal) a host address from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @exception IOException if an I/O error occurs while reading encoded data.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of HostAddress.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return HostAddress.new(sub_der)
        end
      end
    }
    
    private
    alias_method :initialize__host_address, :initialize
  end
  
end

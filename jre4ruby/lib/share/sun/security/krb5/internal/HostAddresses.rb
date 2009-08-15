require "rjava"

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
  module HostAddressesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :Inet4Address
      include_const ::Java::Net, :Inet6Address
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CCacheOutputStream
    }
  end
  
  # Implements the ASN.1 HostAddresses type.
  # 
  # <xmp>
  # HostAddresses   -- NOTE: subtly different from rfc1510,
  # -- but has a value mapping and encodes the same
  # ::= SEQUENCE OF HostAddress
  # 
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
  class HostAddresses 
    include_class_members HostAddressesImports
    include Cloneable
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Sun::Security::Krb5::Internal::Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    attr_accessor :addresses
    alias_method :attr_addresses, :addresses
    undef_method :addresses
    alias_method :attr_addresses=, :addresses=
    undef_method :addresses=
    
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    typesig { [Array.typed(HostAddress)] }
    def initialize(new_addresses)
      @addresses = nil
      @hash_code = 0
      if (!(new_addresses).nil?)
        @addresses = Array.typed(HostAddress).new(new_addresses.attr_length) { nil }
        i = 0
        while i < new_addresses.attr_length
          if ((new_addresses[i]).nil?)
            raise IOException.new("Cannot create a HostAddress")
          else
            @addresses[i] = new_addresses[i].clone
          end
          i += 1
        end
      end
    end
    
    typesig { [] }
    def initialize
      @addresses = nil
      @hash_code = 0
      @addresses = Array.typed(HostAddress).new(1) { nil }
      @addresses[0] = HostAddress.new
    end
    
    typesig { [::Java::Int] }
    def initialize(dummy)
      @addresses = nil
      @hash_code = 0
    end
    
    typesig { [PrincipalName] }
    def initialize(server_principal)
      @addresses = nil
      @hash_code = 0
      components = server_principal.get_name_strings
      if (!(server_principal.get_name_type).equal?(PrincipalName::KRB_NT_SRV_HST) || components.attr_length < 2)
        raise KrbException.new(Krb5::KRB_ERR_GENERIC, "Bad name")
      end
      host = components[1]
      addr = InetAddress.get_all_by_name(host)
      h_addrs = Array.typed(HostAddress).new(addr.attr_length) { nil }
      i = 0
      while i < addr.attr_length
        h_addrs[i] = HostAddress.new(addr[i])
        i += 1
      end
      @addresses = h_addrs
    end
    
    typesig { [] }
    def clone
      new_host_addresses = HostAddresses.new(0)
      if (!(@addresses).nil?)
        new_host_addresses.attr_addresses = Array.typed(HostAddress).new(@addresses.attr_length) { nil }
        i = 0
        while i < @addresses.attr_length
          new_host_addresses.attr_addresses[i] = @addresses[i].clone
          i += 1
        end
      end
      return new_host_addresses
    end
    
    typesig { [HostAddress] }
    def in_list(addr)
      if (!(@addresses).nil?)
        i = 0
        while i < @addresses.attr_length
          if ((@addresses[i] == addr))
            return true
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [] }
    def hash_code
      if ((@hash_code).equal?(0))
        result = 17
        if (!(@addresses).nil?)
          i = 0
          while i < @addresses.attr_length
            result = 37 * result + @addresses[i].hash_code
            i += 1
          end
        end
        @hash_code = result
      end
      return @hash_code
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(HostAddresses)))
        return false
      end
      addrs = obj
      if (((@addresses).nil? && !(addrs.attr_addresses).nil?) || (!(@addresses).nil? && (addrs.attr_addresses).nil?))
        return false
      end
      if (!(@addresses).nil? && !(addrs.attr_addresses).nil?)
        if (!(@addresses.attr_length).equal?(addrs.attr_addresses.attr_length))
          return false
        end
        i = 0
        while i < @addresses.attr_length
          if (!(@addresses[i] == addrs.attr_addresses[i]))
            return false
          end
          i += 1
        end
      end
      return true
    end
    
    typesig { [DerValue] }
    # Constructs a new <code>HostAddresses</code> object.
    # @param encoding a single DER-encoded value.
    # @exception Asn1Exception if an error occurs while decoding an
    # ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading
    # encoded data.
    def initialize(encoding)
      @addresses = nil
      @hash_code = 0
      temp_addresses = Vector.new
      der = nil
      while (encoding.get_data.available > 0)
        der = encoding.get_data.get_der_value
        temp_addresses.add_element(HostAddress.new(der))
      end
      if (temp_addresses.size > 0)
        @addresses = Array.typed(HostAddress).new(temp_addresses.size) { nil }
        temp_addresses.copy_into(@addresses)
      end
    end
    
    typesig { [] }
    # Encodes a <code>HostAddresses</code> object.
    # @return byte array of encoded <code>HostAddresses</code> object.
    # @exception Asn1Exception if an error occurs while decoding an
    # ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading
    # encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      if (!(@addresses).nil? && @addresses.attr_length > 0)
        i = 0
        while i < @addresses.attr_length
          bytes.write(@addresses[i].asn1_encode)
          i += 1
        end
      end
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a <code>HostAddresses</code> from a DER input stream.
      # This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception if an Asn1Exception occurs.
      # @param data the Der input stream value, which contains one or more
      # marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional.
      # @return an instance of <code>HostAddresses</code>.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return HostAddresses.new(sub_der)
        end
      end
    }
    
    typesig { [CCacheOutputStream] }
    # Writes data field values in <code>HostAddresses</code> in FCC
    # format to a <code>CCacheOutputStream</code>.
    # 
    # @param cos a <code>CCacheOutputStream</code> to be written to.
    # @exception IOException if an I/O exception occurs.
    # @see sun.security.krb5.internal.ccache.CCacheOutputStream
    def write_addrs(cos)
      cos.write32(@addresses.attr_length)
      i = 0
      while i < @addresses.attr_length
        cos.write16(@addresses[i].attr_addr_type)
        cos.write32(@addresses[i].attr_address.attr_length)
        cos.write(@addresses[i].attr_address, 0, @addresses[i].attr_address.attr_length)
        i += 1
      end
    end
    
    typesig { [] }
    def get_inet_addresses
      if ((@addresses).nil? || (@addresses.attr_length).equal?(0))
        return nil
      end
      ip_addrs = ArrayList.new(@addresses.attr_length)
      i = 0
      while i < @addresses.attr_length
        begin
          if (((@addresses[i].attr_addr_type).equal?(Krb5::ADDRTYPE_INET)) || ((@addresses[i].attr_addr_type).equal?(Krb5::ADDRTYPE_INET6)))
            ip_addrs.add(@addresses[i].get_inet_address)
          end
        rescue Java::Net::UnknownHostException => e
          # Should not happen since IP address given
          return nil
        end
        i += 1
      end
      ret_val = Array.typed(InetAddress).new(ip_addrs.size) { nil }
      return ip_addrs.to_array(ret_val)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns all the IP addresses of the local host.
      def get_local_addresses
        hostname = nil
        inet_addresses = nil
        begin
          local_host = InetAddress.get_local_host
          hostname = RJava.cast_to_string(local_host.get_host_name)
          inet_addresses = InetAddress.get_all_by_name(hostname)
          h_addresses = Array.typed(HostAddress).new(inet_addresses.attr_length) { nil }
          i = 0
          while i < inet_addresses.attr_length
            h_addresses[i] = HostAddress.new(inet_addresses[i])
            i += 1
          end
          if (self.attr_debug)
            System.out.println(">>> KrbKdcReq local addresses for " + hostname + " are: ")
            i_ = 0
            while i_ < inet_addresses.attr_length
              System.out.println("\n\t" + RJava.cast_to_string(inet_addresses[i_]))
              if (inet_addresses[i_].is_a?(Inet4Address))
                System.out.println("IPv4 address")
              end
              if (inet_addresses[i_].is_a?(Inet6Address))
                System.out.println("IPv6 address")
              end
              i_ += 1
            end
          end
          return (HostAddresses.new(h_addresses))
        rescue JavaException => exc
          raise IOException.new(exc.to_s)
        end
      end
    }
    
    typesig { [Array.typed(InetAddress)] }
    # Creates a new HostAddresses instance from the supplied list
    # of InetAddresses.
    def initialize(inet_addresses)
      @addresses = nil
      @hash_code = 0
      if ((inet_addresses).nil?)
        @addresses = nil
        return
      end
      @addresses = Array.typed(HostAddress).new(inet_addresses.attr_length) { nil }
      i = 0
      while i < inet_addresses.attr_length
        @addresses[i] = HostAddress.new(inet_addresses[i])
        i += 1
      end
    end
    
    private
    alias_method :initialize__host_addresses, :initialize
  end
  
end

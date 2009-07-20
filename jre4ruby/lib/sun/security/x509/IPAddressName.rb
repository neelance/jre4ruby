require "rjava"

# Copyright 1997-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module IPAddressNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang, :JavaInteger
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Util, :BitArray
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
    }
  end
  
  # This class implements the IPAddressName as required by the GeneralNames
  # ASN.1 object.  Both IPv4 and IPv6 addresses are supported using the
  # formats specified in IETF PKIX RFC2459.
  # <p>
  # [RFC2459 4.2.1.7 Subject Alternative Name]
  # When the subjectAltName extension contains a iPAddress, the address
  # MUST be stored in the octet string in "network byte order," as
  # specified in RFC 791. The least significant bit (LSB) of
  # each octet is the LSB of the corresponding byte in the network
  # address. For IP Version 4, as specified in RFC 791, the octet string
  # MUST contain exactly four octets.  For IP Version 6, as specified in
  # RFC 1883, the octet string MUST contain exactly sixteen octets.
  # <p>
  # [RFC2459 4.2.1.11 Name Constraints]
  # The syntax of iPAddress MUST be as described in section 4.2.1.7 with
  # the following additions specifically for Name Constraints.  For IPv4
  # addresses, the ipAddress field of generalName MUST contain eight (8)
  # octets, encoded in the style of RFC 1519 (CIDR) to represent an
  # address range.[RFC 1519]  For IPv6 addresses, the ipAddress field
  # MUST contain 32 octets similarly encoded.  For example, a name
  # constraint for "class C" subnet 10.9.8.0 shall be represented as the
  # octets 0A 09 08 00 FF FF FF 00, representing the CIDR notation
  # 10.9.8.0/255.255.255.0.
  # <p>
  # @see GeneralName
  # @see GeneralNameInterface
  # @see GeneralNames
  # 
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class IPAddressName 
    include_class_members IPAddressNameImports
    include GeneralNameInterface
    
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    attr_accessor :is_ipv4
    alias_method :attr_is_ipv4, :is_ipv4
    undef_method :is_ipv4
    alias_method :attr_is_ipv4=, :is_ipv4=
    undef_method :is_ipv4=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [DerValue] }
    # Create the IPAddressName object from the passed encoded Der value.
    # 
    # @params derValue the encoded DER IPAddressName.
    # @exception IOException on error.
    def initialize(der_value)
      initialize__ipaddress_name(der_value.get_octet_string)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create the IPAddressName object with the specified octets.
    # 
    # @params address the IP address
    # @throws IOException if address is not a valid IPv4 or IPv6 address
    def initialize(address)
      @address = nil
      @is_ipv4 = false
      @name = nil
      # A valid address must consist of 4 bytes of address and
      # optional 4 bytes of 4 bytes of mask, or 16 bytes of address
      # and optional 16 bytes of mask.
      if ((address.attr_length).equal?(4) || (address.attr_length).equal?(8))
        @is_ipv4 = true
      else
        if ((address.attr_length).equal?(16) || (address.attr_length).equal?(32))
          @is_ipv4 = false
        else
          raise IOException.new("Invalid IPAddressName")
        end
      end
      @address = address
    end
    
    typesig { [String] }
    # Create an IPAddressName from a String.
    # [IETF RFC1338 Supernetting & IETF RFC1519 Classless Inter-Domain
    # Routing (CIDR)] For IPv4 addresses, the forms are
    # "b1.b2.b3.b4" or "b1.b2.b3.b4/m1.m2.m3.m4", where b1 - b4 are decimal
    # byte values 0-255 and m1 - m4 are decimal mask values
    # 0 - 255.
    # <p>
    # [IETF RFC2373 IP Version 6 Addressing Architecture]
    # For IPv6 addresses, the forms are "a1:a2:...:a8" or "a1:a2:...:a8/n",
    # where a1-a8 are hexadecimal values representing the eight 16-bit pieces
    # of the address. If /n is used, n is a decimal number indicating how many
    # of the leftmost contiguous bits of the address comprise the prefix for
    # this subnet. Internally, a mask value is created using the prefix length.
    # <p>
    # @param name String form of IPAddressName
    # @throws IOException if name can not be converted to a valid IPv4 or IPv6
    # address
    def initialize(name)
      @address = nil
      @is_ipv4 = false
      @name = nil
      if ((name).nil? || (name.length).equal?(0))
        raise IOException.new("IPAddress cannot be null or empty")
      end
      if ((name.char_at(name.length - 1)).equal?(Character.new(?/.ord)))
        raise IOException.new("Invalid IPAddress: " + name)
      end
      if (name.index_of(Character.new(?:.ord)) >= 0)
        # name is IPv6: uses colons as value separators
        # Parse name into byte-value address components and optional
        # prefix
        parse_ipv6(name)
        @is_ipv4 = false
      else
        if (name.index_of(Character.new(?..ord)) >= 0)
          # name is IPv4: uses dots as value separators
          parse_ipv4(name)
          @is_ipv4 = true
        else
          raise IOException.new("Invalid IPAddress: " + name)
        end
      end
    end
    
    typesig { [String] }
    # Parse an IPv4 address.
    # 
    # @param name IPv4 address with optional mask values
    # @throws IOException on error
    def parse_ipv4(name)
      # Parse name into byte-value address components
      slash_ndx = name.index_of(Character.new(?/.ord))
      if ((slash_ndx).equal?(-1))
        @address = InetAddress.get_by_name(name).get_address
      else
        @address = Array.typed(::Java::Byte).new(8) { 0 }
        # parse mask
        mask = InetAddress.get_by_name(name.substring(slash_ndx + 1)).get_address
        # parse base address
        host = InetAddress.get_by_name(name.substring(0, slash_ndx)).get_address
        System.arraycopy(host, 0, @address, 0, 4)
        System.arraycopy(mask, 0, @address, 4, 4)
      end
    end
    
    class_module.module_eval {
      # Parse an IPv6 address.
      # 
      # @param name String IPv6 address with optional /<prefix length>
      # If /<prefix length> is present, address[] array will
      # be 32 bytes long, otherwise 16.
      # @throws IOException on error
      const_set_lazy(:MASKSIZE) { 16 }
      const_attr_reader  :MASKSIZE
    }
    
    typesig { [String] }
    def parse_ipv6(name)
      slash_ndx = name.index_of(Character.new(?/.ord))
      if ((slash_ndx).equal?(-1))
        @address = InetAddress.get_by_name(name).get_address
      else
        @address = Array.typed(::Java::Byte).new(32) { 0 }
        base = InetAddress.get_by_name(name.substring(0, slash_ndx)).get_address
        System.arraycopy(base, 0, @address, 0, 16)
        # append a mask corresponding to the num of prefix bits specified
        prefix_len = JavaInteger.parse_int(name.substring(slash_ndx + 1))
        if (prefix_len > 128)
          raise IOException.new("IPv6Address prefix is longer than 128")
        end
        # create new bit array initialized to zeros
        bit_array = BitArray.new(MASKSIZE * 8)
        # set all most significant bits up to prefix length
        i = 0
        while i < prefix_len
          bit_array.set(i, true)
          i += 1
        end
        mask_array = bit_array.to_byte_array
        # copy mask bytes into mask portion of address
        i_ = 0
        while i_ < MASKSIZE
          @address[MASKSIZE + i_] = mask_array[i_]
          i_ += 1
        end
      end
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return NAME_IP
    end
    
    typesig { [DerOutputStream] }
    # Encode the IPAddress name into the DerOutputStream.
    # 
    # @params out the DER stream to encode the IPAddressName to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_octet_string(@address)
    end
    
    typesig { [] }
    # Return a printable string of IPaddress
    def to_s
      begin
        return "IPAddress: " + (get_name).to_s
      rescue IOException => ioe
        # dump out hex rep for debugging purposes
        enc = HexDumpEncoder.new
        return "IPAddress: " + (enc.encode_buffer(@address)).to_s
      end
    end
    
    typesig { [] }
    # Return a standard String representation of IPAddress.
    # See IPAddressName(String) for the formats used for IPv4
    # and IPv6 addresses.
    # 
    # @throws IOException if the IPAddress cannot be converted to a String
    def get_name
      if (!(@name).nil?)
        return @name
      end
      if (@is_ipv4)
        # IPv4 address or subdomain
        host = Array.typed(::Java::Byte).new(4) { 0 }
        System.arraycopy(@address, 0, host, 0, 4)
        @name = (InetAddress.get_by_address(host).get_host_address).to_s
        if ((@address.attr_length).equal?(8))
          mask = Array.typed(::Java::Byte).new(4) { 0 }
          System.arraycopy(@address, 4, mask, 0, 4)
          @name = @name + "/" + (InetAddress.get_by_address(mask).get_host_address).to_s
        end
      else
        # IPv6 address or subdomain
        host = Array.typed(::Java::Byte).new(16) { 0 }
        System.arraycopy(@address, 0, host, 0, 16)
        @name = (InetAddress.get_by_address(host).get_host_address).to_s
        if ((@address.attr_length).equal?(32))
          # IPv6 subdomain: display prefix length
          # copy subdomain into new array and convert to BitArray
          mask_bytes = Array.typed(::Java::Byte).new(16) { 0 }
          i = 16
          while i < 32
            mask_bytes[i - 16] = @address[i]
            i += 1
          end
          ba = BitArray.new(16 * 8, mask_bytes)
          # Find first zero bit
          i_ = 0
          while i_ < 16 * 8
            if (!ba.get(i_))
              break
            end
            i_ += 1
          end
          @name = @name + "/" + (i_).to_s
          # Verify remaining bits 0
          while i_ < 16 * 8
            if (ba.get(i_))
              raise IOException.new("Invalid IPv6 subdomain - set " + "bit " + (i_).to_s + " not contiguous")
            end
            i_ += 1
          end
        end
      end
      return @name
    end
    
    typesig { [] }
    # Returns this IPAddress name as a byte array.
    def get_bytes
      return @address.clone
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are identical.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(IPAddressName)))
        return false
      end
      other = (obj).get_bytes
      if (!(other.attr_length).equal?(@address.attr_length))
        return false
      end
      if ((@address.attr_length).equal?(8) || (@address.attr_length).equal?(32))
        # Two subnet addresses
        # Mask each and compare masked values
        mask_len = @address.attr_length / 2
        masked_this = Array.typed(::Java::Byte).new(mask_len) { 0 }
        masked_other = Array.typed(::Java::Byte).new(mask_len) { 0 }
        i = 0
        while i < mask_len
          masked_this[i] = (@address[i] & @address[i + mask_len])
          masked_other[i] = (other[i] & other[i + mask_len])
          if (!(masked_this[i]).equal?(masked_other[i]))
            return false
          end
          i += 1
        end
        # Now compare masks
        i_ = mask_len
        while i_ < @address.attr_length
          if (!(@address[i_]).equal?(other[i_]))
            return false
          end
          i_ += 1
        end
        return true
      else
        # Two IPv4 host addresses or two IPv6 host addresses
        # Compare bytes
        return (Arrays == other)
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      retval = 0
      i = 0
      while i < @address.attr_length
        retval += @address[i] * i
        i += 1
      end
      return retval
    end
    
    typesig { [GeneralNameInterface] }
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name
    # (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the naming
    # subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the naming
    # subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but
    # is same type.
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # <p>
    # [RFC2459] The syntax of iPAddress MUST be as described in section
    # 4.2.1.7 with the following additions specifically for Name Constraints.
    # For IPv4 addresses, the ipAddress field of generalName MUST contain
    # eight (8) octets, encoded in the style of RFC 1519 (CIDR) to represent an
    # address range.[RFC 1519]  For IPv6 addresses, the ipAddress field
    # MUST contain 32 octets similarly encoded.  For example, a name
    # constraint for "class C" subnet 10.9.8.0 shall be represented as the
    # octets 0A 09 08 00 FF FF FF 00, representing the CIDR notation
    # 10.9.8.0/255.255.255.0.
    # <p>
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is not exact match, but
    # narrowing and widening are not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_IP))
          constraint_type = NAME_DIFF_TYPE
        else
          if (((input_name) == self))
            constraint_type = NAME_MATCH
          else
            other_address = (input_name).get_bytes
            if ((other_address.attr_length).equal?(4) && (@address.attr_length).equal?(4))
              # Two host addresses
              constraint_type = NAME_SAME_TYPE
            else
              if (((other_address.attr_length).equal?(8) && (@address.attr_length).equal?(8)) || ((other_address.attr_length).equal?(32) && (@address.attr_length).equal?(32)))
                # Two subnet addresses
                # See if one address fully encloses the other address
                other_subset_of_this = true
                this_subset_of_other = true
                this_empty = false
                other_empty = false
                mask_offset = @address.attr_length / 2
                i = 0
                while i < mask_offset
                  if (!((@address[i] & @address[i + mask_offset])).equal?(@address[i]))
                    this_empty = true
                  end
                  if (!((other_address[i] & other_address[i + mask_offset])).equal?(other_address[i]))
                    other_empty = true
                  end
                  if (!((((@address[i + mask_offset] & other_address[i + mask_offset])).equal?(@address[i + mask_offset])) && (((@address[i] & @address[i + mask_offset])).equal?((other_address[i] & @address[i + mask_offset])))))
                    other_subset_of_this = false
                  end
                  if (!((((other_address[i + mask_offset] & @address[i + mask_offset])).equal?(other_address[i + mask_offset])) && (((other_address[i] & other_address[i + mask_offset])).equal?((@address[i] & other_address[i + mask_offset])))))
                    this_subset_of_other = false
                  end
                  i += 1
                end
                if (this_empty || other_empty)
                  if (this_empty && other_empty)
                    constraint_type = NAME_MATCH
                  else
                    if (this_empty)
                      constraint_type = NAME_WIDENS
                    else
                      constraint_type = NAME_NARROWS
                    end
                  end
                else
                  if (other_subset_of_this)
                    constraint_type = NAME_NARROWS
                  else
                    if (this_subset_of_other)
                      constraint_type = NAME_WIDENS
                    else
                      constraint_type = NAME_SAME_TYPE
                    end
                  end
                end
              else
                if ((other_address.attr_length).equal?(8) || (other_address.attr_length).equal?(32))
                  # Other is a subnet, this is a host address
                  i = 0
                  mask_offset = other_address.attr_length / 2
                  while i < mask_offset
                    # Mask this address by other address mask and compare to other address
                    # If all match, then this address is in other address subnet
                    if (!((@address[i] & other_address[i + mask_offset])).equal?(other_address[i]))
                      break
                    end
                    i += 1
                  end
                  if ((i).equal?(mask_offset))
                    constraint_type = NAME_WIDENS
                  else
                    constraint_type = NAME_SAME_TYPE
                  end
                else
                  if ((@address.attr_length).equal?(8) || (@address.attr_length).equal?(32))
                    # This is a subnet, other is a host address
                    i = 0
                    mask_offset = @address.attr_length / 2
                    while i < mask_offset
                      # Mask other address by this address mask and compare to this address
                      if (!((other_address[i] & @address[i + mask_offset])).equal?(@address[i]))
                        break
                      end
                      i += 1
                    end
                    if ((i).equal?(mask_offset))
                      constraint_type = NAME_NARROWS
                    else
                      constraint_type = NAME_SAME_TYPE
                    end
                  else
                    constraint_type = NAME_SAME_TYPE
                  end
                end
              end
            end
          end
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      raise UnsupportedOperationException.new("subtreeDepth() not defined for IPAddressName")
    end
    
    private
    alias_method :initialize__ipaddress_name, :initialize
  end
  
end

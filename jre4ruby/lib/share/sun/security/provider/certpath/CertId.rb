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
module Sun::Security::Provider::Certpath
  module CertIdImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::X509
      include ::Sun::Security::Util
    }
  end
  
  # This class corresponds to the CertId field in OCSP Request
  # and the OCSP Response. The ASN.1 definition for CertID is defined
  # in RFC 2560 as:
  # <pre>
  # 
  # CertID          ::=     SEQUENCE {
  # hashAlgorithm       AlgorithmIdentifier,
  # issuerNameHash      OCTET STRING, -- Hash of Issuer's DN
  # issuerKeyHash       OCTET STRING, -- Hash of Issuers public key
  # serialNumber        CertificateSerialNumber
  # }
  # 
  # </pre>
  # 
  # @author      Ram Marti
  class CertId 
    include_class_members CertIdImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
    }
    
    attr_accessor :hash_alg_id
    alias_method :attr_hash_alg_id, :hash_alg_id
    undef_method :hash_alg_id
    alias_method :attr_hash_alg_id=, :hash_alg_id=
    undef_method :hash_alg_id=
    
    attr_accessor :issuer_name_hash
    alias_method :attr_issuer_name_hash, :issuer_name_hash
    undef_method :issuer_name_hash
    alias_method :attr_issuer_name_hash=, :issuer_name_hash=
    undef_method :issuer_name_hash=
    
    attr_accessor :issuer_key_hash
    alias_method :attr_issuer_key_hash, :issuer_key_hash
    undef_method :issuer_key_hash
    alias_method :attr_issuer_key_hash=, :issuer_key_hash=
    undef_method :issuer_key_hash=
    
    attr_accessor :cert_serial_number
    alias_method :attr_cert_serial_number, :cert_serial_number
    undef_method :cert_serial_number
    alias_method :attr_cert_serial_number=, :cert_serial_number=
    undef_method :cert_serial_number=
    
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [X509CertImpl, SerialNumber] }
    # hashcode for this CertId
    # 
    # Creates a CertId. The hash algorithm used is SHA-1.
    def initialize(issuer_cert, serial_number)
      @hash_alg_id = nil
      @issuer_name_hash = nil
      @issuer_key_hash = nil
      @cert_serial_number = nil
      @myhash = -1
      # compute issuerNameHash
      md = MessageDigest.get_instance("SHA1")
      @hash_alg_id = AlgorithmId.get("SHA1")
      md.update(issuer_cert.get_subject_x500principal.get_encoded)
      @issuer_name_hash = md.digest
      # compute issuerKeyHash (remove the tag and length)
      pub_key = issuer_cert.get_public_key.get_encoded
      val = DerValue.new(pub_key)
      seq = Array.typed(DerValue).new(2) { nil }
      seq[0] = val.attr_data.get_der_value # AlgorithmID
      seq[1] = val.attr_data.get_der_value # Key
      key_bytes = seq[1].get_bit_string
      md.update(key_bytes)
      @issuer_key_hash = md.digest
      @cert_serial_number = serial_number
      if (Debug)
        encoder = HexDumpEncoder.new
        System.out.println("Issuer Certificate is " + RJava.cast_to_string(issuer_cert))
        System.out.println("issuerNameHash is " + RJava.cast_to_string(encoder.encode(@issuer_name_hash)))
        System.out.println("issuerKeyHash is " + RJava.cast_to_string(encoder.encode(@issuer_key_hash)))
      end
    end
    
    typesig { [DerInputStream] }
    # Creates a CertId from its ASN.1 DER encoding.
    def initialize(der_in)
      @hash_alg_id = nil
      @issuer_name_hash = nil
      @issuer_key_hash = nil
      @cert_serial_number = nil
      @myhash = -1
      @hash_alg_id = AlgorithmId.parse(der_in.get_der_value)
      @issuer_name_hash = der_in.get_octet_string
      @issuer_key_hash = der_in.get_octet_string
      @cert_serial_number = SerialNumber.new(der_in)
    end
    
    typesig { [] }
    # Return the hash algorithm identifier.
    def get_hash_algorithm
      return @hash_alg_id
    end
    
    typesig { [] }
    # Return the hash value for the issuer name.
    def get_issuer_name_hash
      return @issuer_name_hash
    end
    
    typesig { [] }
    # Return the hash value for the issuer key.
    def get_issuer_key_hash
      return @issuer_key_hash
    end
    
    typesig { [] }
    # Return the serial number.
    def get_serial_number
      return @cert_serial_number.get_number
    end
    
    typesig { [DerOutputStream] }
    # Encode the CertId using ASN.1 DER.
    # The hash algorithm used is SHA-1.
    def encode(out)
      tmp = DerOutputStream.new
      @hash_alg_id.encode(tmp)
      tmp.put_octet_string(@issuer_name_hash)
      tmp.put_octet_string(@issuer_key_hash)
      @cert_serial_number.encode(tmp)
      out.write(DerValue.attr_tag_sequence, tmp)
      if (Debug)
        encoder = HexDumpEncoder.new
        System.out.println("Encoded certId is " + RJava.cast_to_string(encoder.encode(out.to_byte_array)))
      end
    end
    
    typesig { [] }
    # Returns a hashcode value for this CertId.
    # 
    # @return the hashcode value.
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = @hash_alg_id.hash_code
        i = 0
        while i < @issuer_name_hash.attr_length
          @myhash += @issuer_name_hash[i] * i
          i += 1
        end
        i_ = 0
        while i_ < @issuer_key_hash.attr_length
          @myhash += @issuer_key_hash[i_] * i_
          i_ += 1
        end
        @myhash += @cert_serial_number.get_number.hash_code
      end
      return @myhash
    end
    
    typesig { [Object] }
    # Compares this CertId for equality with the specified
    # object. Two CertId objects are considered equal if their hash algorithms,
    # their issuer name and issuer key hash values and their serial numbers
    # are equal.
    # 
    # @param other the object to test for equality with this object.
    # @return true if the objects are considered equal, false otherwise.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if ((other).nil? || (!(other.is_a?(CertId))))
        return false
      end
      that = other
      if ((@hash_alg_id == that.get_hash_algorithm) && (Arrays == @issuer_name_hash) && (Arrays == @issuer_key_hash) && (@cert_serial_number.get_number == that.get_serial_number))
        return true
      else
        return false
      end
    end
    
    typesig { [] }
    # Create a string representation of the CertId.
    def to_s
      sb = StringBuilder.new
      sb.append("CertId \n")
      sb.append("Algorithm: " + RJava.cast_to_string(@hash_alg_id.to_s) + "\n")
      sb.append("issuerNameHash \n")
      encoder = HexDumpEncoder.new
      sb.append(encoder.encode(@issuer_name_hash))
      sb.append("\nissuerKeyHash: \n")
      sb.append(encoder.encode(@issuer_key_hash))
      sb.append("\n" + RJava.cast_to_string(@cert_serial_number.to_s))
      return sb.to_s
    end
    
    private
    alias_method :initialize__cert_id, :initialize
  end
  
end

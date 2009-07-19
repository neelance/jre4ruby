require "rjava"

# Copyright 1998-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs
  module EncryptedPrivateKeyInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include ::Java::Io
      include ::Sun::Security::X509
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # This class implements the <code>EncryptedPrivateKeyInfo</code> type,
  # which is defined in PKCS #8 as follows:
  # 
  # <pre>
  # EncryptedPrivateKeyInfo ::=  SEQUENCE {
  # encryptionAlgorithm   AlgorithmIdentifier,
  # encryptedData   OCTET STRING }
  # </pre>
  # 
  # @author Jan Luehe
  class EncryptedPrivateKeyInfo 
    include_class_members EncryptedPrivateKeyInfoImports
    
    # the "encryptionAlgorithm" field
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    # the "encryptedData" field
    attr_accessor :encrypted_data
    alias_method :attr_encrypted_data, :encrypted_data
    undef_method :encrypted_data
    alias_method :attr_encrypted_data=, :encrypted_data=
    undef_method :encrypted_data=
    
    # the ASN.1 encoded contents of this class
    attr_accessor :encoded
    alias_method :attr_encoded, :encoded
    undef_method :encoded
    alias_method :attr_encoded=, :encoded=
    undef_method :encoded=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs (i.e., parses) an <code>EncryptedPrivateKeyInfo</code> from
    # its encoding.
    def initialize(encoded)
      @algid = nil
      @encrypted_data = nil
      @encoded = nil
      if ((encoded).nil?)
        raise IllegalArgumentException.new("encoding must not be null")
      end
      val = DerValue.new(encoded)
      seq = Array.typed(DerValue).new(2) { nil }
      seq[0] = val.attr_data.get_der_value
      seq[1] = val.attr_data.get_der_value
      if (!(val.attr_data.available).equal?(0))
        raise IOException.new("overrun, bytes = " + (val.attr_data.available).to_s)
      end
      @algid = AlgorithmId.parse(seq[0])
      if (!(seq[0].attr_data.available).equal?(0))
        raise IOException.new("encryptionAlgorithm field overrun")
      end
      @encrypted_data = seq[1].get_octet_string
      if (!(seq[1].attr_data.available).equal?(0))
        raise IOException.new("encryptedData field overrun")
      end
      @encoded = encoded.clone
    end
    
    typesig { [AlgorithmId, Array.typed(::Java::Byte)] }
    # Constructs an <code>EncryptedPrivateKeyInfo</code> from the
    # encryption algorithm and the encrypted data.
    def initialize(algid, encrypted_data)
      @algid = nil
      @encrypted_data = nil
      @encoded = nil
      @algid = algid
      @encrypted_data = encrypted_data.clone
    end
    
    typesig { [] }
    # Returns the encryption algorithm.
    def get_algorithm
      return @algid
    end
    
    typesig { [] }
    # Returns the encrypted data.
    def get_encrypted_data
      return @encrypted_data.clone
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding of this class.
    def get_encoded
      if (!(@encoded).nil?)
        return @encoded.clone
      end
      out = DerOutputStream.new
      tmp = DerOutputStream.new
      # encode encryption algorithm
      @algid.encode(tmp)
      # encode encrypted data
      tmp.put_octet_string(@encrypted_data)
      # wrap everything into a SEQUENCE
      out.write(DerValue.attr_tag_sequence, tmp)
      @encoded = out.to_byte_array
      return @encoded.clone
    end
    
    typesig { [Object] }
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(EncryptedPrivateKeyInfo)))
        return false
      end
      begin
        this_encr_info = self.get_encoded
        other_encr_info = (other).get_encoded
        if (!(this_encr_info.attr_length).equal?(other_encr_info.attr_length))
          return false
        end
        i = 0
        while i < this_encr_info.attr_length
          if (!(this_encr_info[i]).equal?(other_encr_info[i]))
            return false
          end
          ((i += 1) - 1)
        end
        return true
      rescue IOException => e
        return false
      end
    end
    
    typesig { [] }
    # Returns a hashcode for this EncryptedPrivateKeyInfo.
    # 
    # @return a hashcode for this EncryptedPrivateKeyInfo.
    def hash_code
      retval = 0
      i = 0
      while i < @encrypted_data.attr_length
        retval += @encrypted_data[i] * i
        ((i += 1) - 1)
      end
      return retval
    end
    
    private
    alias_method :initialize__encrypted_private_key_info, :initialize
  end
  
end

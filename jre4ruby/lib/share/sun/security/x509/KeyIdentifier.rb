require "rjava"

# Copyright 1997-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KeyIdentifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::Util
    }
  end
  
  # Represent the Key Identifier ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class KeyIdentifier 
    include_class_members KeyIdentifierImports
    
    attr_accessor :octet_string
    alias_method :attr_octet_string, :octet_string
    undef_method :octet_string
    alias_method :attr_octet_string=, :octet_string=
    undef_method :octet_string=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a KeyIdentifier with the passed bit settings.
    # 
    # @param octetString the octet string identifying the key identifier.
    def initialize(octet_string)
      @octet_string = nil
      @octet_string = octet_string.clone
    end
    
    typesig { [DerValue] }
    # Create a KeyIdentifier from the DER encoded value.
    # 
    # @param val the DerValue
    def initialize(val)
      @octet_string = nil
      @octet_string = val.get_octet_string
    end
    
    typesig { [PublicKey] }
    # Creates a KeyIdentifier from a public-key value.
    # 
    # <p>From RFC2459: Two common methods for generating key identifiers from
    # the public key are:
    # <ol>
    # <li>The keyIdentifier is composed of the 160-bit SHA-1 hash of the
    # value of the BIT STRING subjectPublicKey (excluding the tag,
    # length, and number of unused bits).
    # <p>
    # <li>The keyIdentifier is composed of a four bit type field with
    # the value 0100 followed by the least significant 60 bits of the
    # SHA-1 hash of the value of the BIT STRING subjectPublicKey.
    # </ol>
    # <p>This method supports method 1.
    # 
    # @param pubKey the public key from which to construct this KeyIdentifier
    # @throws IOException on parsing errors
    def initialize(pub_key)
      @octet_string = nil
      alg_and_key = DerValue.new(pub_key.get_encoded)
      if (!(alg_and_key.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("PublicKey value is not a valid " + "X.509 public key")
      end
      algid = AlgorithmId.parse(alg_and_key.attr_data.get_der_value)
      key = alg_and_key.attr_data.get_unaligned_bit_string.to_byte_array
      md = nil
      begin
        md = MessageDigest.get_instance("SHA1")
      rescue NoSuchAlgorithmException => e3
        raise IOException.new("SHA1 not supported")
      end
      md.update(key)
      @octet_string = md.digest
    end
    
    typesig { [] }
    # Return the value of the KeyIdentifier as byte array.
    def get_identifier
      return @octet_string.clone
    end
    
    typesig { [] }
    # Returns a printable representation of the KeyUsage.
    def to_s
      s = "KeyIdentifier [\n"
      encoder = HexDumpEncoder.new
      s += RJava.cast_to_string(encoder.encode_buffer(@octet_string))
      s += "]\n"
      return (s)
    end
    
    typesig { [DerOutputStream] }
    # Write the KeyIdentifier to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the object to.
    # @exception IOException
    def encode(out)
      out.put_octet_string(@octet_string)
    end
    
    typesig { [] }
    # Returns a hash code value for this object.
    # Objects that are equal will also have the same hashcode.
    def hash_code
      retval = 0
      i = 0
      while i < @octet_string.attr_length
        retval += @octet_string[i] * i
        i += 1
      end
      return retval
    end
    
    typesig { [Object] }
    # Indicates whether some other object is "equal to" this one.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(KeyIdentifier)))
        return false
      end
      return Java::Util::Arrays.==(@octet_string, (other).get_identifier)
    end
    
    private
    alias_method :initialize__key_identifier, :initialize
  end
  
end

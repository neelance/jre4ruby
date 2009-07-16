require "rjava"

# 
# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509KeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Io
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Properties
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :KeyFactory
      include_const ::Java::Security, :KeyRep
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security::Spec, :InvalidKeySpecException
      include_const ::Java::Security::Spec, :X509EncodedKeySpec
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::Util
    }
  end
  
  # 
  # Holds an X.509 key, for example a public key found in an X.509
  # certificate.  Includes a description of the algorithm to be used
  # with the key; these keys normally are used as
  # "SubjectPublicKeyInfo".
  # 
  # <P>While this class can represent any kind of X.509 key, it may be
  # desirable to provide subclasses which understand how to parse keying
  # data.   For example, RSA public keys have two members, one for the
  # public modulus and one for the prime exponent.  If such a class is
  # provided, it is used when parsing X.509 keys.  If one is not provided,
  # the key still parses correctly.
  # 
  # @author David Brownell
  class X509Key 
    include_class_members X509KeyImports
    include PublicKey
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -5359250853002055002 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The algorithm information (name, parameters, etc).
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    # 
    # The key bytes, without the algorithm information.
    # @deprecated Use the BitArray form which does not require keys to
    # be byte aligned.
    # @see sun.security.x509.X509Key#setKey(BitArray)
    # @see sun.security.x509.X509Key#getKey()
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    # 
    # The number of bits unused in the last byte of the key.
    # Added to keep the byte[] key form consistent with the BitArray
    # form. Can de deleted when byte[] key is deleted.
    attr_accessor :unused_bits
    alias_method :attr_unused_bits, :unused_bits
    undef_method :unused_bits
    alias_method :attr_unused_bits=, :unused_bits=
    undef_method :unused_bits=
    
    # BitArray form of key
    attr_accessor :bit_string_key
    alias_method :attr_bit_string_key, :bit_string_key
    undef_method :bit_string_key
    alias_method :attr_bit_string_key=, :bit_string_key=
    undef_method :bit_string_key=
    
    # The encoding for the key.
    attr_accessor :encoded_key
    alias_method :attr_encoded_key, :encoded_key
    undef_method :encoded_key
    alias_method :attr_encoded_key=, :encoded_key=
    undef_method :encoded_key=
    
    typesig { [] }
    # 
    # Default constructor.  The key constructed must have its key
    # and algorithm initialized before it may be used, for example
    # by using <code>decode</code>.
    def initialize
      @algid = nil
      @key = nil
      @unused_bits = 0
      @bit_string_key = nil
      @encoded_key = nil
    end
    
    typesig { [AlgorithmId, BitArray] }
    # 
    # Build and initialize as a "default" key.  All X.509 key
    # data is stored and transmitted losslessly, but no knowledge
    # about this particular algorithm is available.
    def initialize(algid, key)
      @algid = nil
      @key = nil
      @unused_bits = 0
      @bit_string_key = nil
      @encoded_key = nil
      @algid = algid
      set_key(key)
      encode
    end
    
    typesig { [BitArray] }
    # 
    # Sets the key in the BitArray form.
    def set_key(key)
      @bit_string_key = key.clone
      # 
      # Do this to keep the byte array form consistent with
      # this. Can delete when byte[] key is deleted.
      @key = key.to_byte_array
      remaining = key.length % 8
      @unused_bits = (((remaining).equal?(0)) ? 0 : 8 - remaining)
    end
    
    typesig { [] }
    # 
    # Gets the key. The key may or may not be byte aligned.
    # @return a BitArray containing the key.
    def get_key
      # 
      # Do this for consistency in case a subclass
      # modifies byte[] key directly. Remove when
      # byte[] key is deleted.
      # Note: the consistency checks fail when the subclass
      # modifies a non byte-aligned key (into a byte-aligned key)
      # using the deprecated byte[] key field.
      @bit_string_key = BitArray.new(@key.attr_length * 8 - @unused_bits, @key)
      return @bit_string_key.clone
    end
    
    class_module.module_eval {
      typesig { [DerValue] }
      # 
      # Construct X.509 subject public key from a DER value.  If
      # the runtime environment is configured with a specific class for
      # this kind of key, a subclass is returned.  Otherwise, a generic
      # X509Key object is returned.
      # 
      # <P>This mechanism gurantees that keys (and algorithms) may be
      # freely manipulated and transferred, without risk of losing
      # information.  Also, when a key (or algorithm) needs some special
      # handling, that specific need can be accomodated.
      # 
      # @param in the DER-encoded SubjectPublicKeyInfo value
      # @exception IOException on data format errors
      def parse(in_)
        algorithm = nil
        subject_key = nil
        if (!(in_.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("corrupt subject key")
        end
        algorithm = AlgorithmId.parse(in_.attr_data.get_der_value)
        begin
          subject_key = build_x509key(algorithm, in_.attr_data.get_unaligned_bit_string)
        rescue InvalidKeyException => e
          raise IOException.new("subject key, " + (e.get_message).to_s)
        end
        if (!(in_.attr_data.available).equal?(0))
          raise IOException.new("excess subject key")
        end
        return subject_key
      end
    }
    
    typesig { [] }
    # 
    # Parse the key bits.  This may be redefined by subclasses to take
    # advantage of structure within the key.  For example, RSA public
    # keys encapsulate two unsigned integers (modulus and exponent) as
    # DER values within the <code>key</code> bits; Diffie-Hellman and
    # DSS/DSA keys encapsulate a single unsigned integer.
    # 
    # <P>This function is called when creating X.509 SubjectPublicKeyInfo
    # values using the X509Key member functions, such as <code>parse</code>
    # and <code>decode</code>.
    # 
    # @exception IOException on parsing errors.
    # @exception InvalidKeyException on invalid key encodings.
    def parse_key_bits
      encode
    end
    
    class_module.module_eval {
      typesig { [AlgorithmId, BitArray] }
      # 
      # Factory interface, building the kind of key associated with this
      # specific algorithm ID or else returning this generic base class.
      # See the description above.
      def build_x509key(algid, key)
        # 
        # Use the algid and key parameters to produce the ASN.1 encoding
        # of the key, which will then be used as the input to the
        # key factory.
        x509encoded_key_stream = DerOutputStream.new
        encode(x509encoded_key_stream, algid, key)
        x509key_spec = X509EncodedKeySpec.new(x509encoded_key_stream.to_byte_array)
        begin
          # Instantiate the key factory of the appropriate algorithm
          key_fac = KeyFactory.get_instance(algid.get_name)
          # Generate the public key
          return key_fac.generate_public(x509key_spec)
        rescue NoSuchAlgorithmException => e
          # Return generic X509Key with opaque key data (see below)
        rescue InvalidKeySpecException => e
          raise InvalidKeyException.new(e_.get_message)
        end
        # 
        # Try again using JDK1.1-style for backwards compatibility.
        classname = ""
        begin
          props = nil
          keytype = nil
          sun_provider = nil
          sun_provider = Security.get_provider("SUN")
          if ((sun_provider).nil?)
            raise InstantiationException.new
          end
          classname = (sun_provider.get_property("PublicKey.X.509." + (algid.get_name).to_s)).to_s
          if ((classname).nil?)
            raise InstantiationException.new
          end
          key_class = nil
          begin
            key_class = Class.for_name(classname)
          rescue ClassNotFoundException => e
            cl = ClassLoader.get_system_class_loader
            if (!(cl).nil?)
              key_class = cl.load_class(classname)
            end
          end
          inst = nil
          result = nil
          if (!(key_class).nil?)
            inst = key_class.new_instance
          end
          if (inst.is_a?(X509Key))
            result = inst
            result.attr_algid = algid
            result.set_key(key)
            result.parse_key_bits
            return result
          end
        rescue ClassNotFoundException => e
        rescue InstantiationException => e
        rescue IllegalAccessException => e
          # this should not happen.
          raise IOException.new(classname + " [internal error]")
        end
        result_ = X509Key.new(algid, key)
        return result_
      end
    }
    
    typesig { [] }
    # 
    # Returns the algorithm to be used with this key.
    def get_algorithm
      return @algid.get_name
    end
    
    typesig { [] }
    # 
    # Returns the algorithm ID to be used with this key.
    def get_algorithm_id
      return @algid
    end
    
    typesig { [DerOutputStream] }
    # 
    # Encode SubjectPublicKeyInfo sequence on the DER output stream.
    # 
    # @exception IOException on encoding errors.
    def encode(out)
      encode(out, @algid, get_key)
    end
    
    typesig { [] }
    # 
    # Returns the DER-encoded form of the key as a byte array.
    def get_encoded
      begin
        return get_encoded_internal.clone
      rescue InvalidKeyException => e
        # XXX
      end
      return nil
    end
    
    typesig { [] }
    def get_encoded_internal
      encoded = @encoded_key
      if ((encoded).nil?)
        begin
          out = DerOutputStream.new
          encode(out)
          encoded = out.to_byte_array
        rescue IOException => e
          raise InvalidKeyException.new("IOException : " + (e.get_message).to_s)
        end
        @encoded_key = encoded
      end
      return encoded
    end
    
    typesig { [] }
    # 
    # Returns the format for this key: "X.509"
    def get_format
      return "X.509"
    end
    
    typesig { [] }
    # 
    # Returns the DER-encoded form of the key as a byte array.
    # 
    # @exception InvalidKeyException on encoding errors.
    def encode
      return get_encoded_internal.clone
    end
    
    typesig { [] }
    # 
    # Returns a printable representation of the key
    def to_s
      encoder = HexDumpEncoder.new
      return "algorithm = " + (@algid.to_s).to_s + ", unparsed keybits = \n" + (encoder.encode_buffer(@key)).to_s
    end
    
    typesig { [InputStream] }
    # 
    # Initialize an X509Key object from an input stream.  The data on that
    # input stream must be encoded using DER, obeying the X.509
    # <code>SubjectPublicKeyInfo</code> format.  That is, the data is a
    # sequence consisting of an algorithm ID and a bit string which holds
    # the key.  (That bit string is often used to encapsulate another DER
    # encoded sequence.)
    # 
    # <P>Subclasses should not normally redefine this method; they should
    # instead provide a <code>parseKeyBits</code> method to parse any
    # fields inside the <code>key</code> member.
    # 
    # <P>The exception to this rule is that since private keys need not
    # be encoded using the X.509 <code>SubjectPublicKeyInfo</code> format,
    # private keys may override this method, <code>encode</code>, and
    # of course <code>getFormat</code>.
    # 
    # @param in an input stream with a DER-encoded X.509
    # SubjectPublicKeyInfo value
    # @exception InvalidKeyException on parsing errors.
    def decode(in_)
      val = nil
      begin
        val = DerValue.new(in_)
        if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise InvalidKeyException.new("invalid key format")
        end
        @algid = AlgorithmId.parse(val.attr_data.get_der_value)
        set_key(val.attr_data.get_unaligned_bit_string)
        parse_key_bits
        if (!(val.attr_data.available).equal?(0))
          raise InvalidKeyException.new("excess key data")
        end
      rescue IOException => e
        # e.printStackTrace ();
        raise InvalidKeyException.new("IOException: " + (e.get_message).to_s)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def decode(encoded_key)
      decode(ByteArrayInputStream.new(encoded_key))
    end
    
    typesig { [ObjectOutputStream] }
    # 
    # Serialization write ... X.509 keys serialize as
    # themselves, and they're parsed when they get read back.
    def write_object(stream)
      stream.write(get_encoded)
    end
    
    typesig { [ObjectInputStream] }
    # 
    # Serialization read ... X.509 keys serialize as
    # themselves, and they're parsed when they get read back.
    def read_object(stream)
      begin
        decode(stream)
      rescue InvalidKeyException => e
        e.print_stack_trace
        raise IOException.new("deserialized key is invalid: " + (e.get_message).to_s)
      end
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(Key)).equal?(false))
        return false
      end
      begin
        this_encoded = self.get_encoded_internal
        other_encoded = nil
        if (obj.is_a?(X509Key))
          other_encoded = (obj).get_encoded_internal
        else
          other_encoded = (obj).get_encoded
        end
        return (Arrays == this_encoded)
      rescue InvalidKeyException => e
        return false
      end
    end
    
    typesig { [] }
    # 
    # Calculates a hash code value for the object. Objects
    # which are equal will also have the same hashcode.
    def hash_code
      begin
        b1 = get_encoded_internal
        r = b1.attr_length
        i = 0
        while i < b1.attr_length
          r += (b1[i] & 0xff) * 37
          ((i += 1) - 1)
        end
        return r
      rescue InvalidKeyException => e
        # should not happen
        return 0
      end
    end
    
    class_module.module_eval {
      typesig { [DerOutputStream, AlgorithmId, BitArray] }
      # 
      # Produce SubjectPublicKey encoding from algorithm id and key material.
      def encode(out, algid, key)
        tmp = DerOutputStream.new
        algid.encode(tmp)
        tmp.put_unaligned_bit_string(key)
        out.write(DerValue.attr_tag_sequence, tmp)
      end
    }
    
    private
    alias_method :initialize__x509key, :initialize
  end
  
end

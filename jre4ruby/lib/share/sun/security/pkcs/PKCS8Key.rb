require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKCS8KeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include ::Java::Io
      include_const ::Java::Util, :Properties
      include ::Java::Math
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :KeyRep
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :KeyFactory
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security::Spec, :InvalidKeySpecException
      include_const ::Java::Security::Spec, :PKCS8EncodedKeySpec
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::X509
      include ::Sun::Security::Util
    }
  end
  
  # Holds a PKCS#8 key, for example a private key
  # 
  # @author Dave Brownell
  # @author Benjamin Renaud
  class PKCS8Key 
    include_class_members PKCS8KeyImports
    include PrivateKey
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -3836890099307167124 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The algorithm information (name, parameters, etc).
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    # The key bytes, without the algorithm information
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    # The encoded for the key.
    attr_accessor :encoded_key
    alias_method :attr_encoded_key, :encoded_key
    undef_method :encoded_key
    alias_method :attr_encoded_key=, :encoded_key=
    undef_method :encoded_key=
    
    class_module.module_eval {
      # The version for this key
      const_set_lazy(:Version) { BigInteger::ZERO }
      const_attr_reader  :Version
    }
    
    typesig { [] }
    # Default constructor.  The key constructed must have its key
    # and algorithm initialized before it may be used, for example
    # by using <code>decode</code>.
    def initialize
      @algid = nil
      @key = nil
      @encoded_key = nil
    end
    
    typesig { [AlgorithmId, Array.typed(::Java::Byte)] }
    # Build and initialize as a "default" key.  All PKCS#8 key
    # data is stored and transmitted losslessly, but no knowledge
    # about this particular algorithm is available.
    def initialize(algid, key)
      @algid = nil
      @key = nil
      @encoded_key = nil
      @algid = algid
      @key = key
      encode
    end
    
    class_module.module_eval {
      typesig { [DerValue] }
      # Binary backwards compatibility. New uses should call parseKey().
      def parse(in_)
        key = nil
        key = parse_key(in_)
        if (key.is_a?(PKCS8Key))
          return key
        end
        raise IOException.new("Provider did not return PKCS8Key")
      end
      
      typesig { [DerValue] }
      # Construct PKCS#8 subject public key from a DER value.  If
      # the runtime environment is configured with a specific class for
      # this kind of key, a subclass is returned.  Otherwise, a generic
      # PKCS8Key object is returned.
      # 
      # <P>This mechanism gurantees that keys (and algorithms) may be
      # freely manipulated and transferred, without risk of losing
      # information.  Also, when a key (or algorithm) needs some special
      # handling, that specific need can be accomodated.
      # 
      # @param in the DER-encoded SubjectPublicKeyInfo value
      # @exception IOException on data format errors
      def parse_key(in_)
        algorithm = nil
        priv_key = nil
        if (!(in_.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("corrupt private key")
        end
        parsed_version = in_.attr_data.get_big_integer
        if (!(Version == parsed_version))
          raise IOException.new("version mismatch: (supported: " + RJava.cast_to_string(Debug.to_hex_string(Version)) + ", parsed: " + RJava.cast_to_string(Debug.to_hex_string(parsed_version)))
        end
        algorithm = AlgorithmId.parse(in_.attr_data.get_der_value)
        begin
          priv_key = build_pkcs8key(algorithm, in_.attr_data.get_octet_string)
        rescue InvalidKeyException => e
          raise IOException.new("corrupt private key")
        end
        if (!(in_.attr_data.available).equal?(0))
          raise IOException.new("excess private key")
        end
        return priv_key
      end
    }
    
    typesig { [] }
    # Parse the key bits.  This may be redefined by subclasses to take
    # advantage of structure within the key.  For example, RSA public
    # keys encapsulate two unsigned integers (modulus and exponent) as
    # DER values within the <code>key</code> bits; Diffie-Hellman and
    # DSS/DSA keys encapsulate a single unsigned integer.
    # 
    # <P>This function is called when creating PKCS#8 SubjectPublicKeyInfo
    # values using the PKCS8Key member functions, such as <code>parse</code>
    # and <code>decode</code>.
    # 
    # @exception IOException if a parsing error occurs.
    # @exception InvalidKeyException if the key encoding is invalid.
    def parse_key_bits
      encode
    end
    
    class_module.module_eval {
      typesig { [AlgorithmId, Array.typed(::Java::Byte)] }
      # Factory interface, building the kind of key associated with this
      # specific algorithm ID or else returning this generic base class.
      # See the description above.
      def build_pkcs8key(algid, key)
        # Use the algid and key parameters to produce the ASN.1 encoding
        # of the key, which will then be used as the input to the
        # key factory.
        pkcs8encoded_key_stream = DerOutputStream.new
        encode(pkcs8encoded_key_stream, algid, key)
        pkcs8key_spec = PKCS8EncodedKeySpec.new(pkcs8encoded_key_stream.to_byte_array)
        begin
          # Instantiate the key factory of the appropriate algorithm
          key_fac = KeyFactory.get_instance(algid.get_name)
          # Generate the private key
          return key_fac.generate_private(pkcs8key_spec)
        rescue NoSuchAlgorithmException => e
          # Return generic PKCS8Key with opaque key data (see below)
        rescue InvalidKeySpecException => e
          # Return generic PKCS8Key with opaque key data (see below)
        end
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
          classname = RJava.cast_to_string(sun_provider.get_property("PrivateKey.PKCS#8." + RJava.cast_to_string(algid.get_name)))
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
          if (inst.is_a?(PKCS8Key))
            result = inst
            result.attr_algid = algid
            result.attr_key = key
            result.parse_key_bits
            return result
          end
        rescue ClassNotFoundException => e
        rescue InstantiationException => e
        rescue IllegalAccessException => e
          # this should not happen.
          raise IOException.new(classname + " [internal error]")
        end
        result_ = PKCS8Key.new
        result_.attr_algid = algid
        result_.attr_key = key
        return result_
      end
    }
    
    typesig { [] }
    # Returns the algorithm to be used with this key.
    def get_algorithm
      return @algid.get_name
    end
    
    typesig { [] }
    # Returns the algorithm ID to be used with this key.
    def get_algorithm_id
      return @algid
    end
    
    typesig { [DerOutputStream] }
    # PKCS#8 sequence on the DER output stream.
    def encode(out)
      encode(out, @algid, @key)
    end
    
    typesig { [] }
    # Returns the DER-encoded form of the key as a byte array.
    def get_encoded
      synchronized(self) do
        result = nil
        begin
          result = encode
        rescue InvalidKeyException => e
        end
        return result
      end
    end
    
    typesig { [] }
    # Returns the format for this key: "PKCS#8"
    def get_format
      return "PKCS#8"
    end
    
    typesig { [] }
    # Returns the DER-encoded form of the key as a byte array.
    # 
    # @exception InvalidKeyException if an encoding error occurs.
    def encode
      if ((@encoded_key).nil?)
        begin
          out = nil
          out = DerOutputStream.new
          encode(out)
          @encoded_key = out.to_byte_array
        rescue IOException => e
          raise InvalidKeyException.new("IOException : " + RJava.cast_to_string(e.get_message))
        end
      end
      return @encoded_key.clone
    end
    
    typesig { [] }
    # Returns a printable representation of the key
    def to_s
      encoder = HexDumpEncoder.new
      return "algorithm = " + RJava.cast_to_string(@algid.to_s) + ", unparsed keybits = \n" + RJava.cast_to_string(encoder.encode_buffer(@key))
    end
    
    typesig { [InputStream] }
    # Initialize an PKCS8Key object from an input stream.  The data
    # on that input stream must be encoded using DER, obeying the
    # PKCS#8 format: a sequence consisting of a version, an algorithm
    # ID and a bit string which holds the key.  (That bit string is
    # often used to encapsulate another DER encoded sequence.)
    # 
    # <P>Subclasses should not normally redefine this method; they should
    # instead provide a <code>parseKeyBits</code> method to parse any
    # fields inside the <code>key</code> member.
    # 
    # @param in an input stream with a DER-encoded PKCS#8
    # SubjectPublicKeyInfo value
    # 
    # @exception InvalidKeyException if a parsing error occurs.
    def decode(in_)
      val = nil
      begin
        val = DerValue.new(in_)
        if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise InvalidKeyException.new("invalid key format")
        end
        version = val.attr_data.get_big_integer
        if (!(version == self.attr_version))
          raise IOException.new("version mismatch: (supported: " + RJava.cast_to_string(Debug.to_hex_string(self.attr_version)) + ", parsed: " + RJava.cast_to_string(Debug.to_hex_string(version)))
        end
        @algid = AlgorithmId.parse(val.attr_data.get_der_value)
        @key = val.attr_data.get_octet_string
        parse_key_bits
        if (!(val.attr_data.available).equal?(0))
          # OPTIONAL attributes not supported yet
        end
      rescue IOException => e
        # e.printStackTrace ();
        raise InvalidKeyException.new("IOException : " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def decode(encoded_key)
      decode(ByteArrayInputStream.new(encoded_key))
    end
    
    typesig { [] }
    def write_replace
      return KeyRep.new(KeyRep::Type::PRIVATE, get_algorithm, get_format, get_encoded)
    end
    
    typesig { [ObjectInputStream] }
    # Serialization read ... PKCS#8 keys serialize as
    # themselves, and they're parsed when they get read back.
    def read_object(stream)
      begin
        decode(stream)
      rescue InvalidKeyException => e
        e.print_stack_trace
        raise IOException.new("deserialized key is invalid: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    class_module.module_eval {
      typesig { [DerOutputStream, AlgorithmId, Array.typed(::Java::Byte)] }
      # Produce PKCS#8 encoding from algorithm id and key material.
      def encode(out, algid, key)
        tmp = DerOutputStream.new
        tmp.put_integer(Version)
        algid.encode(tmp)
        tmp.put_octet_string(key)
        out.write(DerValue.attr_tag_sequence, tmp)
      end
    }
    
    typesig { [Object] }
    # Compares two private keys. This returns false if the object with which
    # to compare is not of type <code>Key</code>.
    # Otherwise, the encoding of this key object is compared with the
    # encoding of the given key object.
    # 
    # @param object the object with which to compare
    # @return <code>true</code> if this key has the same encoding as the
    # object argument; <code>false</code> otherwise.
    def ==(object)
      if ((self).equal?(object))
        return true
      end
      if (object.is_a?(Key))
        # this encoding
        b1 = nil
        if (!(@encoded_key).nil?)
          b1 = @encoded_key
        else
          b1 = get_encoded
        end
        # that encoding
        b2 = (object).get_encoded
        # do the comparison
        i = 0
        if (!(b1.attr_length).equal?(b2.attr_length))
          return false
        end
        i = 0
        while i < b1.attr_length
          if (!(b1[i]).equal?(b2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # Calculates a hash code value for this object. Objects
    # which are equal will also have the same hashcode.
    def hash_code
      retval = 0
      b1 = get_encoded
      i = 1
      while i < b1.attr_length
        retval += b1[i] * i
        i += 1
      end
      return (retval)
    end
    
    private
    alias_method :initialize__pkcs8key, :initialize
  end
  
end

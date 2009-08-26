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
module Sun::Security::Provider
  module DSAImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Security
      include_const ::Java::Security, :SecureRandom
      include ::Java::Security::Interfaces
      include_const ::Java::Security::Spec, :DSAParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::X509, :AlgIdDSA
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # The Digital Signature Standard (using the Digital Signature
  # Algorithm), as described in fips186 of the National Instute of
  # Standards and Technology (NIST), using fips180-1 (SHA-1).
  # 
  # This file contains both the signature implementation for the
  # commonly used SHA1withDSA (DSS) as well as RawDSA, used by TLS
  # among others. RawDSA expects the 20 byte SHA-1 digest as input
  # via update rather than the original data like other signature
  # implementations.
  # 
  # @author Benjamin Renaud
  # 
  # @since   1.1
  # 
  # @see DSAPublicKey
  # @see DSAPrivateKey
  class DSA < DSAImports.const_get :SignatureSpi
    include_class_members DSAImports
    
    class_module.module_eval {
      # Are we debugging?
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
    }
    
    # The parameter object
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    # algorithm parameters
    attr_accessor :preset_p
    alias_method :attr_preset_p, :preset_p
    undef_method :preset_p
    alias_method :attr_preset_p=, :preset_p=
    undef_method :preset_p=
    
    attr_accessor :preset_q
    alias_method :attr_preset_q, :preset_q
    undef_method :preset_q
    alias_method :attr_preset_q=, :preset_q=
    undef_method :preset_q=
    
    attr_accessor :preset_g
    alias_method :attr_preset_g, :preset_g
    undef_method :preset_g
    alias_method :attr_preset_g=, :preset_g=
    undef_method :preset_g=
    
    # The public key, if any
    attr_accessor :preset_y
    alias_method :attr_preset_y, :preset_y
    undef_method :preset_y
    alias_method :attr_preset_y=, :preset_y=
    undef_method :preset_y=
    
    # The private key, if any
    attr_accessor :preset_x
    alias_method :attr_preset_x, :preset_x
    undef_method :preset_x
    alias_method :attr_preset_x=, :preset_x=
    undef_method :preset_x=
    
    # The random seed used to generate k
    attr_accessor :kseed
    alias_method :attr_kseed, :kseed
    undef_method :kseed
    alias_method :attr_kseed=, :kseed=
    undef_method :kseed=
    
    # The random seed used to generate k (specified by application)
    attr_accessor :kseed_as_byte_array
    alias_method :attr_kseed_as_byte_array, :kseed_as_byte_array
    undef_method :kseed_as_byte_array
    alias_method :attr_kseed_as_byte_array=, :kseed_as_byte_array=
    undef_method :kseed_as_byte_array=
    
    # The random seed used to generate k
    # (prevent the same Kseed from being used twice in a row
    attr_accessor :previous_kseed
    alias_method :attr_previous_kseed, :previous_kseed
    undef_method :previous_kseed
    alias_method :attr_previous_kseed=, :previous_kseed=
    undef_method :previous_kseed=
    
    # The RNG used to output a seed for generating k
    attr_accessor :signing_random
    alias_method :attr_signing_random, :signing_random
    undef_method :signing_random
    alias_method :attr_signing_random=, :signing_random=
    undef_method :signing_random=
    
    typesig { [] }
    # Construct a blank DSA object. It must be
    # initialized before being usable for signing or verifying.
    def initialize
      @params = nil
      @preset_p = nil
      @preset_q = nil
      @preset_g = nil
      @preset_y = nil
      @preset_x = nil
      @kseed = nil
      @kseed_as_byte_array = nil
      @previous_kseed = nil
      @signing_random = nil
      super()
    end
    
    typesig { [] }
    # Return the 20 byte hash value and reset the digest.
    def get_digest
      raise NotImplementedError
    end
    
    typesig { [] }
    # Reset the digest.
    def reset_digest
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # Standard SHA1withDSA implementation.
      const_set_lazy(:SHA1withDSA) { Class.new(DSA) do
        include_class_members DSA
        
        # The SHA hash for the data
        attr_accessor :data_sha
        alias_method :attr_data_sha, :data_sha
        undef_method :data_sha
        alias_method :attr_data_sha=, :data_sha=
        undef_method :data_sha=
        
        typesig { [] }
        def initialize
          @data_sha = nil
          super()
          @data_sha = MessageDigest.get_instance("SHA-1")
        end
        
        typesig { [::Java::Byte] }
        # Update a byte to be signed or verified.
        def engine_update(b)
          @data_sha.update(b)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        # Update an array of bytes to be signed or verified.
        def engine_update(data, off, len)
          @data_sha.update(data, off, len)
        end
        
        typesig { [self::ByteBuffer] }
        def engine_update(b)
          @data_sha.update(b)
        end
        
        typesig { [] }
        def get_digest
          return @data_sha.digest
        end
        
        typesig { [] }
        def reset_digest
          @data_sha.reset
        end
        
        private
        alias_method :initialize__sha1with_dsa, :initialize
      end }
      
      # RawDSA implementation.
      # 
      # RawDSA requires the data to be exactly 20 bytes long. If it is
      # not, a SignatureException is thrown when sign()/verify() is called
      # per JCA spec.
      const_set_lazy(:RawDSA) { Class.new(DSA) do
        include_class_members DSA
        
        class_module.module_eval {
          # length of the SHA-1 digest (20 bytes)
          const_set_lazy(:SHA1_LEN) { 20 }
          const_attr_reader  :SHA1_LEN
        }
        
        # 20 byte digest buffer
        attr_accessor :digest_buffer
        alias_method :attr_digest_buffer, :digest_buffer
        undef_method :digest_buffer
        alias_method :attr_digest_buffer=, :digest_buffer=
        undef_method :digest_buffer=
        
        # offset into the buffer
        attr_accessor :ofs
        alias_method :attr_ofs, :ofs
        undef_method :ofs
        alias_method :attr_ofs=, :ofs=
        undef_method :ofs=
        
        typesig { [] }
        def initialize
          @digest_buffer = nil
          @ofs = 0
          super()
          @digest_buffer = Array.typed(::Java::Byte).new(self.class::SHA1_LEN) { 0 }
        end
        
        typesig { [::Java::Byte] }
        def engine_update(b)
          if ((@ofs).equal?(self.class::SHA1_LEN))
            @ofs = self.class::SHA1_LEN + 1
            return
          end
          @digest_buffer[((@ofs += 1) - 1)] = b
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_update(data, off, len)
          if (@ofs + len > self.class::SHA1_LEN)
            @ofs = self.class::SHA1_LEN + 1
            return
          end
          System.arraycopy(data, off, @digest_buffer, @ofs, len)
          @ofs += len
        end
        
        typesig { [] }
        def get_digest
          if (!(@ofs).equal?(self.class::SHA1_LEN))
            raise self.class::SignatureException.new("Data for RawDSA must be exactly 20 bytes long")
          end
          @ofs = 0
          return @digest_buffer
        end
        
        typesig { [] }
        def reset_digest
          @ofs = 0
        end
        
        private
        alias_method :initialize__raw_dsa, :initialize
      end }
    }
    
    typesig { [PrivateKey] }
    # Initialize the DSA object with a DSA private key.
    # 
    # @param privateKey the DSA private key
    # 
    # @exception InvalidKeyException if the key is not a valid DSA private
    # key.
    def engine_init_sign(private_key)
      if (!(private_key.is_a?(Java::Security::Interfaces::DSAPrivateKey)))
        raise InvalidKeyException.new("not a DSA private key: " + RJava.cast_to_string(private_key))
      end
      priv = private_key
      @preset_x = priv.get_x
      @preset_y = nil
      initialize_(priv.get_params)
    end
    
    typesig { [PublicKey] }
    # Initialize the DSA object with a DSA public key.
    # 
    # @param publicKey the DSA public key.
    # 
    # @exception InvalidKeyException if the key is not a valid DSA public
    # key.
    def engine_init_verify(public_key)
      if (!(public_key.is_a?(Java::Security::Interfaces::DSAPublicKey)))
        raise InvalidKeyException.new("not a DSA public key: " + RJava.cast_to_string(public_key))
      end
      pub = public_key
      @preset_y = pub.get_y
      @preset_x = nil
      initialize_(pub.get_params)
    end
    
    typesig { [DSAParams] }
    def initialize_(params)
      reset_digest
      set_params(params)
    end
    
    typesig { [] }
    # Sign all the data thus far updated. The signature is formatted
    # according to the Canonical Encoding Rules, returned as a DER
    # sequence of Integer, r and s.
    # 
    # @return a signature block formatted according to the Canonical
    # Encoding Rules.
    # 
    # @exception SignatureException if the signature object was not
    # properly initialized, or if another exception occurs.
    # 
    # @see sun.security.DSA#engineUpdate
    # @see sun.security.DSA#engineVerify
    def engine_sign
      k = generate_k(@preset_q)
      r = generate_r(@preset_p, @preset_q, @preset_g, k)
      s = generate_s(@preset_x, @preset_q, r, k)
      begin
        outseq = DerOutputStream.new(100)
        outseq.put_integer(r)
        outseq.put_integer(s)
        result = DerValue.new(DerValue.attr_tag_sequence, outseq.to_byte_array)
        return result.to_byte_array
      rescue IOException => e
        raise SignatureException.new("error encoding signature")
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Verify all the data thus far updated.
    # 
    # @param signature the alledged signature, encoded using the
    # Canonical Encoding Rules, as a sequence of integers, r and s.
    # 
    # @exception SignatureException if the signature object was not
    # properly initialized, or if another exception occurs.
    # 
    # @see sun.security.DSA#engineUpdate
    # @see sun.security.DSA#engineSign
    def engine_verify(signature)
      return engine_verify(signature, 0, signature.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Verify all the data thus far updated.
    # 
    # @param signature the alledged signature, encoded using the
    # Canonical Encoding Rules, as a sequence of integers, r and s.
    # 
    # @param offset the offset to start from in the array of bytes.
    # 
    # @param length the number of bytes to use, starting at offset.
    # 
    # @exception SignatureException if the signature object was not
    # properly initialized, or if another exception occurs.
    # 
    # @see sun.security.DSA#engineUpdate
    # @see sun.security.DSA#engineSign
    def engine_verify(signature, offset, length)
      r = nil
      s = nil
      # first decode the signature.
      begin
        in_ = DerInputStream.new(signature, offset, length)
        values = in_.get_sequence(2)
        r = values[0].get_big_integer
        s = values[1].get_big_integer
      rescue IOException => e
        raise SignatureException.new("invalid encoding for signature")
      end
      # some implementations do not correctly encode values in the ASN.1
      # 2's complement format. force r and s to be positive in order to
      # to validate those signatures
      if (r.signum < 0)
        r = BigInteger.new(1, r.to_byte_array)
      end
      if (s.signum < 0)
        s = BigInteger.new(1, s.to_byte_array)
      end
      if ((((r <=> @preset_q)).equal?(-1)) && (((s <=> @preset_q)).equal?(-1)))
        w = generate_w(@preset_p, @preset_q, @preset_g, s)
        v = generate_v(@preset_y, @preset_p, @preset_q, @preset_g, w, r)
        return (v == r)
      else
        raise SignatureException.new("invalid signature: out of range values")
      end
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    def generate_r(p, q, g, k)
      temp = g.mod_pow(k, p)
      return temp.remainder(q)
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    def generate_s(x, q, r, k)
      s2 = get_digest
      temp = BigInteger.new(1, s2)
      k1 = k.mod_inverse(q)
      s = x.multiply(r)
      s = temp.add(s)
      s = k1.multiply(s)
      return s.remainder(q)
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    def generate_w(p, q, g, s)
      return s.mod_inverse(q)
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger] }
    def generate_v(y, p, q, g, w, r)
      s2 = get_digest
      temp = BigInteger.new(1, s2)
      temp = temp.multiply(w)
      u1 = temp.remainder(q)
      u2 = (r.multiply(w)).remainder(q)
      t1 = g.mod_pow(u1, p)
      t2 = y.mod_pow(u2, p)
      t3 = t1.multiply(t2)
      t5 = t3.remainder(p)
      return t5.remainder(q)
    end
    
    typesig { [BigInteger] }
    # Please read bug report 4044247 for an alternative, faster,
    # NON-FIPS approved method to generate K
    def generate_k(q)
      k = nil
      # The application specified a Kseed for us to use.
      # Note that we do not allow usage of the same Kseed twice in a row
      if (!(@kseed).nil? && !(Arrays == @kseed))
        k = generate_k(@kseed, q)
        if (k.signum > 0 && (k <=> q) < 0)
          @previous_kseed = Array.typed(::Java::Int).new(@kseed.attr_length) { 0 }
          System.arraycopy(@kseed, 0, @previous_kseed, 0, @kseed.attr_length)
          return k
        end
      end
      # The application did not specify a Kseed for us to use.
      # We'll generate a new Kseed by getting random bytes from
      # a SecureRandom object.
      random = get_signing_random
      while (true)
        seed = Array.typed(::Java::Int).new(5) { 0 }
        i = 0
        while i < 5
          seed[i] = random.next_int
          i += 1
        end
        k = generate_k(seed, q)
        if (k.signum > 0 && (k <=> q) < 0)
          @previous_kseed = Array.typed(::Java::Int).new(seed.attr_length) { 0 }
          System.arraycopy(seed, 0, @previous_kseed, 0, seed.attr_length)
          return k
        end
      end
    end
    
    typesig { [] }
    # Use the application-specified SecureRandom Object if provided.
    # Otherwise, use our default SecureRandom Object.
    def get_signing_random
      if ((@signing_random).nil?)
        if (!(self.attr_app_random).nil?)
          @signing_random = self.attr_app_random
        else
          @signing_random = JCAUtil.get_secure_random
        end
      end
      return @signing_random
    end
    
    typesig { [Array.typed(::Java::Int), BigInteger] }
    # Compute k for a DSA signature.
    # 
    # @param seed the seed for generating k. This seed should be
    # secure. This is what is refered to as the KSEED in the DSA
    # specification.
    # 
    # @param g the g parameter from the DSA key pair.
    def generate_k(seed, q)
      # check out t in the spec.
      t = Array.typed(::Java::Int).new([-0x10325477, -0x67452302, 0x10325476, -0x3c2d1e10, 0x67452301])
      tmp = DSA._sha_7(seed, t)
      tmp_bytes = Array.typed(::Java::Byte).new(tmp.attr_length * 4) { 0 }
      i = 0
      while i < tmp.attr_length
        k = tmp[i]
        j = 0
        while j < 4
          tmp_bytes[(i * 4) + j] = (k >> (24 - (j * 8)))
          j += 1
        end
        i += 1
      end
      k = BigInteger.new(1, tmp_bytes).mod(q)
      return k
    end
    
    class_module.module_eval {
      # Constants for each round
      const_set_lazy(:Round1_kt) { 0x5a827999 }
      const_attr_reader  :Round1_kt
      
      const_set_lazy(:Round2_kt) { 0x6ed9eba1 }
      const_attr_reader  :Round2_kt
      
      const_set_lazy(:Round3_kt) { -0x70e44324 }
      const_attr_reader  :Round3_kt
      
      const_set_lazy(:Round4_kt) { -0x359d3e2a }
      const_attr_reader  :Round4_kt
      
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int)] }
      # Computes set 1 thru 7 of SHA-1 on m1.
      def _sha_7(m1, h)
        w = Array.typed(::Java::Int).new(80) { 0 }
        System.arraycopy(m1, 0, w, 0, m1.attr_length)
        temp = 0
        t = 16
        while t <= 79
          temp = w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16]
          w[t] = ((temp << 1) | (temp >> (32 - 1)))
          t += 1
        end
        a = h[0]
        b = h[1]
        c = h[2]
        d = h[3]
        e = h[4]
        i = 0
        while i < 20
          temp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | ((~b) & d)) + e + w[i] + Round1_kt
          e = d
          d = c
          c = ((b << 30) | (b >> (32 - 30)))
          b = a
          a = temp
          i += 1
        end
        # Round 2
        i_ = 20
        while i_ < 40
          temp = ((a << 5) | (a >> (32 - 5))) + (b ^ c ^ d) + e + w[i_] + Round2_kt
          e = d
          d = c
          c = ((b << 30) | (b >> (32 - 30)))
          b = a
          a = temp
          i_ += 1
        end
        # Round 3
        i__ = 40
        while i__ < 60
          temp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | (b & d) | (c & d)) + e + w[i__] + Round3_kt
          e = d
          d = c
          c = ((b << 30) | (b >> (32 - 30)))
          b = a
          a = temp
          i__ += 1
        end
        # Round 4
        i___ = 60
        while i___ < 80
          temp = ((a << 5) | (a >> (32 - 5))) + (b ^ c ^ d) + e + w[i___] + Round4_kt
          e = d
          d = c
          c = ((b << 30) | (b >> (32 - 30)))
          b = a
          a = temp
          i___ += 1
        end
        md = Array.typed(::Java::Int).new(5) { 0 }
        md[0] = h[0] + a
        md[1] = h[1] + b
        md[2] = h[2] + c
        md[3] = h[3] + d
        md[4] = h[4] + e
        return md
      end
    }
    
    typesig { [String, Object] }
    # This implementation recognizes the following parameter:<dl>
    # 
    # <dt><tt>Kseed</tt>
    # 
    # <dd>a byte array.
    # 
    # </dl>
    # 
    # @deprecated
    def engine_set_parameter(key, param)
      if ((key == "KSEED"))
        if (param.is_a?(Array.typed(::Java::Byte)))
          @kseed = byte_array2int_array(param)
          @kseed_as_byte_array = param
        else
          debug("unrecognized param: " + key)
          raise InvalidParameterException.new("Kseed not a byte array")
        end
      else
        raise InvalidParameterException.new("invalid parameter")
      end
    end
    
    typesig { [String] }
    # Return the value of the requested parameter. Recognized
    # parameters are:
    # 
    # <dl>
    # 
    # <dt><tt>Kseed</tt>
    # 
    # <dd>a byte array.
    # 
    # </dl>
    # 
    # @return the value of the requested parameter.
    # 
    # @see java.security.SignatureEngine
    # 
    # @deprecated
    def engine_get_parameter(key)
      if ((key == "KSEED"))
        return @kseed_as_byte_array
      else
        return nil
      end
    end
    
    typesig { [DSAParams] }
    # Set the algorithm object.
    def set_params(params)
      if ((params).nil?)
        raise InvalidKeyException.new("DSA public key lacks parameters")
      end
      @params = params
      @preset_p = params.get_p
      @preset_q = params.get_q
      @preset_g = params.get_g
    end
    
    typesig { [] }
    # Return a human readable rendition of the engine.
    def to_s
      printable = "DSA Signature"
      if (!(@preset_p).nil? && !(@preset_q).nil? && !(@preset_g).nil?)
        printable += "\n\tp: " + RJava.cast_to_string(Debug.to_hex_string(@preset_p))
        printable += "\n\tq: " + RJava.cast_to_string(Debug.to_hex_string(@preset_q))
        printable += "\n\tg: " + RJava.cast_to_string(Debug.to_hex_string(@preset_g))
      else
        printable += "\n\t P, Q or G not initialized."
      end
      if (!(@preset_y).nil?)
        printable += "\n\ty: " + RJava.cast_to_string(Debug.to_hex_string(@preset_y))
      end
      if ((@preset_y).nil? && (@preset_x).nil?)
        printable += "\n\tUNINIIALIZED"
      end
      return printable
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Utility routine for converting a byte array into an int array
    def byte_array2int_array(byte_array)
      j = 0
      new_ba = nil
      mod = byte_array.attr_length % 4
      # guarantee that the incoming byteArray is a multiple of 4
      # (pad with 0's)
      case (mod)
      when 3
        new_ba = Array.typed(::Java::Byte).new(byte_array.attr_length + 1) { 0 }
      when 2
        new_ba = Array.typed(::Java::Byte).new(byte_array.attr_length + 2) { 0 }
      when 1
        new_ba = Array.typed(::Java::Byte).new(byte_array.attr_length + 3) { 0 }
      else
        new_ba = Array.typed(::Java::Byte).new(byte_array.attr_length + 0) { 0 }
      end
      System.arraycopy(byte_array, 0, new_ba, 0, byte_array.attr_length)
      # copy each set of 4 bytes in the byte array into an integer
      new_seed = Array.typed(::Java::Int).new(new_ba.attr_length / 4) { 0 }
      i = 0
      while i < new_ba.attr_length
        new_seed[j] = new_ba[i + 3] & 0xff
        new_seed[j] |= (new_ba[i + 2] << 8) & 0xff00
        new_seed[j] |= (new_ba[i + 1] << 16) & 0xff0000
        new_seed[j] |= (new_ba[i + 0] << 24) & -0x1000000
        j += 1
        i += 4
      end
      return new_seed
    end
    
    class_module.module_eval {
      typesig { [JavaException] }
      def debug(e)
        if (Debug)
          e.print_stack_trace
        end
      end
      
      typesig { [String] }
      def debug(s)
        if (Debug)
          System.err.println(s)
        end
      end
    }
    
    private
    alias_method :initialize__dsa, :initialize
  end
  
end

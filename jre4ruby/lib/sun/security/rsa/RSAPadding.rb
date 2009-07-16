require "rjava"

# 
# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Rsa
  module RSAPaddingImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include_const ::Javax::Crypto, :BadPaddingException
      include_const ::Javax::Crypto::Spec, :PSource
      include_const ::Javax::Crypto::Spec, :OAEPParameterSpec
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # 
  # RSA padding and unpadding.
  # 
  # Format of PKCS#1 v1.5 padding is:
  # 0x00 | BT | PS...PS | 0x00 | data...data
  # where BT is the blocktype (1 or 2). The length of the entire string
  # must be the same as the size of the modulus (i.e. 128 byte for a 1024 bit
  # key). Per spec, the padding string must be at least 8 bytes long. That
  # leaves up to (length of key in bytes) - 11 bytes for the data.
  # 
  # OAEP padding is a bit more complicated and has a number of options.
  # We support:
  # . arbitrary hash functions ('Hash' in the specification), MessageDigest
  # implementation must be available
  # . MGF1 as the mask generation function
  # . the empty string as the default value for label L and whatever
  # specified in javax.crypto.spec.OAEPParameterSpec
  # 
  # Note: RSA keys should be at least 512 bits long
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAPadding 
    include_class_members RSAPaddingImports
    
    class_module.module_eval {
      # NOTE: the constants below are embedded in the JCE RSACipher class
      # file. Do not change without coordinating the update
      # PKCS#1 v1.5 padding, blocktype 1 (signing)
      const_set_lazy(:PAD_BLOCKTYPE_1) { 1 }
      const_attr_reader  :PAD_BLOCKTYPE_1
      
      # PKCS#1 v1.5 padding, blocktype 2 (encryption)
      const_set_lazy(:PAD_BLOCKTYPE_2) { 2 }
      const_attr_reader  :PAD_BLOCKTYPE_2
      
      # nopadding. Does not do anything, but allows simpler RSACipher code
      const_set_lazy(:PAD_NONE) { 3 }
      const_attr_reader  :PAD_NONE
      
      # PKCS#1 v2.1 OAEP padding
      const_set_lazy(:PAD_OAEP_MGF1) { 4 }
      const_attr_reader  :PAD_OAEP_MGF1
    }
    
    # type, one of PAD_*
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # size of the padded block (i.e. size of the modulus)
    attr_accessor :padded_size
    alias_method :attr_padded_size, :padded_size
    undef_method :padded_size
    alias_method :attr_padded_size=, :padded_size=
    undef_method :padded_size=
    
    # PRNG used to generate padding bytes (PAD_BLOCKTYPE_2, PAD_OAEP_MGF1)
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    # maximum size of the data
    attr_accessor :max_data_size
    alias_method :attr_max_data_size, :max_data_size
    undef_method :max_data_size
    alias_method :attr_max_data_size=, :max_data_size=
    undef_method :max_data_size=
    
    # OAEP: main messagedigest
    attr_accessor :md
    alias_method :attr_md, :md
    undef_method :md
    alias_method :attr_md=, :md=
    undef_method :md=
    
    # OAEP: message digest for MGF1
    attr_accessor :mgf_md
    alias_method :attr_mgf_md, :mgf_md
    undef_method :mgf_md
    alias_method :attr_mgf_md=, :mgf_md=
    undef_method :mgf_md=
    
    # OAEP: value of digest of data (user-supplied or zero-length) using md
    attr_accessor :l_hash
    alias_method :attr_l_hash, :l_hash
    undef_method :l_hash
    alias_method :attr_l_hash=, :l_hash=
    undef_method :l_hash=
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # 
      # Get a RSAPadding instance of the specified type.
      # Keys used with this padding must be paddedSize bytes long.
      def get_instance(type, padded_size)
        return RSAPadding.new(type, padded_size, nil, nil)
      end
      
      typesig { [::Java::Int, ::Java::Int, SecureRandom] }
      # 
      # Get a RSAPadding instance of the specified type.
      # Keys used with this padding must be paddedSize bytes long.
      def get_instance(type, padded_size, random)
        return RSAPadding.new(type, padded_size, random, nil)
      end
      
      typesig { [::Java::Int, ::Java::Int, SecureRandom, OAEPParameterSpec] }
      # 
      # Get a RSAPadding instance of the specified type, which must be
      # OAEP. Keys used with this padding must be paddedSize bytes long.
      def get_instance(type, padded_size, random, spec)
        return RSAPadding.new(type, padded_size, random, spec)
      end
    }
    
    typesig { [::Java::Int, ::Java::Int, SecureRandom, OAEPParameterSpec] }
    # internal constructor
    def initialize(type, padded_size, random, spec)
      @type = 0
      @padded_size = 0
      @random = nil
      @max_data_size = 0
      @md = nil
      @mgf_md = nil
      @l_hash = nil
      @type = type
      @padded_size = padded_size
      @random = random
      if (padded_size < 64)
        # sanity check, already verified in RSASignature/RSACipher
        raise InvalidKeyException.new("Padded size must be at least 64")
      end
      case (type)
      when PAD_BLOCKTYPE_1, PAD_BLOCKTYPE_2
        @max_data_size = padded_size - 11
      when PAD_NONE
        @max_data_size = padded_size
      when PAD_OAEP_MGF1
        md_name = "SHA-1"
        mgf_md_name = "SHA-1"
        digest_input = nil
        begin
          if (!(spec).nil?)
            md_name = (spec.get_digest_algorithm).to_s
            mgf_name = spec.get_mgfalgorithm
            if (!mgf_name.equals_ignore_case("MGF1"))
              raise InvalidAlgorithmParameterException.new("Unsupported MGF algo: " + mgf_name)
            end
            mgf_md_name = ((spec.get_mgfparameters).get_digest_algorithm).to_s
            p_src = spec.get_psource
            p_src_algo = p_src.get_algorithm
            if (!p_src_algo.equals_ignore_case("PSpecified"))
              raise InvalidAlgorithmParameterException.new("Unsupported pSource algo: " + p_src_algo)
            end
            digest_input = (p_src).get_value
          end
          @md = MessageDigest.get_instance(md_name)
          @mgf_md = MessageDigest.get_instance(mgf_md_name)
        rescue NoSuchAlgorithmException => e
          raise InvalidKeyException.new("Digest " + md_name + " not available", e)
        end
        @l_hash = get_initial_hash(@md, digest_input)
        digest_len = @l_hash.attr_length
        @max_data_size = padded_size - 2 - 2 * digest_len
        if (@max_data_size <= 0)
          raise InvalidKeyException.new("Key is too short for encryption using OAEPPadding" + " with " + md_name + " and MGF1" + mgf_md_name)
        end
      else
        raise InvalidKeyException.new("Invalid padding: " + (type).to_s)
      end
    end
    
    class_module.module_eval {
      # cache of hashes of zero length data
      const_set_lazy(:EmptyHashes) { Collections.synchronized_map(HashMap.new) }
      const_attr_reader  :EmptyHashes
      
      typesig { [MessageDigest, Array.typed(::Java::Byte)] }
      # 
      # Return the value of the digest using the specified message digest
      # <code>md</code> and the digest input <code>digestInput</code>.
      # if <code>digestInput</code> is null or 0-length, zero length
      # is used to generate the initial digest.
      # Note: the md object must be in reset state
      def get_initial_hash(md, digest_input)
        result = nil
        if (((digest_input).nil?) || ((digest_input.attr_length).equal?(0)))
          digest_name = md.get_algorithm
          result = EmptyHashes.get(digest_name)
          if ((result).nil?)
            result = md.digest
            EmptyHashes.put(digest_name, result)
          end
        else
          result = md.digest(digest_input)
        end
        return result
      end
    }
    
    typesig { [] }
    # 
    # Return the maximum size of the plaintext data that can be processed using
    # this object.
    def get_max_data_size
      return @max_data_size
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Pad the data and return the padded block.
    def pad(data, ofs, len)
      return pad(RSACore.convert(data, ofs, len))
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Pad the data and return the padded block.
    def pad(data)
      if (data.attr_length > @max_data_size)
        raise BadPaddingException.new("Data must be shorter than " + ((@max_data_size + 1)).to_s + " bytes")
      end
      case (@type)
      when PAD_NONE
        return data
      when PAD_BLOCKTYPE_1, PAD_BLOCKTYPE_2
        return pad_v15(data)
      when PAD_OAEP_MGF1
        return pad_oaep(data)
      else
        raise AssertionError.new
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Unpad the padded block and return the data.
    def unpad(padded, ofs, len)
      return unpad(RSACore.convert(padded, ofs, len))
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Unpad the padded block and return the data.
    def unpad(padded)
      if (!(padded.attr_length).equal?(@padded_size))
        raise BadPaddingException.new("Padded length must be " + (@padded_size).to_s)
      end
      case (@type)
      when PAD_NONE
        return padded
      when PAD_BLOCKTYPE_1, PAD_BLOCKTYPE_2
        return unpad_v15(padded)
      when PAD_OAEP_MGF1
        return unpad_oaep(padded)
      else
        raise AssertionError.new
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # PKCS#1 v1.5 padding (blocktype 1 and 2).
    def pad_v15(data)
      padded = Array.typed(::Java::Byte).new(@padded_size) { 0 }
      System.arraycopy(data, 0, padded, @padded_size - data.attr_length, data.attr_length)
      ps_size = @padded_size - 3 - data.attr_length
      k = 0
      padded[((k += 1) - 1)] = 0
      padded[((k += 1) - 1)] = @type
      if ((@type).equal?(PAD_BLOCKTYPE_1))
        # blocktype 1: all padding bytes are 0xff
        while (((ps_size -= 1) + 1) > 0)
          padded[((k += 1) - 1)] = 0xff
        end
      else
        # blocktype 2: padding bytes are random non-zero bytes
        if ((@random).nil?)
          @random = JCAUtil.get_secure_random
        end
        # generate non-zero padding bytes
        # use a buffer to reduce calls to SecureRandom
        r = Array.typed(::Java::Byte).new(64) { 0 }
        i = -1
        while (((ps_size -= 1) + 1) > 0)
          b = 0
          begin
            if (i < 0)
              @random.next_bytes(r)
              i = r.attr_length - 1
            end
            b = r[((i -= 1) + 1)] & 0xff
          end while ((b).equal?(0))
          padded[((k += 1) - 1)] = b
        end
      end
      return padded
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # PKCS#1 v1.5 unpadding (blocktype 1 and 2).
    def unpad_v15(padded)
      k = 0
      if (!(padded[((k += 1) - 1)]).equal?(0))
        raise BadPaddingException.new("Data must start with zero")
      end
      if (!(padded[((k += 1) - 1)]).equal?(@type))
        raise BadPaddingException.new("Blocktype mismatch: " + (padded[1]).to_s)
      end
      while (true)
        b = padded[((k += 1) - 1)] & 0xff
        if ((b).equal?(0))
          break
        end
        if ((k).equal?(padded.attr_length))
          raise BadPaddingException.new("Padding string not terminated")
        end
        if (((@type).equal?(PAD_BLOCKTYPE_1)) && (!(b).equal?(0xff)))
          raise BadPaddingException.new("Padding byte not 0xff: " + (b).to_s)
        end
      end
      n = padded.attr_length - k
      if (n > @max_data_size)
        raise BadPaddingException.new("Padding string too short")
      end
      data = Array.typed(::Java::Byte).new(n) { 0 }
      System.arraycopy(padded, padded.attr_length - n, data, 0, n)
      return data
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # PKCS#1 v2.0 OAEP padding (MGF1).
    # Paragraph references refer to PKCS#1 v2.1 (June 14, 2002)
    def pad_oaep(m)
      if ((@random).nil?)
        @random = JCAUtil.get_secure_random
      end
      h_len = @l_hash.attr_length
      # 2.d: generate a random octet string seed of length hLen
      # if necessary
      seed = Array.typed(::Java::Byte).new(h_len) { 0 }
      @random.next_bytes(seed)
      # buffer for encoded message EM
      em = Array.typed(::Java::Byte).new(@padded_size) { 0 }
      # start and length of seed (as index into EM)
      seed_start = 1
      seed_len = h_len
      # copy seed into EM
      System.arraycopy(seed, 0, em, seed_start, seed_len)
      # start and length of data block DB in EM
      # we place it inside of EM to reduce copying
      db_start = h_len + 1
      db_len = em.attr_length - db_start
      # start of message M in EM
      m_start = @padded_size - m.attr_length
      # build DB
      # 2.b: Concatenate lHash, PS, a single octet with hexadecimal value
      # 0x01, and the message M to form a data block DB of length
      # k - hLen -1 octets as DB = lHash || PS || 0x01 || M
      # (note that PS is all zeros)
      System.arraycopy(@l_hash, 0, em, db_start, h_len)
      em[m_start - 1] = 1
      System.arraycopy(m, 0, em, m_start, m.attr_length)
      # produce maskedDB
      mgf1(em, seed_start, seed_len, em, db_start, db_len)
      # produce maskSeed
      mgf1(em, db_start, db_len, em, seed_start, seed_len)
      return em
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # PKCS#1 v2.1 OAEP unpadding (MGF1).
    def unpad_oaep(padded)
      em = padded
      h_len = @l_hash.attr_length
      if (!(em[0]).equal?(0))
        raise BadPaddingException.new("Data must start with zero")
      end
      seed_start = 1
      seed_len = h_len
      db_start = h_len + 1
      db_len = em.attr_length - db_start
      mgf1(em, db_start, db_len, em, seed_start, seed_len)
      mgf1(em, seed_start, seed_len, em, db_start, db_len)
      # verify lHash == lHash'
      i = 0
      while i < h_len
        if (!(@l_hash[i]).equal?(em[db_start + i]))
          raise BadPaddingException.new("lHash mismatch")
        end
        ((i += 1) - 1)
      end
      # skip over padding (0x00 bytes)
      i_ = db_start + h_len
      while ((em[i_]).equal?(0))
        ((i_ += 1) - 1)
        if (i_ >= em.attr_length)
          raise BadPaddingException.new("Padding string not terminated")
        end
      end
      if (!(em[((i_ += 1) - 1)]).equal?(1))
        raise BadPaddingException.new("Padding string not terminated by 0x01 byte")
      end
      m_len = em.attr_length - i_
      m = Array.typed(::Java::Byte).new(m_len) { 0 }
      System.arraycopy(em, i_, m, 0, m_len)
      return m
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Compute MGF1 using mgfMD as the message digest.
    # Note that we combine MGF1 with the XOR operation to reduce data
    # copying.
    # 
    # We generate maskLen bytes of MGF1 from the seed and XOR it into
    # out[] starting at outOfs;
    def mgf1(seed, seed_ofs, seed_len, out, out_ofs, mask_len)
      c = Array.typed(::Java::Byte).new(4) { 0 } # 32 bit counter
      digest_ = Array.typed(::Java::Byte).new(20) { 0 } # 20 bytes is length of SHA-1 digest
      while (mask_len > 0)
        @mgf_md.update(seed, seed_ofs, seed_len)
        @mgf_md.update(c)
        begin
          @mgf_md.digest(digest_, 0, digest_.attr_length)
        rescue DigestException => e
          # should never happen
          raise BadPaddingException.new(e.to_s)
        end
        i = 0
        while (i < digest_.attr_length) && (mask_len > 0)
          out[((out_ofs += 1) - 1)] ^= digest_[((i += 1) - 1)]
          ((mask_len -= 1) + 1)
        end
        if (mask_len > 0)
          # increment counter
          i_ = c.attr_length - 1
          while (((c[i_] += 1)).equal?(0)) && (i_ > 0)
            ((i_ -= 1) + 1)
          end
        end
      end
    end
    
    private
    alias_method :initialize__rsapadding, :initialize
  end
  
end

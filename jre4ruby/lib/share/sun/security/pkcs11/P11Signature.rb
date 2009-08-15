require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module P11SignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Nio, :ByteBuffer
      include ::Java::Security
      include_const ::Java::Security::Interfaces, :ECPublicKey
      include_const ::Sun::Nio::Ch, :DirectBuffer
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Rsa, :RSASignature
      include_const ::Sun::Security::Rsa, :RSAPadding
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # Signature implementation class. This class currently supports the
  # following algorithms:
  # 
  # . DSA
  # . NONEwithDSA (RawDSA)
  # . SHA1withDSA
  # . RSA:
  # . MD2withRSA
  # . MD5withRSA
  # . SHA1withRSA
  # . SHA256withRSA
  # . SHA384withRSA
  # . SHA512withRSA
  # . ECDSA
  # . NONEwithECDSA
  # . SHA1withECDSA
  # . SHA256withECDSA
  # . SHA384withECDSA
  # . SHA512withECDSA
  # 
  # Note that the underlying PKCS#11 token may support complete signature
  # algorithm (e.g. CKM_DSA_SHA1, CKM_MD5_RSA_PKCS), or it may just
  # implement the signature algorithm without hashing (e.g. CKM_DSA, CKM_PKCS),
  # or it may only implement the raw public key operation (CKM_RSA_X_509).
  # This class uses what is available and adds whatever extra processing
  # is needed.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Signature < P11SignatureImports.const_get :SignatureSpi
    include_class_members P11SignatureImports
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # name of the key algorithm, currently either RSA or DSA
    attr_accessor :key_algorithm
    alias_method :attr_key_algorithm, :key_algorithm
    undef_method :key_algorithm
    alias_method :attr_key_algorithm=, :key_algorithm=
    undef_method :key_algorithm=
    
    # mechanism id
    attr_accessor :mechanism
    alias_method :attr_mechanism, :mechanism
    undef_method :mechanism
    alias_method :attr_mechanism=, :mechanism=
    undef_method :mechanism=
    
    # digest algorithm OID, if we do RSA padding ourselves
    attr_accessor :digest_oid
    alias_method :attr_digest_oid, :digest_oid
    undef_method :digest_oid
    alias_method :attr_digest_oid=, :digest_oid=
    undef_method :digest_oid=
    
    # type, one of T_* below
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # key instance used, if init*() was called
    attr_accessor :p11key
    alias_method :attr_p11key, :p11key
    undef_method :p11key
    alias_method :attr_p11key=, :p11key=
    undef_method :p11key=
    
    # message digest, if we do the digesting ourselves
    attr_accessor :md
    alias_method :attr_md, :md
    undef_method :md
    alias_method :attr_md=, :md=
    undef_method :md=
    
    # associated session, if any
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # mode, on of M_* below
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    # flag indicating whether an operation is initialized
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    # buffer, for update(byte) or DSA
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # total number of bytes processed in current operation
    attr_accessor :bytes_processed
    alias_method :attr_bytes_processed, :bytes_processed
    undef_method :bytes_processed
    alias_method :attr_bytes_processed=, :bytes_processed=
    undef_method :bytes_processed=
    
    class_module.module_eval {
      # constant for signing mode
      const_set_lazy(:M_SIGN) { 1 }
      const_attr_reader  :M_SIGN
      
      # constant for verification mode
      const_set_lazy(:M_VERIFY) { 2 }
      const_attr_reader  :M_VERIFY
      
      # constant for type digesting, we do the hashing ourselves
      const_set_lazy(:T_DIGEST) { 1 }
      const_attr_reader  :T_DIGEST
      
      # constant for type update, token does everything
      const_set_lazy(:T_UPDATE) { 2 }
      const_attr_reader  :T_UPDATE
      
      # constant for type raw, used with RawDSA and NONEwithECDSA only
      const_set_lazy(:T_RAW) { 3 }
      const_attr_reader  :T_RAW
      
      # XXX PKCS#11 v2.20 says "should not be longer than 1024 bits",
      # but this is a little arbitrary
      const_set_lazy(:RAW_ECDSA_MAX) { 128 }
      const_attr_reader  :RAW_ECDSA_MAX
    }
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @key_algorithm = nil
      @mechanism = 0
      @digest_oid = nil
      @type = 0
      @p11key = nil
      @md = nil
      @session = nil
      @mode = 0
      @initialized = false
      @buffer = nil
      @bytes_processed = 0
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      case (RJava.cast_to_int(mechanism))
      when RJava.cast_to_int(CKM_MD2_RSA_PKCS), RJava.cast_to_int(CKM_MD5_RSA_PKCS), RJava.cast_to_int(CKM_SHA1_RSA_PKCS), RJava.cast_to_int(CKM_SHA256_RSA_PKCS), RJava.cast_to_int(CKM_SHA384_RSA_PKCS), RJava.cast_to_int(CKM_SHA512_RSA_PKCS)
        @key_algorithm = "RSA"
        @type = T_UPDATE
        @digest_oid = nil
        @buffer = Array.typed(::Java::Byte).new(1) { 0 }
        @md = nil
      when RJava.cast_to_int(CKM_DSA_SHA1)
        @key_algorithm = "DSA"
        @type = T_UPDATE
        @digest_oid = nil
        @buffer = Array.typed(::Java::Byte).new(1) { 0 }
        @md = nil
      when RJava.cast_to_int(CKM_ECDSA_SHA1)
        @key_algorithm = "EC"
        @type = T_UPDATE
        @digest_oid = nil
        @buffer = Array.typed(::Java::Byte).new(1) { 0 }
        @md = nil
      when RJava.cast_to_int(CKM_DSA)
        @key_algorithm = "DSA"
        @digest_oid = nil
        if ((algorithm == "DSA"))
          @type = T_DIGEST
          @md = MessageDigest.get_instance("SHA-1")
          @buffer = nil
        else
          if ((algorithm == "RawDSA"))
            @type = T_RAW
            @md = nil
            @buffer = Array.typed(::Java::Byte).new(20) { 0 }
          else
            raise ProviderException.new(algorithm)
          end
        end
      when RJava.cast_to_int(CKM_ECDSA)
        @key_algorithm = "EC"
        @digest_oid = nil
        if ((algorithm == "NONEwithECDSA"))
          @type = T_RAW
          @md = nil
          @buffer = Array.typed(::Java::Byte).new(RAW_ECDSA_MAX) { 0 }
        else
          digest_alg = nil
          if ((algorithm == "SHA1withECDSA"))
            digest_alg = "SHA-1"
          else
            if ((algorithm == "SHA256withECDSA"))
              digest_alg = "SHA-256"
            else
              if ((algorithm == "SHA384withECDSA"))
                digest_alg = "SHA-384"
              else
                if ((algorithm == "SHA512withECDSA"))
                  digest_alg = "SHA-512"
                else
                  raise ProviderException.new(algorithm)
                end
              end
            end
          end
          @type = T_DIGEST
          @md = MessageDigest.get_instance(digest_alg)
          @buffer = nil
        end
      when RJava.cast_to_int(CKM_RSA_PKCS), RJava.cast_to_int(CKM_RSA_X_509)
        @key_algorithm = "RSA"
        @type = T_DIGEST
        @buffer = nil
        if ((algorithm == "MD5withRSA"))
          @md = MessageDigest.get_instance("MD5")
          @digest_oid = AlgorithmId::MD5_oid
        else
          if ((algorithm == "SHA1withRSA"))
            @md = MessageDigest.get_instance("SHA-1")
            @digest_oid = AlgorithmId::SHA_oid
          else
            if ((algorithm == "MD2withRSA"))
              @md = MessageDigest.get_instance("MD2")
              @digest_oid = AlgorithmId::MD2_oid
            else
              if ((algorithm == "SHA256withRSA"))
                @md = MessageDigest.get_instance("SHA-256")
                @digest_oid = AlgorithmId::SHA256_oid
              else
                if ((algorithm == "SHA384withRSA"))
                  @md = MessageDigest.get_instance("SHA-384")
                  @digest_oid = AlgorithmId::SHA384_oid
                else
                  if ((algorithm == "SHA512withRSA"))
                    @md = MessageDigest.get_instance("SHA-512")
                    @digest_oid = AlgorithmId::SHA512_oid
                  else
                    raise ProviderException.new("Unknown signature: " + algorithm)
                  end
                end
              end
            end
          end
        end
      else
        raise ProviderException.new("Unknown mechanism: " + RJava.cast_to_string(mechanism))
      end
      @session = token.get_op_session
    end
    
    typesig { [] }
    def ensure_initialized
      @token.ensure_valid
      if ((@initialized).equal?(false))
        initialize_
      end
    end
    
    typesig { [] }
    def cancel_operation
      @token.ensure_valid
      if ((@initialized).equal?(false))
        return
      end
      @initialized = false
      if (((@session).nil?) || ((@token.attr_explicit_cancel).equal?(false)))
        return
      end
      if ((@session.has_objects).equal?(false))
        @session = @token.kill_session(@session)
        return
      end
      # "cancel" operation by finishing it
      # XXX make sure all this always works correctly
      if ((@mode).equal?(M_SIGN))
        begin
          if ((@type).equal?(T_UPDATE))
            @token.attr_p11._c_sign_final(@session.id, 0)
          else
            digest = nil
            if ((@type).equal?(T_DIGEST))
              digest = @md.digest
            else
              # T_RAW
              digest = @buffer
            end
            @token.attr_p11._c_sign(@session.id, digest)
          end
        rescue PKCS11Exception => e
          raise ProviderException.new("cancel failed", e)
        end
      else
        # M_VERIFY
        begin
          signature = nil
          if ((@key_algorithm == "DSA"))
            signature = Array.typed(::Java::Byte).new(40) { 0 }
          else
            signature = Array.typed(::Java::Byte).new((@p11key.key_length + 7) >> 3) { 0 }
          end
          if ((@type).equal?(T_UPDATE))
            @token.attr_p11._c_verify_final(@session.id, signature)
          else
            digest_ = nil
            if ((@type).equal?(T_DIGEST))
              digest_ = @md.digest
            else
              # T_RAW
              digest_ = @buffer
            end
            @token.attr_p11._c_verify(@session.id, digest_, signature)
          end
        rescue PKCS11Exception => e
          # will fail since the signature is incorrect
          # XXX check error code
        end
      end
    end
    
    typesig { [] }
    # assumes current state is initialized == false
    def initialize_
      begin
        if ((@session).nil?)
          @session = @token.get_op_session
        end
        if ((@mode).equal?(M_SIGN))
          @token.attr_p11._c_sign_init(@session.id, CK_MECHANISM.new(@mechanism), @p11key.attr_key_id)
        else
          @token.attr_p11._c_verify_init(@session.id, CK_MECHANISM.new(@mechanism), @p11key.attr_key_id)
        end
        @initialized = true
      rescue PKCS11Exception => e
        raise ProviderException.new("Initialization failed", e)
      end
      if (!(@bytes_processed).equal?(0))
        @bytes_processed = 0
        if (!(@md).nil?)
          @md.reset
        end
      end
    end
    
    typesig { [PublicKey] }
    # see JCA spec
    def engine_init_verify(public_key)
      cancel_operation
      @mode = M_VERIFY
      @p11key = P11KeyFactory.convert_key(@token, public_key, @key_algorithm)
      initialize_
    end
    
    typesig { [PrivateKey] }
    # see JCA spec
    def engine_init_sign(private_key)
      cancel_operation
      @mode = M_SIGN
      @p11key = P11KeyFactory.convert_key(@token, private_key, @key_algorithm)
      initialize_
    end
    
    typesig { [::Java::Byte] }
    # see JCA spec
    def engine_update(b)
      ensure_initialized
      case (@type)
      when T_UPDATE
        @buffer[0] = b
        engine_update(@buffer, 0, 1)
      when T_DIGEST
        @md.update(b)
        @bytes_processed += 1
      when T_RAW
        if (@bytes_processed >= @buffer.attr_length)
          @bytes_processed = @buffer.attr_length + 1
          return
        end
        @buffer[((@bytes_processed += 1) - 1)] = b
      else
        raise ProviderException.new("Internal error")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # see JCA spec
    def engine_update(b, ofs, len)
      ensure_initialized
      if ((len).equal?(0))
        return
      end
      case (@type)
      when T_UPDATE
        begin
          if ((@mode).equal?(M_SIGN))
            @token.attr_p11._c_sign_update(@session.id, 0, b, ofs, len)
          else
            @token.attr_p11._c_verify_update(@session.id, 0, b, ofs, len)
          end
          @bytes_processed += len
        rescue PKCS11Exception => e
          raise ProviderException.new(e)
        end
      when T_DIGEST
        @md.update(b, ofs, len)
        @bytes_processed += len
      when T_RAW
        if (@bytes_processed + len > @buffer.attr_length)
          @bytes_processed = @buffer.attr_length + 1
          return
        end
        System.arraycopy(b, ofs, @buffer, @bytes_processed, len)
        @bytes_processed += len
      else
        raise ProviderException.new("Internal error")
      end
    end
    
    typesig { [ByteBuffer] }
    # see JCA spec
    def engine_update(byte_buffer)
      ensure_initialized
      len = byte_buffer.remaining
      if (len <= 0)
        return
      end
      case (@type)
      when T_UPDATE
        if ((byte_buffer.is_a?(DirectBuffer)).equal?(false))
          # cannot do better than default impl
          super(byte_buffer)
          return
        end
        addr = (byte_buffer).address
        ofs = byte_buffer.position
        begin
          if ((@mode).equal?(M_SIGN))
            @token.attr_p11._c_sign_update(@session.id, addr + ofs, nil, 0, len)
          else
            @token.attr_p11._c_verify_update(@session.id, addr + ofs, nil, 0, len)
          end
          @bytes_processed += len
          byte_buffer.position(ofs + len)
        rescue PKCS11Exception => e
          raise ProviderException.new("Update failed", e)
        end
      when T_DIGEST
        @md.update(byte_buffer)
        @bytes_processed += len
      when T_RAW
        if (@bytes_processed + len > @buffer.attr_length)
          @bytes_processed = @buffer.attr_length + 1
          return
        end
        byte_buffer.get(@buffer, @bytes_processed, len)
        @bytes_processed += len
      else
        raise ProviderException.new("Internal error")
      end
    end
    
    typesig { [] }
    # see JCA spec
    def engine_sign
      ensure_initialized
      begin
        signature = nil
        if ((@type).equal?(T_UPDATE))
          len = (@key_algorithm == "DSA") ? 40 : 0
          signature = @token.attr_p11._c_sign_final(@session.id, len)
        else
          digest_ = nil
          if ((@type).equal?(T_DIGEST))
            digest_ = @md.digest
          else
            # T_RAW
            if ((@mechanism).equal?(CKM_DSA))
              if (!(@bytes_processed).equal?(@buffer.attr_length))
                raise SignatureException.new("Data for RawDSA must be exactly 20 bytes long")
              end
              digest_ = @buffer
            else
              # CKM_ECDSA
              if (@bytes_processed > @buffer.attr_length)
                raise SignatureException.new("Data for NONEwithECDSA" + " must be at most " + RJava.cast_to_string(RAW_ECDSA_MAX) + " bytes long")
              end
              digest_ = Array.typed(::Java::Byte).new(@bytes_processed) { 0 }
              System.arraycopy(@buffer, 0, digest_, 0, @bytes_processed)
            end
          end
          if (((@key_algorithm == "RSA")).equal?(false))
            # DSA and ECDSA
            signature = @token.attr_p11._c_sign(@session.id, digest_)
          else
            # RSA
            data = encode_signature(digest_)
            if ((@mechanism).equal?(CKM_RSA_X_509))
              data = pkcs1_pad(data)
            end
            signature = @token.attr_p11._c_sign(@session.id, data)
          end
        end
        if (((@key_algorithm == "RSA")).equal?(false))
          return dsa_to_asn1(signature)
        else
          return signature
        end
      rescue PKCS11Exception => e
        raise ProviderException.new(e)
      ensure
        @initialized = false
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # see JCA spec
    def engine_verify(signature)
      ensure_initialized
      begin
        if ((@key_algorithm == "DSA"))
          signature = asn1_to_dsa(signature)
        else
          if ((@key_algorithm == "EC"))
            signature = asn1_to_ecdsa(signature)
          end
        end
        if ((@type).equal?(T_UPDATE))
          @token.attr_p11._c_verify_final(@session.id, signature)
        else
          digest_ = nil
          if ((@type).equal?(T_DIGEST))
            digest_ = @md.digest
          else
            # T_RAW
            if ((@mechanism).equal?(CKM_DSA))
              if (!(@bytes_processed).equal?(@buffer.attr_length))
                raise SignatureException.new("Data for RawDSA must be exactly 20 bytes long")
              end
              digest_ = @buffer
            else
              if (@bytes_processed > @buffer.attr_length)
                raise SignatureException.new("Data for NONEwithECDSA" + " must be at most " + RJava.cast_to_string(RAW_ECDSA_MAX) + " bytes long")
              end
              digest_ = Array.typed(::Java::Byte).new(@bytes_processed) { 0 }
              System.arraycopy(@buffer, 0, digest_, 0, @bytes_processed)
            end
          end
          if (((@key_algorithm == "RSA")).equal?(false))
            # DSA and ECDSA
            @token.attr_p11._c_verify(@session.id, digest_, signature)
          else
            # RSA
            data = encode_signature(digest_)
            if ((@mechanism).equal?(CKM_RSA_X_509))
              data = pkcs1_pad(data)
            end
            @token.attr_p11._c_verify(@session.id, data, signature)
          end
        end
        return true
      rescue PKCS11Exception => e
        error_code = e.get_error_code
        if ((error_code).equal?(CKR_SIGNATURE_INVALID))
          return false
        end
        if ((error_code).equal?(CKR_SIGNATURE_LEN_RANGE))
          # return false rather than throwing an exception
          return false
        end
        # ECF bug?
        if ((error_code).equal?(CKR_DATA_LEN_RANGE))
          return false
        end
        raise ProviderException.new(e)
      ensure
        # XXX we should not release the session if we abort above
        # before calling C_Verify
        @initialized = false
        @session = @token.release_session(@session)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def pkcs1_pad(data)
      begin
        len = (@p11key.key_length + 7) >> 3
        padding = RSAPadding.get_instance(RSAPadding::PAD_BLOCKTYPE_1, len)
        padded = padding.pad(data)
        return padded
      rescue GeneralSecurityException => e
        raise ProviderException.new(e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def encode_signature(digest_)
      begin
        return RSASignature.encode_signature(@digest_oid, digest_)
      rescue IOException => e
        raise SignatureException.new("Invalid encoding", e)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # private static byte[] decodeSignature(byte[] signature) throws IOException {
      # return RSASignature.decodeSignature(digestOID, signature);
      # }
      # For DSA and ECDSA signatures, PKCS#11 represents them as a simple
      # byte array that contains the concatenation of r and s.
      # For DSA, r and s are always exactly 20 bytes long.
      # For ECDSA, r and s are of variable length, but we know that each
      # occupies half of the array.
      def dsa_to_asn1(signature)
        n = signature.attr_length >> 1
        r = BigInteger.new(1, P11Util.subarray(signature, 0, n))
        s = BigInteger.new(1, P11Util.subarray(signature, n, n))
        begin
          outseq = DerOutputStream.new(100)
          outseq.put_integer(r)
          outseq.put_integer(s)
          result = DerValue.new(DerValue.attr_tag_sequence, outseq.to_byte_array)
          return result.to_byte_array
        rescue Java::Io::IOException => e
          raise RuntimeException.new("Internal error", e)
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def asn1_to_dsa(signature)
        begin
          in_ = DerInputStream.new(signature)
          values = in_.get_sequence(2)
          r = values[0].get_positive_big_integer
          s = values[1].get_positive_big_integer
          br = to_byte_array(r, 20)
          bs = to_byte_array(s, 20)
          if (((br).nil?) || ((bs).nil?))
            raise SignatureException.new("Out of range value for R or S")
          end
          return P11Util.concat(br, bs)
        rescue SignatureException => e
          raise e
        rescue JavaException => e
          raise SignatureException.new("invalid encoding for signature", e)
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def asn1_to_ecdsa(signature)
      begin
        in_ = DerInputStream.new(signature)
        values = in_.get_sequence(2)
        r = values[0].get_positive_big_integer
        s = values[1].get_positive_big_integer
        # trim leading zeroes
        br = P11Util.trim_zeroes(r.to_byte_array)
        bs = P11Util.trim_zeroes(s.to_byte_array)
        k = Math.max(br.attr_length, bs.attr_length)
        # r and s each occupy half the array
        res = Array.typed(::Java::Byte).new(k << 1) { 0 }
        System.arraycopy(br, 0, res, k - br.attr_length, br.attr_length)
        System.arraycopy(bs, 0, res, res.attr_length - bs.attr_length, bs.attr_length)
        return res
      rescue JavaException => e
        raise SignatureException.new("invalid encoding for signature", e)
      end
    end
    
    class_module.module_eval {
      typesig { [BigInteger, ::Java::Int] }
      def to_byte_array(bi, len)
        b = bi.to_byte_array
        n = b.attr_length
        if ((n).equal?(len))
          return b
        end
        if (((n).equal?(len + 1)) && ((b[0]).equal?(0)))
          t = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(b, 1, t, 0, len)
          return t
        end
        if (n > len)
          return nil
        end
        # must be smaller
        t = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(b, 0, t, (len - n), n)
        return t
      end
    }
    
    typesig { [String, Object] }
    # see JCA spec
    def engine_set_parameter(param, value)
      raise UnsupportedOperationException.new("setParameter() not supported")
    end
    
    typesig { [String] }
    # see JCA spec
    def engine_get_parameter(param)
      raise UnsupportedOperationException.new("getParameter() not supported")
    end
    
    typesig { [] }
    def finalize
      begin
        if ((!(@session).nil?) && @token.is_valid)
          cancel_operation
          @session = @token.release_session(@session)
        end
      ensure
        super
      end
    end
    
    private
    alias_method :initialize__p11signature, :initialize
  end
  
end

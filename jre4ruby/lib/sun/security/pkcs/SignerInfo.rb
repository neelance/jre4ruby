require "rjava"

# 
# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SignerInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security::Cert, :X509Certificate
      include ::Java::Security
      include_const ::Java::Util, :ArrayList
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :KeyUsageExtension
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # 
  # A SignerInfo, as defined in PKCS#7's signedData type.
  # 
  # @author Benjamin Renaud
  class SignerInfo 
    include_class_members SignerInfoImports
    include DerEncoder
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :issuer_name
    alias_method :attr_issuer_name, :issuer_name
    undef_method :issuer_name
    alias_method :attr_issuer_name=, :issuer_name=
    undef_method :issuer_name=
    
    attr_accessor :certificate_serial_number
    alias_method :attr_certificate_serial_number, :certificate_serial_number
    undef_method :certificate_serial_number
    alias_method :attr_certificate_serial_number=, :certificate_serial_number=
    undef_method :certificate_serial_number=
    
    attr_accessor :digest_algorithm_id
    alias_method :attr_digest_algorithm_id, :digest_algorithm_id
    undef_method :digest_algorithm_id
    alias_method :attr_digest_algorithm_id=, :digest_algorithm_id=
    undef_method :digest_algorithm_id=
    
    attr_accessor :digest_encryption_algorithm_id
    alias_method :attr_digest_encryption_algorithm_id, :digest_encryption_algorithm_id
    undef_method :digest_encryption_algorithm_id
    alias_method :attr_digest_encryption_algorithm_id=, :digest_encryption_algorithm_id=
    undef_method :digest_encryption_algorithm_id=
    
    attr_accessor :encrypted_digest
    alias_method :attr_encrypted_digest, :encrypted_digest
    undef_method :encrypted_digest
    alias_method :attr_encrypted_digest=, :encrypted_digest=
    undef_method :encrypted_digest=
    
    attr_accessor :authenticated_attributes
    alias_method :attr_authenticated_attributes, :authenticated_attributes
    undef_method :authenticated_attributes
    alias_method :attr_authenticated_attributes=, :authenticated_attributes=
    undef_method :authenticated_attributes=
    
    attr_accessor :unauthenticated_attributes
    alias_method :attr_unauthenticated_attributes, :unauthenticated_attributes
    undef_method :unauthenticated_attributes
    alias_method :attr_unauthenticated_attributes=, :unauthenticated_attributes=
    undef_method :unauthenticated_attributes=
    
    typesig { [X500Name, BigInteger, AlgorithmId, AlgorithmId, Array.typed(::Java::Byte)] }
    def initialize(issuer_name, serial, digest_algorithm_id, digest_encryption_algorithm_id, encrypted_digest)
      @version = nil
      @issuer_name = nil
      @certificate_serial_number = nil
      @digest_algorithm_id = nil
      @digest_encryption_algorithm_id = nil
      @encrypted_digest = nil
      @authenticated_attributes = nil
      @unauthenticated_attributes = nil
      @version = BigInteger::ONE
      @issuer_name = issuer_name
      @certificate_serial_number = serial
      @digest_algorithm_id = digest_algorithm_id
      @digest_encryption_algorithm_id = digest_encryption_algorithm_id
      @encrypted_digest = encrypted_digest
    end
    
    typesig { [X500Name, BigInteger, AlgorithmId, PKCS9Attributes, AlgorithmId, Array.typed(::Java::Byte), PKCS9Attributes] }
    def initialize(issuer_name, serial, digest_algorithm_id, authenticated_attributes, digest_encryption_algorithm_id, encrypted_digest, unauthenticated_attributes)
      @version = nil
      @issuer_name = nil
      @certificate_serial_number = nil
      @digest_algorithm_id = nil
      @digest_encryption_algorithm_id = nil
      @encrypted_digest = nil
      @authenticated_attributes = nil
      @unauthenticated_attributes = nil
      @version = BigInteger::ONE
      @issuer_name = issuer_name
      @certificate_serial_number = serial
      @digest_algorithm_id = digest_algorithm_id
      @authenticated_attributes = authenticated_attributes
      @digest_encryption_algorithm_id = digest_encryption_algorithm_id
      @encrypted_digest = encrypted_digest
      @unauthenticated_attributes = unauthenticated_attributes
    end
    
    typesig { [DerInputStream] }
    # 
    # Parses a PKCS#7 signer info.
    def initialize(derin)
      initialize__signer_info(derin, false)
    end
    
    typesig { [DerInputStream, ::Java::Boolean] }
    # 
    # Parses a PKCS#7 signer info.
    # 
    # <p>This constructor is used only for backwards compatibility with
    # PKCS#7 blocks that were generated using JDK1.1.x.
    # 
    # @param derin the ASN.1 encoding of the signer info.
    # @param oldStyle flag indicating whether or not the given signer info
    # is encoded according to JDK1.1.x.
    def initialize(derin, old_style)
      @version = nil
      @issuer_name = nil
      @certificate_serial_number = nil
      @digest_algorithm_id = nil
      @digest_encryption_algorithm_id = nil
      @encrypted_digest = nil
      @authenticated_attributes = nil
      @unauthenticated_attributes = nil
      # version
      @version = derin.get_big_integer
      # issuerAndSerialNumber
      issuer_and_serial_number = derin.get_sequence(2)
      issuer_bytes = issuer_and_serial_number[0].to_byte_array
      @issuer_name = X500Name.new(DerValue.new(DerValue.attr_tag_sequence, issuer_bytes))
      @certificate_serial_number = issuer_and_serial_number[1].get_big_integer
      # digestAlgorithmId
      tmp = derin.get_der_value
      @digest_algorithm_id = AlgorithmId.parse(tmp)
      # authenticatedAttributes
      if (old_style)
        # In JDK1.1.x, the authenticatedAttributes are always present,
        # encoded as an empty Set (Set of length zero)
        derin.get_set(0)
      else
        # check if set of auth attributes (implicit tag) is provided
        # (auth attributes are OPTIONAL)
        if (((derin.peek_byte)).equal?(0xa0))
          @authenticated_attributes = PKCS9Attributes.new(derin)
        end
      end
      # digestEncryptionAlgorithmId - little RSA naming scheme -
      # signature == encryption...
      tmp = derin.get_der_value
      @digest_encryption_algorithm_id = AlgorithmId.parse(tmp)
      # encryptedDigest
      @encrypted_digest = derin.get_octet_string
      # unauthenticatedAttributes
      if (old_style)
        # In JDK1.1.x, the unauthenticatedAttributes are always present,
        # encoded as an empty Set (Set of length zero)
        derin.get_set(0)
      else
        # check if set of unauth attributes (implicit tag) is provided
        # (unauth attributes are OPTIONAL)
        if (!(derin.available).equal?(0) && ((derin.peek_byte)).equal?(0xa1))
          @unauthenticated_attributes = PKCS9Attributes.new(derin, true) # ignore unsupported attrs
        end
      end
      # all done
      if (!(derin.available).equal?(0))
        raise ParsingException.new("extra data at the end")
      end
    end
    
    typesig { [DerOutputStream] }
    def encode(out)
      der_encode(out)
    end
    
    typesig { [OutputStream] }
    # 
    # DER encode this object onto an output stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out
    # the output stream on which to write the DER encoding.
    # 
    # @exception IOException on encoding error.
    def der_encode(out)
      seq = DerOutputStream.new
      seq.put_integer(@version)
      issuer_and_serial_number = DerOutputStream.new
      @issuer_name.encode(issuer_and_serial_number)
      issuer_and_serial_number.put_integer(@certificate_serial_number)
      seq.write(DerValue.attr_tag_sequence, issuer_and_serial_number)
      @digest_algorithm_id.encode(seq)
      # encode authenticated attributes if there are any
      if (!(@authenticated_attributes).nil?)
        @authenticated_attributes.encode(0xa0, seq)
      end
      @digest_encryption_algorithm_id.encode(seq)
      seq.put_octet_string(@encrypted_digest)
      # encode unauthenticated attributes if there are any
      if (!(@unauthenticated_attributes).nil?)
        @unauthenticated_attributes.encode(0xa1, seq)
      end
      tmp = DerOutputStream.new
      tmp.write(DerValue.attr_tag_sequence, seq)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [PKCS7] }
    # 
    # Returns the (user) certificate pertaining to this SignerInfo.
    def get_certificate(block)
      return block.get_certificate(@certificate_serial_number, @issuer_name)
    end
    
    typesig { [PKCS7] }
    # 
    # Returns the certificate chain pertaining to this SignerInfo.
    def get_certificate_chain(block)
      user_cert = nil
      user_cert = block.get_certificate(@certificate_serial_number, @issuer_name)
      if ((user_cert).nil?)
        return nil
      end
      cert_list = ArrayList.new
      cert_list.add(user_cert)
      pkcs_certs = block.get_certificates
      if ((pkcs_certs).nil? || (user_cert.get_subject_dn == user_cert.get_issuer_dn))
        return cert_list
      end
      issuer = user_cert.get_issuer_dn
      start = 0
      while (true)
        match = false
        i = start
        while (i < pkcs_certs.attr_length)
          if ((issuer == pkcs_certs[i].get_subject_dn))
            # next cert in chain found
            cert_list.add(pkcs_certs[i])
            # if selected cert is self-signed, we're done
            # constructing the chain
            if ((pkcs_certs[i].get_subject_dn == pkcs_certs[i].get_issuer_dn))
              start = pkcs_certs.attr_length
            else
              issuer = pkcs_certs[i].get_issuer_dn
              tmp_cert = pkcs_certs[start]
              pkcs_certs[start] = pkcs_certs[i]
              pkcs_certs[i] = tmp_cert
              ((start += 1) - 1)
            end
            match = true
            break
          else
            ((i += 1) - 1)
          end
        end
        if (!match)
          break
        end
      end
      return cert_list
    end
    
    typesig { [PKCS7, Array.typed(::Java::Byte)] }
    # Returns null if verify fails, this signerInfo if
    # verify succeeds.
    def verify(block, data)
      begin
        content = block.get_content_info
        if ((data).nil?)
          data = content.get_content_bytes
        end
        digest_algname = get_digest_algorithm_id.get_name
        if (digest_algname.equals_ignore_case("SHA"))
          digest_algname = "SHA1"
        end
        data_signed = nil
        # if there are authenticate attributes, get the message
        # digest and compare it with the digest of data
        if ((@authenticated_attributes).nil?)
          data_signed = data
        else
          # first, check content type
          content_type = @authenticated_attributes.get_attribute_value(PKCS9Attribute::CONTENT_TYPE_OID)
          if ((content_type).nil? || !(content_type == content.attr_content_type))
            return nil
          end # contentType does not match, bad SignerInfo
          # now, check message digest
          message_digest = @authenticated_attributes.get_attribute_value(PKCS9Attribute::MESSAGE_DIGEST_OID)
          if ((message_digest).nil?)
            # fail if there is no message digest
            return nil
          end
          md = MessageDigest.get_instance(digest_algname)
          computed_message_digest = md.digest(data)
          if (!(message_digest.attr_length).equal?(computed_message_digest.attr_length))
            return nil
          end
          i = 0
          while i < message_digest.attr_length
            if (!(message_digest[i]).equal?(computed_message_digest[i]))
              return nil
            end
            ((i += 1) - 1)
          end
          # message digest attribute matched
          # digest of original data
          # the data actually signed is the DER encoding of
          # the authenticated attributes (tagged with
          # the "SET OF" tag, not 0xA0).
          data_signed = @authenticated_attributes.get_der_encoding
        end
        # put together digest algorithm and encryption algorithm
        # to form signing algorithm
        encryption_algname = get_digest_encryption_algorithm_id.get_name
        if (encryption_algname.equals_ignore_case("SHA1withDSA"))
          encryption_algname = "DSA"
        end
        algname = digest_algname + "with" + encryption_algname
        sig = Signature.get_instance(algname)
        cert = get_certificate(block)
        if ((cert).nil?)
          return nil
        end
        if (cert.has_unsupported_critical_extension)
          raise SignatureException.new("Certificate has unsupported " + "critical extension(s)")
        end
        # Make sure that if the usage of the key in the certificate is
        # restricted, it can be used for digital signatures.
        # XXX We may want to check for additional extensions in the
        # future.
        key_usage_bits = cert.get_key_usage
        if (!(key_usage_bits).nil?)
          key_usage = nil
          begin
            # We don't care whether or not this extension was marked
            # critical in the certificate.
            # We're interested only in its value (i.e., the bits set)
            # and treat the extension as critical.
            key_usage = KeyUsageExtension.new(key_usage_bits)
          rescue IOException => ioe
            raise SignatureException.new("Failed to parse keyUsage " + "extension")
          end
          dig_sig_allowed = (key_usage.get(KeyUsageExtension::DIGITAL_SIGNATURE)).boolean_value
          non_repu_allowed = (key_usage.get(KeyUsageExtension::NON_REPUDIATION)).boolean_value
          if (!dig_sig_allowed && !non_repu_allowed)
            raise SignatureException.new("Key usage restricted: " + "cannot be used for " + "digital signatures")
          end
        end
        key = cert.get_public_key
        sig.init_verify(key)
        sig.update(data_signed)
        if (sig.verify(@encrypted_digest))
          return self
        end
      rescue IOException => e
        raise SignatureException.new("IO error verifying signature:\n" + (e.get_message).to_s)
      rescue InvalidKeyException => e
        raise SignatureException.new("InvalidKey: " + (e_.get_message).to_s)
      end
      return nil
    end
    
    typesig { [PKCS7] }
    # Verify the content of the pkcs7 block.
    def verify(block)
      return verify(block, nil)
    end
    
    typesig { [] }
    def get_version
      return @version
    end
    
    typesig { [] }
    def get_issuer_name
      return @issuer_name
    end
    
    typesig { [] }
    def get_certificate_serial_number
      return @certificate_serial_number
    end
    
    typesig { [] }
    def get_digest_algorithm_id
      return @digest_algorithm_id
    end
    
    typesig { [] }
    def get_authenticated_attributes
      return @authenticated_attributes
    end
    
    typesig { [] }
    def get_digest_encryption_algorithm_id
      return @digest_encryption_algorithm_id
    end
    
    typesig { [] }
    def get_encrypted_digest
      return @encrypted_digest
    end
    
    typesig { [] }
    def get_unauthenticated_attributes
      return @unauthenticated_attributes
    end
    
    typesig { [] }
    def to_s
      hex_dump = HexDumpEncoder.new
      out = ""
      out += "Signer Info for (issuer): " + (@issuer_name).to_s + "\n"
      out += "\tversion: " + (Debug.to_hex_string(@version)).to_s + "\n"
      out += "\tcertificateSerialNumber: " + (Debug.to_hex_string(@certificate_serial_number)).to_s + "\n"
      out += "\tdigestAlgorithmId: " + (@digest_algorithm_id).to_s + "\n"
      if (!(@authenticated_attributes).nil?)
        out += "\tauthenticatedAttributes: " + (@authenticated_attributes).to_s + "\n"
      end
      out += "\tdigestEncryptionAlgorithmId: " + (@digest_encryption_algorithm_id).to_s + "\n"
      out += "\tencryptedDigest: " + "\n" + (hex_dump.encode_buffer(@encrypted_digest)).to_s + "\n"
      if (!(@unauthenticated_attributes).nil?)
        out += "\tunauthenticatedAttributes: " + (@unauthenticated_attributes).to_s + "\n"
      end
      return out
    end
    
    private
    alias_method :initialize__signer_info, :initialize
  end
  
end

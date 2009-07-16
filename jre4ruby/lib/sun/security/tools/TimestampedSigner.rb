require "rjava"

# 
# Copyright (c) 2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Tools
  module TimestampedSignerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Net, :URI
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Util, :JavaList
      include ::Com::Sun::Jarsigner
      include_const ::Java::Util, :Arrays
      include ::Sun::Security::Pkcs
      include ::Sun::Security::Timestamp
      include ::Sun::Security::Util
      include ::Sun::Security::X509
    }
  end
  
  # 
  # This class implements a content signing service.
  # It generates a timestamped signature for a given content according to
  # <a href="http://www.ietf.org/rfc/rfc3161.txt">RFC 3161</a>.
  # The signature along with a trusted timestamp and the signer's certificate
  # are all packaged into a standard PKCS #7 Signed Data message.
  # 
  # @author Vincent Ryan
  class TimestampedSigner < TimestampedSignerImports.const_get :ContentSigner
    include_class_members TimestampedSignerImports
    
    class_module.module_eval {
      when_class_loaded do
        tmp = nil
        begin
          tmp = SecureRandom.get_instance("SHA1PRNG")
        rescue NoSuchAlgorithmException => e
          # should not happen
        end
        const_set :RANDOM, tmp
      end
      
      # 
      # Object identifier for the subject information access X.509 certificate
      # extension.
      const_set_lazy(:SUBJECT_INFO_ACCESS_OID) { "1.3.6.1.5.5.7.1.11" }
      const_attr_reader  :SUBJECT_INFO_ACCESS_OID
      
      # 
      # Object identifier for the timestamping key purpose.
      const_set_lazy(:KP_TIMESTAMPING_OID) { "1.3.6.1.5.5.7.3.8" }
      const_attr_reader  :KP_TIMESTAMPING_OID
      
      when_class_loaded do
        tmp = nil
        begin
          tmp = ObjectIdentifier.new("1.3.6.1.5.5.7.48.3")
        rescue IOException => e
          # ignore
        end
        const_set :AD_TIMESTAMPING_Id, tmp
      end
    }
    
    # 
    # Location of the TSA.
    attr_accessor :tsa_url
    alias_method :attr_tsa_url, :tsa_url
    undef_method :tsa_url
    alias_method :attr_tsa_url=, :tsa_url=
    undef_method :tsa_url=
    
    # 
    # TSA's X.509 certificate.
    attr_accessor :tsa_certificate
    alias_method :attr_tsa_certificate, :tsa_certificate
    undef_method :tsa_certificate
    alias_method :attr_tsa_certificate=, :tsa_certificate=
    undef_method :tsa_certificate=
    
    # 
    # Generates an SHA-1 hash value for the data to be timestamped.
    attr_accessor :message_digest
    alias_method :attr_message_digest, :message_digest
    undef_method :message_digest
    alias_method :attr_message_digest=, :message_digest=
    undef_method :message_digest=
    
    # 
    # Parameters for the timestamping protocol.
    attr_accessor :ts_request_certificate
    alias_method :attr_ts_request_certificate, :ts_request_certificate
    undef_method :ts_request_certificate
    alias_method :attr_ts_request_certificate=, :ts_request_certificate=
    undef_method :ts_request_certificate=
    
    typesig { [] }
    # 
    # Instantiates a content signer that supports timestamped signatures.
    def initialize
      @tsa_url = nil
      @tsa_certificate = nil
      @message_digest = nil
      @ts_request_certificate = false
      super()
      @tsa_url = nil
      @tsa_certificate = nil
      @message_digest = nil
      @ts_request_certificate = true
    end
    
    typesig { [ContentSignerParameters, ::Java::Boolean, ::Java::Boolean] }
    # 
    # Generates a PKCS #7 signed data message that includes a signature
    # timestamp.
    # This method is used when a signature has already been generated.
    # The signature, a signature timestamp, the signer's certificate chain,
    # and optionally the content that was signed, are packaged into a PKCS #7
    # signed data message.
    # 
    # @param parameters The non-null input parameters.
    # @param omitContent true if the content should be omitted from the
    # signed data message. Otherwise the content is included.
    # @param applyTimestamp true if the signature should be timestamped.
    # Otherwise timestamping is not performed.
    # @return A PKCS #7 signed data message including a signature timestamp.
    # @throws NoSuchAlgorithmException The exception is thrown if the signature
    # algorithm is unrecognised.
    # @throws CertificateException The exception is thrown if an error occurs
    # while processing the signer's certificate or the TSA's
    # certificate.
    # @throws IOException The exception is thrown if an error occurs while
    # generating the signature timestamp or while generating the signed
    # data message.
    # @throws NullPointerException The exception is thrown if parameters is
    # null.
    def generate_signed_data(parameters, omit_content, apply_timestamp)
      if ((parameters).nil?)
        raise NullPointerException.new
      end
      # Parse the signature algorithm to extract the digest and key
      # algorithms. The expected format is:
      # "<digest>with<encryption>"
      # or  "<digest>with<encryption>and<mgf>"
      signature_algorithm = parameters.get_signature_algorithm
      digest_algorithm = nil
      key_algorithm = nil
      with = signature_algorithm.index_of("with")
      if (with > 0)
        digest_algorithm = (signature_algorithm.substring(0, with)).to_s
        and_ = signature_algorithm.index_of("and", with + 4)
        if (and_ > 0)
          key_algorithm = (signature_algorithm.substring(with + 4, and_)).to_s
        else
          key_algorithm = (signature_algorithm.substring(with + 4)).to_s
        end
      end
      digest_algorithm_id = AlgorithmId.get(digest_algorithm)
      # Examine signer's certificate
      signer_certificate_chain = parameters.get_signer_certificate_chain
      issuer_name = signer_certificate_chain[0].get_issuer_dn
      if (!(issuer_name.is_a?(X500Name)))
        # must extract the original encoded form of DN for subsequent
        # name comparison checks (converting to a String and back to
        # an encoded DN could cause the types of String attribute
        # values to be changed)
        tbs_cert = X509CertInfo.new(signer_certificate_chain[0].get_tbscertificate)
        issuer_name = tbs_cert.get((CertificateIssuerName::NAME).to_s + "." + (CertificateIssuerName::DN_NAME).to_s)
      end
      serial_number = signer_certificate_chain[0].get_serial_number
      # Include or exclude content
      content = parameters.get_content
      content_info = nil
      if (omit_content)
        content_info = ContentInfo.new(ContentInfo::DATA_OID, nil)
      else
        content_info = ContentInfo.new(content)
      end
      # Generate the timestamp token
      signature = parameters.get_signature
      signer_info = nil
      if (apply_timestamp)
        @tsa_certificate = parameters.get_timestamping_authority_certificate
        tsa_uri = parameters.get_timestamping_authority
        if (!(tsa_uri).nil?)
          @tsa_url = (tsa_uri.to_s).to_s
        else
          # Examine TSA cert
          cert_url = get_timestamping_url(@tsa_certificate)
          if ((cert_url).nil?)
            raise CertificateException.new("Subject Information Access extension not found")
          end
          @tsa_url = cert_url
        end
        # Timestamp the signature
        ts_token = generate_timestamp_token(signature)
        # Insert the timestamp token into the PKCS #7 signer info element
        # (as an unsigned attribute)
        unsigned_attrs = PKCS9Attributes.new(Array.typed(PKCS9Attribute).new([PKCS9Attribute.new(PKCS9Attribute::SIGNATURE_TIMESTAMP_TOKEN_STR, ts_token)]))
        signer_info = SignerInfo.new(issuer_name, serial_number, digest_algorithm_id, nil, AlgorithmId.get(key_algorithm), signature, unsigned_attrs)
      else
        signer_info = SignerInfo.new(issuer_name, serial_number, digest_algorithm_id, AlgorithmId.get(key_algorithm), signature)
      end
      signer_infos = Array.typed(SignerInfo).new([signer_info])
      algorithms = Array.typed(AlgorithmId).new([digest_algorithm_id])
      # Create the PKCS #7 signed data message
      p7 = PKCS7.new(algorithms, content_info, signer_certificate_chain, signer_infos)
      p7out = ByteArrayOutputStream.new
      p7.encode_signed_data(p7out)
      return p7out.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # 
      # Examine the certificate for a Subject Information Access extension
      # (<a href="http://www.ietf.org/rfc/rfc3280.txt">RFC 3280</a>).
      # The extension's <tt>accessMethod</tt> field should contain the object
      # identifier defined for timestamping: 1.3.6.1.5.5.7.48.3 and its
      # <tt>accessLocation</tt> field should contain an HTTP URL.
      # 
      # @param tsaCertificate An X.509 certificate for the TSA.
      # @return An HTTP URL or null if none was found.
      def get_timestamping_url(tsa_certificate)
        if ((tsa_certificate).nil?)
          return nil
        end
        # Parse the extensions
        begin
          extension_value = tsa_certificate.get_extension_value(SUBJECT_INFO_ACCESS_OID)
          if ((extension_value).nil?)
            return nil
          end
          der = DerInputStream.new(extension_value)
          der = DerInputStream.new(der.get_octet_string)
          der_value = der.get_sequence(5)
          description = nil
          location = nil
          uri = nil
          i = 0
          while i < der_value.attr_length
            description = AccessDescription.new(der_value[i])
            if ((description.get_access_method == AD_TIMESTAMPING_Id))
              location = description.get_access_location
              if ((location.get_type).equal?(GeneralNameInterface::NAME_URI))
                uri = location.get_name
                if (uri.get_scheme.equals_ignore_case("http"))
                  return uri.get_name
                end
              end
            end
            ((i += 1) - 1)
          end
        rescue IOException => ioe
          # ignore
        end
        return nil
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Returns a timestamp token from a TSA for the given content.
    # Performs a basic check on the token to confirm that it has been signed
    # by a certificate that is permitted to sign timestamps.
    # 
    # @param  toBeTimestamped The data to be timestamped.
    # @throws IOException The exception is throw if an error occurs while
    # communicating with the TSA.
    # @throws CertificateException The exception is throw if the TSA's
    # certificate is not permitted for timestamping.
    def generate_timestamp_token(to_be_timestamped)
      # Generate hash value for the data to be timestamped
      # SHA-1 is always used.
      if ((@message_digest).nil?)
        begin
          @message_digest = MessageDigest.get_instance("SHA-1")
        rescue NoSuchAlgorithmException => e
          # ignore
        end
      end
      digest_ = @message_digest.digest(to_be_timestamped)
      # Generate a timestamp
      ts_query = TSRequest.new(digest_, "SHA-1")
      # Generate a nonce
      nonce = nil
      if (!(RANDOM).nil?)
        nonce = BigInteger.new(64, RANDOM)
        ts_query.set_nonce(nonce)
      end
      ts_query.request_certificate(@ts_request_certificate)
      tsa = HttpTimestamper.new(@tsa_url) # use supplied TSA
      ts_reply = tsa.generate_timestamp(ts_query)
      status = ts_reply.get_status_code
      # Handle TSP error
      if (!(status).equal?(0) && !(status).equal?(1))
        failure_code = ts_reply.get_failure_code
        if ((failure_code).equal?(-1))
          raise IOException.new("Error generating timestamp: " + (ts_reply.get_status_code_as_text).to_s)
        else
          raise IOException.new("Error generating timestamp: " + (ts_reply.get_status_code_as_text).to_s + " " + (ts_reply.get_failure_code_as_text).to_s)
        end
      end
      ts_token = ts_reply.get_token
      tst = TimestampToken.new(ts_token.get_content_info.get_data)
      if (!(tst.get_hash_algorithm == AlgorithmId.new(ObjectIdentifier.new("1.3.14.3.2.26"))))
        raise IOException.new("Digest algorithm not SHA-1 in timestamp token")
      end
      if (!(Arrays == tst.get_hashed_message))
        raise IOException.new("Digest octets changed in timestamp token")
      end
      reply_nonce = tst.get_nonce
      if ((reply_nonce).nil? && !(nonce).nil?)
        raise IOException.new("Nonce missing in timestamp token")
      end
      if (!(reply_nonce).nil? && !(reply_nonce == nonce))
        raise IOException.new("Nonce changed in timestamp token")
      end
      # Examine the TSA's certificate (if present)
      key_purposes = nil
      certs = ts_token.get_certificates
      if (!(certs).nil? && certs.attr_length > 0)
        # Use certficate from the TSP reply
        # Pick out the cert for the TS server, which is the end-entity
        # one inside the chain.
        certs.each do |cert|
          is_signer = false
          certs.each do |cert2|
            if (!(cert).equal?(cert2))
              if ((cert.get_subject_dn == cert2.get_issuer_dn))
                is_signer = true
                break
              end
            end
          end
          if (!is_signer)
            key_purposes = cert.get_extended_key_usage
            if (!key_purposes.contains(KP_TIMESTAMPING_OID))
              raise CertificateException.new("Certificate is not valid for timestamping")
            end
            break
          end
        end
      end
      return ts_reply.get_encoded_token
    end
    
    private
    alias_method :initialize__timestamped_signer, :initialize
  end
  
end

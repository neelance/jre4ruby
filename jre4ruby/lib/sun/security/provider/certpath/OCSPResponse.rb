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
module Sun::Security::Provider::Certpath
  module OCSPResponseImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :PKIXParameters
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Iterator
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::X509
      include ::Sun::Security::Util
    }
  end
  
  # This class is used to process an OCSP response.
  # The OCSP Response is defined
  # in RFC 2560 and the ASN.1 encoding is as follows:
  # <pre>
  # 
  # OCSPResponse ::= SEQUENCE {
  # responseStatus         OCSPResponseStatus,
  # responseBytes          [0] EXPLICIT ResponseBytes OPTIONAL }
  # 
  # OCSPResponseStatus ::= ENUMERATED {
  # successful            (0),  --Response has valid confirmations
  # malformedRequest      (1),  --Illegal confirmation request
  # internalError         (2),  --Internal error in issuer
  # tryLater              (3),  --Try again later
  # --(4) is not used
  # sigRequired           (5),  --Must sign the request
  # unauthorized          (6)   --Request unauthorized
  # }
  # 
  # ResponseBytes ::=       SEQUENCE {
  # responseType   OBJECT IDENTIFIER,
  # response       OCTET STRING }
  # 
  # BasicOCSPResponse       ::= SEQUENCE {
  # tbsResponseData      ResponseData,
  # signatureAlgorithm   AlgorithmIdentifier,
  # signature            BIT STRING,
  # certs                [0] EXPLICIT SEQUENCE OF Certificate OPTIONAL }
  # 
  # The value for signature SHALL be computed on the hash of the DER
  # encoding ResponseData.
  # 
  # ResponseData ::= SEQUENCE {
  # version              [0] EXPLICIT Version DEFAULT v1,
  # responderID              ResponderID,
  # producedAt               GeneralizedTime,
  # responses                SEQUENCE OF SingleResponse,
  # responseExtensions   [1] EXPLICIT Extensions OPTIONAL }
  # 
  # ResponderID ::= CHOICE {
  # byName               [1] Name,
  # byKey                [2] KeyHash }
  # 
  # KeyHash ::= OCTET STRING -- SHA-1 hash of responder's public key
  # (excluding the tag and length fields)
  # 
  # SingleResponse ::= SEQUENCE {
  # certID                       CertID,
  # certStatus                   CertStatus,
  # thisUpdate                   GeneralizedTime,
  # nextUpdate         [0]       EXPLICIT GeneralizedTime OPTIONAL,
  # singleExtensions   [1]       EXPLICIT Extensions OPTIONAL }
  # 
  # CertStatus ::= CHOICE {
  # good        [0]     IMPLICIT NULL,
  # revoked     [1]     IMPLICIT RevokedInfo,
  # unknown     [2]     IMPLICIT UnknownInfo }
  # 
  # RevokedInfo ::= SEQUENCE {
  # revocationTime              GeneralizedTime,
  # revocationReason    [0]     EXPLICIT CRLReason OPTIONAL }
  # 
  # UnknownInfo ::= NULL -- this can be replaced with an enumeration
  # 
  # </pre>
  # 
  # @author      Ram Marti
  class OCSPResponse 
    include_class_members OCSPResponseImports
    
    class_module.module_eval {
      # Certificate status CHOICE
      const_set_lazy(:CERT_STATUS_GOOD) { 0 }
      const_attr_reader  :CERT_STATUS_GOOD
      
      const_set_lazy(:CERT_STATUS_REVOKED) { 1 }
      const_attr_reader  :CERT_STATUS_REVOKED
      
      const_set_lazy(:CERT_STATUS_UNKNOWN) { 2 }
      const_attr_reader  :CERT_STATUS_UNKNOWN
      
      const_set_lazy(:DEBUG) { Debug.get_instance("certpath") }
      const_attr_reader  :DEBUG
      
      const_set_lazy(:Dump) { false }
      const_attr_reader  :Dump
      
      when_class_loaded do
        tmp1 = nil
        tmp2 = nil
        begin
          tmp1 = ObjectIdentifier.new("1.3.6.1.5.5.7.48.1.1")
          tmp2 = ObjectIdentifier.new("1.3.6.1.5.5.7.48.1.2")
        rescue Exception => e
          # should not happen; log and exit
        end
        const_set :OCSP_BASIC_RESPONSE_OID, tmp1
        const_set :OCSP_NONCE_EXTENSION_OID, tmp2
      end
      
      # OCSP response status code
      const_set_lazy(:OCSP_RESPONSE_OK) { 0 }
      const_attr_reader  :OCSP_RESPONSE_OK
      
      # ResponderID CHOICE tags
      const_set_lazy(:NAME_TAG) { 1 }
      const_attr_reader  :NAME_TAG
      
      const_set_lazy(:KEY_TAG) { 2 }
      const_attr_reader  :KEY_TAG
      
      # Object identifier for the OCSPSigning key purpose
      const_set_lazy(:KP_OCSP_SIGNING_OID) { "1.3.6.1.5.5.7.3.9" }
      const_attr_reader  :KP_OCSP_SIGNING_OID
    }
    
    attr_accessor :single_response
    alias_method :attr_single_response, :single_response
    undef_method :single_response
    alias_method :attr_single_response=, :single_response=
    undef_method :single_response=
    
    typesig { [Array.typed(::Java::Byte), PKIXParameters, X509Certificate] }
    # Create an OCSP response from its ASN.1 DER encoding.
    # 
    # used by OCSPChecker
    def initialize(bytes, params, responder_cert)
      @single_response = nil
      begin
        response_status = 0
        response_type = nil
        version = 0
        responder_name = nil
        produced_at_date = nil
        sig_alg_id = nil
        ocsp_nonce = nil
        # OCSPResponse
        if (Dump)
          hex_enc = HexDumpEncoder.new
          System.out.println("OCSPResponse bytes are...")
          System.out.println(hex_enc.encode(bytes))
        end
        der = DerValue.new(bytes)
        if (!(der.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Bad encoding in OCSP response: " + "expected ASN.1 SEQUENCE tag.")
        end
        der_in = der.get_data
        # responseStatus
        response_status = der_in.get_enumerated
        if (!(DEBUG).nil?)
          DEBUG.println("OCSP response: " + (response_to_text(response_status)).to_s)
        end
        if (!(response_status).equal?(OCSP_RESPONSE_OK))
          raise CertPathValidatorException.new("OCSP Response Failure: " + (response_to_text(response_status)).to_s)
        end
        # responseBytes
        der = der_in.get_der_value
        if (!der.is_context_specific(0))
          raise IOException.new("Bad encoding in responseBytes element " + "of OCSP response: expected ASN.1 context specific tag 0.")
        end
        tmp = der.attr_data.get_der_value
        if (!(tmp.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Bad encoding in responseBytes element " + "of OCSP response: expected ASN.1 SEQUENCE tag.")
        end
        # responseType
        der_in = tmp.attr_data
        response_type = der_in.get_oid
        if ((response_type == OCSP_BASIC_RESPONSE_OID))
          if (!(DEBUG).nil?)
            DEBUG.println("OCSP response type: basic")
          end
        else
          if (!(DEBUG).nil?)
            DEBUG.println("OCSP response type: " + (response_type).to_s)
          end
          raise IOException.new("Unsupported OCSP response type: " + (response_type).to_s)
        end
        # BasicOCSPResponse
        basic_ocspresponse = DerInputStream.new(der_in.get_octet_string)
        seq_tmp = basic_ocspresponse.get_sequence(2)
        response_data = seq_tmp[0]
        # Need the DER encoded ResponseData to verify the signature later
        response_data_der = seq_tmp[0].to_byte_array
        # tbsResponseData
        if (!(response_data.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Bad encoding in tbsResponseData " + " element of OCSP response: expected ASN.1 SEQUENCE tag.")
        end
        seq_der_in = response_data.attr_data
        seq = seq_der_in.get_der_value
        # version
        if (seq.is_context_specific(0))
          # seq[0] is version
          if (seq.is_constructed && seq.is_context_specific)
            # System.out.println ("version is available");
            seq = seq.attr_data.get_der_value
            version = seq.get_integer
            if (!(seq.attr_data.available).equal?(0))
              raise IOException.new("Bad encoding in version " + " element of OCSP response: bad format")
            end
            seq = seq_der_in.get_der_value
          end
        end
        # responderID
        tag = (seq.attr_tag & 0x1f)
        if ((tag).equal?(NAME_TAG))
          responder_name = CertificateIssuerName.new(seq.get_data)
          if (!(DEBUG).nil?)
            DEBUG.println("OCSP Responder name: " + (responder_name).to_s)
          end
        else
          if ((tag).equal?(KEY_TAG))
            # Ignore, for now
          else
            raise IOException.new("Bad encoding in responderID element " + "of OCSP response: expected ASN.1 context specific tag 0 " + "or 1")
          end
        end
        # producedAt
        seq = seq_der_in.get_der_value
        produced_at_date = seq.get_generalized_time
        # responses
        single_response_der = seq_der_in.get_sequence(1)
        # Examine only the first response
        @single_response = SingleResponse.new_local(self, single_response_der[0])
        # responseExtensions
        if (seq_der_in.available > 0)
          seq = seq_der_in.get_der_value
          if (seq.is_context_specific(1))
            response_ext_der = seq.attr_data.get_sequence(3)
            response_extension = Array.typed(Extension).new(response_ext_der.attr_length) { nil }
            i = 0
            while i < response_ext_der.attr_length
              response_extension[i] = Extension.new(response_ext_der[i])
              if (!(DEBUG).nil?)
                DEBUG.println("OCSP extension: " + (response_extension[i]).to_s)
              end
              if (((response_extension[i].get_extension_id) == OCSP_NONCE_EXTENSION_OID))
                ocsp_nonce = response_extension[i].get_extension_value
              else
                if (response_extension[i].is_critical)
                  raise IOException.new("Unsupported OCSP critical extension: " + (response_extension[i].get_extension_id).to_s)
                end
              end
              i += 1
            end
          end
        end
        # signatureAlgorithmId
        sig_alg_id = AlgorithmId.parse(seq_tmp[1])
        # signature
        signature = seq_tmp[2].get_bit_string
        x509certs = nil
        # if seq[3] is available , then it is a sequence of certificates
        if (seq_tmp.attr_length > 3)
          # certs are available
          seq_cert = seq_tmp[3]
          if (!seq_cert.is_context_specific(0))
            raise IOException.new("Bad encoding in certs element " + "of OCSP response: expected ASN.1 context specific tag 0.")
          end
          certs = (seq_cert.get_data).get_sequence(3)
          x509certs = Array.typed(X509CertImpl).new(certs.attr_length) { nil }
          i = 0
          while i < certs.attr_length
            x509certs[i] = X509CertImpl.new(certs[i].to_byte_array)
            i += 1
          end
        end
        # Check whether the cert returned by the responder is trusted
        if (!(x509certs).nil? && !(x509certs[0]).nil?)
          cert = x509certs[0]
          # First check if the cert matches the responder cert which
          # was set locally.
          if ((cert == responder_cert))
            # cert is trusted, now verify the signed response
            # Next check if the cert was issued by the responder cert
            # which was set locally.
          else
            if ((cert.get_issuer_dn == responder_cert.get_subject_dn))
              # Check for the OCSPSigning key purpose
              key_purposes = cert.get_extended_key_usage
              if ((key_purposes).nil? || !key_purposes.contains(KP_OCSP_SIGNING_OID))
                if (!(DEBUG).nil?)
                  DEBUG.println("Responder's certificate is not " + "valid for signing OCSP responses.")
                end
                raise CertPathValidatorException.new("Responder's certificate not valid for signing " + "OCSP responses")
              end
              # verify the signature
              begin
                cert.verify(responder_cert.get_public_key)
                responder_cert = cert
                # cert is trusted, now verify the signed response
              rescue GeneralSecurityException => e
                responder_cert = nil
              end
            end
          end
        end
        # Confirm that the signed response was generated using the public
        # key from the trusted responder cert
        if (!(responder_cert).nil?)
          if (!verify_response(response_data_der, responder_cert, sig_alg_id, signature, params))
            if (!(DEBUG).nil?)
              DEBUG.println("Error verifying OCSP Responder's " + "signature")
            end
            raise CertPathValidatorException.new("Error verifying OCSP Responder's signature")
          end
        else
          # Need responder's cert in order to verify the signature
          if (!(DEBUG).nil?)
            DEBUG.println("Unable to verify OCSP Responder's " + "signature")
          end
          raise CertPathValidatorException.new("Unable to verify OCSP Responder's signature")
        end
      rescue CertPathValidatorException => cpve
        raise cpve
      rescue Exception => e
        raise CertPathValidatorException.new(e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), X509Certificate, AlgorithmId, Array.typed(::Java::Byte), PKIXParameters] }
    # Verify the signature of the OCSP response.
    # The responder's cert is implicitly trusted.
    def verify_response(response_data, cert, sig_alg_id, sign_bytes, params)
      begin
        resp_signature = Signature.get_instance(sig_alg_id.get_name)
        resp_signature.init_verify(cert)
        resp_signature.update(response_data)
        if (resp_signature.verify(sign_bytes))
          if (!(DEBUG).nil?)
            DEBUG.println("Verified signature of OCSP Responder")
          end
          return true
        else
          if (!(DEBUG).nil?)
            DEBUG.println("Error verifying signature of OCSP Responder")
          end
          return false
        end
      rescue InvalidKeyException => ike
        raise SignatureException.new(ike)
      rescue NoSuchAlgorithmException => nsae
        raise SignatureException.new(nsae)
      end
    end
    
    typesig { [SerialNumber] }
    # Return the revocation status code for a given certificate.
    # 
    # used by OCSPChecker
    def get_cert_status(sn)
      # ignore serial number for now; if we support multiple
      # requests/responses then it will be used
      return @single_response.get_status
    end
    
    typesig { [] }
    # used by OCSPChecker
    def get_cert_id
      return @single_response.get_cert_id
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Map an OCSP response status code to a string.
      def response_to_text(status)
        case (status)
        when 0
          return "Successful"
        when 1
          return "Malformed request"
        when 2
          return "Internal error"
        when 3
          return "Try again later"
        when 4
          return "Unused status code"
        when 5
          return "Request must be signed"
        when 6
          return "Request is unauthorized"
        else
          return ("Unknown status code: " + (status).to_s)
        end
      end
      
      typesig { [::Java::Int] }
      # Map a certificate's revocation status code to a string.
      # 
      # used by OCSPChecker
      def cert_status_to_text(cert_status)
        case (cert_status)
        when 0
          return "Good"
        when 1
          return "Revoked"
        when 2
          return "Unknown"
        else
          return ("Unknown certificate status code: " + (cert_status).to_s)
        end
      end
      
      # A class representing a single OCSP response.
      const_set_lazy(:SingleResponse) { Class.new do
        extend LocalClass
        include_class_members OCSPResponse
        
        attr_accessor :cert_id
        alias_method :attr_cert_id, :cert_id
        undef_method :cert_id
        alias_method :attr_cert_id=, :cert_id=
        undef_method :cert_id=
        
        attr_accessor :cert_status
        alias_method :attr_cert_status, :cert_status
        undef_method :cert_status
        alias_method :attr_cert_status=, :cert_status=
        undef_method :cert_status=
        
        attr_accessor :this_update
        alias_method :attr_this_update, :this_update
        undef_method :this_update
        alias_method :attr_this_update=, :this_update=
        undef_method :this_update=
        
        attr_accessor :next_update
        alias_method :attr_next_update, :next_update
        undef_method :next_update
        alias_method :attr_next_update=, :next_update=
        undef_method :next_update=
        
        typesig { [DerValue] }
        def initialize(der)
          @cert_id = nil
          @cert_status = 0
          @this_update = nil
          @next_update = nil
          if (!(der.attr_tag).equal?(DerValue.attr_tag_sequence))
            raise IOException.new("Bad ASN.1 encoding in SingleResponse")
          end
          tmp = der.attr_data
          @cert_id = CertId.new(tmp.get_der_value.attr_data)
          der_val = tmp.get_der_value
          tag = (der_val.attr_tag & 0x1f)
          if ((tag).equal?(CERT_STATUS_GOOD))
            @cert_status = CERT_STATUS_GOOD
          else
            if ((tag).equal?(CERT_STATUS_REVOKED))
              @cert_status = CERT_STATUS_REVOKED
              # RevokedInfo
              if (!(DEBUG).nil?)
                revocation_time = der_val.attr_data.get_generalized_time
                DEBUG.println("Revocation time: " + (revocation_time).to_s)
              end
            else
              if ((tag).equal?(CERT_STATUS_UNKNOWN))
                @cert_status = CERT_STATUS_UNKNOWN
              else
                raise IOException.new("Invalid certificate status")
              end
            end
          end
          @this_update = tmp.get_generalized_time
          if ((tmp.available).equal?(0))
            # we are done
          else
            der_val = tmp.get_der_value
            tag = (der_val.attr_tag & 0x1f)
            if ((tag).equal?(0))
              # next update
              @next_update = der_val.attr_data.get_generalized_time
              if ((tmp.available).equal?(0))
                return
              else
                der_val = tmp.get_der_value
                tag = (der_val.attr_tag & 0x1f)
              end
            end
            # ignore extensions
          end
          now = Date.new
          if (!(DEBUG).nil?)
            until_ = ""
            if (!(@next_update).nil?)
              until_ = " until " + (@next_update).to_s
            end
            DEBUG.println("Response's validity interval is from " + (@this_update).to_s + until_)
          end
          # Check that the test date is within the validity interval
          if ((!(@this_update).nil? && now.before(@this_update)) || (!(@next_update).nil? && now.after(@next_update)))
            if (!(DEBUG).nil?)
              DEBUG.println("Response is unreliable: its validity " + "interval is out-of-date")
            end
            raise IOException.new("Response is unreliable: its validity " + "interval is out-of-date")
          end
        end
        
        typesig { [] }
        # Return the certificate's revocation status code
        def get_status
          return @cert_status
        end
        
        typesig { [] }
        def get_cert_id
          return @cert_id
        end
        
        typesig { [] }
        # Construct a string representation of a single OCSP response.
        def to_s
          sb = StringBuilder.new
          sb.append("SingleResponse:  \n")
          sb.append(@cert_id)
          sb.append("\nCertStatus: " + (cert_status_to_text(get_cert_status(nil))).to_s + "\n")
          sb.append("thisUpdate is " + (@this_update).to_s + "\n")
          if (!(@next_update).nil?)
            sb.append("nextUpdate is " + (@next_update).to_s + "\n")
          end
          return sb.to_s
        end
        
        private
        alias_method :initialize__single_response, :initialize
      end }
    }
    
    private
    alias_method :initialize__ocspresponse, :initialize
  end
  
end

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
  module OCSPCheckerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Security
      include ::Java::Security::Cert
      include ::Java::Net
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include ::Sun::Security::Util
      include ::Sun::Security::X509
    }
  end
  
  # OCSPChecker is a <code>PKIXCertPathChecker</code> that uses the
  # Online Certificate Status Protocol (OCSP) as specified in RFC 2560
  # <a href="http://www.ietf.org/rfc/rfc2560.txt">
  # http://www.ietf.org/rfc/rfc2560.txt</a>.
  # 
  # @author      Ram Marti
  class OCSPChecker < OCSPCheckerImports.const_get :PKIXCertPathChecker
    include_class_members OCSPCheckerImports
    
    class_module.module_eval {
      const_set_lazy(:OCSP_ENABLE_PROP) { "ocsp.enable" }
      const_attr_reader  :OCSP_ENABLE_PROP
      
      const_set_lazy(:OCSP_URL_PROP) { "ocsp.responderURL" }
      const_attr_reader  :OCSP_URL_PROP
      
      const_set_lazy(:OCSP_CERT_SUBJECT_PROP) { "ocsp.responderCertSubjectName" }
      const_attr_reader  :OCSP_CERT_SUBJECT_PROP
      
      const_set_lazy(:OCSP_CERT_ISSUER_PROP) { "ocsp.responderCertIssuerName" }
      const_attr_reader  :OCSP_CERT_ISSUER_PROP
      
      const_set_lazy(:OCSP_CERT_NUMBER_PROP) { "ocsp.responderCertSerialNumber" }
      const_attr_reader  :OCSP_CERT_NUMBER_PROP
      
      const_set_lazy(:HEX_DIGITS) { "0123456789ABCDEFabcdef" }
      const_attr_reader  :HEX_DIGITS
      
      const_set_lazy(:DEBUG) { Debug.get_instance("certpath") }
      const_attr_reader  :DEBUG
      
      const_set_lazy(:Dump) { false }
      const_attr_reader  :Dump
      
      # Supported extensions
      const_set_lazy(:OCSP_NONCE_DATA) { Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 48, 1, 2]) }
      const_attr_reader  :OCSP_NONCE_DATA
      
      when_class_loaded do
        const_set :OCSP_NONCE_OID, ObjectIdentifier.new_internal(OCSP_NONCE_DATA)
      end
    }
    
    attr_accessor :remaining_certs
    alias_method :attr_remaining_certs, :remaining_certs
    undef_method :remaining_certs
    alias_method :attr_remaining_certs=, :remaining_certs=
    undef_method :remaining_certs=
    
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    attr_accessor :cp
    alias_method :attr_cp, :cp
    undef_method :cp
    alias_method :attr_cp=, :cp=
    undef_method :cp=
    
    attr_accessor :pkix_params
    alias_method :attr_pkix_params, :pkix_params
    undef_method :pkix_params
    alias_method :attr_pkix_params=, :pkix_params=
    undef_method :pkix_params=
    
    typesig { [CertPath, PKIXParameters] }
    # Default Constructor
    # 
    # @param certPath the X509 certification path
    # @param pkixParams the input PKIX parameter set
    # @exception CertPathValidatorException Exception thrown if cert path
    # does not validate.
    def initialize(cert_path, pkix_params)
      @remaining_certs = 0
      @certs = nil
      @cp = nil
      @pkix_params = nil
      super()
      @cp = cert_path
      @pkix_params = pkix_params
      tmp = @cp.get_certificates
      @certs = tmp.to_array(Array.typed(X509Certificate).new(tmp.size) { nil })
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    # Initializes the internal state of the checker from parameters
    # specified in the constructor
    def init(forward)
      if (!forward)
        @remaining_certs = @certs.attr_length
      else
        raise CertPathValidatorException.new("Forward checking not supported")
      end
    end
    
    typesig { [] }
    def is_forward_checking_supported
      return false
    end
    
    typesig { [] }
    def get_supported_extensions
      return Collections.empty_set
    end
    
    typesig { [Certificate, Collection] }
    # Sends an OCSPRequest for the certificate to the OCSP Server and
    # processes the response back from the OCSP Server.
    # 
    # @param cert the Certificate
    # @param unresolvedCritExts the unresolved critical extensions
    # @exception CertPathValidatorException Exception is thrown if the
    # certificate has been revoked.
    def check(cert, unresolved_crit_exts)
      in_ = nil
      out = nil
      begin
        # Examine OCSP properties
        responder_cert = nil
        seek_responder_cert = false
        responder_subject_name = nil
        responder_issuer_name = nil
        responder_serial_number = nil
        # OCSP security property values, in the following order:
        # 1. ocsp.responderURL
        # 2. ocsp.responderCertSubjectName
        # 3. ocsp.responderCertIssuerName
        # 4. ocsp.responderCertSerialNumber
        properties = get_ocspproperties
        # When responder's subject name is set then the issuer/serial
        # properties are ignored
        if (!(properties[1]).nil?)
          responder_subject_name = X500Principal.new(properties[1])
        else
          if (!(properties[2]).nil? && !(properties[3]).nil?)
            responder_issuer_name = X500Principal.new(properties[2])
            # remove colon or space separators
            value = strip_out_separators(properties[3])
            responder_serial_number = BigInteger.new(value, 16)
          else
            if (!(properties[2]).nil? || !(properties[3]).nil?)
              raise CertPathValidatorException.new("Must specify both ocsp.responderCertIssuerName and " + "ocsp.responderCertSerialNumber properties")
            end
          end
        end
        # If the OCSP responder cert properties are set then the
        # identified cert must be located in the trust anchors or
        # in the cert stores.
        if (!(responder_subject_name).nil? || !(responder_issuer_name).nil?)
          seek_responder_cert = true
        end
        seek_issuer_cert = true
        issuer_cert_impl = nil
        curr_cert_impl = X509CertImpl.to_impl(cert)
        @remaining_certs -= 1
        # Set the issuer certificate
        if (!(@remaining_certs).equal?(0))
          issuer_cert_impl = X509CertImpl.to_impl(@certs[@remaining_certs])
          seek_issuer_cert = false # done
          # By default, the OCSP responder's cert is the same as the
          # issuer of the cert being validated.
          if (!seek_responder_cert)
            responder_cert = @certs[@remaining_certs]
            if (!(DEBUG).nil?)
              DEBUG.println("Responder's certificate is the same " + "as the issuer of the certificate being validated")
            end
          end
        end
        # Check anchor certs for:
        # - the issuer cert (of the cert being validated)
        # - the OCSP responder's cert
        if (seek_issuer_cert || seek_responder_cert)
          if (!(DEBUG).nil? && seek_responder_cert)
            DEBUG.println("Searching trust anchors for responder's " + "certificate")
          end
          # Extract the anchor certs
          anchors = @pkix_params.get_trust_anchors.iterator
          if (!anchors.has_next)
            raise CertPathValidatorException.new("Must specify at least one trust anchor")
          end
          cert_issuer_name = curr_cert_impl.get_issuer_x500principal
          while (anchors.has_next && (seek_issuer_cert || seek_responder_cert))
            anchor = anchors.next_
            anchor_cert = anchor.get_trusted_cert
            anchor_subject_name = anchor_cert.get_subject_x500principal
            if (Dump)
              System.out.println("Issuer DN is " + RJava.cast_to_string(cert_issuer_name))
              System.out.println("Subject DN is " + RJava.cast_to_string(anchor_subject_name))
            end
            # Check if anchor cert is the issuer cert
            if (seek_issuer_cert && (cert_issuer_name == anchor_subject_name))
              issuer_cert_impl = X509CertImpl.to_impl(anchor_cert)
              seek_issuer_cert = false # done
              # By default, the OCSP responder's cert is the same as
              # the issuer of the cert being validated.
              if (!seek_responder_cert && (responder_cert).nil?)
                responder_cert = anchor_cert
                if (!(DEBUG).nil?)
                  DEBUG.println("Responder's certificate is the" + " same as the issuer of the certificate " + "being validated")
                end
              end
            end
            # Check if anchor cert is the responder cert
            if (seek_responder_cert)
              # Satisfy the responder subject name property only, or
              # satisfy the responder issuer name and serial number
              # properties only
              if ((!(responder_subject_name).nil? && (responder_subject_name == anchor_subject_name)) || (!(responder_issuer_name).nil? && !(responder_serial_number).nil? && (responder_issuer_name == anchor_cert.get_issuer_x500principal) && (responder_serial_number == anchor_cert.get_serial_number)))
                responder_cert = anchor_cert
                seek_responder_cert = false # done
              end
            end
          end
          if ((issuer_cert_impl).nil?)
            raise CertPathValidatorException.new("No trusted certificate for " + RJava.cast_to_string(curr_cert_impl.get_issuer_dn))
          end
          # Check cert stores if responder cert has not yet been found
          if (seek_responder_cert)
            if (!(DEBUG).nil?)
              DEBUG.println("Searching cert stores for responder's " + "certificate")
            end
            filter = nil
            if (!(responder_subject_name).nil?)
              filter = X509CertSelector.new
              filter.set_subject(responder_subject_name.get_name)
            else
              if (!(responder_issuer_name).nil? && !(responder_serial_number).nil?)
                filter = X509CertSelector.new
                filter.set_issuer(responder_issuer_name.get_name)
                filter.set_serial_number(responder_serial_number)
              end
            end
            if (!(filter).nil?)
              cert_stores = @pkix_params.get_cert_stores
              cert_stores.each do |certStore|
                i = cert_store.get_certificates(filter).iterator
                if (i.has_next)
                  responder_cert = i.next_
                  seek_responder_cert = false # done
                  break
                end
              end
            end
          end
        end
        # Could not find the certificate identified in the OCSP properties
        if (seek_responder_cert)
          raise CertPathValidatorException.new("Cannot find the responder's certificate " + "(set using the OCSP security properties).")
        end
        # Construct an OCSP Request
        ocsp_request = OCSPRequest.new(curr_cert_impl, issuer_cert_impl)
        url = get_ocspserver_url(curr_cert_impl, properties)
        con = url.open_connection
        if (!(DEBUG).nil?)
          DEBUG.println("connecting to OCSP service at: " + RJava.cast_to_string(url))
        end
        # Indicate that both input and output will be performed,
        # that the method is POST, and that the content length is
        # the length of the byte array
        con.set_do_output(true)
        con.set_do_input(true)
        con.set_request_method("POST")
        con.set_request_property("Content-type", "application/ocsp-request")
        bytes = ocsp_request.encode_bytes
        cert_id = ocsp_request.get_cert_id
        con.set_request_property("Content-length", String.value_of(bytes.attr_length))
        out = con.get_output_stream
        out.write(bytes)
        out.flush
        # Check the response
        if (!(DEBUG).nil? && !(con.get_response_code).equal?(HttpURLConnection::HTTP_OK))
          DEBUG.println("Received HTTP error: " + RJava.cast_to_string(con.get_response_code) + " - " + RJava.cast_to_string(con.get_response_message))
        end
        in_ = con.get_input_stream
        content_length = con.get_content_length
        if ((content_length).equal?(-1))
          content_length = JavaInteger::MAX_VALUE
        end
        response = Array.typed(::Java::Byte).new(content_length) { 0 }
        total = 0
        count = 0
        while (!(count).equal?(-1) && total < content_length)
          count = in_.read(response, total, response.attr_length - total)
          total += count
        end
        ocsp_response = OCSPResponse.new(response, @pkix_params, responder_cert)
        # Check that response applies to the cert that was supplied
        if (!(cert_id == ocsp_response.get_cert_id))
          raise CertPathValidatorException.new("Certificate in the OCSP response does not match the " + "certificate supplied in the OCSP request.")
        end
        serial_number = curr_cert_impl.get_serial_number_object
        cert_ocspstatus = ocsp_response.get_cert_status(serial_number)
        if (!(DEBUG).nil?)
          DEBUG.println("Status of certificate (with serial number " + RJava.cast_to_string(serial_number.get_number) + ") is: " + RJava.cast_to_string(OCSPResponse.cert_status_to_text(cert_ocspstatus)))
        end
        if ((cert_ocspstatus).equal?(OCSPResponse::CERT_STATUS_REVOKED))
          raise CertificateRevokedException.new("Certificate has been revoked", @cp, @remaining_certs)
        else
          if ((cert_ocspstatus).equal?(OCSPResponse::CERT_STATUS_UNKNOWN))
            raise CertPathValidatorException.new("Certificate's revocation status is unknown", nil, @cp, @remaining_certs)
          end
        end
      rescue CertificateRevokedException => cre
        raise cre
      rescue CertPathValidatorException => cpve
        raise cpve
      rescue JavaException => e
        raise CertPathValidatorException.new(e)
      ensure
        if (!(in_).nil?)
          begin
            in_.close
          rescue IOException => ioe
            raise CertPathValidatorException.new(ioe)
          end
        end
        if (!(out).nil?)
          begin
            out.close
          rescue IOException => ioe
            raise CertPathValidatorException.new(ioe)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [X509CertImpl, Array.typed(String)] }
      # The OCSP security property values are in the following order:
      # 1. ocsp.responderURL
      # 2. ocsp.responderCertSubjectName
      # 3. ocsp.responderCertIssuerName
      # 4. ocsp.responderCertSerialNumber
      def get_ocspserver_url(curr_cert_impl, properties)
        if (!(properties[0]).nil?)
          begin
            return URL.new(properties[0])
          rescue Java::Net::MalformedURLException => e
            raise CertPathValidatorException.new(e)
          end
        end
        # Examine the certificate's AuthorityInfoAccess extension
        aia = curr_cert_impl.get_authority_info_access_extension
        if ((aia).nil?)
          raise CertPathValidatorException.new("Must specify the location of an OCSP Responder")
        end
        descriptions = aia.get_access_descriptions
        descriptions.each do |description|
          if ((description.get_access_method == AccessDescription::Ad_OCSP_Id))
            general_name = description.get_access_location
            if ((general_name.get_type).equal?(GeneralNameInterface::NAME_URI))
              begin
                uri = general_name.get_name
                return (URL.new(uri.get_name))
              rescue Java::Net::MalformedURLException => e
                raise CertPathValidatorException.new(e)
              end
            end
          end
        end
        raise CertPathValidatorException.new("Cannot find the location of the OCSP Responder")
      end
      
      typesig { [] }
      # Retrieves the values of the OCSP security properties.
      def get_ocspproperties
        properties = Array.typed(String).new(4) { nil }
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members OCSPChecker
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            properties[0] = Security.get_property(OCSP_URL_PROP)
            properties[1] = Security.get_property(OCSP_CERT_SUBJECT_PROP)
            properties[2] = Security.get_property(OCSP_CERT_ISSUER_PROP)
            properties[3] = Security.get_property(OCSP_CERT_NUMBER_PROP)
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return properties
      end
      
      typesig { [String] }
      # Removes any non-hexadecimal characters from a string.
      def strip_out_separators(value)
        chars = value.to_char_array
        hex_number = StringBuilder.new
        i = 0
        while i < chars.attr_length
          if (!(HEX_DIGITS.index_of(chars[i])).equal?(-1))
            hex_number.append(chars[i])
          end
          i += 1
        end
        return hex_number.to_s
      end
    }
    
    private
    alias_method :initialize__ocspchecker, :initialize
  end
  
  # Indicates that the identified certificate has been revoked.
  class CertificateRevokedException < OCSPCheckerImports.const_get :CertPathValidatorException
    include_class_members OCSPCheckerImports
    
    typesig { [String, CertPath, ::Java::Int] }
    def initialize(msg, cert_path, index)
      super(msg, nil, cert_path, index)
    end
    
    private
    alias_method :initialize__certificate_revoked_exception, :initialize
  end
  
end

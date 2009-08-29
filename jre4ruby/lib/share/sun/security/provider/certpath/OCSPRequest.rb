require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OCSPRequestImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::X509
      include ::Sun::Security::Util
    }
  end
  
  # This class can be used to generate an OCSP request and send it over
  # an outputstream. Currently we do not support signing requests
  # The OCSP Request is specified in RFC 2560 and
  # the ASN.1 definition is as follows:
  # <pre>
  # 
  # OCSPRequest     ::=     SEQUENCE {
  # tbsRequest                  TBSRequest,
  # optionalSignature   [0]     EXPLICIT Signature OPTIONAL }
  # 
  # TBSRequest      ::=     SEQUENCE {
  # version             [0]     EXPLICIT Version DEFAULT v1,
  # requestorName       [1]     EXPLICIT GeneralName OPTIONAL,
  # requestList                 SEQUENCE OF Request,
  # requestExtensions   [2]     EXPLICIT Extensions OPTIONAL }
  # 
  # Signature       ::=     SEQUENCE {
  # signatureAlgorithm      AlgorithmIdentifier,
  # signature               BIT STRING,
  # certs               [0] EXPLICIT SEQUENCE OF Certificate OPTIONAL
  # }
  # 
  # Version         ::=             INTEGER  {  v1(0) }
  # 
  # Request         ::=     SEQUENCE {
  # reqCert                     CertID,
  # singleRequestExtensions     [0] EXPLICIT Extensions OPTIONAL }
  # 
  # CertID          ::= SEQUENCE {
  # hashAlgorithm  AlgorithmIdentifier,
  # issuerNameHash OCTET STRING, -- Hash of Issuer's DN
  # issuerKeyHash  OCTET STRING, -- Hash of Issuers public key
  # serialNumber   CertificateSerialNumber
  # }
  # 
  # </pre>
  # 
  # @author      Ram Marti
  class OCSPRequest 
    include_class_members OCSPRequestImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      const_set_lazy(:Dump) { false }
      const_attr_reader  :Dump
    }
    
    # Serial number of the certificates to be checked for revocation
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    # Issuer's certificate (for computing certId hash values)
    attr_accessor :issuer_cert
    alias_method :attr_issuer_cert, :issuer_cert
    undef_method :issuer_cert
    alias_method :attr_issuer_cert=, :issuer_cert=
    undef_method :issuer_cert=
    
    # CertId of the certificate to be checked
    attr_accessor :cert_id
    alias_method :attr_cert_id, :cert_id
    undef_method :cert_id
    alias_method :attr_cert_id=, :cert_id=
    undef_method :cert_id=
    
    typesig { [X509CertImpl, X509CertImpl] }
    # Constructs an OCSPRequest. This constructor is used
    # to construct an unsigned OCSP Request for a single user cert.
    # 
    # used by OCSPChecker
    def initialize(user_cert, issuer_cert)
      @serial_number = nil
      @issuer_cert = nil
      @cert_id = nil
      if ((issuer_cert).nil?)
        raise CertPathValidatorException.new("Null IssuerCertificate")
      end
      @issuer_cert = issuer_cert
      @serial_number = user_cert.get_serial_number_object
    end
    
    typesig { [] }
    # used by OCSPChecker
    def encode_bytes
      # encode tbsRequest
      tmp = DerOutputStream.new
      der_single_req_list = DerOutputStream.new
      single_request = nil
      begin
        single_request = SingleRequest.new(@issuer_cert, @serial_number)
      rescue JavaException => e
        raise IOException.new("Error encoding OCSP request")
      end
      @cert_id = single_request.get_cert_id
      single_request.encode(der_single_req_list)
      tmp.write(DerValue.attr_tag_sequence, der_single_req_list)
      # No extensions supported
      tbs_request = DerOutputStream.new
      tbs_request.write(DerValue.attr_tag_sequence, tmp)
      # OCSPRequest without the signature
      ocsp_request = DerOutputStream.new
      ocsp_request.write(DerValue.attr_tag_sequence, tbs_request)
      bytes = ocsp_request.to_byte_array
      if (Dump)
        hex_enc = HexDumpEncoder.new
        System.out.println("OCSPRequest bytes are... ")
        System.out.println(hex_enc.encode(bytes))
      end
      return (bytes)
    end
    
    typesig { [] }
    # used by OCSPChecker
    def get_cert_id
      return @cert_id
    end
    
    class_module.module_eval {
      const_set_lazy(:SingleRequest) { Class.new do
        include_class_members OCSPRequest
        
        attr_accessor :cert_id
        alias_method :attr_cert_id, :cert_id
        undef_method :cert_id
        alias_method :attr_cert_id=, :cert_id=
        undef_method :cert_id=
        
        typesig { [class_self::X509CertImpl, class_self::SerialNumber] }
        # No extensions are set
        def initialize(cert, serial_no)
          @cert_id = nil
          @cert_id = self.class::CertId.new(cert, serial_no)
        end
        
        typesig { [class_self::DerOutputStream] }
        def encode(out)
          tmp = self.class::DerOutputStream.new
          @cert_id.encode(tmp)
          out.write(DerValue.attr_tag_sequence, tmp)
        end
        
        typesig { [] }
        def get_cert_id
          return @cert_id
        end
        
        private
        alias_method :initialize__single_request, :initialize
      end }
    }
    
    private
    alias_method :initialize__ocsprequest, :initialize
  end
  
end

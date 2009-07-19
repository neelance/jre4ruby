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
module Sun::Security::Pkcs
  module SigningCertificateInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :ArrayList
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::X509, :GeneralNames
      include_const ::Sun::Security::X509, :SerialNumber
    }
  end
  
  # This class represents a signing certificate attribute.
  # Its attribute value is defined by the following ASN.1 definition.
  # <pre>
  # 
  # id-aa-signingCertificate OBJECT IDENTIFIER ::= { iso(1)
  # member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs9(9)
  # smime(16) id-aa(2) 12 }
  # 
  # SigningCertificate ::=  SEQUENCE {
  # certs       SEQUENCE OF ESSCertID,
  # policies    SEQUENCE OF PolicyInformation OPTIONAL
  # }
  # 
  # ESSCertID ::=  SEQUENCE {
  # certHash        Hash,
  # issuerSerial    IssuerSerial OPTIONAL
  # }
  # 
  # Hash ::= OCTET STRING -- SHA1 hash of entire certificate
  # 
  # IssuerSerial ::= SEQUENCE {
  # issuer         GeneralNames,
  # serialNumber   CertificateSerialNumber
  # }
  # 
  # PolicyInformation ::= SEQUENCE {
  # policyIdentifier   CertPolicyId,
  # policyQualifiers   SEQUENCE SIZE (1..MAX) OF
  # PolicyQualifierInfo OPTIONAL }
  # 
  # CertPolicyId ::= OBJECT IDENTIFIER
  # 
  # PolicyQualifierInfo ::= SEQUENCE {
  # policyQualifierId  PolicyQualifierId,
  # qualifier        ANY DEFINED BY policyQualifierId }
  # 
  # -- Implementations that recognize additional policy qualifiers MUST
  # -- augment the following definition for PolicyQualifierId
  # 
  # PolicyQualifierId ::= OBJECT IDENTIFIER ( id-qt-cps | id-qt-unotice )
  # 
  # </pre>
  # 
  # @since 1.5
  # @author Vincent Ryan
  class SigningCertificateInfo 
    include_class_members SigningCertificateInfoImports
    
    attr_accessor :ber
    alias_method :attr_ber, :ber
    undef_method :ber
    alias_method :attr_ber=, :ber=
    undef_method :ber=
    
    attr_accessor :cert_id
    alias_method :attr_cert_id, :cert_id
    undef_method :cert_id
    alias_method :attr_cert_id=, :cert_id=
    undef_method :cert_id=
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(ber)
      @ber = nil
      @cert_id = nil
      parse(ber)
    end
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new
      buffer.append("[\n")
      i = 0
      while i < @cert_id.attr_length
        buffer.append(@cert_id[i].to_s)
        ((i += 1) - 1)
      end
      # format policies as a string
      buffer.append("\n]")
      return buffer.to_s
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def parse(bytes)
      # Parse signingCertificate
      der_value = DerValue.new(bytes)
      if (!(der_value.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Bad encoding for signingCertificate")
      end
      # Parse certs
      certs = der_value.attr_data.get_sequence(1)
      @cert_id = Array.typed(ESSCertId).new(certs.attr_length) { nil }
      i = 0
      while i < certs.attr_length
        @cert_id[i] = ESSCertId.new(certs[i])
        ((i += 1) - 1)
      end
      # Parse policies, if present
      if (der_value.attr_data.available > 0)
        policies = der_value.attr_data.get_sequence(1)
        i_ = 0
        while i_ < policies.attr_length
          ((i_ += 1) - 1)
        end
      end
    end
    
    private
    alias_method :initialize__signing_certificate_info, :initialize
  end
  
  class ESSCertId 
    include_class_members SigningCertificateInfoImports
    
    class_module.module_eval {
      
      def hex_dumper
        defined?(@@hex_dumper) ? @@hex_dumper : @@hex_dumper= nil
      end
      alias_method :attr_hex_dumper, :hex_dumper
      
      def hex_dumper=(value)
        @@hex_dumper = value
      end
      alias_method :attr_hex_dumper=, :hex_dumper=
    }
    
    attr_accessor :cert_hash
    alias_method :attr_cert_hash, :cert_hash
    undef_method :cert_hash
    alias_method :attr_cert_hash=, :cert_hash=
    undef_method :cert_hash=
    
    attr_accessor :issuer
    alias_method :attr_issuer, :issuer
    undef_method :issuer
    alias_method :attr_issuer=, :issuer=
    undef_method :issuer=
    
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    typesig { [DerValue] }
    def initialize(cert_id)
      @cert_hash = nil
      @issuer = nil
      @serial_number = nil
      # Parse certHash
      @cert_hash = cert_id.attr_data.get_der_value.to_byte_array
      # Parse issuerSerial, if present
      if (cert_id.attr_data.available > 0)
        issuer_serial = cert_id.attr_data.get_der_value
        # Parse issuer
        @issuer = GeneralNames.new(issuer_serial.attr_data.get_der_value)
        # Parse serialNumber
        @serial_number = SerialNumber.new(issuer_serial.attr_data.get_der_value)
      end
    end
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new
      buffer.append("[\n\tCertificate hash (SHA-1):\n")
      if ((self.attr_hex_dumper).nil?)
        self.attr_hex_dumper = HexDumpEncoder.new
      end
      buffer.append(self.attr_hex_dumper.encode(@cert_hash))
      if (!(@issuer).nil? && !(@serial_number).nil?)
        buffer.append("\n\tIssuer: " + (@issuer).to_s + "\n")
        buffer.append("\t" + (@serial_number).to_s)
      end
      buffer.append("\n]")
      return buffer.to_s
    end
    
    private
    alias_method :initialize__esscert_id, :initialize
  end
  
end

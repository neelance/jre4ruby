require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module X509CRLEntryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :CRLException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509CRLEntry
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashSet
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include ::Sun::Security::Util
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # <p>Abstract class for a revoked certificate in a CRL.
  # This class is for each entry in the <code>revokedCertificates</code>,
  # so it deals with the inner <em>SEQUENCE</em>.
  # The ASN.1 definition for this is:
  # <pre>
  # revokedCertificates    SEQUENCE OF SEQUENCE  {
  # userCertificate    CertificateSerialNumber,
  # revocationDate     ChoiceOfTime,
  # crlEntryExtensions Extensions OPTIONAL
  # -- if present, must be v2
  # }  OPTIONAL
  # 
  # CertificateSerialNumber  ::=  INTEGER
  # 
  # Extensions  ::=  SEQUENCE SIZE (1..MAX) OF Extension
  # 
  # Extension  ::=  SEQUENCE  {
  # extnId        OBJECT IDENTIFIER,
  # critical      BOOLEAN DEFAULT FALSE,
  # extnValue     OCTET STRING
  # -- contains a DER encoding of a value
  # -- of the type registered for use with
  # -- the extnId object identifier value
  # }
  # </pre>
  # 
  # @author Hemma Prafullchandra
  class X509CRLEntryImpl < X509CRLEntryImplImports.const_get :X509CRLEntry
    include_class_members X509CRLEntryImplImports
    
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    attr_accessor :revocation_date
    alias_method :attr_revocation_date, :revocation_date
    undef_method :revocation_date
    alias_method :attr_revocation_date=, :revocation_date=
    undef_method :revocation_date=
    
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    attr_accessor :revoked_cert
    alias_method :attr_revoked_cert, :revoked_cert
    undef_method :revoked_cert
    alias_method :attr_revoked_cert=, :revoked_cert=
    undef_method :revoked_cert=
    
    attr_accessor :cert_issuer
    alias_method :attr_cert_issuer, :cert_issuer
    undef_method :cert_issuer
    alias_method :attr_cert_issuer=, :cert_issuer=
    undef_method :cert_issuer=
    
    class_module.module_eval {
      const_set_lazy(:IsExplicit) { false }
      const_attr_reader  :IsExplicit
      
      const_set_lazy(:YR_2050) { 2524636800000 }
      const_attr_reader  :YR_2050
    }
    
    typesig { [BigInteger, Date] }
    # Constructs a revoked certificate entry using the given
    # serial number and revocation date.
    # 
    # @param num the serial number of the revoked certificate.
    # @param date the Date on which revocation took place.
    def initialize(num, date)
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @cert_issuer = nil
      super()
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @serial_number = SerialNumber.new(num)
      @revocation_date = date
    end
    
    typesig { [BigInteger, Date, CRLExtensions] }
    # Constructs a revoked certificate entry using the given
    # serial number, revocation date and the entry
    # extensions.
    # 
    # @param num the serial number of the revoked certificate.
    # @param date the Date on which revocation took place.
    # @param crlEntryExts the extensions for this entry.
    def initialize(num, date, crl_entry_exts)
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @cert_issuer = nil
      super()
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @serial_number = SerialNumber.new(num)
      @revocation_date = date
      @extensions = crl_entry_exts
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Unmarshals a revoked certificate from its encoded form.
    # 
    # @param revokedCert the encoded bytes.
    # @exception CRLException on parsing errors.
    def initialize(revoked_cert)
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @cert_issuer = nil
      super()
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      begin
        parse(DerValue.new(revoked_cert))
      rescue IOException => e
        @revoked_cert = nil
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.to_s))
      end
    end
    
    typesig { [DerValue] }
    # Unmarshals a revoked certificate from its encoded form.
    # 
    # @param derVal the DER value containing the revoked certificate.
    # @exception CRLException on parsing errors.
    def initialize(der_value)
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      @cert_issuer = nil
      super()
      @serial_number = nil
      @revocation_date = nil
      @extensions = nil
      @revoked_cert = nil
      begin
        parse(der_value)
      rescue IOException => e
        @revoked_cert = nil
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.to_s))
      end
    end
    
    typesig { [] }
    # Returns true if this revoked certificate entry has
    # extensions, otherwise false.
    # 
    # @return true if this CRL entry has extensions, otherwise
    # false.
    def has_extensions
      return (!(@extensions).nil?)
    end
    
    typesig { [DerOutputStream] }
    # Encodes the revoked certificate to an output stream.
    # 
    # @param outStrm an output stream to which the encoded revoked
    # certificate is written.
    # @exception CRLException on encoding errors.
    def encode(out_strm)
      begin
        if ((@revoked_cert).nil?)
          tmp = DerOutputStream.new
          # sequence { serialNumber, revocationDate, extensions }
          @serial_number.encode(tmp)
          if (@revocation_date.get_time < YR_2050)
            tmp.put_utctime(@revocation_date)
          else
            tmp.put_generalized_time(@revocation_date)
          end
          if (!(@extensions).nil?)
            @extensions.encode(tmp, IsExplicit)
          end
          seq = DerOutputStream.new
          seq.write(DerValue.attr_tag_sequence, tmp)
          @revoked_cert = seq.to_byte_array
        end
        out_strm.write(@revoked_cert)
      rescue IOException => e
        raise CRLException.new("Encoding error: " + RJava.cast_to_string(e.to_s))
      end
    end
    
    typesig { [] }
    # Returns the ASN.1 DER-encoded form of this CRL Entry,
    # which corresponds to the inner SEQUENCE.
    # 
    # @exception CRLException if an encoding error occurs.
    def get_encoded
      if ((@revoked_cert).nil?)
        self.encode(DerOutputStream.new)
      end
      return @revoked_cert.clone
    end
    
    typesig { [] }
    def get_certificate_issuer
      return @cert_issuer
    end
    
    typesig { [X500Principal, X500Principal] }
    def set_certificate_issuer(crl_issuer, cert_issuer)
      if ((crl_issuer == cert_issuer))
        @cert_issuer = nil
      else
        @cert_issuer = cert_issuer
      end
    end
    
    typesig { [] }
    # Gets the serial number from this X509CRLEntry,
    # i.e. the <em>userCertificate</em>.
    # 
    # @return the serial number.
    def get_serial_number
      return @serial_number.get_number
    end
    
    typesig { [] }
    # Gets the revocation date from this X509CRLEntry,
    # the <em>revocationDate</em>.
    # 
    # @return the revocation date.
    def get_revocation_date
      return Date.new(@revocation_date.get_time)
    end
    
    typesig { [] }
    # get Reason Code from CRL entry.
    # 
    # @returns Integer or null, if no such extension
    # @throws IOException on error
    def get_reason_code
      obj = get_extension(PKIXExtensions::ReasonCode_Id)
      if ((obj).nil?)
        return nil
      end
      reason_code = obj
      return (reason_code.get(reason_code.attr_reason))
    end
    
    typesig { [] }
    # Returns a printable string of this revoked certificate.
    # 
    # @return value of this revoked certificate in a printable form.
    def to_s
      sb = StringBuilder.new
      sb.append(@serial_number.to_s)
      sb.append("  On: " + RJava.cast_to_string(@revocation_date.to_s))
      if (!(@cert_issuer).nil?)
        sb.append("\n    Certificate issuer: " + RJava.cast_to_string(@cert_issuer))
      end
      if (!(@extensions).nil?)
        all_entry_exts = @extensions.get_all_extensions
        objs = all_entry_exts.to_array
        sb.append("\n    CRL Entry Extensions: " + RJava.cast_to_string(objs.attr_length))
        i = 0
        while i < objs.attr_length
          sb.append("\n    [" + RJava.cast_to_string((i + 1)) + "]: ")
          ext = objs[i]
          begin
            if ((OIDMap.get_class(ext.get_extension_id)).nil?)
              sb.append(ext.to_s)
              ext_value = ext.get_extension_value
              if (!(ext_value).nil?)
                out = DerOutputStream.new
                out.put_octet_string(ext_value)
                ext_value = out.to_byte_array
                enc = HexDumpEncoder.new
                sb.append("Extension unknown: " + "DER encoded OCTET string =\n" + RJava.cast_to_string(enc.encode_buffer(ext_value)) + "\n")
              end
            else
              sb.append(ext.to_s)
            end # sub-class exists
          rescue JavaException => e
            sb.append(", Error parsing this extension")
          end
          i += 1
        end
      end
      sb.append("\n")
      return sb.to_s
    end
    
    typesig { [] }
    # Return true if a critical extension is found that is
    # not supported, otherwise return false.
    def has_unsupported_critical_extension
      if ((@extensions).nil?)
        return false
      end
      return @extensions.has_unsupported_critical_extension
    end
    
    typesig { [] }
    # Gets a Set of the extension(s) marked CRITICAL in this
    # X509CRLEntry.  In the returned set, each extension is
    # represented by its OID string.
    # 
    # @return a set of the extension oid strings in the
    # Object that are marked critical.
    def get_critical_extension_oids
      if ((@extensions).nil?)
        return nil
      end
      ext_set = HashSet.new
      @extensions.get_all_extensions.each do |ex|
        if (ex.is_critical)
          ext_set.add(ex.get_extension_id.to_s)
        end
      end
      return ext_set
    end
    
    typesig { [] }
    # Gets a Set of the extension(s) marked NON-CRITICAL in this
    # X509CRLEntry. In the returned set, each extension is
    # represented by its OID string.
    # 
    # @return a set of the extension oid strings in the
    # Object that are marked critical.
    def get_non_critical_extension_oids
      if ((@extensions).nil?)
        return nil
      end
      ext_set = HashSet.new
      @extensions.get_all_extensions.each do |ex|
        if (!ex.is_critical)
          ext_set.add(ex.get_extension_id.to_s)
        end
      end
      return ext_set
    end
    
    typesig { [String] }
    # Gets the DER encoded OCTET string for the extension value
    # (<em>extnValue</em>) identified by the passed in oid String.
    # The <code>oid</code> string is
    # represented by a set of positive whole number separated
    # by ".", that means,<br>
    # &lt;positive whole number&gt;.&lt;positive whole number&gt;.&lt;positive
    # whole number&gt;.&lt;...&gt;
    # 
    # @param oid the Object Identifier value for the extension.
    # @return the DER encoded octet string of the extension value.
    def get_extension_value(oid)
      if ((@extensions).nil?)
        return nil
      end
      begin
        ext_alias = OIDMap.get_name(ObjectIdentifier.new(oid))
        crl_ext = nil
        if ((ext_alias).nil?)
          # may be unknown
          find_oid = ObjectIdentifier.new(oid)
          ex = nil
          in_cert_oid = nil
          e = @extensions.get_elements
          while e.has_more_elements
            ex = e.next_element
            in_cert_oid = ex.get_extension_id
            if ((in_cert_oid == find_oid))
              crl_ext = ex
              break
            end
          end
        else
          crl_ext = @extensions.get(ext_alias)
        end
        if ((crl_ext).nil?)
          return nil
        end
        ext_data = crl_ext.get_extension_value
        if ((ext_data).nil?)
          return nil
        end
        out = DerOutputStream.new
        out.put_octet_string(ext_data)
        return out.to_byte_array
      rescue JavaException => e
        return nil
      end
    end
    
    typesig { [ObjectIdentifier] }
    # get an extension
    # 
    # @param oid ObjectIdentifier of extension desired
    # @returns Extension of type <extension> or null, if not found
    def get_extension(oid)
      if ((@extensions).nil?)
        return nil
      end
      # following returns null if no such OID in map
      # XXX consider cloning this
      return @extensions.get(OIDMap.get_name(oid))
    end
    
    typesig { [DerValue] }
    def parse(der_val)
      if (!(der_val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CRLException.new("Invalid encoded RevokedCertificate, " + "starting sequence tag missing.")
      end
      if ((der_val.attr_data.available).equal?(0))
        raise CRLException.new("No data encoded for RevokedCertificates")
      end
      @revoked_cert = der_val.to_byte_array
      # serial number
      in_ = der_val.to_der_input_stream
      val = in_.get_der_value
      @serial_number = SerialNumber.new(val)
      # revocationDate
      next_byte = der_val.attr_data.peek_byte
      if ((next_byte).equal?(DerValue.attr_tag_utc_time))
        @revocation_date = der_val.attr_data.get_utctime
      else
        if ((next_byte).equal?(DerValue.attr_tag_generalized_time))
          @revocation_date = der_val.attr_data.get_generalized_time
        else
          raise CRLException.new("Invalid encoding for revocation date")
        end
      end
      if ((der_val.attr_data.available).equal?(0))
        return
      end # no extensions
      # crlEntryExtensions
      @extensions = CRLExtensions.new(der_val.to_der_input_stream)
    end
    
    class_module.module_eval {
      typesig { [X509CRLEntry] }
      # Utility method to convert an arbitrary instance of X509CRLEntry
      # to a X509CRLEntryImpl. Does a cast if possible, otherwise reparses
      # the encoding.
      def to_impl(entry)
        if (entry.is_a?(X509CRLEntryImpl))
          return entry
        else
          return X509CRLEntryImpl.new(entry.get_encoded)
        end
      end
    }
    
    typesig { [] }
    # Returns the CertificateIssuerExtension
    # 
    # @return the CertificateIssuerExtension, or null if it does not exist
    def get_certificate_issuer_extension
      return get_extension(PKIXExtensions::CertificateIssuer_Id)
    end
    
    private
    alias_method :initialize__x509crlentry_impl, :initialize
  end
  
end

require "rjava"

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
  module PKCS7Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509CRL
      include_const ::Java::Security::Cert, :CRLException
      include_const ::Java::Security::Cert, :CertificateFactory
      include ::Java::Security
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::X509, :CertificateIssuerName
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :X509CertInfo
      include_const ::Sun::Security::X509, :X509CRLImpl
      include_const ::Sun::Security::X509, :X500Name
    }
  end
  
  # PKCS7 as defined in RSA Laboratories PKCS7 Technical Note. Profile
  # Supports only <tt>SignedData</tt> ContentInfo
  # type, where to the type of data signed is plain Data.
  # For signedData, <tt>crls</tt>, <tt>attributes</tt> and
  # PKCS#6 Extended Certificates are not supported.
  # 
  # @author Benjamin Renaud
  class PKCS7 
    include_class_members PKCS7Imports
    
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    # the ASN.1 members for a signedData (and other) contentTypes
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :digest_algorithm_ids
    alias_method :attr_digest_algorithm_ids, :digest_algorithm_ids
    undef_method :digest_algorithm_ids
    alias_method :attr_digest_algorithm_ids=, :digest_algorithm_ids=
    undef_method :digest_algorithm_ids=
    
    attr_accessor :content_info
    alias_method :attr_content_info, :content_info
    undef_method :content_info
    alias_method :attr_content_info=, :content_info=
    undef_method :content_info=
    
    attr_accessor :certificates
    alias_method :attr_certificates, :certificates
    undef_method :certificates
    alias_method :attr_certificates=, :certificates=
    undef_method :certificates=
    
    attr_accessor :crls
    alias_method :attr_crls, :crls
    undef_method :crls
    alias_method :attr_crls=, :crls=
    undef_method :crls=
    
    attr_accessor :signer_infos
    alias_method :attr_signer_infos, :signer_infos
    undef_method :signer_infos
    alias_method :attr_signer_infos=, :signer_infos=
    undef_method :signer_infos=
    
    attr_accessor :old_style
    alias_method :attr_old_style, :old_style
    undef_method :old_style
    alias_method :attr_old_style=, :old_style=
    undef_method :old_style=
    
    # Is this JDK1.1.x-style?
    attr_accessor :cert_issuer_names
    alias_method :attr_cert_issuer_names, :cert_issuer_names
    undef_method :cert_issuer_names
    alias_method :attr_cert_issuer_names=, :cert_issuer_names=
    undef_method :cert_issuer_names=
    
    typesig { [InputStream] }
    # Unmarshals a PKCS7 block from its encoded form, parsing the
    # encoded bytes from the InputStream.
    # 
    # @param in an input stream holding at least one PKCS7 block.
    # @exception ParsingException on parsing errors.
    # @exception IOException on other errors.
    def initialize(in_)
      @content_type = nil
      @version = nil
      @digest_algorithm_ids = nil
      @content_info = nil
      @certificates = nil
      @crls = nil
      @signer_infos = nil
      @old_style = false
      @cert_issuer_names = nil
      dis = DataInputStream.new(in_)
      data = Array.typed(::Java::Byte).new(dis.available) { 0 }
      dis.read_fully(data)
      parse(DerInputStream.new(data))
    end
    
    typesig { [DerInputStream] }
    # Unmarshals a PKCS7 block from its encoded form, parsing the
    # encoded bytes from the DerInputStream.
    # 
    # @param derin a DerInputStream holding at least one PKCS7 block.
    # @exception ParsingException on parsing errors.
    def initialize(derin)
      @content_type = nil
      @version = nil
      @digest_algorithm_ids = nil
      @content_info = nil
      @certificates = nil
      @crls = nil
      @signer_infos = nil
      @old_style = false
      @cert_issuer_names = nil
      parse(derin)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Unmarshals a PKCS7 block from its encoded form, parsing the
    # encoded bytes.
    # 
    # @param bytes the encoded bytes.
    # @exception ParsingException on parsing errors.
    def initialize(bytes)
      @content_type = nil
      @version = nil
      @digest_algorithm_ids = nil
      @content_info = nil
      @certificates = nil
      @crls = nil
      @signer_infos = nil
      @old_style = false
      @cert_issuer_names = nil
      begin
        derin = DerInputStream.new(bytes)
        parse(derin)
      rescue IOException => ioe1
        pe = ParsingException.new("Unable to parse the encoded bytes")
        pe.init_cause(ioe1)
        raise pe
      end
    end
    
    typesig { [DerInputStream] }
    # Parses a PKCS#7 block.
    def parse(derin)
      begin
        derin.mark(derin.available)
        # try new (i.e., JDK1.2) style
        parse(derin, false)
      rescue IOException => ioe
        begin
          derin.reset
          # try old (i.e., JDK1.1.x) style
          parse(derin, true)
          @old_style = true
        rescue IOException => ioe1
          pe = ParsingException.new(ioe1.get_message)
          pe.init_cause(ioe1)
          raise pe
        end
      end
    end
    
    typesig { [DerInputStream, ::Java::Boolean] }
    # Parses a PKCS#7 block.
    # 
    # @param derin the ASN.1 encoding of the PKCS#7 block.
    # @param oldStyle flag indicating whether or not the given PKCS#7 block
    # is encoded according to JDK1.1.x.
    def parse(derin, old_style)
      @content_info = ContentInfo.new(derin, old_style)
      @content_type = @content_info.attr_content_type
      content = @content_info.get_content
      if ((@content_type == ContentInfo::SIGNED_DATA_OID))
        parse_signed_data(content)
      else
        if ((@content_type == ContentInfo::OLD_SIGNED_DATA_OID))
          # This is for backwards compatibility with JDK 1.1.x
          parse_old_signed_data(content)
        else
          if ((@content_type == ContentInfo::NETSCAPE_CERT_SEQUENCE_OID))
            parse_netscape_cert_chain(content)
          else
            raise ParsingException.new("content type " + RJava.cast_to_string(@content_type) + " not supported.")
          end
        end
      end
    end
    
    typesig { [Array.typed(AlgorithmId), ContentInfo, Array.typed(X509Certificate), Array.typed(SignerInfo)] }
    # Construct an initialized PKCS7 block.
    # 
    # @param digestAlgorithmIds the message digest algorithm identifiers.
    # @param contentInfo the content information.
    # @param certificates an array of X.509 certificates.
    # @param signerInfos an array of signer information.
    def initialize(digest_algorithm_ids, content_info, certificates, signer_infos)
      @content_type = nil
      @version = nil
      @digest_algorithm_ids = nil
      @content_info = nil
      @certificates = nil
      @crls = nil
      @signer_infos = nil
      @old_style = false
      @cert_issuer_names = nil
      @version = BigInteger::ONE
      @digest_algorithm_ids = digest_algorithm_ids
      @content_info = content_info
      @certificates = certificates
      @signer_infos = signer_infos
    end
    
    typesig { [DerValue] }
    def parse_netscape_cert_chain(val)
      dis = DerInputStream.new(val.to_byte_array)
      contents = dis.get_sequence(2)
      @certificates = Array.typed(X509Certificate).new(contents.attr_length) { nil }
      certfac = nil
      begin
        certfac = CertificateFactory.get_instance("X.509")
      rescue CertificateException => ce
        # do nothing
      end
      i = 0
      while i < contents.attr_length
        bais = nil
        begin
          if ((certfac).nil?)
            @certificates[i] = X509CertImpl.new(contents[i])
          else
            encoded = contents[i].to_byte_array
            bais = ByteArrayInputStream.new(encoded)
            @certificates[i] = certfac.generate_certificate(bais)
            bais.close
            bais = nil
          end
        rescue CertificateException => ce
          pe = ParsingException.new(ce.get_message)
          pe.init_cause(ce)
          raise pe
        rescue IOException => ioe
          pe = ParsingException.new(ioe.get_message)
          pe.init_cause(ioe)
          raise pe
        ensure
          if (!(bais).nil?)
            bais.close
          end
        end
        i += 1
      end
    end
    
    typesig { [DerValue] }
    def parse_signed_data(val)
      dis = val.to_der_input_stream
      # Version
      @version = dis.get_big_integer
      # digestAlgorithmIds
      digest_algorithm_id_vals = dis.get_set(1)
      len = digest_algorithm_id_vals.attr_length
      @digest_algorithm_ids = Array.typed(AlgorithmId).new(len) { nil }
      begin
        i = 0
        while i < len
          oid = digest_algorithm_id_vals[i]
          @digest_algorithm_ids[i] = AlgorithmId.parse(oid)
          i += 1
        end
      rescue IOException => e
        pe = ParsingException.new("Error parsing digest AlgorithmId IDs: " + RJava.cast_to_string(e.get_message))
        pe.init_cause(e)
        raise pe
      end
      # contentInfo
      @content_info = ContentInfo.new(dis)
      certfac = nil
      begin
        certfac = CertificateFactory.get_instance("X.509")
      rescue CertificateException => ce
        # do nothing
      end
      # check if certificates (implicit tag) are provided
      # (certificates are OPTIONAL)
      if (((dis.peek_byte)).equal?(0xa0))
        cert_vals = dis.get_set(2, true)
        len = cert_vals.attr_length
        @certificates = Array.typed(X509Certificate).new(len) { nil }
        i_ = 0
        while i_ < len
          bais = nil
          begin
            if ((certfac).nil?)
              @certificates[i_] = X509CertImpl.new(cert_vals[i_])
            else
              encoded = cert_vals[i_].to_byte_array
              bais = ByteArrayInputStream.new(encoded)
              @certificates[i_] = certfac.generate_certificate(bais)
              bais.close
              bais = nil
            end
          rescue CertificateException => ce
            pe = ParsingException.new(ce.get_message)
            pe.init_cause(ce)
            raise pe
          rescue IOException => ioe
            pe = ParsingException.new(ioe.get_message)
            pe.init_cause(ioe)
            raise pe
          ensure
            if (!(bais).nil?)
              bais.close
            end
          end
          i_ += 1
        end
      end
      # check if crls (implicit tag) are provided (crls are OPTIONAL)
      if (((dis.peek_byte)).equal?(0xa1))
        crl_vals = dis.get_set(1, true)
        len = crl_vals.attr_length
        @crls = Array.typed(X509CRL).new(len) { nil }
        i_ = 0
        while i_ < len
          bais = nil
          begin
            if ((certfac).nil?)
              @crls[i_] = X509CRLImpl.new(crl_vals[i_])
            else
              encoded = crl_vals[i_].to_byte_array
              bais = ByteArrayInputStream.new(encoded)
              @crls[i_] = certfac.generate_crl(bais)
              bais.close
              bais = nil
            end
          rescue CRLException => e
            pe = ParsingException.new(e.get_message)
            pe.init_cause(e)
            raise pe
          ensure
            if (!(bais).nil?)
              bais.close
            end
          end
          i_ += 1
        end
      end
      # signerInfos
      signer_info_vals = dis.get_set(1)
      len = signer_info_vals.attr_length
      @signer_infos = Array.typed(SignerInfo).new(len) { nil }
      i_ = 0
      while i_ < len
        in_ = signer_info_vals[i_].to_der_input_stream
        @signer_infos[i_] = SignerInfo.new(in_)
        i_ += 1
      end
    end
    
    typesig { [DerValue] }
    # Parses an old-style SignedData encoding (for backwards
    # compatibility with JDK1.1.x).
    def parse_old_signed_data(val)
      dis = val.to_der_input_stream
      # Version
      @version = dis.get_big_integer
      # digestAlgorithmIds
      digest_algorithm_id_vals = dis.get_set(1)
      len = digest_algorithm_id_vals.attr_length
      @digest_algorithm_ids = Array.typed(AlgorithmId).new(len) { nil }
      begin
        i = 0
        while i < len
          oid = digest_algorithm_id_vals[i]
          @digest_algorithm_ids[i] = AlgorithmId.parse(oid)
          i += 1
        end
      rescue IOException => e
        raise ParsingException.new("Error parsing digest AlgorithmId IDs")
      end
      # contentInfo
      @content_info = ContentInfo.new(dis, true)
      # certificates
      certfac = nil
      begin
        certfac = CertificateFactory.get_instance("X.509")
      rescue CertificateException => ce
        # do nothing
      end
      cert_vals = dis.get_set(2)
      len = cert_vals.attr_length
      @certificates = Array.typed(X509Certificate).new(len) { nil }
      i_ = 0
      while i_ < len
        bais = nil
        begin
          if ((certfac).nil?)
            @certificates[i_] = X509CertImpl.new(cert_vals[i_])
          else
            encoded = cert_vals[i_].to_byte_array
            bais = ByteArrayInputStream.new(encoded)
            @certificates[i_] = certfac.generate_certificate(bais)
            bais.close
            bais = nil
          end
        rescue CertificateException => ce
          pe = ParsingException.new(ce.get_message)
          pe.init_cause(ce)
          raise pe
        rescue IOException => ioe
          pe = ParsingException.new(ioe.get_message)
          pe.init_cause(ioe)
          raise pe
        ensure
          if (!(bais).nil?)
            bais.close
          end
        end
        i_ += 1
      end
      # crls are ignored.
      dis.get_set(0)
      # signerInfos
      signer_info_vals = dis.get_set(1)
      len = signer_info_vals.attr_length
      @signer_infos = Array.typed(SignerInfo).new(len) { nil }
      i__ = 0
      while i__ < len
        in_ = signer_info_vals[i__].to_der_input_stream
        @signer_infos[i__] = SignerInfo.new(in_, true)
        i__ += 1
      end
    end
    
    typesig { [OutputStream] }
    # Encodes the signed data to an output stream.
    # 
    # @param out the output stream to write the encoded data to.
    # @exception IOException on encoding errors.
    def encode_signed_data(out)
      derout = DerOutputStream.new
      encode_signed_data(derout)
      out.write(derout.to_byte_array)
    end
    
    typesig { [DerOutputStream] }
    # Encodes the signed data to a DerOutputStream.
    # 
    # @param out the DerOutputStream to write the encoded data to.
    # @exception IOException on encoding errors.
    def encode_signed_data(out)
      signed_data = DerOutputStream.new
      # version
      signed_data.put_integer(@version)
      # digestAlgorithmIds
      signed_data.put_ordered_set_of(DerValue.attr_tag_set, @digest_algorithm_ids)
      # contentInfo
      @content_info.encode(signed_data)
      # certificates (optional)
      if (!(@certificates).nil? && !(@certificates.attr_length).equal?(0))
        # cast to X509CertImpl[] since X509CertImpl implements DerEncoder
        impl_certs = Array.typed(X509CertImpl).new(@certificates.attr_length) { nil }
        i = 0
        while i < @certificates.attr_length
          if (@certificates[i].is_a?(X509CertImpl))
            impl_certs[i] = @certificates[i]
          else
            begin
              encoded = @certificates[i].get_encoded
              impl_certs[i] = X509CertImpl.new(encoded)
            rescue CertificateException => ce
              ie = IOException.new(ce.get_message)
              ie.init_cause(ce)
              raise ie
            end
          end
          i += 1
        end
        # Add the certificate set (tagged with [0] IMPLICIT)
        # to the signed data
        signed_data.put_ordered_set_of(0xa0, impl_certs)
      end
      # no crls (OPTIONAL field)
      # signerInfos
      signed_data.put_ordered_set_of(DerValue.attr_tag_set, @signer_infos)
      # making it a signed data block
      signed_data_seq = DerValue.new(DerValue.attr_tag_sequence, signed_data.to_byte_array)
      # making it a content info sequence
      block = ContentInfo.new(ContentInfo::SIGNED_DATA_OID, signed_data_seq)
      # writing out the contentInfo sequence
      block.encode(out)
    end
    
    typesig { [SignerInfo, Array.typed(::Java::Byte)] }
    # This verifies a given SignerInfo.
    # 
    # @param info the signer information.
    # @param bytes the DER encoded content information.
    # 
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    # @exception SignatureException on signature handling errors.
    def verify(info, bytes)
      return info.verify(self, bytes)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Returns all signerInfos which self-verify.
    # 
    # @param bytes the DER encoded content information.
    # 
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    # @exception SignatureException on signature handling errors.
    def verify(bytes)
      int_result = Vector.new
      i = 0
      while i < @signer_infos.attr_length
        signer_info = verify(@signer_infos[i], bytes)
        if (!(signer_info).nil?)
          int_result.add_element(signer_info)
        end
        i += 1
      end
      if (!(int_result.size).equal?(0))
        result = Array.typed(SignerInfo).new(int_result.size) { nil }
        int_result.copy_into(result)
        return result
      end
      return nil
    end
    
    typesig { [] }
    # Returns all signerInfos which self-verify.
    # 
    # @exception NoSuchAlgorithmException on unrecognized algorithms.
    # @exception SignatureException on signature handling errors.
    def verify
      return verify(nil)
    end
    
    typesig { [] }
    # Returns the version number of this PKCS7 block.
    # @return the version or null if version is not specified
    #         for the content type.
    def get_version
      return @version
    end
    
    typesig { [] }
    # Returns the message digest algorithms specified in this PKCS7 block.
    # @return the array of Digest Algorithms or null if none are specified
    #         for the content type.
    def get_digest_algorithm_ids
      return @digest_algorithm_ids
    end
    
    typesig { [] }
    # Returns the content information specified in this PKCS7 block.
    def get_content_info
      return @content_info
    end
    
    typesig { [] }
    # Returns the X.509 certificates listed in this PKCS7 block.
    # @return a clone of the array of X.509 certificates or null if
    #         none are specified for the content type.
    def get_certificates
      if (!(@certificates).nil?)
        return @certificates.clone
      else
        return nil
      end
    end
    
    typesig { [] }
    # Returns the X.509 crls listed in this PKCS7 block.
    # @return a clone of the array of X.509 crls or null if none
    #         are specified for the content type.
    def get_crls
      if (!(@crls).nil?)
        return @crls.clone
      else
        return nil
      end
    end
    
    typesig { [] }
    # Returns the signer's information specified in this PKCS7 block.
    # @return the array of Signer Infos or null if none are specified
    #         for the content type.
    def get_signer_infos
      return @signer_infos
    end
    
    typesig { [BigInteger, X500Name] }
    # Returns the X.509 certificate listed in this PKCS7 block
    # which has a matching serial number and Issuer name, or
    # null if one is not found.
    # 
    # @param serial the serial number of the certificate to retrieve.
    # @param issuerName the Distinguished Name of the Issuer.
    def get_certificate(serial, issuer_name)
      if (!(@certificates).nil?)
        if ((@cert_issuer_names).nil?)
          populate_cert_issuer_names
        end
        i = 0
        while i < @certificates.attr_length
          cert = @certificates[i]
          this_serial = cert.get_serial_number
          if ((serial == this_serial) && (issuer_name == @cert_issuer_names[i]))
            return cert
          end
          i += 1
        end
      end
      return nil
    end
    
    typesig { [] }
    # Populate array of Issuer DNs from certificates and convert
    # each Principal to type X500Name if necessary.
    def populate_cert_issuer_names
      if ((@certificates).nil?)
        return
      end
      @cert_issuer_names = Array.typed(Principal).new(@certificates.attr_length) { nil }
      i = 0
      while i < @certificates.attr_length
        cert = @certificates[i]
        cert_issuer_name = cert.get_issuer_dn
        if (!(cert_issuer_name.is_a?(X500Name)))
          # must extract the original encoded form of DN for
          # subsequent name comparison checks (converting to a
          # String and back to an encoded DN could cause the
          # types of String attribute values to be changed)
          begin
            tbs_cert = X509CertInfo.new(cert.get_tbscertificate)
            cert_issuer_name = tbs_cert.get(RJava.cast_to_string(CertificateIssuerName::NAME) + "." + RJava.cast_to_string(CertificateIssuerName::DN_NAME))
          rescue JavaException => e
            # error generating X500Name object from the cert's
            # issuer DN, leave name as is.
          end
        end
        @cert_issuer_names[i] = cert_issuer_name
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the PKCS7 block in a printable string form.
    def to_s
      out = ""
      out += RJava.cast_to_string(@content_info) + "\n"
      if (!(@version).nil?)
        out += "PKCS7 :: version: " + RJava.cast_to_string(Debug.to_hex_string(@version)) + "\n"
      end
      if (!(@digest_algorithm_ids).nil?)
        out += "PKCS7 :: digest AlgorithmIds: \n"
        i = 0
        while i < @digest_algorithm_ids.attr_length
          out += "\t" + RJava.cast_to_string(@digest_algorithm_ids[i]) + "\n"
          i += 1
        end
      end
      if (!(@certificates).nil?)
        out += "PKCS7 :: certificates: \n"
        i = 0
        while i < @certificates.attr_length
          out += "\t" + RJava.cast_to_string(i) + ".   " + RJava.cast_to_string(@certificates[i]) + "\n"
          i += 1
        end
      end
      if (!(@crls).nil?)
        out += "PKCS7 :: crls: \n"
        i = 0
        while i < @crls.attr_length
          out += "\t" + RJava.cast_to_string(i) + ".   " + RJava.cast_to_string(@crls[i]) + "\n"
          i += 1
        end
      end
      if (!(@signer_infos).nil?)
        out += "PKCS7 :: signer infos: \n"
        i = 0
        while i < @signer_infos.attr_length
          out += RJava.cast_to_string(("\t" + RJava.cast_to_string(i) + ".  " + RJava.cast_to_string(@signer_infos[i]) + "\n"))
          i += 1
        end
      end
      return out
    end
    
    typesig { [] }
    # Returns true if this is a JDK1.1.x-style PKCS#7 block, and false
    # otherwise.
    def is_old_style
      return @old_style
    end
    
    private
    alias_method :initialize__pkcs7, :initialize
  end
  
end

require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509CRLImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :Signature
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :SignatureException
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509CRL
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :X509CRLEntry
      include_const ::Java::Security::Cert, :CRLException
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Provider, :X509Factory
      include ::Sun::Security::Util
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # <p>
  # An implmentation for X509 CRL (Certificate Revocation List).
  # <p>
  # The X.509 v2 CRL format is described below in ASN.1:
  # <pre>
  # CertificateList  ::=  SEQUENCE  {
  # tbsCertList          TBSCertList,
  # signatureAlgorithm   AlgorithmIdentifier,
  # signature            BIT STRING  }
  # </pre>
  # More information can be found in
  # <a href="http://www.ietf.org/rfc/rfc3280.txt">RFC 3280: Internet X.509
  # Public Key Infrastructure Certificate and CRL Profile</a>.
  # <p>
  # The ASN.1 definition of <code>tbsCertList</code> is:
  # <pre>
  # TBSCertList  ::=  SEQUENCE  {
  # version                 Version OPTIONAL,
  # -- if present, must be v2
  # signature               AlgorithmIdentifier,
  # issuer                  Name,
  # thisUpdate              ChoiceOfTime,
  # nextUpdate              ChoiceOfTime OPTIONAL,
  # revokedCertificates     SEQUENCE OF SEQUENCE  {
  # userCertificate         CertificateSerialNumber,
  # revocationDate          ChoiceOfTime,
  # crlEntryExtensions      Extensions OPTIONAL
  # -- if present, must be v2
  # }  OPTIONAL,
  # crlExtensions           [0]  EXPLICIT Extensions OPTIONAL
  # -- if present, must be v2
  # }
  # </pre>
  # 
  # @author Hemma Prafullchandra
  # @see X509CRL
  class X509CRLImpl < X509CRLImplImports.const_get :X509CRL
    include_class_members X509CRLImplImports
    
    # CRL data, and its envelope
    attr_accessor :signed_crl
    alias_method :attr_signed_crl, :signed_crl
    undef_method :signed_crl
    alias_method :attr_signed_crl=, :signed_crl=
    undef_method :signed_crl=
    
    # DER encoded crl
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    # raw signature bits
    attr_accessor :tbs_cert_list
    alias_method :attr_tbs_cert_list, :tbs_cert_list
    undef_method :tbs_cert_list
    alias_method :attr_tbs_cert_list=, :tbs_cert_list=
    undef_method :tbs_cert_list=
    
    # DER encoded "to-be-signed" CRL
    attr_accessor :sig_alg_id
    alias_method :attr_sig_alg_id, :sig_alg_id
    undef_method :sig_alg_id
    alias_method :attr_sig_alg_id=, :sig_alg_id=
    undef_method :sig_alg_id=
    
    # sig alg in CRL
    # crl information
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :info_sig_alg_id
    alias_method :attr_info_sig_alg_id, :info_sig_alg_id
    undef_method :info_sig_alg_id
    alias_method :attr_info_sig_alg_id=, :info_sig_alg_id=
    undef_method :info_sig_alg_id=
    
    # sig alg in "to-be-signed" crl
    attr_accessor :issuer
    alias_method :attr_issuer, :issuer
    undef_method :issuer
    alias_method :attr_issuer=, :issuer=
    undef_method :issuer=
    
    attr_accessor :issuer_principal
    alias_method :attr_issuer_principal, :issuer_principal
    undef_method :issuer_principal
    alias_method :attr_issuer_principal=, :issuer_principal=
    undef_method :issuer_principal=
    
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
    
    attr_accessor :revoked_certs
    alias_method :attr_revoked_certs, :revoked_certs
    undef_method :revoked_certs
    alias_method :attr_revoked_certs=, :revoked_certs=
    undef_method :revoked_certs=
    
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    class_module.module_eval {
      const_set_lazy(:IsExplicit) { true }
      const_attr_reader  :IsExplicit
      
      const_set_lazy(:YR_2050) { 2524636800000 }
      const_attr_reader  :YR_2050
    }
    
    attr_accessor :read_only
    alias_method :attr_read_only, :read_only
    undef_method :read_only
    alias_method :attr_read_only=, :read_only=
    undef_method :read_only=
    
    # PublicKey that has previously been used to successfully verify
    # the signature of this CRL. Null if the CRL has not
    # yet been verified (successfully).
    attr_accessor :verified_public_key
    alias_method :attr_verified_public_key, :verified_public_key
    undef_method :verified_public_key
    alias_method :attr_verified_public_key=, :verified_public_key=
    undef_method :verified_public_key=
    
    # If verifiedPublicKey is not null, name of the provider used to
    # successfully verify the signature of this CRL, or the
    # empty String if no provider was explicitly specified.
    attr_accessor :verified_provider
    alias_method :attr_verified_provider, :verified_provider
    undef_method :verified_provider
    alias_method :attr_verified_provider=, :verified_provider=
    undef_method :verified_provider=
    
    typesig { [] }
    # Not to be used. As it would lead to cases of uninitialized
    # CRL objects.
    def initialize
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Unmarshals an X.509 CRL from its encoded form, parsing the encoded
    # bytes.  This form of constructor is used by agents which
    # need to examine and use CRL contents. Note that the buffer
    # must include only one CRL, and no "garbage" may be left at
    # the end.
    # 
    # @param crlData the encoded bytes, with no trailing padding.
    # @exception CRLException on parsing errors.
    def initialize(crl_data)
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
      begin
        parse(DerValue.new(crl_data))
      rescue IOException => e
        @signed_crl = nil
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [DerValue] }
    # Unmarshals an X.509 CRL from an DER value.
    # 
    # @param val a DER value holding at least one CRL
    # @exception CRLException on parsing errors.
    def initialize(val)
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
      begin
        parse(val)
      rescue IOException => e
        @signed_crl = nil
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [InputStream] }
    # Unmarshals an X.509 CRL from an input stream. Only one CRL
    # is expected at the end of the input stream.
    # 
    # @param inStrm an input stream holding at least one CRL
    # @exception CRLException on parsing errors.
    def initialize(in_strm)
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
      begin
        parse(DerValue.new(in_strm))
      rescue IOException => e
        @signed_crl = nil
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [X500Name, Date, Date] }
    # Initial CRL constructor, no revoked certs, and no extensions.
    # 
    # @param issuer the name of the CA issuing this CRL.
    # @param thisUpdate the Date of this issue.
    # @param nextUpdate the Date of the next CRL.
    def initialize(issuer, this_date, next_date)
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
      @issuer = issuer
      @this_update = this_date
      @next_update = next_date
    end
    
    typesig { [X500Name, Date, Date, Array.typed(X509CRLEntry)] }
    # CRL constructor, revoked certs, no extensions.
    # 
    # @param issuer the name of the CA issuing this CRL.
    # @param thisUpdate the Date of this issue.
    # @param nextUpdate the Date of the next CRL.
    # @param badCerts the array of CRL entries.
    # 
    # @exception CRLException on parsing/construction errors.
    def initialize(issuer, this_date, next_date, bad_certs)
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @version = 0
      @info_sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = nil
      @extensions = nil
      @read_only = false
      @verified_public_key = nil
      @verified_provider = nil
      super()
      @signed_crl = nil
      @signature = nil
      @tbs_cert_list = nil
      @sig_alg_id = nil
      @issuer = nil
      @issuer_principal = nil
      @this_update = nil
      @next_update = nil
      @revoked_certs = LinkedHashMap.new
      @extensions = nil
      @read_only = false
      @issuer = issuer
      @this_update = this_date
      @next_update = next_date
      if (!(bad_certs).nil?)
        crl_issuer = get_issuer_x500principal
        bad_cert_issuer = crl_issuer
        i = 0
        while i < bad_certs.attr_length
          bad_cert = bad_certs[i]
          begin
            bad_cert_issuer = get_cert_issuer(bad_cert, bad_cert_issuer)
          rescue IOException => ioe
            raise CRLException.new(ioe)
          end
          bad_cert.set_certificate_issuer(crl_issuer, bad_cert_issuer)
          issuer_serial = X509IssuerSerial.new(bad_cert_issuer, bad_cert.get_serial_number)
          @revoked_certs.put(issuer_serial, bad_cert)
          if (bad_cert.has_extensions)
            @version = 1
          end
          i += 1
        end
      end
    end
    
    typesig { [X500Name, Date, Date, Array.typed(X509CRLEntry), CRLExtensions] }
    # CRL constructor, revoked certs and extensions.
    # 
    # @param issuer the name of the CA issuing this CRL.
    # @param thisUpdate the Date of this issue.
    # @param nextUpdate the Date of the next CRL.
    # @param badCerts the array of CRL entries.
    # @param crlExts the CRL extensions.
    # 
    # @exception CRLException on parsing/construction errors.
    def initialize(issuer, this_date, next_date, bad_certs, crl_exts)
      initialize__x509crlimpl(issuer, this_date, next_date, bad_certs)
      if (!(crl_exts).nil?)
        @extensions = crl_exts
        @version = 1
      end
    end
    
    typesig { [] }
    # Returned the encoding as an uncloned byte array. Callers must
    # guarantee that they neither modify it nor expose it to untrusted
    # code.
    def get_encoded_internal
      if ((@signed_crl).nil?)
        raise CRLException.new("Null CRL to encode")
      end
      return @signed_crl
    end
    
    typesig { [] }
    # Returns the ASN.1 DER encoded form of this CRL.
    # 
    # @exception CRLException if an encoding error occurs.
    def get_encoded
      return get_encoded_internal.clone
    end
    
    typesig { [OutputStream] }
    # Encodes the "to-be-signed" CRL to the OutputStream.
    # 
    # @param out the OutputStream to write to.
    # @exception CRLException on encoding errors.
    def encode_info(out)
      begin
        tmp = DerOutputStream.new
        r_certs = DerOutputStream.new
        seq = DerOutputStream.new
        if (!(@version).equal?(0))
          # v2 crl encode version
          tmp.put_integer(@version)
        end
        @info_sig_alg_id.encode(tmp)
        if (((@version).equal?(0)) && ((@issuer.to_s).nil?))
          raise CRLException.new("Null Issuer DN not allowed in v1 CRL")
        end
        @issuer.encode(tmp)
        if (@this_update.get_time < YR_2050)
          tmp.put_utctime(@this_update)
        else
          tmp.put_generalized_time(@this_update)
        end
        if (!(@next_update).nil?)
          if (@next_update.get_time < YR_2050)
            tmp.put_utctime(@next_update)
          else
            tmp.put_generalized_time(@next_update)
          end
        end
        if (!@revoked_certs.is_empty)
          @revoked_certs.values.each do |entry|
            (entry).encode(r_certs)
          end
          tmp.write(DerValue.attr_tag_sequence, r_certs)
        end
        if (!(@extensions).nil?)
          @extensions.encode(tmp, IsExplicit)
        end
        seq.write(DerValue.attr_tag_sequence, tmp)
        @tbs_cert_list = seq.to_byte_array
        out.write(@tbs_cert_list)
      rescue IOException => e
        raise CRLException.new("Encoding error: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [PublicKey] }
    # Verifies that this CRL was signed using the
    # private key that corresponds to the given public key.
    # 
    # @param key the PublicKey used to carry out the verification.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException if there's no default provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException on encoding errors.
    def verify(key)
      verify(key, "")
    end
    
    typesig { [PublicKey, String] }
    # Verifies that this CRL was signed using the
    # private key that corresponds to the given public key,
    # and that the signature verification was computed by
    # the given provider.
    # 
    # @param key the PublicKey used to carry out the verification.
    # @param sigProvider the name of the signature provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException on encoding errors.
    def verify(key, sig_provider)
      synchronized(self) do
        if ((sig_provider).nil?)
          sig_provider = ""
        end
        if ((!(@verified_public_key).nil?) && (@verified_public_key == key))
          # this CRL has already been successfully verified using
          # this public key. Make sure providers match, too.
          if ((sig_provider == @verified_provider))
            return
          end
        end
        if ((@signed_crl).nil?)
          raise CRLException.new("Uninitialized CRL")
        end
        sig_verf = nil
        if ((sig_provider.length).equal?(0))
          sig_verf = Signature.get_instance(@sig_alg_id.get_name)
        else
          sig_verf = Signature.get_instance(@sig_alg_id.get_name, sig_provider)
        end
        sig_verf.init_verify(key)
        if ((@tbs_cert_list).nil?)
          raise CRLException.new("Uninitialized CRL")
        end
        sig_verf.update(@tbs_cert_list, 0, @tbs_cert_list.attr_length)
        if (!sig_verf.verify(@signature))
          raise SignatureException.new("Signature does not match.")
        end
        @verified_public_key = key
        @verified_provider = sig_provider
      end
    end
    
    typesig { [PrivateKey, String] }
    # Encodes an X.509 CRL, and signs it using the given key.
    # 
    # @param key the private key used for signing.
    # @param algorithm the name of the signature algorithm used.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException if any mandatory data was omitted.
    def sign(key, algorithm)
      sign(key, algorithm, nil)
    end
    
    typesig { [PrivateKey, String, String] }
    # Encodes an X.509 CRL, and signs it using the given key.
    # 
    # @param key the private key used for signing.
    # @param algorithm the name of the signature algorithm used.
    # @param provider the name of the provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CRLException if any mandatory data was omitted.
    def sign(key, algorithm, provider)
      begin
        if (@read_only)
          raise CRLException.new("cannot over-write existing CRL")
        end
        sig_engine = nil
        if (((provider).nil?) || ((provider.length).equal?(0)))
          sig_engine = Signature.get_instance(algorithm)
        else
          sig_engine = Signature.get_instance(algorithm, provider)
        end
        sig_engine.init_sign(key)
        # in case the name is reset
        @sig_alg_id = AlgorithmId.get(sig_engine.get_algorithm)
        @info_sig_alg_id = @sig_alg_id
        out = DerOutputStream.new
        tmp = DerOutputStream.new
        # encode crl info
        encode_info(tmp)
        # encode algorithm identifier
        @sig_alg_id.encode(tmp)
        # Create and encode the signature itself.
        sig_engine.update(@tbs_cert_list, 0, @tbs_cert_list.attr_length)
        @signature = sig_engine.sign
        tmp.put_bit_string(@signature)
        # Wrap the signed data in a SEQUENCE { data, algorithm, sig }
        out.write(DerValue.attr_tag_sequence, tmp)
        @signed_crl = out.to_byte_array
        @read_only = true
      rescue IOException => e
        raise CRLException.new("Error while encoding data: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    # Returns a printable string of this CRL.
    # 
    # @return value of this CRL in a printable form.
    def to_s
      sb = StringBuffer.new
      sb.append("X.509 CRL v" + RJava.cast_to_string((@version + 1)) + "\n")
      if (!(@sig_alg_id).nil?)
        sb.append("Signature Algorithm: " + RJava.cast_to_string(@sig_alg_id.to_s) + ", OID=" + RJava.cast_to_string((@sig_alg_id.get_oid).to_s) + "\n")
      end
      if (!(@issuer).nil?)
        sb.append("Issuer: " + RJava.cast_to_string(@issuer.to_s) + "\n")
      end
      if (!(@this_update).nil?)
        sb.append("\nThis Update: " + RJava.cast_to_string(@this_update.to_s) + "\n")
      end
      if (!(@next_update).nil?)
        sb.append("Next Update: " + RJava.cast_to_string(@next_update.to_s) + "\n")
      end
      if (@revoked_certs.is_empty)
        sb.append("\nNO certificates have been revoked\n")
      else
        sb.append("\nRevoked Certificates: " + RJava.cast_to_string(@revoked_certs.size))
        i = 1
        iter = @revoked_certs.values.iterator
        while iter.has_next
          sb.append("\n[" + RJava.cast_to_string(i) + "] " + RJava.cast_to_string(iter.next_.to_s))
          i += 1
        end
      end
      if (!(@extensions).nil?)
        all_exts = @extensions.get_all_extensions
        objs = all_exts.to_array
        sb.append("\nCRL Extensions: " + RJava.cast_to_string(objs.attr_length))
        i = 0
        while i < objs.attr_length
          sb.append("\n[" + RJava.cast_to_string((i + 1)) + "]: ")
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
      if (!(@signature).nil?)
        encoder = HexDumpEncoder.new
        sb.append("\nSignature:\n" + RJava.cast_to_string(encoder.encode_buffer(@signature)) + "\n")
      else
        sb.append("NOT signed yet\n")
      end
      return sb.to_s
    end
    
    typesig { [Certificate] }
    # Checks whether the given certificate is on this CRL.
    # 
    # @param cert the certificate to check for.
    # @return true if the given certificate is on this CRL,
    # false otherwise.
    def is_revoked(cert)
      if (@revoked_certs.is_empty || (!(cert.is_a?(X509Certificate))))
        return false
      end
      xcert = cert
      issuer_serial = X509IssuerSerial.new(xcert)
      return @revoked_certs.contains_key(issuer_serial)
    end
    
    typesig { [] }
    # Gets the version number from this CRL.
    # The ASN.1 definition for this is:
    # <pre>
    # Version  ::=  INTEGER  {  v1(0), v2(1), v3(2)  }
    # -- v3 does not apply to CRLs but appears for consistency
    # -- with definition of Version for certs
    # </pre>
    # @return the version number, i.e. 1 or 2.
    def get_version
      return @version + 1
    end
    
    typesig { [] }
    # Gets the issuer distinguished name from this CRL.
    # The issuer name identifies the entity who has signed (and
    # issued the CRL). The issuer name field contains an
    # X.500 distinguished name (DN).
    # The ASN.1 definition for this is:
    # <pre>
    # issuer    Name
    # 
    # Name ::= CHOICE { RDNSequence }
    # RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
    # RelativeDistinguishedName ::=
    # SET OF AttributeValueAssertion
    # 
    # AttributeValueAssertion ::= SEQUENCE {
    # AttributeType,
    # AttributeValue }
    # AttributeType ::= OBJECT IDENTIFIER
    # AttributeValue ::= ANY
    # </pre>
    # The Name describes a hierarchical name composed of attributes,
    # such as country name, and corresponding values, such as US.
    # The type of the component AttributeValue is determined by the
    # AttributeType; in general it will be a directoryString.
    # A directoryString is usually one of PrintableString,
    # TeletexString or UniversalString.
    # @return the issuer name.
    def get_issuer_dn
      return @issuer
    end
    
    typesig { [] }
    # Return the issuer as X500Principal. Overrides method in X509CRL
    # to provide a slightly more efficient version.
    def get_issuer_x500principal
      if ((@issuer_principal).nil?)
        @issuer_principal = @issuer.as_x500principal
      end
      return @issuer_principal
    end
    
    typesig { [] }
    # Gets the thisUpdate date from the CRL.
    # The ASN.1 definition for this is:
    # 
    # @return the thisUpdate date from the CRL.
    def get_this_update
      return (Date.new(@this_update.get_time))
    end
    
    typesig { [] }
    # Gets the nextUpdate date from the CRL.
    # 
    # @return the nextUpdate date from the CRL, or null if
    # not present.
    def get_next_update
      if ((@next_update).nil?)
        return nil
      end
      return (Date.new(@next_update.get_time))
    end
    
    typesig { [BigInteger] }
    # Gets the CRL entry with the given serial number from this CRL.
    # 
    # @return the entry with the given serial number, or <code>null</code> if
    # no such entry exists in the CRL.
    # @see X509CRLEntry
    def get_revoked_certificate(serial_number)
      if (@revoked_certs.is_empty)
        return nil
      end
      # assume this is a direct CRL entry (cert and CRL issuer are the same)
      issuer_serial = X509IssuerSerial.new(get_issuer_x500principal, serial_number)
      return @revoked_certs.get(issuer_serial)
    end
    
    typesig { [X509Certificate] }
    # Gets the CRL entry for the given certificate.
    def get_revoked_certificate(cert)
      if (@revoked_certs.is_empty)
        return nil
      end
      issuer_serial = X509IssuerSerial.new(cert)
      return @revoked_certs.get(issuer_serial)
    end
    
    typesig { [] }
    # Gets all the revoked certificates from the CRL.
    # A Set of X509CRLEntry.
    # 
    # @return all the revoked certificates or <code>null</code> if there are
    # none.
    # @see X509CRLEntry
    def get_revoked_certificates
      if (@revoked_certs.is_empty)
        return nil
      else
        return HashSet.new(@revoked_certs.values)
      end
    end
    
    typesig { [] }
    # Gets the DER encoded CRL information, the
    # <code>tbsCertList</code> from this CRL.
    # This can be used to verify the signature independently.
    # 
    # @return the DER encoded CRL information.
    # @exception CRLException on encoding errors.
    def get_tbscert_list
      if ((@tbs_cert_list).nil?)
        raise CRLException.new("Uninitialized CRL")
      end
      dup = Array.typed(::Java::Byte).new(@tbs_cert_list.attr_length) { 0 }
      System.arraycopy(@tbs_cert_list, 0, dup, 0, dup.attr_length)
      return dup
    end
    
    typesig { [] }
    # Gets the raw Signature bits from the CRL.
    # 
    # @return the signature.
    def get_signature
      if ((@signature).nil?)
        return nil
      end
      dup = Array.typed(::Java::Byte).new(@signature.attr_length) { 0 }
      System.arraycopy(@signature, 0, dup, 0, dup.attr_length)
      return dup
    end
    
    typesig { [] }
    # Gets the signature algorithm name for the CRL
    # signature algorithm. For example, the string "SHA1withDSA".
    # The ASN.1 definition for this is:
    # <pre>
    # AlgorithmIdentifier  ::=  SEQUENCE  {
    # algorithm               OBJECT IDENTIFIER,
    # parameters              ANY DEFINED BY algorithm OPTIONAL  }
    # -- contains a value of the type
    # -- registered for use with the
    # -- algorithm object identifier value
    # </pre>
    # 
    # @return the signature algorithm name.
    def get_sig_alg_name
      if ((@sig_alg_id).nil?)
        return nil
      end
      return @sig_alg_id.get_name
    end
    
    typesig { [] }
    # Gets the signature algorithm OID string from the CRL.
    # An OID is represented by a set of positive whole number separated
    # by ".", that means,<br>
    # &lt;positive whole number&gt;.&lt;positive whole number&gt;.&lt;...&gt;
    # For example, the string "1.2.840.10040.4.3" identifies the SHA-1
    # with DSA signature algorithm defined in
    # <a href="http://www.ietf.org/rfc/rfc3279.txt">RFC 3279: Algorithms and
    # Identifiers for the Internet X.509 Public Key Infrastructure Certificate
    # and CRL Profile</a>.
    # 
    # @return the signature algorithm oid string.
    def get_sig_alg_oid
      if ((@sig_alg_id).nil?)
        return nil
      end
      oid = @sig_alg_id.get_oid
      return oid.to_s
    end
    
    typesig { [] }
    # Gets the DER encoded signature algorithm parameters from this
    # CRL's signature algorithm. In most cases, the signature
    # algorithm parameters are null, the parameters are usually
    # supplied with the Public Key.
    # 
    # @return the DER encoded signature algorithm parameters, or
    # null if no parameters are present.
    def get_sig_alg_params
      if ((@sig_alg_id).nil?)
        return nil
      end
      begin
        return @sig_alg_id.get_encoded_params
      rescue IOException => e
        return nil
      end
    end
    
    typesig { [] }
    # return the AuthorityKeyIdentifier, if any.
    # 
    # @returns AuthorityKeyIdentifier or null
    # (if no AuthorityKeyIdentifierExtension)
    # @throws IOException on error
    def get_auth_key_id
      aki = get_auth_key_id_extension
      if (!(aki).nil?)
        key_id = aki.get(aki.attr_key_id)
        return key_id
      else
        return nil
      end
    end
    
    typesig { [] }
    # return the AuthorityKeyIdentifierExtension, if any.
    # 
    # @returns AuthorityKeyIdentifierExtension or null (if no such extension)
    # @throws IOException on error
    def get_auth_key_id_extension
      obj = get_extension(PKIXExtensions::AuthorityKey_Id)
      return obj
    end
    
    typesig { [] }
    # return the CRLNumberExtension, if any.
    # 
    # @returns CRLNumberExtension or null (if no such extension)
    # @throws IOException on error
    def get_crlnumber_extension
      obj = get_extension(PKIXExtensions::CRLNumber_Id)
      return obj
    end
    
    typesig { [] }
    # return the CRL number from the CRLNumberExtension, if any.
    # 
    # @returns number or null (if no such extension)
    # @throws IOException on error
    def get_crlnumber
      num_ext = get_crlnumber_extension
      if (!(num_ext).nil?)
        num = num_ext.get(num_ext.attr_number)
        return num
      else
        return nil
      end
    end
    
    typesig { [] }
    # return the DeltaCRLIndicatorExtension, if any.
    # 
    # @returns DeltaCRLIndicatorExtension or null (if no such extension)
    # @throws IOException on error
    def get_delta_crlindicator_extension
      obj = get_extension(PKIXExtensions::DeltaCRLIndicator_Id)
      return obj
    end
    
    typesig { [] }
    # return the base CRL number from the DeltaCRLIndicatorExtension, if any.
    # 
    # @returns number or null (if no such extension)
    # @throws IOException on error
    def get_base_crlnumber
      dci_ext = get_delta_crlindicator_extension
      if (!(dci_ext).nil?)
        num = dci_ext.get(dci_ext.attr_number)
        return num
      else
        return nil
      end
    end
    
    typesig { [] }
    # return the IssuerAlternativeNameExtension, if any.
    # 
    # @returns IssuerAlternativeNameExtension or null (if no such extension)
    # @throws IOException on error
    def get_issuer_alt_name_extension
      obj = get_extension(PKIXExtensions::IssuerAlternativeName_Id)
      return obj
    end
    
    typesig { [] }
    # return the IssuingDistributionPointExtension, if any.
    # 
    # @returns IssuingDistributionPointExtension or null
    # (if no such extension)
    # @throws IOException on error
    def get_issuing_distribution_point_extension
      obj = get_extension(PKIXExtensions::IssuingDistributionPoint_Id)
      return obj
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
    # Gets a Set of the extension(s) marked CRITICAL in the
    # CRL. In the returned set, each extension is represented by
    # its OID string.
    # 
    # @return a set of the extension oid strings in the
    # CRL that are marked critical.
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
    # Gets a Set of the extension(s) marked NON-CRITICAL in the
    # CRL. In the returned set, each extension is represented by
    # its OID string.
    # 
    # @return a set of the extension oid strings in the
    # CRL that are NOT marked critical.
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
    # (<code>extnValue</code>) identified by the passed in oid String.
    # The <code>oid</code> string is
    # represented by a set of positive whole number separated
    # by ".", that means,<br>
    # &lt;positive whole number&gt;.&lt;positive whole number&gt;.&lt;...&gt;
    # 
    # @param oid the Object Identifier value for the extension.
    # @return the der encoded octet string of the extension value.
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
    # @returns Object of type <extension> or null, if not found
    # @throws IOException on error
    def get_extension(oid)
      if ((@extensions).nil?)
        return nil
      end
      # XXX Consider cloning this
      return @extensions.get(OIDMap.get_name(oid))
    end
    
    typesig { [DerValue] }
    # Parses an X.509 CRL, should be used only by constructors.
    def parse(val)
      # check if can over write the certificate
      if (@read_only)
        raise CRLException.new("cannot over-write existing CRL")
      end
      if ((val.get_data).nil? || !(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CRLException.new("Invalid DER-encoded CRL data")
      end
      @signed_crl = val.to_byte_array
      seq = Array.typed(DerValue).new(3) { nil }
      seq[0] = val.attr_data.get_der_value
      seq[1] = val.attr_data.get_der_value
      seq[2] = val.attr_data.get_der_value
      if (!(val.attr_data.available).equal?(0))
        raise CRLException.new("signed overrun, bytes = " + RJava.cast_to_string(val.attr_data.available))
      end
      if (!(seq[0].attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CRLException.new("signed CRL fields invalid")
      end
      @sig_alg_id = AlgorithmId.parse(seq[1])
      @signature = seq[2].get_bit_string
      if (!(seq[1].attr_data.available).equal?(0))
        raise CRLException.new("AlgorithmId field overrun")
      end
      if (!(seq[2].attr_data.available).equal?(0))
        raise CRLException.new("Signature field overrun")
      end
      # the tbsCertsList
      @tbs_cert_list = seq[0].to_byte_array
      # parse the information
      der_strm = seq[0].attr_data
      tmp = nil
      next_byte = 0
      # version (optional if v1)
      @version = 0 # by default, version = v1 == 0
      next_byte = der_strm.peek_byte
      if ((next_byte).equal?(DerValue.attr_tag_integer))
        @version = der_strm.get_integer
        if (!(@version).equal?(1))
          # i.e. v2
          raise CRLException.new("Invalid version")
        end
      end
      tmp = der_strm.get_der_value
      # signature
      tmp_id = AlgorithmId.parse(tmp)
      # the "inner" and "outer" signature algorithms must match
      if (!(tmp_id == @sig_alg_id))
        raise CRLException.new("Signature algorithm mismatch")
      end
      @info_sig_alg_id = tmp_id
      # issuer
      @issuer = X500Name.new(der_strm)
      if (@issuer.is_empty)
        raise CRLException.new("Empty issuer DN not allowed in X509CRLs")
      end
      # thisUpdate
      # check if UTCTime encoded or GeneralizedTime
      next_byte = der_strm.peek_byte
      if ((next_byte).equal?(DerValue.attr_tag_utc_time))
        @this_update = der_strm.get_utctime
      else
        if ((next_byte).equal?(DerValue.attr_tag_generalized_time))
          @this_update = der_strm.get_generalized_time
        else
          raise CRLException.new("Invalid encoding for thisUpdate" + " (tag=" + RJava.cast_to_string(next_byte) + ")")
        end
      end
      if ((der_strm.available).equal?(0))
        return
      end # done parsing no more optional fields present
      # nextUpdate (optional)
      next_byte = der_strm.peek_byte
      if ((next_byte).equal?(DerValue.attr_tag_utc_time))
        @next_update = der_strm.get_utctime
      else
        if ((next_byte).equal?(DerValue.attr_tag_generalized_time))
          @next_update = der_strm.get_generalized_time
        end
      end # else it is not present
      if ((der_strm.available).equal?(0))
        return
      end # done parsing no more optional fields present
      # revokedCertificates (optional)
      next_byte = der_strm.peek_byte
      if (((next_byte).equal?(DerValue.attr_tag_sequence_of)) && (!(((next_byte & 0xc0)).equal?(0x80))))
        bad_certs = der_strm.get_sequence(4)
        crl_issuer = get_issuer_x500principal
        bad_cert_issuer = crl_issuer
        i = 0
        while i < bad_certs.attr_length
          entry = X509CRLEntryImpl.new(bad_certs[i])
          bad_cert_issuer = get_cert_issuer(entry, bad_cert_issuer)
          entry.set_certificate_issuer(crl_issuer, bad_cert_issuer)
          issuer_serial = X509IssuerSerial.new(bad_cert_issuer, entry.get_serial_number)
          @revoked_certs.put(issuer_serial, entry)
          i += 1
        end
      end
      if ((der_strm.available).equal?(0))
        return
      end # done parsing no extensions
      # crlExtensions (optional)
      tmp = der_strm.get_der_value
      if (tmp.is_constructed && tmp.is_context_specific(0))
        @extensions = CRLExtensions.new(tmp.attr_data)
      end
      @read_only = true
    end
    
    class_module.module_eval {
      typesig { [X509CRL] }
      # Extract the issuer X500Principal from an X509CRL. Parses the encoded
      # form of the CRL to preserve the principal's ASN.1 encoding.
      # 
      # Called by java.security.cert.X509CRL.getIssuerX500Principal().
      def get_issuer_x500principal(crl)
        begin
          encoded = crl.get_encoded
          der_in = DerInputStream.new(encoded)
          tbs_cert = der_in.get_sequence(3)[0]
          tbs_in = tbs_cert.attr_data
          tmp = nil
          # skip version number if present
          next_byte = tbs_in.peek_byte
          if ((next_byte).equal?(DerValue.attr_tag_integer))
            tmp = tbs_in.get_der_value
          end
          tmp = tbs_in.get_der_value # skip signature
          tmp = tbs_in.get_der_value # issuer
          principal_bytes = tmp.to_byte_array
          return X500Principal.new(principal_bytes)
        rescue JavaException => e
          raise RuntimeException.new("Could not parse issuer", e)
        end
      end
      
      typesig { [X509CRL] }
      # Returned the encoding of the given certificate for internal use.
      # Callers must guarantee that they neither modify it nor expose it
      # to untrusted code. Uses getEncodedInternal() if the certificate
      # is instance of X509CertImpl, getEncoded() otherwise.
      def get_encoded_internal(crl)
        if (crl.is_a?(X509CRLImpl))
          return (crl).get_encoded_internal
        else
          return crl.get_encoded
        end
      end
      
      typesig { [X509CRL] }
      # Utility method to convert an arbitrary instance of X509CRL
      # to a X509CRLImpl. Does a cast if possible, otherwise reparses
      # the encoding.
      def to_impl(crl)
        if (crl.is_a?(X509CRLImpl))
          return crl
        else
          return X509Factory.intern(crl)
        end
      end
    }
    
    typesig { [X509CRLEntryImpl, X500Principal] }
    # Returns the X500 certificate issuer DN of a CRL entry.
    # 
    # @param entry the entry to check
    # @param prevCertIssuer the previous entry's certificate issuer
    # @return the X500Principal in a CertificateIssuerExtension, or
    # prevCertIssuer if it does not exist
    def get_cert_issuer(entry, prev_cert_issuer)
      ci_ext = entry.get_certificate_issuer_extension
      if (!(ci_ext).nil?)
        names = ci_ext.get(CertificateIssuerExtension::ISSUER)
        issuer_dn = names.get(0).get_name
        return issuer_dn.as_x500principal
      else
        return prev_cert_issuer
      end
    end
    
    class_module.module_eval {
      # Immutable X.509 Certificate Issuer DN and serial number pair
      const_set_lazy(:X509IssuerSerial) { Class.new do
        include_class_members X509CRLImpl
        
        attr_accessor :issuer
        alias_method :attr_issuer, :issuer
        undef_method :issuer
        alias_method :attr_issuer=, :issuer=
        undef_method :issuer=
        
        attr_accessor :serial
        alias_method :attr_serial, :serial
        undef_method :serial
        alias_method :attr_serial=, :serial=
        undef_method :serial=
        
        attr_accessor :hashcode
        alias_method :attr_hashcode, :hashcode
        undef_method :hashcode
        alias_method :attr_hashcode=, :hashcode=
        undef_method :hashcode=
        
        typesig { [self::X500Principal, self::BigInteger] }
        # Create an X509IssuerSerial.
        # 
        # @param issuer the issuer DN
        # @param serial the serial number
        def initialize(issuer, serial)
          @issuer = nil
          @serial = nil
          @hashcode = 0
          @issuer = issuer
          @serial = serial
        end
        
        typesig { [self::X509Certificate] }
        # Construct an X509IssuerSerial from an X509Certificate.
        def initialize(cert)
          initialize__x509issuer_serial(cert.get_issuer_x500principal, cert.get_serial_number)
        end
        
        typesig { [] }
        # Returns the issuer.
        # 
        # @return the issuer
        def get_issuer
          return @issuer
        end
        
        typesig { [] }
        # Returns the serial number.
        # 
        # @return the serial number
        def get_serial
          return @serial
        end
        
        typesig { [Object] }
        # Compares this X509Serial with another and returns true if they
        # are equivalent.
        # 
        # @param o the other object to compare with
        # @return true if equal, false otherwise
        def ==(o)
          if ((o).equal?(self))
            return true
          end
          if (!(o.is_a?(self.class::X509IssuerSerial)))
            return false
          end
          other = o
          if ((@serial == other.get_serial) && (@issuer == other.get_issuer))
            return true
          end
          return false
        end
        
        typesig { [] }
        # Returns a hash code value for this X509IssuerSerial.
        # 
        # @return the hash code value
        def hash_code
          if ((@hashcode).equal?(0))
            result = 17
            result = 37 * result + @issuer.hash_code
            result = 37 * result + @serial.hash_code
            @hashcode = result
          end
          return @hashcode
        end
        
        private
        alias_method :initialize__x509issuer_serial, :initialize
      end }
    }
    
    private
    alias_method :initialize__x509crlimpl, :initialize
  end
  
end

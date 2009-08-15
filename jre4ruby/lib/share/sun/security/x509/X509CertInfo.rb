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
  module X509CertInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Security::Cert
      include ::Java::Util
      include ::Sun::Security::Util
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # The X509CertInfo class represents X.509 certificate information.
  # 
  # <P>X.509 certificates have several base data elements, including:<UL>
  # 
  # <LI>The <em>Subject Name</em>, an X.500 Distinguished Name for
  # the entity (subject) for which the certificate was issued.
  # 
  # <LI>The <em>Subject Public Key</em>, the public key of the subject.
  # This is one of the most important parts of the certificate.
  # 
  # <LI>The <em>Validity Period</em>, a time period (e.g. six months)
  # within which the certificate is valid (unless revoked).
  # 
  # <LI>The <em>Issuer Name</em>, an X.500 Distinguished Name for the
  # Certificate Authority (CA) which issued the certificate.
  # 
  # <LI>A <em>Serial Number</em> assigned by the CA, for use in
  # certificate revocation and other applications.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  # @see X509CertImpl
  class X509CertInfo 
    include_class_members X509CertInfoImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info" }
      const_attr_reader  :IDENT
      
      # Certificate attribute names
      const_set_lazy(:NAME) { "info" }
      const_attr_reader  :NAME
      
      const_set_lazy(:VERSION) { CertificateVersion::NAME }
      const_attr_reader  :VERSION
      
      const_set_lazy(:SERIAL_NUMBER) { CertificateSerialNumber::NAME }
      const_attr_reader  :SERIAL_NUMBER
      
      const_set_lazy(:ALGORITHM_ID) { CertificateAlgorithmId::NAME }
      const_attr_reader  :ALGORITHM_ID
      
      const_set_lazy(:ISSUER) { CertificateIssuerName::NAME }
      const_attr_reader  :ISSUER
      
      const_set_lazy(:VALIDITY) { CertificateValidity::NAME }
      const_attr_reader  :VALIDITY
      
      const_set_lazy(:SUBJECT) { CertificateSubjectName::NAME }
      const_attr_reader  :SUBJECT
      
      const_set_lazy(:KEY) { CertificateX509Key::NAME }
      const_attr_reader  :KEY
      
      const_set_lazy(:ISSUER_ID) { CertificateIssuerUniqueIdentity::NAME }
      const_attr_reader  :ISSUER_ID
      
      const_set_lazy(:SUBJECT_ID) { CertificateSubjectUniqueIdentity::NAME }
      const_attr_reader  :SUBJECT_ID
      
      const_set_lazy(:EXTENSIONS) { CertificateExtensions::NAME }
      const_attr_reader  :EXTENSIONS
    }
    
    # X509.v1 data
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :serial_num
    alias_method :attr_serial_num, :serial_num
    undef_method :serial_num
    alias_method :attr_serial_num=, :serial_num=
    undef_method :serial_num=
    
    attr_accessor :alg_id
    alias_method :attr_alg_id, :alg_id
    undef_method :alg_id
    alias_method :attr_alg_id=, :alg_id=
    undef_method :alg_id=
    
    attr_accessor :issuer
    alias_method :attr_issuer, :issuer
    undef_method :issuer
    alias_method :attr_issuer=, :issuer=
    undef_method :issuer=
    
    attr_accessor :interval
    alias_method :attr_interval, :interval
    undef_method :interval
    alias_method :attr_interval=, :interval=
    undef_method :interval=
    
    attr_accessor :subject
    alias_method :attr_subject, :subject
    undef_method :subject
    alias_method :attr_subject=, :subject=
    undef_method :subject=
    
    attr_accessor :pub_key
    alias_method :attr_pub_key, :pub_key
    undef_method :pub_key
    alias_method :attr_pub_key=, :pub_key=
    undef_method :pub_key=
    
    # X509.v2 & v3 extensions
    attr_accessor :issuer_unique_id
    alias_method :attr_issuer_unique_id, :issuer_unique_id
    undef_method :issuer_unique_id
    alias_method :attr_issuer_unique_id=, :issuer_unique_id=
    undef_method :issuer_unique_id=
    
    attr_accessor :subject_unique_id
    alias_method :attr_subject_unique_id, :subject_unique_id
    undef_method :subject_unique_id
    alias_method :attr_subject_unique_id=, :subject_unique_id=
    undef_method :subject_unique_id=
    
    # X509.v3 extensions
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    class_module.module_eval {
      # Attribute numbers for internal manipulation
      const_set_lazy(:ATTR_VERSION) { 1 }
      const_attr_reader  :ATTR_VERSION
      
      const_set_lazy(:ATTR_SERIAL) { 2 }
      const_attr_reader  :ATTR_SERIAL
      
      const_set_lazy(:ATTR_ALGORITHM) { 3 }
      const_attr_reader  :ATTR_ALGORITHM
      
      const_set_lazy(:ATTR_ISSUER) { 4 }
      const_attr_reader  :ATTR_ISSUER
      
      const_set_lazy(:ATTR_VALIDITY) { 5 }
      const_attr_reader  :ATTR_VALIDITY
      
      const_set_lazy(:ATTR_SUBJECT) { 6 }
      const_attr_reader  :ATTR_SUBJECT
      
      const_set_lazy(:ATTR_KEY) { 7 }
      const_attr_reader  :ATTR_KEY
      
      const_set_lazy(:ATTR_ISSUER_ID) { 8 }
      const_attr_reader  :ATTR_ISSUER_ID
      
      const_set_lazy(:ATTR_SUBJECT_ID) { 9 }
      const_attr_reader  :ATTR_SUBJECT_ID
      
      const_set_lazy(:ATTR_EXTENSIONS) { 10 }
      const_attr_reader  :ATTR_EXTENSIONS
    }
    
    # DER encoded CertificateInfo data
    attr_accessor :raw_cert_info
    alias_method :attr_raw_cert_info, :raw_cert_info
    undef_method :raw_cert_info
    alias_method :attr_raw_cert_info=, :raw_cert_info=
    undef_method :raw_cert_info=
    
    class_module.module_eval {
      # The certificate attribute name to integer mapping stored here
      const_set_lazy(:Map) { HashMap.new }
      const_attr_reader  :Map
      
      when_class_loaded do
        Map.put(VERSION, JavaInteger.value_of(ATTR_VERSION))
        Map.put(SERIAL_NUMBER, JavaInteger.value_of(ATTR_SERIAL))
        Map.put(ALGORITHM_ID, JavaInteger.value_of(ATTR_ALGORITHM))
        Map.put(ISSUER, JavaInteger.value_of(ATTR_ISSUER))
        Map.put(VALIDITY, JavaInteger.value_of(ATTR_VALIDITY))
        Map.put(SUBJECT, JavaInteger.value_of(ATTR_SUBJECT))
        Map.put(KEY, JavaInteger.value_of(ATTR_KEY))
        Map.put(ISSUER_ID, JavaInteger.value_of(ATTR_ISSUER_ID))
        Map.put(SUBJECT_ID, JavaInteger.value_of(ATTR_SUBJECT_ID))
        Map.put(EXTENSIONS, JavaInteger.value_of(ATTR_EXTENSIONS))
      end
    }
    
    typesig { [] }
    # Construct an uninitialized X509CertInfo on which <a href="#decode">
    # decode</a> must later be called (or which may be deserialized).
    def initialize
      @version = CertificateVersion.new
      @serial_num = nil
      @alg_id = nil
      @issuer = nil
      @interval = nil
      @subject = nil
      @pub_key = nil
      @issuer_unique_id = nil
      @subject_unique_id = nil
      @extensions = nil
      @raw_cert_info = nil
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Unmarshals a certificate from its encoded form, parsing the
    # encoded bytes.  This form of constructor is used by agents which
    # need to examine and use certificate contents.  That is, this is
    # one of the more commonly used constructors.  Note that the buffer
    # must include only a certificate, and no "garbage" may be left at
    # the end.  If you need to ignore data at the end of a certificate,
    # use another constructor.
    # 
    # @param cert the encoded bytes, with no trailing data.
    # @exception CertificateParsingException on parsing errors.
    def initialize(cert)
      @version = CertificateVersion.new
      @serial_num = nil
      @alg_id = nil
      @issuer = nil
      @interval = nil
      @subject = nil
      @pub_key = nil
      @issuer_unique_id = nil
      @subject_unique_id = nil
      @extensions = nil
      @raw_cert_info = nil
      begin
        in_ = DerValue.new(cert)
        parse(in_)
      rescue IOException => e
        parse_exception = CertificateParsingException.new(e.to_s)
        parse_exception.init_cause(e)
        raise parse_exception
      end
    end
    
    typesig { [DerValue] }
    # Unmarshal a certificate from its encoded form, parsing a DER value.
    # This form of constructor is used by agents which need to examine
    # and use certificate contents.
    # 
    # @param derVal the der value containing the encoded cert.
    # @exception CertificateParsingException on parsing errors.
    def initialize(der_val)
      @version = CertificateVersion.new
      @serial_num = nil
      @alg_id = nil
      @issuer = nil
      @interval = nil
      @subject = nil
      @pub_key = nil
      @issuer_unique_id = nil
      @subject_unique_id = nil
      @extensions = nil
      @raw_cert_info = nil
      begin
        parse(der_val)
      rescue IOException => e
        parse_exception = CertificateParsingException.new(e.to_s)
        parse_exception.init_cause(e)
        raise parse_exception
      end
    end
    
    typesig { [OutputStream] }
    # Appends the certificate to an output stream.
    # 
    # @param out an output stream to which the certificate is appended.
    # @exception CertificateException on encoding errors.
    # @exception IOException on other errors.
    def encode(out)
      if ((@raw_cert_info).nil?)
        tmp = DerOutputStream.new
        emit(tmp)
        @raw_cert_info = tmp.to_byte_array
      end
      out.write(@raw_cert_info.clone)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(VERSION)
      elements.add_element(SERIAL_NUMBER)
      elements.add_element(ALGORITHM_ID)
      elements.add_element(ISSUER)
      elements.add_element(VALIDITY)
      elements.add_element(SUBJECT)
      elements.add_element(KEY)
      elements.add_element(ISSUER_ID)
      elements.add_element(SUBJECT_ID)
      elements.add_element(EXTENSIONS)
      return elements.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [] }
    # Returns the encoded certificate info.
    # 
    # @exception CertificateEncodingException on encoding information errors.
    def get_encoded_info
      begin
        if ((@raw_cert_info).nil?)
          tmp = DerOutputStream.new
          emit(tmp)
          @raw_cert_info = tmp.to_byte_array
        end
        return @raw_cert_info.clone
      rescue IOException => e
        raise CertificateEncodingException.new(e.to_s)
      rescue CertificateException => e
        raise CertificateEncodingException.new(e.to_s)
      end
    end
    
    typesig { [Object] }
    # Compares two X509CertInfo objects.  This is false if the
    # certificates are not both X.509 certs, otherwise it
    # compares them as binary data.
    # 
    # @param other the object being compared with this one
    # @return true iff the certificates are equivalent
    def ==(other)
      if (other.is_a?(X509CertInfo))
        return self.==(other)
      else
        return false
      end
    end
    
    typesig { [X509CertInfo] }
    # Compares two certificates, returning false if any data
    # differs between the two.
    # 
    # @param other the object being compared with this one
    # @return true iff the certificates are equivalent
    def ==(other)
      if ((self).equal?(other))
        return (true)
      else
        if ((@raw_cert_info).nil? || (other.attr_raw_cert_info).nil?)
          return (false)
        else
          if (!(@raw_cert_info.attr_length).equal?(other.attr_raw_cert_info.attr_length))
            return (false)
          end
        end
      end
      i = 0
      while i < @raw_cert_info.attr_length
        if (!(@raw_cert_info[i]).equal?(other.attr_raw_cert_info[i]))
          return (false)
        end
        i += 1
      end
      return (true)
    end
    
    typesig { [] }
    # Calculates a hash code value for the object.  Objects
    # which are equal will also have the same hashcode.
    def hash_code
      retval = 0
      i = 1
      while i < @raw_cert_info.attr_length
        retval += @raw_cert_info[i] * i
        i += 1
      end
      return (retval)
    end
    
    typesig { [] }
    # Returns a printable representation of the certificate.
    def to_s
      if ((@subject).nil? || (@pub_key).nil? || (@interval).nil? || (@issuer).nil? || (@alg_id).nil? || (@serial_num).nil?)
        raise NullPointerException.new("X.509 cert is incomplete")
      end
      sb = StringBuilder.new
      sb.append("[\n")
      sb.append("  " + RJava.cast_to_string(@version.to_s) + "\n")
      sb.append("  Subject: " + RJava.cast_to_string(@subject.to_s) + "\n")
      sb.append("  Signature Algorithm: " + RJava.cast_to_string(@alg_id.to_s) + "\n")
      sb.append("  Key:  " + RJava.cast_to_string(@pub_key.to_s) + "\n")
      sb.append("  " + RJava.cast_to_string(@interval.to_s) + "\n")
      sb.append("  Issuer: " + RJava.cast_to_string(@issuer.to_s) + "\n")
      sb.append("  " + RJava.cast_to_string(@serial_num.to_s) + "\n")
      # optional v2, v3 extras
      if (!(@issuer_unique_id).nil?)
        sb.append("  Issuer Id:\n" + RJava.cast_to_string(@issuer_unique_id.to_s) + "\n")
      end
      if (!(@subject_unique_id).nil?)
        sb.append("  Subject Id:\n" + RJava.cast_to_string(@subject_unique_id.to_s) + "\n")
      end
      if (!(@extensions).nil?)
        all_exts = @extensions.get_all_extensions
        objs = all_exts.to_array
        sb.append("\nCertificate Extensions: " + RJava.cast_to_string(objs.attr_length))
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
        invalid = @extensions.get_unparseable_extensions
        if ((invalid.is_empty).equal?(false))
          sb.append("\nUnparseable certificate extensions: " + RJava.cast_to_string(invalid.size))
          i_ = 1
          invalid.values.each do |ext|
            sb.append("\n[" + RJava.cast_to_string((((i_ += 1) - 1))) + "]: ")
            sb.append(ext)
          end
        end
      end
      sb.append("\n]")
      return sb.to_s
    end
    
    typesig { [String, Object] }
    # Set the certificate attribute.
    # 
    # @params name the name of the Certificate attribute.
    # @params val the value of the Certificate attribute.
    # @exception CertificateException on invalid attributes.
    # @exception IOException on other errors.
    def set(name, val)
      attr_name = X509AttributeName.new(name)
      attr = attribute_map(attr_name.get_prefix)
      if ((attr).equal?(0))
        raise CertificateException.new("Attribute name not recognized: " + name)
      end
      # set rawCertInfo to null, so that we are forced to re-encode
      @raw_cert_info = nil
      suffix = attr_name.get_suffix
      case (attr)
      when ATTR_VERSION
        if ((suffix).nil?)
          set_version(val)
        else
          @version.set(suffix, val)
        end
      when ATTR_SERIAL
        if ((suffix).nil?)
          set_serial_number(val)
        else
          @serial_num.set(suffix, val)
        end
      when ATTR_ALGORITHM
        if ((suffix).nil?)
          set_algorithm_id(val)
        else
          @alg_id.set(suffix, val)
        end
      when ATTR_ISSUER
        if ((suffix).nil?)
          set_issuer(val)
        else
          @issuer.set(suffix, val)
        end
      when ATTR_VALIDITY
        if ((suffix).nil?)
          set_validity(val)
        else
          @interval.set(suffix, val)
        end
      when ATTR_SUBJECT
        if ((suffix).nil?)
          set_subject(val)
        else
          @subject.set(suffix, val)
        end
      when ATTR_KEY
        if ((suffix).nil?)
          set_key(val)
        else
          @pub_key.set(suffix, val)
        end
      when ATTR_ISSUER_ID
        if ((suffix).nil?)
          set_issuer_unique_id(val)
        else
          @issuer_unique_id.set(suffix, val)
        end
      when ATTR_SUBJECT_ID
        if ((suffix).nil?)
          set_subject_unique_id(val)
        else
          @subject_unique_id.set(suffix, val)
        end
      when ATTR_EXTENSIONS
        if ((suffix).nil?)
          set_extensions(val)
        else
          if ((@extensions).nil?)
            @extensions = CertificateExtensions.new
          end
          @extensions.set(suffix, val)
        end
      end
    end
    
    typesig { [String] }
    # Delete the certificate attribute.
    # 
    # @params name the name of the Certificate attribute.
    # @exception CertificateException on invalid attributes.
    # @exception IOException on other errors.
    def delete(name)
      attr_name = X509AttributeName.new(name)
      attr = attribute_map(attr_name.get_prefix)
      if ((attr).equal?(0))
        raise CertificateException.new("Attribute name not recognized: " + name)
      end
      # set rawCertInfo to null, so that we are forced to re-encode
      @raw_cert_info = nil
      suffix = attr_name.get_suffix
      case (attr)
      when ATTR_VERSION
        if ((suffix).nil?)
          @version = nil
        else
          @version.delete(suffix)
        end
      when (ATTR_SERIAL)
        if ((suffix).nil?)
          @serial_num = nil
        else
          @serial_num.delete(suffix)
        end
      when (ATTR_ALGORITHM)
        if ((suffix).nil?)
          @alg_id = nil
        else
          @alg_id.delete(suffix)
        end
      when (ATTR_ISSUER)
        if ((suffix).nil?)
          @issuer = nil
        else
          @issuer.delete(suffix)
        end
      when (ATTR_VALIDITY)
        if ((suffix).nil?)
          @interval = nil
        else
          @interval.delete(suffix)
        end
      when (ATTR_SUBJECT)
        if ((suffix).nil?)
          @subject = nil
        else
          @subject.delete(suffix)
        end
      when (ATTR_KEY)
        if ((suffix).nil?)
          @pub_key = nil
        else
          @pub_key.delete(suffix)
        end
      when (ATTR_ISSUER_ID)
        if ((suffix).nil?)
          @issuer_unique_id = nil
        else
          @issuer_unique_id.delete(suffix)
        end
      when (ATTR_SUBJECT_ID)
        if ((suffix).nil?)
          @subject_unique_id = nil
        else
          @subject_unique_id.delete(suffix)
        end
      when (ATTR_EXTENSIONS)
        if ((suffix).nil?)
          @extensions = nil
        else
          if (!(@extensions).nil?)
            @extensions.delete(suffix)
          end
        end
      end
    end
    
    typesig { [String] }
    # Get the certificate attribute.
    # 
    # @params name the name of the Certificate attribute.
    # 
    # @exception CertificateException on invalid attributes.
    # @exception IOException on other errors.
    def get(name)
      attr_name = X509AttributeName.new(name)
      attr = attribute_map(attr_name.get_prefix)
      if ((attr).equal?(0))
        raise CertificateParsingException.new("Attribute name not recognized: " + name)
      end
      suffix = attr_name.get_suffix
      case (attr) # frequently used attributes first
      when (ATTR_EXTENSIONS)
        if ((suffix).nil?)
          return (@extensions)
        else
          if ((@extensions).nil?)
            return nil
          else
            return (@extensions.get(suffix))
          end
        end
      when (ATTR_SUBJECT)
        if ((suffix).nil?)
          return (@subject)
        else
          return (@subject.get(suffix))
        end
      when (ATTR_ISSUER)
        if ((suffix).nil?)
          return (@issuer)
        else
          return (@issuer.get(suffix))
        end
      when (ATTR_KEY)
        if ((suffix).nil?)
          return (@pub_key)
        else
          return (@pub_key.get(suffix))
        end
      when (ATTR_ALGORITHM)
        if ((suffix).nil?)
          return (@alg_id)
        else
          return (@alg_id.get(suffix))
        end
      when (ATTR_VALIDITY)
        if ((suffix).nil?)
          return (@interval)
        else
          return (@interval.get(suffix))
        end
      when (ATTR_VERSION)
        if ((suffix).nil?)
          return (@version)
        else
          return (@version.get(suffix))
        end
      when (ATTR_SERIAL)
        if ((suffix).nil?)
          return (@serial_num)
        else
          return (@serial_num.get(suffix))
        end
      when (ATTR_ISSUER_ID)
        if ((suffix).nil?)
          return (@issuer_unique_id)
        else
          if ((@issuer_unique_id).nil?)
            return nil
          else
            return (@issuer_unique_id.get(suffix))
          end
        end
      when (ATTR_SUBJECT_ID)
        if ((suffix).nil?)
          return (@subject_unique_id)
        else
          if ((@subject_unique_id).nil?)
            return nil
          else
            return (@subject_unique_id.get(suffix))
          end
        end
      end
      return nil
    end
    
    typesig { [DerValue] }
    # This routine unmarshals the certificate information.
    def parse(val)
      in_ = nil
      tmp = nil
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise CertificateParsingException.new("signed fields invalid")
      end
      @raw_cert_info = val.to_byte_array
      in_ = val.attr_data
      # Version
      tmp = in_.get_der_value
      if (tmp.is_context_specific(0))
        @version = CertificateVersion.new(tmp)
        tmp = in_.get_der_value
      end
      # Serial number ... an integer
      @serial_num = CertificateSerialNumber.new(tmp)
      # Algorithm Identifier
      @alg_id = CertificateAlgorithmId.new(in_)
      # Issuer name
      @issuer = CertificateIssuerName.new(in_)
      issuer_dn = @issuer.get(CertificateIssuerName::DN_NAME)
      if (issuer_dn.is_empty)
        raise CertificateParsingException.new("Empty issuer DN not allowed in X509Certificates")
      end
      # validity:  SEQUENCE { start date, end date }
      @interval = CertificateValidity.new(in_)
      # subject name
      @subject = CertificateSubjectName.new(in_)
      subject_dn = @subject.get(CertificateSubjectName::DN_NAME)
      if (((@version.compare(CertificateVersion::V1)).equal?(0)) && subject_dn.is_empty)
        raise CertificateParsingException.new("Empty subject DN not allowed in v1 certificate")
      end
      # public key
      @pub_key = CertificateX509Key.new(in_)
      # If more data available, make sure version is not v1.
      if (!(in_.available).equal?(0))
        if ((@version.compare(CertificateVersion::V1)).equal?(0))
          raise CertificateParsingException.new("no more data allowed for version 1 certificate")
        end
      else
        return
      end
      # Get the issuerUniqueId if present
      tmp = in_.get_der_value
      if (tmp.is_context_specific(1))
        @issuer_unique_id = CertificateIssuerUniqueIdentity.new(tmp)
        if ((in_.available).equal?(0))
          return
        end
        tmp = in_.get_der_value
      end
      # Get the subjectUniqueId if present.
      if (tmp.is_context_specific(2))
        @subject_unique_id = CertificateSubjectUniqueIdentity.new(tmp)
        if ((in_.available).equal?(0))
          return
        end
        tmp = in_.get_der_value
      end
      # Get the extensions.
      if (!(@version.compare(CertificateVersion::V3)).equal?(0))
        raise CertificateParsingException.new("Extensions not allowed in v2 certificate")
      end
      if (tmp.is_constructed && tmp.is_context_specific(3))
        @extensions = CertificateExtensions.new(tmp.attr_data)
      end
      # verify X.509 V3 Certificate
      verify_cert(@subject, @extensions)
    end
    
    typesig { [CertificateSubjectName, CertificateExtensions] }
    # Verify if X.509 V3 Certificate is compliant with RFC 3280.
    def verify_cert(subject, extensions)
      # if SubjectName is empty, check for SubjectAlternativeNameExtension
      subject_dn = subject.get(CertificateSubjectName::DN_NAME)
      if (subject_dn.is_empty)
        if ((extensions).nil?)
          raise CertificateParsingException.new("X.509 Certificate is " + "incomplete: subject field is empty, and certificate " + "has no extensions")
        end
        subject_alt_name_ext = nil
        ext_value = nil
        names = nil
        begin
          subject_alt_name_ext = extensions.get(SubjectAlternativeNameExtension::NAME)
          names = subject_alt_name_ext.get(SubjectAlternativeNameExtension::SUBJECT_NAME)
        rescue IOException => e
          raise CertificateParsingException.new("X.509 Certificate is " + "incomplete: subject field is empty, and " + "SubjectAlternativeName extension is absent")
        end
        # SubjectAlternativeName extension is empty or not marked critical
        if ((names).nil? || names.is_empty)
          raise CertificateParsingException.new("X.509 Certificate is " + "incomplete: subject field is empty, and " + "SubjectAlternativeName extension is empty")
        else
          if ((subject_alt_name_ext.is_critical).equal?(false))
            raise CertificateParsingException.new("X.509 Certificate is " + "incomplete: SubjectAlternativeName extension MUST " + "be marked critical when subject field is empty")
          end
        end
      end
    end
    
    typesig { [DerOutputStream] }
    # Marshal the contents of a "raw" certificate into a DER sequence.
    def emit(out)
      tmp = DerOutputStream.new
      # version number, iff not V1
      @version.encode(tmp)
      # Encode serial number, issuer signing algorithm, issuer name
      # and validity
      @serial_num.encode(tmp)
      @alg_id.encode(tmp)
      if (((@version.compare(CertificateVersion::V1)).equal?(0)) && ((@issuer.to_s).nil?))
        raise CertificateParsingException.new("Null issuer DN not allowed in v1 certificate")
      end
      @issuer.encode(tmp)
      @interval.encode(tmp)
      # Encode subject (principal) and associated key
      if (((@version.compare(CertificateVersion::V1)).equal?(0)) && ((@subject.to_s).nil?))
        raise CertificateParsingException.new("Null subject DN not allowed in v1 certificate")
      end
      @subject.encode(tmp)
      @pub_key.encode(tmp)
      # Encode issuerUniqueId & subjectUniqueId.
      if (!(@issuer_unique_id).nil?)
        @issuer_unique_id.encode(tmp)
      end
      if (!(@subject_unique_id).nil?)
        @subject_unique_id.encode(tmp)
      end
      # Write all the extensions.
      if (!(@extensions).nil?)
        @extensions.encode(tmp)
      end
      # Wrap the data; encoding of the "raw" cert is now complete.
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    typesig { [String] }
    # Returns the integer attribute number for the passed attribute name.
    def attribute_map(name)
      num = Map.get(name)
      if ((num).nil?)
        return 0
      end
      return num.int_value
    end
    
    typesig { [Object] }
    # Set the version number of the certificate.
    # 
    # @params val the Object class value for the Extensions
    # @exception CertificateException on invalid data.
    def set_version(val)
      if (!(val.is_a?(CertificateVersion)))
        raise CertificateException.new("Version class type invalid.")
      end
      @version = val
    end
    
    typesig { [Object] }
    # Set the serial number of the certificate.
    # 
    # @params val the Object class value for the CertificateSerialNumber
    # @exception CertificateException on invalid data.
    def set_serial_number(val)
      if (!(val.is_a?(CertificateSerialNumber)))
        raise CertificateException.new("SerialNumber class type invalid.")
      end
      @serial_num = val
    end
    
    typesig { [Object] }
    # Set the algorithm id of the certificate.
    # 
    # @params val the Object class value for the AlgorithmId
    # @exception CertificateException on invalid data.
    def set_algorithm_id(val)
      if (!(val.is_a?(CertificateAlgorithmId)))
        raise CertificateException.new("AlgorithmId class type invalid.")
      end
      @alg_id = val
    end
    
    typesig { [Object] }
    # Set the issuer name of the certificate.
    # 
    # @params val the Object class value for the issuer
    # @exception CertificateException on invalid data.
    def set_issuer(val)
      if (!(val.is_a?(CertificateIssuerName)))
        raise CertificateException.new("Issuer class type invalid.")
      end
      @issuer = val
    end
    
    typesig { [Object] }
    # Set the validity interval of the certificate.
    # 
    # @params val the Object class value for the CertificateValidity
    # @exception CertificateException on invalid data.
    def set_validity(val)
      if (!(val.is_a?(CertificateValidity)))
        raise CertificateException.new("CertificateValidity class type invalid.")
      end
      @interval = val
    end
    
    typesig { [Object] }
    # Set the subject name of the certificate.
    # 
    # @params val the Object class value for the Subject
    # @exception CertificateException on invalid data.
    def set_subject(val)
      if (!(val.is_a?(CertificateSubjectName)))
        raise CertificateException.new("Subject class type invalid.")
      end
      @subject = val
    end
    
    typesig { [Object] }
    # Set the public key in the certificate.
    # 
    # @params val the Object class value for the PublicKey
    # @exception CertificateException on invalid data.
    def set_key(val)
      if (!(val.is_a?(CertificateX509Key)))
        raise CertificateException.new("Key class type invalid.")
      end
      @pub_key = val
    end
    
    typesig { [Object] }
    # Set the Issuer Unique Identity in the certificate.
    # 
    # @params val the Object class value for the IssuerUniqueId
    # @exception CertificateException
    def set_issuer_unique_id(val)
      if (@version.compare(CertificateVersion::V2) < 0)
        raise CertificateException.new("Invalid version")
      end
      if (!(val.is_a?(CertificateIssuerUniqueIdentity)))
        raise CertificateException.new("IssuerUniqueId class type invalid.")
      end
      @issuer_unique_id = val
    end
    
    typesig { [Object] }
    # Set the Subject Unique Identity in the certificate.
    # 
    # @params val the Object class value for the SubjectUniqueId
    # @exception CertificateException
    def set_subject_unique_id(val)
      if (@version.compare(CertificateVersion::V2) < 0)
        raise CertificateException.new("Invalid version")
      end
      if (!(val.is_a?(CertificateSubjectUniqueIdentity)))
        raise CertificateException.new("SubjectUniqueId class type invalid.")
      end
      @subject_unique_id = val
    end
    
    typesig { [Object] }
    # Set the extensions in the certificate.
    # 
    # @params val the Object class value for the Extensions
    # @exception CertificateException
    def set_extensions(val)
      if (@version.compare(CertificateVersion::V3) < 0)
        raise CertificateException.new("Invalid version")
      end
      if (!(val.is_a?(CertificateExtensions)))
        raise CertificateException.new("Extensions class type invalid.")
      end
      @extensions = val
    end
    
    private
    alias_method :initialize__x509cert_info, :initialize
  end
  
end

require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509CertPathImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :X509Certificate
      include ::Java::Util
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Sun::Security::Pkcs, :ContentInfo
      include_const ::Sun::Security::Pkcs, :PKCS7
      include_const ::Sun::Security::Pkcs, :SignerInfo
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerInputStream
    }
  end
  
  # 
  # A {@link java.security.cert.CertPath CertPath} (certification path)
  # consisting exclusively of
  # {@link java.security.cert.X509Certificate X509Certificate}s.
  # <p>
  # By convention, X.509 <code>CertPath</code>s are stored from target
  # to trust anchor.
  # That is, the issuer of one certificate is the subject of the following
  # one. However, unvalidated X.509 <code>CertPath</code>s may not follow
  # this convention. PKIX <code>CertPathValidator</code>s will detect any
  # departure from this convention and throw a
  # <code>CertPathValidatorException</code>.
  # 
  # @author      Yassir Elley
  # @since       1.4
  class X509CertPath < X509CertPathImports.const_get :CertPath
    include_class_members X509CertPathImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4989800333263052980 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # List of certificates in this chain
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    class_module.module_eval {
      # 
      # The names of our encodings.  PkiPath is the default.
      const_set_lazy(:COUNT_ENCODING) { "count" }
      const_attr_reader  :COUNT_ENCODING
      
      const_set_lazy(:PKCS7_ENCODING) { "PKCS7" }
      const_attr_reader  :PKCS7_ENCODING
      
      const_set_lazy(:PKIPATH_ENCODING) { "PkiPath" }
      const_attr_reader  :PKIPATH_ENCODING
      
      when_class_loaded do
        list = ArrayList.new(2)
        list.add(PKIPATH_ENCODING)
        list.add(PKCS7_ENCODING)
        const_set :EncodingList, Collections.unmodifiable_collection(list)
      end
    }
    
    typesig { [JavaList] }
    # 
    # Creates an <code>X509CertPath</code> from a <code>List</code> of
    # <code>X509Certificate</code>s.
    # <p>
    # The certificates are copied out of the supplied <code>List</code>
    # object.
    # 
    # @param certs a <code>List</code> of <code>X509Certificate</code>s
    # @exception CertificateException if <code>certs</code> contains an element
    # that is not an <code>X509Certificate</code>
    def initialize(certs)
      @certs = nil
      super("X.509")
      # Ensure that the List contains only X509Certificates
      certs.each do |obj|
        if ((obj.is_a?(X509Certificate)).equal?(false))
          raise CertificateException.new("List is not all X509Certificates: " + (obj.get_class.get_name).to_s)
        end
      end
      # Assumes that the resulting List is thread-safe. This is true
      # because we ensure that it cannot be modified after construction
      # and the methods in the Sun JDK 1.4 implementation of ArrayList that
      # allow read-only access are thread-safe.
      @certs = Collections.unmodifiable_list(ArrayList.new(certs))
    end
    
    typesig { [InputStream] }
    # 
    # Creates an <code>X509CertPath</code>, reading the encoded form
    # from an <code>InputStream</code>. The data is assumed to be in
    # the default encoding.
    # 
    # @param is the <code>InputStream</code> to read the data from
    # @exception CertificateException if an exception occurs while decoding
    def initialize(is)
      initialize__x509cert_path(is, PKIPATH_ENCODING)
    end
    
    typesig { [InputStream, String] }
    # 
    # Creates an <code>X509CertPath</code>, reading the encoded form
    # from an InputStream. The data is assumed to be in the specified
    # encoding.
    # 
    # @param is the <code>InputStream</code> to read the data from
    # @param encoding the encoding used
    # @exception CertificateException if an exception occurs while decoding or
    # the encoding requested is not supported
    def initialize(is, encoding)
      @certs = nil
      super("X.509")
      if ((PKIPATH_ENCODING == encoding))
        @certs = parse_pkipath(is)
      else
        if ((PKCS7_ENCODING == encoding))
          @certs = parse_pkcs7(is)
        else
          raise CertificateException.new("unsupported encoding")
        end
      end
    end
    
    class_module.module_eval {
      typesig { [InputStream] }
      # 
      # Parse a PKIPATH format CertPath from an InputStream. Return an
      # unmodifiable List of the certificates.
      # 
      # @param is the <code>InputStream</code> to read the data from
      # @return an unmodifiable List of the certificates
      # @exception CertificateException if an exception occurs
      def parse_pkipath(is)
        cert_list = nil
        cert_fac = nil
        if ((is).nil?)
          raise CertificateException.new("input stream is null")
        end
        begin
          dis = DerInputStream.new(read_all_bytes(is))
          seq = dis.get_sequence(3)
          if ((seq.attr_length).equal?(0))
            return Collections.empty_list
          end
          cert_fac = CertificateFactory.get_instance("X.509")
          cert_list = ArrayList.new(seq.attr_length)
          # append certs in reverse order (target to trust anchor)
          i = seq.attr_length - 1
          while i >= 0
            cert_list.add(cert_fac.generate_certificate(ByteArrayInputStream.new(seq[i].to_byte_array)))
            ((i -= 1) + 1)
          end
          return Collections.unmodifiable_list(cert_list)
        rescue IOException => ioe
          ce = CertificateException.new("IOException" + " parsing PkiPath data: " + (ioe).to_s)
          ce.init_cause(ioe)
          raise ce
        end
      end
      
      typesig { [InputStream] }
      # 
      # Parse a PKCS#7 format CertPath from an InputStream. Return an
      # unmodifiable List of the certificates.
      # 
      # @param is the <code>InputStream</code> to read the data from
      # @return an unmodifiable List of the certificates
      # @exception CertificateException if an exception occurs
      def parse_pkcs7(is)
        cert_list = nil
        if ((is).nil?)
          raise CertificateException.new("input stream is null")
        end
        begin
          if ((is.mark_supported).equal?(false))
            # Copy the entire input stream into an InputStream that does
            # support mark
            is = ByteArrayInputStream.new(read_all_bytes(is))
          end
          pkcs7 = PKCS7.new(is)
          cert_array = pkcs7.get_certificates
          # certs are optional in PKCS #7
          if (!(cert_array).nil?)
            cert_list = Arrays.as_list(cert_array)
          else
            # no certs provided
            cert_list = ArrayList.new(0)
          end
        rescue IOException => ioe
          raise CertificateException.new("IOException parsing PKCS7 data: " + (ioe).to_s)
        end
        # Assumes that the resulting List is thread-safe. This is true
        # because we ensure that it cannot be modified after construction
        # and the methods in the Sun JDK 1.4 implementation of ArrayList that
        # allow read-only access are thread-safe.
        return Collections.unmodifiable_list(cert_list)
      end
      
      typesig { [InputStream] }
      # 
      # Reads the entire contents of an InputStream into a byte array.
      # 
      # @param is the InputStream to read from
      # @return the bytes read from the InputStream
      def read_all_bytes(is)
        buffer = Array.typed(::Java::Byte).new(8192) { 0 }
        baos = ByteArrayOutputStream.new(2048)
        n = 0
        while (!((n = is.read(buffer))).equal?(-1))
          baos.write(buffer, 0, n)
        end
        return baos.to_byte_array
      end
    }
    
    typesig { [] }
    # 
    # Returns the encoded form of this certification path, using the
    # default encoding.
    # 
    # @return the encoded bytes
    # @exception CertificateEncodingException if an encoding error occurs
    def get_encoded
      # @@@ Should cache the encoded form
      return encode_pkipath
    end
    
    typesig { [] }
    # 
    # Encode the CertPath using PKIPATH format.
    # 
    # @return a byte array containing the binary encoding of the PkiPath object
    # @exception CertificateEncodingException if an exception occurs
    def encode_pkipath
      li = @certs.list_iterator(@certs.size)
      begin
        bytes = DerOutputStream.new
        # encode certs in reverse order (trust anchor to target)
        # according to PkiPath format
        while (li.has_previous)
          cert = li.previous
          # check for duplicate cert
          if (!(@certs.last_index_of(cert)).equal?(@certs.index_of(cert)))
            raise CertificateEncodingException.new("Duplicate Certificate")
          end
          # get encoded certificates
          encoded = cert.get_encoded
          bytes.write(encoded)
        end
        # Wrap the data in a SEQUENCE
        derout = DerOutputStream.new
        derout.write(DerValue.attr_tag_sequence_of, bytes)
        return derout.to_byte_array
      rescue IOException => ioe
        ce = CertificateEncodingException.new("IOException encoding PkiPath data: " + (ioe).to_s)
        ce.init_cause(ioe)
        raise ce
      end
    end
    
    typesig { [] }
    # 
    # Encode the CertPath using PKCS#7 format.
    # 
    # @return a byte array containing the binary encoding of the PKCS#7 object
    # @exception CertificateEncodingException if an exception occurs
    def encode_pkcs7
      p7 = PKCS7.new(Array.typed(AlgorithmId).new(0) { nil }, ContentInfo.new(ContentInfo::DATA_OID, nil), @certs.to_array(Array.typed(X509Certificate).new(@certs.size) { nil }), Array.typed(SignerInfo).new(0) { nil })
      derout = DerOutputStream.new
      begin
        p7.encode_signed_data(derout)
      rescue IOException => ioe
        raise CertificateEncodingException.new(ioe.get_message)
      end
      return derout.to_byte_array
    end
    
    typesig { [String] }
    # 
    # Returns the encoded form of this certification path, using the
    # specified encoding.
    # 
    # @param encoding the name of the encoding to use
    # @return the encoded bytes
    # @exception CertificateEncodingException if an encoding error occurs or
    # the encoding requested is not supported
    def get_encoded(encoding)
      if ((PKIPATH_ENCODING == encoding))
        return encode_pkipath
      else
        if ((PKCS7_ENCODING == encoding))
          return encode_pkcs7
        else
          raise CertificateEncodingException.new("unsupported encoding")
        end
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Returns the encodings supported by this certification path, with the
      # default encoding first.
      # 
      # @return an <code>Iterator</code> over the names of the supported
      # encodings (as Strings)
      def get_encodings_static
        return EncodingList.iterator
      end
    }
    
    typesig { [] }
    # 
    # Returns an iteration of the encodings supported by this certification
    # path, with the default encoding first.
    # <p>
    # Attempts to modify the returned <code>Iterator</code> via its
    # <code>remove</code> method result in an
    # <code>UnsupportedOperationException</code>.
    # 
    # @return an <code>Iterator</code> over the names of the supported
    # encodings (as Strings)
    def get_encodings
      return get_encodings_static
    end
    
    typesig { [] }
    # 
    # Returns the list of certificates in this certification path.
    # The <code>List</code> returned must be immutable and thread-safe.
    # 
    # @return an immutable <code>List</code> of <code>X509Certificate</code>s
    # (may be empty, but not null)
    def get_certificates
      return @certs
    end
    
    private
    alias_method :initialize__x509cert_path, :initialize
  end
  
end

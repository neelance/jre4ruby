require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module X509FactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include_const ::Java::Util, :Collection
      include ::Java::Util
      include ::Java::Security::Cert
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :X509CRLImpl
      include_const ::Sun::Security::Pkcs, :PKCS7
      include_const ::Sun::Security::Provider::Certpath, :X509CertPath
      include_const ::Sun::Security::Provider::Certpath, :X509CertificatePair
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :Cache
      include_const ::Sun::Misc, :BASE64Decoder
    }
  end
  
  # This class defines a certificate factory for X.509 v3 certificates &
  # certification paths, and X.509 v2 certificate revocation lists (CRLs).
  # 
  # @author Jan Luehe
  # @author Hemma Prafullchandra
  # @author Sean Mullan
  # 
  # 
  # @see java.security.cert.CertificateFactorySpi
  # @see java.security.cert.Certificate
  # @see java.security.cert.CertPath
  # @see java.security.cert.CRL
  # @see java.security.cert.X509Certificate
  # @see java.security.cert.X509CRL
  # @see sun.security.x509.X509CertImpl
  # @see sun.security.x509.X509CRLImpl
  class X509Factory < X509FactoryImports.const_get :CertificateFactorySpi
    include_class_members X509FactoryImports
    
    class_module.module_eval {
      const_set_lazy(:BEGIN_CERT) { "-----BEGIN CERTIFICATE-----" }
      const_attr_reader  :BEGIN_CERT
      
      const_set_lazy(:END_CERT) { "-----END CERTIFICATE-----" }
      const_attr_reader  :END_CERT
      
      const_set_lazy(:DefaultExpectedLineLength) { 80 }
      const_attr_reader  :DefaultExpectedLineLength
      
      const_set_lazy(:EndBoundary) { "-----END".to_char_array }
      const_attr_reader  :EndBoundary
      
      const_set_lazy(:ENC_MAX_LENGTH) { 4096 * 1024 }
      const_attr_reader  :ENC_MAX_LENGTH
      
      # 4 MB MAX
      const_set_lazy(:CertCache) { Cache.new_soft_memory_cache(750) }
      const_attr_reader  :CertCache
      
      const_set_lazy(:CrlCache) { Cache.new_soft_memory_cache(750) }
      const_attr_reader  :CrlCache
    }
    
    typesig { [InputStream] }
    # Generates an X.509 certificate object and initializes it with
    # the data read from the input stream <code>is</code>.
    # 
    # @param is an input stream with the certificate data.
    # 
    # @return an X.509 certificate object initialized with the data
    # from the input stream.
    # 
    # @exception CertificateException on parsing errors.
    def engine_generate_certificate(is)
      if ((is).nil?)
        # clear the caches (for debugging)
        CertCache.clear
        X509CertificatePair.clear_cache
        raise CertificateException.new("Missing input stream")
      end
      begin
        if ((is.mark_supported).equal?(false))
          # consume the entire input stream
          total_bytes = nil
          total_bytes = get_total_bytes(BufferedInputStream.new(is))
          is = ByteArrayInputStream.new(total_bytes)
        end
        encoding = read_sequence(is)
        if (!(encoding).nil?)
          cert = get_from_cache(CertCache, encoding)
          if (!(cert).nil?)
            return cert
          end
          cert = X509CertImpl.new(encoding)
          add_to_cache(CertCache, cert.get_encoded_internal, cert)
          return cert
        else
          cert = nil
          # determine if binary or Base64 encoding. If Base64 encoding,
          # the certificate must be bounded at the beginning by
          # "-----BEGIN".
          if (is_base64(is))
            # Base64
            data = base64_to_binary(is)
            cert = X509CertImpl.new(data)
          else
            # binary
            cert = X509CertImpl.new(DerValue.new(is))
          end
          return intern(cert)
        end
      rescue IOException => ioe
        raise CertificateException.new("Could not parse certificate: " + (ioe.to_s).to_s).init_cause(ioe)
      end
    end
    
    class_module.module_eval {
      typesig { [InputStream] }
      # Read a DER SEQUENCE from an InputStream and return the encoding.
      # If data does not represent a SEQUENCE, it uses indefinite length
      # encoding, or is longer than ENC_MAX_LENGTH, the stream is reset
      # and this method returns null.
      def read_sequence(in_)
        in_.mark(ENC_MAX_LENGTH)
        b = Array.typed(::Java::Byte).new(4) { 0 }
        i = read_fully(in_, b, 0, b.attr_length)
        if ((!(i).equal?(b.attr_length)) || (!(b[0]).equal?(0x30)))
          # first byte must be SEQUENCE
          in_.reset
          return nil
        end
        i = b[1] & 0xff
        total_length = 0
        if (i < 0x80)
          value_length = i
          total_length = value_length + 2
        else
          if ((i).equal?(0x81))
            value_length = b[2] & 0xff
            total_length = value_length + 3
          else
            if ((i).equal?(0x82))
              value_length = ((b[2] & 0xff) << 8) | (b[3] & 0xff)
              total_length = value_length + 4
            else
              # ignore longer length forms
              in_.reset
              return nil
            end
          end
        end
        if (total_length > ENC_MAX_LENGTH)
          in_.reset
          return nil
        end
        encoding = Array.typed(::Java::Byte).new(total_length) { 0 }
        if (total_length < b.attr_length)
          in_.reset
          i = read_fully(in_, encoding, 0, total_length)
          if (!(i).equal?(total_length))
            in_.reset
            return nil
          end
        else
          System.arraycopy(b, 0, encoding, 0, b.attr_length)
          n = total_length - b.attr_length
          i = read_fully(in_, encoding, b.attr_length, n)
          if (!(i).equal?(n))
            in_.reset
            return nil
          end
        end
        return encoding
      end
      
      typesig { [InputStream, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Read from the stream until length bytes have been read or EOF has
      # been reached. Return the number of bytes actually read.
      def read_fully(in_, buffer, offset, length)
        read = 0
        while (length > 0)
          n = in_.read(buffer, offset, length)
          if (n <= 0)
            break
          end
          read += n
          length -= n
          offset += n
        end
        return read
      end
      
      typesig { [X509Certificate] }
      # Return an interned X509CertImpl for the given certificate.
      # If the given X509Certificate or X509CertImpl is already present
      # in the cert cache, the cached object is returned. Otherwise,
      # if it is a X509Certificate, it is first converted to a X509CertImpl.
      # Then the X509CertImpl is added to the cache and returned.
      # 
      # Note that all certificates created via generateCertificate(InputStream)
      # are already interned and this method does not need to be called.
      # It is useful for certificates that cannot be created via
      # generateCertificate() and for converting other X509Certificate
      # implementations to an X509CertImpl.
      def intern(c)
        synchronized(self) do
          if ((c).nil?)
            return nil
          end
          is_impl = c.is_a?(X509CertImpl)
          encoding = nil
          if (is_impl)
            encoding = (c).get_encoded_internal
          else
            encoding = c.get_encoded
          end
          new_c = get_from_cache(CertCache, encoding)
          if (!(new_c).nil?)
            return new_c
          end
          if (is_impl)
            new_c = c
          else
            new_c = X509CertImpl.new(encoding)
            encoding = new_c.get_encoded_internal
          end
          add_to_cache(CertCache, encoding, new_c)
          return new_c
        end
      end
      
      typesig { [X509CRL] }
      # Return an interned X509CRLImpl for the given certificate.
      # For more information, see intern(X509Certificate).
      def intern(c)
        synchronized(self) do
          if ((c).nil?)
            return nil
          end
          is_impl = c.is_a?(X509CRLImpl)
          encoding = nil
          if (is_impl)
            encoding = (c).get_encoded_internal
          else
            encoding = c.get_encoded
          end
          new_c = get_from_cache(CrlCache, encoding)
          if (!(new_c).nil?)
            return new_c
          end
          if (is_impl)
            new_c = c
          else
            new_c = X509CRLImpl.new(encoding)
            encoding = new_c.get_encoded_internal
          end
          add_to_cache(CrlCache, encoding, new_c)
          return new_c
        end
      end
      
      typesig { [Cache, Array.typed(::Java::Byte)] }
      # Get the X509CertImpl or X509CRLImpl from the cache.
      def get_from_cache(cache, encoding)
        synchronized(self) do
          key = Cache::EqualByteArray.new(encoding)
          value = cache.get(key)
          return value
        end
      end
      
      typesig { [Cache, Array.typed(::Java::Byte), Object] }
      # Add the X509CertImpl or X509CRLImpl to the cache.
      def add_to_cache(cache, encoding, value)
        synchronized(self) do
          if (encoding.attr_length > ENC_MAX_LENGTH)
            return
          end
          key = Cache::EqualByteArray.new(encoding)
          cache.put(key, value)
        end
      end
    }
    
    typesig { [InputStream] }
    # Generates a <code>CertPath</code> object and initializes it with
    # the data read from the <code>InputStream</code> inStream. The data
    # is assumed to be in the default encoding.
    # 
    # @param inStream an <code>InputStream</code> containing the data
    # @return a <code>CertPath</code> initialized with the data from the
    # <code>InputStream</code>
    # @exception CertificateException if an exception occurs while decoding
    # @since 1.4
    def engine_generate_cert_path(in_stream)
      if ((in_stream).nil?)
        raise CertificateException.new("Missing input stream")
      end
      begin
        if ((in_stream.mark_supported).equal?(false))
          # consume the entire input stream
          total_bytes = nil
          total_bytes = get_total_bytes(BufferedInputStream.new(in_stream))
          in_stream = ByteArrayInputStream.new(total_bytes)
        end
        # determine if binary or Base64 encoding. If Base64 encoding,
        # each certificate must be bounded at the beginning by
        # "-----BEGIN".
        if (is_base64(in_stream))
          # Base64
          data = base64_to_binary(in_stream)
          return X509CertPath.new(ByteArrayInputStream.new(data))
        else
          return X509CertPath.new(in_stream)
        end
      rescue IOException => ioe
        raise CertificateException.new(ioe.get_message)
      end
    end
    
    typesig { [InputStream, String] }
    # Generates a <code>CertPath</code> object and initializes it with
    # the data read from the <code>InputStream</code> inStream. The data
    # is assumed to be in the specified encoding.
    # 
    # @param inStream an <code>InputStream</code> containing the data
    # @param encoding the encoding used for the data
    # @return a <code>CertPath</code> initialized with the data from the
    # <code>InputStream</code>
    # @exception CertificateException if an exception occurs while decoding or
    # the encoding requested is not supported
    # @since 1.4
    def engine_generate_cert_path(in_stream, encoding)
      if ((in_stream).nil?)
        raise CertificateException.new("Missing input stream")
      end
      begin
        if ((in_stream.mark_supported).equal?(false))
          # consume the entire input stream
          total_bytes = nil
          total_bytes = get_total_bytes(BufferedInputStream.new(in_stream))
          in_stream = ByteArrayInputStream.new(total_bytes)
        end
        # determine if binary or Base64 encoding. If Base64 encoding,
        # each certificate must be bounded at the beginning by
        # "-----BEGIN".
        if (is_base64(in_stream))
          # Base64
          data = base64_to_binary(in_stream)
          return X509CertPath.new(ByteArrayInputStream.new(data), encoding)
        else
          return (X509CertPath.new(in_stream, encoding))
        end
      rescue IOException => ioe
        raise CertificateException.new(ioe.get_message)
      end
    end
    
    typesig { [JavaList] }
    # Generates a <code>CertPath</code> object and initializes it with
    # a <code>List</code> of <code>Certificate</code>s.
    # <p>
    # The certificates supplied must be of a type supported by the
    # <code>CertificateFactory</code>. They will be copied out of the supplied
    # <code>List</code> object.
    # 
    # @param certificates a <code>List</code> of <code>Certificate</code>s
    # @return a <code>CertPath</code> initialized with the supplied list of
    # certificates
    # @exception CertificateException if an exception occurs
    # @since 1.4
    def engine_generate_cert_path(certificates)
      return (X509CertPath.new(certificates))
    end
    
    typesig { [] }
    # Returns an iteration of the <code>CertPath</code> encodings supported
    # by this certificate factory, with the default encoding first.
    # <p>
    # Attempts to modify the returned <code>Iterator</code> via its
    # <code>remove</code> method result in an
    # <code>UnsupportedOperationException</code>.
    # 
    # @return an <code>Iterator</code> over the names of the supported
    # <code>CertPath</code> encodings (as <code>String</code>s)
    # @since 1.4
    def engine_get_cert_path_encodings
      return (X509CertPath.get_encodings_static)
    end
    
    typesig { [InputStream] }
    # Returns a (possibly empty) collection view of X.509 certificates read
    # from the given input stream <code>is</code>.
    # 
    # @param is the input stream with the certificates.
    # 
    # @return a (possibly empty) collection view of X.509 certificate objects
    # initialized with the data from the input stream.
    # 
    # @exception CertificateException on parsing errors.
    def engine_generate_certificates(is)
      if ((is).nil?)
        raise CertificateException.new("Missing input stream")
      end
      begin
        if ((is.mark_supported).equal?(false))
          # consume the entire input stream
          is = ByteArrayInputStream.new(get_total_bytes(BufferedInputStream.new(is)))
        end
        return parse_x509or_pkcs7cert(is)
      rescue IOException => ioe
        raise CertificateException.new(ioe)
      end
    end
    
    typesig { [InputStream] }
    # Generates an X.509 certificate revocation list (CRL) object and
    # initializes it with the data read from the given input stream
    # <code>is</code>.
    # 
    # @param is an input stream with the CRL data.
    # 
    # @return an X.509 CRL object initialized with the data
    # from the input stream.
    # 
    # @exception CRLException on parsing errors.
    def engine_generate_crl(is)
      if ((is).nil?)
        # clear the cache (for debugging)
        CrlCache.clear
        raise CRLException.new("Missing input stream")
      end
      begin
        if ((is.mark_supported).equal?(false))
          # consume the entire input stream
          total_bytes = nil
          total_bytes = get_total_bytes(BufferedInputStream.new(is))
          is = ByteArrayInputStream.new(total_bytes)
        end
        encoding = read_sequence(is)
        if (!(encoding).nil?)
          crl = get_from_cache(CrlCache, encoding)
          if (!(crl).nil?)
            return crl
          end
          crl = X509CRLImpl.new(encoding)
          add_to_cache(CrlCache, crl.get_encoded_internal, crl)
          return crl
        else
          crl = nil
          # determine if binary or Base64 encoding. If Base64 encoding,
          # the CRL must be bounded at the beginning by
          # "-----BEGIN".
          if (is_base64(is))
            # Base64
            data = base64_to_binary(is)
            crl = X509CRLImpl.new(data)
          else
            # binary
            crl = X509CRLImpl.new(DerValue.new(is))
          end
          return intern(crl)
        end
      rescue IOException => ioe
        raise CRLException.new(ioe.get_message)
      end
    end
    
    typesig { [InputStream] }
    # Returns a (possibly empty) collection view of X.509 CRLs read
    # from the given input stream <code>is</code>.
    # 
    # @param is the input stream with the CRLs.
    # 
    # @return a (possibly empty) collection view of X.509 CRL objects
    # initialized with the data from the input stream.
    # 
    # @exception CRLException on parsing errors.
    def engine_generate_crls(is)
      if ((is).nil?)
        raise CRLException.new("Missing input stream")
      end
      begin
        if ((is.mark_supported).equal?(false))
          # consume the entire input stream
          is = ByteArrayInputStream.new(get_total_bytes(BufferedInputStream.new(is)))
        end
        return parse_x509or_pkcs7crl(is)
      rescue IOException => ioe
        raise CRLException.new(ioe.get_message)
      end
    end
    
    typesig { [InputStream] }
    # Parses the data in the given input stream as a sequence of DER
    # encoded X.509 certificates (in binary or base 64 encoded format) OR
    # as a single PKCS#7 encoded blob (in binary or base64 encoded format).
    def parse_x509or_pkcs7cert(is)
      coll = ArrayList.new
      first = true
      while (!(is.available).equal?(0))
        # determine if binary or Base64 encoding. If Base64 encoding,
        # each certificate must be bounded at the beginning by
        # "-----BEGIN".
        is2 = is
        if (is_base64(is2))
          # Base64
          is2 = ByteArrayInputStream.new(base64_to_binary(is2))
        end
        if (first)
          is2.mark(is2.available)
        end
        begin
          # treat as X.509 cert
          coll.add(intern(X509CertImpl.new(DerValue.new(is2))))
        rescue CertificateException => e
          cause = e.get_cause
          # only treat as PKCS#7 if this is the first cert parsed
          # and the root cause of the decoding failure is an IOException
          if (first && !(cause).nil? && (cause.is_a?(IOException)))
            # treat as PKCS#7
            is2.reset
            pkcs7 = PKCS7.new(is2)
            certs = pkcs7.get_certificates
            # certs are optional in PKCS #7
            if (!(certs).nil?)
              return Arrays.as_list(certs)
            else
              # no certs provided
              return ArrayList.new(0)
            end
          else
            raise e
          end
        end
        first = false
      end
      return coll
    end
    
    typesig { [InputStream] }
    # Parses the data in the given input stream as a sequence of DER encoded
    # X.509 CRLs (in binary or base 64 encoded format) OR as a single PKCS#7
    # encoded blob (in binary or base 64 encoded format).
    def parse_x509or_pkcs7crl(is)
      coll = ArrayList.new
      first = true
      while (!(is.available).equal?(0))
        # determine if binary or Base64 encoding. If Base64 encoding,
        # the CRL must be bounded at the beginning by
        # "-----BEGIN".
        is2 = is
        if (is_base64(is))
          # Base64
          is2 = ByteArrayInputStream.new(base64_to_binary(is2))
        end
        if (first)
          is2.mark(is2.available)
        end
        begin
          # treat as X.509 CRL
          coll.add(X509CRLImpl.new(is2))
        rescue CRLException => e
          # only treat as PKCS#7 if this is the first CRL parsed
          if (first)
            is2.reset
            pkcs7 = PKCS7.new(is2)
            crls = pkcs7.get_crls
            # CRLs are optional in PKCS #7
            if (!(crls).nil?)
              return Arrays.as_list(crls)
            else
              # no crls provided
              return ArrayList.new(0)
            end
          end
        end
        first = false
      end
      return coll
    end
    
    typesig { [InputStream] }
    # Converts a Base64-encoded X.509 certificate or X.509 CRL or PKCS#7 data
    # to binary encoding.
    # In all cases, the data must be bounded at the beginning by
    # "-----BEGIN", and must be bounded at the end by "-----END".
    def base64_to_binary(is)
      len = 0 # total length of base64 encoding, including boundaries
      is.mark(is.available)
      bufin = BufferedInputStream.new(is)
      br = BufferedReader.new(InputStreamReader.new(bufin, "ASCII"))
      # First read all of the data that is found between
      # the "-----BEGIN" and "-----END" boundaries into a buffer.
      temp = nil
      if (((temp = (read_line(br)).to_s)).nil? || !temp.starts_with("-----BEGIN"))
        raise IOException.new("Unsupported encoding")
      else
        len += temp.length
      end
      str_buf = StringBuffer.new
      while (!((temp = (read_line(br)).to_s)).nil? && !temp.starts_with("-----END"))
        str_buf.append(temp)
      end
      if ((temp).nil?)
        raise IOException.new("Unsupported encoding")
      else
        len += temp.length
      end
      # consume only as much as was needed
      len += str_buf.length
      is.reset
      is.skip(len)
      # Now, that data is supposed to be a single X.509 certificate or
      # X.509 CRL or PKCS#7 formatted data... Base64 encoded.
      # Decode into binary and return the result.
      decoder = BASE64Decoder.new
      return decoder.decode_buffer(str_buf.to_s)
    end
    
    typesig { [InputStream] }
    # Reads the entire input stream into a byte array.
    def get_total_bytes(is)
      buffer = Array.typed(::Java::Byte).new(8192) { 0 }
      baos = ByteArrayOutputStream.new(2048)
      n = 0
      baos.reset
      while (!((n = is.read(buffer, 0, buffer.attr_length))).equal?(-1))
        baos.write(buffer, 0, n)
      end
      return baos.to_byte_array
    end
    
    typesig { [InputStream] }
    # Determines if input is binary or Base64 encoded.
    def is_base64(is)
      if (is.available >= 10)
        is.mark(10)
        c1 = is.read
        c2 = is.read
        c3 = is.read
        c4 = is.read
        c5 = is.read
        c6 = is.read
        c7 = is.read
        c8 = is.read
        c9 = is.read
        c10 = is.read
        is.reset
        if ((c1).equal?(Character.new(?-.ord)) && (c2).equal?(Character.new(?-.ord)) && (c3).equal?(Character.new(?-.ord)) && (c4).equal?(Character.new(?-.ord)) && (c5).equal?(Character.new(?-.ord)) && (c6).equal?(Character.new(?B.ord)) && (c7).equal?(Character.new(?E.ord)) && (c8).equal?(Character.new(?G.ord)) && (c9).equal?(Character.new(?I.ord)) && (c10).equal?(Character.new(?N.ord)))
          return true
        else
          return false
        end
      else
        return false
      end
    end
    
    typesig { [BufferedReader] }
    # Read a line of text.  A line is considered to be terminated by any one
    # of a line feed ('\n'), a carriage return ('\r'), a carriage return
    # followed immediately by a linefeed, or an end-of-certificate marker.
    # 
    # @return     A String containing the contents of the line, including
    # any line-termination characters, or null if the end of the
    # stream has been reached.
    def read_line(br)
      c = 0
      i = 0
      is_match = true
      matched = false
      sb = StringBuffer.new(DefaultExpectedLineLength)
      begin
        c = br.read
        if (is_match && (i < EndBoundary.attr_length))
          is_match = (!(RJava.cast_to_char(c)).equal?(EndBoundary[((i += 1) - 1)])) ? false : true
        end
        if (!matched)
          matched = (is_match && ((i).equal?(EndBoundary.attr_length)))
        end
        sb.append(RJava.cast_to_char(c))
      end while ((!(c).equal?(-1)) && (!(c).equal?(Character.new(?\n.ord))) && (!(c).equal?(Character.new(?\r.ord))))
      if (!matched && (c).equal?(-1))
        return nil
      end
      if ((c).equal?(Character.new(?\r.ord)))
        br.mark(1)
        c2 = br.read
        if ((c2).equal?(Character.new(?\n.ord)))
          sb.append(RJava.cast_to_char(c))
        else
          br.reset
        end
      end
      return sb.to_s
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__x509factory, :initialize
  end
  
end

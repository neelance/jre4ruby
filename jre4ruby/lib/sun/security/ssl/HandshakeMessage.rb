require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module HandshakeMessageImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
      include ::Java::Util
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include ::Java::Lang::Reflect
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Javax::Crypto, :KeyGenerator
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include ::Javax::Net::Ssl
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Internal::Spec, :TlsPrfParameterSpec
      include ::Sun::Security::Ssl::CipherSuite
    }
  end
  
  # END of nested classes
  # 
  # 
  # Many data structures are involved in the handshake messages.  These
  # classes are used as structures, with public data members.  They are
  # not visible outside the SSL package.
  # 
  # Handshake messages all have a common header format, and they are all
  # encoded in a "handshake data" SSL record substream.  The base class
  # here (HandshakeMessage) provides a common framework and records the
  # SSL record type of the particular handshake message.
  # 
  # This file contains subclasses for all the basic handshake messages.
  # All handshake messages know how to encode and decode themselves on
  # SSL streams; this facilitates using the same code on SSL client and
  # server sides, although they don't send and receive the same messages.
  # 
  # Messages also know how to print themselves, which is quite handy
  # for debugging.  They always identify their type, and can optionally
  # dump all of their content.
  # 
  # @author David Brownell
  class HandshakeMessage 
    include_class_members HandshakeMessageImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # enum HandshakeType:
      const_set_lazy(:Ht_hello_request) { 0 }
      const_attr_reader  :Ht_hello_request
      
      const_set_lazy(:Ht_client_hello) { 1 }
      const_attr_reader  :Ht_client_hello
      
      const_set_lazy(:Ht_server_hello) { 2 }
      const_attr_reader  :Ht_server_hello
      
      const_set_lazy(:Ht_certificate) { 11 }
      const_attr_reader  :Ht_certificate
      
      const_set_lazy(:Ht_server_key_exchange) { 12 }
      const_attr_reader  :Ht_server_key_exchange
      
      const_set_lazy(:Ht_certificate_request) { 13 }
      const_attr_reader  :Ht_certificate_request
      
      const_set_lazy(:Ht_server_hello_done) { 14 }
      const_attr_reader  :Ht_server_hello_done
      
      const_set_lazy(:Ht_certificate_verify) { 15 }
      const_attr_reader  :Ht_certificate_verify
      
      const_set_lazy(:Ht_client_key_exchange) { 16 }
      const_attr_reader  :Ht_client_key_exchange
      
      const_set_lazy(:Ht_finished) { 20 }
      const_attr_reader  :Ht_finished
      
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
      
      typesig { [BigInteger] }
      # Utility method to convert a BigInteger to a byte array in unsigned
      # format as needed in the handshake messages. BigInteger uses
      # 2's complement format, i.e. it prepends an extra zero if the MSB
      # is set. We remove that.
      def to_byte_array(bi)
        b = bi.to_byte_array
        if ((b.attr_length > 1) && ((b[0]).equal?(0)))
          n = b.attr_length - 1
          newarray = Array.typed(::Java::Byte).new(n) { 0 }
          System.arraycopy(b, 1, newarray, 0, n)
          b = newarray
        end
        return b
      end
      
      # SSL 3.0 MAC padding constants.
      # Also used by CertificateVerify and Finished during the handshake.
      const_set_lazy(:MD5_pad1) { gen_pad(0x36, 48) }
      const_attr_reader  :MD5_pad1
      
      const_set_lazy(:MD5_pad2) { gen_pad(0x5c, 48) }
      const_attr_reader  :MD5_pad2
      
      const_set_lazy(:SHA_pad1) { gen_pad(0x36, 40) }
      const_attr_reader  :SHA_pad1
      
      const_set_lazy(:SHA_pad2) { gen_pad(0x5c, 40) }
      const_attr_reader  :SHA_pad2
      
      typesig { [::Java::Int, ::Java::Int] }
      def gen_pad(b, count)
        padding = Array.typed(::Java::Byte).new(count) { 0 }
        Arrays.fill(padding, b)
        return padding
      end
    }
    
    typesig { [HandshakeOutStream] }
    # Write a handshake message on the (handshake) output stream.
    # This is just a four byte header followed by the data.
    # 
    # NOTE that huge messages -- notably, ones with huge cert
    # chains -- are handled correctly.
    def write(s)
      len = message_length
      if (len > (1 << 24))
        raise SSLException.new("Handshake message too big" + ", type = " + (message_type).to_s + ", len = " + (len).to_s)
      end
      s.write(message_type)
      s.put_int24(len)
      send(s)
    end
    
    typesig { [] }
    # Subclasses implement these methods so those kinds of
    # messages can be emitted.  Base class delegates to subclass.
    def message_type
      raise NotImplementedError
    end
    
    typesig { [] }
    def message_length
      raise NotImplementedError
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      raise NotImplementedError
    end
    
    typesig { [PrintStream] }
    # Write a descriptive message on the output stream; for debugging.
    def print(p)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # NOTE:  the rest of these classes are nested within this one, and are
      # imported by other classes in this package.  There are a few other
      # handshake message classes, not neatly nested here because of current
      # licensing requirement for native (RSA) methods.  They belong here,
      # but those native methods complicate things a lot!
      # 
      # 
      # HelloRequest ... SERVER --> CLIENT
      # 
      # Server can ask the client to initiate a new handshake, e.g. to change
      # session parameters after a connection has been (re)established.
      const_set_lazy(:HelloRequest) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_hello_request
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        typesig { [HandshakeInStream] }
        def initialize(in_)
          super()
          # nothing in this message
        end
        
        typesig { [] }
        def message_length
          return 0
        end
        
        typesig { [HandshakeOutStream] }
        def send(out)
          # nothing in this messaage
        end
        
        typesig { [PrintStream] }
        def print(out)
          out.println("*** HelloRequest (empty)")
        end
        
        private
        alias_method :initialize__hello_request, :initialize
      end }
      
      # ClientHello ... CLIENT --> SERVER
      # 
      # Client initiates handshake by telling server what it wants, and what it
      # can support (prioritized by what's first in the ciphe suite list).
      # 
      # By RFC2246:7.4.1.2 it's explicitly anticipated that this message
      # will have more data added at the end ... e.g. what CAs the client trusts.
      # Until we know how to parse it, we will just read what we know
      # about, and let our caller handle the jumps over unknown data.
      const_set_lazy(:ClientHello) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_client_hello
        end
        
        attr_accessor :protocol_version
        alias_method :attr_protocol_version, :protocol_version
        undef_method :protocol_version
        alias_method :attr_protocol_version=, :protocol_version=
        undef_method :protocol_version=
        
        attr_accessor :clnt_random
        alias_method :attr_clnt_random, :clnt_random
        undef_method :clnt_random
        alias_method :attr_clnt_random=, :clnt_random=
        undef_method :clnt_random=
        
        attr_accessor :session_id
        alias_method :attr_session_id, :session_id
        undef_method :session_id
        alias_method :attr_session_id=, :session_id=
        undef_method :session_id=
        
        attr_accessor :cipher_suites
        alias_method :attr_cipher_suites, :cipher_suites
        undef_method :cipher_suites
        alias_method :attr_cipher_suites=, :cipher_suites=
        undef_method :cipher_suites=
        
        attr_accessor :compression_methods
        alias_method :attr_compression_methods, :compression_methods
        undef_method :compression_methods
        alias_method :attr_compression_methods=, :compression_methods=
        undef_method :compression_methods=
        
        attr_accessor :extensions
        alias_method :attr_extensions, :extensions
        undef_method :extensions
        alias_method :attr_extensions=, :extensions=
        undef_method :extensions=
        
        class_module.module_eval {
          const_set_lazy(:NULL_COMPRESSION) { Array.typed(::Java::Byte).new([0]) }
          const_attr_reader  :NULL_COMPRESSION
        }
        
        typesig { [SecureRandom, ProtocolVersion] }
        def initialize(generator, protocol_version)
          @protocol_version = nil
          @clnt_random = nil
          @session_id = nil
          @cipher_suites = nil
          @compression_methods = nil
          @extensions = nil
          super()
          @extensions = HelloExtensions.new
          @protocol_version = protocol_version
          @clnt_random = RandomCookie.new(generator)
          @compression_methods = self.class::NULL_COMPRESSION
          # sessionId, cipher_suites TBS later
        end
        
        typesig { [] }
        def get_cipher_suites
          return @cipher_suites
        end
        
        typesig { [CipherSuiteList] }
        # Set the ciphersuites.
        # This method may only be called once.
        def set_cipher_suites(cipher_suites)
          @cipher_suites = cipher_suites
          if (cipher_suites.contains_ec)
            @extensions.add(SupportedEllipticCurvesExtension::DEFAULT)
            @extensions.add(SupportedEllipticPointFormatsExtension::DEFAULT)
          end
        end
        
        typesig { [] }
        def message_length
          # Add fixed size parts of each field...
          # version + random + session + cipher + compress
          # 
          # ... + variable parts
          return (2 + 32 + 1 + 2 + 1 + @session_id.length + (@cipher_suites.size * 2) + @compression_methods.attr_length) + @extensions.length
        end
        
        typesig { [HandshakeInStream, ::Java::Int] }
        def initialize(s, message_length)
          @protocol_version = nil
          @clnt_random = nil
          @session_id = nil
          @cipher_suites = nil
          @compression_methods = nil
          @extensions = nil
          super()
          @extensions = HelloExtensions.new
          @protocol_version = ProtocolVersion.value_of(s.get_int8, s.get_int8)
          @clnt_random = RandomCookie.new(s)
          @session_id = SessionId.new(s.get_bytes8)
          @cipher_suites = CipherSuiteList.new(s)
          @compression_methods = s.get_bytes8
          if (!(message_length).equal?(message_length))
            @extensions = HelloExtensions.new(s)
          end
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_int8(@protocol_version.attr_major)
          s.put_int8(@protocol_version.attr_minor)
          @clnt_random.send(s)
          s.put_bytes8(@session_id.get_id)
          @cipher_suites.send(s)
          s.put_bytes8(@compression_methods)
          @extensions.send(s)
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** ClientHello, " + (@protocol_version).to_s)
          if (!(Debug).nil? && Debug.is_on("verbose"))
            s.print("RandomCookie:  ")
            @clnt_random.print(s)
            s.print("Session ID:  ")
            s.println(@session_id)
            s.println("Cipher Suites: " + (@cipher_suites).to_s)
            Debug.println(s, "Compression Methods", @compression_methods)
            @extensions.print(s)
            s.println("***")
          end
        end
        
        private
        alias_method :initialize__client_hello, :initialize
      end }
      
      # ServerHello ... SERVER --> CLIENT
      # 
      # Server chooses protocol options from among those it supports and the
      # client supports.  Then it sends the basic session descriptive parameters
      # back to the client.
      const_set_lazy(:ServerHello) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_server_hello
        end
        
        attr_accessor :protocol_version
        alias_method :attr_protocol_version, :protocol_version
        undef_method :protocol_version
        alias_method :attr_protocol_version=, :protocol_version=
        undef_method :protocol_version=
        
        attr_accessor :svr_random
        alias_method :attr_svr_random, :svr_random
        undef_method :svr_random
        alias_method :attr_svr_random=, :svr_random=
        undef_method :svr_random=
        
        attr_accessor :session_id
        alias_method :attr_session_id, :session_id
        undef_method :session_id
        alias_method :attr_session_id=, :session_id=
        undef_method :session_id=
        
        attr_accessor :cipher_suite
        alias_method :attr_cipher_suite, :cipher_suite
        undef_method :cipher_suite
        alias_method :attr_cipher_suite=, :cipher_suite=
        undef_method :cipher_suite=
        
        attr_accessor :compression_method
        alias_method :attr_compression_method, :compression_method
        undef_method :compression_method
        alias_method :attr_compression_method=, :compression_method=
        undef_method :compression_method=
        
        attr_accessor :extensions
        alias_method :attr_extensions, :extensions
        undef_method :extensions
        alias_method :attr_extensions=, :extensions=
        undef_method :extensions=
        
        attr_accessor :extension_length
        alias_method :attr_extension_length, :extension_length
        undef_method :extension_length
        alias_method :attr_extension_length=, :extension_length=
        undef_method :extension_length=
        
        typesig { [] }
        def initialize
          @protocol_version = nil
          @svr_random = nil
          @session_id = nil
          @cipher_suite = nil
          @compression_method = 0
          @extensions = nil
          @extension_length = 0
          super()
          @extensions = HelloExtensions.new
          # empty
        end
        
        typesig { [HandshakeInStream, ::Java::Int] }
        def initialize(input, message_length)
          @protocol_version = nil
          @svr_random = nil
          @session_id = nil
          @cipher_suite = nil
          @compression_method = 0
          @extensions = nil
          @extension_length = 0
          super()
          @extensions = HelloExtensions.new
          @protocol_version = ProtocolVersion.value_of(input.get_int8, input.get_int8)
          @svr_random = RandomCookie.new(input)
          @session_id = SessionId.new(input.get_bytes8)
          @cipher_suite = CipherSuite.value_of(input.get_int8, input.get_int8)
          @compression_method = input.get_int8
          if (!(message_length).equal?(message_length))
            @extensions = HelloExtensions.new(input)
          end
        end
        
        typesig { [] }
        def message_length
          # almost fixed size, except session ID and extensions:
          # major + minor = 2
          # random = 32
          # session ID len field = 1
          # cipher suite + compression = 3
          # extensions: if present, 2 + length of extensions
          return 38 + @session_id.length + @extensions.length
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_int8(@protocol_version.attr_major)
          s.put_int8(@protocol_version.attr_minor)
          @svr_random.send(s)
          s.put_bytes8(@session_id.get_id)
          s.put_int8(@cipher_suite.attr_id >> 8)
          s.put_int8(@cipher_suite.attr_id & 0xff)
          s.put_int8(@compression_method)
          @extensions.send(s)
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** ServerHello, " + (@protocol_version).to_s)
          if (!(Debug).nil? && Debug.is_on("verbose"))
            s.print("RandomCookie:  ")
            @svr_random.print(s)
            i = 0
            s.print("Session ID:  ")
            s.println(@session_id)
            s.println("Cipher Suite: " + (@cipher_suite).to_s)
            s.println("Compression Method: " + (@compression_method).to_s)
            @extensions.print(s)
            s.println("***")
          end
        end
        
        private
        alias_method :initialize__server_hello, :initialize
      end }
      
      # CertificateMsg ... send by both CLIENT and SERVER
      # 
      # Each end of a connection may need to pass its certificate chain to
      # the other end.  Such chains are intended to validate an identity with
      # reference to some certifying authority.  Examples include companies
      # like Verisign, or financial institutions.  There's some control over
      # the certifying authorities which are sent.
      # 
      # NOTE: that these messages might be huge, taking many handshake records.
      # Up to 2^48 bytes of certificate may be sent, in records of at most 2^14
      # bytes each ... up to 2^32 records sent on the output stream.
      const_set_lazy(:CertificateMsg) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_certificate
        end
        
        attr_accessor :chain
        alias_method :attr_chain, :chain
        undef_method :chain
        alias_method :attr_chain=, :chain=
        undef_method :chain=
        
        attr_accessor :encoded_chain
        alias_method :attr_encoded_chain, :encoded_chain
        undef_method :encoded_chain
        alias_method :attr_encoded_chain=, :encoded_chain=
        undef_method :encoded_chain=
        
        attr_accessor :message_length
        alias_method :attr_message_length, :message_length
        undef_method :message_length
        alias_method :attr_message_length=, :message_length=
        undef_method :message_length=
        
        typesig { [Array.typed(X509Certificate)] }
        def initialize(certs)
          @chain = nil
          @encoded_chain = nil
          @message_length = 0
          super()
          @chain = certs
        end
        
        typesig { [HandshakeInStream] }
        def initialize(input)
          @chain = nil
          @encoded_chain = nil
          @message_length = 0
          super()
          chain_len = input.get_int24
          v = ArrayList.new(4)
          cf = nil
          while (chain_len > 0)
            cert = input.get_bytes24
            chain_len -= (3 + cert.attr_length)
            begin
              if ((cf).nil?)
                cf = CertificateFactory.get_instance("X.509")
              end
              v.add(cf.generate_certificate(ByteArrayInputStream.new(cert)))
            rescue CertificateException => e
              raise SSLProtocolException.new(e.get_message).init_cause(e)
            end
          end
          @chain = v.to_array(Array.typed(X509Certificate).new(v.size) { nil })
        end
        
        typesig { [] }
        def message_length
          if ((@encoded_chain).nil?)
            @message_length = 3
            @encoded_chain = ArrayList.new(@chain.attr_length)
            begin
              @chain.each do |cert|
                b = cert.get_encoded
                @encoded_chain.add(b)
                @message_length += b.attr_length + 3
              end
            rescue CertificateEncodingException => e
              @encoded_chain = nil
              raise RuntimeException.new("Could not encode certificates", e)
            end
          end
          return @message_length
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_int24(message_length - 3)
          @encoded_chain.each do |b|
            s.put_bytes24(b)
          end
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** Certificate chain")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            i = 0
            while i < @chain.attr_length
              s.println("chain [" + (i).to_s + "] = " + (@chain[i]).to_s)
              ((i += 1) - 1)
            end
            s.println("***")
          end
        end
        
        typesig { [] }
        def get_certificate_chain
          return @chain
        end
        
        private
        alias_method :initialize__certificate_msg, :initialize
      end }
      
      # ServerKeyExchange ... SERVER --> CLIENT
      # 
      # The cipher suite selected, when combined with the certificate exchanged,
      # implies one of several different kinds of key exchange.  Most current
      # cipher suites require the server to send more than its certificate.
      # 
      # The primary exceptions are when a server sends an encryption-capable
      # RSA public key in its cert, to be used with RSA (or RSA_export) key
      # exchange; and when a server sends its Diffie-Hellman cert.  Those kinds
      # of key exchange do not require a ServerKeyExchange message.
      # 
      # Key exchange can be viewed as having three modes, which are explicit
      # for the Diffie-Hellman flavors and poorly specified for RSA ones:
      # 
      # - "Ephemeral" keys.  Here, a "temporary" key is allocated by the
      # server, and signed.  Diffie-Hellman keys signed using RSA or
      # DSS are ephemeral (DHE flavor).  RSA keys get used to do the same
      # thing, to cut the key size down to 512 bits (export restrictions)
      # or for signing-only RSA certificates.
      # 
      # - Anonymity.  Here no server certificate is sent, only the public
      # key of the server.  This case is subject to man-in-the-middle
      # attacks.  This can be done with Diffie-Hellman keys (DH_anon) or
      # with RSA keys, but is only used in SSLv3 for DH_anon.
      # 
      # - "Normal" case.  Here a server certificate is sent, and the public
      # key there is used directly in exchanging the premaster secret.
      # For example, Diffie-Hellman "DH" flavor, and any RSA flavor with
      # only 512 bit keys.
      # 
      # If a server certificate is sent, there is no anonymity.  However,
      # when a certificate is sent, ephemeral keys may still be used to
      # exchange the premaster secret.  That's how RSA_EXPORT often works,
      # as well as how the DHE_* flavors work.
      const_set_lazy(:ServerKeyExchange) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_server_key_exchange
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__server_key_exchange, :initialize
      end }
      
      # Using RSA for Key Exchange:  exchange a session key that's not as big
      # as the signing-only key.  Used for export applications, since exported
      # RSA encryption keys can't be bigger than 512 bytes.
      # 
      # This is never used when keys are 512 bits or smaller, and isn't used
      # on "US Domestic" ciphers in any case.
      const_set_lazy(:RSA_ServerKeyExchange) { Class.new(ServerKeyExchange) do
        include_class_members HandshakeMessage
        
        attr_accessor :rsa_modulus
        alias_method :attr_rsa_modulus, :rsa_modulus
        undef_method :rsa_modulus
        alias_method :attr_rsa_modulus=, :rsa_modulus=
        undef_method :rsa_modulus=
        
        # 1 to 2^16 - 1 bytes
        attr_accessor :rsa_exponent
        alias_method :attr_rsa_exponent, :rsa_exponent
        undef_method :rsa_exponent
        alias_method :attr_rsa_exponent=, :rsa_exponent=
        undef_method :rsa_exponent=
        
        # 1 to 2^16 - 1 bytes
        attr_accessor :signature
        alias_method :attr_signature, :signature
        undef_method :signature
        alias_method :attr_signature=, :signature=
        undef_method :signature=
        
        attr_accessor :signature_bytes
        alias_method :attr_signature_bytes, :signature_bytes
        undef_method :signature_bytes
        alias_method :attr_signature_bytes=, :signature_bytes=
        undef_method :signature_bytes=
        
        typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        # Hash the nonces and the ephemeral RSA public key.
        def update_signature(clnt_nonce, svr_nonce)
          tmp = 0
          @signature.update(clnt_nonce)
          @signature.update(svr_nonce)
          tmp = @rsa_modulus.attr_length
          @signature.update((tmp >> 8))
          @signature.update((tmp & 0xff))
          @signature.update(@rsa_modulus)
          tmp = @rsa_exponent.attr_length
          @signature.update((tmp >> 8))
          @signature.update((tmp & 0xff))
          @signature.update(@rsa_exponent)
        end
        
        typesig { [PublicKey, PrivateKey, RandomCookie, RandomCookie, SecureRandom] }
        # Construct an RSA server key exchange message, using data
        # known _only_ to the server.
        # 
        # The client knows the public key corresponding to this private
        # key, from the Certificate message sent previously.  To comply
        # with US export regulations we use short RSA keys ... either
        # long term ones in the server's X509 cert, or else ephemeral
        # ones sent using this message.
        def initialize(ephemeral_key, private_key, clnt_nonce, svr_nonce, sr)
          @rsa_modulus = nil
          @rsa_exponent = nil
          @signature = nil
          @signature_bytes = nil
          super()
          rsa_key = JsseJce.get_rsapublic_key_spec(ephemeral_key)
          @rsa_modulus = to_byte_array(rsa_key.get_modulus)
          @rsa_exponent = to_byte_array(rsa_key.get_public_exponent)
          @signature = RSASignature.get_instance
          @signature.init_sign(private_key, sr)
          update_signature(clnt_nonce.attr_random_bytes, svr_nonce.attr_random_bytes)
          @signature_bytes = @signature.sign
        end
        
        typesig { [HandshakeInStream] }
        # Parse an RSA server key exchange message, using data known
        # to the client (and, in some situations, eavesdroppers).
        def initialize(input)
          @rsa_modulus = nil
          @rsa_exponent = nil
          @signature = nil
          @signature_bytes = nil
          super()
          @signature = RSASignature.get_instance
          @rsa_modulus = input.get_bytes16
          @rsa_exponent = input.get_bytes16
          @signature_bytes = input.get_bytes16
        end
        
        typesig { [] }
        # Get the ephemeral RSA public key that will be used in this
        # SSL connection.
        def get_public_key
          begin
            kfac = JsseJce.get_key_factory("RSA")
            # modulus and exponent are always positive
            kspec = RSAPublicKeySpec.new(BigInteger.new(1, @rsa_modulus), BigInteger.new(1, @rsa_exponent))
            return kfac.generate_public(kspec)
          rescue Exception => e
            raise RuntimeException.new(e)
          end
        end
        
        typesig { [PublicKey, RandomCookie, RandomCookie] }
        # Verify the signed temporary key using the hashes computed
        # from it and the two nonces.  This is called by clients
        # with "exportable" RSA flavors.
        def verify(certified_key, clnt_nonce, svr_nonce)
          @signature.init_verify(certified_key)
          update_signature(clnt_nonce.attr_random_bytes, svr_nonce.attr_random_bytes)
          return @signature.verify(@signature_bytes)
        end
        
        typesig { [] }
        def message_length
          return 6 + @rsa_modulus.attr_length + @rsa_exponent.attr_length + @signature_bytes.attr_length
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_bytes16(@rsa_modulus)
          s.put_bytes16(@rsa_exponent)
          s.put_bytes16(@signature_bytes)
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** RSA ServerKeyExchange")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            Debug.println(s, "RSA Modulus", @rsa_modulus)
            Debug.println(s, "RSA Public Exponent", @rsa_exponent)
          end
        end
        
        private
        alias_method :initialize__rsa_server_key_exchange, :initialize
      end }
      
      # Using Diffie-Hellman algorithm for key exchange.  All we really need to
      # do is securely get Diffie-Hellman keys (using the same P, G parameters)
      # to our peer, then we automatically have a shared secret without need
      # to exchange any more data.  (D-H only solutions, such as SKIP, could
      # eliminate key exchange negotiations and get faster connection setup.
      # But they still need a signature algorithm like DSS/DSA to support the
      # trusted distribution of keys without relying on unscalable physical
      # key distribution systems.)
      # 
      # This class supports several DH-based key exchange algorithms, though
      # perhaps eventually each deserves its own class.  Notably, this has
      # basic support for DH_anon and its DHE_DSS and DHE_RSA signed variants.
      const_set_lazy(:DH_ServerKeyExchange) { Class.new(ServerKeyExchange) do
        include_class_members HandshakeMessage
        
        class_module.module_eval {
          # Fix message encoding, see 4348279
          const_set_lazy(:DhKeyExchangeFix) { Debug.get_boolean_property("com.sun.net.ssl.dhKeyExchangeFix", true) }
          const_attr_reader  :DhKeyExchangeFix
        }
        
        attr_accessor :dh_p
        alias_method :attr_dh_p, :dh_p
        undef_method :dh_p
        alias_method :attr_dh_p=, :dh_p=
        undef_method :dh_p=
        
        # 1 to 2^16 - 1 bytes
        attr_accessor :dh_g
        alias_method :attr_dh_g, :dh_g
        undef_method :dh_g
        alias_method :attr_dh_g=, :dh_g=
        undef_method :dh_g=
        
        # 1 to 2^16 - 1 bytes
        attr_accessor :dh_ys
        alias_method :attr_dh_ys, :dh_ys
        undef_method :dh_ys
        alias_method :attr_dh_ys=, :dh_ys=
        undef_method :dh_ys=
        
        # 1 to 2^16 - 1 bytes
        attr_accessor :signature
        alias_method :attr_signature, :signature
        undef_method :signature
        alias_method :attr_signature=, :signature=
        undef_method :signature=
        
        typesig { [] }
        # Return the Diffie-Hellman modulus
        def get_modulus
          return BigInteger.new(1, @dh_p)
        end
        
        typesig { [] }
        # Return the Diffie-Hellman base/generator
        def get_base
          return BigInteger.new(1, @dh_g)
        end
        
        typesig { [] }
        # Return the server's Diffie-Hellman public key
        def get_server_public_key
          return BigInteger.new(1, @dh_ys)
        end
        
        typesig { [Signature, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        # Update sig with nonces and Diffie-Hellman public key.
        def update_signature(sig, clnt_nonce, svr_nonce)
          tmp = 0
          sig.update(clnt_nonce)
          sig.update(svr_nonce)
          tmp = @dh_p.attr_length
          sig.update((tmp >> 8))
          sig.update((tmp & 0xff))
          sig.update(@dh_p)
          tmp = @dh_g.attr_length
          sig.update((tmp >> 8))
          sig.update((tmp & 0xff))
          sig.update(@dh_g)
          tmp = @dh_ys.attr_length
          sig.update((tmp >> 8))
          sig.update((tmp & 0xff))
          sig.update(@dh_ys)
        end
        
        typesig { [DHCrypt] }
        # Construct from initialized DH key object, for DH_anon
        # key exchange.
        def initialize(obj)
          @dh_p = nil
          @dh_g = nil
          @dh_ys = nil
          @signature = nil
          super()
          get_values(obj)
          @signature = nil
        end
        
        typesig { [DHCrypt, PrivateKey, Array.typed(::Java::Byte), Array.typed(::Java::Byte), SecureRandom] }
        # Construct from initialized DH key object and the key associated
        # with the cert chain which was sent ... for DHE_DSS and DHE_RSA
        # key exchange.  (Constructor called by server.)
        def initialize(obj, key, clnt_nonce, svr_nonce, sr)
          @dh_p = nil
          @dh_g = nil
          @dh_ys = nil
          @signature = nil
          super()
          get_values(obj)
          sig = nil
          if ((key.get_algorithm == "DSA"))
            sig = JsseJce.get_signature(JsseJce::SIGNATURE_DSA)
          else
            sig = RSASignature.get_instance
          end
          sig.init_sign(key, sr)
          update_signature(sig, clnt_nonce, svr_nonce)
          @signature = sig.sign
        end
        
        typesig { [DHCrypt] }
        def get_values(obj)
          @dh_p = to_byte_array(obj.get_modulus)
          @dh_g = to_byte_array(obj.get_base)
          @dh_ys = to_byte_array(obj.get_public_key)
        end
        
        typesig { [HandshakeInStream] }
        # Construct a DH_ServerKeyExchange message from an input
        # stream, as if sent from server to client for use with
        # DH_anon key exchange
        def initialize(input)
          @dh_p = nil
          @dh_g = nil
          @dh_ys = nil
          @signature = nil
          super()
          @dh_p = input.get_bytes16
          @dh_g = input.get_bytes16
          @dh_ys = input.get_bytes16
          @signature = nil
        end
        
        typesig { [HandshakeInStream, PublicKey, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
        # Construct a DH_ServerKeyExchange message from an input stream
        # and a certificate, as if sent from server to client for use with
        # DHE_DSS or DHE_RSA key exchange.  (Called by client.)
        def initialize(input, public_key, clnt_nonce, svr_nonce, message_size)
          @dh_p = nil
          @dh_g = nil
          @dh_ys = nil
          @signature = nil
          super()
          @dh_p = input.get_bytes16
          @dh_g = input.get_bytes16
          @dh_ys = input.get_bytes16
          signature = nil
          if (self.class::DhKeyExchangeFix)
            signature = input.get_bytes16
          else
            message_size -= (@dh_p.attr_length + 2)
            message_size -= (@dh_g.attr_length + 2)
            message_size -= (@dh_ys.attr_length + 2)
            signature = Array.typed(::Java::Byte).new(message_size) { 0 }
            input.read(signature)
          end
          sig = nil
          algorithm = public_key.get_algorithm
          if ((algorithm == "DSA"))
            sig = JsseJce.get_signature(JsseJce::SIGNATURE_DSA)
          else
            if ((algorithm == "RSA"))
              sig = RSASignature.get_instance
            else
              raise SSLKeyException.new("neither an RSA or a DSA key")
            end
          end
          sig.init_verify(public_key)
          update_signature(sig, clnt_nonce, svr_nonce)
          if ((sig.verify(signature)).equal?(false))
            raise SSLKeyException.new("Server D-H key verification failed")
          end
        end
        
        typesig { [] }
        def message_length
          temp = 6 # overhead for p, g, y(s) values.
          temp += @dh_p.attr_length
          temp += @dh_g.attr_length
          temp += @dh_ys.attr_length
          if (!(@signature).nil?)
            temp += @signature.attr_length
            if (self.class::DhKeyExchangeFix)
              temp += 2
            end
          end
          return temp
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_bytes16(@dh_p)
          s.put_bytes16(@dh_g)
          s.put_bytes16(@dh_ys)
          if (!(@signature).nil?)
            if (self.class::DhKeyExchangeFix)
              s.put_bytes16(@signature)
            else
              s.write(@signature)
            end
          end
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** Diffie-Hellman ServerKeyExchange")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            Debug.println(s, "DH Modulus", @dh_p)
            Debug.println(s, "DH Base", @dh_g)
            Debug.println(s, "Server DH Public Key", @dh_ys)
            if ((@signature).nil?)
              s.println("Anonymous")
            else
              s.println("Signed with a DSA or RSA public key")
            end
          end
        end
        
        private
        alias_method :initialize__dh_server_key_exchange, :initialize
      end }
      
      # ECDH server key exchange message. Sent by the server for ECDHE and ECDH_anon
      # ciphersuites to communicate its ephemeral public key (including the
      # EC domain parameters).
      # 
      # We support named curves only, no explicitly encoded curves.
      const_set_lazy(:ECDH_ServerKeyExchange) { Class.new(ServerKeyExchange) do
        include_class_members HandshakeMessage
        
        class_module.module_eval {
          # constants for ECCurveType
          const_set_lazy(:CURVE_EXPLICIT_PRIME) { 1 }
          const_attr_reader  :CURVE_EXPLICIT_PRIME
          
          const_set_lazy(:CURVE_EXPLICIT_CHAR2) { 2 }
          const_attr_reader  :CURVE_EXPLICIT_CHAR2
          
          const_set_lazy(:CURVE_NAMED_CURVE) { 3 }
          const_attr_reader  :CURVE_NAMED_CURVE
        }
        
        # id of the curve we are using
        attr_accessor :curve_id
        alias_method :attr_curve_id, :curve_id
        undef_method :curve_id
        alias_method :attr_curve_id=, :curve_id=
        undef_method :curve_id=
        
        # encoded public point
        attr_accessor :point_bytes
        alias_method :attr_point_bytes, :point_bytes
        undef_method :point_bytes
        alias_method :attr_point_bytes=, :point_bytes=
        undef_method :point_bytes=
        
        # signature bytes (or null if anonymous)
        attr_accessor :signature_bytes
        alias_method :attr_signature_bytes, :signature_bytes
        undef_method :signature_bytes
        alias_method :attr_signature_bytes=, :signature_bytes=
        undef_method :signature_bytes=
        
        # public key object encapsulated in this message
        attr_accessor :public_key
        alias_method :attr_public_key, :public_key
        undef_method :public_key
        alias_method :attr_public_key=, :public_key=
        undef_method :public_key=
        
        typesig { [ECDHCrypt, PrivateKey, Array.typed(::Java::Byte), Array.typed(::Java::Byte), SecureRandom] }
        def initialize(obj, private_key, clnt_nonce, svr_nonce, sr)
          @curve_id = 0
          @point_bytes = nil
          @signature_bytes = nil
          @public_key = nil
          super()
          @public_key = obj.get_public_key
          params = @public_key.get_params
          point = @public_key.get_w
          @point_bytes = JsseJce.encode_point(point, params.get_curve)
          @curve_id = SupportedEllipticCurvesExtension.get_curve_index(params)
          if ((private_key).nil?)
            # ECDH_anon
            return
          end
          sig = get_signature(private_key.get_algorithm)
          sig.init_sign(private_key)
          update_signature(sig, clnt_nonce, svr_nonce)
          @signature_bytes = sig.sign
        end
        
        typesig { [HandshakeInStream, PublicKey, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        # Parse an ECDH server key exchange message.
        def initialize(input, signing_key, clnt_nonce, svr_nonce)
          @curve_id = 0
          @point_bytes = nil
          @signature_bytes = nil
          @public_key = nil
          super()
          curve_type = input.get_int8
          parameters = nil
          # These parsing errors should never occur as we negotiated
          # the supported curves during the exchange of the Hello messages.
          if ((curve_type).equal?(self.class::CURVE_NAMED_CURVE))
            @curve_id = input.get_int16
            if ((SupportedEllipticCurvesExtension.is_supported(@curve_id)).equal?(false))
              raise SSLHandshakeException.new("Unsupported curveId: " + (@curve_id).to_s)
            end
            curve_oid = SupportedEllipticCurvesExtension.get_curve_oid(@curve_id)
            if ((curve_oid).nil?)
              raise SSLHandshakeException.new("Unknown named curve: " + (@curve_id).to_s)
            end
            parameters = JsseJce.get_ecparameter_spec(curve_oid)
            if ((parameters).nil?)
              raise SSLHandshakeException.new("Unsupported curve: " + curve_oid)
            end
          else
            raise SSLHandshakeException.new("Unsupported ECCurveType: " + (curve_type).to_s)
          end
          @point_bytes = input.get_bytes8
          point = JsseJce.decode_point(@point_bytes, parameters.get_curve)
          factory = JsseJce.get_key_factory("EC")
          @public_key = factory.generate_public(ECPublicKeySpec.new(point, parameters))
          if ((signing_key).nil?)
            # ECDH_anon
            return
          end
          # verify the signature
          @signature_bytes = input.get_bytes16
          sig = get_signature(signing_key.get_algorithm)
          sig.init_verify(signing_key)
          update_signature(sig, clnt_nonce, svr_nonce)
          if ((sig.verify(@signature_bytes)).equal?(false))
            raise SSLKeyException.new("Invalid signature on ECDH server key exchange message")
          end
        end
        
        typesig { [] }
        # Get the ephemeral EC public key encapsulated in this message.
        def get_public_key
          return @public_key
        end
        
        class_module.module_eval {
          typesig { [String] }
          def get_signature(key_algorithm)
            if ((key_algorithm == "EC"))
              return JsseJce.get_signature(JsseJce::SIGNATURE_ECDSA)
            else
              if ((key_algorithm == "RSA"))
                return RSASignature.get_instance
              else
                raise NoSuchAlgorithmException.new("neither an RSA or a EC key")
              end
            end
          end
        }
        
        typesig { [Signature, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        def update_signature(sig, clnt_nonce, svr_nonce)
          sig.update(clnt_nonce)
          sig.update(svr_nonce)
          sig.update(self.class::CURVE_NAMED_CURVE)
          sig.update((@curve_id >> 8))
          sig.update(@curve_id)
          sig.update(@point_bytes.attr_length)
          sig.update(@point_bytes)
        end
        
        typesig { [] }
        def message_length
          sig_len = ((@signature_bytes).nil?) ? 0 : 2 + @signature_bytes.attr_length
          return 4 + @point_bytes.attr_length + sig_len
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_int8(self.class::CURVE_NAMED_CURVE)
          s.put_int16(@curve_id)
          s.put_bytes8(@point_bytes)
          if (!(@signature_bytes).nil?)
            s.put_bytes16(@signature_bytes)
          end
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** ECDH ServerKeyExchange")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            s.println("Server key: " + (@public_key).to_s)
          end
        end
        
        private
        alias_method :initialize__ecdh_server_key_exchange, :initialize
      end }
      
      const_set_lazy(:DistinguishedName) { Class.new do
        include_class_members HandshakeMessage
        
        # DER encoded distinguished name.
        # TLS requires that its not longer than 65535 bytes.
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        typesig { [HandshakeInStream] }
        def initialize(input)
          @name = nil
          @name = input.get_bytes16
        end
        
        typesig { [X500Principal] }
        def initialize(dn)
          @name = nil
          @name = dn.get_encoded
        end
        
        typesig { [] }
        def get_x500principal
          begin
            return X500Principal.new(@name)
          rescue IllegalArgumentException => e
            raise SSLProtocolException.new(e.get_message).init_cause(e)
          end
        end
        
        typesig { [] }
        def length
          return 2 + @name.attr_length
        end
        
        typesig { [HandshakeOutStream] }
        def send(output)
          output.put_bytes16(@name)
        end
        
        typesig { [PrintStream] }
        def print(output)
          principal = X500Principal.new(@name)
          output.println("<" + (principal.to_s).to_s + ">")
        end
        
        private
        alias_method :initialize__distinguished_name, :initialize
      end }
      
      # CertificateRequest ... SERVER --> CLIENT
      # 
      # Authenticated servers may ask clients to authenticate themselves
      # in turn, using this message.
      const_set_lazy(:CertificateRequest) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_certificate_request
        end
        
        class_module.module_eval {
          # enum ClientCertificateType
          const_set_lazy(:Cct_rsa_sign) { 1 }
          const_attr_reader  :Cct_rsa_sign
          
          const_set_lazy(:Cct_dss_sign) { 2 }
          const_attr_reader  :Cct_dss_sign
          
          const_set_lazy(:Cct_rsa_fixed_dh) { 3 }
          const_attr_reader  :Cct_rsa_fixed_dh
          
          const_set_lazy(:Cct_dss_fixed_dh) { 4 }
          const_attr_reader  :Cct_dss_fixed_dh
          
          # The existance of these two values is a bug in the SSL specification.
          # They are never used in the protocol.
          const_set_lazy(:Cct_rsa_ephemeral_dh) { 5 }
          const_attr_reader  :Cct_rsa_ephemeral_dh
          
          const_set_lazy(:Cct_dss_ephemeral_dh) { 6 }
          const_attr_reader  :Cct_dss_ephemeral_dh
          
          # From RFC 4492 (ECC)
          const_set_lazy(:Cct_ecdsa_sign) { 64 }
          const_attr_reader  :Cct_ecdsa_sign
          
          const_set_lazy(:Cct_rsa_fixed_ecdh) { 65 }
          const_attr_reader  :Cct_rsa_fixed_ecdh
          
          const_set_lazy(:Cct_ecdsa_fixed_ecdh) { 66 }
          const_attr_reader  :Cct_ecdsa_fixed_ecdh
          
          const_set_lazy(:TYPES_NO_ECC) { Array.typed(::Java::Byte).new([self.class::Cct_rsa_sign, self.class::Cct_dss_sign]) }
          const_attr_reader  :TYPES_NO_ECC
          
          const_set_lazy(:TYPES_ECC) { Array.typed(::Java::Byte).new([self.class::Cct_rsa_sign, self.class::Cct_dss_sign, self.class::Cct_ecdsa_sign]) }
          const_attr_reader  :TYPES_ECC
        }
        
        attr_accessor :types
        alias_method :attr_types, :types
        undef_method :types
        alias_method :attr_types=, :types=
        undef_method :types=
        
        # 1 to 255 types
        attr_accessor :authorities
        alias_method :attr_authorities, :authorities
        undef_method :authorities
        alias_method :attr_authorities=, :authorities=
        undef_method :authorities=
        
        typesig { [Array.typed(X509Certificate), KeyExchange] }
        # 3 to 2^16 - 1
        # ... "3" because that's the smallest DER-encoded X500 DN
        def initialize(ca, key_exchange)
          @types = nil
          @authorities = nil
          super()
          # always use X500Principal
          @authorities = Array.typed(DistinguishedName).new(ca.attr_length) { nil }
          i = 0
          while i < ca.attr_length
            x500principal = ca[i].get_subject_x500principal
            @authorities[i] = DistinguishedName.new(x500principal)
            ((i += 1) - 1)
          end
          # we support RSA, DSS, and ECDSA client authentication and they
          # can be used with all ciphersuites. If this changes, the code
          # needs to be adapted to take keyExchange into account.
          # We only request ECDSA client auth if we have ECC crypto available.
          @types = JsseJce.is_ec_available ? self.class::TYPES_ECC : self.class::TYPES_NO_ECC
        end
        
        typesig { [HandshakeInStream] }
        def initialize(input)
          @types = nil
          @authorities = nil
          super()
          @types = input.get_bytes8
          len = input.get_int16
          v = ArrayList.new
          while (len >= 3)
            dn = DistinguishedName.new(input)
            v.add(dn)
            len -= dn.length
          end
          if (!(len).equal?(0))
            raise SSLProtocolException.new("Bad CertificateRequest DN length")
          end
          @authorities = v.to_array(Array.typed(DistinguishedName).new(v.size) { nil })
        end
        
        typesig { [] }
        def get_authorities
          ret = Array.typed(X500Principal).new(@authorities.attr_length) { nil }
          i = 0
          while i < @authorities.attr_length
            ret[i] = @authorities[i].get_x500principal
            ((i += 1) - 1)
          end
          return ret
        end
        
        typesig { [] }
        def message_length
          len = 0
          len = 1 + @types.attr_length + 2
          i = 0
          while i < @authorities.attr_length
            len += @authorities[i].length
            ((i += 1) - 1)
          end
          return len
        end
        
        typesig { [HandshakeOutStream] }
        def send(output)
          len = 0
          i = 0
          while i < @authorities.attr_length
            len += @authorities[i].length
            ((i += 1) - 1)
          end
          output.put_bytes8(@types)
          output.put_int16(len)
          i_ = 0
          while i_ < @authorities.attr_length
            @authorities[i_].send(output)
            ((i_ += 1) - 1)
          end
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** CertificateRequest")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            s.print("Cert Types: ")
            i = 0
            while i < @types.attr_length
              case (@types[i])
              when self.class::Cct_rsa_sign
                s.print("RSA")
              when self.class::Cct_dss_sign
                s.print("DSS")
              when self.class::Cct_rsa_fixed_dh
                s.print("Fixed DH (RSA sig)")
              when self.class::Cct_dss_fixed_dh
                s.print("Fixed DH (DSS sig)")
              when self.class::Cct_rsa_ephemeral_dh
                s.print("Ephemeral DH (RSA sig)")
              when self.class::Cct_dss_ephemeral_dh
                s.print("Ephemeral DH (DSS sig)")
              when self.class::Cct_ecdsa_sign
                s.print("ECDSA")
              when self.class::Cct_rsa_fixed_ecdh
                s.print("Fixed ECDH (RSA sig)")
              when self.class::Cct_ecdsa_fixed_ecdh
                s.print("Fixed ECDH (ECDSA sig)")
              else
                s.print("Type-" + ((@types[i] & 0xff)).to_s)
              end
              if (!(i).equal?(@types.attr_length - 1))
                s.print(", ")
              end
              ((i += 1) - 1)
            end
            s.println
            s.println("Cert Authorities:")
            i_ = 0
            while i_ < @authorities.attr_length
              @authorities[i_].print(s)
              ((i_ += 1) - 1)
            end
          end
        end
        
        private
        alias_method :initialize__certificate_request, :initialize
      end }
      
      # ServerHelloDone ... SERVER --> CLIENT
      # 
      # When server's done sending its messages in response to the client's
      # "hello" (e.g. its own hello, certificate, key exchange message, perhaps
      # client certificate request) it sends this message to flag that it's
      # done that part of the handshake.
      const_set_lazy(:ServerHelloDone) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_server_hello_done
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        typesig { [HandshakeInStream] }
        def initialize(input)
          super()
          # nothing to do
        end
        
        typesig { [] }
        def message_length
          return 0
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          # nothing to send
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** ServerHelloDone")
        end
        
        private
        alias_method :initialize__server_hello_done, :initialize
      end }
      
      # CertificateVerify ... CLIENT --> SERVER
      # 
      # Sent after client sends signature-capable certificates (e.g. not
      # Diffie-Hellman) to verify.
      const_set_lazy(:CertificateVerify) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_certificate_verify
        end
        
        attr_accessor :signature
        alias_method :attr_signature, :signature
        undef_method :signature
        alias_method :attr_signature=, :signature=
        undef_method :signature=
        
        typesig { [ProtocolVersion, HandshakeHash, PrivateKey, SecretKey, SecureRandom] }
        # Create an RSA or DSA signed certificate verify message.
        def initialize(protocol_version, handshake_hash, private_key, master_secret, sr)
          @signature = nil
          super()
          algorithm = private_key.get_algorithm
          sig = get_signature(protocol_version, algorithm)
          sig.init_sign(private_key, sr)
          update_signature(sig, protocol_version, handshake_hash, algorithm, master_secret)
          @signature = sig.sign
        end
        
        typesig { [HandshakeInStream] }
        # Unmarshal the signed data from the input stream.
        def initialize(input)
          @signature = nil
          super()
          @signature = input.get_bytes16
        end
        
        typesig { [ProtocolVersion, HandshakeHash, PublicKey, SecretKey] }
        # Verify a certificate verify message. Return the result of verification,
        # if there is a problem throw a GeneralSecurityException.
        def verify(protocol_version, handshake_hash, public_key, master_secret)
          algorithm = public_key.get_algorithm
          sig = get_signature(protocol_version, algorithm)
          sig.init_verify(public_key)
          update_signature(sig, protocol_version, handshake_hash, algorithm, master_secret)
          return sig.verify(@signature)
        end
        
        class_module.module_eval {
          typesig { [ProtocolVersion, String] }
          # Get the Signature object appropriate for verification using the
          # given signature algorithm and protocol version.
          def get_signature(protocol_version, algorithm)
            if ((algorithm == "RSA"))
              return RSASignature.get_internal_instance
            else
              if ((algorithm == "DSA"))
                return JsseJce.get_signature(JsseJce::SIGNATURE_RAWDSA)
              else
                if ((algorithm == "EC"))
                  return JsseJce.get_signature(JsseJce::SIGNATURE_RAWECDSA)
                else
                  raise SignatureException.new("Unrecognized algorithm: " + algorithm)
                end
              end
            end
          end
          
          typesig { [Signature, ProtocolVersion, HandshakeHash, String, SecretKey] }
          # Update the Signature with the data appropriate for the given
          # signature algorithm and protocol version so that the object is
          # ready for signing or verifying.
          def update_signature(sig, protocol_version, handshake_hash, algorithm, master_key)
            md5clone = handshake_hash.get_md5clone
            sha_clone = handshake_hash.get_shaclone
            tls = protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v
            if ((algorithm == "RSA"))
              if (tls)
                # nothing to do
              else
                # SSLv3
                update_digest(md5clone, MD5_pad1, MD5_pad2, master_key)
                update_digest(sha_clone, SHA_pad1, SHA_pad2, master_key)
              end
              # need to use these hashes directly
              RSASignature.set_hashes(sig, md5clone, sha_clone)
            else
              # DSA, ECDSA
              if (tls)
                # nothing to do
              else
                # SSLv3
                update_digest(sha_clone, SHA_pad1, SHA_pad2, master_key)
              end
              sig.update(sha_clone.digest)
            end
          end
          
          typesig { [MessageDigest, Array.typed(::Java::Byte), Array.typed(::Java::Byte), SecretKey] }
          # Update the MessageDigest for SSLv3 certificate verify or finished
          # message calculation. The digest must already have been updated with
          # all preceding handshake messages.
          # Used by the Finished class as well.
          def update_digest(md, pad1, pad2, master_secret)
            # Digest the key bytes if available.
            # Otherwise (sensitive key), try digesting the key directly.
            # That is currently only implemented in SunPKCS11 using a private
            # reflection API, so we avoid that if possible.
            key_bytes = ("RAW" == master_secret.get_format) ? master_secret.get_encoded : nil
            if (!(key_bytes).nil?)
              md.update(key_bytes)
            else
              digest_key(md, master_secret)
            end
            md.update(pad1)
            temp = md.digest
            if (!(key_bytes).nil?)
              md.update(key_bytes)
            else
              digest_key(md, master_secret)
            end
            md.update(pad2)
            md.update(temp)
          end
          
          when_class_loaded do
            begin
              const_set :Delegate, Class.for_name("java.security.MessageDigest$Delegate")
              const_set :SpiField, self.class::Delegate.get_declared_field("digestSpi")
            rescue Exception => e
              raise RuntimeException.new("Reflection failed", e)
            end
            make_accessible(self.class::SpiField)
          end
          
          typesig { [AccessibleObject] }
          def make_accessible(o)
            AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members CertificateVerify
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                o.set_accessible(true)
                return nil
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          # ConcurrentHashMap does not allow null values, use this marker object
          const_set_lazy(:NULL_OBJECT) { Object.new }
          const_attr_reader  :NULL_OBJECT
          
          # cache Method objects per Spi class
          # Note that this will prevent the Spi classes from being GC'd. We assume
          # that is not a problem.
          const_set_lazy(:MethodCache) { ConcurrentHashMap.new }
          const_attr_reader  :MethodCache
          
          typesig { [MessageDigest, SecretKey] }
          def digest_key(md, key)
            begin
              # Verify that md is implemented via MessageDigestSpi, not
              # via JDK 1.1 style MessageDigest subclassing.
              if (!(md.get_class).equal?(self.class::Delegate))
                raise Exception.new("Digest is not a MessageDigestSpi")
              end
              spi = self.class::SpiField.get(md)
              clazz = spi.get_class
              r = self.class::MethodCache.get(clazz)
              if ((r).nil?)
                begin
                  r = clazz.get_declared_method("implUpdate", SecretKey.class)
                  make_accessible(r)
                rescue NoSuchMethodException => e
                  r = self.class::NULL_OBJECT
                end
                self.class::MethodCache.put(clazz, r)
              end
              if ((r).equal?(self.class::NULL_OBJECT))
                raise Exception.new("Digest does not support implUpdate(SecretKey)")
              end
              update_ = r
              update_.invoke(spi, key)
            rescue Exception => e
              raise RuntimeException.new("Could not obtain encoded key and MessageDigest cannot digest key", e)
            end
          end
        }
        
        typesig { [] }
        def message_length
          return 2 + @signature.attr_length
        end
        
        typesig { [HandshakeOutStream] }
        def send(s)
          s.put_bytes16(@signature)
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** CertificateVerify")
        end
        
        private
        alias_method :initialize__certificate_verify, :initialize
      end }
      
      # FINISHED ... sent by both CLIENT and SERVER
      # 
      # This is the FINISHED message as defined in the SSL and TLS protocols.
      # Both protocols define this handshake message slightly differently.
      # This class supports both formats.
      # 
      # When handshaking is finished, each side sends a "change_cipher_spec"
      # record, then immediately sends a "finished" handshake message prepared
      # according to the newly adopted cipher spec.
      # 
      # NOTE that until this is sent, no application data may be passed, unless
      # some non-default cipher suite has already been set up on this connection
      # connection (e.g. a previous handshake arranged one).
      const_set_lazy(:Finished) { Class.new(HandshakeMessage) do
        include_class_members HandshakeMessage
        
        typesig { [] }
        def message_type
          return Ht_finished
        end
        
        class_module.module_eval {
          # constant for a Finished message sent by the client
          const_set_lazy(:CLIENT) { 1 }
          const_attr_reader  :CLIENT
          
          # constant for a Finished message sent by the server
          const_set_lazy(:SERVER) { 2 }
          const_attr_reader  :SERVER
          
          # enum Sender:  "CLNT" and "SRVR"
          const_set_lazy(:SSL_CLIENT) { Array.typed(::Java::Byte).new([0x43, 0x4c, 0x4e, 0x54]) }
          const_attr_reader  :SSL_CLIENT
          
          const_set_lazy(:SSL_SERVER) { Array.typed(::Java::Byte).new([0x53, 0x52, 0x56, 0x52]) }
          const_attr_reader  :SSL_SERVER
        }
        
        # Contents of the finished message ("checksum"). For TLS, it
        # is 12 bytes long, for SSLv3 36 bytes.
        attr_accessor :verify_data
        alias_method :attr_verify_data, :verify_data
        undef_method :verify_data
        alias_method :attr_verify_data=, :verify_data=
        undef_method :verify_data=
        
        typesig { [ProtocolVersion, HandshakeHash, ::Java::Int, SecretKey] }
        # Create a finished message to send to the remote peer.
        def initialize(protocol_version, handshake_hash, sender, master)
          @verify_data = nil
          super()
          @verify_data = get_finished(protocol_version, handshake_hash, sender, master)
        end
        
        typesig { [ProtocolVersion, HandshakeInStream] }
        # Constructor that reads FINISHED message from stream.
        def initialize(protocol_version, input)
          @verify_data = nil
          super()
          msg_len = (protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v) ? 12 : 36
          @verify_data = Array.typed(::Java::Byte).new(msg_len) { 0 }
          input.read(@verify_data)
        end
        
        typesig { [ProtocolVersion, HandshakeHash, ::Java::Int, SecretKey] }
        # Verify that the hashes here are what would have been produced
        # according to a given set of inputs.  This is used to ensure that
        # both client and server are fully in sync, and that the handshake
        # computations have been successful.
        def verify(protocol_version, handshake_hash, sender, master)
          my_finished = get_finished(protocol_version, handshake_hash, sender, master)
          return (Arrays == my_finished)
        end
        
        class_module.module_eval {
          typesig { [ProtocolVersion, HandshakeHash, ::Java::Int, SecretKey] }
          # Perform the actual finished message calculation.
          def get_finished(protocol_version, handshake_hash, sender, master_key)
            ssl_label = nil
            tls_label = nil
            if ((sender).equal?(self.class::CLIENT))
              ssl_label = self.class::SSL_CLIENT
              tls_label = "client finished"
            else
              if ((sender).equal?(self.class::SERVER))
                ssl_label = self.class::SSL_SERVER
                tls_label = "server finished"
              else
                raise RuntimeException.new("Invalid sender: " + (sender).to_s)
              end
            end
            md5clone = handshake_hash.get_md5clone
            sha_clone = handshake_hash.get_shaclone
            if (protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
              # TLS
              begin
                seed = Array.typed(::Java::Byte).new(36) { 0 }
                md5clone.digest(seed, 0, 16)
                sha_clone.digest(seed, 16, 20)
                spec = TlsPrfParameterSpec.new(master_key, tls_label, seed, 12)
                prf = JsseJce.get_key_generator("SunTlsPrf")
                prf.init(spec)
                prf_key = prf.generate_key
                if ((("RAW" == prf_key.get_format)).equal?(false))
                  raise ProviderException.new("Invalid PRF output, format must be RAW")
                end
                finished = prf_key.get_encoded
                return finished
              rescue GeneralSecurityException => e
                raise RuntimeException.new("PRF failed", e)
              end
            else
              # SSLv3
              update_digest(md5clone, ssl_label, MD5_pad1, MD5_pad2, master_key)
              update_digest(sha_clone, ssl_label, SHA_pad1, SHA_pad2, master_key)
              finished = Array.typed(::Java::Byte).new(36) { 0 }
              begin
                md5clone.digest(finished, 0, 16)
                sha_clone.digest(finished, 16, 20)
              rescue DigestException => e
                # cannot occur
                raise RuntimeException.new("Digest failed", e)
              end
              return finished
            end
          end
          
          typesig { [MessageDigest, Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), SecretKey] }
          # Update the MessageDigest for SSLv3 finished message calculation.
          # The digest must already have been updated with all preceding handshake
          # messages. This operation is almost identical to the certificate verify
          # hash, reuse that code.
          def update_digest(md, sender, pad1, pad2, master_secret)
            md.update(sender)
            CertificateVerify.update_digest(md, pad1, pad2, master_secret)
          end
        }
        
        typesig { [] }
        def message_length
          return @verify_data.attr_length
        end
        
        typesig { [HandshakeOutStream] }
        def send(out)
          out.write(@verify_data)
        end
        
        typesig { [PrintStream] }
        def print(s)
          s.println("*** Finished")
          if (!(Debug).nil? && Debug.is_on("verbose"))
            Debug.println(s, "verify_data", @verify_data)
            s.println("***")
          end
        end
        
        private
        alias_method :initialize__finished, :initialize
      end }
    }
    
    private
    alias_method :initialize__handshake_message, :initialize
  end
  
end

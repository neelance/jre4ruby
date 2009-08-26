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
module Sun::Security::Pkcs11
  module P11KeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Interfaces
      include ::Javax::Crypto::Spec
      include_const ::Sun::Security::Rsa, :RSAPublicKeyImpl
      include_const ::Sun::Security::Internal::Interfaces, :TlsMasterSecret
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # Key implementation classes.
  # 
  # In PKCS#11, the components of private and secret keys may or may not
  # be accessible. If they are, we use the algorithm specific key classes
  # (e.g. DSAPrivateKey) for compatibility with existing applications.
  # If the components are not accessible, we use a generic class that
  # only implements PrivateKey (or SecretKey). Whether the components of a
  # key are extractable is automatically determined when the key object is
  # created.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Key 
    include_class_members P11KeyImports
    include Key
    
    class_module.module_eval {
      const_set_lazy(:PUBLIC) { "public" }
      const_attr_reader  :PUBLIC
      
      const_set_lazy(:PRIVATE) { "private" }
      const_attr_reader  :PRIVATE
      
      const_set_lazy(:SECRET) { "secret" }
      const_attr_reader  :SECRET
    }
    
    # type of key, one of (PUBLIC, PRIVATE, SECRET)
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # session in which the key was created, relevant for session objects
    attr_accessor :session
    alias_method :attr_session, :session
    undef_method :session
    alias_method :attr_session=, :session=
    undef_method :session=
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name, returned by getAlgorithm(), etc.
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # key id
    attr_accessor :key_id
    alias_method :attr_key_id, :key_id
    undef_method :key_id
    alias_method :attr_key_id=, :key_id=
    undef_method :key_id=
    
    # effective key length of the key, e.g. 56 for a DES key
    attr_accessor :key_length
    alias_method :attr_key_length, :key_length
    undef_method :key_length
    alias_method :attr_key_length=, :key_length=
    undef_method :key_length=
    
    # flags indicating whether the key is a token object, sensitive, extractable
    attr_accessor :token_object
    alias_method :attr_token_object, :token_object
    undef_method :token_object
    alias_method :attr_token_object=, :token_object=
    undef_method :token_object=
    
    attr_accessor :sensitive
    alias_method :attr_sensitive, :sensitive
    undef_method :sensitive
    alias_method :attr_sensitive=, :sensitive=
    undef_method :sensitive=
    
    attr_accessor :extractable
    alias_method :attr_extractable, :extractable
    undef_method :extractable
    alias_method :attr_extractable=, :extractable=
    undef_method :extractable=
    
    typesig { [String, Session, ::Java::Long, String, ::Java::Int, Array.typed(CK_ATTRIBUTE)] }
    def initialize(type, session, key_id, algorithm, key_length, attributes)
      @type = nil
      @session = nil
      @token = nil
      @algorithm = nil
      @key_id = 0
      @key_length = 0
      @token_object = false
      @sensitive = false
      @extractable = false
      @type = type
      @session = session
      @token = session.attr_token
      @key_id = key_id
      @algorithm = algorithm
      @key_length = key_length
      token_object = false
      sensitive = false
      extractable = true
      n = ((attributes).nil?) ? 0 : attributes.attr_length
      i = 0
      while i < n
        attr = attributes[i]
        if ((attr.attr_type).equal?(CKA_TOKEN))
          token_object = attr.get_boolean
        else
          if ((attr.attr_type).equal?(CKA_SENSITIVE))
            sensitive = attr.get_boolean
          else
            if ((attr.attr_type).equal?(CKA_EXTRACTABLE))
              extractable = attr.get_boolean
            end
          end
        end
        i += 1
      end
      @token_object = token_object
      @sensitive = sensitive
      @extractable = extractable
      if ((token_object).equal?(false))
        session.add_object
      end
    end
    
    typesig { [] }
    # see JCA spec
    def get_algorithm
      @token.ensure_valid
      return @algorithm
    end
    
    typesig { [] }
    # see JCA spec
    def get_encoded
      b = get_encoded_internal
      return ((b).nil?) ? nil : b.clone
    end
    
    typesig { [] }
    def get_encoded_internal
      raise NotImplementedError
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      # equals() should never throw exceptions
      if ((@token.is_valid).equal?(false))
        return false
      end
      if ((obj.is_a?(Key)).equal?(false))
        return false
      end
      this_format = get_format
      if ((this_format).nil?)
        # no encoding, key only equal to itself
        # XXX getEncoded() for unextractable keys will change that
        return false
      end
      other = obj
      if (((this_format == other.get_format)).equal?(false))
        return false
      end
      this_enc = self.get_encoded_internal
      other_enc = nil
      if (obj.is_a?(P11Key))
        other_enc = (other).get_encoded_internal
      else
        other_enc = other.get_encoded
      end
      return (Arrays == this_enc)
    end
    
    typesig { [] }
    def hash_code
      # hashCode() should never throw exceptions
      if ((@token.is_valid).equal?(false))
        return 0
      end
      b1 = get_encoded_internal
      if ((b1).nil?)
        return 0
      end
      r = b1.attr_length
      i = 0
      while i < b1.attr_length
        r += (b1[i] & 0xff) * 37
        i += 1
      end
      return r
    end
    
    typesig { [] }
    def write_replace
      type = nil
      format = get_format
      if (is_private && ("PKCS#8" == format))
        type = KeyRep::Type::PRIVATE
      else
        if (is_public && ("X.509" == format))
          type = KeyRep::Type::PUBLIC
        else
          if (is_secret && ("RAW" == format))
            type = KeyRep::Type::SECRET
          else
            # XXX short term serialization for unextractable keys
            raise NotSerializableException.new("Cannot serialize sensitive and unextractable keys")
          end
        end
      end
      return KeyRep.new(type, get_algorithm, format, get_encoded)
    end
    
    typesig { [] }
    def to_s
      @token.ensure_valid
      s1 = RJava.cast_to_string(@token.attr_provider.get_name) + " " + @algorithm + " " + @type + " key, " + RJava.cast_to_string(@key_length) + " bits"
      s1 += " (id " + RJava.cast_to_string(@key_id) + ", " + RJava.cast_to_string((@token_object ? "token" : "session")) + " object"
      if (is_public)
        s1 += ")"
      else
        s1 += ", " + RJava.cast_to_string((@sensitive ? "" : "not ")) + "sensitive"
        s1 += ", " + RJava.cast_to_string((@extractable ? "" : "un")) + "extractable)"
      end
      return s1
    end
    
    typesig { [] }
    def key_length
      return @key_length
    end
    
    typesig { [] }
    def is_public
      return (@type).equal?(PUBLIC)
    end
    
    typesig { [] }
    def is_private
      return (@type).equal?(PRIVATE)
    end
    
    typesig { [] }
    def is_secret
      return (@type).equal?(SECRET)
    end
    
    typesig { [Array.typed(CK_ATTRIBUTE)] }
    def fetch_attributes(attributes)
      temp_session = nil
      begin
        temp_session = @token.get_op_session
        @token.attr_p11._c_get_attribute_value(temp_session.id, @key_id, attributes)
      rescue PKCS11Exception => e
        raise ProviderException.new(e)
      ensure
        @token.release_session(temp_session)
      end
    end
    
    typesig { [] }
    def finalize
      if (@token_object || ((@token.is_valid).equal?(false)))
        super
        return
      end
      new_session = nil
      begin
        new_session = @token.get_op_session
        @token.attr_p11._c_destroy_object(new_session.id, @key_id)
      rescue PKCS11Exception => e
        # ignore
      ensure
        @token.release_session(new_session)
        @session.remove_object
        super
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:A0) { Array.typed(CK_ATTRIBUTE).new(0) { nil } }
      const_attr_reader  :A0
      
      typesig { [Session, ::Java::Long, Array.typed(CK_ATTRIBUTE), Array.typed(CK_ATTRIBUTE)] }
      def get_attributes(session, key_id, known_attributes, desired_attributes)
        if ((known_attributes).nil?)
          known_attributes = A0
        end
        i = 0
        while i < desired_attributes.attr_length
          # For each desired attribute, check to see if we have the value
          # available already. If everything is here, we save a native call.
          attr = desired_attributes[i]
          known_attributes.each do |known|
            if (((attr.attr_type).equal?(known.attr_type)) && (!(known.attr_p_value).nil?))
              attr.attr_p_value = known.attr_p_value
              break # break inner for loop
            end
          end
          if ((attr.attr_p_value).nil?)
            # nothing found, need to call C_GetAttributeValue()
            j = 0
            while j < i
              # clear values copied from knownAttributes
              desired_attributes[j].attr_p_value = nil
              j += 1
            end
            begin
              session.attr_token.attr_p11._c_get_attribute_value(session.id, key_id, desired_attributes)
            rescue PKCS11Exception => e
              raise ProviderException.new(e)
            end
            break # break loop, goto return
          end
          i += 1
        end
        return desired_attributes
      end
      
      typesig { [Session, ::Java::Long, String, ::Java::Int, Array.typed(CK_ATTRIBUTE)] }
      def secret_key(session, key_id, algorithm, key_length, attributes)
        attributes = get_attributes(session, key_id, attributes, Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_TOKEN), CK_ATTRIBUTE.new(CKA_SENSITIVE), CK_ATTRIBUTE.new(CKA_EXTRACTABLE), ]))
        return P11SecretKey.new(session, key_id, algorithm, key_length, attributes)
      end
      
      typesig { [Session, ::Java::Long, String, ::Java::Int, Array.typed(CK_ATTRIBUTE), ::Java::Int, ::Java::Int] }
      def master_secret_key(session, key_id, algorithm, key_length, attributes, major, minor)
        attributes = get_attributes(session, key_id, attributes, Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_TOKEN), CK_ATTRIBUTE.new(CKA_SENSITIVE), CK_ATTRIBUTE.new(CKA_EXTRACTABLE), ]))
        return P11TlsMasterSecretKey.new(session, key_id, algorithm, key_length, attributes, major, minor)
      end
      
      typesig { [Session, ::Java::Long, String, ::Java::Int, Array.typed(CK_ATTRIBUTE)] }
      # we assume that all components of public keys are always accessible
      def public_key(session, key_id, algorithm, key_length, attributes)
        if ((algorithm == "RSA"))
          return P11RSAPublicKey.new(session, key_id, algorithm, key_length, attributes)
        else
          if ((algorithm == "DSA"))
            return P11DSAPublicKey.new(session, key_id, algorithm, key_length, attributes)
          else
            if ((algorithm == "DH"))
              return P11DHPublicKey.new(session, key_id, algorithm, key_length, attributes)
            else
              if ((algorithm == "EC"))
                return P11ECPublicKey.new(session, key_id, algorithm, key_length, attributes)
              else
                raise ProviderException.new("Unknown public key algorithm " + algorithm)
              end
            end
          end
        end
      end
      
      typesig { [Session, ::Java::Long, String, ::Java::Int, Array.typed(CK_ATTRIBUTE)] }
      def private_key(session, key_id, algorithm, key_length, attributes)
        attributes = get_attributes(session, key_id, attributes, Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_TOKEN), CK_ATTRIBUTE.new(CKA_SENSITIVE), CK_ATTRIBUTE.new(CKA_EXTRACTABLE), ]))
        if (attributes[1].get_boolean || ((attributes[2].get_boolean).equal?(false)))
          return P11PrivateKey.new(session, key_id, algorithm, key_length, attributes)
        else
          if ((algorithm == "RSA"))
            # XXX better test for RSA CRT keys (single getAttributes() call)
            # we need to determine whether this is a CRT key
            # see if we can obtain the public exponent
            # this should also be readable for sensitive/extractable keys
            attrs2 = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT), ])
            crt_key = false
            begin
              session.attr_token.attr_p11._c_get_attribute_value(session.id, key_id, attrs2)
              crt_key = (attrs2[0].attr_p_value.is_a?(Array.typed(::Java::Byte)))
            rescue PKCS11Exception => e
              # ignore, assume not available
              crt_key = false
            end
            if (crt_key)
              return P11RSAPrivateKey.new(session, key_id, algorithm, key_length, attributes)
            else
              return P11RSAPrivateNonCRTKey.new(session, key_id, algorithm, key_length, attributes)
            end
          else
            if ((algorithm == "DSA"))
              return P11DSAPrivateKey.new(session, key_id, algorithm, key_length, attributes)
            else
              if ((algorithm == "DH"))
                return P11DHPrivateKey.new(session, key_id, algorithm, key_length, attributes)
              else
                if ((algorithm == "EC"))
                  return P11ECPrivateKey.new(session, key_id, algorithm, key_length, attributes)
                else
                  raise ProviderException.new("Unknown private key algorithm " + algorithm)
                end
              end
            end
          end
        end
      end
      
      # class for sensitive and unextractable private keys
      const_set_lazy(:P11PrivateKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include PrivateKey
        }
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        # XXX temporary encoding for serialization purposes
        def get_format
          self.attr_token.ensure_valid
          return nil
        end
        
        typesig { [] }
        def get_encoded_internal
          self.attr_token.ensure_valid
          return nil
        end
        
        private
        alias_method :initialize__p11private_key, :initialize
      end }
      
      const_set_lazy(:P11SecretKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include SecretKey
        }
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @encoded = nil
          super(SECRET, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          if (self.attr_sensitive || ((self.attr_extractable).equal?(false)))
            return nil
          else
            return "RAW"
          end
        end
        
        typesig { [] }
        def get_encoded_internal
          self.attr_token.ensure_valid
          if ((get_format).nil?)
            return nil
          end
          b = @encoded
          if ((b).nil?)
            synchronized((self)) do
              b = @encoded
              if ((b).nil?)
                temp_session = nil
                begin
                  temp_session = self.attr_token.get_op_session
                  attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), ])
                  self.attr_token.attr_p11._c_get_attribute_value(temp_session.id, self.attr_key_id, attributes)
                  b = attributes[0].get_byte_array
                rescue self.class::PKCS11Exception => e
                  raise self.class::ProviderException.new(e)
                ensure
                  self.attr_token.release_session(temp_session)
                end
                @encoded = b
              end
            end
          end
          return b
        end
        
        private
        alias_method :initialize__p11secret_key, :initialize
      end }
      
      const_set_lazy(:P11TlsMasterSecretKey) { Class.new(P11SecretKey) do
        include_class_members P11Key
        overload_protected {
          include TlsMasterSecret
        }
        
        attr_accessor :major_version
        alias_method :attr_major_version, :major_version
        undef_method :major_version
        alias_method :attr_major_version=, :major_version=
        undef_method :major_version=
        
        attr_accessor :minor_version
        alias_method :attr_minor_version, :minor_version
        undef_method :minor_version
        alias_method :attr_minor_version=, :minor_version=
        undef_method :minor_version=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE), ::Java::Int, ::Java::Int] }
        def initialize(session, key_id, algorithm, key_length, attributes, major, minor)
          @major_version = 0
          @minor_version = 0
          super(session, key_id, algorithm, key_length, attributes)
          @major_version = major
          @minor_version = minor
        end
        
        typesig { [] }
        def get_major_version
          return @major_version
        end
        
        typesig { [] }
        def get_minor_version
          return @minor_version
        end
        
        private
        alias_method :initialize__p11tls_master_secret_key, :initialize
      end }
      
      # RSA CRT private key
      const_set_lazy(:P11RSAPrivateKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include RSAPrivateCrtKey
        }
        
        attr_accessor :n
        alias_method :attr_n, :n
        undef_method :n
        alias_method :attr_n=, :n=
        undef_method :n=
        
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        attr_accessor :d
        alias_method :attr_d, :d
        undef_method :d
        alias_method :attr_d=, :d=
        undef_method :d=
        
        attr_accessor :p
        alias_method :attr_p, :p
        undef_method :p
        alias_method :attr_p=, :p=
        undef_method :p=
        
        attr_accessor :q
        alias_method :attr_q, :q
        undef_method :q
        alias_method :attr_q=, :q=
        undef_method :q=
        
        attr_accessor :pe
        alias_method :attr_pe, :pe
        undef_method :pe
        alias_method :attr_pe=, :pe=
        undef_method :pe=
        
        attr_accessor :qe
        alias_method :attr_qe, :qe
        undef_method :qe
        alias_method :attr_qe=, :qe=
        undef_method :qe=
        
        attr_accessor :coeff
        alias_method :attr_coeff, :coeff
        undef_method :coeff
        alias_method :attr_coeff=, :coeff=
        undef_method :coeff=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @n = nil
          @e = nil
          @d = nil
          @p = nil
          @q = nil
          @pe = nil
          @qe = nil
          @coeff = nil
          @encoded = nil
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@n).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_MODULUS), self.class::CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT), self.class::CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT), self.class::CK_ATTRIBUTE.new(CKA_PRIME_1), self.class::CK_ATTRIBUTE.new(CKA_PRIME_2), self.class::CK_ATTRIBUTE.new(CKA_EXPONENT_1), self.class::CK_ATTRIBUTE.new(CKA_EXPONENT_2), self.class::CK_ATTRIBUTE.new(CKA_COEFFICIENT), ])
            fetch_attributes(attributes)
            @n = attributes[0].get_big_integer
            @e = attributes[1].get_big_integer
            @d = attributes[2].get_big_integer
            @p = attributes[3].get_big_integer
            @q = attributes[4].get_big_integer
            @pe = attributes[5].get_big_integer
            @qe = attributes[6].get_big_integer
            @coeff = attributes[7].get_big_integer
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "PKCS#8"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                # XXX make constructor in SunRsaSign provider public
                # and call it directly
                factory = KeyFactory.get_instance("RSA", P11Util.get_sun_rsa_sign_provider)
                new_key = factory.translate_key(self)
                @encoded = new_key.get_encoded
              rescue self.class::GeneralSecurityException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_modulus
          fetch_values
          return @n
        end
        
        typesig { [] }
        def get_public_exponent
          fetch_values
          return @e
        end
        
        typesig { [] }
        def get_private_exponent
          fetch_values
          return @d
        end
        
        typesig { [] }
        def get_prime_p
          fetch_values
          return @p
        end
        
        typesig { [] }
        def get_prime_q
          fetch_values
          return @q
        end
        
        typesig { [] }
        def get_prime_exponent_p
          fetch_values
          return @pe
        end
        
        typesig { [] }
        def get_prime_exponent_q
          fetch_values
          return @qe
        end
        
        typesig { [] }
        def get_crt_coefficient
          fetch_values
          return @coeff
        end
        
        typesig { [] }
        def to_s
          fetch_values
          sb = self.class::StringBuilder.new(super)
          sb.append("\n  modulus:          ")
          sb.append(@n)
          sb.append("\n  public exponent:  ")
          sb.append(@e)
          sb.append("\n  private exponent: ")
          sb.append(@d)
          sb.append("\n  prime p:          ")
          sb.append(@p)
          sb.append("\n  prime q:          ")
          sb.append(@q)
          sb.append("\n  prime exponent p: ")
          sb.append(@pe)
          sb.append("\n  prime exponent q: ")
          sb.append(@qe)
          sb.append("\n  crt coefficient:  ")
          sb.append(@coeff)
          return sb.to_s
        end
        
        private
        alias_method :initialize__p11rsaprivate_key, :initialize
      end }
      
      # RSA non-CRT private key
      const_set_lazy(:P11RSAPrivateNonCRTKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include RSAPrivateKey
        }
        
        attr_accessor :n
        alias_method :attr_n, :n
        undef_method :n
        alias_method :attr_n=, :n=
        undef_method :n=
        
        attr_accessor :d
        alias_method :attr_d, :d
        undef_method :d
        alias_method :attr_d=, :d=
        undef_method :d=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @n = nil
          @d = nil
          @encoded = nil
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@n).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_MODULUS), self.class::CK_ATTRIBUTE.new(CKA_PRIVATE_EXPONENT), ])
            fetch_attributes(attributes)
            @n = attributes[0].get_big_integer
            @d = attributes[1].get_big_integer
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "PKCS#8"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                # XXX make constructor in SunRsaSign provider public
                # and call it directly
                factory = KeyFactory.get_instance("RSA", P11Util.get_sun_rsa_sign_provider)
                new_key = factory.translate_key(self)
                @encoded = new_key.get_encoded
              rescue self.class::GeneralSecurityException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_modulus
          fetch_values
          return @n
        end
        
        typesig { [] }
        def get_private_exponent
          fetch_values
          return @d
        end
        
        typesig { [] }
        def to_s
          fetch_values
          sb = self.class::StringBuilder.new(super)
          sb.append("\n  modulus:          ")
          sb.append(@n)
          sb.append("\n  private exponent: ")
          sb.append(@d)
          return sb.to_s
        end
        
        private
        alias_method :initialize__p11rsaprivate_non_crtkey, :initialize
      end }
      
      const_set_lazy(:P11RSAPublicKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include RSAPublicKey
        }
        
        attr_accessor :n
        alias_method :attr_n, :n
        undef_method :n
        alias_method :attr_n=, :n=
        undef_method :n=
        
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @n = nil
          @e = nil
          @encoded = nil
          super(PUBLIC, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@n).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_MODULUS), self.class::CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT), ])
            fetch_attributes(attributes)
            @n = attributes[0].get_big_integer
            @e = attributes[1].get_big_integer
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "X.509"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                @encoded = self.class::RSAPublicKeyImpl.new(@n, @e).get_encoded
              rescue self.class::InvalidKeyException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_modulus
          fetch_values
          return @n
        end
        
        typesig { [] }
        def get_public_exponent
          fetch_values
          return @e
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  modulus: " + RJava.cast_to_string(@n) + "\n  public exponent: " + RJava.cast_to_string(@e)
        end
        
        private
        alias_method :initialize__p11rsapublic_key, :initialize
      end }
      
      const_set_lazy(:P11DSAPublicKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include DSAPublicKey
        }
        
        attr_accessor :y
        alias_method :attr_y, :y
        undef_method :y
        alias_method :attr_y=, :y=
        undef_method :y=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @y = nil
          @params = nil
          @encoded = nil
          super(PUBLIC, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@y).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), self.class::CK_ATTRIBUTE.new(CKA_PRIME), self.class::CK_ATTRIBUTE.new(CKA_SUBPRIME), self.class::CK_ATTRIBUTE.new(CKA_BASE), ])
            fetch_attributes(attributes)
            @y = attributes[0].get_big_integer
            @params = self.class::DSAParameterSpec.new(attributes[1].get_big_integer, attributes[2].get_big_integer, attributes[3].get_big_integer)
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "X.509"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                key = Sun::Security::Provider::self.class::DSAPublicKey.new(@y, @params.get_p, @params.get_q, @params.get_g)
                @encoded = key.get_encoded
              rescue self.class::InvalidKeyException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_y
          fetch_values
          return @y
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  y: " + RJava.cast_to_string(@y) + "\n  p: " + RJava.cast_to_string(@params.get_p) + "\n  q: " + RJava.cast_to_string(@params.get_q) + "\n  g: " + RJava.cast_to_string(@params.get_g)
        end
        
        private
        alias_method :initialize__p11dsapublic_key, :initialize
      end }
      
      const_set_lazy(:P11DSAPrivateKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include DSAPrivateKey
        }
        
        attr_accessor :x
        alias_method :attr_x, :x
        undef_method :x
        alias_method :attr_x=, :x=
        undef_method :x=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @x = nil
          @params = nil
          @encoded = nil
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@x).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), self.class::CK_ATTRIBUTE.new(CKA_PRIME), self.class::CK_ATTRIBUTE.new(CKA_SUBPRIME), self.class::CK_ATTRIBUTE.new(CKA_BASE), ])
            fetch_attributes(attributes)
            @x = attributes[0].get_big_integer
            @params = self.class::DSAParameterSpec.new(attributes[1].get_big_integer, attributes[2].get_big_integer, attributes[3].get_big_integer)
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "PKCS#8"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                key = Sun::Security::Provider::self.class::DSAPrivateKey.new(@x, @params.get_p, @params.get_q, @params.get_g)
                @encoded = key.get_encoded
              rescue self.class::InvalidKeyException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_x
          fetch_values
          return @x
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  x: " + RJava.cast_to_string(@x) + "\n  p: " + RJava.cast_to_string(@params.get_p) + "\n  q: " + RJava.cast_to_string(@params.get_q) + "\n  g: " + RJava.cast_to_string(@params.get_g)
        end
        
        private
        alias_method :initialize__p11dsaprivate_key, :initialize
      end }
      
      const_set_lazy(:P11DHPrivateKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include DHPrivateKey
        }
        
        attr_accessor :x
        alias_method :attr_x, :x
        undef_method :x
        alias_method :attr_x=, :x=
        undef_method :x=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @x = nil
          @params = nil
          @encoded = nil
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@x).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), self.class::CK_ATTRIBUTE.new(CKA_PRIME), self.class::CK_ATTRIBUTE.new(CKA_BASE), ])
            fetch_attributes(attributes)
            @x = attributes[0].get_big_integer
            @params = self.class::DHParameterSpec.new(attributes[1].get_big_integer, attributes[2].get_big_integer)
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "PKCS#8"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                spec = self.class::DHPrivateKeySpec.new(@x, @params.get_p, @params.get_g)
                kf = KeyFactory.get_instance("DH", P11Util.get_sun_jce_provider)
                key = kf.generate_private(spec)
                @encoded = key.get_encoded
              rescue self.class::GeneralSecurityException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_x
          fetch_values
          return @x
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  x: " + RJava.cast_to_string(@x) + "\n  p: " + RJava.cast_to_string(@params.get_p) + "\n  g: " + RJava.cast_to_string(@params.get_g)
        end
        
        private
        alias_method :initialize__p11dhprivate_key, :initialize
      end }
      
      const_set_lazy(:P11DHPublicKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include DHPublicKey
        }
        
        attr_accessor :y
        alias_method :attr_y, :y
        undef_method :y
        alias_method :attr_y=, :y=
        undef_method :y=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @y = nil
          @params = nil
          @encoded = nil
          super(PUBLIC, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@y).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), self.class::CK_ATTRIBUTE.new(CKA_PRIME), self.class::CK_ATTRIBUTE.new(CKA_BASE), ])
            fetch_attributes(attributes)
            @y = attributes[0].get_big_integer
            @params = self.class::DHParameterSpec.new(attributes[1].get_big_integer, attributes[2].get_big_integer)
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "X.509"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                spec = self.class::DHPublicKeySpec.new(@y, @params.get_p, @params.get_g)
                kf = KeyFactory.get_instance("DH", P11Util.get_sun_jce_provider)
                key = kf.generate_public(spec)
                @encoded = key.get_encoded
              rescue self.class::GeneralSecurityException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_y
          fetch_values
          return @y
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  y: " + RJava.cast_to_string(@y) + "\n  p: " + RJava.cast_to_string(@params.get_p) + "\n  g: " + RJava.cast_to_string(@params.get_g)
        end
        
        private
        alias_method :initialize__p11dhpublic_key, :initialize
      end }
      
      const_set_lazy(:P11ECPrivateKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include ECPrivateKey
        }
        
        attr_accessor :s
        alias_method :attr_s, :s
        undef_method :s
        alias_method :attr_s=, :s=
        undef_method :s=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @s = nil
          @params = nil
          @encoded = nil
          super(PRIVATE, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@s).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_VALUE), self.class::CK_ATTRIBUTE.new(CKA_EC_PARAMS, @params), ])
            fetch_attributes(attributes)
            @s = attributes[0].get_big_integer
            begin
              @params = P11ECKeyFactory.decode_parameters(attributes[1].get_byte_array)
            rescue self.class::JavaException => e
              raise self.class::RuntimeException.new("Could not parse key values", e)
            end
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "PKCS#8"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                key = Sun::Security::Ec::self.class::ECPrivateKeyImpl.new(@s, @params)
                @encoded = key.get_encoded
              rescue self.class::InvalidKeyException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_s
          fetch_values
          return @s
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  private value:  " + RJava.cast_to_string(@s) + "\n  parameters: " + RJava.cast_to_string(@params)
        end
        
        private
        alias_method :initialize__p11ecprivate_key, :initialize
      end }
      
      const_set_lazy(:P11ECPublicKey) { Class.new(P11Key) do
        include_class_members P11Key
        overload_protected {
          include ECPublicKey
        }
        
        attr_accessor :w
        alias_method :attr_w, :w
        undef_method :w
        alias_method :attr_w=, :w=
        undef_method :w=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        attr_accessor :encoded
        alias_method :attr_encoded, :encoded
        undef_method :encoded
        alias_method :attr_encoded=, :encoded=
        undef_method :encoded=
        
        typesig { [self::Session, ::Java::Long, String, ::Java::Int, Array.typed(self::CK_ATTRIBUTE)] }
        def initialize(session, key_id, algorithm, key_length, attributes)
          @w = nil
          @params = nil
          @encoded = nil
          super(PUBLIC, session, key_id, algorithm, key_length, attributes)
        end
        
        typesig { [] }
        def fetch_values
          synchronized(self) do
            self.attr_token.ensure_valid
            if (!(@w).nil?)
              return
            end
            attributes = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_EC_POINT), self.class::CK_ATTRIBUTE.new(CKA_EC_PARAMS), ])
            fetch_attributes(attributes)
            begin
              @params = P11ECKeyFactory.decode_parameters(attributes[1].get_byte_array)
              @w = P11ECKeyFactory.decode_point(attributes[0].get_byte_array, @params.get_curve)
            rescue self.class::JavaException => e
              raise self.class::RuntimeException.new("Could not parse key values", e)
            end
          end
        end
        
        typesig { [] }
        def get_format
          self.attr_token.ensure_valid
          return "X.509"
        end
        
        typesig { [] }
        def get_encoded_internal
          synchronized(self) do
            self.attr_token.ensure_valid
            if ((@encoded).nil?)
              fetch_values
              begin
                key = Sun::Security::Ec::self.class::ECPublicKeyImpl.new(@w, @params)
                @encoded = key.get_encoded
              rescue self.class::InvalidKeyException => e
                raise self.class::ProviderException.new(e)
              end
            end
            return @encoded
          end
        end
        
        typesig { [] }
        def get_w
          fetch_values
          return @w
        end
        
        typesig { [] }
        def get_params
          fetch_values
          return @params
        end
        
        typesig { [] }
        def to_s
          fetch_values
          return RJava.cast_to_string(super) + "\n  public x coord: " + RJava.cast_to_string(@w.get_affine_x) + "\n  public y coord: " + RJava.cast_to_string(@w.get_affine_y) + "\n  parameters: " + RJava.cast_to_string(@params)
        end
        
        private
        alias_method :initialize__p11ecpublic_key, :initialize
      end }
    }
    
    private
    alias_method :initialize__p11key, :initialize
  end
  
end

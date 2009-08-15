require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CipherSuiteImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Util
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include ::Sun::Security::Ssl::CipherSuite
    }
  end
  
  # An SSL/TLS CipherSuite. Constants for the standard key exchange, cipher,
  # and mac algorithms are also defined in this class.
  # 
  # The CipherSuite class and the inner classes defined in this file roughly
  # follow the type safe enum pattern described in Effective Java. This means:
  # 
  # . instances are immutable, classes are final
  # 
  # . there is a unique instance of every value, i.e. there are never two
  # instances representing the same CipherSuite, etc. This means equality
  # tests can be performed using == instead of equals() (although that works
  # as well). [A minor exception are *unsupported* CipherSuites read from a
  # handshake message, but this is usually irrelevant]
  # 
  # . instances are obtained using the static valueOf() factory methods.
  # 
  # . properties are defined as final variables and made available as
  # package private variables without method accessors
  # 
  # . if the member variable allowed is false, the given algorithm is either
  # unavailable or disabled at compile time
  class CipherSuite 
    include_class_members CipherSuiteImports
    include JavaComparable
    
    class_module.module_eval {
      # minimum priority for supported CipherSuites
      const_set_lazy(:SUPPORTED_SUITES_PRIORITY) { 1 }
      const_attr_reader  :SUPPORTED_SUITES_PRIORITY
      
      # minimum priority for default enabled CipherSuites
      const_set_lazy(:DEFAULT_SUITES_PRIORITY) { 300 }
      const_attr_reader  :DEFAULT_SUITES_PRIORITY
      
      # Flag indicating if CipherSuite availability can change dynamically.
      # This is the case when we rely on a JCE cipher implementation that
      # may not be available in the installed JCE providers.
      # It is true because we do not have a Java ECC implementation.
      const_set_lazy(:DYNAMIC_AVAILABILITY) { true }
      const_attr_reader  :DYNAMIC_AVAILABILITY
      
      const_set_lazy(:ALLOW_ECC) { Debug.get_boolean_property("com.sun.net.ssl.enableECC", true) }
      const_attr_reader  :ALLOW_ECC
    }
    
    # Protocol defined CipherSuite name, e.g. SSL_RSA_WITH_RC4_128_MD5
    # we use TLS_* only for new CipherSuites, still SSL_* for old ones
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # id in 16 bit MSB format, i.e. 0x0004 for SSL_RSA_WITH_RC4_128_MD5
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # priority for the internal default preference order. the higher the
    # better. Each supported CipherSuite *must* have a unique priority.
    # Ciphersuites with priority >= DEFAULT_SUITES_PRIORITY are enabled
    # by default
    attr_accessor :priority
    alias_method :attr_priority, :priority
    undef_method :priority
    alias_method :attr_priority=, :priority=
    undef_method :priority=
    
    # key exchange, bulk cipher, and mac algorithms. See those classes below.
    attr_accessor :key_exchange
    alias_method :attr_key_exchange, :key_exchange
    undef_method :key_exchange
    alias_method :attr_key_exchange=, :key_exchange=
    undef_method :key_exchange=
    
    attr_accessor :cipher
    alias_method :attr_cipher, :cipher
    undef_method :cipher
    alias_method :attr_cipher=, :cipher=
    undef_method :cipher=
    
    attr_accessor :mac_alg
    alias_method :attr_mac_alg, :mac_alg
    undef_method :mac_alg
    alias_method :attr_mac_alg=, :mac_alg=
    undef_method :mac_alg=
    
    # whether a CipherSuite qualifies as exportable under 512/40 bit rules.
    attr_accessor :exportable
    alias_method :attr_exportable, :exportable
    undef_method :exportable
    alias_method :attr_exportable=, :exportable=
    undef_method :exportable=
    
    # true iff implemented and enabled at compile time
    attr_accessor :allowed
    alias_method :attr_allowed, :allowed
    undef_method :allowed
    alias_method :attr_allowed=, :allowed=
    undef_method :allowed=
    
    typesig { [String, ::Java::Int, ::Java::Int, KeyExchange, BulkCipher, ::Java::Boolean] }
    def initialize(name, id, priority, key_exchange, cipher, allowed)
      @name = nil
      @id = 0
      @priority = 0
      @key_exchange = nil
      @cipher = nil
      @mac_alg = nil
      @exportable = false
      @allowed = false
      @name = name
      @id = id
      @priority = priority
      @key_exchange = key_exchange
      @cipher = cipher
      @exportable = cipher.attr_exportable
      if (name.ends_with("_MD5"))
        @mac_alg = M_MD5
      else
        if (name.ends_with("_SHA"))
          @mac_alg = M_SHA
        else
          if (name.ends_with("_NULL"))
            @mac_alg = M_NULL
          else
            raise IllegalArgumentException.new("Unknown MAC algorithm for ciphersuite " + name)
          end
        end
      end
      allowed &= key_exchange.attr_allowed
      allowed &= cipher.attr_allowed
      @allowed = allowed
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(name, id)
      @name = nil
      @id = 0
      @priority = 0
      @key_exchange = nil
      @cipher = nil
      @mac_alg = nil
      @exportable = false
      @allowed = false
      @name = name
      @id = id
      @allowed = false
      @priority = 0
      @key_exchange = nil
      @cipher = nil
      @mac_alg = nil
      @exportable = false
    end
    
    typesig { [] }
    # Return whether this CipherSuite is available for use. A
    # CipherSuite may be unavailable even if it is supported
    # (i.e. allowed == true) if the required JCE cipher is not installed.
    # In some configuration, this situation may change over time, call
    # CipherSuiteList.clearAvailableCache() before this method to obtain
    # the most current status.
    def is_available
      return @allowed && @key_exchange.is_available && @cipher.is_available
    end
    
    typesig { [Object] }
    # Compares CipherSuites based on their priority. Has the effect of
    # sorting CipherSuites when put in a sorted collection, which is
    # used by CipherSuiteList. Follows standard Comparable contract.
    # 
    # Note that for unsupported CipherSuites parsed from a handshake
    # message we violate the equals() contract.
    def compare_to(o)
      return (o).attr_priority - @priority
    end
    
    typesig { [] }
    # Returns this.name.
    def to_s
      return @name
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Return a CipherSuite for the given name. The returned CipherSuite
      # is supported by this implementation but may not actually be
      # currently useable. See isAvailable().
      # 
      # @exception IllegalArgumentException if the CipherSuite is unknown or
      # unsupported.
      def value_of(s)
        if ((s).nil?)
          raise IllegalArgumentException.new("Name must not be null")
        end
        c = NameMap.get(s)
        if (((c).nil?) || ((c.attr_allowed).equal?(false)))
          raise IllegalArgumentException.new("Unsupported ciphersuite " + s)
        end
        return c
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Return a CipherSuite with the given ID. A temporary object is
      # constructed if the ID is unknown. Use isAvailable() to verify that
      # the CipherSuite can actually be used.
      def value_of(id1, id2)
        id1 &= 0xff
        id2 &= 0xff
        id = (id1 << 8) | id2
        c = IdMap.get(id)
        if ((c).nil?)
          h1 = JavaInteger.to_s(id1, 16)
          h2 = JavaInteger.to_s(id2, 16)
          c = CipherSuite.new("Unknown 0x" + h1 + ":0x" + h2, id)
        end
        return c
      end
      
      typesig { [] }
      # for use by CipherSuiteList only
      def allowed_cipher_suites
        return NameMap.values
      end
      
      typesig { [String, ::Java::Int, ::Java::Int, KeyExchange, BulkCipher, ::Java::Boolean] }
      def add(name, id, priority, key_exchange, cipher, allowed)
        c = CipherSuite.new(name, id, priority, key_exchange, cipher, allowed)
        if (!(IdMap.put(id, c)).nil?)
          raise RuntimeException.new("Duplicate ciphersuite definition: " + RJava.cast_to_string(id) + ", " + name)
        end
        if (c.attr_allowed)
          if (!(NameMap.put(name, c)).nil?)
            raise RuntimeException.new("Duplicate ciphersuite definition: " + RJava.cast_to_string(id) + ", " + name)
          end
        end
      end
      
      typesig { [String, ::Java::Int] }
      def add(name, id)
        c = CipherSuite.new(name, id)
        if (!(IdMap.put(id, c)).nil?)
          raise RuntimeException.new("Duplicate ciphersuite definition: " + RJava.cast_to_string(id) + ", " + name)
        end
      end
      
      const_set_lazy(:K_NULL) { KeyExchange::K_NULL }
      const_attr_reader  :K_NULL
      
      const_set_lazy(:K_RSA) { KeyExchange::K_RSA }
      const_attr_reader  :K_RSA
      
      const_set_lazy(:K_RSA_EXPORT) { KeyExchange::K_RSA_EXPORT }
      const_attr_reader  :K_RSA_EXPORT
      
      const_set_lazy(:K_DH_RSA) { KeyExchange::K_DH_RSA }
      const_attr_reader  :K_DH_RSA
      
      const_set_lazy(:K_DH_DSS) { KeyExchange::K_DH_DSS }
      const_attr_reader  :K_DH_DSS
      
      const_set_lazy(:K_DHE_DSS) { KeyExchange::K_DHE_DSS }
      const_attr_reader  :K_DHE_DSS
      
      const_set_lazy(:K_DHE_RSA) { KeyExchange::K_DHE_RSA }
      const_attr_reader  :K_DHE_RSA
      
      const_set_lazy(:K_DH_ANON) { KeyExchange::K_DH_ANON }
      const_attr_reader  :K_DH_ANON
      
      const_set_lazy(:K_ECDH_ECDSA) { KeyExchange::K_ECDH_ECDSA }
      const_attr_reader  :K_ECDH_ECDSA
      
      const_set_lazy(:K_ECDH_RSA) { KeyExchange::K_ECDH_RSA }
      const_attr_reader  :K_ECDH_RSA
      
      const_set_lazy(:K_ECDHE_ECDSA) { KeyExchange::K_ECDHE_ECDSA }
      const_attr_reader  :K_ECDHE_ECDSA
      
      const_set_lazy(:K_ECDHE_RSA) { KeyExchange::K_ECDHE_RSA }
      const_attr_reader  :K_ECDHE_RSA
      
      const_set_lazy(:K_ECDH_ANON) { KeyExchange::K_ECDH_ANON }
      const_attr_reader  :K_ECDH_ANON
      
      const_set_lazy(:K_KRB5) { KeyExchange::K_KRB5 }
      const_attr_reader  :K_KRB5
      
      const_set_lazy(:K_KRB5_EXPORT) { KeyExchange::K_KRB5_EXPORT }
      const_attr_reader  :K_KRB5_EXPORT
      
      # An SSL/TLS key exchange algorithm.
      class KeyExchange 
        include_class_members CipherSuite
        
        class_module.module_eval {
          # key exchange algorithms
          const_set_lazy(:K_NULL) { KeyExchange.new("NULL", false).set_value_name("K_NULL") }
          const_attr_reader  :K_NULL
          
          const_set_lazy(:K_RSA) { KeyExchange.new("RSA", true).set_value_name("K_RSA") }
          const_attr_reader  :K_RSA
          
          const_set_lazy(:K_RSA_EXPORT) { KeyExchange.new("RSA_EXPORT", true).set_value_name("K_RSA_EXPORT") }
          const_attr_reader  :K_RSA_EXPORT
          
          const_set_lazy(:K_DH_RSA) { KeyExchange.new("DH_RSA", false).set_value_name("K_DH_RSA") }
          const_attr_reader  :K_DH_RSA
          
          const_set_lazy(:K_DH_DSS) { KeyExchange.new("DH_DSS", false).set_value_name("K_DH_DSS") }
          const_attr_reader  :K_DH_DSS
          
          const_set_lazy(:K_DHE_DSS) { KeyExchange.new("DHE_DSS", true).set_value_name("K_DHE_DSS") }
          const_attr_reader  :K_DHE_DSS
          
          const_set_lazy(:K_DHE_RSA) { KeyExchange.new("DHE_RSA", true).set_value_name("K_DHE_RSA") }
          const_attr_reader  :K_DHE_RSA
          
          const_set_lazy(:K_DH_ANON) { KeyExchange.new("DH_anon", true).set_value_name("K_DH_ANON") }
          const_attr_reader  :K_DH_ANON
          
          const_set_lazy(:K_ECDH_ECDSA) { KeyExchange.new("ECDH_ECDSA", ALLOW_ECC).set_value_name("K_ECDH_ECDSA") }
          const_attr_reader  :K_ECDH_ECDSA
          
          const_set_lazy(:K_ECDH_RSA) { KeyExchange.new("ECDH_RSA", ALLOW_ECC).set_value_name("K_ECDH_RSA") }
          const_attr_reader  :K_ECDH_RSA
          
          const_set_lazy(:K_ECDHE_ECDSA) { KeyExchange.new("ECDHE_ECDSA", ALLOW_ECC).set_value_name("K_ECDHE_ECDSA") }
          const_attr_reader  :K_ECDHE_ECDSA
          
          const_set_lazy(:K_ECDHE_RSA) { KeyExchange.new("ECDHE_RSA", ALLOW_ECC).set_value_name("K_ECDHE_RSA") }
          const_attr_reader  :K_ECDHE_RSA
          
          const_set_lazy(:K_ECDH_ANON) { KeyExchange.new("ECDH_anon", ALLOW_ECC).set_value_name("K_ECDH_ANON") }
          const_attr_reader  :K_ECDH_ANON
          
          # Kerberos cipher suites
          const_set_lazy(:K_KRB5) { KeyExchange.new("KRB5", true).set_value_name("K_KRB5") }
          const_attr_reader  :K_KRB5
          
          const_set_lazy(:K_KRB5_EXPORT) { KeyExchange.new("KRB5_EXPORT", true).set_value_name("K_KRB5_EXPORT") }
          const_attr_reader  :K_KRB5_EXPORT
        }
        
        # name of the key exchange algorithm, e.g. DHE_DSS
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :allowed
        alias_method :attr_allowed, :allowed
        undef_method :allowed
        alias_method :attr_allowed=, :allowed=
        undef_method :allowed=
        
        attr_accessor :always_available
        alias_method :attr_always_available, :always_available
        undef_method :always_available
        alias_method :attr_always_available=, :always_available=
        undef_method :always_available=
        
        typesig { [String, ::Java::Boolean] }
        def initialize(name, allowed)
          @name = nil
          @allowed = false
          @always_available = false
          @name = name
          @allowed = allowed
          @always_available = allowed && ((name.starts_with("EC")).equal?(false))
        end
        
        typesig { [] }
        def is_available
          if (@always_available)
            return true
          end
          return @allowed && JsseJce.is_ec_available
        end
        
        typesig { [] }
        def to_s
          return @name
        end
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [K_NULL, K_RSA, K_RSA_EXPORT, K_DH_RSA, K_DH_DSS, K_DHE_DSS, K_DHE_RSA, K_DH_ANON, K_ECDH_ECDSA, K_ECDH_RSA, K_ECDHE_ECDSA, K_ECDHE_RSA, K_ECDH_ANON, K_KRB5, K_KRB5_EXPORT]
          end
        }
        
        private
        alias_method :initialize__key_exchange, :initialize
      end
      
      # An SSL/TLS bulk cipher algorithm. One instance per combination of
      # cipher and key length.
      # 
      # Also contains a factory method to obtain in initialized CipherBox
      # for this algorithm.
      const_set_lazy(:BulkCipher) { Class.new do
        include_class_members CipherSuite
        
        class_module.module_eval {
          # Map BulkCipher -> Boolean(available)
          const_set_lazy(:AvailableCache) { HashMap.new(8) }
          const_attr_reader  :AvailableCache
        }
        
        # descriptive name including key size, e.g. AES/128
        attr_accessor :description
        alias_method :attr_description, :description
        undef_method :description
        alias_method :attr_description=, :description=
        undef_method :description=
        
        # JCE cipher transformation string, e.g. AES/CBC/NoPadding
        attr_accessor :transformation
        alias_method :attr_transformation, :transformation
        undef_method :transformation
        alias_method :attr_transformation=, :transformation=
        undef_method :transformation=
        
        # algorithm name, e.g. AES
        attr_accessor :algorithm
        alias_method :attr_algorithm, :algorithm
        undef_method :algorithm
        alias_method :attr_algorithm=, :algorithm=
        undef_method :algorithm=
        
        # supported and compile time enabled. Also see isAvailable()
        attr_accessor :allowed
        alias_method :attr_allowed, :allowed
        undef_method :allowed
        alias_method :attr_allowed=, :allowed=
        undef_method :allowed=
        
        # number of bytes of entropy in the key
        attr_accessor :key_size
        alias_method :attr_key_size, :key_size
        undef_method :key_size
        alias_method :attr_key_size=, :key_size=
        undef_method :key_size=
        
        # length of the actual cipher key in bytes.
        # for non-exportable ciphers, this is the same as keySize
        attr_accessor :expanded_key_size
        alias_method :attr_expanded_key_size, :expanded_key_size
        undef_method :expanded_key_size
        alias_method :attr_expanded_key_size=, :expanded_key_size=
        undef_method :expanded_key_size=
        
        # size of the IV (also block size)
        attr_accessor :iv_size
        alias_method :attr_iv_size, :iv_size
        undef_method :iv_size
        alias_method :attr_iv_size=, :iv_size=
        undef_method :iv_size=
        
        # exportable under 512/40 bit rules
        attr_accessor :exportable
        alias_method :attr_exportable, :exportable
        undef_method :exportable
        alias_method :attr_exportable=, :exportable=
        undef_method :exportable=
        
        typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def initialize(transformation, key_size, expanded_key_size, iv_size, allowed)
          @description = nil
          @transformation = nil
          @algorithm = nil
          @allowed = false
          @key_size = 0
          @expanded_key_size = 0
          @iv_size = 0
          @exportable = false
          @transformation = transformation
          @algorithm = transformation.split(Regexp.new("/"))[0]
          @description = RJava.cast_to_string(@algorithm) + "/" + RJava.cast_to_string((key_size << 3))
          @key_size = key_size
          @iv_size = iv_size
          @allowed = allowed
          @expanded_key_size = expanded_key_size
          @exportable = true
        end
        
        typesig { [String, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def initialize(transformation, key_size, iv_size, allowed)
          @description = nil
          @transformation = nil
          @algorithm = nil
          @allowed = false
          @key_size = 0
          @expanded_key_size = 0
          @iv_size = 0
          @exportable = false
          @transformation = transformation
          @algorithm = transformation.split(Regexp.new("/"))[0]
          @description = RJava.cast_to_string(@algorithm) + "/" + RJava.cast_to_string((key_size << 3))
          @key_size = key_size
          @iv_size = iv_size
          @allowed = allowed
          @expanded_key_size = key_size
          @exportable = false
        end
        
        typesig { [ProtocolVersion, SecretKey, IvParameterSpec, ::Java::Boolean] }
        # Return an initialized CipherBox for this BulkCipher.
        # IV must be null for stream ciphers.
        # 
        # @exception NoSuchAlgorithmException if anything goes wrong
        def new_cipher(version, key, iv, encrypt)
          return CipherBox.new_cipher_box(version, self, key, iv, encrypt)
        end
        
        typesig { [] }
        # Test if this bulk cipher is available. For use by CipherSuite.
        # 
        # Currently all supported ciphers except AES are always available
        # via the JSSE internal implementations. We also assume AES/128
        # is always available since it is shipped with the SunJCE provider.
        # However, AES/256 is unavailable when the default JCE policy
        # jurisdiction files are installed because of key length restrictions.
        def is_available
          if ((@allowed).equal?(false))
            return false
          end
          if ((self).equal?(B_AES_256))
            return is_available(self)
          end
          # always available
          return true
        end
        
        class_module.module_eval {
          typesig { [] }
          # for use by CipherSuiteList.clearAvailableCache();
          def clear_available_cache
            synchronized(self) do
              if (DYNAMIC_AVAILABILITY)
                self.class::AvailableCache.clear
              end
            end
          end
          
          typesig { [BulkCipher] }
          def is_available(cipher)
            synchronized(self) do
              b = self.class::AvailableCache.get(cipher)
              if ((b).nil?)
                begin
                  key = SecretKeySpec.new(Array.typed(::Java::Byte).new(cipher.attr_expanded_key_size) { 0 }, cipher.attr_algorithm)
                  iv = IvParameterSpec.new(Array.typed(::Java::Byte).new(cipher.attr_iv_size) { 0 })
                  cipher.new_cipher(ProtocolVersion::DEFAULT, key, iv, true)
                  b = Boolean::TRUE
                rescue NoSuchAlgorithmException => e
                  b = Boolean::FALSE
                end
                self.class::AvailableCache.put(cipher, b)
              end
              return b.boolean_value
            end
          end
        }
        
        typesig { [] }
        def to_s
          return @description
        end
        
        private
        alias_method :initialize__bulk_cipher, :initialize
      end }
      
      # An SSL/TLS key MAC algorithm.
      # 
      # Also contains a factory method to obtain in initialized MAC
      # for this algorithm.
      const_set_lazy(:MacAlg) { Class.new do
        include_class_members CipherSuite
        
        # descriptive name, e.g. MD5
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        # size of the MAC value (and MAC key) in bytes
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [String, ::Java::Int] }
        def initialize(name, size)
          @name = nil
          @size = 0
          @name = name
          @size = size
        end
        
        typesig { [ProtocolVersion, SecretKey] }
        # Return an initialized MAC for this MacAlg. ProtocolVersion
        # must either be SSL30 (SSLv3 custom MAC) or TLS10 (std. HMAC).
        # 
        # @exception NoSuchAlgorithmException if anything goes wrong
        def new_mac(protocol_version, secret)
          return MAC.new(self, protocol_version, secret)
        end
        
        typesig { [] }
        def to_s
          return @name
        end
        
        private
        alias_method :initialize__mac_alg, :initialize
      end }
      
      # export strength ciphers
      const_set_lazy(:B_NULL) { BulkCipher.new("NULL", 0, 0, 0, true) }
      const_attr_reader  :B_NULL
      
      const_set_lazy(:B_RC4_40) { BulkCipher.new(CIPHER_RC4, 5, 16, 0, true) }
      const_attr_reader  :B_RC4_40
      
      const_set_lazy(:B_RC2_40) { BulkCipher.new("RC2", 5, 16, 8, false) }
      const_attr_reader  :B_RC2_40
      
      const_set_lazy(:B_DES_40) { BulkCipher.new(CIPHER_DES, 5, 8, 8, true) }
      const_attr_reader  :B_DES_40
      
      # domestic strength ciphers
      const_set_lazy(:B_RC4_128) { BulkCipher.new(CIPHER_RC4, 16, 0, true) }
      const_attr_reader  :B_RC4_128
      
      const_set_lazy(:B_DES) { BulkCipher.new(CIPHER_DES, 8, 8, true) }
      const_attr_reader  :B_DES
      
      const_set_lazy(:B_3DES) { BulkCipher.new(CIPHER_3DES, 24, 8, true) }
      const_attr_reader  :B_3DES
      
      const_set_lazy(:B_IDEA) { BulkCipher.new("IDEA", 16, 8, false) }
      const_attr_reader  :B_IDEA
      
      const_set_lazy(:B_AES_128) { BulkCipher.new(CIPHER_AES, 16, 16, true) }
      const_attr_reader  :B_AES_128
      
      const_set_lazy(:B_AES_256) { BulkCipher.new(CIPHER_AES, 32, 16, true) }
      const_attr_reader  :B_AES_256
      
      # MACs
      const_set_lazy(:M_NULL) { MacAlg.new("NULL", 0) }
      const_attr_reader  :M_NULL
      
      const_set_lazy(:M_MD5) { MacAlg.new("MD5", 16) }
      const_attr_reader  :M_MD5
      
      const_set_lazy(:M_SHA) { MacAlg.new("SHA", 20) }
      const_attr_reader  :M_SHA
      
      when_class_loaded do
        const_set :IdMap, HashMap.new
        const_set :NameMap, HashMap.new
        f = false
        t = true
        # N: ciphersuites only allowed if we are not in FIPS mode
        n = ((SunJSSE.is_fips).equal?(false))
        add("SSL_NULL_WITH_NULL_NULL", 0x0, 1, K_NULL, B_NULL, f)
        # Definition of the CipherSuites that are enabled by default.
        # They are listed in preference order, most preferred first.
        p = DEFAULT_SUITES_PRIORITY * 2
        add("SSL_RSA_WITH_RC4_128_MD5", 0x4, (p -= 1), K_RSA, B_RC4_128, n)
        add("SSL_RSA_WITH_RC4_128_SHA", 0x5, (p -= 1), K_RSA, B_RC4_128, n)
        add("TLS_RSA_WITH_AES_128_CBC_SHA", 0x2f, (p -= 1), K_RSA, B_AES_128, t)
        add("TLS_RSA_WITH_AES_256_CBC_SHA", 0x35, (p -= 1), K_RSA, B_AES_256, t)
        add("TLS_ECDH_ECDSA_WITH_RC4_128_SHA", 0xc002, (p -= 1), K_ECDH_ECDSA, B_RC4_128, n)
        add("TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA", 0xc004, (p -= 1), K_ECDH_ECDSA, B_AES_128, t)
        add("TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA", 0xc005, (p -= 1), K_ECDH_ECDSA, B_AES_256, t)
        add("TLS_ECDH_RSA_WITH_RC4_128_SHA", 0xc00c, (p -= 1), K_ECDH_RSA, B_RC4_128, n)
        add("TLS_ECDH_RSA_WITH_AES_128_CBC_SHA", 0xc00e, (p -= 1), K_ECDH_RSA, B_AES_128, t)
        add("TLS_ECDH_RSA_WITH_AES_256_CBC_SHA", 0xc00f, (p -= 1), K_ECDH_RSA, B_AES_256, t)
        add("TLS_ECDHE_ECDSA_WITH_RC4_128_SHA", 0xc007, (p -= 1), K_ECDHE_ECDSA, B_RC4_128, n)
        add("TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA", 0xc009, (p -= 1), K_ECDHE_ECDSA, B_AES_128, t)
        add("TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA", 0xc00a, (p -= 1), K_ECDHE_ECDSA, B_AES_256, t)
        add("TLS_ECDHE_RSA_WITH_RC4_128_SHA", 0xc011, (p -= 1), K_ECDHE_RSA, B_RC4_128, n)
        add("TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA", 0xc013, (p -= 1), K_ECDHE_RSA, B_AES_128, t)
        add("TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA", 0xc014, (p -= 1), K_ECDHE_RSA, B_AES_256, t)
        add("TLS_DHE_RSA_WITH_AES_128_CBC_SHA", 0x33, (p -= 1), K_DHE_RSA, B_AES_128, t)
        add("TLS_DHE_RSA_WITH_AES_256_CBC_SHA", 0x39, (p -= 1), K_DHE_RSA, B_AES_256, t)
        add("TLS_DHE_DSS_WITH_AES_128_CBC_SHA", 0x32, (p -= 1), K_DHE_DSS, B_AES_128, t)
        add("TLS_DHE_DSS_WITH_AES_256_CBC_SHA", 0x38, (p -= 1), K_DHE_DSS, B_AES_256, t)
        add("SSL_RSA_WITH_3DES_EDE_CBC_SHA", 0xa, (p -= 1), K_RSA, B_3DES, t)
        add("TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA", 0xc003, (p -= 1), K_ECDH_ECDSA, B_3DES, t)
        add("TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA", 0xc00d, (p -= 1), K_ECDH_RSA, B_3DES, t)
        add("TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA", 0xc008, (p -= 1), K_ECDHE_ECDSA, B_3DES, t)
        add("TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA", 0xc012, (p -= 1), K_ECDHE_RSA, B_3DES, t)
        add("SSL_DHE_RSA_WITH_3DES_EDE_CBC_SHA", 0x16, (p -= 1), K_DHE_RSA, B_3DES, t)
        add("SSL_DHE_DSS_WITH_3DES_EDE_CBC_SHA", 0x13, (p -= 1), K_DHE_DSS, B_3DES, n)
        add("SSL_RSA_WITH_DES_CBC_SHA", 0x9, (p -= 1), K_RSA, B_DES, n)
        add("SSL_DHE_RSA_WITH_DES_CBC_SHA", 0x15, (p -= 1), K_DHE_RSA, B_DES, n)
        add("SSL_DHE_DSS_WITH_DES_CBC_SHA", 0x12, (p -= 1), K_DHE_DSS, B_DES, n)
        add("SSL_RSA_EXPORT_WITH_RC4_40_MD5", 0x3, (p -= 1), K_RSA_EXPORT, B_RC4_40, n)
        add("SSL_RSA_EXPORT_WITH_DES40_CBC_SHA", 0x8, (p -= 1), K_RSA_EXPORT, B_DES_40, n)
        add("SSL_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA", 0x14, (p -= 1), K_DHE_RSA, B_DES_40, n)
        add("SSL_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA", 0x11, (p -= 1), K_DHE_DSS, B_DES_40, n)
        # Definition of the CipherSuites that are supported but not enabled
        # by default.
        # They are listed in preference order, preferred first.
        p = DEFAULT_SUITES_PRIORITY
        # Anonymous key exchange and the NULL ciphers
        add("SSL_RSA_WITH_NULL_MD5", 0x1, (p -= 1), K_RSA, B_NULL, n)
        add("SSL_RSA_WITH_NULL_SHA", 0x2, (p -= 1), K_RSA, B_NULL, n)
        add("TLS_ECDH_ECDSA_WITH_NULL_SHA", 0xc001, (p -= 1), K_ECDH_ECDSA, B_NULL, n)
        add("TLS_ECDH_RSA_WITH_NULL_SHA", 0xc00b, (p -= 1), K_ECDH_RSA, B_NULL, n)
        add("TLS_ECDHE_ECDSA_WITH_NULL_SHA", 0xc006, (p -= 1), K_ECDHE_ECDSA, B_NULL, n)
        add("TLS_ECDHE_RSA_WITH_NULL_SHA", 0xc010, (p -= 1), K_ECDHE_RSA, B_NULL, n)
        add("SSL_DH_anon_WITH_RC4_128_MD5", 0x18, (p -= 1), K_DH_ANON, B_RC4_128, n)
        add("TLS_DH_anon_WITH_AES_128_CBC_SHA", 0x34, (p -= 1), K_DH_ANON, B_AES_128, n)
        add("TLS_DH_anon_WITH_AES_256_CBC_SHA", 0x3a, (p -= 1), K_DH_ANON, B_AES_256, n)
        add("SSL_DH_anon_WITH_3DES_EDE_CBC_SHA", 0x1b, (p -= 1), K_DH_ANON, B_3DES, n)
        add("SSL_DH_anon_WITH_DES_CBC_SHA", 0x1a, (p -= 1), K_DH_ANON, B_DES, n)
        add("TLS_ECDH_anon_WITH_RC4_128_SHA", 0xc016, (p -= 1), K_ECDH_ANON, B_RC4_128, n)
        add("TLS_ECDH_anon_WITH_AES_128_CBC_SHA", 0xc018, (p -= 1), K_ECDH_ANON, B_AES_128, t)
        add("TLS_ECDH_anon_WITH_AES_256_CBC_SHA", 0xc019, (p -= 1), K_ECDH_ANON, B_AES_256, t)
        add("TLS_ECDH_anon_WITH_3DES_EDE_CBC_SHA", 0xc017, (p -= 1), K_ECDH_ANON, B_3DES, t)
        add("SSL_DH_anon_EXPORT_WITH_RC4_40_MD5", 0x17, (p -= 1), K_DH_ANON, B_RC4_40, n)
        add("SSL_DH_anon_EXPORT_WITH_DES40_CBC_SHA", 0x19, (p -= 1), K_DH_ANON, B_DES_40, n)
        add("TLS_ECDH_anon_WITH_NULL_SHA", 0xc015, (p -= 1), K_ECDH_ANON, B_NULL, n)
        # Supported Kerberos ciphersuites from RFC2712
        add("TLS_KRB5_WITH_RC4_128_SHA", 0x20, (p -= 1), K_KRB5, B_RC4_128, n)
        add("TLS_KRB5_WITH_RC4_128_MD5", 0x24, (p -= 1), K_KRB5, B_RC4_128, n)
        add("TLS_KRB5_WITH_3DES_EDE_CBC_SHA", 0x1f, (p -= 1), K_KRB5, B_3DES, n)
        add("TLS_KRB5_WITH_3DES_EDE_CBC_MD5", 0x23, (p -= 1), K_KRB5, B_3DES, n)
        add("TLS_KRB5_WITH_DES_CBC_SHA", 0x1e, (p -= 1), K_KRB5, B_DES, n)
        add("TLS_KRB5_WITH_DES_CBC_MD5", 0x22, (p -= 1), K_KRB5, B_DES, n)
        add("TLS_KRB5_EXPORT_WITH_RC4_40_SHA", 0x28, (p -= 1), K_KRB5_EXPORT, B_RC4_40, n)
        add("TLS_KRB5_EXPORT_WITH_RC4_40_MD5", 0x2b, (p -= 1), K_KRB5_EXPORT, B_RC4_40, n)
        add("TLS_KRB5_EXPORT_WITH_DES_CBC_40_SHA", 0x26, (p -= 1), K_KRB5_EXPORT, B_DES_40, n)
        add("TLS_KRB5_EXPORT_WITH_DES_CBC_40_MD5", 0x29, (p -= 1), K_KRB5_EXPORT, B_DES_40, n)
        # Register the names of a few additional CipherSuites.
        # Makes them show up as names instead of numbers in
        # the debug output.
        # remaining unsupported ciphersuites defined in RFC2246.
        add("SSL_RSA_EXPORT_WITH_RC2_CBC_40_MD5", 0x6)
        add("SSL_RSA_WITH_IDEA_CBC_SHA", 0x7)
        add("SSL_DH_DSS_EXPORT_WITH_DES40_CBC_SHA", 0xb)
        add("SSL_DH_DSS_WITH_DES_CBC_SHA", 0xc)
        add("SSL_DH_DSS_WITH_3DES_EDE_CBC_SHA", 0xd)
        add("SSL_DH_RSA_EXPORT_WITH_DES40_CBC_SHA", 0xe)
        add("SSL_DH_RSA_WITH_DES_CBC_SHA", 0xf)
        add("SSL_DH_RSA_WITH_3DES_EDE_CBC_SHA", 0x10)
        # SSL 3.0 Fortezza ciphersuites
        add("SSL_FORTEZZA_DMS_WITH_NULL_SHA", 0x1c)
        add("SSL_FORTEZZA_DMS_WITH_FORTEZZA_CBC_SHA", 0x1d)
        # 1024/56 bit exportable ciphersuites from expired internet draft
        add("SSL_RSA_EXPORT1024_WITH_DES_CBC_SHA", 0x62)
        add("SSL_DHE_DSS_EXPORT1024_WITH_DES_CBC_SHA", 0x63)
        add("SSL_RSA_EXPORT1024_WITH_RC4_56_SHA", 0x64)
        add("SSL_DHE_DSS_EXPORT1024_WITH_RC4_56_SHA", 0x65)
        add("SSL_DHE_DSS_WITH_RC4_128_SHA", 0x66)
        # Netscape old and new SSL 3.0 FIPS ciphersuites
        # see http://www.mozilla.org/projects/security/pki/nss/ssl/fips-ssl-ciphersuites.html
        add("NETSCAPE_RSA_FIPS_WITH_3DES_EDE_CBC_SHA", 0xffe0)
        add("NETSCAPE_RSA_FIPS_WITH_DES_CBC_SHA", 0xffe1)
        add("SSL_RSA_FIPS_WITH_DES_CBC_SHA", 0xfefe)
        add("SSL_RSA_FIPS_WITH_3DES_EDE_CBC_SHA", 0xfeff)
        # Unsupported Kerberos cipher suites from RFC 2712
        add("TLS_KRB5_WITH_IDEA_CBC_SHA", 0x21)
        add("TLS_KRB5_WITH_IDEA_CBC_MD5", 0x25)
        add("TLS_KRB5_EXPORT_WITH_RC2_CBC_40_SHA", 0x27)
        add("TLS_KRB5_EXPORT_WITH_RC2_CBC_40_MD5", 0x2a)
      end
      
      # ciphersuite SSL_NULL_WITH_NULL_NULL
      const_set_lazy(:C_NULL) { CipherSuite.value_of(0, 0) }
      const_attr_reader  :C_NULL
    }
    
    private
    alias_method :initialize__cipher_suite, :initialize
  end
  
end

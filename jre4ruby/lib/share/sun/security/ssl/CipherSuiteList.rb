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
  module CipherSuiteListImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Util
      include_const ::Javax::Net::Ssl, :SSLException
    }
  end
  
  # A list of CipherSuites. Also maintains the lists of supported and
  # default ciphersuites and supports I/O from handshake streams.
  # 
  # Instances of this class are immutable.
  class CipherSuiteList 
    include_class_members CipherSuiteListImports
    
    class_module.module_eval {
      # lists of supported and default enabled ciphersuites
      # created on demand
      
      def supported_suites
        defined?(@@supported_suites) ? @@supported_suites : @@supported_suites= nil
      end
      alias_method :attr_supported_suites, :supported_suites
      
      def supported_suites=(value)
        @@supported_suites = value
      end
      alias_method :attr_supported_suites=, :supported_suites=
      
      
      def default_suites
        defined?(@@default_suites) ? @@default_suites : @@default_suites= nil
      end
      alias_method :attr_default_suites, :default_suites
      
      def default_suites=(value)
        @@default_suites = value
      end
      alias_method :attr_default_suites=, :default_suites=
    }
    
    attr_accessor :cipher_suites
    alias_method :attr_cipher_suites, :cipher_suites
    undef_method :cipher_suites
    alias_method :attr_cipher_suites=, :cipher_suites=
    undef_method :cipher_suites=
    
    attr_accessor :suite_names
    alias_method :attr_suite_names, :suite_names
    undef_method :suite_names
    alias_method :attr_suite_names=, :suite_names=
    undef_method :suite_names=
    
    # flag indicating whether this list contains any ECC ciphersuites.
    # null if not yet checked.
    attr_accessor :contains_ec
    alias_method :attr_contains_ec, :contains_ec
    undef_method :contains_ec
    alias_method :attr_contains_ec=, :contains_ec=
    undef_method :contains_ec=
    
    typesig { [Collection] }
    # for use by buildAvailableCache() only
    def initialize(cipher_suites)
      @cipher_suites = nil
      @suite_names = nil
      @contains_ec = nil
      @cipher_suites = cipher_suites
    end
    
    typesig { [CipherSuite] }
    # Create a CipherSuiteList with a single element.
    def initialize(suite)
      @cipher_suites = nil
      @suite_names = nil
      @contains_ec = nil
      @cipher_suites = ArrayList.new(1)
      @cipher_suites.add(suite)
    end
    
    typesig { [Array.typed(String)] }
    # Construct a CipherSuiteList from a array of names. We don't bother
    # to eliminate duplicates.
    # 
    # @exception IllegalArgumentException if the array or any of its elements
    # is null or if the ciphersuite name is unrecognized or unsupported
    # using currently installed providers.
    def initialize(names)
      @cipher_suites = nil
      @suite_names = nil
      @contains_ec = nil
      if ((names).nil?)
        raise IllegalArgumentException.new("CipherSuites may not be null")
      end
      @cipher_suites = ArrayList.new(names.attr_length)
      # refresh available cache once if a CipherSuite is not available
      # (maybe new JCE providers have been installed)
      refreshed = false
      i = 0
      while i < names.attr_length
        suite_name = names[i]
        suite = CipherSuite.value_of(suite_name)
        if ((suite.is_available).equal?(false))
          if ((refreshed).equal?(false))
            # clear the cache so that the isAvailable() call below
            # does a full check
            clear_available_cache
            refreshed = true
          end
          # still missing?
          if ((suite.is_available).equal?(false))
            raise IllegalArgumentException.new("Cannot support " + suite_name + " with currently installed providers")
          end
        end
        @cipher_suites.add(suite)
        i += 1
      end
    end
    
    typesig { [HandshakeInStream] }
    # Read a CipherSuiteList from a HandshakeInStream in V3 ClientHello
    # format. Does not check if the listed ciphersuites are known or
    # supported.
    def initialize(in_)
      @cipher_suites = nil
      @suite_names = nil
      @contains_ec = nil
      bytes = in_.get_bytes16
      if (!((bytes.attr_length & 1)).equal?(0))
        raise SSLException.new("Invalid ClientHello message")
      end
      @cipher_suites = ArrayList.new(bytes.attr_length >> 1)
      i = 0
      while i < bytes.attr_length
        @cipher_suites.add(CipherSuite.value_of(bytes[i], bytes[i + 1]))
        i += 2
      end
    end
    
    typesig { [CipherSuite] }
    # Return whether this list contains the given CipherSuite.
    def contains(suite)
      return @cipher_suites.contains(suite)
    end
    
    typesig { [] }
    # Return whether this list contains any ECC ciphersuites
    def contains_ec
      if ((@contains_ec).nil?)
        @cipher_suites.each do |c|
          case (c.attr_key_exchange)
          when K_ECDH_ECDSA, K_ECDH_RSA, K_ECDHE_ECDSA, K_ECDHE_RSA, K_ECDH_ANON
            @contains_ec = true
            return true
          else
          end
        end
        @contains_ec = false
      end
      return @contains_ec
    end
    
    typesig { [] }
    # Return an Iterator for the CipherSuites in this list.
    def iterator
      return @cipher_suites.iterator
    end
    
    typesig { [] }
    # Return a reference to the internal Collection of CipherSuites.
    # The Collection MUST NOT be modified.
    def collection
      return @cipher_suites
    end
    
    typesig { [] }
    # Return the number of CipherSuites in this list.
    def size
      return @cipher_suites.size
    end
    
    typesig { [] }
    # Return an array with the names of the CipherSuites in this list.
    def to_string_array
      synchronized(self) do
        if ((@suite_names).nil?)
          @suite_names = Array.typed(String).new(@cipher_suites.size) { nil }
          i = 0
          @cipher_suites.each do |c|
            @suite_names[((i += 1) - 1)] = c.attr_name
          end
        end
        return @suite_names.clone
      end
    end
    
    typesig { [] }
    def to_s
      return @cipher_suites.to_s
    end
    
    typesig { [HandshakeOutStream] }
    # Write this list to an HandshakeOutStream in V3 ClientHello format.
    def send(s)
      suite_bytes = Array.typed(::Java::Byte).new(@cipher_suites.size * 2) { 0 }
      i = 0
      @cipher_suites.each do |c|
        suite_bytes[i] = (c.attr_id >> 8)
        suite_bytes[i + 1] = c.attr_id
        i += 2
      end
      s.put_bytes16(suite_bytes)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Clear cache of available ciphersuites. If we support all ciphers
      # internally, there is no need to clear the cache and calling this
      # method has no effect.
      def clear_available_cache
        synchronized(self) do
          if (CipherSuite::DYNAMIC_AVAILABILITY)
            self.attr_supported_suites = nil
            self.attr_default_suites = nil
            CipherSuite::BulkCipher.clear_available_cache
            JsseJce.clear_ec_available
          end
        end
      end
      
      typesig { [::Java::Int] }
      # Return the list of all available CipherSuites with a priority of
      # minPriority or above.
      # Should be called with the Class lock held.
      def build_available_cache(min_priority)
        # SortedSet automatically arranges ciphersuites in default
        # preference order
        cipher_suites = TreeSet.new
        allowed_cipher_suites_ = CipherSuite.allowed_cipher_suites
        allowed_cipher_suites_.each do |c|
          if (((c.attr_allowed).equal?(false)) || (c.attr_priority < min_priority))
            next
          end
          if (c.is_available)
            cipher_suites.add(c)
          end
        end
        return CipherSuiteList.new(cipher_suites)
      end
      
      typesig { [] }
      # Return supported CipherSuites in preference order.
      def get_supported
        synchronized(self) do
          if ((self.attr_supported_suites).nil?)
            self.attr_supported_suites = build_available_cache(CipherSuite::SUPPORTED_SUITES_PRIORITY)
          end
          return self.attr_supported_suites
        end
      end
      
      typesig { [] }
      # Return default enabled CipherSuites in preference order.
      def get_default
        synchronized(self) do
          if ((self.attr_default_suites).nil?)
            self.attr_default_suites = build_available_cache(CipherSuite::DEFAULT_SUITES_PRIORITY)
          end
          return self.attr_default_suites
        end
      end
    }
    
    private
    alias_method :initialize__cipher_suite_list, :initialize
  end
  
end

require "rjava"

# Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509KeyManagerImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Lang::Ref
      include ::Java::Util
      include_const ::Java::Util::Locale, :ENGLISH
      include_const ::Java::Util::Concurrent::Atomic, :AtomicLong
      include_const ::Java::Net, :Socket
      include ::Java::Security
      include ::Java::Security::KeyStore
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
      include ::Javax::Net::Ssl
    }
  end
  
  # The new X509 key manager implementation. The main differences to the
  # old SunX509 key manager are:
  # . it is based around the KeyStore.Builder API. This allows it to use
  # other forms of KeyStore protection or password input (e.g. a
  # CallbackHandler) or to have keys within one KeyStore protected by
  # different keys.
  # . it can use multiple KeyStores at the same time.
  # . it is explicitly designed to accomodate KeyStores that change over
  # the lifetime of the process.
  # . it makes an effort to choose the key that matches best, i.e. one that
  # is not expired and has the appropriate certificate extensions.
  # 
  # Note that this code is not explicitly performance optimzied yet.
  # 
  # @author  Andreas Sterbenz
  class X509KeyManagerImpl < X509KeyManagerImplImports.const_get :X509ExtendedKeyManager
    include_class_members X509KeyManagerImplImports
    overload_protected {
      include X509KeyManager
    }
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
      
      const_set_lazy(:UseDebug) { (!(Debug).nil?) && Debug.is_on("keymanager") }
      const_attr_reader  :UseDebug
      
      # for unit testing only, set via privileged reflection
      
      def verification_date
        defined?(@@verification_date) ? @@verification_date : @@verification_date= nil
      end
      alias_method :attr_verification_date, :verification_date
      
      def verification_date=(value)
        @@verification_date = value
      end
      alias_method :attr_verification_date=, :verification_date=
    }
    
    # list of the builders
    attr_accessor :builders
    alias_method :attr_builders, :builders
    undef_method :builders
    alias_method :attr_builders=, :builders=
    undef_method :builders=
    
    # counter to generate unique ids for the aliases
    attr_accessor :uid_counter
    alias_method :attr_uid_counter, :uid_counter
    undef_method :uid_counter
    alias_method :attr_uid_counter=, :uid_counter=
    undef_method :uid_counter=
    
    # cached entries
    attr_accessor :entry_cache_map
    alias_method :attr_entry_cache_map, :entry_cache_map
    undef_method :entry_cache_map
    alias_method :attr_entry_cache_map=, :entry_cache_map=
    undef_method :entry_cache_map=
    
    typesig { [Builder] }
    def initialize(builder)
      initialize__x509key_manager_impl(Collections.singleton_list(builder))
    end
    
    typesig { [JavaList] }
    def initialize(builders)
      @builders = nil
      @uid_counter = nil
      @entry_cache_map = nil
      super()
      @builders = builders
      @uid_counter = AtomicLong.new
      @entry_cache_map = Collections.synchronized_map(SizedMap.new)
    end
    
    class_module.module_eval {
      # LinkedHashMap with a max size of 10
      # see LinkedHashMap JavaDocs
      const_set_lazy(:SizedMap) { Class.new(LinkedHashMap) do
        include_class_members X509KeyManagerImpl
        
        typesig { [self::Map::Entry] }
        def remove_eldest_entry(eldest)
          return size > 10
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__sized_map, :initialize
      end }
    }
    
    typesig { [String] }
    # public methods
    def get_certificate_chain(alias_)
      entry = get_entry(alias_)
      return (entry).nil? ? nil : entry.get_certificate_chain
    end
    
    typesig { [String] }
    def get_private_key(alias_)
      entry = get_entry(alias_)
      return (entry).nil? ? nil : entry.get_private_key
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), Socket] }
    def choose_client_alias(key_types, issuers, socket)
      return choose_alias(get_key_types(key_types), issuers, CheckType::CLIENT)
    end
    
    typesig { [Array.typed(String), Array.typed(Principal), SSLEngine] }
    def choose_engine_client_alias(key_types, issuers, engine)
      return choose_alias(get_key_types(key_types), issuers, CheckType::CLIENT)
    end
    
    typesig { [String, Array.typed(Principal), Socket] }
    def choose_server_alias(key_type, issuers, socket)
      return choose_alias(get_key_types(key_type), issuers, CheckType::SERVER)
    end
    
    typesig { [String, Array.typed(Principal), SSLEngine] }
    def choose_engine_server_alias(key_type, issuers, engine)
      return choose_alias(get_key_types(key_type), issuers, CheckType::SERVER)
    end
    
    typesig { [String, Array.typed(Principal)] }
    def get_client_aliases(key_type, issuers)
      return get_aliases(key_type, issuers, CheckType::CLIENT)
    end
    
    typesig { [String, Array.typed(Principal)] }
    def get_server_aliases(key_type, issuers)
      return get_aliases(key_type, issuers, CheckType::SERVER)
    end
    
    typesig { [EntryStatus] }
    # implementation private methods
    # 
    # we construct the alias we return to JSSE as seen in the code below
    # a unique id is included to allow us to reliably cache entries
    # between the calls to getCertificateChain() and getPrivateKey()
    # even if tokens are inserted or removed
    def make_alias(entry)
      return RJava.cast_to_string(@uid_counter.increment_and_get) + "." + RJava.cast_to_string(entry.attr_builder_index) + "." + RJava.cast_to_string(entry.attr_alias)
    end
    
    typesig { [String] }
    def get_entry(alias_)
      # if the alias is null, return immediately
      if ((alias_).nil?)
        return nil
      end
      # try to get the entry from cache
      ref = @entry_cache_map.get(alias_)
      entry = (!(ref).nil?) ? ref.get : nil
      if (!(entry).nil?)
        return entry
      end
      # parse the alias
      first_dot = alias_.index_of(Character.new(?..ord))
      second_dot = alias_.index_of(Character.new(?..ord), first_dot + 1)
      if (((first_dot).equal?(-1)) || ((second_dot).equal?(first_dot)))
        # invalid alias
        return nil
      end
      begin
        builder_index = JavaInteger.parse_int(alias_.substring(first_dot + 1, second_dot))
        key_store_alias = alias_.substring(second_dot + 1)
        builder = @builders.get(builder_index)
        ks = builder.get_key_store
        new_entry = ks.get_entry(key_store_alias, builder.get_protection_parameter(alias_))
        if ((new_entry.is_a?(PrivateKeyEntry)).equal?(false))
          # unexpected type of entry
          return nil
        end
        entry = new_entry
        @entry_cache_map.put(alias_, SoftReference.new(entry))
        return entry
      rescue JavaException => e
        # ignore
        return nil
      end
    end
    
    class_module.module_eval {
      # Class to help verify that the public key algorithm (and optionally
      # the signature algorithm) of a certificate matches what we need.
      const_set_lazy(:KeyType) { Class.new do
        include_class_members X509KeyManagerImpl
        
        attr_accessor :key_algorithm
        alias_method :attr_key_algorithm, :key_algorithm
        undef_method :key_algorithm
        alias_method :attr_key_algorithm=, :key_algorithm=
        undef_method :key_algorithm=
        
        attr_accessor :sig_key_algorithm
        alias_method :attr_sig_key_algorithm, :sig_key_algorithm
        undef_method :sig_key_algorithm
        alias_method :attr_sig_key_algorithm=, :sig_key_algorithm=
        undef_method :sig_key_algorithm=
        
        typesig { [String] }
        def initialize(algorithm)
          @key_algorithm = nil
          @sig_key_algorithm = nil
          k = algorithm.index_of("_")
          if ((k).equal?(-1))
            @key_algorithm = algorithm
            @sig_key_algorithm = RJava.cast_to_string(nil)
          else
            @key_algorithm = RJava.cast_to_string(algorithm.substring(0, k))
            @sig_key_algorithm = RJava.cast_to_string(algorithm.substring(k + 1))
          end
        end
        
        typesig { [Array.typed(self::Certificate)] }
        def matches(chain)
          if (!(chain[0].get_public_key.get_algorithm == @key_algorithm))
            return false
          end
          if ((@sig_key_algorithm).nil?)
            return true
          end
          if (chain.attr_length > 1)
            # if possible, check the public key in the issuer cert
            return (@sig_key_algorithm == chain[1].get_public_key.get_algorithm)
          else
            # Check the signature algorithm of the certificate itself.
            # Look for the "withRSA" in "SHA1withRSA", etc.
            issuer = chain[0]
            sig_alg_name = issuer.get_sig_alg_name.to_upper_case(ENGLISH)
            pattern = "WITH" + RJava.cast_to_string(@sig_key_algorithm.to_upper_case(ENGLISH))
            return sig_alg_name.contains(pattern)
          end
        end
        
        private
        alias_method :initialize__key_type, :initialize
      end }
      
      typesig { [String] }
      def get_key_types(*key_types)
        if (((key_types).nil?) || ((key_types.attr_length).equal?(0)) || ((key_types[0]).nil?))
          return nil
        end
        list = ArrayList.new(key_types.attr_length)
        key_types.each do |keyType|
          list.add(KeyType.new(key_type))
        end
        return list
      end
    }
    
    typesig { [JavaList, Array.typed(Principal), CheckType] }
    # Return the best alias that fits the given parameters.
    # The algorithm we use is:
    # . scan through all the aliases in all builders in order
    # . as soon as we find a perfect match, return
    # (i.e. a match with a cert that has appropriate key usage
    # and is not expired).
    # . if we do not find a perfect match, keep looping and remember
    # the imperfect matches
    # . at the end, sort the imperfect matches. we prefer expired certs
    # with appropriate key usage to certs with the wrong key usage.
    # return the first one of them.
    def choose_alias(key_type_list, issuers, check_type)
      if ((key_type_list).nil? || (key_type_list.size).equal?(0))
        return nil
      end
      issuer_set = get_issuer_set(issuers)
      all_results = nil
      i = 0
      n = @builders.size
      while i < n
        begin
          results = get_aliases(i, key_type_list, issuer_set, false, check_type)
          if (!(results).nil?)
            # the results will either be a single perfect match
            # or 1 or more imperfect matches
            # if it's a perfect match, return immediately
            status = results.get(0)
            if ((status.attr_check_result).equal?(CheckResult::OK))
              if (UseDebug)
                Debug.println("KeyMgr: choosing key: " + RJava.cast_to_string(status))
              end
              return make_alias(status)
            end
            if ((all_results).nil?)
              all_results = ArrayList.new
            end
            all_results.add_all(results)
          end
        rescue JavaException => e
          # ignore
        end
        i += 1
      end
      if ((all_results).nil?)
        if (UseDebug)
          Debug.println("KeyMgr: no matching key found")
        end
        return nil
      end
      Collections.sort(all_results)
      if (UseDebug)
        Debug.println("KeyMgr: no good matching key found, " + "returning best match out of:")
        Debug.println(all_results.to_s)
      end
      return make_alias(all_results.get(0))
    end
    
    typesig { [String, Array.typed(Principal), CheckType] }
    # Return all aliases that (approximately) fit the parameters.
    # These are perfect matches plus imperfect matches (expired certificates
    # and certificates with the wrong extensions).
    # The perfect matches will be first in the array.
    def get_aliases(key_type, issuers, check_type)
      if ((key_type).nil?)
        return nil
      end
      issuer_set = get_issuer_set(issuers)
      key_type_list = get_key_types(key_type)
      all_results = nil
      i = 0
      n = @builders.size
      while i < n
        begin
          results = get_aliases(i, key_type_list, issuer_set, true, check_type)
          if (!(results).nil?)
            if ((all_results).nil?)
              all_results = ArrayList.new
            end
            all_results.add_all(results)
          end
        rescue JavaException => e
          # ignore
        end
        i += 1
      end
      if ((all_results).nil? || (all_results.size).equal?(0))
        if (UseDebug)
          Debug.println("KeyMgr: no matching alias found")
        end
        return nil
      end
      Collections.sort(all_results)
      if (UseDebug)
        Debug.println("KeyMgr: getting aliases: " + RJava.cast_to_string(all_results))
      end
      return to_aliases(all_results)
    end
    
    typesig { [JavaList] }
    # turn candidate entries into unique aliases we can return to JSSE
    def to_aliases(results)
      s = Array.typed(String).new(results.size) { nil }
      i = 0
      results.each do |result|
        s[((i += 1) - 1)] = make_alias(result)
      end
      return s
    end
    
    typesig { [Array.typed(Principal)] }
    # make a Set out of the array
    def get_issuer_set(issuers)
      if ((!(issuers).nil?) && (!(issuers.attr_length).equal?(0)))
        return HashSet.new(Arrays.as_list(issuers))
      else
        return nil
      end
    end
    
    class_module.module_eval {
      # a candidate match
      # identifies the entry by builder and alias
      # and includes the result of the certificate check
      const_set_lazy(:EntryStatus) { Class.new do
        include_class_members X509KeyManagerImpl
        include JavaComparable
        
        attr_accessor :builder_index
        alias_method :attr_builder_index, :builder_index
        undef_method :builder_index
        alias_method :attr_builder_index=, :builder_index=
        undef_method :builder_index=
        
        attr_accessor :key_index
        alias_method :attr_key_index, :key_index
        undef_method :key_index
        alias_method :attr_key_index=, :key_index=
        undef_method :key_index=
        
        attr_accessor :alias
        alias_method :attr_alias, :alias
        undef_method :alias
        alias_method :attr_alias=, :alias=
        undef_method :alias=
        
        attr_accessor :check_result
        alias_method :attr_check_result, :check_result
        undef_method :check_result
        alias_method :attr_check_result=, :check_result=
        undef_method :check_result=
        
        typesig { [::Java::Int, ::Java::Int, String, Array.typed(self::Certificate), self::CheckResult] }
        def initialize(builder_index, key_index, alias_, chain, check_result)
          @builder_index = 0
          @key_index = 0
          @alias = nil
          @check_result = nil
          @builder_index = builder_index
          @key_index = key_index
          @alias = alias_
          @check_result = check_result
        end
        
        typesig { [self::EntryStatus] }
        def compare_to(other)
          result = (@check_result <=> other.attr_check_result)
          return ((result).equal?(0)) ? (@key_index - other.attr_key_index) : result
        end
        
        typesig { [] }
        def to_s
          s = @alias + " (verified: " + RJava.cast_to_string(@check_result) + ")"
          if ((@builder_index).equal?(0))
            return s
          else
            return "Builder #" + RJava.cast_to_string(@builder_index) + ", alias: " + s
          end
        end
        
        private
        alias_method :initialize__entry_status, :initialize
      end }
      
      const_set_lazy(:NONE) { CheckType::NONE }
      const_attr_reader  :NONE
      
      const_set_lazy(:CLIENT) { CheckType::CLIENT }
      const_attr_reader  :CLIENT
      
      const_set_lazy(:SERVER) { CheckType::SERVER }
      const_attr_reader  :SERVER
      
      # enum for the type of certificate check we want to perform
      # (client or server)
      # also includes the check code itself
      class CheckType 
        include_class_members X509KeyManagerImpl
        
        class_module.module_eval {
          # enum constant for "no check" (currently not used)
          const_set_lazy(:NONE) { CheckType.new(Collections.empty_set).set_value_name("NONE") }
          const_attr_reader  :NONE
          
          # enum constant for "tls client" check
          # valid EKU for TLS client: any, tls_client
          const_set_lazy(:CLIENT) { CheckType.new(HashSet.new(Arrays.as_list(Array.typed(String).new(["2.5.29.37.0", "1.3.6.1.5.5.7.3.2"])))).set_value_name("CLIENT") }
          const_attr_reader  :CLIENT
          
          # enum constant for "tls server" check
          # valid EKU for TLS server: any, tls_server, ns_sgc, ms_sgc
          const_set_lazy(:SERVER) { CheckType.new(HashSet.new(Arrays.as_list(Array.typed(String).new(["2.5.29.37.0", "1.3.6.1.5.5.7.3.1", "2.16.840.1.113730.4.1", "1.3.6.1.4.1.311.10.3.3"])))).set_value_name("SERVER") }
          const_attr_reader  :SERVER
        }
        
        # set of valid EKU values for this type
        attr_accessor :valid_eku
        alias_method :attr_valid_eku, :valid_eku
        undef_method :valid_eku
        alias_method :attr_valid_eku=, :valid_eku=
        undef_method :valid_eku=
        
        typesig { [JavaSet] }
        def initialize(valid_eku)
          @valid_eku = nil
          @valid_eku = valid_eku
        end
        
        class_module.module_eval {
          typesig { [Array.typed(::Java::Boolean), ::Java::Int] }
          def get_bit(key_usage, bit)
            return (bit < key_usage.attr_length) && key_usage[bit]
          end
        }
        
        typesig { [X509Certificate, Date] }
        # check if this certificate is appropriate for this type of use
        # first check extensions, if they match, check expiration
        # note: we may want to move this code into the sun.security.validator
        # package
        def check(cert, date)
          if ((self).equal?(NONE))
            return CheckResult::OK
          end
          # check extensions
          begin
            # check extended key usage
            cert_eku = cert.get_extended_key_usage
            if ((!(cert_eku).nil?) && Collections.disjoint(@valid_eku, cert_eku))
              # if extension present and it does not contain any of
              # the valid EKU OIDs, return extension_mismatch
              return CheckResult::EXTENSION_MISMATCH
            end
            # check key usage
            ku = cert.get_key_usage
            if (!(ku).nil?)
              algorithm = cert.get_public_key.get_algorithm
              ku_signature = get_bit(ku, 0)
              if ((algorithm == "RSA"))
                # require either signature bit
                # or if server also allow key encipherment bit
                if ((ku_signature).equal?(false))
                  if (((self).equal?(CLIENT)) || ((get_bit(ku, 2)).equal?(false)))
                    return CheckResult::EXTENSION_MISMATCH
                  end
                end
              else
                if ((algorithm == "DSA"))
                  # require signature bit
                  if ((ku_signature).equal?(false))
                    return CheckResult::EXTENSION_MISMATCH
                  end
                else
                  if ((algorithm == "DH"))
                    # require keyagreement bit
                    if ((get_bit(ku, 4)).equal?(false))
                      return CheckResult::EXTENSION_MISMATCH
                    end
                  else
                    if ((algorithm == "EC"))
                      # require signature bit
                      if ((ku_signature).equal?(false))
                        return CheckResult::EXTENSION_MISMATCH
                      end
                      # For servers, also require key agreement.
                      # This is not totally accurate as the keyAgreement bit
                      # is only necessary for static ECDH key exchange and
                      # not ephemeral ECDH. We leave it in for now until
                      # there are signs that this check causes problems
                      # for real world EC certificates.
                      if (((self).equal?(SERVER)) && ((get_bit(ku, 4)).equal?(false)))
                        return CheckResult::EXTENSION_MISMATCH
                      end
                    end
                  end
                end
              end
            end
          rescue CertificateException => e
            # extensions unparseable, return failure
            return CheckResult::EXTENSION_MISMATCH
          end
          begin
            cert.check_validity(date)
            return CheckResult::OK
          rescue CertificateException => e
            return CheckResult::EXPIRED
          end
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
            [NONE, CLIENT, SERVER]
          end
        }
        
        private
        alias_method :initialize__check_type, :initialize
      end
      
      const_set_lazy(:OK) { CheckResult::OK }
      const_attr_reader  :OK
      
      const_set_lazy(:EXPIRED) { CheckResult::EXPIRED }
      const_attr_reader  :EXPIRED
      
      const_set_lazy(:EXTENSION_MISMATCH) { CheckResult::EXTENSION_MISMATCH }
      const_attr_reader  :EXTENSION_MISMATCH
      
      # extensions invalid (expiration not checked)
      # enum for the result of the extension check
      # NOTE: the order of the constants is important as they are used
      # for sorting, i.e. OK is best, followed by EXPIRED and EXTENSION_MISMATCH
      class CheckResult 
        include_class_members X509KeyManagerImpl
        
        class_module.module_eval {
          const_set_lazy(:OK) { CheckResult.new.set_value_name("OK") }
          const_attr_reader  :OK
          
          # ok or not checked
          const_set_lazy(:EXPIRED) { CheckResult.new.set_value_name("EXPIRED") }
          const_attr_reader  :EXPIRED
          
          # extensions valid but cert expired
          const_set_lazy(:EXTENSION_MISMATCH) { CheckResult.new.set_value_name("EXTENSION_MISMATCH") }
          const_attr_reader  :EXTENSION_MISMATCH
        }
        
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
            [OK, EXPIRED, EXTENSION_MISMATCH]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__check_result, :initialize
      end
    }
    
    typesig { [::Java::Int, JavaList, JavaSet, ::Java::Boolean, CheckType] }
    # Return a List of all candidate matches in the specified builder
    # that fit the parameters.
    # We exclude entries in the KeyStore if they are not:
    # . private key entries
    # . the certificates are not X509 certificates
    # . the algorithm of the key in the EE cert doesn't match one of keyTypes
    # . none of the certs is issued by a Principal in issuerSet
    # Using those entries would not be possible or they would almost
    # certainly be rejected by the peer.
    # 
    # In addition to those checks, we also check the extensions in the EE
    # cert and its expiration. Even if there is a mismatch, we include
    # such certificates because they technically work and might be accepted
    # by the peer. This leads to more graceful failure and better error
    # messages if the cert expires from one day to the next.
    # 
    # The return values are:
    # . null, if there are no matching entries at all
    # . if 'findAll' is 'false' and there is a perfect match, a List
    # with a single element (early return)
    # . if 'findAll' is 'false' and there is NO perfect match, a List
    # with all the imperfect matches (expired, wrong extensions)
    # . if 'findAll' is 'true', a List with all perfect and imperfect
    # matches
    def get_aliases(builder_index, key_types, issuer_set, find_all, check_type)
      builder = @builders.get(builder_index)
      ks = builder.get_key_store
      results = nil
      date = self.attr_verification_date
      preferred = false
      e = ks.aliases
      while e.has_more_elements
        alias_ = e.next_element
        # check if it is a key entry (private key or secret key)
        if ((ks.is_key_entry(alias_)).equal?(false))
          next
        end
        chain = ks.get_certificate_chain(alias_)
        if (((chain).nil?) || ((chain.attr_length).equal?(0)))
          # must be secret key entry, ignore
          next
        end
        # check keytype
        key_index = -1
        j = 0
        key_types.each do |keyType|
          if (key_type.matches(chain))
            key_index = j
            break
          end
          j += 1
        end
        if ((key_index).equal?(-1))
          if (UseDebug)
            Debug.println("Ignoring alias " + alias_ + ": key algorithm does not match")
          end
          next
        end
        # check issuers
        if (!(issuer_set).nil?)
          found = false
          chain.each do |cert|
            if ((cert.is_a?(X509Certificate)).equal?(false))
              # not an X509Certificate, ignore this entry
              break
            end
            xcert = cert
            if (issuer_set.contains(xcert.get_issuer_x500principal))
              found = true
              break
            end
          end
          if ((found).equal?(false))
            if (UseDebug)
              Debug.println("Ignoring alias " + alias_ + ": issuers do not match")
            end
            next
          end
        end
        if ((date).nil?)
          date = Date.new
        end
        check_result = check_type.check(chain[0], date)
        status = EntryStatus.new(builder_index, key_index, alias_, chain, check_result)
        if (!preferred && (check_result).equal?(CheckResult::OK) && (key_index).equal?(0))
          preferred = true
        end
        if (preferred && ((find_all).equal?(false)))
          # if we have a good match and do not need all matches,
          # return immediately
          return Collections.singleton_list(status)
        else
          if ((results).nil?)
            results = ArrayList.new
          end
          results.add(status)
        end
      end
      return results
    end
    
    private
    alias_method :initialize__x509key_manager_impl, :initialize
  end
  
end

require "rjava"

# 
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
  module TokenImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Io
      include ::Java::Lang::Ref
      include ::Java::Security
      include_const ::Javax::Security::Auth::Login, :LoginException
      include_const ::Sun::Security::Jca, :JCAUtil
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # PKCS#11 token.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class Token 
    include_class_members TokenImports
    include Serializable
    
    class_module.module_eval {
      # need to be serializable to allow SecureRandom to be serialized
      const_set_lazy(:SerialVersionUID) { 2541527649100571747 }
      const_attr_reader  :SerialVersionUID
      
      # how often to check if the token is still present (in ms)
      # this is different from checking if a token has been inserted,
      # that is done in SunPKCS11. Currently 50 ms.
      const_set_lazy(:CHECK_INTERVAL) { 50 }
      const_attr_reader  :CHECK_INTERVAL
    }
    
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    attr_accessor :p11
    alias_method :attr_p11, :p11
    undef_method :p11
    alias_method :attr_p11=, :p11=
    undef_method :p11=
    
    attr_accessor :config
    alias_method :attr_config, :config
    undef_method :config
    alias_method :attr_config=, :config=
    undef_method :config=
    
    attr_accessor :token_info
    alias_method :attr_token_info, :token_info
    undef_method :token_info
    alias_method :attr_token_info=, :token_info=
    undef_method :token_info=
    
    # session manager to pool sessions
    attr_accessor :session_manager
    alias_method :attr_session_manager, :session_manager
    undef_method :session_manager
    alias_method :attr_session_manager=, :session_manager=
    undef_method :session_manager=
    
    # template manager to customize the attributes used when creating objects
    attr_accessor :template_manager
    alias_method :attr_template_manager, :template_manager
    undef_method :template_manager
    alias_method :attr_template_manager=, :template_manager=
    undef_method :template_manager=
    
    # flag indicating whether we need to explicitly cancel operations
    # we started on the token. If false, we assume operations are
    # automatically cancelled once we start another one
    attr_accessor :explicit_cancel
    alias_method :attr_explicit_cancel, :explicit_cancel
    undef_method :explicit_cancel
    alias_method :attr_explicit_cancel=, :explicit_cancel=
    undef_method :explicit_cancel=
    
    # translation cache for secret keys
    attr_accessor :secret_cache
    alias_method :attr_secret_cache, :secret_cache
    undef_method :secret_cache
    alias_method :attr_secret_cache=, :secret_cache=
    undef_method :secret_cache=
    
    # translation cache for asymmetric keys (public and private)
    attr_accessor :private_cache
    alias_method :attr_private_cache, :private_cache
    undef_method :private_cache
    alias_method :attr_private_cache=, :private_cache=
    undef_method :private_cache=
    
    # cached instances of the various key factories, initialized on demand
    attr_accessor :rsa_factory
    alias_method :attr_rsa_factory, :rsa_factory
    undef_method :rsa_factory
    alias_method :attr_rsa_factory=, :rsa_factory=
    undef_method :rsa_factory=
    
    attr_accessor :dsa_factory
    alias_method :attr_dsa_factory, :dsa_factory
    undef_method :dsa_factory
    alias_method :attr_dsa_factory=, :dsa_factory=
    undef_method :dsa_factory=
    
    attr_accessor :dh_factory
    alias_method :attr_dh_factory, :dh_factory
    undef_method :dh_factory
    alias_method :attr_dh_factory=, :dh_factory=
    undef_method :dh_factory=
    
    attr_accessor :ec_factory
    alias_method :attr_ec_factory, :ec_factory
    undef_method :ec_factory
    alias_method :attr_ec_factory=, :ec_factory=
    undef_method :ec_factory=
    
    # table which maps mechanisms to the corresponding cached
    # MechanismInfo objects
    attr_accessor :mech_info_map
    alias_method :attr_mech_info_map, :mech_info_map
    undef_method :mech_info_map
    alias_method :attr_mech_info_map=, :mech_info_map=
    undef_method :mech_info_map=
    
    # single SecureRandomSpi instance we use per token
    # initialized on demand (if supported)
    attr_accessor :secure_random
    alias_method :attr_secure_random, :secure_random
    undef_method :secure_random
    alias_method :attr_secure_random=, :secure_random=
    undef_method :secure_random=
    
    # single KeyStoreSpi instance we use per provider
    # initialized on demand
    attr_accessor :key_store
    alias_method :attr_key_store, :key_store
    undef_method :key_store
    alias_method :attr_key_store=, :key_store=
    undef_method :key_store=
    
    # whether this token is a removable token
    attr_accessor :removable
    alias_method :attr_removable, :removable
    undef_method :removable
    alias_method :attr_removable=, :removable=
    undef_method :removable=
    
    # for removable tokens: whether this token is valid or has been removed
    attr_accessor :valid
    alias_method :attr_valid, :valid
    undef_method :valid
    alias_method :attr_valid=, :valid=
    undef_method :valid=
    
    # for removable tokens: time last checked for token presence
    attr_accessor :last_present_check
    alias_method :attr_last_present_check, :last_present_check
    undef_method :last_present_check
    alias_method :attr_last_present_check=, :last_present_check=
    undef_method :last_present_check=
    
    # unique token id, used for serialization only
    attr_accessor :token_id
    alias_method :attr_token_id, :token_id
    undef_method :token_id
    alias_method :attr_token_id=, :token_id=
    undef_method :token_id=
    
    # flag indicating whether the token is write protected
    attr_accessor :write_protected
    alias_method :attr_write_protected, :write_protected
    undef_method :write_protected
    alias_method :attr_write_protected=, :write_protected=
    undef_method :write_protected=
    
    # flag indicating whether we are logged in
    attr_accessor :logged_in
    alias_method :attr_logged_in, :logged_in
    undef_method :logged_in
    alias_method :attr_logged_in=, :logged_in=
    undef_method :logged_in=
    
    # time we last checked login status
    attr_accessor :last_login_check
    alias_method :attr_last_login_check, :last_login_check
    undef_method :last_login_check
    alias_method :attr_last_login_check=, :last_login_check=
    undef_method :last_login_check=
    
    class_module.module_eval {
      # mutex for token-present-check
      const_set_lazy(:CHECK_LOCK) { Object.new }
      const_attr_reader  :CHECK_LOCK
      
      # object for indicating unsupported mechanism in 'mechInfoMap'
      const_set_lazy(:INVALID_MECH) { CK_MECHANISM_INFO.new(0, 0, 0) }
      const_attr_reader  :INVALID_MECH
    }
    
    typesig { [SunPKCS11] }
    def initialize(provider)
      @provider = nil
      @p11 = nil
      @config = nil
      @token_info = nil
      @session_manager = nil
      @template_manager = nil
      @explicit_cancel = false
      @secret_cache = nil
      @private_cache = nil
      @rsa_factory = nil
      @dsa_factory = nil
      @dh_factory = nil
      @ec_factory = nil
      @mech_info_map = nil
      @secure_random = nil
      @key_store = nil
      @removable = false
      @valid = false
      @last_present_check = 0
      @token_id = nil
      @write_protected = false
      @logged_in = false
      @last_login_check = 0
      @provider = provider
      @removable = provider.attr_removable
      @valid = true
      @p11 = provider.attr_p11
      @config = provider.attr_config
      @token_info = @p11._c_get_token_info(provider.attr_slot_id)
      @write_protected = !((@token_info.attr_flags & CKF_WRITE_PROTECTED)).equal?(0)
      # create session manager and open a test session
      session_manager = nil
      begin
        session_manager = SessionManager.new(self)
        s = session_manager.get_op_session
        session_manager.release_session(s)
      rescue PKCS11Exception => e
        if (@write_protected)
          raise e
        end
        # token might not permit RW sessions even though
        # CKF_WRITE_PROTECTED is not set
        @write_protected = true
        session_manager = SessionManager.new(self)
        s_ = session_manager.get_op_session
        session_manager.release_session(s_)
      end
      @session_manager = session_manager
      @secret_cache = KeyCache.new
      @private_cache = KeyCache.new
      @template_manager = @config.get_template_manager
      @explicit_cancel = @config.get_explicit_cancel
      @mech_info_map = Collections.synchronized_map(HashMap.new(10))
    end
    
    typesig { [] }
    def is_write_protected
      return @write_protected
    end
    
    typesig { [Session] }
    # return whether we are logged in
    # uses cached result if current. session is optional and may be null
    def is_logged_in(session)
      # volatile load first
      logged_in = @logged_in
      time = System.current_time_millis
      if (time - @last_login_check > CHECK_INTERVAL)
        logged_in = is_logged_in_now(session)
        @last_login_check = time
      end
      return logged_in
    end
    
    typesig { [Session] }
    # return whether we are logged in now
    # does not use cache
    def is_logged_in_now(session)
      alloc_session = ((session).nil?)
      begin
        if (alloc_session)
          session = get_op_session
        end
        info = @p11._c_get_session_info(session.id)
        logged_in = ((info.attr_state).equal?(CKS_RO_USER_FUNCTIONS)) || ((info.attr_state).equal?(CKS_RW_USER_FUNCTIONS))
        @logged_in = logged_in
        return logged_in
      ensure
        if (alloc_session)
          release_session(session)
        end
      end
    end
    
    typesig { [Session] }
    # ensure that we are logged in
    # call provider.login() if not
    def ensure_logged_in(session)
      if ((is_logged_in(session)).equal?(false))
        @provider.login(nil, nil)
      end
    end
    
    typesig { [] }
    # return whether this token object is valid (i.e. token not removed)
    # returns value from last check, does not perform new check
    def is_valid
      if ((@removable).equal?(false))
        return true
      end
      return @valid
    end
    
    typesig { [] }
    def ensure_valid
      if ((is_valid).equal?(false))
        raise ProviderException.new("Token has been removed")
      end
    end
    
    typesig { [Session] }
    # return whether a token is present (i.e. token not removed)
    # returns cached value if current, otherwise performs new check
    def is_present(session)
      if ((@removable).equal?(false))
        return true
      end
      if ((@valid).equal?(false))
        return false
      end
      time = System.current_time_millis
      if ((time - @last_present_check) >= CHECK_INTERVAL)
        synchronized((CHECK_LOCK)) do
          if ((time - @last_present_check) >= CHECK_INTERVAL)
            ok = false
            begin
              # check if token still present
              slot_info = @provider.attr_p11._c_get_slot_info(@provider.attr_slot_id)
              if (!((slot_info.attr_flags & CKF_TOKEN_PRESENT)).equal?(0))
                # if the token has been removed and re-inserted,
                # the token should return an error
                sess_info = @provider.attr_p11._c_get_session_info(session.id_internal)
                ok = true
              end
            rescue PKCS11Exception => e
              # empty
            end
            @valid = ok
            @last_present_check = System.current_time_millis
            if ((ok).equal?(false))
              destroy
            end
          end
        end
      end
      return @valid
    end
    
    typesig { [] }
    def destroy
      @valid = false
      @provider.uninit_token(self)
    end
    
    typesig { [] }
    def get_obj_session
      return @session_manager.get_obj_session
    end
    
    typesig { [] }
    def get_op_session
      return @session_manager.get_op_session
    end
    
    typesig { [Session] }
    def release_session(session)
      return @session_manager.release_session(session)
    end
    
    typesig { [Session] }
    def kill_session(session)
      return @session_manager.kill_session(session)
    end
    
    typesig { [String, ::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    def get_attributes(op, type, alg, attrs)
      new_attrs = @template_manager.get_attributes(op, type, alg, attrs)
      new_attrs.each do |attr|
        if ((attr.attr_type).equal?(CKA_TOKEN))
          if (attr.get_boolean)
            begin
              ensure_logged_in(nil)
            rescue LoginException => e
              raise ProviderException.new("Login failed", e)
            end
          end
          # break once we have found a CKA_TOKEN attribute
          break
        end
      end
      return new_attrs
    end
    
    typesig { [String] }
    def get_key_factory(algorithm)
      f = nil
      if ((algorithm == "RSA"))
        f = @rsa_factory
        if ((f).nil?)
          f = P11RSAKeyFactory.new(self, algorithm)
          @rsa_factory = f
        end
      else
        if ((algorithm == "DSA"))
          f = @dsa_factory
          if ((f).nil?)
            f = P11DSAKeyFactory.new(self, algorithm)
            @dsa_factory = f
          end
        else
          if ((algorithm == "DH"))
            f = @dh_factory
            if ((f).nil?)
              f = P11DHKeyFactory.new(self, algorithm)
              @dh_factory = f
            end
          else
            if ((algorithm == "EC"))
              f = @ec_factory
              if ((f).nil?)
                f = P11ECKeyFactory.new(self, algorithm)
                @ec_factory = f
              end
            else
              raise ProviderException.new("Unknown algorithm " + algorithm)
            end
          end
        end
      end
      return f
    end
    
    typesig { [] }
    def get_random
      if ((@secure_random).nil?)
        @secure_random = P11SecureRandom.new(self)
      end
      return @secure_random
    end
    
    typesig { [] }
    def get_key_store
      if ((@key_store).nil?)
        @key_store = P11KeyStore.new(self)
      end
      return @key_store
    end
    
    typesig { [::Java::Long] }
    def get_mechanism_info(mechanism)
      result = @mech_info_map.get(mechanism)
      if ((result).nil?)
        begin
          result = @p11._c_get_mechanism_info(@provider.attr_slot_id, mechanism)
          @mech_info_map.put(mechanism, result)
        rescue PKCS11Exception => e
          if (!(e.get_error_code).equal?(PKCS11Constants::CKR_MECHANISM_INVALID))
            raise e
          else
            @mech_info_map.put(mechanism, INVALID_MECH)
          end
        end
      else
        if ((result).equal?(INVALID_MECH))
          result = nil
        end
      end
      return result
    end
    
    typesig { [] }
    def get_token_id
      synchronized(self) do
        if ((@token_id).nil?)
          random = JCAUtil.get_secure_random
          @token_id = Array.typed(::Java::Byte).new(20) { 0 }
          random.next_bytes(@token_id)
          SerializedTokens.add(WeakReference.new(self))
        end
        return @token_id
      end
    end
    
    class_module.module_eval {
      # list of all tokens that have been serialized within this VM
      # NOTE that elements are never removed from this list
      # the assumption is that the number of tokens that are serialized
      # is relatively small
      const_set_lazy(:SerializedTokens) { ArrayList.new }
      const_attr_reader  :SerializedTokens
    }
    
    typesig { [] }
    def write_replace
      if ((is_valid).equal?(false))
        raise NotSerializableException.new("Token has been removed")
      end
      return TokenRep.new(self)
    end
    
    class_module.module_eval {
      # serialized representation of a token
      # tokens can only be de-serialized within the same VM invocation
      # and if the token has not been removed in the meantime
      const_set_lazy(:TokenRep) { Class.new do
        include_class_members Token
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 3503721168218219807 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :token_id
        alias_method :attr_token_id, :token_id
        undef_method :token_id
        alias_method :attr_token_id=, :token_id=
        undef_method :token_id=
        
        typesig { [Token] }
        def initialize(token)
          @token_id = nil
          @token_id = token.get_token_id
        end
        
        typesig { [] }
        def read_resolve
          SerializedTokens.each do |tokenRef|
            token = token_ref.get
            if ((!(token).nil?) && token.is_valid)
              if ((Arrays == token.get_token_id))
                return token
              end
            end
          end
          raise NotSerializableException.new("Could not find token")
        end
        
        private
        alias_method :initialize__token_rep, :initialize
      end }
    }
    
    private
    alias_method :initialize__token, :initialize
  end
  
end

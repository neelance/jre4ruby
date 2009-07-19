require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11KeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include ::Java::Security::Spec
      include_const ::Sun::Security::Pkcs11::Wrapper, :PKCS11Exception
    }
  end
  
  # KeyFactory base class. Provides common infrastructure for the RSA, DSA,
  # and DH implementations.
  # 
  # The subclasses support conversion between keys and keyspecs
  # using X.509, PKCS#8, and their individual algorithm specific formats,
  # assuming keys are extractable.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11KeyFactory < P11KeyFactoryImports.const_get :KeyFactorySpi
    include_class_members P11KeyFactoryImports
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name, currently one of RSA, DSA, DH
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    typesig { [Token, String] }
    def initialize(token, algorithm)
      @token = nil
      @algorithm = nil
      super()
      @token = token
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      typesig { [Token, Key, String] }
      # Convert an arbitrary key of algorithm into a P11Key of token.
      # Used by P11Signature.init() and RSACipher.init().
      def convert_key(token, key, algorithm)
        return token.get_key_factory(algorithm).engine_translate_key(key)
      end
    }
    
    typesig { [Key, Class] }
    # see JCA spec
    def engine_get_key_spec(key, key_spec)
      @token.ensure_valid
      if (((key).nil?) || ((key_spec).nil?))
        raise InvalidKeySpecException.new("key and keySpec must not be null")
      end
      # delegate to our Java based providers for PKCS#8 and X.509
      if (PKCS8EncodedKeySpec.class.is_assignable_from(key_spec) || X509EncodedKeySpec.class.is_assignable_from(key_spec))
        begin
          return impl_get_software_factory.get_key_spec(key, key_spec)
        rescue GeneralSecurityException => e
          raise InvalidKeySpecException.new("Could not encode key", e)
        end
      end
      # first translate into a key of this token, if it is not already
      p11key = nil
      begin
        p11key = engine_translate_key(key)
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new("Could not convert key", e)
      end
      session = Array.typed(Session).new(1) { nil }
      begin
        if (p11key.is_public)
          return impl_get_public_key_spec(p11key, key_spec, session)
        else
          return impl_get_private_key_spec(p11key, key_spec, session)
        end
      rescue PKCS11Exception => e
        raise InvalidKeySpecException.new("Could not generate KeySpec", e)
      ensure
        session[0] = @token.release_session(session[0])
      end
    end
    
    typesig { [Key] }
    # see JCA spec
    def engine_translate_key(key)
      @token.ensure_valid
      if ((key).nil?)
        raise InvalidKeyException.new("Key must not be null")
      end
      if (((key.get_algorithm == @algorithm)).equal?(false))
        raise InvalidKeyException.new("Key algorithm must be " + @algorithm)
      end
      if (key.is_a?(P11Key))
        p11key = key
        if ((p11key.attr_token).equal?(@token))
          # already a key of this token, no need to translate
          return key
        end
      end
      p11key = @token.attr_private_cache.get(key)
      if (!(p11key).nil?)
        return p11key
      end
      if (key.is_a?(PublicKey))
        public_key = impl_translate_public_key(key)
        @token.attr_private_cache.put(key, public_key)
        return public_key
      else
        if (key.is_a?(PrivateKey))
          private_key = impl_translate_private_key(key)
          @token.attr_private_cache.put(key, private_key)
          return private_key
        else
          raise InvalidKeyException.new("Key must be instance of PublicKey or PrivateKey")
        end
      end
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_public_key_spec(key, key_spec, session)
      raise NotImplementedError
    end
    
    typesig { [P11Key, Class, Array.typed(Session)] }
    def impl_get_private_key_spec(key, key_spec, session)
      raise NotImplementedError
    end
    
    typesig { [PublicKey] }
    def impl_translate_public_key(key)
      raise NotImplementedError
    end
    
    typesig { [PrivateKey] }
    def impl_translate_private_key(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    def impl_get_software_factory
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__p11key_factory, :initialize
  end
  
end

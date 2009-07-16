require "rjava"

# 
# Copyright 2006-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ECDHCryptImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Security
      include_const ::Java::Security::Interfaces, :ECPublicKey
      include ::Java::Security::Spec
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto, :KeyAgreement
      include ::Javax::Crypto::Spec
    }
  end
  
  # 
  # Helper class for the ECDH key exchange. It generates the appropriate
  # ephemeral keys as necessary and performs the actual shared secret derivation.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECDHCrypt 
    include_class_members ECDHCryptImports
    
    # our private key
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    # our public key
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    typesig { [PrivateKey, PublicKey] }
    # Called by ServerHandshaker for static ECDH
    def initialize(private_key, public_key)
      @private_key = nil
      @public_key = nil
      @private_key = private_key
      @public_key = public_key
    end
    
    typesig { [String, SecureRandom] }
    # Called by ServerHandshaker for ephemeral ECDH
    def initialize(curve_name, random)
      @private_key = nil
      @public_key = nil
      begin
        kpg = JsseJce.get_key_pair_generator("EC")
        params = ECGenParameterSpec.new(curve_name)
        kpg.initialize_(params, random)
        kp = kpg.generate_key_pair
        @private_key = kp.get_private
        @public_key = kp.get_public
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate DH keypair", e)
      end
    end
    
    typesig { [ECParameterSpec, SecureRandom] }
    # Called by ClientHandshaker with params it received from the server
    def initialize(params, random)
      @private_key = nil
      @public_key = nil
      begin
        kpg = JsseJce.get_key_pair_generator("EC")
        kpg.initialize_(params, random)
        kp = kpg.generate_key_pair
        @private_key = kp.get_private
        @public_key = kp.get_public
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate DH keypair", e)
      end
    end
    
    typesig { [] }
    # 
    # Gets the public key of this end of the key exchange.
    def get_public_key
      return @public_key
    end
    
    typesig { [PublicKey] }
    # called by ClientHandshaker with either the server's static or ephemeral public key
    def get_agreed_secret(peer_public_key)
      begin
        ka = JsseJce.get_key_agreement("ECDH")
        ka.init(@private_key)
        ka.do_phase(peer_public_key, true)
        return ka.generate_secret("TlsPremasterSecret")
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate secret", e)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # called by ServerHandshaker
    def get_agreed_secret(encoded_point)
      begin
        params = @public_key.get_params
        point = JsseJce.decode_point(encoded_point, params.get_curve)
        kf = JsseJce.get_key_factory("EC")
        spec = ECPublicKeySpec.new(point, params)
        peer_public_key = kf.generate_public(spec)
        return get_agreed_secret(peer_public_key)
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate secret", e)
      rescue Java::Io::IOException => e
        raise RuntimeException.new("Could not generate secret", e_)
      end
    end
    
    private
    alias_method :initialize__ecdhcrypt, :initialize
  end
  
end

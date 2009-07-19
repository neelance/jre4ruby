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
  module DHCryptImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto, :KeyAgreement
      include_const ::Javax::Crypto::Interfaces, :DHPublicKey
      include ::Javax::Crypto::Spec
    }
  end
  
  # This class implements the Diffie-Hellman key exchange algorithm.
  # D-H means combining your private key with your partners public key to
  # generate a number. The peer does the same with its private key and our
  # public key. Through the magic of Diffie-Hellman we both come up with the
  # same number. This number is secret (discounting MITM attacks) and hence
  # called the shared secret. It has the same length as the modulus, e.g. 512
  # or 1024 bit. Man-in-the-middle attacks are typically countered by an
  # independent authentication step using certificates (RSA, DSA, etc.).
  # 
  # The thing to note is that the shared secret is constant for two partners
  # with constant private keys. This is often not what we want, which is why
  # it is generally a good idea to create a new private key for each session.
  # Generating a private key involves one modular exponentiation assuming
  # suitable D-H parameters are available.
  # 
  # General usage of this class (TLS DHE case):
  # . if we are server, call DHCrypt(keyLength,random). This generates
  # an ephemeral keypair of the request length.
  # . if we are client, call DHCrypt(modulus, base, random). This
  # generates an ephemeral keypair using the parameters specified by the server.
  # . send parameters and public value to remote peer
  # . receive peers ephemeral public key
  # . call getAgreedSecret() to calculate the shared secret
  # 
  # In TLS the server chooses the parameter values itself, the client must use
  # those sent to it by the server.
  # 
  # The use of ephemeral keys as described above also achieves what is called
  # "forward secrecy". This means that even if the authentication keys are
  # broken at a later date, the shared secret remains secure. The session is
  # compromised only if the authentication keys are already broken at the
  # time the key exchange takes place and an active MITM attack is used.
  # This is in contrast to straightforward encrypting RSA key exchanges.
  # 
  # @author David Brownell
  class DHCrypt 
    include_class_members DHCryptImports
    
    # group parameters (prime modulus and generator)
    attr_accessor :modulus
    alias_method :attr_modulus, :modulus
    undef_method :modulus
    alias_method :attr_modulus=, :modulus=
    undef_method :modulus=
    
    # P (aka N)
    attr_accessor :base
    alias_method :attr_base, :base
    undef_method :base
    alias_method :attr_base=, :base=
    undef_method :base=
    
    # G (aka alpha)
    # our private key (including private component x)
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    # public component of our key, X = (g ^ x) mod p
    attr_accessor :public_value
    alias_method :attr_public_value, :public_value
    undef_method :public_value
    alias_method :attr_public_value=, :public_value=
    undef_method :public_value=
    
    typesig { [::Java::Int, SecureRandom] }
    # X (aka y)
    # 
    # Generate a Diffie-Hellman keypair of the specified size.
    def initialize(key_length, random)
      @modulus = nil
      @base = nil
      @private_key = nil
      @public_value = nil
      begin
        kpg = JsseJce.get_key_pair_generator("DiffieHellman")
        kpg.initialize_(key_length, random)
        kp = kpg.generate_key_pair
        @private_key = kp.get_private
        spec = get_dhpublic_key_spec(kp.get_public)
        @public_value = spec.get_y
        @modulus = spec.get_p
        @base = spec.get_g
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate DH keypair", e)
      end
    end
    
    typesig { [BigInteger, BigInteger, SecureRandom] }
    # Generate a Diffie-Hellman keypair using the specified parameters.
    # 
    # @param modulus the Diffie-Hellman modulus P
    # @param base the Diffie-Hellman base G
    def initialize(modulus, base, random)
      @modulus = nil
      @base = nil
      @private_key = nil
      @public_value = nil
      @modulus = modulus
      @base = base
      begin
        kpg = JsseJce.get_key_pair_generator("DiffieHellman")
        params = DHParameterSpec.new(modulus, base)
        kpg.initialize_(params, random)
        kp = kpg.generate_key_pair
        @private_key = kp.get_private
        spec = get_dhpublic_key_spec(kp.get_public)
        @public_value = spec.get_y
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate DH keypair", e)
      end
    end
    
    class_module.module_eval {
      typesig { [PublicKey] }
      def get_dhpublic_key_spec(key)
        if (key.is_a?(DHPublicKey))
          dh_key = key
          params = dh_key.get_params
          return DHPublicKeySpec.new(dh_key.get_y, params.get_p, params.get_g)
        end
        begin
          factory = JsseJce.get_key_factory("DH")
          return factory.get_key_spec(key, DHPublicKeySpec.class)
        rescue Exception => e
          raise RuntimeException.new(e)
        end
      end
    }
    
    typesig { [] }
    # Returns the Diffie-Hellman modulus.
    def get_modulus
      return @modulus
    end
    
    typesig { [] }
    # Returns the Diffie-Hellman base (generator).
    def get_base
      return @base
    end
    
    typesig { [] }
    # Gets the public key of this end of the key exchange.
    def get_public_key
      return @public_value
    end
    
    typesig { [BigInteger] }
    # Get the secret data that has been agreed on through Diffie-Hellman
    # key agreement protocol.  Note that in the two party protocol, if
    # the peer keys are already known, no other data needs to be sent in
    # order to agree on a secret.  That is, a secured message may be
    # sent without any mandatory round-trip overheads.
    # 
    # <P>It is illegal to call this member function if the private key
    # has not been set (or generated).
    # 
    # @param peerPublicKey the peer's public key.
    # @returns the secret, which is an unsigned big-endian integer
    # the same size as the Diffie-Hellman modulus.
    def get_agreed_secret(peer_public_value)
      begin
        kf = JsseJce.get_key_factory("DiffieHellman")
        spec = DHPublicKeySpec.new(peer_public_value, @modulus, @base)
        public_key = kf.generate_public(spec)
        ka = JsseJce.get_key_agreement("DiffieHellman")
        ka.init(@private_key)
        ka.do_phase(public_key, true)
        return ka.generate_secret("TlsPremasterSecret")
      rescue GeneralSecurityException => e
        raise RuntimeException.new("Could not generate secret", e)
      end
    end
    
    private
    alias_method :initialize__dhcrypt, :initialize
  end
  
end

require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module KeyFactorySpiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Java::Security::Spec, :InvalidKeySpecException
    }
  end
  
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>KeyFactory</code> class.
  # All the abstract methods in this class must be implemented by each
  # cryptographic service provider who wishes to supply the implementation
  # of a key factory for a particular algorithm.
  # 
  # <P> Key factories are used to convert <I>keys</I> (opaque
  # cryptographic keys of type <code>Key</code>) into <I>key specifications</I>
  # (transparent representations of the underlying key material), and vice
  # versa.
  # 
  # <P> Key factories are bi-directional. That is, they allow you to build an
  # opaque key object from a given key specification (key material), or to
  # retrieve the underlying key material of a key object in a suitable format.
  # 
  # <P> Multiple compatible key specifications may exist for the same key.
  # For example, a DSA public key may be specified using
  # <code>DSAPublicKeySpec</code> or
  # <code>X509EncodedKeySpec</code>. A key factory can be used to translate
  # between compatible key specifications.
  # 
  # <P> A provider should document all the key specifications supported by its
  # key factory.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see KeyFactory
  # @see Key
  # @see PublicKey
  # @see PrivateKey
  # @see java.security.spec.KeySpec
  # @see java.security.spec.DSAPublicKeySpec
  # @see java.security.spec.X509EncodedKeySpec
  # 
  # @since 1.2
  class KeyFactorySpi 
    include_class_members KeyFactorySpiImports
    
    typesig { [KeySpec] }
    # Generates a public key object from the provided key
    # specification (key material).
    # 
    # @param keySpec the specification (key material) of the public key.
    # 
    # @return the public key.
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a public key.
    def engine_generate_public(key_spec)
      raise NotImplementedError
    end
    
    typesig { [KeySpec] }
    # Generates a private key object from the provided key
    # specification (key material).
    # 
    # @param keySpec the specification (key material) of the private key.
    # 
    # @return the private key.
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a private key.
    def engine_generate_private(key_spec)
      raise NotImplementedError
    end
    
    typesig { [Key, Class] }
    # Returns a specification (key material) of the given key
    # object.
    # <code>keySpec</code> identifies the specification class in which
    # the key material should be returned. It could, for example, be
    # <code>DSAPublicKeySpec.class</code>, to indicate that the
    # key material should be returned in an instance of the
    # <code>DSAPublicKeySpec</code> class.
    # 
    # @param key the key.
    # 
    # @param keySpec the specification class in which
    # the key material should be returned.
    # 
    # @return the underlying key specification (key material) in an instance
    # of the requested specification class.
    # 
    # @exception InvalidKeySpecException if the requested key specification is
    # inappropriate for the given key, or the given key cannot be dealt with
    # (e.g., the given key has an unrecognized format).
    def engine_get_key_spec(key, key_spec)
      raise NotImplementedError
    end
    
    typesig { [Key] }
    # Translates a key object, whose provider may be unknown or
    # potentially untrusted, into a corresponding key object of this key
    # factory.
    # 
    # @param key the key whose provider is unknown or untrusted.
    # 
    # @return the translated key.
    # 
    # @exception InvalidKeyException if the given key cannot be processed
    # by this key factory.
    def engine_translate_key(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__key_factory_spi, :initialize
  end
  
end

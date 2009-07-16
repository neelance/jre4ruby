require "rjava"

# 
# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SignedObjectImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
    }
  end
  
  # 
  # <p> SignedObject is a class for the purpose of creating authentic
  # runtime objects whose integrity cannot be compromised without being
  # detected.
  # 
  # <p> More specifically, a SignedObject contains another Serializable
  # object, the (to-be-)signed object and its signature.
  # 
  # <p> The signed object is a "deep copy" (in serialized form) of an
  # original object.  Once the copy is made, further manipulation of
  # the original object has no side effect on the copy.
  # 
  # <p> The underlying signing algorithm is designated by the Signature
  # object passed to the constructor and the <code>verify</code> method.
  # A typical usage for signing is the following:
  # 
  # <p> <code> <pre>
  # Signature signingEngine = Signature.getInstance(algorithm,
  # provider);
  # SignedObject so = new SignedObject(myobject, signingKey,
  # signingEngine);
  # </pre> </code>
  # 
  # <p> A typical usage for verification is the following (having
  # received SignedObject <code>so</code>):
  # 
  # <p> <code> <pre>
  # Signature verificationEngine =
  # Signature.getInstance(algorithm, provider);
  # if (so.verify(publickey, verificationEngine))
  # try {
  # Object myobj = so.getObject();
  # } catch (java.lang.ClassNotFoundException e) {};
  # </pre> </code>
  # 
  # <p> Several points are worth noting.  First, there is no need to
  # initialize the signing or verification engine, as it will be
  # re-initialized inside the constructor and the <code>verify</code>
  # method. Secondly, for verification to succeed, the specified
  # public key must be the public key corresponding to the private key
  # used to generate the SignedObject.
  # 
  # <p> More importantly, for flexibility reasons, the
  # constructor and <code>verify</code> method allow for
  # customized signature engines, which can implement signature
  # algorithms that are not installed formally as part of a crypto
  # provider.  However, it is crucial that the programmer writing the
  # verifier code be aware what <code>Signature</code> engine is being
  # used, as its own implementation of the <code>verify</code> method
  # is invoked to verify a signature.  In other words, a malicious
  # <code>Signature</code> may choose to always return true on
  # verification in an attempt to bypass a security check.
  # 
  # <p> The signature algorithm can be, among others, the NIST standard
  # DSA, using DSA and SHA-1.  The algorithm is specified using the
  # same convention as that for signatures. The DSA algorithm using the
  # SHA-1 message digest algorithm can be specified, for example, as
  # "SHA/DSA" or "SHA-1/DSA" (they are equivalent).  In the case of
  # RSA, there are multiple choices for the message digest algorithm,
  # so the signing algorithm could be specified as, for example,
  # "MD2/RSA", "MD5/RSA" or "SHA-1/RSA".  The algorithm name must be
  # specified, as there is no default.
  # 
  # <p> The name of the Cryptography Package Provider is designated
  # also by the Signature parameter to the constructor and the
  # <code>verify</code> method.  If the provider is not
  # specified, the default provider is used.  Each installation can
  # be configured to use a particular provider as default.
  # 
  # <p> Potential applications of SignedObject include:
  # <ul>
  # <li> It can be used
  # internally to any Java runtime as an unforgeable authorization
  # token -- one that can be passed around without the fear that the
  # token can be maliciously modified without being detected.
  # <li> It
  # can be used to sign and serialize data/object for storage outside
  # the Java runtime (e.g., storing critical access control data on
  # disk).
  # <li> Nested SignedObjects can be used to construct a logical
  # sequence of signatures, resembling a chain of authorization and
  # delegation.
  # </ul>
  # 
  # @see Signature
  # 
  # @author Li Gong
  class SignedObject 
    include_class_members SignedObjectImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 720502720485447167 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # The original content is "deep copied" in its serialized format
    # and stored in a byte array.  The signature field is also in the
    # form of byte array.
    attr_accessor :content
    alias_method :attr_content, :content
    undef_method :content
    alias_method :attr_content=, :content=
    undef_method :content=
    
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    attr_accessor :thealgorithm
    alias_method :attr_thealgorithm, :thealgorithm
    undef_method :thealgorithm
    alias_method :attr_thealgorithm=, :thealgorithm=
    undef_method :thealgorithm=
    
    typesig { [Serializable, PrivateKey, Signature] }
    # 
    # Constructs a SignedObject from any Serializable object.
    # The given object is signed with the given signing key, using the
    # designated signature engine.
    # 
    # @param object the object to be signed.
    # @param signingKey the private key for signing.
    # @param signingEngine the signature signing engine.
    # 
    # @exception IOException if an error occurs during serialization
    # @exception InvalidKeyException if the key is invalid.
    # @exception SignatureException if signing fails.
    def initialize(object, signing_key, signing_engine)
      @content = nil
      @signature = nil
      @thealgorithm = nil
      # creating a stream pipe-line, from a to b
      b = ByteArrayOutputStream.new
      a = ObjectOutputStream.new(b)
      # write and flush the object content to byte array
      a.write_object(object)
      a.flush
      a.close
      @content = b.to_byte_array
      b.close
      # now sign the encapsulated object
      self.sign(signing_key, signing_engine)
    end
    
    typesig { [] }
    # 
    # Retrieves the encapsulated object.
    # The encapsulated object is de-serialized before it is returned.
    # 
    # @return the encapsulated object.
    # 
    # @exception IOException if an error occurs during de-serialization
    # @exception ClassNotFoundException if an error occurs during
    # de-serialization
    def get_object
      # creating a stream pipe-line, from b to a
      b = ByteArrayInputStream.new(@content)
      a = ObjectInputStream.new(b)
      obj = a.read_object
      b.close
      a.close
      return obj
    end
    
    typesig { [] }
    # 
    # Retrieves the signature on the signed object, in the form of a
    # byte array.
    # 
    # @return the signature. Returns a new array each time this
    # method is called.
    def get_signature
      return @signature.clone
    end
    
    typesig { [] }
    # 
    # Retrieves the name of the signature algorithm.
    # 
    # @return the signature algorithm name.
    def get_algorithm
      return @thealgorithm
    end
    
    typesig { [PublicKey, Signature] }
    # 
    # Verifies that the signature in this SignedObject is the valid
    # signature for the object stored inside, with the given
    # verification key, using the designated verification engine.
    # 
    # @param verificationKey the public key for verification.
    # @param verificationEngine the signature verification engine.
    # 
    # @exception SignatureException if signature verification failed.
    # @exception InvalidKeyException if the verification key is invalid.
    # 
    # @return <tt>true</tt> if the signature
    # is valid, <tt>false</tt> otherwise
    def verify(verification_key, verification_engine)
      verification_engine.init_verify(verification_key)
      verification_engine.update(@content.clone)
      return verification_engine.verify(@signature.clone)
    end
    
    typesig { [PrivateKey, Signature] }
    # 
    # Signs the encapsulated object with the given signing key, using the
    # designated signature engine.
    # 
    # @param signingKey the private key for signing.
    # @param signingEngine the signature signing engine.
    # 
    # @exception InvalidKeyException if the key is invalid.
    # @exception SignatureException if signing fails.
    def sign(signing_key, signing_engine)
      # initialize the signing engine
      signing_engine.init_sign(signing_key)
      signing_engine.update(@content.clone)
      @signature = signing_engine.sign.clone
      @thealgorithm = signing_engine.get_algorithm
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # 
    # readObject is called to restore the state of the SignedObject from
    # a stream.
    def read_object(s)
      s.default_read_object
      @content = @content.clone
      @signature = @signature.clone
    end
    
    private
    alias_method :initialize__signed_object, :initialize
  end
  
end

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
module Java::Security
  module KeyRepImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Security::Spec, :PKCS8EncodedKeySpec
      include_const ::Java::Security::Spec, :X509EncodedKeySpec
      include_const ::Java::Security::Spec, :InvalidKeySpecException
      include_const ::Javax::Crypto, :SecretKeyFactory
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
    }
  end
  
  # Standardized representation for serialized Key objects.
  # 
  # <p>
  # 
  # Note that a serialized Key may contain sensitive information
  # which should not be exposed in untrusted environments.  See the
  # <a href="../../../platform/serialization/spec/security.html">
  # Security Appendix</a>
  # of the Serialization Specification for more information.
  # 
  # @see Key
  # @see KeyFactory
  # @see javax.crypto.spec.SecretKeySpec
  # @see java.security.spec.X509EncodedKeySpec
  # @see java.security.spec.PKCS8EncodedKeySpec
  # 
  # @since 1.5
  class KeyRep 
    include_class_members KeyRepImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -4757683898830641853 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:SECRET) { Type::SECRET }
      const_attr_reader  :SECRET
      
      const_set_lazy(:PUBLIC) { Type::PUBLIC }
      const_attr_reader  :PUBLIC
      
      const_set_lazy(:PRIVATE) { Type::PRIVATE }
      const_attr_reader  :PRIVATE
      
      # Key type.
      # 
      # @since 1.5
      class Type 
        include_class_members KeyRep
        
        class_module.module_eval {
          # Type for secret keys.
          const_set_lazy(:SECRET) { Type.new.set_value_name("SECRET") }
          const_attr_reader  :SECRET
          
          # Type for public keys.
          const_set_lazy(:PUBLIC) { Type.new.set_value_name("PUBLIC") }
          const_attr_reader  :PUBLIC
          
          # Type for private keys.
          const_set_lazy(:PRIVATE) { Type.new.set_value_name("PRIVATE") }
          const_attr_reader  :PRIVATE
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
            [SECRET, PUBLIC, PRIVATE]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__type, :initialize
      end
      
      const_set_lazy(:PKCS8) { "PKCS#8" }
      const_attr_reader  :PKCS8
      
      const_set_lazy(:X509) { "X.509" }
      const_attr_reader  :X509
      
      const_set_lazy(:RAW) { "RAW" }
      const_attr_reader  :RAW
    }
    
    # Either one of Type.SECRET, Type.PUBLIC, or Type.PRIVATE
    # 
    # @serial
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # The Key algorithm
    # 
    # @serial
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # The Key encoding format
    # 
    # @serial
    attr_accessor :format
    alias_method :attr_format, :format
    undef_method :format
    alias_method :attr_format=, :format=
    undef_method :format=
    
    # The encoded Key bytes
    # 
    # @serial
    attr_accessor :encoded
    alias_method :attr_encoded, :encoded
    undef_method :encoded
    alias_method :attr_encoded=, :encoded=
    undef_method :encoded=
    
    typesig { [Type, String, String, Array.typed(::Java::Byte)] }
    # Construct the alternate Key class.
    # 
    # <p>
    # 
    # @param type either one of Type.SECRET, Type.PUBLIC, or Type.PRIVATE
    # @param algorithm the algorithm returned from
    # <code>Key.getAlgorithm()</code>
    # @param format the encoding format returned from
    # <code>Key.getFormat()</code>
    # @param encoded the encoded bytes returned from
    # <code>Key.getEncoded()</code>
    # 
    # @exception NullPointerException
    # if type is <code>null</code>,
    # if algorithm is <code>null</code>,
    # if format is <code>null</code>,
    # or if encoded is <code>null</code>
    def initialize(type, algorithm, format, encoded)
      @type = nil
      @algorithm = nil
      @format = nil
      @encoded = nil
      if ((type).nil? || (algorithm).nil? || (format).nil? || (encoded).nil?)
        raise NullPointerException.new("invalid null input(s)")
      end
      @type = type
      @algorithm = algorithm
      @format = format.to_upper_case
      @encoded = encoded.clone
    end
    
    typesig { [] }
    # Resolve the Key object.
    # 
    # <p> This method supports three Type/format combinations:
    # <ul>
    # <li> Type.SECRET/"RAW" - returns a SecretKeySpec object
    # constructed using encoded key bytes and algorithm
    # <li> Type.PUBLIC/"X.509" - gets a KeyFactory instance for
    # the key algorithm, constructs an X509EncodedKeySpec with the
    # encoded key bytes, and generates a public key from the spec
    # <li> Type.PRIVATE/"PKCS#8" - gets a KeyFactory instance for
    # the key algorithm, constructs a PKCS8EncodedKeySpec with the
    # encoded key bytes, and generates a private key from the spec
    # </ul>
    # 
    # <p>
    # 
    # @return the resolved Key object
    # 
    # @exception ObjectStreamException if the Type/format
    # combination is unrecognized, if the algorithm, key format, or
    # encoded key bytes are unrecognized/invalid, of if the
    # resolution of the key fails for any reason
    def read_resolve
      begin
        if ((@type).equal?(Type::SECRET) && (RAW == @format))
          return SecretKeySpec.new(@encoded, @algorithm)
        else
          if ((@type).equal?(Type::PUBLIC) && (X509 == @format))
            f = KeyFactory.get_instance(@algorithm)
            return f.generate_public(X509EncodedKeySpec.new(@encoded))
          else
            if ((@type).equal?(Type::PRIVATE) && (PKCS8 == @format))
              f = KeyFactory.get_instance(@algorithm)
              return f.generate_private(PKCS8EncodedKeySpec.new(@encoded))
            else
              raise NotSerializableException.new("unrecognized type/format combination: " + (@type).to_s + "/" + @format)
            end
          end
        end
      rescue NotSerializableException => nse
        raise nse
      rescue Exception => e
        nse = NotSerializableException.new("java.security.Key: " + "[" + (@type).to_s + "] " + "[" + @algorithm + "] " + "[" + @format + "]")
        nse.init_cause(e)
        raise nse
      end
    end
    
    private
    alias_method :initialize__key_rep, :initialize
  end
  
end

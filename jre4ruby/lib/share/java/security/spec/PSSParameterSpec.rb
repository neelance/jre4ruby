require "rjava"

# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Spec
  module PSSParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security::Spec, :MGF1ParameterSpec
    }
  end
  
  # This class specifies a parameter spec for RSA-PSS signature scheme,
  # as defined in the
  # <a href="http://www.ietf.org/rfc/rfc3447.txt">PKCS#1 v2.1</a>
  # standard.
  # 
  # <p>Its ASN.1 definition in PKCS#1 standard is described below:
  # <pre>
  # RSASSA-PSS-params ::= SEQUENCE {
  # hashAlgorithm      [0] OAEP-PSSDigestAlgorithms  DEFAULT sha1,
  # maskGenAlgorithm   [1] PKCS1MGFAlgorithms  DEFAULT mgf1SHA1,
  # saltLength         [2] INTEGER  DEFAULT 20,
  # trailerField       [3] INTEGER  DEFAULT 1
  # }
  # </pre>
  # where
  # <pre>
  # OAEP-PSSDigestAlgorithms    ALGORITHM-IDENTIFIER ::= {
  # { OID id-sha1 PARAMETERS NULL   }|
  # { OID id-sha256 PARAMETERS NULL }|
  # { OID id-sha384 PARAMETERS NULL }|
  # { OID id-sha512 PARAMETERS NULL },
  # ...  -- Allows for future expansion --
  # }
  # 
  # PKCS1MGFAlgorithms    ALGORITHM-IDENTIFIER ::= {
  # { OID id-mgf1 PARAMETERS OAEP-PSSDigestAlgorithms },
  # ...  -- Allows for future expansion --
  # }
  # </pre>
  # <p>Note: the PSSParameterSpec.DEFAULT uses the following:
  # message digest  -- "SHA-1"
  # mask generation function (mgf) -- "MGF1"
  # parameters for mgf -- MGF1ParameterSpec.SHA1
  # SaltLength   -- 20
  # TrailerField -- 1
  # 
  # @see MGF1ParameterSpec
  # @see AlgorithmParameterSpec
  # @see java.security.Signature
  # 
  # @author Valerie Peng
  # 
  # 
  # @since 1.4
  class PSSParameterSpec 
    include_class_members PSSParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :md_name
    alias_method :attr_md_name, :md_name
    undef_method :md_name
    alias_method :attr_md_name=, :md_name=
    undef_method :md_name=
    
    attr_accessor :mgf_name
    alias_method :attr_mgf_name, :mgf_name
    undef_method :mgf_name
    alias_method :attr_mgf_name=, :mgf_name=
    undef_method :mgf_name=
    
    attr_accessor :mgf_spec
    alias_method :attr_mgf_spec, :mgf_spec
    undef_method :mgf_spec
    alias_method :attr_mgf_spec=, :mgf_spec=
    undef_method :mgf_spec=
    
    attr_accessor :salt_len
    alias_method :attr_salt_len, :salt_len
    undef_method :salt_len
    alias_method :attr_salt_len=, :salt_len=
    undef_method :salt_len=
    
    attr_accessor :trailer_field
    alias_method :attr_trailer_field, :trailer_field
    undef_method :trailer_field
    alias_method :attr_trailer_field=, :trailer_field=
    undef_method :trailer_field=
    
    class_module.module_eval {
      # The PSS parameter set with all default values.
      # @since 1.5
      const_set_lazy(:DEFAULT) { PSSParameterSpec.new }
      const_attr_reader  :DEFAULT
    }
    
    typesig { [] }
    # Constructs a new <code>PSSParameterSpec</code> as defined in
    # the PKCS #1 standard using the default values.
    def initialize
      @md_name = "SHA-1"
      @mgf_name = "MGF1"
      @mgf_spec = MGF1ParameterSpec::SHA1
      @salt_len = 20
      @trailer_field = 1
    end
    
    typesig { [String, String, AlgorithmParameterSpec, ::Java::Int, ::Java::Int] }
    # Creates a new <code>PSSParameterSpec</code> as defined in
    # the PKCS #1 standard using the specified message digest,
    # mask generation function, parameters for mask generation
    # function, salt length, and trailer field values.
    # 
    # @param mdName the algorithm name of the hash function.
    # @param mgfName the algorithm name of the mask generation
    # function.
    # @param mgfSpec the parameters for the mask generation
    # function. If null is specified, null will be returned by
    # getMGFParameters().
    # @param saltLen the length of salt.
    # @param trailerField the value of the trailer field.
    # @exception NullPointerException if <code>mdName</code>,
    # or <code>mgfName</code> is null.
    # @exception IllegalArgumentException if <code>saltLen</code>
    # or <code>trailerField</code> is less than 0.
    # @since 1.5
    def initialize(md_name, mgf_name, mgf_spec, salt_len, trailer_field)
      @md_name = "SHA-1"
      @mgf_name = "MGF1"
      @mgf_spec = MGF1ParameterSpec::SHA1
      @salt_len = 20
      @trailer_field = 1
      if ((md_name).nil?)
        raise NullPointerException.new("digest algorithm is null")
      end
      if ((mgf_name).nil?)
        raise NullPointerException.new("mask generation function " + "algorithm is null")
      end
      if (salt_len < 0)
        raise IllegalArgumentException.new("negative saltLen value: " + RJava.cast_to_string(salt_len))
      end
      if (trailer_field < 0)
        raise IllegalArgumentException.new("negative trailerField: " + RJava.cast_to_string(trailer_field))
      end
      @md_name = md_name
      @mgf_name = mgf_name
      @mgf_spec = mgf_spec
      @salt_len = salt_len
      @trailer_field = trailer_field
    end
    
    typesig { [::Java::Int] }
    # Creates a new <code>PSSParameterSpec</code>
    # using the specified salt length and other default values as
    # defined in PKCS#1.
    # 
    # @param saltLen the length of salt in bits to be used in PKCS#1
    # PSS encoding.
    # @exception IllegalArgumentException if <code>saltLen</code> is
    # less than 0.
    def initialize(salt_len)
      @md_name = "SHA-1"
      @mgf_name = "MGF1"
      @mgf_spec = MGF1ParameterSpec::SHA1
      @salt_len = 20
      @trailer_field = 1
      if (salt_len < 0)
        raise IllegalArgumentException.new("negative saltLen value: " + RJava.cast_to_string(salt_len))
      end
      @salt_len = salt_len
    end
    
    typesig { [] }
    # Returns the message digest algorithm name.
    # 
    # @return the message digest algorithm name.
    # @since 1.5
    def get_digest_algorithm
      return @md_name
    end
    
    typesig { [] }
    # Returns the mask generation function algorithm name.
    # 
    # @return the mask generation function algorithm name.
    # 
    # @since 1.5
    def get_mgfalgorithm
      return @mgf_name
    end
    
    typesig { [] }
    # Returns the parameters for the mask generation function.
    # 
    # @return the parameters for the mask generation function.
    # @since 1.5
    def get_mgfparameters
      return @mgf_spec
    end
    
    typesig { [] }
    # Returns the salt length in bits.
    # 
    # @return the salt length.
    def get_salt_length
      return @salt_len
    end
    
    typesig { [] }
    # Returns the value for the trailer field, i.e. bc in PKCS#1 v2.1.
    # 
    # @return the value for the trailer field, i.e. bc in PKCS#1 v2.1.
    # @since 1.5
    def get_trailer_field
      return @trailer_field
    end
    
    private
    alias_method :initialize__pssparameter_spec, :initialize
  end
  
end

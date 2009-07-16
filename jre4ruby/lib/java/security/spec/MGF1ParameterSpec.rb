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
module Java::Security::Spec
  module MGF1ParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
    }
  end
  
  # 
  # This class specifies the set of parameters used with mask generation
  # function MGF1 in OAEP Padding and RSA-PSS signature scheme, as
  # defined in the
  # <a href="http://www.ietf.org/rfc/rfc3447.txt">PKCS #1 v2.1</a>
  # standard.
  # 
  # <p>Its ASN.1 definition in PKCS#1 standard is described below:
  # <pre>
  # MGF1Parameters ::= OAEP-PSSDigestAlgorthms
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
  # </pre>
  # @see PSSParameterSpec
  # @see javax.crypto.spec.OAEPParameterSpec
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class MGF1ParameterSpec 
    include_class_members MGF1ParameterSpecImports
    include AlgorithmParameterSpec
    
    class_module.module_eval {
      # 
      # The MGF1ParameterSpec which uses "SHA-1" message digest.
      const_set_lazy(:SHA1) { MGF1ParameterSpec.new("SHA-1") }
      const_attr_reader  :SHA1
      
      # 
      # The MGF1ParameterSpec which uses "SHA-256" message digest.
      const_set_lazy(:SHA256) { MGF1ParameterSpec.new("SHA-256") }
      const_attr_reader  :SHA256
      
      # 
      # The MGF1ParameterSpec which uses "SHA-384" message digest.
      const_set_lazy(:SHA384) { MGF1ParameterSpec.new("SHA-384") }
      const_attr_reader  :SHA384
      
      # 
      # The MGF1ParameterSpec which uses SHA-512 message digest.
      const_set_lazy(:SHA512) { MGF1ParameterSpec.new("SHA-512") }
      const_attr_reader  :SHA512
    }
    
    attr_accessor :md_name
    alias_method :attr_md_name, :md_name
    undef_method :md_name
    alias_method :attr_md_name=, :md_name=
    undef_method :md_name=
    
    typesig { [String] }
    # 
    # Constructs a parameter set for mask generation function MGF1
    # as defined in the PKCS #1 standard.
    # 
    # @param mdName the algorithm name for the message digest
    # used in this mask generation function MGF1.
    # @exception NullPointerException if <code>mdName</code> is null.
    def initialize(md_name)
      @md_name = nil
      if ((md_name).nil?)
        raise NullPointerException.new("digest algorithm is null")
      end
      @md_name = md_name
    end
    
    typesig { [] }
    # 
    # Returns the algorithm name of the message digest used by the mask
    # generation function.
    # 
    # @return the algorithm name of the message digest.
    def get_digest_algorithm
      return @md_name
    end
    
    private
    alias_method :initialize__mgf1parameter_spec, :initialize
  end
  
end

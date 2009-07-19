require "rjava"

# reserved comment block
# DO NOT REMOVE OR ALTER!
# 
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
# include the following acknowledgment:
# 
# "This product includes software developed by IAIK of Graz University of
# Technology."
# 
# Alternately, this acknowledgment may appear in the software itself, if
# and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
# Technology" must not be used to endorse or promote products derived from
# this software without prior written permission.
# 
# 5. Products derived from this software may not be called
# "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
# written permission of Graz University of Technology.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module CK_RSA_PKCS_OAEP_PARAMSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_RSA_PKCS_OAEP_PARAMS provides the parameters to the
  # CKM_RSA_PKCS_OAEP mechanism.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_RSA_PKCS_OAEP_PARAMS {
  # CK_MECHANISM_TYPE hashAlg;
  # CK_RSA_PKCS_OAEP_MGF_TYPE mgf;
  # CK_RSA_PKCS_OAEP_SOURCE_TYPE source;
  # CK_VOID_PTR pSourceData;
  # CK_ULONG ulSourceDataLen;
  # } CK_RSA_PKCS_OAEP_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_RSA_PKCS_OAEP_PARAMS 
    include_class_members CK_RSA_PKCS_OAEP_PARAMSImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_MECHANISM_TYPE hashAlg;
    # </PRE>
    attr_accessor :hash_alg
    alias_method :attr_hash_alg, :hash_alg
    undef_method :hash_alg
    alias_method :attr_hash_alg=, :hash_alg=
    undef_method :hash_alg=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_RSA_PKCS_OAEP_MGF_TYPE mgf;
    # </PRE>
    attr_accessor :mgf
    alias_method :attr_mgf, :mgf
    undef_method :mgf
    alias_method :attr_mgf=, :mgf=
    undef_method :mgf=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_RSA_PKCS_OAEP_SOURCE_TYPE source;
    # </PRE>
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VOID_PTR pSourceData;
    # CK_ULONG ulSourceDataLen;
    # </PRE>
    attr_accessor :p_source_data
    alias_method :attr_p_source_data, :p_source_data
    undef_method :p_source_data
    alias_method :attr_p_source_data=, :p_source_data=
    undef_method :p_source_data=
    
    typesig { [] }
    # CK_ULONG ulSourceDataLen;
    # ulSourceDataLen == pSourceData.length
    # 
    # Returns the string representation of CK_RSA_PKCS_OAEP_PARAMS.
    # 
    # @return the string representation of CK_RSA_PKCS_OAEP_PARAMS
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("hashAlg: ")
      buffer.append(@hash_alg)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("mgf: ")
      buffer.append(@mgf)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("source: ")
      buffer.append(@source)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pSourceData: ")
      buffer.append(@p_source_data.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pSourceDataLen: ")
      buffer.append(Functions.to_hex_string(@p_source_data))
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    typesig { [] }
    def initialize
      @hash_alg = 0
      @mgf = 0
      @source = 0
      @p_source_data = nil
    end
    
    private
    alias_method :initialize__ck_rsa_pkcs_oaep_params, :initialize
  end
  
end

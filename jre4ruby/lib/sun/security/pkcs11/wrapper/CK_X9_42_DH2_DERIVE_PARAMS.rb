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
  module CK_X9_42_DH2_DERIVE_PARAMSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_X9_42_DH2_DERIVE_PARAMS provides the parameters to the
  # CKM_X9_42_DH_HYBRID_DERIVE and CKM_X9_42_MQV_DERIVE mechanisms.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_X9_42_DH2_DERIVE_PARAMS {
  # CK_X9_42_DH_KDF_TYPE kdf;
  # CK_ULONG ulOtherInfoLen;
  # CK_BYTE_PTR pOtherInfo;
  # CK_ULONG ulPublicDataLen;
  # CK_BYTE_PTR pPublicData;
  # CK_ULONG ulPrivateDataLen;
  # CK_OBJECT_HANDLE hPrivateData;
  # CK_ULONG ulPublicDataLen2;
  # CK_BYTE_PTR pPublicData2;
  # } CK_X9_42_DH2_DERIVE_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  class CK_X9_42_DH2_DERIVE_PARAMS 
    include_class_members CK_X9_42_DH2_DERIVE_PARAMSImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_X9_42_DH_KDF_TYPE kdf;
    # </PRE>
    attr_accessor :kdf
    alias_method :attr_kdf, :kdf
    undef_method :kdf
    alias_method :attr_kdf=, :kdf=
    undef_method :kdf=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulOtherInfoLen;
    # CK_BYTE_PTR pOtherInfo;
    # </PRE>
    attr_accessor :p_other_info
    alias_method :attr_p_other_info, :p_other_info
    undef_method :p_other_info
    alias_method :attr_p_other_info=, :p_other_info=
    undef_method :p_other_info=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulPublicDataLen;
    # CK_BYTE_PTR pPublicData;
    # </PRE>
    attr_accessor :p_public_data
    alias_method :attr_p_public_data, :p_public_data
    undef_method :p_public_data
    alias_method :attr_p_public_data=, :p_public_data=
    undef_method :p_public_data=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulPrivateDataLen;
    # </PRE>
    attr_accessor :ul_private_data_len
    alias_method :attr_ul_private_data_len, :ul_private_data_len
    undef_method :ul_private_data_len
    alias_method :attr_ul_private_data_len=, :ul_private_data_len=
    undef_method :ul_private_data_len=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_OBJECT_HANDLE hPrivateData;
    # </PRE>
    attr_accessor :h_private_data
    alias_method :attr_h_private_data, :h_private_data
    undef_method :h_private_data
    alias_method :attr_h_private_data=, :h_private_data=
    undef_method :h_private_data=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulPublicDataLen2;
    # CK_BYTE_PTR pPublicData2;
    # </PRE>
    attr_accessor :p_public_data2
    alias_method :attr_p_public_data2, :p_public_data2
    undef_method :p_public_data2
    alias_method :attr_p_public_data2=, :p_public_data2=
    undef_method :p_public_data2=
    
    typesig { [] }
    # Returns the string representation of CK_PKCS5_PBKD2_PARAMS.
    # 
    # @return the string representation of CK_PKCS5_PBKD2_PARAMS
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("kdf: 0x")
      buffer.append(Functions.to_full_hex_string(@kdf))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pOtherInfoLen: ")
      buffer.append(@p_other_info.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pOtherInfo: ")
      buffer.append(Functions.to_hex_string(@p_other_info))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPublicDataLen: ")
      buffer.append(@p_public_data.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPublicData: ")
      buffer.append(Functions.to_hex_string(@p_public_data))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulPrivateDataLen: ")
      buffer.append(@ul_private_data_len)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("hPrivateData: ")
      buffer.append(@h_private_data)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPublicDataLen2: ")
      buffer.append(@p_public_data2.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPublicData2: ")
      buffer.append(Functions.to_hex_string(@p_public_data2))
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    typesig { [] }
    def initialize
      @kdf = 0
      @p_other_info = nil
      @p_public_data = nil
      @ul_private_data_len = 0
      @h_private_data = 0
      @p_public_data2 = nil
    end
    
    private
    alias_method :initialize__ck_x9_42_dh2_derive_params, :initialize
  end
  
end

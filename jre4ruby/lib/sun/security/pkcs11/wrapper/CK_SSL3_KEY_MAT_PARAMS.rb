require "rjava"

# 
# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CK_SSL3_KEY_MAT_PARAMSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class CK_SSL3_KEY_MAT_PARAMS provides the parameters to the
  # CKM_SSL3_KEY_AND_MAC_DERIVE mechanism.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_SSL3_KEY_MAT_PARAMS {
  # CK_ULONG ulMacSizeInBits;
  # CK_ULONG ulKeySizeInBits;
  # CK_ULONG ulIVSizeInBits;
  # CK_BBOOL bIsExport;
  # CK_SSL3_RANDOM_DATA RandomInfo;
  # CK_SSL3_KEY_MAT_OUT_PTR pReturnedKeyMaterial;
  # } CK_SSL3_KEY_MAT_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_SSL3_KEY_MAT_PARAMS 
    include_class_members CK_SSL3_KEY_MAT_PARAMSImports
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMacSizeInBits;
    # </PRE>
    attr_accessor :ul_mac_size_in_bits
    alias_method :attr_ul_mac_size_in_bits, :ul_mac_size_in_bits
    undef_method :ul_mac_size_in_bits
    alias_method :attr_ul_mac_size_in_bits=, :ul_mac_size_in_bits=
    undef_method :ul_mac_size_in_bits=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulKeySizeInBits;
    # </PRE>
    attr_accessor :ul_key_size_in_bits
    alias_method :attr_ul_key_size_in_bits, :ul_key_size_in_bits
    undef_method :ul_key_size_in_bits
    alias_method :attr_ul_key_size_in_bits=, :ul_key_size_in_bits=
    undef_method :ul_key_size_in_bits=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulIVSizeInBits;
    # </PRE>
    attr_accessor :ul_ivsize_in_bits
    alias_method :attr_ul_ivsize_in_bits, :ul_ivsize_in_bits
    undef_method :ul_ivsize_in_bits
    alias_method :attr_ul_ivsize_in_bits=, :ul_ivsize_in_bits=
    undef_method :ul_ivsize_in_bits=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_BBOOL bIsExport;
    # </PRE>
    attr_accessor :b_is_export
    alias_method :attr_b_is_export, :b_is_export
    undef_method :b_is_export
    alias_method :attr_b_is_export=, :b_is_export=
    undef_method :b_is_export=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_SSL3_RANDOM_DATA RandomInfo;
    # </PRE>
    attr_accessor :random_info
    alias_method :attr_random_info, :random_info
    undef_method :random_info
    alias_method :attr_random_info=, :random_info=
    undef_method :random_info=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_SSL3_KEY_MAT_OUT_PTR pReturnedKeyMaterial;
    # </PRE>
    attr_accessor :p_returned_key_material
    alias_method :attr_p_returned_key_material, :p_returned_key_material
    undef_method :p_returned_key_material
    alias_method :attr_p_returned_key_material=, :p_returned_key_material=
    undef_method :p_returned_key_material=
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean, CK_SSL3_RANDOM_DATA] }
    def initialize(mac_size, key_size, iv_size, export, random)
      @ul_mac_size_in_bits = 0
      @ul_key_size_in_bits = 0
      @ul_ivsize_in_bits = 0
      @b_is_export = false
      @random_info = nil
      @p_returned_key_material = nil
      @ul_mac_size_in_bits = mac_size
      @ul_key_size_in_bits = key_size
      @ul_ivsize_in_bits = iv_size
      @b_is_export = export
      @random_info = random
      @p_returned_key_material = CK_SSL3_KEY_MAT_OUT.new
      if (!(iv_size).equal?(0))
        n = iv_size >> 3
        @p_returned_key_material.attr_p_ivclient = Array.typed(::Java::Byte).new(n) { 0 }
        @p_returned_key_material.attr_p_ivserver = Array.typed(::Java::Byte).new(n) { 0 }
      end
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_SSL3_KEY_MAT_PARAMS.
    # 
    # @return the string representation of CK_SSL3_KEY_MAT_PARAMS
    def to_s
      buffer = StringBuilder.new
      buffer.append(Constants::INDENT)
      buffer.append("ulMacSizeInBits: ")
      buffer.append(@ul_mac_size_in_bits)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulKeySizeInBits: ")
      buffer.append(@ul_key_size_in_bits)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulIVSizeInBits: ")
      buffer.append(@ul_ivsize_in_bits)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("bIsExport: ")
      buffer.append(@b_is_export)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("RandomInfo: ")
      buffer.append(@random_info)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pReturnedKeyMaterial: ")
      buffer.append(@p_returned_key_material)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_ssl3_key_mat_params, :initialize
  end
  
end

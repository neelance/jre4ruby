require "rjava"

# reserved comment block
# DO NOT REMOVE OR ALTER!
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
#    include the following acknowledgment:
# 
#    "This product includes software developed by IAIK of Graz University of
#     Technology."
# 
#    Alternately, this acknowledgment may appear in the software itself, if
#    and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
#    Technology" must not be used to endorse or promote products derived from
#    this software without prior written permission.
# 
# 5. Products derived from this software may not be called
#    "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
#    written permission of Graz University of Technology.
# 
#  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
#  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module CK_PKCS5_PBKD2_PARAMSImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_PKCS5_PBKD2_PARAMS provides the parameters to the CKM_PKCS5_PBKD2
  # mechanism.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_PKCS5_PBKD2_PARAMS {
  #   CK_PKCS5_PBKD2_SALT_SOURCE_TYPE saltSource;
  #   CK_VOID_PTR pSaltSourceData;
  #   CK_ULONG ulSaltSourceDataLen;
  #   CK_ULONG iterations;
  #   CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE prf;
  #   CK_VOID_PTR pPrfData;
  #   CK_ULONG ulPrfDataLen;
  # } CK_PKCS5_PBKD2_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_PKCS5_PBKD2_PARAMS 
    include_class_members CK_PKCS5_PBKD2_PARAMSImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    #   CK_PKCS5_PBKDF2_SALT_SOURCE_TYPE saltSource;
    # </PRE>
    attr_accessor :salt_source
    alias_method :attr_salt_source, :salt_source
    undef_method :salt_source
    alias_method :attr_salt_source=, :salt_source=
    undef_method :salt_source=
    
    # <B>PKCS#11:</B>
    # <PRE>
    #   CK_VOID_PTR pSaltSourceData;
    #   CK_ULONG ulSaltSourceDataLen;
    # </PRE>
    attr_accessor :p_salt_source_data
    alias_method :attr_p_salt_source_data, :p_salt_source_data
    undef_method :p_salt_source_data
    alias_method :attr_p_salt_source_data=, :p_salt_source_data=
    undef_method :p_salt_source_data=
    
    # <B>PKCS#11:</B>
    # <PRE>
    #   CK_ULONG iterations;
    # </PRE>
    attr_accessor :iterations
    alias_method :attr_iterations, :iterations
    undef_method :iterations
    alias_method :attr_iterations=, :iterations=
    undef_method :iterations=
    
    # <B>PKCS#11:</B>
    # <PRE>
    #   CK_PKCS5_PBKD2_PSEUDO_RANDOM_FUNCTION_TYPE prf;
    # </PRE>
    attr_accessor :prf
    alias_method :attr_prf, :prf
    undef_method :prf
    alias_method :attr_prf=, :prf=
    undef_method :prf=
    
    # <B>PKCS#11:</B>
    # <PRE>
    #   CK_VOID_PTR pPrfData;
    #   CK_ULONG ulPrfDataLen;
    # </PRE>
    attr_accessor :p_prf_data
    alias_method :attr_p_prf_data, :p_prf_data
    undef_method :p_prf_data
    alias_method :attr_p_prf_data=, :p_prf_data=
    undef_method :p_prf_data=
    
    typesig { [] }
    # Returns the string representation of CK_PKCS5_PBKD2_PARAMS.
    # 
    # @return the string representation of CK_PKCS5_PBKD2_PARAMS
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("saltSource: ")
      buffer.append(@salt_source)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pSaltSourceData: ")
      buffer.append(Functions.to_hex_string(@p_salt_source_data))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulSaltSourceDataLen: ")
      buffer.append(@p_salt_source_data.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("iterations: ")
      buffer.append(@iterations)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("prf: ")
      buffer.append(@prf)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPrfData: ")
      buffer.append(Functions.to_hex_string(@p_prf_data))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulPrfDataLen: ")
      buffer.append(@p_prf_data.attr_length)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    typesig { [] }
    def initialize
      @salt_source = 0
      @p_salt_source_data = nil
      @iterations = 0
      @prf = 0
      @p_prf_data = nil
    end
    
    private
    alias_method :initialize__ck_pkcs5_pbkd2_params, :initialize
  end
  
end

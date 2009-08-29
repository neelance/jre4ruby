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
  module CK_PBE_PARAMSImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_PBE_PARAMS provides all of the necessary information required byte
  # the CKM_PBE mechanisms and the CKM_PBA_SHA1_WITH_SHA1_HMAC mechanism.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_PBE_PARAMS {
  # CK_CHAR_PTR pInitVector;
  # CK_CHAR_PTR pPassword;
  # CK_ULONG ulPasswordLen;
  # CK_CHAR_PTR pSalt;
  # CK_ULONG ulSaltLen;
  # CK_ULONG ulIteration;
  # } CK_PBE_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_PBE_PARAMS 
    include_class_members CK_PBE_PARAMSImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR_PTR pInitVector;
    # </PRE>
    attr_accessor :p_init_vector
    alias_method :attr_p_init_vector, :p_init_vector
    undef_method :p_init_vector
    alias_method :attr_p_init_vector=, :p_init_vector=
    undef_method :p_init_vector=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR_PTR pPassword;
    # CK_ULONG ulPasswordLen;
    # </PRE>
    attr_accessor :p_password
    alias_method :attr_p_password, :p_password
    undef_method :p_password
    alias_method :attr_p_password=, :p_password=
    undef_method :p_password=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR_PTR pSalt
    # CK_ULONG ulSaltLen;
    # </PRE>
    attr_accessor :p_salt
    alias_method :attr_p_salt, :p_salt
    undef_method :p_salt
    alias_method :attr_p_salt=, :p_salt=
    undef_method :p_salt=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulIteration;
    # </PRE>
    attr_accessor :ul_iteration
    alias_method :attr_ul_iteration, :ul_iteration
    undef_method :ul_iteration
    alias_method :attr_ul_iteration=, :ul_iteration=
    undef_method :ul_iteration=
    
    typesig { [] }
    # Returns the string representation of CK_PBE_PARAMS.
    # 
    # @return the string representation of CK_PBE_PARAMS
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("pInitVector: ")
      buffer.append(@p_init_vector)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulPasswordLen: ")
      buffer.append(@p_password.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pPassword: ")
      buffer.append(@p_password)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulSaltLen: ")
      buffer.append(@p_salt.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pSalt: ")
      buffer.append(@p_salt)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulIteration: ")
      buffer.append(@ul_iteration)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    typesig { [] }
    def initialize
      @p_init_vector = nil
      @p_password = nil
      @p_salt = nil
      @ul_iteration = 0
    end
    
    private
    alias_method :initialize__ck_pbe_params, :initialize
  end
  
end

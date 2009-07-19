require "rjava"

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
  module CK_SSL3_MASTER_KEY_DERIVE_PARAMSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_SSL3_MASTER_KEY_DERIVE_PARAMS provides the parameters to the
  # CKM_SSL3_MASTER_KEY_DERIVE mechanism.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_SSL3_MASTER_KEY_DERIVE_PARAMS {
  # CK_SSL3_RANDOM_DATA RandomInfo;
  # CK_VERSION_PTR pVersion;
  # } CK_SSL3_MASTER_KEY_DERIVE_PARAMS;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_SSL3_MASTER_KEY_DERIVE_PARAMS 
    include_class_members CK_SSL3_MASTER_KEY_DERIVE_PARAMSImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_SSL3_RANDOM_DATA RandomInfo;
    # </PRE>
    attr_accessor :random_info
    alias_method :attr_random_info, :random_info
    undef_method :random_info
    alias_method :attr_random_info=, :random_info=
    undef_method :random_info=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION_PTR pVersion;
    # </PRE>
    attr_accessor :p_version
    alias_method :attr_p_version, :p_version
    undef_method :p_version
    alias_method :attr_p_version=, :p_version=
    undef_method :p_version=
    
    typesig { [CK_SSL3_RANDOM_DATA, CK_VERSION] }
    def initialize(random, version)
      @random_info = nil
      @p_version = nil
      @random_info = random
      @p_version = version
    end
    
    typesig { [] }
    # Returns the string representation of CK_SSL3_MASTER_KEY_DERIVE_PARAMS.
    # 
    # @return the string representation of CK_SSL3_MASTER_KEY_DERIVE_PARAMS
    def to_s
      buffer = StringBuilder.new
      buffer.append(Constants::INDENT)
      buffer.append("RandomInfo: ")
      buffer.append(@random_info)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pVersion: ")
      buffer.append(@p_version)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_ssl3_master_key_derive_params, :initialize
  end
  
end

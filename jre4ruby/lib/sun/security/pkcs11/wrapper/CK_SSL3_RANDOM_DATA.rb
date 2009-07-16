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
  module CK_SSL3_RANDOM_DATAImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class CK_SSL3_RANDOM_DATA provides information about the random data of a
  # client and a server in an SSL context. This class is used by both the
  # CKM_SSL3_MASTER_KEY_DERIVE and the CKM_SSL3_KEY_AND_MAC_DERIVE mechanisms.
  # <p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_SSL3_RANDOM_DATA {
  # CK_BYTE_PTR pClientRandom;
  # CK_ULONG ulClientRandomLen;
  # CK_BYTE_PTR pServerRandom;
  # CK_ULONG ulServerRandomLen;
  # } CK_SSL3_RANDOM_DATA;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_SSL3_RANDOM_DATA 
    include_class_members CK_SSL3_RANDOM_DATAImports
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_BYTE_PTR pClientRandom;
    # CK_ULONG ulClientRandomLen;
    # </PRE>
    attr_accessor :p_client_random
    alias_method :attr_p_client_random, :p_client_random
    undef_method :p_client_random
    alias_method :attr_p_client_random=, :p_client_random=
    undef_method :p_client_random=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_BYTE_PTR pServerRandom;
    # CK_ULONG ulServerRandomLen;
    # </PRE>
    attr_accessor :p_server_random
    alias_method :attr_p_server_random, :p_server_random
    undef_method :p_server_random
    alias_method :attr_p_server_random=, :p_server_random=
    undef_method :p_server_random=
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def initialize(client_random, server_random)
      @p_client_random = nil
      @p_server_random = nil
      @p_client_random = client_random
      @p_server_random = server_random
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_SSL3_RANDOM_DATA.
    # 
    # @return the string representation of CK_SSL3_RANDOM_DATA
    def to_s
      buffer = StringBuilder.new
      buffer.append(Constants::INDENT)
      buffer.append("pClientRandom: ")
      buffer.append(Functions.to_hex_string(@p_client_random))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulClientRandomLen: ")
      buffer.append(@p_client_random.attr_length)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pServerRandom: ")
      buffer.append(Functions.to_hex_string(@p_server_random))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulServerRandomLen: ")
      buffer.append(@p_server_random.attr_length)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_ssl3_random_data, :initialize
  end
  
end

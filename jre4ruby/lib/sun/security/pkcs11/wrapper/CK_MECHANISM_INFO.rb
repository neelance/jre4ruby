require "rjava"

# 
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
  module CK_MECHANISM_INFOImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class CK_MECHANISM_INFO provides information about a particular mechanism.
  # <p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_MECHANISM_INFO {&nbsp;&nbsp;
  # CK_ULONG ulMinKeySize;&nbsp;&nbsp;
  # CK_ULONG ulMaxKeySize;&nbsp;&nbsp;
  # CK_FLAGS flags;&nbsp;&nbsp;
  # } CK_MECHANISM_INFO;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_MECHANISM_INFO 
    include_class_members CK_MECHANISM_INFOImports
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMinKeySize;
    # </PRE>
    attr_accessor :ul_min_key_size
    alias_method :attr_ul_min_key_size, :ul_min_key_size
    undef_method :ul_min_key_size
    alias_method :attr_ul_min_key_size=, :ul_min_key_size=
    undef_method :ul_min_key_size=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMaxKeySize;
    # </PRE>
    attr_accessor :ul_max_key_size
    alias_method :attr_ul_max_key_size, :ul_max_key_size
    undef_method :ul_max_key_size
    alias_method :attr_ul_max_key_size=, :ul_max_key_size=
    undef_method :ul_max_key_size=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_FLAGS flags;
    # </PRE>
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
    def initialize(min_key_size, max_key_size, flags)
      @ul_min_key_size = 0
      @ul_max_key_size = 0
      @flags = 0
      @ul_min_key_size = min_key_size
      @ul_max_key_size = max_key_size
      @flags = flags
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_MECHANISM_INFO.
    # 
    # @return the string representation of CK_MECHANISM_INFO
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("ulMinKeySize: ")
      buffer.append(String.value_of(@ul_min_key_size))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulMaxKeySize: ")
      buffer.append(String.value_of(@ul_max_key_size))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("flags: ")
      buffer.append(String.value_of(@flags))
      buffer.append(" = ")
      buffer.append(Functions.mechanism_info_flags_to_string(@flags))
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_mechanism_info, :initialize
  end
  
end

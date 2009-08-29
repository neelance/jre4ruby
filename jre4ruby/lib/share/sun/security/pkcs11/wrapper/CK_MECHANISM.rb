require "rjava"

# Portions Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CK_MECHANISMImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # class CK_MECHANISM specifies a particular mechanism and any parameters it
  # requires.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_MECHANISM {&nbsp;&nbsp;
  # CK_MECHANISM_TYPE mechanism;&nbsp;&nbsp;
  # CK_VOID_PTR pParameter;&nbsp;&nbsp;
  # CK_ULONG ulParameterLen;&nbsp;&nbsp;
  # } CK_MECHANISM;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_MECHANISM 
    include_class_members CK_MECHANISMImports
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_MECHANISM_TYPE mechanism;
    # </PRE>
    attr_accessor :mechanism
    alias_method :attr_mechanism, :mechanism
    undef_method :mechanism
    alias_method :attr_mechanism=, :mechanism=
    undef_method :mechanism=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VOID_PTR pParameter;
    # CK_ULONG ulParameterLen;
    # </PRE>
    attr_accessor :p_parameter
    alias_method :attr_p_parameter, :p_parameter
    undef_method :p_parameter
    alias_method :attr_p_parameter=, :p_parameter=
    undef_method :p_parameter=
    
    typesig { [] }
    def initialize
      @mechanism = 0
      @p_parameter = nil
      # empty
    end
    
    typesig { [::Java::Long] }
    def initialize(mechanism)
      @mechanism = 0
      @p_parameter = nil
      @mechanism = mechanism
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    # We don't have a (long,Object) constructor to force type checking.
    # This makes sure we don't accidentally pass a class that the native
    # code cannot handle.
    def initialize(mechanism, p_parameter)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, p_parameter)
    end
    
    typesig { [::Java::Long, BigInteger] }
    def initialize(mechanism, b)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, Sun::Security::Pkcs11::P11Util.get_magnitude(b))
    end
    
    typesig { [::Java::Long, CK_VERSION] }
    def initialize(mechanism, version)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, version)
    end
    
    typesig { [::Java::Long, CK_SSL3_MASTER_KEY_DERIVE_PARAMS] }
    def initialize(mechanism, params)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, params)
    end
    
    typesig { [::Java::Long, CK_SSL3_KEY_MAT_PARAMS] }
    def initialize(mechanism, params)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, params)
    end
    
    typesig { [::Java::Long, CK_TLS_PRF_PARAMS] }
    def initialize(mechanism, params)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, params)
    end
    
    typesig { [::Java::Long, CK_ECDH1_DERIVE_PARAMS] }
    def initialize(mechanism, params)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, params)
    end
    
    typesig { [::Java::Long, Long] }
    def initialize(mechanism, params)
      @mechanism = 0
      @p_parameter = nil
      init(mechanism, params)
    end
    
    typesig { [::Java::Long, Object] }
    def init(mechanism, p_parameter)
      @mechanism = mechanism
      @p_parameter = p_parameter
    end
    
    typesig { [] }
    # Returns the string representation of CK_MECHANISM.
    # 
    # @return the string representation of CK_MECHANISM
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("mechanism: ")
      buffer.append(@mechanism)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("pParameter: ")
      buffer.append(@p_parameter.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulParameterLen: ??")
      # buffer.append(pParameter.length);
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_mechanism, :initialize
  end
  
end

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
  module CK_SESSION_INFOImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class CK_SESSION_INFO provides information about a session.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_SESSION_INFO {&nbsp;&nbsp;
  # CK_SLOT_ID slotID;&nbsp;&nbsp;
  # CK_STATE state;&nbsp;&nbsp;
  # CK_FLAGS flags;&nbsp;&nbsp;
  # CK_ULONG ulDeviceError;&nbsp;&nbsp;
  # } CK_SESSION_INFO;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_SESSION_INFO 
    include_class_members CK_SESSION_INFOImports
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_SLOT_ID slotID;
    # </PRE>
    attr_accessor :slot_id
    alias_method :attr_slot_id, :slot_id
    undef_method :slot_id
    alias_method :attr_slot_id=, :slot_id=
    undef_method :slot_id=
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_STATE state;
    # </PRE>
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
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
    
    # see below
    # ulDeviceError was changed from CK_USHORT to CK_ULONG for
    # v2.0
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulDeviceError;
    # </PRE>
    attr_accessor :ul_device_error
    alias_method :attr_ul_device_error, :ul_device_error
    undef_method :ul_device_error
    alias_method :attr_ul_device_error=, :ul_device_error=
    undef_method :ul_device_error=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long] }
    # device-dependent error code
    def initialize(slot_id, state, flags, ul_device_error)
      @slot_id = 0
      @state = 0
      @flags = 0
      @ul_device_error = 0
      @slot_id = slot_id
      @state = state
      @flags = flags
      @ul_device_error = ul_device_error
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_SESSION_INFO.
    # 
    # @return the string representation of CK_SESSION_INFO
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("slotID: ")
      buffer.append(String.value_of(@slot_id))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("state: ")
      buffer.append(Functions.session_state_to_string(@state))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("flags: ")
      buffer.append(Functions.session_info_flags_to_string(@flags))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulDeviceError: ")
      buffer.append(Functions.to_hex_string(@ul_device_error))
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_session_info, :initialize
  end
  
end

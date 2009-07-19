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
  module CK_SLOT_INFOImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_SLOT_INFO provides information about a slot.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_SLOT_INFO {&nbsp;&nbsp;
  # CK_UTF8CHAR slotDescription[64];&nbsp;&nbsp;
  # CK_UTF8CHAR manufacturerID[32];&nbsp;&nbsp;
  # CK_FLAGS flags;&nbsp;&nbsp;
  # CK_VERSION hardwareVersion;&nbsp;&nbsp;
  # CK_VERSION firmwareVersion;&nbsp;&nbsp;
  # } CK_SLOT_INFO;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_SLOT_INFO 
    include_class_members CK_SLOT_INFOImports
    
    # slotDescription and manufacturerID have been changed from
    # CK_CHAR to CK_UTF8CHAR for v2.11.
    # 
    # must be blank padded and only the first 64 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR slotDescription[64];
    # </PRE>
    attr_accessor :slot_description
    alias_method :attr_slot_description, :slot_description
    undef_method :slot_description
    alias_method :attr_slot_description=, :slot_description=
    undef_method :slot_description=
    
    # must be blank padded and only the first 32 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR manufacturerID[32];
    # </PRE>
    attr_accessor :manufacturer_id
    alias_method :attr_manufacturer_id, :manufacturer_id
    undef_method :manufacturer_id
    alias_method :attr_manufacturer_id=, :manufacturer_id=
    undef_method :manufacturer_id=
    
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_FLAGS flags;
    # </PRE>
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    # hardwareVersion and firmwareVersion are new for v2.0
    # 
    # version of hardware<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION hardwareVersion;
    # </PRE>
    attr_accessor :hardware_version
    alias_method :attr_hardware_version, :hardware_version
    undef_method :hardware_version
    alias_method :attr_hardware_version=, :hardware_version=
    undef_method :hardware_version=
    
    # version of firmware<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION firmwareVersion;
    # </PRE>
    attr_accessor :firmware_version
    alias_method :attr_firmware_version, :firmware_version
    undef_method :firmware_version
    alias_method :attr_firmware_version=, :firmware_version=
    undef_method :firmware_version=
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Char), ::Java::Long, CK_VERSION, CK_VERSION] }
    def initialize(slot_desc, vendor, flags, hw_ver, fw_ver)
      @slot_description = nil
      @manufacturer_id = nil
      @flags = 0
      @hardware_version = nil
      @firmware_version = nil
      @slot_description = slot_desc
      @manufacturer_id = vendor
      @flags = flags
      @hardware_version = hw_ver
      @firmware_version = fw_ver
    end
    
    typesig { [] }
    # Returns the string representation of CK_SLOT_INFO.
    # 
    # @return the string representation of CK_SLOT_INFO
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("slotDescription: ")
      buffer.append(String.new(@slot_description))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("manufacturerID: ")
      buffer.append(String.new(@manufacturer_id))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("flags: ")
      buffer.append(Functions.slot_info_flags_to_string(@flags))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("hardwareVersion: ")
      buffer.append(@hardware_version.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("firmwareVersion: ")
      buffer.append(@firmware_version.to_s)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_slot_info, :initialize
  end
  
end

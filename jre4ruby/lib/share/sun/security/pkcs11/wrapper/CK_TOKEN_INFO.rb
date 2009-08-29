require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CK_TOKEN_INFOImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # class CK_TOKEN_INFO provides information about a token.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_TOKEN_INFO {&nbsp;&nbsp;
  # CK_UTF8CHAR label[32];&nbsp;&nbsp;
  # CK_UTF8CHAR manufacturerID[32];&nbsp;&nbsp;
  # CK_UTF8CHAR model[16];&nbsp;&nbsp;
  # CK_CHAR serialNumber[16];&nbsp;&nbsp;
  # CK_FLAGS flags;&nbsp;&nbsp;
  # CK_ULONG ulMaxSessionCount;&nbsp;&nbsp;
  # CK_ULONG ulSessionCount;&nbsp;&nbsp;
  # CK_ULONG ulMaxRwSessionCount;&nbsp;&nbsp;
  # CK_ULONG ulRwSessionCount;&nbsp;&nbsp;
  # CK_ULONG ulMaxPinLen;&nbsp;&nbsp;
  # CK_ULONG ulMinPinLen;&nbsp;&nbsp;
  # CK_ULONG ulTotalPublicMemory;&nbsp;&nbsp;
  # CK_ULONG ulFreePublicMemory;&nbsp;&nbsp;
  # CK_ULONG ulTotalPrivateMemory;&nbsp;&nbsp;
  # CK_ULONG ulFreePrivateMemory;&nbsp;&nbsp;
  # CK_VERSION hardwareVersion;&nbsp;&nbsp;
  # CK_VERSION firmwareVersion;&nbsp;&nbsp;
  # CK_CHAR utcTime[16];&nbsp;&nbsp;
  # } CK_TOKEN_INFO;
  # &nbsp;&nbsp;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_TOKEN_INFO 
    include_class_members CK_TOKEN_INFOImports
    
    # label, manufacturerID, and model have been changed from
    # CK_CHAR to CK_UTF8CHAR for v2.11.
    # 
    # must be blank padded and only the first 32 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR label[32];
    # </PRE>
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    # blank padded
    # 
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
    
    # blank padded
    # 
    # must be blank padded and only the first 16 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR model[16];
    # </PRE>
    attr_accessor :model
    alias_method :attr_model, :model
    undef_method :model
    alias_method :attr_model=, :model=
    undef_method :model=
    
    # blank padded
    # 
    # must be blank padded and only the first 16 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR serialNumber[16];
    # </PRE>
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    # blank padded
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
    # ulMaxSessionCount, ulSessionCount, ulMaxRwSessionCount,
    # ulRwSessionCount, ulMaxPinLen, and ulMinPinLen have all been
    # changed from CK_USHORT to CK_ULONG for v2.0
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMaxSessionCount;
    # </PRE>
    attr_accessor :ul_max_session_count
    alias_method :attr_ul_max_session_count, :ul_max_session_count
    undef_method :ul_max_session_count
    alias_method :attr_ul_max_session_count=, :ul_max_session_count=
    undef_method :ul_max_session_count=
    
    # max open sessions
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulSessionCount;
    # </PRE>
    attr_accessor :ul_session_count
    alias_method :attr_ul_session_count, :ul_session_count
    undef_method :ul_session_count
    alias_method :attr_ul_session_count=, :ul_session_count=
    undef_method :ul_session_count=
    
    # sess. now open
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMaxRwSessionCount;
    # </PRE>
    attr_accessor :ul_max_rw_session_count
    alias_method :attr_ul_max_rw_session_count, :ul_max_rw_session_count
    undef_method :ul_max_rw_session_count
    alias_method :attr_ul_max_rw_session_count=, :ul_max_rw_session_count=
    undef_method :ul_max_rw_session_count=
    
    # max R/W sessions
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulRwSessionCount;
    # </PRE>
    attr_accessor :ul_rw_session_count
    alias_method :attr_ul_rw_session_count, :ul_rw_session_count
    undef_method :ul_rw_session_count
    alias_method :attr_ul_rw_session_count=, :ul_rw_session_count=
    undef_method :ul_rw_session_count=
    
    # R/W sess. now open
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMaxPinLen;
    # </PRE>
    attr_accessor :ul_max_pin_len
    alias_method :attr_ul_max_pin_len, :ul_max_pin_len
    undef_method :ul_max_pin_len
    alias_method :attr_ul_max_pin_len=, :ul_max_pin_len=
    undef_method :ul_max_pin_len=
    
    # in bytes
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulMinPinLen;
    # </PRE>
    attr_accessor :ul_min_pin_len
    alias_method :attr_ul_min_pin_len, :ul_min_pin_len
    undef_method :ul_min_pin_len
    alias_method :attr_ul_min_pin_len=, :ul_min_pin_len=
    undef_method :ul_min_pin_len=
    
    # in bytes
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulTotalPublicMemory;
    # </PRE>
    attr_accessor :ul_total_public_memory
    alias_method :attr_ul_total_public_memory, :ul_total_public_memory
    undef_method :ul_total_public_memory
    alias_method :attr_ul_total_public_memory=, :ul_total_public_memory=
    undef_method :ul_total_public_memory=
    
    # in bytes
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulFreePublicMemory;
    # </PRE>
    attr_accessor :ul_free_public_memory
    alias_method :attr_ul_free_public_memory, :ul_free_public_memory
    undef_method :ul_free_public_memory
    alias_method :attr_ul_free_public_memory=, :ul_free_public_memory=
    undef_method :ul_free_public_memory=
    
    # in bytes
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulTotalPrivateMemory;
    # </PRE>
    attr_accessor :ul_total_private_memory
    alias_method :attr_ul_total_private_memory, :ul_total_private_memory
    undef_method :ul_total_private_memory
    alias_method :attr_ul_total_private_memory=, :ul_total_private_memory=
    undef_method :ul_total_private_memory=
    
    # in bytes
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_ULONG ulFreePrivateMemory;
    # </PRE>
    attr_accessor :ul_free_private_memory
    alias_method :attr_ul_free_private_memory, :ul_free_private_memory
    undef_method :ul_free_private_memory
    alias_method :attr_ul_free_private_memory=, :ul_free_private_memory=
    undef_method :ul_free_private_memory=
    
    # in bytes
    # hardwareVersion, firmwareVersion, and time are new for
    # v2.0
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION hardwareVersion;
    # </PRE>
    attr_accessor :hardware_version
    alias_method :attr_hardware_version, :hardware_version
    undef_method :hardware_version
    alias_method :attr_hardware_version=, :hardware_version=
    undef_method :hardware_version=
    
    # version of hardware
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION firmwareVersion;
    # </PRE>
    attr_accessor :firmware_version
    alias_method :attr_firmware_version, :firmware_version
    undef_method :firmware_version
    alias_method :attr_firmware_version=, :firmware_version=
    undef_method :firmware_version=
    
    # version of firmware
    # 
    # only the first 16 chars will be used
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR utcTime[16];
    # </PRE>
    attr_accessor :utc_time
    alias_method :attr_utc_time, :utc_time
    undef_method :utc_time
    alias_method :attr_utc_time=, :utc_time=
    undef_method :utc_time=
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Char), Array.typed(::Java::Char), Array.typed(::Java::Char), ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, CK_VERSION, CK_VERSION, Array.typed(::Java::Char)] }
    # time
    def initialize(label, vendor, model, serial_no, flags, session_max, session, rw_session_max, rw_session, pin_len_max, pin_len_min, total_pub_mem, free_pub_mem, total_priv_mem, free_priv_mem, hw_ver, fw_ver, utc_time)
      @label = nil
      @manufacturer_id = nil
      @model = nil
      @serial_number = nil
      @flags = 0
      @ul_max_session_count = 0
      @ul_session_count = 0
      @ul_max_rw_session_count = 0
      @ul_rw_session_count = 0
      @ul_max_pin_len = 0
      @ul_min_pin_len = 0
      @ul_total_public_memory = 0
      @ul_free_public_memory = 0
      @ul_total_private_memory = 0
      @ul_free_private_memory = 0
      @hardware_version = nil
      @firmware_version = nil
      @utc_time = nil
      @label = label
      @manufacturer_id = vendor
      @model = model
      @serial_number = serial_no
      @flags = flags
      @ul_max_session_count = session_max
      @ul_session_count = session
      @ul_max_rw_session_count = rw_session_max
      @ul_rw_session_count = rw_session
      @ul_max_pin_len = pin_len_max
      @ul_min_pin_len = pin_len_min
      @ul_total_public_memory = total_pub_mem
      @ul_free_public_memory = free_pub_mem
      @ul_total_private_memory = total_priv_mem
      @ul_free_private_memory = free_priv_mem
      @hardware_version = hw_ver
      @firmware_version = fw_ver
      @utc_time = utc_time
    end
    
    typesig { [] }
    # Returns the string representation of CK_TOKEN_INFO.
    # 
    # @return the string representation of CK_TOKEN_INFO
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("label: ")
      buffer.append(String.new(@label))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("manufacturerID: ")
      buffer.append(String.new(@manufacturer_id))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("model: ")
      buffer.append(String.new(@model))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("serialNumber: ")
      buffer.append(String.new(@serial_number))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("flags: ")
      buffer.append(Functions.token_info_flags_to_string(@flags))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulMaxSessionCount: ")
      buffer.append(((@ul_max_session_count).equal?(PKCS11Constants::CK_EFFECTIVELY_INFINITE)) ? "CK_EFFECTIVELY_INFINITE" : ((@ul_max_session_count).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_max_session_count))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulSessionCount: ")
      buffer.append(((@ul_session_count).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_session_count))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulMaxRwSessionCount: ")
      buffer.append(((@ul_max_rw_session_count).equal?(PKCS11Constants::CK_EFFECTIVELY_INFINITE)) ? "CK_EFFECTIVELY_INFINITE" : ((@ul_max_rw_session_count).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_max_rw_session_count))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulRwSessionCount: ")
      buffer.append(((@ul_rw_session_count).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_rw_session_count))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulMaxPinLen: ")
      buffer.append(String.value_of(@ul_max_pin_len))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulMinPinLen: ")
      buffer.append(String.value_of(@ul_min_pin_len))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulTotalPublicMemory: ")
      buffer.append(((@ul_total_public_memory).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_total_public_memory))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulFreePublicMemory: ")
      buffer.append(((@ul_free_public_memory).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_free_public_memory))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulTotalPrivateMemory: ")
      buffer.append(((@ul_total_private_memory).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_total_private_memory))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("ulFreePrivateMemory: ")
      buffer.append(((@ul_free_private_memory).equal?(PKCS11Constants::CK_UNAVAILABLE_INFORMATION)) ? "CK_UNAVAILABLE_INFORMATION" : String.value_of(@ul_free_private_memory))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("hardwareVersion: ")
      buffer.append(@hardware_version.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("firmwareVersion: ")
      buffer.append(@firmware_version.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("utcTime: ")
      buffer.append(String.new(@utc_time))
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_token_info, :initialize
  end
  
end

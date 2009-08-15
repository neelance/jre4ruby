require "rjava"

# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ktab
  module KeyTabOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ktab
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Util, :KrbDataOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :UnsupportedEncodingException
    }
  end
  
  # This class implements a buffered input stream. It is used for parsing key table
  # data to memory.
  # 
  # @author Yanni Zhang
  class KeyTabOutputStream < KeyTabOutputStreamImports.const_get :KrbDataOutputStream
    include_class_members KeyTabOutputStreamImports
    overload_protected {
      include KeyTabConstants
    }
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    attr_accessor :key_type
    alias_method :attr_key_type, :key_type
    undef_method :key_type
    alias_method :attr_key_type=, :key_type=
    undef_method :key_type=
    
    attr_accessor :key_value
    alias_method :attr_key_value, :key_value
    undef_method :key_value
    alias_method :attr_key_value=, :key_value=
    undef_method :key_value=
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    typesig { [OutputStream] }
    def initialize(os)
      @entry = nil
      @key_type = 0
      @key_value = nil
      @version = 0
      super(os)
    end
    
    typesig { [::Java::Int] }
    def write_version(num)
      @version = num
      write16(num) # we use the standard version.
    end
    
    typesig { [KeyTabEntry] }
    def write_entry(entry)
      write32(entry.entry_length)
      service_names = entry.attr_service.get_name_strings
      comp_num = service_names.attr_length
      if ((@version).equal?(KRB5_KT_VNO_1))
        write16(comp_num + 1)
      else
        write16(comp_num)
      end
      realm = nil
      begin
        realm = entry.attr_service.get_realm_string.get_bytes("8859_1")
      rescue UnsupportedEncodingException => exc
      end
      write16(realm.attr_length)
      write(realm)
      i = 0
      while i < comp_num
        begin
          write16(service_names[i].get_bytes("8859_1").attr_length)
          write(service_names[i].get_bytes("8859_1"))
        rescue UnsupportedEncodingException => exc
        end
        i += 1
      end
      write32(entry.attr_service.get_name_type)
      # time is long, but we only use 4 bytes to store the data.
      write32(RJava.cast_to_int((entry.attr_timestamp.get_time / 1000)))
      # the key version might be a 32 bit extended number.
      write8(entry.attr_key_version % 256)
      write16(entry.attr_key_type)
      write16(entry.attr_keyblock.attr_length)
      write(entry.attr_keyblock)
      # if the key version isn't smaller than 256, it could be saved as
      # extension key version number in 4 bytes. The nonzero extension
      # key version number will be trusted. However, it isn't standardized
      # yet, we won't support it.
      # if (entry.keyVersion >= 256) {
      # write32(entry.keyVersion);
      # }
    end
    
    private
    alias_method :initialize__key_tab_output_stream, :initialize
  end
  
end

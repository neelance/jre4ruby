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
  module KeyTabEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ktab
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Io, :UnsupportedEncodingException
    }
  end
  
  # This class represents a Key Table entry. Each entry contains the service principal of
  # the key, time stamp, key version and secret key itself.
  # 
  # @author Yanni Zhang
  class KeyTabEntry 
    include_class_members KeyTabEntryImports
    include KeyTabConstants
    
    attr_accessor :service
    alias_method :attr_service, :service
    undef_method :service
    alias_method :attr_service=, :service=
    undef_method :service=
    
    attr_accessor :realm
    alias_method :attr_realm, :realm
    undef_method :realm
    alias_method :attr_realm=, :realm=
    undef_method :realm=
    
    attr_accessor :timestamp
    alias_method :attr_timestamp, :timestamp
    undef_method :timestamp
    alias_method :attr_timestamp=, :timestamp=
    undef_method :timestamp=
    
    attr_accessor :key_version
    alias_method :attr_key_version, :key_version
    undef_method :key_version
    alias_method :attr_key_version=, :key_version=
    undef_method :key_version=
    
    attr_accessor :key_type
    alias_method :attr_key_type, :key_type
    undef_method :key_type
    alias_method :attr_key_type=, :key_type=
    undef_method :key_type=
    
    attr_accessor :keyblock
    alias_method :attr_keyblock, :keyblock
    undef_method :keyblock
    alias_method :attr_keyblock=, :keyblock=
    undef_method :keyblock=
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [PrincipalName, Realm, KerberosTime, ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(new_service, new_realm, new_time, new_key_version, new_key_type, new_keyblock)
      @service = nil
      @realm = nil
      @timestamp = nil
      @key_version = 0
      @key_type = 0
      @keyblock = nil
      @debug = Krb5::DEBUG
      @service = new_service
      @realm = new_realm
      @timestamp = new_time
      @key_version = new_key_version
      @key_type = new_key_type
      if (!(new_keyblock).nil?)
        @keyblock = new_keyblock.clone
      end
    end
    
    typesig { [] }
    def get_service
      return @service
    end
    
    typesig { [] }
    def get_key
      key = EncryptionKey.new(@keyblock, @key_type, @key_version)
      return key
    end
    
    typesig { [] }
    def get_key_string
      sb = StringBuffer.new("0x")
      i = 0
      while i < @keyblock.attr_length
        sb.append(JavaInteger.to_hex_string(@keyblock[i] & 0xff))
        ((i += 1) - 1)
      end
      return sb.to_s
    end
    
    typesig { [] }
    def entry_length
      total_principal_length = 0
      names = @service.get_name_strings
      i = 0
      while i < names.attr_length
        begin
          total_principal_length += self.attr_principal_size + names[i].get_bytes("8859_1").attr_length
        rescue UnsupportedEncodingException => exc
        end
        ((i += 1) - 1)
      end
      realm_len = 0
      begin
        realm_len = @realm.to_s.get_bytes("8859_1").attr_length
      rescue UnsupportedEncodingException => exc
      end
      size = self.attr_principal_component_size + self.attr_realm_size + realm_len + total_principal_length + self.attr_principal_type_size + self.attr_timestamp_size + self.attr_key_version_size + self.attr_key_type_size + self.attr_key_size + @keyblock.attr_length
      if (@debug)
        System.out.println(">>> KeyTabEntry: key tab entry size is " + (size).to_s)
      end
      return size
    end
    
    typesig { [] }
    def get_time_stamp
      return @timestamp
    end
    
    private
    alias_method :initialize__key_tab_entry, :initialize
  end
  
end

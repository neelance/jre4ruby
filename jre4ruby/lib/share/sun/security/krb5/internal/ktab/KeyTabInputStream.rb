require "rjava"

# Portions Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ktab
  module KeyTabInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ktab
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :Realm
      include_const ::Sun::Security::Krb5, :RealmException
      include_const ::Sun::Security::Krb5::Internal::Util, :KrbDataInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
    }
  end
  
  # This class implements a buffered input stream. It is used for parsing key table
  # data to memory.
  # 
  # @author Yanni Zhang
  class KeyTabInputStream < KeyTabInputStreamImports.const_get :KrbDataInputStream
    include_class_members KeyTabInputStreamImports
    overload_protected {
      include KeyTabConstants
    }
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    class_module.module_eval {
      
      def index
        defined?(@@index) ? @@index : @@index= 0
      end
      alias_method :attr_index, :index
      
      def index=(value)
        @@index = value
      end
      alias_method :attr_index=, :index=
    }
    
    typesig { [InputStream] }
    def initialize(is)
      @debug = false
      super(is)
      @debug = Krb5::DEBUG
    end
    
    typesig { [] }
    # Reads the number of bytes this entry data occupy.
    def read_entry_length
      return read(4)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def read_entry(entry_len, kt_version)
      self.attr_index = entry_len
      if ((self.attr_index).equal?(0))
        # in native implementation, when the last entry is deleted, a byte 0 is left.
        return nil
      end
      if (self.attr_index < 0)
        # in native implementation, when one of the entries is deleted, the entry length turns to be negative, and
        skip(Math.abs(self.attr_index)) # the fields are left with 0 bytes
        return nil
      end
      principal_num = read(2) # the number of service names.
      self.attr_index -= 2
      if ((kt_version).equal?(KRB5_KT_VNO_1))
        # V1 includes realm in the count.
        principal_num -= 1
      end
      realm = Realm.new(read_name)
      name_parts = Array.typed(String).new(principal_num) { nil }
      i = 0
      while i < principal_num
        name_parts[i] = read_name
        i += 1
      end
      name_type = read(4)
      self.attr_index -= 4
      service = PrincipalName.new(name_parts, name_type)
      service.set_realm(realm)
      time_stamp = read_time_stamp
      key_version = read & 0xff
      self.attr_index -= 1
      key_type = read(2)
      self.attr_index -= 2
      key_length = read(2)
      self.attr_index -= 2
      keyblock = read_key(key_length)
      self.attr_index -= key_length
      # There might be a 32 bit kvno here.
      # If index is zero, assume that the 8 bit key version number was
      # right, otherwise trust the new nonzero value.
      if (self.attr_index >= 4)
        ext_kvno = read(4)
        if (!(ext_kvno).equal?(0))
          key_version = ext_kvno
        end
        self.attr_index -= 4
      end
      # if index is negative, the keytab format must be wrong.
      if (self.attr_index < 0)
        raise RealmException.new("Keytab is corrupted")
      end
      # ignore the left bytes.
      skip(self.attr_index)
      return KeyTabEntry.new(service, realm, time_stamp, key_version, key_type, keyblock)
    end
    
    typesig { [::Java::Int] }
    def read_key(length)
      bytes = Array.typed(::Java::Byte).new(length) { 0 }
      read(bytes, 0, length)
      return bytes
    end
    
    typesig { [] }
    def read_time_stamp
      self.attr_index -= 4
      return KerberosTime.new(read(4) * 1000)
    end
    
    typesig { [] }
    def read_name
      name = nil
      length = read(2) # length of the realm name or service name
      self.attr_index -= 2
      bytes = Array.typed(::Java::Byte).new(length) { 0 }
      read(bytes, 0, length)
      self.attr_index -= length
      name = RJava.cast_to_string(String.new(bytes))
      if (@debug)
        System.out.println(">>> KeyTabInputStream, readName(): " + name)
      end
      return name
    end
    
    private
    alias_method :initialize__key_tab_input_stream, :initialize
  end
  
end

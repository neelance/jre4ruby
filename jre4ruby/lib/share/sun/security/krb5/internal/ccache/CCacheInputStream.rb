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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ccache
  module CCacheInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :StringTokenizer
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Util, :KrbDataInputStream
    }
  end
  
  # This class extends KrbDataInputStream. It is used for parsing FCC-format
  # data from file to memory.
  # 
  # @author Yanni Zhang
  class CCacheInputStream < CCacheInputStreamImports.const_get :KrbDataInputStream
    include_class_members CCacheInputStreamImports
    overload_protected {
      include FileCCacheConstants
    }
    
    class_module.module_eval {
      # FCC version 2 contains type information for principals.  FCC
      # version 1 does not.
      # 
      # FCC version 3 contains keyblock encryption type information, and is
      # architecture independent.  Previous versions are not.
      # 
      # The code will accept version 1, 2, and 3 ccaches, and depending
      # what KRB5_FCC_DEFAULT_FVNO is set to, it will create version 1, 2,
      # or 3 FCC caches.
      # 
      # The default credentials cache should be type 3 for now (see
      # init_ctx.c).
      # V4 of the credentials cache format allows for header tags
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    typesig { [InputStream] }
    def initialize(is)
      super(is)
    end
    
    typesig { [] }
    # Read tag field introduced in KRB5_FCC_FVNO_4
    # this needs to be public for Kinit.
    def read_tag
      buf = CharArray.new(1024)
      bytes = nil
      len = 0
      tag = -1
      taglen = 0
      time_offset = nil
      usec_offset = nil
      len = read(2)
      if (len < 0)
        raise IOException.new("stop.")
      end
      bytes = Array.typed(::Java::Byte).new(len + 2) { 0 }
      if (len > buf.attr_length)
        raise IOException.new("Invalid tag length.")
      end
      while (len > 0)
        tag = read(2)
        taglen = read(2)
        case (tag)
        when FCC_TAG_DELTATIME
          time_offset = read(4)
          usec_offset = read(4)
        else
        end
        len = len - (4 + taglen)
      end
      result = nil
      if ((tag).equal?(-1))
      end
      result = Tag.new(len, tag, time_offset, usec_offset)
      return result
    end
    
    typesig { [::Java::Int] }
    # In file-based credential cache, the realm name is stored as part of
    # principal name at the first place.
    # made public for KinitOptions to call directly
    def read_principal(version)
      type = 0
      length = 0
      namelength = 0
      kret = 0
      p = nil
      pname = nil
      realm = nil
      # Read principal type
      if ((version).equal?(KRB5_FCC_FVNO_1))
        type = KRB5_NT_UNKNOWN
      else
        type = read(4)
      end
      length = read(4)
      result = Array.typed(String).new(length + 1) { nil }
      # DCE includes the principal's realm in the count; the new format
      # does not.
      if ((version).equal?(KRB5_FCC_FVNO_1))
        length -= 1
      end
      i = 0
      while i <= length
        namelength = read(4)
        if (namelength > MAXNAMELENGTH)
          raise IOException.new("Invalid name length in principal name.")
        end
        bytes = Array.typed(::Java::Byte).new(namelength) { 0 }
        read(bytes, 0, namelength)
        result[i] = String.new(bytes)
        i += 1
      end
      if (is_realm(result[0]))
        realm = RJava.cast_to_string(result[0])
        pname = Array.typed(String).new(length) { nil }
        System.arraycopy(result, 1, pname, 0, length)
        p = PrincipalName.new(pname, type)
        p.set_realm(realm)
      else
        p = PrincipalName.new(result, type)
      end
      return p
    end
    
    typesig { [String] }
    # In practice, a realm is named by uppercasing the DNS domain name. we currently
    # rely on this to determine if the string within the principal identifier is realm
    # name.
    def is_realm(str)
      begin
        r = Realm.new(str)
      rescue JavaException => e
        return false
      end
      st = StringTokenizer.new(str, ".")
      s = nil
      while (st.has_more_tokens)
        s = RJava.cast_to_string(st.next_token)
        i = 0
        while i < s.length
          if (s.char_at(i) >= 141)
            return false
          end
          i += 1
        end
      end
      return true
    end
    
    typesig { [::Java::Int] }
    def read_key(version)
      key_type = 0
      key_len = 0
      key_type = read(2)
      if ((version).equal?(KRB5_FCC_FVNO_3))
        read(2)
      end # keytype recorded twice in fvno 3
      key_len = read(4)
      bytes = Array.typed(::Java::Byte).new(key_len) { 0 }
      i = 0
      while i < key_len
        bytes[i] = read
        i += 1
      end
      return EncryptionKey.new(bytes, key_type, version)
    end
    
    typesig { [] }
    def read_times
      times = Array.typed(::Java::Long).new(4) { 0 }
      times[0] = read(4) * 1000
      times[1] = read(4) * 1000
      times[2] = read(4) * 1000
      times[3] = read(4) * 1000
      return times
    end
    
    typesig { [] }
    def readskey
      if ((read).equal?(0))
        return false
      else
        return true
      end
    end
    
    typesig { [] }
    def read_addr
      num_addrs = 0
      addr_type = 0
      addr_length = 0
      num_addrs = read(4)
      if (num_addrs > 0)
        addrs = Array.typed(HostAddress).new(num_addrs) { nil }
        i = 0
        while i < num_addrs
          addr_type = read(2)
          addr_length = read(4)
          if (!((addr_length).equal?(4) || (addr_length).equal?(16)))
            System.out.println("Incorrect address format.")
            return nil
          end
          result = Array.typed(::Java::Byte).new(addr_length) { 0 }
          j = 0
          while j < addr_length
            result[j] = read(1)
            j += 1
          end
          addrs[i] = HostAddress.new(addr_type, result)
          i += 1
        end
        return addrs
      end
      return nil
    end
    
    typesig { [] }
    def read_auth
      num = 0
      adtype = 0
      adlength = 0
      num = read(4)
      if (num > 0)
        au_data = Array.typed(AuthorizationDataEntry).new(num) { nil }
        data = nil
        i = 0
        while i < num
          adtype = read(2)
          adlength = read(4)
          data = Array.typed(::Java::Byte).new(adlength) { 0 }
          j = 0
          while j < adlength
            data[j] = read
            j += 1
          end
          au_data[i] = AuthorizationDataEntry.new(adtype, data)
          i += 1
        end
        return au_data
      else
        return nil
      end
    end
    
    typesig { [] }
    def read_data
      length_ = 0
      length_ = read(4)
      if (length_ > 0)
        bytes = Array.typed(::Java::Byte).new(length_) { 0 }
        read(bytes, 0, length_)
        ticket = Ticket.new(bytes)
        return ticket
      else
        return nil
      end
    end
    
    typesig { [] }
    def read_flags
      flags = Array.typed(::Java::Boolean).new(Krb5::TKT_OPTS_MAX + 1) { false }
      ticket_flags = 0
      ticket_flags = read(4)
      if (((ticket_flags & 0x40000000)).equal?(TKT_FLG_FORWARDABLE))
        flags[1] = true
      end
      if (((ticket_flags & 0x20000000)).equal?(TKT_FLG_FORWARDED))
        flags[2] = true
      end
      if (((ticket_flags & 0x10000000)).equal?(TKT_FLG_PROXIABLE))
        flags[3] = true
      end
      if (((ticket_flags & 0x8000000)).equal?(TKT_FLG_PROXY))
        flags[4] = true
      end
      if (((ticket_flags & 0x4000000)).equal?(TKT_FLG_MAY_POSTDATE))
        flags[5] = true
      end
      if (((ticket_flags & 0x2000000)).equal?(TKT_FLG_POSTDATED))
        flags[6] = true
      end
      if (((ticket_flags & 0x1000000)).equal?(TKT_FLG_INVALID))
        flags[7] = true
      end
      if (((ticket_flags & 0x800000)).equal?(TKT_FLG_RENEWABLE))
        flags[8] = true
      end
      if (((ticket_flags & 0x400000)).equal?(TKT_FLG_INITIAL))
        flags[9] = true
      end
      if (((ticket_flags & 0x200000)).equal?(TKT_FLG_PRE_AUTH))
        flags[10] = true
      end
      if (((ticket_flags & 0x100000)).equal?(TKT_FLG_HW_AUTH))
        flags[11] = true
      end
      if (self.attr_debug)
        msg = ">>> CCacheInputStream: readFlags() "
        if ((flags[1]).equal?(true))
          msg += " FORWARDABLE;"
        end
        if ((flags[2]).equal?(true))
          msg += " FORWARDED;"
        end
        if ((flags[3]).equal?(true))
          msg += " PROXIABLE;"
        end
        if ((flags[4]).equal?(true))
          msg += " PROXY;"
        end
        if ((flags[5]).equal?(true))
          msg += " MAY_POSTDATE;"
        end
        if ((flags[6]).equal?(true))
          msg += " POSTDATED;"
        end
        if ((flags[7]).equal?(true))
          msg += " INVALID;"
        end
        if ((flags[8]).equal?(true))
          msg += " RENEWABLE;"
        end
        if ((flags[9]).equal?(true))
          msg += " INITIAL;"
        end
        if ((flags[10]).equal?(true))
          msg += " PRE_AUTH;"
        end
        if ((flags[11]).equal?(true))
          msg += " HW_AUTH;"
        end
        System.out.println(msg)
      end
      return flags
    end
    
    typesig { [::Java::Int] }
    def read_cred(version)
      cpname = read_principal(version)
      if (self.attr_debug)
        System.out.println(">>>DEBUG <CCacheInputStream>  client principal is " + RJava.cast_to_string(cpname.to_s))
      end
      spname = read_principal(version)
      if (self.attr_debug)
        System.out.println(">>>DEBUG <CCacheInputStream> server principal is " + RJava.cast_to_string(spname.to_s))
      end
      key = read_key(version)
      if (self.attr_debug)
        System.out.println(">>>DEBUG <CCacheInputStream> key type: " + RJava.cast_to_string(key.get_etype))
      end
      times = read_times
      authtime = KerberosTime.new(times[0])
      starttime = KerberosTime.new(times[1])
      endtime = KerberosTime.new(times[2])
      renew_till = KerberosTime.new(times[3])
      if (self.attr_debug)
        System.out.println(">>>DEBUG <CCacheInputStream> auth time: " + RJava.cast_to_string(authtime.to_date.to_s))
        System.out.println(">>>DEBUG <CCacheInputStream> start time: " + RJava.cast_to_string(starttime.to_date.to_s))
        System.out.println(">>>DEBUG <CCacheInputStream> end time: " + RJava.cast_to_string(endtime.to_date.to_s))
        System.out.println(">>>DEBUG <CCacheInputStream> renew_till time: " + RJava.cast_to_string(renew_till.to_date.to_s))
      end
      skey = readskey
      flags = read_flags
      t_flags = TicketFlags.new(flags)
      addr = read_addr
      addrs = nil
      if (!(addr).nil?)
        addrs = HostAddresses.new(addr)
      end
      au_data_entry = read_auth
      au_data = nil
      if (!(au_data).nil?)
        au_data = AuthorizationData.new(au_data_entry)
      end
      ticket = read_data
      if (self.attr_debug)
        System.out.println(">>>DEBUG <CCacheInputStream>")
        if ((ticket).nil?)
          System.out.println("///ticket is null")
        end
      end
      sec_ticket = read_data
      cred = Credentials.new(cpname, spname, key, authtime, starttime, endtime, renew_till, skey, t_flags, addrs, au_data, ticket, sec_ticket)
      return cred
    end
    
    private
    alias_method :initialize__ccache_input_stream, :initialize
  end
  
end

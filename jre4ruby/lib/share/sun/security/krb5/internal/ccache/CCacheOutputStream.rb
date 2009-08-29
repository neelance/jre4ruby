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
module Sun::Security::Krb5::Internal::Ccache
  module CCacheOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Sun::Security::Krb5::Internal::Util, :KrbDataOutputStream
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  # This class implements a buffered output stream. It provides functions to write FCC-format data to a disk file.
  # 
  # @author Yanni Zhang
  class CCacheOutputStream < CCacheOutputStreamImports.const_get :KrbDataOutputStream
    include_class_members CCacheOutputStreamImports
    overload_protected {
      include FileCCacheConstants
    }
    
    typesig { [OutputStream] }
    def initialize(os)
      super(os)
    end
    
    typesig { [PrincipalName, ::Java::Int] }
    def write_header(p, version)
      write((version & 0xff00) >> 8)
      write(version & 0xff)
      p.write_principal(self)
    end
    
    typesig { [Credentials] }
    # Writes a credentials in FCC format to this cache output stream.
    # 
    # @param creds the credentials to be written to the output stream.
    # @exception IOException if an I/O exception occurs.
    # @exception Asn1Exception  if an Asn1Exception occurs.
    # 
    # For object data fields which themselves have multiple data fields, such as PrincipalName, EncryptionKey
    # HostAddresses, AuthorizationData, I created corresponding write methods (writePrincipal,
    # writeKey,...) in each class, since converting the object into FCC format data stream
    # should be encapsulated in object itself.
    def add_creds(creds)
      creds.attr_cname.write_principal(self)
      creds.attr_sname.write_principal(self)
      creds.attr_key.write_key(self)
      write32(RJava.cast_to_int((creds.attr_authtime.get_time / 1000)))
      if (!(creds.attr_starttime).nil?)
        write32(RJava.cast_to_int((creds.attr_starttime.get_time / 1000)))
      else
        write32(0)
      end
      write32(RJava.cast_to_int((creds.attr_endtime.get_time / 1000)))
      if (!(creds.attr_renew_till).nil?)
        write32(RJava.cast_to_int((creds.attr_renew_till.get_time / 1000)))
      else
        write32(0)
      end
      if (creds.attr_is_enc_in_skey)
        write8(1)
      else
        write8(0)
      end
      write_flags(creds.attr_flags)
      if ((creds.attr_caddr).nil?)
        write32(0)
      else
        creds.attr_caddr.write_addrs(self)
      end
      if ((creds.attr_authorization_data).nil?)
        write32(0)
      else
        creds.attr_authorization_data.write_auth(self)
      end
      write_ticket(creds.attr_ticket)
      write_ticket(creds.attr_second_ticket)
    end
    
    typesig { [Ticket] }
    def write_ticket(t)
      if ((t).nil?)
        write32(0)
      else
        bytes = t.asn1_encode
        write32(bytes.attr_length)
        write(bytes, 0, bytes.attr_length)
      end
    end
    
    typesig { [TicketFlags] }
    def write_flags(flags)
      t_flags = 0
      f = flags.to_boolean_array
      if ((f[1]).equal?(true))
        t_flags |= TKT_FLG_FORWARDABLE
      end
      if ((f[2]).equal?(true))
        t_flags |= TKT_FLG_FORWARDED
      end
      if ((f[3]).equal?(true))
        t_flags |= TKT_FLG_PROXIABLE
      end
      if ((f[4]).equal?(true))
        t_flags |= TKT_FLG_PROXY
      end
      if ((f[5]).equal?(true))
        t_flags |= TKT_FLG_MAY_POSTDATE
      end
      if ((f[6]).equal?(true))
        t_flags |= TKT_FLG_POSTDATED
      end
      if ((f[7]).equal?(true))
        t_flags |= TKT_FLG_INVALID
      end
      if ((f[8]).equal?(true))
        t_flags |= TKT_FLG_RENEWABLE
      end
      if ((f[9]).equal?(true))
        t_flags |= TKT_FLG_INITIAL
      end
      if ((f[10]).equal?(true))
        t_flags |= TKT_FLG_PRE_AUTH
      end
      if ((f[11]).equal?(true))
        t_flags |= TKT_FLG_HW_AUTH
      end
      write32(t_flags)
    end
    
    private
    alias_method :initialize__ccache_output_stream, :initialize
  end
  
end

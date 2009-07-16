require "rjava"

# 
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
module Sun::Security::Krb5::Internal
  module KrbCredInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # Implements the ASN.1 KrbCredInfo type.
  # 
  # <xmp>
  # KrbCredInfo  ::= SEQUENCE {
  # key             [0] EncryptionKey,
  # prealm          [1] Realm OPTIONAL,
  # pname           [2] PrincipalName OPTIONAL,
  # flags           [3] TicketFlags OPTIONAL,
  # authtime        [4] KerberosTime OPTIONAL,
  # starttime       [5] KerberosTime OPTIONAL,
  # endtime         [6] KerberosTime OPTIONAL,
  # renew-till      [7] KerberosTime OPTIONAL,
  # srealm          [8] Realm OPTIONAL,
  # sname           [9] PrincipalName OPTIONAL,
  # caddr           [10] HostAddresses OPTIONAL
  # }
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KrbCredInfo 
    include_class_members KrbCredInfoImports
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :prealm
    alias_method :attr_prealm, :prealm
    undef_method :prealm
    alias_method :attr_prealm=, :prealm=
    undef_method :prealm=
    
    # optional
    attr_accessor :pname
    alias_method :attr_pname, :pname
    undef_method :pname
    alias_method :attr_pname=, :pname=
    undef_method :pname=
    
    # optional
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    # optional
    attr_accessor :authtime
    alias_method :attr_authtime, :authtime
    undef_method :authtime
    alias_method :attr_authtime=, :authtime=
    undef_method :authtime=
    
    # optional
    attr_accessor :starttime
    alias_method :attr_starttime, :starttime
    undef_method :starttime
    alias_method :attr_starttime=, :starttime=
    undef_method :starttime=
    
    # optional
    attr_accessor :endtime
    alias_method :attr_endtime, :endtime
    undef_method :endtime
    alias_method :attr_endtime=, :endtime=
    undef_method :endtime=
    
    # optional
    attr_accessor :renew_till
    alias_method :attr_renew_till, :renew_till
    undef_method :renew_till
    alias_method :attr_renew_till=, :renew_till=
    undef_method :renew_till=
    
    # optional
    attr_accessor :srealm
    alias_method :attr_srealm, :srealm
    undef_method :srealm
    alias_method :attr_srealm=, :srealm=
    undef_method :srealm=
    
    # optional
    attr_accessor :sname
    alias_method :attr_sname, :sname
    undef_method :sname
    alias_method :attr_sname=, :sname=
    undef_method :sname=
    
    # optional
    attr_accessor :caddr
    alias_method :attr_caddr, :caddr
    undef_method :caddr
    alias_method :attr_caddr=, :caddr=
    undef_method :caddr=
    
    typesig { [] }
    # optional
    def initialize
      @key = nil
      @prealm = nil
      @pname = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
    end
    
    typesig { [EncryptionKey, Realm, PrincipalName, TicketFlags, KerberosTime, KerberosTime, KerberosTime, KerberosTime, Realm, PrincipalName, HostAddresses] }
    def initialize(new_key, new_prealm, new_pname, new_flags, new_authtime, new_starttime, new_endtime, new_renew_till, new_srealm, new_sname, new_caddr)
      @key = nil
      @prealm = nil
      @pname = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @key = new_key
      @prealm = new_prealm
      @pname = new_pname
      @flags = new_flags
      @authtime = new_authtime
      @starttime = new_starttime
      @endtime = new_endtime
      @renew_till = new_renew_till
      @srealm = new_srealm
      @sname = new_sname
      @caddr = new_caddr
    end
    
    typesig { [DerValue] }
    # 
    # Constructs a KrbCredInfo object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def initialize(encoding)
      @key = nil
      @prealm = nil
      @pname = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      @prealm = nil
      @pname = nil
      @flags = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @srealm = nil
      @sname = nil
      @caddr = nil
      @key = EncryptionKey.parse(encoding.get_data, 0x0, false)
      if (encoding.get_data.available > 0)
        @prealm = Realm.parse(encoding.get_data, 0x1, true)
      end
      if (encoding.get_data.available > 0)
        @pname = PrincipalName.parse(encoding.get_data, 0x2, true)
      end
      if (encoding.get_data.available > 0)
        @flags = TicketFlags.parse(encoding.get_data, 0x3, true)
      end
      if (encoding.get_data.available > 0)
        @authtime = KerberosTime.parse(encoding.get_data, 0x4, true)
      end
      if (encoding.get_data.available > 0)
        @starttime = KerberosTime.parse(encoding.get_data, 0x5, true)
      end
      if (encoding.get_data.available > 0)
        @endtime = KerberosTime.parse(encoding.get_data, 0x6, true)
      end
      if (encoding.get_data.available > 0)
        @renew_till = KerberosTime.parse(encoding.get_data, 0x7, true)
      end
      if (encoding.get_data.available > 0)
        @srealm = Realm.parse(encoding.get_data, 0x8, true)
      end
      if (encoding.get_data.available > 0)
        @sname = PrincipalName.parse(encoding.get_data, 0x9, true)
      end
      if (encoding.get_data.available > 0)
        @caddr = HostAddresses.parse(encoding.get_data, 0xa, true)
      end
      if (encoding.get_data.available > 0)
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    typesig { [] }
    # 
    # Encodes an KrbCredInfo object.
    # @return the byte array of encoded KrbCredInfo object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      v = Vector.new
      v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @key.asn1_encode))
      if (!(@prealm).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), @prealm.asn1_encode))
      end
      if (!(@pname).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), @pname.asn1_encode))
      end
      if (!(@flags).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), @flags.asn1_encode))
      end
      if (!(@authtime).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x4), @authtime.asn1_encode))
      end
      if (!(@starttime).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x5), @starttime.asn1_encode))
      end
      if (!(@endtime).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x6), @endtime.asn1_encode))
      end
      if (!(@renew_till).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x7), @renew_till.asn1_encode))
      end
      if (!(@srealm).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x8), @srealm.asn1_encode))
      end
      if (!(@sname).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x9), @sname.asn1_encode))
      end
      if (!(@caddr).nil?)
        v.add_element(DerValue.new(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0xa), @caddr.asn1_encode))
      end
      der = Array.typed(DerValue).new(v.size) { nil }
      v.copy_into(der)
      out = DerOutputStream.new
      out.put_sequence(der)
      return out.to_byte_array
    end
    
    typesig { [] }
    def clone
      kcred = KrbCredInfo.new
      kcred.attr_key = @key.clone
      # optional fields
      if (!(@prealm).nil?)
        kcred.attr_prealm = @prealm.clone
      end
      if (!(@pname).nil?)
        kcred.attr_pname = @pname.clone
      end
      if (!(@flags).nil?)
        kcred.attr_flags = @flags.clone
      end
      if (!(@authtime).nil?)
        kcred.attr_authtime = @authtime.clone
      end
      if (!(@starttime).nil?)
        kcred.attr_starttime = @starttime.clone
      end
      if (!(@endtime).nil?)
        kcred.attr_endtime = @endtime.clone
      end
      if (!(@renew_till).nil?)
        kcred.attr_renew_till = @renew_till.clone
      end
      if (!(@srealm).nil?)
        kcred.attr_srealm = @srealm.clone
      end
      if (!(@sname).nil?)
        kcred.attr_sname = @sname.clone
      end
      if (!(@caddr).nil?)
        kcred.attr_caddr = @caddr.clone
      end
      return kcred
    end
    
    private
    alias_method :initialize__krb_cred_info, :initialize
  end
  
end

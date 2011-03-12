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
module Sun::Security::Krb5
  module KrbAppMessageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class KrbAppMessage 
    include_class_members KrbAppMessageImports
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    typesig { [KerberosTime, JavaInteger, JavaInteger, HostAddress, HostAddress, SeqNumber, HostAddress, HostAddress, ::Java::Boolean, ::Java::Boolean, PrincipalName, Realm] }
    # Common checks for KRB-PRIV and KRB-SAFE
    def check(packet_timestamp, packet_usec, packet_seq_number, packet_saddress, packet_raddress, seq_number, s_address, r_address, timestamp_required, seq_number_required, packet_principal, packet_realm)
      if (!Krb5::AP_EMPTY_ADDRESSES_ALLOWED || !(s_address).nil?)
        if ((packet_saddress).nil? || (s_address).nil? || !(packet_saddress == s_address))
          if (self.attr_debug && (packet_saddress).nil?)
            System.out.println("packetSAddress is null")
          end
          if (self.attr_debug && (s_address).nil?)
            System.out.println("sAddress is null")
          end
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADADDR)
        end
      end
      if (!Krb5::AP_EMPTY_ADDRESSES_ALLOWED || !(r_address).nil?)
        if ((packet_raddress).nil? || (r_address).nil? || !(packet_raddress == r_address))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADADDR)
        end
      end
      if (!(packet_timestamp).nil?)
        packet_timestamp.set_micro_seconds(packet_usec)
        if (!packet_timestamp.in_clock_skew)
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_SKEW)
        end
      else
        if (timestamp_required)
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_SKEW)
        end
      end
      # XXX check replay cache
      # if (rcache.repeated(packetTimestamp, packetUsec, packetSAddress))
      #      throw new KrbApErrException(Krb5.KRB_AP_ERR_REPEAT);
      # XXX consider moving up to api level
      if ((seq_number).nil? && (seq_number_required).equal?(true))
        raise KrbApErrException.new(Krb5::API_INVALID_ARG)
      end
      if (!(packet_seq_number).nil? && !(seq_number).nil?)
        if (!(packet_seq_number.int_value).equal?(seq_number.current))
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADORDER)
        end
        # should be done only when no more exceptions are possible
        seq_number.step
      else
        if (seq_number_required)
          raise KrbApErrException.new(Krb5::KRB_AP_ERR_BADORDER)
        end
      end
      # Must not be relaxed, per RFC 4120
      if ((packet_timestamp).nil? && (packet_seq_number).nil?)
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_MODIFIED)
      end
      # XXX check replay cache
      # rcache.save_identifier(packetTimestamp, packetUsec, packetSAddress,
      # packetPrincipal, pcaketRealm);
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__krb_app_message, :initialize
  end
  
end

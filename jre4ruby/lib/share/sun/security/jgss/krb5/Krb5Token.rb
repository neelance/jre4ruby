require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Krb5
  module Krb5TokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
      include ::Sun::Security::Jgss
    }
  end
  
  # This class represents a base class for all Kerberos v5 GSS-API
  # tokens. It contains commonly used definitions and utilities.
  # 
  # @author Mayank Upadhyay
  class Krb5Token < Krb5TokenImports.const_get :GSSToken
    include_class_members Krb5TokenImports
    
    class_module.module_eval {
      # The token id defined for the token emitted by the initSecContext call
      # carrying the AP_REQ .
      const_set_lazy(:AP_REQ_ID) { 0x100 }
      const_attr_reader  :AP_REQ_ID
      
      # The token id defined for the token emitted by the acceptSecContext call
      # carrying the AP_REP .
      const_set_lazy(:AP_REP_ID) { 0x200 }
      const_attr_reader  :AP_REP_ID
      
      # The token id defined for any token carrying a KRB-ERR message.
      const_set_lazy(:ERR_ID) { 0x300 }
      const_attr_reader  :ERR_ID
      
      # The token id defined for the token emitted by the getMIC call.
      const_set_lazy(:MIC_ID) { 0x101 }
      const_attr_reader  :MIC_ID
      
      # The token id defined for the token emitted by the wrap call.
      const_set_lazy(:WRAP_ID) { 0x201 }
      const_attr_reader  :WRAP_ID
      
      # new token ID draft-ietf-krb-wg-gssapi-cfx-07.txt
      const_set_lazy(:MIC_ID_v2) { 0x404 }
      const_attr_reader  :MIC_ID_v2
      
      const_set_lazy(:WRAP_ID_v2) { 0x504 }
      const_attr_reader  :WRAP_ID_v2
      
      # The object identifier corresponding to the Kerberos v5 GSS-API
      # mechanism.
      
      def oid
        defined?(@@oid) ? @@oid : @@oid= nil
      end
      alias_method :attr_oid, :oid
      
      def oid=(value)
        @@oid = value
      end
      alias_method :attr_oid=, :oid=
      
      when_class_loaded do
        begin
          self.attr_oid = ObjectIdentifier.new(Krb5MechFactory::GSS_KRB5_MECH_OID.to_s)
        rescue IOException => ioe
          # should not happen
        end
      end
      
      typesig { [::Java::Int] }
      # Returns a strign representing the token type.
      # 
      # @param tokenId the token id for which a string name is desired
      # @return the String name of this token type
      def get_token_name(token_id)
        ret_val = nil
        case (token_id)
        when AP_REQ_ID, AP_REP_ID
          ret_val = "Context Establishment Token"
        when MIC_ID
          ret_val = "MIC Token"
        when MIC_ID_v2
          ret_val = "MIC Token (new format)"
        when WRAP_ID
          ret_val = "Wrap Token"
        when WRAP_ID_v2
          ret_val = "Wrap Token (new format)"
        else
          ret_val = "Kerberos GSS-API Mechanism Token"
        end
        return ret_val
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__krb5token, :initialize
  end
  
end

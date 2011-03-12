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
module Sun::Security::Krb5::Internal::Rcache
  module CacheTableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Rcache
      include_const ::Java::Util, :Hashtable
      include_const ::Sun::Security::Krb5::Internal, :KerberosTime
    }
  end
  
  # This class implements Hashtable to store the replay caches.
  # 
  # @author Yanni Zhang
  class CacheTable < CacheTableImports.const_get :Hashtable
    include_class_members CacheTableImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -4695501354546664910 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [] }
    def initialize
      @debug = false
      super()
      @debug = Sun::Security::Krb5::Internal::Krb5::DEBUG
    end
    
    typesig { [String, AuthTime, ::Java::Long] }
    # Puts the client timestamp in replay cache.
    # @params principal the client's principal name.
    # @params time authenticator timestamp.
    def put(principal, time, curr_time)
      synchronized(self) do
        rc = Hashtable.instance_method(:get).bind(self).call(principal)
        if ((rc).nil?)
          if (@debug)
            System.out.println("replay cache for " + principal + " is null.")
          end
          rc = ReplayCache.new(principal, self)
          rc.put(time, curr_time)
          super(principal, rc)
        else
          rc.put(time, curr_time)
          # re-insert the entry, since rc.put could have removed the entry
          super(principal, rc)
          if (@debug)
            System.out.println("replay cache found.")
          end
        end
      end
    end
    
    typesig { [AuthTime, String] }
    # This method tests if replay cache keeps a record of the authenticator's time stamp.
    # If there is a record (replay attack detected), the server should reject the client request.
    # @params principal the client's principal name.
    # @params time authenticator timestamp.
    # @return null if no record found, else return an <code>AuthTime</code> object.
    def get(time, principal)
      rc = super(principal)
      if ((!(rc).nil?) && (rc.contains(time)))
        return time
      end
      return nil
    end
    
    private
    alias_method :initialize__cache_table, :initialize
  end
  
end

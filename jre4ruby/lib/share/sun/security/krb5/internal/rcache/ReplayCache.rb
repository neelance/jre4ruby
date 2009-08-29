require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal::Rcache
  module ReplayCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Rcache
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Sun::Security::Krb5::Internal, :KerberosTime
    }
  end
  
  # This class provides an efficient caching mechanism to store the timestamp of client authenticators.
  # The cache minimizes the memory usage by doing self-cleanup of expired items in the cache.
  # 
  # @author Yanni Zhang
  class ReplayCache < ReplayCacheImports.const_get :LinkedList
    include_class_members ReplayCacheImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2997933194993803994 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :principal
    alias_method :attr_principal, :principal
    undef_method :principal
    alias_method :attr_principal=, :principal=
    undef_method :principal=
    
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    attr_accessor :nap
    alias_method :attr_nap, :nap
    undef_method :nap
    alias_method :attr_nap=, :nap=
    undef_method :nap=
    
    # 10 minutes break
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [String, CacheTable] }
    # Constructs a ReplayCache for a client principal in specified <code>CacheTable</code>.
    # @param p client principal name.
    # @param ct CacheTable.
    def initialize(p, ct)
      @principal = nil
      @table = nil
      @nap = 0
      @debug = false
      super()
      @nap = 10 * 60 * 1000
      @debug = Krb5::DEBUG
      @principal = p
      @table = ct
    end
    
    typesig { [AuthTime, ::Java::Long] }
    # Puts the authenticator timestamp into the cache in descending order.
    # @param t <code>AuthTime</code>
    def put(t, current_time)
      synchronized(self) do
        if ((self.size).equal?(0))
          add_first(t)
        else
          temp = get_first
          if (temp.attr_kerberos_time < t.attr_kerberos_time)
            # in most cases, newly received authenticator has
            # larger timestamp.
            add_first(t)
          else
            if ((temp.attr_kerberos_time).equal?(t.attr_kerberos_time))
              if (temp.attr_cusec < t.attr_cusec)
                add_first(t)
              end
            else
              # unless client clock being re-adjusted.
              it = list_iterator(1)
              while (it.has_next)
                temp = it.next_
                if (temp.attr_kerberos_time < t.attr_kerberos_time)
                  add(index_of(temp), t)
                  break
                  # we always put the bigger timestamp at the front.
                else
                  if ((temp.attr_kerberos_time).equal?(t.attr_kerberos_time))
                    if (temp.attr_cusec < t.attr_cusec)
                      add(index_of(temp), t)
                      break
                    end
                  end
                end
              end
            end
          end
        end
        # let us cleanup while we are here
        time_limit = current_time - KerberosTime.get_default_skew * 1000
        it = list_iterator(0)
        temp = nil
        index = -1
        while (it.has_next)
          # search expired timestamps.
          temp = it.next_
          if (temp.attr_kerberos_time < time_limit)
            index = index_of(temp)
            break
          end
        end
        if (index > -1)
          begin
            # remove expired timestamps from the list.
            remove_last
          end while (size > index)
        end
        if (@debug)
          print_list
        end
        # if there are no entries in the replay cache,
        # remove the replay cache from the table.
        if ((self.size).equal?(0))
          @table.remove(@principal)
        end
        if (@debug)
          print_list
        end
      end
    end
    
    typesig { [] }
    # Printes out the debug message.
    def print_list
      total = to_array
      i = 0
      while i < total.attr_length
        System.out.println("object " + RJava.cast_to_string(i) + ": " + RJava.cast_to_string((total[i]).attr_kerberos_time) + "/" + RJava.cast_to_string((total[i]).attr_cusec))
        i += 1
      end
    end
    
    private
    alias_method :initialize__replay_cache, :initialize
  end
  
end

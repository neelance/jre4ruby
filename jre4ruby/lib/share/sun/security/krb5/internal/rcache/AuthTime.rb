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
  module AuthTimeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Rcache
      include_const ::Sun::Security::Krb5::Internal, :KerberosTime
    }
  end
  
  # The class represents the timestamp in authenticator.
  # 
  # @author Yanni Zhang
  class AuthTime 
    include_class_members AuthTimeImports
    
    attr_accessor :kerberos_time
    alias_method :attr_kerberos_time, :kerberos_time
    undef_method :kerberos_time
    alias_method :attr_kerberos_time=, :kerberos_time=
    undef_method :kerberos_time=
    
    attr_accessor :cusec
    alias_method :attr_cusec, :cusec
    undef_method :cusec
    alias_method :attr_cusec=, :cusec=
    undef_method :cusec=
    
    typesig { [::Java::Long, ::Java::Int] }
    # Constructs a new <code>AuthTime</code>.
    # @param time time from the <code>Authenticator</code>.
    # @param cusec microsecond field from the <code>Authenticator</code>.
    def initialize(time, c)
      @kerberos_time = 0
      @cusec = 0
      @kerberos_time = time
      @cusec = c
    end
    
    typesig { [Object] }
    # Compares if an object equals to an <code>AuthTime</code> object.
    # @param o an object.
    # @return true if two objects are equivalent, otherwise, return false.
    def ==(o)
      if (o.is_a?(AuthTime))
        if ((((o).attr_kerberos_time).equal?(@kerberos_time)) && (((o).attr_cusec).equal?(@cusec)))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns a hash code for this <code>AuthTime</code> object.
    # 
    # @return  a <code>hash code</code> value for this object.
    def hash_code
      result = 17
      result = 37 * result + ((@kerberos_time ^ (@kerberos_time >> 32))).to_int
      result = 37 * result + @cusec
      return result
    end
    
    private
    alias_method :initialize__auth_time, :initialize
  end
  
end

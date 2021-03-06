require "rjava"

# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Acl
  module PrincipalImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include ::Java::Security
    }
  end
  
  # This class implements the principal interface.
  # 
  # @author      Satish Dharmaraj
  class PrincipalImpl 
    include_class_members PrincipalImplImports
    include Principal
    
    attr_accessor :user
    alias_method :attr_user, :user
    undef_method :user
    alias_method :attr_user=, :user=
    undef_method :user=
    
    typesig { [String] }
    # Construct a principal from a string user name.
    # @param user The string form of the principal name.
    def initialize(user)
      @user = nil
      @user = user
    end
    
    typesig { [Object] }
    # This function returns true if the object passed matches
    # the principal represented in this implementation
    # @param another the Principal to compare with.
    # @return true if the Principal passed is the same as that
    # encapsulated in this object, false otherwise
    def ==(another)
      if (another.is_a?(PrincipalImpl))
        p = another
        return (@user == p.to_s)
      else
        return false
      end
    end
    
    typesig { [] }
    # Prints a stringified version of the principal.
    def to_s
      return @user
    end
    
    typesig { [] }
    # return a hashcode for the principal.
    def hash_code
      return @user.hash_code
    end
    
    typesig { [] }
    # return the name of the principal.
    def get_name
      return @user
    end
    
    private
    alias_method :initialize__principal_impl, :initialize
  end
  
end

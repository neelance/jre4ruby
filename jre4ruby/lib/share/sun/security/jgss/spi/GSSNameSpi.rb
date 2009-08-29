require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Spi
  module GSSNameSpiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spi
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
    }
  end
  
  # This interface is implemented by a mechanism specific name element. A
  # GSSName is conceptually a container class of several name elements from
  # different mechanisms.
  # 
  # @author Mayank Upadhyay
  module GSSNameSpi
    include_class_members GSSNameSpiImports
    
    typesig { [] }
    def get_provider
      raise NotImplementedError
    end
    
    typesig { [GSSNameSpi] }
    # Equals method for the GSSNameSpi objects.
    # If either name denotes an anonymous principal, the call should
    # return false.
    # 
    # @param name to be compared with
    # @returns true if they both refer to the same entity, else false
    # @exception GSSException with major codes of BAD_NAMETYPE,
    # BAD_NAME, FAILURE
    def ==(name)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Compares this <code>GSSNameSpi</code> object to another Object
    # that might be a <code>GSSNameSpi</code>. The behaviour is exactly
    # the same as in {@link #equals(GSSNameSpi) equals} except that
    # no GSSException is thrown; instead, false will be returned in the
    # situation where an error occurs.
    # 
    # @param another the object to be compared to
    # @returns true if they both refer to the same entity, else false
    # @see #equals(GSSNameSpi)
    def ==(another)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a hashcode value for this GSSNameSpi.
    # 
    # @return a hashCode value
    def hash_code
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a flat name representation for this object. The name
    # format is defined in RFC 2078.
    # 
    # @return the flat name representation for this object
    # @exception GSSException with major codes NAME_NOT_MN, BAD_NAME,
    # BAD_NAME, FAILURE.
    def export
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get the mechanism type that this NameElement corresponds to.
    # 
    # @return the Oid of the mechanism type
    def get_mechanism
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a string representation for this name. The printed
    # name type can be obtained by calling getStringNameType().
    # 
    # @return string form of this name
    # @see #getStringNameType()
    # @overrides Object#toString
    def to_s
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the oid describing the format of the printable name.
    # 
    # @return the Oid for the format of the printed name
    def get_string_name_type
      raise NotImplementedError
    end
    
    typesig { [] }
    # Indicates if this name object represents an Anonymous name.
    def is_anonymous_name
      raise NotImplementedError
    end
  end
  
end

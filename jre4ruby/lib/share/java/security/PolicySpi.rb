require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module PolicySpiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>Policy</code> class.
  # All the abstract methods in this class must be implemented by each
  # service provider who wishes to supply a Policy implementation.
  # 
  # <p> Subclass implementations of this abstract class must provide
  # a public constructor that takes a <code>Policy.Parameters</code>
  # object as an input parameter.  This constructor also must throw
  # an IllegalArgumentException if it does not understand the
  # <code>Policy.Parameters</code> input.
  # 
  # 
  # @since 1.6
  class PolicySpi 
    include_class_members PolicySpiImports
    
    typesig { [ProtectionDomain, Permission] }
    # Check whether the policy has granted a Permission to a ProtectionDomain.
    # 
    # @param domain the ProtectionDomain to check.
    # 
    # @param permission check whether this permission is granted to the
    #          specified domain.
    # 
    # @return boolean true if the permission is granted to the domain.
    def engine_implies(domain, permission)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Refreshes/reloads the policy configuration. The behavior of this method
    # depends on the implementation. For example, calling <code>refresh</code>
    # on a file-based policy will cause the file to be re-read.
    # 
    # <p> The default implementation of this method does nothing.
    # This method should be overridden if a refresh operation is supported
    # by the policy implementation.
    def engine_refresh
    end
    
    typesig { [CodeSource] }
    # Return a PermissionCollection object containing the set of
    # permissions granted to the specified CodeSource.
    # 
    # <p> The default implementation of this method returns
    # Policy.UNSUPPORTED_EMPTY_COLLECTION object.  This method can be
    # overridden if the policy implementation can return a set of
    # permissions granted to a CodeSource.
    # 
    # @param codesource the CodeSource to which the returned
    #          PermissionCollection has been granted.
    # 
    # @return a set of permissions granted to the specified CodeSource.
    #          If this operation is supported, the returned
    #          set of permissions must be a new mutable instance
    #          and it must support heterogeneous Permission types.
    #          If this operation is not supported,
    #          Policy.UNSUPPORTED_EMPTY_COLLECTION is returned.
    def engine_get_permissions(codesource)
      return Policy::UNSUPPORTED_EMPTY_COLLECTION
    end
    
    typesig { [ProtectionDomain] }
    # Return a PermissionCollection object containing the set of
    # permissions granted to the specified ProtectionDomain.
    # 
    # <p> The default implementation of this method returns
    # Policy.UNSUPPORTED_EMPTY_COLLECTION object.  This method can be
    # overridden if the policy implementation can return a set of
    # permissions granted to a ProtectionDomain.
    # 
    # @param domain the ProtectionDomain to which the returned
    #          PermissionCollection has been granted.
    # 
    # @return a set of permissions granted to the specified ProtectionDomain.
    #          If this operation is supported, the returned
    #          set of permissions must be a new mutable instance
    #          and it must support heterogeneous Permission types.
    #          If this operation is not supported,
    #          Policy.UNSUPPORTED_EMPTY_COLLECTION is returned.
    def engine_get_permissions(domain)
      return Policy::UNSUPPORTED_EMPTY_COLLECTION
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__policy_spi, :initialize
  end
  
end

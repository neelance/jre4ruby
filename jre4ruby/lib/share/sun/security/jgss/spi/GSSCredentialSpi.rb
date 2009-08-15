require "rjava"

# Copyright 2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GSSCredentialSpiImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spi
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
    }
  end
  
  # This interface is implemented by a mechanism specific credential
  # element. A GSSCredential is conceptually a container class of several
  # credential elements from different mechanisms.
  # 
  # @author Mayank Upadhyay
  module GSSCredentialSpi
    include_class_members GSSCredentialSpiImports
    
    typesig { [] }
    def get_provider
      raise NotImplementedError
    end
    
    typesig { [] }
    # Called to invalidate this credential element and release
    # any system recourses and cryptographic information owned
    # by the credential.
    # 
    # @exception GSSException with major codes NO_CRED and FAILURE
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the principal name for this credential. The name
    # is in mechanism specific format.
    # 
    # @return GSSNameSpi representing principal name of this credential
    # @exception GSSException may be thrown
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the init lifetime remaining.
    # 
    # @return the init lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_init_lifetime
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the accept lifetime remaining.
    # 
    # @return the accept lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_accept_lifetime
      raise NotImplementedError
    end
    
    typesig { [] }
    # Determines if this credential element can be used by a context
    # initiator.
    # @return true if it can be used for initiating contexts
    def is_initiator_credential
      raise NotImplementedError
    end
    
    typesig { [] }
    # Determines if this credential element can be used by a context
    # acceptor.
    # @return true if it can be used for accepting contexts
    def is_acceptor_credential
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the oid representing the underlying credential
    # mechanism oid.
    # 
    # @return the Oid for this credential mechanism
    # @exception GSSException may be thrown
    def get_mechanism
      raise NotImplementedError
    end
  end
  
end

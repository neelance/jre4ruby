require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider::Certpath
  module StateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertPathValidatorException
    }
  end
  
  # A specification of a PKIX validation state
  # which is initialized by each build and updated each time a
  # certificate is added to the current path.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  module State
    include_class_members StateImports
    include Cloneable
    
    typesig { [X509Certificate] }
    # Update the state with the next certificate added to the path.
    # 
    # @param cert the certificate which is used to update the state
    def update_state(cert)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Creates and returns a copy of this object
    def clone
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a boolean flag indicating if the state is initial
    # (just starting)
    # 
    # @return boolean flag indicating if the state is initial (just starting)
    def is_initial
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a boolean flag indicating if a key lacking necessary key
    # algorithm parameters has been encountered.
    # 
    # @return boolean flag indicating if key lacking parameters encountered.
    def key_params_needed
      raise NotImplementedError
    end
  end
  
end

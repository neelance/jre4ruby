require "rjava"

# Copyright 1998-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Interfaces
  module RSAPublicKeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Interfaces
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # The interface to an RSA public key.
  # 
  # @author Jan Luehe
  module RSAPublicKey
    include_class_members RSAPublicKeyImports
    include Java::Security::PublicKey
    include RSAKey
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8727434096241101194 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Returns the public exponent.
    # 
    # @return the public exponent
    def get_public_exponent
      raise NotImplementedError
    end
  end
  
end

require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DSAPublicKeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Interfaces
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # The interface to a DSA public key. DSA (Digital Signature Algorithm)
  # is defined in NIST's FIPS-186.
  # 
  # @see java.security.Key
  # @see java.security.Signature
  # @see DSAKey
  # @see DSAPrivateKey
  # 
  # @author Benjamin Renaud
  module DSAPublicKey
    include_class_members DSAPublicKeyImports
    include DSAKey
    include Java::Security::PublicKey
    
    class_module.module_eval {
      # Declare serialVersionUID to be compatible with JDK1.1
      # The class fingerprint that is set to indicate
      # serialization compatibility with a previous
      # version of the class.
      const_set_lazy(:SerialVersionUID) { 1234526332779022332 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Returns the value of the public key, <code>y</code>.
    # 
    # @return the value of the public key, <code>y</code>.
    def get_y
      raise NotImplementedError
    end
  end
  
end

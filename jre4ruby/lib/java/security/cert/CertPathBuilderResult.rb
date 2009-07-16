require "rjava"

# 
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
module Java::Security::Cert
  module CertPathBuilderResultImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
    }
  end
  
  # 
  # A specification of the result of a certification path builder algorithm.
  # All results returned by the {@link CertPathBuilder#build
  # CertPathBuilder.build} method must implement this interface.
  # <p>
  # At a minimum, a <code>CertPathBuilderResult</code> contains the
  # <code>CertPath</code> built by the <code>CertPathBuilder</code> instance.
  # Implementations of this interface may add methods to return implementation
  # or algorithm specific information, such as debugging information or
  # certification path validation results.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this interface are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathBuilder
  # 
  # @since       1.4
  # @author      Sean Mullan
  module CertPathBuilderResult
    include_class_members CertPathBuilderResultImports
    include Cloneable
    
    typesig { [] }
    # 
    # Returns the built certification path.
    # 
    # @return the certification path (never <code>null</code>)
    def get_cert_path
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Makes a copy of this <code>CertPathBuilderResult</code>. Changes to the
    # copy will not affect the original and vice versa.
    # 
    # @return a copy of this <code>CertPathBuilderResult</code>
    def clone
      raise NotImplementedError
    end
  end
  
end

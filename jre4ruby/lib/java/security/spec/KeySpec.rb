require "rjava"

# Copyright 1997-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Spec
  module KeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
    }
  end
  
  # A (transparent) specification of the key material
  # that constitutes a cryptographic key.
  # 
  # <p>If the key is stored on a hardware device, its
  # specification may contain information that helps identify the key on the
  # device.
  # 
  # <P> A key may be specified in an algorithm-specific way, or in an
  # algorithm-independent encoding format (such as ASN.1).
  # For example, a DSA private key may be specified by its components
  # <code>x</code>, <code>p</code>, <code>q</code>, and <code>g</code>
  # (see {@link DSAPrivateKeySpec}), or it may be
  # specified using its DER encoding
  # (see {@link PKCS8EncodedKeySpec}).
  # 
  # <P> This interface contains no methods or constants. Its only purpose
  # is to group (and provide type safety for) all key specifications.
  # All key specifications must implement this interface.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see EncodedKeySpec
  # @see X509EncodedKeySpec
  # @see PKCS8EncodedKeySpec
  # @see DSAPrivateKeySpec
  # @see DSAPublicKeySpec
  # 
  # @since 1.2
  module KeySpec
    include_class_members KeySpecImports
  end
  
end

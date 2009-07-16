require "rjava"

# 
# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EncodedKeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
    }
  end
  
  # 
  # This class represents a public or private key in encoded format.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see KeySpec
  # @see X509EncodedKeySpec
  # @see PKCS8EncodedKeySpec
  # 
  # @since 1.2
  class EncodedKeySpec 
    include_class_members EncodedKeySpecImports
    include KeySpec
    
    attr_accessor :encoded_key
    alias_method :attr_encoded_key, :encoded_key
    undef_method :encoded_key
    alias_method :attr_encoded_key=, :encoded_key=
    undef_method :encoded_key=
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Creates a new EncodedKeySpec with the given encoded key.
    # 
    # @param encodedKey the encoded key. The contents of the
    # array are copied to protect against subsequent modification.
    # @exception NullPointerException if <code>encodedKey</code>
    # is null.
    def initialize(encoded_key)
      @encoded_key = nil
      @encoded_key = encoded_key.clone
    end
    
    typesig { [] }
    # 
    # Returns the encoded key.
    # 
    # @return the encoded key. Returns a new array each time
    # this method is called.
    def get_encoded
      return @encoded_key.clone
    end
    
    typesig { [] }
    # 
    # Returns the name of the encoding format associated with this
    # key specification.
    # 
    # <p>If the opaque representation of a key
    # (see {@link java.security.Key Key}) can be transformed
    # (see {@link java.security.KeyFactory KeyFactory})
    # into this key specification (or a subclass of it),
    # <code>getFormat</code> called
    # on the opaque key returns the same value as the
    # <code>getFormat</code> method
    # of this key specification.
    # 
    # @return a string representation of the encoding format.
    def get_format
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__encoded_key_spec, :initialize
  end
  
end

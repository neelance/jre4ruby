require "rjava"

# 
# Copyright 1998-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SecureRandomSpiImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # 
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>SecureRandom</code> class.
  # All the abstract methods in this class must be implemented by each
  # service provider who wishes to supply the implementation
  # of a cryptographically strong pseudo-random number generator.
  # 
  # 
  # @see SecureRandom
  # @since 1.2
  class SecureRandomSpi 
    include_class_members SecureRandomSpiImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2991854161009191830 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Reseeds this random object. The given seed supplements, rather than
    # replaces, the existing seed. Thus, repeated calls are guaranteed
    # never to reduce randomness.
    # 
    # @param seed the seed.
    def engine_set_seed(seed)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Generates a user-specified number of random bytes.
    # 
    # <p> If a call to <code>engineSetSeed</code> had not occurred previously,
    # the first call to this method forces this SecureRandom implementation
    # to seed itself.  This self-seeding will not occur if
    # <code>engineSetSeed</code> was previously called.
    # 
    # @param bytes the array to be filled in with random bytes.
    def engine_next_bytes(bytes)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the given number of seed bytes.  This call may be used to
    # seed other random number generators.
    # 
    # @param numBytes the number of seed bytes to generate.
    # 
    # @return the seed bytes.
    def engine_generate_seed(num_bytes)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__secure_random_spi, :initialize
  end
  
end

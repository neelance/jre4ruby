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
module Sun::Security::Mscapi
  module PRNGImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Security, :ProviderException
      include_const ::Java::Security, :SecureRandomSpi
    }
  end
  
  # Native PRNG implementation for Windows using the Microsoft Crypto API.
  # 
  # @since 1.6
  class PRNG < PRNGImports.const_get :SecureRandomSpi
    include_class_members PRNGImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_mscapi_PRNG_generateSeed, [:pointer, :long, :int32, :long], :long
      typesig { [::Java::Int, Array.typed(::Java::Byte)] }
      # TODO - generate the serialVersionUID
      # private static final long serialVersionUID = XXX;
      # 
      # The CryptGenRandom function fills a buffer with cryptographically random
      # bytes.
      def generate_seed(length, seed)
        JNI.__send__(:Java_sun_security_mscapi_PRNG_generateSeed, JNI.env, self.jni_id, length.to_int, seed.jni_id)
      end
    }
    
    typesig { [] }
    # Creates a random number generator.
    def initialize
      super()
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reseeds this random object. The given seed supplements, rather than
    # replaces, the existing seed. Thus, repeated calls are guaranteed
    # never to reduce randomness.
    # 
    # @param seed the seed.
    def engine_set_seed(seed)
      if (!(seed).nil?)
        generate_seed(-1, seed)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Generates a user-specified number of random bytes.
    # 
    # @param bytes the array to be filled in with random bytes.
    def engine_next_bytes(bytes)
      if (!(bytes).nil?)
        if ((generate_seed(0, bytes)).nil?)
          raise ProviderException.new("Error generating random bytes")
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the given number of seed bytes.  This call may be used to
    # seed other random number generators.
    # 
    # @param numBytes the number of seed bytes to generate.
    # 
    # @return the seed bytes.
    def engine_generate_seed(num_bytes)
      seed = generate_seed(num_bytes, nil)
      if ((seed).nil?)
        raise ProviderException.new("Error generating seed bytes")
      end
      return seed
    end
    
    private
    alias_method :initialize__prng, :initialize
  end
  
end

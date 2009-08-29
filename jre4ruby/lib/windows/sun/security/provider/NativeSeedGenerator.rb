require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module NativeSeedGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Io, :IOException
    }
  end
  
  # Seed generator for Windows making use of MS CryptoAPI using native code.
  class NativeSeedGenerator < NativeSeedGeneratorImports.const_get :SeedGenerator
    include_class_members NativeSeedGeneratorImports
    
    typesig { [] }
    # Create a new CryptoAPI seed generator instances.
    # 
    # @exception IOException if CryptoAPI seeds are not available
    # on this platform.
    def initialize
      super()
      # try generating two random bytes to see if CAPI is available
      if (!native_generate_seed(Array.typed(::Java::Byte).new(2) { 0 }))
        raise IOException.new("Required native CryptoAPI features not " + " available on this machine")
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_provider_NativeSeedGenerator_nativeGenerateSeed, [:pointer, :long, :long], :int8
      typesig { [Array.typed(::Java::Byte)] }
      # Native method to do the actual work.
      def native_generate_seed(result)
        JNI.__send__(:Java_sun_security_provider_NativeSeedGenerator_nativeGenerateSeed, JNI.env, self.jni_id, result.jni_id) != 0
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_seed_bytes(result)
      # fill array as a side effect
      if ((native_generate_seed(result)).equal?(false))
        # should never happen if constructor check succeeds
        raise InternalError.new("Unexpected CryptoAPI failure generating seed")
      end
    end
    
    typesig { [] }
    def get_seed_byte
      b = Array.typed(::Java::Byte).new(1) { 0 }
      get_seed_bytes(b)
      return b[0]
    end
    
    private
    alias_method :initialize__native_seed_generator, :initialize
  end
  
end

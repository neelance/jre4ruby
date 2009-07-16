require "rjava"

# 
# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Internal::Spec
  module TlsPrfParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Internal::Spec
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Javax::Crypto, :SecretKey
    }
  end
  
  # 
  # Parameters for the TLS PRF (pseudo-random function). The PRF function
  # is defined in RFC 2246.
  # This class is used to initialize KeyGenerators of the type "TlsPrf".
  # 
  # <p>Instances of this class are immutable.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @deprecated Sun JDK internal use only --- WILL BE REMOVED in Dolphin (JDK 7)
  class TlsPrfParameterSpec 
    include_class_members TlsPrfParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :secret
    alias_method :attr_secret, :secret
    undef_method :secret
    alias_method :attr_secret=, :secret=
    undef_method :secret=
    
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    attr_accessor :seed
    alias_method :attr_seed, :seed
    undef_method :seed
    alias_method :attr_seed=, :seed=
    undef_method :seed=
    
    attr_accessor :output_length
    alias_method :attr_output_length, :output_length
    undef_method :output_length
    alias_method :attr_output_length=, :output_length=
    undef_method :output_length=
    
    typesig { [SecretKey, String, Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Constructs a new TlsPrfParameterSpec.
    # 
    # @param secret the secret to use in the calculation (or null)
    # @param label the label to use in the calculation
    # @param seed the random seed to use in the calculation
    # @param outputLength the length in bytes of the output key to be produced
    # 
    # @throws NullPointerException if label or seed is null
    # @throws IllegalArgumentException if outputLength is negative
    def initialize(secret, label, seed, output_length)
      @secret = nil
      @label = nil
      @seed = nil
      @output_length = 0
      if (((label).nil?) || ((seed).nil?))
        raise NullPointerException.new("label and seed must not be null")
      end
      if (output_length <= 0)
        raise IllegalArgumentException.new("outputLength must be positive")
      end
      @secret = secret
      @label = label
      @seed = seed.clone
      @output_length = output_length
    end
    
    typesig { [] }
    # 
    # Returns the secret to use in the PRF calculation, or null if there is no
    # secret.
    # 
    # @return the secret to use in the PRF calculation, or null if there is no
    # secret.
    def get_secret
      return @secret
    end
    
    typesig { [] }
    # 
    # Returns the label to use in the PRF calcuation.
    # 
    # @return the label to use in the PRF calcuation.
    def get_label
      return @label
    end
    
    typesig { [] }
    # 
    # Returns a copy of the seed to use in the PRF calcuation.
    # 
    # @return a copy of the seed to use in the PRF calcuation.
    def get_seed
      return @seed.clone
    end
    
    typesig { [] }
    # 
    # Returns the length in bytes of the output key to be produced.
    # 
    # @return the length in bytes of the output key to be produced.
    def get_output_length
      return @output_length
    end
    
    private
    alias_method :initialize__tls_prf_parameter_spec, :initialize
  end
  
end

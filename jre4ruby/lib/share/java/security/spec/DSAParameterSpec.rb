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
  module DSAParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class specifies the set of parameters used with the DSA algorithm.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see AlgorithmParameterSpec
  # 
  # @since 1.2
  class DSAParameterSpec 
    include_class_members DSAParameterSpecImports
    include AlgorithmParameterSpec
    include Java::Security::Interfaces::DSAParams
    
    attr_accessor :p
    alias_method :attr_p, :p
    undef_method :p
    alias_method :attr_p=, :p=
    undef_method :p=
    
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    attr_accessor :g
    alias_method :attr_g, :g
    undef_method :g
    alias_method :attr_g=, :g=
    undef_method :g=
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    # Creates a new DSAParameterSpec with the specified parameter values.
    # 
    # @param p the prime.
    # 
    # @param q the sub-prime.
    # 
    # @param g the base.
    def initialize(p, q, g)
      @p = nil
      @q = nil
      @g = nil
      @p = p
      @q = q
      @g = g
    end
    
    typesig { [] }
    # Returns the prime <code>p</code>.
    # 
    # @return the prime <code>p</code>.
    def get_p
      return @p
    end
    
    typesig { [] }
    # Returns the sub-prime <code>q</code>.
    # 
    # @return the sub-prime <code>q</code>.
    def get_q
      return @q
    end
    
    typesig { [] }
    # Returns the base <code>g</code>.
    # 
    # @return the base <code>g</code>.
    def get_g
      return @g
    end
    
    private
    alias_method :initialize__dsaparameter_spec, :initialize
  end
  
end

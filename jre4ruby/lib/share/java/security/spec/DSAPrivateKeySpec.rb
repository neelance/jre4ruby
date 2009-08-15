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
  module DSAPrivateKeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class specifies a DSA private key with its associated parameters.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see KeySpec
  # @see DSAPublicKeySpec
  # @see PKCS8EncodedKeySpec
  # 
  # @since 1.2
  class DSAPrivateKeySpec 
    include_class_members DSAPrivateKeySpecImports
    include KeySpec
    
    attr_accessor :x
    alias_method :attr_x, :x
    undef_method :x
    alias_method :attr_x=, :x=
    undef_method :x=
    
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
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    # Creates a new DSAPrivateKeySpec with the specified parameter values.
    # 
    # @param x the private key.
    # 
    # @param p the prime.
    # 
    # @param q the sub-prime.
    # 
    # @param g the base.
    def initialize(x, p, q, g)
      @x = nil
      @p = nil
      @q = nil
      @g = nil
      @x = x
      @p = p
      @q = q
      @g = g
    end
    
    typesig { [] }
    # Returns the private key <code>x</code>.
    # 
    # @return the private key <code>x</code>.
    def get_x
      return @x
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
    alias_method :initialize__dsaprivate_key_spec, :initialize
  end
  
end

require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ECPrivateKeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This immutable class specifies an elliptic curve private key with
  # its associated parameters.
  # 
  # @see KeySpec
  # @see ECParameterSpec
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECPrivateKeySpec 
    include_class_members ECPrivateKeySpecImports
    include KeySpec
    
    attr_accessor :s
    alias_method :attr_s, :s
    undef_method :s
    alias_method :attr_s=, :s=
    undef_method :s=
    
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [BigInteger, ECParameterSpec] }
    # Creates a new ECPrivateKeySpec with the specified
    # parameter values.
    # @param s the private value.
    # @param params the associated elliptic curve domain
    # parameters.
    # @exception NullPointerException if <code>s</code>
    # or <code>params</code> is null.
    def initialize(s, params)
      @s = nil
      @params = nil
      if ((s).nil?)
        raise NullPointerException.new("s is null")
      end
      if ((params).nil?)
        raise NullPointerException.new("params is null")
      end
      @s = s
      @params = params
    end
    
    typesig { [] }
    # Returns the private value S.
    # @return the private value S.
    def get_s
      return @s
    end
    
    typesig { [] }
    # Returns the associated elliptic curve domain
    # parameters.
    # @return the EC domain parameters.
    def get_params
      return @params
    end
    
    private
    alias_method :initialize__ecprivate_key_spec, :initialize
  end
  
end

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
  module ECPublicKeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
    }
  end
  
  # This immutable class specifies an elliptic curve public key with
  # its associated parameters.
  # 
  # @see KeySpec
  # @see ECPoint
  # @see ECParameterSpec
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECPublicKeySpec 
    include_class_members ECPublicKeySpecImports
    include KeySpec
    
    attr_accessor :w
    alias_method :attr_w, :w
    undef_method :w
    alias_method :attr_w=, :w=
    undef_method :w=
    
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [ECPoint, ECParameterSpec] }
    # Creates a new ECPublicKeySpec with the specified
    # parameter values.
    # @param w the public point.
    # @param params the associated elliptic curve domain
    # parameters.
    # @exception NullPointerException if <code>w</code>
    # or <code>params</code> is null.
    # @exception IllegalArgumentException if <code>w</code>
    # is point at infinity, i.e. ECPoint.POINT_INFINITY
    def initialize(w, params)
      @w = nil
      @params = nil
      if ((w).nil?)
        raise NullPointerException.new("w is null")
      end
      if ((params).nil?)
        raise NullPointerException.new("params is null")
      end
      if ((w).equal?(ECPoint::POINT_INFINITY))
        raise IllegalArgumentException.new("w is ECPoint.POINT_INFINITY")
      end
      @w = w
      @params = params
    end
    
    typesig { [] }
    # Returns the public point W.
    # @return the public point W.
    def get_w
      return @w
    end
    
    typesig { [] }
    # Returns the associated elliptic curve domain
    # parameters.
    # @return the EC domain parameters.
    def get_params
      return @params
    end
    
    private
    alias_method :initialize__ecpublic_key_spec, :initialize
  end
  
end

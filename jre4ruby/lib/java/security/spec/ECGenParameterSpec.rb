require "rjava"

# 
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
  module ECGenParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
    }
  end
  
  # 
  # This immutable class specifies the set of parameters used for
  # generating elliptic curve (EC) domain parameters.
  # 
  # @see AlgorithmParameterSpec
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECGenParameterSpec 
    include_class_members ECGenParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [String] }
    # 
    # Creates a parameter specification for EC parameter
    # generation using a standard (or predefined) name
    # <code>stdName</code> in order to generate the corresponding
    # (precomputed) elliptic curve domain parameters. For the
    # list of supported names, please consult the documentation
    # of provider whose implementation will be used.
    # @param stdName the standard name of the to-be-generated EC
    # domain parameters.
    # @exception NullPointerException if <code>stdName</code>
    # is null.
    def initialize(std_name)
      @name = nil
      if ((std_name).nil?)
        raise NullPointerException.new("stdName is null")
      end
      @name = std_name
    end
    
    typesig { [] }
    # 
    # Returns the standard or predefined name of the
    # to-be-generated EC domain parameters.
    # @return the standard or predefined name.
    def get_name
      return @name
    end
    
    private
    alias_method :initialize__ecgen_parameter_spec, :initialize
  end
  
end

require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Generics::Repository
  module GenericDeclRepositoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Repository
      include_const ::Java::Lang::Reflect, :TypeVariable
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :FormalTypeParameter
      include_const ::Sun::Reflect::Generics::Tree, :Signature
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # This class represents the generic type information for a generic
  # declaration.
  # The code is not dependent on a particular reflective implementation.
  # It is designed to be used unchanged by at least core reflection and JDI.
  class GenericDeclRepository < GenericDeclRepositoryImports.const_get :AbstractRepository
    include_class_members GenericDeclRepositoryImports
    
    attr_accessor :type_params
    alias_method :attr_type_params, :type_params
    undef_method :type_params
    alias_method :attr_type_params=, :type_params=
    undef_method :type_params=
    
    typesig { [String, GenericsFactory] }
    # caches the formal type parameters
    def initialize(raw_sig, f)
      @type_params = nil
      super(raw_sig, f)
    end
    
    typesig { [] }
    # public API
    # When queried for a particular piece of type information, the
    # general pattern is to consult the corresponding cached value.
    # If the corresponding field is non-null, it is returned.
    # If not, it is created lazily. This is done by selecting the appropriate
    # part of the tree and transforming it into a reflective object
    # using a visitor.
    # a visitor, which is created by feeding it the factory
    # with which the repository was created.
    # Return the formal type parameters of this generic declaration.
    # @return the formal type parameters of this generic declaration
    # <?>
    def get_type_parameters
      if ((@type_params).nil?)
        # lazily initialize type parameters
        # first, extract type parameter subtree(s) from AST
        ftps = get_tree.get_formal_type_parameters
        # create array to store reified subtree(s)
        tps = Array.typed(TypeVariable).new(ftps.attr_length) { nil }
        # reify all subtrees
        i = 0
        while i < ftps.attr_length
          r = get_reifier # obtain visitor
          ftps[i].accept(r) # reify subtree
          # extract result from visitor and store it
          tps[i] = r.get_result
          i += 1
        end
        @type_params = tps # cache overall result
      end
      return @type_params.clone # return cached result
    end
    
    private
    alias_method :initialize__generic_decl_repository, :initialize
  end
  
end

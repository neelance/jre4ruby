require "rjava"

# 
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
  module ConstructorRepositoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Repository
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Parser, :SignatureParser
      include_const ::Sun::Reflect::Generics::Tree, :FieldTypeSignature
      include_const ::Sun::Reflect::Generics::Tree, :MethodTypeSignature
      include_const ::Sun::Reflect::Generics::Tree, :TypeSignature
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # 
  # This class represents the generic type information for a constructor.
  # The code is not dependent on a particular reflective implementation.
  # It is designed to be used unchanged by at least core reflection and JDI.
  class ConstructorRepository < ConstructorRepositoryImports.const_get :GenericDeclRepository
    include_class_members ConstructorRepositoryImports
    
    attr_accessor :param_types
    alias_method :attr_param_types, :param_types
    undef_method :param_types
    alias_method :attr_param_types=, :param_types=
    undef_method :param_types=
    
    # caches the generic parameter types info
    attr_accessor :exception_types
    alias_method :attr_exception_types, :exception_types
    undef_method :exception_types
    alias_method :attr_exception_types=, :exception_types=
    undef_method :exception_types=
    
    typesig { [String, GenericsFactory] }
    # caches the generic exception types info
    # protected, to enforce use of static factory yet allow subclassing
    def initialize(raw_sig, f)
      @param_types = nil
      @exception_types = nil
      super(raw_sig, f)
    end
    
    typesig { [String] }
    def parse(s)
      return SignatureParser.make.parse_method_sig(s)
    end
    
    class_module.module_eval {
      typesig { [String, GenericsFactory] }
      # 
      # Static factory method.
      # @param rawSig - the generic signature of the reflective object
      # that this repository is servicing
      # @param f - a factory that will provide instances of reflective
      # objects when this repository converts its AST
      # @return a <tt>ConstructorRepository</tt> that manages the generic type
      # information represented in the signature <tt>rawSig</tt>
      def make(raw_sig, f)
        return ConstructorRepository.new(raw_sig, f)
      end
    }
    
    typesig { [] }
    # public API
    # 
    # When queried for a particular piece of type information, the
    # general pattern is to consult the corresponding cached value.
    # If the corresponding field is non-null, it is returned.
    # If not, it is created lazily. This is done by selecting the appropriate
    # part of the tree and transforming it into a reflective object
    # using a visitor.
    # a visitor, which is created by feeding it the factory
    # with which the repository was created.
    def get_parameter_types
      if ((@param_types).nil?)
        # lazily initialize parameter types
        # first, extract parameter type subtree(s) from AST
        pts = get_tree.get_parameter_types
        # create array to store reified subtree(s)
        ps = Array.typed(Type).new(pts.attr_length) { nil }
        # reify all subtrees
        i = 0
        while i < pts.attr_length
          r = get_reifier # obtain visitor
          pts[i].accept(r) # reify subtree
          # extract result from visitor and store it
          ps[i] = r.get_result
          ((i += 1) - 1)
        end
        @param_types = ps # cache overall result
      end
      return @param_types.clone # return cached result
    end
    
    typesig { [] }
    def get_exception_types
      if ((@exception_types).nil?)
        # lazily initialize exception types
        # first, extract exception type subtree(s) from AST
        ets = get_tree.get_exception_types
        # create array to store reified subtree(s)
        es = Array.typed(Type).new(ets.attr_length) { nil }
        # reify all subtrees
        i = 0
        while i < ets.attr_length
          r = get_reifier # obtain visitor
          ets[i].accept(r) # reify subtree
          # extract result from visitor and store it
          es[i] = r.get_result
          ((i += 1) - 1)
        end
        @exception_types = es # cache overall result
      end
      return @exception_types.clone # return cached result
    end
    
    private
    alias_method :initialize__constructor_repository, :initialize
  end
  
end

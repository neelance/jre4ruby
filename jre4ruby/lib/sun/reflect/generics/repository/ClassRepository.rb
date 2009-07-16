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
  module ClassRepositoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Repository
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :ClassSignature
      include_const ::Sun::Reflect::Generics::Tree, :TypeTree
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
      include_const ::Sun::Reflect::Generics::Parser, :SignatureParser
      include_const ::Java::Lang::Reflect, :Type
    }
  end
  
  # 
  # This class represents the generic type information for a class.
  # The code is not dependent on a particular reflective implementation.
  # It is designed to be used unchanged by at least core reflection and JDI.
  class ClassRepository < ClassRepositoryImports.const_get :GenericDeclRepository
    include_class_members ClassRepositoryImports
    
    attr_accessor :superclass
    alias_method :attr_superclass, :superclass
    undef_method :superclass
    alias_method :attr_superclass=, :superclass=
    undef_method :superclass=
    
    # caches the generic superclass info
    attr_accessor :super_interfaces
    alias_method :attr_super_interfaces, :super_interfaces
    undef_method :super_interfaces
    alias_method :attr_super_interfaces=, :super_interfaces=
    undef_method :super_interfaces=
    
    typesig { [String, GenericsFactory] }
    # caches the generic superinterface info
    # private, to enforce use of static factory
    def initialize(raw_sig, f)
      @superclass = nil
      @super_interfaces = nil
      super(raw_sig, f)
    end
    
    typesig { [String] }
    def parse(s)
      return SignatureParser.make.parse_class_sig(s)
    end
    
    class_module.module_eval {
      typesig { [String, GenericsFactory] }
      # 
      # Static factory method.
      # @param rawSig - the generic signature of the reflective object
      # that this repository is servicing
      # @param f - a factory that will provide instances of reflective
      # objects when this repository converts its AST
      # @return a <tt>ClassRepository</tt> that manages the generic type
      # information represented in the signature <tt>rawSig</tt>
      def make(raw_sig, f)
        return ClassRepository.new(raw_sig, f)
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
    def get_superclass
      if ((@superclass).nil?)
        # lazily initialize superclass
        r = get_reifier # obtain visitor
        # Extract superclass subtree from AST and reify
        get_tree.get_superclass.accept(r)
        # extract result from visitor and cache it
        @superclass = r.get_result
      end
      return @superclass # return cached result
    end
    
    typesig { [] }
    def get_super_interfaces
      if ((@super_interfaces).nil?)
        # lazily initialize super interfaces
        # first, extract super interface subtree(s) from AST
        ts = get_tree.get_super_interfaces
        # create array to store reified subtree(s)
        sis = Array.typed(Type).new(ts.attr_length) { nil }
        # reify all subtrees
        i = 0
        while i < ts.attr_length
          r = get_reifier # obtain visitor
          ts[i].accept(r) # reify subtree
          # extract result from visitor and store it
          sis[i] = r.get_result
          ((i += 1) - 1)
        end
        @super_interfaces = sis # cache overall result
      end
      return @super_interfaces.clone # return cached result
    end
    
    private
    alias_method :initialize__class_repository, :initialize
  end
  
end

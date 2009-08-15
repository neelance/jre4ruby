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
module Sun::Reflect::Generics::Repository
  module AbstractRepositoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Repository
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :Tree
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # Abstract superclass for representing the generic type information for
  # a reflective entity.
  # The code is not dependent on a particular reflective implementation.
  # It is designed to be used unchanged by at least core reflection and JDI.
  class AbstractRepository 
    include_class_members AbstractRepositoryImports
    
    # A factory used to produce reflective objects. Provided when the
    # repository is created. Will vary across implementations.
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    attr_accessor :tree
    alias_method :attr_tree, :tree
    undef_method :tree
    alias_method :attr_tree=, :tree=
    undef_method :tree=
    
    typesig { [] }
    # the AST for the generic type info
    # accessors
    def get_factory
      return @factory
    end
    
    typesig { [] }
    # Accessor for <tt>tree</tt>.
    # @return the cached AST this repository holds
    def get_tree
      return @tree
    end
    
    typesig { [] }
    # Returns a <tt>Reifier</tt> used to convert parts of the
    # AST into reflective objects.
    # @return  a <tt>Reifier</tt> used to convert parts of the
    # AST into reflective objects
    def get_reifier
      return Reifier.make(get_factory)
    end
    
    typesig { [String, GenericsFactory] }
    # Constructor. Should only be used by subclasses. Concrete subclasses
    # should make their constructors private and provide public factory
    # methods.
    # @param rawSig - the generic signature of the reflective object
    # that this repository is servicing
    # @param f - a factory that will provide instances of reflective
    # objects when this repository converts its AST
    def initialize(raw_sig, f)
      @factory = nil
      @tree = nil
      @tree = parse(raw_sig)
      @factory = f
    end
    
    typesig { [String] }
    # Returns the AST for the genric type info of this entity.
    # @param s - a string representing the generic signature of this
    # entity
    # @return the AST for the generic type info of this entity.
    def parse(s)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__abstract_repository, :initialize
  end
  
end

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
  module FieldRepositoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Repository
      include_const ::Java::Lang::Reflect, :Type
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Tree, :TypeSignature
      include_const ::Sun::Reflect::Generics::Parser, :SignatureParser
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # This class represents the generic type information for a constructor.
  # The code is not dependent on a particular reflective implementation.
  # It is designed to be used unchanged by at least core reflection and JDI.
  class FieldRepository < FieldRepositoryImports.const_get :AbstractRepository
    include_class_members FieldRepositoryImports
    
    attr_accessor :generic_type
    alias_method :attr_generic_type, :generic_type
    undef_method :generic_type
    alias_method :attr_generic_type=, :generic_type=
    undef_method :generic_type=
    
    typesig { [String, GenericsFactory] }
    # caches the generic type info
    # protected, to enforce use of static factory yet allow subclassing
    def initialize(raw_sig, f)
      @generic_type = nil
      super(raw_sig, f)
    end
    
    typesig { [String] }
    def parse(s)
      return SignatureParser.make.parse_type_sig(s)
    end
    
    class_module.module_eval {
      typesig { [String, GenericsFactory] }
      # Static factory method.
      # @param rawSig - the generic signature of the reflective object
      # that this repository is servicing
      # @param f - a factory that will provide instances of reflective
      # objects when this repository converts its AST
      # @return a <tt>FieldRepository</tt> that manages the generic type
      # information represented in the signature <tt>rawSig</tt>
      def make(raw_sig, f)
        return FieldRepository.new(raw_sig, f)
      end
    }
    
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
    def get_generic_type
      if ((@generic_type).nil?)
        # lazily initialize generic type
        r = get_reifier # obtain visitor
        get_tree.accept(r) # reify subtree
        # extract result from visitor and cache it
        @generic_type = r.get_result
      end
      return @generic_type # return cached result
    end
    
    private
    alias_method :initialize__field_repository, :initialize
  end
  
end

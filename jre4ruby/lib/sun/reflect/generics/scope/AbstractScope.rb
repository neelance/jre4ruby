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
module Sun::Reflect::Generics::Scope
  module AbstractScopeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Scope
      include_const ::Java::Lang::Reflect, :GenericDeclaration
      include_const ::Java::Lang::Reflect, :TypeVariable
    }
  end
  
  # 
  # Abstract superclass for lazy scope objects, used when building
  # factories for generic information repositories.
  # The type parameter <tt>D</tt> represents the type of reflective
  # object whose scope this class is representing.
  # <p> To subclass this, all one needs to do is implement
  # <tt>computeEnclosingScope</tt> and the subclass' constructor.
  class AbstractScope 
    include_class_members AbstractScopeImports
    include Scope
    
    attr_accessor :recvr
    alias_method :attr_recvr, :recvr
    undef_method :recvr
    alias_method :attr_recvr=, :recvr=
    undef_method :recvr=
    
    # the declaration whose scope this instance represents
    attr_accessor :enclosing_scope
    alias_method :attr_enclosing_scope, :enclosing_scope
    undef_method :enclosing_scope
    alias_method :attr_enclosing_scope=, :enclosing_scope=
    undef_method :enclosing_scope=
    
    typesig { [Object] }
    # the enclosing scope of this scope
    # 
    # Constructor. Takes a reflective object whose scope the newly
    # constructed instance will represent.
    # @param D - A generic declaration whose scope the newly
    # constructed instance will represent
    def initialize(decl)
      @recvr = nil
      @enclosing_scope = nil
      @recvr = decl
    end
    
    typesig { [] }
    # 
    # Accessor for the receiver - the object whose scope this <tt>Scope</tt>
    # object represents.
    # @return The object whose scope this <tt>Scope</tt> object represents
    def get_recvr
      return @recvr
    end
    
    typesig { [] }
    # This method must be implemented by any concrete subclass.
    # It must return the enclosing scope of this scope. If this scope
    # is a top-level scope, an instance of  DummyScope must be returned.
    # @return The enclosing scope of this scope
    def compute_enclosing_scope
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Accessor for the enclosing scope, which is computed lazily and cached.
    # @return the enclosing scope
    def get_enclosing_scope
      if ((@enclosing_scope).nil?)
        @enclosing_scope = compute_enclosing_scope
      end
      return @enclosing_scope
    end
    
    typesig { [String] }
    # 
    # Lookup a type variable in the scope, using its name. Returns null if
    # no type variable with this name is declared in this scope or any of its
    # surrounding scopes.
    # @param name - the name of the type variable being looked up
    # @return the requested type variable, if found
    def lookup(name)
      tas = get_recvr.get_type_parameters
      # <?>
      tas.each do |tv|
        if ((tv.get_name == name))
          return tv
        end
      end
      return get_enclosing_scope.lookup(name)
    end
    
    private
    alias_method :initialize__abstract_scope, :initialize
  end
  
end

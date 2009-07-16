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
module Sun::Reflect::Generics::ReflectiveObjects
  module LazyReflectiveObjectGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::ReflectiveObjects
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
    }
  end
  
  # 
  # Common infrastructure for things that lazily generate reflective generics
  # objects.
  # <p> In all these cases, one needs produce a visitor that will, on demand,
  # traverse the stored AST(s) and reify them into reflective objects.
  # The visitor needs to be initialized with a factory, which will be
  # provided when the instance is initialized.
  # The factory should be cached.
  class LazyReflectiveObjectGenerator 
    include_class_members LazyReflectiveObjectGeneratorImports
    
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    typesig { [GenericsFactory] }
    # cached factory
    def initialize(f)
      @factory = nil
      @factory = f
    end
    
    typesig { [] }
    # accessor for factory
    def get_factory
      return @factory
    end
    
    typesig { [] }
    # produce a reifying visitor (could this be typed as a TypeTreeVisitor?
    def get_reifier
      return Reifier.make(get_factory)
    end
    
    private
    alias_method :initialize__lazy_reflective_object_generator, :initialize
  end
  
end

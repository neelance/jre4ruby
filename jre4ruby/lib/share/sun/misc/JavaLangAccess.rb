require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module JavaLangAccessImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Sun::Reflect, :ConstantPool
      include_const ::Sun::Reflect::Annotation, :AnnotationType
      include_const ::Sun::Nio::Ch, :Interruptible
    }
  end
  
  module JavaLangAccess
    include_class_members JavaLangAccessImports
    
    typesig { [Class] }
    # Return the constant pool for a class.
    def get_constant_pool(klass)
      raise NotImplementedError
    end
    
    typesig { [Class, AnnotationType] }
    # Set the AnnotationType instance corresponding to this class.
    # (This method only applies to annotation types.)
    def set_annotation_type(klass, annotation_type)
      raise NotImplementedError
    end
    
    typesig { [Class] }
    # Get the AnnotationType instance corresponding to this class.
    # (This method only applies to annotation types.)
    def get_annotation_type(klass)
      raise NotImplementedError
    end
    
    typesig { [Class] }
    # Returns the elements of an enum class or null if the
    # Class object does not represent an enum type;
    # the result is uncloned, cached, and shared by all callers.
    def get_enum_constants_shared(klass)
      raise NotImplementedError
    end
    
    typesig { [JavaThread, Interruptible] }
    # Set thread's blocker field.
    def blocked_on(t, b)
      raise NotImplementedError
    end
  end
  
end

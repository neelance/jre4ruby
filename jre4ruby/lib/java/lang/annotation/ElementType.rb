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
module Java::Lang::Annotation
  module ElementTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
    }
  end
  
  # 
  # A program element type.  The constants of this enumerated type
  # provide a simple classification of the declared elements in a
  # Java program.
  # 
  # <p>These constants are used with the {@link Target} meta-annotation type
  # to specify where it is legal to use an annotation type.
  # 
  # @author  Joshua Bloch
  # @since 1.5
  class ElementType 
    include_class_members ElementTypeImports
    
    class_module.module_eval {
      # Class, interface (including annotation type), or enum declaration
      const_set_lazy(:TYPE) { ElementType.new.set_value_name("TYPE") }
      const_attr_reader  :TYPE
      
      # Field declaration (includes enum constants)
      const_set_lazy(:FIELD) { ElementType.new.set_value_name("FIELD") }
      const_attr_reader  :FIELD
      
      # Method declaration
      const_set_lazy(:METHOD) { ElementType.new.set_value_name("METHOD") }
      const_attr_reader  :METHOD
      
      # Parameter declaration
      const_set_lazy(:PARAMETER) { ElementType.new.set_value_name("PARAMETER") }
      const_attr_reader  :PARAMETER
      
      # Constructor declaration
      const_set_lazy(:CONSTRUCTOR) { ElementType.new.set_value_name("CONSTRUCTOR") }
      const_attr_reader  :CONSTRUCTOR
      
      # Local variable declaration
      const_set_lazy(:LOCAL_VARIABLE) { ElementType.new.set_value_name("LOCAL_VARIABLE") }
      const_attr_reader  :LOCAL_VARIABLE
      
      # Annotation type declaration
      const_set_lazy(:ANNOTATION_TYPE) { ElementType.new.set_value_name("ANNOTATION_TYPE") }
      const_attr_reader  :ANNOTATION_TYPE
      
      # Package declaration
      const_set_lazy(:PACKAGE) { ElementType.new.set_value_name("PACKAGE") }
      const_attr_reader  :PACKAGE
    }
    
    typesig { [String] }
    def set_value_name(name)
      @value_name = name
      self
    end
    
    typesig { [] }
    def to_s
      @value_name
    end
    
    class_module.module_eval {
      typesig { [] }
      def values
        [TYPE, FIELD, METHOD, PARAMETER, CONSTRUCTOR, LOCAL_VARIABLE, ANNOTATION_TYPE, PACKAGE]
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__element_type, :initialize
  end
  
end

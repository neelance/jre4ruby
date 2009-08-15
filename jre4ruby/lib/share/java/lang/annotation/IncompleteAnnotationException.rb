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
module Java::Lang::Annotation
  module IncompleteAnnotationExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
    }
  end
  
  # Thrown to indicate that a program has attempted to access an element of
  # an annotation type that was added to the annotation type definition after
  # the annotation was compiled (or serialized).  This exception will not be
  # thrown if the new element has a default value.
  # 
  # @author  Josh Bloch
  # @since 1.5
  class IncompleteAnnotationException < IncompleteAnnotationExceptionImports.const_get :RuntimeException
    include_class_members IncompleteAnnotationExceptionImports
    
    attr_accessor :annotation_type
    alias_method :attr_annotation_type, :annotation_type
    undef_method :annotation_type
    alias_method :attr_annotation_type=, :annotation_type=
    undef_method :annotation_type=
    
    attr_accessor :element_name
    alias_method :attr_element_name, :element_name
    undef_method :element_name
    alias_method :attr_element_name=, :element_name=
    undef_method :element_name=
    
    typesig { [Class, String] }
    # Constructs an IncompleteAnnotationException to indicate that
    # the named element was missing from the specified annotation type.
    # 
    # @param annotationType the Class object for the annotation type
    # @param elementName the name of the missing element
    def initialize(annotation_type, element_name)
      @annotation_type = nil
      @element_name = nil
      super(RJava.cast_to_string(annotation_type.get_name) + " missing element " + element_name)
      @annotation_type = annotation_type
      @element_name = element_name
    end
    
    typesig { [] }
    # Returns the Class object for the annotation type with the
    # missing element.
    # 
    # @return the Class object for the annotation type with the
    # missing element
    def annotation_type
      return @annotation_type
    end
    
    typesig { [] }
    # Returns the name of the missing element.
    # 
    # @return the name of the missing element
    def element_name
      return @element_name
    end
    
    private
    alias_method :initialize__incomplete_annotation_exception, :initialize
  end
  
end

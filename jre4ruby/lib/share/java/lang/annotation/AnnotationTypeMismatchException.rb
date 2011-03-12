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
  module AnnotationTypeMismatchExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
      include_const ::Java::Lang::Reflect, :Method
    }
  end
  
  # Thrown to indicate that a program has attempted to access an element of
  # an annotation whose type has changed after the annotation was compiled
  # (or serialized).
  # 
  # @author  Josh Bloch
  # @since 1.5
  class AnnotationTypeMismatchException < AnnotationTypeMismatchExceptionImports.const_get :RuntimeException
    include_class_members AnnotationTypeMismatchExceptionImports
    
    # The <tt>Method</tt> object for the annotation element.
    attr_accessor :element
    alias_method :attr_element, :element
    undef_method :element
    alias_method :attr_element=, :element=
    undef_method :element=
    
    # The (erroneous) type of data found in the annotation.  This string
    # may, but is not required to, contain the value as well.  The exact
    # format of the string is unspecified.
    attr_accessor :found_type
    alias_method :attr_found_type, :found_type
    undef_method :found_type
    alias_method :attr_found_type=, :found_type=
    undef_method :found_type=
    
    typesig { [Method, String] }
    # Constructs an AnnotationTypeMismatchException for the specified
    # annotation type element and found data type.
    # 
    # @param element the <tt>Method</tt> object for the annotation element
    # @param foundType the (erroneous) type of data found in the annotation.
    #        This string may, but is not required to, contain the value
    #        as well.  The exact format of the string is unspecified.
    def initialize(element, found_type)
      @element = nil
      @found_type = nil
      super("Incorrectly typed data found for annotation element " + RJava.cast_to_string(element) + " (Found data of type " + found_type + ")")
      @element = element
      @found_type = found_type
    end
    
    typesig { [] }
    # Returns the <tt>Method</tt> object for the incorrectly typed element.
    # 
    # @return the <tt>Method</tt> object for the incorrectly typed element
    def element
      return @element
    end
    
    typesig { [] }
    # Returns the type of data found in the incorrectly typed element.
    # The returned string may, but is not required to, contain the value
    # as well.  The exact format of the string is unspecified.
    # 
    # @return the type of data found in the incorrectly typed element
    def found_type
      return @found_type
    end
    
    private
    alias_method :initialize__annotation_type_mismatch_exception, :initialize
  end
  
end

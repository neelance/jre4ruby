require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Annotation
  module AnnotationTypeMismatchExceptionProxyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
      include_const ::Java::Lang::Reflect, :Method
    }
  end
  
  # ExceptionProxy for AnnotationTypeMismatchException.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class AnnotationTypeMismatchExceptionProxy < AnnotationTypeMismatchExceptionProxyImports.const_get :ExceptionProxy
    include_class_members AnnotationTypeMismatchExceptionProxyImports
    
    attr_accessor :member
    alias_method :attr_member, :member
    undef_method :member
    alias_method :attr_member=, :member=
    undef_method :member=
    
    attr_accessor :found_type
    alias_method :attr_found_type, :found_type
    undef_method :found_type
    alias_method :attr_found_type=, :found_type=
    undef_method :found_type=
    
    typesig { [String] }
    # It turns out to be convenient to construct these proxies in
    # two stages.  Since this is a private implementation class, we
    # permit ourselves this liberty even though it's normally a very
    # bad idea.
    def initialize(found_type)
      @member = nil
      @found_type = nil
      super()
      @found_type = found_type
    end
    
    typesig { [Method] }
    def set_member(member)
      @member = member
      return self
    end
    
    typesig { [] }
    def generate_exception
      return AnnotationTypeMismatchException.new(@member, @found_type)
    end
    
    private
    alias_method :initialize__annotation_type_mismatch_exception_proxy, :initialize
  end
  
end

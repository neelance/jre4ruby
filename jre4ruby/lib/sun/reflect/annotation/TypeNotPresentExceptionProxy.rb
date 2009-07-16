require "rjava"

# 
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
  module TypeNotPresentExceptionProxyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
    }
  end
  
  # 
  # ExceptionProxy for TypeNotPresentException.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class TypeNotPresentExceptionProxy < TypeNotPresentExceptionProxyImports.const_get :ExceptionProxy
    include_class_members TypeNotPresentExceptionProxyImports
    
    attr_accessor :type_name
    alias_method :attr_type_name, :type_name
    undef_method :type_name
    alias_method :attr_type_name=, :type_name=
    undef_method :type_name=
    
    attr_accessor :cause
    alias_method :attr_cause, :cause
    undef_method :cause
    alias_method :attr_cause=, :cause=
    undef_method :cause=
    
    typesig { [String, Exception] }
    def initialize(type_name, cause)
      @type_name = nil
      @cause = nil
      super()
      @type_name = type_name
      @cause = cause
    end
    
    typesig { [] }
    def generate_exception
      return TypeNotPresentException.new(@type_name, @cause)
    end
    
    private
    alias_method :initialize__type_not_present_exception_proxy, :initialize
  end
  
end

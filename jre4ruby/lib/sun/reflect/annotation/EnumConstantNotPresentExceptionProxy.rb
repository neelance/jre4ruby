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
  module EnumConstantNotPresentExceptionProxyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
    }
  end
  
  # 
  # ExceptionProxy for EnumConstantNotPresentException.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class EnumConstantNotPresentExceptionProxy < EnumConstantNotPresentExceptionProxyImports.const_get :ExceptionProxy
    include_class_members EnumConstantNotPresentExceptionProxyImports
    
    attr_accessor :enum_type
    alias_method :attr_enum_type, :enum_type
    undef_method :enum_type
    alias_method :attr_enum_type=, :enum_type=
    undef_method :enum_type=
    
    attr_accessor :const_name
    alias_method :attr_const_name, :const_name
    undef_method :const_name
    alias_method :attr_const_name=, :const_name=
    undef_method :const_name=
    
    typesig { [Class, String] }
    def initialize(enum_type, const_name)
      @enum_type = nil
      @const_name = nil
      super()
      @enum_type = enum_type
      @const_name = const_name
    end
    
    typesig { [] }
    def generate_exception
      return EnumConstantNotPresentException.new(@enum_type, @const_name)
    end
    
    private
    alias_method :initialize__enum_constant_not_present_exception_proxy, :initialize
  end
  
end

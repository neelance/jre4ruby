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
module Java::Lang
  module EnumConstantNotPresentExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown when an application tries to access an enum constant by name
  # and the enum type contains no constant with the specified name.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class EnumConstantNotPresentException < EnumConstantNotPresentExceptionImports.const_get :RuntimeException
    include_class_members EnumConstantNotPresentExceptionImports
    
    # The type of the missing enum constant.
    attr_accessor :enum_type
    alias_method :attr_enum_type, :enum_type
    undef_method :enum_type
    alias_method :attr_enum_type=, :enum_type=
    undef_method :enum_type=
    
    # The name of the missing enum constant.
    attr_accessor :constant_name
    alias_method :attr_constant_name, :constant_name
    undef_method :constant_name
    alias_method :attr_constant_name=, :constant_name=
    undef_method :constant_name=
    
    typesig { [Class, String] }
    # Constructs an <tt>EnumConstantNotPresentException</tt> for the
    # specified constant.
    # 
    # @param enumType the type of the missing enum constant
    # @param constantName the name of the missing enum constant
    def initialize(enum_type, constant_name)
      @enum_type = nil
      @constant_name = nil
      super(RJava.cast_to_string(enum_type.get_name) + "." + constant_name)
      @enum_type = enum_type
      @constant_name = constant_name
    end
    
    typesig { [] }
    # Returns the type of the missing enum constant.
    # 
    # @return the type of the missing enum constant
    def enum_type
      return @enum_type
    end
    
    typesig { [] }
    # Returns the name of the missing enum constant.
    # 
    # @return the name of the missing enum constant
    def constant_name
      return @constant_name
    end
    
    private
    alias_method :initialize__enum_constant_not_present_exception, :initialize
  end
  
end

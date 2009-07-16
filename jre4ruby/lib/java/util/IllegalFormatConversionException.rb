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
module Java::Util
  module IllegalFormatConversionExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # Unchecked exception thrown when the argument corresponding to the format
  # specifier is of an incompatible type.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method or constructor in this class will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @since 1.5
  class IllegalFormatConversionException < IllegalFormatConversionExceptionImports.const_get :IllegalFormatException
    include_class_members IllegalFormatConversionExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 17000126 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    attr_accessor :arg
    alias_method :attr_arg, :arg
    undef_method :arg
    alias_method :attr_arg=, :arg=
    undef_method :arg=
    
    typesig { [::Java::Char, Class] }
    # 
    # Constructs an instance of this class with the mismatched conversion and
    # the corresponding argument class.
    # 
    # @param  c
    # Inapplicable conversion
    # 
    # @param  arg
    # Class of the mismatched argument
    def initialize(c, arg)
      @c = 0
      @arg = nil
      super()
      if ((arg).nil?)
        raise NullPointerException.new
      end
      @c = c
      @arg = arg
    end
    
    typesig { [] }
    # 
    # Returns the inapplicable conversion.
    # 
    # @return  The inapplicable conversion
    def get_conversion
      return @c
    end
    
    typesig { [] }
    # 
    # Returns the class of the mismatched argument.
    # 
    # @return   The class of the mismatched argument
    def get_argument_class
      return @arg
    end
    
    typesig { [] }
    # javadoc inherited from Throwable.java
    def get_message
      return String.format("%c != %s", @c, @arg.get_name)
    end
    
    private
    alias_method :initialize__illegal_format_conversion_exception, :initialize
  end
  
end

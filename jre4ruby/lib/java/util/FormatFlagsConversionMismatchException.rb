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
module Java::Util
  module FormatFlagsConversionMismatchExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # Unchecked exception thrown when a conversion and flag are incompatible.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method or constructor in this class will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @since 1.5
  class FormatFlagsConversionMismatchException < FormatFlagsConversionMismatchExceptionImports.const_get :IllegalFormatException
    include_class_members FormatFlagsConversionMismatchExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 19120414 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :f
    alias_method :attr_f, :f
    undef_method :f
    alias_method :attr_f=, :f=
    undef_method :f=
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    typesig { [String, ::Java::Char] }
    # 
    # Constructs an instance of this class with the specified flag
    # and conversion.
    # 
    # @param  f
    # The flag
    # 
    # @param  c
    # The conversion
    def initialize(f, c)
      @f = nil
      @c = 0
      super()
      if ((f).nil?)
        raise NullPointerException.new
      end
      @f = f
      @c = c
    end
    
    typesig { [] }
    # 
    # Returns the incompatible flag.
    # 
    # @return  The flag
    def get_flags
      return @f
    end
    
    typesig { [] }
    # 
    # Returns the incompatible conversion.
    # 
    # @return  The conversion
    def get_conversion
      return @c
    end
    
    typesig { [] }
    def get_message
      return "Conversion = " + (@c).to_s + ", Flags = " + @f
    end
    
    private
    alias_method :initialize__format_flags_conversion_mismatch_exception, :initialize
  end
  
end

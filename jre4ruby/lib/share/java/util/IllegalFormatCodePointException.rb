require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IllegalFormatCodePointExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Unchecked exception thrown when a character with an invalid Unicode code
  # point as defined by {@link Character#isValidCodePoint} is passed to the
  # {@link Formatter}.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method or constructor in this class will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @since 1.5
  class IllegalFormatCodePointException < IllegalFormatCodePointExceptionImports.const_get :IllegalFormatException
    include_class_members IllegalFormatCodePointExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 19080630 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    typesig { [::Java::Int] }
    # Constructs an instance of this class with the specified illegal code
    # point as defined by {@link Character#isValidCodePoint}.
    # 
    # @param  c
    # The illegal Unicode code point
    def initialize(c)
      @c = 0
      super()
      @c = c
    end
    
    typesig { [] }
    # Returns the illegal code point as defined by {@link
    # Character#isValidCodePoint}.
    # 
    # @return  The illegal Unicode code point
    def get_code_point
      return @c
    end
    
    typesig { [] }
    def get_message
      return String.format("Code point = %#x", @c)
    end
    
    private
    alias_method :initialize__illegal_format_code_point_exception, :initialize
  end
  
end

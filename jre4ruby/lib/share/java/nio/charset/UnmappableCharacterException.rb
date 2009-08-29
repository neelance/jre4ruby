require "rjava"

# Copyright 2001-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Charset
  module UnmappableCharacterExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
    }
  end
  
  # Checked exception thrown when an input character (or byte) sequence
  # is valid but cannot be mapped to an output byte (or character)
  # sequence.  </p>
  # 
  # @since 1.4
  class UnmappableCharacterException < UnmappableCharacterExceptionImports.const_get :CharacterCodingException
    include_class_members UnmappableCharacterExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7026962371537706123 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :input_length
    alias_method :attr_input_length, :input_length
    undef_method :input_length
    alias_method :attr_input_length=, :input_length=
    undef_method :input_length=
    
    typesig { [::Java::Int] }
    def initialize(input_length)
      @input_length = 0
      super()
      @input_length = input_length
    end
    
    typesig { [] }
    def get_input_length
      return @input_length
    end
    
    typesig { [] }
    def get_message
      return "Input length = " + RJava.cast_to_string(@input_length)
    end
    
    private
    alias_method :initialize__unmappable_character_exception, :initialize
  end
  
end

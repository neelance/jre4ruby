require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module ParsePositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # <code>ParsePosition</code> is a simple class used by <code>Format</code>
  # and its subclasses to keep track of the current position during parsing.
  # The <code>parseObject</code> method in the various <code>Format</code>
  # classes requires a <code>ParsePosition</code> object as an argument.
  # 
  # <p>
  # By design, as you parse through a string with different formats,
  # you can use the same <code>ParsePosition</code>, since the index parameter
  # records the current position.
  # 
  # @author      Mark Davis
  # @see         java.text.Format
  class ParsePosition 
    include_class_members ParsePositionImports
    
    # Input: the place you start parsing.
    # <br>Output: position where the parse stopped.
    # This is designed to be used serially,
    # with each call setting index up for the next one.
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :error_index
    alias_method :attr_error_index, :error_index
    undef_method :error_index
    alias_method :attr_error_index=, :error_index=
    undef_method :error_index=
    
    typesig { [] }
    # Retrieve the current parse position.  On input to a parse method, this
    # is the index of the character at which parsing will begin; on output, it
    # is the index of the character following the last character parsed.
    def get_index
      return @index
    end
    
    typesig { [::Java::Int] }
    # Set the current parse position.
    def set_index(index)
      @index = index
    end
    
    typesig { [::Java::Int] }
    # Create a new ParsePosition with the given initial index.
    def initialize(index)
      @index = 0
      @error_index = -1
      @index = index
    end
    
    typesig { [::Java::Int] }
    # Set the index at which a parse error occurred.  Formatters
    # should set this before returning an error code from their
    # parseObject method.  The default value is -1 if this is not set.
    # @since 1.2
    def set_error_index(ei)
      @error_index = ei
    end
    
    typesig { [] }
    # Retrieve the index at which an error occurred, or -1 if the
    # error index has not been set.
    # @since 1.2
    def get_error_index
      return @error_index
    end
    
    typesig { [Object] }
    # Overrides equals
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      if (!(obj.is_a?(ParsePosition)))
        return false
      end
      other = obj
      return ((@index).equal?(other.attr_index) && (@error_index).equal?(other.attr_error_index))
    end
    
    typesig { [] }
    # Returns a hash code for this ParsePosition.
    # @return a hash code value for this object
    def hash_code
      return (@error_index << 16) | @index
    end
    
    typesig { [] }
    # Return a string representation of this ParsePosition.
    # @return  a string representation of this object
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[index=" + RJava.cast_to_string(@index) + ",errorIndex=" + RJava.cast_to_string(@error_index) + RJava.cast_to_string(Character.new(?].ord))
    end
    
    private
    alias_method :initialize__parse_position, :initialize
  end
  
end

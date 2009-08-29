require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module URISyntaxExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # Checked exception thrown to indicate that a string could not be parsed as a
  # URI reference.
  # 
  # @author Mark Reinhold
  # @see URI
  # @since 1.4
  class URISyntaxException < URISyntaxExceptionImports.const_get :JavaException
    include_class_members URISyntaxExceptionImports
    
    attr_accessor :input
    alias_method :attr_input, :input
    undef_method :input
    alias_method :attr_input=, :input=
    undef_method :input=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    typesig { [String, String, ::Java::Int] }
    # Constructs an instance from the given input string, reason, and error
    # index.
    # 
    # @param  input   The input string
    # @param  reason  A string explaining why the input could not be parsed
    # @param  index   The index at which the parse error occurred,
    # or <tt>-1</tt> if the index is not known
    # 
    # @throws  NullPointerException
    # If either the input or reason strings are <tt>null</tt>
    # 
    # @throws  IllegalArgumentException
    # If the error index is less than <tt>-1</tt>
    def initialize(input, reason, index)
      @input = nil
      @index = 0
      super(reason)
      if (((input).nil?) || ((reason).nil?))
        raise NullPointerException.new
      end
      if (index < -1)
        raise IllegalArgumentException.new
      end
      @input = input
      @index = index
    end
    
    typesig { [String, String] }
    # Constructs an instance from the given input string and reason.  The
    # resulting object will have an error index of <tt>-1</tt>.
    # 
    # @param  input   The input string
    # @param  reason  A string explaining why the input could not be parsed
    # 
    # @throws  NullPointerException
    # If either the input or reason strings are <tt>null</tt>
    def initialize(input, reason)
      initialize__urisyntax_exception(input, reason, -1)
    end
    
    typesig { [] }
    # Returns the input string.
    # 
    # @return  The input string
    def get_input
      return @input
    end
    
    typesig { [] }
    # Returns a string explaining why the input string could not be parsed.
    # 
    # @return  The reason string
    def get_reason
      return JavaException.instance_method(:get_message).bind(self).call
    end
    
    typesig { [] }
    # Returns an index into the input string of the position at which the
    # parse error occurred, or <tt>-1</tt> if this position is not known.
    # 
    # @return  The error index
    def get_index
      return @index
    end
    
    typesig { [] }
    # Returns a string describing the parse error.  The resulting string
    # consists of the reason string followed by a colon character
    # (<tt>':'</tt>), a space, and the input string.  If the error index is
    # defined then the string <tt>" at index "</tt> followed by the index, in
    # decimal, is inserted after the reason string and before the colon
    # character.
    # 
    # @return  A string describing the parse error
    def get_message
      sb = StringBuffer.new
      sb.append(get_reason)
      if (@index > -1)
        sb.append(" at index ")
        sb.append(@index)
      end
      sb.append(": ")
      sb.append(@input)
      return sb.to_s
    end
    
    private
    alias_method :initialize__urisyntax_exception, :initialize
  end
  
end

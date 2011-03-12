require "rjava"

# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Regex
  module PatternSyntaxExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Regex
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Unchecked exception thrown to indicate a syntax error in a
  # regular-expression pattern.
  # 
  # @author  unascribed
  # @since 1.4
  # @spec JSR-51
  class PatternSyntaxException < PatternSyntaxExceptionImports.const_get :IllegalArgumentException
    include_class_members PatternSyntaxExceptionImports
    
    attr_accessor :desc
    alias_method :attr_desc, :desc
    undef_method :desc
    alias_method :attr_desc=, :desc=
    undef_method :desc=
    
    attr_accessor :pattern
    alias_method :attr_pattern, :pattern
    undef_method :pattern
    alias_method :attr_pattern=, :pattern=
    undef_method :pattern=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    typesig { [String, String, ::Java::Int] }
    # Constructs a new instance of this class.
    # 
    # @param  desc
    #         A description of the error
    # 
    # @param  regex
    #         The erroneous pattern
    # 
    # @param  index
    #         The approximate index in the pattern of the error,
    #         or <tt>-1</tt> if the index is not known
    def initialize(desc, regex, index)
      @desc = nil
      @pattern = nil
      @index = 0
      super()
      @desc = desc
      @pattern = regex
      @index = index
    end
    
    typesig { [] }
    # Retrieves the error index.
    # 
    # @return  The approximate index in the pattern of the error,
    #         or <tt>-1</tt> if the index is not known
    def get_index
      return @index
    end
    
    typesig { [] }
    # Retrieves the description of the error.
    # 
    # @return  The description of the error
    def get_description
      return @desc
    end
    
    typesig { [] }
    # Retrieves the erroneous regular-expression pattern.
    # 
    # @return  The erroneous pattern
    def get_pattern
      return @pattern
    end
    
    class_module.module_eval {
      const_set_lazy(:Nl) { Java::Security::AccessController.do_privileged(GetPropertyAction.new("line.separator")) }
      const_attr_reader  :Nl
    }
    
    typesig { [] }
    # Returns a multi-line string containing the description of the syntax
    # error and its index, the erroneous regular-expression pattern, and a
    # visual indication of the error index within the pattern.
    # 
    # @return  The full detail message
    def get_message
      sb = StringBuffer.new
      sb.append(@desc)
      if (@index >= 0)
        sb.append(" near index ")
        sb.append(@index)
      end
      sb.append(Nl)
      sb.append(@pattern)
      if (@index >= 0)
        sb.append(Nl)
        i = 0
        while i < @index
          sb.append(Character.new(?\s.ord))
          i += 1
        end
        sb.append(Character.new(?^.ord))
      end
      return sb.to_s
    end
    
    private
    alias_method :initialize__pattern_syntax_exception, :initialize
  end
  
end

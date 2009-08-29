require "rjava"

# Copyright 2001-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CodingErrorActionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
    }
  end
  
  # A typesafe enumeration for coding-error actions.
  # 
  # <p> Instances of this class are used to specify how malformed-input and
  # unmappable-character errors are to be handled by charset <a
  # href="CharsetDecoder.html#cae">decoders</a> and <a
  # href="CharsetEncoder.html#cae">encoders</a>.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class CodingErrorAction 
    include_class_members CodingErrorActionImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [String] }
    def initialize(name)
      @name = nil
      @name = name
    end
    
    class_module.module_eval {
      # Action indicating that a coding error is to be handled by dropping the
      # erroneous input and resuming the coding operation.  </p>
      const_set_lazy(:IGNORE) { CodingErrorAction.new("IGNORE") }
      const_attr_reader  :IGNORE
      
      # Action indicating that a coding error is to be handled by dropping the
      # erroneous input, appending the coder's replacement value to the output
      # buffer, and resuming the coding operation.  </p>
      const_set_lazy(:REPLACE) { CodingErrorAction.new("REPLACE") }
      const_attr_reader  :REPLACE
      
      # Action indicating that a coding error is to be reported, either by
      # returning a {@link CoderResult} object or by throwing a {@link
      # CharacterCodingException}, whichever is appropriate for the method
      # implementing the coding process.
      const_set_lazy(:REPORT) { CodingErrorAction.new("REPORT") }
      const_attr_reader  :REPORT
    }
    
    typesig { [] }
    # Returns a string describing this action.  </p>
    # 
    # @return  A descriptive string
    def to_s
      return @name
    end
    
    private
    alias_method :initialize__coding_error_action, :initialize
  end
  
end

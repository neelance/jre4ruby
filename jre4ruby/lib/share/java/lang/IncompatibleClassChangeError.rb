require "rjava"

# Copyright 1994-1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IncompatibleClassChangeErrorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown when an incompatible class change has occurred to some class
  # definition. The definition of some class, on which the currently
  # executing method depends, has since changed.
  # 
  # @author  unascribed
  # @since   JDK1.0
  class IncompatibleClassChangeError < IncompatibleClassChangeErrorImports.const_get :LinkageError
    include_class_members IncompatibleClassChangeErrorImports
    
    typesig { [] }
    # Constructs an <code>IncompatibleClassChangeError</code> with no
    # detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an <code>IncompatibleClassChangeError</code> with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__incompatible_class_change_error, :initialize
  end
  
end

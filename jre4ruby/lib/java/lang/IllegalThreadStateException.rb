require "rjava"

# 
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
  module IllegalThreadStateExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # 
  # Thrown to indicate that a thread is not in an appropriate state
  # for the requested operation. See, for example, the
  # <code>suspend</code> and <code>resume</code> methods in class
  # <code>Thread</code>.
  # 
  # @author  unascribed
  # @see     java.lang.Thread#resume()
  # @see     java.lang.Thread#suspend()
  # @since   JDK1.0
  class IllegalThreadStateException < IllegalThreadStateExceptionImports.const_get :IllegalArgumentException
    include_class_members IllegalThreadStateExceptionImports
    
    typesig { [] }
    # 
    # Constructs an <code>IllegalThreadStateException</code> with no
    # detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # 
    # Constructs an <code>IllegalThreadStateException</code> with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__illegal_thread_state_exception, :initialize
  end
  
end

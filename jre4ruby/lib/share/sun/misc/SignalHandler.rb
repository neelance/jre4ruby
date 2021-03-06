require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module SignalHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # This is the signal handler interface expected in <code>Signal.handle</code>.
  # 
  # @author   Sheng Liang
  # @author   Bill Shannon
  # @see      sun.misc.Signal
  # @since    1.2
  module SignalHandler
    include_class_members SignalHandlerImports
    
    class_module.module_eval {
      # The default signal handler
      const_set_lazy(:SIG_DFL) { NativeSignalHandler.new(0) }
      const_attr_reader  :SIG_DFL
      
      # Ignore the signal
      const_set_lazy(:SIG_IGN) { NativeSignalHandler.new(1) }
      const_attr_reader  :SIG_IGN
    }
    
    typesig { [Signal] }
    # Handle the given signal
    # 
    # @param sig a signal object
    def handle(sig)
      raise NotImplementedError
    end
  end
  
end

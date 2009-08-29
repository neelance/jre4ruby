require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module SelChImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
    }
  end
  
  # An interface that allows translation (and more!).
  # 
  # @since 1.4
  module SelChImpl
    include_class_members SelChImplImports
    
    typesig { [] }
    def get_fd
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_fdval
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    # Adds the specified ops if present in interestOps. The specified
    # ops are turned on without affecting the other ops.
    # 
    # @return  true iff the new value of sk.readyOps() set by this method
    # contains at least one bit that the previous value did not
    # contain
    def translate_and_update_ready_ops(ops, sk)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    # Sets the specified ops if present in interestOps. The specified
    # ops are turned on, and all other ops are turned off.
    # 
    # @return  true iff the new value of sk.readyOps() set by this method
    # contains at least one bit that the previous value did not
    # contain
    def translate_and_set_ready_ops(ops, sk)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    def translate_and_set_interest_ops(ops, sk)
      raise NotImplementedError
    end
    
    typesig { [] }
    def valid_ops
      raise NotImplementedError
    end
    
    typesig { [] }
    def kill
      raise NotImplementedError
    end
  end
  
end

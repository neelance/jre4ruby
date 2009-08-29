require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module ByteVectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  # A growable array of bytes.
  module ByteVector
    include_class_members ByteVectorImports
    
    typesig { [] }
    def get_length
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    def get(index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(index, value)
      raise NotImplementedError
    end
    
    typesig { [::Java::Byte] }
    def add(value)
      raise NotImplementedError
    end
    
    typesig { [] }
    def trim
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_data
      raise NotImplementedError
    end
  end
  
end

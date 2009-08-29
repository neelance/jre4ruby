require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Zip
  module ChecksumImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # An interface representing a data checksum.
  # 
  # @author      David Connelly
  module Checksum
    include_class_members ChecksumImports
    
    typesig { [::Java::Int] }
    # Updates the current checksum with the specified byte.
    # 
    # @param b the byte to update the checksum with
    def update(b)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the current checksum with the specified array of bytes.
    # @param b the byte array to update the checksum with
    # @param off the start offset of the data
    # @param len the number of bytes to use for the update
    def update(b, off, len)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current checksum value.
    # @return the current checksum value
    def get_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Resets the checksum to its initial value.
    def reset
      raise NotImplementedError
    end
  end
  
end

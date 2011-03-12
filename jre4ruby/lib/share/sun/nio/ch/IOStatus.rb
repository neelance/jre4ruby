require "rjava"

# Copyright 2002-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IOStatusImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
    }
  end
  
  # Constants for reporting I/O status
  class IOStatus 
    include_class_members IOStatusImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      const_set_lazy(:EOF) { -1 }
      const_attr_reader  :EOF
      
      # End of file
      const_set_lazy(:UNAVAILABLE) { -2 }
      const_attr_reader  :UNAVAILABLE
      
      # Nothing available (non-blocking)
      const_set_lazy(:INTERRUPTED) { -3 }
      const_attr_reader  :INTERRUPTED
      
      # System call interrupted
      const_set_lazy(:UNSUPPORTED) { -4 }
      const_attr_reader  :UNSUPPORTED
      
      # Operation not supported
      const_set_lazy(:THROWN) { -5 }
      const_attr_reader  :THROWN
      
      # Exception thrown in JNI code
      const_set_lazy(:UNSUPPORTED_CASE) { -6 }
      const_attr_reader  :UNSUPPORTED_CASE
      
      typesig { [::Java::Int] }
      # This case not supported
      # The following two methods are for use in try/finally blocks where a
      # status value needs to be normalized before being returned to the invoker
      # but also checked for illegal negative values before the return
      # completes, like so:
      # 
      #     int n = 0;
      #     try {
      #         begin();
      #         n = op(fd, buf, ...);
      #         return IOStatus.normalize(n);    // Converts UNAVAILABLE to zero
      #     } finally {
      #         end(n > 0);
      #         assert IOStatus.check(n);        // Checks other negative values
      #     }
      # 
      def normalize(n)
        if ((n).equal?(UNAVAILABLE))
          return 0
        end
        return n
      end
      
      typesig { [::Java::Int] }
      def check(n)
        return (n >= UNAVAILABLE)
      end
      
      typesig { [::Java::Long] }
      def normalize(n)
        if ((n).equal?(UNAVAILABLE))
          return 0
        end
        return n
      end
      
      typesig { [::Java::Long] }
      def check(n)
        return (n >= UNAVAILABLE)
      end
      
      typesig { [::Java::Long] }
      # Return true iff n is not one of the IOStatus values
      def check_all(n)
        return ((n > EOF) || (n < UNSUPPORTED_CASE))
      end
    }
    
    private
    alias_method :initialize__iostatus, :initialize
  end
  
end

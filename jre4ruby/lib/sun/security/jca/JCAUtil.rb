require "rjava"

# 
# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jca
  module JCAUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jca
      include ::Java::Lang::Ref
      include ::Java::Security
    }
  end
  
  # 
  # Collection of static utility methods used by the security framework.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class JCAUtil 
    include_class_members JCAUtilImports
    
    typesig { [] }
    def initialize
      # no instantiation
    end
    
    class_module.module_eval {
      # lock to use for synchronization
      const_set_lazy(:LOCK) { JCAUtil.class }
      const_attr_reader  :LOCK
      
      # cached SecureRandom instance
      
      def secure_random
        defined?(@@secure_random) ? @@secure_random : @@secure_random= nil
      end
      alias_method :attr_secure_random, :secure_random
      
      def secure_random=(value)
        @@secure_random = value
      end
      alias_method :attr_secure_random=, :secure_random=
      
      # size of the temporary arrays we use. Should fit into the CPU's 1st
      # level cache and could be adjusted based on the platform
      const_set_lazy(:ARRAY_SIZE) { 4096 }
      const_attr_reader  :ARRAY_SIZE
      
      typesig { [::Java::Int] }
      # 
      # Get the size of a temporary buffer array to use in order to be
      # cache efficient. totalSize indicates the total amount of data to
      # be buffered. Used by the engineUpdate(ByteBuffer) methods.
      def get_temp_array_size(total_size)
        return Math.min(ARRAY_SIZE, total_size)
      end
      
      typesig { [] }
      # 
      # Get a SecureRandom instance. This method should me used by JDK
      # internal code in favor of calling "new SecureRandom()". That needs to
      # iterate through the provider table to find the default SecureRandom
      # implementation, which is fairly inefficient.
      def get_secure_random
        # we use double checked locking to minimize synchronization
        # works because we use a volatile reference
        r = self.attr_secure_random
        if ((r).nil?)
          synchronized((LOCK)) do
            r = self.attr_secure_random
            if ((r).nil?)
              r = SecureRandom.new
              self.attr_secure_random = r
            end
          end
        end
        return r
      end
    }
    
    private
    alias_method :initialize__jcautil, :initialize
  end
  
end

require "rjava"

# 
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
  module IOVecWrapperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Sun::Misc
    }
  end
  
  # 
  # Manipulates a native array of iovec structs on Solaris:
  # 
  # typedef struct iovec {
  # caddr_t  iov_base;
  # int      iov_len;
  # } iovec_t;
  # 
  # @author Mike McCloskey
  # @since 1.4
  class IOVecWrapper 
    include_class_members IOVecWrapperImports
    
    class_module.module_eval {
      # Miscellaneous constants
      
      def base_offset
        defined?(@@base_offset) ? @@base_offset : @@base_offset= 0
      end
      alias_method :attr_base_offset, :base_offset
      
      def base_offset=(value)
        @@base_offset = value
      end
      alias_method :attr_base_offset=, :base_offset=
      
      
      def len_offset
        defined?(@@len_offset) ? @@len_offset : @@len_offset= 0
      end
      alias_method :attr_len_offset, :len_offset
      
      def len_offset=(value)
        @@len_offset = value
      end
      alias_method :attr_len_offset=, :len_offset=
      
      
      def size_iovec
        defined?(@@size_iovec) ? @@size_iovec : @@size_iovec= 0
      end
      alias_method :attr_size_iovec, :size_iovec
      
      def size_iovec=(value)
        @@size_iovec = value
      end
      alias_method :attr_size_iovec=, :size_iovec=
    }
    
    # The iovec array
    attr_accessor :vec_array
    alias_method :attr_vec_array, :vec_array
    undef_method :vec_array
    alias_method :attr_vec_array=, :vec_array=
    undef_method :vec_array=
    
    # Base address of this array
    attr_accessor :address
    alias_method :attr_address, :address
    undef_method :address
    alias_method :attr_address=, :address=
    undef_method :address=
    
    class_module.module_eval {
      # Address size in bytes
      
      def address_size
        defined?(@@address_size) ? @@address_size : @@address_size= 0
      end
      alias_method :attr_address_size, :address_size
      
      def address_size=(value)
        @@address_size = value
      end
      alias_method :attr_address_size=, :address_size=
    }
    
    typesig { [::Java::Int] }
    def initialize(new_size)
      @vec_array = nil
      @address = 0
      new_size = (new_size + 1) * self.attr_size_iovec
      @vec_array = AllocatedNativeObject.new(new_size, false)
      @address = @vec_array.address
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_base(i, base)
      offset = self.attr_size_iovec * i + self.attr_base_offset
      if ((self.attr_address_size).equal?(4))
        @vec_array.put_int(offset, RJava.cast_to_int(base))
      else
        @vec_array.put_long(offset, base)
      end
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    def put_len(i, len)
      offset = self.attr_size_iovec * i + self.attr_len_offset
      if ((self.attr_address_size).equal?(4))
        @vec_array.put_int(offset, RJava.cast_to_int(len))
      else
        @vec_array.put_long(offset, len)
      end
    end
    
    typesig { [] }
    def free
      @vec_array.free
    end
    
    class_module.module_eval {
      when_class_loaded do
        self.attr_address_size = Util.unsafe.address_size
        self.attr_len_offset = self.attr_address_size
        self.attr_size_iovec = RJava.cast_to_short((self.attr_address_size * 2))
      end
    }
    
    private
    alias_method :initialize__iovec_wrapper, :initialize
  end
  
end

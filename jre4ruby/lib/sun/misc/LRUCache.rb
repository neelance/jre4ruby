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
module Sun::Misc
  module LRUCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # 
  # Utility class for small LRU caches.
  # 
  # @author Mark Reinhold
  class LRUCache 
    include_class_members LRUCacheImports
    
    attr_accessor :oa
    alias_method :attr_oa, :oa
    undef_method :oa
    alias_method :attr_oa=, :oa=
    undef_method :oa=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [::Java::Int] }
    def initialize(size)
      @oa = nil
      @size = 0
      @size = size
    end
    
    typesig { [Object] }
    def create(name)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    def has_name(ob, name)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [Array.typed(Object), ::Java::Int] }
      def move_to_front(oa, i)
        ob = oa[i]
        j = i
        while j > 0
          oa[j] = oa[j - 1]
          ((j -= 1) + 1)
        end
        oa[0] = ob
      end
    }
    
    typesig { [Object] }
    def for_name(name)
      if ((@oa).nil?)
        @oa = Array.typed(Object).new(@size) { nil }
      else
        i = 0
        while i < @oa.attr_length
          ob = @oa[i]
          if ((ob).nil?)
            ((i += 1) - 1)
            next
          end
          if (has_name(ob, name))
            if (i > 0)
              move_to_front(@oa, i)
            end
            return ob
          end
          ((i += 1) - 1)
        end
      end
      # Create a new object
      ob_ = create(name)
      @oa[@oa.attr_length - 1] = ob_
      move_to_front(@oa, @oa.attr_length - 1)
      return ob_
    end
    
    private
    alias_method :initialize__lrucache, :initialize
  end
  
end

require "rjava"

# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# Sort: a class that uses the quicksort algorithm to sort an
# array of objects.
# 
# @author Sunita Mani
module Sun::Misc
  module SortImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  class Sort 
    include_class_members SortImports
    
    class_module.module_eval {
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int] }
      def swap(arr, i, j)
        tmp = nil
        tmp = arr[i]
        arr[i] = arr[j]
        arr[j] = tmp
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, Compare] }
      # quicksort the array of objects.
      # 
      # @param arr[] - an array of objects
      # @param left - the start index - from where to begin sorting
      # @param right - the last index.
      # @param comp - an object that implemnts the Compare interface to resolve thecomparison.
      def quicksort(arr, left, right, comp)
        i = 0
        last = 0
        if (left >= right)
          # do nothing if array contains fewer than two
          return
          # two elements
        end
        swap(arr, left, (left + right) / 2)
        last = left
        i = left + 1
        while i <= right
          if (comp.do_compare(arr[i], arr[left]) < 0)
            swap(arr, (last += 1), i)
          end
          i += 1
        end
        swap(arr, left, last)
        quicksort(arr, left, last - 1, comp)
        quicksort(arr, last + 1, right, comp)
      end
      
      typesig { [Array.typed(Object), Compare] }
      def quicksort(arr, comp)
        quicksort(arr, 0, arr.attr_length - 1, comp)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__sort, :initialize
  end
  
end

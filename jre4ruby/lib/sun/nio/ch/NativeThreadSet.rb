require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NativeThreadSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
    }
  end
  
  # Special-purpose data structure for sets of native threads
  class NativeThreadSet 
    include_class_members NativeThreadSetImports
    
    attr_accessor :elts
    alias_method :attr_elts, :elts
    undef_method :elts
    alias_method :attr_elts=, :elts=
    undef_method :elts=
    
    attr_accessor :used
    alias_method :attr_used, :used
    undef_method :used
    alias_method :attr_used=, :used=
    undef_method :used=
    
    typesig { [::Java::Int] }
    def initialize(n)
      @elts = nil
      @used = 0
      @elts = Array.typed(::Java::Long).new(n) { 0 }
    end
    
    typesig { [] }
    # Adds the current native thread to this set, returning its index so that
    # it can efficiently be removed later.
    def add
      th = NativeThread.current
      if ((th).equal?(-1))
        return -1
      end
      synchronized((self)) do
        start = 0
        if (@used >= @elts.attr_length)
          on = @elts.attr_length
          nn = on * 2
          nelts = Array.typed(::Java::Long).new(nn) { 0 }
          System.arraycopy(@elts, 0, nelts, 0, on)
          @elts = nelts
          start = on
        end
        i = start
        while i < @elts.attr_length
          if ((@elts[i]).equal?(0))
            @elts[i] = th
            ((@used += 1) - 1)
            return i
          end
          ((i += 1) - 1)
        end
        raise AssertError if not (false)
        return -1
      end
    end
    
    typesig { [::Java::Int] }
    # Removes the thread at the given index.
    def remove(i)
      if (i < 0)
        return
      end
      synchronized((self)) do
        @elts[i] = 0
        ((@used -= 1) + 1)
      end
    end
    
    typesig { [] }
    # Signals all threads in this set.
    def signal
      synchronized((self)) do
        u = @used
        n = @elts.attr_length
        i = 0
        while i < n
          th = @elts[i]
          if ((th).equal?(0))
            ((i += 1) - 1)
            next
          end
          NativeThread.signal(th)
          if (((u -= 1)).equal?(0))
            break
          end
          ((i += 1) - 1)
        end
      end
    end
    
    private
    alias_method :initialize__native_thread_set, :initialize
  end
  
end

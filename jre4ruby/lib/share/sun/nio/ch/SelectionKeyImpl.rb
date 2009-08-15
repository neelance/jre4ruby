require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SelectionKeyImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # An implementation of SelectionKey for Solaris.
  class SelectionKeyImpl < SelectionKeyImplImports.const_get :AbstractSelectionKey
    include_class_members SelectionKeyImplImports
    
    attr_accessor :channel
    alias_method :attr_channel, :channel
    undef_method :channel
    alias_method :attr_channel=, :channel=
    undef_method :channel=
    
    # package-private
    attr_accessor :selector
    alias_method :attr_selector, :selector
    undef_method :selector
    alias_method :attr_selector=, :selector=
    undef_method :selector=
    
    # package-private
    # Index for a pollfd array in Selector that this key is registered with
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :interest_ops
    alias_method :attr_interest_ops, :interest_ops
    undef_method :interest_ops
    alias_method :attr_interest_ops=, :interest_ops=
    undef_method :interest_ops=
    
    attr_accessor :ready_ops
    alias_method :attr_ready_ops, :ready_ops
    undef_method :ready_ops
    alias_method :attr_ready_ops=, :ready_ops=
    undef_method :ready_ops=
    
    typesig { [SelChImpl, SelectorImpl] }
    def initialize(ch, sel)
      @channel = nil
      @selector = nil
      @index = 0
      @interest_ops = 0
      @ready_ops = 0
      super()
      @channel = ch
      @selector = sel
    end
    
    typesig { [] }
    def channel
      return @channel
    end
    
    typesig { [] }
    def selector
      return @selector
    end
    
    typesig { [] }
    def get_index
      # package-private
      return @index
    end
    
    typesig { [::Java::Int] }
    def set_index(i)
      # package-private
      @index = i
    end
    
    typesig { [] }
    def ensure_valid
      if (!is_valid)
        raise CancelledKeyException.new
      end
    end
    
    typesig { [] }
    def interest_ops
      ensure_valid
      return @interest_ops
    end
    
    typesig { [::Java::Int] }
    def interest_ops(ops)
      ensure_valid
      return nio_interest_ops(ops)
    end
    
    typesig { [] }
    def ready_ops
      ensure_valid
      return @ready_ops
    end
    
    typesig { [::Java::Int] }
    # The nio versions of these operations do not care if a key
    # has been invalidated. They are for internal use by nio code.
    def nio_ready_ops(ops)
      # package-private
      @ready_ops = ops
    end
    
    typesig { [] }
    def nio_ready_ops
      # package-private
      return @ready_ops
    end
    
    typesig { [::Java::Int] }
    def nio_interest_ops(ops)
      # package-private
      if (!((ops & ~channel.valid_ops)).equal?(0))
        raise IllegalArgumentException.new
      end
      @channel.translate_and_set_interest_ops(ops, self)
      @interest_ops = ops
      return self
    end
    
    typesig { [] }
    def nio_interest_ops
      # package-private
      return @interest_ops
    end
    
    private
    alias_method :initialize__selection_key_impl, :initialize
  end
  
end

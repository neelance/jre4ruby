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
  module SelectorImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Net, :SocketException
      include ::Java::Util
      include ::Sun::Misc
    }
  end
  
  # Base Selector implementation class.
  class SelectorImpl < SelectorImplImports.const_get :AbstractSelector
    include_class_members SelectorImplImports
    
    # The set of keys with data ready for an operation
    attr_accessor :selected_keys
    alias_method :attr_selected_keys, :selected_keys
    undef_method :selected_keys
    alias_method :attr_selected_keys=, :selected_keys=
    undef_method :selected_keys=
    
    # The set of keys registered with this Selector
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    # Public views of the key sets
    attr_accessor :public_keys
    alias_method :attr_public_keys, :public_keys
    undef_method :public_keys
    alias_method :attr_public_keys=, :public_keys=
    undef_method :public_keys=
    
    # Immutable
    attr_accessor :public_selected_keys
    alias_method :attr_public_selected_keys, :public_selected_keys
    undef_method :public_selected_keys
    alias_method :attr_public_selected_keys=, :public_selected_keys=
    undef_method :public_selected_keys=
    
    typesig { [SelectorProvider] }
    # Removal allowed, but not addition
    def initialize(sp)
      @selected_keys = nil
      @keys = nil
      @public_keys = nil
      @public_selected_keys = nil
      super(sp)
      @keys = HashSet.new
      @selected_keys = HashSet.new
      if (Util.at_bug_level("1.4"))
        @public_keys = @keys
        @public_selected_keys = @selected_keys
      else
        @public_keys = Collections.unmodifiable_set(@keys)
        @public_selected_keys = Util.ungrowable_set(@selected_keys)
      end
    end
    
    typesig { [] }
    def keys
      if (!is_open && !Util.at_bug_level("1.4"))
        raise ClosedSelectorException.new
      end
      return @public_keys
    end
    
    typesig { [] }
    def selected_keys
      if (!is_open && !Util.at_bug_level("1.4"))
        raise ClosedSelectorException.new
      end
      return @public_selected_keys
    end
    
    typesig { [::Java::Long] }
    def do_select(timeout)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long] }
    def lock_and_do_select(timeout)
      synchronized((self)) do
        if (!is_open)
          raise ClosedSelectorException.new
        end
        synchronized((@public_keys)) do
          synchronized((@public_selected_keys)) do
            return do_select(timeout)
          end
        end
      end
    end
    
    typesig { [::Java::Long] }
    def select(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("Negative timeout")
      end
      return lock_and_do_select(((timeout).equal?(0)) ? -1 : timeout)
    end
    
    typesig { [] }
    def select
      return select(0)
    end
    
    typesig { [] }
    def select_now
      return lock_and_do_select(0)
    end
    
    typesig { [] }
    def impl_close_selector
      wakeup
      synchronized((self)) do
        synchronized((@public_keys)) do
          synchronized((@public_selected_keys)) do
            impl_close
          end
        end
      end
    end
    
    typesig { [] }
    def impl_close
      raise NotImplementedError
    end
    
    typesig { [SelectionKeyImpl, ::Java::Int] }
    def put_event_ops(sk, ops)
    end
    
    typesig { [AbstractSelectableChannel, ::Java::Int, Object] }
    def register(ch, ops, attachment)
      if (!(ch.is_a?(SelChImpl)))
        raise IllegalSelectorException.new
      end
      k = SelectionKeyImpl.new(ch, self)
      k.attach(attachment)
      synchronized((@public_keys)) do
        impl_register(k)
      end
      k.interest_ops(ops)
      return k
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_register(ski)
      raise NotImplementedError
    end
    
    typesig { [] }
    def process_deregister_queue
      # Precondition: Synchronized on this, keys, and selectedKeys
      cks = cancelled_keys
      synchronized((cks)) do
        i = cks.iterator
        while (i.has_next)
          ski = i.next_
          begin
            impl_dereg(ski)
          rescue SocketException => se
            ioe = IOException.new("Error deregistering key")
            ioe.init_cause(se)
            raise ioe
          ensure
            i.remove
          end
        end
      end
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_dereg(ski)
      raise NotImplementedError
    end
    
    typesig { [] }
    def wakeup
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__selector_impl, :initialize
  end
  
end

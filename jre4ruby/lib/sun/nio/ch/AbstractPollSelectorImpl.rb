require "rjava"

# 
# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AbstractPollSelectorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include ::Java::Util
      include ::Sun::Misc
    }
  end
  
  # 
  # An abstract selector impl.
  class AbstractPollSelectorImpl < AbstractPollSelectorImplImports.const_get :SelectorImpl
    include_class_members AbstractPollSelectorImplImports
    
    # The poll fd array
    attr_accessor :poll_wrapper
    alias_method :attr_poll_wrapper, :poll_wrapper
    undef_method :poll_wrapper
    alias_method :attr_poll_wrapper=, :poll_wrapper=
    undef_method :poll_wrapper=
    
    # Initial capacity of the pollfd array
    attr_accessor :init_cap
    alias_method :attr_init_cap, :init_cap
    undef_method :init_cap
    alias_method :attr_init_cap=, :init_cap=
    undef_method :init_cap=
    
    # The list of SelectableChannels serviced by this Selector
    attr_accessor :channel_array
    alias_method :attr_channel_array, :channel_array
    undef_method :channel_array
    alias_method :attr_channel_array=, :channel_array=
    undef_method :channel_array=
    
    # In some impls the first entry of channelArray is bogus
    attr_accessor :channel_offset
    alias_method :attr_channel_offset, :channel_offset
    undef_method :channel_offset
    alias_method :attr_channel_offset=, :channel_offset=
    undef_method :channel_offset=
    
    # The number of valid channels in this Selector's poll array
    attr_accessor :total_channels
    alias_method :attr_total_channels, :total_channels
    undef_method :total_channels
    alias_method :attr_total_channels=, :total_channels=
    undef_method :total_channels=
    
    # True if this Selector has been closed
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    typesig { [SelectorProvider, ::Java::Int, ::Java::Int] }
    def initialize(sp, channels, offset)
      @poll_wrapper = nil
      @init_cap = 0
      @channel_array = nil
      @channel_offset = 0
      @total_channels = 0
      @closed = false
      super(sp)
      @init_cap = 10
      @channel_offset = 0
      @closed = false
      @total_channels = channels
      @channel_offset = offset
    end
    
    typesig { [SelectionKeyImpl, ::Java::Int] }
    def put_event_ops(sk, ops)
      @poll_wrapper.put_event_ops(sk.get_index, ops)
    end
    
    typesig { [] }
    def wakeup
      @poll_wrapper.interrupt
      return self
    end
    
    typesig { [::Java::Long] }
    def do_select(timeout)
      raise NotImplementedError
    end
    
    typesig { [] }
    def impl_close
      if (!@closed)
        @closed = true
        # Deregister channels
        i = @channel_offset
        while i < @total_channels
          ski = @channel_array[i]
          raise AssertError if not ((!(ski.get_index).equal?(-1)))
          ski.set_index(-1)
          deregister(ski)
          selch = @channel_array[i].channel
          if (!selch.is_open && !selch.is_registered)
            (selch).kill
          end
          ((i += 1) - 1)
        end
        impl_close_interrupt
        @poll_wrapper.free
        @poll_wrapper = nil
        self.attr_selected_keys = nil
        @channel_array = nil
        @total_channels = 0
      end
    end
    
    typesig { [] }
    def impl_close_interrupt
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Copy the information in the pollfd structs into the opss
    # of the corresponding Channels. Add the ready keys to the
    # ready queue.
    def update_selected_keys
      num_keys_updated = 0
      # Skip zeroth entry; it is for interrupts only
      i = @channel_offset
      while i < @total_channels
        r_ops = @poll_wrapper.get_revent_ops(i)
        if (!(r_ops).equal?(0))
          sk = @channel_array[i]
          @poll_wrapper.put_revent_ops(i, 0)
          if (self.attr_selected_keys.contains(sk))
            if (sk.attr_channel.translate_and_set_ready_ops(r_ops, sk))
              ((num_keys_updated += 1) - 1)
            end
          else
            sk.attr_channel.translate_and_set_ready_ops(r_ops, sk)
            if (!((sk.nio_ready_ops & sk.nio_interest_ops)).equal?(0))
              self.attr_selected_keys.add(sk)
              ((num_keys_updated += 1) - 1)
            end
          end
        end
        ((i += 1) - 1)
      end
      return num_keys_updated
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_register(ski)
      # Check to see if the array is large enough
      if ((@channel_array.attr_length).equal?(@total_channels))
        # Make a larger array
        new_size = @poll_wrapper.attr_total_channels * 2
        temp = Array.typed(SelectionKeyImpl).new(new_size) { nil }
        # Copy over
        i = @channel_offset
        while i < @total_channels
          temp[i] = @channel_array[i]
          ((i += 1) - 1)
        end
        @channel_array = temp
        # Grow the NativeObject poll array
        @poll_wrapper.grow(new_size)
      end
      @channel_array[@total_channels] = ski
      ski.set_index(@total_channels)
      @poll_wrapper.add_entry(ski.attr_channel)
      ((@total_channels += 1) - 1)
      self.attr_keys.add(ski)
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_dereg(ski)
      # Algorithm: Copy the sc from the end of the list and put it into
      # the location of the sc to be removed (since order doesn't
      # matter). Decrement the sc count. Update the index of the sc
      # that is moved.
      i = ski.get_index
      raise AssertError if not ((i >= 0))
      if (!(i).equal?(@total_channels - 1))
        # Copy end one over it
        end_channel = @channel_array[@total_channels - 1]
        @channel_array[i] = end_channel
        end_channel.set_index(i)
        @poll_wrapper.release(i)
        PollArrayWrapper.replace_entry(@poll_wrapper, @total_channels - 1, @poll_wrapper, i)
      else
        @poll_wrapper.release(i)
      end
      # Destroy the last one
      @channel_array[@total_channels - 1] = nil
      ((@total_channels -= 1) + 1)
      ((@poll_wrapper.attr_total_channels -= 1) + 1)
      ski.set_index(-1)
      # Remove the key from keys and selectedKeys
      self.attr_keys.remove(ski)
      self.attr_selected_keys.remove(ski)
      deregister(ski)
      selch = ski.channel
      if (!selch.is_open && !selch.is_registered)
        (selch).kill
      end
    end
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
      end
    }
    
    private
    alias_method :initialize__abstract_poll_selector_impl, :initialize
  end
  
end

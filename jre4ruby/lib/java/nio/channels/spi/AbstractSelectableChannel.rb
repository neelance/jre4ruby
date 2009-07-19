require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Channels::Spi
  module AbstractSelectableChannelImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Io, :IOException
      include ::Java::Nio::Channels
    }
  end
  
  # Base implementation class for selectable channels.
  # 
  # <p> This class defines methods that handle the mechanics of channel
  # registration, deregistration, and closing.  It maintains the current
  # blocking mode of this channel as well as its current set of selection keys.
  # It performs all of the synchronization required to implement the {@link
  # java.nio.channels.SelectableChannel} specification.  Implementations of the
  # abstract protected methods defined in this class need not synchronize
  # against other threads that might be engaged in the same operations.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author Mike McCloskey
  # @author JSR-51 Expert Group
  # @since 1.4
  class AbstractSelectableChannel < AbstractSelectableChannelImports.const_get :SelectableChannel
    include_class_members AbstractSelectableChannelImports
    
    # The provider that created this channel
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # Keys that have been created by registering this channel with selectors.
    # They are saved because if this channel is closed the keys must be
    # deregistered.  Protected by keyLock.
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    attr_accessor :key_count
    alias_method :attr_key_count, :key_count
    undef_method :key_count
    alias_method :attr_key_count=, :key_count=
    undef_method :key_count=
    
    # Lock for key set and count
    attr_accessor :key_lock
    alias_method :attr_key_lock, :key_lock
    undef_method :key_lock
    alias_method :attr_key_lock=, :key_lock=
    undef_method :key_lock=
    
    # Lock for registration and configureBlocking operations
    attr_accessor :reg_lock
    alias_method :attr_reg_lock, :reg_lock
    undef_method :reg_lock
    alias_method :attr_reg_lock=, :reg_lock=
    undef_method :reg_lock=
    
    # Blocking mode, protected by regLock
    attr_accessor :blocking
    alias_method :attr_blocking, :blocking
    undef_method :blocking
    alias_method :attr_blocking=, :blocking=
    undef_method :blocking=
    
    typesig { [SelectorProvider] }
    # Initializes a new instance of this class.
    def initialize(provider)
      @provider = nil
      @keys = nil
      @key_count = 0
      @key_lock = nil
      @reg_lock = nil
      @blocking = false
      super()
      @keys = nil
      @key_count = 0
      @key_lock = Object.new
      @reg_lock = Object.new
      @blocking = true
      @provider = provider
    end
    
    typesig { [] }
    # Returns the provider that created this channel.
    # 
    # @return  The provider that created this channel
    def provider
      return @provider
    end
    
    typesig { [SelectionKey] }
    # -- Utility methods for the key set --
    def add_key(k)
      synchronized((@key_lock)) do
        i = 0
        if ((!(@keys).nil?) && (@key_count < @keys.attr_length))
          # Find empty element of key array
          i = 0
          while i < @keys.attr_length
            if ((@keys[i]).nil?)
              break
            end
            ((i += 1) - 1)
          end
        else
          if ((@keys).nil?)
            @keys = Array.typed(SelectionKey).new(3) { nil }
          else
            # Grow key array
            n = @keys.attr_length * 2
            ks = Array.typed(SelectionKey).new(n) { nil }
            i = 0
            while i < @keys.attr_length
              ks[i] = @keys[i]
              ((i += 1) - 1)
            end
            @keys = ks
            i = @key_count
          end
        end
        @keys[i] = k
        ((@key_count += 1) - 1)
      end
    end
    
    typesig { [Selector] }
    def find_key(sel)
      synchronized((@key_lock)) do
        if ((@keys).nil?)
          return nil
        end
        i = 0
        while i < @keys.attr_length
          if ((!(@keys[i]).nil?) && ((@keys[i].selector).equal?(sel)))
            return @keys[i]
          end
          ((i += 1) - 1)
        end
        return nil
      end
    end
    
    typesig { [SelectionKey] }
    def remove_key(k)
      # package-private
      synchronized((@key_lock)) do
        i = 0
        while i < @keys.attr_length
          if ((@keys[i]).equal?(k))
            @keys[i] = nil
            ((@key_count -= 1) + 1)
          end
          ((i += 1) - 1)
        end
        (k).invalidate
      end
    end
    
    typesig { [] }
    def have_valid_keys
      synchronized((@key_lock)) do
        if ((@key_count).equal?(0))
          return false
        end
        i = 0
        while i < @keys.attr_length
          if ((!(@keys[i]).nil?) && @keys[i].is_valid)
            return true
          end
          ((i += 1) - 1)
        end
        return false
      end
    end
    
    typesig { [] }
    # -- Registration --
    def is_registered
      synchronized((@key_lock)) do
        return !(@key_count).equal?(0)
      end
    end
    
    typesig { [Selector] }
    def key_for(sel)
      return find_key(sel)
    end
    
    typesig { [Selector, ::Java::Int, Object] }
    # Registers this channel with the given selector, returning a selection key.
    # 
    # <p>  This method first verifies that this channel is open and that the
    # given initial interest set is valid.
    # 
    # <p> If this channel is already registered with the given selector then
    # the selection key representing that registration is returned after
    # setting its interest set to the given value.
    # 
    # <p> Otherwise this channel has not yet been registered with the given
    # selector, so the {@link AbstractSelector#register register} method of
    # the selector is invoked while holding the appropriate locks.  The
    # resulting key is added to this channel's key set before being returned.
    # </p>
    def register(sel, ops, att)
      if (!is_open)
        raise ClosedChannelException.new
      end
      if (!((ops & ~valid_ops)).equal?(0))
        raise IllegalArgumentException.new
      end
      synchronized((@reg_lock)) do
        if (@blocking)
          raise IllegalBlockingModeException.new
        end
        k = find_key(sel)
        if (!(k).nil?)
          k.interest_ops(ops)
          k.attach(att)
        end
        if ((k).nil?)
          # New registration
          k = (sel).register(self, ops, att)
          add_key(k)
        end
        return k
      end
    end
    
    typesig { [] }
    # -- Closing --
    # 
    # Closes this channel.
    # 
    # <p> This method, which is specified in the {@link
    # AbstractInterruptibleChannel} class and is invoked by the {@link
    # java.nio.channels.Channel#close close} method, in turn invokes the
    # {@link #implCloseSelectableChannel implCloseSelectableChannel} method in
    # order to perform the actual work of closing this channel.  It then
    # cancels all of this channel's keys.  </p>
    def impl_close_channel
      impl_close_selectable_channel
      synchronized((@key_lock)) do
        count = ((@keys).nil?) ? 0 : @keys.attr_length
        i = 0
        while i < count
          k = @keys[i]
          if (!(k).nil?)
            k.cancel
          end
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [] }
    # Closes this selectable channel.
    # 
    # <p> This method is invoked by the {@link java.nio.channels.Channel#close
    # close} method in order to perform the actual work of closing the
    # channel.  This method is only invoked if the channel has not yet been
    # closed, and it is never invoked more than once.
    # 
    # <p> An implementation of this method must arrange for any other thread
    # that is blocked in an I/O operation upon this channel to return
    # immediately, either by throwing an exception or by returning normally.
    # </p>
    def impl_close_selectable_channel
      raise NotImplementedError
    end
    
    typesig { [] }
    # -- Blocking --
    def is_blocking
      synchronized((@reg_lock)) do
        return @blocking
      end
    end
    
    typesig { [] }
    def blocking_lock
      return @reg_lock
    end
    
    typesig { [::Java::Boolean] }
    # Adjusts this channel's blocking mode.
    # 
    # <p> If the given blocking mode is different from the current blocking
    # mode then this method invokes the {@link #implConfigureBlocking
    # implConfigureBlocking} method, while holding the appropriate locks, in
    # order to change the mode.  </p>
    def configure_blocking(block)
      if (!is_open)
        raise ClosedChannelException.new
      end
      synchronized((@reg_lock)) do
        if ((@blocking).equal?(block))
          return self
        end
        if (block && have_valid_keys)
          raise IllegalBlockingModeException.new
        end
        impl_configure_blocking(block)
        @blocking = block
      end
      return self
    end
    
    typesig { [::Java::Boolean] }
    # Adjusts this channel's blocking mode.
    # 
    # <p> This method is invoked by the {@link #configureBlocking
    # configureBlocking} method in order to perform the actual work of
    # changing the blocking mode.  This method is only invoked if the new mode
    # is different from the current mode.  </p>
    # 
    # @throws IOException
    # If an I/O error occurs
    def impl_configure_blocking(block)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__abstract_selectable_channel, :initialize
  end
  
end

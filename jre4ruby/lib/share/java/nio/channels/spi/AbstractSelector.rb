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
module Java::Nio::Channels::Spi
  module AbstractSelectorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio::Channels, :SelectionKey
      include_const ::Java::Nio::Channels, :Selector
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Sun::Nio::Ch, :Interruptible
      include_const ::Java::Util::Concurrent::Atomic, :AtomicBoolean
    }
  end
  
  # Base implementation class for selectors.
  # 
  # <p> This class encapsulates the low-level machinery required to implement
  # the interruption of selection operations.  A concrete selector class must
  # invoke the {@link #begin begin} and {@link #end end} methods before and
  # after, respectively, invoking an I/O operation that might block
  # indefinitely.  In order to ensure that the {@link #end end} method is always
  # invoked, these methods should be used within a
  # <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block: <a name="be">
  # 
  # <blockquote><pre>
  # try {
  # begin();
  # // Perform blocking I/O operation here
  # ...
  # } finally {
  # end();
  # }</pre></blockquote>
  # 
  # <p> This class also defines methods for maintaining a selector's
  # cancelled-key set and for removing a key from its channel's key set, and
  # declares the abstract {@link #register register} method that is invoked by a
  # selectable channel's {@link AbstractSelectableChannel#register register}
  # method in order to perform the actual work of registering a channel.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class AbstractSelector < AbstractSelectorImports.const_get :Selector
    include_class_members AbstractSelectorImports
    
    attr_accessor :selector_open
    alias_method :attr_selector_open, :selector_open
    undef_method :selector_open
    alias_method :attr_selector_open=, :selector_open=
    undef_method :selector_open=
    
    # The provider that created this selector
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    typesig { [SelectorProvider] }
    # Initializes a new instance of this class.  </p>
    def initialize(provider)
      @selector_open = nil
      @provider = nil
      @cancelled_keys = nil
      @interruptor = nil
      super()
      @selector_open = AtomicBoolean.new(true)
      @cancelled_keys = HashSet.new
      @interruptor = nil
      @provider = provider
    end
    
    attr_accessor :cancelled_keys
    alias_method :attr_cancelled_keys, :cancelled_keys
    undef_method :cancelled_keys
    alias_method :attr_cancelled_keys=, :cancelled_keys=
    undef_method :cancelled_keys=
    
    typesig { [SelectionKey] }
    def cancel(k)
      # package-private
      synchronized((@cancelled_keys)) do
        @cancelled_keys.add(k)
      end
    end
    
    typesig { [] }
    # Closes this selector.
    # 
    # <p> If the selector has already been closed then this method returns
    # immediately.  Otherwise it marks the selector as closed and then invokes
    # the {@link #implCloseSelector implCloseSelector} method in order to
    # complete the close operation.  </p>
    # 
    # @throws  IOException
    # If an I/O error occurs
    def close
      open = @selector_open.get_and_set(false)
      if (!open)
        return
      end
      impl_close_selector
    end
    
    typesig { [] }
    # Closes this selector.
    # 
    # <p> This method is invoked by the {@link #close close} method in order
    # to perform the actual work of closing the selector.  This method is only
    # invoked if the selector has not yet been closed, and it is never invoked
    # more than once.
    # 
    # <p> An implementation of this method must arrange for any other thread
    # that is blocked in a selection operation upon this selector to return
    # immediately as if by invoking the {@link
    # java.nio.channels.Selector#wakeup wakeup} method. </p>
    # 
    # @throws  IOException
    # If an I/O error occurs while closing the selector
    def impl_close_selector
      raise NotImplementedError
    end
    
    typesig { [] }
    def is_open
      return @selector_open.get
    end
    
    typesig { [] }
    # Returns the provider that created this channel.
    # 
    # @return  The provider that created this channel
    def provider
      return @provider
    end
    
    typesig { [] }
    # Retrieves this selector's cancelled-key set.
    # 
    # <p> This set should only be used while synchronized upon it.  </p>
    # 
    # @return  The cancelled-key set
    def cancelled_keys
      return @cancelled_keys
    end
    
    typesig { [AbstractSelectableChannel, ::Java::Int, Object] }
    # Registers the given channel with this selector.
    # 
    # <p> This method is invoked by a channel's {@link
    # AbstractSelectableChannel#register register} method in order to perform
    # the actual work of registering the channel with this selector.  </p>
    # 
    # @param  ch
    # The channel to be registered
    # 
    # @param  ops
    # The initial interest set, which must be valid
    # 
    # @param  att
    # The initial attachment for the resulting key
    # 
    # @return  A new key representing the registration of the given channel
    # with this selector
    def register(ch, ops, att)
      raise NotImplementedError
    end
    
    typesig { [AbstractSelectionKey] }
    # Removes the given key from its channel's key set.
    # 
    # <p> This method must be invoked by the selector for each channel that it
    # deregisters.  </p>
    # 
    # @param  key
    # The selection key to be removed
    def deregister(key)
      (key.channel).remove_key(key)
    end
    
    # -- Interruption machinery --
    attr_accessor :interruptor
    alias_method :attr_interruptor, :interruptor
    undef_method :interruptor
    alias_method :attr_interruptor=, :interruptor=
    undef_method :interruptor=
    
    typesig { [] }
    # Marks the beginning of an I/O operation that might block indefinitely.
    # 
    # <p> This method should be invoked in tandem with the {@link #end end}
    # method, using a <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block as
    # shown <a href="#be">above</a>, in order to implement interruption for
    # this selector.
    # 
    # <p> Invoking this method arranges for the selector's {@link
    # Selector#wakeup wakeup} method to be invoked if a thread's {@link
    # Thread#interrupt interrupt} method is invoked while the thread is
    # blocked in an I/O operation upon the selector.  </p>
    def begin_
      if ((@interruptor).nil?)
        @interruptor = Class.new(Interruptible.class == Class ? Interruptible : Object) do
          extend LocalClass
          include_class_members AbstractSelector
          include Interruptible if Interruptible.class == Module
          
          typesig { [] }
          define_method :interrupt do
            @local_class_parent.wakeup
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      AbstractInterruptibleChannel.blocked_on(@interruptor)
      if (JavaThread.current_thread.is_interrupted)
        @interruptor.interrupt
      end
    end
    
    typesig { [] }
    # Marks the end of an I/O operation that might block indefinitely.
    # 
    # <p> This method should be invoked in tandem with the {@link #begin begin}
    # method, using a <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block as
    # shown <a href="#be">above</a>, in order to implement interruption for
    # this selector.  </p>
    def end_
      AbstractInterruptibleChannel.blocked_on(nil)
    end
    
    private
    alias_method :initialize__abstract_selector, :initialize
  end
  
end

require "rjava"

# Copyright 2001-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DevPollSelectorImplImports #:nodoc:
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
  
  # An implementation of Selector for Solaris.
  class DevPollSelectorImpl < DevPollSelectorImplImports.const_get :SelectorImpl
    include_class_members DevPollSelectorImplImports
    
    # File descriptors used for interrupt
    attr_accessor :fd0
    alias_method :attr_fd0, :fd0
    undef_method :fd0
    alias_method :attr_fd0=, :fd0=
    undef_method :fd0=
    
    attr_accessor :fd1
    alias_method :attr_fd1, :fd1
    undef_method :fd1
    alias_method :attr_fd1=, :fd1=
    undef_method :fd1=
    
    # The poll object
    attr_accessor :poll_wrapper
    alias_method :attr_poll_wrapper, :poll_wrapper
    undef_method :poll_wrapper
    alias_method :attr_poll_wrapper=, :poll_wrapper=
    undef_method :poll_wrapper=
    
    # The number of valid channels in this Selector's poll array
    attr_accessor :total_channels
    alias_method :attr_total_channels, :total_channels
    undef_method :total_channels
    alias_method :attr_total_channels=, :total_channels=
    undef_method :total_channels=
    
    # Maps from file descriptors to keys
    attr_accessor :fd_to_key
    alias_method :attr_fd_to_key, :fd_to_key
    undef_method :fd_to_key
    alias_method :attr_fd_to_key=, :fd_to_key=
    undef_method :fd_to_key=
    
    # True if this Selector has been closed
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    # Lock for interrupt triggering and clearing
    attr_accessor :interrupt_lock
    alias_method :attr_interrupt_lock, :interrupt_lock
    undef_method :interrupt_lock
    alias_method :attr_interrupt_lock=, :interrupt_lock=
    undef_method :interrupt_lock=
    
    attr_accessor :interrupt_triggered
    alias_method :attr_interrupt_triggered, :interrupt_triggered
    undef_method :interrupt_triggered
    alias_method :attr_interrupt_triggered=, :interrupt_triggered=
    undef_method :interrupt_triggered=
    
    typesig { [SelectorProvider] }
    # Package private constructor called by factory method in
    # the abstract superclass Selector.
    def initialize(sp)
      @fd0 = 0
      @fd1 = 0
      @poll_wrapper = nil
      @total_channels = 0
      @fd_to_key = nil
      @closed = false
      @interrupt_lock = nil
      @interrupt_triggered = false
      super(sp)
      @closed = false
      @interrupt_lock = Object.new
      @interrupt_triggered = false
      fdes = Array.typed(::Java::Int).new(2) { 0 }
      IOUtil.init_pipe(fdes, false)
      @fd0 = fdes[0]
      @fd1 = fdes[1]
      @poll_wrapper = DevPollArrayWrapper.new
      @poll_wrapper.init_interrupt(@fd0, @fd1)
      @fd_to_key = HashMap.new
      @total_channels = 1
    end
    
    typesig { [::Java::Long] }
    def do_select(timeout)
      if (@closed)
        raise ClosedSelectorException.new
      end
      process_deregister_queue
      begin
        begin_
        @poll_wrapper.poll(timeout)
      ensure
        end_
      end
      process_deregister_queue
      num_keys_updated = update_selected_keys
      if (@poll_wrapper.interrupted)
        # Clear the wakeup pipe
        @poll_wrapper.put_revent_ops(@poll_wrapper.interrupted_index, 0)
        synchronized((@interrupt_lock)) do
          @poll_wrapper.clear_interrupted
          IOUtil.drain(@fd0)
          @interrupt_triggered = false
        end
      end
      return num_keys_updated
    end
    
    typesig { [] }
    # Update the keys whose fd's have been selected by the devpoll
    # driver. Add the ready keys to the ready queue.
    def update_selected_keys
      entries = @poll_wrapper.attr_updated
      num_keys_updated = 0
      i = 0
      while i < entries
        next_fd = @poll_wrapper.get_descriptor(i)
        ski = @fd_to_key.get(next_fd)
        # ski is null in the case of an interrupt
        if (!(ski).nil?)
          r_ops = @poll_wrapper.get_revent_ops(i)
          if (self.attr_selected_keys.contains(ski))
            if (ski.attr_channel.translate_and_set_ready_ops(r_ops, ski))
              num_keys_updated += 1
            end
          else
            ski.attr_channel.translate_and_set_ready_ops(r_ops, ski)
            if (!((ski.nio_ready_ops & ski.nio_interest_ops)).equal?(0))
              self.attr_selected_keys.add(ski)
              num_keys_updated += 1
            end
          end
        end
        i += 1
      end
      return num_keys_updated
    end
    
    typesig { [] }
    def impl_close
      if (!@closed)
        @closed = true
        # prevent further wakeup
        synchronized((@interrupt_lock)) do
          @interrupt_triggered = true
        end
        FileDispatcher.close_int_fd(@fd0)
        FileDispatcher.close_int_fd(@fd1)
        if (!(@poll_wrapper).nil?)
          @poll_wrapper.release(@fd0)
          @poll_wrapper.close_dev_poll_fd
          @poll_wrapper = nil
          self.attr_selected_keys = nil
          # Deregister channels
          i = self.attr_keys.iterator
          while (i.has_next)
            ski = i.next_
            deregister(ski)
            selch = ski.channel
            if (!selch.is_open && !selch.is_registered)
              (selch).kill
            end
            i.remove
          end
          @total_channels = 0
        end
        @fd0 = -1
        @fd1 = -1
      end
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_register(ski)
      fd = IOUtil.fd_val(ski.attr_channel.get_fd)
      @fd_to_key.put(fd, ski)
      @total_channels += 1
      self.attr_keys.add(ski)
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_dereg(ski)
      i = ski.get_index
      raise AssertError if not ((i >= 0))
      fd = ski.attr_channel.get_fdval
      @fd_to_key.remove(fd)
      @poll_wrapper.release(fd)
      @total_channels -= 1
      ski.set_index(-1)
      self.attr_keys.remove(ski)
      self.attr_selected_keys.remove(ski)
      deregister(ski)
      selch = ski.channel
      if (!selch.is_open && !selch.is_registered)
        (selch).kill
      end
    end
    
    typesig { [SelectionKeyImpl, ::Java::Int] }
    def put_event_ops(sk, ops)
      fd = IOUtil.fd_val(sk.attr_channel.get_fd)
      @poll_wrapper.set_interest(fd, ops)
    end
    
    typesig { [] }
    def wakeup
      synchronized((@interrupt_lock)) do
        if (!@interrupt_triggered)
          @poll_wrapper.interrupt
          @interrupt_triggered = true
        end
      end
      return self
    end
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
      end
    }
    
    private
    alias_method :initialize__dev_poll_selector_impl, :initialize
  end
  
end

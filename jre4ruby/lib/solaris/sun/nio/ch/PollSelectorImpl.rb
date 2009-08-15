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
  module PollSelectorImplImports
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
  class PollSelectorImpl < PollSelectorImplImports.const_get :AbstractPollSelectorImpl
    include_class_members PollSelectorImplImports
    
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
      @interrupt_lock = nil
      @interrupt_triggered = false
      super(sp, 1, 1)
      @interrupt_lock = Object.new
      @interrupt_triggered = false
      fdes = Array.typed(::Java::Int).new(2) { 0 }
      IOUtil.init_pipe(fdes, false)
      @fd0 = fdes[0]
      @fd1 = fdes[1]
      self.attr_poll_wrapper = PollArrayWrapper.new(INIT_CAP)
      self.attr_poll_wrapper.init_interrupt(@fd0, @fd1)
      self.attr_channel_array = Array.typed(SelectionKeyImpl).new(INIT_CAP) { nil }
    end
    
    typesig { [::Java::Long] }
    def do_select(timeout)
      if ((self.attr_channel_array).nil?)
        raise ClosedSelectorException.new
      end
      process_deregister_queue
      begin
        begin_
        self.attr_poll_wrapper.poll(self.attr_total_channels, 0, timeout)
      ensure
        end_
      end
      process_deregister_queue
      num_keys_updated = update_selected_keys
      if (!(self.attr_poll_wrapper.get_revent_ops(0)).equal?(0))
        # Clear the wakeup pipe
        self.attr_poll_wrapper.put_revent_ops(0, 0)
        synchronized((@interrupt_lock)) do
          IOUtil.drain(@fd0)
          @interrupt_triggered = false
        end
      end
      return num_keys_updated
    end
    
    typesig { [] }
    def impl_close_interrupt
      # prevent further wakeup
      synchronized((@interrupt_lock)) do
        @interrupt_triggered = true
      end
      FileDispatcher.close_int_fd(@fd0)
      FileDispatcher.close_int_fd(@fd1)
      @fd0 = -1
      @fd1 = -1
      self.attr_poll_wrapper.release(0)
    end
    
    typesig { [] }
    def wakeup
      synchronized((@interrupt_lock)) do
        if (!@interrupt_triggered)
          self.attr_poll_wrapper.interrupt
          @interrupt_triggered = true
        end
      end
      return self
    end
    
    private
    alias_method :initialize__poll_selector_impl, :initialize
  end
  
end

require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module WindowsSelectorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Nio::Channels::Spi, :SelectorProvider
      include_const ::Java::Nio::Channels, :Selector
      include_const ::Java::Nio::Channels, :ClosedSelectorException
      include_const ::Java::Nio::Channels, :Pipe
      include_const ::Java::Nio::Channels, :SelectableChannel
      include_const ::Java::Nio::Channels, :SelectionKey
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
    }
  end
  
  # A multi-threaded implementation of Selector for Windows.
  # 
  # @author Konstantin Kladko
  # @author Mark Reinhold
  class WindowsSelectorImpl < WindowsSelectorImplImports.const_get :SelectorImpl
    include_class_members WindowsSelectorImplImports
    
    # Initial capacity of the poll array
    attr_accessor :init_cap
    alias_method :attr_init_cap, :init_cap
    undef_method :init_cap
    alias_method :attr_init_cap=, :init_cap=
    undef_method :init_cap=
    
    class_module.module_eval {
      # Maximum number of sockets for select().
      # Should be INIT_CAP times a power of 2
      const_set_lazy(:MAX_SELECTABLE_FDS) { 1024 }
      const_attr_reader  :MAX_SELECTABLE_FDS
    }
    
    # The list of SelectableChannels serviced by this Selector. Every mod
    # MAX_SELECTABLE_FDS entry is bogus, to align this array with the poll
    # array,  where the corresponding entry is occupied by the wakeupSocket
    attr_accessor :channel_array
    alias_method :attr_channel_array, :channel_array
    undef_method :channel_array
    alias_method :attr_channel_array=, :channel_array=
    undef_method :channel_array=
    
    # The global native poll array holds file decriptors and event masks
    attr_accessor :poll_wrapper
    alias_method :attr_poll_wrapper, :poll_wrapper
    undef_method :poll_wrapper
    alias_method :attr_poll_wrapper=, :poll_wrapper=
    undef_method :poll_wrapper=
    
    # The number of valid entries in  poll array, including entries occupied
    # by wakeup socket handle.
    attr_accessor :total_channels
    alias_method :attr_total_channels, :total_channels
    undef_method :total_channels
    alias_method :attr_total_channels=, :total_channels=
    undef_method :total_channels=
    
    # Number of helper threads needed for select. We need one thread per
    # each additional set of MAX_SELECTABLE_FDS - 1 channels.
    attr_accessor :threads_count
    alias_method :attr_threads_count, :threads_count
    undef_method :threads_count
    alias_method :attr_threads_count=, :threads_count=
    undef_method :threads_count=
    
    # A list of helper threads for select.
    attr_accessor :threads
    alias_method :attr_threads, :threads
    undef_method :threads
    alias_method :attr_threads=, :threads=
    undef_method :threads=
    
    # Pipe used as a wakeup object.
    attr_accessor :wakeup_pipe
    alias_method :attr_wakeup_pipe, :wakeup_pipe
    undef_method :wakeup_pipe
    alias_method :attr_wakeup_pipe=, :wakeup_pipe=
    undef_method :wakeup_pipe=
    
    # File descriptors corresponding to source and sink
    attr_accessor :wakeup_source_fd
    alias_method :attr_wakeup_source_fd, :wakeup_source_fd
    undef_method :wakeup_source_fd
    alias_method :attr_wakeup_source_fd=, :wakeup_source_fd=
    undef_method :wakeup_source_fd=
    
    attr_accessor :wakeup_sink_fd
    alias_method :attr_wakeup_sink_fd, :wakeup_sink_fd
    undef_method :wakeup_sink_fd
    alias_method :attr_wakeup_sink_fd=, :wakeup_sink_fd=
    undef_method :wakeup_sink_fd=
    
    class_module.module_eval {
      # Maps file descriptors to their indices in  pollArray
      const_set_lazy(:FdMap) { Class.new(HashMap) do
        include_class_members WindowsSelectorImpl
        
        typesig { [::Java::Int] }
        def get(desc)
          return get(desc)
        end
        
        typesig { [class_self::SelectionKeyImpl] }
        def put(ski)
          return put(ski.attr_channel.get_fdval, self.class::MapEntry.new(ski))
        end
        
        typesig { [class_self::SelectionKeyImpl] }
        def remove(ski)
          fd = ski.attr_channel.get_fdval
          x = get(fd)
          if ((!(x).nil?) && ((x.attr_ski.attr_channel).equal?(ski.attr_channel)))
            return remove(fd)
          end
          return nil
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__fd_map, :initialize
      end }
      
      # class for fdMap entries
      const_set_lazy(:MapEntry) { Class.new do
        include_class_members WindowsSelectorImpl
        
        attr_accessor :ski
        alias_method :attr_ski, :ski
        undef_method :ski
        alias_method :attr_ski=, :ski=
        undef_method :ski=
        
        attr_accessor :update_count
        alias_method :attr_update_count, :update_count
        undef_method :update_count
        alias_method :attr_update_count=, :update_count=
        undef_method :update_count=
        
        attr_accessor :cleared_count
        alias_method :attr_cleared_count, :cleared_count
        undef_method :cleared_count
        alias_method :attr_cleared_count=, :cleared_count=
        undef_method :cleared_count=
        
        typesig { [class_self::SelectionKeyImpl] }
        def initialize(ski)
          @ski = nil
          @update_count = 0
          @cleared_count = 0
          @ski = ski
        end
        
        private
        alias_method :initialize__map_entry, :initialize
      end }
    }
    
    attr_accessor :fd_map
    alias_method :attr_fd_map, :fd_map
    undef_method :fd_map
    alias_method :attr_fd_map=, :fd_map=
    undef_method :fd_map=
    
    # SubSelector for the main thread
    attr_accessor :sub_selector
    alias_method :attr_sub_selector, :sub_selector
    undef_method :sub_selector
    alias_method :attr_sub_selector=, :sub_selector=
    undef_method :sub_selector=
    
    attr_accessor :timeout
    alias_method :attr_timeout, :timeout
    undef_method :timeout
    alias_method :attr_timeout=, :timeout=
    undef_method :timeout=
    
    # timeout for poll
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
    def initialize(sp)
      @init_cap = 0
      @channel_array = nil
      @poll_wrapper = nil
      @total_channels = 0
      @threads_count = 0
      @threads = nil
      @wakeup_pipe = nil
      @wakeup_source_fd = 0
      @wakeup_sink_fd = 0
      @fd_map = nil
      @sub_selector = nil
      @timeout = 0
      @interrupt_lock = nil
      @interrupt_triggered = false
      @start_lock = nil
      @finish_lock = nil
      @update_count = 0
      super(sp)
      @init_cap = 8
      @channel_array = Array.typed(SelectionKeyImpl).new(@init_cap) { nil }
      @total_channels = 1
      @threads_count = 0
      @threads = ArrayList.new
      @fd_map = FdMap.new
      @sub_selector = SubSelector.new_local(self)
      @interrupt_lock = Object.new
      @interrupt_triggered = false
      @start_lock = StartLock.new_local(self)
      @finish_lock = FinishLock.new_local(self)
      @update_count = 0
      @poll_wrapper = PollArrayWrapper.new(@init_cap)
      @wakeup_pipe = Pipe.open
      @wakeup_source_fd = (@wakeup_pipe.source).get_fdval
      # Disable the Nagle algorithm so that the wakeup is more immediate
      sink_ = @wakeup_pipe.sink
      (sink_.attr_sc).socket.set_tcp_no_delay(true)
      @wakeup_sink_fd = (sink_).get_fdval
      @poll_wrapper.add_wakeup_socket(@wakeup_source_fd, 0)
    end
    
    typesig { [::Java::Long] }
    def do_select(timeout)
      if ((@channel_array).nil?)
        raise ClosedSelectorException.new
      end
      @timeout = timeout # set selector timeout
      process_deregister_queue
      if (@interrupt_triggered)
        reset_wakeup_socket
        return 0
      end
      # Calculate number of helper threads needed for poll. If necessary
      # threads are created here and start waiting on startLock
      adjust_threads_count
      @finish_lock.reset # reset finishLock
      # Wakeup helper threads, waiting on startLock, so they start polling.
      # Redundant threads will exit here after wakeup.
      @start_lock.start_threads
      # do polling in the main thread. Main thread is responsible for
      # first MAX_SELECTABLE_FDS entries in pollArray.
      begin
        begin_
        begin
          @sub_selector.poll
        rescue IOException => e
          @finish_lock.set_exception(e) # Save this exception
        end
        # Main thread is out of poll(). Wakeup others and wait for them
        if (@threads.size > 0)
          @finish_lock.wait_for_helper_threads
        end
      ensure
        end_
      end
      # Done with poll(). Set wakeupSocket to nonsignaled  for the next run.
      @finish_lock.check_for_exception
      process_deregister_queue
      updated = update_selected_keys
      # Done with poll(). Set wakeupSocket to nonsignaled  for the next run.
      reset_wakeup_socket
      return updated
    end
    
    # Helper threads wait on this lock for the next poll.
    attr_accessor :start_lock
    alias_method :attr_start_lock, :start_lock
    undef_method :start_lock
    alias_method :attr_start_lock=, :start_lock=
    undef_method :start_lock=
    
    class_module.module_eval {
      const_set_lazy(:StartLock) { Class.new do
        extend LocalClass
        include_class_members WindowsSelectorImpl
        
        # A variable which distinguishes the current run of doSelect from the
        # previous one. Incrementing runsCounter and notifying threads will
        # trigger another round of poll.
        attr_accessor :runs_counter
        alias_method :attr_runs_counter, :runs_counter
        undef_method :runs_counter
        alias_method :attr_runs_counter=, :runs_counter=
        undef_method :runs_counter=
        
        typesig { [] }
        # Triggers threads, waiting on this lock to start polling.
        def start_threads
          synchronized(self) do
            @runs_counter += 1 # next run
            notify_all
          end # wake up threads.
        end
        
        typesig { [class_self::SelectThread] }
        # This function is called by a helper thread to wait for the
        # next round of poll(). It also checks, if this thread became
        # redundant. If yes, it returns true, notifying the thread
        # that it should exit.
        def wait_for_start(thread)
          synchronized(self) do
            while (true)
              while ((@runs_counter).equal?(thread.attr_last_run))
                begin
                  self.attr_start_lock.wait
                rescue self.class::InterruptedException => e
                  JavaThread.current_thread.interrupt
                end
              end
              if (thread.attr_index >= self.attr_threads.size)
                # redundant thread
                return true # will cause run() to exit.
              else
                thread.attr_last_run = @runs_counter # update lastRun
                return false # will cause run() to poll.
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          @runs_counter = 0
        end
        
        private
        alias_method :initialize__start_lock, :initialize
      end }
    }
    
    # Main thread waits on this lock, until all helper threads are done
    # with poll().
    attr_accessor :finish_lock
    alias_method :attr_finish_lock, :finish_lock
    undef_method :finish_lock
    alias_method :attr_finish_lock=, :finish_lock=
    undef_method :finish_lock=
    
    class_module.module_eval {
      const_set_lazy(:FinishLock) { Class.new do
        extend LocalClass
        include_class_members WindowsSelectorImpl
        
        # Number of helper threads, that did not finish yet.
        attr_accessor :threads_to_finish
        alias_method :attr_threads_to_finish, :threads_to_finish
        undef_method :threads_to_finish
        alias_method :attr_threads_to_finish=, :threads_to_finish=
        undef_method :threads_to_finish=
        
        # IOException which occured during the last run.
        attr_accessor :exception
        alias_method :attr_exception, :exception
        undef_method :exception
        alias_method :attr_exception=, :exception=
        undef_method :exception=
        
        typesig { [] }
        # Called before polling.
        def reset
          @threads_to_finish = self.attr_threads.size # helper threads
        end
        
        typesig { [] }
        # Each helper thread invokes this function on finishLock, when
        # the thread is done with poll().
        def thread_finished
          synchronized(self) do
            if ((@threads_to_finish).equal?(self.attr_threads.size))
              # finished poll() first
              # if finished first, wakeup others
              wakeup
            end
            @threads_to_finish -= 1
            if ((@threads_to_finish).equal?(0))
              # all helper threads finished poll().
              notify
            end
          end # notify the main thread
        end
        
        typesig { [] }
        # The main thread invokes this function on finishLock to wait
        # for helper threads to finish poll().
        def wait_for_helper_threads
          synchronized(self) do
            if ((@threads_to_finish).equal?(self.attr_threads.size))
              # no helper threads finished yet. Wakeup them up.
              wakeup
            end
            while (!(@threads_to_finish).equal?(0))
              begin
                self.attr_finish_lock.wait
              rescue self.class::InterruptedException => e
                # Interrupted - set interrupted state.
                JavaThread.current_thread.interrupt
              end
            end
          end
        end
        
        typesig { [class_self::IOException] }
        # sets IOException for this run
        def set_exception(e)
          synchronized(self) do
            @exception = e
          end
        end
        
        typesig { [] }
        # Checks if there was any exception during the last run.
        # If yes, throws it
        def check_for_exception
          if ((@exception).nil?)
            return
          end
          message = self.class::StringBuffer.new("An exception occured" + " during the execution of select(): \n")
          message.append(@exception)
          message.append(Character.new(?\n.ord))
          @exception = nil
          raise self.class::IOException.new(message.to_s)
        end
        
        typesig { [] }
        def initialize
          @threads_to_finish = 0
          @exception = nil
        end
        
        private
        alias_method :initialize__finish_lock, :initialize
      end }
      
      const_set_lazy(:SubSelector) { Class.new do
        extend LocalClass
        include_class_members WindowsSelectorImpl
        
        attr_accessor :poll_array_index
        alias_method :attr_poll_array_index, :poll_array_index
        undef_method :poll_array_index
        alias_method :attr_poll_array_index=, :poll_array_index=
        undef_method :poll_array_index=
        
        # starting index in pollArray to poll
        # These arrays will hold result of native select().
        # The first element of each array is the number of selected sockets.
        # Other elements are file descriptors of selected sockets.
        attr_accessor :read_fds
        alias_method :attr_read_fds, :read_fds
        undef_method :read_fds
        alias_method :attr_read_fds=, :read_fds=
        undef_method :read_fds=
        
        attr_accessor :write_fds
        alias_method :attr_write_fds, :write_fds
        undef_method :write_fds
        alias_method :attr_write_fds=, :write_fds=
        undef_method :write_fds=
        
        attr_accessor :except_fds
        alias_method :attr_except_fds, :except_fds
        undef_method :except_fds
        alias_method :attr_except_fds=, :except_fds=
        undef_method :except_fds=
        
        typesig { [] }
        def initialize
          @poll_array_index = 0
          @read_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 }
          @write_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 }
          @except_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 }
          @poll_array_index = 0 # main thread
        end
        
        typesig { [::Java::Int] }
        def initialize(thread_index)
          @poll_array_index = 0
          @read_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 }
          @write_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 }
          @except_fds = Array.typed(::Java::Int).new(MAX_SELECTABLE_FDS + 1) { 0 } # helper threads
          @poll_array_index = (thread_index + 1) * MAX_SELECTABLE_FDS
        end
        
        typesig { [] }
        def poll
          # poll for the main thread
          return poll0(self.attr_poll_wrapper.attr_poll_array_address, Math.min(self.attr_total_channels, MAX_SELECTABLE_FDS), @read_fds, @write_fds, @except_fds, self.attr_timeout)
        end
        
        typesig { [::Java::Int] }
        def poll(index)
          # poll for helper threads
          return poll0(self.attr_poll_wrapper.attr_poll_array_address + (@poll_array_index * PollArrayWrapper::SIZE_POLLFD), Math.min(MAX_SELECTABLE_FDS, self.attr_total_channels - (index + 1) * MAX_SELECTABLE_FDS), @read_fds, @write_fds, @except_fds, self.attr_timeout)
        end
        
        JNI.native_method :Java_sun_nio_ch_SubSelector_poll0, [:pointer, :long, :int64, :int32, :long, :long, :long, :int64], :int32
        typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Int), Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Long] }
        def poll0(poll_address, numfds, read_fds, write_fds, except_fds, timeout)
          JNI.__send__(:Java_sun_nio_ch_SubSelector_poll0, JNI.env, self.jni_id, poll_address.to_int, numfds.to_int, read_fds.jni_id, write_fds.jni_id, except_fds.jni_id, timeout.to_int)
        end
        
        typesig { [::Java::Long] }
        def process_selected_keys(update_count)
          num_keys_updated = 0
          num_keys_updated += process_fdset(update_count, @read_fds, PollArrayWrapper::POLLIN)
          num_keys_updated += process_fdset(update_count, @write_fds, PollArrayWrapper::POLLCONN | PollArrayWrapper::POLLOUT)
          num_keys_updated += process_fdset(update_count, @except_fds, PollArrayWrapper::POLLIN | PollArrayWrapper::POLLCONN | PollArrayWrapper::POLLOUT)
          return num_keys_updated
        end
        
        typesig { [::Java::Long, Array.typed(::Java::Int), ::Java::Int] }
        # Note, clearedCount is used to determine if the readyOps have
        # been reset in this select operation. updateCount is used to
        # tell if a key has been counted as updated in this select
        # operation.
        # 
        # me.updateCount <= me.clearedCount <= updateCount
        def process_fdset(update_count, fds, r_ops)
          num_keys_updated = 0
          i = 1
          while i <= fds[0]
            desc = fds[i]
            if ((desc).equal?(self.attr_wakeup_source_fd))
              synchronized((self.attr_interrupt_lock)) do
                self.attr_interrupt_triggered = true
              end
              i += 1
              next
            end
            me = self.attr_fd_map.get(desc)
            # If me is null, the key was deregistered in the previous
            # processDeregisterQueue.
            if ((me).nil?)
              i += 1
              next
            end
            sk = me.attr_ski
            if (self.attr_selected_keys.contains(sk))
              # Key in selected set
              if (!(me.attr_cleared_count).equal?(update_count))
                if (sk.attr_channel.translate_and_set_ready_ops(r_ops, sk) && (!(me.attr_update_count).equal?(update_count)))
                  me.attr_update_count = update_count
                  num_keys_updated += 1
                end
              else
                # The readyOps have been set; now add
                if (sk.attr_channel.translate_and_update_ready_ops(r_ops, sk) && (!(me.attr_update_count).equal?(update_count)))
                  me.attr_update_count = update_count
                  num_keys_updated += 1
                end
              end
              me.attr_cleared_count = update_count
            else
              # Key is not in selected set yet
              if (!(me.attr_cleared_count).equal?(update_count))
                sk.attr_channel.translate_and_set_ready_ops(r_ops, sk)
                if (!((sk.nio_ready_ops & sk.nio_interest_ops)).equal?(0))
                  self.attr_selected_keys.add(sk)
                  me.attr_update_count = update_count
                  num_keys_updated += 1
                end
              else
                # The readyOps have been set; now add
                sk.attr_channel.translate_and_update_ready_ops(r_ops, sk)
                if (!((sk.nio_ready_ops & sk.nio_interest_ops)).equal?(0))
                  self.attr_selected_keys.add(sk)
                  me.attr_update_count = update_count
                  num_keys_updated += 1
                end
              end
              me.attr_cleared_count = update_count
            end
            i += 1
          end
          return num_keys_updated
        end
        
        private
        alias_method :initialize__sub_selector, :initialize
      end }
      
      # Represents a helper thread used for select.
      const_set_lazy(:SelectThread) { Class.new(JavaThread) do
        extend LocalClass
        include_class_members WindowsSelectorImpl
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        # index of this thread
        attr_accessor :sub_selector
        alias_method :attr_sub_selector, :sub_selector
        undef_method :sub_selector
        alias_method :attr_sub_selector=, :sub_selector=
        undef_method :sub_selector=
        
        attr_accessor :last_run
        alias_method :attr_last_run, :last_run
        undef_method :last_run
        alias_method :attr_last_run=, :last_run=
        undef_method :last_run=
        
        typesig { [::Java::Int] }
        # last run number
        # Creates a new thread
        def initialize(i)
          @index = 0
          @sub_selector = nil
          @last_run = 0
          super()
          @last_run = 0
          @index = i
          @sub_selector = self.class::SubSelector.new(i)
          # make sure we wait for next round of poll
          @last_run = self.attr_start_lock.attr_runs_counter
        end
        
        typesig { [] }
        def run
          while (true)
            # poll loop
            # wait for the start of poll. If this thread has become
            # redundant, then exit.
            if (self.attr_start_lock.wait_for_start(self))
              return
            end
            # call poll()
            begin
              @sub_selector.poll(@index)
            rescue self.class::IOException => e
              # Save this exception and let other threads finish.
              self.attr_finish_lock.set_exception(e)
            end
            # notify main thread, that this thread has finished, and
            # wakeup others, if this thread is the first to finish.
            self.attr_finish_lock.thread_finished
          end
        end
        
        private
        alias_method :initialize__select_thread, :initialize
      end }
    }
    
    typesig { [] }
    # After some channels registered/deregistered, the number of required
    # helper threads may have changed. Adjust this number.
    def adjust_threads_count
      if (@threads_count > @threads.size)
        # More threads needed. Start more threads.
        i = @threads.size
        while i < @threads_count
          new_thread = SelectThread.new_local(self, i)
          @threads.add(new_thread)
          new_thread.set_daemon(true)
          new_thread.start
          i += 1
        end
      else
        if (@threads_count < @threads.size)
          # Some threads become redundant. Remove them from the threads List.
          i = @threads.size - 1
          while i >= @threads_count
            @threads.remove(i)
            i -= 1
          end
        end
      end
    end
    
    typesig { [] }
    # Sets Windows wakeup socket to a signaled state.
    def set_wakeup_socket
      set_wakeup_socket0(@wakeup_sink_fd)
    end
    
    JNI.native_method :Java_sun_nio_ch_WindowsSelectorImpl_setWakeupSocket0, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def set_wakeup_socket0(wakeup_sink_fd)
      JNI.__send__(:Java_sun_nio_ch_WindowsSelectorImpl_setWakeupSocket0, JNI.env, self.jni_id, wakeup_sink_fd.to_int)
    end
    
    typesig { [] }
    # Sets Windows wakeup socket to a non-signaled state.
    def reset_wakeup_socket
      synchronized((@interrupt_lock)) do
        if ((@interrupt_triggered).equal?(false))
          return
        end
        reset_wakeup_socket0(@wakeup_source_fd)
        @interrupt_triggered = false
      end
    end
    
    JNI.native_method :Java_sun_nio_ch_WindowsSelectorImpl_resetWakeupSocket0, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    def reset_wakeup_socket0(wakeup_source_fd)
      JNI.__send__(:Java_sun_nio_ch_WindowsSelectorImpl_resetWakeupSocket0, JNI.env, self.jni_id, wakeup_source_fd.to_int)
    end
    
    # We increment this counter on each call to updateSelectedKeys()
    # each entry in  SubSelector.fdsMap has a memorized value of
    # updateCount. When we increment numKeysUpdated we set updateCount
    # for the corresponding entry to its current value. This is used to
    # avoid counting the same key more than once - the same key can
    # appear in readfds and writefds.
    attr_accessor :update_count
    alias_method :attr_update_count, :update_count
    undef_method :update_count
    alias_method :attr_update_count=, :update_count=
    undef_method :update_count=
    
    typesig { [] }
    # Update ops of the corresponding Channels. Add the ready keys to the
    # ready queue.
    def update_selected_keys
      @update_count += 1
      num_keys_updated = 0
      num_keys_updated += @sub_selector.process_selected_keys(@update_count)
      it = @threads.iterator
      while (it.has_next)
        num_keys_updated += (it.next_).attr_sub_selector.process_selected_keys(@update_count)
      end
      return num_keys_updated
    end
    
    typesig { [] }
    def impl_close
      if (!(@channel_array).nil?)
        if (!(@poll_wrapper).nil?)
          # prevent further wakeup
          synchronized((@interrupt_lock)) do
            @interrupt_triggered = true
          end
          @wakeup_pipe.sink.close
          @wakeup_pipe.source.close
          i = 1
          while i < @total_channels
            # Deregister channels
            if (!(i % MAX_SELECTABLE_FDS).equal?(0))
              # skip wakeupEvent
              deregister(@channel_array[i])
              selch = @channel_array[i].channel
              if (!selch.is_open && !selch.is_registered)
                (selch).kill
              end
            end
            i += 1
          end
          @poll_wrapper.free
          @poll_wrapper = nil
          self.attr_selected_keys = nil
          @channel_array = nil
          @threads.clear
          # Call startThreads. All remaining helper threads now exit,
          # since threads.size() = 0;
          @start_lock.start_threads
        end
      end
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_register(ski)
      grow_if_needed
      @channel_array[@total_channels] = ski
      ski.set_index(@total_channels)
      @fd_map.put(ski)
      self.attr_keys.add(ski)
      @poll_wrapper.add_entry(@total_channels, ski)
      @total_channels += 1
    end
    
    typesig { [] }
    def grow_if_needed
      if ((@channel_array.attr_length).equal?(@total_channels))
        new_size = @total_channels * 2 # Make a larger array
        temp = Array.typed(SelectionKeyImpl).new(new_size) { nil }
        System.arraycopy(@channel_array, 1, temp, 1, @total_channels - 1)
        @channel_array = temp
        @poll_wrapper.grow(new_size)
      end
      if ((@total_channels % MAX_SELECTABLE_FDS).equal?(0))
        # more threads needed
        @poll_wrapper.add_wakeup_socket(@wakeup_source_fd, @total_channels)
        @total_channels += 1
        @threads_count += 1
      end
    end
    
    typesig { [SelectionKeyImpl] }
    def impl_dereg(ski)
      i = ski.get_index
      raise AssertError if not ((i >= 0))
      if (!(i).equal?(@total_channels - 1))
        # Copy end one over it
        end_channel = @channel_array[@total_channels - 1]
        @channel_array[i] = end_channel
        end_channel.set_index(i)
        @poll_wrapper.replace_entry(@poll_wrapper, @total_channels - 1, @poll_wrapper, i)
      end
      @channel_array[@total_channels - 1] = nil
      @total_channels -= 1
      ski.set_index(-1)
      if (!(@total_channels).equal?(1) && (@total_channels % MAX_SELECTABLE_FDS).equal?(1))
        @total_channels -= 1
        @threads_count -= 1 # The last thread has become redundant.
      end
      @fd_map.remove(ski) # Remove the key from fdMap, keys and selectedKeys
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
      @poll_wrapper.put_event_ops(sk.get_index, ops)
    end
    
    typesig { [] }
    def wakeup
      synchronized((@interrupt_lock)) do
        if (!@interrupt_triggered)
          set_wakeup_socket
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
    alias_method :initialize__windows_selector_impl, :initialize
  end
  
end

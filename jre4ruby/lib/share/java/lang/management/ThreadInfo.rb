require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Management
  module ThreadInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
      include_const ::Javax::Management::Openmbean, :CompositeData
      include_const ::Sun::Management, :ThreadInfoCompositeData
    }
  end
  
  # Thread information. <tt>ThreadInfo</tt> contains the information
  # about a thread including:
  # <h4>General thread information</h4>
  # <ul>
  #   <li>Thread ID.</li>
  #   <li>Name of the thread.</li>
  # </ul>
  # 
  # <h4>Execution information</h4>
  # <ul>
  #   <li>Thread state.</li>
  #   <li>The object upon which the thread is blocked due to:
  #       <ul>
  #       <li>waiting to enter a synchronization block/method, or</li>
  #       <li>waiting to be notified in a {@link Object#wait Object.wait} method,
  #           or</li>
  #       <li>parking due to a {@link java.util.concurrent.locks.LockSupport#park
  #           LockSupport.park} call.</li>
  #       </ul>
  #   </li>
  #   <li>The ID of the thread that owns the object
  #       that the thread is blocked.</li>
  #   <li>Stack trace of the thread.</li>
  #   <li>List of object monitors locked by the thread.</li>
  #   <li>List of <a href="LockInfo.html#OwnableSynchronizer">
  #       ownable synchronizers</a> locked by the thread.</li>
  # </ul>
  # 
  # <h4><a name="SyncStats">Synchronization Statistics</a></h4>
  # <ul>
  #   <li>The number of times that the thread has blocked for
  #       synchronization or waited for notification.</li>
  #   <li>The accumulated elapsed time that the thread has blocked
  #       for synchronization or waited for notification
  #       since {@link ThreadMXBean#setThreadContentionMonitoringEnabled
  #       thread contention monitoring}
  #       was enabled. Some Java virtual machine implementation
  #       may not support this.  The
  #       {@link ThreadMXBean#isThreadContentionMonitoringSupported()}
  #       method can be used to determine if a Java virtual machine
  #       supports this.</li>
  # </ul>
  # 
  # <p>This thread information class is designed for use in monitoring of
  # the system, not for synchronization control.
  # 
  # <h4>MXBean Mapping</h4>
  # <tt>ThreadInfo</tt> is mapped to a {@link CompositeData CompositeData}
  # with attributes as specified in
  # the {@link #from from} method.
  # 
  # @see ThreadMXBean#getThreadInfo
  # @see ThreadMXBean#dumpAllThreads
  # 
  # @author  Mandy Chung
  # @since   1.5
  class ThreadInfo 
    include_class_members ThreadInfoImports
    
    attr_accessor :thread_name
    alias_method :attr_thread_name, :thread_name
    undef_method :thread_name
    alias_method :attr_thread_name=, :thread_name=
    undef_method :thread_name=
    
    attr_accessor :thread_id
    alias_method :attr_thread_id, :thread_id
    undef_method :thread_id
    alias_method :attr_thread_id=, :thread_id=
    undef_method :thread_id=
    
    attr_accessor :blocked_time
    alias_method :attr_blocked_time, :blocked_time
    undef_method :blocked_time
    alias_method :attr_blocked_time=, :blocked_time=
    undef_method :blocked_time=
    
    attr_accessor :blocked_count
    alias_method :attr_blocked_count, :blocked_count
    undef_method :blocked_count
    alias_method :attr_blocked_count=, :blocked_count=
    undef_method :blocked_count=
    
    attr_accessor :waited_time
    alias_method :attr_waited_time, :waited_time
    undef_method :waited_time
    alias_method :attr_waited_time=, :waited_time=
    undef_method :waited_time=
    
    attr_accessor :waited_count
    alias_method :attr_waited_count, :waited_count
    undef_method :waited_count
    alias_method :attr_waited_count=, :waited_count=
    undef_method :waited_count=
    
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    attr_accessor :lock_name
    alias_method :attr_lock_name, :lock_name
    undef_method :lock_name
    alias_method :attr_lock_name=, :lock_name=
    undef_method :lock_name=
    
    attr_accessor :lock_owner_id
    alias_method :attr_lock_owner_id, :lock_owner_id
    undef_method :lock_owner_id
    alias_method :attr_lock_owner_id=, :lock_owner_id=
    undef_method :lock_owner_id=
    
    attr_accessor :lock_owner_name
    alias_method :attr_lock_owner_name, :lock_owner_name
    undef_method :lock_owner_name
    alias_method :attr_lock_owner_name=, :lock_owner_name=
    undef_method :lock_owner_name=
    
    attr_accessor :in_native
    alias_method :attr_in_native, :in_native
    undef_method :in_native
    alias_method :attr_in_native=, :in_native=
    undef_method :in_native=
    
    attr_accessor :suspended
    alias_method :attr_suspended, :suspended
    undef_method :suspended
    alias_method :attr_suspended=, :suspended=
    undef_method :suspended=
    
    attr_accessor :thread_state
    alias_method :attr_thread_state, :thread_state
    undef_method :thread_state
    alias_method :attr_thread_state=, :thread_state=
    undef_method :thread_state=
    
    attr_accessor :stack_trace
    alias_method :attr_stack_trace, :stack_trace
    undef_method :stack_trace
    alias_method :attr_stack_trace=, :stack_trace=
    undef_method :stack_trace=
    
    attr_accessor :locked_monitors
    alias_method :attr_locked_monitors, :locked_monitors
    undef_method :locked_monitors
    alias_method :attr_locked_monitors=, :locked_monitors=
    undef_method :locked_monitors=
    
    attr_accessor :locked_synchronizers
    alias_method :attr_locked_synchronizers, :locked_synchronizers
    undef_method :locked_synchronizers
    alias_method :attr_locked_synchronizers=, :locked_synchronizers=
    undef_method :locked_synchronizers=
    
    class_module.module_eval {
      
      def empty_monitors
        defined?(@@empty_monitors) ? @@empty_monitors : @@empty_monitors= Array.typed(MonitorInfo).new(0) { nil }
      end
      alias_method :attr_empty_monitors, :empty_monitors
      
      def empty_monitors=(value)
        @@empty_monitors = value
      end
      alias_method :attr_empty_monitors=, :empty_monitors=
      
      
      def empty_syncs
        defined?(@@empty_syncs) ? @@empty_syncs : @@empty_syncs= Array.typed(LockInfo).new(0) { nil }
      end
      alias_method :attr_empty_syncs, :empty_syncs
      
      def empty_syncs=(value)
        @@empty_syncs = value
      end
      alias_method :attr_empty_syncs=, :empty_syncs=
    }
    
    typesig { [JavaThread, ::Java::Int, Object, JavaThread, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, Array.typed(StackTraceElement)] }
    # Constructor of ThreadInfo created by the JVM
    # 
    # @param t             Thread
    # @param state         Thread state
    # @param lockObj       Object on which the thread is blocked
    # @param lockOwner     the thread holding the lock
    # @param blockedCount  Number of times blocked to enter a lock
    # @param blockedTime   Approx time blocked to enter a lock
    # @param waitedCount   Number of times waited on a lock
    # @param waitedTime    Approx time waited on a lock
    # @param stackTrace    Thread stack trace
    def initialize(t, state, lock_obj, lock_owner, blocked_count, blocked_time, waited_count, waited_time, stack_trace)
      @thread_name = nil
      @thread_id = 0
      @blocked_time = 0
      @blocked_count = 0
      @waited_time = 0
      @waited_count = 0
      @lock = nil
      @lock_name = nil
      @lock_owner_id = 0
      @lock_owner_name = nil
      @in_native = false
      @suspended = false
      @thread_state = nil
      @stack_trace = nil
      @locked_monitors = nil
      @locked_synchronizers = nil
      initialize_(t, state, lock_obj, lock_owner, blocked_count, blocked_time, waited_count, waited_time, stack_trace, self.attr_empty_monitors, self.attr_empty_syncs)
    end
    
    typesig { [JavaThread, ::Java::Int, Object, JavaThread, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, Array.typed(StackTraceElement), Array.typed(Object), Array.typed(::Java::Int), Array.typed(Object)] }
    # Constructor of ThreadInfo created by the JVM
    # for {@link ThreadMXBean#getThreadInfo(long[],boolean,boolean)}
    # and {@link ThreadMXBean#dumpAllThreads}
    # 
    # @param t             Thread
    # @param state         Thread state
    # @param lockObj       Object on which the thread is blocked
    # @param lockOwner     the thread holding the lock
    # @param blockedCount  Number of times blocked to enter a lock
    # @param blockedTime   Approx time blocked to enter a lock
    # @param waitedCount   Number of times waited on a lock
    # @param waitedTime    Approx time waited on a lock
    # @param stackTrace    Thread stack trace
    # @param lockedMonitors List of locked monitors
    # @param lockedSynchronizers List of locked synchronizers
    def initialize(t, state, lock_obj, lock_owner, blocked_count, blocked_time, waited_count, waited_time, stack_trace, monitors, stack_depths, synchronizers)
      @thread_name = nil
      @thread_id = 0
      @blocked_time = 0
      @blocked_count = 0
      @waited_time = 0
      @waited_count = 0
      @lock = nil
      @lock_name = nil
      @lock_owner_id = 0
      @lock_owner_name = nil
      @in_native = false
      @suspended = false
      @thread_state = nil
      @stack_trace = nil
      @locked_monitors = nil
      @locked_synchronizers = nil
      num_monitors = ((monitors).nil? ? 0 : monitors.attr_length)
      locked_monitors = nil
      if ((num_monitors).equal?(0))
        locked_monitors = self.attr_empty_monitors
      else
        locked_monitors = Array.typed(MonitorInfo).new(num_monitors) { nil }
        i = 0
        while i < num_monitors
          lock = monitors[i]
          class_name = lock.get_class.get_name
          identity_hash_code_ = System.identity_hash_code(lock)
          depth = stack_depths[i]
          ste = (depth >= 0 ? stack_trace[depth] : nil)
          locked_monitors[i] = MonitorInfo.new(class_name, identity_hash_code_, depth, ste)
          i += 1
        end
      end
      num_syncs = ((synchronizers).nil? ? 0 : synchronizers.attr_length)
      locked_synchronizers = nil
      if ((num_syncs).equal?(0))
        locked_synchronizers = self.attr_empty_syncs
      else
        locked_synchronizers = Array.typed(LockInfo).new(num_syncs) { nil }
        i = 0
        while i < num_syncs
          lock = synchronizers[i]
          class_name = lock.get_class.get_name
          identity_hash_code_ = System.identity_hash_code(lock)
          locked_synchronizers[i] = LockInfo.new(class_name, identity_hash_code_)
          i += 1
        end
      end
      initialize_(t, state, lock_obj, lock_owner, blocked_count, blocked_time, waited_count, waited_time, stack_trace, locked_monitors, locked_synchronizers)
    end
    
    typesig { [JavaThread, ::Java::Int, Object, JavaThread, ::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long, Array.typed(StackTraceElement), Array.typed(MonitorInfo), Array.typed(LockInfo)] }
    # Initialize ThreadInfo object
    # 
    # @param t             Thread
    # @param state         Thread state
    # @param lockObj       Object on which the thread is blocked
    # @param lockOwner     the thread holding the lock
    # @param blockedCount  Number of times blocked to enter a lock
    # @param blockedTime   Approx time blocked to enter a lock
    # @param waitedCount   Number of times waited on a lock
    # @param waitedTime    Approx time waited on a lock
    # @param stackTrace    Thread stack trace
    # @param lockedMonitors List of locked monitors
    # @param lockedSynchronizers List of locked synchronizers
    def initialize_(t, state, lock_obj, lock_owner, blocked_count, blocked_time, waited_count, waited_time, stack_trace, locked_monitors, locked_synchronizers)
      @thread_id = t.get_id
      @thread_name = t.get_name
      @thread_state = Sun::Management::ManagementFactory.to_thread_state(state)
      @suspended = Sun::Management::ManagementFactory.is_thread_suspended(state)
      @in_native = Sun::Management::ManagementFactory.is_thread_running_native(state)
      @blocked_count = blocked_count
      @blocked_time = blocked_time
      @waited_count = waited_count
      @waited_time = waited_time
      if ((lock_obj).nil?)
        @lock = nil
        @lock_name = nil
      else
        @lock = LockInfo.new(lock_obj)
        @lock_name = @lock.get_class_name + Character.new(?@.ord) + JavaInteger.to_hex_string(@lock.get_identity_hash_code)
      end
      if ((lock_owner).nil?)
        @lock_owner_id = -1
        @lock_owner_name = nil
      else
        @lock_owner_id = lock_owner.get_id
        @lock_owner_name = lock_owner.get_name
      end
      if ((stack_trace).nil?)
        @stack_trace = NO_STACK_TRACE
      else
        @stack_trace = stack_trace
      end
      @locked_monitors = locked_monitors
      @locked_synchronizers = locked_synchronizers
    end
    
    typesig { [CompositeData] }
    # Constructs a <tt>ThreadInfo</tt> object from a
    # {@link CompositeData CompositeData}.
    def initialize(cd)
      @thread_name = nil
      @thread_id = 0
      @blocked_time = 0
      @blocked_count = 0
      @waited_time = 0
      @waited_count = 0
      @lock = nil
      @lock_name = nil
      @lock_owner_id = 0
      @lock_owner_name = nil
      @in_native = false
      @suspended = false
      @thread_state = nil
      @stack_trace = nil
      @locked_monitors = nil
      @locked_synchronizers = nil
      ticd = ThreadInfoCompositeData.get_instance(cd)
      @thread_id = ticd.thread_id
      @thread_name = RJava.cast_to_string(ticd.thread_name)
      @blocked_time = ticd.blocked_time
      @blocked_count = ticd.blocked_count
      @waited_time = ticd.waited_time
      @waited_count = ticd.waited_count
      @lock_name = RJava.cast_to_string(ticd.lock_name)
      @lock_owner_id = ticd.lock_owner_id
      @lock_owner_name = RJava.cast_to_string(ticd.lock_owner_name)
      @thread_state = ticd.thread_state
      @suspended = ticd.suspended
      @in_native = ticd.in_native
      @stack_trace = ticd.stack_trace
      # 6.0 attributes
      if (ticd.is_current_version)
        @lock = ticd.lock_info
        @locked_monitors = ticd.locked_monitors
        @locked_synchronizers = ticd.locked_synchronizers
      else
        # lockInfo is a new attribute added in 1.6 ThreadInfo
        # If cd is a 5.0 version, construct the LockInfo object
        #  from the lockName value.
        if (!(@lock_name).nil?)
          result = @lock_name.split(Regexp.new("@"))
          if ((result.attr_length).equal?(2))
            identity_hash_code_ = JavaInteger.parse_int(result[1], 16)
            @lock = LockInfo.new(result[0], identity_hash_code_)
          else
            raise AssertError if not ((result.attr_length).equal?(2))
            @lock = nil
          end
        else
          @lock = nil
        end
        @locked_monitors = self.attr_empty_monitors
        @locked_synchronizers = self.attr_empty_syncs
      end
    end
    
    typesig { [] }
    # Returns the ID of the thread associated with this <tt>ThreadInfo</tt>.
    # 
    # @return the ID of the associated thread.
    def get_thread_id
      return @thread_id
    end
    
    typesig { [] }
    # Returns the name of the thread associated with this <tt>ThreadInfo</tt>.
    # 
    # @return the name of the associated thread.
    def get_thread_name
      return @thread_name
    end
    
    typesig { [] }
    # Returns the state of the thread associated with this <tt>ThreadInfo</tt>.
    # 
    # @return <tt>Thread.State</tt> of the associated thread.
    def get_thread_state
      return @thread_state
    end
    
    typesig { [] }
    # Returns the approximate accumulated elapsed time (in milliseconds)
    # that the thread associated with this <tt>ThreadInfo</tt>
    # has blocked to enter or reenter a monitor
    # since thread contention monitoring is enabled.
    # I.e. the total accumulated time the thread has been in the
    # {@link java.lang.Thread.State#BLOCKED BLOCKED} state since thread
    # contention monitoring was last enabled.
    # This method returns <tt>-1</tt> if thread contention monitoring
    # is disabled.
    # 
    # <p>The Java virtual machine may measure the time with a high
    # resolution timer.  This statistic is reset when
    # the thread contention monitoring is reenabled.
    # 
    # @return the approximate accumulated elapsed time in milliseconds
    # that a thread entered the <tt>BLOCKED</tt> state;
    # <tt>-1</tt> if thread contention monitoring is disabled.
    # 
    # @throws java.lang.UnsupportedOperationException if the Java
    # virtual machine does not support this operation.
    # 
    # @see ThreadMXBean#isThreadContentionMonitoringSupported
    # @see ThreadMXBean#setThreadContentionMonitoringEnabled
    def get_blocked_time
      return @blocked_time
    end
    
    typesig { [] }
    # Returns the total number of times that
    # the thread associated with this <tt>ThreadInfo</tt>
    # blocked to enter or reenter a monitor.
    # I.e. the number of times a thread has been in the
    # {@link java.lang.Thread.State#BLOCKED BLOCKED} state.
    # 
    # @return the total number of times that the thread
    # entered the <tt>BLOCKED</tt> state.
    def get_blocked_count
      return @blocked_count
    end
    
    typesig { [] }
    # Returns the approximate accumulated elapsed time (in milliseconds)
    # that the thread associated with this <tt>ThreadInfo</tt>
    # has waited for notification
    # since thread contention monitoring is enabled.
    # I.e. the total accumulated time the thread has been in the
    # {@link java.lang.Thread.State#WAITING WAITING}
    # or {@link java.lang.Thread.State#TIMED_WAITING TIMED_WAITING} state
    # since thread contention monitoring is enabled.
    # This method returns <tt>-1</tt> if thread contention monitoring
    # is disabled.
    # 
    # <p>The Java virtual machine may measure the time with a high
    # resolution timer.  This statistic is reset when
    # the thread contention monitoring is reenabled.
    # 
    # @return the approximate accumulated elapsed time in milliseconds
    # that a thread has been in the <tt>WAITING</tt> or
    # <tt>TIMED_WAITING</tt> state;
    # <tt>-1</tt> if thread contention monitoring is disabled.
    # 
    # @throws java.lang.UnsupportedOperationException if the Java
    # virtual machine does not support this operation.
    # 
    # @see ThreadMXBean#isThreadContentionMonitoringSupported
    # @see ThreadMXBean#setThreadContentionMonitoringEnabled
    def get_waited_time
      return @waited_time
    end
    
    typesig { [] }
    # Returns the total number of times that
    # the thread associated with this <tt>ThreadInfo</tt>
    # waited for notification.
    # I.e. the number of times that a thread has been
    # in the {@link java.lang.Thread.State#WAITING WAITING}
    # or {@link java.lang.Thread.State#TIMED_WAITING TIMED_WAITING} state.
    # 
    # @return the total number of times that the thread
    # was in the <tt>WAITING</tt> or <tt>TIMED_WAITING</tt> state.
    def get_waited_count
      return @waited_count
    end
    
    typesig { [] }
    # Returns the <tt>LockInfo</tt> of an object for which
    # the thread associated with this <tt>ThreadInfo</tt>
    # is blocked waiting.
    # A thread can be blocked waiting for one of the following:
    # <ul>
    # <li>an object monitor to be acquired for entering or reentering
    #     a synchronization block/method.
    #     <br>The thread is in the {@link java.lang.Thread.State#BLOCKED BLOCKED}
    #     state waiting to enter the <tt>synchronized</tt> statement
    #     or method.
    #     <p></li>
    # <li>an object monitor to be notified by another thread.
    #     <br>The thread is in the {@link java.lang.Thread.State#WAITING WAITING}
    #     or {@link java.lang.Thread.State#TIMED_WAITING TIMED_WAITING} state
    #     due to a call to the {@link Object#wait Object.wait} method.
    #     <p></li>
    # <li>a synchronization object responsible for the thread parking.
    #     <br>The thread is in the {@link java.lang.Thread.State#WAITING WAITING}
    #     or {@link java.lang.Thread.State#TIMED_WAITING TIMED_WAITING} state
    #     due to a call to the
    #     {@link java.util.concurrent.locks.LockSupport#park(Object)
    #     LockSupport.park} method.  The synchronization object
    #     is the object returned from
    #     {@link java.util.concurrent.locks.LockSupport#getBlocker
    #     LockSupport.getBlocker} method. Typically it is an
    #     <a href="LockInfo.html#OwnableSynchronizer"> ownable synchronizer</a>
    #     or a {@link java.util.concurrent.locks.Condition Condition}.</li>
    # </ul>
    # 
    # <p>This method returns <tt>null</tt> if the thread is not in any of
    # the above conditions.
    # 
    # @return <tt>LockInfo</tt> of an object for which the thread
    #         is blocked waiting if any; <tt>null</tt> otherwise.
    # @since 1.6
    def get_lock_info
      return @lock
    end
    
    typesig { [] }
    # Returns the {@link LockInfo#toString string representation}
    # of an object for which the thread associated with this
    # <tt>ThreadInfo</tt> is blocked waiting.
    # This method is equivalent to calling:
    # <blockquote>
    # <pre>
    # getLockInfo().toString()
    # </pre></blockquote>
    # 
    # <p>This method will return <tt>null</tt> if this thread is not blocked
    # waiting for any object or if the object is not owned by any thread.
    # 
    # @return the string representation of the object on which
    # the thread is blocked if any;
    # <tt>null</tt> otherwise.
    # 
    # @see #getLockInfo
    def get_lock_name
      return @lock_name
    end
    
    typesig { [] }
    # Returns the ID of the thread which owns the object
    # for which the thread associated with this <tt>ThreadInfo</tt>
    # is blocked waiting.
    # This method will return <tt>-1</tt> if this thread is not blocked
    # waiting for any object or if the object is not owned by any thread.
    # 
    # @return the thread ID of the owner thread of the object
    # this thread is blocked on;
    # <tt>-1</tt> if this thread is not blocked
    # or if the object lis not owned by any thread.
    # 
    # @see #getLockInfo
    def get_lock_owner_id
      return @lock_owner_id
    end
    
    typesig { [] }
    # Returns the name of the thread which owns the object
    # for which the thread associated with this <tt>ThreadInfo</tt>
    # is blocked waiting.
    # This method will return <tt>null</tt> if this thread is not blocked
    # waiting for any object or if the object is not owned by any thread.
    # 
    # @return the name of the thread that owns the object
    # this thread is blocked on;
    # <tt>null</tt> if this thread is not blocked
    # or if the object is not owned by any thread.
    # 
    # @see #getLockInfo
    def get_lock_owner_name
      return @lock_owner_name
    end
    
    typesig { [] }
    # Returns the stack trace of the thread
    # associated with this <tt>ThreadInfo</tt>.
    # If no stack trace was requested for this thread info, this method
    # will return a zero-length array.
    # If the returned array is of non-zero length then the first element of
    # the array represents the top of the stack, which is the most recent
    # method invocation in the sequence.  The last element of the array
    # represents the bottom of the stack, which is the least recent method
    # invocation in the sequence.
    # 
    # <p>Some Java virtual machines may, under some circumstances, omit one
    # or more stack frames from the stack trace.  In the extreme case,
    # a virtual machine that has no stack trace information concerning
    # the thread associated with this <tt>ThreadInfo</tt>
    # is permitted to return a zero-length array from this method.
    # 
    # @return an array of <tt>StackTraceElement</tt> objects of the thread.
    def get_stack_trace
      return @stack_trace
    end
    
    typesig { [] }
    # Tests if the thread associated with this <tt>ThreadInfo</tt>
    # is suspended.  This method returns <tt>true</tt> if
    # {@link Thread#suspend} has been called.
    # 
    # @return <tt>true</tt> if the thread is suspended;
    #         <tt>false</tt> otherwise.
    def is_suspended
      return @suspended
    end
    
    typesig { [] }
    # Tests if the thread associated with this <tt>ThreadInfo</tt>
    # is executing native code via the Java Native Interface (JNI).
    # The JNI native code does not include
    # the virtual machine support code or the compiled native
    # code generated by the virtual machine.
    # 
    # @return <tt>true</tt> if the thread is executing native code;
    #         <tt>false</tt> otherwise.
    def is_in_native
      return @in_native
    end
    
    typesig { [] }
    # Returns a string representation of this thread info.
    # The format of this string depends on the implementation.
    # The returned string will typically include
    # the {@linkplain #getThreadName thread name},
    # the {@linkplain #getThreadId thread ID},
    # its {@linkplain #getThreadState state},
    # and a {@linkplain #getStackTrace stack trace} if any.
    # 
    # @return a string representation of this thread info.
    def to_s
      sb = StringBuilder.new("\"" + RJava.cast_to_string(get_thread_name) + "\"" + " Id=" + RJava.cast_to_string(get_thread_id) + " " + RJava.cast_to_string(get_thread_state))
      if (!(get_lock_name).nil?)
        sb.append(" on " + RJava.cast_to_string(get_lock_name))
      end
      if (!(get_lock_owner_name).nil?)
        sb.append(" owned by \"" + RJava.cast_to_string(get_lock_owner_name) + "\" Id=" + RJava.cast_to_string(get_lock_owner_id))
      end
      if (is_suspended)
        sb.append(" (suspended)")
      end
      if (is_in_native)
        sb.append(" (in native)")
      end
      sb.append(Character.new(?\n.ord))
      i = 0
      while i < @stack_trace.attr_length && i < MAX_FRAMES
        ste = @stack_trace[i]
        sb.append("\tat " + RJava.cast_to_string(ste.to_s))
        sb.append(Character.new(?\n.ord))
        if ((i).equal?(0) && !(get_lock_info).nil?)
          ts = get_thread_state
          case (ts)
          when BLOCKED
            sb.append("\t-  blocked on " + RJava.cast_to_string(get_lock_info))
            sb.append(Character.new(?\n.ord))
          when WAITING
            sb.append("\t-  waiting on " + RJava.cast_to_string(get_lock_info))
            sb.append(Character.new(?\n.ord))
          when TIMED_WAITING
            sb.append("\t-  waiting on " + RJava.cast_to_string(get_lock_info))
            sb.append(Character.new(?\n.ord))
          else
          end
        end
        @locked_monitors.each do |mi|
          if ((mi.get_locked_stack_depth).equal?(i))
            sb.append("\t-  locked " + RJava.cast_to_string(mi))
            sb.append(Character.new(?\n.ord))
          end
        end
        i += 1
      end
      if (i < @stack_trace.attr_length)
        sb.append("\t...")
        sb.append(Character.new(?\n.ord))
      end
      locks = get_locked_synchronizers
      if (locks.attr_length > 0)
        sb.append("\n\tNumber of locked synchronizers = " + RJava.cast_to_string(locks.attr_length))
        sb.append(Character.new(?\n.ord))
        locks.each do |li|
          sb.append("\t- " + RJava.cast_to_string(li))
          sb.append(Character.new(?\n.ord))
        end
      end
      sb.append(Character.new(?\n.ord))
      return sb.to_s
    end
    
    class_module.module_eval {
      const_set_lazy(:MAX_FRAMES) { 8 }
      const_attr_reader  :MAX_FRAMES
      
      typesig { [CompositeData] }
      # Returns a <tt>ThreadInfo</tt> object represented by the
      # given <tt>CompositeData</tt>.
      # The given <tt>CompositeData</tt> must contain the following attributes
      # unless otherwise specified below:
      # <blockquote>
      # <table border>
      # <tr>
      #   <th align=left>Attribute Name</th>
      #   <th align=left>Type</th>
      # </tr>
      # <tr>
      #   <td>threadId</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>threadName</td>
      #   <td><tt>java.lang.String</tt></td>
      # </tr>
      # <tr>
      #   <td>threadState</td>
      #   <td><tt>java.lang.String</tt></td>
      # </tr>
      # <tr>
      #   <td>suspended</td>
      #   <td><tt>java.lang.Boolean</tt></td>
      # </tr>
      # <tr>
      #   <td>inNative</td>
      #   <td><tt>java.lang.Boolean</tt></td>
      # </tr>
      # <tr>
      #   <td>blockedCount</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>blockedTime</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>waitedCount</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>waitedTime</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>lockInfo</td>
      #   <td><tt>javax.management.openmbean.CompositeData</tt>
      #       - the mapped type for {@link LockInfo} as specified in the
      #       <a href="../../../javax/management/MXBean.html#mapping-rules">
      #       type mapping rules</a> of
      #       {@linkplain javax.management.MXBean MXBeans}.
      #       <p>
      #       If <tt>cd</tt> does not contain this attribute,
      #       the <tt>LockInfo</tt> object will be constructed from
      #       the value of the <tt>lockName</tt> attribute. </td>
      # </tr>
      # <tr>
      #   <td>lockName</td>
      #   <td><tt>java.lang.String</tt></td>
      # </tr>
      # <tr>
      #   <td>lockOwnerId</td>
      #   <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      #   <td>lockOwnerName</td>
      #   <td><tt>java.lang.String</tt></td>
      # </tr>
      # <tr>
      #   <td><a name="StackTrace">stackTrace</a></td>
      #   <td><tt>javax.management.openmbean.CompositeData[]</tt>
      #       <p>
      #       Each element is a <tt>CompositeData</tt> representing
      #       StackTraceElement containing the following attributes:
      #       <blockquote>
      #       <table cellspacing=1 cellpadding=0>
      #       <tr>
      #         <th align=left>Attribute Name</th>
      #         <th align=left>Type</th>
      #       </tr>
      #       <tr>
      #         <td>className</td>
      #         <td><tt>java.lang.String</tt></td>
      #       </tr>
      #       <tr>
      #         <td>methodName</td>
      #         <td><tt>java.lang.String</tt></td>
      #       </tr>
      #       <tr>
      #         <td>fileName</td>
      #         <td><tt>java.lang.String</tt></td>
      #       </tr>
      #       <tr>
      #         <td>lineNumber</td>
      #         <td><tt>java.lang.Integer</tt></td>
      #       </tr>
      #       <tr>
      #         <td>nativeMethod</td>
      #         <td><tt>java.lang.Boolean</tt></td>
      #       </tr>
      #       </table>
      #       </blockquote>
      #   </td>
      # </tr>
      # <tr>
      #   <td>lockedMonitors</td>
      #   <td><tt>javax.management.openmbean.CompositeData[]</tt>
      #       whose element type is the mapped type for
      #       {@link MonitorInfo} as specified in the
      #       {@link MonitorInfo#from Monitor.from} method.
      #       <p>
      #       If <tt>cd</tt> does not contain this attribute,
      #       this attribute will be set to an empty array. </td>
      # </tr>
      # <tr>
      #   <td>lockedSynchronizers</td>
      #   <td><tt>javax.management.openmbean.CompositeData[]</tt>
      #       whose element type is the mapped type for
      #       {@link LockInfo} as specified in the
      #       <a href="../../../javax/management/MXBean.html#mapping-rules">
      #       type mapping rules</a> of
      #       {@linkplain javax.management.MXBean MXBeans}.
      #       <p>
      #       If <tt>cd</tt> does not contain this attribute,
      #       this attribute will be set to an empty array. </td>
      # </tr>
      # </table>
      # </blockquote>
      # 
      # @param cd <tt>CompositeData</tt> representing a <tt>ThreadInfo</tt>
      # 
      # @throws IllegalArgumentException if <tt>cd</tt> does not
      #   represent a <tt>ThreadInfo</tt> with the attributes described
      #   above.
      # 
      # @return a <tt>ThreadInfo</tt> object represented
      #         by <tt>cd</tt> if <tt>cd</tt> is not <tt>null</tt>;
      #         <tt>null</tt> otherwise.
      def from(cd)
        if ((cd).nil?)
          return nil
        end
        if (cd.is_a?(ThreadInfoCompositeData))
          return (cd).get_thread_info
        else
          return ThreadInfo.new(cd)
        end
      end
    }
    
    typesig { [] }
    # Returns an array of {@link MonitorInfo} objects, each of which
    # represents an object monitor currently locked by the thread
    # associated with this <tt>ThreadInfo</tt>.
    # If no locked monitor was requested for this thread info or
    # no monitor is locked by the thread, this method
    # will return a zero-length array.
    # 
    # @return an array of <tt>MonitorInfo</tt> objects representing
    #         the object monitors locked by the thread.
    # 
    # @since 1.6
    def get_locked_monitors
      return @locked_monitors
    end
    
    typesig { [] }
    # Returns an array of {@link LockInfo} objects, each of which
    # represents an <a href="LockInfo.html#OwnableSynchronizer">ownable
    # synchronizer</a> currently locked by the thread associated with
    # this <tt>ThreadInfo</tt>.  If no locked synchronizer was
    # requested for this thread info or no synchronizer is locked by
    # the thread, this method will return a zero-length array.
    # 
    # @return an array of <tt>LockInfo</tt> objects representing
    #         the ownable synchronizers locked by the thread.
    # 
    # @since 1.6
    def get_locked_synchronizers
      # represents an <a href="LockInfo.html#OwnableSynchronizer">
      return @locked_synchronizers
    end
    
    class_module.module_eval {
      const_set_lazy(:NO_STACK_TRACE) { Array.typed(StackTraceElement).new(0) { nil } }
      const_attr_reader  :NO_STACK_TRACE
    }
    
    private
    alias_method :initialize__thread_info, :initialize
  end
  
end

require "rjava"

# 
# Copyright 1994-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module ThreadImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Collections
      include_const ::Java::Util::Concurrent::Locks, :LockSupport
      include_const ::Sun::Misc, :SoftCache
      include_const ::Sun::Nio::Ch, :Interruptible
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # 
  # A <i>thread</i> is a thread of execution in a program. The Java
  # Virtual Machine allows an application to have multiple threads of
  # execution running concurrently.
  # <p>
  # Every thread has a priority. Threads with higher priority are
  # executed in preference to threads with lower priority. Each thread
  # may or may not also be marked as a daemon. When code running in
  # some thread creates a new <code>Thread</code> object, the new
  # thread has its priority initially set equal to the priority of the
  # creating thread, and is a daemon thread if and only if the
  # creating thread is a daemon.
  # <p>
  # When a Java Virtual Machine starts up, there is usually a single
  # non-daemon thread (which typically calls the method named
  # <code>main</code> of some designated class). The Java Virtual
  # Machine continues to execute threads until either of the following
  # occurs:
  # <ul>
  # <li>The <code>exit</code> method of class <code>Runtime</code> has been
  # called and the security manager has permitted the exit operation
  # to take place.
  # <li>All threads that are not daemon threads have died, either by
  # returning from the call to the <code>run</code> method or by
  # throwing an exception that propagates beyond the <code>run</code>
  # method.
  # </ul>
  # <p>
  # There are two ways to create a new thread of execution. One is to
  # declare a class to be a subclass of <code>Thread</code>. This
  # subclass should override the <code>run</code> method of class
  # <code>Thread</code>. An instance of the subclass can then be
  # allocated and started. For example, a thread that computes primes
  # larger than a stated value could be written as follows:
  # <p><hr><blockquote><pre>
  # class PrimeThread extends Thread {
  # long minPrime;
  # PrimeThread(long minPrime) {
  # this.minPrime = minPrime;
  # }
  # 
  # public void run() {
  # // compute primes larger than minPrime
  # &nbsp;.&nbsp;.&nbsp;.
  # }
  # }
  # </pre></blockquote><hr>
  # <p>
  # The following code would then create a thread and start it running:
  # <p><blockquote><pre>
  # PrimeThread p = new PrimeThread(143);
  # p.start();
  # </pre></blockquote>
  # <p>
  # The other way to create a thread is to declare a class that
  # implements the <code>Runnable</code> interface. That class then
  # implements the <code>run</code> method. An instance of the class can
  # then be allocated, passed as an argument when creating
  # <code>Thread</code>, and started. The same example in this other
  # style looks like the following:
  # <p><hr><blockquote><pre>
  # class PrimeRun implements Runnable {
  # long minPrime;
  # PrimeRun(long minPrime) {
  # this.minPrime = minPrime;
  # }
  # 
  # public void run() {
  # // compute primes larger than minPrime
  # &nbsp;.&nbsp;.&nbsp;.
  # }
  # }
  # </pre></blockquote><hr>
  # <p>
  # The following code would then create a thread and start it running:
  # <p><blockquote><pre>
  # PrimeRun p = new PrimeRun(143);
  # new Thread(p).start();
  # </pre></blockquote>
  # <p>
  # Every thread has a name for identification purposes. More than
  # one thread may have the same name. If a name is not specified when
  # a thread is created, a new name is generated for it.
  # 
  # @author  unascribed
  # @see     Runnable
  # @see     Runtime#exit(int)
  # @see     #run()
  # @see     #stop()
  # @since   JDK1.0
  class JavaThread 
    include_class_members ThreadImports
    include Runnable
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Thread_registerNatives, [:pointer, :long], :void
      typesig { [] }
      # Make sure registerNatives is the first thing <clinit> does.
      def register_natives
        JNI.__send__(:Java_java_lang_Thread_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
      end
    }
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :priority
    alias_method :attr_priority, :priority
    undef_method :priority
    alias_method :attr_priority=, :priority=
    undef_method :priority=
    
    attr_accessor :thread_q
    alias_method :attr_thread_q, :thread_q
    undef_method :thread_q
    alias_method :attr_thread_q=, :thread_q=
    undef_method :thread_q=
    
    attr_accessor :eetop
    alias_method :attr_eetop, :eetop
    undef_method :eetop
    alias_method :attr_eetop=, :eetop=
    undef_method :eetop=
    
    # Whether or not to single_step this thread.
    attr_accessor :single_step
    alias_method :attr_single_step, :single_step
    undef_method :single_step
    alias_method :attr_single_step=, :single_step=
    undef_method :single_step=
    
    # Whether or not the thread is a daemon thread.
    attr_accessor :daemon
    alias_method :attr_daemon, :daemon
    undef_method :daemon
    alias_method :attr_daemon=, :daemon=
    undef_method :daemon=
    
    # JVM state
    attr_accessor :stillborn
    alias_method :attr_stillborn, :stillborn
    undef_method :stillborn
    alias_method :attr_stillborn=, :stillborn=
    undef_method :stillborn=
    
    # What will be run.
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    # The group of this thread
    attr_accessor :group
    alias_method :attr_group, :group
    undef_method :group
    alias_method :attr_group=, :group=
    undef_method :group=
    
    # The context ClassLoader for this thread
    attr_accessor :context_class_loader
    alias_method :attr_context_class_loader, :context_class_loader
    undef_method :context_class_loader
    alias_method :attr_context_class_loader=, :context_class_loader=
    undef_method :context_class_loader=
    
    # The inherited AccessControlContext of this thread
    attr_accessor :inherited_access_control_context
    alias_method :attr_inherited_access_control_context, :inherited_access_control_context
    undef_method :inherited_access_control_context
    alias_method :attr_inherited_access_control_context=, :inherited_access_control_context=
    undef_method :inherited_access_control_context=
    
    class_module.module_eval {
      # For autonumbering anonymous threads.
      
      def thread_init_number
        defined?(@@thread_init_number) ? @@thread_init_number : @@thread_init_number= 0
      end
      alias_method :attr_thread_init_number, :thread_init_number
      
      def thread_init_number=(value)
        @@thread_init_number = value
      end
      alias_method :attr_thread_init_number=, :thread_init_number=
      
      typesig { [] }
      def next_thread_num
        synchronized(self) do
          return ((self.attr_thread_init_number += 1) - 1)
        end
      end
    }
    
    # ThreadLocal values pertaining to this thread. This map is maintained
    # by the ThreadLocal class.
    attr_accessor :thread_locals
    alias_method :attr_thread_locals, :thread_locals
    undef_method :thread_locals
    alias_method :attr_thread_locals=, :thread_locals=
    undef_method :thread_locals=
    
    # 
    # InheritableThreadLocal values pertaining to this thread. This map is
    # maintained by the InheritableThreadLocal class.
    attr_accessor :inheritable_thread_locals
    alias_method :attr_inheritable_thread_locals, :inheritable_thread_locals
    undef_method :inheritable_thread_locals
    alias_method :attr_inheritable_thread_locals=, :inheritable_thread_locals=
    undef_method :inheritable_thread_locals=
    
    # 
    # The requested stack size for this thread, or 0 if the creator did
    # not specify a stack size.  It is up to the VM to do whatever it
    # likes with this number; some VMs will ignore it.
    attr_accessor :stack_size
    alias_method :attr_stack_size, :stack_size
    undef_method :stack_size
    alias_method :attr_stack_size=, :stack_size=
    undef_method :stack_size=
    
    # 
    # JVM-private state that persists after native thread termination.
    attr_accessor :native_park_event_pointer
    alias_method :attr_native_park_event_pointer, :native_park_event_pointer
    undef_method :native_park_event_pointer
    alias_method :attr_native_park_event_pointer=, :native_park_event_pointer=
    undef_method :native_park_event_pointer=
    
    # 
    # Thread ID
    attr_accessor :tid
    alias_method :attr_tid, :tid
    undef_method :tid
    alias_method :attr_tid=, :tid=
    undef_method :tid=
    
    class_module.module_eval {
      # For generating thread ID
      
      def thread_seq_number
        defined?(@@thread_seq_number) ? @@thread_seq_number : @@thread_seq_number= 0
      end
      alias_method :attr_thread_seq_number, :thread_seq_number
      
      def thread_seq_number=(value)
        @@thread_seq_number = value
      end
      alias_method :attr_thread_seq_number=, :thread_seq_number=
    }
    
    # Java thread status for tools,
    # initialized to indicate thread 'not yet started'
    attr_accessor :thread_status
    alias_method :attr_thread_status, :thread_status
    undef_method :thread_status
    alias_method :attr_thread_status=, :thread_status=
    undef_method :thread_status=
    
    class_module.module_eval {
      typesig { [] }
      def next_thread_id
        synchronized(self) do
          return (self.attr_thread_seq_number += 1)
        end
      end
    }
    
    # 
    # The argument supplied to the current call to
    # java.util.concurrent.locks.LockSupport.park.
    # Set by (private) java.util.concurrent.locks.LockSupport.setBlocker
    # Accessed using java.util.concurrent.locks.LockSupport.getBlocker
    attr_accessor :park_blocker
    alias_method :attr_park_blocker, :park_blocker
    undef_method :park_blocker
    alias_method :attr_park_blocker=, :park_blocker=
    undef_method :park_blocker=
    
    # The object in which this thread is blocked in an interruptible I/O
    # operation, if any.  The blocker's interrupt method should be invoked
    # after setting this thread's interrupt status.
    attr_accessor :blocker
    alias_method :attr_blocker, :blocker
    undef_method :blocker
    alias_method :attr_blocker=, :blocker=
    undef_method :blocker=
    
    attr_accessor :blocker_lock
    alias_method :attr_blocker_lock, :blocker_lock
    undef_method :blocker_lock
    alias_method :attr_blocker_lock=, :blocker_lock=
    undef_method :blocker_lock=
    
    typesig { [Interruptible] }
    # Set the blocker field; invoked via sun.misc.SharedSecrets from java.nio code
    def blocked_on(b)
      synchronized((@blocker_lock)) do
        @blocker = b
      end
    end
    
    class_module.module_eval {
      # 
      # The minimum priority that a thread can have.
      const_set_lazy(:MIN_PRIORITY) { 1 }
      const_attr_reader  :MIN_PRIORITY
      
      # 
      # The default priority that is assigned to a thread.
      const_set_lazy(:NORM_PRIORITY) { 5 }
      const_attr_reader  :NORM_PRIORITY
      
      # 
      # The maximum priority that a thread can have.
      const_set_lazy(:MAX_PRIORITY) { 10 }
      const_attr_reader  :MAX_PRIORITY
    }
    
    # If stop was called before start
    attr_accessor :stop_before_start
    alias_method :attr_stop_before_start, :stop_before_start
    undef_method :stop_before_start
    alias_method :attr_stop_before_start=, :stop_before_start=
    undef_method :stop_before_start=
    
    # Remembered Throwable from stop before start
    attr_accessor :throwable_from_stop
    alias_method :attr_throwable_from_stop, :throwable_from_stop
    undef_method :throwable_from_stop
    alias_method :attr_throwable_from_stop=, :throwable_from_stop=
    undef_method :throwable_from_stop=
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Thread_currentThread, [:pointer, :long], :long
      typesig { [] }
      # 
      # Returns a reference to the currently executing thread object.
      # 
      # @return  the currently executing thread.
      def current_thread
        JNI.__send__(:Java_java_lang_Thread_currentThread, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Thread_yield, [:pointer, :long], :void
      typesig { [] }
      # 
      # Causes the currently executing thread object to temporarily pause
      # and allow other threads to execute.
      def yield
        JNI.__send__(:Java_java_lang_Thread_yield, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Thread_sleep, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      # 
      # Causes the currently executing thread to sleep (temporarily cease
      # execution) for the specified number of milliseconds, subject to
      # the precision and accuracy of system timers and schedulers. The thread
      # does not lose ownership of any monitors.
      # 
      # @param      millis   the length of time to sleep in milliseconds.
      # @exception  InterruptedException if any thread has interrupted
      # the current thread.  The <i>interrupted status</i> of the
      # current thread is cleared when this exception is thrown.
      # @see        Object#notify()
      def sleep(millis)
        JNI.__send__(:Java_java_lang_Thread_sleep, JNI.env, self.jni_id, millis.to_int)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # 
      # Causes the currently executing thread to sleep (cease execution)
      # for the specified number of milliseconds plus the specified number
      # of nanoseconds, subject to the precision and accuracy of system
      # timers and schedulers. The thread does not lose ownership of any
      # monitors.
      # 
      # @param      millis   the length of time to sleep in milliseconds.
      # @param      nanos    0-999999 additional nanoseconds to sleep.
      # @exception  IllegalArgumentException  if the value of millis is
      # negative or the value of nanos is not in the range
      # 0-999999.
      # @exception  InterruptedException if any thread has interrupted
      # the current thread.  The <i>interrupted status</i> of the
      # current thread is cleared when this exception is thrown.
      # @see        Object#notify()
      def sleep(millis, nanos)
        if (millis < 0)
          raise IllegalArgumentException.new("timeout value is negative")
        end
        if (nanos < 0 || nanos > 999999)
          raise IllegalArgumentException.new("nanosecond timeout value out of range")
        end
        if (nanos >= 500000 || (!(nanos).equal?(0) && (millis).equal?(0)))
          ((millis += 1) - 1)
        end
        sleep(millis)
      end
    }
    
    typesig { [JavaThreadGroup, Runnable, String, ::Java::Long] }
    # 
    # Initializes a Thread.
    # 
    # @param g the Thread group
    # @param target the object whose run() method gets called
    # @param name the name of the new Thread
    # @param stackSize the desired stack size for the new thread, or
    # zero to indicate that this parameter is to be ignored.
    def init(g, target, name, stack_size)
      parent = current_thread
      security = System.get_security_manager
      if ((g).nil?)
        # Determine if it's an applet or not
        # If there is a security manager, ask the security manager
        # what to do.
        if (!(security).nil?)
          g = security.get_thread_group
        end
        # If the security doesn't have a strong opinion of the matter
        # use the parent thread group.
        if ((g).nil?)
          g = parent.get_thread_group
        end
      end
      # checkAccess regardless of whether or not threadgroup is
      # explicitly passed in.
      g.check_access
      # 
      # Do we have the required permissions?
      if (!(security).nil?)
        if (is_ccloverridden(get_class))
          security.check_permission(SUBCLASS_IMPLEMENTATION_PERMISSION)
        end
      end
      g.add_unstarted
      @group = g
      @daemon = parent.is_daemon
      @priority = parent.get_priority
      @name = name.to_char_array
      if ((security).nil? || is_ccloverridden(parent.get_class))
        @context_class_loader = parent.get_context_class_loader
      else
        @context_class_loader = parent.attr_context_class_loader
      end
      @inherited_access_control_context = AccessController.get_context
      @target = target
      set_priority(@priority)
      if (!(parent.attr_inheritable_thread_locals).nil?)
        @inheritable_thread_locals = ThreadLocal.create_inherited_map(parent.attr_inheritable_thread_locals)
      end
      # Stash the specified stack size in case the VM cares
      @stack_size = stack_size
      # Set thread ID
      @tid = next_thread_id
    end
    
    typesig { [] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(null, null,</code>
    # <i>gname</i><code>)</code>, where <b><i>gname</i></b> is
    # a newly generated name. Automatically generated names are of the
    # form <code>"Thread-"+</code><i>n</i>, where <i>n</i> is an integer.
    # 
    # @see     #Thread(ThreadGroup, Runnable, String)
    def initialize
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(nil, nil, "Thread-" + (next_thread_num).to_s, 0)
    end
    
    typesig { [Runnable] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(null, target,</code>
    # <i>gname</i><code>)</code>, where <i>gname</i> is
    # a newly generated name. Automatically generated names are of the
    # form <code>"Thread-"+</code><i>n</i>, where <i>n</i> is an integer.
    # 
    # @param   target   the object whose <code>run</code> method is called.
    # @see     #Thread(ThreadGroup, Runnable, String)
    def initialize(target)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(nil, target, "Thread-" + (next_thread_num).to_s, 0)
    end
    
    typesig { [JavaThreadGroup, Runnable] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(group, target,</code>
    # <i>gname</i><code>)</code>, where <i>gname</i> is
    # a newly generated name. Automatically generated names are of the
    # form <code>"Thread-"+</code><i>n</i>, where <i>n</i> is an integer.
    # 
    # @param      group    the thread group.
    # @param      target   the object whose <code>run</code> method is called.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group.
    # @see        #Thread(ThreadGroup, Runnable, String)
    def initialize(group, target)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(group, target, "Thread-" + (next_thread_num).to_s, 0)
    end
    
    typesig { [String] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(null, null, name)</code>.
    # 
    # @param   name   the name of the new thread.
    # @see     #Thread(ThreadGroup, Runnable, String)
    def initialize(name)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(nil, nil, name, 0)
    end
    
    typesig { [JavaThreadGroup, String] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(group, null, name)</code>
    # 
    # @param      group   the thread group.
    # @param      name    the name of the new thread.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group.
    # @see        #Thread(ThreadGroup, Runnable, String)
    def initialize(group, name)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(group, nil, name, 0)
    end
    
    typesig { [Runnable, String] }
    # 
    # Allocates a new <code>Thread</code> object. This constructor has
    # the same effect as <code>Thread(null, target, name)</code>.
    # 
    # @param   target   the object whose <code>run</code> method is called.
    # @param   name     the name of the new thread.
    # @see     #Thread(ThreadGroup, Runnable, String)
    def initialize(target, name)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(nil, target, name, 0)
    end
    
    typesig { [JavaThreadGroup, Runnable, String] }
    # 
    # Allocates a new <code>Thread</code> object so that it has
    # <code>target</code> as its run object, has the specified
    # <code>name</code> as its name, and belongs to the thread group
    # referred to by <code>group</code>.
    # <p>
    # If <code>group</code> is <code>null</code> and there is a
    # security manager, the group is determined by the security manager's
    # <code>getThreadGroup</code> method. If <code>group</code> is
    # <code>null</code> and there is not a security manager, or the
    # security manager's <code>getThreadGroup</code> method returns
    # <code>null</code>, the group is set to be the same ThreadGroup
    # as the thread that is creating the new thread.
    # 
    # <p>If there is a security manager, its <code>checkAccess</code>
    # method is called with the ThreadGroup as its argument.
    # <p>In addition, its <code>checkPermission</code>
    # method is called with the
    # <code>RuntimePermission("enableContextClassLoaderOverride")</code>
    # permission when invoked directly or indirectly by the constructor
    # of a subclass which overrides the <code>getContextClassLoader</code>
    # or <code>setContextClassLoader</code> methods.
    # This may result in a SecurityException.
    # 
    # <p>
    # If the <code>target</code> argument is not <code>null</code>, the
    # <code>run</code> method of the <code>target</code> is called when
    # this thread is started. If the target argument is
    # <code>null</code>, this thread's <code>run</code> method is called
    # when this thread is started.
    # <p>
    # The priority of the newly created thread is set equal to the
    # priority of the thread creating it, that is, the currently running
    # thread. The method <code>setPriority</code> may be used to
    # change the priority to a new value.
    # <p>
    # The newly created thread is initially marked as being a daemon
    # thread if and only if the thread creating it is currently marked
    # as a daemon thread. The method <code>setDaemon </code> may be used
    # to change whether or not a thread is a daemon.
    # 
    # @param      group     the thread group.
    # @param      target   the object whose <code>run</code> method is called.
    # @param      name     the name of the new thread.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group or cannot
    # override the context class loader methods.
    # @see        Runnable#run()
    # @see        #run()
    # @see        #setDaemon(boolean)
    # @see        #setPriority(int)
    # @see        ThreadGroup#checkAccess()
    # @see        SecurityManager#checkAccess
    def initialize(group, target, name)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(group, target, name, 0)
    end
    
    typesig { [JavaThreadGroup, Runnable, String, ::Java::Long] }
    # 
    # Allocates a new <code>Thread</code> object so that it has
    # <code>target</code> as its run object, has the specified
    # <code>name</code> as its name, belongs to the thread group referred to
    # by <code>group</code>, and has the specified <i>stack size</i>.
    # 
    # <p>This constructor is identical to {@link
    # #Thread(ThreadGroup,Runnable,String)} with the exception of the fact
    # that it allows the thread stack size to be specified.  The stack size
    # is the approximate number of bytes of address space that the virtual
    # machine is to allocate for this thread's stack.  <b>The effect of the
    # <tt>stackSize</tt> parameter, if any, is highly platform dependent.</b>
    # 
    # <p>On some platforms, specifying a higher value for the
    # <tt>stackSize</tt> parameter may allow a thread to achieve greater
    # recursion depth before throwing a {@link StackOverflowError}.
    # Similarly, specifying a lower value may allow a greater number of
    # threads to exist concurrently without throwing an {@link
    # OutOfMemoryError} (or other internal error).  The details of
    # the relationship between the value of the <tt>stackSize</tt> parameter
    # and the maximum recursion depth and concurrency level are
    # platform-dependent.  <b>On some platforms, the value of the
    # <tt>stackSize</tt> parameter may have no effect whatsoever.</b>
    # 
    # <p>The virtual machine is free to treat the <tt>stackSize</tt>
    # parameter as a suggestion.  If the specified value is unreasonably low
    # for the platform, the virtual machine may instead use some
    # platform-specific minimum value; if the specified value is unreasonably
    # high, the virtual machine may instead use some platform-specific
    # maximum.  Likewise, the virtual machine is free to round the specified
    # value up or down as it sees fit (or to ignore it completely).
    # 
    # <p>Specifying a value of zero for the <tt>stackSize</tt> parameter will
    # cause this constructor to behave exactly like the
    # <tt>Thread(ThreadGroup, Runnable, String)</tt> constructor.
    # 
    # <p><i>Due to the platform-dependent nature of the behavior of this
    # constructor, extreme care should be exercised in its use.
    # The thread stack size necessary to perform a given computation will
    # likely vary from one JRE implementation to another.  In light of this
    # variation, careful tuning of the stack size parameter may be required,
    # and the tuning may need to be repeated for each JRE implementation on
    # which an application is to run.</i>
    # 
    # <p>Implementation note: Java platform implementers are encouraged to
    # document their implementation's behavior with respect to the
    # <tt>stackSize parameter</tt>.
    # 
    # @param      group    the thread group.
    # @param      target   the object whose <code>run</code> method is called.
    # @param      name     the name of the new thread.
    # @param      stackSize the desired stack size for the new thread, or
    # zero to indicate that this parameter is to be ignored.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group.
    # @since 1.4
    def initialize(group, target, name, stack_size)
      @name = nil
      @priority = 0
      @thread_q = nil
      @eetop = 0
      @single_step = false
      @daemon = false
      @stillborn = false
      @target = nil
      @group = nil
      @context_class_loader = nil
      @inherited_access_control_context = nil
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @stack_size = 0
      @native_park_event_pointer = 0
      @tid = 0
      @thread_status = 0
      @park_blocker = nil
      @blocker = nil
      @blocker_lock = Object.new
      @stop_before_start = false
      @throwable_from_stop = nil
      @uncaught_exception_handler = nil
      init(group, target, name, stack_size)
    end
    
    typesig { [] }
    # 
    # Causes this thread to begin execution; the Java Virtual Machine
    # calls the <code>run</code> method of this thread.
    # <p>
    # The result is that two threads are running concurrently: the
    # current thread (which returns from the call to the
    # <code>start</code> method) and the other thread (which executes its
    # <code>run</code> method).
    # <p>
    # It is never legal to start a thread more than once.
    # In particular, a thread may not be restarted once it has completed
    # execution.
    # 
    # @exception  IllegalThreadStateException  if the thread was already
    # started.
    # @see        #run()
    # @see        #stop()
    def start
      synchronized(self) do
        # 
        # This method is not invoked for the main method thread or "system"
        # group threads created/set up by the VM. Any new functionality added
        # to this method in the future may have to also be added to the VM.
        # 
        # A zero status value corresponds to state "NEW".
        if (!(@thread_status).equal?(0))
          raise IllegalThreadStateException.new
        end
        @group.add(self)
        start0
        if (@stop_before_start)
          stop0(@throwable_from_stop)
        end
      end
    end
    
    JNI.native_method :Java_java_lang_Thread_start0, [:pointer, :long], :void
    typesig { [] }
    def start0
      JNI.__send__(:Java_java_lang_Thread_start0, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # 
    # If this thread was constructed using a separate
    # <code>Runnable</code> run object, then that
    # <code>Runnable</code> object's <code>run</code> method is called;
    # otherwise, this method does nothing and returns.
    # <p>
    # Subclasses of <code>Thread</code> should override this method.
    # 
    # @see     #start()
    # @see     #stop()
    # @see     #Thread(ThreadGroup, Runnable, String)
    def run
      if (!(@target).nil?)
        @target.run
      end
    end
    
    typesig { [] }
    # 
    # This method is called by the system to give a Thread
    # a chance to clean up before it actually exits.
    def exit
      if (!(@group).nil?)
        @group.remove(self)
        @group = nil
      end
      # Aggressively null out all reference fields: see bug 4006245
      @target = nil
      # Speed the release of some of these resources
      @thread_locals = nil
      @inheritable_thread_locals = nil
      @inherited_access_control_context = nil
      @blocker = nil
      @uncaught_exception_handler = nil
    end
    
    typesig { [] }
    # 
    # Forces the thread to stop executing.
    # <p>
    # If there is a security manager installed, its <code>checkAccess</code>
    # method is called with <code>this</code>
    # as its argument. This may result in a
    # <code>SecurityException</code> being raised (in the current thread).
    # <p>
    # If this thread is different from the current thread (that is, the current
    # thread is trying to stop a thread other than itself), the
    # security manager's <code>checkPermission</code> method (with a
    # <code>RuntimePermission("stopThread")</code> argument) is called in
    # addition.
    # Again, this may result in throwing a
    # <code>SecurityException</code> (in the current thread).
    # <p>
    # The thread represented by this thread is forced to stop whatever
    # it is doing abnormally and to throw a newly created
    # <code>ThreadDeath</code> object as an exception.
    # <p>
    # It is permitted to stop a thread that has not yet been started.
    # If the thread is eventually started, it immediately terminates.
    # <p>
    # An application should not normally try to catch
    # <code>ThreadDeath</code> unless it must do some extraordinary
    # cleanup operation (note that the throwing of
    # <code>ThreadDeath</code> causes <code>finally</code> clauses of
    # <code>try</code> statements to be executed before the thread
    # officially dies).  If a <code>catch</code> clause catches a
    # <code>ThreadDeath</code> object, it is important to rethrow the
    # object so that the thread actually dies.
    # <p>
    # The top-level error handler that reacts to otherwise uncaught
    # exceptions does not print out a message or otherwise notify the
    # application if the uncaught exception is an instance of
    # <code>ThreadDeath</code>.
    # 
    # @exception  SecurityException  if the current thread cannot
    # modify this thread.
    # @see        #interrupt()
    # @see        #checkAccess()
    # @see        #run()
    # @see        #start()
    # @see        ThreadDeath
    # @see        ThreadGroup#uncaughtException(Thread,Throwable)
    # @see        SecurityManager#checkAccess(Thread)
    # @see        SecurityManager#checkPermission
    # @deprecated This method is inherently unsafe.  Stopping a thread with
    # Thread.stop causes it to unlock all of the monitors that it
    # has locked (as a natural consequence of the unchecked
    # <code>ThreadDeath</code> exception propagating up the stack).  If
    # any of the objects previously protected by these monitors were in
    # an inconsistent state, the damaged objects become visible to
    # other threads, potentially resulting in arbitrary behavior.  Many
    # uses of <code>stop</code> should be replaced by code that simply
    # modifies some variable to indicate that the target thread should
    # stop running.  The target thread should check this variable
    # regularly, and return from its run method in an orderly fashion
    # if the variable indicates that it is to stop running.  If the
    # target thread waits for long periods (on a condition variable,
    # for example), the <code>interrupt</code> method should be used to
    # interrupt the wait.
    # For more information, see
    # <a href="{@docRoot}/../technotes/guides/concurrency/threadPrimitiveDeprecation.html">Why
    # are Thread.stop, Thread.suspend and Thread.resume Deprecated?</a>.
    def stop
      # If the thread is already dead, return.
      # A zero status value corresponds to "NEW".
      if ((!(@thread_status).equal?(0)) && !is_alive)
        return
      end
      stop1(ThreadDeath.new)
    end
    
    typesig { [Exception] }
    # 
    # Forces the thread to stop executing.
    # <p>
    # If there is a security manager installed, the <code>checkAccess</code>
    # method of this thread is called, which may result in a
    # <code>SecurityException</code> being raised (in the current thread).
    # <p>
    # If this thread is different from the current thread (that is, the current
    # thread is trying to stop a thread other than itself) or
    # <code>obj</code> is not an instance of <code>ThreadDeath</code>, the
    # security manager's <code>checkPermission</code> method (with the
    # <code>RuntimePermission("stopThread")</code> argument) is called in
    # addition.
    # Again, this may result in throwing a
    # <code>SecurityException</code> (in the current thread).
    # <p>
    # If the argument <code>obj</code> is null, a
    # <code>NullPointerException</code> is thrown (in the current thread).
    # <p>
    # The thread represented by this thread is forced to stop
    # whatever it is doing abnormally and to throw the
    # <code>Throwable</code> object <code>obj</code> as an exception. This
    # is an unusual action to take; normally, the <code>stop</code> method
    # that takes no arguments should be used.
    # <p>
    # It is permitted to stop a thread that has not yet been started.
    # If the thread is eventually started, it immediately terminates.
    # 
    # @param      obj   the Throwable object to be thrown.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread.
    # @throws     NullPointerException if obj is <tt>null</tt>.
    # @see        #interrupt()
    # @see        #checkAccess()
    # @see        #run()
    # @see        #start()
    # @see        #stop()
    # @see        SecurityManager#checkAccess(Thread)
    # @see        SecurityManager#checkPermission
    # @deprecated This method is inherently unsafe.  See {@link #stop()}
    # for details.  An additional danger of this
    # method is that it may be used to generate exceptions that the
    # target thread is unprepared to handle (including checked
    # exceptions that the thread could not possibly throw, were it
    # not for this method).
    # For more information, see
    # <a href="{@docRoot}/../technotes/guides/concurrency/threadPrimitiveDeprecation.html">Why
    # are Thread.stop, Thread.suspend and Thread.resume Deprecated?</a>.
    def stop(obj)
      synchronized(self) do
        stop1(obj)
      end
    end
    
    typesig { [Exception] }
    # 
    # Common impl for stop() and stop(Throwable).
    def stop1(th)
      synchronized(self) do
        security = System.get_security_manager
        if (!(security).nil?)
          check_access
          if ((!(self).equal?(JavaThread.current_thread)) || (!(th.is_a?(ThreadDeath))))
            security.check_permission(SecurityConstants::STOP_THREAD_PERMISSION)
          end
        end
        # A zero status value corresponds to "NEW"
        if (!(@thread_status).equal?(0))
          resume # Wake up thread if it was suspended; no-op otherwise
          stop0(th)
        else
          # Must do the null arg check that the VM would do with stop0
          if ((th).nil?)
            raise NullPointerException.new
          end
          # Remember this stop attempt for if/when start is used
          @stop_before_start = true
          @throwable_from_stop = th
        end
      end
    end
    
    typesig { [] }
    # 
    # Interrupts this thread.
    # 
    # <p> Unless the current thread is interrupting itself, which is
    # always permitted, the {@link #checkAccess() checkAccess} method
    # of this thread is invoked, which may cause a {@link
    # SecurityException} to be thrown.
    # 
    # <p> If this thread is blocked in an invocation of the {@link
    # Object#wait() wait()}, {@link Object#wait(long) wait(long)}, or {@link
    # Object#wait(long, int) wait(long, int)} methods of the {@link Object}
    # class, or of the {@link #join()}, {@link #join(long)}, {@link
    # #join(long, int)}, {@link #sleep(long)}, or {@link #sleep(long, int)},
    # methods of this class, then its interrupt status will be cleared and it
    # will receive an {@link InterruptedException}.
    # 
    # <p> If this thread is blocked in an I/O operation upon an {@link
    # java.nio.channels.InterruptibleChannel </code>interruptible
    # channel<code>} then the channel will be closed, the thread's interrupt
    # status will be set, and the thread will receive a {@link
    # java.nio.channels.ClosedByInterruptException}.
    # 
    # <p> If this thread is blocked in a {@link java.nio.channels.Selector}
    # then the thread's interrupt status will be set and it will return
    # immediately from the selection operation, possibly with a non-zero
    # value, just as if the selector's {@link
    # java.nio.channels.Selector#wakeup wakeup} method were invoked.
    # 
    # <p> If none of the previous conditions hold then this thread's interrupt
    # status will be set. </p>
    # 
    # <p> Interrupting a thread that is not alive need not have any effect.
    # 
    # @throws  SecurityException
    # if the current thread cannot modify this thread
    # 
    # @revised 6.0
    # @spec JSR-51
    def interrupt
      if (!(self).equal?(JavaThread.current_thread))
        check_access
      end
      synchronized((@blocker_lock)) do
        b = @blocker
        if (!(b).nil?)
          interrupt0 # Just to set the interrupt flag
          b.interrupt
          return
        end
      end
      interrupt0
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Tests whether the current thread has been interrupted.  The
      # <i>interrupted status</i> of the thread is cleared by this method.  In
      # other words, if this method were to be called twice in succession, the
      # second call would return false (unless the current thread were
      # interrupted again, after the first call had cleared its interrupted
      # status and before the second call had examined it).
      # 
      # <p>A thread interruption ignored because a thread was not alive
      # at the time of the interrupt will be reflected by this method
      # returning false.
      # 
      # @return  <code>true</code> if the current thread has been interrupted;
      # <code>false</code> otherwise.
      # @see #isInterrupted()
      # @revised 6.0
      def interrupted
        return current_thread.is_interrupted(true)
      end
    }
    
    typesig { [] }
    # 
    # Tests whether this thread has been interrupted.  The <i>interrupted
    # status</i> of the thread is unaffected by this method.
    # 
    # <p>A thread interruption ignored because a thread was not alive
    # at the time of the interrupt will be reflected by this method
    # returning false.
    # 
    # @return  <code>true</code> if this thread has been interrupted;
    # <code>false</code> otherwise.
    # @see     #interrupted()
    # @revised 6.0
    def is_interrupted
      return is_interrupted(false)
    end
    
    JNI.native_method :Java_java_lang_Thread_isInterrupted, [:pointer, :long, :int8], :int8
    typesig { [::Java::Boolean] }
    # 
    # Tests if some Thread has been interrupted.  The interrupted state
    # is reset or not based on the value of ClearInterrupted that is
    # passed.
    def is_interrupted(clear_interrupted)
      JNI.__send__(:Java_java_lang_Thread_isInterrupted, JNI.env, self.jni_id, clear_interrupted ? 1 : 0) != 0
    end
    
    typesig { [] }
    # 
    # Throws {@link NoSuchMethodError}.
    # 
    # @deprecated This method was originally designed to destroy this
    # thread without any cleanup. Any monitors it held would have
    # remained locked. However, the method was never implemented.
    # If if were to be implemented, it would be deadlock-prone in
    # much the manner of {@link #suspend}. If the target thread held
    # a lock protecting a critical system resource when it was
    # destroyed, no thread could ever access this resource again.
    # If another thread ever attempted to lock this resource, deadlock
    # would result. Such deadlocks typically manifest themselves as
    # "frozen" processes. For more information, see
    # <a href="{@docRoot}/../technotes/guides/concurrency/threadPrimitiveDeprecation.html">
    # Why are Thread.stop, Thread.suspend and Thread.resume Deprecated?</a>.
    # @throws NoSuchMethodError always
    def destroy
      raise NoSuchMethodError.new
    end
    
    JNI.native_method :Java_java_lang_Thread_isAlive, [:pointer, :long], :int8
    typesig { [] }
    # 
    # Tests if this thread is alive. A thread is alive if it has
    # been started and has not yet died.
    # 
    # @return  <code>true</code> if this thread is alive;
    # <code>false</code> otherwise.
    def is_alive
      JNI.__send__(:Java_java_lang_Thread_isAlive, JNI.env, self.jni_id) != 0
    end
    
    typesig { [] }
    # 
    # Suspends this thread.
    # <p>
    # First, the <code>checkAccess</code> method of this thread is called
    # with no arguments. This may result in throwing a
    # <code>SecurityException </code>(in the current thread).
    # <p>
    # If the thread is alive, it is suspended and makes no further
    # progress unless and until it is resumed.
    # 
    # @exception  SecurityException  if the current thread cannot modify
    # this thread.
    # @see #checkAccess
    # @deprecated   This method has been deprecated, as it is
    # inherently deadlock-prone.  If the target thread holds a lock on the
    # monitor protecting a critical system resource when it is suspended, no
    # thread can access this resource until the target thread is resumed. If
    # the thread that would resume the target thread attempts to lock this
    # monitor prior to calling <code>resume</code>, deadlock results.  Such
    # deadlocks typically manifest themselves as "frozen" processes.
    # For more information, see
    # <a href="{@docRoot}/../technotes/guides/concurrency/threadPrimitiveDeprecation.html">Why
    # are Thread.stop, Thread.suspend and Thread.resume Deprecated?</a>.
    def suspend
      check_access
      suspend0
    end
    
    typesig { [] }
    # 
    # Resumes a suspended thread.
    # <p>
    # First, the <code>checkAccess</code> method of this thread is called
    # with no arguments. This may result in throwing a
    # <code>SecurityException</code> (in the current thread).
    # <p>
    # If the thread is alive but suspended, it is resumed and is
    # permitted to make progress in its execution.
    # 
    # @exception  SecurityException  if the current thread cannot modify this
    # thread.
    # @see        #checkAccess
    # @see        #suspend()
    # @deprecated This method exists solely for use with {@link #suspend},
    # which has been deprecated because it is deadlock-prone.
    # For more information, see
    # <a href="{@docRoot}/../technotes/guides/concurrency/threadPrimitiveDeprecation.html">Why
    # are Thread.stop, Thread.suspend and Thread.resume Deprecated?</a>.
    def resume
      check_access
      resume0
    end
    
    typesig { [::Java::Int] }
    # 
    # Changes the priority of this thread.
    # <p>
    # First the <code>checkAccess</code> method of this thread is called
    # with no arguments. This may result in throwing a
    # <code>SecurityException</code>.
    # <p>
    # Otherwise, the priority of this thread is set to the smaller of
    # the specified <code>newPriority</code> and the maximum permitted
    # priority of the thread's thread group.
    # 
    # @param newPriority priority to set this thread to
    # @exception  IllegalArgumentException  If the priority is not in the
    # range <code>MIN_PRIORITY</code> to
    # <code>MAX_PRIORITY</code>.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread.
    # @see        #getPriority
    # @see        #checkAccess()
    # @see        #getThreadGroup()
    # @see        #MAX_PRIORITY
    # @see        #MIN_PRIORITY
    # @see        ThreadGroup#getMaxPriority()
    def set_priority(new_priority)
      g = nil
      check_access
      if (new_priority > MAX_PRIORITY || new_priority < MIN_PRIORITY)
        raise IllegalArgumentException.new
      end
      if (!((g = get_thread_group)).nil?)
        if (new_priority > g.get_max_priority)
          new_priority = g.get_max_priority
        end
        set_priority0(@priority = new_priority)
      end
    end
    
    typesig { [] }
    # 
    # Returns this thread's priority.
    # 
    # @return  this thread's priority.
    # @see     #setPriority
    def get_priority
      return @priority
    end
    
    typesig { [String] }
    # 
    # Changes the name of this thread to be equal to the argument
    # <code>name</code>.
    # <p>
    # First the <code>checkAccess</code> method of this thread is called
    # with no arguments. This may result in throwing a
    # <code>SecurityException</code>.
    # 
    # @param      name   the new name for this thread.
    # @exception  SecurityException  if the current thread cannot modify this
    # thread.
    # @see        #getName
    # @see        #checkAccess()
    def set_name(name)
      check_access
      @name = name.to_char_array
    end
    
    typesig { [] }
    # 
    # Returns this thread's name.
    # 
    # @return  this thread's name.
    # @see     #setName(String)
    def get_name
      return String.value_of(@name)
    end
    
    typesig { [] }
    # 
    # Returns the thread group to which this thread belongs.
    # This method returns null if this thread has died
    # (been stopped).
    # 
    # @return  this thread's thread group.
    def get_thread_group
      return @group
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Returns the number of active threads in the current thread's thread
      # group.
      # 
      # @return  the number of active threads in the current thread's thread
      # group.
      def active_count
        return current_thread.get_thread_group.active_count
      end
      
      typesig { [Array.typed(JavaThread)] }
      # 
      # Copies into the specified array every active thread in
      # the current thread's thread group and its subgroups. This method simply
      # calls the <code>enumerate</code> method of the current thread's thread
      # group with the array argument.
      # <p>
      # First, if there is a security manager, that <code>enumerate</code>
      # method calls the security
      # manager's <code>checkAccess</code> method
      # with the thread group as its argument. This may result
      # in throwing a <code>SecurityException</code>.
      # 
      # @param tarray an array of Thread objects to copy to
      # @return  the number of threads put into the array
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkAccess</code> method doesn't allow the operation.
      # @see     ThreadGroup#enumerate(Thread[])
      # @see     SecurityManager#checkAccess(ThreadGroup)
      def enumerate(tarray)
        return current_thread.get_thread_group.enumerate(tarray)
      end
    }
    
    JNI.native_method :Java_java_lang_Thread_countStackFrames, [:pointer, :long], :int32
    typesig { [] }
    # 
    # Counts the number of stack frames in this thread. The thread must
    # be suspended.
    # 
    # @return     the number of stack frames in this thread.
    # @exception  IllegalThreadStateException  if this thread is not
    # suspended.
    # @deprecated The definition of this call depends on {@link #suspend},
    # which is deprecated.  Further, the results of this call
    # were never well-defined.
    def count_stack_frames
      JNI.__send__(:Java_java_lang_Thread_countStackFrames, JNI.env, self.jni_id)
    end
    
    typesig { [::Java::Long] }
    # 
    # Waits at most <code>millis</code> milliseconds for this thread to
    # die. A timeout of <code>0</code> means to wait forever.
    # 
    # @param      millis   the time to wait in milliseconds.
    # @exception  InterruptedException if any thread has interrupted
    # the current thread.  The <i>interrupted status</i> of the
    # current thread is cleared when this exception is thrown.
    def join(millis)
      synchronized(self) do
        base = System.current_time_millis
        now = 0
        if (millis < 0)
          raise IllegalArgumentException.new("timeout value is negative")
        end
        if ((millis).equal?(0))
          while (is_alive)
            wait(0)
          end
        else
          while (is_alive)
            delay = millis - now
            if (delay <= 0)
              break
            end
            wait(delay)
            now = System.current_time_millis - base
          end
        end
      end
    end
    
    typesig { [::Java::Long, ::Java::Int] }
    # 
    # Waits at most <code>millis</code> milliseconds plus
    # <code>nanos</code> nanoseconds for this thread to die.
    # 
    # @param      millis   the time to wait in milliseconds.
    # @param      nanos    0-999999 additional nanoseconds to wait.
    # @exception  IllegalArgumentException  if the value of millis is negative
    # the value of nanos is not in the range 0-999999.
    # @exception  InterruptedException if any thread has interrupted
    # the current thread.  The <i>interrupted status</i> of the
    # current thread is cleared when this exception is thrown.
    def join(millis, nanos)
      synchronized(self) do
        if (millis < 0)
          raise IllegalArgumentException.new("timeout value is negative")
        end
        if (nanos < 0 || nanos > 999999)
          raise IllegalArgumentException.new("nanosecond timeout value out of range")
        end
        if (nanos >= 500000 || (!(nanos).equal?(0) && (millis).equal?(0)))
          ((millis += 1) - 1)
        end
        join(millis)
      end
    end
    
    typesig { [] }
    # 
    # Waits for this thread to die.
    # 
    # @exception  InterruptedException if any thread has interrupted
    # the current thread.  The <i>interrupted status</i> of the
    # current thread is cleared when this exception is thrown.
    def join
      join(0)
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Prints a stack trace of the current thread to the standard error stream.
      # This method is used only for debugging.
      # 
      # @see     Throwable#printStackTrace()
      def dump_stack
        Exception.new("Stack trace").print_stack_trace
      end
    }
    
    typesig { [::Java::Boolean] }
    # 
    # Marks this thread as either a daemon thread or a user thread. The
    # Java Virtual Machine exits when the only threads running are all
    # daemon threads.
    # <p>
    # This method must be called before the thread is started.
    # <p>
    # This method first calls the <code>checkAccess</code> method
    # of this thread
    # with no arguments. This may result in throwing a
    # <code>SecurityException </code>(in the current thread).
    # 
    # @param      on   if <code>true</code>, marks this thread as a
    # daemon thread.
    # @exception  IllegalThreadStateException  if this thread is active.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread.
    # @see        #isDaemon()
    # @see        #checkAccess
    def set_daemon(on)
      check_access
      if (is_alive)
        raise IllegalThreadStateException.new
      end
      @daemon = on
    end
    
    typesig { [] }
    # 
    # Tests if this thread is a daemon thread.
    # 
    # @return  <code>true</code> if this thread is a daemon thread;
    # <code>false</code> otherwise.
    # @see     #setDaemon(boolean)
    def is_daemon
      return @daemon
    end
    
    typesig { [] }
    # 
    # Determines if the currently running thread has permission to
    # modify this thread.
    # <p>
    # If there is a security manager, its <code>checkAccess</code> method
    # is called with this thread as its argument. This may result in
    # throwing a <code>SecurityException</code>.
    # 
    # @exception  SecurityException  if the current thread is not allowed to
    # access this thread.
    # @see        SecurityManager#checkAccess(Thread)
    def check_access
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_access(self)
      end
    end
    
    typesig { [] }
    # 
    # Returns a string representation of this thread, including the
    # thread's name, priority, and thread group.
    # 
    # @return  a string representation of this thread.
    def to_s
      group = get_thread_group
      if (!(group).nil?)
        return "Thread[" + (get_name).to_s + "," + (get_priority).to_s + "," + (group.get_name).to_s + "]"
      else
        return "Thread[" + (get_name).to_s + "," + (get_priority).to_s + "," + "" + "]"
      end
    end
    
    typesig { [] }
    # 
    # Returns the context ClassLoader for this Thread. The context
    # ClassLoader is provided by the creator of the thread for use
    # by code running in this thread when loading classes and resources.
    # If not set, the default is the ClassLoader context of the parent
    # Thread. The context ClassLoader of the primordial thread is
    # typically set to the class loader used to load the application.
    # 
    # <p>First, if there is a security manager, and the caller's class
    # loader is not null and the caller's class loader is not the same as or
    # an ancestor of the context class loader for the thread whose
    # context class loader is being requested, then the security manager's
    # <code>checkPermission</code>
    # method is called with a
    # <code>RuntimePermission("getClassLoader")</code> permission
    # to see if it's ok to get the context ClassLoader..
    # 
    # @return the context ClassLoader for this Thread
    # 
    # @throws SecurityException
    # if a security manager exists and its
    # <code>checkPermission</code> method doesn't allow
    # getting the context ClassLoader.
    # @see #setContextClassLoader
    # @see SecurityManager#checkPermission
    # @see RuntimePermission
    # 
    # @since 1.2
    def get_context_class_loader
      if ((@context_class_loader).nil?)
        return nil
      end
      sm = System.get_security_manager
      if (!(sm).nil?)
        ccl = ClassLoader.get_caller_class_loader
        if (!(ccl).nil? && !(ccl).equal?(@context_class_loader) && !@context_class_loader.is_ancestor(ccl))
          sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
        end
      end
      return @context_class_loader
    end
    
    typesig { [ClassLoader] }
    # 
    # Sets the context ClassLoader for this Thread. The context
    # ClassLoader can be set when a thread is created, and allows
    # the creator of the thread to provide the appropriate class loader
    # to code running in the thread when loading classes and resources.
    # 
    # <p>First, if there is a security manager, its <code>checkPermission</code>
    # method is called with a
    # <code>RuntimePermission("setContextClassLoader")</code> permission
    # to see if it's ok to set the context ClassLoader..
    # 
    # @param cl the context ClassLoader for this Thread
    # 
    # @exception  SecurityException  if the current thread cannot set the
    # context ClassLoader.
    # @see #getContextClassLoader
    # @see SecurityManager#checkPermission
    # @see RuntimePermission
    # 
    # @since 1.2
    def set_context_class_loader(cl)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(RuntimePermission.new("setContextClassLoader"))
      end
      @context_class_loader = cl
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Thread_holdsLock, [:pointer, :long, :long], :int8
      typesig { [Object] }
      # 
      # Returns <tt>true</tt> if and only if the current thread holds the
      # monitor lock on the specified object.
      # 
      # <p>This method is designed to allow a program to assert that
      # the current thread already holds a specified lock:
      # <pre>
      # assert Thread.holdsLock(obj);
      # </pre>
      # 
      # @param  obj the object on which to test lock ownership
      # @throws NullPointerException if obj is <tt>null</tt>
      # @return <tt>true</tt> if the current thread holds the monitor lock on
      # the specified object.
      # @since 1.4
      def holds_lock(obj)
        JNI.__send__(:Java_java_lang_Thread_holdsLock, JNI.env, self.jni_id, obj.jni_id) != 0
      end
      
      const_set_lazy(:EMPTY_STACK_TRACE) { Array.typed(StackTraceElement).new(0) { nil } }
      const_attr_reader  :EMPTY_STACK_TRACE
    }
    
    typesig { [] }
    # 
    # Returns an array of stack trace elements representing the stack dump
    # of this thread.  This method will return a zero-length array if
    # this thread has not started or has terminated.
    # If the returned array is of non-zero length then the first element of
    # the array represents the top of the stack, which is the most recent
    # method invocation in the sequence.  The last element of the array
    # represents the bottom of the stack, which is the least recent method
    # invocation in the sequence.
    # 
    # <p>If there is a security manager, and this thread is not
    # the current thread, then the security manager's
    # <tt>checkPermission</tt> method is called with a
    # <tt>RuntimePermission("getStackTrace")</tt> permission
    # to see if it's ok to get the stack trace.
    # 
    # <p>Some virtual machines may, under some circumstances, omit one
    # or more stack frames from the stack trace.  In the extreme case,
    # a virtual machine that has no stack trace information concerning
    # this thread is permitted to return a zero-length array from this
    # method.
    # 
    # @return an array of <tt>StackTraceElement</tt>,
    # each represents one stack frame.
    # 
    # @throws SecurityException
    # if a security manager exists and its
    # <tt>checkPermission</tt> method doesn't allow
    # getting the stack trace of thread.
    # @see SecurityManager#checkPermission
    # @see RuntimePermission
    # @see Throwable#getStackTrace
    # 
    # @since 1.5
    def get_stack_trace
      if (!(self).equal?(JavaThread.current_thread))
        # check for getStackTrace permission
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_permission(SecurityConstants::GET_STACK_TRACE_PERMISSION)
        end
        # optimization so we do not call into the vm for threads that
        # have not yet started or have terminated
        if (!is_alive)
          return EMPTY_STACK_TRACE
        end
        stack_trace_array = dump_threads(Array.typed(JavaThread).new([self]))
        stack_trace = stack_trace_array[0]
        # a thread that was alive during the previous isAlive call may have
        # since terminated, therefore not having a stacktrace.
        if ((stack_trace).nil?)
          stack_trace = EMPTY_STACK_TRACE
        end
        return stack_trace
      else
        # Don't need JVM help for current thread
        return (Exception.new).get_stack_trace
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Returns a map of stack traces for all live threads.
      # The map keys are threads and each map value is an array of
      # <tt>StackTraceElement</tt> that represents the stack dump
      # of the corresponding <tt>Thread</tt>.
      # The returned stack traces are in the format specified for
      # the {@link #getStackTrace getStackTrace} method.
      # 
      # <p>The threads may be executing while this method is called.
      # The stack trace of each thread only represents a snapshot and
      # each stack trace may be obtained at different time.  A zero-length
      # array will be returned in the map value if the virtual machine has
      # no stack trace information about a thread.
      # 
      # <p>If there is a security manager, then the security manager's
      # <tt>checkPermission</tt> method is called with a
      # <tt>RuntimePermission("getStackTrace")</tt> permission as well as
      # <tt>RuntimePermission("modifyThreadGroup")</tt> permission
      # to see if it is ok to get the stack trace of all threads.
      # 
      # @return a <tt>Map</tt> from <tt>Thread</tt> to an array of
      # <tt>StackTraceElement</tt> that represents the stack trace of
      # the corresponding thread.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <tt>checkPermission</tt> method doesn't allow
      # getting the stack trace of thread.
      # @see #getStackTrace
      # @see SecurityManager#checkPermission
      # @see RuntimePermission
      # @see Throwable#getStackTrace
      # 
      # @since 1.5
      def get_all_stack_traces
        # check for getStackTrace permission
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_permission(SecurityConstants::GET_STACK_TRACE_PERMISSION)
          security.check_permission(SecurityConstants::MODIFY_THREADGROUP_PERMISSION)
        end
        # Get a snapshot of the list of all threads
        threads = get_threads
        traces = dump_threads(threads)
        m = HashMap.new(threads.attr_length)
        i = 0
        while i < threads.attr_length
          stack_trace = traces[i]
          if (!(stack_trace).nil?)
            m.put(threads[i], stack_trace)
          end
          ((i += 1) - 1)
        end
        return m
      end
      
      const_set_lazy(:SUBCLASS_IMPLEMENTATION_PERMISSION) { RuntimePermission.new("enableContextClassLoaderOverride") }
      const_attr_reader  :SUBCLASS_IMPLEMENTATION_PERMISSION
      
      # cache of subclass security audit results
      const_set_lazy(:SubclassAudits) { SoftCache.new(10) }
      const_attr_reader  :SubclassAudits
      
      typesig { [Class] }
      # 
      # Verifies that this (possibly subclass) instance can be constructed
      # without violating security constraints: the subclass must not override
      # security-sensitive non-final methods, or else the
      # "enableContextClassLoaderOverride" RuntimePermission is checked.
      def is_ccloverridden(cl)
        if ((cl).equal?(JavaThread.class))
          return false
        end
        result = nil
        synchronized((SubclassAudits)) do
          result = SubclassAudits.get(cl)
          if ((result).nil?)
            # 
            # Note: only new Boolean instances (i.e., not Boolean.TRUE or
            # Boolean.FALSE) must be used as cache values, otherwise cache
            # entry will pin associated class.
            result = Boolean.new(audit_subclass(cl))
            SubclassAudits.put(cl, result)
          end
        end
        return result.boolean_value
      end
      
      typesig { [Class] }
      # 
      # Performs reflective checks on given subclass to verify that it doesn't
      # override security-sensitive non-final methods.  Returns true if the
      # subclass overrides any of the methods, false otherwise.
      def audit_subclass(subcl)
        result = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members JavaThread
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            cl = subcl
            while !(cl).equal?(JavaThread.class)
              begin
                cl.get_declared_method("getContextClassLoader", Array.typed(Class).new(0) { nil })
                return Boolean::TRUE
              rescue NoSuchMethodException => ex
              end
              begin
                params = Array.typed(Class).new([ClassLoader.class])
                cl.get_declared_method("setContextClassLoader", params)
                return Boolean::TRUE
              rescue NoSuchMethodException => ex
              end
              cl = cl.get_superclass
            end
            return Boolean::FALSE
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return result.boolean_value
      end
      
      JNI.native_method :Java_java_lang_Thread_dumpThreads, [:pointer, :long, :long], :long
      typesig { [Array.typed(JavaThread)] }
      def dump_threads(threads)
        JNI.__send__(:Java_java_lang_Thread_dumpThreads, JNI.env, self.jni_id, threads.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Thread_getThreads, [:pointer, :long], :long
      typesig { [] }
      def get_threads
        JNI.__send__(:Java_java_lang_Thread_getThreads, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    # 
    # Returns the identifier of this Thread.  The thread ID is a positive
    # <tt>long</tt> number generated when this thread was created.
    # The thread ID is unique and remains unchanged during its lifetime.
    # When a thread is terminated, this thread ID may be reused.
    # 
    # @return this thread's ID.
    # @since 1.5
    def get_id
      return @tid
    end
    
    class_module.module_eval {
      const_set_lazy(:NEW) { State::NEW }
      const_attr_reader  :NEW
      
      const_set_lazy(:RUNNABLE) { State::RUNNABLE }
      const_attr_reader  :RUNNABLE
      
      const_set_lazy(:BLOCKED) { State::BLOCKED }
      const_attr_reader  :BLOCKED
      
      const_set_lazy(:WAITING) { State::WAITING }
      const_attr_reader  :WAITING
      
      const_set_lazy(:TIMED_WAITING) { State::TIMED_WAITING }
      const_attr_reader  :TIMED_WAITING
      
      const_set_lazy(:TERMINATED) { State::TERMINATED }
      const_attr_reader  :TERMINATED
      
      # 
      # A thread state.  A thread can be in one of the following states:
      # <ul>
      # <li>{@link #NEW}<br>
      # A thread that has not yet started is in this state.
      # </li>
      # <li>{@link #RUNNABLE}<br>
      # A thread executing in the Java virtual machine is in this state.
      # </li>
      # <li>{@link #BLOCKED}<br>
      # A thread that is blocked waiting for a monitor lock
      # is in this state.
      # </li>
      # <li>{@link #WAITING}<br>
      # A thread that is waiting indefinitely for another thread to
      # perform a particular action is in this state.
      # </li>
      # <li>{@link #TIMED_WAITING}<br>
      # A thread that is waiting for another thread to perform an action
      # for up to a specified waiting time is in this state.
      # </li>
      # <li>{@link #TERMINATED}<br>
      # A thread that has exited is in this state.
      # </li>
      # </ul>
      # 
      # <p>
      # A thread can be in only one state at a given point in time.
      # These states are virtual machine states which do not reflect
      # any operating system thread states.
      # 
      # @since   1.5
      # @see #getState
      class State 
        include_class_members JavaThread
        
        class_module.module_eval {
          # 
          # Thread state for a thread which has not yet started.
          const_set_lazy(:NEW) { State.new.set_value_name("NEW") }
          const_attr_reader  :NEW
          
          # 
          # Thread state for a runnable thread.  A thread in the runnable
          # state is executing in the Java virtual machine but it may
          # be waiting for other resources from the operating system
          # such as processor.
          const_set_lazy(:RUNNABLE) { State.new.set_value_name("RUNNABLE") }
          const_attr_reader  :RUNNABLE
          
          # 
          # Thread state for a thread blocked waiting for a monitor lock.
          # A thread in the blocked state is waiting for a monitor lock
          # to enter a synchronized block/method or
          # reenter a synchronized block/method after calling
          # {@link Object#wait() Object.wait}.
          const_set_lazy(:BLOCKED) { State.new.set_value_name("BLOCKED") }
          const_attr_reader  :BLOCKED
          
          # 
          # Thread state for a waiting thread.
          # A thread is in the waiting state due to calling one of the
          # following methods:
          # <ul>
          # <li>{@link Object#wait() Object.wait} with no timeout</li>
          # <li>{@link #join() Thread.join} with no timeout</li>
          # <li>{@link LockSupport#park() LockSupport.park}</li>
          # </ul>
          # 
          # <p>A thread in the waiting state is waiting for another thread to
          # perform a particular action.
          # 
          # For example, a thread that has called <tt>Object.wait()</tt>
          # on an object is waiting for another thread to call
          # <tt>Object.notify()</tt> or <tt>Object.notifyAll()</tt> on
          # that object. A thread that has called <tt>Thread.join()</tt>
          # is waiting for a specified thread to terminate.
          const_set_lazy(:WAITING) { State.new.set_value_name("WAITING") }
          const_attr_reader  :WAITING
          
          # 
          # Thread state for a waiting thread with a specified waiting time.
          # A thread is in the timed waiting state due to calling one of
          # the following methods with a specified positive waiting time:
          # <ul>
          # <li>{@link #sleep Thread.sleep}</li>
          # <li>{@link Object#wait(long) Object.wait} with timeout</li>
          # <li>{@link #join(long) Thread.join} with timeout</li>
          # <li>{@link LockSupport#parkNanos LockSupport.parkNanos}</li>
          # <li>{@link LockSupport#parkUntil LockSupport.parkUntil}</li>
          # </ul>
          const_set_lazy(:TIMED_WAITING) { State.new.set_value_name("TIMED_WAITING") }
          const_attr_reader  :TIMED_WAITING
          
          # 
          # Thread state for a terminated thread.
          # The thread has completed execution.
          const_set_lazy(:TERMINATED) { State.new.set_value_name("TERMINATED") }
          const_attr_reader  :TERMINATED
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [NEW, RUNNABLE, BLOCKED, WAITING, TIMED_WAITING, TERMINATED]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__state, :initialize
      end
    }
    
    typesig { [] }
    # 
    # Returns the state of this thread.
    # This method is designed for use in monitoring of the system state,
    # not for synchronization control.
    # 
    # @return this thread's state.
    # @since 1.5
    def get_state
      # get current thread state
      return Sun::Misc::VM.to_thread_state(@thread_status)
    end
    
    class_module.module_eval {
      # Added in JSR-166
      # 
      # Interface for handlers invoked when a <tt>Thread</tt> abruptly
      # terminates due to an uncaught exception.
      # <p>When a thread is about to terminate due to an uncaught exception
      # the Java Virtual Machine will query the thread for its
      # <tt>UncaughtExceptionHandler</tt> using
      # {@link #getUncaughtExceptionHandler} and will invoke the handler's
      # <tt>uncaughtException</tt> method, passing the thread and the
      # exception as arguments.
      # If a thread has not had its <tt>UncaughtExceptionHandler</tt>
      # explicitly set, then its <tt>ThreadGroup</tt> object acts as its
      # <tt>UncaughtExceptionHandler</tt>. If the <tt>ThreadGroup</tt> object
      # has no
      # special requirements for dealing with the exception, it can forward
      # the invocation to the {@linkplain #getDefaultUncaughtExceptionHandler
      # default uncaught exception handler}.
      # 
      # @see #setDefaultUncaughtExceptionHandler
      # @see #setUncaughtExceptionHandler
      # @see ThreadGroup#uncaughtException
      # @since 1.5
      const_set_lazy(:UncaughtExceptionHandler) { Module.new do
        include_class_members JavaThread
        
        typesig { [JavaThread, Exception] }
        # 
        # Method invoked when the given thread terminates due to the
        # given uncaught exception.
        # <p>Any exception thrown by this method will be ignored by the
        # Java Virtual Machine.
        # @param t the thread
        # @param e the exception
        def uncaught_exception(t, e)
          raise NotImplementedError
        end
      end }
    }
    
    # null unless explicitly set
    attr_accessor :uncaught_exception_handler
    alias_method :attr_uncaught_exception_handler, :uncaught_exception_handler
    undef_method :uncaught_exception_handler
    alias_method :attr_uncaught_exception_handler=, :uncaught_exception_handler=
    undef_method :uncaught_exception_handler=
    
    class_module.module_eval {
      # null unless explicitly set
      
      def default_uncaught_exception_handler
        defined?(@@default_uncaught_exception_handler) ? @@default_uncaught_exception_handler : @@default_uncaught_exception_handler= nil
      end
      alias_method :attr_default_uncaught_exception_handler, :default_uncaught_exception_handler
      
      def default_uncaught_exception_handler=(value)
        @@default_uncaught_exception_handler = value
      end
      alias_method :attr_default_uncaught_exception_handler=, :default_uncaught_exception_handler=
      
      typesig { [UncaughtExceptionHandler] }
      # 
      # Set the default handler invoked when a thread abruptly terminates
      # due to an uncaught exception, and no other handler has been defined
      # for that thread.
      # 
      # <p>Uncaught exception handling is controlled first by the thread, then
      # by the thread's {@link ThreadGroup} object and finally by the default
      # uncaught exception handler. If the thread does not have an explicit
      # uncaught exception handler set, and the thread's thread group
      # (including parent thread groups)  does not specialize its
      # <tt>uncaughtException</tt> method, then the default handler's
      # <tt>uncaughtException</tt> method will be invoked.
      # <p>By setting the default uncaught exception handler, an application
      # can change the way in which uncaught exceptions are handled (such as
      # logging to a specific device, or file) for those threads that would
      # already accept whatever &quot;default&quot; behavior the system
      # provided.
      # 
      # <p>Note that the default uncaught exception handler should not usually
      # defer to the thread's <tt>ThreadGroup</tt> object, as that could cause
      # infinite recursion.
      # 
      # @param eh the object to use as the default uncaught exception handler.
      # If <tt>null</tt> then there is no default handler.
      # 
      # @throws SecurityException if a security manager is present and it
      # denies <tt>{@link RuntimePermission}
      # (&quot;setDefaultUncaughtExceptionHandler&quot;)</tt>
      # 
      # @see #setUncaughtExceptionHandler
      # @see #getUncaughtExceptionHandler
      # @see ThreadGroup#uncaughtException
      # @since 1.5
      def set_default_uncaught_exception_handler(eh)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(RuntimePermission.new("setDefaultUncaughtExceptionHandler"))
        end
        self.attr_default_uncaught_exception_handler = eh
      end
      
      typesig { [] }
      # 
      # Returns the default handler invoked when a thread abruptly terminates
      # due to an uncaught exception. If the returned value is <tt>null</tt>,
      # there is no default.
      # @since 1.5
      # @see #setDefaultUncaughtExceptionHandler
      def get_default_uncaught_exception_handler
        return self.attr_default_uncaught_exception_handler
      end
    }
    
    typesig { [] }
    # 
    # Returns the handler invoked when this thread abruptly terminates
    # due to an uncaught exception. If this thread has not had an
    # uncaught exception handler explicitly set then this thread's
    # <tt>ThreadGroup</tt> object is returned, unless this thread
    # has terminated, in which case <tt>null</tt> is returned.
    # @since 1.5
    def get_uncaught_exception_handler
      return !(@uncaught_exception_handler).nil? ? @uncaught_exception_handler : @group
    end
    
    typesig { [UncaughtExceptionHandler] }
    # 
    # Set the handler invoked when this thread abruptly terminates
    # due to an uncaught exception.
    # <p>A thread can take full control of how it responds to uncaught
    # exceptions by having its uncaught exception handler explicitly set.
    # If no such handler is set then the thread's <tt>ThreadGroup</tt>
    # object acts as its handler.
    # @param eh the object to use as this thread's uncaught exception
    # handler. If <tt>null</tt> then this thread has no explicit handler.
    # @throws  SecurityException  if the current thread is not allowed to
    # modify this thread.
    # @see #setDefaultUncaughtExceptionHandler
    # @see ThreadGroup#uncaughtException
    # @since 1.5
    def set_uncaught_exception_handler(eh)
      check_access
      @uncaught_exception_handler = eh
    end
    
    typesig { [Exception] }
    # 
    # Dispatch an uncaught exception to the handler. This method is
    # intended to be called only by the JVM.
    def dispatch_uncaught_exception(e)
      get_uncaught_exception_handler.uncaught_exception(self, e)
    end
    
    JNI.native_method :Java_java_lang_Thread_setPriority0, [:pointer, :long, :int32], :void
    typesig { [::Java::Int] }
    # Some private helper methods
    def set_priority0(new_priority)
      JNI.__send__(:Java_java_lang_Thread_setPriority0, JNI.env, self.jni_id, new_priority.to_int)
    end
    
    JNI.native_method :Java_java_lang_Thread_stop0, [:pointer, :long, :long], :void
    typesig { [Object] }
    def stop0(o)
      JNI.__send__(:Java_java_lang_Thread_stop0, JNI.env, self.jni_id, o.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Thread_suspend0, [:pointer, :long], :void
    typesig { [] }
    def suspend0
      JNI.__send__(:Java_java_lang_Thread_suspend0, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Thread_resume0, [:pointer, :long], :void
    typesig { [] }
    def resume0
      JNI.__send__(:Java_java_lang_Thread_resume0, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Thread_interrupt0, [:pointer, :long], :void
    typesig { [] }
    def interrupt0
      JNI.__send__(:Java_java_lang_Thread_interrupt0, JNI.env, self.jni_id)
    end
    
    private
    alias_method :initialize__thread, :initialize
  end
  
end

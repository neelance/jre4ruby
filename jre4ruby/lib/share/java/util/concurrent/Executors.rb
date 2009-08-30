require "rjava"

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
# 
# 
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module ExecutorsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :AccessControlException
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # Factory and utility methods for {@link Executor}, {@link
  # ExecutorService}, {@link ScheduledExecutorService}, {@link
  # ThreadFactory}, and {@link Callable} classes defined in this
  # package. This class supports the following kinds of methods:
  # 
  # <ul>
  # <li> Methods that create and return an {@link ExecutorService}
  # set up with commonly useful configuration settings.
  # <li> Methods that create and return a {@link ScheduledExecutorService}
  # set up with commonly useful configuration settings.
  # <li> Methods that create and return a "wrapped" ExecutorService, that
  # disables reconfiguration by making implementation-specific methods
  # inaccessible.
  # <li> Methods that create and return a {@link ThreadFactory}
  # that sets newly created threads to a known state.
  # <li> Methods that create and return a {@link Callable}
  # out of other closure-like forms, so they can be used
  # in execution methods requiring <tt>Callable</tt>.
  # </ul>
  # 
  # @since 1.5
  # @author Doug Lea
  class Executors 
    include_class_members ExecutorsImports
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Creates a thread pool that reuses a fixed number of threads
      # operating off a shared unbounded queue.  At any point, at most
      # <tt>nThreads</tt> threads will be active processing tasks.
      # If additional tasks are submitted when all threads are active,
      # they will wait in the queue until a thread is available.
      # If any thread terminates due to a failure during execution
      # prior to shutdown, a new one will take its place if needed to
      # execute subsequent tasks.  The threads in the pool will exist
      # until it is explicitly {@link ExecutorService#shutdown shutdown}.
      # 
      # @param nThreads the number of threads in the pool
      # @return the newly created thread pool
      # @throws IllegalArgumentException if <tt>nThreads &lt;= 0</tt>
      def new_fixed_thread_pool(n_threads)
        return ThreadPoolExecutor.new(n_threads, n_threads, 0, TimeUnit::MILLISECONDS, LinkedBlockingQueue.new)
      end
      
      typesig { [::Java::Int, ThreadFactory] }
      # Creates a thread pool that reuses a fixed number of threads
      # operating off a shared unbounded queue, using the provided
      # ThreadFactory to create new threads when needed.  At any point,
      # at most <tt>nThreads</tt> threads will be active processing
      # tasks.  If additional tasks are submitted when all threads are
      # active, they will wait in the queue until a thread is
      # available.  If any thread terminates due to a failure during
      # execution prior to shutdown, a new one will take its place if
      # needed to execute subsequent tasks.  The threads in the pool will
      # exist until it is explicitly {@link ExecutorService#shutdown
      # shutdown}.
      # 
      # @param nThreads the number of threads in the pool
      # @param threadFactory the factory to use when creating new threads
      # @return the newly created thread pool
      # @throws NullPointerException if threadFactory is null
      # @throws IllegalArgumentException if <tt>nThreads &lt;= 0</tt>
      def new_fixed_thread_pool(n_threads, thread_factory)
        return ThreadPoolExecutor.new(n_threads, n_threads, 0, TimeUnit::MILLISECONDS, LinkedBlockingQueue.new, thread_factory)
      end
      
      typesig { [] }
      # Creates an Executor that uses a single worker thread operating
      # off an unbounded queue. (Note however that if this single
      # thread terminates due to a failure during execution prior to
      # shutdown, a new one will take its place if needed to execute
      # subsequent tasks.)  Tasks are guaranteed to execute
      # sequentially, and no more than one task will be active at any
      # given time. Unlike the otherwise equivalent
      # <tt>newFixedThreadPool(1)</tt> the returned executor is
      # guaranteed not to be reconfigurable to use additional threads.
      # 
      # @return the newly created single-threaded Executor
      def new_single_thread_executor
        return FinalizableDelegatedExecutorService.new(ThreadPoolExecutor.new(1, 1, 0, TimeUnit::MILLISECONDS, LinkedBlockingQueue.new))
      end
      
      typesig { [ThreadFactory] }
      # Creates an Executor that uses a single worker thread operating
      # off an unbounded queue, and uses the provided ThreadFactory to
      # create a new thread when needed. Unlike the otherwise
      # equivalent <tt>newFixedThreadPool(1, threadFactory)</tt> the
      # returned executor is guaranteed not to be reconfigurable to use
      # additional threads.
      # 
      # @param threadFactory the factory to use when creating new
      # threads
      # 
      # @return the newly created single-threaded Executor
      # @throws NullPointerException if threadFactory is null
      def new_single_thread_executor(thread_factory)
        return FinalizableDelegatedExecutorService.new(ThreadPoolExecutor.new(1, 1, 0, TimeUnit::MILLISECONDS, LinkedBlockingQueue.new, thread_factory))
      end
      
      typesig { [] }
      # Creates a thread pool that creates new threads as needed, but
      # will reuse previously constructed threads when they are
      # available.  These pools will typically improve the performance
      # of programs that execute many short-lived asynchronous tasks.
      # Calls to <tt>execute</tt> will reuse previously constructed
      # threads if available. If no existing thread is available, a new
      # thread will be created and added to the pool. Threads that have
      # not been used for sixty seconds are terminated and removed from
      # the cache. Thus, a pool that remains idle for long enough will
      # not consume any resources. Note that pools with similar
      # properties but different details (for example, timeout parameters)
      # may be created using {@link ThreadPoolExecutor} constructors.
      # 
      # @return the newly created thread pool
      def new_cached_thread_pool
        return ThreadPoolExecutor.new(0, JavaInteger::MAX_VALUE, 60, TimeUnit::SECONDS, SynchronousQueue.new)
      end
      
      typesig { [ThreadFactory] }
      # Creates a thread pool that creates new threads as needed, but
      # will reuse previously constructed threads when they are
      # available, and uses the provided
      # ThreadFactory to create new threads when needed.
      # @param threadFactory the factory to use when creating new threads
      # @return the newly created thread pool
      # @throws NullPointerException if threadFactory is null
      def new_cached_thread_pool(thread_factory)
        return ThreadPoolExecutor.new(0, JavaInteger::MAX_VALUE, 60, TimeUnit::SECONDS, SynchronousQueue.new, thread_factory)
      end
      
      typesig { [] }
      # Creates a single-threaded executor that can schedule commands
      # to run after a given delay, or to execute periodically.
      # (Note however that if this single
      # thread terminates due to a failure during execution prior to
      # shutdown, a new one will take its place if needed to execute
      # subsequent tasks.)  Tasks are guaranteed to execute
      # sequentially, and no more than one task will be active at any
      # given time. Unlike the otherwise equivalent
      # <tt>newScheduledThreadPool(1)</tt> the returned executor is
      # guaranteed not to be reconfigurable to use additional threads.
      # @return the newly created scheduled executor
      def new_single_thread_scheduled_executor
        return DelegatedScheduledExecutorService.new(ScheduledThreadPoolExecutor.new(1))
      end
      
      typesig { [ThreadFactory] }
      # Creates a single-threaded executor that can schedule commands
      # to run after a given delay, or to execute periodically.  (Note
      # however that if this single thread terminates due to a failure
      # during execution prior to shutdown, a new one will take its
      # place if needed to execute subsequent tasks.)  Tasks are
      # guaranteed to execute sequentially, and no more than one task
      # will be active at any given time. Unlike the otherwise
      # equivalent <tt>newScheduledThreadPool(1, threadFactory)</tt>
      # the returned executor is guaranteed not to be reconfigurable to
      # use additional threads.
      # @param threadFactory the factory to use when creating new
      # threads
      # @return a newly created scheduled executor
      # @throws NullPointerException if threadFactory is null
      def new_single_thread_scheduled_executor(thread_factory)
        return DelegatedScheduledExecutorService.new(ScheduledThreadPoolExecutor.new(1, thread_factory))
      end
      
      typesig { [::Java::Int] }
      # Creates a thread pool that can schedule commands to run after a
      # given delay, or to execute periodically.
      # @param corePoolSize the number of threads to keep in the pool,
      # even if they are idle.
      # @return a newly created scheduled thread pool
      # @throws IllegalArgumentException if <tt>corePoolSize &lt; 0</tt>
      def new_scheduled_thread_pool(core_pool_size)
        return ScheduledThreadPoolExecutor.new(core_pool_size)
      end
      
      typesig { [::Java::Int, ThreadFactory] }
      # Creates a thread pool that can schedule commands to run after a
      # given delay, or to execute periodically.
      # @param corePoolSize the number of threads to keep in the pool,
      # even if they are idle.
      # @param threadFactory the factory to use when the executor
      # creates a new thread.
      # @return a newly created scheduled thread pool
      # @throws IllegalArgumentException if <tt>corePoolSize &lt; 0</tt>
      # @throws NullPointerException if threadFactory is null
      def new_scheduled_thread_pool(core_pool_size, thread_factory)
        return ScheduledThreadPoolExecutor.new(core_pool_size, thread_factory)
      end
      
      typesig { [ExecutorService] }
      # Returns an object that delegates all defined {@link
      # ExecutorService} methods to the given executor, but not any
      # other methods that might otherwise be accessible using
      # casts. This provides a way to safely "freeze" configuration and
      # disallow tuning of a given concrete implementation.
      # @param executor the underlying implementation
      # @return an <tt>ExecutorService</tt> instance
      # @throws NullPointerException if executor null
      def unconfigurable_executor_service(executor)
        if ((executor).nil?)
          raise NullPointerException.new
        end
        return DelegatedExecutorService.new(executor)
      end
      
      typesig { [ScheduledExecutorService] }
      # Returns an object that delegates all defined {@link
      # ScheduledExecutorService} methods to the given executor, but
      # not any other methods that might otherwise be accessible using
      # casts. This provides a way to safely "freeze" configuration and
      # disallow tuning of a given concrete implementation.
      # @param executor the underlying implementation
      # @return a <tt>ScheduledExecutorService</tt> instance
      # @throws NullPointerException if executor null
      def unconfigurable_scheduled_executor_service(executor)
        if ((executor).nil?)
          raise NullPointerException.new
        end
        return DelegatedScheduledExecutorService.new(executor)
      end
      
      typesig { [] }
      # Returns a default thread factory used to create new threads.
      # This factory creates all new threads used by an Executor in the
      # same {@link ThreadGroup}. If there is a {@link
      # java.lang.SecurityManager}, it uses the group of {@link
      # System#getSecurityManager}, else the group of the thread
      # invoking this <tt>defaultThreadFactory</tt> method. Each new
      # thread is created as a non-daemon thread with priority set to
      # the smaller of <tt>Thread.NORM_PRIORITY</tt> and the maximum
      # priority permitted in the thread group.  New threads have names
      # accessible via {@link Thread#getName} of
      # <em>pool-N-thread-M</em>, where <em>N</em> is the sequence
      # number of this factory, and <em>M</em> is the sequence number
      # of the thread created by this factory.
      # @return a thread factory
      def default_thread_factory
        return DefaultThreadFactory.new
      end
      
      typesig { [] }
      # Returns a thread factory used to create new threads that
      # have the same permissions as the current thread.
      # This factory creates threads with the same settings as {@link
      # Executors#defaultThreadFactory}, additionally setting the
      # AccessControlContext and contextClassLoader of new threads to
      # be the same as the thread invoking this
      # <tt>privilegedThreadFactory</tt> method.  A new
      # <tt>privilegedThreadFactory</tt> can be created within an
      # {@link AccessController#doPrivileged} action setting the
      # current thread's access control context to create threads with
      # the selected permission settings holding within that action.
      # 
      # <p> Note that while tasks running within such threads will have
      # the same access control and class loader settings as the
      # current thread, they need not have the same {@link
      # java.lang.ThreadLocal} or {@link
      # java.lang.InheritableThreadLocal} values. If necessary,
      # particular values of thread locals can be set or reset before
      # any task runs in {@link ThreadPoolExecutor} subclasses using
      # {@link ThreadPoolExecutor#beforeExecute}. Also, if it is
      # necessary to initialize worker threads to have the same
      # InheritableThreadLocal settings as some other designated
      # thread, you can create a custom ThreadFactory in which that
      # thread waits for and services requests to create others that
      # will inherit its values.
      # 
      # @return a thread factory
      # @throws AccessControlException if the current access control
      # context does not have permission to both get and set context
      # class loader.
      def privileged_thread_factory
        return PrivilegedThreadFactory.new
      end
      
      typesig { [Runnable, T] }
      # Returns a {@link Callable} object that, when
      # called, runs the given task and returns the given result.  This
      # can be useful when applying methods requiring a
      # <tt>Callable</tt> to an otherwise resultless action.
      # @param task the task to run
      # @param result the result to return
      # @return a callable object
      # @throws NullPointerException if task null
      def callable(task, result)
        if ((task).nil?)
          raise NullPointerException.new
        end
        return RunnableAdapter.new(task, result)
      end
      
      typesig { [Runnable] }
      # Returns a {@link Callable} object that, when
      # called, runs the given task and returns <tt>null</tt>.
      # @param task the task to run
      # @return a callable object
      # @throws NullPointerException if task null
      def callable(task)
        if ((task).nil?)
          raise NullPointerException.new
        end
        return RunnableAdapter.new(task, nil)
      end
      
      typesig { [PrivilegedAction] }
      # Returns a {@link Callable} object that, when
      # called, runs the given privileged action and returns its result.
      # @param action the privileged action to run
      # @return a callable object
      # @throws NullPointerException if action null
      def callable(action)
        if ((action).nil?)
          raise NullPointerException.new
        end
        return Class.new(Callable.class == Class ? Callable : Object) do
          extend LocalClass
          include_class_members Executors
          include Callable if Callable.class == Module
          
          typesig { [] }
          define_method :call do
            return action.run
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [PrivilegedExceptionAction] }
      # Returns a {@link Callable} object that, when
      # called, runs the given privileged exception action and returns
      # its result.
      # @param action the privileged exception action to run
      # @return a callable object
      # @throws NullPointerException if action null
      def callable(action)
        if ((action).nil?)
          raise NullPointerException.new
        end
        return Class.new(Callable.class == Class ? Callable : Object) do
          extend LocalClass
          include_class_members Executors
          include Callable if Callable.class == Module
          
          typesig { [] }
          define_method :call do
            return action.run
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [Callable] }
      # Returns a {@link Callable} object that will, when
      # called, execute the given <tt>callable</tt> under the current
      # access control context. This method should normally be
      # invoked within an {@link AccessController#doPrivileged} action
      # to create callables that will, if possible, execute under the
      # selected permission settings holding within that action; or if
      # not possible, throw an associated {@link
      # AccessControlException}.
      # @param callable the underlying task
      # @return a callable object
      # @throws NullPointerException if callable null
      def privileged_callable(callable)
        if ((callable).nil?)
          raise NullPointerException.new
        end
        return PrivilegedCallable.new(callable)
      end
      
      typesig { [Callable] }
      # Returns a {@link Callable} object that will, when
      # called, execute the given <tt>callable</tt> under the current
      # access control context, with the current context class loader
      # as the context class loader. This method should normally be
      # invoked within an {@link AccessController#doPrivileged} action
      # to create callables that will, if possible, execute under the
      # selected permission settings holding within that action; or if
      # not possible, throw an associated {@link
      # AccessControlException}.
      # @param callable the underlying task
      # 
      # @return a callable object
      # @throws NullPointerException if callable null
      # @throws AccessControlException if the current access control
      # context does not have permission to both set and get context
      # class loader.
      def privileged_callable_using_current_class_loader(callable)
        if ((callable).nil?)
          raise NullPointerException.new
        end
        return PrivilegedCallableUsingCurrentClassLoader.new(callable)
      end
      
      # Non-public classes supporting the public methods
      # 
      # A callable that runs given task and returns given result
      const_set_lazy(:RunnableAdapter) { Class.new do
        include_class_members Executors
        include Callable
        
        attr_accessor :task
        alias_method :attr_task, :task
        undef_method :task
        alias_method :attr_task=, :task=
        undef_method :task=
        
        attr_accessor :result
        alias_method :attr_result, :result
        undef_method :result
        alias_method :attr_result=, :result=
        undef_method :result=
        
        typesig { [class_self::Runnable, Object] }
        def initialize(task, result)
          @task = nil
          @result = nil
          @task = task
          @result = result
        end
        
        typesig { [] }
        def call
          @task.run
          return @result
        end
        
        private
        alias_method :initialize__runnable_adapter, :initialize
      end }
      
      # A callable that runs under established access control settings
      const_set_lazy(:PrivilegedCallable) { Class.new do
        include_class_members Executors
        include Callable
        
        attr_accessor :task
        alias_method :attr_task, :task
        undef_method :task
        alias_method :attr_task=, :task=
        undef_method :task=
        
        attr_accessor :acc
        alias_method :attr_acc, :acc
        undef_method :acc
        alias_method :attr_acc=, :acc=
        undef_method :acc=
        
        typesig { [class_self::Callable] }
        def initialize(task)
          @task = nil
          @acc = nil
          @task = task
          @acc = AccessController.get_context
        end
        
        typesig { [] }
        def call
          begin
            return AccessController.do_privileged(Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members PrivilegedCallable
              include class_self::PrivilegedExceptionAction if class_self::PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                return self.attr_task.call
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self), @acc)
          rescue self.class::PrivilegedActionException => e
            raise e.get_exception
          end
        end
        
        private
        alias_method :initialize__privileged_callable, :initialize
      end }
      
      # A callable that runs under established access control settings and
      # current ClassLoader
      const_set_lazy(:PrivilegedCallableUsingCurrentClassLoader) { Class.new do
        include_class_members Executors
        include Callable
        
        attr_accessor :task
        alias_method :attr_task, :task
        undef_method :task
        alias_method :attr_task=, :task=
        undef_method :task=
        
        attr_accessor :acc
        alias_method :attr_acc, :acc
        undef_method :acc
        alias_method :attr_acc=, :acc=
        undef_method :acc=
        
        attr_accessor :ccl
        alias_method :attr_ccl, :ccl
        undef_method :ccl
        alias_method :attr_ccl=, :ccl=
        undef_method :ccl=
        
        typesig { [class_self::Callable] }
        def initialize(task)
          @task = nil
          @acc = nil
          @ccl = nil
          sm = System.get_security_manager
          if (!(sm).nil?)
            # Calls to getContextClassLoader from this class
            # never trigger a security check, but we check
            # whether our callers have this permission anyways.
            sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
            # Whether setContextClassLoader turns out to be necessary
            # or not, we fail fast if permission is not available.
            sm.check_permission(self.class::RuntimePermission.new("setContextClassLoader"))
          end
          @task = task
          @acc = AccessController.get_context
          @ccl = JavaThread.current_thread.get_context_class_loader
        end
        
        typesig { [] }
        def call
          begin
            return AccessController.do_privileged(Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members PrivilegedCallableUsingCurrentClassLoader
              include class_self::PrivilegedExceptionAction if class_self::PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                savedcl = nil
                t = JavaThread.current_thread
                begin
                  cl = t.get_context_class_loader
                  if (!(self.attr_ccl).equal?(cl))
                    t.set_context_class_loader(self.attr_ccl)
                    savedcl = cl
                  end
                  return self.attr_task.call
                ensure
                  if (!(savedcl).nil?)
                    t.set_context_class_loader(savedcl)
                  end
                end
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self), @acc)
          rescue self.class::PrivilegedActionException => e
            raise e.get_exception
          end
        end
        
        private
        alias_method :initialize__privileged_callable_using_current_class_loader, :initialize
      end }
      
      # The default thread factory
      const_set_lazy(:DefaultThreadFactory) { Class.new do
        include_class_members Executors
        include ThreadFactory
        
        class_module.module_eval {
          const_set_lazy(:PoolNumber) { class_self::AtomicInteger.new(1) }
          const_attr_reader  :PoolNumber
        }
        
        attr_accessor :group
        alias_method :attr_group, :group
        undef_method :group
        alias_method :attr_group=, :group=
        undef_method :group=
        
        attr_accessor :thread_number
        alias_method :attr_thread_number, :thread_number
        undef_method :thread_number
        alias_method :attr_thread_number=, :thread_number=
        undef_method :thread_number=
        
        attr_accessor :name_prefix
        alias_method :attr_name_prefix, :name_prefix
        undef_method :name_prefix
        alias_method :attr_name_prefix=, :name_prefix=
        undef_method :name_prefix=
        
        typesig { [] }
        def initialize
          @group = nil
          @thread_number = self.class::AtomicInteger.new(1)
          @name_prefix = nil
          s = System.get_security_manager
          @group = (!(s).nil?) ? s.get_thread_group : JavaThread.current_thread.get_thread_group
          @name_prefix = "pool-" + RJava.cast_to_string(self.class::PoolNumber.get_and_increment) + "-thread-"
        end
        
        typesig { [class_self::Runnable] }
        def new_thread(r)
          t = self.class::JavaThread.new(@group, r, @name_prefix + RJava.cast_to_string(@thread_number.get_and_increment), 0)
          if (t.is_daemon)
            t.set_daemon(false)
          end
          if (!(t.get_priority).equal?(JavaThread::NORM_PRIORITY))
            t.set_priority(JavaThread::NORM_PRIORITY)
          end
          return t
        end
        
        private
        alias_method :initialize__default_thread_factory, :initialize
      end }
      
      # Thread factory capturing access control context and class loader
      const_set_lazy(:PrivilegedThreadFactory) { Class.new(DefaultThreadFactory) do
        include_class_members Executors
        
        attr_accessor :acc
        alias_method :attr_acc, :acc
        undef_method :acc
        alias_method :attr_acc=, :acc=
        undef_method :acc=
        
        attr_accessor :ccl
        alias_method :attr_ccl, :ccl
        undef_method :ccl
        alias_method :attr_ccl=, :ccl=
        undef_method :ccl=
        
        typesig { [] }
        def initialize
          @acc = nil
          @ccl = nil
          super()
          sm = System.get_security_manager
          if (!(sm).nil?)
            # Calls to getContextClassLoader from this class
            # never trigger a security check, but we check
            # whether our callers have this permission anyways.
            sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
            # Fail fast
            sm.check_permission(self.class::RuntimePermission.new("setContextClassLoader"))
          end
          @acc = AccessController.get_context
          @ccl = JavaThread.current_thread.get_context_class_loader
        end
        
        typesig { [class_self::Runnable] }
        def new_thread(r)
          return super(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            extend LocalClass
            include_class_members PrivilegedThreadFactory
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              runnable_class = self.class
              AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
                extend LocalClass
                include_class_members runnable_class
                include class_self::PrivilegedAction if class_self::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  JavaThread.current_thread.set_context_class_loader(self.attr_ccl)
                  r.run
                  return nil
                end
                
                typesig { [Object] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self), self.attr_acc)
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        private
        alias_method :initialize__privileged_thread_factory, :initialize
      end }
      
      # A wrapper class that exposes only the ExecutorService methods
      # of an ExecutorService implementation.
      const_set_lazy(:DelegatedExecutorService) { Class.new(AbstractExecutorService) do
        include_class_members Executors
        
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        typesig { [class_self::ExecutorService] }
        def initialize(executor)
          @e = nil
          super()
          @e = executor
        end
        
        typesig { [class_self::Runnable] }
        def execute(command)
          @e.execute(command)
        end
        
        typesig { [] }
        def shutdown
          @e.shutdown
        end
        
        typesig { [] }
        def shutdown_now
          return @e.shutdown_now
        end
        
        typesig { [] }
        def is_shutdown
          return @e.is_shutdown
        end
        
        typesig { [] }
        def is_terminated
          return @e.is_terminated
        end
        
        typesig { [::Java::Long, class_self::TimeUnit] }
        def await_termination(timeout, unit)
          return @e.await_termination(timeout, unit)
        end
        
        typesig { [class_self::Runnable] }
        def submit(task)
          return @e.submit(task)
        end
        
        typesig { [class_self::Callable] }
        def submit(task)
          return @e.submit(task)
        end
        
        typesig { [class_self::Runnable, class_self::T] }
        def submit(task, result)
          return @e.submit(task, result)
        end
        
        typesig { [class_self::Collection] }
        def invoke_all(tasks)
          return @e.invoke_all(tasks)
        end
        
        typesig { [class_self::Collection, ::Java::Long, class_self::TimeUnit] }
        def invoke_all(tasks, timeout, unit)
          return @e.invoke_all(tasks, timeout, unit)
        end
        
        typesig { [class_self::Collection] }
        def invoke_any(tasks)
          return @e.invoke_any(tasks)
        end
        
        typesig { [class_self::Collection, ::Java::Long, class_self::TimeUnit] }
        def invoke_any(tasks, timeout, unit)
          return @e.invoke_any(tasks, timeout, unit)
        end
        
        private
        alias_method :initialize__delegated_executor_service, :initialize
      end }
      
      const_set_lazy(:FinalizableDelegatedExecutorService) { Class.new(DelegatedExecutorService) do
        include_class_members Executors
        
        typesig { [class_self::ExecutorService] }
        def initialize(executor)
          super(executor)
        end
        
        typesig { [] }
        def finalize
          DelegatedExecutorService.instance_method(:shutdown).bind(self).call
        end
        
        private
        alias_method :initialize__finalizable_delegated_executor_service, :initialize
      end }
      
      # A wrapper class that exposes only the ScheduledExecutorService
      # methods of a ScheduledExecutorService implementation.
      const_set_lazy(:DelegatedScheduledExecutorService) { Class.new(DelegatedExecutorService) do
        include_class_members Executors
        overload_protected {
          include ScheduledExecutorService
        }
        
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        typesig { [class_self::ScheduledExecutorService] }
        def initialize(executor)
          @e = nil
          super(executor)
          @e = executor
        end
        
        typesig { [class_self::Runnable, ::Java::Long, class_self::TimeUnit] }
        def schedule(command, delay, unit)
          return @e.schedule(command, delay, unit)
        end
        
        typesig { [class_self::Callable, ::Java::Long, class_self::TimeUnit] }
        def schedule(callable, delay, unit)
          return @e.schedule(callable, delay, unit)
        end
        
        typesig { [class_self::Runnable, ::Java::Long, ::Java::Long, class_self::TimeUnit] }
        def schedule_at_fixed_rate(command, initial_delay, period, unit)
          return @e.schedule_at_fixed_rate(command, initial_delay, period, unit)
        end
        
        typesig { [class_self::Runnable, ::Java::Long, ::Java::Long, class_self::TimeUnit] }
        def schedule_with_fixed_delay(command, initial_delay, delay, unit)
          return @e.schedule_with_fixed_delay(command, initial_delay, delay, unit)
        end
        
        private
        alias_method :initialize__delegated_scheduled_executor_service, :initialize
      end }
    }
    
    typesig { [] }
    # Cannot instantiate.
    def initialize
    end
    
    private
    alias_method :initialize__executors, :initialize
  end
  
end

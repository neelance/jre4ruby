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
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module FutureTaskImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
    }
  end
  
  # A cancellable asynchronous computation.  This class provides a base
  # implementation of {@link Future}, with methods to start and cancel
  # a computation, query to see if the computation is complete, and
  # retrieve the result of the computation.  The result can only be
  # retrieved when the computation has completed; the <tt>get</tt>
  # method will block if the computation has not yet completed.  Once
  # the computation has completed, the computation cannot be restarted
  # or cancelled.
  # 
  # <p>A <tt>FutureTask</tt> can be used to wrap a {@link Callable} or
  # {@link java.lang.Runnable} object.  Because <tt>FutureTask</tt>
  # implements <tt>Runnable</tt>, a <tt>FutureTask</tt> can be
  # submitted to an {@link Executor} for execution.
  # 
  # <p>In addition to serving as a standalone class, this class provides
  # <tt>protected</tt> functionality that may be useful when creating
  # customized task classes.
  # 
  # @since 1.5
  # @author Doug Lea
  # @param <V> The result type returned by this FutureTask's <tt>get</tt> method
  class FutureTask 
    include_class_members FutureTaskImports
    include RunnableFuture
    
    # Synchronization control for FutureTask
    attr_accessor :sync
    alias_method :attr_sync, :sync
    undef_method :sync
    alias_method :attr_sync=, :sync=
    undef_method :sync=
    
    typesig { [Callable] }
    # Creates a <tt>FutureTask</tt> that will, upon running, execute the
    # given <tt>Callable</tt>.
    # 
    # @param  callable the callable task
    # @throws NullPointerException if callable is null
    def initialize(callable)
      @sync = nil
      if ((callable).nil?)
        raise NullPointerException.new
      end
      @sync = Sync.new_local(self, callable)
    end
    
    typesig { [Runnable, Object] }
    # Creates a <tt>FutureTask</tt> that will, upon running, execute the
    # given <tt>Runnable</tt>, and arrange that <tt>get</tt> will return the
    # given result on successful completion.
    # 
    # @param runnable the runnable task
    # @param result the result to return on successful completion. If
    # you don't need a particular result, consider using
    # constructions of the form:
    # <tt>Future&lt;?&gt; f = new FutureTask&lt;Object&gt;(runnable, null)</tt>
    # @throws NullPointerException if runnable is null
    def initialize(runnable, result)
      @sync = nil
      @sync = Sync.new_local(self, Executors.callable(runnable, result))
    end
    
    typesig { [] }
    def is_cancelled
      return @sync.inner_is_cancelled
    end
    
    typesig { [] }
    def is_done
      return @sync.inner_is_done
    end
    
    typesig { [::Java::Boolean] }
    def cancel(may_interrupt_if_running)
      return @sync.inner_cancel(may_interrupt_if_running)
    end
    
    typesig { [] }
    # @throws CancellationException {@inheritDoc}
    def get
      return @sync.inner_get
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # @throws CancellationException {@inheritDoc}
    def get(timeout, unit)
      return @sync.inner_get(unit.to_nanos(timeout))
    end
    
    typesig { [] }
    # Protected method invoked when this task transitions to state
    # <tt>isDone</tt> (whether normally or via cancellation). The
    # default implementation does nothing.  Subclasses may override
    # this method to invoke completion callbacks or perform
    # bookkeeping. Note that you can query status inside the
    # implementation of this method to determine whether this task
    # has been cancelled.
    def done
    end
    
    typesig { [Object] }
    # Sets the result of this Future to the given value unless
    # this future has already been set or has been cancelled.
    # This method is invoked internally by the <tt>run</tt> method
    # upon successful completion of the computation.
    # @param v the value
    def set(v)
      @sync.inner_set(v)
    end
    
    typesig { [JavaThrowable] }
    # Causes this future to report an <tt>ExecutionException</tt>
    # with the given throwable as its cause, unless this Future has
    # already been set or has been cancelled.
    # This method is invoked internally by the <tt>run</tt> method
    # upon failure of the computation.
    # @param t the cause of failure
    def set_exception(t)
      @sync.inner_set_exception(t)
    end
    
    typesig { [] }
    # The following (duplicated) doc comment can be removed once
    # 
    # 6270645: Javadoc comments should be inherited from most derived
    #          superinterface or superclass
    # is fixed.
    # Sets this Future to the result of its computation
    # unless it has been cancelled.
    def run
      @sync.inner_run
    end
    
    typesig { [] }
    # Executes the computation without setting its result, and then
    # resets this Future to initial state, failing to do so if the
    # computation encounters an exception or is cancelled.  This is
    # designed for use with tasks that intrinsically execute more
    # than once.
    # @return true if successfully run and reset
    def run_and_reset
      return @sync.inner_run_and_reset
    end
    
    class_module.module_eval {
      # Synchronization control for FutureTask. Note that this must be
      # a non-static inner class in order to invoke the protected
      # <tt>done</tt> method. For clarity, all inner class support
      # methods are same as outer, prefixed with "inner".
      # 
      # Uses AQS sync state to represent run status
      const_set_lazy(:Sync) { Class.new(AbstractQueuedSynchronizer) do
        local_class_in FutureTask
        include_class_members FutureTask
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -7828117401763700385 }
          const_attr_reader  :SerialVersionUID
          
          # State value representing that task is ready to run
          const_set_lazy(:READY) { 0 }
          const_attr_reader  :READY
          
          # State value representing that task is running
          const_set_lazy(:RUNNING) { 1 }
          const_attr_reader  :RUNNING
          
          # State value representing that task ran
          const_set_lazy(:RAN) { 2 }
          const_attr_reader  :RAN
          
          # State value representing that task was cancelled
          const_set_lazy(:CANCELLED) { 4 }
          const_attr_reader  :CANCELLED
        }
        
        # The underlying callable
        attr_accessor :callable
        alias_method :attr_callable, :callable
        undef_method :callable
        alias_method :attr_callable=, :callable=
        undef_method :callable=
        
        # The result to return from get()
        attr_accessor :result
        alias_method :attr_result, :result
        undef_method :result
        alias_method :attr_result=, :result=
        undef_method :result=
        
        # The exception to throw from get()
        attr_accessor :exception
        alias_method :attr_exception, :exception
        undef_method :exception
        alias_method :attr_exception=, :exception=
        undef_method :exception=
        
        # The thread running task. When nulled after set/cancel, this
        # indicates that the results are accessible.  Must be
        # volatile, to ensure visibility upon completion.
        attr_accessor :runner
        alias_method :attr_runner, :runner
        undef_method :runner
        alias_method :attr_runner=, :runner=
        undef_method :runner=
        
        typesig { [class_self::Callable] }
        def initialize(callable)
          @callable = nil
          @result = nil
          @exception = nil
          @runner = nil
          super()
          @callable = callable
        end
        
        typesig { [::Java::Int] }
        def ran_or_cancelled(state)
          return !((state & (self.class::RAN | self.class::CANCELLED))).equal?(0)
        end
        
        typesig { [::Java::Int] }
        # Implements AQS base acquire to succeed if ran or cancelled
        def try_acquire_shared(ignore)
          return inner_is_done ? 1 : -1
        end
        
        typesig { [::Java::Int] }
        # Implements AQS base release to always signal after setting
        # final done status by nulling runner thread.
        def try_release_shared(ignore)
          @runner = nil
          return true
        end
        
        typesig { [] }
        def inner_is_cancelled
          return (get_state).equal?(self.class::CANCELLED)
        end
        
        typesig { [] }
        def inner_is_done
          return ran_or_cancelled(get_state) && (@runner).nil?
        end
        
        typesig { [] }
        def inner_get
          acquire_shared_interruptibly(0)
          if ((get_state).equal?(self.class::CANCELLED))
            raise self.class::CancellationException.new
          end
          if (!(@exception).nil?)
            raise self.class::ExecutionException.new(@exception)
          end
          return @result
        end
        
        typesig { [::Java::Long] }
        def inner_get(nanos_timeout)
          if (!try_acquire_shared_nanos(0, nanos_timeout))
            raise self.class::TimeoutException.new
          end
          if ((get_state).equal?(self.class::CANCELLED))
            raise self.class::CancellationException.new
          end
          if (!(@exception).nil?)
            raise self.class::ExecutionException.new(@exception)
          end
          return @result
        end
        
        typesig { [class_self::V] }
        def inner_set(v)
          loop do
            s = get_state
            if ((s).equal?(self.class::RAN))
              return
            end
            if ((s).equal?(self.class::CANCELLED))
              # aggressively release to set runner to null,
              # in case we are racing with a cancel request
              # that will try to interrupt runner
              release_shared(0)
              return
            end
            if (compare_and_set_state(s, self.class::RAN))
              @result = v
              release_shared(0)
              done
              return
            end
          end
        end
        
        typesig { [class_self::JavaThrowable] }
        def inner_set_exception(t)
          loop do
            s = get_state
            if ((s).equal?(self.class::RAN))
              return
            end
            if ((s).equal?(self.class::CANCELLED))
              # aggressively release to set runner to null,
              # in case we are racing with a cancel request
              # that will try to interrupt runner
              release_shared(0)
              return
            end
            if (compare_and_set_state(s, self.class::RAN))
              @exception = t
              release_shared(0)
              done
              return
            end
          end
        end
        
        typesig { [::Java::Boolean] }
        def inner_cancel(may_interrupt_if_running)
          loop do
            s = get_state
            if (ran_or_cancelled(s))
              return false
            end
            if (compare_and_set_state(s, self.class::CANCELLED))
              break
            end
          end
          if (may_interrupt_if_running)
            r = @runner
            if (!(r).nil?)
              r.interrupt
            end
          end
          release_shared(0)
          done
          return true
        end
        
        typesig { [] }
        def inner_run
          if (!compare_and_set_state(self.class::READY, self.class::RUNNING))
            return
          end
          @runner = JavaThread.current_thread
          if ((get_state).equal?(self.class::RUNNING))
            # recheck after setting thread
            result = nil
            begin
              result = @callable.call
            rescue self.class::JavaThrowable => ex
              set_exception(ex)
              return
            end
            set(result)
          else
            release_shared(0) # cancel
          end
        end
        
        typesig { [] }
        def inner_run_and_reset
          if (!compare_and_set_state(self.class::READY, self.class::RUNNING))
            return false
          end
          begin
            @runner = JavaThread.current_thread
            if ((get_state).equal?(self.class::RUNNING))
              @callable.call
            end # don't set result
            @runner = nil
            return compare_and_set_state(self.class::RUNNING, self.class::READY)
          rescue self.class::JavaThrowable => ex
            set_exception(ex)
            return false
          end
        end
        
        private
        alias_method :initialize__sync, :initialize
      end }
    }
    
    private
    alias_method :initialize__future_task, :initialize
  end
  
end

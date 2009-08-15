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
  module AbstractExecutorServiceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
    }
  end
  
  # Provides default implementations of {@link ExecutorService}
  # execution methods. This class implements the <tt>submit</tt>,
  # <tt>invokeAny</tt> and <tt>invokeAll</tt> methods using a
  # {@link RunnableFuture} returned by <tt>newTaskFor</tt>, which defaults
  # to the {@link FutureTask} class provided in this package.  For example,
  # the implementation of <tt>submit(Runnable)</tt> creates an
  # associated <tt>RunnableFuture</tt> that is executed and
  # returned. Subclasses may override the <tt>newTaskFor</tt> methods
  # to return <tt>RunnableFuture</tt> implementations other than
  # <tt>FutureTask</tt>.
  # 
  # <p> <b>Extension example</b>. Here is a sketch of a class
  # that customizes {@link ThreadPoolExecutor} to use
  # a <tt>CustomTask</tt> class instead of the default <tt>FutureTask</tt>:
  # <pre>
  # public class CustomThreadPoolExecutor extends ThreadPoolExecutor {
  # 
  # static class CustomTask&lt;V&gt; implements RunnableFuture&lt;V&gt; {...}
  # 
  # protected &lt;V&gt; RunnableFuture&lt;V&gt; newTaskFor(Callable&lt;V&gt; c) {
  # return new CustomTask&lt;V&gt;(c);
  # }
  # protected &lt;V&gt; RunnableFuture&lt;V&gt; newTaskFor(Runnable r, V v) {
  # return new CustomTask&lt;V&gt;(r, v);
  # }
  # // ... add constructors, etc.
  # }
  # </pre>
  # @since 1.5
  # @author Doug Lea
  class AbstractExecutorService 
    include_class_members AbstractExecutorServiceImports
    include ExecutorService
    
    typesig { [Runnable, T] }
    # Returns a <tt>RunnableFuture</tt> for the given runnable and default
    # value.
    # 
    # @param runnable the runnable task being wrapped
    # @param value the default value for the returned future
    # @return a <tt>RunnableFuture</tt> which when run will run the
    # underlying runnable and which, as a <tt>Future</tt>, will yield
    # the given value as its result and provide for cancellation of
    # the underlying task.
    # @since 1.6
    def new_task_for(runnable, value)
      return FutureTask.new(runnable, value)
    end
    
    typesig { [Callable] }
    # Returns a <tt>RunnableFuture</tt> for the given callable task.
    # 
    # @param callable the callable task being wrapped
    # @return a <tt>RunnableFuture</tt> which when run will call the
    # underlying callable and which, as a <tt>Future</tt>, will yield
    # the callable's result as its result and provide for
    # cancellation of the underlying task.
    # @since 1.6
    def new_task_for(callable)
      return FutureTask.new(callable)
    end
    
    typesig { [Runnable] }
    def submit(task)
      if ((task).nil?)
        raise NullPointerException.new
      end
      ftask = new_task_for(task, nil)
      execute(ftask)
      return ftask
    end
    
    typesig { [Runnable, T] }
    def submit(task, result)
      if ((task).nil?)
        raise NullPointerException.new
      end
      ftask = new_task_for(task, result)
      execute(ftask)
      return ftask
    end
    
    typesig { [Callable] }
    def submit(task)
      if ((task).nil?)
        raise NullPointerException.new
      end
      ftask = new_task_for(task)
      execute(ftask)
      return ftask
    end
    
    typesig { [Collection, ::Java::Boolean, ::Java::Long] }
    # the main mechanics of invokeAny.
    def do_invoke_any(tasks, timed, nanos)
      if ((tasks).nil?)
        raise NullPointerException.new
      end
      ntasks = tasks.size
      if ((ntasks).equal?(0))
        raise IllegalArgumentException.new
      end
      futures = ArrayList.new(ntasks)
      ecs = ExecutorCompletionService.new(self)
      # For efficiency, especially in executors with limited
      # parallelism, check to see if previously submitted tasks are
      # done before submitting more of them. This interleaving
      # plus the exception mechanics account for messiness of main
      # loop.
      begin
        # Record exceptions so that if we fail to obtain any
        # result, we can throw the last exception we got.
        ee = nil
        last_time = (timed) ? System.nano_time : 0
        it = tasks.iterator
        # Start one task for sure; the rest incrementally
        futures.add(ecs.submit(it.next_))
        (ntasks -= 1)
        active = 1
        loop do
          f = ecs.poll
          if ((f).nil?)
            if (ntasks > 0)
              (ntasks -= 1)
              futures.add(ecs.submit(it.next_))
              (active += 1)
            else
              if ((active).equal?(0))
                break
              else
                if (timed)
                  f = ecs.poll(nanos, TimeUnit::NANOSECONDS)
                  if ((f).nil?)
                    raise TimeoutException.new
                  end
                  now = System.nano_time
                  nanos -= now - last_time
                  last_time = now
                else
                  f = ecs.take
                end
              end
            end
          end
          if (!(f).nil?)
            (active -= 1)
            begin
              return f.get
            rescue InterruptedException => ie
              raise ie
            rescue ExecutionException => eex
              ee = eex
            rescue RuntimeException => rex
              ee = ExecutionException.new(rex)
            end
          end
        end
        if ((ee).nil?)
          ee = ExecutionException.new
        end
        raise ee
      ensure
        futures.each do |f|
          f.cancel(true)
        end
      end
    end
    
    typesig { [Collection] }
    def invoke_any(tasks)
      begin
        return do_invoke_any(tasks, false, 0)
      rescue TimeoutException => cannot_happen
        raise AssertError if not (false)
        return nil
      end
    end
    
    typesig { [Collection, ::Java::Long, TimeUnit] }
    def invoke_any(tasks, timeout, unit)
      return do_invoke_any(tasks, true, unit.to_nanos(timeout))
    end
    
    typesig { [Collection] }
    def invoke_all(tasks)
      if ((tasks).nil?)
        raise NullPointerException.new
      end
      futures = ArrayList.new(tasks.size)
      done = false
      begin
        tasks.each do |t|
          f = new_task_for(t)
          futures.add(f)
          execute(f)
        end
        futures.each do |f|
          if (!f.is_done)
            begin
              f.get
            rescue CancellationException => ignore
            rescue ExecutionException => ignore
            end
          end
        end
        done = true
        return futures
      ensure
        if (!done)
          futures.each do |f|
            f.cancel(true)
          end
        end
      end
    end
    
    typesig { [Collection, ::Java::Long, TimeUnit] }
    def invoke_all(tasks, timeout, unit)
      if ((tasks).nil? || (unit).nil?)
        raise NullPointerException.new
      end
      nanos = unit.to_nanos(timeout)
      futures = ArrayList.new(tasks.size)
      done = false
      begin
        tasks.each do |t|
          futures.add(new_task_for(t))
        end
        last_time = System.nano_time
        # Interleave time checks and calls to execute in case
        # executor doesn't have any/much parallelism.
        it = futures.iterator
        while (it.has_next)
          execute((it.next_))
          now = System.nano_time
          nanos -= now - last_time
          last_time = now
          if (nanos <= 0)
            return futures
          end
        end
        futures.each do |f|
          if (!f.is_done)
            if (nanos <= 0)
              return futures
            end
            begin
              f.get(nanos, TimeUnit::NANOSECONDS)
            rescue CancellationException => ignore
            rescue ExecutionException => ignore
            rescue TimeoutException => toe
              return futures
            end
            now = System.nano_time
            nanos -= now - last_time
            last_time = now
          end
        end
        done = true
        return futures
      ensure
        if (!done)
          futures.each do |f|
            f.cancel(true)
          end
        end
      end
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__abstract_executor_service, :initialize
  end
  
end

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
  module ExecutorCompletionServiceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
    }
  end
  
  # A {@link CompletionService} that uses a supplied {@link Executor}
  # to execute tasks.  This class arranges that submitted tasks are,
  # upon completion, placed on a queue accessible using {@code take}.
  # The class is lightweight enough to be suitable for transient use
  # when processing groups of tasks.
  # 
  # <p>
  # 
  # <b>Usage Examples.</b>
  # 
  # Suppose you have a set of solvers for a certain problem, each
  # returning a value of some type {@code Result}, and would like to
  # run them concurrently, processing the results of each of them that
  # return a non-null value, in some method {@code use(Result r)}. You
  # could write this as:
  # 
  # <pre> {@code
  # void solve(Executor e,
  # Collection<Callable<Result>> solvers)
  # throws InterruptedException, ExecutionException {
  # CompletionService<Result> ecs
  # = new ExecutorCompletionService<Result>(e);
  # for (Callable<Result> s : solvers)
  # ecs.submit(s);
  # int n = solvers.size();
  # for (int i = 0; i < n; ++i) {
  # Result r = ecs.take().get();
  # if (r != null)
  # use(r);
  # }
  # }}</pre>
  # 
  # Suppose instead that you would like to use the first non-null result
  # of the set of tasks, ignoring any that encounter exceptions,
  # and cancelling all other tasks when the first one is ready:
  # 
  # <pre> {@code
  # void solve(Executor e,
  # Collection<Callable<Result>> solvers)
  # throws InterruptedException {
  # CompletionService<Result> ecs
  # = new ExecutorCompletionService<Result>(e);
  # int n = solvers.size();
  # List<Future<Result>> futures
  # = new ArrayList<Future<Result>>(n);
  # Result result = null;
  # try {
  # for (Callable<Result> s : solvers)
  # futures.add(ecs.submit(s));
  # for (int i = 0; i < n; ++i) {
  # try {
  # Result r = ecs.take().get();
  # if (r != null) {
  # result = r;
  # break;
  # }
  # } catch (ExecutionException ignore) {}
  # }
  # }
  # finally {
  # for (Future<Result> f : futures)
  # f.cancel(true);
  # }
  # 
  # if (result != null)
  # use(result);
  # }}</pre>
  class ExecutorCompletionService 
    include_class_members ExecutorCompletionServiceImports
    include CompletionService
    
    attr_accessor :executor
    alias_method :attr_executor, :executor
    undef_method :executor
    alias_method :attr_executor=, :executor=
    undef_method :executor=
    
    attr_accessor :aes
    alias_method :attr_aes, :aes
    undef_method :aes
    alias_method :attr_aes=, :aes=
    undef_method :aes=
    
    attr_accessor :completion_queue
    alias_method :attr_completion_queue, :completion_queue
    undef_method :completion_queue
    alias_method :attr_completion_queue=, :completion_queue=
    undef_method :completion_queue=
    
    class_module.module_eval {
      # FutureTask extension to enqueue upon completion
      const_set_lazy(:QueueingFuture) { Class.new(FutureTask) do
        extend LocalClass
        include_class_members ExecutorCompletionService
        
        typesig { [RunnableFuture] }
        def initialize(task)
          @task = nil
          super(task, nil)
          @task = task
        end
        
        typesig { [] }
        def done
          self.attr_completion_queue.add(@task)
        end
        
        attr_accessor :task
        alias_method :attr_task, :task
        undef_method :task
        alias_method :attr_task=, :task=
        undef_method :task=
        
        private
        alias_method :initialize__queueing_future, :initialize
      end }
    }
    
    typesig { [Callable] }
    def new_task_for(task)
      if ((@aes).nil?)
        return FutureTask.new(task)
      else
        return @aes.new_task_for(task)
      end
    end
    
    typesig { [Runnable, Object] }
    def new_task_for(task, result)
      if ((@aes).nil?)
        return FutureTask.new(task, result)
      else
        return @aes.new_task_for(task, result)
      end
    end
    
    typesig { [Executor] }
    # Creates an ExecutorCompletionService using the supplied
    # executor for base task execution and a
    # {@link LinkedBlockingQueue} as a completion queue.
    # 
    # @param executor the executor to use
    # @throws NullPointerException if executor is {@code null}
    def initialize(executor)
      @executor = nil
      @aes = nil
      @completion_queue = nil
      if ((executor).nil?)
        raise NullPointerException.new
      end
      @executor = executor
      @aes = (executor.is_a?(AbstractExecutorService)) ? executor : nil
      @completion_queue = LinkedBlockingQueue.new
    end
    
    typesig { [Executor, BlockingQueue] }
    # Creates an ExecutorCompletionService using the supplied
    # executor for base task execution and the supplied queue as its
    # completion queue.
    # 
    # @param executor the executor to use
    # @param completionQueue the queue to use as the completion queue
    # normally one dedicated for use by this service. This
    # queue is treated as unbounded -- failed attempted
    # {@code Queue.add} operations for completed taskes cause
    # them not to be retrievable.
    # @throws NullPointerException if executor or completionQueue are {@code null}
    def initialize(executor, completion_queue)
      @executor = nil
      @aes = nil
      @completion_queue = nil
      if ((executor).nil? || (completion_queue).nil?)
        raise NullPointerException.new
      end
      @executor = executor
      @aes = (executor.is_a?(AbstractExecutorService)) ? executor : nil
      @completion_queue = completion_queue
    end
    
    typesig { [Callable] }
    def submit(task)
      if ((task).nil?)
        raise NullPointerException.new
      end
      f = new_task_for(task)
      @executor.execute(QueueingFuture.new_local(self, f))
      return f
    end
    
    typesig { [Runnable, Object] }
    def submit(task, result)
      if ((task).nil?)
        raise NullPointerException.new
      end
      f = new_task_for(task, result)
      @executor.execute(QueueingFuture.new_local(self, f))
      return f
    end
    
    typesig { [] }
    def take
      return @completion_queue.take
    end
    
    typesig { [] }
    def poll
      return @completion_queue.poll
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def poll(timeout, unit)
      return @completion_queue.poll(timeout, unit)
    end
    
    private
    alias_method :initialize__executor_completion_service, :initialize
  end
  
end

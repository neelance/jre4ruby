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
  module ExecutorServiceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Collection
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
    }
  end
  
  # An {@link Executor} that provides methods to manage termination and
  # methods that can produce a {@link Future} for tracking progress of
  # one or more asynchronous tasks.
  # 
  # <p> An <tt>ExecutorService</tt> can be shut down, which will cause
  # it to reject new tasks.  Two different methods are provided for
  # shutting down an <tt>ExecutorService</tt>. The {@link #shutdown}
  # method will allow previously submitted tasks to execute before
  # terminating, while the {@link #shutdownNow} method prevents waiting
  # tasks from starting and attempts to stop currently executing tasks.
  # Upon termination, an executor has no tasks actively executing, no
  # tasks awaiting execution, and no new tasks can be submitted.  An
  # unused <tt>ExecutorService</tt> should be shut down to allow
  # reclamation of its resources.
  # 
  # <p> Method <tt>submit</tt> extends base method {@link
  # Executor#execute} by creating and returning a {@link Future} that
  # can be used to cancel execution and/or wait for completion.
  # Methods <tt>invokeAny</tt> and <tt>invokeAll</tt> perform the most
  # commonly useful forms of bulk execution, executing a collection of
  # tasks and then waiting for at least one, or all, to
  # complete. (Class {@link ExecutorCompletionService} can be used to
  # write customized variants of these methods.)
  # 
  # <p>The {@link Executors} class provides factory methods for the
  # executor services provided in this package.
  # 
  # <h3>Usage Examples</h3>
  # 
  # Here is a sketch of a network service in which threads in a thread
  # pool service incoming requests. It uses the preconfigured {@link
  # Executors#newFixedThreadPool} factory method:
  # 
  # <pre>
  # class NetworkService implements Runnable {
  # private final ServerSocket serverSocket;
  # private final ExecutorService pool;
  # 
  # public NetworkService(int port, int poolSize)
  # throws IOException {
  # serverSocket = new ServerSocket(port);
  # pool = Executors.newFixedThreadPool(poolSize);
  # }
  # 
  # public void run() { // run the service
  # try {
  # for (;;) {
  # pool.execute(new Handler(serverSocket.accept()));
  # }
  # } catch (IOException ex) {
  # pool.shutdown();
  # }
  # }
  # }
  # 
  # class Handler implements Runnable {
  # private final Socket socket;
  # Handler(Socket socket) { this.socket = socket; }
  # public void run() {
  # // read and service request on socket
  # }
  # }
  # </pre>
  # 
  # The following method shuts down an <tt>ExecutorService</tt> in two phases,
  # first by calling <tt>shutdown</tt> to reject incoming tasks, and then
  # calling <tt>shutdownNow</tt>, if necessary, to cancel any lingering tasks:
  # 
  # <pre>
  # void shutdownAndAwaitTermination(ExecutorService pool) {
  # pool.shutdown(); // Disable new tasks from being submitted
  # try {
  # // Wait a while for existing tasks to terminate
  # if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
  # pool.shutdownNow(); // Cancel currently executing tasks
  # // Wait a while for tasks to respond to being cancelled
  # if (!pool.awaitTermination(60, TimeUnit.SECONDS))
  # System.err.println("Pool did not terminate");
  # }
  # } catch (InterruptedException ie) {
  # // (Re-)Cancel if current thread also interrupted
  # pool.shutdownNow();
  # // Preserve interrupt status
  # Thread.currentThread().interrupt();
  # }
  # }
  # </pre>
  # 
  # <p>Memory consistency effects: Actions in a thread prior to the
  # submission of a {@code Runnable} or {@code Callable} task to an
  # {@code ExecutorService}
  # <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
  # any actions taken by that task, which in turn <i>happen-before</i> the
  # result is retrieved via {@code Future.get()}.
  # 
  # @since 1.5
  # @author Doug Lea
  module ExecutorService
    include_class_members ExecutorServiceImports
    include Executor
    
    typesig { [] }
    # Initiates an orderly shutdown in which previously submitted
    # tasks are executed, but no new tasks will be accepted.
    # Invocation has no additional effect if already shut down.
    # 
    # @throws SecurityException if a security manager exists and
    # shutting down this ExecutorService may manipulate
    # threads that the caller is not permitted to modify
    # because it does not hold {@link
    # java.lang.RuntimePermission}<tt>("modifyThread")</tt>,
    # or the security manager's <tt>checkAccess</tt> method
    # denies access.
    def shutdown
      raise NotImplementedError
    end
    
    typesig { [] }
    # Attempts to stop all actively executing tasks, halts the
    # processing of waiting tasks, and returns a list of the tasks that were
    # awaiting execution.
    # 
    # <p>There are no guarantees beyond best-effort attempts to stop
    # processing actively executing tasks.  For example, typical
    # implementations will cancel via {@link Thread#interrupt}, so any
    # task that fails to respond to interrupts may never terminate.
    # 
    # @return list of tasks that never commenced execution
    # @throws SecurityException if a security manager exists and
    # shutting down this ExecutorService may manipulate
    # threads that the caller is not permitted to modify
    # because it does not hold {@link
    # java.lang.RuntimePermission}<tt>("modifyThread")</tt>,
    # or the security manager's <tt>checkAccess</tt> method
    # denies access.
    def shutdown_now
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this executor has been shut down.
    # 
    # @return <tt>true</tt> if this executor has been shut down
    def is_shutdown
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if all tasks have completed following shut down.
    # Note that <tt>isTerminated</tt> is never <tt>true</tt> unless
    # either <tt>shutdown</tt> or <tt>shutdownNow</tt> was called first.
    # 
    # @return <tt>true</tt> if all tasks have completed following shut down
    def is_terminated
      raise NotImplementedError
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Blocks until all tasks have completed execution after a shutdown
    # request, or the timeout occurs, or the current thread is
    # interrupted, whichever happens first.
    # 
    # @param timeout the maximum time to wait
    # @param unit the time unit of the timeout argument
    # @return <tt>true</tt> if this executor terminated and
    # <tt>false</tt> if the timeout elapsed before termination
    # @throws InterruptedException if interrupted while waiting
    def await_termination(timeout, unit)
      raise NotImplementedError
    end
    
    typesig { [Callable] }
    # Submits a value-returning task for execution and returns a
    # Future representing the pending results of the task. The
    # Future's <tt>get</tt> method will return the task's result upon
    # successful completion.
    # 
    # <p>
    # If you would like to immediately block waiting
    # for a task, you can use constructions of the form
    # <tt>result = exec.submit(aCallable).get();</tt>
    # 
    # <p> Note: The {@link Executors} class includes a set of methods
    # that can convert some other common closure-like objects,
    # for example, {@link java.security.PrivilegedAction} to
    # {@link Callable} form so they can be submitted.
    # 
    # @param task the task to submit
    # @return a Future representing pending completion of the task
    # @throws RejectedExecutionException if the task cannot be
    # scheduled for execution
    # @throws NullPointerException if the task is null
    def submit(task)
      raise NotImplementedError
    end
    
    typesig { [Runnable, T] }
    # Submits a Runnable task for execution and returns a Future
    # representing that task. The Future's <tt>get</tt> method will
    # return the given result upon successful completion.
    # 
    # @param task the task to submit
    # @param result the result to return
    # @return a Future representing pending completion of the task
    # @throws RejectedExecutionException if the task cannot be
    # scheduled for execution
    # @throws NullPointerException if the task is null
    def submit(task, result)
      raise NotImplementedError
    end
    
    typesig { [Runnable] }
    # Submits a Runnable task for execution and returns a Future
    # representing that task. The Future's <tt>get</tt> method will
    # return <tt>null</tt> upon <em>successful</em> completion.
    # 
    # @param task the task to submit
    # @return a Future representing pending completion of the task
    # @throws RejectedExecutionException if the task cannot be
    # scheduled for execution
    # @throws NullPointerException if the task is null
    def submit(task)
      raise NotImplementedError
    end
    
    typesig { [Collection] }
    # Executes the given tasks, returning a list of Futures holding
    # their status and results when all complete.
    # {@link Future#isDone} is <tt>true</tt> for each
    # element of the returned list.
    # Note that a <em>completed</em> task could have
    # terminated either normally or by throwing an exception.
    # The results of this method are undefined if the given
    # collection is modified while this operation is in progress.
    # 
    # @param tasks the collection of tasks
    # @return A list of Futures representing the tasks, in the same
    # sequential order as produced by the iterator for the
    # given task list, each of which has completed.
    # @throws InterruptedException if interrupted while waiting, in
    # which case unfinished tasks are cancelled.
    # @throws NullPointerException if tasks or any of its elements are <tt>null</tt>
    # @throws RejectedExecutionException if any task cannot be
    # scheduled for execution
    def invoke_all(tasks)
      raise NotImplementedError
    end
    
    typesig { [Collection, ::Java::Long, TimeUnit] }
    # Executes the given tasks, returning a list of Futures holding
    # their status and results
    # when all complete or the timeout expires, whichever happens first.
    # {@link Future#isDone} is <tt>true</tt> for each
    # element of the returned list.
    # Upon return, tasks that have not completed are cancelled.
    # Note that a <em>completed</em> task could have
    # terminated either normally or by throwing an exception.
    # The results of this method are undefined if the given
    # collection is modified while this operation is in progress.
    # 
    # @param tasks the collection of tasks
    # @param timeout the maximum time to wait
    # @param unit the time unit of the timeout argument
    # @return a list of Futures representing the tasks, in the same
    # sequential order as produced by the iterator for the
    # given task list. If the operation did not time out,
    # each task will have completed. If it did time out, some
    # of these tasks will not have completed.
    # @throws InterruptedException if interrupted while waiting, in
    # which case unfinished tasks are cancelled
    # @throws NullPointerException if tasks, any of its elements, or
    # unit are <tt>null</tt>
    # @throws RejectedExecutionException if any task cannot be scheduled
    # for execution
    def invoke_all(tasks, timeout, unit)
      raise NotImplementedError
    end
    
    typesig { [Collection] }
    # Executes the given tasks, returning the result
    # of one that has completed successfully (i.e., without throwing
    # an exception), if any do. Upon normal or exceptional return,
    # tasks that have not completed are cancelled.
    # The results of this method are undefined if the given
    # collection is modified while this operation is in progress.
    # 
    # @param tasks the collection of tasks
    # @return the result returned by one of the tasks
    # @throws InterruptedException if interrupted while waiting
    # @throws NullPointerException if tasks or any of its elements
    # are <tt>null</tt>
    # @throws IllegalArgumentException if tasks is empty
    # @throws ExecutionException if no task successfully completes
    # @throws RejectedExecutionException if tasks cannot be scheduled
    # for execution
    def invoke_any(tasks)
      raise NotImplementedError
    end
    
    typesig { [Collection, ::Java::Long, TimeUnit] }
    # Executes the given tasks, returning the result
    # of one that has completed successfully (i.e., without throwing
    # an exception), if any do before the given timeout elapses.
    # Upon normal or exceptional return, tasks that have not
    # completed are cancelled.
    # The results of this method are undefined if the given
    # collection is modified while this operation is in progress.
    # 
    # @param tasks the collection of tasks
    # @param timeout the maximum time to wait
    # @param unit the time unit of the timeout argument
    # @return the result returned by one of the tasks.
    # @throws InterruptedException if interrupted while waiting
    # @throws NullPointerException if tasks, any of its elements, or
    # unit are <tt>null</tt>
    # @throws TimeoutException if the given timeout elapses before
    # any task successfully completes
    # @throws ExecutionException if no task successfully completes
    # @throws RejectedExecutionException if tasks cannot be scheduled
    # for execution
    def invoke_any(tasks, timeout, unit)
      raise NotImplementedError
    end
  end
  
end

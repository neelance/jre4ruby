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
  module SemaphoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util::Concurrent::Atomic
    }
  end
  
  # A counting semaphore.  Conceptually, a semaphore maintains a set of
  # permits.  Each {@link #acquire} blocks if necessary until a permit is
  # available, and then takes it.  Each {@link #release} adds a permit,
  # potentially releasing a blocking acquirer.
  # However, no actual permit objects are used; the {@code Semaphore} just
  # keeps a count of the number available and acts accordingly.
  # 
  # <p>Semaphores are often used to restrict the number of threads than can
  # access some (physical or logical) resource. For example, here is
  # a class that uses a semaphore to control access to a pool of items:
  # <pre>
  # class Pool {
  # private static final int MAX_AVAILABLE = 100;
  # private final Semaphore available = new Semaphore(MAX_AVAILABLE, true);
  # 
  # public Object getItem() throws InterruptedException {
  # available.acquire();
  # return getNextAvailableItem();
  # }
  # 
  # public void putItem(Object x) {
  # if (markAsUnused(x))
  # available.release();
  # }
  # 
  # // Not a particularly efficient data structure; just for demo
  # 
  # protected Object[] items = ... whatever kinds of items being managed
  # protected boolean[] used = new boolean[MAX_AVAILABLE];
  # 
  # protected synchronized Object getNextAvailableItem() {
  # for (int i = 0; i < MAX_AVAILABLE; ++i) {
  # if (!used[i]) {
  # used[i] = true;
  # return items[i];
  # }
  # }
  # return null; // not reached
  # }
  # 
  # protected synchronized boolean markAsUnused(Object item) {
  # for (int i = 0; i < MAX_AVAILABLE; ++i) {
  # if (item == items[i]) {
  # if (used[i]) {
  # used[i] = false;
  # return true;
  # } else
  # return false;
  # }
  # }
  # return false;
  # }
  # 
  # }
  # </pre>
  # 
  # <p>Before obtaining an item each thread must acquire a permit from
  # the semaphore, guaranteeing that an item is available for use. When
  # the thread has finished with the item it is returned back to the
  # pool and a permit is returned to the semaphore, allowing another
  # thread to acquire that item.  Note that no synchronization lock is
  # held when {@link #acquire} is called as that would prevent an item
  # from being returned to the pool.  The semaphore encapsulates the
  # synchronization needed to restrict access to the pool, separately
  # from any synchronization needed to maintain the consistency of the
  # pool itself.
  # 
  # <p>A semaphore initialized to one, and which is used such that it
  # only has at most one permit available, can serve as a mutual
  # exclusion lock.  This is more commonly known as a <em>binary
  # semaphore</em>, because it only has two states: one permit
  # available, or zero permits available.  When used in this way, the
  # binary semaphore has the property (unlike many {@link Lock}
  # implementations), that the &quot;lock&quot; can be released by a
  # thread other than the owner (as semaphores have no notion of
  # ownership).  This can be useful in some specialized contexts, such
  # as deadlock recovery.
  # 
  # <p> The constructor for this class optionally accepts a
  # <em>fairness</em> parameter. When set false, this class makes no
  # guarantees about the order in which threads acquire permits. In
  # particular, <em>barging</em> is permitted, that is, a thread
  # invoking {@link #acquire} can be allocated a permit ahead of a
  # thread that has been waiting - logically the new thread places itself at
  # the head of the queue of waiting threads. When fairness is set true, the
  # semaphore guarantees that threads invoking any of the {@link
  # #acquire() acquire} methods are selected to obtain permits in the order in
  # which their invocation of those methods was processed
  # (first-in-first-out; FIFO). Note that FIFO ordering necessarily
  # applies to specific internal points of execution within these
  # methods.  So, it is possible for one thread to invoke
  # {@code acquire} before another, but reach the ordering point after
  # the other, and similarly upon return from the method.
  # Also note that the untimed {@link #tryAcquire() tryAcquire} methods do not
  # honor the fairness setting, but will take any permits that are
  # available.
  # 
  # <p>Generally, semaphores used to control resource access should be
  # initialized as fair, to ensure that no thread is starved out from
  # accessing a resource. When using semaphores for other kinds of
  # synchronization control, the throughput advantages of non-fair
  # ordering often outweigh fairness considerations.
  # 
  # <p>This class also provides convenience methods to {@link
  # #acquire(int) acquire} and {@link #release(int) release} multiple
  # permits at a time.  Beware of the increased risk of indefinite
  # postponement when these methods are used without fairness set true.
  # 
  # <p>Memory consistency effects: Actions in a thread prior to calling
  # a "release" method such as {@code release()}
  # <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
  # actions following a successful "acquire" method such as {@code acquire()}
  # in another thread.
  # 
  # @since 1.5
  # @author Doug Lea
  class Semaphore 
    include_class_members SemaphoreImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3222578661600680210 }
      const_attr_reader  :SerialVersionUID
    }
    
    # All mechanics via AbstractQueuedSynchronizer subclass
    attr_accessor :sync
    alias_method :attr_sync, :sync
    undef_method :sync
    alias_method :attr_sync=, :sync=
    undef_method :sync=
    
    class_module.module_eval {
      # Synchronization implementation for semaphore.  Uses AQS state
      # to represent permits. Subclassed into fair and nonfair
      # versions.
      const_set_lazy(:Sync) { Class.new(AbstractQueuedSynchronizer) do
        include_class_members Semaphore
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1192457210091910933 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [::Java::Int] }
        def initialize(permits)
          super()
          set_state(permits)
        end
        
        typesig { [] }
        def get_permits
          return get_state
        end
        
        typesig { [::Java::Int] }
        def nonfair_try_acquire_shared(acquires)
          loop do
            available = get_state
            remaining = available - acquires
            if (remaining < 0 || compare_and_set_state(available, remaining))
              return remaining
            end
          end
        end
        
        typesig { [::Java::Int] }
        def try_release_shared(releases)
          loop do
            p = get_state
            if (compare_and_set_state(p, p + releases))
              return true
            end
          end
        end
        
        typesig { [::Java::Int] }
        def reduce_permits(reductions)
          loop do
            current = get_state
            next_ = current - reductions
            if (compare_and_set_state(current, next_))
              return
            end
          end
        end
        
        typesig { [] }
        def drain_permits
          loop do
            current = get_state
            if ((current).equal?(0) || compare_and_set_state(current, 0))
              return current
            end
          end
        end
        
        private
        alias_method :initialize__sync, :initialize
      end }
      
      # NonFair version
      const_set_lazy(:NonfairSync) { Class.new(Sync) do
        include_class_members Semaphore
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -2694183684443567898 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [::Java::Int] }
        def initialize(permits)
          super(permits)
        end
        
        typesig { [::Java::Int] }
        def try_acquire_shared(acquires)
          return nonfair_try_acquire_shared(acquires)
        end
        
        private
        alias_method :initialize__nonfair_sync, :initialize
      end }
      
      # Fair version
      const_set_lazy(:FairSync) { Class.new(Sync) do
        include_class_members Semaphore
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 2014338818796000944 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [::Java::Int] }
        def initialize(permits)
          super(permits)
        end
        
        typesig { [::Java::Int] }
        def try_acquire_shared(acquires)
          loop do
            if (!(get_first_queued_thread).equal?(JavaThread.current_thread) && has_queued_threads)
              return -1
            end
            available = get_state
            remaining = available - acquires
            if (remaining < 0 || compare_and_set_state(available, remaining))
              return remaining
            end
          end
        end
        
        private
        alias_method :initialize__fair_sync, :initialize
      end }
    }
    
    typesig { [::Java::Int] }
    # Creates a {@code Semaphore} with the given number of
    # permits and nonfair fairness setting.
    # 
    # @param permits the initial number of permits available.
    # This value may be negative, in which case releases
    # must occur before any acquires will be granted.
    def initialize(permits)
      @sync = nil
      @sync = NonfairSync.new(permits)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Creates a {@code Semaphore} with the given number of
    # permits and the given fairness setting.
    # 
    # @param permits the initial number of permits available.
    # This value may be negative, in which case releases
    # must occur before any acquires will be granted.
    # @param fair {@code true} if this semaphore will guarantee
    # first-in first-out granting of permits under contention,
    # else {@code false}
    def initialize(permits, fair)
      @sync = nil
      @sync = (fair) ? FairSync.new(permits) : NonfairSync.new(permits)
    end
    
    typesig { [] }
    # Acquires a permit from this semaphore, blocking until one is
    # available, or the thread is {@linkplain Thread#interrupt interrupted}.
    # 
    # <p>Acquires a permit, if one is available and returns immediately,
    # reducing the number of available permits by one.
    # 
    # <p>If no permit is available then the current thread becomes
    # disabled for thread scheduling purposes and lies dormant until
    # one of two things happens:
    # <ul>
    # <li>Some other thread invokes the {@link #release} method for this
    # semaphore and the current thread is next to be assigned a permit; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread.
    # </ul>
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # for a permit,
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # 
    # @throws InterruptedException if the current thread is interrupted
    def acquire
      @sync.acquire_shared_interruptibly(1)
    end
    
    typesig { [] }
    # Acquires a permit from this semaphore, blocking until one is
    # available.
    # 
    # <p>Acquires a permit, if one is available and returns immediately,
    # reducing the number of available permits by one.
    # 
    # <p>If no permit is available then the current thread becomes
    # disabled for thread scheduling purposes and lies dormant until
    # some other thread invokes the {@link #release} method for this
    # semaphore and the current thread is next to be assigned a permit.
    # 
    # <p>If the current thread is {@linkplain Thread#interrupt interrupted}
    # while waiting for a permit then it will continue to wait, but the
    # time at which the thread is assigned a permit may change compared to
    # the time it would have received the permit had no interruption
    # occurred.  When the thread does return from this method its interrupt
    # status will be set.
    def acquire_uninterruptibly
      @sync.acquire_shared(1)
    end
    
    typesig { [] }
    # Acquires a permit from this semaphore, only if one is available at the
    # time of invocation.
    # 
    # <p>Acquires a permit, if one is available and returns immediately,
    # with the value {@code true},
    # reducing the number of available permits by one.
    # 
    # <p>If no permit is available then this method will return
    # immediately with the value {@code false}.
    # 
    # <p>Even when this semaphore has been set to use a
    # fair ordering policy, a call to {@code tryAcquire()} <em>will</em>
    # immediately acquire a permit if one is available, whether or not
    # other threads are currently waiting.
    # This &quot;barging&quot; behavior can be useful in certain
    # circumstances, even though it breaks fairness. If you want to honor
    # the fairness setting, then use
    # {@link #tryAcquire(long, TimeUnit) tryAcquire(0, TimeUnit.SECONDS) }
    # which is almost equivalent (it also detects interruption).
    # 
    # @return {@code true} if a permit was acquired and {@code false}
    # otherwise
    def try_acquire
      return @sync.nonfair_try_acquire_shared(1) >= 0
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Acquires a permit from this semaphore, if one becomes available
    # within the given waiting time and the current thread has not
    # been {@linkplain Thread#interrupt interrupted}.
    # 
    # <p>Acquires a permit, if one is available and returns immediately,
    # with the value {@code true},
    # reducing the number of available permits by one.
    # 
    # <p>If no permit is available then the current thread becomes
    # disabled for thread scheduling purposes and lies dormant until
    # one of three things happens:
    # <ul>
    # <li>Some other thread invokes the {@link #release} method for this
    # semaphore and the current thread is next to be assigned a permit; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread; or
    # <li>The specified waiting time elapses.
    # </ul>
    # 
    # <p>If a permit is acquired then the value {@code true} is returned.
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # to acquire a permit,
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # 
    # <p>If the specified waiting time elapses then the value {@code false}
    # is returned.  If the time is less than or equal to zero, the method
    # will not wait at all.
    # 
    # @param timeout the maximum time to wait for a permit
    # @param unit the time unit of the {@code timeout} argument
    # @return {@code true} if a permit was acquired and {@code false}
    # if the waiting time elapsed before a permit was acquired
    # @throws InterruptedException if the current thread is interrupted
    def try_acquire(timeout, unit)
      return @sync.try_acquire_shared_nanos(1, unit.to_nanos(timeout))
    end
    
    typesig { [] }
    # Releases a permit, returning it to the semaphore.
    # 
    # <p>Releases a permit, increasing the number of available permits by
    # one.  If any threads are trying to acquire a permit, then one is
    # selected and given the permit that was just released.  That thread
    # is (re)enabled for thread scheduling purposes.
    # 
    # <p>There is no requirement that a thread that releases a permit must
    # have acquired that permit by calling {@link #acquire}.
    # Correct usage of a semaphore is established by programming convention
    # in the application.
    def release
      @sync.release_shared(1)
    end
    
    typesig { [::Java::Int] }
    # Acquires the given number of permits from this semaphore,
    # blocking until all are available,
    # or the thread is {@linkplain Thread#interrupt interrupted}.
    # 
    # <p>Acquires the given number of permits, if they are available,
    # and returns immediately, reducing the number of available permits
    # by the given amount.
    # 
    # <p>If insufficient permits are available then the current thread becomes
    # disabled for thread scheduling purposes and lies dormant until
    # one of two things happens:
    # <ul>
    # <li>Some other thread invokes one of the {@link #release() release}
    # methods for this semaphore, the current thread is next to be assigned
    # permits and the number of available permits satisfies this request; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread.
    # </ul>
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # for a permit,
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # Any permits that were to be assigned to this thread are instead
    # assigned to other threads trying to acquire permits, as if
    # permits had been made available by a call to {@link #release()}.
    # 
    # @param permits the number of permits to acquire
    # @throws InterruptedException if the current thread is interrupted
    # @throws IllegalArgumentException if {@code permits} is negative
    def acquire(permits)
      if (permits < 0)
        raise IllegalArgumentException.new
      end
      @sync.acquire_shared_interruptibly(permits)
    end
    
    typesig { [::Java::Int] }
    # Acquires the given number of permits from this semaphore,
    # blocking until all are available.
    # 
    # <p>Acquires the given number of permits, if they are available,
    # and returns immediately, reducing the number of available permits
    # by the given amount.
    # 
    # <p>If insufficient permits are available then the current thread becomes
    # disabled for thread scheduling purposes and lies dormant until
    # some other thread invokes one of the {@link #release() release}
    # methods for this semaphore, the current thread is next to be assigned
    # permits and the number of available permits satisfies this request.
    # 
    # <p>If the current thread is {@linkplain Thread#interrupt interrupted}
    # while waiting for permits then it will continue to wait and its
    # position in the queue is not affected.  When the thread does return
    # from this method its interrupt status will be set.
    # 
    # @param permits the number of permits to acquire
    # @throws IllegalArgumentException if {@code permits} is negative
    def acquire_uninterruptibly(permits)
      if (permits < 0)
        raise IllegalArgumentException.new
      end
      @sync.acquire_shared(permits)
    end
    
    typesig { [::Java::Int] }
    # Acquires the given number of permits from this semaphore, only
    # if all are available at the time of invocation.
    # 
    # <p>Acquires the given number of permits, if they are available, and
    # returns immediately, with the value {@code true},
    # reducing the number of available permits by the given amount.
    # 
    # <p>If insufficient permits are available then this method will return
    # immediately with the value {@code false} and the number of available
    # permits is unchanged.
    # 
    # <p>Even when this semaphore has been set to use a fair ordering
    # policy, a call to {@code tryAcquire} <em>will</em>
    # immediately acquire a permit if one is available, whether or
    # not other threads are currently waiting.  This
    # &quot;barging&quot; behavior can be useful in certain
    # circumstances, even though it breaks fairness. If you want to
    # honor the fairness setting, then use {@link #tryAcquire(int,
    # long, TimeUnit) tryAcquire(permits, 0, TimeUnit.SECONDS) }
    # which is almost equivalent (it also detects interruption).
    # 
    # @param permits the number of permits to acquire
    # @return {@code true} if the permits were acquired and
    # {@code false} otherwise
    # @throws IllegalArgumentException if {@code permits} is negative
    def try_acquire(permits)
      if (permits < 0)
        raise IllegalArgumentException.new
      end
      return @sync.nonfair_try_acquire_shared(permits) >= 0
    end
    
    typesig { [::Java::Int, ::Java::Long, TimeUnit] }
    # Acquires the given number of permits from this semaphore, if all
    # become available within the given waiting time and the current
    # thread has not been {@linkplain Thread#interrupt interrupted}.
    # 
    # <p>Acquires the given number of permits, if they are available and
    # returns immediately, with the value {@code true},
    # reducing the number of available permits by the given amount.
    # 
    # <p>If insufficient permits are available then
    # the current thread becomes disabled for thread scheduling
    # purposes and lies dormant until one of three things happens:
    # <ul>
    # <li>Some other thread invokes one of the {@link #release() release}
    # methods for this semaphore, the current thread is next to be assigned
    # permits and the number of available permits satisfies this request; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread; or
    # <li>The specified waiting time elapses.
    # </ul>
    # 
    # <p>If the permits are acquired then the value {@code true} is returned.
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # to acquire the permits,
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # Any permits that were to be assigned to this thread, are instead
    # assigned to other threads trying to acquire permits, as if
    # the permits had been made available by a call to {@link #release()}.
    # 
    # <p>If the specified waiting time elapses then the value {@code false}
    # is returned.  If the time is less than or equal to zero, the method
    # will not wait at all.  Any permits that were to be assigned to this
    # thread, are instead assigned to other threads trying to acquire
    # permits, as if the permits had been made available by a call to
    # {@link #release()}.
    # 
    # @param permits the number of permits to acquire
    # @param timeout the maximum time to wait for the permits
    # @param unit the time unit of the {@code timeout} argument
    # @return {@code true} if all permits were acquired and {@code false}
    # if the waiting time elapsed before all permits were acquired
    # @throws InterruptedException if the current thread is interrupted
    # @throws IllegalArgumentException if {@code permits} is negative
    def try_acquire(permits, timeout, unit)
      if (permits < 0)
        raise IllegalArgumentException.new
      end
      return @sync.try_acquire_shared_nanos(permits, unit.to_nanos(timeout))
    end
    
    typesig { [::Java::Int] }
    # Releases the given number of permits, returning them to the semaphore.
    # 
    # <p>Releases the given number of permits, increasing the number of
    # available permits by that amount.
    # If any threads are trying to acquire permits, then one
    # is selected and given the permits that were just released.
    # If the number of available permits satisfies that thread's request
    # then that thread is (re)enabled for thread scheduling purposes;
    # otherwise the thread will wait until sufficient permits are available.
    # If there are still permits available
    # after this thread's request has been satisfied, then those permits
    # are assigned in turn to other threads trying to acquire permits.
    # 
    # <p>There is no requirement that a thread that releases a permit must
    # have acquired that permit by calling {@link Semaphore#acquire acquire}.
    # Correct usage of a semaphore is established by programming convention
    # in the application.
    # 
    # @param permits the number of permits to release
    # @throws IllegalArgumentException if {@code permits} is negative
    def release(permits)
      if (permits < 0)
        raise IllegalArgumentException.new
      end
      @sync.release_shared(permits)
    end
    
    typesig { [] }
    # Returns the current number of permits available in this semaphore.
    # 
    # <p>This method is typically used for debugging and testing purposes.
    # 
    # @return the number of permits available in this semaphore
    def available_permits
      return @sync.get_permits
    end
    
    typesig { [] }
    # Acquires and returns all permits that are immediately available.
    # 
    # @return the number of permits acquired
    def drain_permits
      return @sync.drain_permits
    end
    
    typesig { [::Java::Int] }
    # Shrinks the number of available permits by the indicated
    # reduction. This method can be useful in subclasses that use
    # semaphores to track resources that become unavailable. This
    # method differs from {@code acquire} in that it does not block
    # waiting for permits to become available.
    # 
    # @param reduction the number of permits to remove
    # @throws IllegalArgumentException if {@code reduction} is negative
    def reduce_permits(reduction)
      if (reduction < 0)
        raise IllegalArgumentException.new
      end
      @sync.reduce_permits(reduction)
    end
    
    typesig { [] }
    # Returns {@code true} if this semaphore has fairness set true.
    # 
    # @return {@code true} if this semaphore has fairness set true
    def is_fair
      return @sync.is_a?(FairSync)
    end
    
    typesig { [] }
    # Queries whether any threads are waiting to acquire. Note that
    # because cancellations may occur at any time, a {@code true}
    # return does not guarantee that any other thread will ever
    # acquire.  This method is designed primarily for use in
    # monitoring of the system state.
    # 
    # @return {@code true} if there may be other threads waiting to
    # acquire the lock
    def has_queued_threads
      return @sync.has_queued_threads
    end
    
    typesig { [] }
    # Returns an estimate of the number of threads waiting to acquire.
    # The value is only an estimate because the number of threads may
    # change dynamically while this method traverses internal data
    # structures.  This method is designed for use in monitoring of the
    # system state, not for synchronization control.
    # 
    # @return the estimated number of threads waiting for this lock
    def get_queue_length
      return @sync.get_queue_length
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to acquire.
    # Because the actual set of threads may change dynamically while
    # constructing this result, the returned collection is only a best-effort
    # estimate.  The elements of the returned collection are in no particular
    # order.  This method is designed to facilitate construction of
    # subclasses that provide more extensive monitoring facilities.
    # 
    # @return the collection of threads
    def get_queued_threads
      return @sync.get_queued_threads
    end
    
    typesig { [] }
    # Returns a string identifying this semaphore, as well as its state.
    # The state, in brackets, includes the String {@code "Permits ="}
    # followed by the number of permits.
    # 
    # @return a string identifying this semaphore, as well as its state
    def to_s
      return RJava.cast_to_string(super) + "[Permits = " + RJava.cast_to_string(@sync.get_permits) + "]"
    end
    
    private
    alias_method :initialize__semaphore, :initialize
  end
  
end

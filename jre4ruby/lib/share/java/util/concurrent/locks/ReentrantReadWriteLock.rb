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
module Java::Util::Concurrent::Locks
  module ReentrantReadWriteLockImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Atomic
      include ::Java::Util
    }
  end
  
  # An implementation of {@link ReadWriteLock} supporting similar
  # semantics to {@link ReentrantLock}.
  # <p>This class has the following properties:
  # 
  # <ul>
  # <li><b>Acquisition order</b>
  # 
  # <p> This class does not impose a reader or writer preference
  # ordering for lock access.  However, it does support an optional
  # <em>fairness</em> policy.
  # 
  # <dl>
  # <dt><b><i>Non-fair mode (default)</i></b>
  # <dd>When constructed as non-fair (the default), the order of entry
  # to the read and write lock is unspecified, subject to reentrancy
  # constraints.  A nonfair lock that is continuously contended may
  # indefinitely postpone one or more reader or writer threads, but
  # will normally have higher throughput than a fair lock.
  # <p>
  # 
  # <dt><b><i>Fair mode</i></b>
  # <dd> When constructed as fair, threads contend for entry using an
  # approximately arrival-order policy. When the currently held lock
  # is released either the longest-waiting single writer thread will
  # be assigned the write lock, or if there is a group of reader threads
  # waiting longer than all waiting writer threads, that group will be
  # assigned the read lock.
  # 
  # <p>A thread that tries to acquire a fair read lock (non-reentrantly)
  # will block if either the write lock is held, or there is a waiting
  # writer thread. The thread will not acquire the read lock until
  # after the oldest currently waiting writer thread has acquired and
  # released the write lock. Of course, if a waiting writer abandons
  # its wait, leaving one or more reader threads as the longest waiters
  # in the queue with the write lock free, then those readers will be
  # assigned the read lock.
  # 
  # <p>A thread that tries to acquire a fair write lock (non-reentrantly)
  # will block unless both the read lock and write lock are free (which
  # implies there are no waiting threads).  (Note that the non-blocking
  # {@link ReadLock#tryLock()} and {@link WriteLock#tryLock()} methods
  # do not honor this fair setting and will acquire the lock if it is
  # possible, regardless of waiting threads.)
  # <p>
  # </dl>
  # 
  # <li><b>Reentrancy</b>
  # 
  # <p>This lock allows both readers and writers to reacquire read or
  # write locks in the style of a {@link ReentrantLock}. Non-reentrant
  # readers are not allowed until all write locks held by the writing
  # thread have been released.
  # 
  # <p>Additionally, a writer can acquire the read lock, but not
  # vice-versa.  Among other applications, reentrancy can be useful
  # when write locks are held during calls or callbacks to methods that
  # perform reads under read locks.  If a reader tries to acquire the
  # write lock it will never succeed.
  # 
  # <li><b>Lock downgrading</b>
  # <p>Reentrancy also allows downgrading from the write lock to a read lock,
  # by acquiring the write lock, then the read lock and then releasing the
  # write lock. However, upgrading from a read lock to the write lock is
  # <b>not</b> possible.
  # 
  # <li><b>Interruption of lock acquisition</b>
  # <p>The read lock and write lock both support interruption during lock
  # acquisition.
  # 
  # <li><b>{@link Condition} support</b>
  # <p>The write lock provides a {@link Condition} implementation that
  # behaves in the same way, with respect to the write lock, as the
  # {@link Condition} implementation provided by
  # {@link ReentrantLock#newCondition} does for {@link ReentrantLock}.
  # This {@link Condition} can, of course, only be used with the write lock.
  # 
  # <p>The read lock does not support a {@link Condition} and
  # {@code readLock().newCondition()} throws
  # {@code UnsupportedOperationException}.
  # 
  # <li><b>Instrumentation</b>
  # <p>This class supports methods to determine whether locks
  # are held or contended. These methods are designed for monitoring
  # system state, not for synchronization control.
  # </ul>
  # 
  # <p>Serialization of this class behaves in the same way as built-in
  # locks: a deserialized lock is in the unlocked state, regardless of
  # its state when serialized.
  # 
  # <p><b>Sample usages</b>. Here is a code sketch showing how to perform
  # lock downgrading after updating a cache (exception handling is
  # particularly tricky when handling multiple locks in a non-nested
  # fashion):
  # 
  # <pre> {@code
  # class CachedData {
  # Object data;
  # volatile boolean cacheValid;
  # final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
  # 
  # void processCachedData() {
  # rwl.readLock().lock();
  # if (!cacheValid) {
  # // Must release read lock before acquiring write lock
  # rwl.readLock().unlock();
  # rwl.writeLock().lock();
  # try {
  # // Recheck state because another thread might have
  # // acquired write lock and changed state before we did.
  # if (!cacheValid) {
  # data = ...
  # cacheValid = true;
  # }
  # // Downgrade by acquiring read lock before releasing write lock
  # rwl.readLock().lock();
  # } finally  {
  # rwl.writeLock().unlock(); // Unlock write, still hold read
  # }
  # }
  # 
  # try {
  # use(data);
  # } finally {
  # rwl.readLock().unlock();
  # }
  # }
  # }}</pre>
  # 
  # ReentrantReadWriteLocks can be used to improve concurrency in some
  # uses of some kinds of Collections. This is typically worthwhile
  # only when the collections are expected to be large, accessed by
  # more reader threads than writer threads, and entail operations with
  # overhead that outweighs synchronization overhead. For example, here
  # is a class using a TreeMap that is expected to be large and
  # concurrently accessed.
  # 
  # <pre>{@code
  # class RWDictionary {
  # private final Map<String, Data> m = new TreeMap<String, Data>();
  # private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
  # private final Lock r = rwl.readLock();
  # private final Lock w = rwl.writeLock();
  # 
  # public Data get(String key) {
  # r.lock();
  # try { return m.get(key); }
  # finally { r.unlock(); }
  # }
  # public String[] allKeys() {
  # r.lock();
  # try { return m.keySet().toArray(); }
  # finally { r.unlock(); }
  # }
  # public Data put(String key, Data value) {
  # w.lock();
  # try { return m.put(key, value); }
  # finally { w.unlock(); }
  # }
  # public void clear() {
  # w.lock();
  # try { m.clear(); }
  # finally { w.unlock(); }
  # }
  # }}</pre>
  # 
  # <h3>Implementation Notes</h3>
  # 
  # <p>This lock supports a maximum of 65535 recursive write locks
  # and 65535 read locks. Attempts to exceed these limits result in
  # {@link Error} throws from locking methods.
  # 
  # @since 1.5
  # @author Doug Lea
  class ReentrantReadWriteLock 
    include_class_members ReentrantReadWriteLockImports
    include ReadWriteLock
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6992448646407690164 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Inner class providing readlock
    attr_accessor :reader_lock
    alias_method :attr_reader_lock, :reader_lock
    undef_method :reader_lock
    alias_method :attr_reader_lock=, :reader_lock=
    undef_method :reader_lock=
    
    # Inner class providing writelock
    attr_accessor :writer_lock
    alias_method :attr_writer_lock, :writer_lock
    undef_method :writer_lock
    alias_method :attr_writer_lock=, :writer_lock=
    undef_method :writer_lock=
    
    # Performs all synchronization mechanics
    attr_accessor :sync
    alias_method :attr_sync, :sync
    undef_method :sync
    alias_method :attr_sync=, :sync=
    undef_method :sync=
    
    typesig { [] }
    # Creates a new {@code ReentrantReadWriteLock} with
    # default (nonfair) ordering properties.
    def initialize
      initialize__reentrant_read_write_lock(false)
    end
    
    typesig { [::Java::Boolean] }
    # Creates a new {@code ReentrantReadWriteLock} with
    # the given fairness policy.
    # 
    # @param fair {@code true} if this lock should use a fair ordering policy
    def initialize(fair)
      @reader_lock = nil
      @writer_lock = nil
      @sync = nil
      @sync = (fair) ? FairSync.new : NonfairSync.new
      @reader_lock = ReadLock.new(self)
      @writer_lock = WriteLock.new(self)
    end
    
    typesig { [] }
    def write_lock
      return @writer_lock
    end
    
    typesig { [] }
    def read_lock
      return @reader_lock
    end
    
    class_module.module_eval {
      # Synchronization implementation for ReentrantReadWriteLock.
      # Subclassed into fair and nonfair versions.
      const_set_lazy(:Sync) { Class.new(AbstractQueuedSynchronizer) do
        include_class_members ReentrantReadWriteLock
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 6317671515068378041 }
          const_attr_reader  :SerialVersionUID
          
          # Read vs write count extraction constants and functions.
          # Lock state is logically divided into two shorts: The lower
          # one representing the exclusive (writer) lock hold count,
          # and the upper the shared (reader) hold count.
          const_set_lazy(:SHARED_SHIFT) { 16 }
          const_attr_reader  :SHARED_SHIFT
          
          const_set_lazy(:SHARED_UNIT) { (1 << self.class::SHARED_SHIFT) }
          const_attr_reader  :SHARED_UNIT
          
          const_set_lazy(:MAX_COUNT) { (1 << self.class::SHARED_SHIFT) - 1 }
          const_attr_reader  :MAX_COUNT
          
          const_set_lazy(:EXCLUSIVE_MASK) { (1 << self.class::SHARED_SHIFT) - 1 }
          const_attr_reader  :EXCLUSIVE_MASK
          
          typesig { [::Java::Int] }
          # Returns the number of shared holds represented in count
          def shared_count(c)
            return c >> self.class::SHARED_SHIFT
          end
          
          typesig { [::Java::Int] }
          # Returns the number of exclusive holds represented in count
          def exclusive_count(c)
            return c & self.class::EXCLUSIVE_MASK
          end
          
          # A counter for per-thread read hold counts.
          # Maintained as a ThreadLocal; cached in cachedHoldCounter
          const_set_lazy(:HoldCounter) { Class.new do
            include_class_members Sync
            
            attr_accessor :count
            alias_method :attr_count, :count
            undef_method :count
            alias_method :attr_count=, :count=
            undef_method :count=
            
            # Use id, not reference, to avoid garbage retention
            attr_accessor :tid
            alias_method :attr_tid, :tid
            undef_method :tid
            alias_method :attr_tid=, :tid=
            undef_method :tid=
            
            typesig { [] }
            # Decrement if positive; return previous value
            def try_decrement
              c = @count
              if (c > 0)
                @count = c - 1
              end
              return c
            end
            
            typesig { [] }
            def initialize
              @count = 0
              @tid = JavaThread.current_thread.get_id
            end
            
            private
            alias_method :initialize__hold_counter, :initialize
          end }
          
          # ThreadLocal subclass. Easiest to explicitly define for sake
          # of deserialization mechanics.
          const_set_lazy(:ThreadLocalHoldCounter) { Class.new(ThreadLocal) do
            include_class_members Sync
            
            typesig { [] }
            def initial_value
              return HoldCounter.new
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__thread_local_hold_counter, :initialize
          end }
        }
        
        # The number of read locks held by current thread.
        # Initialized only in constructor and readObject.
        attr_accessor :read_holds
        alias_method :attr_read_holds, :read_holds
        undef_method :read_holds
        alias_method :attr_read_holds=, :read_holds=
        undef_method :read_holds=
        
        # The hold count of the last thread to successfully acquire
        # readLock. This saves ThreadLocal lookup in the common case
        # where the next thread to release is the last one to
        # acquire. This is non-volatile since it is just used
        # as a heuristic, and would be great for threads to cache.
        attr_accessor :cached_hold_counter
        alias_method :attr_cached_hold_counter, :cached_hold_counter
        undef_method :cached_hold_counter
        alias_method :attr_cached_hold_counter=, :cached_hold_counter=
        undef_method :cached_hold_counter=
        
        typesig { [] }
        def initialize
          @read_holds = nil
          @cached_hold_counter = nil
          super()
          @read_holds = ThreadLocalHoldCounter.new
          set_state(get_state) # ensures visibility of readHolds
        end
        
        typesig { [] }
        # Acquires and releases use the same code for fair and
        # nonfair locks, but differ in whether/how they allow barging
        # when queues are non-empty.
        # 
        # 
        # Returns true if the current thread, when trying to acquire
        # the read lock, and otherwise eligible to do so, should block
        # because of policy for overtaking other waiting threads.
        def reader_should_block
          raise NotImplementedError
        end
        
        typesig { [] }
        # Returns true if the current thread, when trying to acquire
        # the write lock, and otherwise eligible to do so, should block
        # because of policy for overtaking other waiting threads.
        def writer_should_block
          raise NotImplementedError
        end
        
        typesig { [::Java::Int] }
        # Note that tryRelease and tryAcquire can be called by
        # Conditions. So it is possible that their arguments contain
        # both read and write holds that are all released during a
        # condition wait and re-established in tryAcquire.
        def try_release(releases)
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          nextc = get_state - releases
          free = (exclusive_count(nextc)).equal?(0)
          if (free)
            set_exclusive_owner_thread(nil)
          end
          set_state(nextc)
          return free
        end
        
        typesig { [::Java::Int] }
        def try_acquire(acquires)
          # Walkthrough:
          # 1. If read count nonzero or write count nonzero
          # and owner is a different thread, fail.
          # 2. If count would saturate, fail. (This can only
          # happen if count is already nonzero.)
          # 3. Otherwise, this thread is eligible for lock if
          # it is either a reentrant acquire or
          # queue policy allows it. If so, update state
          # and set owner.
          current = JavaThread.current_thread
          c = get_state
          w = exclusive_count(c)
          if (!(c).equal?(0))
            # (Note: if c != 0 and w == 0 then shared count != 0)
            if ((w).equal?(0) || !(current).equal?(get_exclusive_owner_thread))
              return false
            end
            if (w + exclusive_count(acquires) > self.class::MAX_COUNT)
              raise JavaError.new("Maximum lock count exceeded")
            end
            # Reentrant acquire
            set_state(c + acquires)
            return true
          end
          if (writer_should_block || !compare_and_set_state(c, c + acquires))
            return false
          end
          set_exclusive_owner_thread(current)
          return true
        end
        
        typesig { [::Java::Int] }
        def try_release_shared(unused)
          rh = @cached_hold_counter
          current = JavaThread.current_thread
          if ((rh).nil? || !(rh.attr_tid).equal?(current.get_id))
            rh = @read_holds.get
          end
          if (rh.try_decrement <= 0)
            raise IllegalMonitorStateException.new
          end
          loop do
            c = get_state
            nextc = c - self.class::SHARED_UNIT
            if (compare_and_set_state(c, nextc))
              return (nextc).equal?(0)
            end
          end
        end
        
        typesig { [::Java::Int] }
        def try_acquire_shared(unused)
          # Walkthrough:
          # 1. If write lock held by another thread, fail.
          # 2. If count saturated, throw error.
          # 3. Otherwise, this thread is eligible for
          # lock wrt state, so ask if it should block
          # because of queue policy. If not, try
          # to grant by CASing state and updating count.
          # Note that step does not check for reentrant
          # acquires, which is postponed to full version
          # to avoid having to check hold count in
          # the more typical non-reentrant case.
          # 4. If step 3 fails either because thread
          # apparently not eligible or CAS fails,
          # chain to version with full retry loop.
          current = JavaThread.current_thread
          c = get_state
          if (!(exclusive_count(c)).equal?(0) && !(get_exclusive_owner_thread).equal?(current))
            return -1
          end
          if ((shared_count(c)).equal?(self.class::MAX_COUNT))
            raise JavaError.new("Maximum lock count exceeded")
          end
          if (!reader_should_block && compare_and_set_state(c, c + self.class::SHARED_UNIT))
            rh = @cached_hold_counter
            if ((rh).nil? || !(rh.attr_tid).equal?(current.get_id))
              @cached_hold_counter = rh = @read_holds.get
            end
            rh.attr_count += 1
            return 1
          end
          return full_try_acquire_shared(current)
        end
        
        typesig { [JavaThread] }
        # Full version of acquire for reads, that handles CAS misses
        # and reentrant reads not dealt with in tryAcquireShared.
        def full_try_acquire_shared(current)
          # This code is in part redundant with that in
          # tryAcquireShared but is simpler overall by not
          # complicating tryAcquireShared with interactions between
          # retries and lazily reading hold counts.
          rh = @cached_hold_counter
          if ((rh).nil? || !(rh.attr_tid).equal?(current.get_id))
            rh = @read_holds.get
          end
          loop do
            c = get_state
            w = exclusive_count(c)
            if ((!(w).equal?(0) && !(get_exclusive_owner_thread).equal?(current)) || (((rh.attr_count | w)).equal?(0) && reader_should_block))
              return -1
            end
            if ((shared_count(c)).equal?(self.class::MAX_COUNT))
              raise JavaError.new("Maximum lock count exceeded")
            end
            if (compare_and_set_state(c, c + self.class::SHARED_UNIT))
              @cached_hold_counter = rh # cache for release
              rh.attr_count += 1
              return 1
            end
          end
        end
        
        typesig { [] }
        # Performs tryLock for write, enabling barging in both modes.
        # This is identical in effect to tryAcquire except for lack
        # of calls to writerShouldBlock
        def try_write_lock
          current = JavaThread.current_thread
          c = get_state
          if (!(c).equal?(0))
            w = exclusive_count(c)
            if ((w).equal?(0) || !(current).equal?(get_exclusive_owner_thread))
              return false
            end
            if ((w).equal?(self.class::MAX_COUNT))
              raise JavaError.new("Maximum lock count exceeded")
            end
          end
          if (!compare_and_set_state(c, c + 1))
            return false
          end
          set_exclusive_owner_thread(current)
          return true
        end
        
        typesig { [] }
        # Performs tryLock for read, enabling barging in both modes.
        # This is identical in effect to tryAcquireShared except for
        # lack of calls to readerShouldBlock
        def try_read_lock
          current = JavaThread.current_thread
          loop do
            c = get_state
            if (!(exclusive_count(c)).equal?(0) && !(get_exclusive_owner_thread).equal?(current))
              return false
            end
            if ((shared_count(c)).equal?(self.class::MAX_COUNT))
              raise JavaError.new("Maximum lock count exceeded")
            end
            if (compare_and_set_state(c, c + self.class::SHARED_UNIT))
              rh = @cached_hold_counter
              if ((rh).nil? || !(rh.attr_tid).equal?(current.get_id))
                @cached_hold_counter = rh = @read_holds.get
              end
              rh.attr_count += 1
              return true
            end
          end
        end
        
        typesig { [] }
        def is_held_exclusively
          # While we must in general read state before owner,
          # we don't need to do so to check if current thread is owner
          return (get_exclusive_owner_thread).equal?(JavaThread.current_thread)
        end
        
        typesig { [] }
        # Methods relayed to outer class
        def new_condition
          return ConditionObject.new
        end
        
        typesig { [] }
        def get_owner
          # Must read state before owner to ensure memory consistency
          return (((exclusive_count(get_state)).equal?(0)) ? nil : get_exclusive_owner_thread)
        end
        
        typesig { [] }
        def get_read_lock_count
          return shared_count(get_state)
        end
        
        typesig { [] }
        def is_write_locked
          return !(exclusive_count(get_state)).equal?(0)
        end
        
        typesig { [] }
        def get_write_hold_count
          return is_held_exclusively ? exclusive_count(get_state) : 0
        end
        
        typesig { [] }
        def get_read_hold_count
          return (get_read_lock_count).equal?(0) ? 0 : @read_holds.get.attr_count
        end
        
        typesig { [Java::Io::ObjectInputStream] }
        # Reconstitute this lock instance from a stream
        # @param s the stream
        def read_object(s)
          s.default_read_object
          @read_holds = ThreadLocalHoldCounter.new
          set_state(0) # reset to unlocked state
        end
        
        typesig { [] }
        def get_count
          return get_state
        end
        
        private
        alias_method :initialize__sync, :initialize
      end }
      
      # Nonfair version of Sync
      const_set_lazy(:NonfairSync) { Class.new(Sync) do
        include_class_members ReentrantReadWriteLock
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8159625535654395037 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def writer_should_block
          return false # writers can always barge
        end
        
        typesig { [] }
        def reader_should_block
          # As a heuristic to avoid indefinite writer starvation,
          # block if the thread that momentarily appears to be head
          # of queue, if one exists, is a waiting writer.  This is
          # only a probabilistic effect since a new reader will not
          # block if there is a waiting writer behind other enabled
          # readers that have not yet drained from the queue.
          return apparently_first_queued_is_exclusive
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__nonfair_sync, :initialize
      end }
      
      # Fair version of Sync
      const_set_lazy(:FairSync) { Class.new(Sync) do
        include_class_members ReentrantReadWriteLock
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -2274990926593161451 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def writer_should_block
          return has_queued_predecessors
        end
        
        typesig { [] }
        def reader_should_block
          return has_queued_predecessors
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__fair_sync, :initialize
      end }
      
      # The lock returned by method {@link ReentrantReadWriteLock#readLock}.
      const_set_lazy(:ReadLock) { Class.new do
        include_class_members ReentrantReadWriteLock
        include Lock
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -5992448646407690164 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :sync
        alias_method :attr_sync, :sync
        undef_method :sync
        alias_method :attr_sync=, :sync=
        undef_method :sync=
        
        typesig { [ReentrantReadWriteLock] }
        # Constructor for use by subclasses
        # 
        # @param lock the outer lock object
        # @throws NullPointerException if the lock is null
        def initialize(lock)
          @sync = nil
          @sync = lock.attr_sync
        end
        
        typesig { [] }
        # Acquires the read lock.
        # 
        # <p>Acquires the read lock if the write lock is not held by
        # another thread and returns immediately.
        # 
        # <p>If the write lock is held by another thread then
        # the current thread becomes disabled for thread scheduling
        # purposes and lies dormant until the read lock has been acquired.
        def lock
          @sync.acquire_shared(1)
        end
        
        typesig { [] }
        # Acquires the read lock unless the current thread is
        # {@linkplain Thread#interrupt interrupted}.
        # 
        # <p>Acquires the read lock if the write lock is not held
        # by another thread and returns immediately.
        # 
        # <p>If the write lock is held by another thread then the
        # current thread becomes disabled for thread scheduling
        # purposes and lies dormant until one of two things happens:
        # 
        # <ul>
        # 
        # <li>The read lock is acquired by the current thread; or
        # 
        # <li>Some other thread {@linkplain Thread#interrupt interrupts}
        # the current thread.
        # 
        # </ul>
        # 
        # <p>If the current thread:
        # 
        # <ul>
        # 
        # <li>has its interrupted status set on entry to this method; or
        # 
        # <li>is {@linkplain Thread#interrupt interrupted} while
        # acquiring the read lock,
        # 
        # </ul>
        # 
        # then {@link InterruptedException} is thrown and the current
        # thread's interrupted status is cleared.
        # 
        # <p>In this implementation, as this method is an explicit
        # interruption point, preference is given to responding to
        # the interrupt over normal or reentrant acquisition of the
        # lock.
        # 
        # @throws InterruptedException if the current thread is interrupted
        def lock_interruptibly
          @sync.acquire_shared_interruptibly(1)
        end
        
        typesig { [] }
        # Acquires the read lock only if the write lock is not held by
        # another thread at the time of invocation.
        # 
        # <p>Acquires the read lock if the write lock is not held by
        # another thread and returns immediately with the value
        # {@code true}. Even when this lock has been set to use a
        # fair ordering policy, a call to {@code tryLock()}
        # <em>will</em> immediately acquire the read lock if it is
        # available, whether or not other threads are currently
        # waiting for the read lock.  This &quot;barging&quot; behavior
        # can be useful in certain circumstances, even though it
        # breaks fairness. If you want to honor the fairness setting
        # for this lock, then use {@link #tryLock(long, TimeUnit)
        # tryLock(0, TimeUnit.SECONDS) } which is almost equivalent
        # (it also detects interruption).
        # 
        # <p>If the write lock is held by another thread then
        # this method will return immediately with the value
        # {@code false}.
        # 
        # @return {@code true} if the read lock was acquired
        def try_lock
          return @sync.try_read_lock
        end
        
        typesig { [::Java::Long, TimeUnit] }
        # Acquires the read lock if the write lock is not held by
        # another thread within the given waiting time and the
        # current thread has not been {@linkplain Thread#interrupt
        # interrupted}.
        # 
        # <p>Acquires the read lock if the write lock is not held by
        # another thread and returns immediately with the value
        # {@code true}. If this lock has been set to use a fair
        # ordering policy then an available lock <em>will not</em> be
        # acquired if any other threads are waiting for the
        # lock. This is in contrast to the {@link #tryLock()}
        # method. If you want a timed {@code tryLock} that does
        # permit barging on a fair lock then combine the timed and
        # un-timed forms together:
        # 
        # <pre>if (lock.tryLock() || lock.tryLock(timeout, unit) ) { ... }
        # </pre>
        # 
        # <p>If the write lock is held by another thread then the
        # current thread becomes disabled for thread scheduling
        # purposes and lies dormant until one of three things happens:
        # 
        # <ul>
        # 
        # <li>The read lock is acquired by the current thread; or
        # 
        # <li>Some other thread {@linkplain Thread#interrupt interrupts}
        # the current thread; or
        # 
        # <li>The specified waiting time elapses.
        # 
        # </ul>
        # 
        # <p>If the read lock is acquired then the value {@code true} is
        # returned.
        # 
        # <p>If the current thread:
        # 
        # <ul>
        # 
        # <li>has its interrupted status set on entry to this method; or
        # 
        # <li>is {@linkplain Thread#interrupt interrupted} while
        # acquiring the read lock,
        # 
        # </ul> then {@link InterruptedException} is thrown and the
        # current thread's interrupted status is cleared.
        # 
        # <p>If the specified waiting time elapses then the value
        # {@code false} is returned.  If the time is less than or
        # equal to zero, the method will not wait at all.
        # 
        # <p>In this implementation, as this method is an explicit
        # interruption point, preference is given to responding to
        # the interrupt over normal or reentrant acquisition of the
        # lock, and over reporting the elapse of the waiting time.
        # 
        # @param timeout the time to wait for the read lock
        # @param unit the time unit of the timeout argument
        # @return {@code true} if the read lock was acquired
        # @throws InterruptedException if the current thread is interrupted
        # @throws NullPointerException if the time unit is null
        def try_lock(timeout, unit)
          return @sync.try_acquire_shared_nanos(1, unit.to_nanos(timeout))
        end
        
        typesig { [] }
        # Attempts to release this lock.
        # 
        # <p> If the number of readers is now zero then the lock
        # is made available for write lock attempts.
        def unlock
          @sync.release_shared(1)
        end
        
        typesig { [] }
        # Throws {@code UnsupportedOperationException} because
        # {@code ReadLocks} do not support conditions.
        # 
        # @throws UnsupportedOperationException always
        def new_condition
          raise UnsupportedOperationException.new
        end
        
        typesig { [] }
        # Returns a string identifying this lock, as well as its lock state.
        # The state, in brackets, includes the String {@code "Read locks ="}
        # followed by the number of held read locks.
        # 
        # @return a string identifying this lock, as well as its lock state
        def to_s
          r = @sync.get_read_lock_count
          return RJava.cast_to_string(super) + "[Read locks = " + RJava.cast_to_string(r) + "]"
        end
        
        private
        alias_method :initialize__read_lock, :initialize
      end }
      
      # The lock returned by method {@link ReentrantReadWriteLock#writeLock}.
      const_set_lazy(:WriteLock) { Class.new do
        include_class_members ReentrantReadWriteLock
        include Lock
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -4992448646407690164 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :sync
        alias_method :attr_sync, :sync
        undef_method :sync
        alias_method :attr_sync=, :sync=
        undef_method :sync=
        
        typesig { [ReentrantReadWriteLock] }
        # Constructor for use by subclasses
        # 
        # @param lock the outer lock object
        # @throws NullPointerException if the lock is null
        def initialize(lock)
          @sync = nil
          @sync = lock.attr_sync
        end
        
        typesig { [] }
        # Acquires the write lock.
        # 
        # <p>Acquires the write lock if neither the read nor write lock
        # are held by another thread
        # and returns immediately, setting the write lock hold count to
        # one.
        # 
        # <p>If the current thread already holds the write lock then the
        # hold count is incremented by one and the method returns
        # immediately.
        # 
        # <p>If the lock is held by another thread then the current
        # thread becomes disabled for thread scheduling purposes and
        # lies dormant until the write lock has been acquired, at which
        # time the write lock hold count is set to one.
        def lock
          @sync.acquire(1)
        end
        
        typesig { [] }
        # Acquires the write lock unless the current thread is
        # {@linkplain Thread#interrupt interrupted}.
        # 
        # <p>Acquires the write lock if neither the read nor write lock
        # are held by another thread
        # and returns immediately, setting the write lock hold count to
        # one.
        # 
        # <p>If the current thread already holds this lock then the
        # hold count is incremented by one and the method returns
        # immediately.
        # 
        # <p>If the lock is held by another thread then the current
        # thread becomes disabled for thread scheduling purposes and
        # lies dormant until one of two things happens:
        # 
        # <ul>
        # 
        # <li>The write lock is acquired by the current thread; or
        # 
        # <li>Some other thread {@linkplain Thread#interrupt interrupts}
        # the current thread.
        # 
        # </ul>
        # 
        # <p>If the write lock is acquired by the current thread then the
        # lock hold count is set to one.
        # 
        # <p>If the current thread:
        # 
        # <ul>
        # 
        # <li>has its interrupted status set on entry to this method;
        # or
        # 
        # <li>is {@linkplain Thread#interrupt interrupted} while
        # acquiring the write lock,
        # 
        # </ul>
        # 
        # then {@link InterruptedException} is thrown and the current
        # thread's interrupted status is cleared.
        # 
        # <p>In this implementation, as this method is an explicit
        # interruption point, preference is given to responding to
        # the interrupt over normal or reentrant acquisition of the
        # lock.
        # 
        # @throws InterruptedException if the current thread is interrupted
        def lock_interruptibly
          @sync.acquire_interruptibly(1)
        end
        
        typesig { [] }
        # Acquires the write lock only if it is not held by another thread
        # at the time of invocation.
        # 
        # <p>Acquires the write lock if neither the read nor write lock
        # are held by another thread
        # and returns immediately with the value {@code true},
        # setting the write lock hold count to one. Even when this lock has
        # been set to use a fair ordering policy, a call to
        # {@code tryLock()} <em>will</em> immediately acquire the
        # lock if it is available, whether or not other threads are
        # currently waiting for the write lock.  This &quot;barging&quot;
        # behavior can be useful in certain circumstances, even
        # though it breaks fairness. If you want to honor the
        # fairness setting for this lock, then use {@link
        # #tryLock(long, TimeUnit) tryLock(0, TimeUnit.SECONDS) }
        # which is almost equivalent (it also detects interruption).
        # 
        # <p> If the current thread already holds this lock then the
        # hold count is incremented by one and the method returns
        # {@code true}.
        # 
        # <p>If the lock is held by another thread then this method
        # will return immediately with the value {@code false}.
        # 
        # @return {@code true} if the lock was free and was acquired
        # by the current thread, or the write lock was already held
        # by the current thread; and {@code false} otherwise.
        def try_lock
          return @sync.try_write_lock
        end
        
        typesig { [::Java::Long, TimeUnit] }
        # Acquires the write lock if it is not held by another thread
        # within the given waiting time and the current thread has
        # not been {@linkplain Thread#interrupt interrupted}.
        # 
        # <p>Acquires the write lock if neither the read nor write lock
        # are held by another thread
        # and returns immediately with the value {@code true},
        # setting the write lock hold count to one. If this lock has been
        # set to use a fair ordering policy then an available lock
        # <em>will not</em> be acquired if any other threads are
        # waiting for the write lock. This is in contrast to the {@link
        # #tryLock()} method. If you want a timed {@code tryLock}
        # that does permit barging on a fair lock then combine the
        # timed and un-timed forms together:
        # 
        # <pre>if (lock.tryLock() || lock.tryLock(timeout, unit) ) { ... }
        # </pre>
        # 
        # <p>If the current thread already holds this lock then the
        # hold count is incremented by one and the method returns
        # {@code true}.
        # 
        # <p>If the lock is held by another thread then the current
        # thread becomes disabled for thread scheduling purposes and
        # lies dormant until one of three things happens:
        # 
        # <ul>
        # 
        # <li>The write lock is acquired by the current thread; or
        # 
        # <li>Some other thread {@linkplain Thread#interrupt interrupts}
        # the current thread; or
        # 
        # <li>The specified waiting time elapses
        # 
        # </ul>
        # 
        # <p>If the write lock is acquired then the value {@code true} is
        # returned and the write lock hold count is set to one.
        # 
        # <p>If the current thread:
        # 
        # <ul>
        # 
        # <li>has its interrupted status set on entry to this method;
        # or
        # 
        # <li>is {@linkplain Thread#interrupt interrupted} while
        # acquiring the write lock,
        # 
        # </ul>
        # 
        # then {@link InterruptedException} is thrown and the current
        # thread's interrupted status is cleared.
        # 
        # <p>If the specified waiting time elapses then the value
        # {@code false} is returned.  If the time is less than or
        # equal to zero, the method will not wait at all.
        # 
        # <p>In this implementation, as this method is an explicit
        # interruption point, preference is given to responding to
        # the interrupt over normal or reentrant acquisition of the
        # lock, and over reporting the elapse of the waiting time.
        # 
        # @param timeout the time to wait for the write lock
        # @param unit the time unit of the timeout argument
        # 
        # @return {@code true} if the lock was free and was acquired
        # by the current thread, or the write lock was already held by the
        # current thread; and {@code false} if the waiting time
        # elapsed before the lock could be acquired.
        # 
        # @throws InterruptedException if the current thread is interrupted
        # @throws NullPointerException if the time unit is null
        def try_lock(timeout, unit)
          return @sync.try_acquire_nanos(1, unit.to_nanos(timeout))
        end
        
        typesig { [] }
        # Attempts to release this lock.
        # 
        # <p>If the current thread is the holder of this lock then
        # the hold count is decremented. If the hold count is now
        # zero then the lock is released.  If the current thread is
        # not the holder of this lock then {@link
        # IllegalMonitorStateException} is thrown.
        # 
        # @throws IllegalMonitorStateException if the current thread does not
        # hold this lock.
        def unlock
          @sync.release(1)
        end
        
        typesig { [] }
        # Returns a {@link Condition} instance for use with this
        # {@link Lock} instance.
        # <p>The returned {@link Condition} instance supports the same
        # usages as do the {@link Object} monitor methods ({@link
        # Object#wait() wait}, {@link Object#notify notify}, and {@link
        # Object#notifyAll notifyAll}) when used with the built-in
        # monitor lock.
        # 
        # <ul>
        # 
        # <li>If this write lock is not held when any {@link
        # Condition} method is called then an {@link
        # IllegalMonitorStateException} is thrown.  (Read locks are
        # held independently of write locks, so are not checked or
        # affected. However it is essentially always an error to
        # invoke a condition waiting method when the current thread
        # has also acquired read locks, since other threads that
        # could unblock it will not be able to acquire the write
        # lock.)
        # 
        # <li>When the condition {@linkplain Condition#await() waiting}
        # methods are called the write lock is released and, before
        # they return, the write lock is reacquired and the lock hold
        # count restored to what it was when the method was called.
        # 
        # <li>If a thread is {@linkplain Thread#interrupt interrupted} while
        # waiting then the wait will terminate, an {@link
        # InterruptedException} will be thrown, and the thread's
        # interrupted status will be cleared.
        # 
        # <li> Waiting threads are signalled in FIFO order.
        # 
        # <li>The ordering of lock reacquisition for threads returning
        # from waiting methods is the same as for threads initially
        # acquiring the lock, which is in the default case not specified,
        # but for <em>fair</em> locks favors those threads that have been
        # waiting the longest.
        # 
        # </ul>
        # 
        # @return the Condition object
        def new_condition
          return @sync.new_condition
        end
        
        typesig { [] }
        # Returns a string identifying this lock, as well as its lock
        # state.  The state, in brackets includes either the String
        # {@code "Unlocked"} or the String {@code "Locked by"}
        # followed by the {@linkplain Thread#getName name} of the owning thread.
        # 
        # @return a string identifying this lock, as well as its lock state
        def to_s
          o = @sync.get_owner
          return super + (((o).nil?) ? "[Unlocked]" : "[Locked by thread " + RJava.cast_to_string(o.get_name) + "]")
        end
        
        typesig { [] }
        # Queries if this write lock is held by the current thread.
        # Identical in effect to {@link
        # ReentrantReadWriteLock#isWriteLockedByCurrentThread}.
        # 
        # @return {@code true} if the current thread holds this lock and
        # {@code false} otherwise
        # @since 1.6
        def is_held_by_current_thread
          return @sync.is_held_exclusively
        end
        
        typesig { [] }
        # Queries the number of holds on this write lock by the current
        # thread.  A thread has a hold on a lock for each lock action
        # that is not matched by an unlock action.  Identical in effect
        # to {@link ReentrantReadWriteLock#getWriteHoldCount}.
        # 
        # @return the number of holds on this lock by the current thread,
        # or zero if this lock is not held by the current thread
        # @since 1.6
        def get_hold_count
          return @sync.get_write_hold_count
        end
        
        private
        alias_method :initialize__write_lock, :initialize
      end }
    }
    
    typesig { [] }
    # Instrumentation and status
    # 
    # Returns {@code true} if this lock has fairness set true.
    # 
    # @return {@code true} if this lock has fairness set true
    def is_fair
      return @sync.is_a?(FairSync)
    end
    
    typesig { [] }
    # Returns the thread that currently owns the write lock, or
    # {@code null} if not owned. When this method is called by a
    # thread that is not the owner, the return value reflects a
    # best-effort approximation of current lock status. For example,
    # the owner may be momentarily {@code null} even if there are
    # threads trying to acquire the lock but have not yet done so.
    # This method is designed to facilitate construction of
    # subclasses that provide more extensive lock monitoring
    # facilities.
    # 
    # @return the owner, or {@code null} if not owned
    def get_owner
      return @sync.get_owner
    end
    
    typesig { [] }
    # Queries the number of read locks held for this lock. This
    # method is designed for use in monitoring system state, not for
    # synchronization control.
    # @return the number of read locks held.
    def get_read_lock_count
      return @sync.get_read_lock_count
    end
    
    typesig { [] }
    # Queries if the write lock is held by any thread. This method is
    # designed for use in monitoring system state, not for
    # synchronization control.
    # 
    # @return {@code true} if any thread holds the write lock and
    # {@code false} otherwise
    def is_write_locked
      return @sync.is_write_locked
    end
    
    typesig { [] }
    # Queries if the write lock is held by the current thread.
    # 
    # @return {@code true} if the current thread holds the write lock and
    # {@code false} otherwise
    def is_write_locked_by_current_thread
      return @sync.is_held_exclusively
    end
    
    typesig { [] }
    # Queries the number of reentrant write holds on this lock by the
    # current thread.  A writer thread has a hold on a lock for
    # each lock action that is not matched by an unlock action.
    # 
    # @return the number of holds on the write lock by the current thread,
    # or zero if the write lock is not held by the current thread
    def get_write_hold_count
      return @sync.get_write_hold_count
    end
    
    typesig { [] }
    # Queries the number of reentrant read holds on this lock by the
    # current thread.  A reader thread has a hold on a lock for
    # each lock action that is not matched by an unlock action.
    # 
    # @return the number of holds on the read lock by the current thread,
    # or zero if the read lock is not held by the current thread
    # @since 1.6
    def get_read_hold_count
      return @sync.get_read_hold_count
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire the write lock.  Because the actual set of threads may
    # change dynamically while constructing this result, the returned
    # collection is only a best-effort estimate.  The elements of the
    # returned collection are in no particular order.  This method is
    # designed to facilitate construction of subclasses that provide
    # more extensive lock monitoring facilities.
    # 
    # @return the collection of threads
    def get_queued_writer_threads
      return @sync.get_exclusive_queued_threads
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire the read lock.  Because the actual set of threads may
    # change dynamically while constructing this result, the returned
    # collection is only a best-effort estimate.  The elements of the
    # returned collection are in no particular order.  This method is
    # designed to facilitate construction of subclasses that provide
    # more extensive lock monitoring facilities.
    # 
    # @return the collection of threads
    def get_queued_reader_threads
      return @sync.get_shared_queued_threads
    end
    
    typesig { [] }
    # Queries whether any threads are waiting to acquire the read or
    # write lock. Note that because cancellations may occur at any
    # time, a {@code true} return does not guarantee that any other
    # thread will ever acquire a lock.  This method is designed
    # primarily for use in monitoring of the system state.
    # 
    # @return {@code true} if there may be other threads waiting to
    # acquire the lock
    def has_queued_threads
      return @sync.has_queued_threads
    end
    
    typesig { [JavaThread] }
    # Queries whether the given thread is waiting to acquire either
    # the read or write lock. Note that because cancellations may
    # occur at any time, a {@code true} return does not guarantee
    # that this thread will ever acquire a lock.  This method is
    # designed primarily for use in monitoring of the system state.
    # 
    # @param thread the thread
    # @return {@code true} if the given thread is queued waiting for this lock
    # @throws NullPointerException if the thread is null
    def has_queued_thread(thread)
      return @sync.is_queued(thread)
    end
    
    typesig { [] }
    # Returns an estimate of the number of threads waiting to acquire
    # either the read or write lock.  The value is only an estimate
    # because the number of threads may change dynamically while this
    # method traverses internal data structures.  This method is
    # designed for use in monitoring of the system state, not for
    # synchronization control.
    # 
    # @return the estimated number of threads waiting for this lock
    def get_queue_length
      return @sync.get_queue_length
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire either the read or write lock.  Because the actual set
    # of threads may change dynamically while constructing this
    # result, the returned collection is only a best-effort estimate.
    # The elements of the returned collection are in no particular
    # order.  This method is designed to facilitate construction of
    # subclasses that provide more extensive monitoring facilities.
    # 
    # @return the collection of threads
    def get_queued_threads
      return @sync.get_queued_threads
    end
    
    typesig { [Condition] }
    # Queries whether any threads are waiting on the given condition
    # associated with the write lock. Note that because timeouts and
    # interrupts may occur at any time, a {@code true} return does
    # not guarantee that a future {@code signal} will awaken any
    # threads.  This method is designed primarily for use in
    # monitoring of the system state.
    # 
    # @param condition the condition
    # @return {@code true} if there are any waiting threads
    # @throws IllegalMonitorStateException if this lock is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this lock
    # @throws NullPointerException if the condition is null
    def has_waiters(condition)
      if ((condition).nil?)
        raise NullPointerException.new
      end
      if (!(condition.is_a?(AbstractQueuedSynchronizer::ConditionObject)))
        raise IllegalArgumentException.new("not owner")
      end
      return @sync.has_waiters(condition)
    end
    
    typesig { [Condition] }
    # Returns an estimate of the number of threads waiting on the
    # given condition associated with the write lock. Note that because
    # timeouts and interrupts may occur at any time, the estimate
    # serves only as an upper bound on the actual number of waiters.
    # This method is designed for use in monitoring of the system
    # state, not for synchronization control.
    # 
    # @param condition the condition
    # @return the estimated number of waiting threads
    # @throws IllegalMonitorStateException if this lock is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this lock
    # @throws NullPointerException if the condition is null
    def get_wait_queue_length(condition)
      if ((condition).nil?)
        raise NullPointerException.new
      end
      if (!(condition.is_a?(AbstractQueuedSynchronizer::ConditionObject)))
        raise IllegalArgumentException.new("not owner")
      end
      return @sync.get_wait_queue_length(condition)
    end
    
    typesig { [Condition] }
    # Returns a collection containing those threads that may be
    # waiting on the given condition associated with the write lock.
    # Because the actual set of threads may change dynamically while
    # constructing this result, the returned collection is only a
    # best-effort estimate. The elements of the returned collection
    # are in no particular order.  This method is designed to
    # facilitate construction of subclasses that provide more
    # extensive condition monitoring facilities.
    # 
    # @param condition the condition
    # @return the collection of threads
    # @throws IllegalMonitorStateException if this lock is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this lock
    # @throws NullPointerException if the condition is null
    def get_waiting_threads(condition)
      if ((condition).nil?)
        raise NullPointerException.new
      end
      if (!(condition.is_a?(AbstractQueuedSynchronizer::ConditionObject)))
        raise IllegalArgumentException.new("not owner")
      end
      return @sync.get_waiting_threads(condition)
    end
    
    typesig { [] }
    # Returns a string identifying this lock, as well as its lock state.
    # The state, in brackets, includes the String {@code "Write locks ="}
    # followed by the number of reentrantly held write locks, and the
    # String {@code "Read locks ="} followed by the number of held
    # read locks.
    # 
    # @return a string identifying this lock, as well as its lock state
    def to_s
      c = @sync.get_count
      w = Sync.exclusive_count(c)
      r = Sync.shared_count(c)
      return RJava.cast_to_string(super) + "[Write locks = " + RJava.cast_to_string(w) + ", Read locks = " + RJava.cast_to_string(r) + "]"
    end
    
    private
    alias_method :initialize__reentrant_read_write_lock, :initialize
  end
  
end

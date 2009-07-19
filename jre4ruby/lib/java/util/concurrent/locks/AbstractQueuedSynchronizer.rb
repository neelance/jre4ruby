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
  module AbstractQueuedSynchronizerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Atomic
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Provides a framework for implementing blocking locks and related
  # synchronizers (semaphores, events, etc) that rely on
  # first-in-first-out (FIFO) wait queues.  This class is designed to
  # be a useful basis for most kinds of synchronizers that rely on a
  # single atomic <tt>int</tt> value to represent state. Subclasses
  # must define the protected methods that change this state, and which
  # define what that state means in terms of this object being acquired
  # or released.  Given these, the other methods in this class carry
  # out all queuing and blocking mechanics. Subclasses can maintain
  # other state fields, but only the atomically updated <tt>int</tt>
  # value manipulated using methods {@link #getState}, {@link
  # #setState} and {@link #compareAndSetState} is tracked with respect
  # to synchronization.
  # 
  # <p>Subclasses should be defined as non-public internal helper
  # classes that are used to implement the synchronization properties
  # of their enclosing class.  Class
  # <tt>AbstractQueuedSynchronizer</tt> does not implement any
  # synchronization interface.  Instead it defines methods such as
  # {@link #acquireInterruptibly} that can be invoked as
  # appropriate by concrete locks and related synchronizers to
  # implement their public methods.
  # 
  # <p>This class supports either or both a default <em>exclusive</em>
  # mode and a <em>shared</em> mode. When acquired in exclusive mode,
  # attempted acquires by other threads cannot succeed. Shared mode
  # acquires by multiple threads may (but need not) succeed. This class
  # does not &quot;understand&quot; these differences except in the
  # mechanical sense that when a shared mode acquire succeeds, the next
  # waiting thread (if one exists) must also determine whether it can
  # acquire as well. Threads waiting in the different modes share the
  # same FIFO queue. Usually, implementation subclasses support only
  # one of these modes, but both can come into play for example in a
  # {@link ReadWriteLock}. Subclasses that support only exclusive or
  # only shared modes need not define the methods supporting the unused mode.
  # 
  # <p>This class defines a nested {@link ConditionObject} class that
  # can be used as a {@link Condition} implementation by subclasses
  # supporting exclusive mode for which method {@link
  # #isHeldExclusively} reports whether synchronization is exclusively
  # held with respect to the current thread, method {@link #release}
  # invoked with the current {@link #getState} value fully releases
  # this object, and {@link #acquire}, given this saved state value,
  # eventually restores this object to its previous acquired state.  No
  # <tt>AbstractQueuedSynchronizer</tt> method otherwise creates such a
  # condition, so if this constraint cannot be met, do not use it.  The
  # behavior of {@link ConditionObject} depends of course on the
  # semantics of its synchronizer implementation.
  # 
  # <p>This class provides inspection, instrumentation, and monitoring
  # methods for the internal queue, as well as similar methods for
  # condition objects. These can be exported as desired into classes
  # using an <tt>AbstractQueuedSynchronizer</tt> for their
  # synchronization mechanics.
  # 
  # <p>Serialization of this class stores only the underlying atomic
  # integer maintaining state, so deserialized objects have empty
  # thread queues. Typical subclasses requiring serializability will
  # define a <tt>readObject</tt> method that restores this to a known
  # initial state upon deserialization.
  # 
  # <h3>Usage</h3>
  # 
  # <p>To use this class as the basis of a synchronizer, redefine the
  # following methods, as applicable, by inspecting and/or modifying
  # the synchronization state using {@link #getState}, {@link
  # #setState} and/or {@link #compareAndSetState}:
  # 
  # <ul>
  # <li> {@link #tryAcquire}
  # <li> {@link #tryRelease}
  # <li> {@link #tryAcquireShared}
  # <li> {@link #tryReleaseShared}
  # <li> {@link #isHeldExclusively}
  # </ul>
  # 
  # Each of these methods by default throws {@link
  # UnsupportedOperationException}.  Implementations of these methods
  # must be internally thread-safe, and should in general be short and
  # not block. Defining these methods is the <em>only</em> supported
  # means of using this class. All other methods are declared
  # <tt>final</tt> because they cannot be independently varied.
  # 
  # <p>You may also find the inherited methods from {@link
  # AbstractOwnableSynchronizer} useful to keep track of the thread
  # owning an exclusive synchronizer.  You are encouraged to use them
  # -- this enables monitoring and diagnostic tools to assist users in
  # determining which threads hold locks.
  # 
  # <p>Even though this class is based on an internal FIFO queue, it
  # does not automatically enforce FIFO acquisition policies.  The core
  # of exclusive synchronization takes the form:
  # 
  # <pre>
  # Acquire:
  # while (!tryAcquire(arg)) {
  # <em>enqueue thread if it is not already queued</em>;
  # <em>possibly block current thread</em>;
  # }
  # 
  # Release:
  # if (tryRelease(arg))
  # <em>unblock the first queued thread</em>;
  # </pre>
  # 
  # (Shared mode is similar but may involve cascading signals.)
  # 
  # <p><a name="barging">Because checks in acquire are invoked before enqueuing, a newly
  # acquiring thread may <em>barge</em> ahead of others that are
  # blocked and queued. However, you can, if desired, define
  # <tt>tryAcquire</tt> and/or <tt>tryAcquireShared</tt> to disable
  # barging by internally invoking one or more of the inspection
  # methods. In particular, a strict FIFO lock can define
  # <tt>tryAcquire</tt> to immediately return <tt>false</tt> if {@link
  # #getFirstQueuedThread} does not return the current thread.  A
  # normally preferable non-strict fair version can immediately return
  # <tt>false</tt> only if {@link #hasQueuedThreads} returns
  # <tt>true</tt> and <tt>getFirstQueuedThread</tt> is not the current
  # thread; or equivalently, that <tt>getFirstQueuedThread</tt> is both
  # non-null and not the current thread.  Further variations are
  # possible.
  # 
  # <p>Throughput and scalability are generally highest for the
  # default barging (also known as <em>greedy</em>,
  # <em>renouncement</em>, and <em>convoy-avoidance</em>) strategy.
  # While this is not guaranteed to be fair or starvation-free, earlier
  # queued threads are allowed to recontend before later queued
  # threads, and each recontention has an unbiased chance to succeed
  # against incoming threads.  Also, while acquires do not
  # &quot;spin&quot; in the usual sense, they may perform multiple
  # invocations of <tt>tryAcquire</tt> interspersed with other
  # computations before blocking.  This gives most of the benefits of
  # spins when exclusive synchronization is only briefly held, without
  # most of the liabilities when it isn't. If so desired, you can
  # augment this by preceding calls to acquire methods with
  # "fast-path" checks, possibly prechecking {@link #hasContended}
  # and/or {@link #hasQueuedThreads} to only do so if the synchronizer
  # is likely not to be contended.
  # 
  # <p>This class provides an efficient and scalable basis for
  # synchronization in part by specializing its range of use to
  # synchronizers that can rely on <tt>int</tt> state, acquire, and
  # release parameters, and an internal FIFO wait queue. When this does
  # not suffice, you can build synchronizers from a lower level using
  # {@link java.util.concurrent.atomic atomic} classes, your own custom
  # {@link java.util.Queue} classes, and {@link LockSupport} blocking
  # support.
  # 
  # <h3>Usage Examples</h3>
  # 
  # <p>Here is a non-reentrant mutual exclusion lock class that uses
  # the value zero to represent the unlocked state, and one to
  # represent the locked state. While a non-reentrant lock
  # does not strictly require recording of the current owner
  # thread, this class does so anyway to make usage easier to monitor.
  # It also supports conditions and exposes
  # one of the instrumentation methods:
  # 
  # <pre>
  # class Mutex implements Lock, java.io.Serializable {
  # 
  # // Our internal helper class
  # private static class Sync extends AbstractQueuedSynchronizer {
  # // Report whether in locked state
  # protected boolean isHeldExclusively() {
  # return getState() == 1;
  # }
  # 
  # // Acquire the lock if state is zero
  # public boolean tryAcquire(int acquires) {
  # assert acquires == 1; // Otherwise unused
  # if (compareAndSetState(0, 1)) {
  # setExclusiveOwnerThread(Thread.currentThread());
  # return true;
  # }
  # return false;
  # }
  # 
  # // Release the lock by setting state to zero
  # protected boolean tryRelease(int releases) {
  # assert releases == 1; // Otherwise unused
  # if (getState() == 0) throw new IllegalMonitorStateException();
  # setExclusiveOwnerThread(null);
  # setState(0);
  # return true;
  # }
  # 
  # // Provide a Condition
  # Condition newCondition() { return new ConditionObject(); }
  # 
  # // Deserialize properly
  # private void readObject(ObjectInputStream s)
  # throws IOException, ClassNotFoundException {
  # s.defaultReadObject();
  # setState(0); // reset to unlocked state
  # }
  # }
  # 
  # // The sync object does all the hard work. We just forward to it.
  # private final Sync sync = new Sync();
  # 
  # public void lock()                { sync.acquire(1); }
  # public boolean tryLock()          { return sync.tryAcquire(1); }
  # public void unlock()              { sync.release(1); }
  # public Condition newCondition()   { return sync.newCondition(); }
  # public boolean isLocked()         { return sync.isHeldExclusively(); }
  # public boolean hasQueuedThreads() { return sync.hasQueuedThreads(); }
  # public void lockInterruptibly() throws InterruptedException {
  # sync.acquireInterruptibly(1);
  # }
  # public boolean tryLock(long timeout, TimeUnit unit)
  # throws InterruptedException {
  # return sync.tryAcquireNanos(1, unit.toNanos(timeout));
  # }
  # }
  # </pre>
  # 
  # <p>Here is a latch class that is like a {@link CountDownLatch}
  # except that it only requires a single <tt>signal</tt> to
  # fire. Because a latch is non-exclusive, it uses the <tt>shared</tt>
  # acquire and release methods.
  # 
  # <pre>
  # class BooleanLatch {
  # 
  # private static class Sync extends AbstractQueuedSynchronizer {
  # boolean isSignalled() { return getState() != 0; }
  # 
  # protected int tryAcquireShared(int ignore) {
  # return isSignalled()? 1 : -1;
  # }
  # 
  # protected boolean tryReleaseShared(int ignore) {
  # setState(1);
  # return true;
  # }
  # }
  # 
  # private final Sync sync = new Sync();
  # public boolean isSignalled() { return sync.isSignalled(); }
  # public void signal()         { sync.releaseShared(1); }
  # public void await() throws InterruptedException {
  # sync.acquireSharedInterruptibly(1);
  # }
  # }
  # </pre>
  # 
  # @since 1.5
  # @author Doug Lea
  class AbstractQueuedSynchronizer < AbstractQueuedSynchronizerImports.const_get :AbstractOwnableSynchronizer
    include_class_members AbstractQueuedSynchronizerImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7373984972572414691 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new <tt>AbstractQueuedSynchronizer</tt> instance
    # with initial synchronization state of zero.
    def initialize
      @head = nil
      @tail = nil
      @state = 0
      super()
    end
    
    class_module.module_eval {
      # Wait queue node class.
      # 
      # <p>The wait queue is a variant of a "CLH" (Craig, Landin, and
      # Hagersten) lock queue. CLH locks are normally used for
      # spinlocks.  We instead use them for blocking synchronizers, but
      # use the same basic tactic of holding some of the control
      # information about a thread in the predecessor of its node.  A
      # "status" field in each node keeps track of whether a thread
      # should block.  A node is signalled when its predecessor
      # releases.  Each node of the queue otherwise serves as a
      # specific-notification-style monitor holding a single waiting
      # thread. The status field does NOT control whether threads are
      # granted locks etc though.  A thread may try to acquire if it is
      # first in the queue. But being first does not guarantee success;
      # it only gives the right to contend.  So the currently released
      # contender thread may need to rewait.
      # 
      # <p>To enqueue into a CLH lock, you atomically splice it in as new
      # tail. To dequeue, you just set the head field.
      # <pre>
      # +------+  prev +-----+       +-----+
      # head |      | <---- |     | <---- |     |  tail
      # +------+       +-----+       +-----+
      # </pre>
      # 
      # <p>Insertion into a CLH queue requires only a single atomic
      # operation on "tail", so there is a simple atomic point of
      # demarcation from unqueued to queued. Similarly, dequeing
      # involves only updating the "head". However, it takes a bit
      # more work for nodes to determine who their successors are,
      # in part to deal with possible cancellation due to timeouts
      # and interrupts.
      # 
      # <p>The "prev" links (not used in original CLH locks), are mainly
      # needed to handle cancellation. If a node is cancelled, its
      # successor is (normally) relinked to a non-cancelled
      # predecessor. For explanation of similar mechanics in the case
      # of spin locks, see the papers by Scott and Scherer at
      # http://www.cs.rochester.edu/u/scott/synchronization/
      # 
      # <p>We also use "next" links to implement blocking mechanics.
      # The thread id for each node is kept in its own node, so a
      # predecessor signals the next node to wake up by traversing
      # next link to determine which thread it is.  Determination of
      # successor must avoid races with newly queued nodes to set
      # the "next" fields of their predecessors.  This is solved
      # when necessary by checking backwards from the atomically
      # updated "tail" when a node's successor appears to be null.
      # (Or, said differently, the next-links are an optimization
      # so that we don't usually need a backward scan.)
      # 
      # <p>Cancellation introduces some conservatism to the basic
      # algorithms.  Since we must poll for cancellation of other
      # nodes, we can miss noticing whether a cancelled node is
      # ahead or behind us. This is dealt with by always unparking
      # successors upon cancellation, allowing them to stabilize on
      # a new predecessor, unless we can identify an uncancelled
      # predecessor who will carry this responsibility.
      # 
      # <p>CLH queues need a dummy header node to get started. But
      # we don't create them on construction, because it would be wasted
      # effort if there is never contention. Instead, the node
      # is constructed and head and tail pointers are set upon first
      # contention.
      # 
      # <p>Threads waiting on Conditions use the same nodes, but
      # use an additional link. Conditions only need to link nodes
      # in simple (non-concurrent) linked queues because they are
      # only accessed when exclusively held.  Upon await, a node is
      # inserted into a condition queue.  Upon signal, the node is
      # transferred to the main queue.  A special value of status
      # field is used to mark which queue a node is on.
      # 
      # <p>Thanks go to Dave Dice, Mark Moir, Victor Luchangco, Bill
      # Scherer and Michael Scott, along with members of JSR-166
      # expert group, for helpful ideas, discussions, and critiques
      # on the design of this class.
      const_set_lazy(:Node) { Class.new do
        include_class_members AbstractQueuedSynchronizer
        
        class_module.module_eval {
          # Marker to indicate a node is waiting in shared mode
          const_set_lazy(:SHARED) { Node.new }
          const_attr_reader  :SHARED
          
          # Marker to indicate a node is waiting in exclusive mode
          const_set_lazy(:EXCLUSIVE) { nil }
          const_attr_reader  :EXCLUSIVE
          
          # waitStatus value to indicate thread has cancelled
          const_set_lazy(:CANCELLED) { 1 }
          const_attr_reader  :CANCELLED
          
          # waitStatus value to indicate successor's thread needs unparking
          const_set_lazy(:SIGNAL) { -1 }
          const_attr_reader  :SIGNAL
          
          # waitStatus value to indicate thread is waiting on condition
          const_set_lazy(:CONDITION) { -2 }
          const_attr_reader  :CONDITION
          
          # waitStatus value to indicate the next acquireShared should
          # unconditionally propagate
          const_set_lazy(:PROPAGATE) { -3 }
          const_attr_reader  :PROPAGATE
        }
        
        # Status field, taking on only the values:
        # SIGNAL:     The successor of this node is (or will soon be)
        # blocked (via park), so the current node must
        # unpark its successor when it releases or
        # cancels. To avoid races, acquire methods must
        # first indicate they need a signal,
        # then retry the atomic acquire, and then,
        # on failure, block.
        # CANCELLED:  This node is cancelled due to timeout or interrupt.
        # Nodes never leave this state. In particular,
        # a thread with cancelled node never again blocks.
        # CONDITION:  This node is currently on a condition queue.
        # It will not be used as a sync queue node
        # until transferred, at which time the status
        # will be set to 0. (Use of this value here has
        # nothing to do with the other uses of the
        # field, but simplifies mechanics.)
        # PROPAGATE:  A releaseShared should be propagated to other
        # nodes. This is set (for head node only) in
        # doReleaseShared to ensure propagation
        # continues, even if other operations have
        # since intervened.
        # 0:          None of the above
        # 
        # The values are arranged numerically to simplify use.
        # Non-negative values mean that a node doesn't need to
        # signal. So, most code doesn't need to check for particular
        # values, just for sign.
        # 
        # The field is initialized to 0 for normal sync nodes, and
        # CONDITION for condition nodes.  It is modified using CAS
        # (or when possible, unconditional volatile writes).
        attr_accessor :wait_status
        alias_method :attr_wait_status, :wait_status
        undef_method :wait_status
        alias_method :attr_wait_status=, :wait_status=
        undef_method :wait_status=
        
        # Link to predecessor node that current node/thread relies on
        # for checking waitStatus. Assigned during enqueing, and nulled
        # out (for sake of GC) only upon dequeuing.  Also, upon
        # cancellation of a predecessor, we short-circuit while
        # finding a non-cancelled one, which will always exist
        # because the head node is never cancelled: A node becomes
        # head only as a result of successful acquire. A
        # cancelled thread never succeeds in acquiring, and a thread only
        # cancels itself, not any other node.
        attr_accessor :prev
        alias_method :attr_prev, :prev
        undef_method :prev
        alias_method :attr_prev=, :prev=
        undef_method :prev=
        
        # Link to the successor node that the current node/thread
        # unparks upon release. Assigned during enqueuing, adjusted
        # when bypassing cancelled predecessors, and nulled out (for
        # sake of GC) when dequeued.  The enq operation does not
        # assign next field of a predecessor until after attachment,
        # so seeing a null next field does not necessarily mean that
        # node is at end of queue. However, if a next field appears
        # to be null, we can scan prev's from the tail to
        # double-check.  The next field of cancelled nodes is set to
        # point to the node itself instead of null, to make life
        # easier for isOnSyncQueue.
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        # The thread that enqueued this node.  Initialized on
        # construction and nulled out after use.
        attr_accessor :thread
        alias_method :attr_thread, :thread
        undef_method :thread
        alias_method :attr_thread=, :thread=
        undef_method :thread=
        
        # Link to next node waiting on condition, or the special
        # value SHARED.  Because condition queues are accessed only
        # when holding in exclusive mode, we just need a simple
        # linked queue to hold nodes while they are waiting on
        # conditions. They are then transferred to the queue to
        # re-acquire. And because conditions can only be exclusive,
        # we save a field by using special value to indicate shared
        # mode.
        attr_accessor :next_waiter
        alias_method :attr_next_waiter, :next_waiter
        undef_method :next_waiter
        alias_method :attr_next_waiter=, :next_waiter=
        undef_method :next_waiter=
        
        typesig { [] }
        # Returns true if node is waiting in shared mode
        def is_shared
          return (@next_waiter).equal?(self.class::SHARED)
        end
        
        typesig { [] }
        # Returns previous node, or throws NullPointerException if null.
        # Use when predecessor cannot be null.  The null check could
        # be elided, but is present to help the VM.
        # 
        # @return the predecessor of this node
        def predecessor
          p = @prev
          if ((p).nil?)
            raise NullPointerException.new
          else
            return p
          end
        end
        
        typesig { [] }
        def initialize
          @wait_status = 0
          @prev = nil
          @next = nil
          @thread = nil
          @next_waiter = nil # Used to establish initial head or SHARED marker
        end
        
        typesig { [JavaThread, Node] }
        def initialize(thread, mode)
          @wait_status = 0
          @prev = nil
          @next = nil
          @thread = nil
          @next_waiter = nil # Used by addWaiter
          @next_waiter = mode
          @thread = thread
        end
        
        typesig { [JavaThread, ::Java::Int] }
        def initialize(thread, wait_status)
          @wait_status = 0
          @prev = nil
          @next = nil
          @thread = nil
          @next_waiter = nil # Used by Condition
          @wait_status = wait_status
          @thread = thread
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
    }
    
    # Head of the wait queue, lazily initialized.  Except for
    # initialization, it is modified only via method setHead.  Note:
    # If head exists, its waitStatus is guaranteed not to be
    # CANCELLED.
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    # Tail of the wait queue, lazily initialized.  Modified only via
    # method enq to add new wait node.
    attr_accessor :tail
    alias_method :attr_tail, :tail
    undef_method :tail
    alias_method :attr_tail=, :tail=
    undef_method :tail=
    
    # The synchronization state.
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [] }
    # Returns the current value of synchronization state.
    # This operation has memory semantics of a <tt>volatile</tt> read.
    # @return current state value
    def get_state
      return @state
    end
    
    typesig { [::Java::Int] }
    # Sets the value of synchronization state.
    # This operation has memory semantics of a <tt>volatile</tt> write.
    # @param newState the new state value
    def set_state(new_state)
      @state = new_state
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Atomically sets synchronization state to the given updated
    # value if the current state value equals the expected value.
    # This operation has memory semantics of a <tt>volatile</tt> read
    # and write.
    # 
    # @param expect the expected value
    # @param update the new value
    # @return true if successful. False return indicates that the actual
    # value was not equal to the expected value.
    def compare_and_set_state(expect, update)
      # See below for intrinsics setup to support this
      return UnsafeInstance.compare_and_swap_int(self, StateOffset, expect, update)
    end
    
    class_module.module_eval {
      # Queuing utilities
      # 
      # The number of nanoseconds for which it is faster to spin
      # rather than to use timed park. A rough estimate suffices
      # to improve responsiveness with very short timeouts.
      const_set_lazy(:SpinForTimeoutThreshold) { 1000 }
      const_attr_reader  :SpinForTimeoutThreshold
    }
    
    typesig { [Node] }
    # Inserts node into queue, initializing if necessary. See picture above.
    # @param node the node to insert
    # @return node's predecessor
    def enq(node)
      loop do
        t = @tail
        if ((t).nil?)
          # Must initialize
          if (compare_and_set_head(Node.new))
            @tail = @head
          end
        else
          node.attr_prev = t
          if (compare_and_set_tail(t, node))
            t.attr_next = node
            return t
          end
        end
      end
    end
    
    typesig { [Node] }
    # Creates and enqueues node for current thread and given mode.
    # 
    # @param mode Node.EXCLUSIVE for exclusive, Node.SHARED for shared
    # @return the new node
    def add_waiter(mode)
      node = Node.new(JavaThread.current_thread, mode)
      # Try the fast path of enq; backup to full enq on failure
      pred = @tail
      if (!(pred).nil?)
        node.attr_prev = pred
        if (compare_and_set_tail(pred, node))
          pred.attr_next = node
          return node
        end
      end
      enq(node)
      return node
    end
    
    typesig { [Node] }
    # Sets head of queue to be node, thus dequeuing. Called only by
    # acquire methods.  Also nulls out unused fields for sake of GC
    # and to suppress unnecessary signals and traversals.
    # 
    # @param node the node
    def set_head(node)
      @head = node
      node.attr_thread = nil
      node.attr_prev = nil
    end
    
    typesig { [Node] }
    # Wakes up node's successor, if one exists.
    # 
    # @param node the node
    def unpark_successor(node)
      # If status is negative (i.e., possibly needing signal) try
      # to clear in anticipation of signalling.  It is OK if this
      # fails or if status is changed by waiting thread.
      ws = node.attr_wait_status
      if (ws < 0)
        compare_and_set_wait_status(node, ws, 0)
      end
      # Thread to unpark is held in successor, which is normally
      # just the next node.  But if cancelled or apparently null,
      # traverse backwards from tail to find the actual
      # non-cancelled successor.
      s = node.attr_next
      if ((s).nil? || s.attr_wait_status > 0)
        s = nil
        t = @tail
        while !(t).nil? && !(t).equal?(node)
          if (t.attr_wait_status <= 0)
            s = t
          end
          t = t.attr_prev
        end
      end
      if (!(s).nil?)
        LockSupport.unpark(s.attr_thread)
      end
    end
    
    typesig { [] }
    # Release action for shared mode -- signal successor and ensure
    # propagation. (Note: For exclusive mode, release just amounts
    # to calling unparkSuccessor of head if it needs signal.)
    def do_release_shared
      # Ensure that a release propagates, even if there are other
      # in-progress acquires/releases.  This proceeds in the usual
      # way of trying to unparkSuccessor of head if it needs
      # signal. But if it does not, status is set to PROPAGATE to
      # ensure that upon release, propagation continues.
      # Additionally, we must loop in case a new node is added
      # while we are doing this. Also, unlike other uses of
      # unparkSuccessor, we need to know if CAS to reset status
      # fails, if so rechecking.
      loop do
        h = @head
        if (!(h).nil? && !(h).equal?(@tail))
          ws = h.attr_wait_status
          if ((ws).equal?(Node::SIGNAL))
            if (!compare_and_set_wait_status(h, Node::SIGNAL, 0))
              next
            end # loop to recheck cases
            unpark_successor(h)
          else
            if ((ws).equal?(0) && !compare_and_set_wait_status(h, 0, Node::PROPAGATE))
              next
            end
          end # loop on failed CAS
        end
        if ((h).equal?(@head))
          # loop if head changed
          break
        end
      end
    end
    
    typesig { [Node, ::Java::Int] }
    # Sets head of queue, and checks if successor may be waiting
    # in shared mode, if so propagating if either propagate > 0 or
    # PROPAGATE status was set.
    # 
    # @param node the node
    # @param propagate the return value from a tryAcquireShared
    def set_head_and_propagate(node, propagate)
      h = @head # Record old head for check below
      set_head(node)
      # Try to signal next queued node if:
      # Propagation was indicated by caller,
      # or was recorded (as h.waitStatus) by a previous operation
      # (note: this uses sign-check of waitStatus because
      # PROPAGATE status may transition to SIGNAL.)
      # and
      # The next node is waiting in shared mode,
      # or we don't know, because it appears null
      # 
      # The conservatism in both of these checks may cause
      # unnecessary wake-ups, but only when there are multiple
      # racing acquires/releases, so most need signals now or soon
      # anyway.
      if (propagate > 0 || (h).nil? || h.attr_wait_status < 0)
        s = node.attr_next
        if ((s).nil? || s.is_shared)
          do_release_shared
        end
      end
    end
    
    typesig { [Node] }
    # Utilities for various versions of acquire
    # 
    # Cancels an ongoing attempt to acquire.
    # 
    # @param node the node
    def cancel_acquire(node)
      # Ignore if node doesn't exist
      if ((node).nil?)
        return
      end
      node.attr_thread = nil
      # Skip cancelled predecessors
      pred = node.attr_prev
      while (pred.attr_wait_status > 0)
        node.attr_prev = pred = pred.attr_prev
      end
      # predNext is the apparent node to unsplice. CASes below will
      # fail if not, in which case, we lost race vs another cancel
      # or signal, so no further action is necessary.
      pred_next = pred.attr_next
      # Can use unconditional write instead of CAS here.
      # After this atomic step, other Nodes can skip past us.
      # Before, we are free of interference from other threads.
      node.attr_wait_status = Node::CANCELLED
      # If we are the tail, remove ourselves.
      if ((node).equal?(@tail) && compare_and_set_tail(node, pred))
        compare_and_set_next(pred, pred_next, nil)
      else
        # If successor needs signal, try to set pred's next-link
        # so it will get one. Otherwise wake it up to propagate.
        ws = 0
        if (!(pred).equal?(@head) && (((ws = pred.attr_wait_status)).equal?(Node::SIGNAL) || (ws <= 0 && compare_and_set_wait_status(pred, ws, Node::SIGNAL))) && !(pred.attr_thread).nil?)
          next_ = node.attr_next
          if (!(next_).nil? && next_.attr_wait_status <= 0)
            compare_and_set_next(pred, pred_next, next_)
          end
        else
          unpark_successor(node)
        end
        node.attr_next = node # help GC
      end
    end
    
    class_module.module_eval {
      typesig { [Node, Node] }
      # Checks and updates status for a node that failed to acquire.
      # Returns true if thread should block. This is the main signal
      # control in all acquire loops.  Requires that pred == node.prev
      # 
      # @param pred node's predecessor holding status
      # @param node the node
      # @return {@code true} if thread should block
      def should_park_after_failed_acquire(pred, node)
        ws = pred.attr_wait_status
        if ((ws).equal?(Node::SIGNAL))
          # This node has already set status asking a release
          # to signal it, so it can safely park.
          return true
        end
        if (ws > 0)
          # Predecessor was cancelled. Skip over predecessors and
          # indicate retry.
          begin
            node.attr_prev = pred = pred.attr_prev
          end while (pred.attr_wait_status > 0)
          pred.attr_next = node
        else
          # waitStatus must be 0 or PROPAGATE.  Indicate that we
          # need a signal, but don't park yet.  Caller will need to
          # retry to make sure it cannot acquire before parking.
          compare_and_set_wait_status(pred, ws, Node::SIGNAL)
        end
        return false
      end
      
      typesig { [] }
      # Convenience method to interrupt current thread.
      def self_interrupt
        JavaThread.current_thread.interrupt
      end
    }
    
    typesig { [] }
    # Convenience method to park and then check if interrupted
    # 
    # @return {@code true} if interrupted
    def park_and_check_interrupt
      LockSupport.park(self)
      return JavaThread.interrupted
    end
    
    typesig { [Node, ::Java::Int] }
    # Various flavors of acquire, varying in exclusive/shared and
    # control modes.  Each is mostly the same, but annoyingly
    # different.  Only a little bit of factoring is possible due to
    # interactions of exception mechanics (including ensuring that we
    # cancel if tryAcquire throws exception) and other control, at
    # least not without hurting performance too much.
    # 
    # 
    # Acquires in exclusive uninterruptible mode for thread already in
    # queue. Used by condition wait methods as well as acquire.
    # 
    # @param node the node
    # @param arg the acquire argument
    # @return {@code true} if interrupted while waiting
    def acquire_queued(node, arg)
      failed = true
      begin
        interrupted_ = false
        loop do
          p = node.predecessor
          if ((p).equal?(@head) && try_acquire(arg))
            set_head(node)
            p.attr_next = nil # help GC
            failed = false
            return interrupted_
          end
          if (should_park_after_failed_acquire(p, node) && park_and_check_interrupt)
            interrupted_ = true
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Acquires in exclusive interruptible mode.
    # @param arg the acquire argument
    def do_acquire_interruptibly(arg)
      node = add_waiter(Node::EXCLUSIVE)
      failed = true
      begin
        loop do
          p = node.predecessor
          if ((p).equal?(@head) && try_acquire(arg))
            set_head(node)
            p.attr_next = nil # help GC
            failed = false
            return
          end
          if (should_park_after_failed_acquire(p, node) && park_and_check_interrupt)
            raise InterruptedException.new
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Acquires in exclusive timed mode.
    # 
    # @param arg the acquire argument
    # @param nanosTimeout max wait time
    # @return {@code true} if acquired
    def do_acquire_nanos(arg, nanos_timeout)
      last_time = System.nano_time
      node = add_waiter(Node::EXCLUSIVE)
      failed = true
      begin
        loop do
          p = node.predecessor
          if ((p).equal?(@head) && try_acquire(arg))
            set_head(node)
            p.attr_next = nil # help GC
            failed = false
            return true
          end
          if (nanos_timeout <= 0)
            return false
          end
          if (should_park_after_failed_acquire(p, node) && nanos_timeout > SpinForTimeoutThreshold)
            LockSupport.park_nanos(self, nanos_timeout)
          end
          now = System.nano_time
          nanos_timeout -= now - last_time
          last_time = now
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Acquires in shared uninterruptible mode.
    # @param arg the acquire argument
    def do_acquire_shared(arg)
      node = add_waiter(Node::SHARED)
      failed = true
      begin
        interrupted_ = false
        loop do
          p = node.predecessor
          if ((p).equal?(@head))
            r = try_acquire_shared(arg)
            if (r >= 0)
              set_head_and_propagate(node, r)
              p.attr_next = nil # help GC
              if (interrupted_)
                self_interrupt
              end
              failed = false
              return
            end
          end
          if (should_park_after_failed_acquire(p, node) && park_and_check_interrupt)
            interrupted_ = true
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Acquires in shared interruptible mode.
    # @param arg the acquire argument
    def do_acquire_shared_interruptibly(arg)
      node = add_waiter(Node::SHARED)
      failed = true
      begin
        loop do
          p = node.predecessor
          if ((p).equal?(@head))
            r = try_acquire_shared(arg)
            if (r >= 0)
              set_head_and_propagate(node, r)
              p.attr_next = nil # help GC
              failed = false
              return
            end
          end
          if (should_park_after_failed_acquire(p, node) && park_and_check_interrupt)
            raise InterruptedException.new
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Acquires in shared timed mode.
    # 
    # @param arg the acquire argument
    # @param nanosTimeout max wait time
    # @return {@code true} if acquired
    def do_acquire_shared_nanos(arg, nanos_timeout)
      last_time = System.nano_time
      node = add_waiter(Node::SHARED)
      failed = true
      begin
        loop do
          p = node.predecessor
          if ((p).equal?(@head))
            r = try_acquire_shared(arg)
            if (r >= 0)
              set_head_and_propagate(node, r)
              p.attr_next = nil # help GC
              failed = false
              return true
            end
          end
          if (nanos_timeout <= 0)
            return false
          end
          if (should_park_after_failed_acquire(p, node) && nanos_timeout > SpinForTimeoutThreshold)
            LockSupport.park_nanos(self, nanos_timeout)
          end
          now = System.nano_time
          nanos_timeout -= now - last_time
          last_time = now
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
        end
      ensure
        if (failed)
          cancel_acquire(node)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Main exported methods
    # 
    # Attempts to acquire in exclusive mode. This method should query
    # if the state of the object permits it to be acquired in the
    # exclusive mode, and if so to acquire it.
    # 
    # <p>This method is always invoked by the thread performing
    # acquire.  If this method reports failure, the acquire method
    # may queue the thread, if it is not already queued, until it is
    # signalled by a release from some other thread. This can be used
    # to implement method {@link Lock#tryLock()}.
    # 
    # <p>The default
    # implementation throws {@link UnsupportedOperationException}.
    # 
    # @param arg the acquire argument. This value is always the one
    # passed to an acquire method, or is the value saved on entry
    # to a condition wait.  The value is otherwise uninterpreted
    # and can represent anything you like.
    # @return {@code true} if successful. Upon success, this object has
    # been acquired.
    # @throws IllegalMonitorStateException if acquiring would place this
    # synchronizer in an illegal state. This exception must be
    # thrown in a consistent fashion for synchronization to work
    # correctly.
    # @throws UnsupportedOperationException if exclusive mode is not supported
    def try_acquire(arg)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # Attempts to set the state to reflect a release in exclusive
    # mode.
    # 
    # <p>This method is always invoked by the thread performing release.
    # 
    # <p>The default implementation throws
    # {@link UnsupportedOperationException}.
    # 
    # @param arg the release argument. This value is always the one
    # passed to a release method, or the current state value upon
    # entry to a condition wait.  The value is otherwise
    # uninterpreted and can represent anything you like.
    # @return {@code true} if this object is now in a fully released
    # state, so that any waiting threads may attempt to acquire;
    # and {@code false} otherwise.
    # @throws IllegalMonitorStateException if releasing would place this
    # synchronizer in an illegal state. This exception must be
    # thrown in a consistent fashion for synchronization to work
    # correctly.
    # @throws UnsupportedOperationException if exclusive mode is not supported
    def try_release(arg)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # Attempts to acquire in shared mode. This method should query if
    # the state of the object permits it to be acquired in the shared
    # mode, and if so to acquire it.
    # 
    # <p>This method is always invoked by the thread performing
    # acquire.  If this method reports failure, the acquire method
    # may queue the thread, if it is not already queued, until it is
    # signalled by a release from some other thread.
    # 
    # <p>The default implementation throws {@link
    # UnsupportedOperationException}.
    # 
    # @param arg the acquire argument. This value is always the one
    # passed to an acquire method, or is the value saved on entry
    # to a condition wait.  The value is otherwise uninterpreted
    # and can represent anything you like.
    # @return a negative value on failure; zero if acquisition in shared
    # mode succeeded but no subsequent shared-mode acquire can
    # succeed; and a positive value if acquisition in shared
    # mode succeeded and subsequent shared-mode acquires might
    # also succeed, in which case a subsequent waiting thread
    # must check availability. (Support for three different
    # return values enables this method to be used in contexts
    # where acquires only sometimes act exclusively.)  Upon
    # success, this object has been acquired.
    # @throws IllegalMonitorStateException if acquiring would place this
    # synchronizer in an illegal state. This exception must be
    # thrown in a consistent fashion for synchronization to work
    # correctly.
    # @throws UnsupportedOperationException if shared mode is not supported
    def try_acquire_shared(arg)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # Attempts to set the state to reflect a release in shared mode.
    # 
    # <p>This method is always invoked by the thread performing release.
    # 
    # <p>The default implementation throws
    # {@link UnsupportedOperationException}.
    # 
    # @param arg the release argument. This value is always the one
    # passed to a release method, or the current state value upon
    # entry to a condition wait.  The value is otherwise
    # uninterpreted and can represent anything you like.
    # @return {@code true} if this release of shared mode may permit a
    # waiting acquire (shared or exclusive) to succeed; and
    # {@code false} otherwise
    # @throws IllegalMonitorStateException if releasing would place this
    # synchronizer in an illegal state. This exception must be
    # thrown in a consistent fashion for synchronization to work
    # correctly.
    # @throws UnsupportedOperationException if shared mode is not supported
    def try_release_shared(arg)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    # Returns {@code true} if synchronization is held exclusively with
    # respect to the current (calling) thread.  This method is invoked
    # upon each call to a non-waiting {@link ConditionObject} method.
    # (Waiting methods instead invoke {@link #release}.)
    # 
    # <p>The default implementation throws {@link
    # UnsupportedOperationException}. This method is invoked
    # internally only within {@link ConditionObject} methods, so need
    # not be defined if conditions are not used.
    # 
    # @return {@code true} if synchronization is held exclusively;
    # {@code false} otherwise
    # @throws UnsupportedOperationException if conditions are not supported
    def is_held_exclusively
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    # Acquires in exclusive mode, ignoring interrupts.  Implemented
    # by invoking at least once {@link #tryAcquire},
    # returning on success.  Otherwise the thread is queued, possibly
    # repeatedly blocking and unblocking, invoking {@link
    # #tryAcquire} until success.  This method can be used
    # to implement method {@link Lock#lock}.
    # 
    # @param arg the acquire argument.  This value is conveyed to
    # {@link #tryAcquire} but is otherwise uninterpreted and
    # can represent anything you like.
    def acquire(arg)
      if (!try_acquire(arg) && acquire_queued(add_waiter(Node::EXCLUSIVE), arg))
        self_interrupt
      end
    end
    
    typesig { [::Java::Int] }
    # Acquires in exclusive mode, aborting if interrupted.
    # Implemented by first checking interrupt status, then invoking
    # at least once {@link #tryAcquire}, returning on
    # success.  Otherwise the thread is queued, possibly repeatedly
    # blocking and unblocking, invoking {@link #tryAcquire}
    # until success or the thread is interrupted.  This method can be
    # used to implement method {@link Lock#lockInterruptibly}.
    # 
    # @param arg the acquire argument.  This value is conveyed to
    # {@link #tryAcquire} but is otherwise uninterpreted and
    # can represent anything you like.
    # @throws InterruptedException if the current thread is interrupted
    def acquire_interruptibly(arg)
      if (JavaThread.interrupted)
        raise InterruptedException.new
      end
      if (!try_acquire(arg))
        do_acquire_interruptibly(arg)
      end
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Attempts to acquire in exclusive mode, aborting if interrupted,
    # and failing if the given timeout elapses.  Implemented by first
    # checking interrupt status, then invoking at least once {@link
    # #tryAcquire}, returning on success.  Otherwise, the thread is
    # queued, possibly repeatedly blocking and unblocking, invoking
    # {@link #tryAcquire} until success or the thread is interrupted
    # or the timeout elapses.  This method can be used to implement
    # method {@link Lock#tryLock(long, TimeUnit)}.
    # 
    # @param arg the acquire argument.  This value is conveyed to
    # {@link #tryAcquire} but is otherwise uninterpreted and
    # can represent anything you like.
    # @param nanosTimeout the maximum number of nanoseconds to wait
    # @return {@code true} if acquired; {@code false} if timed out
    # @throws InterruptedException if the current thread is interrupted
    def try_acquire_nanos(arg, nanos_timeout)
      if (JavaThread.interrupted)
        raise InterruptedException.new
      end
      return try_acquire(arg) || do_acquire_nanos(arg, nanos_timeout)
    end
    
    typesig { [::Java::Int] }
    # Releases in exclusive mode.  Implemented by unblocking one or
    # more threads if {@link #tryRelease} returns true.
    # This method can be used to implement method {@link Lock#unlock}.
    # 
    # @param arg the release argument.  This value is conveyed to
    # {@link #tryRelease} but is otherwise uninterpreted and
    # can represent anything you like.
    # @return the value returned from {@link #tryRelease}
    def release(arg)
      if (try_release(arg))
        h = @head
        if (!(h).nil? && !(h.attr_wait_status).equal?(0))
          unpark_successor(h)
        end
        return true
      end
      return false
    end
    
    typesig { [::Java::Int] }
    # Acquires in shared mode, ignoring interrupts.  Implemented by
    # first invoking at least once {@link #tryAcquireShared},
    # returning on success.  Otherwise the thread is queued, possibly
    # repeatedly blocking and unblocking, invoking {@link
    # #tryAcquireShared} until success.
    # 
    # @param arg the acquire argument.  This value is conveyed to
    # {@link #tryAcquireShared} but is otherwise uninterpreted
    # and can represent anything you like.
    def acquire_shared(arg)
      if (try_acquire_shared(arg) < 0)
        do_acquire_shared(arg)
      end
    end
    
    typesig { [::Java::Int] }
    # Acquires in shared mode, aborting if interrupted.  Implemented
    # by first checking interrupt status, then invoking at least once
    # {@link #tryAcquireShared}, returning on success.  Otherwise the
    # thread is queued, possibly repeatedly blocking and unblocking,
    # invoking {@link #tryAcquireShared} until success or the thread
    # is interrupted.
    # @param arg the acquire argument
    # This value is conveyed to {@link #tryAcquireShared} but is
    # otherwise uninterpreted and can represent anything
    # you like.
    # @throws InterruptedException if the current thread is interrupted
    def acquire_shared_interruptibly(arg)
      if (JavaThread.interrupted)
        raise InterruptedException.new
      end
      if (try_acquire_shared(arg) < 0)
        do_acquire_shared_interruptibly(arg)
      end
    end
    
    typesig { [::Java::Int, ::Java::Long] }
    # Attempts to acquire in shared mode, aborting if interrupted, and
    # failing if the given timeout elapses.  Implemented by first
    # checking interrupt status, then invoking at least once {@link
    # #tryAcquireShared}, returning on success.  Otherwise, the
    # thread is queued, possibly repeatedly blocking and unblocking,
    # invoking {@link #tryAcquireShared} until success or the thread
    # is interrupted or the timeout elapses.
    # 
    # @param arg the acquire argument.  This value is conveyed to
    # {@link #tryAcquireShared} but is otherwise uninterpreted
    # and can represent anything you like.
    # @param nanosTimeout the maximum number of nanoseconds to wait
    # @return {@code true} if acquired; {@code false} if timed out
    # @throws InterruptedException if the current thread is interrupted
    def try_acquire_shared_nanos(arg, nanos_timeout)
      if (JavaThread.interrupted)
        raise InterruptedException.new
      end
      return try_acquire_shared(arg) >= 0 || do_acquire_shared_nanos(arg, nanos_timeout)
    end
    
    typesig { [::Java::Int] }
    # Releases in shared mode.  Implemented by unblocking one or more
    # threads if {@link #tryReleaseShared} returns true.
    # 
    # @param arg the release argument.  This value is conveyed to
    # {@link #tryReleaseShared} but is otherwise uninterpreted
    # and can represent anything you like.
    # @return the value returned from {@link #tryReleaseShared}
    def release_shared(arg)
      if (try_release_shared(arg))
        do_release_shared
        return true
      end
      return false
    end
    
    typesig { [] }
    # Queue inspection methods
    # 
    # Queries whether any threads are waiting to acquire. Note that
    # because cancellations due to interrupts and timeouts may occur
    # at any time, a {@code true} return does not guarantee that any
    # other thread will ever acquire.
    # 
    # <p>In this implementation, this operation returns in
    # constant time.
    # 
    # @return {@code true} if there may be other threads waiting to acquire
    def has_queued_threads
      return !(@head).equal?(@tail)
    end
    
    typesig { [] }
    # Queries whether any threads have ever contended to acquire this
    # synchronizer; that is if an acquire method has ever blocked.
    # 
    # <p>In this implementation, this operation returns in
    # constant time.
    # 
    # @return {@code true} if there has ever been contention
    def has_contended
      return !(@head).nil?
    end
    
    typesig { [] }
    # Returns the first (longest-waiting) thread in the queue, or
    # {@code null} if no threads are currently queued.
    # 
    # <p>In this implementation, this operation normally returns in
    # constant time, but may iterate upon contention if other threads are
    # concurrently modifying the queue.
    # 
    # @return the first (longest-waiting) thread in the queue, or
    # {@code null} if no threads are currently queued
    def get_first_queued_thread
      # handle only fast path, else relay
      return ((@head).equal?(@tail)) ? nil : full_get_first_queued_thread
    end
    
    typesig { [] }
    # Version of getFirstQueuedThread called when fastpath fails
    def full_get_first_queued_thread
      # The first node is normally head.next. Try to get its
      # thread field, ensuring consistent reads: If thread
      # field is nulled out or s.prev is no longer head, then
      # some other thread(s) concurrently performed setHead in
      # between some of our reads. We try this twice before
      # resorting to traversal.
      h = nil
      s = nil
      st = nil
      if ((!((h = @head)).nil? && !((s = h.attr_next)).nil? && (s.attr_prev).equal?(@head) && !((st = s.attr_thread)).nil?) || (!((h = @head)).nil? && !((s = h.attr_next)).nil? && (s.attr_prev).equal?(@head) && !((st = s.attr_thread)).nil?))
        return st
      end
      # Head's next field might not have been set yet, or may have
      # been unset after setHead. So we must check to see if tail
      # is actually first node. If not, we continue on, safely
      # traversing from tail back to head to find first,
      # guaranteeing termination.
      t = @tail
      first_thread = nil
      while (!(t).nil? && !(t).equal?(@head))
        tt = t.attr_thread
        if (!(tt).nil?)
          first_thread = tt
        end
        t = t.attr_prev
      end
      return first_thread
    end
    
    typesig { [JavaThread] }
    # Returns true if the given thread is currently queued.
    # 
    # <p>This implementation traverses the queue to determine
    # presence of the given thread.
    # 
    # @param thread the thread
    # @return {@code true} if the given thread is on the queue
    # @throws NullPointerException if the thread is null
    def is_queued(thread)
      if ((thread).nil?)
        raise NullPointerException.new
      end
      p = @tail
      while !(p).nil?
        if ((p.attr_thread).equal?(thread))
          return true
        end
        p = p.attr_prev
      end
      return false
    end
    
    typesig { [] }
    # Returns {@code true} if the apparent first queued thread, if one
    # exists, is waiting in exclusive mode.  If this method returns
    # {@code true}, and the current thread is attempting to acquire in
    # shared mode (that is, this method is invoked from {@link
    # #tryAcquireShared}) then it is guaranteed that the current thread
    # is not the first queued thread.  Used only as a heuristic in
    # ReentrantReadWriteLock.
    def apparently_first_queued_is_exclusive
      h = nil
      s = nil
      return !((h = @head)).nil? && !((s = h.attr_next)).nil? && !s.is_shared && !(s.attr_thread).nil?
    end
    
    typesig { [] }
    # Queries whether any threads have been waiting to acquire longer
    # than the current thread.
    # 
    # <p>An invocation of this method is equivalent to (but may be
    # more efficient than):
    # <pre> {@code
    # getFirstQueuedThread() != Thread.currentThread() &&
    # hasQueuedThreads()}</pre>
    # 
    # <p>Note that because cancellations due to interrupts and
    # timeouts may occur at any time, a {@code true} return does not
    # guarantee that some other thread will acquire before the current
    # thread.  Likewise, it is possible for another thread to win a
    # race to enqueue after this method has returned {@code false},
    # due to the queue being empty.
    # 
    # <p>This method is designed to be used by a fair synchronizer to
    # avoid <a href="AbstractQueuedSynchronizer#barging">barging</a>.
    # Such a synchronizer's {@link #tryAcquire} method should return
    # {@code false}, and its {@link #tryAcquireShared} method should
    # return a negative value, if this method returns {@code true}
    # (unless this is a reentrant acquire).  For example, the {@code
    # tryAcquire} method for a fair, reentrant, exclusive mode
    # synchronizer might look like this:
    # 
    # <pre> {@code
    # protected boolean tryAcquire(int arg) {
    # if (isHeldExclusively()) {
    # // A reentrant acquire; increment hold count
    # return true;
    # } else if (hasQueuedPredecessors()) {
    # return false;
    # } else {
    # // try to acquire normally
    # }
    # }}</pre>
    # 
    # @return {@code true} if there is a queued thread preceding the
    # current thread, and {@code false} if the current thread
    # is at the head of the queue or the queue is empty
    # @since 1.7
    def has_queued_predecessors
      # The correctness of this depends on head being initialized
      # before tail and on head.next being accurate if the current
      # thread is first in queue.
      t = @tail # Read fields in reverse initialization order
      h = @head
      s = nil
      return !(h).equal?(t) && (((s = h.attr_next)).nil? || !(s.attr_thread).equal?(JavaThread.current_thread))
    end
    
    typesig { [] }
    # Instrumentation and monitoring methods
    # 
    # Returns an estimate of the number of threads waiting to
    # acquire.  The value is only an estimate because the number of
    # threads may change dynamically while this method traverses
    # internal data structures.  This method is designed for use in
    # monitoring system state, not for synchronization
    # control.
    # 
    # @return the estimated number of threads waiting to acquire
    def get_queue_length
      n = 0
      p = @tail
      while !(p).nil?
        if (!(p.attr_thread).nil?)
          (n += 1)
        end
        p = p.attr_prev
      end
      return n
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire.  Because the actual set of threads may change
    # dynamically while constructing this result, the returned
    # collection is only a best-effort estimate.  The elements of the
    # returned collection are in no particular order.  This method is
    # designed to facilitate construction of subclasses that provide
    # more extensive monitoring facilities.
    # 
    # @return the collection of threads
    def get_queued_threads
      list = ArrayList.new
      p = @tail
      while !(p).nil?
        t = p.attr_thread
        if (!(t).nil?)
          list.add(t)
        end
        p = p.attr_prev
      end
      return list
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire in exclusive mode. This has the same properties
    # as {@link #getQueuedThreads} except that it only returns
    # those threads waiting due to an exclusive acquire.
    # 
    # @return the collection of threads
    def get_exclusive_queued_threads
      list = ArrayList.new
      p = @tail
      while !(p).nil?
        if (!p.is_shared)
          t = p.attr_thread
          if (!(t).nil?)
            list.add(t)
          end
        end
        p = p.attr_prev
      end
      return list
    end
    
    typesig { [] }
    # Returns a collection containing threads that may be waiting to
    # acquire in shared mode. This has the same properties
    # as {@link #getQueuedThreads} except that it only returns
    # those threads waiting due to a shared acquire.
    # 
    # @return the collection of threads
    def get_shared_queued_threads
      list = ArrayList.new
      p = @tail
      while !(p).nil?
        if (p.is_shared)
          t = p.attr_thread
          if (!(t).nil?)
            list.add(t)
          end
        end
        p = p.attr_prev
      end
      return list
    end
    
    typesig { [] }
    # Returns a string identifying this synchronizer, as well as its state.
    # The state, in brackets, includes the String {@code "State ="}
    # followed by the current value of {@link #getState}, and either
    # {@code "nonempty"} or {@code "empty"} depending on whether the
    # queue is empty.
    # 
    # @return a string identifying this synchronizer, as well as its state
    def to_s
      s = get_state
      q = has_queued_threads ? "non" : ""
      return (super).to_s + "[State = " + (s).to_s + ", " + q + "empty queue]"
    end
    
    typesig { [Node] }
    # Internal support methods for Conditions
    # 
    # Returns true if a node, always one that was initially placed on
    # a condition queue, is now waiting to reacquire on sync queue.
    # @param node the node
    # @return true if is reacquiring
    def is_on_sync_queue(node)
      if ((node.attr_wait_status).equal?(Node::CONDITION) || (node.attr_prev).nil?)
        return false
      end
      if (!(node.attr_next).nil?)
        # If has successor, it must be on queue
        return true
      end
      # node.prev can be non-null, but not yet on queue because
      # the CAS to place it on queue can fail. So we have to
      # traverse from tail to make sure it actually made it.  It
      # will always be near the tail in calls to this method, and
      # unless the CAS failed (which is unlikely), it will be
      # there, so we hardly ever traverse much.
      return find_node_from_tail(node)
    end
    
    typesig { [Node] }
    # Returns true if node is on sync queue by searching backwards from tail.
    # Called only when needed by isOnSyncQueue.
    # @return true if present
    def find_node_from_tail(node)
      t = @tail
      loop do
        if ((t).equal?(node))
          return true
        end
        if ((t).nil?)
          return false
        end
        t = t.attr_prev
      end
    end
    
    typesig { [Node] }
    # Transfers a node from a condition queue onto sync queue.
    # Returns true if successful.
    # @param node the node
    # @return true if successfully transferred (else the node was
    # cancelled before signal).
    def transfer_for_signal(node)
      # If cannot change waitStatus, the node has been cancelled.
      if (!compare_and_set_wait_status(node, Node::CONDITION, 0))
        return false
      end
      # Splice onto queue and try to set waitStatus of predecessor to
      # indicate that thread is (probably) waiting. If cancelled or
      # attempt to set waitStatus fails, wake up to resync (in which
      # case the waitStatus can be transiently and harmlessly wrong).
      p = enq(node)
      ws = p.attr_wait_status
      if (ws > 0 || !compare_and_set_wait_status(p, ws, Node::SIGNAL))
        LockSupport.unpark(node.attr_thread)
      end
      return true
    end
    
    typesig { [Node] }
    # Transfers node, if necessary, to sync queue after a cancelled
    # wait. Returns true if thread was cancelled before being
    # signalled.
    # @param current the waiting thread
    # @param node its node
    # @return true if cancelled before the node was signalled
    def transfer_after_cancelled_wait(node)
      if (compare_and_set_wait_status(node, Node::CONDITION, 0))
        enq(node)
        return true
      end
      # If we lost out to a signal(), then we can't proceed
      # until it finishes its enq().  Cancelling during an
      # incomplete transfer is both rare and transient, so just
      # spin.
      while (!is_on_sync_queue(node))
        JavaThread.yield
      end
      return false
    end
    
    typesig { [Node] }
    # Invokes release with current state value; returns saved state.
    # Cancels node and throws exception on failure.
    # @param node the condition node for this wait
    # @return previous sync state
    def fully_release(node)
      failed = true
      begin
        saved_state = get_state
        if (release(saved_state))
          failed = false
          return saved_state
        else
          raise IllegalMonitorStateException.new
        end
      ensure
        if (failed)
          node.attr_wait_status = Node::CANCELLED
        end
      end
    end
    
    typesig { [ConditionObject] }
    # Instrumentation methods for conditions
    # 
    # Queries whether the given ConditionObject
    # uses this synchronizer as its lock.
    # 
    # @param condition the condition
    # @return <tt>true</tt> if owned
    # @throws NullPointerException if the condition is null
    def owns(condition)
      if ((condition).nil?)
        raise NullPointerException.new
      end
      return condition.is_owned_by(self)
    end
    
    typesig { [ConditionObject] }
    # Queries whether any threads are waiting on the given condition
    # associated with this synchronizer. Note that because timeouts
    # and interrupts may occur at any time, a <tt>true</tt> return
    # does not guarantee that a future <tt>signal</tt> will awaken
    # any threads.  This method is designed primarily for use in
    # monitoring of the system state.
    # 
    # @param condition the condition
    # @return <tt>true</tt> if there are any waiting threads
    # @throws IllegalMonitorStateException if exclusive synchronization
    # is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this synchronizer
    # @throws NullPointerException if the condition is null
    def has_waiters(condition)
      if (!owns(condition))
        raise IllegalArgumentException.new("Not owner")
      end
      return condition.has_waiters
    end
    
    typesig { [ConditionObject] }
    # Returns an estimate of the number of threads waiting on the
    # given condition associated with this synchronizer. Note that
    # because timeouts and interrupts may occur at any time, the
    # estimate serves only as an upper bound on the actual number of
    # waiters.  This method is designed for use in monitoring of the
    # system state, not for synchronization control.
    # 
    # @param condition the condition
    # @return the estimated number of waiting threads
    # @throws IllegalMonitorStateException if exclusive synchronization
    # is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this synchronizer
    # @throws NullPointerException if the condition is null
    def get_wait_queue_length(condition)
      if (!owns(condition))
        raise IllegalArgumentException.new("Not owner")
      end
      return condition.get_wait_queue_length
    end
    
    typesig { [ConditionObject] }
    # Returns a collection containing those threads that may be
    # waiting on the given condition associated with this
    # synchronizer.  Because the actual set of threads may change
    # dynamically while constructing this result, the returned
    # collection is only a best-effort estimate. The elements of the
    # returned collection are in no particular order.
    # 
    # @param condition the condition
    # @return the collection of threads
    # @throws IllegalMonitorStateException if exclusive synchronization
    # is not held
    # @throws IllegalArgumentException if the given condition is
    # not associated with this synchronizer
    # @throws NullPointerException if the condition is null
    def get_waiting_threads(condition)
      if (!owns(condition))
        raise IllegalArgumentException.new("Not owner")
      end
      return condition.get_waiting_threads
    end
    
    class_module.module_eval {
      # Condition implementation for a {@link
      # AbstractQueuedSynchronizer} serving as the basis of a {@link
      # Lock} implementation.
      # 
      # <p>Method documentation for this class describes mechanics,
      # not behavioral specifications from the point of view of Lock
      # and Condition users. Exported versions of this class will in
      # general need to be accompanied by documentation describing
      # condition semantics that rely on those of the associated
      # <tt>AbstractQueuedSynchronizer</tt>.
      # 
      # <p>This class is Serializable, but all fields are transient,
      # so deserialized conditions have no waiters.
      const_set_lazy(:ConditionObject) { Class.new do
        extend LocalClass
        include_class_members AbstractQueuedSynchronizer
        include Condition
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 1173984872572414699 }
          const_attr_reader  :SerialVersionUID
        }
        
        # First node of condition queue.
        attr_accessor :first_waiter
        alias_method :attr_first_waiter, :first_waiter
        undef_method :first_waiter
        alias_method :attr_first_waiter=, :first_waiter=
        undef_method :first_waiter=
        
        # Last node of condition queue.
        attr_accessor :last_waiter
        alias_method :attr_last_waiter, :last_waiter
        undef_method :last_waiter
        alias_method :attr_last_waiter=, :last_waiter=
        undef_method :last_waiter=
        
        typesig { [] }
        # Creates a new <tt>ConditionObject</tt> instance.
        def initialize
          @first_waiter = nil
          @last_waiter = nil
        end
        
        typesig { [] }
        # Internal methods
        # 
        # Adds a new waiter to wait queue.
        # @return its new wait node
        def add_condition_waiter
          t = @last_waiter
          # If lastWaiter is cancelled, clean out.
          if (!(t).nil? && !(t.attr_wait_status).equal?(Node::CONDITION))
            unlink_cancelled_waiters
            t = @last_waiter
          end
          node = Node.new(JavaThread.current_thread, Node::CONDITION)
          if ((t).nil?)
            @first_waiter = node
          else
            t.attr_next_waiter = node
          end
          @last_waiter = node
          return node
        end
        
        typesig { [Node] }
        # Removes and transfers nodes until hit non-cancelled one or
        # null. Split out from signal in part to encourage compilers
        # to inline the case of no waiters.
        # @param first (non-null) the first node on condition queue
        def do_signal(first)
          begin
            if (((@first_waiter = first.attr_next_waiter)).nil?)
              @last_waiter = nil
            end
            first.attr_next_waiter = nil
          end while (!transfer_for_signal(first) && !((first = @first_waiter)).nil?)
        end
        
        typesig { [Node] }
        # Removes and transfers all nodes.
        # @param first (non-null) the first node on condition queue
        def do_signal_all(first)
          @last_waiter = @first_waiter = nil
          begin
            next_ = first.attr_next_waiter
            first.attr_next_waiter = nil
            transfer_for_signal(first)
            first = next_
          end while (!(first).nil?)
        end
        
        typesig { [] }
        # Unlinks cancelled waiter nodes from condition queue.
        # Called only while holding lock. This is called when
        # cancellation occurred during condition wait, and upon
        # insertion of a new waiter when lastWaiter is seen to have
        # been cancelled. This method is needed to avoid garbage
        # retention in the absence of signals. So even though it may
        # require a full traversal, it comes into play only when
        # timeouts or cancellations occur in the absence of
        # signals. It traverses all nodes rather than stopping at a
        # particular target to unlink all pointers to garbage nodes
        # without requiring many re-traversals during cancellation
        # storms.
        def unlink_cancelled_waiters
          t = @first_waiter
          trail = nil
          while (!(t).nil?)
            next_ = t.attr_next_waiter
            if (!(t.attr_wait_status).equal?(Node::CONDITION))
              t.attr_next_waiter = nil
              if ((trail).nil?)
                @first_waiter = next_
              else
                trail.attr_next_waiter = next_
              end
              if ((next_).nil?)
                @last_waiter = trail
              end
            else
              trail = t
            end
            t = next_
          end
        end
        
        typesig { [] }
        # public methods
        # 
        # Moves the longest-waiting thread, if one exists, from the
        # wait queue for this condition to the wait queue for the
        # owning lock.
        # 
        # @throws IllegalMonitorStateException if {@link #isHeldExclusively}
        # returns {@code false}
        def signal
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          first = @first_waiter
          if (!(first).nil?)
            do_signal(first)
          end
        end
        
        typesig { [] }
        # Moves all threads from the wait queue for this condition to
        # the wait queue for the owning lock.
        # 
        # @throws IllegalMonitorStateException if {@link #isHeldExclusively}
        # returns {@code false}
        def signal_all
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          first = @first_waiter
          if (!(first).nil?)
            do_signal_all(first)
          end
        end
        
        typesig { [] }
        # Implements uninterruptible condition wait.
        # <ol>
        # <li> Save lock state returned by {@link #getState}.
        # <li> Invoke {@link #release} with
        # saved state as argument, throwing
        # IllegalMonitorStateException if it fails.
        # <li> Block until signalled.
        # <li> Reacquire by invoking specialized version of
        # {@link #acquire} with saved state as argument.
        # </ol>
        def await_uninterruptibly
          node = add_condition_waiter
          saved_state = fully_release(node)
          interrupted = false
          while (!is_on_sync_queue(node))
            LockSupport.park(self)
            if (JavaThread.interrupted)
              interrupted = true
            end
          end
          if (acquire_queued(node, saved_state) || interrupted)
            self_interrupt
          end
        end
        
        class_module.module_eval {
          # For interruptible waits, we need to track whether to throw
          # InterruptedException, if interrupted while blocked on
          # condition, versus reinterrupt current thread, if
          # interrupted while blocked waiting to re-acquire.
          # 
          # Mode meaning to reinterrupt on exit from wait
          const_set_lazy(:REINTERRUPT) { 1 }
          const_attr_reader  :REINTERRUPT
          
          # Mode meaning to throw InterruptedException on exit from wait
          const_set_lazy(:THROW_IE) { -1 }
          const_attr_reader  :THROW_IE
        }
        
        typesig { [Node] }
        # Checks for interrupt, returning THROW_IE if interrupted
        # before signalled, REINTERRUPT if after signalled, or
        # 0 if not interrupted.
        def check_interrupt_while_waiting(node)
          return JavaThread.interrupted ? (transfer_after_cancelled_wait(node) ? self.class::THROW_IE : self.class::REINTERRUPT) : 0
        end
        
        typesig { [::Java::Int] }
        # Throws InterruptedException, reinterrupts current thread, or
        # does nothing, depending on mode.
        def report_interrupt_after_wait(interrupt_mode)
          if ((interrupt_mode).equal?(self.class::THROW_IE))
            raise InterruptedException.new
          else
            if ((interrupt_mode).equal?(self.class::REINTERRUPT))
              self_interrupt
            end
          end
        end
        
        typesig { [] }
        # Implements interruptible condition wait.
        # <ol>
        # <li> If current thread is interrupted, throw InterruptedException.
        # <li> Save lock state returned by {@link #getState}.
        # <li> Invoke {@link #release} with
        # saved state as argument, throwing
        # IllegalMonitorStateException if it fails.
        # <li> Block until signalled or interrupted.
        # <li> Reacquire by invoking specialized version of
        # {@link #acquire} with saved state as argument.
        # <li> If interrupted while blocked in step 4, throw InterruptedException.
        # </ol>
        def await
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
          node = add_condition_waiter
          saved_state = fully_release(node)
          interrupt_mode = 0
          while (!is_on_sync_queue(node))
            LockSupport.park(self)
            if (!((interrupt_mode = check_interrupt_while_waiting(node))).equal?(0))
              break
            end
          end
          if (acquire_queued(node, saved_state) && !(interrupt_mode).equal?(self.class::THROW_IE))
            interrupt_mode = self.class::REINTERRUPT
          end
          if (!(node.attr_next_waiter).nil?)
            # clean up if cancelled
            unlink_cancelled_waiters
          end
          if (!(interrupt_mode).equal?(0))
            report_interrupt_after_wait(interrupt_mode)
          end
        end
        
        typesig { [::Java::Long] }
        # Implements timed condition wait.
        # <ol>
        # <li> If current thread is interrupted, throw InterruptedException.
        # <li> Save lock state returned by {@link #getState}.
        # <li> Invoke {@link #release} with
        # saved state as argument, throwing
        # IllegalMonitorStateException if it fails.
        # <li> Block until signalled, interrupted, or timed out.
        # <li> Reacquire by invoking specialized version of
        # {@link #acquire} with saved state as argument.
        # <li> If interrupted while blocked in step 4, throw InterruptedException.
        # </ol>
        def await_nanos(nanos_timeout)
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
          node = add_condition_waiter
          saved_state = fully_release(node)
          last_time = System.nano_time
          interrupt_mode = 0
          while (!is_on_sync_queue(node))
            if (nanos_timeout <= 0)
              transfer_after_cancelled_wait(node)
              break
            end
            LockSupport.park_nanos(self, nanos_timeout)
            if (!((interrupt_mode = check_interrupt_while_waiting(node))).equal?(0))
              break
            end
            now = System.nano_time
            nanos_timeout -= now - last_time
            last_time = now
          end
          if (acquire_queued(node, saved_state) && !(interrupt_mode).equal?(self.class::THROW_IE))
            interrupt_mode = self.class::REINTERRUPT
          end
          if (!(node.attr_next_waiter).nil?)
            unlink_cancelled_waiters
          end
          if (!(interrupt_mode).equal?(0))
            report_interrupt_after_wait(interrupt_mode)
          end
          return nanos_timeout - (System.nano_time - last_time)
        end
        
        typesig { [Date] }
        # Implements absolute timed condition wait.
        # <ol>
        # <li> If current thread is interrupted, throw InterruptedException.
        # <li> Save lock state returned by {@link #getState}.
        # <li> Invoke {@link #release} with
        # saved state as argument, throwing
        # IllegalMonitorStateException if it fails.
        # <li> Block until signalled, interrupted, or timed out.
        # <li> Reacquire by invoking specialized version of
        # {@link #acquire} with saved state as argument.
        # <li> If interrupted while blocked in step 4, throw InterruptedException.
        # <li> If timed out while blocked in step 4, return false, else true.
        # </ol>
        def await_until(deadline)
          if ((deadline).nil?)
            raise NullPointerException.new
          end
          abstime = deadline.get_time
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
          node = add_condition_waiter
          saved_state = fully_release(node)
          timedout = false
          interrupt_mode = 0
          while (!is_on_sync_queue(node))
            if (System.current_time_millis > abstime)
              timedout = transfer_after_cancelled_wait(node)
              break
            end
            LockSupport.park_until(self, abstime)
            if (!((interrupt_mode = check_interrupt_while_waiting(node))).equal?(0))
              break
            end
          end
          if (acquire_queued(node, saved_state) && !(interrupt_mode).equal?(self.class::THROW_IE))
            interrupt_mode = self.class::REINTERRUPT
          end
          if (!(node.attr_next_waiter).nil?)
            unlink_cancelled_waiters
          end
          if (!(interrupt_mode).equal?(0))
            report_interrupt_after_wait(interrupt_mode)
          end
          return !timedout
        end
        
        typesig { [::Java::Long, TimeUnit] }
        # Implements timed condition wait.
        # <ol>
        # <li> If current thread is interrupted, throw InterruptedException.
        # <li> Save lock state returned by {@link #getState}.
        # <li> Invoke {@link #release} with
        # saved state as argument, throwing
        # IllegalMonitorStateException if it fails.
        # <li> Block until signalled, interrupted, or timed out.
        # <li> Reacquire by invoking specialized version of
        # {@link #acquire} with saved state as argument.
        # <li> If interrupted while blocked in step 4, throw InterruptedException.
        # <li> If timed out while blocked in step 4, return false, else true.
        # </ol>
        def await(time, unit)
          if ((unit).nil?)
            raise NullPointerException.new
          end
          nanos_timeout = unit.to_nanos(time)
          if (JavaThread.interrupted)
            raise InterruptedException.new
          end
          node = add_condition_waiter
          saved_state = fully_release(node)
          last_time = System.nano_time
          timedout = false
          interrupt_mode = 0
          while (!is_on_sync_queue(node))
            if (nanos_timeout <= 0)
              timedout = transfer_after_cancelled_wait(node)
              break
            end
            if (nanos_timeout >= SpinForTimeoutThreshold)
              LockSupport.park_nanos(self, nanos_timeout)
            end
            if (!((interrupt_mode = check_interrupt_while_waiting(node))).equal?(0))
              break
            end
            now = System.nano_time
            nanos_timeout -= now - last_time
            last_time = now
          end
          if (acquire_queued(node, saved_state) && !(interrupt_mode).equal?(self.class::THROW_IE))
            interrupt_mode = self.class::REINTERRUPT
          end
          if (!(node.attr_next_waiter).nil?)
            unlink_cancelled_waiters
          end
          if (!(interrupt_mode).equal?(0))
            report_interrupt_after_wait(interrupt_mode)
          end
          return !timedout
        end
        
        typesig { [AbstractQueuedSynchronizer] }
        # support for instrumentation
        # 
        # Returns true if this condition was created by the given
        # synchronization object.
        # 
        # @return {@code true} if owned
        def is_owned_by(sync)
          return (sync).equal?(@local_class_parent)
        end
        
        typesig { [] }
        # Queries whether any threads are waiting on this condition.
        # Implements {@link AbstractQueuedSynchronizer#hasWaiters}.
        # 
        # @return {@code true} if there are any waiting threads
        # @throws IllegalMonitorStateException if {@link #isHeldExclusively}
        # returns {@code false}
        def has_waiters
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          w = @first_waiter
          while !(w).nil?
            if ((w.attr_wait_status).equal?(Node::CONDITION))
              return true
            end
            w = w.attr_next_waiter
          end
          return false
        end
        
        typesig { [] }
        # Returns an estimate of the number of threads waiting on
        # this condition.
        # Implements {@link AbstractQueuedSynchronizer#getWaitQueueLength}.
        # 
        # @return the estimated number of waiting threads
        # @throws IllegalMonitorStateException if {@link #isHeldExclusively}
        # returns {@code false}
        def get_wait_queue_length
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          n = 0
          w = @first_waiter
          while !(w).nil?
            if ((w.attr_wait_status).equal?(Node::CONDITION))
              (n += 1)
            end
            w = w.attr_next_waiter
          end
          return n
        end
        
        typesig { [] }
        # Returns a collection containing those threads that may be
        # waiting on this Condition.
        # Implements {@link AbstractQueuedSynchronizer#getWaitingThreads}.
        # 
        # @return the collection of threads
        # @throws IllegalMonitorStateException if {@link #isHeldExclusively}
        # returns {@code false}
        def get_waiting_threads
          if (!is_held_exclusively)
            raise IllegalMonitorStateException.new
          end
          list = ArrayList.new
          w = @first_waiter
          while !(w).nil?
            if ((w.attr_wait_status).equal?(Node::CONDITION))
              t = w.attr_thread
              if (!(t).nil?)
                list.add(t)
              end
            end
            w = w.attr_next_waiter
          end
          return list
        end
        
        private
        alias_method :initialize__condition_object, :initialize
      end }
      
      # Setup to support compareAndSet. We need to natively implement
      # this here: For the sake of permitting future enhancements, we
      # cannot explicitly subclass AtomicInteger, which would be
      # efficient and useful otherwise. So, as the lesser of evils, we
      # natively implement using hotspot intrinsics API. And while we
      # are at it, we do the same for other CASable fields (which could
      # otherwise be done with atomic field updaters).
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :StateOffset, UnsafeInstance.object_field_offset(AbstractQueuedSynchronizer.class.get_declared_field("state"))
          const_set :HeadOffset, UnsafeInstance.object_field_offset(AbstractQueuedSynchronizer.class.get_declared_field("head"))
          const_set :TailOffset, UnsafeInstance.object_field_offset(AbstractQueuedSynchronizer.class.get_declared_field("tail"))
          const_set :WaitStatusOffset, UnsafeInstance.object_field_offset(Node.class.get_declared_field("waitStatus"))
          const_set :NextOffset, UnsafeInstance.object_field_offset(Node.class.get_declared_field("next"))
        rescue Exception => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    typesig { [Node] }
    # CAS head field. Used only by enq.
    def compare_and_set_head(update)
      return UnsafeInstance.compare_and_swap_object(self, HeadOffset, nil, update)
    end
    
    typesig { [Node, Node] }
    # CAS tail field. Used only by enq.
    def compare_and_set_tail(expect, update)
      return UnsafeInstance.compare_and_swap_object(self, TailOffset, expect, update)
    end
    
    class_module.module_eval {
      typesig { [Node, ::Java::Int, ::Java::Int] }
      # CAS waitStatus field of a node.
      def compare_and_set_wait_status(node, expect, update)
        return UnsafeInstance.compare_and_swap_int(node, WaitStatusOffset, expect, update)
      end
      
      typesig { [Node, Node, Node] }
      # CAS next field of a node.
      def compare_and_set_next(node, expect, update)
        return UnsafeInstance.compare_and_swap_object(node, NextOffset, expect, update)
      end
    }
    
    private
    alias_method :initialize__abstract_queued_synchronizer, :initialize
  end
  
end

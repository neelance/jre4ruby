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
# Written by Doug Lea, Bill Scherer, and Michael Scott with
# assistance from members of JCP JSR-166 Expert Group and released to
# the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module SynchronousQueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util::Concurrent::Atomic
      include ::Java::Util
    }
  end
  
  # A {@linkplain BlockingQueue blocking queue} in which each insert
  # operation must wait for a corresponding remove operation by another
  # thread, and vice versa.  A synchronous queue does not have any
  # internal capacity, not even a capacity of one.  You cannot
  # <tt>peek</tt> at a synchronous queue because an element is only
  # present when you try to remove it; you cannot insert an element
  # (using any method) unless another thread is trying to remove it;
  # you cannot iterate as there is nothing to iterate.  The
  # <em>head</em> of the queue is the element that the first queued
  # inserting thread is trying to add to the queue; if there is no such
  # queued thread then no element is available for removal and
  # <tt>poll()</tt> will return <tt>null</tt>.  For purposes of other
  # <tt>Collection</tt> methods (for example <tt>contains</tt>), a
  # <tt>SynchronousQueue</tt> acts as an empty collection.  This queue
  # does not permit <tt>null</tt> elements.
  # 
  # <p>Synchronous queues are similar to rendezvous channels used in
  # CSP and Ada. They are well suited for handoff designs, in which an
  # object running in one thread must sync up with an object running
  # in another thread in order to hand it some information, event, or
  # task.
  # 
  # <p> This class supports an optional fairness policy for ordering
  # waiting producer and consumer threads.  By default, this ordering
  # is not guaranteed. However, a queue constructed with fairness set
  # to <tt>true</tt> grants threads access in FIFO order.
  # 
  # <p>This class and its iterator implement all of the
  # <em>optional</em> methods of the {@link Collection} and {@link
  # Iterator} interfaces.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.5
  # @author Doug Lea and Bill Scherer and Michael Scott
  # @param <E> the type of elements held in this collection
  class SynchronousQueue < SynchronousQueueImports.const_get :AbstractQueue
    include_class_members SynchronousQueueImports
    overload_protected {
      include BlockingQueue
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3223113410248163686 }
      const_attr_reader  :SerialVersionUID
      
      # This class implements extensions of the dual stack and dual
      # queue algorithms described in "Nonblocking Concurrent Objects
      # with Condition Synchronization", by W. N. Scherer III and
      # M. L. Scott.  18th Annual Conf. on Distributed Computing,
      # Oct. 2004 (see also
      # http://www.cs.rochester.edu/u/scott/synchronization/pseudocode/duals.html).
      # The (Lifo) stack is used for non-fair mode, and the (Fifo)
      # queue for fair mode. The performance of the two is generally
      # similar. Fifo usually supports higher throughput under
      # contention but Lifo maintains higher thread locality in common
      # applications.
      # 
      # A dual queue (and similarly stack) is one that at any given
      # time either holds "data" -- items provided by put operations,
      # or "requests" -- slots representing take operations, or is
      # empty. A call to "fulfill" (i.e., a call requesting an item
      # from a queue holding data or vice versa) dequeues a
      # complementary node.  The most interesting feature of these
      # queues is that any operation can figure out which mode the
      # queue is in, and act accordingly without needing locks.
      # 
      # Both the queue and stack extend abstract class Transferer
      # defining the single method transfer that does a put or a
      # take. These are unified into a single method because in dual
      # data structures, the put and take operations are symmetrical,
      # so nearly all code can be combined. The resulting transfer
      # methods are on the long side, but are easier to follow than
      # they would be if broken up into nearly-duplicated parts.
      # 
      # The queue and stack data structures share many conceptual
      # similarities but very few concrete details. For simplicity,
      # they are kept distinct so that they can later evolve
      # separately.
      # 
      # The algorithms here differ from the versions in the above paper
      # in extending them for use in synchronous queues, as well as
      # dealing with cancellation. The main differences include:
      # 
      # 1. The original algorithms used bit-marked pointers, but
      # the ones here use mode bits in nodes, leading to a number
      # of further adaptations.
      # 2. SynchronousQueues must block threads waiting to become
      # fulfilled.
      # 3. Support for cancellation via timeout and interrupts,
      # including cleaning out cancelled nodes/threads
      # from lists to avoid garbage retention and memory depletion.
      # 
      # Blocking is mainly accomplished using LockSupport park/unpark,
      # except that nodes that appear to be the next ones to become
      # fulfilled first spin a bit (on multiprocessors only). On very
      # busy synchronous queues, spinning can dramatically improve
      # throughput. And on less busy ones, the amount of spinning is
      # small enough not to be noticeable.
      # 
      # Cleaning is done in different ways in queues vs stacks.  For
      # queues, we can almost always remove a node immediately in O(1)
      # time (modulo retries for consistency checks) when it is
      # cancelled. But if it may be pinned as the current tail, it must
      # wait until some subsequent cancellation. For stacks, we need a
      # potentially O(n) traversal to be sure that we can remove the
      # node, but this can run concurrently with other threads
      # accessing the stack.
      # 
      # While garbage collection takes care of most node reclamation
      # issues that otherwise complicate nonblocking algorithms, care
      # is taken to "forget" references to data, other nodes, and
      # threads that might be held on to long-term by blocked
      # threads. In cases where setting to null would otherwise
      # conflict with main algorithms, this is done by changing a
      # node's link to now point to the node itself. This doesn't arise
      # much for Stack nodes (because blocked threads do not hang on to
      # old head pointers), but references in Queue nodes must be
      # aggressively forgotten to avoid reachability of everything any
      # node has ever referred to since arrival.
      # 
      # 
      # Shared internal API for dual stacks and queues.
      const_set_lazy(:Transferer) { Class.new do
        include_class_members SynchronousQueue
        
        typesig { [Object, ::Java::Boolean, ::Java::Long] }
        # Performs a put or take.
        # 
        # @param e if non-null, the item to be handed to a consumer;
        # if null, requests that transfer return an item
        # offered by producer.
        # @param timed if this operation should timeout
        # @param nanos the timeout, in nanoseconds
        # @return if non-null, the item provided or received; if null,
        # the operation failed due to timeout or interrupt --
        # the caller can distinguish which of these occurred
        # by checking Thread.interrupted.
        def transfer(e, timed, nanos)
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__transferer, :initialize
      end }
      
      # The number of CPUs, for spin control
      const_set_lazy(:NCPUS) { Runtime.get_runtime.available_processors }
      const_attr_reader  :NCPUS
      
      # The number of times to spin before blocking in timed waits.
      # The value is empirically derived -- it works well across a
      # variety of processors and OSes. Empirically, the best value
      # seems not to vary with number of CPUs (beyond 2) so is just
      # a constant.
      const_set_lazy(:MaxTimedSpins) { (NCPUS < 2) ? 0 : 32 }
      const_attr_reader  :MaxTimedSpins
      
      # The number of times to spin before blocking in untimed waits.
      # This is greater than timed value because untimed waits spin
      # faster since they don't need to check times on each spin.
      const_set_lazy(:MaxUntimedSpins) { MaxTimedSpins * 16 }
      const_attr_reader  :MaxUntimedSpins
      
      # The number of nanoseconds for which it is faster to spin
      # rather than to use timed park. A rough estimate suffices.
      const_set_lazy(:SpinForTimeoutThreshold) { 1000 }
      const_attr_reader  :SpinForTimeoutThreshold
      
      # Dual stack
      const_set_lazy(:TransferStack) { Class.new(Transferer) do
        include_class_members SynchronousQueue
        
        class_module.module_eval {
          # This extends Scherer-Scott dual stack algorithm, differing,
          # among other ways, by using "covering" nodes rather than
          # bit-marked pointers: Fulfilling operations push on marker
          # nodes (with FULFILLING bit set in mode) to reserve a spot
          # to match a waiting node.
          # 
          # Modes for SNodes, ORed together in node fields
          # Node represents an unfulfilled consumer
          const_set_lazy(:REQUEST) { 0 }
          const_attr_reader  :REQUEST
          
          # Node represents an unfulfilled producer
          const_set_lazy(:DATA) { 1 }
          const_attr_reader  :DATA
          
          # Node is fulfilling another unfulfilled DATA or REQUEST
          const_set_lazy(:FULFILLING) { 2 }
          const_attr_reader  :FULFILLING
          
          typesig { [::Java::Int] }
          # Return true if m has fulfilling bit set
          def is_fulfilling(m)
            return !((m & self.class::FULFILLING)).equal?(0)
          end
          
          # Node class for TransferStacks.
          const_set_lazy(:SNode) { Class.new do
            include_class_members TransferStack
            
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            # next node in stack
            attr_accessor :match
            alias_method :attr_match, :match
            undef_method :match
            alias_method :attr_match=, :match=
            undef_method :match=
            
            # the node matched to this
            attr_accessor :waiter
            alias_method :attr_waiter, :waiter
            undef_method :waiter
            alias_method :attr_waiter=, :waiter=
            undef_method :waiter=
            
            # to control park/unpark
            attr_accessor :item
            alias_method :attr_item, :item
            undef_method :item
            alias_method :attr_item=, :item=
            undef_method :item=
            
            # data; or null for REQUESTs
            attr_accessor :mode
            alias_method :attr_mode, :mode
            undef_method :mode
            alias_method :attr_mode=, :mode=
            undef_method :mode=
            
            typesig { [Object] }
            # Note: item and mode fields don't need to be volatile
            # since they are always written before, and read after,
            # other volatile/atomic operations.
            def initialize(item)
              @next = nil
              @match = nil
              @waiter = nil
              @item = nil
              @mode = 0
              @item = item
            end
            
            class_module.module_eval {
              const_set_lazy(:NextUpdater) { AtomicReferenceFieldUpdater.new_updater(SNode, SNode, "next") }
              const_attr_reader  :NextUpdater
            }
            
            typesig { [class_self::SNode, class_self::SNode] }
            def cas_next(cmp, val)
              return ((cmp).equal?(@next) && self.class::NextUpdater.compare_and_set(self, cmp, val))
            end
            
            class_module.module_eval {
              const_set_lazy(:MatchUpdater) { AtomicReferenceFieldUpdater.new_updater(SNode, SNode, "match") }
              const_attr_reader  :MatchUpdater
            }
            
            typesig { [class_self::SNode] }
            # Tries to match node s to this node, if so, waking up thread.
            # Fulfillers call tryMatch to identify their waiters.
            # Waiters block until they have been matched.
            # 
            # @param s the node to match
            # @return true if successfully matched to s
            def try_match(s)
              if ((@match).nil? && self.class::MatchUpdater.compare_and_set(self, nil, s))
                w = @waiter
                if (!(w).nil?)
                  # waiters need at most one unpark
                  @waiter = nil
                  LockSupport.unpark(w)
                end
                return true
              end
              return (@match).equal?(s)
            end
            
            typesig { [] }
            # Tries to cancel a wait by matching node to itself.
            def try_cancel
              self.class::MatchUpdater.compare_and_set(self, nil, self)
            end
            
            typesig { [] }
            def is_cancelled
              return (@match).equal?(self)
            end
            
            private
            alias_method :initialize__snode, :initialize
          end }
        }
        
        # The head (top) of the stack
        attr_accessor :head
        alias_method :attr_head, :head
        undef_method :head
        alias_method :attr_head=, :head=
        undef_method :head=
        
        class_module.module_eval {
          const_set_lazy(:HeadUpdater) { AtomicReferenceFieldUpdater.new_updater(TransferStack, SNode, "head") }
          const_attr_reader  :HeadUpdater
        }
        
        typesig { [class_self::SNode, class_self::SNode] }
        def cas_head(h, nh)
          return (h).equal?(@head) && self.class::HeadUpdater.compare_and_set(self, h, nh)
        end
        
        class_module.module_eval {
          typesig { [class_self::SNode, Object, class_self::SNode, ::Java::Int] }
          # Creates or resets fields of a node. Called only from transfer
          # where the node to push on stack is lazily created and
          # reused when possible to help reduce intervals between reads
          # and CASes of head and to avoid surges of garbage when CASes
          # to push nodes fail due to contention.
          def snode(s, e, next_, mode)
            if ((s).nil?)
              s = class_self::SNode.new(e)
            end
            s.attr_mode = mode
            s.attr_next = next_
            return s
          end
        }
        
        typesig { [Object, ::Java::Boolean, ::Java::Long] }
        # Puts or takes an item.
        def transfer(e, timed, nanos)
          # Basic algorithm is to loop trying one of three actions:
          # 
          # 1. If apparently empty or already containing nodes of same
          # mode, try to push node on stack and wait for a match,
          # returning it, or null if cancelled.
          # 
          # 2. If apparently containing node of complementary mode,
          # try to push a fulfilling node on to stack, match
          # with corresponding waiting node, pop both from
          # stack, and return matched item. The matching or
          # unlinking might not actually be necessary because of
          # other threads performing action 3:
          # 
          # 3. If top of stack already holds another fulfilling node,
          # help it out by doing its match and/or pop
          # operations, and then continue. The code for helping
          # is essentially the same as for fulfilling, except
          # that it doesn't return the item.
          s = nil # constructed/reused as needed
          mode = ((e).nil?) ? self.class::REQUEST : self.class::DATA
          loop do
            h = @head
            if ((h).nil? || (h.attr_mode).equal?(mode))
              # empty or same-mode
              if (timed && nanos <= 0)
                # can't wait
                if (!(h).nil? && h.is_cancelled)
                  cas_head(h, h.attr_next)
                   # pop cancelled node
                else
                  return nil
                end
              else
                if (cas_head(h, s = snode(s, e, h, mode)))
                  m = await_fulfill(s, timed, nanos)
                  if ((m).equal?(s))
                    # wait was cancelled
                    clean(s)
                    return nil
                  end
                  if (!((h = @head)).nil? && (h.attr_next).equal?(s))
                    cas_head(h, s.attr_next)
                  end # help s's fulfiller
                  return (mode).equal?(self.class::REQUEST) ? m.attr_item : s.attr_item
                end
              end
            else
              if (!is_fulfilling(h.attr_mode))
                # try to fulfill
                if (h.is_cancelled)
                  # already cancelled
                  cas_head(h, h.attr_next)
                   # pop and retry
                else
                  if (cas_head(h, s = snode(s, e, h, self.class::FULFILLING | mode)))
                    loop do
                      # loop until matched or waiters disappear
                      m = s.attr_next # m is s's match
                      if ((m).nil?)
                        # all waiters are gone
                        cas_head(s, nil) # pop fulfill node
                        s = nil # use new node next time
                        break # restart main loop
                      end
                      mn = m.attr_next
                      if (m.try_match(s))
                        cas_head(s, mn) # pop both s and m
                        return ((mode).equal?(self.class::REQUEST)) ? m.attr_item : s.attr_item
                      else
                        # lost match
                        s.cas_next(m, mn)
                      end # help unlink
                    end
                  end
                end
              else
                # help a fulfiller
                m = h.attr_next # m is h's match
                if ((m).nil?)
                  # waiter is gone
                  cas_head(h, nil)
                   # pop fulfilling node
                else
                  mn = m.attr_next
                  if (m.try_match(h))
                    # help match
                    cas_head(h, mn)
                     # pop both h and m
                  else
                    # lost match
                    h.cas_next(m, mn)
                  end # help unlink
                end
              end
            end
          end
        end
        
        typesig { [class_self::SNode, ::Java::Boolean, ::Java::Long] }
        # Spins/blocks until node s is matched by a fulfill operation.
        # 
        # @param s the waiting node
        # @param timed true if timed wait
        # @param nanos timeout value
        # @return matched node, or s if cancelled
        def await_fulfill(s, timed, nanos)
          # When a node/thread is about to block, it sets its waiter
          # field and then rechecks state at least one more time
          # before actually parking, thus covering race vs
          # fulfiller noticing that waiter is non-null so should be
          # woken.
          # 
          # When invoked by nodes that appear at the point of call
          # to be at the head of the stack, calls to park are
          # preceded by spins to avoid blocking when producers and
          # consumers are arriving very close in time.  This can
          # happen enough to bother only on multiprocessors.
          # 
          # The order of checks for returning out of main loop
          # reflects fact that interrupts have precedence over
          # normal returns, which have precedence over
          # timeouts. (So, on timeout, one last check for match is
          # done before giving up.) Except that calls from untimed
          # SynchronousQueue.{poll/offer} don't check interrupts
          # and don't wait at all, so are trapped in transfer
          # method rather than calling awaitFulfill.
          last_time = (timed) ? System.nano_time : 0
          w = JavaThread.current_thread
          h = @head
          spins = (should_spin(s) ? (timed ? MaxTimedSpins : MaxUntimedSpins) : 0)
          loop do
            if (w.is_interrupted)
              s.try_cancel
            end
            m = s.attr_match
            if (!(m).nil?)
              return m
            end
            if (timed)
              now = System.nano_time
              nanos -= now - last_time
              last_time = now
              if (nanos <= 0)
                s.try_cancel
                next
              end
            end
            if (spins > 0)
              spins = should_spin(s) ? (spins - 1) : 0
            else
              if ((s.attr_waiter).nil?)
                s.attr_waiter = w
                 # establish waiter so can park next iter
              else
                if (!timed)
                  LockSupport.park(self)
                else
                  if (nanos > SpinForTimeoutThreshold)
                    LockSupport.park_nanos(self, nanos)
                  end
                end
              end
            end
          end
        end
        
        typesig { [class_self::SNode] }
        # Returns true if node s is at head or there is an active
        # fulfiller.
        def should_spin(s)
          h = @head
          return ((h).equal?(s) || (h).nil? || is_fulfilling(h.attr_mode))
        end
        
        typesig { [class_self::SNode] }
        # Unlinks s from the stack.
        def clean(s)
          s.attr_item = nil # forget item
          s.attr_waiter = nil # forget thread
          # At worst we may need to traverse entire stack to unlink
          # s. If there are multiple concurrent calls to clean, we
          # might not see s if another thread has already removed
          # it. But we can stop when we see any node known to
          # follow s. We use s.next unless it too is cancelled, in
          # which case we try the node one past. We don't check any
          # further because we don't want to doubly traverse just to
          # find sentinel.
          past = s.attr_next
          if (!(past).nil? && past.is_cancelled)
            past = past.attr_next
          end
          # Absorb cancelled nodes at head
          p = nil
          while (!((p = @head)).nil? && !(p).equal?(past) && p.is_cancelled)
            cas_head(p, p.attr_next)
          end
          # Unsplice embedded nodes
          while (!(p).nil? && !(p).equal?(past))
            n = p.attr_next
            if (!(n).nil? && n.is_cancelled)
              p.cas_next(n, n.attr_next)
            else
              p = n
            end
          end
        end
        
        typesig { [] }
        def initialize
          @head = nil
          super()
        end
        
        private
        alias_method :initialize__transfer_stack, :initialize
      end }
      
      # Dual Queue
      const_set_lazy(:TransferQueue) { Class.new(Transferer) do
        include_class_members SynchronousQueue
        
        class_module.module_eval {
          # This extends Scherer-Scott dual queue algorithm, differing,
          # among other ways, by using modes within nodes rather than
          # marked pointers. The algorithm is a little simpler than
          # that for stacks because fulfillers do not need explicit
          # nodes, and matching is done by CAS'ing QNode.item field
          # from non-null to null (for put) or vice versa (for take).
          # 
          # Node class for TransferQueue.
          const_set_lazy(:QNode) { Class.new do
            include_class_members TransferQueue
            
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            # next node in queue
            attr_accessor :item
            alias_method :attr_item, :item
            undef_method :item
            alias_method :attr_item=, :item=
            undef_method :item=
            
            # CAS'ed to or from null
            attr_accessor :waiter
            alias_method :attr_waiter, :waiter
            undef_method :waiter
            alias_method :attr_waiter=, :waiter=
            undef_method :waiter=
            
            # to control park/unpark
            attr_accessor :is_data
            alias_method :attr_is_data, :is_data
            undef_method :is_data
            alias_method :attr_is_data=, :is_data=
            undef_method :is_data=
            
            typesig { [Object, ::Java::Boolean] }
            def initialize(item, is_data)
              @next = nil
              @item = nil
              @waiter = nil
              @is_data = false
              @item = item
              @is_data = is_data
            end
            
            class_module.module_eval {
              const_set_lazy(:NextUpdater) { AtomicReferenceFieldUpdater.new_updater(QNode, QNode, "next") }
              const_attr_reader  :NextUpdater
            }
            
            typesig { [class_self::QNode, class_self::QNode] }
            def cas_next(cmp, val)
              return ((@next).equal?(cmp) && self.class::NextUpdater.compare_and_set(self, cmp, val))
            end
            
            class_module.module_eval {
              const_set_lazy(:ItemUpdater) { AtomicReferenceFieldUpdater.new_updater(QNode, Object, "item") }
              const_attr_reader  :ItemUpdater
            }
            
            typesig { [Object, Object] }
            def cas_item(cmp, val)
              return ((@item).equal?(cmp) && self.class::ItemUpdater.compare_and_set(self, cmp, val))
            end
            
            typesig { [Object] }
            # Tries to cancel by CAS'ing ref to this as item.
            def try_cancel(cmp)
              self.class::ItemUpdater.compare_and_set(self, cmp, self)
            end
            
            typesig { [] }
            def is_cancelled
              return (@item).equal?(self)
            end
            
            typesig { [] }
            # Returns true if this node is known to be off the queue
            # because its next pointer has been forgotten due to
            # an advanceHead operation.
            def is_off_list
              return (@next).equal?(self)
            end
            
            private
            alias_method :initialize__qnode, :initialize
          end }
        }
        
        # Head of queue
        attr_accessor :head
        alias_method :attr_head, :head
        undef_method :head
        alias_method :attr_head=, :head=
        undef_method :head=
        
        # Tail of queue
        attr_accessor :tail
        alias_method :attr_tail, :tail
        undef_method :tail
        alias_method :attr_tail=, :tail=
        undef_method :tail=
        
        # Reference to a cancelled node that might not yet have been
        # unlinked from queue because it was the last inserted node
        # when it cancelled.
        attr_accessor :clean_me
        alias_method :attr_clean_me, :clean_me
        undef_method :clean_me
        alias_method :attr_clean_me=, :clean_me=
        undef_method :clean_me=
        
        typesig { [] }
        def initialize
          @head = nil
          @tail = nil
          @clean_me = nil
          super()
          h = self.class::QNode.new(nil, false) # initialize to dummy node.
          @head = h
          @tail = h
        end
        
        class_module.module_eval {
          const_set_lazy(:HeadUpdater) { AtomicReferenceFieldUpdater.new_updater(TransferQueue, QNode, "head") }
          const_attr_reader  :HeadUpdater
        }
        
        typesig { [class_self::QNode, class_self::QNode] }
        # Tries to cas nh as new head; if successful, unlink
        # old head's next node to avoid garbage retention.
        def advance_head(h, nh)
          if ((h).equal?(@head) && self.class::HeadUpdater.compare_and_set(self, h, nh))
            h.attr_next = h
          end # forget old next
        end
        
        class_module.module_eval {
          const_set_lazy(:TailUpdater) { AtomicReferenceFieldUpdater.new_updater(TransferQueue, QNode, "tail") }
          const_attr_reader  :TailUpdater
        }
        
        typesig { [class_self::QNode, class_self::QNode] }
        # Tries to cas nt as new tail.
        def advance_tail(t, nt)
          if ((@tail).equal?(t))
            self.class::TailUpdater.compare_and_set(self, t, nt)
          end
        end
        
        class_module.module_eval {
          const_set_lazy(:CleanMeUpdater) { AtomicReferenceFieldUpdater.new_updater(TransferQueue, QNode, "cleanMe") }
          const_attr_reader  :CleanMeUpdater
        }
        
        typesig { [class_self::QNode, class_self::QNode] }
        # Tries to CAS cleanMe slot.
        def cas_clean_me(cmp, val)
          return ((@clean_me).equal?(cmp) && self.class::CleanMeUpdater.compare_and_set(self, cmp, val))
        end
        
        typesig { [Object, ::Java::Boolean, ::Java::Long] }
        # Puts or takes an item.
        def transfer(e, timed, nanos)
          # Basic algorithm is to loop trying to take either of
          # two actions:
          # 
          # 1. If queue apparently empty or holding same-mode nodes,
          # try to add node to queue of waiters, wait to be
          # fulfilled (or cancelled) and return matching item.
          # 
          # 2. If queue apparently contains waiting items, and this
          # call is of complementary mode, try to fulfill by CAS'ing
          # item field of waiting node and dequeuing it, and then
          # returning matching item.
          # 
          # In each case, along the way, check for and try to help
          # advance head and tail on behalf of other stalled/slow
          # threads.
          # 
          # The loop starts off with a null check guarding against
          # seeing uninitialized head or tail values. This never
          # happens in current SynchronousQueue, but could if
          # callers held non-volatile/final ref to the
          # transferer. The check is here anyway because it places
          # null checks at top of loop, which is usually faster
          # than having them implicitly interspersed.
          s = nil # constructed/reused as needed
          is_data = (!(e).nil?)
          loop do
            t = @tail
            h = @head
            if ((t).nil? || (h).nil?)
              # saw uninitialized value
              next
            end # spin
            if ((h).equal?(t) || (t.attr_is_data).equal?(is_data))
              # empty or same-mode
              tn = t.attr_next
              if (!(t).equal?(@tail))
                # inconsistent read
                next
              end
              if (!(tn).nil?)
                # lagging tail
                advance_tail(t, tn)
                next
              end
              if (timed && nanos <= 0)
                # can't wait
                return nil
              end
              if ((s).nil?)
                s = self.class::QNode.new(e, is_data)
              end
              if (!t.cas_next(nil, s))
                # failed to link in
                next
              end
              advance_tail(t, s) # swing tail and wait
              x = await_fulfill(s, e, timed, nanos)
              if ((x).equal?(s))
                # wait was cancelled
                clean(t, s)
                return nil
              end
              if (!s.is_off_list)
                # not already unlinked
                advance_head(t, s) # unlink if head
                if (!(x).nil?)
                  # and forget fields
                  s.attr_item = s
                end
                s.attr_waiter = nil
              end
              return (!(x).nil?) ? x : e
            else
              # complementary-mode
              m = h.attr_next # node to fulfill
              if (!(t).equal?(@tail) || (m).nil? || !(h).equal?(@head))
                next
              end # inconsistent read
              x = m.attr_item
              # m already fulfilled
              # m cancelled
              if ((is_data).equal?((!(x).nil?)) || (x).equal?(m) || !m.cas_item(x, e))
                # lost CAS
                advance_head(h, m) # dequeue and retry
                next
              end
              advance_head(h, m) # successfully fulfilled
              LockSupport.unpark(m.attr_waiter)
              return (!(x).nil?) ? x : e
            end
          end
        end
        
        typesig { [class_self::QNode, Object, ::Java::Boolean, ::Java::Long] }
        # Spins/blocks until node s is fulfilled.
        # 
        # @param s the waiting node
        # @param e the comparison value for checking match
        # @param timed true if timed wait
        # @param nanos timeout value
        # @return matched item, or s if cancelled
        def await_fulfill(s, e, timed, nanos)
          # Same idea as TransferStack.awaitFulfill
          last_time = (timed) ? System.nano_time : 0
          w = JavaThread.current_thread
          spins = (((@head.attr_next).equal?(s)) ? (timed ? MaxTimedSpins : MaxUntimedSpins) : 0)
          loop do
            if (w.is_interrupted)
              s.try_cancel(e)
            end
            x = s.attr_item
            if (!(x).equal?(e))
              return x
            end
            if (timed)
              now = System.nano_time
              nanos -= now - last_time
              last_time = now
              if (nanos <= 0)
                s.try_cancel(e)
                next
              end
            end
            if (spins > 0)
              (spins -= 1)
            else
              if ((s.attr_waiter).nil?)
                s.attr_waiter = w
              else
                if (!timed)
                  LockSupport.park(self)
                else
                  if (nanos > SpinForTimeoutThreshold)
                    LockSupport.park_nanos(self, nanos)
                  end
                end
              end
            end
          end
        end
        
        typesig { [class_self::QNode, class_self::QNode] }
        # Gets rid of cancelled node s with original predecessor pred.
        def clean(pred, s)
          s.attr_waiter = nil # forget thread
          # At any given time, exactly one node on list cannot be
          # deleted -- the last inserted node. To accommodate this,
          # if we cannot delete s, we save its predecessor as
          # "cleanMe", deleting the previously saved version
          # first. At least one of node s or the node previously
          # saved can always be deleted, so this always terminates.
          while ((pred.attr_next).equal?(s))
            # Return early if already unlinked
            h = @head
            hn = h.attr_next # Absorb cancelled first node as head
            if (!(hn).nil? && hn.is_cancelled)
              advance_head(h, hn)
              next
            end
            t = @tail # Ensure consistent read for tail
            if ((t).equal?(h))
              return
            end
            tn = t.attr_next
            if (!(t).equal?(@tail))
              next
            end
            if (!(tn).nil?)
              advance_tail(t, tn)
              next
            end
            if (!(s).equal?(t))
              # If not tail, try to unsplice
              sn = s.attr_next
              if ((sn).equal?(s) || pred.cas_next(s, sn))
                return
              end
            end
            dp = @clean_me
            if (!(dp).nil?)
              # Try unlinking previous cancelled node
              d = dp.attr_next
              dn = nil
              # d is gone or
              # d is off list or
              # d not cancelled or
              # d not tail and
              # has successor
              # that is on list
              if ((d).nil? || (d).equal?(dp) || !d.is_cancelled || (!(d).equal?(t) && !((dn = d.attr_next)).nil? && !(dn).equal?(d) && dp.cas_next(d, dn)))
                # d unspliced
                cas_clean_me(dp, nil)
              end
              if ((dp).equal?(pred))
                return
              end # s is already saved node
            else
              if (cas_clean_me(nil, pred))
                return
              end
            end # Postpone cleaning s
          end
        end
        
        private
        alias_method :initialize__transfer_queue, :initialize
      end }
    }
    
    # The transferer. Set only in constructor, but cannot be declared
    # as final without further complicating serialization.  Since
    # this is accessed only at most once per public method, there
    # isn't a noticeable performance penalty for using volatile
    # instead of final here.
    attr_accessor :transferer
    alias_method :attr_transferer, :transferer
    undef_method :transferer
    alias_method :attr_transferer=, :transferer=
    undef_method :transferer=
    
    typesig { [] }
    # Creates a <tt>SynchronousQueue</tt> with nonfair access policy.
    def initialize
      initialize__synchronous_queue(false)
    end
    
    typesig { [::Java::Boolean] }
    # Creates a <tt>SynchronousQueue</tt> with the specified fairness policy.
    # 
    # @param fair if true, waiting threads contend in FIFO order for
    # access; otherwise the order is unspecified.
    def initialize(fair)
      @transferer = nil
      @qlock = nil
      @waiting_producers = nil
      @waiting_consumers = nil
      super()
      @transferer = (fair) ? TransferQueue.new : TransferStack.new
    end
    
    typesig { [Object] }
    # Adds the specified element to this queue, waiting if necessary for
    # another thread to receive it.
    # 
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def put(o)
      if ((o).nil?)
        raise NullPointerException.new
      end
      if ((@transferer.transfer(o, false, 0)).nil?)
        JavaThread.interrupted
        raise InterruptedException.new
      end
    end
    
    typesig { [Object, ::Java::Long, TimeUnit] }
    # Inserts the specified element into this queue, waiting if necessary
    # up to the specified wait time for another thread to receive it.
    # 
    # @return <tt>true</tt> if successful, or <tt>false</tt> if the
    # specified waiting time elapses before a consumer appears.
    # @throws InterruptedException {@inheritDoc}
    # @throws NullPointerException {@inheritDoc}
    def offer(o, timeout, unit)
      if ((o).nil?)
        raise NullPointerException.new
      end
      if (!(@transferer.transfer(o, true, unit.to_nanos(timeout))).nil?)
        return true
      end
      if (!JavaThread.interrupted)
        return false
      end
      raise InterruptedException.new
    end
    
    typesig { [Object] }
    # Inserts the specified element into this queue, if another thread is
    # waiting to receive it.
    # 
    # @param e the element to add
    # @return <tt>true</tt> if the element was added to this queue, else
    # <tt>false</tt>
    # @throws NullPointerException if the specified element is null
    def offer(e)
      if ((e).nil?)
        raise NullPointerException.new
      end
      return !(@transferer.transfer(e, true, 0)).nil?
    end
    
    typesig { [] }
    # Retrieves and removes the head of this queue, waiting if necessary
    # for another thread to insert it.
    # 
    # @return the head of this queue
    # @throws InterruptedException {@inheritDoc}
    def take
      e = @transferer.transfer(nil, false, 0)
      if (!(e).nil?)
        return e
      end
      JavaThread.interrupted
      raise InterruptedException.new
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Retrieves and removes the head of this queue, waiting
    # if necessary up to the specified wait time, for another thread
    # to insert it.
    # 
    # @return the head of this queue, or <tt>null</tt> if the
    # specified waiting time elapses before an element is present.
    # @throws InterruptedException {@inheritDoc}
    def poll(timeout, unit)
      e = @transferer.transfer(nil, true, unit.to_nanos(timeout))
      if (!(e).nil? || !JavaThread.interrupted)
        return e
      end
      raise InterruptedException.new
    end
    
    typesig { [] }
    # Retrieves and removes the head of this queue, if another thread
    # is currently making an element available.
    # 
    # @return the head of this queue, or <tt>null</tt> if no
    # element is available.
    def poll
      return @transferer.transfer(nil, true, 0)
    end
    
    typesig { [] }
    # Always returns <tt>true</tt>.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @return <tt>true</tt>
    def is_empty
      return true
    end
    
    typesig { [] }
    # Always returns zero.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @return zero.
    def size
      return 0
    end
    
    typesig { [] }
    # Always returns zero.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @return zero.
    def remaining_capacity
      return 0
    end
    
    typesig { [] }
    # Does nothing.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    def clear
    end
    
    typesig { [Object] }
    # Always returns <tt>false</tt>.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @param o the element
    # @return <tt>false</tt>
    def contains(o)
      return false
    end
    
    typesig { [Object] }
    # Always returns <tt>false</tt>.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @param o the element to remove
    # @return <tt>false</tt>
    def remove(o)
      return false
    end
    
    typesig { [Collection] }
    # Returns <tt>false</tt> unless the given collection is empty.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @param c the collection
    # @return <tt>false</tt> unless given collection is empty
    def contains_all(c)
      return c.is_empty
    end
    
    typesig { [Collection] }
    # Always returns <tt>false</tt>.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @param c the collection
    # @return <tt>false</tt>
    def remove_all(c)
      return false
    end
    
    typesig { [Collection] }
    # Always returns <tt>false</tt>.
    # A <tt>SynchronousQueue</tt> has no internal capacity.
    # 
    # @param c the collection
    # @return <tt>false</tt>
    def retain_all(c)
      return false
    end
    
    typesig { [] }
    # Always returns <tt>null</tt>.
    # A <tt>SynchronousQueue</tt> does not return elements
    # unless actively waited on.
    # 
    # @return <tt>null</tt>
    def peek
      return nil
    end
    
    typesig { [] }
    # Returns an empty iterator in which <tt>hasNext</tt> always returns
    # <tt>false</tt>.
    # 
    # @return an empty iterator
    def iterator
      return Collections.empty_list.iterator
    end
    
    typesig { [] }
    # Returns a zero-length array.
    # @return a zero-length array
    def to_array
      return Array.typed(Object).new(0) { nil }
    end
    
    typesig { [Array.typed(Object)] }
    # Sets the zeroeth element of the specified array to <tt>null</tt>
    # (if the array has non-zero length) and returns it.
    # 
    # @param a the array
    # @return the specified array
    # @throws NullPointerException if the specified array is null
    def to_array(a)
      if (a.attr_length > 0)
        a[0] = nil
      end
      return a
    end
    
    typesig { [Collection] }
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def drain_to(c)
      if ((c).nil?)
        raise NullPointerException.new
      end
      if ((c).equal?(self))
        raise IllegalArgumentException.new
      end
      n = 0
      e = nil
      while (!((e = poll)).nil?)
        c.add(e)
        (n += 1)
      end
      return n
    end
    
    typesig { [Collection, ::Java::Int] }
    # @throws UnsupportedOperationException {@inheritDoc}
    # @throws ClassCastException            {@inheritDoc}
    # @throws NullPointerException          {@inheritDoc}
    # @throws IllegalArgumentException      {@inheritDoc}
    def drain_to(c, max_elements)
      if ((c).nil?)
        raise NullPointerException.new
      end
      if ((c).equal?(self))
        raise IllegalArgumentException.new
      end
      n = 0
      e = nil
      while (n < max_elements && !((e = poll)).nil?)
        c.add(e)
        (n += 1)
      end
      return n
    end
    
    class_module.module_eval {
      # To cope with serialization strategy in the 1.5 version of
      # SynchronousQueue, we declare some unused classes and fields
      # that exist solely to enable serializability across versions.
      # These fields are never used, so are initialized only if this
      # object is ever serialized or deserialized.
      const_set_lazy(:WaitQueue) { Class.new do
        include_class_members SynchronousQueue
        include Java::Io::Serializable
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__wait_queue, :initialize
      end }
      
      const_set_lazy(:LifoWaitQueue) { Class.new(WaitQueue) do
        include_class_members SynchronousQueue
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -3633113410248163686 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__lifo_wait_queue, :initialize
      end }
      
      const_set_lazy(:FifoWaitQueue) { Class.new(WaitQueue) do
        include_class_members SynchronousQueue
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -3623113410248163686 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__fifo_wait_queue, :initialize
      end }
    }
    
    attr_accessor :qlock
    alias_method :attr_qlock, :qlock
    undef_method :qlock
    alias_method :attr_qlock=, :qlock=
    undef_method :qlock=
    
    attr_accessor :waiting_producers
    alias_method :attr_waiting_producers, :waiting_producers
    undef_method :waiting_producers
    alias_method :attr_waiting_producers=, :waiting_producers=
    undef_method :waiting_producers=
    
    attr_accessor :waiting_consumers
    alias_method :attr_waiting_consumers, :waiting_consumers
    undef_method :waiting_consumers
    alias_method :attr_waiting_consumers=, :waiting_consumers=
    undef_method :waiting_consumers=
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Save the state to a stream (that is, serialize it).
    # 
    # @param s the stream
    def write_object(s)
      fair = @transferer.is_a?(TransferQueue)
      if (fair)
        @qlock = ReentrantLock.new(true)
        @waiting_producers = FifoWaitQueue.new
        @waiting_consumers = FifoWaitQueue.new
      else
        @qlock = ReentrantLock.new
        @waiting_producers = LifoWaitQueue.new
        @waiting_consumers = LifoWaitQueue.new
      end
      s.default_write_object
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    def read_object(s)
      s.default_read_object
      if (@waiting_producers.is_a?(FifoWaitQueue))
        @transferer = TransferQueue.new
      else
        @transferer = TransferStack.new
      end
    end
    
    private
    alias_method :initialize__synchronous_queue, :initialize
  end
  
end

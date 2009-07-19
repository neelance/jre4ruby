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
  module LockSupportImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util::Concurrent
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Basic thread blocking primitives for creating locks and other
  # synchronization classes.
  # 
  # <p>This class associates, with each thread that uses it, a permit
  # (in the sense of the {@link java.util.concurrent.Semaphore
  # Semaphore} class). A call to {@code park} will return immediately
  # if the permit is available, consuming it in the process; otherwise
  # it <em>may</em> block.  A call to {@code unpark} makes the permit
  # available, if it was not already available. (Unlike with Semaphores
  # though, permits do not accumulate. There is at most one.)
  # 
  # <p>Methods {@code park} and {@code unpark} provide efficient
  # means of blocking and unblocking threads that do not encounter the
  # problems that cause the deprecated methods {@code Thread.suspend}
  # and {@code Thread.resume} to be unusable for such purposes: Races
  # between one thread invoking {@code park} and another thread trying
  # to {@code unpark} it will preserve liveness, due to the
  # permit. Additionally, {@code park} will return if the caller's
  # thread was interrupted, and timeout versions are supported. The
  # {@code park} method may also return at any other time, for "no
  # reason", so in general must be invoked within a loop that rechecks
  # conditions upon return. In this sense {@code park} serves as an
  # optimization of a "busy wait" that does not waste as much time
  # spinning, but must be paired with an {@code unpark} to be
  # effective.
  # 
  # <p>The three forms of {@code park} each also support a
  # {@code blocker} object parameter. This object is recorded while
  # the thread is blocked to permit monitoring and diagnostic tools to
  # identify the reasons that threads are blocked. (Such tools may
  # access blockers using method {@link #getBlocker}.) The use of these
  # forms rather than the original forms without this parameter is
  # strongly encouraged. The normal argument to supply as a
  # {@code blocker} within a lock implementation is {@code this}.
  # 
  # <p>These methods are designed to be used as tools for creating
  # higher-level synchronization utilities, and are not in themselves
  # useful for most concurrency control applications.  The {@code park}
  # method is designed for use only in constructions of the form:
  # <pre>while (!canProceed()) { ... LockSupport.park(this); }</pre>
  # where neither {@code canProceed} nor any other actions prior to the
  # call to {@code park} entail locking or blocking.  Because only one
  # permit is associated with each thread, any intermediary uses of
  # {@code park} could interfere with its intended effects.
  # 
  # <p><b>Sample Usage.</b> Here is a sketch of a first-in-first-out
  # non-reentrant lock class:
  # <pre>{@code
  # class FIFOMutex {
  # private final AtomicBoolean locked = new AtomicBoolean(false);
  # private final Queue<Thread> waiters
  # = new ConcurrentLinkedQueue<Thread>();
  # 
  # public void lock() {
  # boolean wasInterrupted = false;
  # Thread current = Thread.currentThread();
  # waiters.add(current);
  # 
  # // Block while not first in queue or cannot acquire lock
  # while (waiters.peek() != current ||
  # !locked.compareAndSet(false, true)) {
  # LockSupport.park(this);
  # if (Thread.interrupted()) // ignore interrupts while waiting
  # wasInterrupted = true;
  # }
  # 
  # waiters.remove();
  # if (wasInterrupted)          // reassert interrupt status on exit
  # current.interrupt();
  # }
  # 
  # public void unlock() {
  # locked.set(false);
  # LockSupport.unpark(waiters.peek());
  # }
  # }}</pre>
  class LockSupport 
    include_class_members LockSupportImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # Cannot be instantiated.
      # Hotspot implementation via intrinsics API
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :ParkBlockerOffset, UnsafeInstance.object_field_offset(Java::Lang::JavaThread.class.get_declared_field("parkBlocker"))
        rescue Exception => ex
          raise JavaError.new(ex)
        end
      end
      
      typesig { [JavaThread, Object] }
      def set_blocker(t, arg)
        # Even though volatile, hotspot doesn't need a write barrier here.
        UnsafeInstance.put_object(t, ParkBlockerOffset, arg)
      end
      
      typesig { [JavaThread] }
      # Makes available the permit for the given thread, if it
      # was not already available.  If the thread was blocked on
      # {@code park} then it will unblock.  Otherwise, its next call
      # to {@code park} is guaranteed not to block. This operation
      # is not guaranteed to have any effect at all if the given
      # thread has not been started.
      # 
      # @param thread the thread to unpark, or {@code null}, in which case
      # this operation has no effect
      def unpark(thread)
        if (!(thread).nil?)
          UnsafeInstance.unpark(thread)
        end
      end
      
      typesig { [Object] }
      # Disables the current thread for thread scheduling purposes unless the
      # permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call returns
      # immediately; otherwise
      # the current thread becomes disabled for thread scheduling
      # purposes and lies dormant until one of three things happens:
      # 
      # <ul>
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts}
      # the current thread; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread upon return.
      # 
      # @param blocker the synchronization object responsible for this
      # thread parking
      # @since 1.6
      def park(blocker)
        t = JavaThread.current_thread
        set_blocker(t, blocker)
        UnsafeInstance.park(false, 0)
        set_blocker(t, nil)
      end
      
      typesig { [Object, ::Java::Long] }
      # Disables the current thread for thread scheduling purposes, for up to
      # the specified waiting time, unless the permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call
      # returns immediately; otherwise the current thread becomes disabled
      # for thread scheduling purposes and lies dormant until one of four
      # things happens:
      # 
      # <ul>
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts} the current
      # thread; or
      # 
      # <li>The specified waiting time elapses; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread, or the elapsed time
      # upon return.
      # 
      # @param blocker the synchronization object responsible for this
      # thread parking
      # @param nanos the maximum number of nanoseconds to wait
      # @since 1.6
      def park_nanos(blocker, nanos)
        if (nanos > 0)
          t = JavaThread.current_thread
          set_blocker(t, blocker)
          UnsafeInstance.park(false, nanos)
          set_blocker(t, nil)
        end
      end
      
      typesig { [Object, ::Java::Long] }
      # Disables the current thread for thread scheduling purposes, until
      # the specified deadline, unless the permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call
      # returns immediately; otherwise the current thread becomes disabled
      # for thread scheduling purposes and lies dormant until one of four
      # things happens:
      # 
      # <ul>
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts} the
      # current thread; or
      # 
      # <li>The specified deadline passes; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread, or the current time
      # upon return.
      # 
      # @param blocker the synchronization object responsible for this
      # thread parking
      # @param deadline the absolute time, in milliseconds from the Epoch,
      # to wait until
      # @since 1.6
      def park_until(blocker, deadline)
        t = JavaThread.current_thread
        set_blocker(t, blocker)
        UnsafeInstance.park(true, deadline)
        set_blocker(t, nil)
      end
      
      typesig { [JavaThread] }
      # Returns the blocker object supplied to the most recent
      # invocation of a park method that has not yet unblocked, or null
      # if not blocked.  The value returned is just a momentary
      # snapshot -- the thread may have since unblocked or blocked on a
      # different blocker object.
      # 
      # @return the blocker
      # @since 1.6
      def get_blocker(t)
        return UnsafeInstance.get_object_volatile(t, ParkBlockerOffset)
      end
      
      typesig { [] }
      # Disables the current thread for thread scheduling purposes unless the
      # permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call
      # returns immediately; otherwise the current thread becomes disabled
      # for thread scheduling purposes and lies dormant until one of three
      # things happens:
      # 
      # <ul>
      # 
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts}
      # the current thread; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread upon return.
      def park
        UnsafeInstance.park(false, 0)
      end
      
      typesig { [::Java::Long] }
      # Disables the current thread for thread scheduling purposes, for up to
      # the specified waiting time, unless the permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call
      # returns immediately; otherwise the current thread becomes disabled
      # for thread scheduling purposes and lies dormant until one of four
      # things happens:
      # 
      # <ul>
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts}
      # the current thread; or
      # 
      # <li>The specified waiting time elapses; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread, or the elapsed time
      # upon return.
      # 
      # @param nanos the maximum number of nanoseconds to wait
      def park_nanos(nanos)
        if (nanos > 0)
          UnsafeInstance.park(false, nanos)
        end
      end
      
      typesig { [::Java::Long] }
      # Disables the current thread for thread scheduling purposes, until
      # the specified deadline, unless the permit is available.
      # 
      # <p>If the permit is available then it is consumed and the call
      # returns immediately; otherwise the current thread becomes disabled
      # for thread scheduling purposes and lies dormant until one of four
      # things happens:
      # 
      # <ul>
      # <li>Some other thread invokes {@link #unpark unpark} with the
      # current thread as the target; or
      # 
      # <li>Some other thread {@linkplain Thread#interrupt interrupts}
      # the current thread; or
      # 
      # <li>The specified deadline passes; or
      # 
      # <li>The call spuriously (that is, for no reason) returns.
      # </ul>
      # 
      # <p>This method does <em>not</em> report which of these caused the
      # method to return. Callers should re-check the conditions which caused
      # the thread to park in the first place. Callers may also determine,
      # for example, the interrupt status of the thread, or the current time
      # upon return.
      # 
      # @param deadline the absolute time, in milliseconds from the Epoch,
      # to wait until
      def park_until(deadline)
        UnsafeInstance.park(true, deadline)
      end
    }
    
    private
    alias_method :initialize__lock_support, :initialize
  end
  
end

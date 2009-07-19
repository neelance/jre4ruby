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
  module CyclicBarrierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
    }
  end
  
  # A synchronization aid that allows a set of threads to all wait for
  # each other to reach a common barrier point.  CyclicBarriers are
  # useful in programs involving a fixed sized party of threads that
  # must occasionally wait for each other. The barrier is called
  # <em>cyclic</em> because it can be re-used after the waiting threads
  # are released.
  # 
  # <p>A <tt>CyclicBarrier</tt> supports an optional {@link Runnable} command
  # that is run once per barrier point, after the last thread in the party
  # arrives, but before any threads are released.
  # This <em>barrier action</em> is useful
  # for updating shared-state before any of the parties continue.
  # 
  # <p><b>Sample usage:</b> Here is an example of
  # using a barrier in a parallel decomposition design:
  # <pre>
  # class Solver {
  # final int N;
  # final float[][] data;
  # final CyclicBarrier barrier;
  # 
  # class Worker implements Runnable {
  # int myRow;
  # Worker(int row) { myRow = row; }
  # public void run() {
  # while (!done()) {
  # processRow(myRow);
  # 
  # try {
  # barrier.await();
  # } catch (InterruptedException ex) {
  # return;
  # } catch (BrokenBarrierException ex) {
  # return;
  # }
  # }
  # }
  # }
  # 
  # public Solver(float[][] matrix) {
  # data = matrix;
  # N = matrix.length;
  # barrier = new CyclicBarrier(N,
  # new Runnable() {
  # public void run() {
  # mergeRows(...);
  # }
  # });
  # for (int i = 0; i < N; ++i)
  # new Thread(new Worker(i)).start();
  # 
  # waitUntilDone();
  # }
  # }
  # </pre>
  # Here, each worker thread processes a row of the matrix then waits at the
  # barrier until all rows have been processed. When all rows are processed
  # the supplied {@link Runnable} barrier action is executed and merges the
  # rows. If the merger
  # determines that a solution has been found then <tt>done()</tt> will return
  # <tt>true</tt> and each worker will terminate.
  # 
  # <p>If the barrier action does not rely on the parties being suspended when
  # it is executed, then any of the threads in the party could execute that
  # action when it is released. To facilitate this, each invocation of
  # {@link #await} returns the arrival index of that thread at the barrier.
  # You can then choose which thread should execute the barrier action, for
  # example:
  # <pre>  if (barrier.await() == 0) {
  # // log the completion of this iteration
  # }</pre>
  # 
  # <p>The <tt>CyclicBarrier</tt> uses an all-or-none breakage model
  # for failed synchronization attempts: If a thread leaves a barrier
  # point prematurely because of interruption, failure, or timeout, all
  # other threads waiting at that barrier point will also leave
  # abnormally via {@link BrokenBarrierException} (or
  # {@link InterruptedException} if they too were interrupted at about
  # the same time).
  # 
  # <p>Memory consistency effects: Actions in a thread prior to calling
  # {@code await()}
  # <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
  # actions that are part of the barrier action, which in turn
  # <i>happen-before</i> actions following a successful return from the
  # corresponding {@code await()} in other threads.
  # 
  # @since 1.5
  # @see CountDownLatch
  # 
  # @author Doug Lea
  class CyclicBarrier 
    include_class_members CyclicBarrierImports
    
    class_module.module_eval {
      # Each use of the barrier is represented as a generation instance.
      # The generation changes whenever the barrier is tripped, or
      # is reset. There can be many generations associated with threads
      # using the barrier - due to the non-deterministic way the lock
      # may be allocated to waiting threads - but only one of these
      # can be active at a time (the one to which <tt>count</tt> applies)
      # and all the rest are either broken or tripped.
      # There need not be an active generation if there has been a break
      # but no subsequent reset.
      const_set_lazy(:Generation) { Class.new do
        include_class_members CyclicBarrier
        
        attr_accessor :broken
        alias_method :attr_broken, :broken
        undef_method :broken
        alias_method :attr_broken=, :broken=
        undef_method :broken=
        
        typesig { [] }
        def initialize
          @broken = false
        end
        
        private
        alias_method :initialize__generation, :initialize
      end }
    }
    
    # The lock for guarding barrier entry
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # Condition to wait on until tripped
    attr_accessor :trip
    alias_method :attr_trip, :trip
    undef_method :trip
    alias_method :attr_trip=, :trip=
    undef_method :trip=
    
    # The number of parties
    attr_accessor :parties
    alias_method :attr_parties, :parties
    undef_method :parties
    alias_method :attr_parties=, :parties=
    undef_method :parties=
    
    # The command to run when tripped
    attr_accessor :barrier_command
    alias_method :attr_barrier_command, :barrier_command
    undef_method :barrier_command
    alias_method :attr_barrier_command=, :barrier_command=
    undef_method :barrier_command=
    
    # The current generation
    attr_accessor :generation
    alias_method :attr_generation, :generation
    undef_method :generation
    alias_method :attr_generation=, :generation=
    undef_method :generation=
    
    # Number of parties still waiting. Counts down from parties to 0
    # on each generation.  It is reset to parties on each new
    # generation or when broken.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [] }
    # Updates state on barrier trip and wakes up everyone.
    # Called only while holding lock.
    def next_generation
      # signal completion of last generation
      @trip.signal_all
      # set up next generation
      @count = @parties
      @generation = Generation.new
    end
    
    typesig { [] }
    # Sets current barrier generation as broken and wakes up everyone.
    # Called only while holding lock.
    def break_barrier
      @generation.attr_broken = true
      @count = @parties
      @trip.signal_all
    end
    
    typesig { [::Java::Boolean, ::Java::Long] }
    # Main barrier code, covering the various policies.
    def dowait(timed, nanos)
      lock = @lock
      lock.lock
      begin
        g = @generation
        if (g.attr_broken)
          raise BrokenBarrierException.new
        end
        if (JavaThread.interrupted)
          break_barrier
          raise InterruptedException.new
        end
        index = (@count -= 1)
        if ((index).equal?(0))
          # tripped
          ran_action = false
          begin
            command = @barrier_command
            if (!(command).nil?)
              command.run
            end
            ran_action = true
            next_generation
            return 0
          ensure
            if (!ran_action)
              break_barrier
            end
          end
        end
        # loop until tripped, broken, interrupted, or timed out
        loop do
          begin
            if (!timed)
              @trip.await
            else
              if (nanos > 0)
                nanos = @trip.await_nanos(nanos)
              end
            end
          rescue InterruptedException => ie
            if ((g).equal?(@generation) && !g.attr_broken)
              break_barrier
              raise ie
            else
              # We're about to finish waiting even if we had not
              # been interrupted, so this interrupt is deemed to
              # "belong" to subsequent execution.
              JavaThread.current_thread.interrupt
            end
          end
          if (g.attr_broken)
            raise BrokenBarrierException.new
          end
          if (!(g).equal?(@generation))
            return index
          end
          if (timed && nanos <= 0)
            break_barrier
            raise TimeoutException.new
          end
        end
      ensure
        lock.unlock
      end
    end
    
    typesig { [::Java::Int, Runnable] }
    # Creates a new <tt>CyclicBarrier</tt> that will trip when the
    # given number of parties (threads) are waiting upon it, and which
    # will execute the given barrier action when the barrier is tripped,
    # performed by the last thread entering the barrier.
    # 
    # @param parties the number of threads that must invoke {@link #await}
    # before the barrier is tripped
    # @param barrierAction the command to execute when the barrier is
    # tripped, or {@code null} if there is no action
    # @throws IllegalArgumentException if {@code parties} is less than 1
    def initialize(parties, barrier_action)
      @lock = ReentrantLock.new
      @trip = @lock.new_condition
      @parties = 0
      @barrier_command = nil
      @generation = Generation.new
      @count = 0
      if (parties <= 0)
        raise IllegalArgumentException.new
      end
      @parties = parties
      @count = parties
      @barrier_command = barrier_action
    end
    
    typesig { [::Java::Int] }
    # Creates a new <tt>CyclicBarrier</tt> that will trip when the
    # given number of parties (threads) are waiting upon it, and
    # does not perform a predefined action when the barrier is tripped.
    # 
    # @param parties the number of threads that must invoke {@link #await}
    # before the barrier is tripped
    # @throws IllegalArgumentException if {@code parties} is less than 1
    def initialize(parties)
      initialize__cyclic_barrier(parties, nil)
    end
    
    typesig { [] }
    # Returns the number of parties required to trip this barrier.
    # 
    # @return the number of parties required to trip this barrier
    def get_parties
      return @parties
    end
    
    typesig { [] }
    # Waits until all {@linkplain #getParties parties} have invoked
    # <tt>await</tt> on this barrier.
    # 
    # <p>If the current thread is not the last to arrive then it is
    # disabled for thread scheduling purposes and lies dormant until
    # one of the following things happens:
    # <ul>
    # <li>The last thread arrives; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # one of the other waiting threads; or
    # <li>Some other thread times out while waiting for barrier; or
    # <li>Some other thread invokes {@link #reset} on this barrier.
    # </ul>
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # 
    # <p>If the barrier is {@link #reset} while any thread is waiting,
    # or if the barrier {@linkplain #isBroken is broken} when
    # <tt>await</tt> is invoked, or while any thread is waiting, then
    # {@link BrokenBarrierException} is thrown.
    # 
    # <p>If any thread is {@linkplain Thread#interrupt interrupted} while waiting,
    # then all other waiting threads will throw
    # {@link BrokenBarrierException} and the barrier is placed in the broken
    # state.
    # 
    # <p>If the current thread is the last thread to arrive, and a
    # non-null barrier action was supplied in the constructor, then the
    # current thread runs the action before allowing the other threads to
    # continue.
    # If an exception occurs during the barrier action then that exception
    # will be propagated in the current thread and the barrier is placed in
    # the broken state.
    # 
    # @return the arrival index of the current thread, where index
    # <tt>{@link #getParties()} - 1</tt> indicates the first
    # to arrive and zero indicates the last to arrive
    # @throws InterruptedException if the current thread was interrupted
    # while waiting
    # @throws BrokenBarrierException if <em>another</em> thread was
    # interrupted or timed out while the current thread was
    # waiting, or the barrier was reset, or the barrier was
    # broken when {@code await} was called, or the barrier
    # action (if present) failed due an exception.
    def await
      begin
        return dowait(false, 0)
      rescue TimeoutException => toe
        raise JavaError.new(toe) # cannot happen;
      end
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Waits until all {@linkplain #getParties parties} have invoked
    # <tt>await</tt> on this barrier, or the specified waiting time elapses.
    # 
    # <p>If the current thread is not the last to arrive then it is
    # disabled for thread scheduling purposes and lies dormant until
    # one of the following things happens:
    # <ul>
    # <li>The last thread arrives; or
    # <li>The specified timeout elapses; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # the current thread; or
    # <li>Some other thread {@linkplain Thread#interrupt interrupts}
    # one of the other waiting threads; or
    # <li>Some other thread times out while waiting for barrier; or
    # <li>Some other thread invokes {@link #reset} on this barrier.
    # </ul>
    # 
    # <p>If the current thread:
    # <ul>
    # <li>has its interrupted status set on entry to this method; or
    # <li>is {@linkplain Thread#interrupt interrupted} while waiting
    # </ul>
    # then {@link InterruptedException} is thrown and the current thread's
    # interrupted status is cleared.
    # 
    # <p>If the specified waiting time elapses then {@link TimeoutException}
    # is thrown. If the time is less than or equal to zero, the
    # method will not wait at all.
    # 
    # <p>If the barrier is {@link #reset} while any thread is waiting,
    # or if the barrier {@linkplain #isBroken is broken} when
    # <tt>await</tt> is invoked, or while any thread is waiting, then
    # {@link BrokenBarrierException} is thrown.
    # 
    # <p>If any thread is {@linkplain Thread#interrupt interrupted} while
    # waiting, then all other waiting threads will throw {@link
    # BrokenBarrierException} and the barrier is placed in the broken
    # state.
    # 
    # <p>If the current thread is the last thread to arrive, and a
    # non-null barrier action was supplied in the constructor, then the
    # current thread runs the action before allowing the other threads to
    # continue.
    # If an exception occurs during the barrier action then that exception
    # will be propagated in the current thread and the barrier is placed in
    # the broken state.
    # 
    # @param timeout the time to wait for the barrier
    # @param unit the time unit of the timeout parameter
    # @return the arrival index of the current thread, where index
    # <tt>{@link #getParties()} - 1</tt> indicates the first
    # to arrive and zero indicates the last to arrive
    # @throws InterruptedException if the current thread was interrupted
    # while waiting
    # @throws TimeoutException if the specified timeout elapses
    # @throws BrokenBarrierException if <em>another</em> thread was
    # interrupted or timed out while the current thread was
    # waiting, or the barrier was reset, or the barrier was broken
    # when {@code await} was called, or the barrier action (if
    # present) failed due an exception
    def await(timeout, unit)
      return dowait(true, unit.to_nanos(timeout))
    end
    
    typesig { [] }
    # Queries if this barrier is in a broken state.
    # 
    # @return {@code true} if one or more parties broke out of this
    # barrier due to interruption or timeout since
    # construction or the last reset, or a barrier action
    # failed due to an exception; {@code false} otherwise.
    def is_broken
      lock_ = @lock
      lock_.lock
      begin
        return @generation.attr_broken
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Resets the barrier to its initial state.  If any parties are
    # currently waiting at the barrier, they will return with a
    # {@link BrokenBarrierException}. Note that resets <em>after</em>
    # a breakage has occurred for other reasons can be complicated to
    # carry out; threads need to re-synchronize in some other way,
    # and choose one to perform the reset.  It may be preferable to
    # instead create a new barrier for subsequent use.
    def reset
      lock_ = @lock
      lock_.lock
      begin
        break_barrier # break the current generation
        next_generation # start a new generation
      ensure
        lock_.unlock
      end
    end
    
    typesig { [] }
    # Returns the number of parties currently waiting at the barrier.
    # This method is primarily useful for debugging and assertions.
    # 
    # @return the number of parties currently blocked in {@link #await}
    def get_number_waiting
      lock_ = @lock
      lock_.lock
      begin
        return @parties - @count
      ensure
        lock_.unlock
      end
    end
    
    private
    alias_method :initialize__cyclic_barrier, :initialize
  end
  
end

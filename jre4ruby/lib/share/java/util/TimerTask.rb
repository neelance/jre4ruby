require "rjava"

# Copyright 1999-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module TimerTaskImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # A task that can be scheduled for one-time or repeated execution by a Timer.
  # 
  # @author  Josh Bloch
  # @see     Timer
  # @since   1.3
  class TimerTask 
    include_class_members TimerTaskImports
    include Runnable
    
    # This object is used to control access to the TimerTask internals.
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # The state of this task, chosen from the constants below.
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    class_module.module_eval {
      # This task has not yet been scheduled.
      const_set_lazy(:VIRGIN) { 0 }
      const_attr_reader  :VIRGIN
      
      # This task is scheduled for execution.  If it is a non-repeating task,
      # it has not yet been executed.
      const_set_lazy(:SCHEDULED) { 1 }
      const_attr_reader  :SCHEDULED
      
      # This non-repeating task has already executed (or is currently
      # executing) and has not been cancelled.
      const_set_lazy(:EXECUTED) { 2 }
      const_attr_reader  :EXECUTED
      
      # This task has been cancelled (with a call to TimerTask.cancel).
      const_set_lazy(:CANCELLED) { 3 }
      const_attr_reader  :CANCELLED
    }
    
    # Next execution time for this task in the format returned by
    # System.currentTimeMillis, assuming this task is scheduled for execution.
    # For repeating tasks, this field is updated prior to each task execution.
    attr_accessor :next_execution_time
    alias_method :attr_next_execution_time, :next_execution_time
    undef_method :next_execution_time
    alias_method :attr_next_execution_time=, :next_execution_time=
    undef_method :next_execution_time=
    
    # Period in milliseconds for repeating tasks.  A positive value indicates
    # fixed-rate execution.  A negative value indicates fixed-delay execution.
    # A value of 0 indicates a non-repeating task.
    attr_accessor :period
    alias_method :attr_period, :period
    undef_method :period
    alias_method :attr_period=, :period=
    undef_method :period=
    
    typesig { [] }
    # Creates a new timer task.
    def initialize
      @lock = Object.new
      @state = VIRGIN
      @next_execution_time = 0
      @period = 0
    end
    
    typesig { [] }
    # The action to be performed by this timer task.
    def run
      raise NotImplementedError
    end
    
    typesig { [] }
    # Cancels this timer task.  If the task has been scheduled for one-time
    # execution and has not yet run, or has not yet been scheduled, it will
    # never run.  If the task has been scheduled for repeated execution, it
    # will never run again.  (If the task is running when this call occurs,
    # the task will run to completion, but will never run again.)
    # 
    # <p>Note that calling this method from within the <tt>run</tt> method of
    # a repeating timer task absolutely guarantees that the timer task will
    # not run again.
    # 
    # <p>This method may be called repeatedly; the second and subsequent
    # calls have no effect.
    # 
    # @return true if this task is scheduled for one-time execution and has
    # not yet run, or this task is scheduled for repeated execution.
    # Returns false if the task was scheduled for one-time execution
    # and has already run, or if the task was never scheduled, or if
    # the task was already cancelled.  (Loosely speaking, this method
    # returns <tt>true</tt> if it prevents one or more scheduled
    # executions from taking place.)
    def cancel
      synchronized((@lock)) do
        result = ((@state).equal?(SCHEDULED))
        @state = CANCELLED
        return result
      end
    end
    
    typesig { [] }
    # Returns the <i>scheduled</i> execution time of the most recent
    # <i>actual</i> execution of this task.  (If this method is invoked
    # while task execution is in progress, the return value is the scheduled
    # execution time of the ongoing task execution.)
    # 
    # <p>This method is typically invoked from within a task's run method, to
    # determine whether the current execution of the task is sufficiently
    # timely to warrant performing the scheduled activity:
    # <pre>
    # public void run() {
    # if (System.currentTimeMillis() - scheduledExecutionTime() >=
    # MAX_TARDINESS)
    # return;  // Too late; skip this execution.
    # // Perform the task
    # }
    # </pre>
    # This method is typically <i>not</i> used in conjunction with
    # <i>fixed-delay execution</i> repeating tasks, as their scheduled
    # execution times are allowed to drift over time, and so are not terribly
    # significant.
    # 
    # @return the time at which the most recent execution of this task was
    # scheduled to occur, in the format returned by Date.getTime().
    # The return value is undefined if the task has yet to commence
    # its first execution.
    # @see Date#getTime()
    def scheduled_execution_time
      synchronized((@lock)) do
        return (@period < 0 ? @next_execution_time + @period : @next_execution_time - @period)
      end
    end
    
    private
    alias_method :initialize__timer_task, :initialize
  end
  
end

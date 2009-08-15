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
  module TimeUnitImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
    }
  end
  
  # A <tt>TimeUnit</tt> represents time durations at a given unit of
  # granularity and provides utility methods to convert across units,
  # and to perform timing and delay operations in these units.  A
  # <tt>TimeUnit</tt> does not maintain time information, but only
  # helps organize and use time representations that may be maintained
  # separately across various contexts.  A nanosecond is defined as one
  # thousandth of a microsecond, a microsecond as one thousandth of a
  # millisecond, a millisecond as one thousandth of a second, a minute
  # as sixty seconds, an hour as sixty minutes, and a day as twenty four
  # hours.
  # 
  # <p>A <tt>TimeUnit</tt> is mainly used to inform time-based methods
  # how a given timing parameter should be interpreted. For example,
  # the following code will timeout in 50 milliseconds if the {@link
  # java.util.concurrent.locks.Lock lock} is not available:
  # 
  # <pre>  Lock lock = ...;
  # if ( lock.tryLock(50L, TimeUnit.MILLISECONDS) ) ...
  # </pre>
  # while this code will timeout in 50 seconds:
  # <pre>
  # Lock lock = ...;
  # if ( lock.tryLock(50L, TimeUnit.SECONDS) ) ...
  # </pre>
  # 
  # Note however, that there is no guarantee that a particular timeout
  # implementation will be able to notice the passage of time at the
  # same granularity as the given <tt>TimeUnit</tt>.
  # 
  # @since 1.5
  # @author Doug Lea
  class TimeUnit 
    include_class_members TimeUnitImports
    
    class_module.module_eval {
      const_set_lazy(:NANOSECONDS) { nanoseconds_class.new.set_value_name("NANOSECONDS") }
      const_attr_reader  :NANOSECONDS
      
      const_set_lazy(:MICROSECONDS) { microseconds_class.new.set_value_name("MICROSECONDS") }
      const_attr_reader  :MICROSECONDS
      
      const_set_lazy(:MILLISECONDS) { milliseconds_class.new.set_value_name("MILLISECONDS") }
      const_attr_reader  :MILLISECONDS
      
      const_set_lazy(:SECONDS) { seconds_class.new.set_value_name("SECONDS") }
      const_attr_reader  :SECONDS
      
      const_set_lazy(:MINUTES) { minutes_class.new.set_value_name("MINUTES") }
      const_attr_reader  :MINUTES
      
      const_set_lazy(:HOURS) { hours_class.new.set_value_name("HOURS") }
      const_attr_reader  :HOURS
      
      const_set_lazy(:DAYS) { days_class.new.set_value_name("DAYS") }
      const_attr_reader  :DAYS
      
      # Handy constants for conversion methods
      const_set_lazy(:C0) { 1 }
      const_attr_reader  :C0
      
      const_set_lazy(:C1) { C0 * 1000 }
      const_attr_reader  :C1
      
      const_set_lazy(:C2) { C1 * 1000 }
      const_attr_reader  :C2
      
      const_set_lazy(:C3) { C2 * 1000 }
      const_attr_reader  :C3
      
      const_set_lazy(:C4) { C3 * 60 }
      const_attr_reader  :C4
      
      const_set_lazy(:C5) { C4 * 60 }
      const_attr_reader  :C5
      
      const_set_lazy(:C6) { C5 * 24 }
      const_attr_reader  :C6
      
      const_set_lazy(:MAX) { Long::MAX_VALUE }
      const_attr_reader  :MAX
      
      typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
      # Scale d by m, checking for overflow.
      # This has a short name to make above code more readable.
      def x(d, m, over)
        if (d > over)
          return Long::MAX_VALUE
        end
        if (d < -over)
          return Long::MIN_VALUE
        end
        return d * m
      end
    }
    
    typesig { [::Java::Long, TimeUnit] }
    # To maintain full signature compatibility with 1.5, and to improve the
    # clarity of the generated javadoc (see 6287639: Abstract methods in
    # enum classes should not be listed as abstract), method convert
    # etc. are not declared abstract but otherwise act as abstract methods.
    # 
    # Convert the given time duration in the given unit to this
    # unit.  Conversions from finer to coarser granularities
    # truncate, so lose precision. For example converting
    # <tt>999</tt> milliseconds to seconds results in
    # <tt>0</tt>. Conversions from coarser to finer granularities
    # with arguments that would numerically overflow saturate to
    # <tt>Long.MIN_VALUE</tt> if negative or <tt>Long.MAX_VALUE</tt>
    # if positive.
    # 
    # <p>For example, to convert 10 minutes to milliseconds, use:
    # <tt>TimeUnit.MILLISECONDS.convert(10L, TimeUnit.MINUTES)</tt>
    # 
    # @param sourceDuration the time duration in the given <tt>sourceUnit</tt>
    # @param sourceUnit the unit of the <tt>sourceDuration</tt> argument
    # @return the converted duration in this unit,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    def convert(source_duration, source_unit)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>NANOSECONDS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    def to_nanos(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>MICROSECONDS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    def to_micros(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>MILLISECONDS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    def to_millis(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>SECONDS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    def to_seconds(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>MINUTES.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    # @since 1.6
    def to_minutes(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>HOURS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration,
    # or <tt>Long.MIN_VALUE</tt> if conversion would negatively
    # overflow, or <tt>Long.MAX_VALUE</tt> if it would positively overflow.
    # @see #convert
    # @since 1.6
    def to_hours(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long] }
    # Equivalent to <tt>DAYS.convert(duration, this)</tt>.
    # @param duration the duration
    # @return the converted duration
    # @see #convert
    # @since 1.6
    def to_days(duration)
      raise AbstractMethodError.new
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Utility to compute the excess-nanosecond argument to wait,
    # sleep, join.
    # @param d the duration
    # @param m the number of milliseconds
    # @return the number of nanoseconds
    def excess_nanos(d, m)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Long] }
    # Performs a timed <tt>Object.wait</tt> using this time unit.
    # This is a convenience method that converts timeout arguments
    # into the form required by the <tt>Object.wait</tt> method.
    # 
    # <p>For example, you could implement a blocking <tt>poll</tt>
    # method (see {@link BlockingQueue#poll BlockingQueue.poll})
    # using:
    # 
    # <pre>  public synchronized Object poll(long timeout, TimeUnit unit) throws InterruptedException {
    # while (empty) {
    # unit.timedWait(this, timeout);
    # ...
    # }
    # }</pre>
    # 
    # @param obj the object to wait on
    # @param timeout the maximum time to wait. If less than
    # or equal to zero, do not wait at all.
    # @throws InterruptedException if interrupted while waiting.
    # @see Object#wait(long, int)
    def timed_wait(obj, timeout)
      if (timeout > 0)
        ms = to_millis(timeout)
        ns = excess_nanos(timeout, ms)
        obj.wait(ms, ns)
      end
    end
    
    typesig { [JavaThread, ::Java::Long] }
    # Performs a timed <tt>Thread.join</tt> using this time unit.
    # This is a convenience method that converts time arguments into the
    # form required by the <tt>Thread.join</tt> method.
    # @param thread the thread to wait for
    # @param timeout the maximum time to wait. If less than
    # or equal to zero, do not wait at all.
    # @throws InterruptedException if interrupted while waiting.
    # @see Thread#join(long, int)
    def timed_join(thread, timeout)
      if (timeout > 0)
        ms = to_millis(timeout)
        ns = excess_nanos(timeout, ms)
        thread.join(ms, ns)
      end
    end
    
    typesig { [::Java::Long] }
    # Performs a <tt>Thread.sleep</tt> using this unit.
    # This is a convenience method that converts time arguments into the
    # form required by the <tt>Thread.sleep</tt> method.
    # @param timeout the minimum time to sleep. If less than
    # or equal to zero, do not sleep at all.
    # @throws InterruptedException if interrupted while sleeping.
    # @see Thread#sleep
    def sleep(timeout)
      if (timeout > 0)
        ms = to_millis(timeout)
        ns = excess_nanos(timeout, ms)
        JavaThread.sleep(ms, ns)
      end
    end
    
    typesig { [String] }
    def set_value_name(name)
      @value_name = name
      self
    end
    
    typesig { [] }
    def to_s
      @value_name
    end
    
    class_module.module_eval {
      typesig { [] }
      def values
        [NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS]
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__time_unit, :initialize
  end
  
end

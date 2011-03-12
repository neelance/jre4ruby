require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module PerformanceLoggerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :FileWriter
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :OutputStreamWriter
      include_const ::Java::Io, :Writer
    }
  end
  
  # This class is intended to be a central place for the jdk to
  # log timing events of interest.  There is pre-defined event
  # of startTime, as well as a general
  # mechanism of setting aribtrary times in an array.
  # All unreserved times in the array can be used by callers
  # in application-defined situations.  The caller is responsible
  # for setting and getting all times and for doing whatever
  # analysis is interesting; this class is merely a central container
  # for those timing values.
  # Note that, due to the variables in this class being static,
  # use of particular time values by multiple applets will cause
  # confusing results.  For example, if plugin runs two applets
  # simultaneously, the initTime for those applets will collide
  # and the results may be undefined.
  # <P>
  # To automatically track startup performance in an app or applet,
  # use the command-line parameter sun.perflog as follows:<BR>
  #     -Dsun.perflog[=file:<filename>]
  # <BR>
  # where simply using the parameter with no value will enable output
  # to the console and a value of "file:<filename>" will cause
  # that given filename to be created and used for all output.
  # <P>
  # By default, times are measured using System.currentTimeMillis().  To use
  # System.nanoTime() instead, add the command-line parameter:<BR>
  #     -Dsun.perflog.nano=true
  # <BR>
  # <P>
  # <B>Warning: Use at your own risk!</B>
  # This class is intended for internal testing
  # purposes only and may be removed at any time.  More
  # permanent monitoring and profiling APIs are expected to be
  # developed for future releases and this class will cease to
  # exist once those APIs are in place.
  # @author Chet Haase
  class PerformanceLogger 
    include_class_members PerformanceLoggerImports
    
    class_module.module_eval {
      # Timing values of global interest
      const_set_lazy(:START_INDEX) { 0 }
      const_attr_reader  :START_INDEX
      
      # VM start
      const_set_lazy(:LAST_RESERVED) { START_INDEX }
      const_attr_reader  :LAST_RESERVED
      
      
      def perf_logging_on
        defined?(@@perf_logging_on) ? @@perf_logging_on : @@perf_logging_on= false
      end
      alias_method :attr_perf_logging_on, :perf_logging_on
      
      def perf_logging_on=(value)
        @@perf_logging_on = value
      end
      alias_method :attr_perf_logging_on=, :perf_logging_on=
      
      
      def use_nano_time
        defined?(@@use_nano_time) ? @@use_nano_time : @@use_nano_time= false
      end
      alias_method :attr_use_nano_time, :use_nano_time
      
      def use_nano_time=(value)
        @@use_nano_time = value
      end
      alias_method :attr_use_nano_time=, :use_nano_time=
      
      
      def times
        defined?(@@times) ? @@times : @@times= nil
      end
      alias_method :attr_times, :times
      
      def times=(value)
        @@times = value
      end
      alias_method :attr_times=, :times=
      
      
      def log_file_name
        defined?(@@log_file_name) ? @@log_file_name : @@log_file_name= nil
      end
      alias_method :attr_log_file_name, :log_file_name
      
      def log_file_name=(value)
        @@log_file_name = value
      end
      alias_method :attr_log_file_name=, :log_file_name=
      
      
      def log_writer
        defined?(@@log_writer) ? @@log_writer : @@log_writer= nil
      end
      alias_method :attr_log_writer, :log_writer
      
      def log_writer=(value)
        @@log_writer = value
      end
      alias_method :attr_log_writer=, :log_writer=
      
      when_class_loaded do
        perf_logging_prop = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("sun.perflog"))
        if (!(perf_logging_prop).nil?)
          self.attr_perf_logging_on = true
          # Check if we should use nanoTime
          perf_nano_prop = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("sun.perflog.nano"))
          if (!(perf_nano_prop).nil?)
            self.attr_use_nano_time = true
          end
          # Now, figure out what the user wants to do with the data
          if (perf_logging_prop.region_matches(true, 0, "file:", 0, 5))
            self.attr_log_file_name = RJava.cast_to_string(perf_logging_prop.substring(5))
          end
          if (!(self.attr_log_file_name).nil?)
            if ((self.attr_log_writer).nil?)
              Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
                local_class_in PerformanceLogger
                include_class_members PerformanceLogger
                include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  begin
                    log_file = self.class::JavaFile.new(self.attr_log_file_name)
                    log_file.create_new_file
                    self.attr_log_writer = self.class::FileWriter.new(log_file)
                  rescue self.class::JavaException => e
                    System.out.println(RJava.cast_to_string(e) + ": Creating logfile " + self.attr_log_file_name + ".  Log to console")
                  end
                  return nil
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            end
          end
          if ((self.attr_log_writer).nil?)
            self.attr_log_writer = OutputStreamWriter.new(System.out)
          end
        end
        self.attr_times = Vector.new(10)
        # Reserve predefined slots
        i = 0
        while i <= LAST_RESERVED
          self.attr_times.add(TimeData.new("Time " + RJava.cast_to_string(i) + " not set", 0))
          (i += 1)
        end
      end
      
      typesig { [] }
      # Returns status of whether logging is enabled or not.  This is
      # provided as a convenience method so that users do not have to
      # perform the same GetPropertyAction check as above to determine whether
      # to enable performance logging.
      def logging_enabled
        return self.attr_perf_logging_on
      end
      
      # Internal class used to store time/message data together.
      const_set_lazy(:TimeData) { Class.new do
        include_class_members PerformanceLogger
        
        attr_accessor :message
        alias_method :attr_message, :message
        undef_method :message
        alias_method :attr_message=, :message=
        undef_method :message=
        
        attr_accessor :time
        alias_method :attr_time, :time
        undef_method :time
        alias_method :attr_time=, :time=
        undef_method :time=
        
        typesig { [String, ::Java::Long] }
        def initialize(message, time)
          @message = nil
          @time = 0
          @message = message
          @time = time
        end
        
        typesig { [] }
        def get_message
          return @message
        end
        
        typesig { [] }
        def get_time
          return @time
        end
        
        private
        alias_method :initialize__time_data, :initialize
      end }
      
      typesig { [] }
      # Return the current time, in millis or nanos as appropriate
      def get_current_time
        if (self.attr_use_nano_time)
          return System.nano_time
        else
          return System.current_time_millis
        end
      end
      
      typesig { [String] }
      # Sets the start time.  Ideally, this is the earliest time available
      # during the startup of a Java applet or application.  This time is
      # later used to analyze the difference between the initial startup
      # time and other events in the system (such as an applet's init time).
      def set_start_time(message)
        if (logging_enabled)
          now_time = get_current_time
          set_start_time(message, now_time)
        end
      end
      
      typesig { [String, ::Java::Long] }
      # Sets the start time.
      # This version of the method is
      # given the time to log, instead of expecting this method to
      # get the time itself.  This is done in case the time was
      # recorded much earlier than this method was called.
      def set_start_time(message, time)
        if (logging_enabled)
          self.attr_times.set(START_INDEX, TimeData.new(message, time))
        end
      end
      
      typesig { [] }
      # Gets the start time, which should be the time when
      # the java process started, prior to the VM actually being
      # loaded.
      def get_start_time
        if (logging_enabled)
          return (self.attr_times.get(START_INDEX)).get_time
        else
          return 0
        end
      end
      
      typesig { [String] }
      # Sets the value of a given time and returns the index of the
      # slot that that time was stored in.
      def set_time(message)
        if (logging_enabled)
          now_time = get_current_time
          return set_time(message, now_time)
        else
          return 0
        end
      end
      
      typesig { [String, ::Java::Long] }
      # Sets the value of a given time and returns the index of the
      # slot that that time was stored in.
      # This version of the method is
      # given the time to log, instead of expecting this method to
      # get the time itself.  This is done in case the time was
      # recorded much earlier than this method was called.
      def set_time(message, time)
        if (logging_enabled)
          # times is already synchronized, but we need to ensure that
          # the size used in times.set() is the same used when returning
          # the index of that operation.
          synchronized((self.attr_times)) do
            self.attr_times.add(TimeData.new(message, time))
            return (self.attr_times.size - 1)
          end
        else
          return 0
        end
      end
      
      typesig { [::Java::Int] }
      # Returns time at given index.
      def get_time_at_index(index)
        if (logging_enabled)
          return (self.attr_times.get(index)).get_time
        else
          return 0
        end
      end
      
      typesig { [::Java::Int] }
      # Returns message at given index.
      def get_message_at_index(index)
        if (logging_enabled)
          return (self.attr_times.get(index)).get_message
        else
          return nil
        end
      end
      
      typesig { [Writer] }
      # Outputs all data to parameter-specified Writer object
      def output_log(writer)
        if (logging_enabled)
          begin
            synchronized((self.attr_times)) do
              i = 0
              while i < self.attr_times.size
                td = self.attr_times.get(i)
                if (!(td).nil?)
                  writer.write(RJava.cast_to_string(i) + " " + RJava.cast_to_string(td.get_message) + ": " + RJava.cast_to_string(td.get_time) + "\n")
                end
                (i += 1)
              end
            end
            writer.flush
          rescue JavaException => e
            System.out.println(RJava.cast_to_string(e) + ": Writing performance log to " + RJava.cast_to_string(writer))
          end
        end
      end
      
      typesig { [] }
      # Outputs all data to whatever location the user specified
      # via sun.perflog command-line parameter.
      def output_log
        output_log(self.attr_log_writer)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__performance_logger, :initialize
  end
  
end

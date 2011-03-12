require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Logging
  module LogRecordImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Util
      include ::Java::Io
    }
  end
  
  # LogRecord objects are used to pass logging requests between
  # the logging framework and individual log Handlers.
  # <p>
  # When a LogRecord is passed into the logging framework it
  # logically belongs to the framework and should no longer be
  # used or updated by the client application.
  # <p>
  # Note that if the client application has not specified an
  # explicit source method name and source class name, then the
  # LogRecord class will infer them automatically when they are
  # first accessed (due to a call on getSourceMethodName or
  # getSourceClassName) by analyzing the call stack.  Therefore,
  # if a logging Handler wants to pass off a LogRecord to another
  # thread, or to transmit it over RMI, and if it wishes to subsequently
  # obtain method name or class name information it should call
  # one of getSourceClassName or getSourceMethodName to force
  # the values to be filled in.
  # <p>
  # <b> Serialization notes:</b>
  # <ul>
  # <li>The LogRecord class is serializable.
  # 
  # <li> Because objects in the parameters array may not be serializable,
  # during serialization all objects in the parameters array are
  # written as the corresponding Strings (using Object.toString).
  # 
  # <li> The ResourceBundle is not transmitted as part of the serialized
  # form, but the resource bundle name is, and the recipient object's
  # readObject method will attempt to locate a suitable resource bundle.
  # 
  # </ul>
  # 
  # @since 1.4
  class LogRecord 
    include_class_members LogRecordImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      
      def global_sequence_number
        defined?(@@global_sequence_number) ? @@global_sequence_number : @@global_sequence_number= 0
      end
      alias_method :attr_global_sequence_number, :global_sequence_number
      
      def global_sequence_number=(value)
        @@global_sequence_number = value
      end
      alias_method :attr_global_sequence_number=, :global_sequence_number=
      
      
      def next_thread_id
        defined?(@@next_thread_id) ? @@next_thread_id : @@next_thread_id= 10
      end
      alias_method :attr_next_thread_id, :next_thread_id
      
      def next_thread_id=(value)
        @@next_thread_id = value
      end
      alias_method :attr_next_thread_id=, :next_thread_id=
      
      
      def thread_ids
        defined?(@@thread_ids) ? @@thread_ids : @@thread_ids= ThreadLocal.new
      end
      alias_method :attr_thread_ids, :thread_ids
      
      def thread_ids=(value)
        @@thread_ids = value
      end
      alias_method :attr_thread_ids=, :thread_ids=
    }
    
    # @serial Logging message level
    attr_accessor :level
    alias_method :attr_level, :level
    undef_method :level
    alias_method :attr_level=, :level=
    undef_method :level=
    
    # @serial Sequence number
    attr_accessor :sequence_number
    alias_method :attr_sequence_number, :sequence_number
    undef_method :sequence_number
    alias_method :attr_sequence_number=, :sequence_number=
    undef_method :sequence_number=
    
    # @serial Class that issued logging call
    attr_accessor :source_class_name
    alias_method :attr_source_class_name, :source_class_name
    undef_method :source_class_name
    alias_method :attr_source_class_name=, :source_class_name=
    undef_method :source_class_name=
    
    # @serial Method that issued logging call
    attr_accessor :source_method_name
    alias_method :attr_source_method_name, :source_method_name
    undef_method :source_method_name
    alias_method :attr_source_method_name=, :source_method_name=
    undef_method :source_method_name=
    
    # @serial Non-localized raw message text
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # @serial Thread ID for thread that issued logging call.
    attr_accessor :thread_id
    alias_method :attr_thread_id, :thread_id
    undef_method :thread_id
    alias_method :attr_thread_id=, :thread_id=
    undef_method :thread_id=
    
    # @serial Event time in milliseconds since 1970
    attr_accessor :millis
    alias_method :attr_millis, :millis
    undef_method :millis
    alias_method :attr_millis=, :millis=
    undef_method :millis=
    
    # @serial The Throwable (if any) associated with log message
    attr_accessor :thrown
    alias_method :attr_thrown, :thrown
    undef_method :thrown
    alias_method :attr_thrown=, :thrown=
    undef_method :thrown=
    
    # @serial Name of the source Logger.
    attr_accessor :logger_name
    alias_method :attr_logger_name, :logger_name
    undef_method :logger_name
    alias_method :attr_logger_name=, :logger_name=
    undef_method :logger_name=
    
    # @serial Resource bundle name to localized log message.
    attr_accessor :resource_bundle_name
    alias_method :attr_resource_bundle_name, :resource_bundle_name
    undef_method :resource_bundle_name
    alias_method :attr_resource_bundle_name=, :resource_bundle_name=
    undef_method :resource_bundle_name=
    
    attr_accessor :need_to_infer_caller
    alias_method :attr_need_to_infer_caller, :need_to_infer_caller
    undef_method :need_to_infer_caller
    alias_method :attr_need_to_infer_caller=, :need_to_infer_caller=
    undef_method :need_to_infer_caller=
    
    attr_accessor :parameters
    alias_method :attr_parameters, :parameters
    undef_method :parameters
    alias_method :attr_parameters=, :parameters=
    undef_method :parameters=
    
    attr_accessor :resource_bundle
    alias_method :attr_resource_bundle, :resource_bundle
    undef_method :resource_bundle
    alias_method :attr_resource_bundle=, :resource_bundle=
    undef_method :resource_bundle=
    
    typesig { [Level, String] }
    # Construct a LogRecord with the given level and message values.
    # <p>
    # The sequence property will be initialized with a new unique value.
    # These sequence values are allocated in increasing order within a VM.
    # <p>
    # The millis property will be initialized to the current time.
    # <p>
    # The thread ID property will be initialized with a unique ID for
    # the current thread.
    # <p>
    # All other properties will be initialized to "null".
    # 
    # @param level  a logging level value
    # @param msg  the raw non-localized logging message (may be null)
    def initialize(level, msg)
      @level = nil
      @sequence_number = 0
      @source_class_name = nil
      @source_method_name = nil
      @message = nil
      @thread_id = 0
      @millis = 0
      @thrown = nil
      @logger_name = nil
      @resource_bundle_name = nil
      @need_to_infer_caller = false
      @parameters = nil
      @resource_bundle = nil
      # Make sure level isn't null, by calling random method.
      level.get_class
      @level = level
      @message = msg
      # Assign a thread ID and a unique sequence number.
      synchronized((LogRecord)) do
        @sequence_number = ((self.attr_global_sequence_number += 1) - 1)
        id = self.attr_thread_ids.get
        if ((id).nil?)
          id = ((self.attr_next_thread_id += 1) - 1)
          self.attr_thread_ids.set(id)
        end
        @thread_id = id.int_value
      end
      @millis = System.current_time_millis
      @need_to_infer_caller = true
    end
    
    typesig { [] }
    # Get the source Logger name's
    # 
    # @return source logger name (may be null)
    def get_logger_name
      return @logger_name
    end
    
    typesig { [String] }
    # Set the source Logger name.
    # 
    # @param name   the source logger name (may be null)
    def set_logger_name(name)
      @logger_name = name
    end
    
    typesig { [] }
    # Get the localization resource bundle
    # <p>
    # This is the ResourceBundle that should be used to localize
    # the message string before formatting it.  The result may
    # be null if the message is not localizable, or if no suitable
    # ResourceBundle is available.
    def get_resource_bundle
      return @resource_bundle
    end
    
    typesig { [ResourceBundle] }
    # Set the localization resource bundle.
    # 
    # @param bundle  localization bundle (may be null)
    def set_resource_bundle(bundle)
      @resource_bundle = bundle
    end
    
    typesig { [] }
    # Get the localization resource bundle name
    # <p>
    # This is the name for the ResourceBundle that should be
    # used to localize the message string before formatting it.
    # The result may be null if the message is not localizable.
    def get_resource_bundle_name
      return @resource_bundle_name
    end
    
    typesig { [String] }
    # Set the localization resource bundle name.
    # 
    # @param name  localization bundle name (may be null)
    def set_resource_bundle_name(name)
      @resource_bundle_name = name
    end
    
    typesig { [] }
    # Get the logging message level, for example Level.SEVERE.
    # @return the logging message level
    def get_level
      return @level
    end
    
    typesig { [Level] }
    # Set the logging message level, for example Level.SEVERE.
    # @param level the logging message level
    def set_level(level)
      if ((level).nil?)
        raise NullPointerException.new
      end
      @level = level
    end
    
    typesig { [] }
    # Get the sequence number.
    # <p>
    # Sequence numbers are normally assigned in the LogRecord
    # constructor, which assigns unique sequence numbers to
    # each new LogRecord in increasing order.
    # @return the sequence number
    def get_sequence_number
      return @sequence_number
    end
    
    typesig { [::Java::Long] }
    # Set the sequence number.
    # <p>
    # Sequence numbers are normally assigned in the LogRecord constructor,
    # so it should not normally be necessary to use this method.
    def set_sequence_number(seq)
      @sequence_number = seq
    end
    
    typesig { [] }
    # Get the  name of the class that (allegedly) issued the logging request.
    # <p>
    # Note that this sourceClassName is not verified and may be spoofed.
    # This information may either have been provided as part of the
    # logging call, or it may have been inferred automatically by the
    # logging framework.  In the latter case, the information may only
    # be approximate and may in fact describe an earlier call on the
    # stack frame.
    # <p>
    # May be null if no information could be obtained.
    # 
    # @return the source class name
    def get_source_class_name
      if (@need_to_infer_caller)
        infer_caller
      end
      return @source_class_name
    end
    
    typesig { [String] }
    # Set the name of the class that (allegedly) issued the logging request.
    # 
    # @param sourceClassName the source class name (may be null)
    def set_source_class_name(source_class_name)
      @source_class_name = source_class_name
      @need_to_infer_caller = false
    end
    
    typesig { [] }
    # Get the  name of the method that (allegedly) issued the logging request.
    # <p>
    # Note that this sourceMethodName is not verified and may be spoofed.
    # This information may either have been provided as part of the
    # logging call, or it may have been inferred automatically by the
    # logging framework.  In the latter case, the information may only
    # be approximate and may in fact describe an earlier call on the
    # stack frame.
    # <p>
    # May be null if no information could be obtained.
    # 
    # @return the source method name
    def get_source_method_name
      if (@need_to_infer_caller)
        infer_caller
      end
      return @source_method_name
    end
    
    typesig { [String] }
    # Set the name of the method that (allegedly) issued the logging request.
    # 
    # @param sourceMethodName the source method name (may be null)
    def set_source_method_name(source_method_name)
      @source_method_name = source_method_name
      @need_to_infer_caller = false
    end
    
    typesig { [] }
    # Get the "raw" log message, before localization or formatting.
    # <p>
    # May be null, which is equivalent to the empty string "".
    # <p>
    # This message may be either the final text or a localization key.
    # <p>
    # During formatting, if the source logger has a localization
    # ResourceBundle and if that ResourceBundle has an entry for
    # this message string, then the message string is replaced
    # with the localized value.
    # 
    # @return the raw message string
    def get_message
      return @message
    end
    
    typesig { [String] }
    # Set the "raw" log message, before localization or formatting.
    # 
    # @param message the raw message string (may be null)
    def set_message(message)
      @message = message
    end
    
    typesig { [] }
    # Get the parameters to the log message.
    # 
    # @return the log message parameters.  May be null if
    #                  there are no parameters.
    def get_parameters
      return @parameters
    end
    
    typesig { [Array.typed(Object)] }
    # Set the parameters to the log message.
    # 
    # @param parameters the log message parameters. (may be null)
    def set_parameters(parameters)
      @parameters = parameters
    end
    
    typesig { [] }
    # Get an identifier for the thread where the message originated.
    # <p>
    # This is a thread identifier within the Java VM and may or
    # may not map to any operating system ID.
    # 
    # @return thread ID
    def get_thread_id
      return @thread_id
    end
    
    typesig { [::Java::Int] }
    # Set an identifier for the thread where the message originated.
    # @param threadID  the thread ID
    def set_thread_id(thread_id)
      @thread_id = thread_id
    end
    
    typesig { [] }
    # Get event time in milliseconds since 1970.
    # 
    # @return event time in millis since 1970
    def get_millis
      return @millis
    end
    
    typesig { [::Java::Long] }
    # Set event time.
    # 
    # @param millis event time in millis since 1970
    def set_millis(millis)
      @millis = millis
    end
    
    typesig { [] }
    # Get any throwable associated with the log record.
    # <p>
    # If the event involved an exception, this will be the
    # exception object. Otherwise null.
    # 
    # @return a throwable
    def get_thrown
      return @thrown
    end
    
    typesig { [JavaThrowable] }
    # Set a throwable associated with the log event.
    # 
    # @param thrown  a throwable (may be null)
    def set_thrown(thrown)
      @thrown = thrown
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5372048053134512534 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default fields, followed by a two byte version number
    # (major byte, followed by minor byte), followed by information on
    # the log record parameter array.  If there is no parameter array,
    # then -1 is written.  If there is a parameter array (possible of zero
    # length) then the array length is written as an integer, followed
    # by String values for each parameter.  If a parameter is null, then
    # a null String is written.  Otherwise the output of Object.toString()
    # is written.
    def write_object(out)
      # We have to call defaultWriteObject first.
      out.default_write_object
      # Write our version number.
      out.write_byte(1)
      out.write_byte(0)
      if ((@parameters).nil?)
        out.write_int(-1)
        return
      end
      out.write_int(@parameters.attr_length)
      # Write string values for the parameters.
      i = 0
      while i < @parameters.attr_length
        if ((@parameters[i]).nil?)
          out.write_object(nil)
        else
          out.write_object(@parameters[i].to_s)
        end
        i += 1
      end
    end
    
    typesig { [ObjectInputStream] }
    def read_object(in_)
      # We have to call defaultReadObject first.
      in_.default_read_object
      # Read version number.
      major = in_.read_byte
      minor = in_.read_byte
      if (!(major).equal?(1))
        raise IOException.new("LogRecord: bad version: " + RJava.cast_to_string(major) + "." + RJava.cast_to_string(minor))
      end
      len = in_.read_int
      if ((len).equal?(-1))
        @parameters = nil
      else
        @parameters = Array.typed(Object).new(len) { nil }
        i = 0
        while i < @parameters.attr_length
          @parameters[i] = in_.read_object
          i += 1
        end
      end
      # If necessary, try to regenerate the resource bundle.
      if (!(@resource_bundle_name).nil?)
        begin
          @resource_bundle = ResourceBundle.get_bundle(@resource_bundle_name)
        rescue MissingResourceException => ex
          # This is not a good place to throw an exception,
          # so we simply leave the resourceBundle null.
          @resource_bundle = nil
        end
      end
      @need_to_infer_caller = false
    end
    
    typesig { [] }
    # Private method to infer the caller's class and method names
    def infer_caller
      @need_to_infer_caller = false
      # Get the stack trace.
      stack = (JavaThrowable.new).get_stack_trace
      # First, search back to a method in the Logger class.
      ix = 0
      while (ix < stack.attr_length)
        frame = stack[ix]
        cname = frame.get_class_name
        if ((cname == "java.util.logging.Logger"))
          break
        end
        ix += 1
      end
      # Now search for the first frame before the "Logger" class.
      while (ix < stack.attr_length)
        frame = stack[ix]
        cname = frame.get_class_name
        if (!(cname == "java.util.logging.Logger"))
          # We've found the relevant frame.
          set_source_class_name(cname)
          set_source_method_name(frame.get_method_name)
          return
        end
        ix += 1
      end
      # We haven't found a suitable frame, so just punt.  This is
      # OK as we are only committed to making a "best effort" here.
    end
    
    private
    alias_method :initialize__log_record, :initialize
  end
  
end

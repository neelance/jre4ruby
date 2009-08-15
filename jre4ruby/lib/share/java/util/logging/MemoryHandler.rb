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
  module MemoryHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
    }
  end
  
  # <tt>Handler</tt> that buffers requests in a circular buffer in memory.
  # <p>
  # Normally this <tt>Handler</tt> simply stores incoming <tt>LogRecords</tt>
  # into its memory buffer and discards earlier records.  This buffering
  # is very cheap and avoids formatting costs.  On certain trigger
  # conditions, the <tt>MemoryHandler</tt> will push out its current buffer
  # contents to a target <tt>Handler</tt>, which will typically publish
  # them to the outside world.
  # <p>
  # There are three main models for triggering a push of the buffer:
  # <ul>
  # <li>
  # An incoming <tt>LogRecord</tt> has a type that is greater than
  # a pre-defined level, the <tt>pushLevel</tt>.
  # <li>
  # An external class calls the <tt>push</tt> method explicitly.
  # <li>
  # A subclass overrides the <tt>log</tt> method and scans each incoming
  # <tt>LogRecord</tt> and calls <tt>push</tt> if a record matches some
  # desired criteria.
  # </ul>
  # <p>
  # <b>Configuration:</b>
  # By default each <tt>MemoryHandler</tt> is initialized using the following
  # LogManager configuration properties.  If properties are not defined
  # (or have invalid values) then the specified default values are used.
  # If no default value is defined then a RuntimeException is thrown.
  # <ul>
  # <li>   java.util.logging.MemoryHandler.level
  # specifies the level for the <tt>Handler</tt>
  # (defaults to <tt>Level.ALL</tt>).
  # <li>   java.util.logging.MemoryHandler.filter
  # specifies the name of a <tt>Filter</tt> class to use
  # (defaults to no <tt>Filter</tt>).
  # <li>   java.util.logging.MemoryHandler.size
  # defines the buffer size (defaults to 1000).
  # <li>   java.util.logging.MemoryHandler.push
  # defines the <tt>pushLevel</tt> (defaults to <tt>level.SEVERE</tt>).
  # <li>   java.util.logging.MemoryHandler.target
  # specifies the name of the target <tt>Handler </tt> class.
  # (no default).
  # </ul>
  # 
  # @since 1.4
  class MemoryHandler < MemoryHandlerImports.const_get :Handler
    include_class_members MemoryHandlerImports
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_SIZE) { 1000 }
      const_attr_reader  :DEFAULT_SIZE
    }
    
    attr_accessor :push_level
    alias_method :attr_push_level, :push_level
    undef_method :push_level
    alias_method :attr_push_level=, :push_level=
    undef_method :push_level=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    attr_accessor :start
    alias_method :attr_start, :start
    undef_method :start
    alias_method :attr_start=, :start=
    undef_method :start=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    typesig { [] }
    # Private method to configure a ConsoleHandler from LogManager
    # properties and/or default values as specified in the class
    # javadoc.
    def configure
      manager = LogManager.get_log_manager
      cname = get_class.get_name
      @push_level = manager.get_level_property(cname + ".push", Level::SEVERE)
      @size = manager.get_int_property(cname + ".size", DEFAULT_SIZE)
      if (@size <= 0)
        @size = DEFAULT_SIZE
      end
      set_level(manager.get_level_property(cname + ".level", Level::ALL))
      set_filter(manager.get_filter_property(cname + ".filter", nil))
      set_formatter(manager.get_formatter_property(cname + ".formatter", SimpleFormatter.new))
    end
    
    typesig { [] }
    # Create a <tt>MemoryHandler</tt> and configure it based on
    # <tt>LogManager</tt> configuration properties.
    def initialize
      @push_level = nil
      @size = 0
      @target = nil
      @buffer = nil
      @start = 0
      @count = 0
      super()
      self.attr_sealed = false
      configure
      self.attr_sealed = true
      name = "???"
      begin
        manager = LogManager.get_log_manager
        name = RJava.cast_to_string(manager.get_property("java.util.logging.MemoryHandler.target"))
        clz = ClassLoader.get_system_class_loader.load_class(name)
        @target = clz.new_instance
      rescue JavaException => ex
        raise RuntimeException.new("MemoryHandler can't load handler \"" + name + "\"", ex)
      end
      init
    end
    
    typesig { [] }
    # Initialize.  Size is a count of LogRecords.
    def init
      @buffer = Array.typed(LogRecord).new(@size) { nil }
      @start = 0
      @count = 0
    end
    
    typesig { [Handler, ::Java::Int, Level] }
    # Create a <tt>MemoryHandler</tt>.
    # <p>
    # The <tt>MemoryHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given <tt>pushLevel</tt>
    # argument and buffer size argument are used.
    # 
    # @param target  the Handler to which to publish output.
    # @param size    the number of log records to buffer (must be greater than zero)
    # @param pushLevel  message level to push on
    # 
    # @throws IllegalArgumentException is size is <= 0
    def initialize(target, size, push_level)
      @push_level = nil
      @size = 0
      @target = nil
      @buffer = nil
      @start = 0
      @count = 0
      super()
      if ((target).nil? || (push_level).nil?)
        raise NullPointerException.new
      end
      if (size <= 0)
        raise IllegalArgumentException.new
      end
      self.attr_sealed = false
      configure
      self.attr_sealed = true
      @target = target
      @push_level = push_level
      @size = size
      init
    end
    
    typesig { [LogRecord] }
    # Store a <tt>LogRecord</tt> in an internal buffer.
    # <p>
    # If there is a <tt>Filter</tt>, its <tt>isLoggable</tt>
    # method is called to check if the given log record is loggable.
    # If not we return.  Otherwise the given record is copied into
    # an internal circular buffer.  Then the record's level property is
    # compared with the <tt>pushLevel</tt>. If the given level is
    # greater than or equal to the <tt>pushLevel</tt> then <tt>push</tt>
    # is called to write all buffered records to the target output
    # <tt>Handler</tt>.
    # 
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      synchronized(self) do
        if (!is_loggable(record))
          return
        end
        ix = (@start + @count) % @buffer.attr_length
        @buffer[ix] = record
        if (@count < @buffer.attr_length)
          @count += 1
        else
          @start += 1
          @start %= @buffer.attr_length
        end
        if (record.get_level.int_value >= @push_level.int_value)
          push
        end
      end
    end
    
    typesig { [] }
    # Push any buffered output to the target <tt>Handler</tt>.
    # <p>
    # The buffer is then cleared.
    def push
      synchronized(self) do
        i = 0
        while i < @count
          ix = (@start + i) % @buffer.attr_length
          record = @buffer[ix]
          @target.publish(record)
          i += 1
        end
        # Empty the buffer.
        @start = 0
        @count = 0
      end
    end
    
    typesig { [] }
    # Causes a flush on the target <tt>Handler</tt>.
    # <p>
    # Note that the current contents of the <tt>MemoryHandler</tt>
    # buffer are <b>not</b> written out.  That requires a "push".
    def flush
      @target.flush
    end
    
    typesig { [] }
    # Close the <tt>Handler</tt> and free all associated resources.
    # This will also close the target <tt>Handler</tt>.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def close
      @target.close
      set_level(Level::OFF)
    end
    
    typesig { [Level] }
    # Set the <tt>pushLevel</tt>.  After a <tt>LogRecord</tt> is copied
    # into our internal buffer, if its level is greater than or equal to
    # the <tt>pushLevel</tt>, then <tt>push</tt> will be called.
    # 
    # @param newLevel the new value of the <tt>pushLevel</tt>
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_push_level(new_level)
      if ((new_level).nil?)
        raise NullPointerException.new
      end
      manager = LogManager.get_log_manager
      check_access
      @push_level = new_level
    end
    
    typesig { [] }
    # Get the <tt>pushLevel</tt>.
    # 
    # @return the value of the <tt>pushLevel</tt>
    def get_push_level
      synchronized(self) do
        return @push_level
      end
    end
    
    typesig { [LogRecord] }
    # Check if this <tt>Handler</tt> would actually log a given
    # <tt>LogRecord</tt> into its internal buffer.
    # <p>
    # This method checks if the <tt>LogRecord</tt> has an appropriate level and
    # whether it satisfies any <tt>Filter</tt>.  However it does <b>not</b>
    # check whether the <tt>LogRecord</tt> would result in a "push" of the
    # buffer contents. It will return false if the <tt>LogRecord</tt> is Null.
    # <p>
    # @param record  a <tt>LogRecord</tt>
    # @return true if the <tt>LogRecord</tt> would be logged.
    def is_loggable(record)
      return super(record)
    end
    
    private
    alias_method :initialize__memory_handler, :initialize
  end
  
end

require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include_const ::Java::Io, :UnsupportedEncodingException
    }
  end
  
  # A <tt>Handler</tt> object takes log messages from a <tt>Logger</tt> and
  # exports them.  It might for example, write them to a console
  # or write them to a file, or send them to a network logging service,
  # or forward them to an OS log, or whatever.
  # <p>
  # A <tt>Handler</tt> can be disabled by doing a <tt>setLevel(Level.OFF)</tt>
  # and can  be re-enabled by doing a <tt>setLevel</tt> with an appropriate level.
  # <p>
  # <tt>Handler</tt> classes typically use <tt>LogManager</tt> properties to set
  # default values for the <tt>Handler</tt>'s <tt>Filter</tt>, <tt>Formatter</tt>,
  # and <tt>Level</tt>.  See the specific documentation for each concrete
  # <tt>Handler</tt> class.
  # 
  # 
  # @since 1.4
  class Handler 
    include_class_members HandlerImports
    
    class_module.module_eval {
      const_set_lazy(:OffValue) { Level::OFF.int_value }
      const_attr_reader  :OffValue
    }
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    attr_accessor :filter
    alias_method :attr_filter, :filter
    undef_method :filter
    alias_method :attr_filter=, :filter=
    undef_method :filter=
    
    attr_accessor :formatter
    alias_method :attr_formatter, :formatter
    undef_method :formatter
    alias_method :attr_formatter=, :formatter=
    undef_method :formatter=
    
    attr_accessor :log_level
    alias_method :attr_log_level, :log_level
    undef_method :log_level
    alias_method :attr_log_level=, :log_level=
    undef_method :log_level=
    
    attr_accessor :error_manager
    alias_method :attr_error_manager, :error_manager
    undef_method :error_manager
    alias_method :attr_error_manager=, :error_manager=
    undef_method :error_manager=
    
    attr_accessor :encoding
    alias_method :attr_encoding, :encoding
    undef_method :encoding
    alias_method :attr_encoding=, :encoding=
    undef_method :encoding=
    
    # Package private support for security checking.  When sealed
    # is true, we access check updates to the class.
    attr_accessor :sealed
    alias_method :attr_sealed, :sealed
    undef_method :sealed
    alias_method :attr_sealed=, :sealed=
    undef_method :sealed=
    
    typesig { [] }
    # Default constructor.  The resulting <tt>Handler</tt> has a log
    # level of <tt>Level.ALL</tt>, no <tt>Formatter</tt>, and no
    # <tt>Filter</tt>.  A default <tt>ErrorManager</tt> instance is installed
    # as the <tt>ErrorManager</tt>.
    def initialize
      @manager = LogManager.get_log_manager
      @filter = nil
      @formatter = nil
      @log_level = Level::ALL
      @error_manager = ErrorManager.new
      @encoding = nil
      @sealed = true
    end
    
    typesig { [LogRecord] }
    # Publish a <tt>LogRecord</tt>.
    # <p>
    # The logging request was made initially to a <tt>Logger</tt> object,
    # which initialized the <tt>LogRecord</tt> and forwarded it here.
    # <p>
    # The <tt>Handler</tt>  is responsible for formatting the message, when and
    # if necessary.  The formatting should include localization.
    # 
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Flush any buffered output.
    def flush
      raise NotImplementedError
    end
    
    typesig { [] }
    # Close the <tt>Handler</tt> and free all associated resources.
    # <p>
    # The close method will perform a <tt>flush</tt> and then close the
    # <tt>Handler</tt>.   After close has been called this <tt>Handler</tt>
    # should no longer be used.  Method calls may either be silently
    # ignored or may throw runtime exceptions.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def close
      raise NotImplementedError
    end
    
    typesig { [Formatter] }
    # Set a <tt>Formatter</tt>.  This <tt>Formatter</tt> will be used
    # to format <tt>LogRecords</tt> for this <tt>Handler</tt>.
    # <p>
    # Some <tt>Handlers</tt> may not use <tt>Formatters</tt>, in
    # which case the <tt>Formatter</tt> will be remembered, but not used.
    # <p>
    # @param newFormatter the <tt>Formatter</tt> to use (may not be null)
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_formatter(new_formatter)
      check_access
      # Check for a null pointer:
      new_formatter.get_class
      @formatter = new_formatter
    end
    
    typesig { [] }
    # Return the <tt>Formatter</tt> for this <tt>Handler</tt>.
    # @return the <tt>Formatter</tt> (may be null).
    def get_formatter
      return @formatter
    end
    
    typesig { [String] }
    # Set the character encoding used by this <tt>Handler</tt>.
    # <p>
    # The encoding should be set before any <tt>LogRecords</tt> are written
    # to the <tt>Handler</tt>.
    # 
    # @param encoding  The name of a supported character encoding.
    # May be null, to indicate the default platform encoding.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    # @exception  UnsupportedEncodingException if the named encoding is
    # not supported.
    def set_encoding(encoding)
      check_access
      if (!(encoding).nil?)
        begin
          if (!Java::Nio::Charset::Charset.is_supported(encoding))
            raise UnsupportedEncodingException.new(encoding)
          end
        rescue Java::Nio::Charset::IllegalCharsetNameException => e
          raise UnsupportedEncodingException.new(encoding)
        end
      end
      @encoding = encoding
    end
    
    typesig { [] }
    # Return the character encoding for this <tt>Handler</tt>.
    # 
    # @return  The encoding name.  May be null, which indicates the
    # default encoding should be used.
    def get_encoding
      return @encoding
    end
    
    typesig { [Filter] }
    # Set a <tt>Filter</tt> to control output on this <tt>Handler</tt>.
    # <P>
    # For each call of <tt>publish</tt> the <tt>Handler</tt> will call
    # this <tt>Filter</tt> (if it is non-null) to check if the
    # <tt>LogRecord</tt> should be published or discarded.
    # 
    # @param   newFilter  a <tt>Filter</tt> object (may be null)
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_filter(new_filter)
      check_access
      @filter = new_filter
    end
    
    typesig { [] }
    # Get the current <tt>Filter</tt> for this <tt>Handler</tt>.
    # 
    # @return  a <tt>Filter</tt> object (may be null)
    def get_filter
      return @filter
    end
    
    typesig { [ErrorManager] }
    # Define an ErrorManager for this Handler.
    # <p>
    # The ErrorManager's "error" method will be invoked if any
    # errors occur while using this Handler.
    # 
    # @param em  the new ErrorManager
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_error_manager(em)
      check_access
      if ((em).nil?)
        raise NullPointerException.new
      end
      @error_manager = em
    end
    
    typesig { [] }
    # Retrieves the ErrorManager for this Handler.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def get_error_manager
      check_access
      return @error_manager
    end
    
    typesig { [String, JavaException, ::Java::Int] }
    # Protected convenience method to report an error to this Handler's
    # ErrorManager.  Note that this method retrieves and uses the ErrorManager
    # without doing a security check.  It can therefore be used in
    # environments where the caller may be non-privileged.
    # 
    # @param msg    a descriptive string (may be null)
    # @param ex     an exception (may be null)
    # @param code   an error code defined in ErrorManager
    def report_error(msg, ex, code)
      begin
        @error_manager.error(msg, ex, code)
      rescue JavaException => ex2
        System.err.println("Handler.reportError caught:")
        ex2.print_stack_trace
      end
    end
    
    typesig { [Level] }
    # Set the log level specifying which message levels will be
    # logged by this <tt>Handler</tt>.  Message levels lower than this
    # value will be discarded.
    # <p>
    # The intention is to allow developers to turn on voluminous
    # logging, but to limit the messages that are sent to certain
    # <tt>Handlers</tt>.
    # 
    # @param newLevel   the new value for the log level
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_level(new_level)
      synchronized(self) do
        if ((new_level).nil?)
          raise NullPointerException.new
        end
        check_access
        @log_level = new_level
      end
    end
    
    typesig { [] }
    # Get the log level specifying which messages will be
    # logged by this <tt>Handler</tt>.  Message levels lower
    # than this level will be discarded.
    # @return  the level of messages being logged.
    def get_level
      synchronized(self) do
        return @log_level
      end
    end
    
    typesig { [LogRecord] }
    # Check if this <tt>Handler</tt> would actually log a given <tt>LogRecord</tt>.
    # <p>
    # This method checks if the <tt>LogRecord</tt> has an appropriate
    # <tt>Level</tt> and  whether it satisfies any <tt>Filter</tt>.  It also
    # may make other <tt>Handler</tt> specific checks that might prevent a
    # handler from logging the <tt>LogRecord</tt>. It will return false if
    # the <tt>LogRecord</tt> is Null.
    # <p>
    # @param record  a <tt>LogRecord</tt>
    # @return true if the <tt>LogRecord</tt> would be logged.
    def is_loggable(record)
      level_value = get_level.int_value
      if (record.get_level.int_value < level_value || (level_value).equal?(OffValue))
        return false
      end
      filter = get_filter
      if ((filter).nil?)
        return true
      end
      return filter.is_loggable(record)
    end
    
    typesig { [] }
    # Package-private support method for security checks.
    # If "sealed" is true, we check that the caller has
    # appropriate security privileges to update Handler
    # state and if not throw a SecurityException.
    def check_access
      if (@sealed)
        @manager.check_access
      end
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end

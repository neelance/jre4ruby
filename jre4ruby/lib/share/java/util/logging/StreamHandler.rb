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
  module StreamHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
    }
  end
  
  # Stream based logging <tt>Handler</tt>.
  # <p>
  # This is primarily intended as a base class or support class to
  # be used in implementing other logging <tt>Handlers</tt>.
  # <p>
  # <tt>LogRecords</tt> are published to a given <tt>java.io.OutputStream</tt>.
  # <p>
  # <b>Configuration:</b>
  # By default each <tt>StreamHandler</tt> is initialized using the following
  # <tt>LogManager</tt> configuration properties.  If properties are not defined
  # (or have invalid values) then the specified default values are used.
  # <ul>
  # <li>   java.util.logging.StreamHandler.level
  # specifies the default level for the <tt>Handler</tt>
  # (defaults to <tt>Level.INFO</tt>).
  # <li>   java.util.logging.StreamHandler.filter
  # specifies the name of a <tt>Filter</tt> class to use
  # (defaults to no <tt>Filter</tt>).
  # <li>   java.util.logging.StreamHandler.formatter
  # specifies the name of a <tt>Formatter</tt> class to use
  # (defaults to <tt>java.util.logging.SimpleFormatter</tt>).
  # <li>   java.util.logging.StreamHandler.encoding
  # the name of the character set encoding to use (defaults to
  # the default platform encoding).
  # </ul>
  # 
  # @since 1.4
  class StreamHandler < StreamHandlerImports.const_get :Handler
    include_class_members StreamHandlerImports
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    attr_accessor :output
    alias_method :attr_output, :output
    undef_method :output
    alias_method :attr_output=, :output=
    undef_method :output=
    
    attr_accessor :done_header
    alias_method :attr_done_header, :done_header
    undef_method :done_header
    alias_method :attr_done_header=, :done_header=
    undef_method :done_header=
    
    attr_accessor :writer
    alias_method :attr_writer, :writer
    undef_method :writer
    alias_method :attr_writer=, :writer=
    undef_method :writer=
    
    typesig { [] }
    # Private method to configure a StreamHandler from LogManager
    # properties and/or default values as specified in the class
    # javadoc.
    def configure
      manager = LogManager.get_log_manager
      cname = get_class.get_name
      set_level(manager.get_level_property(cname + ".level", Level::INFO))
      set_filter(manager.get_filter_property(cname + ".filter", nil))
      set_formatter(manager.get_formatter_property(cname + ".formatter", SimpleFormatter.new))
      begin
        set_encoding(manager.get_string_property(cname + ".encoding", nil))
      rescue JavaException => ex
        begin
          set_encoding(nil)
        rescue JavaException => ex2
          # doing a setEncoding with null should always work.
          # assert false;
        end
      end
    end
    
    typesig { [] }
    # Create a <tt>StreamHandler</tt>, with no current output stream.
    def initialize
      @manager = nil
      @output = nil
      @done_header = false
      @writer = nil
      super()
      @manager = LogManager.get_log_manager
      self.attr_sealed = false
      configure
      self.attr_sealed = true
    end
    
    typesig { [OutputStream, Formatter] }
    # Create a <tt>StreamHandler</tt> with a given <tt>Formatter</tt>
    # and output stream.
    # <p>
    # @param out         the target output stream
    # @param formatter   Formatter to be used to format output
    def initialize(out, formatter)
      @manager = nil
      @output = nil
      @done_header = false
      @writer = nil
      super()
      @manager = LogManager.get_log_manager
      self.attr_sealed = false
      configure
      set_formatter(formatter)
      set_output_stream(out)
      self.attr_sealed = true
    end
    
    typesig { [OutputStream] }
    # Change the output stream.
    # <P>
    # If there is a current output stream then the <tt>Formatter</tt>'s
    # tail string is written and the stream is flushed and closed.
    # Then the output stream is replaced with the new output stream.
    # 
    # @param out   New output stream.  May not be null.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def set_output_stream(out)
      synchronized(self) do
        if ((out).nil?)
          raise NullPointerException.new
        end
        flush_and_close
        @output = out
        @done_header = false
        encoding = get_encoding
        if ((encoding).nil?)
          @writer = OutputStreamWriter.new(@output)
        else
          begin
            @writer = OutputStreamWriter.new(@output, encoding)
          rescue UnsupportedEncodingException => ex
            # This shouldn't happen.  The setEncoding method
            # should have validated that the encoding is OK.
            raise JavaError.new("Unexpected exception " + RJava.cast_to_string(ex))
          end
        end
      end
    end
    
    typesig { [String] }
    # Set (or change) the character encoding used by this <tt>Handler</tt>.
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
      super(encoding)
      if ((@output).nil?)
        return
      end
      # Replace the current writer with a writer for the new encoding.
      flush
      if ((encoding).nil?)
        @writer = OutputStreamWriter.new(@output)
      else
        @writer = OutputStreamWriter.new(@output, encoding)
      end
    end
    
    typesig { [LogRecord] }
    # Format and publish a <tt>LogRecord</tt>.
    # <p>
    # The <tt>StreamHandler</tt> first checks if there is an <tt>OutputStream</tt>
    # and if the given <tt>LogRecord</tt> has at least the required log level.
    # If not it silently returns.  If so, it calls any associated
    # <tt>Filter</tt> to check if the record should be published.  If so,
    # it calls its <tt>Formatter</tt> to format the record and then writes
    # the result to the current output stream.
    # <p>
    # If this is the first <tt>LogRecord</tt> to be written to a given
    # <tt>OutputStream</tt>, the <tt>Formatter</tt>'s "head" string is
    # written to the stream before the <tt>LogRecord</tt> is written.
    # 
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      synchronized(self) do
        if (!is_loggable(record))
          return
        end
        msg = nil
        begin
          msg = RJava.cast_to_string(get_formatter.format(record))
        rescue JavaException => ex
          # We don't want to throw an exception here, but we
          # report the exception to any registered ErrorManager.
          report_error(nil, ex, ErrorManager::FORMAT_FAILURE)
          return
        end
        begin
          if (!@done_header)
            @writer.write(get_formatter.get_head(self))
            @done_header = true
          end
          @writer.write(msg)
        rescue JavaException => ex
          # We don't want to throw an exception here, but we
          # report the exception to any registered ErrorManager.
          report_error(nil, ex, ErrorManager::WRITE_FAILURE)
        end
      end
    end
    
    typesig { [LogRecord] }
    # Check if this <tt>Handler</tt> would actually log a given <tt>LogRecord</tt>.
    # <p>
    # This method checks if the <tt>LogRecord</tt> has an appropriate level and
    # whether it satisfies any <tt>Filter</tt>.  It will also return false if
    # no output stream has been assigned yet or the LogRecord is Null.
    # <p>
    # @param record  a <tt>LogRecord</tt>
    # @return true if the <tt>LogRecord</tt> would be logged.
    def is_loggable(record)
      if ((@writer).nil? || (record).nil?)
        return false
      end
      return super(record)
    end
    
    typesig { [] }
    # Flush any buffered messages.
    def flush
      synchronized(self) do
        if (!(@writer).nil?)
          begin
            @writer.flush
          rescue JavaException => ex
            # We don't want to throw an exception here, but we
            # report the exception to any registered ErrorManager.
            report_error(nil, ex, ErrorManager::FLUSH_FAILURE)
          end
        end
      end
    end
    
    typesig { [] }
    def flush_and_close
      synchronized(self) do
        check_access
        if (!(@writer).nil?)
          begin
            if (!@done_header)
              @writer.write(get_formatter.get_head(self))
              @done_header = true
            end
            @writer.write(get_formatter.get_tail(self))
            @writer.flush
            @writer.close
          rescue JavaException => ex
            # We don't want to throw an exception here, but we
            # report the exception to any registered ErrorManager.
            report_error(nil, ex, ErrorManager::CLOSE_FAILURE)
          end
          @writer = nil
          @output = nil
        end
      end
    end
    
    typesig { [] }
    # Close the current output stream.
    # <p>
    # The <tt>Formatter</tt>'s "tail" string is written to the stream before it
    # is closed.  In addition, if the <tt>Formatter</tt>'s "head" string has not
    # yet been written to the stream, it will be written before the
    # "tail" string.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def close
      synchronized(self) do
        flush_and_close
      end
    end
    
    private
    alias_method :initialize__stream_handler, :initialize
  end
  
end

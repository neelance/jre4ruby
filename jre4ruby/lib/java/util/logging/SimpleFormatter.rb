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
  module SimpleFormatterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include ::Java::Text
      include_const ::Java::Util, :Date
    }
  end
  
  # Print a brief summary of the LogRecord in a human readable
  # format.  The summary will typically be 1 or 2 lines.
  # 
  # @since 1.4
  class SimpleFormatter < SimpleFormatterImports.const_get :Formatter
    include_class_members SimpleFormatterImports
    
    attr_accessor :dat
    alias_method :attr_dat, :dat
    undef_method :dat
    alias_method :attr_dat=, :dat=
    undef_method :dat=
    
    class_module.module_eval {
      const_set_lazy(:Format) { "{0,date} {0,time}" }
      const_attr_reader  :Format
    }
    
    attr_accessor :formatter
    alias_method :attr_formatter, :formatter
    undef_method :formatter
    alias_method :attr_formatter=, :formatter=
    undef_method :formatter=
    
    attr_accessor :args
    alias_method :attr_args, :args
    undef_method :args
    alias_method :attr_args=, :args=
    undef_method :args=
    
    # Line separator string.  This is the value of the line.separator
    # property at the moment that the SimpleFormatter was created.
    attr_accessor :line_separator
    alias_method :attr_line_separator, :line_separator
    undef_method :line_separator
    alias_method :attr_line_separator=, :line_separator=
    undef_method :line_separator=
    
    typesig { [LogRecord] }
    # Format the given LogRecord.
    # <p>
    # This method can be overridden in a subclass.
    # It is recommended to use the {@link Formatter#formatMessage}
    # convenience method to localize and format the message field.
    # 
    # @param record the log record to be formatted.
    # @return a formatted log record
    def format(record)
      synchronized(self) do
        sb = StringBuffer.new
        # Minimize memory allocations here.
        @dat.set_time(record.get_millis)
        @args[0] = @dat
        text = StringBuffer.new
        if ((@formatter).nil?)
          @formatter = MessageFormat.new(Format)
        end
        @formatter.format(@args, text, nil)
        sb.append(text)
        sb.append(" ")
        if (!(record.get_source_class_name).nil?)
          sb.append(record.get_source_class_name)
        else
          sb.append(record.get_logger_name)
        end
        if (!(record.get_source_method_name).nil?)
          sb.append(" ")
          sb.append(record.get_source_method_name)
        end
        sb.append(@line_separator)
        message = format_message(record)
        sb.append(record.get_level.get_localized_name)
        sb.append(": ")
        sb.append(message)
        sb.append(@line_separator)
        if (!(record.get_thrown).nil?)
          begin
            sw = StringWriter.new
            pw = PrintWriter.new(sw)
            record.get_thrown.print_stack_trace(pw)
            pw.close
            sb.append(sw.to_s)
          rescue Exception => ex
          end
        end
        return sb.to_s
      end
    end
    
    typesig { [] }
    def initialize
      @dat = nil
      @formatter = nil
      @args = nil
      @line_separator = nil
      super()
      @dat = Date.new
      @args = Array.typed(Object).new(1) { nil }
      @line_separator = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("line.separator"))
    end
    
    private
    alias_method :initialize__simple_formatter, :initialize
  end
  
end

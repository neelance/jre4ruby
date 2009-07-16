require "rjava"

# 
# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ConsoleHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include ::Java::Net
    }
  end
  
  # 
  # This <tt>Handler</tt> publishes log records to <tt>System.err</tt>.
  # By default the <tt>SimpleFormatter</tt> is used to generate brief summaries.
  # <p>
  # <b>Configuration:</b>
  # By default each <tt>ConsoleHandler</tt> is initialized using the following
  # <tt>LogManager</tt> configuration properties.  If properties are not defined
  # (or have invalid values) then the specified default values are used.
  # <ul>
  # <li>   java.util.logging.ConsoleHandler.level
  # specifies the default level for the <tt>Handler</tt>
  # (defaults to <tt>Level.INFO</tt>).
  # <li>   java.util.logging.ConsoleHandler.filter
  # specifies the name of a <tt>Filter</tt> class to use
  # (defaults to no <tt>Filter</tt>).
  # <li>   java.util.logging.ConsoleHandler.formatter
  # specifies the name of a <tt>Formatter</tt> class to use
  # (defaults to <tt>java.util.logging.SimpleFormatter</tt>).
  # <li>   java.util.logging.ConsoleHandler.encoding
  # the name of the character set encoding to use (defaults to
  # the default platform encoding).
  # </ul>
  # <p>
  # @since 1.4
  class ConsoleHandler < ConsoleHandlerImports.const_get :StreamHandler
    include_class_members ConsoleHandlerImports
    
    typesig { [] }
    # Private method to configure a ConsoleHandler from LogManager
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
      rescue Exception => ex
        begin
          set_encoding(nil)
        rescue Exception => ex2
          # doing a setEncoding with null should always work.
          # assert false;
        end
      end
    end
    
    typesig { [] }
    # 
    # Create a <tt>ConsoleHandler</tt> for <tt>System.err</tt>.
    # <p>
    # The <tt>ConsoleHandler</tt> is configured based on
    # <tt>LogManager</tt> properties (or their default values).
    def initialize
      super()
      self.attr_sealed = false
      configure
      set_output_stream(System.err)
      self.attr_sealed = true
    end
    
    typesig { [LogRecord] }
    # 
    # Publish a <tt>LogRecord</tt>.
    # <p>
    # The logging request was made initially to a <tt>Logger</tt> object,
    # which initialized the <tt>LogRecord</tt> and forwarded it here.
    # <p>
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      super(record)
      flush
    end
    
    typesig { [] }
    # 
    # Override <tt>StreamHandler.close</tt> to do a flush but not
    # to close the output stream.  That is, we do <b>not</b>
    # close <tt>System.err</tt>.
    def close
      flush
    end
    
    private
    alias_method :initialize__console_handler, :initialize
  end
  
end

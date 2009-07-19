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
  module FormatterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
    }
  end
  
  # A Formatter provides support for formatting LogRecords.
  # <p>
  # Typically each logging Handler will have a Formatter associated
  # with it.  The Formatter takes a LogRecord and converts it to
  # a string.
  # <p>
  # Some formatters (such as the XMLFormatter) need to wrap head
  # and tail strings around a set of formatted records. The getHeader
  # and getTail methods can be used to obtain these strings.
  # 
  # @since 1.4
  class Formatter 
    include_class_members FormatterImports
    
    typesig { [] }
    # Construct a new formatter.
    def initialize
    end
    
    typesig { [LogRecord] }
    # Format the given log record and return the formatted string.
    # <p>
    # The resulting formatted String will normally include a
    # localized and formated version of the LogRecord's message field.
    # It is recommended to use the {@link Formatter#formatMessage}
    # convenience method to localize and format the message field.
    # 
    # @param record the log record to be formatted.
    # @return the formatted log record
    def format(record)
      raise NotImplementedError
    end
    
    typesig { [Handler] }
    # Return the header string for a set of formatted records.
    # <p>
    # This base class returns an empty string, but this may be
    # overriden by subclasses.
    # 
    # @param   h  The target handler (can be null)
    # @return  header string
    def get_head(h)
      return ""
    end
    
    typesig { [Handler] }
    # Return the tail string for a set of formatted records.
    # <p>
    # This base class returns an empty string, but this may be
    # overriden by subclasses.
    # 
    # @param   h  The target handler (can be null)
    # @return  tail string
    def get_tail(h)
      return ""
    end
    
    typesig { [LogRecord] }
    # Localize and format the message string from a log record.  This
    # method is provided as a convenience for Formatter subclasses to
    # use when they are performing formatting.
    # <p>
    # The message string is first localized to a format string using
    # the record's ResourceBundle.  (If there is no ResourceBundle,
    # or if the message key is not found, then the key is used as the
    # format string.)  The format String uses java.text style
    # formatting.
    # <ul>
    # <li>If there are no parameters, no formatter is used.
    # <li>Otherwise, if the string contains "{0" then
    # java.text.MessageFormat  is used to format the string.
    # <li>Otherwise no formatting is performed.
    # </ul>
    # <p>
    # 
    # @param  record  the log record containing the raw message
    # @return   a localized and formatted message
    def format_message(record)
      synchronized(self) do
        format = record.get_message
        catalog = record.get_resource_bundle
        if (!(catalog).nil?)
          begin
            format = (catalog.get_string(record.get_message)).to_s
          rescue Java::Util::MissingResourceException => ex
            # Drop through.  Use record message as format
            format = (record.get_message).to_s
          end
        end
        # Do the formatting.
        begin
          parameters = record.get_parameters
          if ((parameters).nil? || (parameters.attr_length).equal?(0))
            # No parameters.  Just return format string.
            return format
          end
          # Is it a java.text style format?
          # Ideally we could match with
          # Pattern.compile("\\{\\d").matcher(format).find())
          # However the cost is 14% higher, so we cheaply check for
          # 1 of the first 4 parameters
          if (format.index_of("{0") >= 0 || format.index_of("{1") >= 0 || format.index_of("{2") >= 0 || format.index_of("{3") >= 0)
            return Java::Text::MessageFormat.format(format, parameters)
          end
          return format
        rescue Exception => ex
          # Formatting failed: use localized format string.
          return format
        end
      end
    end
    
    private
    alias_method :initialize__formatter, :initialize
  end
  
end

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
  module XMLFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include_const ::Java::Nio::Charset, :Charset
      include ::Java::Util
    }
  end
  
  # Format a LogRecord into a standard XML format.
  # <p>
  # The DTD specification is provided as Appendix A to the
  # Java Logging APIs specification.
  # <p>
  # The XMLFormatter can be used with arbitrary character encodings,
  # but it is recommended that it normally be used with UTF-8.  The
  # character encoding can be set on the output Handler.
  # 
  # @since 1.4
  class XMLFormatter < XMLFormatterImports.const_get :Formatter
    include_class_members XMLFormatterImports
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    typesig { [StringBuffer, ::Java::Int] }
    # Append a two digit number.
    def a2(sb, x)
      if (x < 10)
        sb.append(Character.new(?0.ord))
      end
      sb.append(x)
    end
    
    typesig { [StringBuffer, ::Java::Long] }
    # Append the time and date in ISO 8601 format
    def append_iso8601(sb, millis)
      date = JavaDate.new(millis)
      sb.append(date.get_year + 1900)
      sb.append(Character.new(?-.ord))
      a2(sb, date.get_month + 1)
      sb.append(Character.new(?-.ord))
      a2(sb, date.get_date)
      sb.append(Character.new(?T.ord))
      a2(sb, date.get_hours)
      sb.append(Character.new(?:.ord))
      a2(sb, date.get_minutes)
      sb.append(Character.new(?:.ord))
      a2(sb, date.get_seconds)
    end
    
    typesig { [StringBuffer, String] }
    # Append to the given StringBuffer an escaped version of the
    # given text string where XML special characters have been escaped.
    # For a null string we append "<null>"
    def escape(sb, text)
      if ((text).nil?)
        text = "<null>"
      end
      i = 0
      while i < text.length
        ch = text.char_at(i)
        if ((ch).equal?(Character.new(?<.ord)))
          sb.append("&lt;")
        else
          if ((ch).equal?(Character.new(?>.ord)))
            sb.append("&gt;")
          else
            if ((ch).equal?(Character.new(?&.ord)))
              sb.append("&amp;")
            else
              sb.append(ch)
            end
          end
        end
        i += 1
      end
    end
    
    typesig { [LogRecord] }
    # Format the given message to XML.
    # <p>
    # This method can be overridden in a subclass.
    # It is recommended to use the {@link Formatter#formatMessage}
    # convenience method to localize and format the message field.
    # 
    # @param record the log record to be formatted.
    # @return a formatted log record
    def format(record)
      sb = StringBuffer.new(500)
      sb.append("<record>\n")
      sb.append("  <date>")
      append_iso8601(sb, record.get_millis)
      sb.append("</date>\n")
      sb.append("  <millis>")
      sb.append(record.get_millis)
      sb.append("</millis>\n")
      sb.append("  <sequence>")
      sb.append(record.get_sequence_number)
      sb.append("</sequence>\n")
      name = record.get_logger_name
      if (!(name).nil?)
        sb.append("  <logger>")
        escape(sb, name)
        sb.append("</logger>\n")
      end
      sb.append("  <level>")
      escape(sb, record.get_level.to_s)
      sb.append("</level>\n")
      if (!(record.get_source_class_name).nil?)
        sb.append("  <class>")
        escape(sb, record.get_source_class_name)
        sb.append("</class>\n")
      end
      if (!(record.get_source_method_name).nil?)
        sb.append("  <method>")
        escape(sb, record.get_source_method_name)
        sb.append("</method>\n")
      end
      sb.append("  <thread>")
      sb.append(record.get_thread_id)
      sb.append("</thread>\n")
      if (!(record.get_message).nil?)
        # Format the message string and its accompanying parameters.
        message = format_message(record)
        sb.append("  <message>")
        escape(sb, message)
        sb.append("</message>")
        sb.append("\n")
      end
      # If the message is being localized, output the key, resource
      # bundle name, and params.
      bundle = record.get_resource_bundle
      begin
        if (!(bundle).nil? && !(bundle.get_string(record.get_message)).nil?)
          sb.append("  <key>")
          escape(sb, record.get_message)
          sb.append("</key>\n")
          sb.append("  <catalog>")
          escape(sb, record.get_resource_bundle_name)
          sb.append("</catalog>\n")
        end
      rescue JavaException => ex
        # The message is not in the catalog.  Drop through.
      end
      parameters = record.get_parameters
      #  Check to see if the parameter was not a messagetext format
      #  or was not null or empty
      if (!(parameters).nil? && !(parameters.attr_length).equal?(0) && (record.get_message.index_of("{")).equal?(-1))
        i = 0
        while i < parameters.attr_length
          sb.append("  <param>")
          begin
            escape(sb, parameters[i].to_s)
          rescue JavaException => ex
            sb.append("???")
          end
          sb.append("</param>\n")
          i += 1
        end
      end
      if (!(record.get_thrown).nil?)
        # Report on the state of the throwable.
        th = record.get_thrown
        sb.append("  <exception>\n")
        sb.append("    <message>")
        escape(sb, th.to_s)
        sb.append("</message>\n")
        trace = th.get_stack_trace
        i = 0
        while i < trace.attr_length
          frame = trace[i]
          sb.append("    <frame>\n")
          sb.append("      <class>")
          escape(sb, frame.get_class_name)
          sb.append("</class>\n")
          sb.append("      <method>")
          escape(sb, frame.get_method_name)
          sb.append("</method>\n")
          # Check for a line number.
          if (frame.get_line_number >= 0)
            sb.append("      <line>")
            sb.append(frame.get_line_number)
            sb.append("</line>\n")
          end
          sb.append("    </frame>\n")
          i += 1
        end
        sb.append("  </exception>\n")
      end
      sb.append("</record>\n")
      return sb.to_s
    end
    
    typesig { [Handler] }
    # Return the header string for a set of XML formatted records.
    # 
    # @param   h  The target handler (can be null)
    # @return  a valid XML string
    def get_head(h)
      sb = StringBuffer.new
      encoding = nil
      sb.append("<?xml version=\"1.0\"")
      if (!(h).nil?)
        encoding = RJava.cast_to_string(h.get_encoding)
      else
        encoding = RJava.cast_to_string(nil)
      end
      if ((encoding).nil?)
        # Figure out the default encoding.
        encoding = RJava.cast_to_string(Java::Nio::Charset::Charset.default_charset.name)
      end
      # Try to map the encoding name to a canonical name.
      begin
        cs = Charset.for_name(encoding)
        encoding = RJava.cast_to_string(cs.name)
      rescue JavaException => ex
        # We hit problems finding a canonical name.
        # Just use the raw encoding name.
      end
      sb.append(" encoding=\"")
      sb.append(encoding)
      sb.append("\"")
      sb.append(" standalone=\"no\"?>\n")
      sb.append("<!DOCTYPE log SYSTEM \"logger.dtd\">\n")
      sb.append("<log>\n")
      return sb.to_s
    end
    
    typesig { [Handler] }
    # Return the tail string for a set of XML formatted records.
    # 
    # @param   h  The target handler (can be null)
    # @return  a valid XML string
    def get_tail(h)
      return "</log>\n"
    end
    
    typesig { [] }
    def initialize
      @manager = nil
      super()
      @manager = LogManager.get_log_manager
    end
    
    private
    alias_method :initialize__xmlformatter, :initialize
  end
  
end

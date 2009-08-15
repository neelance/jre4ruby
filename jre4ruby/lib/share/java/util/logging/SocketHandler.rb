require "rjava"

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
  module SocketHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include ::Java::Net
    }
  end
  
  # Simple network logging <tt>Handler</tt>.
  # <p>
  # <tt>LogRecords</tt> are published to a network stream connection.  By default
  # the <tt>XMLFormatter</tt> class is used for formatting.
  # <p>
  # <b>Configuration:</b>
  # By default each <tt>SocketHandler</tt> is initialized using the following
  # <tt>LogManager</tt> configuration properties.  If properties are not defined
  # (or have invalid values) then the specified default values are used.
  # <ul>
  # <li>   java.util.logging.SocketHandler.level
  # specifies the default level for the <tt>Handler</tt>
  # (defaults to <tt>Level.ALL</tt>).
  # <li>   java.util.logging.SocketHandler.filter
  # specifies the name of a <tt>Filter</tt> class to use
  # (defaults to no <tt>Filter</tt>).
  # <li>   java.util.logging.SocketHandler.formatter
  # specifies the name of a <tt>Formatter</tt> class to use
  # (defaults to <tt>java.util.logging.XMLFormatter</tt>).
  # <li>   java.util.logging.SocketHandler.encoding
  # the name of the character set encoding to use (defaults to
  # the default platform encoding).
  # <li>   java.util.logging.SocketHandler.host
  # specifies the target host name to connect to (no default).
  # <li>   java.util.logging.SocketHandler.port
  # specifies the target TCP port to use (no default).
  # </ul>
  # <p>
  # The output IO stream is buffered, but is flushed after each
  # <tt>LogRecord</tt> is written.
  # 
  # @since 1.4
  class SocketHandler < SocketHandlerImports.const_get :StreamHandler
    include_class_members SocketHandlerImports
    
    attr_accessor :sock
    alias_method :attr_sock, :sock
    undef_method :sock
    alias_method :attr_sock=, :sock=
    undef_method :sock=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    attr_accessor :port_property
    alias_method :attr_port_property, :port_property
    undef_method :port_property
    alias_method :attr_port_property=, :port_property=
    undef_method :port_property=
    
    typesig { [] }
    # Private method to configure a SocketHandler from LogManager
    # properties and/or default values as specified in the class
    # javadoc.
    def configure
      manager = LogManager.get_log_manager
      cname = get_class.get_name
      set_level(manager.get_level_property(cname + ".level", Level::ALL))
      set_filter(manager.get_filter_property(cname + ".filter", nil))
      set_formatter(manager.get_formatter_property(cname + ".formatter", XMLFormatter.new))
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
      @port = manager.get_int_property(cname + ".port", 0)
      @host = RJava.cast_to_string(manager.get_string_property(cname + ".host", nil))
    end
    
    typesig { [] }
    # Create a <tt>SocketHandler</tt>, using only <tt>LogManager</tt> properties
    # (or their defaults).
    # @throws IllegalArgumentException if the host or port are invalid or
    # are not specified as LogManager properties.
    # @throws IOException if we are unable to connect to the target
    # host and port.
    def initialize
      @sock = nil
      @host = nil
      @port = 0
      @port_property = nil
      super()
      # We are going to use the logging defaults.
      self.attr_sealed = false
      configure
      begin
        connect
      rescue IOException => ix
        System.err.println("SocketHandler: connect failed to " + @host + ":" + RJava.cast_to_string(@port))
        raise ix
      end
      self.attr_sealed = true
    end
    
    typesig { [String, ::Java::Int] }
    # Construct a <tt>SocketHandler</tt> using a specified host and port.
    # 
    # The <tt>SocketHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given target host
    # and port arguments are used. If the host argument is empty, but not
    # null String then the localhost is used.
    # 
    # @param host target host.
    # @param port target port.
    # 
    # @throws IllegalArgumentException if the host or port are invalid.
    # @throws IOException if we are unable to connect to the target
    # host and port.
    def initialize(host, port)
      @sock = nil
      @host = nil
      @port = 0
      @port_property = nil
      super()
      self.attr_sealed = false
      configure
      self.attr_sealed = true
      @port = port
      @host = host
      connect
    end
    
    typesig { [] }
    def connect
      # Check the arguments are valid.
      if ((@port).equal?(0))
        raise IllegalArgumentException.new("Bad port: " + RJava.cast_to_string(@port))
      end
      if ((@host).nil?)
        raise IllegalArgumentException.new("Null host name: " + @host)
      end
      # Try to open a new socket.
      @sock = Socket.new(@host, @port)
      out = @sock.get_output_stream
      bout = BufferedOutputStream.new(out)
      set_output_stream(bout)
    end
    
    typesig { [] }
    # Close this output stream.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def close
      synchronized(self) do
        super
        if (!(@sock).nil?)
          begin
            @sock.close
          rescue IOException => ix
            # drop through.
          end
        end
        @sock = nil
      end
    end
    
    typesig { [LogRecord] }
    # Format and publish a <tt>LogRecord</tt>.
    # 
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      synchronized(self) do
        if (!is_loggable(record))
          return
        end
        super(record)
        flush
      end
    end
    
    private
    alias_method :initialize__socket_handler, :initialize
  end
  
end

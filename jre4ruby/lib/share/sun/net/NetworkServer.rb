require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module NetworkServerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include ::Java::Io
      include_const ::Java::Net, :Socket
      include_const ::Java::Net, :ServerSocket
    }
  end
  
  # This is the base class for network servers.  To define a new type
  # of server define a new subclass of NetworkServer with a serviceRequest
  # method that services one request.  Start the server by executing:
  # <pre>
  # new MyServerClass().startServer(port);
  # </pre>
  class NetworkServer 
    include_class_members NetworkServerImports
    include Runnable
    include Cloneable
    
    # Socket for communicating with client.
    attr_accessor :client_socket
    alias_method :attr_client_socket, :client_socket
    undef_method :client_socket
    alias_method :attr_client_socket=, :client_socket=
    undef_method :client_socket=
    
    attr_accessor :server_instance
    alias_method :attr_server_instance, :server_instance
    undef_method :server_instance
    alias_method :attr_server_instance=, :server_instance=
    undef_method :server_instance=
    
    attr_accessor :server_socket
    alias_method :attr_server_socket, :server_socket
    undef_method :server_socket
    alias_method :attr_server_socket=, :server_socket=
    undef_method :server_socket=
    
    # Stream for printing to the client.
    attr_accessor :client_output
    alias_method :attr_client_output, :client_output
    undef_method :client_output
    alias_method :attr_client_output=, :client_output=
    undef_method :client_output=
    
    # Buffered stream for reading replies from client.
    attr_accessor :client_input
    alias_method :attr_client_input, :client_input
    undef_method :client_input
    alias_method :attr_client_input=, :client_input=
    undef_method :client_input=
    
    typesig { [] }
    # Close an open connection to the client.
    def close
      @client_socket.close
      @client_socket = nil
      @client_input = nil
      @client_output = nil
    end
    
    typesig { [] }
    # Return client connection status
    def client_is_open
      return !(@client_socket).nil?
    end
    
    typesig { [] }
    def run
      if (!(@server_socket).nil?)
        JavaThread.current_thread.set_priority(JavaThread::MAX_PRIORITY)
        # System.out.print("Server starts " + serverSocket + "\n");
        while (true)
          begin
            ns = @server_socket.accept
            # System.out.print("New connection " + ns + "\n");
            n = clone
            n.attr_server_socket = nil
            n.attr_client_socket = ns
            JavaThread.new(n).start
          rescue JavaException => e
            System.out.print("Server failure\n")
            e.print_stack_trace
            begin
              @server_socket.close
            rescue IOException => e2
            end
            System.out.print("cs=" + RJava.cast_to_string(@server_socket) + "\n")
            break
          end
        end
        # close();
      else
        begin
          @client_output = PrintStream.new(BufferedOutputStream.new(@client_socket.get_output_stream), false, "ISO8859_1")
          @client_input = BufferedInputStream.new(@client_socket.get_input_stream)
          service_request
          # System.out.print("Service handler exits
          # "+clientSocket+"\n");
        rescue JavaException => e
          # System.out.print("Service handler failure\n");
          # e.printStackTrace();
        end
        begin
          close
        rescue IOException => e2
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Start a server on port <i>port</i>.  It will call serviceRequest()
    # for each new connection.
    def start_server(port)
      @server_socket = ServerSocket.new(port, 50)
      @server_instance = JavaThread.new(self)
      @server_instance.start
    end
    
    typesig { [] }
    # Service one request.  It is invoked with the clientInput and
    # clientOutput streams initialized.  This method handles one client
    # connection. When it is done, it can simply exit. The default
    # server just echoes it's input. It is invoked in it's own private
    # thread.
    def service_request
      buf = Array.typed(::Java::Byte).new(300) { 0 }
      n = 0
      @client_output.print("Echo server " + RJava.cast_to_string(get_class.get_name) + "\n")
      @client_output.flush
      while ((n = @client_input.read(buf, 0, buf.attr_length)) >= 0)
        @client_output.write(buf, 0, n)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(String)] }
      def main(argv)
        begin
          NetworkServer.new.start_server(8888)
        rescue IOException => e
          System.out.print("Server failed: " + RJava.cast_to_string(e) + "\n")
        end
      end
    }
    
    typesig { [] }
    # Clone this object;
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        # this shouldn't happen, since we are Cloneable
        raise InternalError.new
      end
    end
    
    typesig { [] }
    def initialize
      @client_socket = nil
      @server_instance = nil
      @server_socket = nil
      @client_output = nil
      @client_input = nil
    end
    
    private
    alias_method :initialize__network_server, :initialize
  end
  
  NetworkServer.main($*) if $0 == __FILE__
end

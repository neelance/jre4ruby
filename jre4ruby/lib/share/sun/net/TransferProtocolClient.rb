require "rjava"

# Copyright 1994-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TransferProtocolClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Lang, :StringIndexOutOfBoundsException
      include ::Java::Io
      include_const ::Java::Util, :Vector
      include_const ::Sun::Net, :NetworkClient
    }
  end
  
  # This class implements that basic intefaces of transfer protocols.
  # It is used by subclasses implementing specific protocols.
  # 
  # @author      Jonathan Payne
  # @see         sun.net.ftp.FtpClient
  # @see         sun.net.nntp.NntpClient
  class TransferProtocolClient < TransferProtocolClientImports.const_get :NetworkClient
    include_class_members TransferProtocolClientImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
    }
    
    # Array of strings (usually 1 entry) for the last reply
    # from the server.
    attr_accessor :server_response
    alias_method :attr_server_response, :server_response
    undef_method :server_response
    alias_method :attr_server_response=, :server_response=
    undef_method :server_response=
    
    # code for last reply
    attr_accessor :last_reply_code
    alias_method :attr_last_reply_code, :last_reply_code
    undef_method :last_reply_code
    alias_method :attr_last_reply_code=, :last_reply_code=
    undef_method :last_reply_code=
    
    typesig { [] }
    # Pulls the response from the server and returns the code as a
    # number. Returns -1 on failure.
    def read_server_response
      reply_buf = StringBuffer.new(32)
      c = 0
      continuing_code = -1
      code = 0
      response = nil
      @server_response.set_size(0)
      while (true)
        while (!((c = self.attr_server_input.read)).equal?(-1))
          if ((c).equal?(Character.new(?\r.ord)))
            if (!((c = self.attr_server_input.read)).equal?(Character.new(?\n.ord)))
              reply_buf.append(Character.new(?\r.ord))
            end
          end
          reply_buf.append(RJava.cast_to_char(c))
          if ((c).equal?(Character.new(?\n.ord)))
            break
          end
        end
        response = RJava.cast_to_string(reply_buf.to_s)
        reply_buf.set_length(0)
        if (Debug)
          System.out.print(response)
        end
        if ((response.length).equal?(0))
          code = -1
        else
          begin
            code = JavaInteger.parse_int(response.substring(0, 3))
          rescue NumberFormatException => e
            code = -1
          rescue StringIndexOutOfBoundsException => e
            # this line doesn't contain a response code, so
            # we just completely ignore it
            next
          end
        end
        @server_response.add_element(response)
        if (!(continuing_code).equal?(-1))
          # we've seen a XXX- sequence
          if (!(code).equal?(continuing_code) || (response.length >= 4 && (response.char_at(3)).equal?(Character.new(?-.ord))))
            next
          else
            # seen the end of code sequence
            continuing_code = -1
            break
          end
        else
          if (response.length >= 4 && (response.char_at(3)).equal?(Character.new(?-.ord)))
            continuing_code = code
            next
          else
            break
          end
        end
      end
      return @last_reply_code = code
    end
    
    typesig { [String] }
    # Sends command <i>cmd</i> to the server.
    def send_server(cmd)
      self.attr_server_output.print(cmd)
      if (Debug)
        System.out.print("Sending: " + cmd)
      end
    end
    
    typesig { [] }
    # converts the server response into a string.
    def get_response_string
      return @server_response.element_at(0)
    end
    
    typesig { [] }
    # Returns all server response strings.
    def get_response_strings
      return @server_response
    end
    
    typesig { [String, ::Java::Int] }
    # standard constructor to host <i>host</i>, port <i>port</i>.
    def initialize(host, port)
      @server_response = nil
      @last_reply_code = 0
      super(host, port)
      @server_response = Vector.new(1)
    end
    
    typesig { [] }
    # creates an uninitialized instance of this class.
    def initialize
      @server_response = nil
      @last_reply_code = 0
      super()
      @server_response = Vector.new(1)
    end
    
    private
    alias_method :initialize__transfer_protocol_client, :initialize
  end
  
end

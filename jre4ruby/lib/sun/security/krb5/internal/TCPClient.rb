require "rjava"

# 
# Portions Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module TCPClientImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Java::Io
      include ::Java::Net
    }
  end
  
  class TCPClient 
    include_class_members TCPClientImports
    
    attr_accessor :tcp_socket
    alias_method :attr_tcp_socket, :tcp_socket
    undef_method :tcp_socket
    alias_method :attr_tcp_socket=, :tcp_socket=
    undef_method :tcp_socket=
    
    attr_accessor :out
    alias_method :attr_out, :out
    undef_method :out
    alias_method :attr_out=, :out=
    undef_method :out=
    
    attr_accessor :in
    alias_method :attr_in, :in
    undef_method :in
    alias_method :attr_in=, :in=
    undef_method :in=
    
    typesig { [String, ::Java::Int] }
    def initialize(hostname, port)
      @tcp_socket = nil
      @out = nil
      @in = nil
      @tcp_socket = Socket.new(hostname, port)
      @out = BufferedOutputStream.new(@tcp_socket.get_output_stream)
      @in = BufferedInputStream.new(@tcp_socket.get_input_stream)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def send(data)
      len_field = Array.typed(::Java::Byte).new(4) { 0 }
      int_to_network_byte_order(data.attr_length, len_field, 0, 4)
      @out.write(len_field)
      @out.write(data)
      @out.flush
    end
    
    typesig { [] }
    def receive
      len_field = Array.typed(::Java::Byte).new(4) { 0 }
      count = read_fully(len_field, 4)
      if (!(count).equal?(4))
        if (Krb5::DEBUG)
          System.out.println(">>>DEBUG: TCPClient could not read length field")
        end
        return nil
      end
      len = network_byte_order_to_int(len_field, 0, 4)
      if (Krb5::DEBUG)
        System.out.println(">>>DEBUG: TCPClient reading " + (len).to_s + " bytes")
      end
      if (len <= 0)
        if (Krb5::DEBUG)
          System.out.println(">>>DEBUG: TCPClient zero or negative length field: " + (len).to_s)
        end
        return nil
      end
      data = Array.typed(::Java::Byte).new(len) { 0 }
      count = read_fully(data, len)
      if (!(count).equal?(len))
        if (Krb5::DEBUG)
          System.out.println(">>>DEBUG: TCPClient could not read complete packet (" + (len).to_s + "/" + (count).to_s + ")")
        end
        return nil
      else
        return data
      end
    end
    
    typesig { [] }
    def close
      @tcp_socket.close
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # Read requested number of bytes before returning.
    # @return The number of bytes actually read; -1 if none read
    def read_fully(in_buf, total)
      count = 0
      pos = 0
      while (total > 0)
        count = @in.read(in_buf, pos, total)
        if ((count).equal?(-1))
          return ((pos).equal?(0) ? -1 : pos)
        end
        pos += count
        total -= count
      end
      return pos
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # 
      # Returns the integer represented by 4 bytes in network byte order.
      def network_byte_order_to_int(buf, start, count)
        if (count > 4)
          raise IllegalArgumentException.new("Cannot handle more than 4 bytes")
        end
        answer = 0
        i = 0
        while i < count
          answer <<= 8
          answer |= (RJava.cast_to_int(buf[start + i]) & 0xff)
          ((i += 1) - 1)
        end
        return answer
      end
      
      typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # 
      # Encodes an integer into 4 bytes in network byte order in the buffer
      # supplied.
      def int_to_network_byte_order(num, buf, start, count)
        if (count > 4)
          raise IllegalArgumentException.new("Cannot handle more than 4 bytes")
        end
        i = count - 1
        while i >= 0
          buf[start + i] = (num & 0xff)
          num >>= 8
          ((i -= 1) + 1)
        end
      end
    }
    
    private
    alias_method :initialize__tcpclient, :initialize
  end
  
end

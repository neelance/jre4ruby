require "rjava"

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
  module UDPClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Java::Io
      include ::Java::Net
    }
  end
  
  class UDPClient 
    include_class_members UDPClientImports
    
    attr_accessor :iaddr
    alias_method :attr_iaddr, :iaddr
    undef_method :iaddr
    alias_method :attr_iaddr=, :iaddr=
    undef_method :iaddr=
    
    attr_accessor :iport
    alias_method :attr_iport, :iport
    undef_method :iport
    alias_method :attr_iport=, :iport=
    undef_method :iport=
    
    attr_accessor :buf_size
    alias_method :attr_buf_size, :buf_size
    undef_method :buf_size
    alias_method :attr_buf_size=, :buf_size=
    undef_method :buf_size=
    
    attr_accessor :dg_socket
    alias_method :attr_dg_socket, :dg_socket
    undef_method :dg_socket
    alias_method :attr_dg_socket=, :dg_socket=
    undef_method :dg_socket=
    
    attr_accessor :dg_packet_in
    alias_method :attr_dg_packet_in, :dg_packet_in
    undef_method :dg_packet_in
    alias_method :attr_dg_packet_in=, :dg_packet_in=
    undef_method :dg_packet_in=
    
    typesig { [InetAddress, ::Java::Int] }
    def initialize(new_iaddr, port)
      @iaddr = nil
      @iport = 0
      @buf_size = 65507
      @dg_socket = nil
      @dg_packet_in = nil
      @iaddr = new_iaddr
      @iport = port
      @dg_socket = DatagramSocket.new
    end
    
    typesig { [String, ::Java::Int] }
    def initialize(hostname, port)
      @iaddr = nil
      @iport = 0
      @buf_size = 65507
      @dg_socket = nil
      @dg_packet_in = nil
      @iaddr = InetAddress.get_by_name(hostname)
      @iport = port
      @dg_socket = DatagramSocket.new
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def initialize(hostname, port, timeout)
      @iaddr = nil
      @iport = 0
      @buf_size = 65507
      @dg_socket = nil
      @dg_packet_in = nil
      @iaddr = InetAddress.get_by_name(hostname)
      @iport = port
      @dg_socket = DatagramSocket.new
      @dg_socket.set_so_timeout(timeout)
    end
    
    typesig { [::Java::Int] }
    def set_buf_size(new_buf_size)
      @buf_size = new_buf_size
    end
    
    typesig { [] }
    def get_inet_address
      if (!(@dg_packet_in).nil?)
        return @dg_packet_in.get_address
      end
      return nil
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def send(data)
      dg_packet_out = DatagramPacket.new(data, data.attr_length, @iaddr, @iport)
      @dg_socket.send(dg_packet_out)
    end
    
    typesig { [] }
    def receive
      ibuf = Array.typed(::Java::Byte).new(@buf_size) { 0 }
      @dg_packet_in = DatagramPacket.new(ibuf, ibuf.attr_length)
      begin
        @dg_socket.receive(@dg_packet_in)
      rescue SocketException => e
        @dg_socket.receive(@dg_packet_in)
      end
      data = Array.typed(::Java::Byte).new(@dg_packet_in.get_length) { 0 }
      System.arraycopy(@dg_packet_in.get_data, 0, data, 0, @dg_packet_in.get_length)
      return data
    end
    
    typesig { [] }
    def close
      @dg_socket.close
    end
    
    private
    alias_method :initialize__udpclient, :initialize
  end
  
end

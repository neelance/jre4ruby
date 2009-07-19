require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module AppOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # inherit no-op flush()
  # 
  # Output stream for application data. This is the kind of stream
  # that's handed out via SSLSocket.getOutputStream(). It's all the application
  # ever sees.
  # 
  # Once the initial handshake has completed, application data may be
  # interleaved with handshake data. That is handled internally and remains
  # transparent to the application.
  # 
  # @author  David Brownell
  class AppOutputStream < AppOutputStreamImports.const_get :OutputStream
    include_class_members AppOutputStreamImports
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    attr_accessor :r
    alias_method :attr_r, :r
    undef_method :r
    alias_method :attr_r=, :r=
    undef_method :r=
    
    # One element array used to implement the write(byte) method
    attr_accessor :one_byte
    alias_method :attr_one_byte, :one_byte
    undef_method :one_byte
    alias_method :attr_one_byte=, :one_byte=
    undef_method :one_byte=
    
    typesig { [SSLSocketImpl] }
    def initialize(conn)
      @c = nil
      @r = nil
      @one_byte = nil
      super()
      @one_byte = Array.typed(::Java::Byte).new(1) { 0 }
      @r = OutputRecord.new(Record.attr_ct_application_data)
      @c = conn
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Write the data out, NOW.
    def write(b, off, len)
      synchronized(self) do
        # check if the Socket is invalid (error or closed)
        @c.check_write
        # Always flush at the end of each application level record.
        # This lets application synchronize read and write streams
        # however they like; if we buffered here, they couldn't.
        # 
        # NOTE: *must* call c.writeRecord() even for len == 0
        begin
          begin
            howmuch = Math.min(len, @r.available_data_bytes)
            if (howmuch > 0)
              @r.write(b, off, howmuch)
              off += howmuch
              len -= howmuch
            end
            @c.write_record(@r)
            @c.check_write
          end while (len > 0)
        rescue Exception => e
          # shutdown and rethrow (wrapped) exception as appropriate
          @c.handle_exception(e)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Write one byte now.
    def write(i)
      synchronized(self) do
        @one_byte[0] = i
        write(@one_byte, 0, 1)
      end
    end
    
    typesig { [] }
    # Socket close is already synchronized, no need to block here.
    def close
      @c.close
    end
    
    private
    alias_method :initialize__app_output_stream, :initialize
  end
  
end

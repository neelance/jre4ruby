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
  module AppInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
    }
  end
  
  # inherit default mark/reset behavior (throw Exceptions) from InputStream
  # 
  # InputStream for application data as returned by SSLSocket.getInputStream().
  # It uses an InputRecord as internal buffer that is refilled on demand
  # whenever it runs out of data.
  # 
  # @author David Brownell
  class AppInputStream < AppInputStreamImports.const_get :InputStream
    include_class_members AppInputStreamImports
    
    class_module.module_eval {
      # static dummy array we use to implement skip()
      const_set_lazy(:SKIP_ARRAY) { Array.typed(::Java::Byte).new(1024) { 0 } }
      const_attr_reader  :SKIP_ARRAY
    }
    
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
    
    # One element array used to implement the single byte read() method
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
      @r = InputRecord.new
      @c = conn
    end
    
    typesig { [] }
    # Return the minimum number of bytes that can be read without blocking.
    # Currently not synchronized.
    def available
      if (@c.check_eof || ((@r.is_app_data_valid).equal?(false)))
        return 0
      end
      return @r.available
    end
    
    typesig { [] }
    # Read a single byte, returning -1 on non-fault EOF status.
    def read
      synchronized(self) do
        n = read(@one_byte, 0, 1)
        if (n <= 0)
          # EOF
          return -1
        end
        return @one_byte[0] & 0xff
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Read up to "len" bytes into this buffer, starting at "off".
    # If the layer above needs more data, it asks for more, so we
    # are responsible only for blocking to fill at most one buffer,
    # and returning "-1" on non-fault EOF status.
    def read(b, off, len)
      synchronized(self) do
        if (@c.check_eof)
          return -1
        end
        begin
          # Read data if needed ... notice that the connection guarantees
          # that handshake, alert, and change cipher spec data streams are
          # handled as they arrive, so we never see them here.
          while ((@r.available).equal?(0))
            @c.read_data_record(@r)
            if (@c.check_eof)
              return -1
            end
          end
          howmany = Math.min(len, @r.available)
          howmany = @r.read(b, off, howmany)
          return howmany
        rescue Exception => e
          # shutdown and rethrow (wrapped) exception as appropriate
          @c.handle_exception(e)
          # dummy for compiler
          return -1
        end
      end
    end
    
    typesig { [::Java::Long] }
    # Skip n bytes. This implementation is somewhat less efficient
    # than possible, but not badly so (redundant copy). We reuse
    # the read() code to keep things simpler. Note that SKIP_ARRAY
    # is static and may garbled by concurrent use, but we are not interested
    # in the data anyway.
    def skip(n)
      synchronized(self) do
        skipped = 0
        while (n > 0)
          len = RJava.cast_to_int(Math.min(n, SKIP_ARRAY.attr_length))
          r = read(SKIP_ARRAY, 0, len)
          if (r <= 0)
            break
          end
          n -= r
          skipped += r
        end
        return skipped
      end
    end
    
    typesig { [] }
    # Socket close is already synchronized, no need to block here.
    def close
      @c.close
    end
    
    private
    alias_method :initialize__app_input_stream, :initialize
  end
  
end

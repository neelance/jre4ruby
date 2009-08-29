require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Httpserver
  module LeftOverInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # a (filter) input stream which can tell us if bytes are "left over"
  # on the underlying stream which can be read (without blocking)
  # on another instance of this class.
  # 
  # The class can also report if all bytes "expected" to be read
  # were read, by the time close() was called. In that case,
  # bytes may be drained to consume them (by calling drain() ).
  # 
  # isEOF() returns true, when all expected bytes have been read
  class LeftOverInputStream < LeftOverInputStreamImports.const_get :FilterInputStream
    include_class_members LeftOverInputStreamImports
    
    attr_accessor :t
    alias_method :attr_t, :t
    undef_method :t
    alias_method :attr_t=, :t=
    undef_method :t=
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :eof
    alias_method :attr_eof, :eof
    undef_method :eof
    alias_method :attr_eof=, :eof=
    undef_method :eof=
    
    attr_accessor :one
    alias_method :attr_one, :one
    undef_method :one
    alias_method :attr_one=, :one=
    undef_method :one=
    
    typesig { [ExchangeImpl, InputStream] }
    def initialize(t, src)
      @t = nil
      @server = nil
      @closed = false
      @eof = false
      @one = nil
      super(src)
      @closed = false
      @eof = false
      @one = Array.typed(::Java::Byte).new(1) { 0 }
      @t = t
      @server = t.get_server_impl
    end
    
    typesig { [] }
    # if bytes are left over buffered on *the UNDERLYING* stream
    def is_data_buffered
      raise AssertError if not (@eof)
      return FilterInputStream.instance_method(:available).bind(self).call > 0
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      @closed = true
      if (!@eof)
        @eof = drain(ServerConfig.get_drain_amount)
      end
    end
    
    typesig { [] }
    def is_closed
      return @closed
    end
    
    typesig { [] }
    def is_eof
      return @eof
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read_impl(b, off, len)
      raise NotImplementedError
    end
    
    typesig { [] }
    def read
      synchronized(self) do
        if (@closed)
          raise IOException.new("Stream is closed")
        end
        c = read_impl(@one, 0, 1)
        if ((c).equal?(-1) || (c).equal?(0))
          return c
        else
          return @one[0] & 0xff
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read(b, off, len)
      synchronized(self) do
        if (@closed)
          raise IOException.new("Stream is closed")
        end
        return read_impl(b, off, len)
      end
    end
    
    typesig { [::Java::Long] }
    # read and discard up to l bytes or "eof" occurs,
    # (whichever is first). Then return true if the stream
    # is at eof (ie. all bytes were read) or false if not
    # (still bytes to be read)
    def drain(l)
      buf_size = 2048
      db = Array.typed(::Java::Byte).new(buf_size) { 0 }
      while (l > 0)
        len = read_impl(db, 0, buf_size)
        if ((len).equal?(-1))
          @eof = true
          return true
        else
          l = l - len
        end
      end
      return false
    end
    
    private
    alias_method :initialize__left_over_input_stream, :initialize
  end
  
end

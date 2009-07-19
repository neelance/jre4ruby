require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FixedLengthOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Net
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # flush is a pass-through
  # 
  # a class which allows the caller to write up to a defined
  # number of bytes to an underlying stream. The caller *must*
  # write the pre-defined number or else an exception will be thrown
  # and the whole request aborted.
  # normal close() does not close the underlying stream
  class FixedLengthOutputStream < FixedLengthOutputStreamImports.const_get :FilterOutputStream
    include_class_members FixedLengthOutputStreamImports
    
    attr_accessor :remaining
    alias_method :attr_remaining, :remaining
    undef_method :remaining
    alias_method :attr_remaining=, :remaining=
    undef_method :remaining=
    
    attr_accessor :eof
    alias_method :attr_eof, :eof
    undef_method :eof
    alias_method :attr_eof=, :eof=
    undef_method :eof=
    
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :t
    alias_method :attr_t, :t
    undef_method :t
    alias_method :attr_t=, :t=
    undef_method :t=
    
    typesig { [ExchangeImpl, OutputStream, ::Java::Long] }
    def initialize(t, src, len)
      @remaining = 0
      @eof = false
      @closed = false
      @t = nil
      super(src)
      @eof = false
      @closed = false
      @t = t
      @remaining = len
    end
    
    typesig { [::Java::Int] }
    def write(b)
      if (@closed)
        raise IOException.new("stream closed")
      end
      @eof = ((@remaining).equal?(0))
      if (@eof)
        raise StreamClosedException.new
      end
      self.attr_out.write(b)
      ((@remaining -= 1) + 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      if (@closed)
        raise IOException.new("stream closed")
      end
      @eof = ((@remaining).equal?(0))
      if (@eof)
        raise StreamClosedException.new
      end
      if (len > @remaining)
        # stream is still open, caller can retry
        raise IOException.new("too many bytes to write to stream")
      end
      self.attr_out.write(b, off, len)
      @remaining -= len
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      @closed = true
      if (@remaining > 0)
        @t.close
        raise IOException.new("insufficient bytes written to stream")
      end
      flush
      @eof = true
      is = @t.get_original_input_stream
      if (!is.is_closed)
        begin
          is.close
        rescue IOException => e
        end
      end
      e = WriteFinishedEvent.new(@t)
      @t.get_http_context.get_server_impl.add_event(e)
    end
    
    private
    alias_method :initialize__fixed_length_output_stream, :initialize
  end
  
end

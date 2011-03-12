require "rjava"

# Copyright 2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UndefLengthOutputStreamImports #:nodoc:
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
  # a class which allows the caller to write an indefinite
  # number of bytes to an underlying stream , but without using
  # chunked encoding. Used for http/1.0 clients only
  # The underlying connection needs to be closed afterwards.
  class UndefLengthOutputStream < UndefLengthOutputStreamImports.const_get :FilterOutputStream
    include_class_members UndefLengthOutputStreamImports
    
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
    
    typesig { [ExchangeImpl, OutputStream] }
    def initialize(t, src)
      @closed = false
      @t = nil
      super(src)
      @closed = false
      @t = t
    end
    
    typesig { [::Java::Int] }
    def write(b)
      if (@closed)
        raise IOException.new("stream closed")
      end
      self.attr_out.write(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      if (@closed)
        raise IOException.new("stream closed")
      end
      self.attr_out.write(b, off, len)
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      @closed = true
      flush
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
    alias_method :initialize__undef_length_output_stream, :initialize
  end
  
end

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
  module FixedLengthInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Net
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # a class which allows the caller to read up to a defined
  # number of bytes off an underlying stream
  # close() does not close the underlying stream
  class FixedLengthInputStream < FixedLengthInputStreamImports.const_get :LeftOverInputStream
    include_class_members FixedLengthInputStreamImports
    
    attr_accessor :remaining
    alias_method :attr_remaining, :remaining
    undef_method :remaining
    alias_method :attr_remaining=, :remaining=
    undef_method :remaining=
    
    typesig { [ExchangeImpl, InputStream, ::Java::Int] }
    def initialize(t, src, len)
      @remaining = 0
      super(t, src)
      @remaining = len
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read_impl(b, off, len)
      self.attr_eof = ((@remaining).equal?(0))
      if (self.attr_eof)
        return -1
      end
      if (len > @remaining)
        len = @remaining
      end
      n = self.attr_in.read(b, off, len)
      if (n > -1)
        @remaining -= n
      end
      return n
    end
    
    typesig { [] }
    def available
      if (self.attr_eof)
        return 0
      end
      n = self.attr_in.available
      return n < @remaining ? n : @remaining
    end
    
    typesig { [] }
    def mark_supported
      return false
    end
    
    typesig { [::Java::Int] }
    def mark(l)
    end
    
    typesig { [] }
    def reset
      raise IOException.new("mark/reset not supported")
    end
    
    private
    alias_method :initialize__fixed_length_input_stream, :initialize
  end
  
end

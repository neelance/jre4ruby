require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ChunkedInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Io
      include ::Java::Net
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class ChunkedInputStream < ChunkedInputStreamImports.const_get :LeftOverInputStream
    include_class_members ChunkedInputStreamImports
    
    typesig { [ExchangeImpl, InputStream] }
    def initialize(t, src)
      @remaining = 0
      @need_to_read_header = false
      super(t, src)
      @need_to_read_header = true
    end
    
    attr_accessor :remaining
    alias_method :attr_remaining, :remaining
    undef_method :remaining
    alias_method :attr_remaining=, :remaining=
    undef_method :remaining=
    
    # true when a chunk header needs to be read
    attr_accessor :need_to_read_header
    alias_method :attr_need_to_read_header, :need_to_read_header
    undef_method :need_to_read_header
    alias_method :attr_need_to_read_header=, :need_to_read_header=
    undef_method :need_to_read_header=
    
    class_module.module_eval {
      
      def cr
        defined?(@@cr) ? @@cr : @@cr= Character.new(?\r.ord)
      end
      alias_method :attr_cr, :cr
      
      def cr=(value)
        @@cr = value
      end
      alias_method :attr_cr=, :cr=
      
      
      def lf
        defined?(@@lf) ? @@lf : @@lf= Character.new(?\n.ord)
      end
      alias_method :attr_lf, :lf
      
      def lf=(value)
        @@lf = value
      end
      alias_method :attr_lf=, :lf=
    }
    
    typesig { [Array.typed(::Java::Char), ::Java::Int] }
    def numeric(arr, nchars)
      raise AssertError if not (arr.attr_length >= nchars)
      len = 0
      i = 0
      while i < nchars
        c = arr[i]
        val = 0
        if (c >= Character.new(?0.ord) && c <= Character.new(?9.ord))
          val = c - Character.new(?0.ord)
        else
          if (c >= Character.new(?a.ord) && c <= Character.new(?f.ord))
            val = c - Character.new(?a.ord) + 10
          else
            if (c >= Character.new(?A.ord) && c <= Character.new(?F.ord))
              val = c - Character.new(?A.ord) + 10
            else
              raise IOException.new("invalid chunk length")
            end
          end
        end
        len = len * 16 + val
        i += 1
      end
      return len
    end
    
    typesig { [] }
    # read the chunk header line and return the chunk length
    # any chunk extensions are ignored
    def read_chunk_header
      got_cr = false
      c = 0
      len_arr = CharArray.new(16)
      len_size = 0
      end_of_len = false
      while (!((c = RJava.cast_to_char(self.attr_in.read))).equal?(-1))
        if ((len_size).equal?(len_arr.attr_length - 1))
          raise IOException.new("invalid chunk header")
        end
        if (got_cr)
          if ((c).equal?(self.attr_lf))
            l = numeric(len_arr, len_size)
            return l
          else
            got_cr = false
          end
          if (!end_of_len)
            len_arr[((len_size += 1) - 1)] = c
          end
        else
          if ((c).equal?(self.attr_cr))
            got_cr = true
          else
            if ((c).equal?(Character.new(?;.ord)))
              end_of_len = true
            else
              if (!end_of_len)
                len_arr[((len_size += 1) - 1)] = c
              end
            end
          end
        end
      end
      raise IOException.new("end of stream reading chunk header")
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read_impl(b, off, len)
      if (self.attr_eof)
        return -1
      end
      if (@need_to_read_header)
        @remaining = read_chunk_header
        if ((@remaining).equal?(0))
          self.attr_eof = true
          consume_crlf
          return -1
        end
        @need_to_read_header = false
      end
      if (len > @remaining)
        len = @remaining
      end
      n = self.attr_in.read(b, off, len)
      if (n > -1)
        @remaining -= n
      end
      if ((@remaining).equal?(0))
        @need_to_read_header = true
        consume_crlf
      end
      return n
    end
    
    typesig { [] }
    def consume_crlf
      c = 0
      c = RJava.cast_to_char(self.attr_in.read) # CR
      if (!(c).equal?(self.attr_cr))
        raise IOException.new("invalid chunk end")
      end
      c = RJava.cast_to_char(self.attr_in.read) # LF
      if (!(c).equal?(self.attr_lf))
        raise IOException.new("invalid chunk end")
      end
    end
    
    typesig { [] }
    # returns the number of bytes available to read in the current chunk
    # which may be less than the real amount, but we'll live with that
    # limitation for the moment. It only affects potential efficiency
    # rather than correctness.
    def available
      if (self.attr_eof || self.attr_closed)
        return 0
      end
      n = self.attr_in.available
      return n > @remaining ? @remaining : n
    end
    
    typesig { [] }
    # called after the stream is closed to see if bytes
    # have been read from the underlying channel
    # and buffered internally
    def is_data_buffered
      raise AssertError if not (self.attr_eof)
      return self.attr_in.available > 0
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
    alias_method :initialize__chunked_input_stream, :initialize
  end
  
end

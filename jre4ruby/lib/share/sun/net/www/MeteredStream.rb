require "rjava"

# Copyright 1994-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www
  module MeteredStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Net, :URL
      include ::Java::Util
      include ::Java::Io
      include_const ::Sun::Net, :ProgressSource
      include_const ::Sun::Net::Www::Http, :ChunkedInputStream
    }
  end
  
  class MeteredStream < MeteredStreamImports.const_get :FilterInputStream
    include_class_members MeteredStreamImports
    
    # Instance variables.
    # if expected != -1, after we've read >= expected, we're "closed" and return -1
    # from subsequest read() 's
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    attr_accessor :expected
    alias_method :attr_expected, :expected
    undef_method :expected
    alias_method :attr_expected=, :expected=
    undef_method :expected=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    attr_accessor :marked_count
    alias_method :attr_marked_count, :marked_count
    undef_method :marked_count
    alias_method :attr_marked_count=, :marked_count=
    undef_method :marked_count=
    
    attr_accessor :mark_limit
    alias_method :attr_mark_limit, :mark_limit
    undef_method :mark_limit
    alias_method :attr_mark_limit=, :mark_limit=
    undef_method :mark_limit=
    
    attr_accessor :pi
    alias_method :attr_pi, :pi
    undef_method :pi
    alias_method :attr_pi=, :pi=
    undef_method :pi=
    
    typesig { [InputStream, ProgressSource, ::Java::Int] }
    def initialize(is, pi, expected)
      @closed = false
      @expected = 0
      @count = 0
      @marked_count = 0
      @mark_limit = 0
      @pi = nil
      super(is)
      @closed = false
      @count = 0
      @marked_count = 0
      @mark_limit = -1
      @pi = pi
      @expected = expected
      if (!(pi).nil?)
        pi.update_progress(0, expected)
      end
    end
    
    typesig { [::Java::Int] }
    def just_read(n)
      if ((n).equal?(-1))
        # don't close automatically when mark is set and is valid;
        # cannot reset() after close()
        if (!is_marked)
          close
        end
        return
      end
      @count += n
      # If read beyond the markLimit, invalidate the mark
      if (@count - @marked_count > @mark_limit)
        @mark_limit = -1
      end
      if (!(@pi).nil?)
        @pi.update_progress(@count, @expected)
      end
      if (is_marked)
        return
      end
      # if expected length is known, we could determine if
      # read overrun.
      if (@expected > 0)
        if (@count >= @expected)
          close
        end
      end
    end
    
    typesig { [] }
    # Returns true if the mark is valid, false otherwise
    def is_marked
      if (@mark_limit < 0)
        return false
      end
      # mark is set, but is not valid anymore
      if (@count - @marked_count > @mark_limit)
        return false
      end
      # mark still holds
      return true
    end
    
    typesig { [] }
    def read
      synchronized(self) do
        if (@closed)
          return -1
        end
        c = self.attr_in.read
        if (!(c).equal?(-1))
          just_read(1)
        else
          just_read(c)
        end
        return c
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def read(b, off, len)
      synchronized(self) do
        if (@closed)
          return -1
        end
        n = self.attr_in.read(b, off, len)
        just_read(n)
        return n
      end
    end
    
    typesig { [::Java::Long] }
    def skip(n)
      synchronized(self) do
        # REMIND: what does skip do on EOF????
        if (@closed)
          return 0
        end
        if (self.attr_in.is_a?(ChunkedInputStream))
          n = self.attr_in.skip(n)
        else
          # just skip min(n, num_bytes_left)
          min = (n > @expected - @count) ? @expected - @count : (n).to_int
          n = self.attr_in.skip(min)
        end
        just_read((n).to_int)
        return n
      end
    end
    
    typesig { [] }
    def close
      if (@closed)
        return
      end
      if (!(@pi).nil?)
        @pi.finish_tracking
      end
      @closed = true
      self.attr_in.close
    end
    
    typesig { [] }
    def available
      synchronized(self) do
        return @closed ? 0 : self.attr_in.available
      end
    end
    
    typesig { [::Java::Int] }
    def mark(read_limit)
      synchronized(self) do
        if (@closed)
          return
        end
        super(read_limit)
        # mark the count to restore upon reset
        @marked_count = @count
        @mark_limit = read_limit
      end
    end
    
    typesig { [] }
    def reset
      synchronized(self) do
        if (@closed)
          return
        end
        if (!is_marked)
          raise IOException.new("Resetting to an invalid mark")
        end
        @count = @marked_count
        super
      end
    end
    
    typesig { [] }
    def mark_supported
      if (@closed)
        return false
      end
      return super
    end
    
    typesig { [] }
    def finalize
      begin
        close
        if (!(@pi).nil?)
          @pi.close
        end
      ensure
        # Call super class
        super
      end
    end
    
    private
    alias_method :initialize__metered_stream, :initialize
  end
  
end

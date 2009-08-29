require "rjava"

# Copyright 2004-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EngineArgsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Javax::Net::Ssl
      include ::Java::Nio
    }
  end
  
  # A multi-purpose class which handles all of the SSLEngine arguments.
  # It validates arguments, checks for RO conditions, does space
  # calculations, performs scatter/gather, etc.
  # 
  # @author Brad R. Wetmore
  class EngineArgs 
    include_class_members EngineArgsImports
    
    # Keep track of the input parameters.
    attr_accessor :net_data
    alias_method :attr_net_data, :net_data
    undef_method :net_data
    alias_method :attr_net_data=, :net_data=
    undef_method :net_data=
    
    attr_accessor :app_data
    alias_method :attr_app_data, :app_data
    undef_method :app_data
    alias_method :attr_app_data=, :app_data=
    undef_method :app_data=
    
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    # offset/len for the appData array.
    attr_accessor :len
    alias_method :attr_len, :len
    undef_method :len
    alias_method :attr_len=, :len=
    undef_method :len=
    
    # The initial pos/limit conditions.  This is useful because we can
    # quickly calculate the amount consumed/produced in successful
    # operations, or easily return the buffers to their pre-error
    # conditions.
    attr_accessor :net_pos
    alias_method :attr_net_pos, :net_pos
    undef_method :net_pos
    alias_method :attr_net_pos=, :net_pos=
    undef_method :net_pos=
    
    attr_accessor :net_lim
    alias_method :attr_net_lim, :net_lim
    undef_method :net_lim
    alias_method :attr_net_lim=, :net_lim=
    undef_method :net_lim=
    
    attr_accessor :app_poss
    alias_method :attr_app_poss, :app_poss
    undef_method :app_poss
    alias_method :attr_app_poss=, :app_poss=
    undef_method :app_poss=
    
    attr_accessor :app_lims
    alias_method :attr_app_lims, :app_lims
    undef_method :app_lims
    alias_method :attr_app_lims=, :app_lims=
    undef_method :app_lims=
    
    # Sum total of the space remaining in all of the appData buffers
    attr_accessor :app_remaining
    alias_method :attr_app_remaining, :app_remaining
    undef_method :app_remaining
    alias_method :attr_app_remaining=, :app_remaining=
    undef_method :app_remaining=
    
    attr_accessor :wrap_method
    alias_method :attr_wrap_method, :wrap_method
    undef_method :wrap_method
    alias_method :attr_wrap_method=, :wrap_method=
    undef_method :wrap_method=
    
    typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int, ByteBuffer] }
    # Called by the SSLEngine.wrap() method.
    def initialize(app_data, offset, len, net_data)
      @net_data = nil
      @app_data = nil
      @offset = 0
      @len = 0
      @net_pos = 0
      @net_lim = 0
      @app_poss = nil
      @app_lims = nil
      @app_remaining = 0
      @wrap_method = false
      @wrap_method = true
      init(net_data, app_data, offset, len)
    end
    
    typesig { [ByteBuffer, Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # Called by the SSLEngine.unwrap() method.
    def initialize(net_data, app_data, offset, len)
      @net_data = nil
      @app_data = nil
      @offset = 0
      @len = 0
      @net_pos = 0
      @net_lim = 0
      @app_poss = nil
      @app_lims = nil
      @app_remaining = 0
      @wrap_method = false
      @wrap_method = false
      init(net_data, app_data, offset, len)
    end
    
    typesig { [ByteBuffer, Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
    # The main initialization method for the arguments.  Most
    # of them are pretty obvious as to what they do.
    # 
    # Since we're already iterating over appData array for validity
    # checking, we also keep track of how much remainging space is
    # available.  Info is used in both unwrap (to see if there is
    # enough space available in the destination), and in wrap (to
    # determine how much more we can copy into the outgoing data
    # buffer.
    def init(net_data, app_data, offset, len)
      if (((net_data).nil?) || ((app_data).nil?))
        raise IllegalArgumentException.new("src/dst is null")
      end
      if ((offset < 0) || (len < 0) || (offset > app_data.attr_length - len))
        raise IndexOutOfBoundsException.new
      end
      if (@wrap_method && net_data.is_read_only)
        raise ReadOnlyBufferException.new
      end
      @net_pos = net_data.position
      @net_lim = net_data.limit
      @app_poss = Array.typed(::Java::Int).new(app_data.attr_length) { 0 }
      @app_lims = Array.typed(::Java::Int).new(app_data.attr_length) { 0 }
      i = offset
      while i < offset + len
        if ((app_data[i]).nil?)
          raise IllegalArgumentException.new("appData[" + RJava.cast_to_string(i) + "] == null")
        end
        # If we're unwrapping, then check to make sure our
        # destination bufffers are writable.
        if (!@wrap_method && app_data[i].is_read_only)
          raise ReadOnlyBufferException.new
        end
        @app_remaining += app_data[i].remaining
        @app_poss[i] = app_data[i].position
        @app_lims[i] = app_data[i].limit
        i += 1
      end
      # Ok, looks like we have a good set of args, let's
      # store the rest of this stuff.
      @net_data = net_data
      @app_data = app_data
      @offset = offset
      @len = len
    end
    
    typesig { [::Java::Int] }
    # Given spaceLeft bytes to transfer, gather up that much data
    # from the appData buffers (starting at offset in the array),
    # and transfer it into the netData buffer.
    # 
    # The user has already ensured there is enough room.
    def gather(space_left)
      i = @offset
      while (i < (@offset + @len)) && (space_left > 0)
        amount = Math.min(@app_data[i].remaining, space_left)
        @app_data[i].limit(@app_data[i].position + amount)
        @net_data.put(@app_data[i])
        space_left -= amount
        i += 1
      end
    end
    
    typesig { [ByteBuffer] }
    # Using the supplied buffer, scatter the data into the appData buffers
    # (starting at offset in the array).
    # 
    # The user has already ensured there is enough room.
    def scatter(ready_data)
      amount_left = ready_data.remaining
      i = @offset
      while (i < (@offset + @len)) && (amount_left > 0)
        amount = Math.min(@app_data[i].remaining, amount_left)
        ready_data.limit(ready_data.position + amount)
        @app_data[i].put(ready_data)
        amount_left -= amount
        i += 1
      end
      raise AssertError if not (((ready_data.remaining).equal?(0)))
    end
    
    typesig { [] }
    def get_app_remaining
      return @app_remaining
    end
    
    typesig { [] }
    # Calculate the bytesConsumed/byteProduced.  Aren't you glad
    # we saved this off earlier?
    def delta_net
      return (@net_data.position - @net_pos)
    end
    
    typesig { [] }
    # Calculate the bytesConsumed/byteProduced.  Aren't you glad
    # we saved this off earlier?
    def delta_app
      sum = 0 # Only calculating 2^14 here, don't need a long.
      i = @offset
      while i < @offset + @len
        sum += @app_data[i].position - @app_poss[i]
        i += 1
      end
      return sum
    end
    
    typesig { [] }
    # In the case of Exception, we want to reset the positions
    # to appear as though no data has been consumed or produced.
    def reset_pos
      @net_data.position(@net_pos)
      i = @offset
      while i < @offset + @len
        @app_data[i].position(@app_poss[i])
        i += 1
      end
    end
    
    typesig { [] }
    # We are doing lots of ByteBuffer manipulations, in which case
    # we need to make sure that the limits get set back correctly.
    # This is one of the last things to get done before returning to
    # the user.
    def reset_lim
      @net_data.limit(@net_lim)
      i = @offset
      while i < @offset + @len
        @app_data[i].limit(@app_lims[i])
        i += 1
      end
    end
    
    private
    alias_method :initialize__engine_args, :initialize
  end
  
end

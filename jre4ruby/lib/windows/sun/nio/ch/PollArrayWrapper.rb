require "rjava"

# Copyright 2001-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module PollArrayWrapperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
    }
  end
  
  # Manipulates a native array of structs corresponding to (fd, events) pairs.
  # 
  # typedef struct pollfd {
  # SOCKET fd;            // 4 bytes
  # short events;         // 2 bytes
  # } pollfd_t;
  # 
  # @author Konstantin Kladko
  # @author Mike McCloskey
  class PollArrayWrapper 
    include_class_members PollArrayWrapperImports
    
    attr_accessor :poll_array
    alias_method :attr_poll_array, :poll_array
    undef_method :poll_array
    alias_method :attr_poll_array=, :poll_array=
    undef_method :poll_array=
    
    # The fd array
    attr_accessor :poll_array_address
    alias_method :attr_poll_array_address, :poll_array_address
    undef_method :poll_array_address
    alias_method :attr_poll_array_address=, :poll_array_address=
    undef_method :poll_array_address=
    
    class_module.module_eval {
      # pollArrayAddress
      const_set_lazy(:FD_OFFSET) { 0 }
      const_attr_reader  :FD_OFFSET
      
      # fd offset in pollfd
      const_set_lazy(:EVENT_OFFSET) { 4 }
      const_attr_reader  :EVENT_OFFSET
      
      # events offset in pollfd
      
      def size_pollfd
        defined?(@@size_pollfd) ? @@size_pollfd : @@size_pollfd= 8
      end
      alias_method :attr_size_pollfd, :size_pollfd
      
      def size_pollfd=(value)
        @@size_pollfd = value
      end
      alias_method :attr_size_pollfd=, :size_pollfd=
      
      # sizeof pollfd struct
      # events masks
      const_set_lazy(:POLLIN) { AbstractPollArrayWrapper::POLLIN }
      const_attr_reader  :POLLIN
      
      const_set_lazy(:POLLOUT) { AbstractPollArrayWrapper::POLLOUT }
      const_attr_reader  :POLLOUT
      
      const_set_lazy(:POLLERR) { AbstractPollArrayWrapper::POLLERR }
      const_attr_reader  :POLLERR
      
      const_set_lazy(:POLLHUP) { AbstractPollArrayWrapper::POLLHUP }
      const_attr_reader  :POLLHUP
      
      const_set_lazy(:POLLNVAL) { AbstractPollArrayWrapper::POLLNVAL }
      const_attr_reader  :POLLNVAL
      
      const_set_lazy(:POLLREMOVE) { AbstractPollArrayWrapper::POLLREMOVE }
      const_attr_reader  :POLLREMOVE
      
      const_set_lazy(:POLLCONN) { 0x2 }
      const_attr_reader  :POLLCONN
    }
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [::Java::Int] }
    # Size of the pollArray
    def initialize(new_size)
      @poll_array = nil
      @poll_array_address = 0
      @size = 0
      allocation_size = new_size * self.attr_size_pollfd
      @poll_array = AllocatedNativeObject.new(allocation_size, true)
      @poll_array_address = @poll_array.address
      @size = new_size
    end
    
    typesig { [::Java::Int, SelectionKeyImpl] }
    # Prepare another pollfd struct for use.
    def add_entry(index, ski)
      put_descriptor(index, ski.attr_channel.get_fdval)
    end
    
    typesig { [PollArrayWrapper, ::Java::Int, PollArrayWrapper, ::Java::Int] }
    # Writes the pollfd entry from the source wrapper at the source index
    # over the entry in the target wrapper at the target index.
    def replace_entry(source, sindex, target, tindex)
      target.put_descriptor(tindex, source.get_descriptor(sindex))
      target.put_event_ops(tindex, source.get_event_ops(sindex))
    end
    
    typesig { [::Java::Int] }
    # Grows the pollfd array to new size
    def grow(new_size)
      temp = PollArrayWrapper.new(new_size)
      i = 0
      while i < @size
        replace_entry(self, i, temp, i)
        i += 1
      end
      @poll_array.free
      @poll_array = temp.attr_poll_array
      @size = temp.attr_size
      @poll_array_address = @poll_array.address
    end
    
    typesig { [] }
    def free
      @poll_array.free
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Access methods for fd structures
    def put_descriptor(i, fd)
      @poll_array.put_int(self.attr_size_pollfd * i + FD_OFFSET, fd)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_event_ops(i, event)
      @poll_array.put_short(self.attr_size_pollfd * i + EVENT_OFFSET, RJava.cast_to_short(event))
    end
    
    typesig { [::Java::Int] }
    def get_event_ops(i)
      return @poll_array.get_short(self.attr_size_pollfd * i + EVENT_OFFSET)
    end
    
    typesig { [::Java::Int] }
    def get_descriptor(i)
      return @poll_array.get_int(self.attr_size_pollfd * i + FD_OFFSET)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds Windows wakeup socket at a given index.
    def add_wakeup_socket(fd_val, index)
      put_descriptor(index, fd_val)
      put_event_ops(index, POLLIN)
    end
    
    private
    alias_method :initialize__poll_array_wrapper, :initialize
  end
  
end

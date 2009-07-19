require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AbstractPollArrayWrapperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Sun::Misc
    }
  end
  
  # Manipulates a native array of pollfd structs.
  # 
  # @author Mike McCloskey
  # @since 1.4
  class AbstractPollArrayWrapper 
    include_class_members AbstractPollArrayWrapperImports
    
    class_module.module_eval {
      # Event masks
      const_set_lazy(:POLLIN) { 0x1 }
      const_attr_reader  :POLLIN
      
      const_set_lazy(:POLLOUT) { 0x4 }
      const_attr_reader  :POLLOUT
      
      const_set_lazy(:POLLERR) { 0x8 }
      const_attr_reader  :POLLERR
      
      const_set_lazy(:POLLHUP) { 0x10 }
      const_attr_reader  :POLLHUP
      
      const_set_lazy(:POLLNVAL) { 0x20 }
      const_attr_reader  :POLLNVAL
      
      const_set_lazy(:POLLREMOVE) { 0x800 }
      const_attr_reader  :POLLREMOVE
      
      # Miscellaneous constants
      const_set_lazy(:SIZE_POLLFD) { 8 }
      const_attr_reader  :SIZE_POLLFD
      
      const_set_lazy(:FD_OFFSET) { 0 }
      const_attr_reader  :FD_OFFSET
      
      const_set_lazy(:EVENT_OFFSET) { 4 }
      const_attr_reader  :EVENT_OFFSET
      
      const_set_lazy(:REVENT_OFFSET) { 6 }
      const_attr_reader  :REVENT_OFFSET
    }
    
    # The poll fd array
    attr_accessor :poll_array
    alias_method :attr_poll_array, :poll_array
    undef_method :poll_array
    alias_method :attr_poll_array=, :poll_array=
    undef_method :poll_array=
    
    # Number of valid entries in the pollArray
    attr_accessor :total_channels
    alias_method :attr_total_channels, :total_channels
    undef_method :total_channels
    alias_method :attr_total_channels=, :total_channels=
    undef_method :total_channels=
    
    # Base address of the native pollArray
    attr_accessor :poll_array_address
    alias_method :attr_poll_array_address, :poll_array_address
    undef_method :poll_array_address
    alias_method :attr_poll_array_address=, :poll_array_address=
    undef_method :poll_array_address=
    
    typesig { [::Java::Int] }
    # Access methods for fd structures
    def get_event_ops(i)
      offset = SIZE_POLLFD * i + EVENT_OFFSET
      return @poll_array.get_short(offset)
    end
    
    typesig { [::Java::Int] }
    def get_revent_ops(i)
      offset = SIZE_POLLFD * i + REVENT_OFFSET
      return @poll_array.get_short(offset)
    end
    
    typesig { [::Java::Int] }
    def get_descriptor(i)
      offset = SIZE_POLLFD * i + FD_OFFSET
      return @poll_array.get_int(offset)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_event_ops(i, event)
      offset = SIZE_POLLFD * i + EVENT_OFFSET
      @poll_array.put_short(offset, RJava.cast_to_short(event))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_revent_ops(i, revent)
      offset = SIZE_POLLFD * i + REVENT_OFFSET
      @poll_array.put_short(offset, RJava.cast_to_short(revent))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_descriptor(i, fd)
      offset = SIZE_POLLFD * i + FD_OFFSET
      @poll_array.put_int(offset, fd)
    end
    
    typesig { [] }
    def initialize
      @poll_array = nil
      @total_channels = 0
      @poll_array_address = 0
    end
    
    private
    alias_method :initialize__abstract_poll_array_wrapper, :initialize
  end
  
end

require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NativeDispatcherImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
    }
  end
  
  # Allows different platforms to call different native methods
  # for read and write operations.
  class NativeDispatcher 
    include_class_members NativeDispatcherImports
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def read(fd, address, len)
      raise NotImplementedError
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int, ::Java::Long, Object] }
    def pread(fd, address, len, position, lock)
      raise IOException.new("Operation Unsupported")
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def readv(fd, address, len)
      raise NotImplementedError
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def write(fd, address, len)
      raise NotImplementedError
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int, ::Java::Long, Object] }
    def pwrite(fd, address, len, position, lock)
      raise IOException.new("Operation Unsupported")
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def writev(fd, address, len)
      raise NotImplementedError
    end
    
    typesig { [FileDescriptor] }
    def close(fd)
      raise NotImplementedError
    end
    
    typesig { [FileDescriptor] }
    # Prepare the given fd for closing by duping it to a known internal fd
    # that's already closed.  This is necessary on some operating systems
    # (Solaris and Linux) to prevent fd recycling.
    # 
    def pre_close(fd)
      # Do nothing by default; this is only needed on Unix
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__native_dispatcher, :initialize
  end
  
end

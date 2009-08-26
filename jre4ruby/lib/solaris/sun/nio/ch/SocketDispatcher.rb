require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SocketDispatcherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
    }
  end
  
  # Allows different platforms to call different native methods
  # for read and write operations.
  class SocketDispatcher < SocketDispatcherImports.const_get :NativeDispatcher
    include_class_members SocketDispatcherImports
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def read(fd, address, len)
      return FileDispatcher.read0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def readv(fd, address, len)
      return FileDispatcher.readv0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def write(fd, address, len)
      return FileDispatcher.write0(fd, address, len)
    end
    
    typesig { [FileDescriptor, ::Java::Long, ::Java::Int] }
    def writev(fd, address, len)
      return FileDispatcher.writev0(fd, address, len)
    end
    
    typesig { [FileDescriptor] }
    def close(fd)
      FileDispatcher.close0(fd)
    end
    
    typesig { [FileDescriptor] }
    def pre_close(fd)
      FileDispatcher.pre_close0(fd)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__socket_dispatcher, :initialize
  end
  
end
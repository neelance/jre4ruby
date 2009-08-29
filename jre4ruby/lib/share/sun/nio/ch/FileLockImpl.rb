require "rjava"

# Copyright 2001-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileLockImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio::Channels, :ClosedChannelException
      include_const ::Java::Nio::Channels, :FileLock
      include_const ::Java::Nio::Channels, :FileChannel
    }
  end
  
  class FileLockImpl < FileLockImplImports.const_get :FileLock
    include_class_members FileLockImplImports
    
    attr_accessor :valid
    alias_method :attr_valid, :valid
    undef_method :valid
    alias_method :attr_valid=, :valid=
    undef_method :valid=
    
    typesig { [FileChannel, ::Java::Long, ::Java::Long, ::Java::Boolean] }
    def initialize(channel, position, size, shared)
      @valid = false
      super(channel, position, size, shared)
      @valid = true
    end
    
    typesig { [] }
    def is_valid
      synchronized(self) do
        return @valid
      end
    end
    
    typesig { [] }
    def invalidate
      synchronized(self) do
        @valid = false
      end
    end
    
    typesig { [] }
    def release
      synchronized(self) do
        if (!channel.is_open)
          raise ClosedChannelException.new
        end
        if (@valid)
          (channel).release(self)
          @valid = false
        end
      end
    end
    
    private
    alias_method :initialize__file_lock_impl, :initialize
  end
  
end

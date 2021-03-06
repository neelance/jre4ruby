require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Channels
  module ChannelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Closeable
    }
  end
  
  # A nexus for I/O operations.
  # 
  # <p> A channel represents an open connection to an entity such as a hardware
  # device, a file, a network socket, or a program component that is capable of
  # performing one or more distinct I/O operations, for example reading or
  # writing.
  # 
  # <p> A channel is either open or closed.  A channel is open upon creation,
  # and once closed it remains closed.  Once a channel is closed, any attempt to
  # invoke an I/O operation upon it will cause a {@link ClosedChannelException}
  # to be thrown.  Whether or not a channel is open may be tested by invoking
  # its {@link #isOpen isOpen} method.
  # 
  # <p> Channels are, in general, intended to be safe for multithreaded access
  # as described in the specifications of the interfaces and classes that extend
  # and implement this interface.
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  module Channel
    include_class_members ChannelImports
    include Closeable
    
    typesig { [] }
    # Tells whether or not this channel is open.  </p>
    # 
    # @return <tt>true</tt> if, and only if, this channel is open
    def is_open
      raise NotImplementedError
    end
    
    typesig { [] }
    # Closes this channel.
    # 
    # <p> After a channel is closed, any further attempt to invoke I/O
    # operations upon it will cause a {@link ClosedChannelException} to be
    # thrown.
    # 
    # <p> If this channel is already closed then invoking this method has no
    # effect.
    # 
    # <p> This method may be invoked at any time.  If some other thread has
    # already invoked it, however, then another invocation will block until
    # the first invocation is complete, after which it will return without
    # effect. </p>
    # 
    # @throws  IOException  If an I/O error occurs
    def close
      raise NotImplementedError
    end
  end
  
end

require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PipeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :IOException
      include ::Java::Nio::Channels::Spi
    }
  end
  
  # A pair of channels that implements a unidirectional pipe.
  # 
  # <p> A pipe consists of a pair of channels: A writable {@link
  # Pipe.SinkChannel </code>sink<code>} channel and a readable {@link
  # Pipe.SourceChannel </code>source<code>} channel.  Once some bytes are
  # written to the sink channel they can be read from source channel in exactly
  # the order in which they were written.
  # 
  # <p> Whether or not a thread writing bytes to a pipe will block until another
  # thread reads those bytes, or some previously-written bytes, from the pipe is
  # system-dependent and therefore unspecified.  Many pipe implementations will
  # buffer up to a certain number of bytes between the sink and source channels,
  # but such buffering should not be assumed.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class Pipe 
    include_class_members PipeImports
    
    class_module.module_eval {
      # A channel representing the readable end of a {@link Pipe}.  </p>
      # 
      # @since 1.4
      const_set_lazy(:SourceChannel) { Class.new(AbstractSelectableChannel) do
        include_class_members Pipe
        overload_protected {
          include ReadableByteChannel
          include ScatteringByteChannel
        }
        
        typesig { [self::SelectorProvider] }
        # Constructs a new instance of this class.
        def initialize(provider)
          super(provider)
        end
        
        typesig { [] }
        # Returns an operation set identifying this channel's supported
        # operations.
        # 
        # <p> Pipe-source channels only support reading, so this method
        # returns {@link SelectionKey#OP_READ}.  </p>
        # 
        # @return  The valid-operation set
        def valid_ops
          return SelectionKey::OP_READ
        end
        
        private
        alias_method :initialize__source_channel, :initialize
      end }
      
      # A channel representing the writable end of a {@link Pipe}.  </p>
      # 
      # @since 1.4
      const_set_lazy(:SinkChannel) { Class.new(AbstractSelectableChannel) do
        include_class_members Pipe
        overload_protected {
          include WritableByteChannel
          include GatheringByteChannel
        }
        
        typesig { [self::SelectorProvider] }
        # Initializes a new instance of this class.
        def initialize(provider)
          super(provider)
        end
        
        typesig { [] }
        # Returns an operation set identifying this channel's supported
        # operations.
        # 
        # <p> Pipe-sink channels only support writing, so this method returns
        # {@link SelectionKey#OP_WRITE}.  </p>
        # 
        # @return  The valid-operation set
        def valid_ops
          return SelectionKey::OP_WRITE
        end
        
        private
        alias_method :initialize__sink_channel, :initialize
      end }
    }
    
    typesig { [] }
    # Initializes a new instance of this class.
    def initialize
    end
    
    typesig { [] }
    # Returns this pipe's source channel.  </p>
    # 
    # @return  This pipe's source channel
    def source
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this pipe's sink channel.  </p>
    # 
    # @return  This pipe's sink channel
    def sink
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [] }
      # Opens a pipe.
      # 
      # <p> The new pipe is created by invoking the {@link
      # java.nio.channels.spi.SelectorProvider#openPipe openPipe} method of the
      # system-wide default {@link java.nio.channels.spi.SelectorProvider}
      # object.  </p>
      # 
      # @return  A new pipe
      # 
      # @throws  IOException
      # If an I/O error occurs
      def open
        return SelectorProvider.provider.open_pipe
      end
    }
    
    private
    alias_method :initialize__pipe, :initialize
  end
  
end

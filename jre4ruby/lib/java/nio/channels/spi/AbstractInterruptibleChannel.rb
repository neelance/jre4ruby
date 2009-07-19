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
module Java::Nio::Channels::Spi
  module AbstractInterruptibleChannelImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include ::Java::Nio::Channels
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Nio::Ch, :Interruptible
    }
  end
  
  # Base implementation class for interruptible channels.
  # 
  # <p> This class encapsulates the low-level machinery required to implement
  # the asynchronous closing and interruption of channels.  A concrete channel
  # class must invoke the {@link #begin begin} and {@link #end end} methods
  # before and after, respectively, invoking an I/O operation that might block
  # indefinitely.  In order to ensure that the {@link #end end} method is always
  # invoked, these methods should be used within a
  # <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block: <a name="be">
  # 
  # <blockquote><pre>
  # boolean completed = false;
  # try {
  # begin();
  # completed = ...;    // Perform blocking I/O operation
  # return ...;         // Return result
  # } finally {
  # end(completed);
  # }</pre></blockquote>
  # 
  # <p> The <tt>completed</tt> argument to the {@link #end end} method tells
  # whether or not the I/O operation actually completed, that is, whether it had
  # any effect that would be visible to the invoker.  In the case of an
  # operation that reads bytes, for example, this argument should be
  # <tt>true</tt> if, and only if, some bytes were actually transferred into the
  # invoker's target buffer.
  # 
  # <p> A concrete channel class must also implement the {@link
  # #implCloseChannel implCloseChannel} method in such a way that if it is
  # invoked while another thread is blocked in a native I/O operation upon the
  # channel then that operation will immediately return, either by throwing an
  # exception or by returning normally.  If a thread is interrupted or the
  # channel upon which it is blocked is asynchronously closed then the channel's
  # {@link #end end} method will throw the appropriate exception.
  # 
  # <p> This class performs the synchronization required to implement the {@link
  # java.nio.channels.Channel} specification.  Implementations of the {@link
  # #implCloseChannel implCloseChannel} method need not synchronize against
  # other threads that might be attempting to close the channel.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class AbstractInterruptibleChannel 
    include_class_members AbstractInterruptibleChannelImports
    include Channel
    include InterruptibleChannel
    
    attr_accessor :close_lock
    alias_method :attr_close_lock, :close_lock
    undef_method :close_lock
    alias_method :attr_close_lock=, :close_lock=
    undef_method :close_lock=
    
    attr_accessor :open
    alias_method :attr_open, :open
    undef_method :open
    alias_method :attr_open=, :open=
    undef_method :open=
    
    typesig { [] }
    # Initializes a new instance of this class.
    def initialize
      @close_lock = Object.new
      @open = true
      @interruptor = nil
      @interrupted = false
    end
    
    typesig { [] }
    # Closes this channel.
    # 
    # <p> If the channel has already been closed then this method returns
    # immediately.  Otherwise it marks the channel as closed and then invokes
    # the {@link #implCloseChannel implCloseChannel} method in order to
    # complete the close operation.  </p>
    # 
    # @throws  IOException
    # If an I/O error occurs
    def close
      synchronized((@close_lock)) do
        if (!@open)
          return
        end
        @open = false
        impl_close_channel
      end
    end
    
    typesig { [] }
    # Closes this channel.
    # 
    # <p> This method is invoked by the {@link #close close} method in order
    # to perform the actual work of closing the channel.  This method is only
    # invoked if the channel has not yet been closed, and it is never invoked
    # more than once.
    # 
    # <p> An implementation of this method must arrange for any other thread
    # that is blocked in an I/O operation upon this channel to return
    # immediately, either by throwing an exception or by returning normally.
    # </p>
    # 
    # @throws  IOException
    # If an I/O error occurs while closing the channel
    def impl_close_channel
      raise NotImplementedError
    end
    
    typesig { [] }
    def is_open
      return @open
    end
    
    # -- Interruption machinery --
    attr_accessor :interruptor
    alias_method :attr_interruptor, :interruptor
    undef_method :interruptor
    alias_method :attr_interruptor=, :interruptor=
    undef_method :interruptor=
    
    attr_accessor :interrupted
    alias_method :attr_interrupted, :interrupted
    undef_method :interrupted
    alias_method :attr_interrupted=, :interrupted=
    undef_method :interrupted=
    
    typesig { [] }
    # Marks the beginning of an I/O operation that might block indefinitely.
    # 
    # <p> This method should be invoked in tandem with the {@link #end end}
    # method, using a <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block as
    # shown <a href="#be">above</a>, in order to implement asynchronous
    # closing and interruption for this channel.  </p>
    def begin
      if ((@interruptor).nil?)
        @interruptor = Class.new(Interruptible.class == Class ? Interruptible : Object) do
          extend LocalClass
          include_class_members AbstractInterruptibleChannel
          include Interruptible if Interruptible.class == Module
          
          typesig { [] }
          define_method :interrupt do
            synchronized((self.attr_close_lock)) do
              if (!self.attr_open)
                return
              end
              self.attr_interrupted = true
              self.attr_open = false
              begin
                @local_class_parent.impl_close_channel
              rescue IOException => x
              end
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      blocked_on(@interruptor)
      if (JavaThread.current_thread.is_interrupted)
        @interruptor.interrupt
      end
    end
    
    typesig { [::Java::Boolean] }
    # Marks the end of an I/O operation that might block indefinitely.
    # 
    # <p> This method should be invoked in tandem with the {@link #begin
    # begin} method, using a <tt>try</tt>&nbsp;...&nbsp;<tt>finally</tt> block
    # as shown <a href="#be">above</a>, in order to implement asynchronous
    # closing and interruption for this channel.  </p>
    # 
    # @param  completed
    # <tt>true</tt> if, and only if, the I/O operation completed
    # successfully, that is, had some effect that would be visible to
    # the operation's invoker
    # 
    # @throws  AsynchronousCloseException
    # If the channel was asynchronously closed
    # 
    # @throws  ClosedByInterruptException
    # If the thread blocked in the I/O operation was interrupted
    def end(completed)
      blocked_on(nil)
      if (completed)
        @interrupted = false
        return
      end
      if (@interrupted)
        raise ClosedByInterruptException.new
      end
      if (!@open)
        raise AsynchronousCloseException.new
      end
    end
    
    class_module.module_eval {
      typesig { [Interruptible] }
      # -- sun.misc.SharedSecrets --
      def blocked_on(intr)
        # package-private
        Sun::Misc::SharedSecrets.get_java_lang_access.blocked_on(JavaThread.current_thread, intr)
      end
    }
    
    private
    alias_method :initialize__abstract_interruptible_channel, :initialize
  end
  
end

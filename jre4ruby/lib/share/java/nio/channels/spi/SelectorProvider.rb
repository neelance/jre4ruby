require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SelectorProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :ServerSocket
      include_const ::Java::Net, :Socket
      include ::Java::Nio::Channels
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :ServiceLoader
      include_const ::Java::Util, :ServiceConfigurationError
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Service-provider class for selectors and selectable channels.
  # 
  # <p> A selector provider is a concrete subclass of this class that has a
  # zero-argument constructor and implements the abstract methods specified
  # below.  A given invocation of the Java virtual machine maintains a single
  # system-wide default provider instance, which is returned by the {@link
  # #provider() provider} method.  The first invocation of that method will locate
  # the default provider as specified below.
  # 
  # <p> The system-wide default provider is used by the static <tt>open</tt>
  # methods of the {@link java.nio.channels.DatagramChannel#open
  # DatagramChannel}, {@link java.nio.channels.Pipe#open Pipe}, {@link
  # java.nio.channels.Selector#open Selector}, {@link
  # java.nio.channels.ServerSocketChannel#open ServerSocketChannel}, and {@link
  # java.nio.channels.SocketChannel#open SocketChannel} classes.  It is also
  # used by the {@link java.lang.System#inheritedChannel System.inheritedChannel()}
  # method. A program may make use of a provider other than the default provider
  # by instantiating that provider and then directly invoking the <tt>open</tt>
  # methods defined in this class.
  # 
  # <p> All of the methods in this class are safe for use by multiple concurrent
  # threads.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class SelectorProvider 
    include_class_members SelectorProviderImports
    
    class_module.module_eval {
      const_set_lazy(:Lock) { Object.new }
      const_attr_reader  :Lock
      
      
      def provider
        defined?(@@provider) ? @@provider : @@provider= nil
      end
      alias_method :attr_provider, :provider
      
      def provider=(value)
        @@provider = value
      end
      alias_method :attr_provider=, :provider=
    }
    
    typesig { [] }
    # Initializes a new instance of this class.  </p>
    # 
    # @throws  SecurityException
    # If a security manager has been installed and it denies
    # {@link RuntimePermission}<tt>("selectorProvider")</tt>
    def initialize
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(RuntimePermission.new("selectorProvider"))
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      def load_provider_from_property
        cn = System.get_property("java.nio.channels.spi.SelectorProvider")
        if ((cn).nil?)
          return false
        end
        begin
          c = Class.for_name(cn, true, ClassLoader.get_system_class_loader)
          self.attr_provider = c.new_instance
          return true
        rescue ClassNotFoundException => x
          raise ServiceConfigurationError.new(nil, x)
        rescue IllegalAccessException => x
          raise ServiceConfigurationError.new(nil, x)
        rescue InstantiationException => x
          raise ServiceConfigurationError.new(nil, x)
        rescue SecurityException => x
          raise ServiceConfigurationError.new(nil, x)
        end
      end
      
      typesig { [] }
      def load_provider_as_service
        sl = ServiceLoader.load(SelectorProvider, ClassLoader.get_system_class_loader)
        i = sl.iterator
        loop do
          begin
            if (!i.has_next)
              return false
            end
            self.attr_provider = i.next_
            return true
          rescue ServiceConfigurationError => sce
            if (sce.get_cause.is_a?(SecurityException))
              # Ignore the security exception, try the next provider
              next
            end
            raise sce
          end
        end
      end
      
      typesig { [] }
      # Returns the system-wide default selector provider for this invocation of
      # the Java virtual machine.
      # 
      # <p> The first invocation of this method locates the default provider
      # object as follows: </p>
      # 
      # <ol>
      # 
      # <li><p> If the system property
      # <tt>java.nio.channels.spi.SelectorProvider</tt> is defined then it is
      # taken to be the fully-qualified name of a concrete provider class.
      # The class is loaded and instantiated; if this process fails then an
      # unspecified error is thrown.  </p></li>
      # 
      # <li><p> If a provider class has been installed in a jar file that is
      # visible to the system class loader, and that jar file contains a
      # provider-configuration file named
      # <tt>java.nio.channels.spi.SelectorProvider</tt> in the resource
      # directory <tt>META-INF/services</tt>, then the first class name
      # specified in that file is taken.  The class is loaded and
      # instantiated; if this process fails then an unspecified error is
      # thrown.  </p></li>
      # 
      # <li><p> Finally, if no provider has been specified by any of the above
      # means then the system-default provider class is instantiated and the
      # result is returned.  </p></li>
      # 
      # </ol>
      # 
      # <p> Subsequent invocations of this method return the provider that was
      # returned by the first invocation.  </p>
      # 
      # @return  The system-wide default selector provider
      def provider
        synchronized((Lock)) do
          if (!(self.attr_provider).nil?)
            return self.attr_provider
          end
          return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members SelectorProvider
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              if (load_provider_from_property)
                return self.attr_provider
              end
              if (load_provider_as_service)
                return self.attr_provider
              end
              self.attr_provider = Sun::Nio::Ch::DefaultSelectorProvider.create
              return self.attr_provider
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    }
    
    typesig { [] }
    # Opens a datagram channel.  </p>
    # 
    # @return  The new channel
    def open_datagram_channel
      raise NotImplementedError
    end
    
    typesig { [] }
    # Opens a pipe.  </p>
    # 
    # @return  The new pipe
    def open_pipe
      raise NotImplementedError
    end
    
    typesig { [] }
    # Opens a selector.  </p>
    # 
    # @return  The new selector
    def open_selector
      raise NotImplementedError
    end
    
    typesig { [] }
    # Opens a server-socket channel.  </p>
    # 
    # @return  The new channel
    def open_server_socket_channel
      raise NotImplementedError
    end
    
    typesig { [] }
    # Opens a socket channel. </p>
    # 
    # @return  The new channel
    def open_socket_channel
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the channel inherited from the entity that created this
    # Java virtual machine.
    # 
    # <p> On many operating systems a process, such as a Java virtual
    # machine, can be started in a manner that allows the process to
    # inherit a channel from the entity that created the process. The
    # manner in which this is done is system dependent, as are the
    # possible entities to which the channel may be connected. For example,
    # on UNIX systems, the Internet services daemon (<i>inetd</i>) is used to
    # start programs to service requests when a request arrives on an
    # associated network port. In this example, the process that is started,
    # inherits a channel representing a network socket.
    # 
    # <p> In cases where the inherited channel represents a network socket
    # then the {@link java.nio.channels.Channel Channel} type returned
    # by this method is determined as follows:
    # 
    # <ul>
    # 
    # <li><p> If the inherited channel represents a stream-oriented connected
    # socket then a {@link java.nio.channels.SocketChannel SocketChannel} is
    # returned. The socket channel is, at least initially, in blocking
    # mode, bound to a socket address, and connected to a peer.
    # </p></li>
    # 
    # <li><p> If the inherited channel represents a stream-oriented listening
    # socket then a {@link java.nio.channels.ServerSocketChannel
    # ServerSocketChannel} is returned. The server-socket channel is, at
    # least initially, in blocking mode, and bound to a socket address.
    # </p></li>
    # 
    # <li><p> If the inherited channel is a datagram-oriented socket
    # then a {@link java.nio.channels.DatagramChannel DatagramChannel} is
    # returned. The datagram channel is, at least initially, in blocking
    # mode, and bound to a socket address.
    # </p></li>
    # 
    # </ul>
    # 
    # <p> In addition to the network-oriented channels described, this method
    # may return other kinds of channels in the future.
    # 
    # <p> The first invocation of this method creates the channel that is
    # returned. Subsequent invocations of this method return the same
    # channel. </p>
    # 
    # @return  The inherited channel, if any, otherwise <tt>null</tt>.
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  SecurityException
    # If a security manager has been installed and it denies
    # {@link RuntimePermission}<tt>("inheritedChannel")</tt>
    # 
    # @since 1.5
    def inherited_channel
      return nil
    end
    
    private
    alias_method :initialize__selector_provider, :initialize
  end
  
end

require "rjava"

# Copyright 2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module DefaultDatagramSocketImplFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class defines a factory for creating DatagramSocketImpls. It defaults
  # to creating plain DatagramSocketImpls, but may create other DatagramSocketImpls
  # by setting the impl.prefix system property.
  # 
  # For Windows versions lower than Windows Vista a TwoStacksPlainDatagramSocketImpl
  # is always created. This impl supports IPv6 on these platform where available.
  # 
  # On Windows platforms greater than Vista that support a dual layer TCP/IP stack
  # a DualStackPlainDatagramSocketImpl is created for DatagramSockets. For MulticastSockets
  # a TwoStacksPlainDatagramSocketImpl is always created. This is to overcome the lack
  # of behavior defined for multicasting over a dual layer socket by the RFC.
  # 
  # @author Chris Hegarty
  class DefaultDatagramSocketImplFactory 
    include_class_members DefaultDatagramSocketImplFactoryImports
    
    class_module.module_eval {
      
      def prefix_impl_class
        defined?(@@prefix_impl_class) ? @@prefix_impl_class : @@prefix_impl_class= nil
      end
      alias_method :attr_prefix_impl_class, :prefix_impl_class
      
      def prefix_impl_class=(value)
        @@prefix_impl_class = value
      end
      alias_method :attr_prefix_impl_class=, :prefix_impl_class=
      
      # the windows version.
      
      def version
        defined?(@@version) ? @@version : @@version= 0.0
      end
      alias_method :attr_version, :version
      
      def version=(value)
        @@version = value
      end
      alias_method :attr_version=, :version=
      
      # java.net.preferIPv4Stack
      
      def prefer_ipv4stack
        defined?(@@prefer_ipv4stack) ? @@prefer_ipv4stack : @@prefer_ipv4stack= false
      end
      alias_method :attr_prefer_ipv4stack, :prefer_ipv4stack
      
      def prefer_ipv4stack=(value)
        @@prefer_ipv4stack = value
      end
      alias_method :attr_prefer_ipv4stack=, :prefer_ipv4stack=
      
      # If the version supports a dual stack TCP implementation
      
      def use_dual_stack_impl
        defined?(@@use_dual_stack_impl) ? @@use_dual_stack_impl : @@use_dual_stack_impl= false
      end
      alias_method :attr_use_dual_stack_impl, :use_dual_stack_impl
      
      def use_dual_stack_impl=(value)
        @@use_dual_stack_impl = value
      end
      alias_method :attr_use_dual_stack_impl=, :use_dual_stack_impl=
      
      when_class_loaded do
        Java::Security::AccessController.do_privileged(# Determine Windows Version.
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in DefaultDatagramSocketImplFactory
          include_class_members DefaultDatagramSocketImplFactory
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_version = 0
            begin
              self.attr_version = Float.parse_float(System.get_properties.get_property("os.version"))
              self.attr_prefer_ipv4stack = Boolean.parse_boolean(System.get_properties.get_property("java.net.preferIPv4Stack"))
            rescue self.class::NumberFormatException => e
              raise AssertError, RJava.cast_to_string(e) if not (false)
            end
            return nil # nothing to return
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # (version >= 6.0) implies Vista or greater.
        if (self.attr_version >= 6.0 && !self.attr_prefer_ipv4stack)
          self.attr_use_dual_stack_impl = true
        end
        # impl.prefix
        prefix = nil
        begin
          prefix = RJava.cast_to_string(AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("impl.prefix", nil)))
          if (!(prefix).nil?)
            self.attr_prefix_impl_class = Class.for_name("java.net." + prefix + "DatagramSocketImpl")
          end
        rescue JavaException => e
          System.err.println("Can't find class: java.net." + prefix + "DatagramSocketImpl: check impl.prefix property")
        end
      end
      
      typesig { [::Java::Boolean] }
      # Creates a new <code>DatagramSocketImpl</code> instance.
      # 
      # @param   isMulticast true if this impl is to be used for a MutlicastSocket
      # @return  a new instance of <code>PlainDatagramSocketImpl</code>.
      def create_datagram_socket_impl(is_multicast)
        if (!(self.attr_prefix_impl_class).nil?)
          begin
            return self.attr_prefix_impl_class.new_instance
          rescue JavaException => e
            raise SocketException.new("can't instantiate DatagramSocketImpl")
          end
        else
          if (self.attr_use_dual_stack_impl && !is_multicast)
            return DualStackPlainDatagramSocketImpl.new
          else
            return TwoStacksPlainDatagramSocketImpl.new
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__default_datagram_socket_impl_factory, :initialize
  end
  
end

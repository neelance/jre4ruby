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
  module DefaultDatagramSocketImplFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Security, :AccessController
    }
  end
  
  # This class defines a factory for creating DatagramSocketImpls. It defaults
  # to creating plain DatagramSocketImpls, but may create other DatagramSocketImpls
  # by setting the impl.prefix system property.
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
      
      when_class_loaded do
        prefix = nil
        begin
          prefix = RJava.cast_to_string(AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("impl.prefix", nil)))
          if (!(prefix).nil?)
            self.attr_prefix_impl_class = Class.for_name("java.net." + prefix + "DatagramSocketImpl")
          end
        rescue JavaException => e
          System.err.println("Can't find class: java.net." + prefix + "DatagramSocketImpl: check impl.prefix property")
          # prefixImplClass = null;
        end
      end
      
      typesig { [::Java::Boolean] }
      # Creates a new <code>DatagramSocketImpl</code> instance.
      # 
      # @param   isMulticast     true if this impl if for a MutlicastSocket
      # @return  a new instance of a <code>DatagramSocketImpl</code>.
      # 
      # unused on unix
      def create_datagram_socket_impl(is_multicast)
        if (!(self.attr_prefix_impl_class).nil?)
          begin
            return self.attr_prefix_impl_class.new_instance
          rescue JavaException => e
            raise SocketException.new("can't instantiate DatagramSocketImpl")
          end
        else
          return Java::Net::PlainDatagramSocketImpl.new
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

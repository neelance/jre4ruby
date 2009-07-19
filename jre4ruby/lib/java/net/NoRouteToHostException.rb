require "rjava"

# Copyright 1996-1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NoRouteToHostExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # Signals that an error occurred while attempting to connect a
  # socket to a remote address and port.  Typically, the remote
  # host cannot be reached because of an intervening firewall, or
  # if an intermediate router is down.
  # 
  # @since   JDK1.1
  class NoRouteToHostException < NoRouteToHostExceptionImports.const_get :SocketException
    include_class_members NoRouteToHostExceptionImports
    
    typesig { [String] }
    # Constructs a new NoRouteToHostException with the specified detail
    # message as to why the remote host cannot be reached.
    # A detail message is a String that gives a specific
    # description of this error.
    # @param msg the detail message
    def initialize(msg)
      super(msg)
    end
    
    typesig { [] }
    # Construct a new NoRouteToHostException with no detailed message.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__no_route_to_host_exception, :initialize
  end
  
end

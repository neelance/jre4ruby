require "rjava"

# Copyright 1999-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module TerminatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Sun::Misc, :Signal
      include_const ::Sun::Misc, :SignalHandler
    }
  end
  
  # Package-private utility class for setting up and tearing down
  # platform-specific support for termination-triggered shutdowns.
  # 
  # @author   Mark Reinhold
  # @since    1.3
  class Terminator 
    include_class_members TerminatorImports
    
    class_module.module_eval {
      
      def handler
        defined?(@@handler) ? @@handler : @@handler= nil
      end
      alias_method :attr_handler, :handler
      
      def handler=(value)
        @@handler = value
      end
      alias_method :attr_handler=, :handler=
      
      typesig { [] }
      # Invocations of setup and teardown are already synchronized
      # on the shutdown lock, so no further synchronization is needed here
      def setup
        if (!(self.attr_handler).nil?)
          return
        end
        sh = Class.new(SignalHandler.class == Class ? SignalHandler : Object) do
          extend LocalClass
          include_class_members Terminator
          include SignalHandler if SignalHandler.class == Module
          
          typesig { [Signal] }
          define_method :handle do |sig|
            Shutdown.exit(sig.get_number + 200)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        self.attr_handler = sh
        begin
          Signal.handle(Signal.new("INT"), sh)
          Signal.handle(Signal.new("TERM"), sh)
        rescue IllegalArgumentException => e
          # When -Xrs is specified the user is responsible for
          # ensuring that shutdown hooks are run by calling
          # System.exit()
        end
      end
      
      typesig { [] }
      def teardown
        # The current sun.misc.Signal class does not support
        # the cancellation of handlers
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__terminator, :initialize
  end
  
end

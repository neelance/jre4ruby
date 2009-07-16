require "rjava"

# 
# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ApplicationShutdownHooksImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # Class to track and run user level shutdown hooks registered through
  # <tt>{@link Runtime#addShutdownHook Runtime.addShutdownHook}</tt>.
  # 
  # @see java.lang.Runtime#addShutdownHook
  # @see java.lang.Runtime#removeShutdownHook
  class ApplicationShutdownHooks 
    include_class_members ApplicationShutdownHooksImports
    include Runnable
    
    class_module.module_eval {
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
      
      # The set of registered hooks
      
      def hooks
        defined?(@@hooks) ? @@hooks : @@hooks= IdentityHashMap.new
      end
      alias_method :attr_hooks, :hooks
      
      def hooks=(value)
        @@hooks = value
      end
      alias_method :attr_hooks=, :hooks=
      
      typesig { [] }
      def hook
        synchronized(self) do
          if ((self.attr_instance).nil?)
            self.attr_instance = ApplicationShutdownHooks.new
          end
          return self.attr_instance
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [JavaThread] }
      # Add a new shutdown hook.  Checks the shutdown state and the hook itself,
      # but does not do any security checks.
      def add(hook)
        synchronized(self) do
          if ((self.attr_hooks).nil?)
            raise IllegalStateException.new("Shutdown in progress")
          end
          if (hook.is_alive)
            raise IllegalArgumentException.new("Hook already running")
          end
          if (self.attr_hooks.contains_key(hook))
            raise IllegalArgumentException.new("Hook previously registered")
          end
          self.attr_hooks.put(hook, hook)
        end
      end
      
      typesig { [JavaThread] }
      # Remove a previously-registered hook.  Like the add method, this method
      # does not do any security checks.
      def remove(hook)
        synchronized(self) do
          if ((self.attr_hooks).nil?)
            raise IllegalStateException.new("Shutdown in progress")
          end
          if ((hook).nil?)
            raise NullPointerException.new
          end
          return !(self.attr_hooks.remove(hook)).nil?
        end
      end
    }
    
    typesig { [] }
    # Iterates over all application hooks creating a new thread for each
    # to run in. Hooks are run concurrently and this method waits for
    # them to finish.
    def run
      threads = nil
      synchronized((ApplicationShutdownHooks.class)) do
        threads = self.attr_hooks.key_set
        self.attr_hooks = nil
      end
      threads.each do |hook|
        hook.start
      end
      threads.each do |hook|
        begin
          hook_.join
        rescue InterruptedException => x
        end
      end
    end
    
    private
    alias_method :initialize__application_shutdown_hooks, :initialize
  end
  
end

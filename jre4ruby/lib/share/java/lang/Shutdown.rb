require "rjava"

# Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ShutdownImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # Package-private utility class containing data structures and logic
  # governing the virtual-machine shutdown sequence.
  # 
  # @author   Mark Reinhold
  # @since    1.3
  class Shutdown 
    include_class_members ShutdownImports
    
    class_module.module_eval {
      # Shutdown state
      const_set_lazy(:RUNNING) { 0 }
      const_attr_reader  :RUNNING
      
      const_set_lazy(:HOOKS) { 1 }
      const_attr_reader  :HOOKS
      
      const_set_lazy(:FINALIZERS) { 2 }
      const_attr_reader  :FINALIZERS
      
      
      def state
        defined?(@@state) ? @@state : @@state= RUNNING
      end
      alias_method :attr_state, :state
      
      def state=(value)
        @@state = value
      end
      alias_method :attr_state=, :state=
      
      # Should we run all finalizers upon exit?
      
      def run_finalizers_on_exit
        defined?(@@run_finalizers_on_exit) ? @@run_finalizers_on_exit : @@run_finalizers_on_exit= false
      end
      alias_method :attr_run_finalizers_on_exit, :run_finalizers_on_exit
      
      def run_finalizers_on_exit=(value)
        @@run_finalizers_on_exit = value
      end
      alias_method :attr_run_finalizers_on_exit=, :run_finalizers_on_exit=
      
      # The set of registered, wrapped hooks, or null if there aren't any
      
      def hooks
        defined?(@@hooks) ? @@hooks : @@hooks= ArrayList.new
      end
      alias_method :attr_hooks, :hooks
      
      def hooks=(value)
        @@hooks = value
      end
      alias_method :attr_hooks=, :hooks=
      
      # The preceding static fields are protected by this lock
      const_set_lazy(:Lock) { Class.new do
        include_class_members Shutdown
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__lock, :initialize
      end }
      
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Lock.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      # Lock object for the native halt method
      
      def halt_lock
        defined?(@@halt_lock) ? @@halt_lock : @@halt_lock= Lock.new
      end
      alias_method :attr_halt_lock, :halt_lock
      
      def halt_lock=(value)
        @@halt_lock = value
      end
      alias_method :attr_halt_lock=, :halt_lock=
      
      typesig { [::Java::Boolean] }
      # Invoked by Runtime.runFinalizersOnExit
      def set_run_finalizers_on_exit(run)
        synchronized((self.attr_lock)) do
          self.attr_run_finalizers_on_exit = run
        end
      end
      
      typesig { [Runnable] }
      # Add a new shutdown hook.  Checks the shutdown state and the hook itself,
      # but does not do any security checks.
      def add(hook)
        synchronized((self.attr_lock)) do
          if (self.attr_state > RUNNING)
            raise IllegalStateException.new("Shutdown in progress")
          end
          self.attr_hooks.add(hook)
        end
      end
      
      typesig { [Runnable] }
      # Remove a previously-registered hook.  Like the add method, this method
      # does not do any security checks.
      def remove(hook)
        synchronized((self.attr_lock)) do
          if (self.attr_state > RUNNING)
            raise IllegalStateException.new("Shutdown in progress")
          end
          if ((hook).nil?)
            raise NullPointerException.new
          end
          if ((self.attr_hooks).nil?)
            return false
          else
            return self.attr_hooks.remove(hook)
          end
        end
      end
      
      typesig { [] }
      # Run all registered shutdown hooks
      def run_hooks
        # We needn't bother acquiring the lock just to read the hooks field,
        # since the hooks can't be modified once shutdown is in progress
        self.attr_hooks.each do |hook|
          begin
            hook.run
          rescue JavaThrowable => t
            if (t.is_a?(ThreadDeath))
              td = t
              raise td
            end
          end
        end
      end
      
      typesig { [::Java::Int] }
      # The halt method is synchronized on the halt lock
      # to avoid corruption of the delete-on-shutdown file list.
      # It invokes the true native halt method.
      def halt(status)
        synchronized((self.attr_halt_lock)) do
          halt0(status)
        end
      end
      
      JNI.native_method :Java_java_lang_Shutdown_halt0, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def halt0(status)
        JNI.__send__(:Java_java_lang_Shutdown_halt0, JNI.env, self.jni_id, status.to_int)
      end
      
      JNI.native_method :Java_java_lang_Shutdown_runAllFinalizers, [:pointer, :long], :void
      typesig { [] }
      # Wormhole for invoking java.lang.ref.Finalizer.runAllFinalizers
      def run_all_finalizers
        JNI.__send__(:Java_java_lang_Shutdown_runAllFinalizers, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # The actual shutdown sequence is defined here.
      # 
      # If it weren't for runFinalizersOnExit, this would be simple -- we'd just
      # run the hooks and then halt.  Instead we need to keep track of whether
      # we're running hooks or finalizers.  In the latter case a finalizer could
      # invoke exit(1) to cause immediate termination, while in the former case
      # any further invocations of exit(n), for any n, simply stall.  Note that
      # if on-exit finalizers are enabled they're run iff the shutdown is
      # initiated by an exit(0); they're never run on exit(n) for n != 0 or in
      # response to SIGINT, SIGTERM, etc.
      def sequence
        synchronized((self.attr_lock)) do
          # Guard against the possibility of a daemon thread invoking exit
          # after DestroyJavaVM initiates the shutdown sequence
          if (!(self.attr_state).equal?(HOOKS))
            return
          end
        end
        run_hooks
        rfoe = false
        synchronized((self.attr_lock)) do
          self.attr_state = FINALIZERS
          rfoe = self.attr_run_finalizers_on_exit
        end
        if (rfoe)
          run_all_finalizers
        end
      end
      
      typesig { [::Java::Int] }
      # Invoked by Runtime.exit, which does all the security checks.
      # Also invoked by handlers for system-provided termination events,
      # which should pass a nonzero status code.
      def exit(status)
        run_more_finalizers = false
        synchronized((self.attr_lock)) do
          if (!(status).equal?(0))
            self.attr_run_finalizers_on_exit = false
          end
          case (self.attr_state)
          when RUNNING
            # Initiate shutdown
            self.attr_state = HOOKS
          when HOOKS
            # Stall and halt
          when FINALIZERS
            if (!(status).equal?(0))
              # Halt immediately on nonzero status
              halt(status)
            else
              # Compatibility with old behavior:
              # Run more finalizers and then halt
              run_more_finalizers = self.attr_run_finalizers_on_exit
            end
          end
        end
        if (run_more_finalizers)
          run_all_finalizers
          halt(status)
        end
        synchronized((Shutdown)) do
          # Synchronize on the class object, causing any other thread
          # that attempts to initiate shutdown to stall indefinitely
          sequence
          halt(status)
        end
      end
      
      typesig { [] }
      # Invoked by the JNI DestroyJavaVM procedure when the last non-daemon
      # thread has finished.  Unlike the exit method, this method does not
      # actually halt the VM.
      def shutdown
        synchronized((self.attr_lock)) do
          case (self.attr_state)
          # Stall and then return
          when RUNNING
            # Initiate shutdown
            self.attr_state = HOOKS
          when HOOKS, FINALIZERS
          end
        end
        synchronized((Shutdown)) do
          sequence
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__shutdown, :initialize
  end
  
end

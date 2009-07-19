require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Ref
  module FinalizerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :AccessController
    }
  end
  
  class Finalizer < FinalizerImports.const_get :FinalReference
    include_class_members FinalizerImports
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_ref_Finalizer_invokeFinalizeMethod, [:pointer, :long, :long], :void
      typesig { [Object] }
      # Package-private; must be in
      # same package as the Reference
      # class
      # A native method that invokes an arbitrary object's finalize method is
      # required since the finalize method is protected
      def invoke_finalize_method(o)
        JNI.__send__(:Java_java_lang_ref_Finalizer_invokeFinalizeMethod, JNI.env, self.jni_id, o.jni_id)
      end
      
      
      def queue
        defined?(@@queue) ? @@queue : @@queue= ReferenceQueue.new
      end
      alias_method :attr_queue, :queue
      
      def queue=(value)
        @@queue = value
      end
      alias_method :attr_queue=, :queue=
      
      
      def unfinalized
        defined?(@@unfinalized) ? @@unfinalized : @@unfinalized= nil
      end
      alias_method :attr_unfinalized, :unfinalized
      
      def unfinalized=(value)
        @@unfinalized = value
      end
      alias_method :attr_unfinalized=, :unfinalized=
      
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Object.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
    }
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    attr_accessor :prev
    alias_method :attr_prev, :prev
    undef_method :prev
    alias_method :attr_prev=, :prev=
    undef_method :prev=
    
    typesig { [] }
    def has_been_finalized
      return ((@next).equal?(self))
    end
    
    typesig { [] }
    def add
      synchronized((self.attr_lock)) do
        if (!(self.attr_unfinalized).nil?)
          @next = self.attr_unfinalized
          self.attr_unfinalized.attr_prev = self
        end
        self.attr_unfinalized = self
      end
    end
    
    typesig { [] }
    def remove
      synchronized((self.attr_lock)) do
        if ((self.attr_unfinalized).equal?(self))
          if (!(@next).nil?)
            self.attr_unfinalized = @next
          else
            self.attr_unfinalized = @prev
          end
        end
        if (!(@next).nil?)
          @next.attr_prev = @prev
        end
        if (!(@prev).nil?)
          @prev.attr_next = @next
        end
        @next = self
        # Indicates that this has been finalized
        @prev = self
      end
    end
    
    typesig { [Object] }
    def initialize(finalizee)
      @next = nil
      @prev = nil
      super(finalizee, self.attr_queue)
      @next = nil
      @prev = nil
      add
    end
    
    class_module.module_eval {
      typesig { [Object] }
      # Invoked by VM
      def register(finalizee)
        Finalizer.new(finalizee)
      end
    }
    
    typesig { [] }
    def run_finalizer
      synchronized((self)) do
        if (has_been_finalized)
          return
        end
        remove
      end
      begin
        finalizee = self.get
        if (!(finalizee).nil? && !(finalizee.is_a?(Java::Lang::Enum)))
          invoke_finalize_method(finalizee)
          # Clear stack slot containing this variable, to decrease
          # the chances of false retention with a conservative GC
          finalizee = nil
        end
      rescue Exception => x
      end
      FinalReference.instance_method(:clear).bind(self).call
    end
    
    class_module.module_eval {
      typesig { [Runnable] }
      # Create a privileged secondary finalizer thread in the system thread
      # group for the given Runnable, and wait for it to complete.
      # 
      # This method is used by both runFinalization and runFinalizersOnExit.
      # The former method invokes all pending finalizers, while the latter
      # invokes all uninvoked finalizers if on-exit finalization has been
      # enabled.
      # 
      # These two methods could have been implemented by offloading their work
      # to the regular finalizer thread and waiting for that thread to finish.
      # The advantage of creating a fresh thread, however, is that it insulates
      # invokers of these methods from a stalled or deadlocked finalizer thread.
      def fork_secondary_finalizer(proc)
        pa = Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Finalizer
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            tg = JavaThread.current_thread.get_thread_group
            tgn = tg
            while !(tgn).nil?
              tg = tgn
              tgn = tg.get_parent
            end
            sft = JavaThread.new(tg, proc, "Secondary finalizer")
            sft.start
            begin
              sft.join
            rescue InterruptedException => x
              # Ignore
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        AccessController.do_privileged(pa)
      end
      
      typesig { [] }
      # Called by Runtime.runFinalization()
      def run_finalization
        fork_secondary_finalizer(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members Finalizer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            loop do
              f = self.attr_queue.poll
              if ((f).nil?)
                break
              end
              f.run_finalizer
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      # Invoked by java.lang.Shutdown
      def run_all_finalizers
        fork_secondary_finalizer(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members Finalizer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            loop do
              f = nil
              synchronized((self.attr_lock)) do
                f = self.attr_unfinalized
                if ((f).nil?)
                  break
                end
                self.attr_unfinalized = f.attr_next
              end
              f.run_finalizer
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      const_set_lazy(:FinalizerThread) { Class.new(JavaThread) do
        include_class_members Finalizer
        
        typesig { [JavaThreadGroup] }
        def initialize(g)
          super(g, "Finalizer")
        end
        
        typesig { [] }
        def run
          loop do
            begin
              f = self.attr_queue.remove
              f.run_finalizer
            rescue InterruptedException => x
              next
            end
          end
        end
        
        private
        alias_method :initialize__finalizer_thread, :initialize
      end }
      
      when_class_loaded do
        tg = JavaThread.current_thread.get_thread_group
        tgn = tg
        while !(tgn).nil?
          tg = tgn
          tgn = tg.get_parent
        end
        finalizer = FinalizerThread.new(tg)
        finalizer.set_priority(JavaThread::MAX_PRIORITY - 2)
        finalizer.set_daemon(true)
        finalizer.start
      end
    }
    
    private
    alias_method :initialize__finalizer, :initialize
  end
  
end

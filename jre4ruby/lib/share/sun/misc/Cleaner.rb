require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module CleanerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include ::Java::Lang::Ref
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # General-purpose phantom-reference-based cleaners.
  # 
  # <p> Cleaners are a lightweight and more robust alternative to finalization.
  # They are lightweight because they are not created by the VM and thus do not
  # require a JNI upcall to be created, and because their cleanup code is
  # invoked directly by the reference-handler thread rather than by the
  # finalizer thread.  They are more robust because they use phantom references,
  # the weakest type of reference object, thereby avoiding the nasty ordering
  # problems inherent to finalization.
  # 
  # <p> A cleaner tracks a referent object and encapsulates a thunk of arbitrary
  # cleanup code.  Some time after the GC detects that a cleaner's referent has
  # become phantom-reachable, the reference-handler thread will run the cleaner.
  # Cleaners may also be invoked directly; they are thread safe and ensure that
  # they run their thunks at most once.
  # 
  # <p> Cleaners are not a replacement for finalization.  They should be used
  # only when the cleanup code is extremely simple and straightforward.
  # Nontrivial cleaners are inadvisable since they risk blocking the
  # reference-handler thread and delaying further cleanup and finalization.
  # 
  # 
  # @author Mark Reinhold
  class Cleaner < CleanerImports.const_get :PhantomReference
    include_class_members CleanerImports
    
    class_module.module_eval {
      # Dummy reference queue, needed because the PhantomReference constructor
      # insists that we pass a queue.  Nothing will ever be placed on this queue
      # since the reference handler invokes cleaners explicitly.
      const_set_lazy(:DummyQueue) { ReferenceQueue.new }
      const_attr_reader  :DummyQueue
      
      # Doubly-linked list of live cleaners, which prevents the cleaners
      # themselves from being GC'd before their referents
      
      def first
        defined?(@@first) ? @@first : @@first= nil
      end
      alias_method :attr_first, :first
      
      def first=(value)
        @@first = value
      end
      alias_method :attr_first=, :first=
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
    
    class_module.module_eval {
      typesig { [Cleaner] }
      def add(cl)
        synchronized(self) do
          if (!(self.attr_first).nil?)
            cl.attr_next = self.attr_first
            self.attr_first.attr_prev = cl
          end
          self.attr_first = cl
          return cl
        end
      end
      
      typesig { [Cleaner] }
      def remove(cl)
        synchronized(self) do
          # If already removed, do nothing
          if ((cl.attr_next).equal?(cl))
            return false
          end
          # Update list
          if ((self.attr_first).equal?(cl))
            if (!(cl.attr_next).nil?)
              self.attr_first = cl.attr_next
            else
              self.attr_first = cl.attr_prev
            end
          end
          if (!(cl.attr_next).nil?)
            cl.attr_next.attr_prev = cl.attr_prev
          end
          if (!(cl.attr_prev).nil?)
            cl.attr_prev.attr_next = cl.attr_next
          end
          # Indicate removal by pointing the cleaner to itself
          cl.attr_next = cl
          cl.attr_prev = cl
          return true
        end
      end
    }
    
    attr_accessor :thunk
    alias_method :attr_thunk, :thunk
    undef_method :thunk
    alias_method :attr_thunk=, :thunk=
    undef_method :thunk=
    
    typesig { [Object, Runnable] }
    def initialize(referent, thunk)
      @next = nil
      @prev = nil
      @thunk = nil
      super(referent, DummyQueue)
      @next = nil
      @prev = nil
      @thunk = thunk
    end
    
    class_module.module_eval {
      typesig { [Object, Runnable] }
      # Creates a new cleaner.
      # 
      # @param  thunk
      # The cleanup code to be run when the cleaner is invoked.  The
      # cleanup code is run directly from the reference-handler thread,
      # so it should be as simple and straightforward as possible.
      # 
      # @return  The new cleaner
      def create(ob, thunk)
        if ((thunk).nil?)
          return nil
        end
        return add(Cleaner.new(ob, thunk))
      end
    }
    
    typesig { [] }
    # Runs this cleaner, if it has not been run before.
    def clean
      if (!remove(self))
        return
      end
      begin
        @thunk.run
      rescue JavaThrowable => x
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Cleaner
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            if (!(System.err).nil?)
              self.class::JavaError.new("Cleaner terminated abnormally", x).print_stack_trace
            end
            System.exit(1)
            return nil
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
    
    private
    alias_method :initialize__cleaner, :initialize
  end
  
end

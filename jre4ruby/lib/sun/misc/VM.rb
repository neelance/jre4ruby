require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module VMImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
    }
  end
  
  class VM 
    include_class_members VMImports
    
    class_module.module_eval {
      # The following methods used to be native methods that instruct
      # the VM to selectively suspend certain threads in low-memory
      # situations. They are inherently dangerous and not implementable
      # on native threads. We removed them in JDK 1.2. The skeletons
      # remain so that existing applications that use these methods
      # will still work.
      
      def suspended
        defined?(@@suspended) ? @@suspended : @@suspended= false
      end
      alias_method :attr_suspended, :suspended
      
      def suspended=(value)
        @@suspended = value
      end
      alias_method :attr_suspended=, :suspended=
      
      typesig { [] }
      # @deprecated
      def threads_suspended
        return self.attr_suspended
      end
      
      typesig { [JavaThreadGroup, ::Java::Boolean] }
      def allow_thread_suspension(g, b)
        return g.allow_thread_suspension(b)
      end
      
      typesig { [] }
      # @deprecated
      def suspend_threads
        self.attr_suspended = true
        return true
      end
      
      typesig { [] }
      # Causes any suspended threadgroups to be resumed.
      # @deprecated
      def unsuspend_threads
        self.attr_suspended = false
      end
      
      typesig { [] }
      # Causes threadgroups no longer marked suspendable to be resumed.
      # @deprecated
      def unsuspend_some_threads
      end
      
      # Deprecated fields and methods -- Memory advice not supported in 1.2
      # @deprecated
      const_set_lazy(:STATE_GREEN) { 1 }
      const_attr_reader  :STATE_GREEN
      
      # @deprecated
      const_set_lazy(:STATE_YELLOW) { 2 }
      const_attr_reader  :STATE_YELLOW
      
      # @deprecated
      const_set_lazy(:STATE_RED) { 3 }
      const_attr_reader  :STATE_RED
      
      typesig { [] }
      # @deprecated
      def get_state
        return STATE_GREEN
      end
      
      typesig { [VMNotification] }
      # @deprecated
      def register_vmnotification(n)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # @deprecated
      def as_change(as_old, as_new)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # @deprecated
      def as_change_otherthread(as_old, as_new)
      end
      
      # Not supported in 1.2 because these will have to be exported as
      # JVM functions, and we are not sure we want do that. Leaving
      # here so it can be easily resurrected -- just remove the //
      # comments.
      # 
      # 
      # Resume Java profiling.  All profiling data is added to any
      # earlier profiling, unless <code>resetJavaProfiler</code> is
      # called in between.  If profiling was not started from the
      # command line, <code>resumeJavaProfiler</code> will start it.
      # <p>
      # 
      # NOTE: Profiling must be enabled from the command line for a
      # java.prof report to be automatically generated on exit; if not,
      # writeJavaProfilerReport must be invoked to write a report.
      # 
      # @see     resetJavaProfiler
      # @see     writeJavaProfilerReport
      # 
      # public native static void resumeJavaProfiler();
      # 
      # Suspend Java profiling.
      # 
      # public native static void suspendJavaProfiler();
      # 
      # Initialize Java profiling.  Any accumulated profiling
      # information is discarded.
      # 
      # public native static void resetJavaProfiler();
      # 
      # Write the current profiling contents to the file "java.prof".
      # If the file already exists, it will be overwritten.
      # 
      # public native static void writeJavaProfilerReport();
      
      def booted
        defined?(@@booted) ? @@booted : @@booted= false
      end
      alias_method :attr_booted, :booted
      
      def booted=(value)
        @@booted = value
      end
      alias_method :attr_booted=, :booted=
      
      typesig { [] }
      # Invoked by by System.initializeSystemClass just before returning.
      # Subsystems that are invoked during initialization can check this
      # property in order to avoid doing things that should wait until the
      # application class loader has been set up.
      def booted
        self.attr_booted = true
      end
      
      typesig { [] }
      def is_booted
        return self.attr_booted
      end
      
      # A user-settable upper limit on the maximum amount of allocatable direct
      # buffer memory.  This value may be changed during VM initialization if
      # "java" is launched with "-XX:MaxDirectMemorySize=<size>".
      # 
      # The initial value of this field is arbitrary; during JRE initialization
      # it will be reset to the value specified on the command line, if any,
      # otherwise to Runtime.getRuntime.maxDirectMemory().
      
      def direct_memory
        defined?(@@direct_memory) ? @@direct_memory : @@direct_memory= 64 * 1024 * 1024
      end
      alias_method :attr_direct_memory, :direct_memory
      
      def direct_memory=(value)
        @@direct_memory = value
      end
      alias_method :attr_direct_memory=, :direct_memory=
      
      typesig { [] }
      # If this method is invoked during VM initialization, it initializes the
      # maximum amount of allocatable direct buffer memory (in bytes) from the
      # system property sun.nio.MaxDirectMemorySize.  The system property will
      # be removed when it is accessed.
      # 
      # If this method is invoked after the VM is booted, it returns the
      # maximum amount of allocatable direct buffer memory.
      def max_direct_memory
        if (self.attr_booted)
          return self.attr_direct_memory
        end
        p = System.get_properties
        s = p.remove("sun.nio.MaxDirectMemorySize")
        System.set_properties(p)
        if (!(s).nil?)
          if ((s == "-1"))
            # -XX:MaxDirectMemorySize not given, take default
            self.attr_direct_memory = Runtime.get_runtime.max_memory
          else
            l = Long.parse_long(s)
            if (l > -1)
              self.attr_direct_memory = l
            end
          end
        end
        return self.attr_direct_memory
      end
      
      # A user-settable boolean to determine whether ClassLoader.loadClass should
      # accept array syntax.  This value may be changed during VM initialization
      # via the system property "sun.lang.ClassLoader.allowArraySyntax".
      # 
      # The default for 1.5 is "true", array syntax is allowed.  In 1.6, the
      # default will be "false".  The presence of this system property to
      # control array syntax allows applications the ability to preview this new
      # behaviour.
      
      def default_allow_array_syntax
        defined?(@@default_allow_array_syntax) ? @@default_allow_array_syntax : @@default_allow_array_syntax= false
      end
      alias_method :attr_default_allow_array_syntax, :default_allow_array_syntax
      
      def default_allow_array_syntax=(value)
        @@default_allow_array_syntax = value
      end
      alias_method :attr_default_allow_array_syntax=, :default_allow_array_syntax=
      
      
      def allow_array_syntax
        defined?(@@allow_array_syntax) ? @@allow_array_syntax : @@allow_array_syntax= self.attr_default_allow_array_syntax
      end
      alias_method :attr_allow_array_syntax, :allow_array_syntax
      
      def allow_array_syntax=(value)
        @@allow_array_syntax = value
      end
      alias_method :attr_allow_array_syntax=, :allow_array_syntax=
      
      typesig { [] }
      # If this method is invoked during VM initialization, it initializes the
      # allowArraySyntax boolean based on the value of the system property
      # "sun.lang.ClassLoader.allowArraySyntax".  If the system property is not
      # provided, the default for 1.5 is "true".  In 1.6, the default will be
      # "false".  If the system property is provided, then the value of
      # allowArraySyntax will be equal to "true" if Boolean.parseBoolean()
      # returns "true".   Otherwise, the field will be set to "false".
      # 
      # If this method is invoked after the VM is booted, it returns the
      # allowArraySyntax boolean set during initialization.
      def allow_array_syntax
        if (!self.attr_booted)
          s = System.get_property("sun.lang.ClassLoader.allowArraySyntax")
          self.attr_allow_array_syntax = ((s).nil? ? self.attr_default_allow_array_syntax : Boolean.parse_boolean(s))
        end
        return self.attr_allow_array_syntax
      end
      
      typesig { [] }
      # Initialize any miscellenous operating system settings that need to be
      # set for the class libraries.
      def initialize_osenvironment
        if (!self.attr_booted)
          OSEnvironment.initialize_
        end
      end
      
      # Current count of objects pending for finalization
      
      def final_ref_count
        defined?(@@final_ref_count) ? @@final_ref_count : @@final_ref_count= 0
      end
      alias_method :attr_final_ref_count, :final_ref_count
      
      def final_ref_count=(value)
        @@final_ref_count = value
      end
      alias_method :attr_final_ref_count=, :final_ref_count=
      
      # Peak count of objects pending for finalization
      
      def peak_final_ref_count
        defined?(@@peak_final_ref_count) ? @@peak_final_ref_count : @@peak_final_ref_count= 0
      end
      alias_method :attr_peak_final_ref_count, :peak_final_ref_count
      
      def peak_final_ref_count=(value)
        @@peak_final_ref_count = value
      end
      alias_method :attr_peak_final_ref_count=, :peak_final_ref_count=
      
      typesig { [] }
      # Gets the number of objects pending for finalization.
      # 
      # @return the number of objects pending for finalization.
      def get_final_ref_count
        return self.attr_final_ref_count
      end
      
      typesig { [] }
      # Gets the peak number of objects pending for finalization.
      # 
      # @return the peak number of objects pending for finalization.
      def get_peak_final_ref_count
        return self.attr_peak_final_ref_count
      end
      
      typesig { [::Java::Int] }
      # Add <tt>n</tt> to the objects pending for finalization count.
      # 
      # @param n an integer value to be added to the objects pending
      # for finalization count
      def add_final_ref_count(n)
        # The caller must hold lock to synchronize the update.
        self.attr_final_ref_count += n
        if (self.attr_final_ref_count > self.attr_peak_final_ref_count)
          self.attr_peak_final_ref_count = self.attr_final_ref_count
        end
      end
      
      typesig { [::Java::Int] }
      def to_thread_state(thread_status)
        # Initialize the threadStateMap
        init_thread_state_map
        s = self.attr_thread_state_map.get(thread_status)
        if ((s).nil?)
          # default to RUNNABLE if the threadStatus value is unknown
          s = JavaThread::State::RUNNABLE
        end
        return s
      end
      
      # a map of threadStatus values to the corresponding Thread.State
      
      def thread_state_map
        defined?(@@thread_state_map) ? @@thread_state_map : @@thread_state_map= nil
      end
      alias_method :attr_thread_state_map, :thread_state_map
      
      def thread_state_map=(value)
        @@thread_state_map = value
      end
      alias_method :attr_thread_state_map=, :thread_state_map=
      
      
      def thread_state_names
        defined?(@@thread_state_names) ? @@thread_state_names : @@thread_state_names= nil
      end
      alias_method :attr_thread_state_names, :thread_state_names
      
      def thread_state_names=(value)
        @@thread_state_names = value
      end
      alias_method :attr_thread_state_names=, :thread_state_names=
      
      typesig { [] }
      def init_thread_state_map
        synchronized(self) do
          if (!(self.attr_thread_state_map).nil?)
            return
          end
          ts = JavaThread::State.values
          vm_thread_state_values = Array.typed(::Java::Int).new(ts.attr_length) { 0 }
          vm_thread_state_names = Array.typed(String).new(ts.attr_length) { nil }
          get_thread_state_values(vm_thread_state_values, vm_thread_state_names)
          self.attr_thread_state_map = HashMap.new
          self.attr_thread_state_names = HashMap.new
          i = 0
          while i < ts.attr_length
            state = ts[i].name
            values_ = nil
            names = nil
            j = 0
            while j < ts.attr_length
              if (vm_thread_state_names[j][0].starts_with(state))
                values_ = vm_thread_state_values[j]
                names = vm_thread_state_names[j]
              end
              j += 1
            end
            if ((values_).nil?)
              raise InternalError.new("No VM thread state mapped to " + state)
            end
            if (!(values_.attr_length).equal?(names.attr_length))
              raise InternalError.new("VM thread state values and names " + " mapped to " + state + ": length not matched")
            end
            k = 0
            while k < values_.attr_length
              self.attr_thread_state_map.put(values_[k], ts[i])
              self.attr_thread_state_names.put(values_[k], names[k])
              k += 1
            end
            i += 1
          end
        end
      end
      
      JNI.native_method :Java_sun_misc_VM_getThreadStateValues, [:pointer, :long, :long, :long], :void
      typesig { [Array.typed(Array.typed(::Java::Int)), Array.typed(Array.typed(String))] }
      # Fill in vmThreadStateValues with int arrays, each of which contains
      # the threadStatus values mapping to the Thread.State enum constant.
      # Fill in vmThreadStateNames with String arrays, each of which contains
      # the name of each threadStatus value of the format:
      # <Thread.State.name()>[.<Substate name>]
      # e.g. WAITING.OBJECT_WAIT
      def get_thread_state_values(vm_thread_state_values, vm_thread_state_names)
        JNI.__send__(:Java_sun_misc_VM_getThreadStateValues, JNI.env, self.jni_id, vm_thread_state_values.jni_id, vm_thread_state_names.jni_id)
      end
      
      when_class_loaded do
        initialize_
      end
      
      JNI.native_method :Java_sun_misc_VM_initialize, [:pointer, :long], :void
      typesig { [] }
      def initialize_
        JNI.__send__(:Java_sun_misc_VM_initialize, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__vm, :initialize
  end
  
end

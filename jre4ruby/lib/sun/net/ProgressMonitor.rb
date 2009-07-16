require "rjava"

# 
# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module ProgressMonitorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Net, :URL
    }
  end
  
  # 
  # ProgressMonitor is a class for monitoring progress in network input stream.
  # 
  # @author Stanley Man-Kit Ho
  class ProgressMonitor 
    include_class_members ProgressMonitorImports
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Return default ProgressMonitor.
      def get_default
        synchronized(self) do
          return self.attr_pm
        end
      end
      
      typesig { [ProgressMonitor] }
      # 
      # Change default ProgressMonitor implementation.
      def set_default(m)
        synchronized(self) do
          if (!(m).nil?)
            self.attr_pm = m
          end
        end
      end
      
      typesig { [ProgressMeteringPolicy] }
      # 
      # Change progress metering policy.
      def set_metering_policy(policy)
        synchronized(self) do
          if (!(policy).nil?)
            self.attr_metering_policy = policy
          end
        end
      end
    }
    
    typesig { [] }
    # 
    # Return a snapshot of the ProgressSource list
    def get_progress_sources
      snapshot = ArrayList.new
      begin
        synchronized((@progress_source_list)) do
          iter = @progress_source_list.iterator
          while iter.has_next
            pi = iter.next
            # Clone ProgressSource and add to snapshot
            snapshot.add(pi.clone)
          end
        end
      rescue CloneNotSupportedException => e
        e.print_stack_trace
      end
      return snapshot
    end
    
    typesig { [] }
    # 
    # Return update notification threshold
    def get_progress_update_threshold
      synchronized(self) do
        return self.attr_metering_policy.get_progress_update_threshold
      end
    end
    
    typesig { [URL, String] }
    # 
    # Return true if metering should be turned on
    # for a particular URL input stream.
    def should_meter_input(url, method)
      return self.attr_metering_policy.should_meter_input(url, method)
    end
    
    typesig { [ProgressSource] }
    # 
    # Register progress source when progress is began.
    def register_source(pi)
      synchronized((@progress_source_list)) do
        if (@progress_source_list.contains(pi))
          return
        end
        @progress_source_list.add(pi)
      end
      # Notify only if there is at least one listener
      if (@progress_listener_list.size > 0)
        # Notify progress listener if there is progress change
        listeners = ArrayList.new
        # Copy progress listeners to another list to avoid holding locks
        synchronized((@progress_listener_list)) do
          iter = @progress_listener_list.iterator
          while iter.has_next
            listeners.add(iter.next)
          end
        end
        # Fire event on each progress listener
        iter_ = listeners.iterator
        while iter_.has_next
          pl = iter_.next
          pe = ProgressEvent.new(pi, pi.get_url, pi.get_method, pi.get_content_type, pi.get_state, pi.get_progress, pi.get_expected)
          pl.progress_start(pe)
        end
      end
    end
    
    typesig { [ProgressSource] }
    # 
    # Unregister progress source when progress is finished.
    def unregister_source(pi)
      synchronized((@progress_source_list)) do
        # Return if ProgressEvent does not exist
        if ((@progress_source_list.contains(pi)).equal?(false))
          return
        end
        # Close entry and remove from map
        pi.close
        @progress_source_list.remove(pi)
      end
      # Notify only if there is at least one listener
      if (@progress_listener_list.size > 0)
        # Notify progress listener if there is progress change
        listeners = ArrayList.new
        # Copy progress listeners to another list to avoid holding locks
        synchronized((@progress_listener_list)) do
          iter = @progress_listener_list.iterator
          while iter.has_next
            listeners.add(iter.next)
          end
        end
        # Fire event on each progress listener
        iter_ = listeners.iterator
        while iter_.has_next
          pl = iter_.next
          pe = ProgressEvent.new(pi, pi.get_url, pi.get_method, pi.get_content_type, pi.get_state, pi.get_progress, pi.get_expected)
          pl.progress_finish(pe)
        end
      end
    end
    
    typesig { [ProgressSource] }
    # 
    # Progress source is updated.
    def update_progress(pi)
      synchronized((@progress_source_list)) do
        if ((@progress_source_list.contains(pi)).equal?(false))
          return
        end
      end
      # Notify only if there is at least one listener
      if (@progress_listener_list.size > 0)
        # Notify progress listener if there is progress change
        listeners = ArrayList.new
        # Copy progress listeners to another list to avoid holding locks
        synchronized((@progress_listener_list)) do
          iter = @progress_listener_list.iterator
          while iter.has_next
            listeners.add(iter.next)
          end
        end
        # Fire event on each progress listener
        iter_ = listeners.iterator
        while iter_.has_next
          pl = iter_.next
          pe = ProgressEvent.new(pi, pi.get_url, pi.get_method, pi.get_content_type, pi.get_state, pi.get_progress, pi.get_expected)
          pl.progress_update(pe)
        end
      end
    end
    
    typesig { [ProgressListener] }
    # 
    # Add progress listener in progress monitor.
    def add_progress_listener(l)
      synchronized((@progress_listener_list)) do
        @progress_listener_list.add(l)
      end
    end
    
    typesig { [ProgressListener] }
    # 
    # Remove progress listener from progress monitor.
    def remove_progress_listener(l)
      synchronized((@progress_listener_list)) do
        @progress_listener_list.remove(l)
      end
    end
    
    class_module.module_eval {
      # Metering policy
      
      def metering_policy
        defined?(@@metering_policy) ? @@metering_policy : @@metering_policy= DefaultProgressMeteringPolicy.new
      end
      alias_method :attr_metering_policy, :metering_policy
      
      def metering_policy=(value)
        @@metering_policy = value
      end
      alias_method :attr_metering_policy=, :metering_policy=
      
      # Default implementation
      
      def pm
        defined?(@@pm) ? @@pm : @@pm= ProgressMonitor.new
      end
      alias_method :attr_pm, :pm
      
      def pm=(value)
        @@pm = value
      end
      alias_method :attr_pm=, :pm=
    }
    
    # ArrayList for outstanding progress sources
    attr_accessor :progress_source_list
    alias_method :attr_progress_source_list, :progress_source_list
    undef_method :progress_source_list
    alias_method :attr_progress_source_list=, :progress_source_list=
    undef_method :progress_source_list=
    
    # ArrayList for progress listeners
    attr_accessor :progress_listener_list
    alias_method :attr_progress_listener_list, :progress_listener_list
    undef_method :progress_listener_list
    alias_method :attr_progress_listener_list=, :progress_listener_list=
    undef_method :progress_listener_list=
    
    typesig { [] }
    def initialize
      @progress_source_list = ArrayList.new
      @progress_listener_list = ArrayList.new
    end
    
    private
    alias_method :initialize__progress_monitor, :initialize
  end
  
  # 
  # Default progress metering policy.
  class DefaultProgressMeteringPolicy 
    include_class_members ProgressMonitorImports
    include ProgressMeteringPolicy
    
    typesig { [URL, String] }
    # 
    # Return true if metering should be turned on for a particular network input stream.
    def should_meter_input(url, method)
      # By default, no URL input stream is metered for
      # performance reason.
      return false
    end
    
    typesig { [] }
    # 
    # Return update notification threshold.
    def get_progress_update_threshold
      # 8K - same as default I/O buffer size
      return 8192
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__default_progress_metering_policy, :initialize
  end
  
end

require "rjava"

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
module Java::Lang::Management
  module MonitorInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
      include_const ::Javax::Management::Openmbean, :CompositeData
      include_const ::Sun::Management, :MonitorInfoCompositeData
    }
  end
  
  # Information about an object monitor lock.  An object monitor is locked
  # when entering a synchronization block or method on that object.
  # 
  # <h4>MXBean Mapping</h4>
  # <tt>MonitorInfo</tt> is mapped to a {@link CompositeData CompositeData}
  # with attributes as specified in
  # the {@link #from from} method.
  # 
  # @author  Mandy Chung
  # @since   1.6
  class MonitorInfo < MonitorInfoImports.const_get :LockInfo
    include_class_members MonitorInfoImports
    
    attr_accessor :stack_depth
    alias_method :attr_stack_depth, :stack_depth
    undef_method :stack_depth
    alias_method :attr_stack_depth=, :stack_depth=
    undef_method :stack_depth=
    
    attr_accessor :stack_frame
    alias_method :attr_stack_frame, :stack_frame
    undef_method :stack_frame
    alias_method :attr_stack_frame=, :stack_frame=
    undef_method :stack_frame=
    
    typesig { [String, ::Java::Int, ::Java::Int, StackTraceElement] }
    # Construct a <tt>MonitorInfo</tt> object.
    # 
    # @param className the fully qualified name of the class of the lock object.
    # @param identityHashCode the {@link System#identityHashCode
    #                         identity hash code} of the lock object.
    # @param stackDepth the depth in the stack trace where the object monitor
    #                   was locked.
    # @param stackFrame the stack frame that locked the object monitor.
    # @throws IllegalArgumentException if
    #    <tt>stackDepth</tt> &ge; 0 but <tt>stackFrame</tt> is <tt>null</tt>,
    #    or <tt>stackDepth</tt> &lt; 0 but <tt>stackFrame</tt> is not
    #       <tt>null</tt>.
    def initialize(class_name, identity_hash_code, stack_depth, stack_frame)
      @stack_depth = 0
      @stack_frame = nil
      super(class_name, identity_hash_code)
      if (stack_depth >= 0 && (stack_frame).nil?)
        raise IllegalArgumentException.new("Parameter stackDepth is " + RJava.cast_to_string(stack_depth) + " but stackFrame is null")
      end
      if (stack_depth < 0 && !(stack_frame).nil?)
        raise IllegalArgumentException.new("Parameter stackDepth is " + RJava.cast_to_string(stack_depth) + " but stackFrame is not null")
      end
      @stack_depth = stack_depth
      @stack_frame = stack_frame
    end
    
    typesig { [] }
    # Returns the depth in the stack trace where the object monitor
    # was locked.  The depth is the index to the <tt>StackTraceElement</tt>
    # array returned in the {@link ThreadInfo#getStackTrace} method.
    # 
    # @return the depth in the stack trace where the object monitor
    #         was locked, or a negative number if not available.
    def get_locked_stack_depth
      return @stack_depth
    end
    
    typesig { [] }
    # Returns the stack frame that locked the object monitor.
    # 
    # @return <tt>StackTraceElement</tt> that locked the object monitor,
    #         or <tt>null</tt> if not available.
    def get_locked_stack_frame
      return @stack_frame
    end
    
    class_module.module_eval {
      typesig { [CompositeData] }
      # Returns a <tt>MonitorInfo</tt> object represented by the
      # given <tt>CompositeData</tt>.
      # The given <tt>CompositeData</tt> must contain the following attributes
      # as well as the attributes specified in the
      # <a href="LockInfo.html#MappedType">
      # mapped type</a> for the {@link LockInfo} class:
      # <blockquote>
      # <table border>
      # <tr>
      #   <th align=left>Attribute Name</th>
      #   <th align=left>Type</th>
      # </tr>
      # <tr>
      #   <td>lockedStackFrame</td>
      #   <td><tt>CompositeData as specified in the
      #       <a href="ThreadInfo.html#StackTrace">stackTrace</a>
      #       attribute defined in the {@link ThreadInfo#from
      #       ThreadInfo.from} method.
      #       </tt></td>
      # </tr>
      # <tr>
      #   <td>lockedStackDepth</td>
      #   <td><tt>java.lang.Integer</tt></td>
      # </tr>
      # </table>
      # </blockquote>
      # 
      # @param cd <tt>CompositeData</tt> representing a <tt>MonitorInfo</tt>
      # 
      # @throws IllegalArgumentException if <tt>cd</tt> does not
      #   represent a <tt>MonitorInfo</tt> with the attributes described
      #   above.
      # 
      # @return a <tt>MonitorInfo</tt> object represented
      #         by <tt>cd</tt> if <tt>cd</tt> is not <tt>null</tt>;
      #         <tt>null</tt> otherwise.
      def from(cd)
        if ((cd).nil?)
          return nil
        end
        if (cd.is_a?(MonitorInfoCompositeData))
          return (cd).get_monitor_info
        else
          MonitorInfoCompositeData.validate_composite_data(cd)
          class_name = MonitorInfoCompositeData.get_class_name(cd)
          identity_hash_code = MonitorInfoCompositeData.get_identity_hash_code(cd)
          stack_depth = MonitorInfoCompositeData.get_locked_stack_depth(cd)
          stack_frame = MonitorInfoCompositeData.get_locked_stack_frame(cd)
          return MonitorInfo.new(class_name, identity_hash_code, stack_depth, stack_frame)
        end
      end
    }
    
    private
    alias_method :initialize__monitor_info, :initialize
  end
  
end

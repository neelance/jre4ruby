require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MemoryUsageImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
      include_const ::Javax::Management::Openmbean, :CompositeData
      include_const ::Sun::Management, :MemoryUsageCompositeData
    }
  end
  
  # A <tt>MemoryUsage</tt> object represents a snapshot of memory usage.
  # Instances of the <tt>MemoryUsage</tt> class are usually constructed
  # by methods that are used to obtain memory usage
  # information about individual memory pool of the Java virtual machine or
  # the heap or non-heap memory of the Java virtual machine as a whole.
  # 
  # <p> A <tt>MemoryUsage</tt> object contains four values:
  # <ul>
  # <table>
  # <tr>
  # <td valign=top> <tt>init</tt> </td>
  # <td valign=top> represents the initial amount of memory (in bytes) that
  # the Java virtual machine requests from the operating system
  # for memory management during startup.  The Java virtual machine
  # may request additional memory from the operating system and
  # may also release memory to the system over time.
  # The value of <tt>init</tt> may be undefined.
  # </td>
  # </tr>
  # <tr>
  # <td valign=top> <tt>used</tt> </td>
  # <td valign=top> represents the amount of memory currently used (in bytes).
  # </td>
  # </tr>
  # <tr>
  # <td valign=top> <tt>committed</tt> </td>
  # <td valign=top> represents the amount of memory (in bytes) that is
  # guaranteed to be available for use by the Java virtual machine.
  # The amount of committed memory may change over time (increase
  # or decrease).  The Java virtual machine may release memory to
  # the system and <tt>committed</tt> could be less than <tt>init</tt>.
  # <tt>committed</tt> will always be greater than
  # or equal to <tt>used</tt>.
  # </td>
  # </tr>
  # <tr>
  # <td valign=top> <tt>max</tt> </td>
  # <td valign=top> represents the maximum amount of memory (in bytes)
  # that can be used for memory management. Its value may be undefined.
  # The maximum amount of memory may change over time if defined.
  # The amount of used and committed memory will always be less than
  # or equal to <tt>max</tt> if <tt>max</tt> is defined.
  # A memory allocation may fail if it attempts to increase the
  # used memory such that <tt>used &gt committed</tt> even
  # if <tt>used &lt= max</tt> would still be true (for example,
  # when the system is low on virtual memory).
  # </td>
  # </tr>
  # </table>
  # </ul>
  # 
  # Below is a picture showing an example of a memory pool:
  # <p>
  # <pre>
  # +----------------------------------------------+
  # +////////////////           |                  +
  # +////////////////           |                  +
  # +----------------------------------------------+
  # 
  # |--------|
  # init
  # |---------------|
  # used
  # |---------------------------|
  # committed
  # |----------------------------------------------|
  # max
  # </pre>
  # 
  # <h4>MXBean Mapping</h4>
  # <tt>MemoryUsage</tt> is mapped to a {@link CompositeData CompositeData}
  # with attributes as specified in the {@link #from from} method.
  # 
  # @author   Mandy Chung
  # @since   1.5
  class MemoryUsage 
    include_class_members MemoryUsageImports
    
    attr_accessor :init
    alias_method :attr_init, :init
    undef_method :init
    alias_method :attr_init=, :init=
    undef_method :init=
    
    attr_accessor :used
    alias_method :attr_used, :used
    undef_method :used
    alias_method :attr_used=, :used=
    undef_method :used=
    
    attr_accessor :committed
    alias_method :attr_committed, :committed
    undef_method :committed
    alias_method :attr_committed=, :committed=
    undef_method :committed=
    
    attr_accessor :max
    alias_method :attr_max, :max
    undef_method :max
    alias_method :attr_max=, :max=
    undef_method :max=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long] }
    # Constructs a <tt>MemoryUsage</tt> object.
    # 
    # @param init      the initial amount of memory in bytes that
    # the Java virtual machine allocates;
    # or <tt>-1</tt> if undefined.
    # @param used      the amount of used memory in bytes.
    # @param committed the amount of committed memory in bytes.
    # @param max       the maximum amount of memory in bytes that
    # can be used; or <tt>-1</tt> if undefined.
    # 
    # @throws IllegalArgumentException if
    # <ul>
    # <li> the value of <tt>init</tt> or <tt>max</tt> is negative
    # but not <tt>-1</tt>; or</li>
    # <li> the value of <tt>used</tt> or <tt>committed</tt> is negative;
    # or</li>
    # <li> <tt>used</tt> is greater than the value of <tt>committed</tt>;
    # or</li>
    # <li> <tt>committed</tt> is greater than the value of <tt>max</tt>
    # <tt>max</tt> if defined.</li>
    # </ul>
    def initialize(init, used, committed, max)
      @init = 0
      @used = 0
      @committed = 0
      @max = 0
      if (init < -1)
        raise IllegalArgumentException.new("init parameter = " + (init).to_s + " is negative but not -1.")
      end
      if (max < -1)
        raise IllegalArgumentException.new("max parameter = " + (max).to_s + " is negative but not -1.")
      end
      if (used < 0)
        raise IllegalArgumentException.new("used parameter = " + (used).to_s + " is negative.")
      end
      if (committed < 0)
        raise IllegalArgumentException.new("committed parameter = " + (committed).to_s + " is negative.")
      end
      if (used > committed)
        raise IllegalArgumentException.new("used = " + (used).to_s + " should be <= committed = " + (committed).to_s)
      end
      if (max >= 0 && committed > max)
        raise IllegalArgumentException.new("committed = " + (committed).to_s + " should be < max = " + (max).to_s)
      end
      @init = init
      @used = used
      @committed = committed
      @max = max
    end
    
    typesig { [CompositeData] }
    # Constructs a <tt>MemoryUsage</tt> object from a
    # {@link CompositeData CompositeData}.
    def initialize(cd)
      @init = 0
      @used = 0
      @committed = 0
      @max = 0
      # validate the input composite data
      MemoryUsageCompositeData.validate_composite_data(cd)
      @init = MemoryUsageCompositeData.get_init(cd)
      @used = MemoryUsageCompositeData.get_used(cd)
      @committed = MemoryUsageCompositeData.get_committed(cd)
      @max = MemoryUsageCompositeData.get_max(cd)
    end
    
    typesig { [] }
    # Returns the amount of memory in bytes that the Java virtual machine
    # initially requests from the operating system for memory management.
    # This method returns <tt>-1</tt> if the initial memory size is undefined.
    # 
    # @return the initial size of memory in bytes;
    # <tt>-1</tt> if undefined.
    def get_init
      return @init
    end
    
    typesig { [] }
    # Returns the amount of used memory in bytes.
    # 
    # @return the amount of used memory in bytes.
    def get_used
      return @used
    end
    
    typesig { [] }
    # Returns the amount of memory in bytes that is committed for
    # the Java virtual machine to use.  This amount of memory is
    # guaranteed for the Java virtual machine to use.
    # 
    # @return the amount of committed memory in bytes.
    def get_committed
      return @committed
    end
    
    typesig { [] }
    # Returns the maximum amount of memory in bytes that can be
    # used for memory management.  This method returns <tt>-1</tt>
    # if the maximum memory size is undefined.
    # 
    # <p> This amount of memory is not guaranteed to be available
    # for memory management if it is greater than the amount of
    # committed memory.  The Java virtual machine may fail to allocate
    # memory even if the amount of used memory does not exceed this
    # maximum size.
    # 
    # @return the maximum amount of memory in bytes;
    # <tt>-1</tt> if undefined.
    def get_max
      return @max
    end
    
    typesig { [] }
    # Returns a descriptive representation of this memory usage.
    def to_s
      buf = StringBuffer.new
      buf.append("init = " + (@init).to_s + "(" + ((@init >> 10)).to_s + "K) ")
      buf.append("used = " + (@used).to_s + "(" + ((@used >> 10)).to_s + "K) ")
      buf.append("committed = " + (@committed).to_s + "(" + ((@committed >> 10)).to_s + "K) ")
      buf.append("max = " + (@max).to_s + "(" + ((@max >> 10)).to_s + "K)")
      return buf.to_s
    end
    
    class_module.module_eval {
      typesig { [CompositeData] }
      # Returns a <tt>MemoryUsage</tt> object represented by the
      # given <tt>CompositeData</tt>. The given <tt>CompositeData</tt>
      # must contain the following attributes:
      # <p>
      # <blockquote>
      # <table border>
      # <tr>
      # <th align=left>Attribute Name</th>
      # <th align=left>Type</th>
      # </tr>
      # <tr>
      # <td>init</td>
      # <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      # <td>used</td>
      # <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      # <td>committed</td>
      # <td><tt>java.lang.Long</tt></td>
      # </tr>
      # <tr>
      # <td>max</td>
      # <td><tt>java.lang.Long</tt></td>
      # </tr>
      # </table>
      # </blockquote>
      # 
      # @param cd <tt>CompositeData</tt> representing a <tt>MemoryUsage</tt>
      # 
      # @throws IllegalArgumentException if <tt>cd</tt> does not
      # represent a <tt>MemoryUsage</tt> with the attributes described
      # above.
      # 
      # @return a <tt>MemoryUsage</tt> object represented by <tt>cd</tt>
      # if <tt>cd</tt> is not <tt>null</tt>;
      # <tt>null</tt> otherwise.
      def from(cd)
        if ((cd).nil?)
          return nil
        end
        if (cd.is_a?(MemoryUsageCompositeData))
          return (cd).get_memory_usage
        else
          return MemoryUsage.new(cd)
        end
      end
    }
    
    private
    alias_method :initialize__memory_usage, :initialize
  end
  
end

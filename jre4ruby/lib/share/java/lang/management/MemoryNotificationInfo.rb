require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MemoryNotificationInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
      include_const ::Javax::Management::Openmbean, :CompositeData
      include_const ::Sun::Management, :MemoryNotifInfoCompositeData
    }
  end
  
  # The information about a memory notification.
  # 
  # <p>
  # A memory notification is emitted by {@link MemoryMXBean}
  # when the Java virtual machine detects that the memory usage
  # of a memory pool is exceeding a threshold value.
  # The notification emitted will contain the memory notification
  # information about the detected condition:
  # <ul>
  # <li>The name of the memory pool.</li>
  # <li>The memory usage of the memory pool when the notification
  # was constructed.</li>
  # <li>The number of times that the memory usage has crossed
  # a threshold when the notification was constructed.
  # For usage threshold notifications, this count will be the
  # {@link MemoryPoolMXBean#getUsageThresholdCount usage threshold
  # count}.  For collection threshold notifications,
  # this count will be the
  # {@link MemoryPoolMXBean#getCollectionUsageThresholdCount
  # collection usage threshold count}.
  # </li>
  # </ul>
  # 
  # <p>
  # A {@link CompositeData CompositeData} representing
  # the <tt>MemoryNotificationInfo</tt> object
  # is stored in the
  # {@link javax.management.Notification#setUserData user data}
  # of a {@link javax.management.Notification notification}.
  # The {@link #from from} method is provided to convert from
  # a <tt>CompositeData</tt> to a <tt>MemoryNotificationInfo</tt>
  # object. For example:
  # 
  # <blockquote><pre>
  # Notification notif;
  # 
  # // receive the notification emitted by MemoryMXBean and set to notif
  # ...
  # 
  # String notifType = notif.getType();
  # if (notifType.equals(MemoryNotificationInfo.MEMORY_THRESHOLD_EXCEEDED) ||
  # notifType.equals(MemoryNotificationInfo.MEMORY_COLLECTION_THRESHOLD_EXCEEDED)) {
  # // retrieve the memory notification information
  # CompositeData cd = (CompositeData) notif.getUserData();
  # MemoryNotificationInfo info = MemoryNotificationInfo.from(cd);
  # ....
  # }
  # </pre></blockquote>
  # 
  # <p>
  # The types of notifications emitted by <tt>MemoryMXBean</tt> are:
  # <ul>
  # <li>A {@link #MEMORY_THRESHOLD_EXCEEDED
  # usage threshold exceeded notification}.
  # <br>This notification will be emitted when
  # the memory usage of a memory pool is increased and has reached
  # or exceeded its
  # <a href="MemoryPoolMXBean.html#UsageThreshold"> usage threshold</a> value.
  # Subsequent crossing of the usage threshold value does not cause
  # further notification until the memory usage has returned
  # to become less than the usage threshold value.
  # <p></li>
  # <li>A {@link #MEMORY_COLLECTION_THRESHOLD_EXCEEDED
  # collection usage threshold exceeded notification}.
  # <br>This notification will be emitted when
  # the memory usage of a memory pool is greater than or equal to its
  # <a href="MemoryPoolMXBean.html#CollectionThreshold">
  # collection usage threshold</a> after the Java virtual machine
  # has expended effort in recycling unused objects in that
  # memory pool.</li>
  # </ul>
  # 
  # @author  Mandy Chung
  # @since   1.5
  class MemoryNotificationInfo 
    include_class_members MemoryNotificationInfoImports
    
    attr_accessor :pool_name
    alias_method :attr_pool_name, :pool_name
    undef_method :pool_name
    alias_method :attr_pool_name=, :pool_name=
    undef_method :pool_name=
    
    attr_accessor :usage
    alias_method :attr_usage, :usage
    undef_method :usage
    alias_method :attr_usage=, :usage=
    undef_method :usage=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    class_module.module_eval {
      # Notification type denoting that
      # the memory usage of a memory pool has
      # reached or exceeded its
      # <a href="MemoryPoolMXBean.html#UsageThreshold"> usage threshold</a> value.
      # This notification is emitted by {@link MemoryMXBean}.
      # Subsequent crossing of the usage threshold value does not cause
      # further notification until the memory usage has returned
      # to become less than the usage threshold value.
      # The value of this notification type is
      # <tt>java.management.memory.threshold.exceeded</tt>.
      const_set_lazy(:MEMORY_THRESHOLD_EXCEEDED) { "java.management.memory.threshold.exceeded" }
      const_attr_reader  :MEMORY_THRESHOLD_EXCEEDED
      
      # Notification type denoting that
      # the memory usage of a memory pool is greater than or equal to its
      # <a href="MemoryPoolMXBean.html#CollectionThreshold">
      # collection usage threshold</a> after the Java virtual machine
      # has expended effort in recycling unused objects in that
      # memory pool.
      # This notification is emitted by {@link MemoryMXBean}.
      # The value of this notification type is
      # <tt>java.management.memory.collection.threshold.exceeded</tt>.
      const_set_lazy(:MEMORY_COLLECTION_THRESHOLD_EXCEEDED) { "java.management.memory.collection.threshold.exceeded" }
      const_attr_reader  :MEMORY_COLLECTION_THRESHOLD_EXCEEDED
    }
    
    typesig { [String, MemoryUsage, ::Java::Long] }
    # Constructs a <tt>MemoryNotificationInfo</tt> object.
    # 
    # @param poolName The name of the memory pool which triggers this notification.
    # @param usage Memory usage of the memory pool.
    # @param count The threshold crossing count.
    def initialize(pool_name, usage, count)
      @pool_name = nil
      @usage = nil
      @count = 0
      if ((pool_name).nil?)
        raise NullPointerException.new("Null poolName")
      end
      if ((usage).nil?)
        raise NullPointerException.new("Null usage")
      end
      @pool_name = pool_name
      @usage = usage
      @count = count
    end
    
    typesig { [CompositeData] }
    def initialize(cd)
      @pool_name = nil
      @usage = nil
      @count = 0
      MemoryNotifInfoCompositeData.validate_composite_data(cd)
      @pool_name = MemoryNotifInfoCompositeData.get_pool_name(cd)
      @usage = MemoryNotifInfoCompositeData.get_usage(cd)
      @count = MemoryNotifInfoCompositeData.get_count(cd)
    end
    
    typesig { [] }
    # Returns the name of the memory pool that triggers this notification.
    # The memory pool usage has crossed a threshold.
    # 
    # @return the name of the memory pool that triggers this notification.
    def get_pool_name
      return @pool_name
    end
    
    typesig { [] }
    # Returns the memory usage of the memory pool
    # when this notification was constructed.
    # 
    # @return the memory usage of the memory pool
    # when this notification was constructed.
    def get_usage
      return @usage
    end
    
    typesig { [] }
    # Returns the number of times that the memory usage has crossed
    # a threshold when the notification was constructed.
    # For usage threshold notifications, this count will be the
    # {@link MemoryPoolMXBean#getUsageThresholdCount threshold
    # count}.  For collection threshold notifications,
    # this count will be the
    # {@link MemoryPoolMXBean#getCollectionUsageThresholdCount
    # collection usage threshold count}.
    # 
    # @return the number of times that the memory usage has crossed
    # a threshold when the notification was constructed.
    def get_count
      return @count
    end
    
    class_module.module_eval {
      typesig { [CompositeData] }
      # Returns a <tt>MemoryNotificationInfo</tt> object represented by the
      # given <tt>CompositeData</tt>.
      # The given <tt>CompositeData</tt> must contain
      # the following attributes:
      # <blockquote>
      # <table border>
      # <tr>
      # <th align=left>Attribute Name</th>
      # <th align=left>Type</th>
      # </tr>
      # <tr>
      # <td>poolName</td>
      # <td><tt>java.lang.String</tt></td>
      # </tr>
      # <tr>
      # <td>usage</td>
      # <td><tt>javax.management.openmbean.CompositeData</tt></td>
      # </tr>
      # <tr>
      # <td>count</td>
      # <td><tt>java.lang.Long</tt></td>
      # </tr>
      # </table>
      # </blockquote>
      # 
      # @param cd <tt>CompositeData</tt> representing a
      # <tt>MemoryNotificationInfo</tt>
      # 
      # @throws IllegalArgumentException if <tt>cd</tt> does not
      # represent a <tt>MemoryNotificationInfo</tt> object.
      # 
      # @return a <tt>MemoryNotificationInfo</tt> object represented
      # by <tt>cd</tt> if <tt>cd</tt> is not <tt>null</tt>;
      # <tt>null</tt> otherwise.
      def from(cd)
        if ((cd).nil?)
          return nil
        end
        if (cd.is_a?(MemoryNotifInfoCompositeData))
          return (cd).get_memory_notif_info
        else
          return MemoryNotificationInfo.new(cd)
        end
      end
    }
    
    private
    alias_method :initialize__memory_notification_info, :initialize
  end
  
end

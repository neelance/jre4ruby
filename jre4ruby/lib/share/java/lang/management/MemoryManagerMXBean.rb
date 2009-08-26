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
  module MemoryManagerMXBeanImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
    }
  end
  
  # The management interface for a memory manager.
  # A memory manager manages one or more memory pools of the
  # Java virtual machine.
  # 
  # <p> A Java virtual machine has one or more memory managers.
  # An instance implementing this interface is
  # an <a href="ManagementFactory.html#MXBean">MXBean</a>
  # that can be obtained by calling
  # the {@link ManagementFactory#getMemoryManagerMXBeans} method or
  # from the {@link ManagementFactory#getPlatformMBeanServer
  # platform <tt>MBeanServer</tt>} method.
  # 
  # <p>The <tt>ObjectName</tt> for uniquely identifying the MXBean for
  # a memory manager within an MBeanServer is:
  # <blockquote>
  # {@link ManagementFactory#MEMORY_MANAGER_MXBEAN_DOMAIN_TYPE
  # <tt>java.lang:type=MemoryManager</tt>}<tt>,name=</tt><i>manager's name</i>
  # </blockquote>
  # 
  # @see MemoryMXBean
  # 
  # @see <a href="../../../javax/management/package-summary.html">
  # JMX Specification.</a>
  # @see <a href="package-summary.html#examples">
  # Ways to Access MXBeans</a>
  # 
  # @author  Mandy Chung
  # @since   1.5
  module MemoryManagerMXBean
    include_class_members MemoryManagerMXBeanImports
    
    typesig { [] }
    # Returns the name representing this memory manager.
    # 
    # @return the name of this memory manager.
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tests if this memory manager is valid in the Java virtual
    # machine.  A memory manager becomes invalid once the Java virtual
    # machine removes it from the memory system.
    # 
    # @return <tt>true</tt> if the memory manager is valid in the
    # Java virtual machine;
    # <tt>false</tt> otherwise.
    def is_valid
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the name of memory pools that this memory manager manages.
    # 
    # @return an array of <tt>String</tt> objects, each is
    # the name of a memory pool that this memory manager manages.
    def get_memory_pool_names
      raise NotImplementedError
    end
  end
  
end
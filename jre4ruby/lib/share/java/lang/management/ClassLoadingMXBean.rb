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
  module ClassLoadingMXBeanImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
    }
  end
  
  # The management interface for the class loading system of
  # the Java virtual machine.
  # 
  # <p> A Java virtual machine has a single instance of the implementation
  # class of this interface.  This instance implementing this interface is
  # an <a href="ManagementFactory.html#MXBean">MXBean</a>
  # that can be obtained by calling
  # the {@link ManagementFactory#getClassLoadingMXBean} method or
  # from the {@link ManagementFactory#getPlatformMBeanServer
  # platform <tt>MBeanServer</tt>} method.
  # 
  # <p>The <tt>ObjectName</tt> for uniquely identifying the MXBean for
  # the class loading system within an <tt>MBeanServer</tt> is:
  # <blockquote>
  # {@link ManagementFactory#CLASS_LOADING_MXBEAN_NAME
  #        <tt>java.lang:type=ClassLoading</tt>}
  # </blockquote>
  # 
  # @see <a href="../../../javax/management/package-summary.html">
  #      JMX Specification.</a>
  # @see <a href="package-summary.html#examples">
  #      Ways to Access MXBeans</a>
  # 
  # @author  Mandy Chung
  # @since   1.5
  module ClassLoadingMXBean
    include_class_members ClassLoadingMXBeanImports
    
    typesig { [] }
    # Returns the total number of classes that have been loaded since
    # the Java virtual machine has started execution.
    # 
    # @return the total number of classes loaded.
    def get_total_loaded_class_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of classes that are currently loaded in the
    # Java virtual machine.
    # 
    # @return the number of currently loaded classes.
    def get_loaded_class_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the total number of classes unloaded since the Java virtual machine
    # has started execution.
    # 
    # @return the total number of unloaded classes.
    def get_unloaded_class_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tests if the verbose output for the class loading system is enabled.
    # 
    # @return <tt>true</tt> if the verbose output for the class loading
    # system is enabled; <tt>false</tt> otherwise.
    def is_verbose
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables or disables the verbose output for the class loading
    # system.  The verbose output information and the output stream
    # to which the verbose information is emitted are implementation
    # dependent.  Typically, a Java virtual machine implementation
    # prints a message each time a class file is loaded.
    # 
    # <p>This method can be called by multiple threads concurrently.
    # Each invocation of this method enables or disables the verbose
    # output globally.
    # 
    # @param value <tt>true</tt> to enable the verbose output;
    #              <tt>false</tt> to disable.
    # 
    # @exception  java.lang.SecurityException if a security manager
    #             exists and the caller does not have
    #             ManagementPermission("control").
    def set_verbose(value)
      raise NotImplementedError
    end
  end
  
end

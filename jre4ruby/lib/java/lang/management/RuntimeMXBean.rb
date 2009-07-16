require "rjava"

# 
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
  module RuntimeMXBeanImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
    }
  end
  
  # 
  # The management interface for the runtime system of
  # the Java virtual machine.
  # 
  # <p> A Java virtual machine has a single instance of the implementation
  # class of this interface.  This instance implementing this interface is
  # an <a href="ManagementFactory.html#MXBean">MXBean</a>
  # that can be obtained by calling
  # the {@link ManagementFactory#getRuntimeMXBean} method or
  # from the {@link ManagementFactory#getPlatformMBeanServer
  # platform <tt>MBeanServer</tt>} method.
  # 
  # <p>The <tt>ObjectName</tt> for uniquely identifying the MXBean for
  # the runtime system within an MBeanServer is:
  # <blockquote>
  # {@link ManagementFactory#RUNTIME_MXBEAN_NAME
  # <tt>java.lang:type=Runtime</tt>}
  # </blockquote>
  # 
  # <p> This interface defines several convenient methods for accessing
  # system properties about the Java virtual machine.
  # 
  # @see <a href="../../../javax/management/package-summary.html">
  # JMX Specification.</a>
  # @see <a href="package-summary.html#examples">
  # Ways to Access MXBeans</a>
  # 
  # @author  Mandy Chung
  # @since   1.5
  module RuntimeMXBean
    include_class_members RuntimeMXBeanImports
    
    typesig { [] }
    # 
    # Returns the name representing the running Java virtual machine.
    # The returned name string can be any arbitrary string and
    # a Java virtual machine implementation can choose
    # to embed platform-specific useful information in the
    # returned name string.  Each running virtual machine could have
    # a different name.
    # 
    # @return the name representing the running Java virtual machine.
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine implementation name.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.name")}.
    # 
    # @return the Java virtual machine implementation name.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_vm_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine implementation vendor.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.vendor")}.
    # 
    # @return the Java virtual machine implementation vendor.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_vm_vendor
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine implementation version.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.version")}.
    # 
    # @return the Java virtual machine implementation version.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_vm_version
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine specification name.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.specification.name")}.
    # 
    # @return the Java virtual machine specification name.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_spec_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine specification vendor.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.specification.vendor")}.
    # 
    # @return the Java virtual machine specification vendor.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_spec_vendor
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java virtual machine specification version.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.vm.specification.version")}.
    # 
    # @return the Java virtual machine specification version.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_spec_version
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the version of the specification for the management interface
    # implemented by the running Java virtual machine.
    # 
    # @return the version of the specification for the management interface
    # implemented by the running Java virtual machine.
    def get_management_spec_version
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java class path that is used by the system class loader
    # to search for class files.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.class.path")}.
    # 
    # <p> Multiple paths in the Java class path are separated by the
    # path separator character of the platform of the Java virtual machine
    # being monitored.
    # 
    # @return the Java class path.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_class_path
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Java library path.
    # This method is equivalent to {@link System#getProperty
    # System.getProperty("java.library.path")}.
    # 
    # <p> Multiple paths in the Java library path are separated by the
    # path separator character of the platform of the Java virtual machine
    # being monitored.
    # 
    # @return the Java library path.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to this system property.
    # @see java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
    # @see java.lang.System#getProperty
    def get_library_path
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Tests if the Java virtual machine supports the boot class path
    # mechanism used by the bootstrap class loader to search for class
    # files.
    # 
    # @return <tt>true</tt> if the Java virtual machine supports the
    # class path mechanism; <tt>false</tt> otherwise.
    def is_boot_class_path_supported
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the boot class path that is used by the bootstrap class loader
    # to search for class files.
    # 
    # <p> Multiple paths in the boot class path are separated by the
    # path separator character of the platform on which the Java
    # virtual machine is running.
    # 
    # <p>A Java virtual machine implementation may not support
    # the boot class path mechanism for the bootstrap class loader
    # to search for class files.
    # The {@link #isBootClassPathSupported} method can be used
    # to determine if the Java virtual machine supports this method.
    # 
    # @return the boot class path.
    # 
    # @throws java.lang.UnsupportedOperationException
    # if the Java virtual machine does not support this operation.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and the caller does not have
    # ManagementPermission("monitor").
    def get_boot_class_path
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the input arguments passed to the Java virtual machine
    # which does not include the arguments to the <tt>main</tt> method.
    # This method returns an empty list if there is no input argument
    # to the Java virtual machine.
    # <p>
    # Some Java virtual machine implementations may take input arguments
    # from multiple different sources: for examples, arguments passed from
    # the application that launches the Java virtual machine such as
    # the 'java' command, environment variables, configuration files, etc.
    # <p>
    # Typically, not all command-line options to the 'java' command
    # are passed to the Java virtual machine.
    # Thus, the returned input arguments may not
    # include all command-line options.
    # 
    # <p>
    # <b>MBeanServer access</b>:<br>
    # The mapped type of <tt>List<String></tt> is <tt>String[]</tt>.
    # 
    # @return a list of <tt>String</tt> objects; each element
    # is an argument passed to the Java virtual machine.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and the caller does not have
    # ManagementPermission("monitor").
    def get_input_arguments
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the uptime of the Java virtual machine in milliseconds.
    # 
    # @return uptime of the Java virtual machine in milliseconds.
    def get_uptime
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the start time of the Java virtual machine in milliseconds.
    # This method returns the approximate time when the Java virtual
    # machine started.
    # 
    # @return start time of the Java virtual machine in milliseconds.
    def get_start_time
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns a map of names and values of all system properties.
    # This method calls {@link System#getProperties} to get all
    # system properties.  Properties whose name or value is not
    # a <tt>String</tt> are omitted.
    # 
    # <p>
    # <b>MBeanServer access</b>:<br>
    # The mapped type of <tt>Map<String,String></tt> is
    # {@link javax.management.openmbean.TabularData TabularData}
    # with two items in each row as follows:
    # <blockquote>
    # <table border>
    # <tr>
    # <th>Item Name</th>
    # <th>Item Type</th>
    # </tr>
    # <tr>
    # <td><tt>key</tt></td>
    # <td><tt>String</tt></td>
    # </tr>
    # <tr>
    # <td><tt>value</tt></td>
    # <td><tt>String</tt></td>
    # </tr>
    # </table>
    # </blockquote>
    # 
    # @return a map of names and values of all system properties.
    # 
    # @throws  java.lang.SecurityException
    # if a security manager exists and its
    # <code>checkPropertiesAccess</code> method doesn't allow access
    # to the system properties.
    def get_system_properties
      raise NotImplementedError
    end
  end
  
end

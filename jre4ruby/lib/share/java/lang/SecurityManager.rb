require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module SecurityManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FilePermission
      include_const ::Java::Awt, :AWTPermission
      include_const ::Java::Util, :PropertyPermission
      include_const ::Java::Lang, :RuntimePermission
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Net, :NetPermission
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Lang::Reflect, :Member
      include ::Java::Lang::Reflect
      include_const ::Java::Net, :URL
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # The security manager is a class that allows
  # applications to implement a security policy. It allows an
  # application to determine, before performing a possibly unsafe or
  # sensitive operation, what the operation is and whether
  # it is being attempted in a security context that allows the
  # operation to be performed. The
  # application can allow or disallow the operation.
  # <p>
  # The <code>SecurityManager</code> class contains many methods with
  # names that begin with the word <code>check</code>. These methods
  # are called by various methods in the Java libraries before those
  # methods perform certain potentially sensitive operations. The
  # invocation of such a <code>check</code> method typically looks like this:
  # <p><blockquote><pre>
  # SecurityManager security = System.getSecurityManager();
  # if (security != null) {
  # security.check<i>XXX</i>(argument, &nbsp;.&nbsp;.&nbsp;.&nbsp;);
  # }
  # </pre></blockquote>
  # <p>
  # The security manager is thereby given an opportunity to prevent
  # completion of the operation by throwing an exception. A security
  # manager routine simply returns if the operation is permitted, but
  # throws a <code>SecurityException</code> if the operation is not
  # permitted. The only exception to this convention is
  # <code>checkTopLevelWindow</code>, which returns a
  # <code>boolean</code> value.
  # <p>
  # The current security manager is set by the
  # <code>setSecurityManager</code> method in class
  # <code>System</code>. The current security manager is obtained
  # by the <code>getSecurityManager</code> method.
  # <p>
  # The special method
  # {@link SecurityManager#checkPermission(java.security.Permission)}
  # determines whether an access request indicated by a specified
  # permission should be granted or denied. The
  # default implementation calls
  # 
  # <pre>
  # AccessController.checkPermission(perm);
  # </pre>
  # 
  # <p>
  # If a requested access is allowed,
  # <code>checkPermission</code> returns quietly. If denied, a
  # <code>SecurityException</code> is thrown.
  # <p>
  # As of Java 2 SDK v1.2, the default implementation of each of the other
  # <code>check</code> methods in <code>SecurityManager</code> is to
  # call the <code>SecurityManager checkPermission</code> method
  # to determine if the calling thread has permission to perform the requested
  # operation.
  # <p>
  # Note that the <code>checkPermission</code> method with
  # just a single permission argument always performs security checks
  # within the context of the currently executing thread.
  # Sometimes a security check that should be made within a given context
  # will actually need to be done from within a
  # <i>different</i> context (for example, from within a worker thread).
  # The {@link SecurityManager#getSecurityContext getSecurityContext} method
  # and the {@link SecurityManager#checkPermission(java.security.Permission,
  # java.lang.Object) checkPermission}
  # method that includes a context argument are provided
  # for this situation. The
  # <code>getSecurityContext</code> method returns a "snapshot"
  # of the current calling context. (The default implementation
  # returns an AccessControlContext object.) A sample call is
  # the following:
  # 
  # <pre>
  # Object context = null;
  # SecurityManager sm = System.getSecurityManager();
  # if (sm != null) context = sm.getSecurityContext();
  # </pre>
  # 
  # <p>
  # The <code>checkPermission</code> method
  # that takes a context object in addition to a permission
  # makes access decisions based on that context,
  # rather than on that of the current execution thread.
  # Code within a different context can thus call that method,
  # passing the permission and the
  # previously-saved context object. A sample call, using the
  # SecurityManager <code>sm</code> obtained as in the previous example,
  # is the following:
  # 
  # <pre>
  # if (sm != null) sm.checkPermission(permission, context);
  # </pre>
  # 
  # <p>Permissions fall into these categories: File, Socket, Net,
  # Security, Runtime, Property, AWT, Reflect, and Serializable.
  # The classes managing these various
  # permission categories are <code>java.io.FilePermission</code>,
  # <code>java.net.SocketPermission</code>,
  # <code>java.net.NetPermission</code>,
  # <code>java.security.SecurityPermission</code>,
  # <code>java.lang.RuntimePermission</code>,
  # <code>java.util.PropertyPermission</code>,
  # <code>java.awt.AWTPermission</code>,
  # <code>java.lang.reflect.ReflectPermission</code>, and
  # <code>java.io.SerializablePermission</code>.
  # 
  # <p>All but the first two (FilePermission and SocketPermission) are
  # subclasses of <code>java.security.BasicPermission</code>, which itself
  # is an abstract subclass of the
  # top-level class for permissions, which is
  # <code>java.security.Permission</code>. BasicPermission defines the
  # functionality needed for all permissions that contain a name
  # that follows the hierarchical property naming convention
  # (for example, "exitVM", "setFactory", "queuePrintJob", etc).
  # An asterisk
  # may appear at the end of the name, following a ".", or by itself, to
  # signify a wildcard match. For example: "a.*" or "*" is valid,
  # "*a" or "a*b" is not valid.
  # 
  # <p>FilePermission and SocketPermission are subclasses of the
  # top-level class for permissions
  # (<code>java.security.Permission</code>). Classes like these
  # that have a more complicated name syntax than that used by
  # BasicPermission subclass directly from Permission rather than from
  # BasicPermission. For example,
  # for a <code>java.io.FilePermission</code> object, the permission name is
  # the path name of a file (or directory).
  # 
  # <p>Some of the permission classes have an "actions" list that tells
  # the actions that are permitted for the object.  For example,
  # for a <code>java.io.FilePermission</code> object, the actions list
  # (such as "read, write") specifies which actions are granted for the
  # specified file (or for files in the specified directory).
  # 
  # <p>Other permission classes are for "named" permissions -
  # ones that contain a name but no actions list; you either have the
  # named permission or you don't.
  # 
  # <p>Note: There is also a <code>java.security.AllPermission</code>
  # permission that implies all permissions. It exists to simplify the work
  # of system administrators who might need to perform multiple
  # tasks that require all (or numerous) permissions.
  # <p>
  # See <a href ="../../../technotes/guides/security/permissions.html">
  # Permissions in the JDK</a> for permission-related information.
  # This document includes, for example, a table listing the various SecurityManager
  # <code>check</code> methods and the permission(s) the default
  # implementation of each such method requires.
  # It also contains a table of all the version 1.2 methods
  # that require permissions, and for each such method tells
  # which permission it requires.
  # <p>
  # For more information about <code>SecurityManager</code> changes made in
  # the JDK and advice regarding porting of 1.1-style security managers,
  # see the <a href="../../../technotes/guides/security/index.html">security documentation</a>.
  # 
  # @author  Arthur van Hoff
  # @author  Roland Schemers
  # 
  # @see     java.lang.ClassLoader
  # @see     java.lang.SecurityException
  # @see     java.lang.SecurityManager#checkTopLevelWindow(java.lang.Object)
  # checkTopLevelWindow
  # @see     java.lang.System#getSecurityManager() getSecurityManager
  # @see     java.lang.System#setSecurityManager(java.lang.SecurityManager)
  # setSecurityManager
  # @see     java.security.AccessController AccessController
  # @see     java.security.AccessControlContext AccessControlContext
  # @see     java.security.AccessControlException AccessControlException
  # @see     java.security.Permission
  # @see     java.security.BasicPermission
  # @see     java.io.FilePermission
  # @see     java.net.SocketPermission
  # @see     java.util.PropertyPermission
  # @see     java.lang.RuntimePermission
  # @see     java.awt.AWTPermission
  # @see     java.security.Policy Policy
  # @see     java.security.SecurityPermission SecurityPermission
  # @see     java.security.ProtectionDomain
  # 
  # @since   JDK1.0
  class SecurityManager 
    include_class_members SecurityManagerImports
    
    # This field is <code>true</code> if there is a security check in
    # progress; <code>false</code> otherwise.
    # 
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    attr_accessor :in_check
    alias_method :attr_in_check, :in_check
    undef_method :in_check
    alias_method :attr_in_check=, :in_check=
    undef_method :in_check=
    
    # Have we been initialized. Effective against finalizer attacks.
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    typesig { [] }
    # returns true if the current context has been granted AllPermission
    def has_all_permission
      begin
        check_permission(SecurityConstants::ALL_PERMISSION)
        return true
      rescue SecurityException => se
        return false
      end
    end
    
    typesig { [] }
    # Tests if there is a security check in progress.
    # 
    # @return the value of the <code>inCheck</code> field. This field
    # should contain <code>true</code> if a security check is
    # in progress,
    # <code>false</code> otherwise.
    # @see     java.lang.SecurityManager#inCheck
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    def get_in_check
      return @in_check
    end
    
    typesig { [] }
    # Constructs a new <code>SecurityManager</code>.
    # 
    # <p> If there is a security manager already installed, this method first
    # calls the security manager's <code>checkPermission</code> method
    # with the <code>RuntimePermission("createSecurityManager")</code>
    # permission to ensure the calling thread has permission to create a new
    # security manager.
    # This may result in throwing a <code>SecurityException</code>.
    # 
    # @exception  java.lang.SecurityException if a security manager already
    # exists and its <code>checkPermission</code> method
    # doesn't allow creation of a new security manager.
    # @see        java.lang.System#getSecurityManager()
    # @see        #checkPermission(java.security.Permission) checkPermission
    # @see java.lang.RuntimePermission
    def initialize
      @in_check = false
      @initialized = false
      synchronized((SecurityManager)) do
        sm = System.get_security_manager
        if (!(sm).nil?)
          # ask the currently installed security manager if we
          # can create a new one.
          sm.check_permission(RuntimePermission.new("createSecurityManager"))
        end
        @initialized = true
      end
    end
    
    JNI.native_method :Java_java_lang_SecurityManager_getClassContext, [:pointer, :long], :long
    typesig { [] }
    # Returns the current execution stack as an array of classes.
    # <p>
    # The length of the array is the number of methods on the execution
    # stack. The element at index <code>0</code> is the class of the
    # currently executing method, the element at index <code>1</code> is
    # the class of that method's caller, and so on.
    # 
    # @return  the execution stack.
    def get_class_context
      JNI.__send__(:Java_java_lang_SecurityManager_getClassContext, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the class loader of the most recently executing method from
    # a class defined using a non-system class loader. A non-system
    # class loader is defined as being a class loader that is not equal to
    # the system class loader (as returned
    # by {@link ClassLoader#getSystemClassLoader}) or one of its ancestors.
    # <p>
    # This method will return
    # <code>null</code> in the following three cases:<p>
    # <ol>
    # <li>All methods on the execution stack are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li>All methods on the execution stack up to the first
    # "privileged" caller
    # (see {@link java.security.AccessController#doPrivileged})
    # are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li> A call to <code>checkPermission</code> with
    # <code>java.security.AllPermission</code> does not
    # result in a SecurityException.
    # 
    # </ol>
    # 
    # @return  the class loader of the most recent occurrence on the stack
    # of a method from a class defined using a non-system class
    # loader.
    # 
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    # 
    # @see  java.lang.ClassLoader#getSystemClassLoader() getSystemClassLoader
    # @see  #checkPermission(java.security.Permission) checkPermission
    def current_class_loader
      cl = current_class_loader0
      if ((!(cl).nil?) && has_all_permission)
        cl = nil
      end
      return cl
    end
    
    JNI.native_method :Java_java_lang_SecurityManager_currentClassLoader0, [:pointer, :long], :long
    typesig { [] }
    def current_class_loader0
      JNI.__send__(:Java_java_lang_SecurityManager_currentClassLoader0, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the class of the most recently executing method from
    # a class defined using a non-system class loader. A non-system
    # class loader is defined as being a class loader that is not equal to
    # the system class loader (as returned
    # by {@link ClassLoader#getSystemClassLoader}) or one of its ancestors.
    # <p>
    # This method will return
    # <code>null</code> in the following three cases:<p>
    # <ol>
    # <li>All methods on the execution stack are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li>All methods on the execution stack up to the first
    # "privileged" caller
    # (see {@link java.security.AccessController#doPrivileged})
    # are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li> A call to <code>checkPermission</code> with
    # <code>java.security.AllPermission</code> does not
    # result in a SecurityException.
    # 
    # </ol>
    # 
    # @return  the class  of the most recent occurrence on the stack
    # of a method from a class defined using a non-system class
    # loader.
    # 
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    # 
    # @see  java.lang.ClassLoader#getSystemClassLoader() getSystemClassLoader
    # @see  #checkPermission(java.security.Permission) checkPermission
    def current_loaded_class
      c = current_loaded_class0
      if ((!(c).nil?) && has_all_permission)
        c = nil
      end
      return c
    end
    
    JNI.native_method :Java_java_lang_SecurityManager_classDepth, [:pointer, :long, :long], :int32
    typesig { [String] }
    # Returns the stack depth of the specified class.
    # 
    # @param   name   the fully qualified name of the class to search for.
    # @return  the depth on the stack frame of the first occurrence of a
    # method from a class with the specified name;
    # <code>-1</code> if such a frame cannot be found.
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    def class_depth(name)
      JNI.__send__(:Java_java_lang_SecurityManager_classDepth, JNI.env, self.jni_id, name.jni_id)
    end
    
    typesig { [] }
    # Returns the stack depth of the most recently executing method
    # from a class defined using a non-system class loader.  A non-system
    # class loader is defined as being a class loader that is not equal to
    # the system class loader (as returned
    # by {@link ClassLoader#getSystemClassLoader}) or one of its ancestors.
    # <p>
    # This method will return
    # -1 in the following three cases:<p>
    # <ol>
    # <li>All methods on the execution stack are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li>All methods on the execution stack up to the first
    # "privileged" caller
    # (see {@link java.security.AccessController#doPrivileged})
    # are from classes
    # defined using the system class loader or one of its ancestors.
    # 
    # <li> A call to <code>checkPermission</code> with
    # <code>java.security.AllPermission</code> does not
    # result in a SecurityException.
    # 
    # </ol>
    # 
    # @return the depth on the stack frame of the most recent occurrence of
    # a method from a class defined using a non-system class loader.
    # 
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    # 
    # @see   java.lang.ClassLoader#getSystemClassLoader() getSystemClassLoader
    # @see   #checkPermission(java.security.Permission) checkPermission
    def class_loader_depth
      depth = class_loader_depth0
      if (!(depth).equal?(-1))
        if (has_all_permission)
          depth = -1
        else
          depth -= 1
        end # make sure we don't include ourself
      end
      return depth
    end
    
    JNI.native_method :Java_java_lang_SecurityManager_classLoaderDepth0, [:pointer, :long], :int32
    typesig { [] }
    def class_loader_depth0
      JNI.__send__(:Java_java_lang_SecurityManager_classLoaderDepth0, JNI.env, self.jni_id)
    end
    
    typesig { [String] }
    # Tests if a method from a class with the specified
    # name is on the execution stack.
    # 
    # @param  name   the fully qualified name of the class.
    # @return <code>true</code> if a method from a class with the specified
    # name is on the execution stack; <code>false</code> otherwise.
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    def in_class(name)
      return class_depth(name) >= 0
    end
    
    typesig { [] }
    # Basically, tests if a method from a class defined using a
    # class loader is on the execution stack.
    # 
    # @return  <code>true</code> if a call to <code>currentClassLoader</code>
    # has a non-null return value.
    # 
    # @deprecated This type of security checking is not recommended.
    # It is recommended that the <code>checkPermission</code>
    # call be used instead.
    # @see        #currentClassLoader() currentClassLoader
    def in_class_loader
      return !(current_class_loader).nil?
    end
    
    typesig { [] }
    # Creates an object that encapsulates the current execution
    # environment. The result of this method is used, for example, by the
    # three-argument <code>checkConnect</code> method and by the
    # two-argument <code>checkRead</code> method.
    # These methods are needed because a trusted method may be called
    # on to read a file or open a socket on behalf of another method.
    # The trusted method needs to determine if the other (possibly
    # untrusted) method would be allowed to perform the operation on its
    # own.
    # <p> The default implementation of this method is to return
    # an <code>AccessControlContext</code> object.
    # 
    # @return  an implementation-dependent object that encapsulates
    # sufficient information about the current execution environment
    # to perform some security checks later.
    # @see     java.lang.SecurityManager#checkConnect(java.lang.String, int,
    # java.lang.Object) checkConnect
    # @see     java.lang.SecurityManager#checkRead(java.lang.String,
    # java.lang.Object) checkRead
    # @see     java.security.AccessControlContext AccessControlContext
    def get_security_context
      return AccessController.get_context
    end
    
    typesig { [Permission] }
    # Throws a <code>SecurityException</code> if the requested
    # access, specified by the given permission, is not permitted based
    # on the security policy currently in effect.
    # <p>
    # This method calls <code>AccessController.checkPermission</code>
    # with the given permission.
    # 
    # @param     perm   the requested permission.
    # @exception SecurityException if access is not permitted based on
    # the current security policy.
    # @exception NullPointerException if the permission argument is
    # <code>null</code>.
    # @since     1.2
    def check_permission(perm)
      Java::Security::AccessController.check_permission(perm)
    end
    
    typesig { [Permission, Object] }
    # Throws a <code>SecurityException</code> if the
    # specified security context is denied access to the resource
    # specified by the given permission.
    # The context must be a security
    # context returned by a previous call to
    # <code>getSecurityContext</code> and the access control
    # decision is based upon the configured security policy for
    # that security context.
    # <p>
    # If <code>context</code> is an instance of
    # <code>AccessControlContext</code> then the
    # <code>AccessControlContext.checkPermission</code> method is
    # invoked with the specified permission.
    # <p>
    # If <code>context</code> is not an instance of
    # <code>AccessControlContext</code> then a
    # <code>SecurityException</code> is thrown.
    # 
    # @param      perm      the specified permission
    # @param      context   a system-dependent security context.
    # @exception  SecurityException  if the specified security context
    # is not an instance of <code>AccessControlContext</code>
    # (e.g., is <code>null</code>), or is denied access to the
    # resource specified by the given permission.
    # @exception  NullPointerException if the permission argument is
    # <code>null</code>.
    # @see        java.lang.SecurityManager#getSecurityContext()
    # @see java.security.AccessControlContext#checkPermission(java.security.Permission)
    # @since      1.2
    def check_permission(perm, context)
      if (context.is_a?(AccessControlContext))
        (context).check_permission(perm)
      else
        raise SecurityException.new
      end
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to create a new class loader.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("createClassLoader")</code>
    # permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkCreateClassLoader</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @exception SecurityException if the calling thread does not
    # have permission
    # to create a new class loader.
    # @see        java.lang.ClassLoader#ClassLoader()
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_create_class_loader
      check_permission(SecurityConstants::CREATE_CLASSLOADER_PERMISSION)
    end
    
    class_module.module_eval {
      # reference to the root thread group, used for the checkAccess
      # methods.
      
      def root_group
        defined?(@@root_group) ? @@root_group : @@root_group= get_root_group
      end
      alias_method :attr_root_group, :root_group
      
      def root_group=(value)
        @@root_group = value
      end
      alias_method :attr_root_group=, :root_group=
      
      typesig { [] }
      def get_root_group
        root = JavaThread.current_thread.get_thread_group
        while (!(root.get_parent).nil?)
          root = root.get_parent
        end
        return root
      end
    }
    
    typesig { [JavaThread] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to modify the thread argument.
    # <p>
    # This method is invoked for the current security manager by the
    # <code>stop</code>, <code>suspend</code>, <code>resume</code>,
    # <code>setPriority</code>, <code>setName</code>, and
    # <code>setDaemon</code> methods of class <code>Thread</code>.
    # <p>
    # If the thread argument is a system thread (belongs to
    # the thread group with a <code>null</code> parent) then
    # this method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("modifyThread")</code> permission.
    # If the thread argument is <i>not</i> a system thread,
    # this method just returns silently.
    # <p>
    # Applications that want a stricter policy should override this
    # method. If this method is overridden, the method that overrides
    # it should additionally check to see if the calling thread has the
    # <code>RuntimePermission("modifyThread")</code> permission, and
    # if so, return silently. This is to ensure that code granted
    # that permission (such as the JDK itself) is allowed to
    # manipulate any thread.
    # <p>
    # If this method is overridden, then
    # <code>super.checkAccess</code> should
    # be called by the first statement in the overridden method, or the
    # equivalent security check should be placed in the overridden method.
    # 
    # @param      t   the thread to be checked.
    # @exception  SecurityException  if the calling thread does not have
    # permission to modify the thread.
    # @exception  NullPointerException if the thread argument is
    # <code>null</code>.
    # @see        java.lang.Thread#resume() resume
    # @see        java.lang.Thread#setDaemon(boolean) setDaemon
    # @see        java.lang.Thread#setName(java.lang.String) setName
    # @see        java.lang.Thread#setPriority(int) setPriority
    # @see        java.lang.Thread#stop() stop
    # @see        java.lang.Thread#suspend() suspend
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_access(t)
      if ((t).nil?)
        raise NullPointerException.new("thread can't be null")
      end
      if ((t.get_thread_group).equal?(self.attr_root_group))
        check_permission(SecurityConstants::MODIFY_THREAD_PERMISSION)
      else
        # just return
      end
    end
    
    typesig { [JavaThreadGroup] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to modify the thread group argument.
    # <p>
    # This method is invoked for the current security manager when a
    # new child thread or child thread group is created, and by the
    # <code>setDaemon</code>, <code>setMaxPriority</code>,
    # <code>stop</code>, <code>suspend</code>, <code>resume</code>, and
    # <code>destroy</code> methods of class <code>ThreadGroup</code>.
    # <p>
    # If the thread group argument is the system thread group (
    # has a <code>null</code> parent) then
    # this method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("modifyThreadGroup")</code> permission.
    # If the thread group argument is <i>not</i> the system thread group,
    # this method just returns silently.
    # <p>
    # Applications that want a stricter policy should override this
    # method. If this method is overridden, the method that overrides
    # it should additionally check to see if the calling thread has the
    # <code>RuntimePermission("modifyThreadGroup")</code> permission, and
    # if so, return silently. This is to ensure that code granted
    # that permission (such as the JDK itself) is allowed to
    # manipulate any thread.
    # <p>
    # If this method is overridden, then
    # <code>super.checkAccess</code> should
    # be called by the first statement in the overridden method, or the
    # equivalent security check should be placed in the overridden method.
    # 
    # @param      g   the thread group to be checked.
    # @exception  SecurityException  if the calling thread does not have
    # permission to modify the thread group.
    # @exception  NullPointerException if the thread group argument is
    # <code>null</code>.
    # @see        java.lang.ThreadGroup#destroy() destroy
    # @see        java.lang.ThreadGroup#resume() resume
    # @see        java.lang.ThreadGroup#setDaemon(boolean) setDaemon
    # @see        java.lang.ThreadGroup#setMaxPriority(int) setMaxPriority
    # @see        java.lang.ThreadGroup#stop() stop
    # @see        java.lang.ThreadGroup#suspend() suspend
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_access(g)
      if ((g).nil?)
        raise NullPointerException.new("thread group can't be null")
      end
      if ((g).equal?(self.attr_root_group))
        check_permission(SecurityConstants::MODIFY_THREADGROUP_PERMISSION)
      else
        # just return
      end
    end
    
    typesig { [::Java::Int] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to cause the Java Virtual Machine to
    # halt with the specified status code.
    # <p>
    # This method is invoked for the current security manager by the
    # <code>exit</code> method of class <code>Runtime</code>. A status
    # of <code>0</code> indicates success; other values indicate various
    # errors.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("exitVM."+status)</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkExit</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      status   the exit status.
    # @exception SecurityException if the calling thread does not have
    # permission to halt the Java Virtual Machine with
    # the specified status.
    # @see        java.lang.Runtime#exit(int) exit
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_exit(status)
      check_permission(RuntimePermission.new("exitVM." + RJava.cast_to_string(status)))
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to create a subprocess.
    # <p>
    # This method is invoked for the current security manager by the
    # <code>exec</code> methods of class <code>Runtime</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>FilePermission(cmd,"execute")</code> permission
    # if cmd is an absolute path, otherwise it calls
    # <code>checkPermission</code> with
    # <code>FilePermission("&lt;&lt;ALL FILES&gt;&gt;","execute")</code>.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkExec</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      cmd   the specified system command.
    # @exception  SecurityException if the calling thread does not have
    # permission to create a subprocess.
    # @exception  NullPointerException if the <code>cmd</code> argument is
    # <code>null</code>.
    # @see     java.lang.Runtime#exec(java.lang.String)
    # @see     java.lang.Runtime#exec(java.lang.String, java.lang.String[])
    # @see     java.lang.Runtime#exec(java.lang.String[])
    # @see     java.lang.Runtime#exec(java.lang.String[], java.lang.String[])
    # @see     #checkPermission(java.security.Permission) checkPermission
    def check_exec(cmd)
      f = JavaFile.new(cmd)
      if (f.is_absolute)
        check_permission(FilePermission.new(cmd, SecurityConstants::FILE_EXECUTE_ACTION))
      else
        check_permission(FilePermission.new("<<ALL FILES>>", SecurityConstants::FILE_EXECUTE_ACTION))
      end
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to dynamic link the library code
    # specified by the string argument file. The argument is either a
    # simple library name or a complete filename.
    # <p>
    # This method is invoked for the current security manager by
    # methods <code>load</code> and <code>loadLibrary</code> of class
    # <code>Runtime</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("loadLibrary."+lib)</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkLink</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      lib   the name of the library.
    # @exception  SecurityException if the calling thread does not have
    # permission to dynamically link the library.
    # @exception  NullPointerException if the <code>lib</code> argument is
    # <code>null</code>.
    # @see        java.lang.Runtime#load(java.lang.String)
    # @see        java.lang.Runtime#loadLibrary(java.lang.String)
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_link(lib)
      if ((lib).nil?)
        raise NullPointerException.new("library can't be null")
      end
      check_permission(RuntimePermission.new("loadLibrary." + lib))
    end
    
    typesig { [FileDescriptor] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to read from the specified file
    # descriptor.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("readFileDescriptor")</code>
    # permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkRead</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      fd   the system-dependent file descriptor.
    # @exception  SecurityException  if the calling thread does not have
    # permission to access the specified file descriptor.
    # @exception  NullPointerException if the file descriptor argument is
    # <code>null</code>.
    # @see        java.io.FileDescriptor
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_read(fd)
      if ((fd).nil?)
        raise NullPointerException.new("file descriptor can't be null")
      end
      check_permission(RuntimePermission.new("readFileDescriptor"))
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to read the file specified by the
    # string argument.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>FilePermission(file,"read")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkRead</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      file   the system-dependent file name.
    # @exception  SecurityException if the calling thread does not have
    # permission to access the specified file.
    # @exception  NullPointerException if the <code>file</code> argument is
    # <code>null</code>.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_read(file)
      check_permission(FilePermission.new(file, SecurityConstants::FILE_READ_ACTION))
    end
    
    typesig { [String, Object] }
    # Throws a <code>SecurityException</code> if the
    # specified security context is not allowed to read the file
    # specified by the string argument. The context must be a security
    # context returned by a previous call to
    # <code>getSecurityContext</code>.
    # <p> If <code>context</code> is an instance of
    # <code>AccessControlContext</code> then the
    # <code>AccessControlContext.checkPermission</code> method will
    # be invoked with the <code>FilePermission(file,"read")</code> permission.
    # <p> If <code>context</code> is not an instance of
    # <code>AccessControlContext</code> then a
    # <code>SecurityException</code> is thrown.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkRead</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      file      the system-dependent filename.
    # @param      context   a system-dependent security context.
    # @exception  SecurityException  if the specified security context
    # is not an instance of <code>AccessControlContext</code>
    # (e.g., is <code>null</code>), or does not have permission
    # to read the specified file.
    # @exception  NullPointerException if the <code>file</code> argument is
    # <code>null</code>.
    # @see        java.lang.SecurityManager#getSecurityContext()
    # @see        java.security.AccessControlContext#checkPermission(java.security.Permission)
    def check_read(file, context)
      check_permission(FilePermission.new(file, SecurityConstants::FILE_READ_ACTION), context)
    end
    
    typesig { [FileDescriptor] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to write to the specified file
    # descriptor.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("writeFileDescriptor")</code>
    # permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkWrite</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      fd   the system-dependent file descriptor.
    # @exception SecurityException  if the calling thread does not have
    # permission to access the specified file descriptor.
    # @exception  NullPointerException if the file descriptor argument is
    # <code>null</code>.
    # @see        java.io.FileDescriptor
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_write(fd)
      if ((fd).nil?)
        raise NullPointerException.new("file descriptor can't be null")
      end
      check_permission(RuntimePermission.new("writeFileDescriptor"))
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to write to the file specified by
    # the string argument.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>FilePermission(file,"write")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkWrite</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      file   the system-dependent filename.
    # @exception  SecurityException  if the calling thread does not
    # have permission to access the specified file.
    # @exception  NullPointerException if the <code>file</code> argument is
    # <code>null</code>.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_write(file)
      check_permission(FilePermission.new(file, SecurityConstants::FILE_WRITE_ACTION))
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to delete the specified file.
    # <p>
    # This method is invoked for the current security manager by the
    # <code>delete</code> method of class <code>File</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>FilePermission(file,"delete")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkDelete</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      file   the system-dependent filename.
    # @exception  SecurityException if the calling thread does not
    # have permission to delete the file.
    # @exception  NullPointerException if the <code>file</code> argument is
    # <code>null</code>.
    # @see        java.io.File#delete()
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_delete(file)
      check_permission(FilePermission.new(file, SecurityConstants::FILE_DELETE_ACTION))
    end
    
    typesig { [String, ::Java::Int] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to open a socket connection to the
    # specified host and port number.
    # <p>
    # A port number of <code>-1</code> indicates that the calling
    # method is attempting to determine the IP address of the specified
    # host name.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>SocketPermission(host+":"+port,"connect")</code> permission if
    # the port is not equal to -1. If the port is equal to -1, then
    # it calls <code>checkPermission</code> with the
    # <code>SocketPermission(host,"resolve")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkConnect</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      host   the host name port to connect to.
    # @param      port   the protocol port to connect to.
    # @exception  SecurityException  if the calling thread does not have
    # permission to open a socket connection to the specified
    # <code>host</code> and <code>port</code>.
    # @exception  NullPointerException if the <code>host</code> argument is
    # <code>null</code>.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_connect(host, port)
      if ((host).nil?)
        raise NullPointerException.new("host can't be null")
      end
      if (!host.starts_with("[") && !(host.index_of(Character.new(?:.ord))).equal?(-1))
        host = "[" + host + "]"
      end
      if ((port).equal?(-1))
        check_permission(SocketPermission.new(host, SecurityConstants::SOCKET_RESOLVE_ACTION))
      else
        check_permission(SocketPermission.new(host + ":" + RJava.cast_to_string(port), SecurityConstants::SOCKET_CONNECT_ACTION))
      end
    end
    
    typesig { [String, ::Java::Int, Object] }
    # Throws a <code>SecurityException</code> if the
    # specified security context is not allowed to open a socket
    # connection to the specified host and port number.
    # <p>
    # A port number of <code>-1</code> indicates that the calling
    # method is attempting to determine the IP address of the specified
    # host name.
    # <p> If <code>context</code> is not an instance of
    # <code>AccessControlContext</code> then a
    # <code>SecurityException</code> is thrown.
    # <p>
    # Otherwise, the port number is checked. If it is not equal
    # to -1, the <code>context</code>'s <code>checkPermission</code>
    # method is called with a
    # <code>SocketPermission(host+":"+port,"connect")</code> permission.
    # If the port is equal to -1, then
    # the <code>context</code>'s <code>checkPermission</code> method
    # is called with a
    # <code>SocketPermission(host,"resolve")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkConnect</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      host      the host name port to connect to.
    # @param      port      the protocol port to connect to.
    # @param      context   a system-dependent security context.
    # @exception  SecurityException if the specified security context
    # is not an instance of <code>AccessControlContext</code>
    # (e.g., is <code>null</code>), or does not have permission
    # to open a socket connection to the specified
    # <code>host</code> and <code>port</code>.
    # @exception  NullPointerException if the <code>host</code> argument is
    # <code>null</code>.
    # @see        java.lang.SecurityManager#getSecurityContext()
    # @see        java.security.AccessControlContext#checkPermission(java.security.Permission)
    def check_connect(host, port, context)
      if ((host).nil?)
        raise NullPointerException.new("host can't be null")
      end
      if (!host.starts_with("[") && !(host.index_of(Character.new(?:.ord))).equal?(-1))
        host = "[" + host + "]"
      end
      if ((port).equal?(-1))
        check_permission(SocketPermission.new(host, SecurityConstants::SOCKET_RESOLVE_ACTION), context)
      else
        check_permission(SocketPermission.new(host + ":" + RJava.cast_to_string(port), SecurityConstants::SOCKET_CONNECT_ACTION), context)
      end
    end
    
    typesig { [::Java::Int] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to wait for a connection request on
    # the specified local port number.
    # <p>
    # If port is not 0, this method calls
    # <code>checkPermission</code> with the
    # <code>SocketPermission("localhost:"+port,"listen")</code>.
    # If port is zero, this method calls <code>checkPermission</code>
    # with <code>SocketPermission("localhost:1024-","listen").</code>
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkListen</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      port   the local port.
    # @exception  SecurityException  if the calling thread does not have
    # permission to listen on the specified port.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_listen(port)
      if ((port).equal?(0))
        check_permission(SecurityConstants::LOCAL_LISTEN_PERMISSION)
      else
        check_permission(SocketPermission.new("localhost:" + RJava.cast_to_string(port), SecurityConstants::SOCKET_LISTEN_ACTION))
      end
    end
    
    typesig { [String, ::Java::Int] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not permitted to accept a socket connection from
    # the specified host and port number.
    # <p>
    # This method is invoked for the current security manager by the
    # <code>accept</code> method of class <code>ServerSocket</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>SocketPermission(host+":"+port,"accept")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkAccept</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      host   the host name of the socket connection.
    # @param      port   the port number of the socket connection.
    # @exception  SecurityException  if the calling thread does not have
    # permission to accept the connection.
    # @exception  NullPointerException if the <code>host</code> argument is
    # <code>null</code>.
    # @see        java.net.ServerSocket#accept()
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_accept(host, port)
      if ((host).nil?)
        raise NullPointerException.new("host can't be null")
      end
      if (!host.starts_with("[") && !(host.index_of(Character.new(?:.ord))).equal?(-1))
        host = "[" + host + "]"
      end
      check_permission(SocketPermission.new(host + ":" + RJava.cast_to_string(port), SecurityConstants::SOCKET_ACCEPT_ACTION))
    end
    
    typesig { [InetAddress] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to use
    # (join/leave/send/receive) IP multicast.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>java.net.SocketPermission(maddr.getHostAddress(),
    # "accept,connect")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkMulticast</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      maddr  Internet group address to be used.
    # @exception  SecurityException  if the calling thread is not allowed to
    # use (join/leave/send/receive) IP multicast.
    # @exception  NullPointerException if the address argument is
    # <code>null</code>.
    # @since      JDK1.1
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_multicast(maddr)
      host = maddr.get_host_address
      if (!host.starts_with("[") && !(host.index_of(Character.new(?:.ord))).equal?(-1))
        host = "[" + host + "]"
      end
      check_permission(SocketPermission.new(host, SecurityConstants::SOCKET_CONNECT_ACCEPT_ACTION))
    end
    
    typesig { [InetAddress, ::Java::Byte] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to use
    # (join/leave/send/receive) IP multicast.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>java.net.SocketPermission(maddr.getHostAddress(),
    # "accept,connect")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkMulticast</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      maddr  Internet group address to be used.
    # @param      ttl        value in use, if it is multicast send.
    # Note: this particular implementation does not use the ttl
    # parameter.
    # @exception  SecurityException  if the calling thread is not allowed to
    # use (join/leave/send/receive) IP multicast.
    # @exception  NullPointerException if the address argument is
    # <code>null</code>.
    # @since      JDK1.1
    # @deprecated Use #checkPermission(java.security.Permission) instead
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_multicast(maddr, ttl)
      host = maddr.get_host_address
      if (!host.starts_with("[") && !(host.index_of(Character.new(?:.ord))).equal?(-1))
        host = "[" + host + "]"
      end
      check_permission(SocketPermission.new(host, SecurityConstants::SOCKET_CONNECT_ACCEPT_ACTION))
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access or modify the system
    # properties.
    # <p>
    # This method is used by the <code>getProperties</code> and
    # <code>setProperties</code> methods of class <code>System</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>PropertyPermission("*", "read,write")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkPropertiesAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # <p>
    # 
    # @exception  SecurityException  if the calling thread does not have
    # permission to access or modify the system properties.
    # @see        java.lang.System#getProperties()
    # @see        java.lang.System#setProperties(java.util.Properties)
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_properties_access
      check_permission(PropertyPermission.new("*", SecurityConstants::PROPERTY_RW_ACTION))
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access the system property with
    # the specified <code>key</code> name.
    # <p>
    # This method is used by the <code>getProperty</code> method of
    # class <code>System</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>PropertyPermission(key, "read")</code> permission.
    # <p>
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkPropertyAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param      key   a system property key.
    # 
    # @exception  SecurityException  if the calling thread does not have
    # permission to access the specified system property.
    # @exception  NullPointerException if the <code>key</code> argument is
    # <code>null</code>.
    # @exception  IllegalArgumentException if <code>key</code> is empty.
    # 
    # @see        java.lang.System#getProperty(java.lang.String)
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_property_access(key)
      check_permission(PropertyPermission.new(key, SecurityConstants::PROPERTY_READ_ACTION))
    end
    
    typesig { [Object] }
    # Returns <code>false</code> if the calling
    # thread is not trusted to bring up the top-level window indicated
    # by the <code>window</code> argument. In this case, the caller can
    # still decide to show the window, but the window should include
    # some sort of visual warning. If the method returns
    # <code>true</code>, then the window can be shown without any
    # special restrictions.
    # <p>
    # See class <code>Window</code> for more information on trusted and
    # untrusted windows.
    # <p>
    # This method calls
    # <code>checkPermission</code> with the
    # <code>AWTPermission("showWindowWithoutWarningBanner")</code> permission,
    # and returns <code>true</code> if a SecurityException is not thrown,
    # otherwise it returns <code>false</code>.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkTopLevelWindow</code>
    # at the point the overridden method would normally return
    # <code>false</code>, and the value of
    # <code>super.checkTopLevelWindow</code> should
    # be returned.
    # 
    # @param      window   the new window that is being created.
    # @return     <code>true</code> if the calling thread is trusted to put up
    # top-level windows; <code>false</code> otherwise.
    # @exception  NullPointerException if the <code>window</code> argument is
    # <code>null</code>.
    # @see        java.awt.Window
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_top_level_window(window)
      if ((window).nil?)
        raise NullPointerException.new("window can't be null")
      end
      begin
        check_permission(SecurityConstants::TOPLEVEL_WINDOW_PERMISSION)
        return true
      rescue SecurityException => se
        # just return false
      end
      return false
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to initiate a print job request.
    # <p>
    # This method calls
    # <code>checkPermission</code> with the
    # <code>RuntimePermission("queuePrintJob")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkPrintJobAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # <p>
    # 
    # @exception  SecurityException  if the calling thread does not have
    # permission to initiate a print job request.
    # @since   JDK1.1
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_print_job_access
      check_permission(RuntimePermission.new("queuePrintJob"))
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access the system clipboard.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>AWTPermission("accessClipboard")</code>
    # permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkSystemClipboardAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @since   JDK1.1
    # @exception  SecurityException  if the calling thread does not have
    # permission to access the system clipboard.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_system_clipboard_access
      check_permission(SecurityConstants::ACCESS_CLIPBOARD_PERMISSION)
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access the AWT event queue.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>AWTPermission("accessEventQueue")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkAwtEventQueueAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @since   JDK1.1
    # @exception  SecurityException  if the calling thread does not have
    # permission to access the AWT event queue.
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_awt_event_queue_access
      check_permission(SecurityConstants::CHECK_AWT_EVENTQUEUE_PERMISSION)
    end
    
    class_module.module_eval {
      # We have an initial invalid bit (initially false) for the class
      # variables which tell if the cache is valid.  If the underlying
      # java.security.Security property changes via setProperty(), the
      # Security class uses reflection to change the variable and thus
      # invalidate the cache.
      # 
      # Locking is handled by synchronization to the
      # packageAccessLock/packageDefinitionLock objects.  They are only
      # used in this class.
      # 
      # Note that cache invalidation as a result of the property change
      # happens without using these locks, so there may be a delay between
      # when a thread updates the property and when other threads updates
      # the cache.
      
      def package_access_valid
        defined?(@@package_access_valid) ? @@package_access_valid : @@package_access_valid= false
      end
      alias_method :attr_package_access_valid, :package_access_valid
      
      def package_access_valid=(value)
        @@package_access_valid = value
      end
      alias_method :attr_package_access_valid=, :package_access_valid=
      
      
      def package_access
        defined?(@@package_access) ? @@package_access : @@package_access= nil
      end
      alias_method :attr_package_access, :package_access
      
      def package_access=(value)
        @@package_access = value
      end
      alias_method :attr_package_access=, :package_access=
      
      const_set_lazy(:PackageAccessLock) { Object.new }
      const_attr_reader  :PackageAccessLock
      
      
      def package_definition_valid
        defined?(@@package_definition_valid) ? @@package_definition_valid : @@package_definition_valid= false
      end
      alias_method :attr_package_definition_valid, :package_definition_valid
      
      def package_definition_valid=(value)
        @@package_definition_valid = value
      end
      alias_method :attr_package_definition_valid=, :package_definition_valid=
      
      
      def package_definition
        defined?(@@package_definition) ? @@package_definition : @@package_definition= nil
      end
      alias_method :attr_package_definition, :package_definition
      
      def package_definition=(value)
        @@package_definition = value
      end
      alias_method :attr_package_definition=, :package_definition=
      
      const_set_lazy(:PackageDefinitionLock) { Object.new }
      const_attr_reader  :PackageDefinitionLock
      
      typesig { [String] }
      def get_packages(p)
        packages = nil
        if (!(p).nil? && !(p == ""))
          tok = Java::Util::StringTokenizer.new(p, ",")
          n = tok.count_tokens
          if (n > 0)
            packages = Array.typed(String).new(n) { nil }
            i = 0
            while (tok.has_more_elements)
              s = tok.next_token.trim
              packages[((i += 1) - 1)] = s
            end
          end
        end
        if ((packages).nil?)
          packages = Array.typed(String).new(0) { nil }
        end
        return packages
      end
    }
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access the package specified by
    # the argument.
    # <p>
    # This method is used by the <code>loadClass</code> method of class
    # loaders.
    # <p>
    # This method first gets a list of
    # restricted packages by obtaining a comma-separated list from
    # a call to
    # <code>java.security.Security.getProperty("package.access")</code>,
    # and checks to see if <code>pkg</code> starts with or equals
    # any of the restricted packages. If it does, then
    # <code>checkPermission</code> gets called with the
    # <code>RuntimePermission("accessClassInPackage."+pkg)</code>
    # permission.
    # <p>
    # If this method is overridden, then
    # <code>super.checkPackageAccess</code> should be called
    # as the first line in the overridden method.
    # 
    # @param      pkg   the package name.
    # @exception  SecurityException  if the calling thread does not have
    # permission to access the specified package.
    # @exception  NullPointerException if the package name argument is
    # <code>null</code>.
    # @see        java.lang.ClassLoader#loadClass(java.lang.String, boolean)
    # loadClass
    # @see        java.security.Security#getProperty getProperty
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_package_access(pkg)
      if ((pkg).nil?)
        raise NullPointerException.new("package name can't be null")
      end
      pkgs = nil
      synchronized((PackageAccessLock)) do
        # Do we need to update our property array?
        if (!self.attr_package_access_valid)
          tmp_property_str = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members SecurityManager
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Java::Security::Security.get_property("package.access")
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          self.attr_package_access = get_packages(tmp_property_str)
          self.attr_package_access_valid = true
        end
        # Using a snapshot of packageAccess -- don't care if static field
        # changes afterwards; array contents won't change.
        pkgs = self.attr_package_access
      end
      # Traverse the list of packages, check for any matches.
      i = 0
      while i < pkgs.attr_length
        if (pkg.starts_with(pkgs[i]) || (pkgs[i] == pkg + "."))
          check_permission(RuntimePermission.new("accessClassInPackage." + pkg))
          break # No need to continue; only need to check this once
        end
        i += 1
      end
    end
    
    typesig { [String] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to define classes in the package
    # specified by the argument.
    # <p>
    # This method is used by the <code>loadClass</code> method of some
    # class loaders.
    # <p>
    # This method first gets a list of restricted packages by
    # obtaining a comma-separated list from a call to
    # <code>java.security.Security.getProperty("package.definition")</code>,
    # and checks to see if <code>pkg</code> starts with or equals
    # any of the restricted packages. If it does, then
    # <code>checkPermission</code> gets called with the
    # <code>RuntimePermission("defineClassInPackage."+pkg)</code>
    # permission.
    # <p>
    # If this method is overridden, then
    # <code>super.checkPackageDefinition</code> should be called
    # as the first line in the overridden method.
    # 
    # @param      pkg   the package name.
    # @exception  SecurityException  if the calling thread does not have
    # permission to define classes in the specified package.
    # @see        java.lang.ClassLoader#loadClass(java.lang.String, boolean)
    # @see        java.security.Security#getProperty getProperty
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_package_definition(pkg)
      if ((pkg).nil?)
        raise NullPointerException.new("package name can't be null")
      end
      pkgs = nil
      synchronized((PackageDefinitionLock)) do
        # Do we need to update our property array?
        if (!self.attr_package_definition_valid)
          tmp_property_str = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members SecurityManager
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Java::Security::Security.get_property("package.definition")
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          self.attr_package_definition = get_packages(tmp_property_str)
          self.attr_package_definition_valid = true
        end
        # Using a snapshot of packageDefinition -- don't care if static
        # field changes afterwards; array contents won't change.
        pkgs = self.attr_package_definition
      end
      # Traverse the list of packages, check for any matches.
      i = 0
      while i < pkgs.attr_length
        if (pkg.starts_with(pkgs[i]) || (pkgs[i] == pkg + "."))
          check_permission(RuntimePermission.new("defineClassInPackage." + pkg))
          break # No need to continue; only need to check this once
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to set the socket factory used by
    # <code>ServerSocket</code> or <code>Socket</code>, or the stream
    # handler factory used by <code>URL</code>.
    # <p>
    # This method calls <code>checkPermission</code> with the
    # <code>RuntimePermission("setFactory")</code> permission.
    # <p>
    # If you override this method, then you should make a call to
    # <code>super.checkSetFactory</code>
    # at the point the overridden method would normally throw an
    # exception.
    # <p>
    # 
    # @exception  SecurityException  if the calling thread does not have
    # permission to specify a socket factory or a stream
    # handler factory.
    # 
    # @see        java.net.ServerSocket#setSocketFactory(java.net.SocketImplFactory) setSocketFactory
    # @see        java.net.Socket#setSocketImplFactory(java.net.SocketImplFactory) setSocketImplFactory
    # @see        java.net.URL#setURLStreamHandlerFactory(java.net.URLStreamHandlerFactory) setURLStreamHandlerFactory
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_set_factory
      check_permission(RuntimePermission.new("setFactory"))
    end
    
    typesig { [Class, ::Java::Int] }
    # Throws a <code>SecurityException</code> if the
    # calling thread is not allowed to access members.
    # <p>
    # The default policy is to allow access to PUBLIC members, as well
    # as access to classes that have the same class loader as the caller.
    # In all other cases, this method calls <code>checkPermission</code>
    # with the <code>RuntimePermission("accessDeclaredMembers")
    # </code> permission.
    # <p>
    # If this method is overridden, then a call to
    # <code>super.checkMemberAccess</code> cannot be made,
    # as the default implementation of <code>checkMemberAccess</code>
    # relies on the code being checked being at a stack depth of
    # 4.
    # 
    # @param clazz the class that reflection is to be performed on.
    # 
    # @param which type of access, PUBLIC or DECLARED.
    # 
    # @exception  SecurityException if the caller does not have
    # permission to access members.
    # @exception  NullPointerException if the <code>clazz</code> argument is
    # <code>null</code>.
    # @see java.lang.reflect.Member
    # @since JDK1.1
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_member_access(clazz, which)
      if ((clazz).nil?)
        raise NullPointerException.new("class can't be null")
      end
      if (!(which).equal?(Member::PUBLIC))
        stack = get_class_context
        # stack depth of 4 should be the caller of one of the
        # methods in java.lang.Class that invoke checkMember
        # access. The stack should look like:
        # 
        # someCaller                        [3]
        # java.lang.Class.someReflectionAPI [2]
        # java.lang.Class.checkMemberAccess [1]
        # SecurityManager.checkMemberAccess [0]
        if ((stack.attr_length < 4) || (!(stack[3].get_class_loader).equal?(clazz.get_class_loader)))
          check_permission(SecurityConstants::CHECK_MEMBER_ACCESS_PERMISSION)
        end
      end
    end
    
    typesig { [String] }
    # Determines whether the permission with the specified permission target
    # name should be granted or denied.
    # 
    # <p> If the requested permission is allowed, this method returns
    # quietly. If denied, a SecurityException is raised.
    # 
    # <p> This method creates a <code>SecurityPermission</code> object for
    # the given permission target name and calls <code>checkPermission</code>
    # with it.
    # 
    # <p> See the documentation for
    # <code>{@link java.security.SecurityPermission}</code> for
    # a list of possible permission target names.
    # 
    # <p> If you override this method, then you should make a call to
    # <code>super.checkSecurityAccess</code>
    # at the point the overridden method would normally throw an
    # exception.
    # 
    # @param target the target name of the <code>SecurityPermission</code>.
    # 
    # @exception SecurityException if the calling thread does not have
    # permission for the requested access.
    # @exception NullPointerException if <code>target</code> is null.
    # @exception IllegalArgumentException if <code>target</code> is empty.
    # 
    # @since   JDK1.1
    # @see        #checkPermission(java.security.Permission) checkPermission
    def check_security_access(target)
      check_permission(SecurityPermission.new(target))
    end
    
    JNI.native_method :Java_java_lang_SecurityManager_currentLoadedClass0, [:pointer, :long], :long
    typesig { [] }
    def current_loaded_class0
      JNI.__send__(:Java_java_lang_SecurityManager_currentLoadedClass0, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Returns the thread group into which to instantiate any new
    # thread being created at the time this is being called.
    # By default, it returns the thread group of the current
    # thread. This should be overridden by a specific security
    # manager to return the appropriate thread group.
    # 
    # @return  ThreadGroup that new threads are instantiated into
    # @since   JDK1.1
    # @see     java.lang.ThreadGroup
    def get_thread_group
      return JavaThread.current_thread.get_thread_group
    end
    
    private
    alias_method :initialize__security_manager, :initialize
  end
  
end

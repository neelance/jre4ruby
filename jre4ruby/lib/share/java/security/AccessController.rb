require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module AccessControllerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # <p> The AccessController class is used for access control operations
  # and decisions.
  # 
  # <p> More specifically, the AccessController class is used for
  # three purposes:
  # 
  # <ul>
  # <li> to decide whether an access to a critical system
  # resource is to be allowed or denied, based on the security policy
  # currently in effect,<p>
  # <li>to mark code as being "privileged", thus affecting subsequent
  # access determinations, and<p>
  # <li>to obtain a "snapshot" of the current calling context so
  # access-control decisions from a different context can be made with
  # respect to the saved context. </ul>
  # 
  # <p> The {@link #checkPermission(Permission) checkPermission} method
  # determines whether the access request indicated by a specified
  # permission should be granted or denied. A sample call appears
  # below. In this example, <code>checkPermission</code> will determine
  # whether or not to grant "read" access to the file named "testFile" in
  # the "/temp" directory.
  # 
  # <pre>
  # 
  # FilePermission perm = new FilePermission("/temp/testFile", "read");
  # AccessController.checkPermission(perm);
  # 
  # </pre>
  # 
  # <p> If a requested access is allowed,
  # <code>checkPermission</code> returns quietly. If denied, an
  # AccessControlException is
  # thrown. AccessControlException can also be thrown if the requested
  # permission is of an incorrect type or contains an invalid value.
  # Such information is given whenever possible.
  # 
  # Suppose the current thread traversed m callers, in the order of caller 1
  # to caller 2 to caller m. Then caller m invoked the
  # <code>checkPermission</code> method.
  # The <code>checkPermission </code>method determines whether access
  # is granted or denied based on the following algorithm:
  # 
  # <pre> {@code
  # for (int i = m; i > 0; i--) {
  # 
  # if (caller i's domain does not have the permission)
  # throw AccessControlException
  # 
  # else if (caller i is marked as privileged) {
  # if (a context was specified in the call to doPrivileged)
  # context.checkPermission(permission)
  # return;
  # }
  # };
  # 
  # // Next, check the context inherited when the thread was created.
  # // Whenever a new thread is created, the AccessControlContext at
  # // that time is stored and associated with the new thread, as the
  # // "inherited" context.
  # 
  # inheritedContext.checkPermission(permission);
  # }</pre>
  # 
  # <p> A caller can be marked as being "privileged"
  # (see {@link #doPrivileged(PrivilegedAction) doPrivileged} and below).
  # When making access control decisions, the <code>checkPermission</code>
  # method stops checking if it reaches a caller that
  # was marked as "privileged" via a <code>doPrivileged</code>
  # call without a context argument (see below for information about a
  # context argument). If that caller's domain has the
  # specified permission, no further checking is done and
  # <code>checkPermission</code>
  # returns quietly, indicating that the requested access is allowed.
  # If that domain does not have the specified permission, an exception
  # is thrown, as usual.
  # 
  # <p> The normal use of the "privileged" feature is as follows. If you
  # don't need to return a value from within the "privileged" block, do
  # the following:
  # 
  # <pre> {@code
  # somemethod() {
  # ...normal code here...
  # AccessController.doPrivileged(new PrivilegedAction<Void>() {
  # public Void run() {
  # // privileged code goes here, for example:
  # System.loadLibrary("awt");
  # return null; // nothing to return
  # }
  # });
  # ...normal code here...
  # }}</pre>
  # 
  # <p>
  # PrivilegedAction is an interface with a single method, named
  # <code>run</code>.
  # The above example shows creation of an implementation
  # of that interface; a concrete implementation of the
  # <code>run</code> method is supplied.
  # When the call to <code>doPrivileged</code> is made, an
  # instance of the PrivilegedAction implementation is passed
  # to it. The <code>doPrivileged</code> method calls the
  # <code>run</code> method from the PrivilegedAction
  # implementation after enabling privileges, and returns the
  # <code>run</code> method's return value as the
  # <code>doPrivileged</code> return value (which is
  # ignored in this example).
  # 
  # <p> If you need to return a value, you can do something like the following:
  # 
  # <pre> {@code
  # somemethod() {
  # ...normal code here...
  # String user = AccessController.doPrivileged(
  # new PrivilegedAction<String>() {
  # public String run() {
  # return System.getProperty("user.name");
  # }
  # });
  # ...normal code here...
  # }}</pre>
  # 
  # <p>If the action performed in your <code>run</code> method could
  # throw a "checked" exception (those listed in the <code>throws</code> clause
  # of a method), then you need to use the
  # <code>PrivilegedExceptionAction</code> interface instead of the
  # <code>PrivilegedAction</code> interface:
  # 
  # <pre> {@code
  # somemethod() throws FileNotFoundException {
  # ...normal code here...
  # try {
  # FileInputStream fis = AccessController.doPrivileged(
  # new PrivilegedExceptionAction<FileInputStream>() {
  # public FileInputStream run() throws FileNotFoundException {
  # return new FileInputStream("someFile");
  # }
  # });
  # } catch (PrivilegedActionException e) {
  # // e.getException() should be an instance of FileNotFoundException,
  # // as only "checked" exceptions will be "wrapped" in a
  # // PrivilegedActionException.
  # throw (FileNotFoundException) e.getException();
  # }
  # ...normal code here...
  # }}</pre>
  # 
  # <p> Be *very* careful in your use of the "privileged" construct, and
  # always remember to make the privileged code section as small as possible.
  # 
  # <p> Note that <code>checkPermission</code> always performs security checks
  # within the context of the currently executing thread.
  # Sometimes a security check that should be made within a given context
  # will actually need to be done from within a
  # <i>different</i> context (for example, from within a worker thread).
  # The {@link #getContext() getContext} method and
  # AccessControlContext class are provided
  # for this situation. The <code>getContext</code> method takes a "snapshot"
  # of the current calling context, and places
  # it in an AccessControlContext object, which it returns. A sample call is
  # the following:
  # 
  # <pre>
  # 
  # AccessControlContext acc = AccessController.getContext()
  # 
  # </pre>
  # 
  # <p>
  # AccessControlContext itself has a <code>checkPermission</code> method
  # that makes access decisions based on the context <i>it</i> encapsulates,
  # rather than that of the current execution thread.
  # Code within a different context can thus call that method on the
  # previously-saved AccessControlContext object. A sample call is the
  # following:
  # 
  # <pre>
  # 
  # acc.checkPermission(permission)
  # 
  # </pre>
  # 
  # <p> There are also times where you don't know a priori which permissions
  # to check the context against. In these cases you can use the
  # doPrivileged method that takes a context:
  # 
  # <pre> {@code
  # somemethod() {
  # AccessController.doPrivileged(new PrivilegedAction<Object>() {
  # public Object run() {
  # // Code goes here. Any permission checks within this
  # // run method will require that the intersection of the
  # // callers protection domain and the snapshot's
  # // context have the desired permission.
  # }
  # }, acc);
  # ...normal code here...
  # }}</pre>
  # 
  # @see AccessControlContext
  # 
  # @author Li Gong
  # @author Roland Schemers
  class AccessController 
    include_class_members AccessControllerImports
    
    typesig { [] }
    # Don't allow anyone to instantiate an AccessController
    def initialize
    end
    
    class_module.module_eval {
      JNI.load_native_method "Java_java_security_AccessController_doPrivileged__L#{PrivilegedAction.jni_package_name}_PrivilegedAction_2".to_sym, [:pointer, :long, :long], :long
      typesig { [PrivilegedAction] }
      # Performs the specified <code>PrivilegedAction</code> with privileges
      # enabled. The action is performed with <i>all</i> of the permissions
      # possessed by the caller's protection domain.
      # 
      # <p> If the action's <code>run</code> method throws an (unchecked)
      # exception, it will propagate through this method.
      # 
      # <p> Note that any DomainCombiner associated with the current
      # AccessControlContext will be ignored while the action is performed.
      # 
      # @param action the action to be performed.
      # 
      # @return the value returned by the action's <code>run</code> method.
      # 
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction,AccessControlContext)
      # @see #doPrivileged(PrivilegedExceptionAction)
      # @see #doPrivilegedWithCombiner(PrivilegedAction)
      # @see java.security.DomainCombiner
      def do_privileged(action)
        JNI.call_native_method("Java_java_security_AccessController_doPrivileged__L#{PrivilegedAction.jni_package_name}_PrivilegedAction_2".to_sym, JNI.env, self.jni_id, action.jni_id)
      end
      
      typesig { [PrivilegedAction] }
      # Performs the specified <code>PrivilegedAction</code> with privileges
      # enabled. The action is performed with <i>all</i> of the permissions
      # possessed by the caller's protection domain.
      # 
      # <p> If the action's <code>run</code> method throws an (unchecked)
      # exception, it will propagate through this method.
      # 
      # <p> This method preserves the current AccessControlContext's
      # DomainCombiner (which may be null) while the action is performed.
      # 
      # @param action the action to be performed.
      # 
      # @return the value returned by the action's <code>run</code> method.
      # 
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction)
      # @see java.security.DomainCombiner
      # 
      # @since 1.6
      def do_privileged_with_combiner(action)
        dc = nil
        acc = get_stack_access_control_context
        if ((acc).nil? || ((dc = acc.get_assigned_combiner)).nil?)
          return AccessController.do_privileged(action)
        end
        return AccessController.do_privileged(action, preserve_combiner(dc))
      end
      
      JNI.load_native_method "Java_java_security_AccessController_doPrivileged__L#{PrivilegedAction.jni_package_name}_PrivilegedAction_2L#{AccessControlContext.jni_package_name}_AccessControlContext_2".to_sym, [:pointer, :long, :long, :long], :long
      typesig { [PrivilegedAction, AccessControlContext] }
      # Performs the specified <code>PrivilegedAction</code> with privileges
      # enabled and restricted by the specified
      # <code>AccessControlContext</code>.
      # The action is performed with the intersection of the permissions
      # possessed by the caller's protection domain, and those possessed
      # by the domains represented by the specified
      # <code>AccessControlContext</code>.
      # <p>
      # If the action's <code>run</code> method throws an (unchecked) exception,
      # it will propagate through this method.
      # 
      # @param action the action to be performed.
      # @param context an <i>access control context</i>
      # representing the restriction to be applied to the
      # caller's domain's privileges before performing
      # the specified action.  If the context is
      # <code>null</code>,
      # then no additional restriction is applied.
      # 
      # @return the value returned by the action's <code>run</code> method.
      # 
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction)
      # @see #doPrivileged(PrivilegedExceptionAction,AccessControlContext)
      def do_privileged(action, context)
        JNI.call_native_method("Java_java_security_AccessController_doPrivileged__L#{PrivilegedAction.jni_package_name}_PrivilegedAction_2L#{AccessControlContext.jni_package_name}_AccessControlContext_2".to_sym, JNI.env, self.jni_id, action.jni_id, context.jni_id)
      end
      
      JNI.load_native_method "Java_java_security_AccessController_doPrivileged__L#{PrivilegedExceptionAction.jni_package_name}_PrivilegedExceptionAction_2".to_sym, [:pointer, :long, :long], :long
      typesig { [PrivilegedExceptionAction] }
      # Performs the specified <code>PrivilegedExceptionAction</code> with
      # privileges enabled.  The action is performed with <i>all</i> of the
      # permissions possessed by the caller's protection domain.
      # 
      # <p> If the action's <code>run</code> method throws an <i>unchecked</i>
      # exception, it will propagate through this method.
      # 
      # <p> Note that any DomainCombiner associated with the current
      # AccessControlContext will be ignored while the action is performed.
      # 
      # @param action the action to be performed
      # 
      # @return the value returned by the action's <code>run</code> method
      # 
      # @exception PrivilegedActionException if the specified action's
      # <code>run</code> method threw a <i>checked</i> exception
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction)
      # @see #doPrivileged(PrivilegedExceptionAction,AccessControlContext)
      # @see #doPrivilegedWithCombiner(PrivilegedExceptionAction)
      # @see java.security.DomainCombiner
      def do_privileged(action)
        JNI.call_native_method("Java_java_security_AccessController_doPrivileged__L#{PrivilegedExceptionAction.jni_package_name}_PrivilegedExceptionAction_2".to_sym, JNI.env, self.jni_id, action.jni_id)
      end
      
      typesig { [PrivilegedExceptionAction] }
      # Performs the specified <code>PrivilegedExceptionAction</code> with
      # privileges enabled.  The action is performed with <i>all</i> of the
      # permissions possessed by the caller's protection domain.
      # 
      # <p> If the action's <code>run</code> method throws an <i>unchecked</i>
      # exception, it will propagate through this method.
      # 
      # <p> This method preserves the current AccessControlContext's
      # DomainCombiner (which may be null) while the action is performed.
      # 
      # @param action the action to be performed.
      # 
      # @return the value returned by the action's <code>run</code> method
      # 
      # @exception PrivilegedActionException if the specified action's
      # <code>run</code> method threw a <i>checked</i> exception
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction)
      # @see #doPrivileged(PrivilegedExceptionAction,AccessControlContext)
      # @see java.security.DomainCombiner
      # 
      # @since 1.6
      def do_privileged_with_combiner(action)
        dc = nil
        acc = get_stack_access_control_context
        if ((acc).nil? || ((dc = acc.get_assigned_combiner)).nil?)
          return AccessController.do_privileged(action)
        end
        return AccessController.do_privileged(action, preserve_combiner(dc))
      end
      
      typesig { [DomainCombiner] }
      # preserve the combiner across the doPrivileged call
      def preserve_combiner(combiner)
        # callerClass[0] = Reflection.getCallerClass
        # callerClass[1] = AccessController.preserveCombiner
        # callerClass[2] = AccessController.doPrivileged
        # callerClass[3] = caller
        caller_class = Sun::Reflect::Reflection.get_caller_class(3)
        caller_pd = do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members AccessController
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return caller_class.get_protection_domain
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # perform 'combine' on the caller of doPrivileged,
        # even if the caller is from the bootclasspath
        pds = Array.typed(ProtectionDomain).new([caller_pd])
        return AccessControlContext.new(combiner.combine(pds, nil), combiner)
      end
      
      JNI.load_native_method "Java_java_security_AccessController_doPrivileged__L#{PrivilegedExceptionAction.jni_package_name}_PrivilegedExceptionAction_2L#{AccessControlContext.jni_package_name}_AccessControlContext_2".to_sym, [:pointer, :long, :long, :long], :long
      typesig { [PrivilegedExceptionAction, AccessControlContext] }
      # Performs the specified <code>PrivilegedExceptionAction</code> with
      # privileges enabled and restricted by the specified
      # <code>AccessControlContext</code>.  The action is performed with the
      # intersection of the the permissions possessed by the caller's
      # protection domain, and those possessed by the domains represented by the
      # specified <code>AccessControlContext</code>.
      # <p>
      # If the action's <code>run</code> method throws an <i>unchecked</i>
      # exception, it will propagate through this method.
      # 
      # @param action the action to be performed
      # @param context an <i>access control context</i>
      # representing the restriction to be applied to the
      # caller's domain's privileges before performing
      # the specified action.  If the context is
      # <code>null</code>,
      # then no additional restriction is applied.
      # 
      # @return the value returned by the action's <code>run</code> method
      # 
      # @exception PrivilegedActionException if the specified action's
      # <code>run</code> method
      # threw a <i>checked</i> exception
      # @exception NullPointerException if the action is <code>null</code>
      # 
      # @see #doPrivileged(PrivilegedAction)
      # @see #doPrivileged(PrivilegedExceptionAction,AccessControlContext)
      def do_privileged(action, context)
        JNI.call_native_method("Java_java_security_AccessController_doPrivileged__L#{PrivilegedExceptionAction.jni_package_name}_PrivilegedExceptionAction_2L#{AccessControlContext.jni_package_name}_AccessControlContext_2".to_sym, JNI.env, self.jni_id, action.jni_id, context.jni_id)
      end
      
      JNI.load_native_method :Java_java_security_AccessController_getStackAccessControlContext, [:pointer, :long], :long
      typesig { [] }
      # Returns the AccessControl context. i.e., it gets
      # the protection domains of all the callers on the stack,
      # starting at the first class with a non-null
      # ProtectionDomain.
      # 
      # @return the access control context based on the current stack or
      # null if there was only privileged system code.
      def get_stack_access_control_context
        JNI.call_native_method(:Java_java_security_AccessController_getStackAccessControlContext, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_java_security_AccessController_getInheritedAccessControlContext, [:pointer, :long], :long
      typesig { [] }
      # Returns the "inherited" AccessControl context. This is the context
      # that existed when the thread was created. Package private so
      # AccessControlContext can use it.
      def get_inherited_access_control_context
        JNI.call_native_method(:Java_java_security_AccessController_getInheritedAccessControlContext, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # This method takes a "snapshot" of the current calling context, which
      # includes the current Thread's inherited AccessControlContext,
      # and places it in an AccessControlContext object. This context may then
      # be checked at a later point, possibly in another thread.
      # 
      # @see AccessControlContext
      # 
      # @return the AccessControlContext based on the current context.
      def get_context
        acc = get_stack_access_control_context
        if ((acc).nil?)
          # all we had was privileged system code. We don't want
          # to return null though, so we construct a real ACC.
          return AccessControlContext.new(nil, true)
        else
          return acc.optimize
        end
      end
      
      typesig { [Permission] }
      # Determines whether the access request indicated by the
      # specified permission should be allowed or denied, based on
      # the current AccessControlContext and security policy.
      # This method quietly returns if the access request
      # is permitted, or throws a suitable AccessControlException otherwise.
      # 
      # @param perm the requested permission.
      # 
      # @exception AccessControlException if the specified permission
      # is not permitted, based on the current security policy.
      # @exception NullPointerException if the specified permission
      # is <code>null</code> and is checked based on the
      # security policy currently in effect.
      def check_permission(perm)
        # System.err.println("checkPermission "+perm);
        # Thread.currentThread().dumpStack();
        if ((perm).nil?)
          raise NullPointerException.new("permission can't be null")
        end
        stack = get_stack_access_control_context
        # if context is null, we had privileged system code on the stack.
        if ((stack).nil?)
          debug = AccessControlContext.get_debug
          dump_debug = false
          if (!(debug).nil?)
            dump_debug = !Debug.is_on("codebase=")
            dump_debug &= !Debug.is_on("permission=") || Debug.is_on("permission=" + RJava.cast_to_string(perm.get_class.get_canonical_name))
          end
          if (dump_debug && Debug.is_on("stack"))
            JavaThread.current_thread.dump_stack
          end
          if (dump_debug && Debug.is_on("domain"))
            debug.println("domain (context is null)")
          end
          if (dump_debug)
            debug.println("access allowed " + RJava.cast_to_string(perm))
          end
          return
        end
        acc = stack.optimize
        acc.check_permission(perm)
      end
    }
    
    private
    alias_method :initialize__access_controller, :initialize
  end
  
end

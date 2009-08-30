require "rjava"

# Copyright 1994-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SystemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :PropertyPermission
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :AllPermission
      include_const ::Java::Nio::Channels, :Channel
      include_const ::Java::Nio::Channels::Spi, :SelectorProvider
      include_const ::Sun::Nio::Ch, :Interruptible
      include_const ::Sun::Net, :InetAddressCachePolicy
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Sun::Reflect::Annotation, :AnnotationType
    }
  end
  
  # The <code>System</code> class contains several useful class fields
  # and methods. It cannot be instantiated.
  # 
  # <p>Among the facilities provided by the <code>System</code> class
  # are standard input, standard output, and error output streams;
  # access to externally defined properties and environment
  # variables; a means of loading files and libraries; and a utility
  # method for quickly copying a portion of an array.
  # 
  # @author  unascribed
  # @since   JDK1.0
  class System 
    include_class_members SystemImports
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_System_registerNatives, [:pointer, :long], :void
      typesig { [] }
      # First thing---register the natives
      def register_natives
        JNI.__send__(:Java_java_lang_System_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
      end
    }
    
    typesig { [] }
    # Don't let anyone instantiate this class
    def initialize
    end
    
    class_module.module_eval {
      # The "standard" input stream. This stream is already
      # open and ready to supply input data. Typically this stream
      # corresponds to keyboard input or another input source specified by
      # the host environment or user.
      
      def in
        defined?(@@in) ? @@in : @@in= null_input_stream
      end
      alias_method :attr_in, :in
      
      def in=(value)
        @@in = value
      end
      alias_method :attr_in=, :in=
      
      # The "standard" output stream. This stream is already
      # open and ready to accept output data. Typically this stream
      # corresponds to display output or another output destination
      # specified by the host environment or user.
      # <p>
      # For simple stand-alone Java applications, a typical way to write
      # a line of output data is:
      # <blockquote><pre>
      # System.out.println(data)
      # </pre></blockquote>
      # <p>
      # See the <code>println</code> methods in class <code>PrintStream</code>.
      # 
      # @see     java.io.PrintStream#println()
      # @see     java.io.PrintStream#println(boolean)
      # @see     java.io.PrintStream#println(char)
      # @see     java.io.PrintStream#println(char[])
      # @see     java.io.PrintStream#println(double)
      # @see     java.io.PrintStream#println(float)
      # @see     java.io.PrintStream#println(int)
      # @see     java.io.PrintStream#println(long)
      # @see     java.io.PrintStream#println(java.lang.Object)
      # @see     java.io.PrintStream#println(java.lang.String)
      
      def out
        defined?(@@out) ? @@out : @@out= null_print_stream
      end
      alias_method :attr_out, :out
      
      def out=(value)
        @@out = value
      end
      alias_method :attr_out=, :out=
      
      # The "standard" error output stream. This stream is already
      # open and ready to accept output data.
      # <p>
      # Typically this stream corresponds to display output or another
      # output destination specified by the host environment or user. By
      # convention, this output stream is used to display error messages
      # or other information that should come to the immediate attention
      # of a user even if the principal output stream, the value of the
      # variable <code>out</code>, has been redirected to a file or other
      # destination that is typically not continuously monitored.
      
      def err
        defined?(@@err) ? @@err : @@err= null_print_stream
      end
      alias_method :attr_err, :err
      
      def err=(value)
        @@err = value
      end
      alias_method :attr_err=, :err=
      
      # The security manager for the system.
      
      def security
        defined?(@@security) ? @@security : @@security= nil
      end
      alias_method :attr_security, :security
      
      def security=(value)
        @@security = value
      end
      alias_method :attr_security=, :security=
      
      typesig { [InputStream] }
      # Reassigns the "standard" input stream.
      # 
      # <p>First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a <code>RuntimePermission("setIO")</code> permission
      # to see if it's ok to reassign the "standard" input stream.
      # <p>
      # 
      # @param in the new standard input stream.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # reassigning of the standard input stream.
      # 
      # @see SecurityManager#checkPermission
      # @see java.lang.RuntimePermission
      # 
      # @since   JDK1.1
      def set_in(in_)
        check_io
        set_in0(in_)
      end
      
      typesig { [PrintStream] }
      # Reassigns the "standard" output stream.
      # 
      # <p>First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a <code>RuntimePermission("setIO")</code> permission
      # to see if it's ok to reassign the "standard" output stream.
      # 
      # @param out the new standard output stream
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # reassigning of the standard output stream.
      # 
      # @see SecurityManager#checkPermission
      # @see java.lang.RuntimePermission
      # 
      # @since   JDK1.1
      def set_out(out)
        check_io
        set_out0(out)
      end
      
      typesig { [PrintStream] }
      # Reassigns the "standard" error output stream.
      # 
      # <p>First, if there is a security manager, its <code>checkPermission</code>
      # method is called with a <code>RuntimePermission("setIO")</code> permission
      # to see if it's ok to reassign the "standard" error output stream.
      # 
      # @param err the new standard error output stream.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # reassigning of the standard error output stream.
      # 
      # @see SecurityManager#checkPermission
      # @see java.lang.RuntimePermission
      # 
      # @since   JDK1.1
      def set_err(err)
        check_io
        set_err0(err)
      end
      
      
      def cons
        defined?(@@cons) ? @@cons : @@cons= nil
      end
      alias_method :attr_cons, :cons
      
      def cons=(value)
        @@cons = value
      end
      alias_method :attr_cons=, :cons=
      
      typesig { [] }
      # Returns the unique {@link java.io.Console Console} object associated
      # with the current Java virtual machine, if any.
      # 
      # @return  The system console, if any, otherwise <tt>null</tt>.
      # 
      # @since   1.6
      def console
        if ((self.attr_cons).nil?)
          synchronized((System)) do
            self.attr_cons = Sun::Misc::SharedSecrets.get_java_ioaccess.console
          end
        end
        return self.attr_cons
      end
      
      typesig { [] }
      # Returns the channel inherited from the entity that created this
      # Java virtual machine.
      # 
      # <p> This method returns the channel obtained by invoking the
      # {@link java.nio.channels.spi.SelectorProvider#inheritedChannel
      # inheritedChannel} method of the system-wide default
      # {@link java.nio.channels.spi.SelectorProvider} object. </p>
      # 
      # <p> In addition to the network-oriented channels described in
      # {@link java.nio.channels.spi.SelectorProvider#inheritedChannel
      # inheritedChannel}, this method may return other kinds of
      # channels in the future.
      # 
      # @return  The inherited channel, if any, otherwise <tt>null</tt>.
      # 
      # @throws  IOException
      # If an I/O error occurs
      # 
      # @throws  SecurityException
      # If a security manager is present and it does not
      # permit access to the channel.
      # 
      # @since 1.5
      def inherited_channel
        return SelectorProvider.provider.inherited_channel
      end
      
      typesig { [] }
      def check_io
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_permission(RuntimePermission.new("setIO"))
        end
      end
      
      JNI.native_method :Java_java_lang_System_setIn0, [:pointer, :long, :long], :void
      typesig { [InputStream] }
      def set_in0(in_)
        JNI.__send__(:Java_java_lang_System_setIn0, JNI.env, self.jni_id, in_.jni_id)
      end
      
      JNI.native_method :Java_java_lang_System_setOut0, [:pointer, :long, :long], :void
      typesig { [PrintStream] }
      def set_out0(out)
        JNI.__send__(:Java_java_lang_System_setOut0, JNI.env, self.jni_id, out.jni_id)
      end
      
      JNI.native_method :Java_java_lang_System_setErr0, [:pointer, :long, :long], :void
      typesig { [PrintStream] }
      def set_err0(err)
        JNI.__send__(:Java_java_lang_System_setErr0, JNI.env, self.jni_id, err.jni_id)
      end
      
      typesig { [SecurityManager] }
      # Sets the System security.
      # 
      # <p> If there is a security manager already installed, this method first
      # calls the security manager's <code>checkPermission</code> method
      # with a <code>RuntimePermission("setSecurityManager")</code>
      # permission to ensure it's ok to replace the existing
      # security manager.
      # This may result in throwing a <code>SecurityException</code>.
      # 
      # <p> Otherwise, the argument is established as the current
      # security manager. If the argument is <code>null</code> and no
      # security manager has been established, then no action is taken and
      # the method simply returns.
      # 
      # @param      s   the security manager.
      # @exception  SecurityException  if the security manager has already
      # been set and its <code>checkPermission</code> method
      # doesn't allow it to be replaced.
      # @see #getSecurityManager
      # @see SecurityManager#checkPermission
      # @see java.lang.RuntimePermission
      def set_security_manager(s)
        begin
          s.check_package_access("java.lang")
        rescue JavaException => e
          # no-op
        end
        set_security_manager0(s)
      end
      
      typesig { [SecurityManager] }
      def set_security_manager0(s)
        synchronized(self) do
          sm = get_security_manager
          if (!(sm).nil?)
            # ask the currently installed security manager if we
            # can replace it.
            sm.check_permission(RuntimePermission.new("setSecurityManager"))
          end
          if ((!(s).nil?) && (!(s.get_class.get_class_loader).nil?))
            AccessController.do_privileged(# New security manager class is not on bootstrap classpath.
            # Cause policy to get initialized before we install the new
            # security manager, in order to prevent infinite loops when
            # trying to initialize the policy (which usually involves
            # accessing some security and/or system properties, which in turn
            # calls the installed security manager's checkPermission method
            # which will loop infinitely if there is a non-system class
            # (in this case: the new security manager class) on the stack).
            Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members System
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                s.get_class.get_protection_domain.implies(SecurityConstants::ALL_PERMISSION)
                return nil
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          self.attr_security = s
          InetAddressCachePolicy.set_if_not_set(InetAddressCachePolicy::FOREVER)
        end
      end
      
      typesig { [] }
      # Gets the system security interface.
      # 
      # @return  if a security manager has already been established for the
      # current application, then that security manager is returned;
      # otherwise, <code>null</code> is returned.
      # @see     #setSecurityManager
      def get_security_manager
        return self.attr_security
      end
      
      JNI.native_method :Java_java_lang_System_currentTimeMillis, [:pointer, :long], :int64
      typesig { [] }
      # Returns the current time in milliseconds.  Note that
      # while the unit of time of the return value is a millisecond,
      # the granularity of the value depends on the underlying
      # operating system and may be larger.  For example, many
      # operating systems measure time in units of tens of
      # milliseconds.
      # 
      # <p> See the description of the class <code>Date</code> for
      # a discussion of slight discrepancies that may arise between
      # "computer time" and coordinated universal time (UTC).
      # 
      # @return  the difference, measured in milliseconds, between
      # the current time and midnight, January 1, 1970 UTC.
      # @see     java.util.Date
      def current_time_millis
        JNI.__send__(:Java_java_lang_System_currentTimeMillis, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_System_nanoTime, [:pointer, :long], :int64
      typesig { [] }
      # Returns the current value of the most precise available system
      # timer, in nanoseconds.
      # 
      # <p>This method can only be used to measure elapsed time and is
      # not related to any other notion of system or wall-clock time.
      # The value returned represents nanoseconds since some fixed but
      # arbitrary time (perhaps in the future, so values may be
      # negative).  This method provides nanosecond precision, but not
      # necessarily nanosecond accuracy. No guarantees are made about
      # how frequently values change. Differences in successive calls
      # that span greater than approximately 292 years (2<sup>63</sup>
      # nanoseconds) will not accurately compute elapsed time due to
      # numerical overflow.
      # 
      # <p> For example, to measure how long some code takes to execute:
      # <pre>
      # long startTime = System.nanoTime();
      # // ... the code being measured ...
      # long estimatedTime = System.nanoTime() - startTime;
      # </pre>
      # 
      # @return The current value of the system timer, in nanoseconds.
      # @since 1.5
      def nano_time
        JNI.__send__(:Java_java_lang_System_nanoTime, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_System_arraycopy, [:pointer, :long, :long, :int32, :long, :int32, :int32], :void
      typesig { [Object, ::Java::Int, Object, ::Java::Int, ::Java::Int] }
      # Copies an array from the specified source array, beginning at the
      # specified position, to the specified position of the destination array.
      # A subsequence of array components are copied from the source
      # array referenced by <code>src</code> to the destination array
      # referenced by <code>dest</code>. The number of components copied is
      # equal to the <code>length</code> argument. The components at
      # positions <code>srcPos</code> through
      # <code>srcPos+length-1</code> in the source array are copied into
      # positions <code>destPos</code> through
      # <code>destPos+length-1</code>, respectively, of the destination
      # array.
      # <p>
      # If the <code>src</code> and <code>dest</code> arguments refer to the
      # same array object, then the copying is performed as if the
      # components at positions <code>srcPos</code> through
      # <code>srcPos+length-1</code> were first copied to a temporary
      # array with <code>length</code> components and then the contents of
      # the temporary array were copied into positions
      # <code>destPos</code> through <code>destPos+length-1</code> of the
      # destination array.
      # <p>
      # If <code>dest</code> is <code>null</code>, then a
      # <code>NullPointerException</code> is thrown.
      # <p>
      # If <code>src</code> is <code>null</code>, then a
      # <code>NullPointerException</code> is thrown and the destination
      # array is not modified.
      # <p>
      # Otherwise, if any of the following is true, an
      # <code>ArrayStoreException</code> is thrown and the destination is
      # not modified:
      # <ul>
      # <li>The <code>src</code> argument refers to an object that is not an
      # array.
      # <li>The <code>dest</code> argument refers to an object that is not an
      # array.
      # <li>The <code>src</code> argument and <code>dest</code> argument refer
      # to arrays whose component types are different primitive types.
      # <li>The <code>src</code> argument refers to an array with a primitive
      # component type and the <code>dest</code> argument refers to an array
      # with a reference component type.
      # <li>The <code>src</code> argument refers to an array with a reference
      # component type and the <code>dest</code> argument refers to an array
      # with a primitive component type.
      # </ul>
      # <p>
      # Otherwise, if any of the following is true, an
      # <code>IndexOutOfBoundsException</code> is
      # thrown and the destination is not modified:
      # <ul>
      # <li>The <code>srcPos</code> argument is negative.
      # <li>The <code>destPos</code> argument is negative.
      # <li>The <code>length</code> argument is negative.
      # <li><code>srcPos+length</code> is greater than
      # <code>src.length</code>, the length of the source array.
      # <li><code>destPos+length</code> is greater than
      # <code>dest.length</code>, the length of the destination array.
      # </ul>
      # <p>
      # Otherwise, if any actual component of the source array from
      # position <code>srcPos</code> through
      # <code>srcPos+length-1</code> cannot be converted to the component
      # type of the destination array by assignment conversion, an
      # <code>ArrayStoreException</code> is thrown. In this case, let
      # <b><i>k</i></b> be the smallest nonnegative integer less than
      # length such that <code>src[srcPos+</code><i>k</i><code>]</code>
      # cannot be converted to the component type of the destination
      # array; when the exception is thrown, source array components from
      # positions <code>srcPos</code> through
      # <code>srcPos+</code><i>k</i><code>-1</code>
      # will already have been copied to destination array positions
      # <code>destPos</code> through
      # <code>destPos+</code><i>k</I><code>-1</code> and no other
      # positions of the destination array will have been modified.
      # (Because of the restrictions already itemized, this
      # paragraph effectively applies only to the situation where both
      # arrays have component types that are reference types.)
      # 
      # @param      src      the source array.
      # @param      srcPos   starting position in the source array.
      # @param      dest     the destination array.
      # @param      destPos  starting position in the destination data.
      # @param      length   the number of array elements to be copied.
      # @exception  IndexOutOfBoundsException  if copying would cause
      # access of data outside array bounds.
      # @exception  ArrayStoreException  if an element in the <code>src</code>
      # array could not be stored into the <code>dest</code> array
      # because of a type mismatch.
      # @exception  NullPointerException if either <code>src</code> or
      # <code>dest</code> is <code>null</code>.
      def arraycopy(src, src_pos, dest, dest_pos, length)
        JNI.__send__(:Java_java_lang_System_arraycopy, JNI.env, self.jni_id, src.jni_id, src_pos.to_int, dest.jni_id, dest_pos.to_int, length.to_int)
      end
      
      JNI.native_method :Java_java_lang_System_identityHashCode, [:pointer, :long, :long], :int32
      typesig { [Object] }
      # Returns the same hash code for the given object as
      # would be returned by the default method hashCode(),
      # whether or not the given object's class overrides
      # hashCode().
      # The hash code for the null reference is zero.
      # 
      # @param x object for which the hashCode is to be calculated
      # @return  the hashCode
      # @since   JDK1.1
      def identity_hash_code(x)
        JNI.__send__(:Java_java_lang_System_identityHashCode, JNI.env, self.jni_id, x.jni_id)
      end
      
      # System properties. The following properties are guaranteed to be defined:
      # <dl>
      # <dt>java.version         <dd>Java version number
      # <dt>java.vendor          <dd>Java vendor specific string
      # <dt>java.vendor.url      <dd>Java vendor URL
      # <dt>java.home            <dd>Java installation directory
      # <dt>java.class.version   <dd>Java class version number
      # <dt>java.class.path      <dd>Java classpath
      # <dt>os.name              <dd>Operating System Name
      # <dt>os.arch              <dd>Operating System Architecture
      # <dt>os.version           <dd>Operating System Version
      # <dt>file.separator       <dd>File separator ("/" on Unix)
      # <dt>path.separator       <dd>Path separator (":" on Unix)
      # <dt>line.separator       <dd>Line separator ("\n" on Unix)
      # <dt>user.name            <dd>User account name
      # <dt>user.home            <dd>User home directory
      # <dt>user.dir             <dd>User's current working directory
      # </dl>
      
      def props
        defined?(@@props) ? @@props : @@props= nil
      end
      alias_method :attr_props, :props
      
      def props=(value)
        @@props = value
      end
      alias_method :attr_props=, :props=
      
      JNI.native_method :Java_java_lang_System_initProperties, [:pointer, :long, :long], :long
      typesig { [Properties] }
      def init_properties(props)
        JNI.__send__(:Java_java_lang_System_initProperties, JNI.env, self.jni_id, props.jni_id)
      end
      
      typesig { [] }
      # Determines the current system properties.
      # <p>
      # First, if there is a security manager, its
      # <code>checkPropertiesAccess</code> method is called with no
      # arguments. This may result in a security exception.
      # <p>
      # The current set of system properties for use by the
      # {@link #getProperty(String)} method is returned as a
      # <code>Properties</code> object. If there is no current set of
      # system properties, a set of system properties is first created and
      # initialized. This set of system properties always includes values
      # for the following keys:
      # <table summary="Shows property keys and associated values">
      # <tr><th>Key</th>
      # <th>Description of Associated Value</th></tr>
      # <tr><td><code>java.version</code></td>
      # <td>Java Runtime Environment version</td></tr>
      # <tr><td><code>java.vendor</code></td>
      # <td>Java Runtime Environment vendor</td></tr
      # <tr><td><code>java.vendor.url</code></td>
      # <td>Java vendor URL</td></tr>
      # <tr><td><code>java.home</code></td>
      # <td>Java installation directory</td></tr>
      # <tr><td><code>java.vm.specification.version</code></td>
      # <td>Java Virtual Machine specification version</td></tr>
      # <tr><td><code>java.vm.specification.vendor</code></td>
      # <td>Java Virtual Machine specification vendor</td></tr>
      # <tr><td><code>java.vm.specification.name</code></td>
      # <td>Java Virtual Machine specification name</td></tr>
      # <tr><td><code>java.vm.version</code></td>
      # <td>Java Virtual Machine implementation version</td></tr>
      # <tr><td><code>java.vm.vendor</code></td>
      # <td>Java Virtual Machine implementation vendor</td></tr>
      # <tr><td><code>java.vm.name</code></td>
      # <td>Java Virtual Machine implementation name</td></tr>
      # <tr><td><code>java.specification.version</code></td>
      # <td>Java Runtime Environment specification  version</td></tr>
      # <tr><td><code>java.specification.vendor</code></td>
      # <td>Java Runtime Environment specification  vendor</td></tr>
      # <tr><td><code>java.specification.name</code></td>
      # <td>Java Runtime Environment specification  name</td></tr>
      # <tr><td><code>java.class.version</code></td>
      # <td>Java class format version number</td></tr>
      # <tr><td><code>java.class.path</code></td>
      # <td>Java class path</td></tr>
      # <tr><td><code>java.library.path</code></td>
      # <td>List of paths to search when loading libraries</td></tr>
      # <tr><td><code>java.io.tmpdir</code></td>
      # <td>Default temp file path</td></tr>
      # <tr><td><code>java.compiler</code></td>
      # <td>Name of JIT compiler to use</td></tr>
      # <tr><td><code>java.ext.dirs</code></td>
      # <td>Path of extension directory or directories</td></tr>
      # <tr><td><code>os.name</code></td>
      # <td>Operating system name</td></tr>
      # <tr><td><code>os.arch</code></td>
      # <td>Operating system architecture</td></tr>
      # <tr><td><code>os.version</code></td>
      # <td>Operating system version</td></tr>
      # <tr><td><code>file.separator</code></td>
      # <td>File separator ("/" on UNIX)</td></tr>
      # <tr><td><code>path.separator</code></td>
      # <td>Path separator (":" on UNIX)</td></tr>
      # <tr><td><code>line.separator</code></td>
      # <td>Line separator ("\n" on UNIX)</td></tr>
      # <tr><td><code>user.name</code></td>
      # <td>User's account name</td></tr>
      # <tr><td><code>user.home</code></td>
      # <td>User's home directory</td></tr>
      # <tr><td><code>user.dir</code></td>
      # <td>User's current working directory</td></tr>
      # </table>
      # <p>
      # Multiple paths in a system property value are separated by the path
      # separator character of the platform.
      # <p>
      # Note that even if the security manager does not permit the
      # <code>getProperties</code> operation, it may choose to permit the
      # {@link #getProperty(String)} operation.
      # 
      # @return     the system properties
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow access
      # to the system properties.
      # @see        #setProperties
      # @see        java.lang.SecurityException
      # @see        java.lang.SecurityManager#checkPropertiesAccess()
      # @see        java.util.Properties
      def get_properties
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_properties_access
        end
        return self.attr_props
      end
      
      typesig { [Properties] }
      # Sets the system properties to the <code>Properties</code>
      # argument.
      # <p>
      # First, if there is a security manager, its
      # <code>checkPropertiesAccess</code> method is called with no
      # arguments. This may result in a security exception.
      # <p>
      # The argument becomes the current set of system properties for use
      # by the {@link #getProperty(String)} method. If the argument is
      # <code>null</code>, then the current set of system properties is
      # forgotten.
      # 
      # @param      props   the new system properties.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow access
      # to the system properties.
      # @see        #getProperties
      # @see        java.util.Properties
      # @see        java.lang.SecurityException
      # @see        java.lang.SecurityManager#checkPropertiesAccess()
      def set_properties(props)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_properties_access
        end
        if ((props).nil?)
          props = Properties.new
          init_properties(props)
        end
        System.attr_props = props
      end
      
      typesig { [String] }
      # Gets the system property indicated by the specified key.
      # <p>
      # First, if there is a security manager, its
      # <code>checkPropertyAccess</code> method is called with the key as
      # its argument. This may result in a SecurityException.
      # <p>
      # If there is no current set of system properties, a set of system
      # properties is first created and initialized in the same manner as
      # for the <code>getProperties</code> method.
      # 
      # @param      key   the name of the system property.
      # @return     the string value of the system property,
      # or <code>null</code> if there is no property with that key.
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertyAccess</code> method doesn't allow
      # access to the specified system property.
      # @exception  NullPointerException if <code>key</code> is
      # <code>null</code>.
      # @exception  IllegalArgumentException if <code>key</code> is empty.
      # @see        #setProperty
      # @see        java.lang.SecurityException
      # @see        java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
      # @see        java.lang.System#getProperties()
      def get_property(key)
        check_key(key)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_property_access(key)
        end
        return self.attr_props.get_property(key)
      end
      
      typesig { [String, String] }
      # Gets the system property indicated by the specified key.
      # <p>
      # First, if there is a security manager, its
      # <code>checkPropertyAccess</code> method is called with the
      # <code>key</code> as its argument.
      # <p>
      # If there is no current set of system properties, a set of system
      # properties is first created and initialized in the same manner as
      # for the <code>getProperties</code> method.
      # 
      # @param      key   the name of the system property.
      # @param      def   a default value.
      # @return     the string value of the system property,
      # or the default value if there is no property with that key.
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertyAccess</code> method doesn't allow
      # access to the specified system property.
      # @exception  NullPointerException if <code>key</code> is
      # <code>null</code>.
      # @exception  IllegalArgumentException if <code>key</code> is empty.
      # @see        #setProperty
      # @see        java.lang.SecurityManager#checkPropertyAccess(java.lang.String)
      # @see        java.lang.System#getProperties()
      def get_property(key, def_)
        check_key(key)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_property_access(key)
        end
        return self.attr_props.get_property(key, def_)
      end
      
      typesig { [String, String] }
      # Sets the system property indicated by the specified key.
      # <p>
      # First, if a security manager exists, its
      # <code>SecurityManager.checkPermission</code> method
      # is called with a <code>PropertyPermission(key, "write")</code>
      # permission. This may result in a SecurityException being thrown.
      # If no exception is thrown, the specified property is set to the given
      # value.
      # <p>
      # 
      # @param      key   the name of the system property.
      # @param      value the value of the system property.
      # @return     the previous value of the system property,
      # or <code>null</code> if it did not have one.
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # setting of the specified property.
      # @exception  NullPointerException if <code>key</code> or
      # <code>value</code> is <code>null</code>.
      # @exception  IllegalArgumentException if <code>key</code> is empty.
      # @see        #getProperty
      # @see        java.lang.System#getProperty(java.lang.String)
      # @see        java.lang.System#getProperty(java.lang.String, java.lang.String)
      # @see        java.util.PropertyPermission
      # @see        SecurityManager#checkPermission
      # @since      1.2
      def set_property(key, value)
        check_key(key)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_permission(PropertyPermission.new(key, SecurityConstants::PROPERTY_WRITE_ACTION))
        end
        return self.attr_props.set_property(key, value)
      end
      
      typesig { [String] }
      # Removes the system property indicated by the specified key.
      # <p>
      # First, if a security manager exists, its
      # <code>SecurityManager.checkPermission</code> method
      # is called with a <code>PropertyPermission(key, "write")</code>
      # permission. This may result in a SecurityException being thrown.
      # If no exception is thrown, the specified property is removed.
      # <p>
      # 
      # @param      key   the name of the system property to be removed.
      # @return     the previous string value of the system property,
      # or <code>null</code> if there was no property with that key.
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkPropertyAccess</code> method doesn't allow
      # access to the specified system property.
      # @exception  NullPointerException if <code>key</code> is
      # <code>null</code>.
      # @exception  IllegalArgumentException if <code>key</code> is empty.
      # @see        #getProperty
      # @see        #setProperty
      # @see        java.util.Properties
      # @see        java.lang.SecurityException
      # @see        java.lang.SecurityManager#checkPropertiesAccess()
      # @since 1.5
      def clear_property(key)
        check_key(key)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_permission(PropertyPermission.new(key, "write"))
        end
        return self.attr_props.remove(key)
      end
      
      typesig { [String] }
      def check_key(key)
        if ((key).nil?)
          raise NullPointerException.new("key can't be null")
        end
        if ((key == ""))
          raise IllegalArgumentException.new("key can't be empty")
        end
      end
      
      typesig { [String] }
      # Gets the value of the specified environment variable. An
      # environment variable is a system-dependent external named
      # value.
      # 
      # <p>If a security manager exists, its
      # {@link SecurityManager#checkPermission checkPermission}
      # method is called with a
      # <code>{@link RuntimePermission}("getenv."+name)</code>
      # permission.  This may result in a {@link SecurityException}
      # being thrown.  If no exception is thrown the value of the
      # variable <code>name</code> is returned.
      # 
      # <p><a name="EnvironmentVSSystemProperties"><i>System
      # properties</i> and <i>environment variables</i></a> are both
      # conceptually mappings between names and values.  Both
      # mechanisms can be used to pass user-defined information to a
      # Java process.  Environment variables have a more global effect,
      # because they are visible to all descendants of the process
      # which defines them, not just the immediate Java subprocess.
      # They can have subtly different semantics, such as case
      # insensitivity, on different operating systems.  For these
      # reasons, environment variables are more likely to have
      # unintended side effects.  It is best to use system properties
      # where possible.  Environment variables should be used when a
      # global effect is desired, or when an external system interface
      # requires an environment variable (such as <code>PATH</code>).
      # 
      # <p>On UNIX systems the alphabetic case of <code>name</code> is
      # typically significant, while on Microsoft Windows systems it is
      # typically not.  For example, the expression
      # <code>System.getenv("FOO").equals(System.getenv("foo"))</code>
      # is likely to be true on Microsoft Windows.
      # 
      # @param  name the name of the environment variable
      # @return the string value of the variable, or <code>null</code>
      # if the variable is not defined in the system environment
      # @throws NullPointerException if <code>name</code> is <code>null</code>
      # @throws SecurityException
      # if a security manager exists and its
      # {@link SecurityManager#checkPermission checkPermission}
      # method doesn't allow access to the environment variable
      # <code>name</code>
      # @see    #getenv()
      # @see    ProcessBuilder#environment()
      def getenv(name)
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_permission(RuntimePermission.new("getenv." + name))
        end
        return ProcessEnvironment.getenv(name)
      end
      
      typesig { [] }
      # Returns an unmodifiable string map view of the current system environment.
      # The environment is a system-dependent mapping from names to
      # values which is passed from parent to child processes.
      # 
      # <p>If the system does not support environment variables, an
      # empty map is returned.
      # 
      # <p>The returned map will never contain null keys or values.
      # Attempting to query the presence of a null key or value will
      # throw a {@link NullPointerException}.  Attempting to query
      # the presence of a key or value which is not of type
      # {@link String} will throw a {@link ClassCastException}.
      # 
      # <p>The returned map and its collection views may not obey the
      # general contract of the {@link Object#equals} and
      # {@link Object#hashCode} methods.
      # 
      # <p>The returned map is typically case-sensitive on all platforms.
      # 
      # <p>If a security manager exists, its
      # {@link SecurityManager#checkPermission checkPermission}
      # method is called with a
      # <code>{@link RuntimePermission}("getenv.*")</code>
      # permission.  This may result in a {@link SecurityException} being
      # thrown.
      # 
      # <p>When passing information to a Java subprocess,
      # <a href=#EnvironmentVSSystemProperties>system properties</a>
      # are generally preferred over environment variables.
      # 
      # @return the environment as a map of variable names to values
      # @throws SecurityException
      # if a security manager exists and its
      # {@link SecurityManager#checkPermission checkPermission}
      # method doesn't allow access to the process environment
      # @see    #getenv(String)
      # @see    ProcessBuilder#environment()
      # @since  1.5
      def getenv
        sm = get_security_manager
        if (!(sm).nil?)
          sm.check_permission(RuntimePermission.new("getenv.*"))
        end
        return ProcessEnvironment.getenv
      end
      
      typesig { [::Java::Int] }
      # Terminates the currently running Java Virtual Machine. The
      # argument serves as a status code; by convention, a nonzero status
      # code indicates abnormal termination.
      # <p>
      # This method calls the <code>exit</code> method in class
      # <code>Runtime</code>. This method never returns normally.
      # <p>
      # The call <code>System.exit(n)</code> is effectively equivalent to
      # the call:
      # <blockquote><pre>
      # Runtime.getRuntime().exit(n)
      # </pre></blockquote>
      # 
      # @param      status   exit status.
      # @throws  SecurityException
      # if a security manager exists and its <code>checkExit</code>
      # method doesn't allow exit with the specified status.
      # @see        java.lang.Runtime#exit(int)
      def exit(status)
        Runtime.get_runtime.exit(status)
      end
      
      typesig { [] }
      # Runs the garbage collector.
      # <p>
      # Calling the <code>gc</code> method suggests that the Java Virtual
      # Machine expend effort toward recycling unused objects in order to
      # make the memory they currently occupy available for quick reuse.
      # When control returns from the method call, the Java Virtual
      # Machine has made a best effort to reclaim space from all discarded
      # objects.
      # <p>
      # The call <code>System.gc()</code> is effectively equivalent to the
      # call:
      # <blockquote><pre>
      # Runtime.getRuntime().gc()
      # </pre></blockquote>
      # 
      # @see     java.lang.Runtime#gc()
      def gc
        Runtime.get_runtime.gc
      end
      
      typesig { [] }
      # Runs the finalization methods of any objects pending finalization.
      # <p>
      # Calling this method suggests that the Java Virtual Machine expend
      # effort toward running the <code>finalize</code> methods of objects
      # that have been found to be discarded but whose <code>finalize</code>
      # methods have not yet been run. When control returns from the
      # method call, the Java Virtual Machine has made a best effort to
      # complete all outstanding finalizations.
      # <p>
      # The call <code>System.runFinalization()</code> is effectively
      # equivalent to the call:
      # <blockquote><pre>
      # Runtime.getRuntime().runFinalization()
      # </pre></blockquote>
      # 
      # @see     java.lang.Runtime#runFinalization()
      def run_finalization
        Runtime.get_runtime.run_finalization
      end
      
      typesig { [::Java::Boolean] }
      # Enable or disable finalization on exit; doing so specifies that the
      # finalizers of all objects that have finalizers that have not yet been
      # automatically invoked are to be run before the Java runtime exits.
      # By default, finalization on exit is disabled.
      # 
      # <p>If there is a security manager,
      # its <code>checkExit</code> method is first called
      # with 0 as its argument to ensure the exit is allowed.
      # This could result in a SecurityException.
      # 
      # @deprecated  This method is inherently unsafe.  It may result in
      # finalizers being called on live objects while other threads are
      # concurrently manipulating those objects, resulting in erratic
      # behavior or deadlock.
      # @param value indicating enabling or disabling of finalization
      # @throws  SecurityException
      # if a security manager exists and its <code>checkExit</code>
      # method doesn't allow the exit.
      # 
      # @see     java.lang.Runtime#exit(int)
      # @see     java.lang.Runtime#gc()
      # @see     java.lang.SecurityManager#checkExit(int)
      # @since   JDK1.1
      def run_finalizers_on_exit(value)
        Runtime.get_runtime.run_finalizers_on_exit(value)
      end
      
      typesig { [String] }
      # Loads a code file with the specified filename from the local file
      # system as a dynamic library. The filename
      # argument must be a complete path name.
      # <p>
      # The call <code>System.load(name)</code> is effectively equivalent
      # to the call:
      # <blockquote><pre>
      # Runtime.getRuntime().load(name)
      # </pre></blockquote>
      # 
      # @param      filename   the file to load.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkLink</code> method doesn't allow
      # loading of the specified dynamic library
      # @exception  UnsatisfiedLinkError  if the file does not exist.
      # @exception  NullPointerException if <code>filename</code> is
      # <code>null</code>
      # @see        java.lang.Runtime#load(java.lang.String)
      # @see        java.lang.SecurityManager#checkLink(java.lang.String)
      def load(filename)
        Runtime.get_runtime.load0(get_caller_class, filename)
      end
      
      typesig { [String] }
      # Loads the system library specified by the <code>libname</code>
      # argument. The manner in which a library name is mapped to the
      # actual system library is system dependent.
      # <p>
      # The call <code>System.loadLibrary(name)</code> is effectively
      # equivalent to the call
      # <blockquote><pre>
      # Runtime.getRuntime().loadLibrary(name)
      # </pre></blockquote>
      # 
      # @param      libname   the name of the library.
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkLink</code> method doesn't allow
      # loading of the specified dynamic library
      # @exception  UnsatisfiedLinkError  if the library does not exist.
      # @exception  NullPointerException if <code>libname</code> is
      # <code>null</code>
      # @see        java.lang.Runtime#loadLibrary(java.lang.String)
      # @see        java.lang.SecurityManager#checkLink(java.lang.String)
      def load_library(libname)
        Runtime.get_runtime.load_library0(get_caller_class, libname)
      end
      
      JNI.native_method :Java_java_lang_System_mapLibraryName, [:pointer, :long, :long], :long
      typesig { [String] }
      # Maps a library name into a platform-specific string representing
      # a native library.
      # 
      # @param      libname the name of the library.
      # @return     a platform-dependent native library name.
      # @exception  NullPointerException if <code>libname</code> is
      # <code>null</code>
      # @see        java.lang.System#loadLibrary(java.lang.String)
      # @see        java.lang.ClassLoader#findLibrary(java.lang.String)
      # @since      1.2
      def map_library_name(libname)
        JNI.__send__(:Java_java_lang_System_mapLibraryName, JNI.env, self.jni_id, libname.jni_id)
      end
      
      typesig { [] }
      # The following two methods exist because in, out, and err must be
      # initialized to null.  The compiler, however, cannot be permitted to
      # inline access to them, since they are later set to more sensible values
      # by initializeSystemClass().
      def null_input_stream
        if (current_time_millis > 0)
          return nil
        end
        raise NullPointerException.new
      end
      
      typesig { [] }
      def null_print_stream
        if (current_time_millis > 0)
          return nil
        end
        raise NullPointerException.new
      end
      
      typesig { [] }
      # Initialize the system class.  Called after thread initialization.
      def initialize_system_class
        self.attr_props = Properties.new
        init_properties(self.attr_props)
        Sun::Misc::Version.init
        fd_in = FileInputStream.new(FileDescriptor.attr_in)
        fd_out = FileOutputStream.new(FileDescriptor.attr_out)
        fd_err = FileOutputStream.new(FileDescriptor.attr_err)
        set_in0(BufferedInputStream.new(fd_in))
        set_out0(PrintStream.new(BufferedOutputStream.new(fd_out, 128), true))
        set_err0(PrintStream.new(BufferedOutputStream.new(fd_err, 128), true))
        # Load the zip library now in order to keep java.util.zip.ZipFile
        # from trying to use itself to load this library later.
        load_library("zip")
        # Setup Java signal handlers for HUP, TERM, and INT (where available).
        Terminator.setup
        # The order in with the hooks are added here is important as it
        # determines the order in which they are run.
        # (1)Console restore hook needs to be called first.
        # (2)Application hooks must be run before calling deleteOnExitHook.
        Shutdown.add(Sun::Misc::SharedSecrets.get_java_ioaccess.console_restore_hook)
        Shutdown.add(ApplicationShutdownHooks.hook)
        Shutdown.add(Sun::Misc::SharedSecrets.get_java_iodelete_on_exit_access)
        # Initialize any miscellenous operating system settings that need to be
        # set for the class libraries. Currently this is no-op everywhere except
        # for Windows where the process-wide error mode is set before the java.io
        # classes are used.
        Sun::Misc::VM.initialize_osenvironment
        # Set the maximum amount of direct memory.  This value is controlled
        # by the vm option -XX:MaxDirectMemorySize=<size>.  This method acts
        # as an initializer only if it is called before sun.misc.VM.booted().
        Sun::Misc::VM.max_direct_memory
        # Set a boolean to determine whether ClassLoader.loadClass accepts
        # array syntax.  This value is controlled by the system property
        # "sun.lang.ClassLoader.allowArraySyntax".  This method acts as
        # an initializer only if it is called before sun.misc.VM.booted().
        Sun::Misc::VM.allow_array_syntax
        # Subsystems that are invoked during initialization can invoke
        # sun.misc.VM.isBooted() in order to avoid doing things that should
        # wait until the application class loader has been set up.
        Sun::Misc::VM.booted
        # The main thread is not added to its thread group in the same
        # way as other threads; we must do it ourselves here.
        current = JavaThread.current_thread
        current.get_thread_group.add(current)
        Sun::Misc::SharedSecrets.set_java_lang_access(# Allow privileged classes outside of java.lang
        Class.new(Sun::Misc::JavaLangAccess.class == Class ? Sun::Misc::JavaLangAccess : Object) do
          extend LocalClass
          include_class_members System
          include Sun::Misc::JavaLangAccess if Sun::Misc::JavaLangAccess.class == Module
          
          typesig { [Class] }
          define_method :get_constant_pool do |klass|
            return klass.get_constant_pool
          end
          
          typesig { [Class, AnnotationType] }
          define_method :set_annotation_type do |klass, type|
            klass.set_annotation_type(type)
          end
          
          typesig { [Class] }
          define_method :get_annotation_type do |klass|
            return klass.get_annotation_type
          end
          
          typesig { [Class] }
          define_method :get_enum_constants_shared do |klass|
            return klass.get_enum_constants_shared
          end
          
          typesig { [JavaThread, Interruptible] }
          define_method :blocked_on do |t, b|
            t.blocked_on(b)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      # returns the class of the caller.
      def get_caller_class
        # NOTE use of more generic Reflection.getCallerClass()
        return Reflection.get_caller_class(3)
      end
    }
    
    private
    alias_method :initialize__system, :initialize
  end
  
end

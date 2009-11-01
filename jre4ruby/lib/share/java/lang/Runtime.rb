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
  module RuntimeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # Every Java application has a single instance of class
  # <code>Runtime</code> that allows the application to interface with
  # the environment in which the application is running. The current
  # runtime can be obtained from the <code>getRuntime</code> method.
  # <p>
  # An application cannot create its own instance of this class.
  # 
  # @author  unascribed
  # @see     java.lang.Runtime#getRuntime()
  # @since   JDK1.0
  class Runtime 
    include_class_members RuntimeImports
    
    class_module.module_eval {
      
      def current_runtime
        defined?(@@current_runtime) ? @@current_runtime : @@current_runtime= Runtime.new
      end
      alias_method :attr_current_runtime, :current_runtime
      
      def current_runtime=(value)
        @@current_runtime = value
      end
      alias_method :attr_current_runtime=, :current_runtime=
      
      typesig { [] }
      # Returns the runtime object associated with the current Java application.
      # Most of the methods of class <code>Runtime</code> are instance
      # methods and must be invoked with respect to the current runtime object.
      # 
      # @return  the <code>Runtime</code> object associated with the current
      # Java application.
      def get_runtime
        return self.attr_current_runtime
      end
    }
    
    typesig { [] }
    # Don't let anyone else instantiate this class
    def initialize
    end
    
    typesig { [::Java::Int] }
    # Terminates the currently running Java virtual machine by initiating its
    # shutdown sequence.  This method never returns normally.  The argument
    # serves as a status code; by convention, a nonzero status code indicates
    # abnormal termination.
    # 
    # <p> The virtual machine's shutdown sequence consists of two phases.  In
    # the first phase all registered {@link #addShutdownHook shutdown hooks},
    # if any, are started in some unspecified order and allowed to run
    # concurrently until they finish.  In the second phase all uninvoked
    # finalizers are run if {@link #runFinalizersOnExit finalization-on-exit}
    # has been enabled.  Once this is done the virtual machine {@link #halt
    # halts}.
    # 
    # <p> If this method is invoked after the virtual machine has begun its
    # shutdown sequence then if shutdown hooks are being run this method will
    # block indefinitely.  If shutdown hooks have already been run and on-exit
    # finalization has been enabled then this method halts the virtual machine
    # with the given status code if the status is nonzero; otherwise, it
    # blocks indefinitely.
    # 
    # <p> The <tt>{@link System#exit(int) System.exit}</tt> method is the
    # conventional and convenient means of invoking this method. <p>
    # 
    # @param  status
    # Termination status.  By convention, a nonzero status code
    # indicates abnormal termination.
    # 
    # @throws SecurityException
    # If a security manager is present and its <tt>{@link
    # SecurityManager#checkExit checkExit}</tt> method does not permit
    # exiting with the specified status
    # 
    # @see java.lang.SecurityException
    # @see java.lang.SecurityManager#checkExit(int)
    # @see #addShutdownHook
    # @see #removeShutdownHook
    # @see #runFinalizersOnExit
    # @see #halt(int)
    def exit(status)
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_exit(status)
      end
      Shutdown.exit(status)
    end
    
    typesig { [JavaThread] }
    # Registers a new virtual-machine shutdown hook.
    # 
    # <p> The Java virtual machine <i>shuts down</i> in response to two kinds
    # of events:
    # 
    # <ul>
    # 
    # <p> <li> The program <i>exits</i> normally, when the last non-daemon
    # thread exits or when the <tt>{@link #exit exit}</tt> (equivalently,
    # <tt>{@link System#exit(int) System.exit}</tt>) method is invoked, or
    # 
    # <p> <li> The virtual machine is <i>terminated</i> in response to a
    # user interrupt, such as typing <tt>^C</tt>, or a system-wide event,
    # such as user logoff or system shutdown.
    # 
    # </ul>
    # 
    # <p> A <i>shutdown hook</i> is simply an initialized but unstarted
    # thread.  When the virtual machine begins its shutdown sequence it will
    # start all registered shutdown hooks in some unspecified order and let
    # them run concurrently.  When all the hooks have finished it will then
    # run all uninvoked finalizers if finalization-on-exit has been enabled.
    # Finally, the virtual machine will halt.  Note that daemon threads will
    # continue to run during the shutdown sequence, as will non-daemon threads
    # if shutdown was initiated by invoking the <tt>{@link #exit exit}</tt>
    # method.
    # 
    # <p> Once the shutdown sequence has begun it can be stopped only by
    # invoking the <tt>{@link #halt halt}</tt> method, which forcibly
    # terminates the virtual machine.
    # 
    # <p> Once the shutdown sequence has begun it is impossible to register a
    # new shutdown hook or de-register a previously-registered hook.
    # Attempting either of these operations will cause an
    # <tt>{@link IllegalStateException}</tt> to be thrown.
    # 
    # <p> Shutdown hooks run at a delicate time in the life cycle of a virtual
    # machine and should therefore be coded defensively.  They should, in
    # particular, be written to be thread-safe and to avoid deadlocks insofar
    # as possible.  They should also not rely blindly upon services that may
    # have registered their own shutdown hooks and therefore may themselves in
    # the process of shutting down.  Attempts to use other thread-based
    # services such as the AWT event-dispatch thread, for example, may lead to
    # deadlocks.
    # 
    # <p> Shutdown hooks should also finish their work quickly.  When a
    # program invokes <tt>{@link #exit exit}</tt> the expectation is
    # that the virtual machine will promptly shut down and exit.  When the
    # virtual machine is terminated due to user logoff or system shutdown the
    # underlying operating system may only allow a fixed amount of time in
    # which to shut down and exit.  It is therefore inadvisable to attempt any
    # user interaction or to perform a long-running computation in a shutdown
    # hook.
    # 
    # <p> Uncaught exceptions are handled in shutdown hooks just as in any
    # other thread, by invoking the <tt>{@link ThreadGroup#uncaughtException
    # uncaughtException}</tt> method of the thread's <tt>{@link
    # ThreadGroup}</tt> object.  The default implementation of this method
    # prints the exception's stack trace to <tt>{@link System#err}</tt> and
    # terminates the thread; it does not cause the virtual machine to exit or
    # halt.
    # 
    # <p> In rare circumstances the virtual machine may <i>abort</i>, that is,
    # stop running without shutting down cleanly.  This occurs when the
    # virtual machine is terminated externally, for example with the
    # <tt>SIGKILL</tt> signal on Unix or the <tt>TerminateProcess</tt> call on
    # Microsoft Windows.  The virtual machine may also abort if a native
    # method goes awry by, for example, corrupting internal data structures or
    # attempting to access nonexistent memory.  If the virtual machine aborts
    # then no guarantee can be made about whether or not any shutdown hooks
    # will be run. <p>
    # 
    # @param   hook
    # An initialized but unstarted <tt>{@link Thread}</tt> object
    # 
    # @throws  IllegalArgumentException
    # If the specified hook has already been registered,
    # or if it can be determined that the hook is already running or
    # has already been run
    # 
    # @throws  IllegalStateException
    # If the virtual machine is already in the process
    # of shutting down
    # 
    # @throws  SecurityException
    # If a security manager is present and it denies
    # <tt>{@link RuntimePermission}("shutdownHooks")</tt>
    # 
    # @see #removeShutdownHook
    # @see #halt(int)
    # @see #exit(int)
    # @since 1.3
    def add_shutdown_hook(hook)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(RuntimePermission.new("shutdownHooks"))
      end
      ApplicationShutdownHooks.add(hook)
    end
    
    typesig { [JavaThread] }
    # De-registers a previously-registered virtual-machine shutdown hook. <p>
    # 
    # @param hook the hook to remove
    # @return <tt>true</tt> if the specified hook had previously been
    # registered and was successfully de-registered, <tt>false</tt>
    # otherwise.
    # 
    # @throws  IllegalStateException
    # If the virtual machine is already in the process of shutting
    # down
    # 
    # @throws  SecurityException
    # If a security manager is present and it denies
    # <tt>{@link RuntimePermission}("shutdownHooks")</tt>
    # 
    # @see #addShutdownHook
    # @see #exit(int)
    # @since 1.3
    def remove_shutdown_hook(hook)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(RuntimePermission.new("shutdownHooks"))
      end
      return ApplicationShutdownHooks.remove(hook)
    end
    
    typesig { [::Java::Int] }
    # Forcibly terminates the currently running Java virtual machine.  This
    # method never returns normally.
    # 
    # <p> This method should be used with extreme caution.  Unlike the
    # <tt>{@link #exit exit}</tt> method, this method does not cause shutdown
    # hooks to be started and does not run uninvoked finalizers if
    # finalization-on-exit has been enabled.  If the shutdown sequence has
    # already been initiated then this method does not wait for any running
    # shutdown hooks or finalizers to finish their work. <p>
    # 
    # @param  status
    # Termination status.  By convention, a nonzero status code
    # indicates abnormal termination.  If the <tt>{@link Runtime#exit
    # exit}</tt> (equivalently, <tt>{@link System#exit(int)
    # System.exit}</tt>) method has already been invoked then this
    # status code will override the status code passed to that method.
    # 
    # @throws SecurityException
    # If a security manager is present and its <tt>{@link
    # SecurityManager#checkExit checkExit}</tt> method does not permit
    # an exit with the specified status
    # 
    # @see #exit
    # @see #addShutdownHook
    # @see #removeShutdownHook
    # @since 1.3
    def halt(status)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_exit(status)
      end
      Shutdown.halt(status)
    end
    
    class_module.module_eval {
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
      # @param value true to enable finalization on exit, false to disable
      # @deprecated  This method is inherently unsafe.  It may result in
      # finalizers being called on live objects while other threads are
      # concurrently manipulating those objects, resulting in erratic
      # behavior or deadlock.
      # 
      # @throws  SecurityException
      # if a security manager exists and its <code>checkExit</code>
      # method doesn't allow the exit.
      # 
      # @see     java.lang.Runtime#exit(int)
      # @see     java.lang.Runtime#gc()
      # @see     java.lang.SecurityManager#checkExit(int)
      # @since   JDK1.1
      def run_finalizers_on_exit(value)
        security = System.get_security_manager
        if (!(security).nil?)
          begin
            security.check_exit(0)
          rescue SecurityException => e
            raise SecurityException.new("runFinalizersOnExit")
          end
        end
        Shutdown.set_run_finalizers_on_exit(value)
      end
    }
    
    typesig { [String] }
    # Executes the specified string command in a separate process.
    # 
    # <p>This is a convenience method.  An invocation of the form
    # <tt>exec(command)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>{@link #exec(String, String[], File) exec}(command, null, null)</tt>.
    # 
    # @param   command   a specified system command.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>command</code> is <code>null</code>
    # 
    # @throws  IllegalArgumentException
    # If <code>command</code> is empty
    # 
    # @see     #exec(String[], String[], File)
    # @see     ProcessBuilder
    def exec(command)
      return exec(command, nil, nil)
    end
    
    typesig { [String, Array.typed(String)] }
    # Executes the specified string command in a separate process with the
    # specified environment.
    # 
    # <p>This is a convenience method.  An invocation of the form
    # <tt>exec(command, envp)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>{@link #exec(String, String[], File) exec}(command, envp, null)</tt>.
    # 
    # @param   command   a specified system command.
    # 
    # @param   envp      array of strings, each element of which
    # has environment variable settings in the format
    # <i>name</i>=<i>value</i>, or
    # <tt>null</tt> if the subprocess should inherit
    # the environment of the current process.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>command</code> is <code>null</code>,
    # or one of the elements of <code>envp</code> is <code>null</code>
    # 
    # @throws  IllegalArgumentException
    # If <code>command</code> is empty
    # 
    # @see     #exec(String[], String[], File)
    # @see     ProcessBuilder
    def exec(command, envp)
      return exec(command, envp, nil)
    end
    
    typesig { [String, Array.typed(String), JavaFile] }
    # Executes the specified string command in a separate process with the
    # specified environment and working directory.
    # 
    # <p>This is a convenience method.  An invocation of the form
    # <tt>exec(command, envp, dir)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>{@link #exec(String[], String[], File) exec}(cmdarray, envp, dir)</tt>,
    # where <code>cmdarray</code> is an array of all the tokens in
    # <code>command</code>.
    # 
    # <p>More precisely, the <code>command</code> string is broken
    # into tokens using a {@link StringTokenizer} created by the call
    # <code>new {@link StringTokenizer}(command)</code> with no
    # further modification of the character categories.  The tokens
    # produced by the tokenizer are then placed in the new string
    # array <code>cmdarray</code>, in the same order.
    # 
    # @param   command   a specified system command.
    # 
    # @param   envp      array of strings, each element of which
    # has environment variable settings in the format
    # <i>name</i>=<i>value</i>, or
    # <tt>null</tt> if the subprocess should inherit
    # the environment of the current process.
    # 
    # @param   dir       the working directory of the subprocess, or
    # <tt>null</tt> if the subprocess should inherit
    # the working directory of the current process.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>command</code> is <code>null</code>,
    # or one of the elements of <code>envp</code> is <code>null</code>
    # 
    # @throws  IllegalArgumentException
    # If <code>command</code> is empty
    # 
    # @see     ProcessBuilder
    # @since 1.3
    def exec(command, envp, dir)
      if ((command.length).equal?(0))
        raise IllegalArgumentException.new("Empty command")
      end
      st = StringTokenizer.new(command)
      cmdarray = Array.typed(String).new(st.count_tokens) { nil }
      i = 0
      while st.has_more_tokens
        cmdarray[i] = st.next_token
        i += 1
      end
      return exec(cmdarray, envp, dir)
    end
    
    typesig { [Array.typed(String)] }
    # Executes the specified command and arguments in a separate process.
    # 
    # <p>This is a convenience method.  An invocation of the form
    # <tt>exec(cmdarray)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>{@link #exec(String[], String[], File) exec}(cmdarray, null, null)</tt>.
    # 
    # @param   cmdarray  array containing the command to call and
    # its arguments.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>cmdarray</code> is <code>null</code>,
    # or one of the elements of <code>cmdarray</code> is <code>null</code>
    # 
    # @throws  IndexOutOfBoundsException
    # If <code>cmdarray</code> is an empty array
    # (has length <code>0</code>)
    # 
    # @see     ProcessBuilder
    def exec(cmdarray)
      return exec(cmdarray, nil, nil)
    end
    
    typesig { [Array.typed(String), Array.typed(String)] }
    # Executes the specified command and arguments in a separate process
    # with the specified environment.
    # 
    # <p>This is a convenience method.  An invocation of the form
    # <tt>exec(cmdarray, envp)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>{@link #exec(String[], String[], File) exec}(cmdarray, envp, null)</tt>.
    # 
    # @param   cmdarray  array containing the command to call and
    # its arguments.
    # 
    # @param   envp      array of strings, each element of which
    # has environment variable settings in the format
    # <i>name</i>=<i>value</i>, or
    # <tt>null</tt> if the subprocess should inherit
    # the environment of the current process.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>cmdarray</code> is <code>null</code>,
    # or one of the elements of <code>cmdarray</code> is <code>null</code>,
    # or one of the elements of <code>envp</code> is <code>null</code>
    # 
    # @throws  IndexOutOfBoundsException
    # If <code>cmdarray</code> is an empty array
    # (has length <code>0</code>)
    # 
    # @see     ProcessBuilder
    def exec(cmdarray, envp)
      return exec(cmdarray, envp, nil)
    end
    
    typesig { [Array.typed(String), Array.typed(String), JavaFile] }
    # Executes the specified command and arguments in a separate process with
    # the specified environment and working directory.
    # 
    # <p>Given an array of strings <code>cmdarray</code>, representing the
    # tokens of a command line, and an array of strings <code>envp</code>,
    # representing "environment" variable settings, this method creates
    # a new process in which to execute the specified command.
    # 
    # <p>This method checks that <code>cmdarray</code> is a valid operating
    # system command.  Which commands are valid is system-dependent,
    # but at the very least the command must be a non-empty list of
    # non-null strings.
    # 
    # <p>If <tt>envp</tt> is <tt>null</tt>, the subprocess inherits the
    # environment settings of the current process.
    # 
    # <p>{@link ProcessBuilder#start()} is now the preferred way to
    # start a process with a modified environment.
    # 
    # <p>The working directory of the new subprocess is specified by <tt>dir</tt>.
    # If <tt>dir</tt> is <tt>null</tt>, the subprocess inherits the
    # current working directory of the current process.
    # 
    # <p>If a security manager exists, its
    # {@link SecurityManager#checkExec checkExec}
    # method is invoked with the first component of the array
    # <code>cmdarray</code> as its argument. This may result in a
    # {@link SecurityException} being thrown.
    # 
    # <p>Starting an operating system process is highly system-dependent.
    # Among the many things that can go wrong are:
    # <ul>
    # <li>The operating system program file was not found.
    # <li>Access to the program file was denied.
    # <li>The working directory does not exist.
    # </ul>
    # 
    # <p>In such cases an exception will be thrown.  The exact nature
    # of the exception is system-dependent, but it will always be a
    # subclass of {@link IOException}.
    # 
    # 
    # @param   cmdarray  array containing the command to call and
    # its arguments.
    # 
    # @param   envp      array of strings, each element of which
    # has environment variable settings in the format
    # <i>name</i>=<i>value</i>, or
    # <tt>null</tt> if the subprocess should inherit
    # the environment of the current process.
    # 
    # @param   dir       the working directory of the subprocess, or
    # <tt>null</tt> if the subprocess should inherit
    # the working directory of the current process.
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @throws  NullPointerException
    # If <code>cmdarray</code> is <code>null</code>,
    # or one of the elements of <code>cmdarray</code> is <code>null</code>,
    # or one of the elements of <code>envp</code> is <code>null</code>
    # 
    # @throws  IndexOutOfBoundsException
    # If <code>cmdarray</code> is an empty array
    # (has length <code>0</code>)
    # 
    # @see     ProcessBuilder
    # @since 1.3
    def exec(cmdarray, envp, dir)
      return ProcessBuilder.new(cmdarray).environment(envp).directory(dir).start
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_availableProcessors, [:pointer, :long], :int32
    typesig { [] }
    # Returns the number of processors available to the Java virtual machine.
    # 
    # <p> This value may change during a particular invocation of the virtual
    # machine.  Applications that are sensitive to the number of available
    # processors should therefore occasionally poll this property and adjust
    # their resource usage appropriately. </p>
    # 
    # @return  the maximum number of processors available to the virtual
    # machine; never smaller than one
    # @since 1.4
    def available_processors
      JNI.call_native_method(:Java_java_lang_Runtime_availableProcessors, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_freeMemory, [:pointer, :long], :int64
    typesig { [] }
    # Returns the amount of free memory in the Java Virtual Machine.
    # Calling the
    # <code>gc</code> method may result in increasing the value returned
    # by <code>freeMemory.</code>
    # 
    # @return  an approximation to the total amount of memory currently
    # available for future allocated objects, measured in bytes.
    def free_memory
      JNI.call_native_method(:Java_java_lang_Runtime_freeMemory, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_totalMemory, [:pointer, :long], :int64
    typesig { [] }
    # Returns the total amount of memory in the Java virtual machine.
    # The value returned by this method may vary over time, depending on
    # the host environment.
    # <p>
    # Note that the amount of memory required to hold an object of any
    # given type may be implementation-dependent.
    # 
    # @return  the total amount of memory currently available for current
    # and future objects, measured in bytes.
    def total_memory
      JNI.call_native_method(:Java_java_lang_Runtime_totalMemory, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_maxMemory, [:pointer, :long], :int64
    typesig { [] }
    # Returns the maximum amount of memory that the Java virtual machine will
    # attempt to use.  If there is no inherent limit then the value {@link
    # java.lang.Long#MAX_VALUE} will be returned. </p>
    # 
    # @return  the maximum amount of memory that the virtual machine will
    # attempt to use, measured in bytes
    # @since 1.4
    def max_memory
      JNI.call_native_method(:Java_java_lang_Runtime_maxMemory, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_gc, [:pointer, :long], :void
    typesig { [] }
    # Runs the garbage collector.
    # Calling this method suggests that the Java virtual machine expend
    # effort toward recycling unused objects in order to make the memory
    # they currently occupy available for quick reuse. When control
    # returns from the method call, the virtual machine has made
    # its best effort to recycle all discarded objects.
    # <p>
    # The name <code>gc</code> stands for "garbage
    # collector". The virtual machine performs this recycling
    # process automatically as needed, in a separate thread, even if the
    # <code>gc</code> method is not invoked explicitly.
    # <p>
    # The method {@link System#gc()} is the conventional and convenient
    # means of invoking this method.
    def gc
      JNI.call_native_method(:Java_java_lang_Runtime_gc, JNI.env, self.jni_id)
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_lang_Runtime_runFinalization0, [:pointer, :long], :void
      typesig { [] }
      # Wormhole for calling java.lang.ref.Finalizer.runFinalization
      def run_finalization0
        JNI.call_native_method(:Java_java_lang_Runtime_runFinalization0, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    # Runs the finalization methods of any objects pending finalization.
    # Calling this method suggests that the Java virtual machine expend
    # effort toward running the <code>finalize</code> methods of objects
    # that have been found to be discarded but whose <code>finalize</code>
    # methods have not yet been run. When control returns from the
    # method call, the virtual machine has made a best effort to
    # complete all outstanding finalizations.
    # <p>
    # The virtual machine performs the finalization process
    # automatically as needed, in a separate thread, if the
    # <code>runFinalization</code> method is not invoked explicitly.
    # <p>
    # The method {@link System#runFinalization()} is the conventional
    # and convenient means of invoking this method.
    # 
    # @see     java.lang.Object#finalize()
    def run_finalization
      run_finalization0
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_traceInstructions, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    # Enables/Disables tracing of instructions.
    # If the <code>boolean</code> argument is <code>true</code>, this
    # method suggests that the Java virtual machine emit debugging
    # information for each instruction in the virtual machine as it
    # is executed. The format of this information, and the file or other
    # output stream to which it is emitted, depends on the host environment.
    # The virtual machine may ignore this request if it does not support
    # this feature. The destination of the trace output is system
    # dependent.
    # <p>
    # If the <code>boolean</code> argument is <code>false</code>, this
    # method causes the virtual machine to stop performing the
    # detailed instruction trace it is performing.
    # 
    # @param   on   <code>true</code> to enable instruction tracing;
    # <code>false</code> to disable this feature.
    def trace_instructions(on)
      JNI.call_native_method(:Java_java_lang_Runtime_traceInstructions, JNI.env, self.jni_id, on ? 1 : 0)
    end
    
    JNI.load_native_method :Java_java_lang_Runtime_traceMethodCalls, [:pointer, :long, :int8], :void
    typesig { [::Java::Boolean] }
    # Enables/Disables tracing of method calls.
    # If the <code>boolean</code> argument is <code>true</code>, this
    # method suggests that the Java virtual machine emit debugging
    # information for each method in the virtual machine as it is
    # called. The format of this information, and the file or other output
    # stream to which it is emitted, depends on the host environment. The
    # virtual machine may ignore this request if it does not support
    # this feature.
    # <p>
    # Calling this method with argument false suggests that the
    # virtual machine cease emitting per-call debugging information.
    # 
    # @param   on   <code>true</code> to enable instruction tracing;
    # <code>false</code> to disable this feature.
    def trace_method_calls(on)
      JNI.call_native_method(:Java_java_lang_Runtime_traceMethodCalls, JNI.env, self.jni_id, on ? 1 : 0)
    end
    
    typesig { [String] }
    # Loads the specified filename as a dynamic library. The filename
    # argument must be a complete path name,
    # (for example
    # <code>Runtime.getRuntime().load("/home/avh/lib/libX11.so");</code>).
    # <p>
    # First, if there is a security manager, its <code>checkLink</code>
    # method is called with the <code>filename</code> as its argument.
    # This may result in a security exception.
    # <p>
    # This is similar to the method {@link #loadLibrary(String)}, but it
    # accepts a general file name as an argument rather than just a library
    # name, allowing any file of native code to be loaded.
    # <p>
    # The method {@link System#load(String)} is the conventional and
    # convenient means of invoking this method.
    # 
    # @param      filename   the file to load.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkLink</code> method doesn't allow
    # loading of the specified dynamic library
    # @exception  UnsatisfiedLinkError  if the file does not exist.
    # @exception  NullPointerException if <code>filename</code> is
    # <code>null</code>
    # @see        java.lang.Runtime#getRuntime()
    # @see        java.lang.SecurityException
    # @see        java.lang.SecurityManager#checkLink(java.lang.String)
    def load(filename)
      load0(System.get_caller_class, filename)
    end
    
    typesig { [Class, String] }
    def load0(from_class, filename)
      synchronized(self) do
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_link(filename)
        end
        if (!(JavaFile.new(filename).is_absolute))
          raise UnsatisfiedLinkError.new("Expecting an absolute path of the library: " + filename)
        end
        ClassLoader.load_library(from_class, filename, true)
      end
    end
    
    typesig { [String] }
    # Loads the dynamic library with the specified library name.
    # A file containing native code is loaded from the local file system
    # from a place where library files are conventionally obtained. The
    # details of this process are implementation-dependent. The
    # mapping from a library name to a specific filename is done in a
    # system-specific manner.
    # <p>
    # First, if there is a security manager, its <code>checkLink</code>
    # method is called with the <code>libname</code> as its argument.
    # This may result in a security exception.
    # <p>
    # The method {@link System#loadLibrary(String)} is the conventional
    # and convenient means of invoking this method. If native
    # methods are to be used in the implementation of a class, a standard
    # strategy is to put the native code in a library file (call it
    # <code>LibFile</code>) and then to put a static initializer:
    # <blockquote><pre>
    # static { System.loadLibrary("LibFile"); }
    # </pre></blockquote>
    # within the class declaration. When the class is loaded and
    # initialized, the necessary native code implementation for the native
    # methods will then be loaded as well.
    # <p>
    # If this method is called more than once with the same library
    # name, the second and subsequent calls are ignored.
    # 
    # @param      libname   the name of the library.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkLink</code> method doesn't allow
    # loading of the specified dynamic library
    # @exception  UnsatisfiedLinkError  if the library does not exist.
    # @exception  NullPointerException if <code>libname</code> is
    # <code>null</code>
    # @see        java.lang.SecurityException
    # @see        java.lang.SecurityManager#checkLink(java.lang.String)
    def load_library(libname)
      load_library0(System.get_caller_class, libname)
    end
    
    typesig { [Class, String] }
    def load_library0(from_class, libname)
      synchronized(self) do
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_link(libname)
        end
        if (!(libname.index_of(RJava.cast_to_int(JavaFile.attr_separator_char))).equal?(-1))
          raise UnsatisfiedLinkError.new("Directory separator should not appear in library name: " + libname)
        end
        ClassLoader.load_library(from_class, libname, false)
      end
    end
    
    typesig { [InputStream] }
    # Creates a localized version of an input stream. This method takes
    # an <code>InputStream</code> and returns an <code>InputStream</code>
    # equivalent to the argument in all respects except that it is
    # localized: as characters in the local character set are read from
    # the stream, they are automatically converted from the local
    # character set to Unicode.
    # <p>
    # If the argument is already a localized stream, it may be returned
    # as the result.
    # 
    # @param      in InputStream to localize
    # @return     a localized input stream
    # @see        java.io.InputStream
    # @see        java.io.BufferedReader#BufferedReader(java.io.Reader)
    # @see        java.io.InputStreamReader#InputStreamReader(java.io.InputStream)
    # @deprecated As of JDK&nbsp;1.1, the preferred way to translate a byte
    # stream in the local encoding into a character stream in Unicode is via
    # the <code>InputStreamReader</code> and <code>BufferedReader</code>
    # classes.
    def get_localized_input_stream(in_)
      return in_
    end
    
    typesig { [OutputStream] }
    # Creates a localized version of an output stream. This method
    # takes an <code>OutputStream</code> and returns an
    # <code>OutputStream</code> equivalent to the argument in all respects
    # except that it is localized: as Unicode characters are written to
    # the stream, they are automatically converted to the local
    # character set.
    # <p>
    # If the argument is already a localized stream, it may be returned
    # as the result.
    # 
    # @deprecated As of JDK&nbsp;1.1, the preferred way to translate a
    # Unicode character stream into a byte stream in the local encoding is via
    # the <code>OutputStreamWriter</code>, <code>BufferedWriter</code>, and
    # <code>PrintWriter</code> classes.
    # 
    # @param      out OutputStream to localize
    # @return     a localized output stream
    # @see        java.io.OutputStream
    # @see        java.io.BufferedWriter#BufferedWriter(java.io.Writer)
    # @see        java.io.OutputStreamWriter#OutputStreamWriter(java.io.OutputStream)
    # @see        java.io.PrintWriter#PrintWriter(java.io.OutputStream)
    def get_localized_output_stream(out)
      return out
    end
    
    private
    alias_method :initialize__runtime, :initialize
  end
  
end

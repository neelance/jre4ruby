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
module Java::Lang
  module ProcessBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
    }
  end
  
  # This class is used to create operating system processes.
  # 
  # <p>Each <code>ProcessBuilder</code> instance manages a collection
  # of process attributes.  The {@link #start()} method creates a new
  # {@link Process} instance with those attributes.  The {@link
  # #start()} method can be invoked repeatedly from the same instance
  # to create new subprocesses with identical or related attributes.
  # 
  # <p>Each process builder manages these process attributes:
  # 
  # <ul>
  # 
  # <li>a <i>command</i>, a list of strings which signifies the
  # external program file to be invoked and its arguments, if any.
  # Which string lists represent a valid operating system command is
  # system-dependent.  For example, it is common for each conceptual
  # argument to be an element in this list, but there are operating
  # systems where programs are expected to tokenize command line
  # strings themselves - on such a system a Java implementation might
  # require commands to contain exactly two elements.
  # 
  # <li>an <i>environment</i>, which is a system-dependent mapping from
  # <i>variables</i> to <i>values</i>.  The initial value is a copy of
  # the environment of the current process (see {@link System#getenv()}).
  # 
  # <li>a <i>working directory</i>.  The default value is the current
  # working directory of the current process, usually the directory
  # named by the system property <code>user.dir</code>.
  # 
  # <li>a <i>redirectErrorStream</i> property.  Initially, this property
  # is <code>false</code>, meaning that the standard output and error
  # output of a subprocess are sent to two separate streams, which can
  # be accessed using the {@link Process#getInputStream()} and {@link
  # Process#getErrorStream()} methods.  If the value is set to
  # <code>true</code>, the standard error is merged with the standard
  # output.  This makes it easier to correlate error messages with the
  # corresponding output.  In this case, the merged data can be read
  # from the stream returned by {@link Process#getInputStream()}, while
  # reading from the stream returned by {@link
  # Process#getErrorStream()} will get an immediate end of file.
  # 
  # </ul>
  # 
  # <p>Modifying a process builder's attributes will affect processes
  # subsequently started by that object's {@link #start()} method, but
  # will never affect previously started processes or the Java process
  # itself.
  # 
  # <p>Most error checking is performed by the {@link #start()} method.
  # It is possible to modify the state of an object so that {@link
  # #start()} will fail.  For example, setting the command attribute to
  # an empty list will not throw an exception unless {@link #start()}
  # is invoked.
  # 
  # <p><strong>Note that this class is not synchronized.</strong>
  # If multiple threads access a <code>ProcessBuilder</code> instance
  # concurrently, and at least one of the threads modifies one of the
  # attributes structurally, it <i>must</i> be synchronized externally.
  # 
  # <p>Starting a new process which uses the default working directory
  # and environment is easy:
  # 
  # <blockquote><pre>
  # Process p = new ProcessBuilder("myCommand", "myArg").start();
  # </pre></blockquote>
  # 
  # <p>Here is an example that starts a process with a modified working
  # directory and environment:
  # 
  # <blockquote><pre>
  # ProcessBuilder pb = new ProcessBuilder("myCommand", "myArg1", "myArg2");
  # Map&lt;String, String&gt; env = pb.environment();
  # env.put("VAR1", "myValue");
  # env.remove("OTHERVAR");
  # env.put("VAR2", env.get("VAR1") + "suffix");
  # pb.directory(new File("myDir"));
  # Process p = pb.start();
  # </pre></blockquote>
  # 
  # <p>To start a process with an explicit set of environment
  # variables, first call {@link java.util.Map#clear() Map.clear()}
  # before adding environment variables.
  # 
  # @since 1.5
  class ProcessBuilder 
    include_class_members ProcessBuilderImports
    
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    attr_accessor :directory
    alias_method :attr_directory, :directory
    undef_method :directory
    alias_method :attr_directory=, :directory=
    undef_method :directory=
    
    attr_accessor :environment
    alias_method :attr_environment, :environment
    undef_method :environment
    alias_method :attr_environment=, :environment=
    undef_method :environment=
    
    attr_accessor :redirect_error_stream
    alias_method :attr_redirect_error_stream, :redirect_error_stream
    undef_method :redirect_error_stream
    alias_method :attr_redirect_error_stream=, :redirect_error_stream=
    undef_method :redirect_error_stream=
    
    typesig { [JavaList] }
    # Constructs a process builder with the specified operating
    # system program and arguments.  This constructor does <i>not</i>
    # make a copy of the <code>command</code> list.  Subsequent
    # updates to the list will be reflected in the state of the
    # process builder.  It is not checked whether
    # <code>command</code> corresponds to a valid operating system
    # command.</p>
    # 
    # @param   command  The list containing the program and its arguments
    # 
    # @throws  NullPointerException
    # If the argument is <code>null</code>
    def initialize(command)
      @command = nil
      @directory = nil
      @environment = nil
      @redirect_error_stream = false
      if ((command).nil?)
        raise NullPointerException.new
      end
      @command = command
    end
    
    typesig { [String] }
    # Constructs a process builder with the specified operating
    # system program and arguments.  This is a convenience
    # constructor that sets the process builder's command to a string
    # list containing the same strings as the <code>command</code>
    # array, in the same order.  It is not checked whether
    # <code>command</code> corresponds to a valid operating system
    # command.</p>
    # 
    # @param   command  A string array containing the program and its arguments
    def initialize(*command)
      @command = nil
      @directory = nil
      @environment = nil
      @redirect_error_stream = false
      @command = ArrayList.new(command.attr_length)
      command.each do |arg|
        @command.add(arg)
      end
    end
    
    typesig { [JavaList] }
    # Sets this process builder's operating system program and
    # arguments.  This method does <i>not</i> make a copy of the
    # <code>command</code> list.  Subsequent updates to the list will
    # be reflected in the state of the process builder.  It is not
    # checked whether <code>command</code> corresponds to a valid
    # operating system command.</p>
    # 
    # @param   command  The list containing the program and its arguments
    # @return  This process builder
    # 
    # @throws  NullPointerException
    # If the argument is <code>null</code>
    def command(command)
      if ((command).nil?)
        raise NullPointerException.new
      end
      @command = command
      return self
    end
    
    typesig { [String] }
    # Sets this process builder's operating system program and
    # arguments.  This is a convenience method that sets the command
    # to a string list containing the same strings as the
    # <code>command</code> array, in the same order.  It is not
    # checked whether <code>command</code> corresponds to a valid
    # operating system command.</p>
    # 
    # @param   command  A string array containing the program and its arguments
    # @return  This process builder
    def command(*command)
      @command = ArrayList.new(command.attr_length)
      command.each do |arg|
        @command.add(arg)
      end
      return self
    end
    
    typesig { [] }
    # Returns this process builder's operating system program and
    # arguments.  The returned list is <i>not</i> a copy.  Subsequent
    # updates to the list will be reflected in the state of this
    # process builder.</p>
    # 
    # @return  This process builder's program and its arguments
    def command
      return @command
    end
    
    typesig { [] }
    # Returns a string map view of this process builder's environment.
    # 
    # Whenever a process builder is created, the environment is
    # initialized to a copy of the current process environment (see
    # {@link System#getenv()}).  Subprocesses subsequently started by
    # this object's {@link #start()} method will use this map as
    # their environment.
    # 
    # <p>The returned object may be modified using ordinary {@link
    # java.util.Map Map} operations.  These modifications will be
    # visible to subprocesses started via the {@link #start()}
    # method.  Two <code>ProcessBuilder</code> instances always
    # contain independent process environments, so changes to the
    # returned map will never be reflected in any other
    # <code>ProcessBuilder</code> instance or the values returned by
    # {@link System#getenv System.getenv}.
    # 
    # <p>If the system does not support environment variables, an
    # empty map is returned.
    # 
    # <p>The returned map does not permit null keys or values.
    # Attempting to insert or query the presence of a null key or
    # value will throw a {@link NullPointerException}.
    # Attempting to query the presence of a key or value which is not
    # of type {@link String} will throw a {@link ClassCastException}.
    # 
    # <p>The behavior of the returned map is system-dependent.  A
    # system may not allow modifications to environment variables or
    # may forbid certain variable names or values.  For this reason,
    # attempts to modify the map may fail with
    # {@link UnsupportedOperationException} or
    # {@link IllegalArgumentException}
    # if the modification is not permitted by the operating system.
    # 
    # <p>Since the external format of environment variable names and
    # values is system-dependent, there may not be a one-to-one
    # mapping between them and Java's Unicode strings.  Nevertheless,
    # the map is implemented in such a way that environment variables
    # which are not modified by Java code will have an unmodified
    # native representation in the subprocess.
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
    # <a href=System.html#EnvironmentVSSystemProperties>system properties</a>
    # are generally preferred over environment variables.</p>
    # 
    # @return  This process builder's environment
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkPermission checkPermission}
    # method doesn't allow access to the process environment
    # 
    # @see     Runtime#exec(String[],String[],java.io.File)
    # @see     System#getenv()
    def environment
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_permission(RuntimePermission.new("getenv.*"))
      end
      if ((@environment).nil?)
        @environment = ProcessEnvironment.environment
      end
      raise AssertError if not (!(@environment).nil?)
      return @environment
    end
    
    typesig { [Array.typed(String)] }
    # Only for use by Runtime.exec(...envp...)
    def environment(envp)
      raise AssertError if not ((@environment).nil?)
      if (!(envp).nil?)
        @environment = ProcessEnvironment.empty_environment(envp.attr_length)
        raise AssertError if not (!(@environment).nil?)
        envp.each do |envstring|
          # Before 1.5, we blindly passed invalid envstrings
          # to the child process.
          # We would like to throw an exception, but do not,
          # for compatibility with old broken code.
          # Silently discard any trailing junk.
          if (!(envstring.index_of(RJava.cast_to_int(Character.new(0x0000)))).equal?(-1))
            envstring = (envstring.replace_first(("".to_u << 0x0000 << ".*"), "")).to_s
          end
          eqlsign = envstring.index_of(Character.new(?=.ord), ProcessEnvironment::MIN_NAME_LENGTH)
          # Silently ignore envstrings lacking the required `='.
          if (!(eqlsign).equal?(-1))
            @environment.put(envstring.substring(0, eqlsign), envstring.substring(eqlsign + 1))
          end
        end
      end
      return self
    end
    
    typesig { [] }
    # Returns this process builder's working directory.
    # 
    # Subprocesses subsequently started by this object's {@link
    # #start()} method will use this as their working directory.
    # The returned value may be <code>null</code> -- this means to use
    # the working directory of the current Java process, usually the
    # directory named by the system property <code>user.dir</code>,
    # as the working directory of the child process.</p>
    # 
    # @return  This process builder's working directory
    def directory
      return @directory
    end
    
    typesig { [JavaFile] }
    # Sets this process builder's working directory.
    # 
    # Subprocesses subsequently started by this object's {@link
    # #start()} method will use this as their working directory.
    # The argument may be <code>null</code> -- this means to use the
    # working directory of the current Java process, usually the
    # directory named by the system property <code>user.dir</code>,
    # as the working directory of the child process.</p>
    # 
    # @param   directory  The new working directory
    # @return  This process builder
    def directory(directory)
      @directory = directory
      return self
    end
    
    typesig { [] }
    # Tells whether this process builder merges standard error and
    # standard output.
    # 
    # <p>If this property is <code>true</code>, then any error output
    # generated by subprocesses subsequently started by this object's
    # {@link #start()} method will be merged with the standard
    # output, so that both can be read using the
    # {@link Process#getInputStream()} method.  This makes it easier
    # to correlate error messages with the corresponding output.
    # The initial value is <code>false</code>.</p>
    # 
    # @return  This process builder's <code>redirectErrorStream</code> property
    def redirect_error_stream
      return @redirect_error_stream
    end
    
    typesig { [::Java::Boolean] }
    # Sets this process builder's <code>redirectErrorStream</code> property.
    # 
    # <p>If this property is <code>true</code>, then any error output
    # generated by subprocesses subsequently started by this object's
    # {@link #start()} method will be merged with the standard
    # output, so that both can be read using the
    # {@link Process#getInputStream()} method.  This makes it easier
    # to correlate error messages with the corresponding output.
    # The initial value is <code>false</code>.</p>
    # 
    # @param   redirectErrorStream  The new property value
    # @return  This process builder
    def redirect_error_stream(redirect_error_stream)
      @redirect_error_stream = redirect_error_stream
      return self
    end
    
    typesig { [] }
    # Starts a new process using the attributes of this process builder.
    # 
    # <p>The new process will
    # invoke the command and arguments given by {@link #command()},
    # in a working directory as given by {@link #directory()},
    # with a process environment as given by {@link #environment()}.
    # 
    # <p>This method checks that the command is a valid operating
    # system command.  Which commands are valid is system-dependent,
    # but at the very least the command must be a non-empty list of
    # non-null strings.
    # 
    # <p>If there is a security manager, its
    # {@link SecurityManager#checkExec checkExec}
    # method is called with the first component of this object's
    # <code>command</code> array as its argument. This may result in
    # a {@link SecurityException} being thrown.
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
    # <p>Subsequent modifications to this process builder will not
    # affect the returned {@link Process}.</p>
    # 
    # @return  A new {@link Process} object for managing the subprocess
    # 
    # @throws  NullPointerException
    # If an element of the command list is null
    # 
    # @throws  IndexOutOfBoundsException
    # If the command is an empty list (has size <code>0</code>)
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # {@link SecurityManager#checkExec checkExec}
    # method doesn't allow creation of the subprocess
    # 
    # @throws  IOException
    # If an I/O error occurs
    # 
    # @see     Runtime#exec(String[], String[], java.io.File)
    # @see     SecurityManager#checkExec(String)
    def start
      # Must convert to array first -- a malicious user-supplied
      # list might try to circumvent the security check.
      cmdarray = @command.to_array(Array.typed(String).new(@command.size) { nil })
      cmdarray.each do |arg|
        if ((arg).nil?)
          raise NullPointerException.new
        end
      end
      # Throws IndexOutOfBoundsException if command is empty
      prog = cmdarray[0]
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_exec(prog)
      end
      dir = (@directory).nil? ? nil : @directory.to_s
      begin
        return ProcessImpl.start(cmdarray, @environment, dir, @redirect_error_stream)
      rescue IOException => e
        # It's much easier for us to create a high-quality error
        # message than the low-level C code which found the problem.
        raise IOException.new("Cannot run program \"" + prog + "\"" + (((dir).nil? ? "" : " (in directory \"" + dir + "\")")).to_s + ": " + (e.get_message).to_s, e)
      end
    end
    
    private
    alias_method :initialize__process_builder, :initialize
  end
  
end

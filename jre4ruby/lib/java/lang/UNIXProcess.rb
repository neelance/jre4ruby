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
  module UNIXProcessImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # java.lang.Process subclass in the UNIX environment.
  # 
  # @author Mario Wolczko and Ross Knippel.
  # @author Konstantin Kladko (ported to Linux)
  class UNIXProcess < UNIXProcessImports.const_get :Process
    include_class_members UNIXProcessImports
    
    attr_accessor :stdin_fd
    alias_method :attr_stdin_fd, :stdin_fd
    undef_method :stdin_fd
    alias_method :attr_stdin_fd=, :stdin_fd=
    undef_method :stdin_fd=
    
    attr_accessor :stdout_fd
    alias_method :attr_stdout_fd, :stdout_fd
    undef_method :stdout_fd
    alias_method :attr_stdout_fd=, :stdout_fd=
    undef_method :stdout_fd=
    
    attr_accessor :stderr_fd
    alias_method :attr_stderr_fd, :stderr_fd
    undef_method :stderr_fd
    alias_method :attr_stderr_fd=, :stderr_fd=
    undef_method :stderr_fd=
    
    attr_accessor :pid
    alias_method :attr_pid, :pid
    undef_method :pid
    alias_method :attr_pid=, :pid=
    undef_method :pid=
    
    attr_accessor :exitcode
    alias_method :attr_exitcode, :exitcode
    undef_method :exitcode
    alias_method :attr_exitcode=, :exitcode=
    undef_method :exitcode=
    
    attr_accessor :has_exited
    alias_method :attr_has_exited, :has_exited
    undef_method :has_exited
    alias_method :attr_has_exited=, :has_exited=
    undef_method :has_exited=
    
    attr_accessor :stdin_stream
    alias_method :attr_stdin_stream, :stdin_stream
    undef_method :stdin_stream
    alias_method :attr_stdin_stream=, :stdin_stream=
    undef_method :stdin_stream=
    
    attr_accessor :stdout_stream
    alias_method :attr_stdout_stream, :stdout_stream
    undef_method :stdout_stream
    alias_method :attr_stdout_stream=, :stdout_stream=
    undef_method :stdout_stream=
    
    attr_accessor :stderr_stream
    alias_method :attr_stderr_stream, :stderr_stream
    undef_method :stderr_stream
    alias_method :attr_stderr_stream=, :stderr_stream=
    undef_method :stderr_stream=
    
    JNI.native_method :Java_java_lang_UNIXProcess_waitForProcessExit, [:pointer, :long, :int32], :int32
    typesig { [::Java::Int] }
    # this is for the reaping thread
    def wait_for_process_exit(pid)
      JNI.__send__(:Java_java_lang_UNIXProcess_waitForProcessExit, JNI.env, self.jni_id, pid.to_int)
    end
    
    JNI.native_method :Java_java_lang_UNIXProcess_forkAndExec, [:pointer, :long, :long, :long, :int32, :long, :int32, :long, :int8, :long, :long, :long], :int32
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Boolean, FileDescriptor, FileDescriptor, FileDescriptor] }
    def fork_and_exec(prog, arg_block, argc, env_block, envc, dir, redirect_error_stream, stdin_fd, stdout_fd, stderr_fd)
      JNI.__send__(:Java_java_lang_UNIXProcess_forkAndExec, JNI.env, self.jni_id, prog.jni_id, arg_block.jni_id, argc.to_int, env_block.jni_id, envc.to_int, dir.jni_id, redirect_error_stream ? 1 : 0, stdin_fd.jni_id, stdout_fd.jni_id, stderr_fd.jni_id)
    end
    
    class_module.module_eval {
      # In the process constructor we wait on this gate until the process
      # has been created. Then we return from the constructor.
      # fork() is called by the same thread which later waits for the process
      # to terminate
      const_set_lazy(:Gate) { Class.new do
        include_class_members UNIXProcess
        
        attr_accessor :exited
        alias_method :attr_exited, :exited
        undef_method :exited
        alias_method :attr_exited=, :exited=
        undef_method :exited=
        
        attr_accessor :saved_exception
        alias_method :attr_saved_exception, :saved_exception
        undef_method :saved_exception
        alias_method :attr_saved_exception=, :saved_exception=
        undef_method :saved_exception=
        
        typesig { [] }
        def exit
          synchronized(self) do
            # Opens the gate
            @exited = true
            self.notify
          end
        end
        
        typesig { [] }
        def wait_for_exit
          synchronized(self) do
            # wait until the gate is open
            interrupted = false
            while (!@exited)
              begin
                self.wait
              rescue InterruptedException => e
                interrupted = true
              end
            end
            if (interrupted)
              JavaThread.current_thread.interrupt
            end
          end
        end
        
        typesig { [IOException] }
        def set_exception(e)
          @saved_exception = e
        end
        
        typesig { [] }
        def get_exception
          return @saved_exception
        end
        
        typesig { [] }
        def initialize
          @exited = false
          @saved_exception = nil
        end
        
        private
        alias_method :initialize__gate, :initialize
      end }
    }
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Byte), ::Java::Boolean] }
    def initialize(prog, arg_block, argc, env_block, envc, dir, redirect_error_stream)
      @stdin_fd = nil
      @stdout_fd = nil
      @stderr_fd = nil
      @pid = 0
      @exitcode = 0
      @has_exited = false
      @stdin_stream = nil
      @stdout_stream = nil
      @stderr_stream = nil
      super()
      @stdin_fd = FileDescriptor.new
      @stdout_fd = FileDescriptor.new
      @stderr_fd = FileDescriptor.new
      gate = Gate.new
      Java::Security::AccessController.do_privileged(# For each subprocess forked a corresponding reaper thread
      # is started.  That thread is the only thread which waits
      # for the subprocess to terminate and it doesn't hold any
      # locks while doing so.  This design allows waitFor() and
      # exitStatus() to be safely executed in parallel (and they
      # need no native code).
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members UNIXProcess
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          privileged_action_class = self.class
          t = Class.new(JavaThread.class == Class ? JavaThread : Object) do
            extend LocalClass
            include_class_members privileged_action_class
            include JavaThread if JavaThread.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                self.attr_pid = fork_and_exec(prog, arg_block, argc, env_block, envc, dir, redirect_error_stream, self.attr_stdin_fd, self.attr_stdout_fd, self.attr_stderr_fd)
              rescue IOException => e
                gate.set_exception(e)
                # remember to rethrow later
                gate.exit
                return
              end
              thread_class = self.class
              Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
                extend LocalClass
                include_class_members thread_class
                include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  self.attr_stdin_stream = BufferedOutputStream.new(FileOutputStream.new(self.attr_stdin_fd))
                  self.attr_stdout_stream = BufferedInputStream.new(FileInputStream.new(self.attr_stdout_fd))
                  self.attr_stderr_stream = FileInputStream.new(self.attr_stderr_fd)
                  return nil
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              gate.exit
              # exit from constructor
              res = wait_for_process_exit(self.attr_pid)
              synchronized((@local_class_parent.local_class_parent)) do
                self.attr_has_exited = true
                self.attr_exitcode = res
                @local_class_parent.local_class_parent.notify_all
              end
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self, "process reaper")
          t.set_daemon(true)
          t.start
          return nil
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      gate.wait_for_exit
      e = gate.get_exception
      if (!(e).nil?)
        raise IOException.new(e.to_s)
      end
    end
    
    typesig { [] }
    def get_output_stream
      return @stdin_stream
    end
    
    typesig { [] }
    def get_input_stream
      return @stdout_stream
    end
    
    typesig { [] }
    def get_error_stream
      return @stderr_stream
    end
    
    typesig { [] }
    def wait_for
      synchronized(self) do
        while (!@has_exited)
          wait
        end
        return @exitcode
      end
    end
    
    typesig { [] }
    def exit_value
      synchronized(self) do
        if (!@has_exited)
          raise IllegalThreadStateException.new("process hasn't exited")
        end
        return @exitcode
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_UNIXProcess_destroyProcess, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      def destroy_process(pid)
        JNI.__send__(:Java_java_lang_UNIXProcess_destroyProcess, JNI.env, self.jni_id, pid.to_int)
      end
    }
    
    typesig { [] }
    def destroy
      # There is a risk that pid will be recycled, causing us to
      # kill the wrong process!  So we only terminate processes
      # that appear to still be running.  Even with this check,
      # there is an unavoidable race condition here, but the window
      # is very small, and OSes try hard to not recycle pids too
      # soon, so this is quite safe.
      synchronized((self)) do
        if (!@has_exited)
          destroy_process(@pid)
        end
      end
      begin
        @stdin_stream.close
        @stdout_stream.close
        @stderr_stream.close
      rescue IOException => e
        # ignore
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_UNIXProcess_initIDs, [:pointer, :long], :void
      typesig { [] }
      # This routine initializes JNI field offsets for the class
      def init_ids
        JNI.__send__(:Java_java_lang_UNIXProcess_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    private
    alias_method :initialize__unixprocess, :initialize
  end
  
end

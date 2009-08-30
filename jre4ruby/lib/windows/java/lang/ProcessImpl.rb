require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ProcessImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # This class is for the exclusive use of ProcessBuilder.start() to
  # create new processes.
  # 
  # @author Martin Buchholz
  # @since   1.5
  class ProcessImpl < ProcessImplImports.const_get :Process
    include_class_members ProcessImplImports
    
    class_module.module_eval {
      typesig { [Array.typed(String), Java::Util::Map, String, ::Java::Boolean] }
      # System-dependent portion of ProcessBuilder.start()
      def start(cmdarray, environment, dir, redirect_error_stream)
        envblock = ProcessEnvironment.to_environment_block(environment)
        return ProcessImpl.new(cmdarray, envblock, dir, redirect_error_stream)
      end
    }
    
    attr_accessor :handle
    alias_method :attr_handle, :handle
    undef_method :handle
    alias_method :attr_handle=, :handle=
    undef_method :handle=
    
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
    
    typesig { [Array.typed(String), String, String, ::Java::Boolean] }
    def initialize(cmd, envblock, path, redirect_error_stream)
      @handle = 0
      @stdin_fd = nil
      @stdout_fd = nil
      @stderr_fd = nil
      @stdin_stream = nil
      @stdout_stream = nil
      @stderr_stream = nil
      super()
      @handle = 0
      # Win32 CreateProcess requires cmd[0] to be normalized
      cmd[0] = JavaFile.new(cmd[0]).get_path
      cmdbuf = StringBuilder.new(80)
      i = 0
      while i < cmd.attr_length
        if (i > 0)
          cmdbuf.append(Character.new(?\s.ord))
        end
        s = cmd[i]
        if (s.index_of(Character.new(?\s.ord)) >= 0 || s.index_of(Character.new(?\t.ord)) >= 0)
          if (!(s.char_at(0)).equal?(Character.new(?".ord)))
            cmdbuf.append(Character.new(?".ord))
            cmdbuf.append(s)
            if (s.ends_with("\\"))
              cmdbuf.append("\\")
            end
            cmdbuf.append(Character.new(?".ord))
          else
            if (s.ends_with("\""))
              # The argument has already been quoted.
              cmdbuf.append(s)
            else
              # Unmatched quote for the argument.
              raise IllegalArgumentException.new
            end
          end
        else
          cmdbuf.append(s)
        end
        i += 1
      end
      cmdstr = cmdbuf.to_s
      @stdin_fd = FileDescriptor.new
      @stdout_fd = FileDescriptor.new
      @stderr_fd = FileDescriptor.new
      @handle = create(cmdstr, envblock, path, redirect_error_stream, @stdin_fd, @stdout_fd, @stderr_fd)
      Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ProcessImpl
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_stdin_stream = self.class::BufferedOutputStream.new(self.class::FileOutputStream.new(self.attr_stdin_fd))
          self.attr_stdout_stream = self.class::BufferedInputStream.new(self.class::FileInputStream.new(self.attr_stdout_fd))
          self.attr_stderr_stream = self.class::FileInputStream.new(self.attr_stderr_fd)
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
    def finalize
      close_handle(@handle)
    end
    
    class_module.module_eval {
      const_set_lazy(:STILL_ACTIVE) { get_still_active }
      const_attr_reader  :STILL_ACTIVE
      
      JNI.native_method :Java_java_lang_ProcessImpl_getStillActive, [:pointer, :long], :int32
      typesig { [] }
      def get_still_active
        JNI.__send__(:Java_java_lang_ProcessImpl_getStillActive, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def exit_value
      exit_code = get_exit_code_process(@handle)
      if ((exit_code).equal?(STILL_ACTIVE))
        raise IllegalThreadStateException.new("process has not exited")
      end
      return exit_code
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_ProcessImpl_getExitCodeProcess, [:pointer, :long, :int64], :int32
      typesig { [::Java::Long] }
      def get_exit_code_process(handle)
        JNI.__send__(:Java_java_lang_ProcessImpl_getExitCodeProcess, JNI.env, self.jni_id, handle.to_int)
      end
    }
    
    typesig { [] }
    def wait_for
      wait_for_interruptibly(@handle)
      if (JavaThread.interrupted)
        raise InterruptedException.new
      end
      return exit_value
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_ProcessImpl_waitForInterruptibly, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def wait_for_interruptibly(handle)
        JNI.__send__(:Java_java_lang_ProcessImpl_waitForInterruptibly, JNI.env, self.jni_id, handle.to_int)
      end
    }
    
    typesig { [] }
    def destroy
      terminate_process(@handle)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_ProcessImpl_terminateProcess, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def terminate_process(handle)
        JNI.__send__(:Java_java_lang_ProcessImpl_terminateProcess, JNI.env, self.jni_id, handle.to_int)
      end
      
      JNI.native_method :Java_java_lang_ProcessImpl_create, [:pointer, :long, :long, :long, :long, :int8, :long, :long, :long], :int64
      typesig { [String, String, String, ::Java::Boolean, FileDescriptor, FileDescriptor, FileDescriptor] }
      def create(cmdstr, envblock, dir, redirect_error_stream, in_fd, out_fd, err_fd)
        JNI.__send__(:Java_java_lang_ProcessImpl_create, JNI.env, self.jni_id, cmdstr.jni_id, envblock.jni_id, dir.jni_id, redirect_error_stream ? 1 : 0, in_fd.jni_id, out_fd.jni_id, err_fd.jni_id)
      end
      
      JNI.native_method :Java_java_lang_ProcessImpl_closeHandle, [:pointer, :long, :int64], :int8
      typesig { [::Java::Long] }
      def close_handle(handle)
        JNI.__send__(:Java_java_lang_ProcessImpl_closeHandle, JNI.env, self.jni_id, handle.to_int) != 0
      end
    }
    
    private
    alias_method :initialize__process_impl, :initialize
  end
  
end

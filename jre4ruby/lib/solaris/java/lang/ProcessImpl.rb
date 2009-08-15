require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ProcessImplImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang, :Process
    }
  end
  
  # This class is for the exclusive use of ProcessBuilder.start() to
  # create new processes.
  # 
  # @author Martin Buchholz
  # @since   1.5
  class ProcessImpl 
    include_class_members ProcessImplImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Not instantiable
      def to_cstring(s)
        if ((s).nil?)
          return nil
        end
        bytes = s.get_bytes
        result = Array.typed(::Java::Byte).new(bytes.attr_length + 1) { 0 }
        System.arraycopy(bytes, 0, result, 0, bytes.attr_length)
        result[result.attr_length - 1] = 0
        return result
      end
      
      typesig { [Array.typed(String), Java::Util::Map, String, ::Java::Boolean] }
      # Only for use by ProcessBuilder.start()
      def start(cmdarray, environment, dir, redirect_error_stream)
        raise AssertError if not (!(cmdarray).nil? && cmdarray.attr_length > 0)
        # Convert arguments to a contiguous block; it's easier to do
        # memory management in Java than in C.
        args = Array.typed(Array.typed(::Java::Byte)).new(cmdarray.attr_length - 1) { nil }
        size = args.attr_length # For added NUL bytes
        i = 0
        while i < args.attr_length
          args[i] = cmdarray[i + 1].get_bytes
          size += args[i].attr_length
          i += 1
        end
        arg_block = Array.typed(::Java::Byte).new(size) { 0 }
        i_ = 0
        args.each do |arg|
          System.arraycopy(arg, 0, arg_block, i_, arg.attr_length)
          i_ += arg.attr_length + 1
        end
        envc = Array.typed(::Java::Int).new(1) { 0 }
        env_block = ProcessEnvironment.to_environment_block(environment, envc)
        return UNIXProcess.new(to_cstring(cmdarray[0]), arg_block, args.attr_length, env_block, envc[0], to_cstring(dir), redirect_error_stream)
      end
    }
    
    private
    alias_method :initialize__process_impl, :initialize
  end
  
end

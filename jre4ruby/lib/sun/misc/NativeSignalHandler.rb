require "rjava"

# Copyright 1998 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module NativeSignalHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # A package-private class implementing a signal handler in native code.
  class NativeSignalHandler 
    include_class_members NativeSignalHandlerImports
    include SignalHandler
    
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    typesig { [] }
    def get_handler
      return @handler
    end
    
    typesig { [::Java::Long] }
    def initialize(handler)
      @handler = 0
      @handler = handler
    end
    
    typesig { [Signal] }
    def handle(sig)
      handle0(sig.get_number, @handler)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_misc_NativeSignalHandler_handle0, [:pointer, :long, :int32, :int64], :void
      typesig { [::Java::Int, ::Java::Long] }
      def handle0(number, handler)
        JNI.__send__(:Java_sun_misc_NativeSignalHandler_handle0, JNI.env, self.jni_id, number.to_int, handler.to_int)
      end
    }
    
    private
    alias_method :initialize__native_signal_handler, :initialize
  end
  
end

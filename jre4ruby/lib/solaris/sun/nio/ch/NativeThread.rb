require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module NativeThreadImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
    }
  end
  
  # Signalling operations on native threads
  # 
  # On some operating systems (e.g., Linux), closing a channel while another
  # thread is blocked in an I/O operation upon that channel does not cause that
  # thread to be released.  This class provides access to the native threads
  # upon which Java threads are built, and defines a simple signal mechanism
  # that can be used to release a native thread from a blocking I/O operation.
  # On systems that do not require this type of signalling, the current() method
  # always returns -1 and the signal(long) method has no effect.
  class NativeThread 
    include_class_members NativeThreadImports
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_nio_ch_NativeThread_current, [:pointer, :long], :int64
      typesig { [] }
      # Returns an opaque token representing the native thread underlying the
      # invoking Java thread.  On systems that do not require signalling, this
      # method always returns -1.
      def current
        JNI.call_native_method(:Java_sun_nio_ch_NativeThread_current, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_NativeThread_signal, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      # Signals the given native thread so as to release it from a blocking I/O
      # operation.  On systems that do not require signalling, this method has
      # no effect.
      def signal(nt)
        JNI.call_native_method(:Java_sun_nio_ch_NativeThread_signal, JNI.env, self.jni_id, nt.to_int)
      end
      
      JNI.load_native_method :Java_sun_nio_ch_NativeThread_init, [:pointer, :long], :void
      typesig { [] }
      def init
        JNI.call_native_method(:Java_sun_nio_ch_NativeThread_init, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Util.load
        init
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__native_thread, :initialize
  end
  
end

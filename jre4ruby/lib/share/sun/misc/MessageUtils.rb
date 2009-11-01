require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MessageUtilsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # MessageUtils: miscellaneous utilities for handling error and status
  # properties and messages.
  # 
  # @author Herb Jellinek
  class MessageUtils 
    include_class_members MessageUtilsImports
    
    typesig { [] }
    # can instantiate it for to allow less verbose use - via instance
    # instead of classname
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      def subst(patt, arg)
        args = Array.typed(String).new([arg])
        return subst(patt, args)
      end
      
      typesig { [String, String, String] }
      def subst(patt, arg1, arg2)
        args = Array.typed(String).new([arg1, arg2])
        return subst(patt, args)
      end
      
      typesig { [String, String, String, String] }
      def subst(patt, arg1, arg2, arg3)
        args = Array.typed(String).new([arg1, arg2, arg3])
        return subst(patt, args)
      end
      
      typesig { [String, Array.typed(String)] }
      def subst(patt, args)
        result = StringBuffer.new
        len = patt.length
        i = 0
        while i >= 0 && i < len
          ch = patt.char_at(i)
          if ((ch).equal?(Character.new(?%.ord)))
            if (!(i).equal?(len))
              index = Character.digit(patt.char_at(i + 1), 10)
              if ((index).equal?(-1))
                result.append(patt.char_at(i + 1))
                i += 1
              else
                if (index < args.attr_length)
                  result.append(args[index])
                  i += 1
                end
              end
            end
          else
            result.append(ch)
          end
          i += 1
        end
        return result.to_s
      end
      
      typesig { [String, String] }
      def subst_prop(prop_name, arg)
        return subst(System.get_property(prop_name), arg)
      end
      
      typesig { [String, String, String] }
      def subst_prop(prop_name, arg1, arg2)
        return subst(System.get_property(prop_name), arg1, arg2)
      end
      
      typesig { [String, String, String, String] }
      def subst_prop(prop_name, arg1, arg2, arg3)
        return subst(System.get_property(prop_name), arg1, arg2, arg3)
      end
      
      JNI.load_native_method :Java_sun_misc_MessageUtils_toStderr, [:pointer, :long, :long], :void
      typesig { [String] }
      # Print a message directly to stderr, bypassing all the
      # character conversion methods.
      # @param msg   message to print
      def to_stderr(msg)
        JNI.call_native_method(:Java_sun_misc_MessageUtils_toStderr, JNI.env, self.jni_id, msg.jni_id)
      end
      
      JNI.load_native_method :Java_sun_misc_MessageUtils_toStdout, [:pointer, :long, :long], :void
      typesig { [String] }
      # Print a message directly to stdout, bypassing all the
      # character conversion methods.
      # @param msg   message to print
      def to_stdout(msg)
        JNI.call_native_method(:Java_sun_misc_MessageUtils_toStdout, JNI.env, self.jni_id, msg.jni_id)
      end
      
      typesig { [String] }
      # Short forms of the above
      def err(s)
        to_stderr(s + "\n")
      end
      
      typesig { [String] }
      def out(s)
        to_stdout(s + "\n")
      end
      
      typesig { [] }
      # Print a stack trace to stderr
      def where
        t = JavaThrowable.new
        es = t.get_stack_trace
        i = 1
        while i < es.attr_length
          to_stderr("\t" + RJava.cast_to_string(es[i].to_s) + "\n")
          i += 1
        end
      end
    }
    
    private
    alias_method :initialize__message_utils, :initialize
  end
  
end

require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module DebugImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # This class has be shamefully lifted from sun.security.util.Debug
  # 
  # @author Gary Ellison
  class Debug 
    include_class_members DebugImports
    
    attr_accessor :prefix
    alias_method :attr_prefix, :prefix
    undef_method :prefix
    alias_method :attr_prefix=, :prefix=
    undef_method :prefix=
    
    class_module.module_eval {
      
      def args
        defined?(@@args) ? @@args : @@args= nil
      end
      alias_method :attr_args, :args
      
      def args=(value)
        @@args = value
      end
      alias_method :attr_args=, :args=
      
      when_class_loaded do
        self.attr_args = RJava.cast_to_string(Java::Security::AccessController.do_privileged(GetPropertyAction.new("javax.net.debug", "")))
        self.attr_args = RJava.cast_to_string(self.attr_args.to_lower_case)
        if ((self.attr_args == "help"))
          _help
        end
      end
      
      typesig { [] }
      def _help
        System.err.println
        System.err.println("all            turn on all debugging")
        System.err.println("ssl            turn on ssl debugging")
        System.err.println
        System.err.println("The following can be used with ssl:")
        System.err.println("\trecord       enable per-record tracing")
        System.err.println("\thandshake    print each handshake message")
        System.err.println("\tkeygen       print key generation data")
        System.err.println("\tsession      print session activity")
        System.err.println("\tdefaultctx   print default SSL initialization")
        System.err.println("\tsslctx       print SSLContext tracing")
        System.err.println("\tsessioncache print session cache tracing")
        System.err.println("\tkeymanager   print key manager tracing")
        System.err.println("\ttrustmanager print trust manager tracing")
        System.err.println("\tpluggability print pluggability tracing")
        System.err.println
        System.err.println("\thandshake debugging can be widened with:")
        System.err.println("\tdata         hex dump of each handshake message")
        System.err.println("\tverbose      verbose handshake message printing")
        System.err.println
        System.err.println("\trecord debugging can be widened with:")
        System.err.println("\tplaintext    hex dump of record plaintext")
        System.err.println("\tpacket       print raw SSL/TLS packets")
        System.err.println
        System.exit(0)
      end
      
      typesig { [String] }
      # Get a Debug object corresponding to whether or not the given
      # option is set. Set the prefix to be the same as option.
      def get_instance(option)
        return get_instance(option, option)
      end
      
      typesig { [String, String] }
      # Get a Debug object corresponding to whether or not the given
      # option is set. Set the prefix to be prefix.
      def get_instance(option, prefix)
        if (is_on(option))
          d = Debug.new
          d.attr_prefix = prefix
          return d
        else
          return nil
        end
      end
      
      typesig { [String] }
      # True if the property "javax.net.debug" contains the
      # string "option".
      def is_on(option)
        if ((self.attr_args).nil?)
          return false
        else
          n = 0
          option = RJava.cast_to_string(option.to_lower_case)
          if (!(self.attr_args.index_of("all")).equal?(-1))
            return true
          else
            if (!((n = self.attr_args.index_of("ssl"))).equal?(-1))
              if ((self.attr_args.index_of("sslctx", n)).equal?(-1))
                # don't enable data and plaintext options by default
                if (!((option == "data") || (option == "packet") || (option == "plaintext")))
                  return true
                end
              end
            end
          end
          return (!(self.attr_args.index_of(option)).equal?(-1))
        end
      end
    }
    
    typesig { [String] }
    # print a message to stderr that is prefixed with the prefix
    # created from the call to getInstance.
    def println(message)
      System.err.println(@prefix + ": " + message)
    end
    
    typesig { [] }
    # print a blank line to stderr that is prefixed with the prefix.
    def println
      System.err.println(@prefix + ":")
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # print a message to stderr that is prefixed with the prefix.
      def println(prefix, message)
        System.err.println(prefix + ": " + message)
      end
      
      typesig { [PrintStream, String, Array.typed(::Java::Byte)] }
      def println(s, name, data)
        s.print(name + ":  { ")
        if ((data).nil?)
          s.print("null")
        else
          i = 0
          while i < data.attr_length
            if (!(i).equal?(0))
              s.print(", ")
            end
            s.print(data[i] & 0xff)
            i += 1
          end
        end
        s.println(" }")
      end
      
      typesig { [String, ::Java::Boolean] }
      # Return the value of the boolean System property propName.
      # 
      # Note use of doPrivileged(). Do make accessible to applications.
      def get_boolean_property(prop_name, default_value)
        # if set, require value of either true or false
        b = AccessController.do_privileged(GetPropertyAction.new(prop_name))
        if ((b).nil?)
          return default_value
        else
          if (b.equals_ignore_case("false"))
            return false
          else
            if (b.equals_ignore_case("true"))
              return true
            else
              raise RuntimeException.new("Value of " + prop_name + " must either be 'true' or 'false'")
            end
          end
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def to_s(b)
        return Sun::Security::Util::Debug.to_s(b)
      end
    }
    
    typesig { [] }
    def initialize
      @prefix = nil
    end
    
    private
    alias_method :initialize__debug, :initialize
  end
  
end

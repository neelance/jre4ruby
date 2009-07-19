require "rjava"

# Copyright 1998-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module DebugImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util::Regex, :Pattern
      include_const ::Java::Util::Regex, :Matcher
    }
  end
  
  # A utility class for debuging.
  # 
  # @author Roland Schemers
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
        self.attr_args = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.debug"))).to_s
        args2 = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.auth.debug"))
        if ((self.attr_args).nil?)
          self.attr_args = args2
        else
          if (!(args2).nil?)
            self.attr_args = self.attr_args + "," + args2
          end
        end
        if (!(self.attr_args).nil?)
          self.attr_args = (marshal(self.attr_args)).to_s
          if ((self.attr_args == "help"))
            _help
          end
        end
      end
      
      typesig { [] }
      def _help
        System.err.println
        System.err.println("all           turn on all debugging")
        System.err.println("access        print all checkPermission results")
        System.err.println("combiner      SubjectDomainCombiner debugging")
        System.err.println("gssloginconfig")
        System.err.println("configfile    JAAS ConfigFile loading")
        System.err.println("configparser  JAAS ConfigFile parsing")
        System.err.println("              GSS LoginConfigImpl debugging")
        System.err.println("jar           jar verification")
        System.err.println("logincontext  login context results")
        System.err.println("policy        loading and granting")
        System.err.println("provider      security provider debugging")
        System.err.println("scl           permissions SecureClassLoader assigns")
        System.err.println
        System.err.println("The following can be used with access:")
        System.err.println
        System.err.println("stack         include stack trace")
        System.err.println("domain        dump all domains in context")
        System.err.println("failure       before throwing exception, dump stack")
        System.err.println("              and domain that didn't have permission")
        System.err.println
        System.err.println("The following can be used with stack and domain:")
        System.err.println
        System.err.println("permission=<classname>")
        System.err.println("              only dump output if specified permission")
        System.err.println("              is being checked")
        System.err.println("codebase=<URL>")
        System.err.println("              only dump output if specified codebase")
        System.err.println("              is being checked")
        System.err.println
        System.err.println("Note: Separate multiple options with a comma")
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
      # True if the system property "security.debug" contains the
      # string "option".
      def is_on(option)
        if ((self.attr_args).nil?)
          return false
        else
          if (!(self.attr_args.index_of("all")).equal?(-1))
            return true
          else
            return (!(self.attr_args.index_of(option)).equal?(-1))
          end
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
      
      typesig { [BigInteger] }
      # return a hexadecimal printed representation of the specified
      # BigInteger object. the value is formatted to fit on lines of
      # at least 75 characters, with embedded newlines. Words are
      # separated for readability, with eight words (32 bytes) per line.
      def to_hex_string(b)
        hex_value = b.to_s(16)
        buf = StringBuffer.new(hex_value.length * 2)
        if (hex_value.starts_with("-"))
          buf.append("   -")
          hex_value = (hex_value.substring(1)).to_s
        else
          buf.append("    ") # four spaces
        end
        if (!((hex_value.length % 2)).equal?(0))
          # add back the leading 0
          hex_value = "0" + hex_value
        end
        i = 0
        while (i < hex_value.length)
          # one byte at a time
          buf.append(hex_value.substring(i, i + 2))
          i += 2
          if (!(i).equal?(hex_value.length))
            if (((i % 64)).equal?(0))
              buf.append("\n    ") # line after eight words
            else
              if ((i % 8).equal?(0))
                buf.append(" ") # space between words
              end
            end
          end
        end
        return buf.to_s
      end
      
      typesig { [String] }
      # change a string into lower case except permission classes and URLs.
      def marshal(args)
        if (!(args).nil?)
          target = StringBuffer.new
          source = StringBuffer.new(args)
          # obtain the "permission=<classname>" options
          # the syntax of classname: IDENTIFIER.IDENTIFIER
          # the regular express to match a class name:
          # "[a-zA-Z_$][a-zA-Z0-9_$]*([.][a-zA-Z_$][a-zA-Z0-9_$]*)*"
          key_reg = "[Pp][Ee][Rr][Mm][Ii][Ss][Ss][Ii][Oo][Nn]="
          key_str = "permission="
          reg = key_reg + "[a-zA-Z_$][a-zA-Z0-9_$]*([.][a-zA-Z_$][a-zA-Z0-9_$]*)*"
          pattern = Pattern.compile(reg)
          matcher_ = pattern.matcher(source)
          left = StringBuffer.new
          while (matcher_.find)
            matched = matcher_.group
            target.append(matched.replace_first(key_reg, key_str))
            target.append("  ")
            # delete the matched sequence
            matcher_.append_replacement(left, "")
          end
          matcher_.append_tail(left)
          source = left
          # obtain the "codebase=<URL>" options
          # the syntax of URL is too flexible, and here assumes that the
          # URL contains no space, comma(','), and semicolon(';'). That
          # also means those characters also could be used as separator
          # after codebase option.
          # However, the assumption is incorrect in some special situation
          # when the URL contains comma or semicolon
          key_reg = "[Cc][Oo][Dd][Ee][Bb][Aa][Ss][Ee]="
          key_str = "codebase="
          reg = key_reg + "[^, ;]*"
          pattern = Pattern.compile(reg)
          matcher_ = pattern.matcher(source)
          left = StringBuffer.new
          while (matcher_.find)
            matched = matcher_.group
            target.append(matched.replace_first(key_reg, key_str))
            target.append("  ")
            # delete the matched sequence
            matcher_.append_replacement(left, "")
          end
          matcher_.append_tail(left)
          source = left
          # convert the rest to lower-case characters
          target.append(source.to_s.to_lower_case)
          return target.to_s
        end
        return nil
      end
      
      const_set_lazy(:HexDigits) { "0123456789abcdef".to_char_array }
      const_attr_reader  :HexDigits
      
      typesig { [Array.typed(::Java::Byte)] }
      def to_s(b)
        if ((b).nil?)
          return "(null)"
        end
        sb = StringBuilder.new(b.attr_length * 3)
        i = 0
        while i < b.attr_length
          k = b[i] & 0xff
          if (!(i).equal?(0))
            sb.append(Character.new(?:.ord))
          end
          sb.append(HexDigits[k >> 4])
          sb.append(HexDigits[k & 0xf])
          ((i += 1) - 1)
        end
        return sb.to_s
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

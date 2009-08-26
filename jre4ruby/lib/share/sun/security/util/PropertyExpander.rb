require "rjava"

# Copyright 1998-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PropertyExpanderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URISyntaxException
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # A utility class to expand properties embedded in a string.
  # Strings of the form ${some.property.name} are expanded to
  # be the value of the property. Also, the special ${/} property
  # is expanded to be the same as file.separator. If a property
  # is not set, a GeneralSecurityException will be thrown.
  # 
  # @author Roland Schemers
  class PropertyExpander 
    include_class_members PropertyExpanderImports
    
    class_module.module_eval {
      const_set_lazy(:ExpandException) { Class.new(GeneralSecurityException) do
        include_class_members PropertyExpander
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -7941948581406161702 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [String] }
        def initialize(msg)
          super(msg)
        end
        
        private
        alias_method :initialize__expand_exception, :initialize
      end }
      
      typesig { [String] }
      def expand(value)
        return expand(value, false)
      end
      
      typesig { [String, ::Java::Boolean] }
      def expand(value, encode_url)
        if ((value).nil?)
          return nil
        end
        p = value.index_of("${", 0)
        # no special characters
        if ((p).equal?(-1))
          return value
        end
        sb = StringBuffer.new(value.length)
        max = value.length
        i = 0 # index of last character we copied
        while (p < max)
          if (p > i)
            # copy in anything before the special stuff
            sb.append(value.substring(i, p))
            i = p
          end
          pe = p + 2
          # do not expand ${{ ... }}
          if (pe < max && (value.char_at(pe)).equal?(Character.new(?{.ord)))
            pe = value.index_of("}}", pe)
            if ((pe).equal?(-1) || (pe + 2).equal?(max))
              # append remaining chars
              sb.append(value.substring(p))
              break
            else
              # append as normal text
              pe += 1
              sb.append(value.substring(p, pe + 1))
            end
          else
            while ((pe < max) && (!(value.char_at(pe)).equal?(Character.new(?}.ord))))
              pe += 1
            end
            if ((pe).equal?(max))
              # no matching '}' found, just add in as normal text
              sb.append(value.substring(p, pe))
              break
            end
            prop = value.substring(p + 2, pe)
            if ((prop == "/"))
              sb.append(Java::Io::JavaFile.attr_separator_char)
            else
              val = System.get_property(prop)
              if (!(val).nil?)
                if (encode_url)
                  # encode 'val' unless it's an absolute URI
                  # at the beginning of the string buffer
                  begin
                    if (sb.length > 0 || !(URI.new(val)).is_absolute)
                      val = RJava.cast_to_string(Sun::Net::Www::ParseUtil.encode_path(val))
                    end
                  rescue URISyntaxException => use
                    val = RJava.cast_to_string(Sun::Net::Www::ParseUtil.encode_path(val))
                  end
                end
                sb.append(val)
              else
                raise ExpandException.new("unable to expand property " + prop)
              end
            end
          end
          i = pe + 1
          p = value.index_of("${", i)
          if ((p).equal?(-1))
            # no more to expand. copy in any extra
            if (i < max)
              sb.append(value.substring(i, max))
            end
            # break out of loop
            break
          end
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__property_expander, :initialize
  end
  
end

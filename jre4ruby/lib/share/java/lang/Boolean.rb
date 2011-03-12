require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BooleanImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The Boolean class wraps a value of the primitive type
  # {@code boolean} in an object. An object of type
  # {@code Boolean} contains a single field whose type is
  # {@code boolean}.
  # <p>
  # In addition, this class provides many methods for
  # converting a {@code boolean} to a {@code String} and a
  # {@code String} to a {@code boolean}, as well as other
  # constants and methods useful when dealing with a
  # {@code boolean}.
  # 
  # @author  Arthur van Hoff
  # @since   JDK1.0
  class Boolean 
    include_class_members BooleanImports
    include Java::Io::Serializable
    include JavaComparable
    
    class_module.module_eval {
      # The {@code Boolean} object corresponding to the primitive
      # value {@code true}.
      const_set_lazy(:TRUE) { Boolean.new(true) }
      const_attr_reader  :TRUE
      
      # The {@code Boolean} object corresponding to the primitive
      # value {@code false}.
      const_set_lazy(:FALSE) { Boolean.new(false) }
      const_attr_reader  :FALSE
      
      # The Class object representing the primitive type boolean.
      # 
      # @since   JDK1.1
      const_set_lazy(:TYPE) { Class.get_primitive_class("boolean") }
      const_attr_reader  :TYPE
    }
    
    # The value of the Boolean.
    # 
    # @serial
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -3665804199014368530 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Boolean] }
    # Allocates a {@code Boolean} object representing the
    # {@code value} argument.
    # 
    # <p><b>Note: It is rarely appropriate to use this constructor.
    # Unless a <i>new</i> instance is required, the static factory
    # {@link #valueOf(boolean)} is generally a better choice. It is
    # likely to yield significantly better space and time performance.</b>
    # 
    # @param   value   the value of the {@code Boolean}.
    def initialize(value)
      @value = false
      @value = value
    end
    
    typesig { [String] }
    # Allocates a {@code Boolean} object representing the value
    # {@code true} if the string argument is not {@code null}
    # and is equal, ignoring case, to the string {@code "true"}.
    # Otherwise, allocate a {@code Boolean} object representing the
    # value {@code false}. Examples:<p>
    # {@code new Boolean("True")} produces a {@code Boolean} object
    # that represents {@code true}.<br>
    # {@code new Boolean("yes")} produces a {@code Boolean} object
    # that represents {@code false}.
    # 
    # @param   s   the string to be converted to a {@code Boolean}.
    def initialize(s)
      initialize__boolean(to_boolean(s))
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Parses the string argument as a boolean.  The {@code boolean}
      # returned represents the value {@code true} if the string argument
      # is not {@code null} and is equal, ignoring case, to the string
      # {@code "true"}. <p>
      # Example: {@code Boolean.parseBoolean("True")} returns {@code true}.<br>
      # Example: {@code Boolean.parseBoolean("yes")} returns {@code false}.
      # 
      # @param      s   the {@code String} containing the boolean
      #                 representation to be parsed
      # @return     the boolean represented by the string argument
      # @since 1.5
      def parse_boolean(s)
        return to_boolean(s)
      end
    }
    
    typesig { [] }
    # Returns the value of this {@code Boolean} object as a boolean
    # primitive.
    # 
    # @return  the primitive {@code boolean} value of this object.
    def boolean_value
      return @value
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Returns a {@code Boolean} instance representing the specified
      # {@code boolean} value.  If the specified {@code boolean} value
      # is {@code true}, this method returns {@code Boolean.TRUE};
      # if it is {@code false}, this method returns {@code Boolean.FALSE}.
      # If a new {@code Boolean} instance is not required, this method
      # should generally be used in preference to the constructor
      # {@link #Boolean(boolean)}, as this method is likely to yield
      # significantly better space and time performance.
      # 
      # @param  b a boolean value.
      # @return a {@code Boolean} instance representing {@code b}.
      # @since  1.4
      def value_of(b)
        return (b ? TRUE : FALSE)
      end
      
      typesig { [String] }
      # Returns a {@code Boolean} with a value represented by the
      # specified string.  The {@code Boolean} returned represents a
      # true value if the string argument is not {@code null}
      # and is equal, ignoring case, to the string {@code "true"}.
      # 
      # @param   s   a string.
      # @return  the {@code Boolean} value represented by the string.
      def value_of(s)
        return to_boolean(s) ? TRUE : FALSE
      end
      
      typesig { [::Java::Boolean] }
      # Returns a {@code String} object representing the specified
      # boolean.  If the specified boolean is {@code true}, then
      # the string {@code "true"} will be returned, otherwise the
      # string {@code "false"} will be returned.
      # 
      # @param b the boolean to be converted
      # @return the string representation of the specified {@code boolean}
      # @since 1.4
      def to_s(b)
        return b ? "true" : "false"
      end
    }
    
    typesig { [] }
    # Returns a {@code String} object representing this Boolean's
    # value.  If this object represents the value {@code true},
    # a string equal to {@code "true"} is returned. Otherwise, a
    # string equal to {@code "false"} is returned.
    # 
    # @return  a string representation of this object.
    def to_s
      return @value ? "true" : "false"
    end
    
    typesig { [] }
    # Returns a hash code for this {@code Boolean} object.
    # 
    # @return  the integer {@code 1231} if this object represents
    # {@code true}; returns the integer {@code 1237} if this
    # object represents {@code false}.
    def hash_code
      return @value ? 1231 : 1237
    end
    
    typesig { [Object] }
    # Returns {@code true} if and only if the argument is not
    # {@code null} and is a {@code Boolean} object that
    # represents the same {@code boolean} value as this object.
    # 
    # @param   obj   the object to compare with.
    # @return  {@code true} if the Boolean objects represent the
    #          same value; {@code false} otherwise.
    def ==(obj)
      if (obj.is_a?(Boolean))
        return (@value).equal?((obj).boolean_value)
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns {@code true} if and only if the system property
      # named by the argument exists and is equal to the string
      # {@code "true"}. (Beginning with version 1.0.2 of the
      # Java<small><sup>TM</sup></small> platform, the test of
      # this string is case insensitive.) A system property is accessible
      # through {@code getProperty}, a method defined by the
      # {@code System} class.
      # <p>
      # If there is no property with the specified name, or if the specified
      # name is empty or null, then {@code false} is returned.
      # 
      # @param   name   the system property name.
      # @return  the {@code boolean} value of the system property.
      # @see     java.lang.System#getProperty(java.lang.String)
      # @see     java.lang.System#getProperty(java.lang.String, java.lang.String)
      def get_boolean(name)
        result = false
        begin
          result = to_boolean(System.get_property(name))
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        return result
      end
    }
    
    typesig { [Boolean] }
    # Compares this {@code Boolean} instance with another.
    # 
    # @param   b the {@code Boolean} instance to be compared
    # @return  zero if this object represents the same boolean value as the
    #          argument; a positive value if this object represents true
    #          and the argument represents false; and a negative value if
    #          this object represents false and the argument represents true
    # @throws  NullPointerException if the argument is {@code null}
    # @see     Comparable
    # @since  1.5
    def compare_to(b)
      return ((b.attr_value).equal?(@value) ? 0 : (@value ? 1 : -1))
    end
    
    class_module.module_eval {
      typesig { [String] }
      def to_boolean(name)
        return ((!(name).nil?) && name.equals_ignore_case("true"))
      end
    }
    
    private
    alias_method :initialize__boolean, :initialize
  end
  
end

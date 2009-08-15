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
  module EnumImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectStreamException
    }
  end
  
  # This is the common base class of all Java language enumeration types.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @see     Class#getEnumConstants()
  # @since   1.5
  class Enum 
    include_class_members EnumImports
    include JavaComparable
    include Serializable
    
    # The name of this enum constant, as declared in the enum declaration.
    # Most programmers should use the {@link #toString} method rather than
    # accessing this field.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [] }
    # Returns the name of this enum constant, exactly as declared in its
    # enum declaration.
    # 
    # <b>Most programmers should use the {@link #toString} method in
    # preference to this one, as the toString method may return
    # a more user-friendly name.</b>  This method is designed primarily for
    # use in specialized situations where correctness depends on getting the
    # exact name, which will not vary from release to release.
    # 
    # @return the name of this enum constant
    def name
      return @name
    end
    
    # The ordinal of this enumeration constant (its position
    # in the enum declaration, where the initial constant is assigned
    # an ordinal of zero).
    # 
    # Most programmers will have no use for this field.  It is designed
    # for use by sophisticated enum-based data structures, such as
    # {@link java.util.EnumSet} and {@link java.util.EnumMap}.
    attr_accessor :ordinal
    alias_method :attr_ordinal, :ordinal
    undef_method :ordinal
    alias_method :attr_ordinal=, :ordinal=
    undef_method :ordinal=
    
    typesig { [] }
    # Returns the ordinal of this enumeration constant (its position
    # in its enum declaration, where the initial constant is assigned
    # an ordinal of zero).
    # 
    # Most programmers will have no use for this method.  It is
    # designed for use by sophisticated enum-based data structures, such
    # as {@link java.util.EnumSet} and {@link java.util.EnumMap}.
    # 
    # @return the ordinal of this enumeration constant
    def ordinal
      return @ordinal
    end
    
    typesig { [String, ::Java::Int] }
    # Sole constructor.  Programmers cannot invoke this constructor.
    # It is for use by code emitted by the compiler in response to
    # enum type declarations.
    # 
    # @param name - The name of this enum constant, which is the identifier
    # used to declare it.
    # @param ordinal - The ordinal of this enumeration constant (its position
    # in the enum declaration, where the initial constant is assigned
    # an ordinal of zero).
    def initialize(name, ordinal)
      @name = nil
      @ordinal = 0
      @name = name
      @ordinal = ordinal
    end
    
    typesig { [] }
    # Returns the name of this enum constant, as contained in the
    # declaration.  This method may be overridden, though it typically
    # isn't necessary or desirable.  An enum type should override this
    # method when a more "programmer-friendly" string form exists.
    # 
    # @return the name of this enum constant
    def to_s
      return @name
    end
    
    typesig { [Object] }
    # Returns true if the specified object is equal to this
    # enum constant.
    # 
    # @param other the object to be compared for equality with this object.
    # @return  true if the specified object is equal to this
    # enum constant.
    def ==(other)
      return (self).equal?(other)
    end
    
    typesig { [] }
    # Returns a hash code for this enum constant.
    # 
    # @return a hash code for this enum constant.
    def hash_code
      return super
    end
    
    typesig { [] }
    # Throws CloneNotSupportedException.  This guarantees that enums
    # are never cloned, which is necessary to preserve their "singleton"
    # status.
    # 
    # @return (never returns)
    def clone
      raise CloneNotSupportedException.new
    end
    
    typesig { [Object] }
    # Compares this enum with the specified object for order.  Returns a
    # negative integer, zero, or a positive integer as this object is less
    # than, equal to, or greater than the specified object.
    # 
    # Enum constants are only comparable to other enum constants of the
    # same enum type.  The natural order implemented by this
    # method is the order in which the constants are declared.
    def compare_to(o)
      other = o
      self_ = self
      # optimization
      if (!(self_.get_class).equal?(other.get_class) && !(self_.get_declaring_class).equal?(other.get_declaring_class))
        raise ClassCastException.new
      end
      return self_.attr_ordinal - other.attr_ordinal
    end
    
    typesig { [] }
    # Returns the Class object corresponding to this enum constant's
    # enum type.  Two enum constants e1 and  e2 are of the
    # same enum type if and only if
    # e1.getDeclaringClass() == e2.getDeclaringClass().
    # (The value returned by this method may differ from the one returned
    # by the {@link Object#getClass} method for enum constants with
    # constant-specific class bodies.)
    # 
    # @return the Class object corresponding to this enum constant's
    # enum type
    def get_declaring_class
      clazz = get_class
      zuper = clazz.get_superclass
      return ((zuper).equal?(Enum)) ? clazz : zuper
    end
    
    class_module.module_eval {
      typesig { [Class, String] }
      # Returns the enum constant of the specified enum type with the
      # specified name.  The name must match exactly an identifier used
      # to declare an enum constant in this type.  (Extraneous whitespace
      # characters are not permitted.)
      # 
      # @param enumType the {@code Class} object of the enum type from which
      # to return a constant
      # @param name the name of the constant to return
      # @return the enum constant of the specified enum type with the
      # specified name
      # @throws IllegalArgumentException if the specified enum type has
      # no constant with the specified name, or the specified
      # class object does not represent an enum type
      # @throws NullPointerException if {@code enumType} or {@code name}
      # is null
      # @since 1.5
      def value_of(enum_type, name)
        result = enum_type.enum_constant_directory.get(name)
        if (!(result).nil?)
          return result
        end
        if ((name).nil?)
          raise NullPointerException.new("Name is null")
        end
        raise IllegalArgumentException.new("No enum const " + RJava.cast_to_string(enum_type) + "." + name)
      end
    }
    
    typesig { [] }
    # enum classes cannot have finalize methods.
    def finalize
    end
    
    typesig { [ObjectInputStream] }
    # prevent default deserialization
    def read_object(in_)
      raise InvalidObjectException.new("can't deserialize enum")
    end
    
    typesig { [] }
    def read_object_no_data
      raise InvalidObjectException.new("can't deserialize enum")
    end
    
    private
    alias_method :initialize__enum, :initialize
  end
  
end

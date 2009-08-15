require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module ObjectStreamFieldImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Lang::Reflect, :Field
    }
  end
  
  # A description of a Serializable field from a Serializable class.  An array
  # of ObjectStreamFields is used to declare the Serializable fields of a class.
  # 
  # @author      Mike Warres
  # @author      Roger Riggs
  # @see ObjectStreamClass
  # @since 1.2
  class ObjectStreamField 
    include_class_members ObjectStreamFieldImports
    include JavaComparable
    
    # field name
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # canonical JVM signature of field type
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    # field type (Object.class if unknown non-primitive type)
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # whether or not to (de)serialize field values as unshared
    attr_accessor :unshared
    alias_method :attr_unshared, :unshared
    undef_method :unshared
    alias_method :attr_unshared=, :unshared=
    undef_method :unshared=
    
    # corresponding reflective field object, if any
    attr_accessor :field
    alias_method :attr_field, :field
    undef_method :field
    alias_method :attr_field=, :field=
    undef_method :field=
    
    # offset of field value in enclosing field group
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    typesig { [String, Class] }
    # Create a Serializable field with the specified type.  This field should
    # be documented with a <code>serialField</code> tag.
    # 
    # @param   name the name of the serializable field
    # @param   type the <code>Class</code> object of the serializable field
    def initialize(name, type)
      initialize__object_stream_field(name, type, false)
    end
    
    typesig { [String, Class, ::Java::Boolean] }
    # Creates an ObjectStreamField representing a serializable field with the
    # given name and type.  If unshared is false, values of the represented
    # field are serialized and deserialized in the default manner--if the
    # field is non-primitive, object values are serialized and deserialized as
    # if they had been written and read by calls to writeObject and
    # readObject.  If unshared is true, values of the represented field are
    # serialized and deserialized as if they had been written and read by
    # calls to writeUnshared and readUnshared.
    # 
    # @param   name field name
    # @param   type field type
    # @param   unshared if false, write/read field values in the same manner
    # as writeObject/readObject; if true, write/read in the same
    # manner as writeUnshared/readUnshared
    # @since   1.4
    def initialize(name, type, unshared)
      @name = nil
      @signature = nil
      @type = nil
      @unshared = false
      @field = nil
      @offset = 0
      if ((name).nil?)
        raise NullPointerException.new
      end
      @name = name
      @type = type
      @unshared = unshared
      @signature = RJava.cast_to_string(ObjectStreamClass.get_class_signature(type).intern)
      @field = nil
    end
    
    typesig { [String, String, ::Java::Boolean] }
    # Creates an ObjectStreamField representing a field with the given name,
    # signature and unshared setting.
    def initialize(name, signature, unshared)
      @name = nil
      @signature = nil
      @type = nil
      @unshared = false
      @field = nil
      @offset = 0
      if ((name).nil?)
        raise NullPointerException.new
      end
      @name = name
      @signature = signature.intern
      @unshared = unshared
      @field = nil
      case (signature.char_at(0))
      when Character.new(?Z.ord)
        @type = Boolean::TYPE
      when Character.new(?B.ord)
        @type = Byte::TYPE
      when Character.new(?C.ord)
        @type = Character::TYPE
      when Character.new(?S.ord)
        @type = Short::TYPE
      when Character.new(?I.ord)
        @type = JavaInteger::TYPE
      when Character.new(?J.ord)
        @type = Long::TYPE
      when Character.new(?F.ord)
        @type = Float::TYPE
      when Character.new(?D.ord)
        @type = Double::TYPE
      when Character.new(?L.ord), Character.new(?[.ord)
        @type = Object
      else
        raise IllegalArgumentException.new("illegal signature")
      end
    end
    
    typesig { [Field, ::Java::Boolean, ::Java::Boolean] }
    # Creates an ObjectStreamField representing the given field with the
    # specified unshared setting.  For compatibility with the behavior of
    # earlier serialization implementations, a "showType" parameter is
    # necessary to govern whether or not a getType() call on this
    # ObjectStreamField (if non-primitive) will return Object.class (as
    # opposed to a more specific reference type).
    def initialize(field, unshared, show_type)
      @name = nil
      @signature = nil
      @type = nil
      @unshared = false
      @field = nil
      @offset = 0
      @field = field
      @unshared = unshared
      @name = RJava.cast_to_string(field.get_name)
      ftype = field.get_type
      @type = (show_type || ftype.is_primitive) ? ftype : Object
      @signature = RJava.cast_to_string(ObjectStreamClass.get_class_signature(ftype).intern)
    end
    
    typesig { [] }
    # Get the name of this field.
    # 
    # @return  a <code>String</code> representing the name of the serializable
    # field
    def get_name
      return @name
    end
    
    typesig { [] }
    # Get the type of the field.  If the type is non-primitive and this
    # <code>ObjectStreamField</code> was obtained from a deserialized {@link
    # ObjectStreamClass} instance, then <code>Object.class</code> is returned.
    # Otherwise, the <code>Class</code> object for the type of the field is
    # returned.
    # 
    # @return  a <code>Class</code> object representing the type of the
    # serializable field
    def get_type
      return @type
    end
    
    typesig { [] }
    # Returns character encoding of field type.  The encoding is as follows:
    # <blockquote><pre>
    # B            byte
    # C            char
    # D            double
    # F            float
    # I            int
    # J            long
    # L            class or interface
    # S            short
    # Z            boolean
    # [            array
    # </pre></blockquote>
    # 
    # @return  the typecode of the serializable field
    # 
    # REMIND: deprecate?
    def get_type_code
      return @signature.char_at(0)
    end
    
    typesig { [] }
    # Return the JVM type signature.
    # 
    # @return  null if this field has a primitive type.
    # 
    # REMIND: deprecate?
    def get_type_string
      return is_primitive ? nil : @signature
    end
    
    typesig { [] }
    # Offset of field within instance data.
    # 
    # @return  the offset of this field
    # @see #setOffset
    # 
    # REMIND: deprecate?
    def get_offset
      return @offset
    end
    
    typesig { [::Java::Int] }
    # Offset within instance data.
    # 
    # @param   offset the offset of the field
    # @see #getOffset
    # 
    # REMIND: deprecate?
    def set_offset(offset)
      @offset = offset
    end
    
    typesig { [] }
    # Return true if this field has a primitive type.
    # 
    # @return  true if and only if this field corresponds to a primitive type
    # 
    # REMIND: deprecate?
    def is_primitive
      tcode = @signature.char_at(0)
      return ((!(tcode).equal?(Character.new(?L.ord))) && (!(tcode).equal?(Character.new(?[.ord))))
    end
    
    typesig { [] }
    # Returns boolean value indicating whether or not the serializable field
    # represented by this ObjectStreamField instance is unshared.
    # 
    # @since 1.4
    def is_unshared
      return @unshared
    end
    
    typesig { [Object] }
    # Compare this field with another <code>ObjectStreamField</code>.  Return
    # -1 if this is smaller, 0 if equal, 1 if greater.  Types that are
    # primitives are "smaller" than object types.  If equal, the field names
    # are compared.
    # 
    # REMIND: deprecate?
    def compare_to(obj)
      other = obj
      is_prim = is_primitive
      if (!(is_prim).equal?(other.is_primitive))
        return is_prim ? -1 : 1
      end
      return (@name <=> other.attr_name)
    end
    
    typesig { [] }
    # Return a string that describes this field.
    def to_s
      return @signature + RJava.cast_to_string(Character.new(?\s.ord)) + @name
    end
    
    typesig { [] }
    # Returns field represented by this ObjectStreamField, or null if
    # ObjectStreamField is not associated with an actual field.
    def get_field
      return @field
    end
    
    typesig { [] }
    # Returns JVM type signature of field (similar to getTypeString, except
    # that signature strings are returned for primitive fields as well).
    def get_signature
      return @signature
    end
    
    private
    alias_method :initialize__object_stream_field, :initialize
  end
  
end

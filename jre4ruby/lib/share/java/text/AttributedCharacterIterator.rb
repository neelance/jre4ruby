require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Text
  module AttributedCharacterIteratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :Serializable
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # An AttributedCharacterIterator allows iteration through both text and
  # related attribute information.
  # 
  # <p>
  # An attribute is a key/value pair, identified by the key.  No two
  # attributes on a given character can have the same key.
  # 
  # <p>The values for an attribute are immutable, or must not be mutated
  # by clients or storage.  They are always passed by reference, and not
  # cloned.
  # 
  # <p>A <em>run with respect to an attribute</em> is a maximum text range for
  # which:
  # <ul>
  # <li>the attribute is undefined or null for the entire range, or
  # <li>the attribute value is defined and has the same non-null value for the
  # entire range.
  # </ul>
  # 
  # <p>A <em>run with respect to a set of attributes</em> is a maximum text range for
  # which this condition is met for each member attribute.
  # 
  # <p>The returned indexes are limited to the range of the iterator.
  # 
  # <p>The returned attribute information is limited to runs that contain
  # the current character.
  # 
  # <p>
  # Attribute keys are instances of AttributedCharacterIterator.Attribute and its
  # subclasses, such as java.awt.font.TextAttribute.
  # 
  # @see AttributedCharacterIterator.Attribute
  # @see java.awt.font.TextAttribute
  # @see AttributedString
  # @see Annotation
  # @since 1.2
  module AttributedCharacterIterator
    include_class_members AttributedCharacterIteratorImports
    include CharacterIterator
    
    class_module.module_eval {
      # Defines attribute keys that are used to identify text attributes. These
      # keys are used in AttributedCharacterIterator and AttributedString.
      # @see AttributedCharacterIterator
      # @see AttributedString
      # @since 1.2
      const_set_lazy(:Attribute) { Class.new do
        include_class_members AttributedCharacterIterator
        include Serializable
        
        # The name of this Attribute. The name is used primarily by readResolve
        # to look up the corresponding predefined instance when deserializing
        # an instance.
        # @serial
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        class_module.module_eval {
          # table of all instances in this class, used by readResolve
          const_set_lazy(:InstanceMap) { self.class::HashMap.new(7) }
          const_attr_reader  :InstanceMap
        }
        
        typesig { [self::String] }
        # Constructs an Attribute with the given name.
        def initialize(name)
          @name = nil
          @name = name
          if ((self.get_class).equal?(Attribute))
            self.class::InstanceMap.put(name, self)
          end
        end
        
        typesig { [Object] }
        # Compares two objects for equality. This version only returns true
        # for <code>x.equals(y)</code> if <code>x</code> and <code>y</code> refer
        # to the same object, and guarantees this for all subclasses.
        def ==(obj)
          return super(obj)
        end
        
        typesig { [] }
        # Returns a hash code value for the object. This version is identical to
        # the one in Object, but is also final.
        def hash_code
          return super
        end
        
        typesig { [] }
        # Returns a string representation of the object. This version returns the
        # concatenation of class name, "(", a name identifying the attribute and ")".
        def to_s
          return RJava.cast_to_string(get_class.get_name) + "(" + @name + ")"
        end
        
        typesig { [] }
        # Returns the name of the attribute.
        def get_name
          return @name
        end
        
        typesig { [] }
        # Resolves instances being deserialized to the predefined constants.
        def read_resolve
          if (!(self.get_class).equal?(Attribute))
            raise self.class::InvalidObjectException.new("subclass didn't correctly implement readResolve")
          end
          instance = self.class::InstanceMap.get(get_name)
          if (!(instance).nil?)
            return instance
          else
            raise self.class::InvalidObjectException.new("unknown attribute name")
          end
        end
        
        class_module.module_eval {
          # Attribute key for the language of some text.
          # <p> Values are instances of Locale.
          # @see java.util.Locale
          const_set_lazy(:LANGUAGE) { self.class::Attribute.new("language") }
          const_attr_reader  :LANGUAGE
          
          # Attribute key for the reading of some text. In languages where the written form
          # and the pronunciation of a word are only loosely related (such as Japanese),
          # it is often necessary to store the reading (pronunciation) along with the
          # written form.
          # <p>Values are instances of Annotation holding instances of String.
          # @see Annotation
          # @see java.lang.String
          const_set_lazy(:READING) { self.class::Attribute.new("reading") }
          const_attr_reader  :READING
          
          # Attribute key for input method segments. Input methods often break
          # up text into segments, which usually correspond to words.
          # <p>Values are instances of Annotation holding a null reference.
          # @see Annotation
          const_set_lazy(:INPUT_METHOD_SEGMENT) { self.class::Attribute.new("input_method_segment") }
          const_attr_reader  :INPUT_METHOD_SEGMENT
          
          # make sure the serial version doesn't change between compiler versions
          const_set_lazy(:SerialVersionUID) { -9142742483513960612 }
          const_attr_reader  :SerialVersionUID
        }
        
        private
        alias_method :initialize__attribute, :initialize
      end }
    }
    
    typesig { [] }
    # Returns the index of the first character of the run
    # with respect to all attributes containing the current character.
    def get_run_start
      raise NotImplementedError
    end
    
    typesig { [Attribute] }
    # Returns the index of the first character of the run
    # with respect to the given attribute containing the current character.
    def get_run_start(attribute)
      raise NotImplementedError
    end
    
    typesig { [JavaSet] }
    # Returns the index of the first character of the run
    # with respect to the given attributes containing the current character.
    def get_run_start(attributes)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the index of the first character following the run
    # with respect to all attributes containing the current character.
    def get_run_limit
      raise NotImplementedError
    end
    
    typesig { [Attribute] }
    # Returns the index of the first character following the run
    # with respect to the given attribute containing the current character.
    def get_run_limit(attribute)
      raise NotImplementedError
    end
    
    typesig { [JavaSet] }
    # Returns the index of the first character following the run
    # with respect to the given attributes containing the current character.
    def get_run_limit(attributes)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a map with the attributes defined on the current
    # character.
    def get_attributes
      raise NotImplementedError
    end
    
    typesig { [Attribute] }
    # Returns the value of the named attribute for the current character.
    # Returns null if the attribute is not defined.
    # @param attribute the key of the attribute whose value is requested.
    def get_attribute(attribute)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the keys of all attributes defined on the
    # iterator's text range. The set is empty if no
    # attributes are defined.
    def get_all_attribute_keys
      raise NotImplementedError
    end
  end
  
end

require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module FormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :Serializable
    }
  end
  
  # <code>Format</code> is an abstract base class for formatting locale-sensitive
  # information such as dates, messages, and numbers.
  # 
  # <p>
  # <code>Format</code> defines the programming interface for formatting
  # locale-sensitive objects into <code>String</code>s (the
  # <code>format</code> method) and for parsing <code>String</code>s back
  # into objects (the <code>parseObject</code> method).
  # 
  # <p>
  # Generally, a format's <code>parseObject</code> method must be able to parse
  # any string formatted by its <code>format</code> method. However, there may
  # be exceptional cases where this is not possible. For example, a
  # <code>format</code> method might create two adjacent integer numbers with
  # no separator in between, and in this case the <code>parseObject</code> could
  # not tell which digits belong to which number.
  # 
  # <h4>Subclassing</h4>
  # 
  # <p>
  # The Java Platform provides three specialized subclasses of <code>Format</code>--
  # <code>DateFormat</code>, <code>MessageFormat</code>, and
  # <code>NumberFormat</code>--for formatting dates, messages, and numbers,
  # respectively.
  # <p>
  # Concrete subclasses must implement three methods:
  # <ol>
  # <li> <code>format(Object obj, StringBuffer toAppendTo, FieldPosition pos)</code>
  # <li> <code>formatToCharacterIterator(Object obj)</code>
  # <li> <code>parseObject(String source, ParsePosition pos)</code>
  # </ol>
  # These general methods allow polymorphic parsing and formatting of objects
  # and are used, for example, by <code>MessageFormat</code>.
  # Subclasses often also provide additional <code>format</code> methods for
  # specific input types as well as <code>parse</code> methods for specific
  # result types. Any <code>parse</code> method that does not take a
  # <code>ParsePosition</code> argument should throw <code>ParseException</code>
  # when no text in the required format is at the beginning of the input text.
  # 
  # <p>
  # Most subclasses will also implement the following factory methods:
  # <ol>
  # <li>
  # <code>getInstance</code> for getting a useful format object appropriate
  # for the current locale
  # <li>
  # <code>getInstance(Locale)</code> for getting a useful format
  # object appropriate for the specified locale
  # </ol>
  # In addition, some subclasses may also implement other
  # <code>getXxxxInstance</code> methods for more specialized control. For
  # example, the <code>NumberFormat</code> class provides
  # <code>getPercentInstance</code> and <code>getCurrencyInstance</code>
  # methods for getting specialized number formatters.
  # 
  # <p>
  # Subclasses of <code>Format</code> that allow programmers to create objects
  # for locales (with <code>getInstance(Locale)</code> for example)
  # must also implement the following class method:
  # <blockquote>
  # <pre>
  # public static Locale[] getAvailableLocales()
  # </pre>
  # </blockquote>
  # 
  # <p>
  # And finally subclasses may define a set of constants to identify the various
  # fields in the formatted output. These constants are used to create a FieldPosition
  # object which identifies what information is contained in the field and its
  # position in the formatted result. These constants should be named
  # <code><em>item</em>_FIELD</code> where <code><em>item</em></code> identifies
  # the field. For examples of these constants, see <code>ERA_FIELD</code> and its
  # friends in {@link DateFormat}.
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Formats are generally not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # @see          java.text.ParsePosition
  # @see          java.text.FieldPosition
  # @see          java.text.NumberFormat
  # @see          java.text.DateFormat
  # @see          java.text.MessageFormat
  # @author       Mark Davis
  class Format 
    include_class_members FormatImports
    include Serializable
    include Cloneable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -299282585814624189 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
    end
    
    typesig { [Object] }
    # Formats an object to produce a string. This is equivalent to
    # <blockquote>
    # {@link #format(Object, StringBuffer, FieldPosition) format}<code>(obj,
    # new StringBuffer(), new FieldPosition(0)).toString();</code>
    # </blockquote>
    # 
    # @param obj    The object to format
    # @return       Formatted string.
    # @exception IllegalArgumentException if the Format cannot format the given
    # object
    def format(obj)
      return format(obj, StringBuffer.new, FieldPosition.new(0)).to_s
    end
    
    typesig { [Object, StringBuffer, FieldPosition] }
    # Formats an object and appends the resulting text to a given string
    # buffer.
    # If the <code>pos</code> argument identifies a field used by the format,
    # then its indices are set to the beginning and end of the first such
    # field encountered.
    # 
    # @param obj    The object to format
    # @param toAppendTo    where the text is to be appended
    # @param pos    A <code>FieldPosition</code> identifying a field
    # in the formatted text
    # @return       the string buffer passed in as <code>toAppendTo</code>,
    # with formatted text appended
    # @exception NullPointerException if <code>toAppendTo</code> or
    # <code>pos</code> is null
    # @exception IllegalArgumentException if the Format cannot format the given
    # object
    def format(obj, to_append_to, pos)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Formats an Object producing an <code>AttributedCharacterIterator</code>.
    # You can use the returned <code>AttributedCharacterIterator</code>
    # to build the resulting String, as well as to determine information
    # about the resulting String.
    # <p>
    # Each attribute key of the AttributedCharacterIterator will be of type
    # <code>Field</code>. It is up to each <code>Format</code> implementation
    # to define what the legal values are for each attribute in the
    # <code>AttributedCharacterIterator</code>, but typically the attribute
    # key is also used as the attribute value.
    # <p>The default implementation creates an
    # <code>AttributedCharacterIterator</code> with no attributes. Subclasses
    # that support fields should override this and create an
    # <code>AttributedCharacterIterator</code> with meaningful attributes.
    # 
    # @exception NullPointerException if obj is null.
    # @exception IllegalArgumentException when the Format cannot format the
    # given object.
    # @param obj The object to format
    # @return AttributedCharacterIterator describing the formatted value.
    # @since 1.4
    def format_to_character_iterator(obj)
      return create_attributed_character_iterator(format(obj))
    end
    
    typesig { [String, ParsePosition] }
    # Parses text from a string to produce an object.
    # <p>
    # The method attempts to parse text starting at the index given by
    # <code>pos</code>.
    # If parsing succeeds, then the index of <code>pos</code> is updated
    # to the index after the last character used (parsing does not necessarily
    # use all characters up to the end of the string), and the parsed
    # object is returned. The updated <code>pos</code> can be used to
    # indicate the starting point for the next call to this method.
    # If an error occurs, then the index of <code>pos</code> is not
    # changed, the error index of <code>pos</code> is set to the index of
    # the character where the error occurred, and null is returned.
    # 
    # @param source A <code>String</code>, part of which should be parsed.
    # @param pos A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return An <code>Object</code> parsed from the string. In case of
    # error, returns null.
    # @exception NullPointerException if <code>pos</code> is null.
    def parse_object(source, pos)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Parses text from the beginning of the given string to produce an object.
    # The method may not use the entire text of the given string.
    # 
    # @param source A <code>String</code> whose beginning should be parsed.
    # @return An <code>Object</code> parsed from the string.
    # @exception ParseException if the beginning of the specified string
    # cannot be parsed.
    def parse_object(source)
      pos = ParsePosition.new(0)
      result = parse_object(source, pos)
      if ((pos.attr_index).equal?(0))
        raise ParseException.new("Format.parseObject(String) failed", pos.attr_error_index)
      end
      return result
    end
    
    typesig { [] }
    # Creates and returns a copy of this object.
    # 
    # @return a clone of this instance.
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        # will never happen
        return nil
      end
    end
    
    typesig { [String] }
    # Convenience methods for creating AttributedCharacterIterators from
    # different parameters.
    # 
    # 
    # Creates an <code>AttributedCharacterIterator</code> for the String
    # <code>s</code>.
    # 
    # @param s String to create AttributedCharacterIterator from
    # @return AttributedCharacterIterator wrapping s
    def create_attributed_character_iterator(s)
      as = AttributedString.new(s)
      return as.get_iterator
    end
    
    typesig { [Array.typed(AttributedCharacterIterator)] }
    # Creates an <code>AttributedCharacterIterator</code> containg the
    # concatenated contents of the passed in
    # <code>AttributedCharacterIterator</code>s.
    # 
    # @param iterators AttributedCharacterIterators used to create resulting
    # AttributedCharacterIterators
    # @return AttributedCharacterIterator wrapping passed in
    # AttributedCharacterIterators
    def create_attributed_character_iterator(iterators)
      as = AttributedString.new(iterators)
      return as.get_iterator
    end
    
    typesig { [String, AttributedCharacterIterator::Attribute, Object] }
    # Returns an AttributedCharacterIterator with the String
    # <code>string</code> and additional key/value pair <code>key</code>,
    # <code>value</code>.
    # 
    # @param string String to create AttributedCharacterIterator from
    # @param key Key for AttributedCharacterIterator
    # @param value Value associated with key in AttributedCharacterIterator
    # @return AttributedCharacterIterator wrapping args
    def create_attributed_character_iterator(string, key, value)
      as = AttributedString.new(string)
      as.add_attribute(key, value)
      return as.get_iterator
    end
    
    typesig { [AttributedCharacterIterator, AttributedCharacterIterator::Attribute, Object] }
    # Creates an AttributedCharacterIterator with the contents of
    # <code>iterator</code> and the additional attribute <code>key</code>
    # <code>value</code>.
    # 
    # @param iterator Initial AttributedCharacterIterator to add arg to
    # @param key Key for AttributedCharacterIterator
    # @param value Value associated with key in AttributedCharacterIterator
    # @return AttributedCharacterIterator wrapping args
    def create_attributed_character_iterator(iterator, key, value)
      as = AttributedString.new(iterator)
      as.add_attribute(key, value)
      return as.get_iterator
    end
    
    class_module.module_eval {
      # Defines constants that are used as attribute keys in the
      # <code>AttributedCharacterIterator</code> returned
      # from <code>Format.formatToCharacterIterator</code> and as
      # field identifiers in <code>FieldPosition</code>.
      # 
      # @since 1.4
      const_set_lazy(:Field) { Class.new(AttributedCharacterIterator::Attribute) do
        include_class_members Format
        
        class_module.module_eval {
          # Proclaim serial compatibility with 1.4 FCS
          const_set_lazy(:SerialVersionUID) { 276966692217360283 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [self::String] }
        # Creates a Field with the specified name.
        # 
        # @param name Name of the attribute
        def initialize(name)
          super(name)
        end
        
        private
        alias_method :initialize__field, :initialize
      end }
      
      # FieldDelegate is notified by the various <code>Format</code>
      # implementations as they are formatting the Objects. This allows for
      # storage of the individual sections of the formatted String for
      # later use, such as in a <code>FieldPosition</code> or for an
      # <code>AttributedCharacterIterator</code>.
      # <p>
      # Delegates should NOT assume that the <code>Format</code> will notify
      # the delegate of fields in any particular order.
      # 
      # @see FieldPosition.Delegate
      # @see CharacterIteratorFieldDelegate
      const_set_lazy(:FieldDelegate) { Module.new do
        include_class_members Format
        
        typesig { [Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
        # Notified when a particular region of the String is formatted. This
        # method will be invoked if there is no corresponding integer field id
        # matching <code>attr</code>.
        # 
        # @param attr Identifies the field matched
        # @param value Value associated with the field
        # @param start Beginning location of the field, will be >= 0
        # @param end End of the field, will be >= start and <= buffer.length()
        # @param buffer Contains current formatted value, receiver should
        # NOT modify it.
        def formatted(attr, value, start, end_, buffer)
          raise NotImplementedError
        end
        
        typesig { [::Java::Int, Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
        # Notified when a particular region of the String is formatted.
        # 
        # @param fieldID Identifies the field by integer
        # @param attr Identifies the field matched
        # @param value Value associated with the field
        # @param start Beginning location of the field, will be >= 0
        # @param end End of the field, will be >= start and <= buffer.length()
        # @param buffer Contains current formatted value, receiver should
        # NOT modify it.
        def formatted(field_id, attr, value, start, end_, buffer)
          raise NotImplementedError
        end
      end }
    }
    
    private
    alias_method :initialize__format, :initialize
  end
  
end

require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module FieldPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # <code>FieldPosition</code> is a simple class used by <code>Format</code>
  # and its subclasses to identify fields in formatted output. Fields can
  # be identified in two ways:
  # <ul>
  # <li>By an integer constant, whose names typically end with
  # <code>_FIELD</code>. The constants are defined in the various
  # subclasses of <code>Format</code>.
  # <li>By a <code>Format.Field</code> constant, see <code>ERA_FIELD</code>
  # and its friends in <code>DateFormat</code> for an example.
  # </ul>
  # <p>
  # <code>FieldPosition</code> keeps track of the position of the
  # field within the formatted output with two indices: the index
  # of the first character of the field and the index of the last
  # character of the field.
  # 
  # <p>
  # One version of the <code>format</code> method in the various
  # <code>Format</code> classes requires a <code>FieldPosition</code>
  # object as an argument. You use this <code>format</code> method
  # to perform partial formatting or to get information about the
  # formatted output (such as the position of a field).
  # 
  # <p>
  # If you are interested in the positions of all attributes in the
  # formatted string use the <code>Format</code> method
  # <code>formatToCharacterIterator</code>.
  # 
  # @author      Mark Davis
  # @see         java.text.Format
  class FieldPosition 
    include_class_members FieldPositionImports
    
    # Input: Desired field to determine start and end offsets for.
    # The meaning depends on the subclass of Format.
    attr_accessor :field
    alias_method :attr_field, :field
    undef_method :field
    alias_method :attr_field=, :field=
    undef_method :field=
    
    # Output: End offset of field in text.
    # If the field does not occur in the text, 0 is returned.
    attr_accessor :end_index
    alias_method :attr_end_index, :end_index
    undef_method :end_index
    alias_method :attr_end_index=, :end_index=
    undef_method :end_index=
    
    # Output: Start offset of field in text.
    # If the field does not occur in the text, 0 is returned.
    attr_accessor :begin_index
    alias_method :attr_begin_index, :begin_index
    undef_method :begin_index
    alias_method :attr_begin_index=, :begin_index=
    undef_method :begin_index=
    
    # Desired field this FieldPosition is for.
    attr_accessor :attribute
    alias_method :attr_attribute, :attribute
    undef_method :attribute
    alias_method :attr_attribute=, :attribute=
    undef_method :attribute=
    
    typesig { [::Java::Int] }
    # Creates a FieldPosition object for the given field.  Fields are
    # identified by constants, whose names typically end with _FIELD,
    # in the various subclasses of Format.
    # 
    # @see java.text.NumberFormat#INTEGER_FIELD
    # @see java.text.NumberFormat#FRACTION_FIELD
    # @see java.text.DateFormat#YEAR_FIELD
    # @see java.text.DateFormat#MONTH_FIELD
    def initialize(field)
      @field = 0
      @end_index = 0
      @begin_index = 0
      @attribute = nil
      @field = field
    end
    
    typesig { [Format::Field] }
    # Creates a FieldPosition object for the given field constant. Fields are
    # identified by constants defined in the various <code>Format</code>
    # subclasses. This is equivalent to calling
    # <code>new FieldPosition(attribute, -1)</code>.
    # 
    # @param attribute Format.Field constant identifying a field
    # @since 1.4
    def initialize(attribute)
      initialize__field_position(attribute, -1)
    end
    
    typesig { [Format::Field, ::Java::Int] }
    # Creates a <code>FieldPosition</code> object for the given field.
    # The field is identified by an attribute constant from one of the
    # <code>Field</code> subclasses as well as an integer field ID
    # defined by the <code>Format</code> subclasses. <code>Format</code>
    # subclasses that are aware of <code>Field</code> should give precedence
    # to <code>attribute</code> and ignore <code>fieldID</code> if
    # <code>attribute</code> is not null. However, older <code>Format</code>
    # subclasses may not be aware of <code>Field</code> and rely on
    # <code>fieldID</code>. If the field has no corresponding integer
    # constant, <code>fieldID</code> should be -1.
    # 
    # @param attribute Format.Field constant identifying a field
    # @param fieldID integer constantce identifying a field
    # @since 1.4
    def initialize(attribute, field_id)
      @field = 0
      @end_index = 0
      @begin_index = 0
      @attribute = nil
      @attribute = attribute
      @field = field_id
    end
    
    typesig { [] }
    # Returns the field identifier as an attribute constant
    # from one of the <code>Field</code> subclasses. May return null if
    # the field is specified only by an integer field ID.
    # 
    # @return Identifier for the field
    # @since 1.4
    def get_field_attribute
      return @attribute
    end
    
    typesig { [] }
    # Retrieves the field identifier.
    def get_field
      return @field
    end
    
    typesig { [] }
    # Retrieves the index of the first character in the requested field.
    def get_begin_index
      return @begin_index
    end
    
    typesig { [] }
    # Retrieves the index of the character following the last character in the
    # requested field.
    def get_end_index
      return @end_index
    end
    
    typesig { [::Java::Int] }
    # Sets the begin index.  For use by subclasses of Format.
    # @since 1.2
    def set_begin_index(bi)
      @begin_index = bi
    end
    
    typesig { [::Java::Int] }
    # Sets the end index.  For use by subclasses of Format.
    # @since 1.2
    def set_end_index(ei)
      @end_index = ei
    end
    
    typesig { [] }
    # Returns a <code>Format.FieldDelegate</code> instance that is associated
    # with the FieldPosition. When the delegate is notified of the same
    # field the FieldPosition is associated with, the begin/end will be
    # adjusted.
    def get_field_delegate
      return Delegate.new_local(self)
    end
    
    typesig { [Object] }
    # Overrides equals
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      if (!(obj.is_a?(FieldPosition)))
        return false
      end
      other = obj
      if ((@attribute).nil?)
        if (!(other.attr_attribute).nil?)
          return false
        end
      else
        if (!(@attribute == other.attr_attribute))
          return false
        end
      end
      return ((@begin_index).equal?(other.attr_begin_index) && (@end_index).equal?(other.attr_end_index) && (@field).equal?(other.attr_field))
    end
    
    typesig { [] }
    # Returns a hash code for this FieldPosition.
    # @return a hash code value for this object
    def hash_code
      return (@field << 24) | (@begin_index << 16) | @end_index
    end
    
    typesig { [] }
    # Return a string representation of this FieldPosition.
    # @return  a string representation of this object
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[field=" + RJava.cast_to_string(@field) + ",attribute=" + RJava.cast_to_string(@attribute) + ",beginIndex=" + RJava.cast_to_string(@begin_index) + ",endIndex=" + RJava.cast_to_string(@end_index) + RJava.cast_to_string(Character.new(?].ord))
    end
    
    typesig { [Format::Field] }
    # Return true if the receiver wants a <code>Format.Field</code> value and
    # <code>attribute</code> is equal to it.
    def matches_field(attribute)
      if (!(@attribute).nil?)
        return (@attribute == attribute)
      end
      return false
    end
    
    typesig { [Format::Field, ::Java::Int] }
    # Return true if the receiver wants a <code>Format.Field</code> value and
    # <code>attribute</code> is equal to it, or true if the receiver
    # represents an inteter constant and <code>field</code> equals it.
    def matches_field(attribute, field)
      if (!(@attribute).nil?)
        return (@attribute == attribute)
      end
      return ((field).equal?(@field))
    end
    
    class_module.module_eval {
      # An implementation of FieldDelegate that will adjust the begin/end
      # of the FieldPosition if the arguments match the field of
      # the FieldPosition.
      const_set_lazy(:Delegate) { Class.new do
        extend LocalClass
        include_class_members FieldPosition
        include Format::FieldDelegate
        
        # Indicates whether the field has been  encountered before. If this
        # is true, and <code>formatted</code> is invoked, the begin/end
        # are not updated.
        attr_accessor :encountered_field
        alias_method :attr_encountered_field, :encountered_field
        undef_method :encountered_field
        alias_method :attr_encountered_field=, :encountered_field=
        undef_method :encountered_field=
        
        typesig { [class_self::Format::Field, Object, ::Java::Int, ::Java::Int, class_self::StringBuffer] }
        def formatted(attr, value, start, end_, buffer)
          if (!@encountered_field && matches_field(attr))
            set_begin_index(start)
            set_end_index(end_)
            @encountered_field = (!(start).equal?(end_))
          end
        end
        
        typesig { [::Java::Int, class_self::Format::Field, Object, ::Java::Int, ::Java::Int, class_self::StringBuffer] }
        def formatted(field_id, attr, value, start, end_, buffer)
          if (!@encountered_field && matches_field(attr, field_id))
            set_begin_index(start)
            set_end_index(end_)
            @encountered_field = (!(start).equal?(end_))
          end
        end
        
        typesig { [] }
        def initialize
          @encountered_field = false
        end
        
        private
        alias_method :initialize__delegate, :initialize
      end }
    }
    
    private
    alias_method :initialize__field_position, :initialize
  end
  
end

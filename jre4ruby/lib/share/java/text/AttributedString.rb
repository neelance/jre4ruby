require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AttributedStringImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include ::Java::Util
      include_const ::Java::Text::AttributedCharacterIterator, :Attribute
    }
  end
  
  # An AttributedString holds text and related attribute information. It
  # may be used as the actual data storage in some cases where a text
  # reader wants to access attributed text through the AttributedCharacterIterator
  # interface.
  # 
  # <p>
  # An attribute is a key/value pair, identified by the key.  No two
  # attributes on a given character can have the same key.
  # 
  # <p>The values for an attribute are immutable, or must not be mutated
  # by clients or storage.  They are always passed by reference, and not
  # cloned.
  # 
  # @see AttributedCharacterIterator
  # @see Annotation
  # @since 1.2
  class AttributedString 
    include_class_members AttributedStringImports
    
    class_module.module_eval {
      # since there are no vectors of int, we have to use arrays.
      # We allocate them in chunks of 10 elements so we don't have to allocate all the time.
      const_set_lazy(:ARRAY_SIZE_INCREMENT) { 10 }
      const_attr_reader  :ARRAY_SIZE_INCREMENT
    }
    
    # field holding the text
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # fields holding run attribute information
    # run attributes are organized by run
    attr_accessor :run_array_size
    alias_method :attr_run_array_size, :run_array_size
    undef_method :run_array_size
    alias_method :attr_run_array_size=, :run_array_size=
    undef_method :run_array_size=
    
    # current size of the arrays
    attr_accessor :run_count
    alias_method :attr_run_count, :run_count
    undef_method :run_count
    alias_method :attr_run_count=, :run_count=
    undef_method :run_count=
    
    # actual number of runs, <= runArraySize
    attr_accessor :run_starts
    alias_method :attr_run_starts, :run_starts
    undef_method :run_starts
    alias_method :attr_run_starts=, :run_starts=
    undef_method :run_starts=
    
    # start index for each run
    attr_accessor :run_attributes
    alias_method :attr_run_attributes, :run_attributes
    undef_method :run_attributes
    alias_method :attr_run_attributes=, :run_attributes=
    undef_method :run_attributes=
    
    # vector of attribute keys for each run
    attr_accessor :run_attribute_values
    alias_method :attr_run_attribute_values, :run_attribute_values
    undef_method :run_attribute_values
    alias_method :attr_run_attribute_values=, :run_attribute_values=
    undef_method :run_attribute_values=
    
    typesig { [Array.typed(AttributedCharacterIterator)] }
    # parallel vector of attribute values for each run
    # 
    # Constructs an AttributedString instance with the given
    # AttributedCharacterIterators.
    # 
    # @param iterators AttributedCharacterIterators to construct
    # AttributedString from.
    # @throws NullPointerException if iterators is null
    def initialize(iterators)
      @text = nil
      @run_array_size = 0
      @run_count = 0
      @run_starts = nil
      @run_attributes = nil
      @run_attribute_values = nil
      if ((iterators).nil?)
        raise NullPointerException.new("Iterators must not be null")
      end
      if ((iterators.attr_length).equal?(0))
        @text = ""
      else
        # Build the String contents
        buffer = StringBuffer.new
        counter = 0
        while counter < iterators.attr_length
          append_contents(buffer, iterators[counter])
          counter += 1
        end
        @text = RJava.cast_to_string(buffer.to_s)
        if (@text.length > 0)
          # Determine the runs, creating a new run when the attributes
          # differ.
          offset = 0
          last = nil
          counter_ = 0
          while counter_ < iterators.attr_length
            iterator = iterators[counter_]
            start = iterator.get_begin_index
            end_ = iterator.get_end_index
            index = start
            while (index < end_)
              iterator.set_index(index)
              attrs = iterator.get_attributes
              if (maps_differ(last, attrs))
                set_attributes(attrs, index - start + offset)
              end
              last = attrs
              index = iterator.get_run_limit
            end
            offset += (end_ - start)
            counter_ += 1
          end
        end
      end
    end
    
    typesig { [String] }
    # Constructs an AttributedString instance with the given text.
    # @param text The text for this attributed string.
    # @exception NullPointerException if <code>text</code> is null.
    def initialize(text)
      @text = nil
      @run_array_size = 0
      @run_count = 0
      @run_starts = nil
      @run_attributes = nil
      @run_attribute_values = nil
      if ((text).nil?)
        raise NullPointerException.new
      end
      @text = text
    end
    
    typesig { [String, Map] }
    # Constructs an AttributedString instance with the given text and attributes.
    # @param text The text for this attributed string.
    # @param attributes The attributes that apply to the entire string.
    # @exception NullPointerException if <code>text</code> or
    # <code>attributes</code> is null.
    # @exception IllegalArgumentException if the text has length 0
    # and the attributes parameter is not an empty Map (attributes
    # cannot be applied to a 0-length range).
    def initialize(text, attributes)
      @text = nil
      @run_array_size = 0
      @run_count = 0
      @run_starts = nil
      @run_attributes = nil
      @run_attribute_values = nil
      if ((text).nil? || (attributes).nil?)
        raise NullPointerException.new
      end
      @text = text
      if ((text.length).equal?(0))
        if (attributes.is_empty)
          return
        end
        raise IllegalArgumentException.new("Can't add attribute to 0-length text")
      end
      attribute_count = attributes.size
      if (attribute_count > 0)
        create_run_attribute_data_vectors
        new_run_attributes = Vector.new(attribute_count)
        new_run_attribute_values = Vector.new(attribute_count)
        @run_attributes[0] = new_run_attributes
        @run_attribute_values[0] = new_run_attribute_values
        iterator = attributes.entry_set.iterator
        while (iterator.has_next)
          entry = iterator.next_
          new_run_attributes.add_element(entry.get_key)
          new_run_attribute_values.add_element(entry.get_value)
        end
      end
    end
    
    typesig { [AttributedCharacterIterator] }
    # Constructs an AttributedString instance with the given attributed
    # text represented by AttributedCharacterIterator.
    # @param text The text for this attributed string.
    # @exception NullPointerException if <code>text</code> is null.
    def initialize(text)
      # If performance is critical, this constructor should be
      # implemented here rather than invoking the constructor for a
      # subrange. We can avoid some range checking in the loops.
      initialize__attributed_string(text, text.get_begin_index, text.get_end_index, nil)
    end
    
    typesig { [AttributedCharacterIterator, ::Java::Int, ::Java::Int] }
    # Constructs an AttributedString instance with the subrange of
    # the given attributed text represented by
    # AttributedCharacterIterator. If the given range produces an
    # empty text, all attributes will be discarded.  Note that any
    # attributes wrapped by an Annotation object are discarded for a
    # subrange of the original attribute range.
    # 
    # @param text The text for this attributed string.
    # @param beginIndex Index of the first character of the range.
    # @param endIndex Index of the character following the last character
    # of the range.
    # @exception NullPointerException if <code>text</code> is null.
    # @exception IllegalArgumentException if the subrange given by
    # beginIndex and endIndex is out of the text range.
    # @see java.text.Annotation
    def initialize(text, begin_index, end_index)
      initialize__attributed_string(text, begin_index, end_index, nil)
    end
    
    typesig { [AttributedCharacterIterator, ::Java::Int, ::Java::Int, Array.typed(Attribute)] }
    # Constructs an AttributedString instance with the subrange of
    # the given attributed text represented by
    # AttributedCharacterIterator.  Only attributes that match the
    # given attributes will be incorporated into the instance. If the
    # given range produces an empty text, all attributes will be
    # discarded. Note that any attributes wrapped by an Annotation
    # object are discarded for a subrange of the original attribute
    # range.
    # 
    # @param text The text for this attributed string.
    # @param beginIndex Index of the first character of the range.
    # @param endIndex Index of the character following the last character
    # of the range.
    # @param attributes Specifies attributes to be extracted
    # from the text. If null is specified, all available attributes will
    # be used.
    # @exception NullPointerException if <code>text</code> or
    # <code>attributes</code> is null.
    # @exception IllegalArgumentException if the subrange given by
    # beginIndex and endIndex is out of the text range.
    # @see java.text.Annotation
    def initialize(text, begin_index, end_index, attributes)
      @text = nil
      @run_array_size = 0
      @run_count = 0
      @run_starts = nil
      @run_attributes = nil
      @run_attribute_values = nil
      if ((text).nil?)
        raise NullPointerException.new
      end
      # Validate the given subrange
      text_begin_index = text.get_begin_index
      text_end_index = text.get_end_index
      if (begin_index < text_begin_index || end_index > text_end_index || begin_index > end_index)
        raise IllegalArgumentException.new("Invalid substring range")
      end
      # Copy the given string
      text_buffer = StringBuffer.new
      text.set_index(begin_index)
      c = text.current
      while text.get_index < end_index
        text_buffer.append(c)
        c = text.next_
      end
      @text = text_buffer.to_s
      if ((begin_index).equal?(end_index))
        return
      end
      # Select attribute keys to be taken care of
      keys = HashSet.new
      if ((attributes).nil?)
        keys.add_all(text.get_all_attribute_keys)
      else
        i = 0
        while i < attributes.attr_length
          keys.add(attributes[i])
          i += 1
        end
        keys.retain_all(text.get_all_attribute_keys)
      end
      if (keys.is_empty)
        return
      end
      # Get and set attribute runs for each attribute name. Need to
      # scan from the top of the text so that we can discard any
      # Annotation that is no longer applied to a subset text segment.
      itr = keys.iterator
      while (itr.has_next)
        attribute_key = itr.next_
        text.set_index(text_begin_index)
        while (text.get_index < end_index)
          start = text.get_run_start(attribute_key)
          limit = text.get_run_limit(attribute_key)
          value = text.get_attribute(attribute_key)
          if (!(value).nil?)
            if (value.is_a?(Annotation))
              if (start >= begin_index && limit <= end_index)
                add_attribute(attribute_key, value, start - begin_index, limit - begin_index)
              else
                if (limit > end_index)
                  break
                end
              end
            else
              # if the run is beyond the given (subset) range, we
              # don't need to process further.
              if (start >= end_index)
                break
              end
              if (limit > begin_index)
                # attribute is applied to any subrange
                if (start < begin_index)
                  start = begin_index
                end
                if (limit > end_index)
                  limit = end_index
                end
                if (!(start).equal?(limit))
                  add_attribute(attribute_key, value, start - begin_index, limit - begin_index)
                end
              end
            end
          end
          text.set_index(limit)
        end
      end
    end
    
    typesig { [Attribute, Object] }
    # Adds an attribute to the entire string.
    # @param attribute the attribute key
    # @param value the value of the attribute; may be null
    # @exception NullPointerException if <code>attribute</code> is null.
    # @exception IllegalArgumentException if the AttributedString has length 0
    # (attributes cannot be applied to a 0-length range).
    def add_attribute(attribute, value)
      if ((attribute).nil?)
        raise NullPointerException.new
      end
      len = length
      if ((len).equal?(0))
        raise IllegalArgumentException.new("Can't add attribute to 0-length text")
      end
      add_attribute_impl(attribute, value, 0, len)
    end
    
    typesig { [Attribute, Object, ::Java::Int, ::Java::Int] }
    # Adds an attribute to a subrange of the string.
    # @param attribute the attribute key
    # @param value The value of the attribute. May be null.
    # @param beginIndex Index of the first character of the range.
    # @param endIndex Index of the character following the last character of the range.
    # @exception NullPointerException if <code>attribute</code> is null.
    # @exception IllegalArgumentException if beginIndex is less then 0, endIndex is
    # greater than the length of the string, or beginIndex and endIndex together don't
    # define a non-empty subrange of the string.
    def add_attribute(attribute, value, begin_index, end_index)
      if ((attribute).nil?)
        raise NullPointerException.new
      end
      if (begin_index < 0 || end_index > length || begin_index >= end_index)
        raise IllegalArgumentException.new("Invalid substring range")
      end
      add_attribute_impl(attribute, value, begin_index, end_index)
    end
    
    typesig { [Map, ::Java::Int, ::Java::Int] }
    # Adds a set of attributes to a subrange of the string.
    # @param attributes The attributes to be added to the string.
    # @param beginIndex Index of the first character of the range.
    # @param endIndex Index of the character following the last
    # character of the range.
    # @exception NullPointerException if <code>attributes</code> is null.
    # @exception IllegalArgumentException if beginIndex is less then
    # 0, endIndex is greater than the length of the string, or
    # beginIndex and endIndex together don't define a non-empty
    # subrange of the string and the attributes parameter is not an
    # empty Map.
    def add_attributes(attributes, begin_index, end_index)
      if ((attributes).nil?)
        raise NullPointerException.new
      end
      if (begin_index < 0 || end_index > length || begin_index > end_index)
        raise IllegalArgumentException.new("Invalid substring range")
      end
      if ((begin_index).equal?(end_index))
        if (attributes.is_empty)
          return
        end
        raise IllegalArgumentException.new("Can't add attribute to 0-length text")
      end
      # make sure we have run attribute data vectors
      if ((@run_count).equal?(0))
        create_run_attribute_data_vectors
      end
      # break up runs if necessary
      begin_run_index = ensure_run_break(begin_index)
      end_run_index = ensure_run_break(end_index)
      iterator_ = attributes.entry_set.iterator
      while (iterator_.has_next)
        entry = iterator_.next_
        add_attribute_run_data(entry.get_key, entry.get_value, begin_run_index, end_run_index)
      end
    end
    
    typesig { [Attribute, Object, ::Java::Int, ::Java::Int] }
    def add_attribute_impl(attribute, value, begin_index, end_index)
      synchronized(self) do
        # make sure we have run attribute data vectors
        if ((@run_count).equal?(0))
          create_run_attribute_data_vectors
        end
        # break up runs if necessary
        begin_run_index = ensure_run_break(begin_index)
        end_run_index = ensure_run_break(end_index)
        add_attribute_run_data(attribute, value, begin_run_index, end_run_index)
      end
    end
    
    typesig { [] }
    def create_run_attribute_data_vectors
      # use temporary variables so things remain consistent in case of an exception
      new_run_starts = Array.typed(::Java::Int).new(ARRAY_SIZE_INCREMENT) { 0 }
      new_run_attributes = Array.typed(Vector).new(ARRAY_SIZE_INCREMENT) { nil }
      new_run_attribute_values = Array.typed(Vector).new(ARRAY_SIZE_INCREMENT) { nil }
      @run_starts = new_run_starts
      @run_attributes = new_run_attributes
      @run_attribute_values = new_run_attribute_values
      @run_array_size = ARRAY_SIZE_INCREMENT
      @run_count = 1 # assume initial run starting at index 0
    end
    
    typesig { [::Java::Int] }
    # ensure there's a run break at offset, return the index of the run
    def ensure_run_break(offset)
      return ensure_run_break(offset, true)
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Ensures there is a run break at offset, returning the index of
    # the run. If this results in splitting a run, two things can happen:
    # <ul>
    # <li>If copyAttrs is true, the attributes from the existing run
    # will be placed in both of the newly created runs.
    # <li>If copyAttrs is false, the attributes from the existing run
    # will NOT be copied to the run to the right (>= offset) of the break,
    # but will exist on the run to the left (< offset).
    # </ul>
    def ensure_run_break(offset, copy_attrs)
      if ((offset).equal?(length))
        return @run_count
      end
      # search for the run index where this offset should be
      run_index = 0
      while (run_index < @run_count && @run_starts[run_index] < offset)
        run_index += 1
      end
      # if the offset is at a run start already, we're done
      if (run_index < @run_count && (@run_starts[run_index]).equal?(offset))
        return run_index
      end
      # we'll have to break up a run
      # first, make sure we have enough space in our arrays
      if ((@run_count).equal?(@run_array_size))
        new_array_size = @run_array_size + ARRAY_SIZE_INCREMENT
        new_run_starts = Array.typed(::Java::Int).new(new_array_size) { 0 }
        new_run_attributes = Array.typed(Vector).new(new_array_size) { nil }
        new_run_attribute_values = Array.typed(Vector).new(new_array_size) { nil }
        i = 0
        while i < @run_array_size
          new_run_starts[i] = @run_starts[i]
          new_run_attributes[i] = @run_attributes[i]
          new_run_attribute_values[i] = @run_attribute_values[i]
          i += 1
        end
        @run_starts = new_run_starts
        @run_attributes = new_run_attributes
        @run_attribute_values = new_run_attribute_values
        @run_array_size = new_array_size
      end
      # make copies of the attribute information of the old run that the new one used to be part of
      # use temporary variables so things remain consistent in case of an exception
      new_run_attributes = nil
      new_run_attribute_values = nil
      if (copy_attrs)
        old_run_attributes = @run_attributes[run_index - 1]
        old_run_attribute_values = @run_attribute_values[run_index - 1]
        if (!(old_run_attributes).nil?)
          new_run_attributes = old_run_attributes.clone
        end
        if (!(old_run_attribute_values).nil?)
          new_run_attribute_values = old_run_attribute_values.clone
        end
      end
      # now actually break up the run
      @run_count += 1
      i = @run_count - 1
      while i > run_index
        @run_starts[i] = @run_starts[i - 1]
        @run_attributes[i] = @run_attributes[i - 1]
        @run_attribute_values[i] = @run_attribute_values[i - 1]
        i -= 1
      end
      @run_starts[run_index] = offset
      @run_attributes[run_index] = new_run_attributes
      @run_attribute_values[run_index] = new_run_attribute_values
      return run_index
    end
    
    typesig { [Attribute, Object, ::Java::Int, ::Java::Int] }
    # add the attribute attribute/value to all runs where beginRunIndex <= runIndex < endRunIndex
    def add_attribute_run_data(attribute, value, begin_run_index, end_run_index)
      i = begin_run_index
      while i < end_run_index
        key_value_index = -1 # index of key and value in our vectors; assume we don't have an entry yet
        if ((@run_attributes[i]).nil?)
          new_run_attributes = Vector.new
          new_run_attribute_values = Vector.new
          @run_attributes[i] = new_run_attributes
          @run_attribute_values[i] = new_run_attribute_values
        else
          # check whether we have an entry already
          key_value_index = @run_attributes[i].index_of(attribute)
        end
        if ((key_value_index).equal?(-1))
          # create new entry
          old_size = @run_attributes[i].size
          @run_attributes[i].add_element(attribute)
          begin
            @run_attribute_values[i].add_element(value)
          rescue JavaException => e
            @run_attributes[i].set_size(old_size)
            @run_attribute_values[i].set_size(old_size)
          end
        else
          # update existing entry
          @run_attribute_values[i].set(key_value_index, value)
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Creates an AttributedCharacterIterator instance that provides access to the entire contents of
    # this string.
    # 
    # @return An iterator providing access to the text and its attributes.
    def get_iterator
      return get_iterator(nil, 0, length)
    end
    
    typesig { [Array.typed(Attribute)] }
    # Creates an AttributedCharacterIterator instance that provides access to
    # selected contents of this string.
    # Information about attributes not listed in attributes that the
    # implementor may have need not be made accessible through the iterator.
    # If the list is null, all available attribute information should be made
    # accessible.
    # 
    # @param attributes a list of attributes that the client is interested in
    # @return an iterator providing access to the entire text and its selected attributes
    def get_iterator(attributes)
      return get_iterator(attributes, 0, length)
    end
    
    typesig { [Array.typed(Attribute), ::Java::Int, ::Java::Int] }
    # Creates an AttributedCharacterIterator instance that provides access to
    # selected contents of this string.
    # Information about attributes not listed in attributes that the
    # implementor may have need not be made accessible through the iterator.
    # If the list is null, all available attribute information should be made
    # accessible.
    # 
    # @param attributes a list of attributes that the client is interested in
    # @param beginIndex the index of the first character
    # @param endIndex the index of the character following the last character
    # @return an iterator providing access to the text and its attributes
    # @exception IllegalArgumentException if beginIndex is less then 0,
    # endIndex is greater than the length of the string, or beginIndex is
    # greater than endIndex.
    def get_iterator(attributes, begin_index, end_index)
      return AttributedStringIterator.new_local(self, attributes, begin_index, end_index)
    end
    
    typesig { [] }
    # all (with the exception of length) reading operations are private,
    # since AttributedString instances are accessed through iterators.
    # length is package private so that CharacterIteratorFieldDelegate can
    # access it without creating an AttributedCharacterIterator.
    def length
      return @text.length
    end
    
    typesig { [::Java::Int] }
    def char_at(index)
      return @text.char_at(index)
    end
    
    typesig { [Attribute, ::Java::Int] }
    def get_attribute(attribute, run_index)
      synchronized(self) do
        current_run_attributes = @run_attributes[run_index]
        current_run_attribute_values = @run_attribute_values[run_index]
        if ((current_run_attributes).nil?)
          return nil
        end
        attribute_index = current_run_attributes.index_of(attribute)
        if (!(attribute_index).equal?(-1))
          return current_run_attribute_values.element_at(attribute_index)
        else
          return nil
        end
      end
    end
    
    typesig { [Attribute, ::Java::Int, ::Java::Int, ::Java::Int] }
    # gets an attribute value, but returns an annotation only if it's range does not extend outside the range beginIndex..endIndex
    def get_attribute_check_range(attribute, run_index, begin_index, end_index)
      value = get_attribute(attribute, run_index)
      if (value.is_a?(Annotation))
        # need to check whether the annotation's range extends outside the iterator's range
        if (begin_index > 0)
          curr_index = run_index
          run_start = @run_starts[curr_index]
          while (run_start >= begin_index && values_match(value, get_attribute(attribute, curr_index - 1)))
            curr_index -= 1
            run_start = @run_starts[curr_index]
          end
          if (run_start < begin_index)
            # annotation's range starts before iterator's range
            return nil
          end
        end
        text_length = length
        if (end_index < text_length)
          curr_index = run_index
          run_limit = (curr_index < @run_count - 1) ? @run_starts[curr_index + 1] : text_length
          while (run_limit <= end_index && values_match(value, get_attribute(attribute, curr_index + 1)))
            curr_index += 1
            run_limit = (curr_index < @run_count - 1) ? @run_starts[curr_index + 1] : text_length
          end
          if (run_limit > end_index)
            # annotation's range ends after iterator's range
            return nil
          end
        end
        # annotation's range is subrange of iterator's range,
        # so we can return the value
      end
      return value
    end
    
    typesig { [JavaSet, ::Java::Int, ::Java::Int] }
    # returns whether all specified attributes have equal values in the runs with the given indices
    def attribute_values_match(attributes, run_index1, run_index2)
      iterator_ = attributes.iterator
      while (iterator_.has_next)
        key = iterator_.next_
        if (!values_match(get_attribute(key, run_index1), get_attribute(key, run_index2)))
          return false
        end
      end
      return true
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # returns whether the two objects are either both null or equal
      def values_match(value1, value2)
        if ((value1).nil?)
          return (value2).nil?
        else
          return (value1 == value2)
        end
      end
    }
    
    typesig { [StringBuffer, CharacterIterator] }
    # Appends the contents of the CharacterIterator iterator into the
    # StringBuffer buf.
    def append_contents(buf, iterator_)
      index = iterator_.get_begin_index
      end_ = iterator_.get_end_index
      while (index < end_)
        iterator_.set_index(((index += 1) - 1))
        buf.append(iterator_.current)
      end
    end
    
    typesig { [Map, ::Java::Int] }
    # Sets the attributes for the range from offset to the next run break
    # (typically the end of the text) to the ones specified in attrs.
    # This is only meant to be called from the constructor!
    def set_attributes(attrs, offset)
      if ((@run_count).equal?(0))
        create_run_attribute_data_vectors
      end
      index = ensure_run_break(offset, false)
      size_ = 0
      if (!(attrs).nil? && (size_ = attrs.size) > 0)
        run_attrs = Vector.new(size_)
        run_values = Vector.new(size_)
        iterator_ = attrs.entry_set.iterator
        while (iterator_.has_next)
          entry = iterator_.next_
          run_attrs.add(entry.get_key)
          run_values.add(entry.get_value)
        end
        @run_attributes[index] = run_attrs
        @run_attribute_values[index] = run_values
      end
    end
    
    class_module.module_eval {
      typesig { [Map, Map] }
      # Returns true if the attributes specified in last and attrs differ.
      def maps_differ(last, attrs)
        if ((last).nil?)
          return (!(attrs).nil? && attrs.size > 0)
        end
        return (!(last == attrs))
      end
      
      # the iterator class associated with this string class
      const_set_lazy(:AttributedStringIterator) { Class.new do
        extend LocalClass
        include_class_members AttributedString
        include AttributedCharacterIterator
        
        # note on synchronization:
        # we don't synchronize on the iterator, assuming that an iterator is only used in one thread.
        # we do synchronize access to the AttributedString however, since it's more likely to be shared between threads.
        # start and end index for our iteration
        attr_accessor :begin_index
        alias_method :attr_begin_index, :begin_index
        undef_method :begin_index
        alias_method :attr_begin_index=, :begin_index=
        undef_method :begin_index=
        
        attr_accessor :end_index
        alias_method :attr_end_index, :end_index
        undef_method :end_index
        alias_method :attr_end_index=, :end_index=
        undef_method :end_index=
        
        # attributes that our client is interested in
        attr_accessor :relevant_attributes
        alias_method :attr_relevant_attributes, :relevant_attributes
        undef_method :relevant_attributes
        alias_method :attr_relevant_attributes=, :relevant_attributes=
        undef_method :relevant_attributes=
        
        # the current index for our iteration
        # invariant: beginIndex <= currentIndex <= endIndex
        attr_accessor :current_index
        alias_method :attr_current_index, :current_index
        undef_method :current_index
        alias_method :attr_current_index=, :current_index=
        undef_method :current_index=
        
        # information about the run that includes currentIndex
        attr_accessor :current_run_index
        alias_method :attr_current_run_index, :current_run_index
        undef_method :current_run_index
        alias_method :attr_current_run_index=, :current_run_index=
        undef_method :current_run_index=
        
        attr_accessor :current_run_start
        alias_method :attr_current_run_start, :current_run_start
        undef_method :current_run_start
        alias_method :attr_current_run_start=, :current_run_start=
        undef_method :current_run_start=
        
        attr_accessor :current_run_limit
        alias_method :attr_current_run_limit, :current_run_limit
        undef_method :current_run_limit
        alias_method :attr_current_run_limit=, :current_run_limit=
        undef_method :current_run_limit=
        
        typesig { [Array.typed(class_self::Attribute), ::Java::Int, ::Java::Int] }
        # constructor
        def initialize(attributes, begin_index, end_index)
          @begin_index = 0
          @end_index = 0
          @relevant_attributes = nil
          @current_index = 0
          @current_run_index = 0
          @current_run_start = 0
          @current_run_limit = 0
          if (begin_index < 0 || begin_index > end_index || end_index > length)
            raise self.class::IllegalArgumentException.new("Invalid substring range")
          end
          @begin_index = begin_index
          @end_index = end_index
          @current_index = begin_index
          update_run_info
          if (!(attributes).nil?)
            @relevant_attributes = attributes.clone
          end
        end
        
        typesig { [Object] }
        # Object methods. See documentation in that class.
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if (!(obj.is_a?(self.class::AttributedStringIterator)))
            return false
          end
          that = obj
          if (!(@local_class_parent).equal?(that.get_string))
            return false
          end
          if (!(@current_index).equal?(that.attr_current_index) || !(@begin_index).equal?(that.attr_begin_index) || !(@end_index).equal?(that.attr_end_index))
            return false
          end
          return true
        end
        
        typesig { [] }
        def hash_code
          return self.attr_text.hash_code ^ @current_index ^ @begin_index ^ @end_index
        end
        
        typesig { [] }
        def clone
          begin
            other = super
            return other
          rescue self.class::CloneNotSupportedException => e
            raise self.class::InternalError.new
          end
        end
        
        typesig { [] }
        # CharacterIterator methods. See documentation in that interface.
        def first
          return internal_set_index(@begin_index)
        end
        
        typesig { [] }
        def last
          if ((@end_index).equal?(@begin_index))
            return internal_set_index(@end_index)
          else
            return internal_set_index(@end_index - 1)
          end
        end
        
        typesig { [] }
        def current
          if ((@current_index).equal?(@end_index))
            return DONE
          else
            return char_at(@current_index)
          end
        end
        
        typesig { [] }
        def next_
          if (@current_index < @end_index)
            return internal_set_index(@current_index + 1)
          else
            return DONE
          end
        end
        
        typesig { [] }
        def previous
          if (@current_index > @begin_index)
            return internal_set_index(@current_index - 1)
          else
            return DONE
          end
        end
        
        typesig { [::Java::Int] }
        def set_index(position)
          if (position < @begin_index || position > @end_index)
            raise self.class::IllegalArgumentException.new("Invalid index")
          end
          return internal_set_index(position)
        end
        
        typesig { [] }
        def get_begin_index
          return @begin_index
        end
        
        typesig { [] }
        def get_end_index
          return @end_index
        end
        
        typesig { [] }
        def get_index
          return @current_index
        end
        
        typesig { [] }
        # AttributedCharacterIterator methods. See documentation in that interface.
        def get_run_start
          return @current_run_start
        end
        
        typesig { [class_self::Attribute] }
        def get_run_start(attribute)
          if ((@current_run_start).equal?(@begin_index) || (@current_run_index).equal?(-1))
            return @current_run_start
          else
            value = get_attribute(attribute)
            run_start = @current_run_start
            run_index = @current_run_index
            while (run_start > @begin_index && values_match(value, @local_class_parent.get_attribute(attribute, run_index - 1)))
              run_index -= 1
              run_start = self.attr_run_starts[run_index]
            end
            if (run_start < @begin_index)
              run_start = @begin_index
            end
            return run_start
          end
        end
        
        typesig { [class_self::JavaSet] }
        def get_run_start(attributes)
          if ((@current_run_start).equal?(@begin_index) || (@current_run_index).equal?(-1))
            return @current_run_start
          else
            run_start = @current_run_start
            run_index = @current_run_index
            while (run_start > @begin_index && @local_class_parent.attribute_values_match(attributes, @current_run_index, run_index - 1))
              run_index -= 1
              run_start = self.attr_run_starts[run_index]
            end
            if (run_start < @begin_index)
              run_start = @begin_index
            end
            return run_start
          end
        end
        
        typesig { [] }
        def get_run_limit
          return @current_run_limit
        end
        
        typesig { [class_self::Attribute] }
        def get_run_limit(attribute)
          if ((@current_run_limit).equal?(@end_index) || (@current_run_index).equal?(-1))
            return @current_run_limit
          else
            value = get_attribute(attribute)
            run_limit = @current_run_limit
            run_index = @current_run_index
            while (run_limit < @end_index && values_match(value, @local_class_parent.get_attribute(attribute, run_index + 1)))
              run_index += 1
              run_limit = run_index < self.attr_run_count - 1 ? self.attr_run_starts[run_index + 1] : @end_index
            end
            if (run_limit > @end_index)
              run_limit = @end_index
            end
            return run_limit
          end
        end
        
        typesig { [class_self::JavaSet] }
        def get_run_limit(attributes)
          if ((@current_run_limit).equal?(@end_index) || (@current_run_index).equal?(-1))
            return @current_run_limit
          else
            run_limit = @current_run_limit
            run_index = @current_run_index
            while (run_limit < @end_index && @local_class_parent.attribute_values_match(attributes, @current_run_index, run_index + 1))
              run_index += 1
              run_limit = run_index < self.attr_run_count - 1 ? self.attr_run_starts[run_index + 1] : @end_index
            end
            if (run_limit > @end_index)
              run_limit = @end_index
            end
            return run_limit
          end
        end
        
        typesig { [] }
        def get_attributes
          if ((self.attr_run_attributes).nil? || (@current_run_index).equal?(-1) || (self.attr_run_attributes[@current_run_index]).nil?)
            # ??? would be nice to return null, but current spec doesn't allow it
            # returning Hashtable saves AttributeMap from dealing with emptiness
            return self.class::Hashtable.new
          end
          return self.class::AttributeMap.new(@current_run_index, @begin_index, @end_index)
        end
        
        typesig { [] }
        def get_all_attribute_keys
          # ??? This should screen out attribute keys that aren't relevant to the client
          if ((self.attr_run_attributes).nil?)
            # ??? would be nice to return null, but current spec doesn't allow it
            # returning HashSet saves us from dealing with emptiness
            return self.class::HashSet.new
          end
          synchronized((@local_class_parent)) do
            # ??? should try to create this only once, then update if necessary,
            # and give callers read-only view
            keys = self.class::HashSet.new
            i = 0
            while (i < self.attr_run_count)
              if (self.attr_run_starts[i] < @end_index && ((i).equal?(self.attr_run_count - 1) || self.attr_run_starts[i + 1] > @begin_index))
                current_run_attributes = self.attr_run_attributes[i]
                if (!(current_run_attributes).nil?)
                  j = current_run_attributes.size
                  while (((j -= 1) + 1) > 0)
                    keys.add(current_run_attributes.get(j))
                  end
                end
              end
              i += 1
            end
            return keys
          end
        end
        
        typesig { [class_self::Attribute] }
        def get_attribute(attribute)
          run_index = @current_run_index
          if (run_index < 0)
            return nil
          end
          return @local_class_parent.get_attribute_check_range(attribute, run_index, @begin_index, @end_index)
        end
        
        typesig { [] }
        # internally used methods
        def get_string
          return @local_class_parent
        end
        
        typesig { [::Java::Int] }
        # set the current index, update information about the current run if necessary,
        # return the character at the current index
        def internal_set_index(position)
          @current_index = position
          if (position < @current_run_start || position >= @current_run_limit)
            update_run_info
          end
          if ((@current_index).equal?(@end_index))
            return DONE
          else
            return char_at(position)
          end
        end
        
        typesig { [] }
        # update the information about the current run
        def update_run_info
          if ((@current_index).equal?(@end_index))
            @current_run_start = @current_run_limit = @end_index
            @current_run_index = -1
          else
            synchronized((@local_class_parent)) do
              run_index = -1
              while (run_index < self.attr_run_count - 1 && self.attr_run_starts[run_index + 1] <= @current_index)
                run_index += 1
              end
              @current_run_index = run_index
              if (run_index >= 0)
                @current_run_start = self.attr_run_starts[run_index]
                if (@current_run_start < @begin_index)
                  @current_run_start = @begin_index
                end
              else
                @current_run_start = @begin_index
              end
              if (run_index < self.attr_run_count - 1)
                @current_run_limit = self.attr_run_starts[run_index + 1]
                if (@current_run_limit > @end_index)
                  @current_run_limit = @end_index
                end
              else
                @current_run_limit = @end_index
              end
            end
          end
        end
        
        private
        alias_method :initialize__attributed_string_iterator, :initialize
      end }
      
      # the map class associated with this string class, giving access to the attributes of one run
      const_set_lazy(:AttributeMap) { Class.new(AbstractMap) do
        extend LocalClass
        include_class_members AttributedString
        
        attr_accessor :run_index
        alias_method :attr_run_index, :run_index
        undef_method :run_index
        alias_method :attr_run_index=, :run_index=
        undef_method :run_index=
        
        attr_accessor :begin_index
        alias_method :attr_begin_index, :begin_index
        undef_method :begin_index
        alias_method :attr_begin_index=, :begin_index=
        undef_method :begin_index=
        
        attr_accessor :end_index
        alias_method :attr_end_index, :end_index
        undef_method :end_index
        alias_method :attr_end_index=, :end_index=
        undef_method :end_index=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(run_index, begin_index, end_index)
          @run_index = 0
          @begin_index = 0
          @end_index = 0
          super()
          @run_index = run_index
          @begin_index = begin_index
          @end_index = end_index
        end
        
        typesig { [] }
        def entry_set
          set = self.class::HashSet.new
          synchronized((@local_class_parent)) do
            size = self.attr_run_attributes[@run_index].size
            i = 0
            while i < size
              key = self.attr_run_attributes[@run_index].get(i)
              value = self.attr_run_attribute_values[@run_index].get(i)
              if (value.is_a?(self.class::Annotation))
                value = @local_class_parent.get_attribute_check_range(key, @run_index, @begin_index, @end_index)
                if ((value).nil?)
                  i += 1
                  next
                end
              end
              entry = self.class::AttributeEntry.new(key, value)
              set.add(entry)
              i += 1
            end
          end
          return set
        end
        
        typesig { [Object] }
        def get(key)
          return @local_class_parent.get_attribute_check_range(key, @run_index, @begin_index, @end_index)
        end
        
        private
        alias_method :initialize__attribute_map, :initialize
      end }
    }
    
    private
    alias_method :initialize__attributed_string, :initialize
  end
  
  class AttributeEntry 
    include_class_members AttributedStringImports
    include Map::Entry
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [Attribute, Object] }
    def initialize(key, value)
      @key = nil
      @value = nil
      @key = key
      @value = value
    end
    
    typesig { [Object] }
    def ==(o)
      if (!(o.is_a?(AttributeEntry)))
        return false
      end
      other = o
      return (other.attr_key == @key) && ((@value).nil? ? (other.attr_value).nil? : (other.attr_value == @value))
    end
    
    typesig { [] }
    def get_key
      return @key
    end
    
    typesig { [] }
    def get_value
      return @value
    end
    
    typesig { [Object] }
    def set_value(new_value)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def hash_code
      return @key.hash_code ^ ((@value).nil? ? 0 : @value.hash_code)
    end
    
    typesig { [] }
    def to_s
      return RJava.cast_to_string(@key.to_s) + "=" + RJava.cast_to_string(@value.to_s)
    end
    
    private
    alias_method :initialize__attribute_entry, :initialize
  end
  
end

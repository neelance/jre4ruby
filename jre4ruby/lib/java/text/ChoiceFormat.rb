require "rjava"

# 
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
  module ChoiceFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Util, :Arrays
    }
  end
  
  # 
  # A <code>ChoiceFormat</code> allows you to attach a format to a range of numbers.
  # It is generally used in a <code>MessageFormat</code> for handling plurals.
  # The choice is specified with an ascending list of doubles, where each item
  # specifies a half-open interval up to the next item:
  # <blockquote>
  # <pre>
  # X matches j if and only if limit[j] &lt;= X &lt; limit[j+1]
  # </pre>
  # </blockquote>
  # If there is no match, then either the first or last index is used, depending
  # on whether the number (X) is too low or too high.  If the limit array is not
  # in ascending order, the results of formatting will be incorrect.  ChoiceFormat
  # also accepts <code>&#92;u221E</code> as equivalent to infinity(INF).
  # 
  # <p>
  # <strong>Note:</strong>
  # <code>ChoiceFormat</code> differs from the other <code>Format</code>
  # classes in that you create a <code>ChoiceFormat</code> object with a
  # constructor (not with a <code>getInstance</code> style factory
  # method). The factory methods aren't necessary because <code>ChoiceFormat</code>
  # doesn't require any complex setup for a given locale. In fact,
  # <code>ChoiceFormat</code> doesn't implement any locale specific behavior.
  # 
  # <p>
  # When creating a <code>ChoiceFormat</code>, you must specify an array of formats
  # and an array of limits. The length of these arrays must be the same.
  # For example,
  # <ul>
  # <li>
  # <em>limits</em> = {1,2,3,4,5,6,7}<br>
  # <em>formats</em> = {"Sun","Mon","Tue","Wed","Thur","Fri","Sat"}
  # <li>
  # <em>limits</em> = {0, 1, ChoiceFormat.nextDouble(1)}<br>
  # <em>formats</em> = {"no files", "one file", "many files"}<br>
  # (<code>nextDouble</code> can be used to get the next higher double, to
  # make the half-open interval.)
  # </ul>
  # 
  # <p>
  # Here is a simple example that shows formatting and parsing:
  # <blockquote>
  # <pre>
  # double[] limits = {1,2,3,4,5,6,7};
  # String[] dayOfWeekNames = {"Sun","Mon","Tue","Wed","Thur","Fri","Sat"};
  # ChoiceFormat form = new ChoiceFormat(limits, dayOfWeekNames);
  # ParsePosition status = new ParsePosition(0);
  # for (double i = 0.0; i &lt;= 8.0; ++i) {
  # status.setIndex(0);
  # System.out.println(i + " -&gt; " + form.format(i) + " -&gt; "
  # + form.parse(form.format(i),status));
  # }
  # </pre>
  # </blockquote>
  # Here is a more complex example, with a pattern format:
  # <blockquote>
  # <pre>
  # double[] filelimits = {0,1,2};
  # String[] filepart = {"are no files","is one file","are {2} files"};
  # ChoiceFormat fileform = new ChoiceFormat(filelimits, filepart);
  # Format[] testFormats = {fileform, null, NumberFormat.getInstance()};
  # MessageFormat pattform = new MessageFormat("There {0} on {1}");
  # pattform.setFormats(testFormats);
  # Object[] testArgs = {null, "ADisk", null};
  # for (int i = 0; i &lt; 4; ++i) {
  # testArgs[0] = new Integer(i);
  # testArgs[2] = testArgs[0];
  # System.out.println(pattform.format(testArgs));
  # }
  # </pre>
  # </blockquote>
  # <p>
  # Specifying a pattern for ChoiceFormat objects is fairly straightforward.
  # For example:
  # <blockquote>
  # <pre>
  # ChoiceFormat fmt = new ChoiceFormat(
  # "-1#is negative| 0#is zero or fraction | 1#is one |1.0&lt;is 1+ |2#is two |2&lt;is more than 2.");
  # System.out.println("Formatter Pattern : " + fmt.toPattern());
  # 
  # System.out.println("Format with -INF : " + fmt.format(Double.NEGATIVE_INFINITY));
  # System.out.println("Format with -1.0 : " + fmt.format(-1.0));
  # System.out.println("Format with 0 : " + fmt.format(0));
  # System.out.println("Format with 0.9 : " + fmt.format(0.9));
  # System.out.println("Format with 1.0 : " + fmt.format(1));
  # System.out.println("Format with 1.5 : " + fmt.format(1.5));
  # System.out.println("Format with 2 : " + fmt.format(2));
  # System.out.println("Format with 2.1 : " + fmt.format(2.1));
  # System.out.println("Format with NaN : " + fmt.format(Double.NaN));
  # System.out.println("Format with +INF : " + fmt.format(Double.POSITIVE_INFINITY));
  # </pre>
  # </blockquote>
  # And the output result would be like the following:
  # <pre>
  # <blockquote>
  # Format with -INF : is negative
  # Format with -1.0 : is negative
  # Format with 0 : is zero or fraction
  # Format with 0.9 : is zero or fraction
  # Format with 1.0 : is one
  # Format with 1.5 : is 1+
  # Format with 2 : is two
  # Format with 2.1 : is more than 2.
  # Format with NaN : is negative
  # Format with +INF : is more than 2.
  # </pre>
  # </blockquote>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Choice formats are not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # 
  # @see          DecimalFormat
  # @see          MessageFormat
  # @author       Mark Davis
  class ChoiceFormat < ChoiceFormatImports.const_get :NumberFormat
    include_class_members ChoiceFormatImports
    
    class_module.module_eval {
      # Proclaim serial compatibility with 1.1 FCS
      const_set_lazy(:SerialVersionUID) { 1795184449645032964 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # 
    # Sets the pattern.
    # @param newPattern See the class description.
    def apply_pattern(new_pattern)
      segments = Array.typed(StringBuffer).new(2) { nil }
      i = 0
      while i < segments.attr_length
        segments[i] = StringBuffer.new
        (i += 1)
      end
      new_choice_limits = Array.typed(::Java::Double).new(30) { 0.0 }
      new_choice_formats = Array.typed(String).new(30) { nil }
      count = 0
      part = 0
      start_value = 0
      old_start_value = Double::NaN
      in_quote = false
      i_ = 0
      while i_ < new_pattern.length
        ch = new_pattern.char_at(i_)
        if ((ch).equal?(Character.new(?\'.ord)))
          # Check for "''" indicating a literal quote
          if ((i_ + 1) < new_pattern.length && (new_pattern.char_at(i_ + 1)).equal?(ch))
            segments[part].append(ch)
            (i_ += 1)
          else
            in_quote = !in_quote
          end
        else
          if (in_quote)
            segments[part].append(ch)
          else
            if ((ch).equal?(Character.new(?<.ord)) || (ch).equal?(Character.new(?#.ord)) || (ch).equal?(Character.new(0x2264)))
              if ((segments[0].length).equal?(0))
                raise IllegalArgumentException.new
              end
              begin
                temp_buffer = segments[0].to_s
                if ((temp_buffer == ("".to_u << 0x221E << "")))
                  start_value = Double::POSITIVE_INFINITY
                else
                  if ((temp_buffer == ("-".to_u << 0x221E << "")))
                    start_value = Double::NEGATIVE_INFINITY
                  else
                    start_value = Double.value_of(segments[0].to_s).double_value
                  end
                end
              rescue Exception => e
                raise IllegalArgumentException.new
              end
              if ((ch).equal?(Character.new(?<.ord)) && !(start_value).equal?(Double::POSITIVE_INFINITY) && !(start_value).equal?(Double::NEGATIVE_INFINITY))
                start_value = next_double(start_value)
              end
              if (start_value <= old_start_value)
                raise IllegalArgumentException.new
              end
              segments[0].set_length(0)
              part = 1
            else
              if ((ch).equal?(Character.new(?|.ord)))
                if ((count).equal?(new_choice_limits.attr_length))
                  new_choice_limits = double_array_size(new_choice_limits)
                  new_choice_formats = double_array_size(new_choice_formats)
                end
                new_choice_limits[count] = start_value
                new_choice_formats[count] = segments[1].to_s
                (count += 1)
                old_start_value = start_value
                segments[1].set_length(0)
                part = 0
              else
                segments[part].append(ch)
              end
            end
          end
        end
        (i_ += 1)
      end
      # clean up last one
      if ((part).equal?(1))
        if ((count).equal?(new_choice_limits.attr_length))
          new_choice_limits = double_array_size(new_choice_limits)
          new_choice_formats = double_array_size(new_choice_formats)
        end
        new_choice_limits[count] = start_value
        new_choice_formats[count] = segments[1].to_s
        (count += 1)
      end
      @choice_limits = Array.typed(::Java::Double).new(count) { 0.0 }
      System.arraycopy(new_choice_limits, 0, @choice_limits, 0, count)
      @choice_formats = Array.typed(String).new(count) { nil }
      System.arraycopy(new_choice_formats, 0, @choice_formats, 0, count)
    end
    
    typesig { [] }
    # 
    # Gets the pattern.
    def to_pattern
      result = StringBuffer.new
      i = 0
      while i < @choice_limits.attr_length
        if (!(i).equal?(0))
          result.append(Character.new(?|.ord))
        end
        # choose based upon which has less precision
        # approximate that by choosing the closest one to an integer.
        # could do better, but it's not worth it.
        less = previous_double(@choice_limits[i])
        try_less_or_equal = Math.abs(Math._ieeeremainder(@choice_limits[i], 1.0))
        try_less = Math.abs(Math._ieeeremainder(less, 1.0))
        if (try_less_or_equal < try_less)
          result.append("" + (@choice_limits[i]).to_s)
          result.append(Character.new(?#.ord))
        else
          if ((@choice_limits[i]).equal?(Double::POSITIVE_INFINITY))
            result.append(("".to_u << 0x221E << ""))
          else
            if ((@choice_limits[i]).equal?(Double::NEGATIVE_INFINITY))
              result.append(("-".to_u << 0x221E << ""))
            else
              result.append("" + (less).to_s)
            end
          end
          result.append(Character.new(?<.ord))
        end
        # Append choiceFormats[i], using quotes if there are special characters.
        # Single quotes themselves must be escaped in either case.
        text = @choice_formats[i]
        need_quote = text.index_of(Character.new(?<.ord)) >= 0 || text.index_of(Character.new(?#.ord)) >= 0 || text.index_of(Character.new(0x2264)) >= 0 || text.index_of(Character.new(?|.ord)) >= 0
        if (need_quote)
          result.append(Character.new(?\'.ord))
        end
        if (text.index_of(Character.new(?\'.ord)) < 0)
          result.append(text)
        else
          j = 0
          while j < text.length
            c = text.char_at(j)
            result.append(c)
            if ((c).equal?(Character.new(?\'.ord)))
              result.append(c)
            end
            (j += 1)
          end
        end
        if (need_quote)
          result.append(Character.new(?\'.ord))
        end
        (i += 1)
      end
      return result.to_s
    end
    
    typesig { [String] }
    # 
    # Constructs with limits and corresponding formats based on the pattern.
    # @see #applyPattern
    def initialize(new_pattern)
      @choice_limits = nil
      @choice_formats = nil
      super()
      apply_pattern(new_pattern)
    end
    
    typesig { [Array.typed(::Java::Double), Array.typed(String)] }
    # 
    # Constructs with the limits and the corresponding formats.
    # @see #setChoices
    def initialize(limits, formats)
      @choice_limits = nil
      @choice_formats = nil
      super()
      set_choices(limits, formats)
    end
    
    typesig { [Array.typed(::Java::Double), Array.typed(String)] }
    # 
    # Set the choices to be used in formatting.
    # @param limits contains the top value that you want
    # parsed with that format,and should be in ascending sorted order. When
    # formatting X, the choice will be the i, where
    # limit[i] &lt;= X &lt; limit[i+1].
    # If the limit array is not in ascending order, the results of formatting
    # will be incorrect.
    # @param formats are the formats you want to use for each limit.
    # They can be either Format objects or Strings.
    # When formatting with object Y,
    # if the object is a NumberFormat, then ((NumberFormat) Y).format(X)
    # is called. Otherwise Y.toString() is called.
    def set_choices(limits, formats)
      if (!(limits.attr_length).equal?(formats.attr_length))
        raise IllegalArgumentException.new("Array and limit arrays must be of the same length.")
      end
      @choice_limits = limits
      @choice_formats = formats
    end
    
    typesig { [] }
    # 
    # Get the limits passed in the constructor.
    # @return the limits.
    def get_limits
      return @choice_limits
    end
    
    typesig { [] }
    # 
    # Get the formats passed in the constructor.
    # @return the formats.
    def get_formats
      return @choice_formats
    end
    
    typesig { [::Java::Long, StringBuffer, FieldPosition] }
    # Overrides
    # 
    # Specialization of format. This method really calls
    # <code>format(double, StringBuffer, FieldPosition)</code>
    # thus the range of longs that are supported is only equal to
    # the range that can be stored by double. This will never be
    # a practical limitation.
    def format(number, to_append_to, status)
      return format((number).to_f, to_append_to, status)
    end
    
    typesig { [::Java::Double, StringBuffer, FieldPosition] }
    # 
    # Returns pattern with formatted double.
    # @param number number to be formatted & substituted.
    # @param toAppendTo where text is appended.
    # @param status ignore no useful status is returned.
    def format(number, to_append_to, status)
      # find the number
      i = 0
      i = 0
      while i < @choice_limits.attr_length
        if (!(number >= @choice_limits[i]))
          # same as number < choiceLimits, except catchs NaN
          break
        end
        (i += 1)
      end
      (i -= 1)
      if (i < 0)
        i = 0
      end
      # return either a formatted number, or a string
      return to_append_to.append(@choice_formats[i])
    end
    
    typesig { [String, ParsePosition] }
    # 
    # Parses a Number from the input text.
    # @param text the source text.
    # @param status an input-output parameter.  On input, the
    # status.index field indicates the first character of the
    # source text that should be parsed.  On exit, if no error
    # occured, status.index is set to the first unparsed character
    # in the source text.  On exit, if an error did occur,
    # status.index is unchanged and status.errorIndex is set to the
    # first index of the character that caused the parse to fail.
    # @return A Number representing the value of the number parsed.
    def parse(text, status)
      # find the best number (defined as the one with the longest parse)
      start = status.attr_index
      furthest = start
      best_number = Double::NaN
      temp_number = 0.0
      i = 0
      while i < @choice_formats.attr_length
        temp_string = @choice_formats[i]
        if (text.region_matches(start, temp_string, 0, temp_string.length))
          status.attr_index = start + temp_string.length
          temp_number = @choice_limits[i]
          if (status.attr_index > furthest)
            furthest = status.attr_index
            best_number = temp_number
            if ((furthest).equal?(text.length))
              break
            end
          end
        end
        (i += 1)
      end
      status.attr_index = furthest
      if ((status.attr_index).equal?(start))
        status.attr_error_index = furthest
      end
      return Double.new(best_number)
    end
    
    class_module.module_eval {
      typesig { [::Java::Double] }
      # 
      # Finds the least double greater than d.
      # If NaN, returns same value.
      # <p>Used to make half-open intervals.
      # @see #previousDouble
      def next_double(d)
        return next_double(d, true)
      end
      
      typesig { [::Java::Double] }
      # 
      # Finds the greatest double less than d.
      # If NaN, returns same value.
      # @see #nextDouble
      def previous_double(d)
        return next_double(d, false)
      end
    }
    
    typesig { [] }
    # 
    # Overrides Cloneable
    def clone
      other = super
      # for primitives or immutables, shallow clone is enough
      other.attr_choice_limits = @choice_limits.clone
      other.attr_choice_formats = @choice_formats.clone
      return other
    end
    
    typesig { [] }
    # 
    # Generates a hash code for the message format object.
    def hash_code
      result = @choice_limits.attr_length
      if (@choice_formats.attr_length > 0)
        # enough for reasonable distribution
        result ^= @choice_formats[@choice_formats.attr_length - 1].hash_code
      end
      return result
    end
    
    typesig { [Object] }
    # 
    # Equality comparision between two
    def equals(obj)
      if ((obj).nil?)
        return false
      end
      if ((self).equal?(obj))
        # quick check
        return true
      end
      if (!(get_class).equal?(obj.get_class))
        return false
      end
      other = obj
      return ((Arrays == @choice_limits) && (Arrays == @choice_formats))
    end
    
    typesig { [ObjectInputStream] }
    # 
    # After reading an object from the input stream, do a simple verification
    # to maintain class invariants.
    # @throws InvalidObjectException if the objects read from the stream is invalid.
    def read_object(in_)
      in_.default_read_object
      if (!(@choice_limits.attr_length).equal?(@choice_formats.attr_length))
        raise InvalidObjectException.new("limits and format arrays of different length.")
      end
    end
    
    # ===============privates===========================
    # 
    # A list of lower bounds for the choices.  The formatter will return
    # <code>choiceFormats[i]</code> if the number being formatted is greater than or equal to
    # <code>choiceLimits[i]</code> and less than <code>choiceLimits[i+1]</code>.
    # @serial
    attr_accessor :choice_limits
    alias_method :attr_choice_limits, :choice_limits
    undef_method :choice_limits
    alias_method :attr_choice_limits=, :choice_limits=
    undef_method :choice_limits=
    
    # 
    # A list of choice strings.  The formatter will return
    # <code>choiceFormats[i]</code> if the number being formatted is greater than or equal to
    # <code>choiceLimits[i]</code> and less than <code>choiceLimits[i+1]</code>.
    # @serial
    attr_accessor :choice_formats
    alias_method :attr_choice_formats, :choice_formats
    undef_method :choice_formats
    alias_method :attr_choice_formats=, :choice_formats=
    undef_method :choice_formats=
    
    class_module.module_eval {
      # 
      # static final long SIGN          = 0x8000000000000000L;
      # static final long EXPONENT      = 0x7FF0000000000000L;
      # static final long SIGNIFICAND   = 0x000FFFFFFFFFFFFFL;
      # 
      # private static double nextDouble (double d, boolean positive) {
      # if (Double.isNaN(d) || Double.isInfinite(d)) {
      # return d;
      # }
      # long bits = Double.doubleToLongBits(d);
      # long significand = bits & SIGNIFICAND;
      # if (bits < 0) {
      # significand |= (SIGN | EXPONENT);
      # }
      # long exponent = bits & EXPONENT;
      # if (positive) {
      # significand += 1;
      # // FIXME fix overflow & underflow
      # } else {
      # significand -= 1;
      # // FIXME fix overflow & underflow
      # }
      # bits = exponent | (significand & ~EXPONENT);
      # return Double.longBitsToDouble(bits);
      # }
      const_set_lazy(:SIGN) { -0x8000000000000000 }
      const_attr_reader  :SIGN
      
      const_set_lazy(:EXPONENT) { 0x7ff0000000000000 }
      const_attr_reader  :EXPONENT
      
      const_set_lazy(:POSITIVEINFINITY) { 0x7ff0000000000000 }
      const_attr_reader  :POSITIVEINFINITY
      
      typesig { [::Java::Double, ::Java::Boolean] }
      # 
      # Finds the least double greater than d (if positive == true),
      # or the greatest double less than d (if positive == false).
      # If NaN, returns same value.
      # 
      # Does not affect floating-point flags,
      # provided these member functions do not:
      # Double.longBitsToDouble(long)
      # Double.doubleToLongBits(double)
      # Double.isNaN(double)
      def next_double(d, positive)
        # filter out NaN's
        if (Double.is_na_n(d))
          return d
        end
        # zero's are also a special case
        if ((d).equal?(0.0))
          smallest_positive_double = Double.long_bits_to_double(1)
          if (positive)
            return smallest_positive_double
          else
            return -smallest_positive_double
          end
        end
        # if entering here, d is a nonzero value
        # hold all bits in a long for later use
        bits = Double.double_to_long_bits(d)
        # strip off the sign bit
        magnitude = bits & ~SIGN
        # if next double away from zero, increase magnitude
        if (((bits > 0)).equal?(positive))
          if (!(magnitude).equal?(POSITIVEINFINITY))
            magnitude += 1
          end
        # else decrease magnitude
        else
          magnitude -= 1
        end
        # restore sign bit and return
        signbit = bits & SIGN
        return Double.long_bits_to_double(magnitude | signbit)
      end
      
      typesig { [Array.typed(::Java::Double)] }
      def double_array_size(array)
        old_size = array.attr_length
        new_array = Array.typed(::Java::Double).new(old_size * 2) { 0.0 }
        System.arraycopy(array, 0, new_array, 0, old_size)
        return new_array
      end
    }
    
    typesig { [Array.typed(String)] }
    def double_array_size(array)
      old_size = array.attr_length
      new_array = Array.typed(String).new(old_size * 2) { nil }
      System.arraycopy(array, 0, new_array, 0, old_size)
      return new_array
    end
    
    private
    alias_method :initialize__choice_format, :initialize
  end
  
end

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
  module MessageFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Text, :DecimalFormat
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
    }
  end
  
  # <code>MessageFormat</code> provides a means to produce concatenated
  # messages in a language-neutral way. Use this to construct messages
  # displayed for end users.
  # 
  # <p>
  # <code>MessageFormat</code> takes a set of objects, formats them, then
  # inserts the formatted strings into the pattern at the appropriate places.
  # 
  # <p>
  # <strong>Note:</strong>
  # <code>MessageFormat</code> differs from the other <code>Format</code>
  # classes in that you create a <code>MessageFormat</code> object with one
  # of its constructors (not with a <code>getInstance</code> style factory
  # method). The factory methods aren't necessary because <code>MessageFormat</code>
  # itself doesn't implement locale specific behavior. Any locale specific
  # behavior is defined by the pattern that you provide as well as the
  # subformats used for inserted arguments.
  # 
  # <h4><a name="patterns">Patterns and Their Interpretation</a></h4>
  # 
  # <code>MessageFormat</code> uses patterns of the following form:
  # <blockquote><pre>
  # <i>MessageFormatPattern:</i>
  # <i>String</i>
  # <i>MessageFormatPattern</i> <i>FormatElement</i> <i>String</i>
  # 
  # <i>FormatElement:</i>
  # { <i>ArgumentIndex</i> }
  # { <i>ArgumentIndex</i> , <i>FormatType</i> }
  # { <i>ArgumentIndex</i> , <i>FormatType</i> , <i>FormatStyle</i> }
  # 
  # <i>FormatType: one of </i>
  # number date time choice
  # 
  # <i>FormatStyle:</i>
  # short
  # medium
  # long
  # full
  # integer
  # currency
  # percent
  # <i>SubformatPattern</i>
  # 
  # <i>String:</i>
  # <i>StringPart<sub>opt</sub></i>
  # <i>String</i> <i>StringPart</i>
  # 
  # <i>StringPart:</i>
  # ''
  # ' <i>QuotedString</i> '
  # <i>UnquotedString</i>
  # 
  # <i>SubformatPattern:</i>
  # <i>SubformatPatternPart<sub>opt</sub></i>
  # <i>SubformatPattern</i> <i>SubformatPatternPart</i>
  # 
  # <i>SubFormatPatternPart:</i>
  # ' <i>QuotedPattern</i> '
  # <i>UnquotedPattern</i>
  # </pre></blockquote>
  # 
  # <p>
  # Within a <i>String</i>, <code>"''"</code> represents a single
  # quote. A <i>QuotedString</i> can contain arbitrary characters
  # except single quotes; the surrounding single quotes are removed.
  # An <i>UnquotedString</i> can contain arbitrary characters
  # except single quotes and left curly brackets. Thus, a string that
  # should result in the formatted message "'{0}'" can be written as
  # <code>"'''{'0}''"</code> or <code>"'''{0}'''"</code>.
  # <p>
  # Within a <i>SubformatPattern</i>, different rules apply.
  # A <i>QuotedPattern</i> can contain arbitrary characters
  # except single quotes; but the surrounding single quotes are
  # <strong>not</strong> removed, so they may be interpreted by the
  # subformat. For example, <code>"{1,number,$'#',##}"</code> will
  # produce a number format with the pound-sign quoted, with a result
  # such as: "$#31,45".
  # An <i>UnquotedPattern</i> can contain arbitrary characters
  # except single quotes, but curly braces within it must be balanced.
  # For example, <code>"ab {0} de"</code> and <code>"ab '}' de"</code>
  # are valid subformat patterns, but <code>"ab {0'}' de"</code> and
  # <code>"ab } de"</code> are not.
  # <p>
  # <dl><dt><b>Warning:</b><dd>The rules for using quotes within message
  # format patterns unfortunately have shown to be somewhat confusing.
  # In particular, it isn't always obvious to localizers whether single
  # quotes need to be doubled or not. Make sure to inform localizers about
  # the rules, and tell them (for example, by using comments in resource
  # bundle source files) which strings will be processed by MessageFormat.
  # Note that localizers may need to use single quotes in translated
  # strings where the original version doesn't have them.
  # </dl>
  # <p>
  # The <i>ArgumentIndex</i> value is a non-negative integer written
  # using the digits '0' through '9', and represents an index into the
  # <code>arguments</code> array passed to the <code>format</code> methods
  # or the result array returned by the <code>parse</code> methods.
  # <p>
  # The <i>FormatType</i> and <i>FormatStyle</i> values are used to create
  # a <code>Format</code> instance for the format element. The following
  # table shows how the values map to Format instances. Combinations not
  # shown in the table are illegal. A <i>SubformatPattern</i> must
  # be a valid pattern string for the Format subclass used.
  # <p>
  # <table border=1 summary="Shows how FormatType and FormatStyle values map to Format instances">
  # <tr>
  # <th id="ft">Format Type
  # <th id="fs">Format Style
  # <th id="sc">Subformat Created
  # <tr>
  # <td headers="ft"><i>(none)</i>
  # <td headers="fs"><i>(none)</i>
  # <td headers="sc"><code>null</code>
  # <tr>
  # <td headers="ft" rowspan=5><code>number</code>
  # <td headers="fs"><i>(none)</i>
  # <td headers="sc"><code>NumberFormat.getInstance(getLocale())</code>
  # <tr>
  # <td headers="fs"><code>integer</code>
  # <td headers="sc"><code>NumberFormat.getIntegerInstance(getLocale())</code>
  # <tr>
  # <td headers="fs"><code>currency</code>
  # <td headers="sc"><code>NumberFormat.getCurrencyInstance(getLocale())</code>
  # <tr>
  # <td headers="fs"><code>percent</code>
  # <td headers="sc"><code>NumberFormat.getPercentInstance(getLocale())</code>
  # <tr>
  # <td headers="fs"><i>SubformatPattern</i>
  # <td headers="sc"><code>new DecimalFormat(subformatPattern, DecimalFormatSymbols.getInstance(getLocale()))</code>
  # <tr>
  # <td headers="ft" rowspan=6><code>date</code>
  # <td headers="fs"><i>(none)</i>
  # <td headers="sc"><code>DateFormat.getDateInstance(DateFormat.DEFAULT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>short</code>
  # <td headers="sc"><code>DateFormat.getDateInstance(DateFormat.SHORT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>medium</code>
  # <td headers="sc"><code>DateFormat.getDateInstance(DateFormat.DEFAULT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>long</code>
  # <td headers="sc"><code>DateFormat.getDateInstance(DateFormat.LONG, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>full</code>
  # <td headers="sc"><code>DateFormat.getDateInstance(DateFormat.FULL, getLocale())</code>
  # <tr>
  # <td headers="fs"><i>SubformatPattern</i>
  # <td headers="sc"><code>new SimpleDateFormat(subformatPattern, getLocale())</code>
  # <tr>
  # <td headers="ft" rowspan=6><code>time</code>
  # <td headers="fs"><i>(none)</i>
  # <td headers="sc"><code>DateFormat.getTimeInstance(DateFormat.DEFAULT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>short</code>
  # <td headers="sc"><code>DateFormat.getTimeInstance(DateFormat.SHORT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>medium</code>
  # <td headers="sc"><code>DateFormat.getTimeInstance(DateFormat.DEFAULT, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>long</code>
  # <td headers="sc"><code>DateFormat.getTimeInstance(DateFormat.LONG, getLocale())</code>
  # <tr>
  # <td headers="fs"><code>full</code>
  # <td headers="sc"><code>DateFormat.getTimeInstance(DateFormat.FULL, getLocale())</code>
  # <tr>
  # <td headers="fs"><i>SubformatPattern</i>
  # <td headers="sc"><code>new SimpleDateFormat(subformatPattern, getLocale())</code>
  # <tr>
  # <td headers="ft"><code>choice</code>
  # <td headers="fs"><i>SubformatPattern</i>
  # <td headers="sc"><code>new ChoiceFormat(subformatPattern)</code>
  # </table>
  # <p>
  # 
  # <h4>Usage Information</h4>
  # 
  # <p>
  # Here are some examples of usage.
  # In real internationalized programs, the message format pattern and other
  # static strings will, of course, be obtained from resource bundles.
  # Other parameters will be dynamically determined at runtime.
  # <p>
  # The first example uses the static method <code>MessageFormat.format</code>,
  # which internally creates a <code>MessageFormat</code> for one-time use:
  # <blockquote><pre>
  # int planet = 7;
  # String event = "a disturbance in the Force";
  # 
  # String result = MessageFormat.format(
  # "At {1,time} on {1,date}, there was {2} on planet {0,number,integer}.",
  # planet, new Date(), event);
  # </pre></blockquote>
  # The output is:
  # <blockquote><pre>
  # At 12:30 PM on Jul 3, 2053, there was a disturbance in the Force on planet 7.
  # </pre></blockquote>
  # 
  # <p>
  # The following example creates a <code>MessageFormat</code> instance that
  # can be used repeatedly:
  # <blockquote><pre>
  # int fileCount = 1273;
  # String diskName = "MyDisk";
  # Object[] testArgs = {new Long(fileCount), diskName};
  # 
  # MessageFormat form = new MessageFormat(
  # "The disk \"{1}\" contains {0} file(s).");
  # 
  # System.out.println(form.format(testArgs));
  # </pre></blockquote>
  # The output with different values for <code>fileCount</code>:
  # <blockquote><pre>
  # The disk "MyDisk" contains 0 file(s).
  # The disk "MyDisk" contains 1 file(s).
  # The disk "MyDisk" contains 1,273 file(s).
  # </pre></blockquote>
  # 
  # <p>
  # For more sophisticated patterns, you can use a <code>ChoiceFormat</code>
  # to produce correct forms for singular and plural:
  # <blockquote><pre>
  # MessageFormat form = new MessageFormat("The disk \"{1}\" contains {0}.");
  # double[] filelimits = {0,1,2};
  # String[] filepart = {"no files","one file","{0,number} files"};
  # ChoiceFormat fileform = new ChoiceFormat(filelimits, filepart);
  # form.setFormatByArgumentIndex(0, fileform);
  # 
  # int fileCount = 1273;
  # String diskName = "MyDisk";
  # Object[] testArgs = {new Long(fileCount), diskName};
  # 
  # System.out.println(form.format(testArgs));
  # </pre></blockquote>
  # The output with different values for <code>fileCount</code>:
  # <blockquote><pre>
  # The disk "MyDisk" contains no files.
  # The disk "MyDisk" contains one file.
  # The disk "MyDisk" contains 1,273 files.
  # </pre></blockquote>
  # 
  # <p>
  # You can create the <code>ChoiceFormat</code> programmatically, as in the
  # above example, or by using a pattern. See {@link ChoiceFormat}
  # for more information.
  # <blockquote><pre>
  # form.applyPattern(
  # "There {0,choice,0#are no files|1#is one file|1&lt;are {0,number,integer} files}.");
  # </pre></blockquote>
  # 
  # <p>
  # <strong>Note:</strong> As we see above, the string produced
  # by a <code>ChoiceFormat</code> in <code>MessageFormat</code> is treated as special;
  # occurrences of '{' are used to indicate subformats, and cause recursion.
  # If you create both a <code>MessageFormat</code> and <code>ChoiceFormat</code>
  # programmatically (instead of using the string patterns), then be careful not to
  # produce a format that recurses on itself, which will cause an infinite loop.
  # <p>
  # When a single argument is parsed more than once in the string, the last match
  # will be the final result of the parsing.  For example,
  # <blockquote><pre>
  # MessageFormat mf = new MessageFormat("{0,number,#.##}, {0,number,#.#}");
  # Object[] objs = {new Double(3.1415)};
  # String result = mf.format( objs );
  # // result now equals "3.14, 3.1"
  # objs = null;
  # objs = mf.parse(result, new ParsePosition(0));
  # // objs now equals {new Double(3.1)}
  # </pre></blockquote>
  # 
  # <p>
  # Likewise, parsing with a MessageFormat object using patterns containing
  # multiple occurrences of the same argument would return the last match.  For
  # example,
  # <blockquote><pre>
  # MessageFormat mf = new MessageFormat("{0}, {0}, {0}");
  # String forParsing = "x, y, z";
  # Object[] objs = mf.parse(forParsing, new ParsePosition(0));
  # // result now equals {new String("z")}
  # </pre></blockquote>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Message formats are not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # @see          java.util.Locale
  # @see          Format
  # @see          NumberFormat
  # @see          DecimalFormat
  # @see          ChoiceFormat
  # @author       Mark Davis
  class MessageFormat < MessageFormatImports.const_get :Format
    include_class_members MessageFormatImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6479157306784022952 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs a MessageFormat for the default locale and the
    # specified pattern.
    # The constructor first sets the locale, then parses the pattern and
    # creates a list of subformats for the format elements contained in it.
    # Patterns and their interpretation are specified in the
    # <a href="#patterns">class description</a>.
    # 
    # @param pattern the pattern for this message format
    # @exception IllegalArgumentException if the pattern is invalid
    def initialize(pattern)
      @locale = nil
      @pattern = nil
      @formats = nil
      @offsets = nil
      @argument_numbers = nil
      @max_offset = 0
      super()
      @pattern = ""
      @formats = Array.typed(Format).new(INITIAL_FORMATS) { nil }
      @offsets = Array.typed(::Java::Int).new(INITIAL_FORMATS) { 0 }
      @argument_numbers = Array.typed(::Java::Int).new(INITIAL_FORMATS) { 0 }
      @max_offset = -1
      @locale = Locale.get_default
      apply_pattern(pattern)
    end
    
    typesig { [String, Locale] }
    # Constructs a MessageFormat for the specified locale and
    # pattern.
    # The constructor first sets the locale, then parses the pattern and
    # creates a list of subformats for the format elements contained in it.
    # Patterns and their interpretation are specified in the
    # <a href="#patterns">class description</a>.
    # 
    # @param pattern the pattern for this message format
    # @param locale the locale for this message format
    # @exception IllegalArgumentException if the pattern is invalid
    # @since 1.4
    def initialize(pattern, locale)
      @locale = nil
      @pattern = nil
      @formats = nil
      @offsets = nil
      @argument_numbers = nil
      @max_offset = 0
      super()
      @pattern = ""
      @formats = Array.typed(Format).new(INITIAL_FORMATS) { nil }
      @offsets = Array.typed(::Java::Int).new(INITIAL_FORMATS) { 0 }
      @argument_numbers = Array.typed(::Java::Int).new(INITIAL_FORMATS) { 0 }
      @max_offset = -1
      @locale = locale
      apply_pattern(pattern)
    end
    
    typesig { [Locale] }
    # Sets the locale to be used when creating or comparing subformats.
    # This affects subsequent calls
    # <ul>
    # <li>to the {@link #applyPattern applyPattern}
    # and {@link #toPattern toPattern} methods if format elements specify
    # a format type and therefore have the subformats created in the
    # <code>applyPattern</code> method, as well as
    # <li>to the <code>format</code> and
    # {@link #formatToCharacterIterator formatToCharacterIterator} methods
    # if format elements do not specify a format type and therefore have
    # the subformats created in the formatting methods.
    # </ul>
    # Subformats that have already been created are not affected.
    # 
    # @param locale the locale to be used when creating or comparing subformats
    def set_locale(locale)
      @locale = locale
    end
    
    typesig { [] }
    # Gets the locale that's used when creating or comparing subformats.
    # 
    # @return the locale used when creating or comparing subformats
    def get_locale
      return @locale
    end
    
    typesig { [String] }
    # Sets the pattern used by this message format.
    # The method parses the pattern and creates a list of subformats
    # for the format elements contained in it.
    # Patterns and their interpretation are specified in the
    # <a href="#patterns">class description</a>.
    # 
    # @param pattern the pattern for this message format
    # @exception IllegalArgumentException if the pattern is invalid
    def apply_pattern(pattern)
      segments = Array.typed(StringBuffer).new(4) { nil }
      i = 0
      while i < segments.attr_length
        segments[i] = StringBuffer.new
        (i += 1)
      end
      part = 0
      format_number = 0
      in_quote = false
      brace_stack = 0
      @max_offset = -1
      i_ = 0
      while i_ < pattern.length
        ch = pattern.char_at(i_)
        if ((part).equal?(0))
          if ((ch).equal?(Character.new(?\'.ord)))
            if (i_ + 1 < pattern.length && (pattern.char_at(i_ + 1)).equal?(Character.new(?\'.ord)))
              segments[part].append(ch) # handle doubles
              (i_ += 1)
            else
              in_quote = !in_quote
            end
          else
            if ((ch).equal?(Character.new(?{.ord)) && !in_quote)
              part = 1
            else
              segments[part].append(ch)
            end
          end
        else
          if (in_quote)
            # just copy quotes in parts
            segments[part].append(ch)
            if ((ch).equal?(Character.new(?\'.ord)))
              in_quote = false
            end
          else
            case (ch)
            # fall through, so we keep quotes in other parts
            when Character.new(?,.ord)
              if (part < 3)
                part += 1
              else
                segments[part].append(ch)
              end
            when Character.new(?{.ord)
              (brace_stack += 1)
              segments[part].append(ch)
            when Character.new(?}.ord)
              if ((brace_stack).equal?(0))
                part = 0
                make_format(i_, format_number, segments)
                format_number += 1
              else
                (brace_stack -= 1)
                segments[part].append(ch)
              end
            when Character.new(?\'.ord)
              in_quote = true
              segments[part].append(ch)
            else
              segments[part].append(ch)
            end
          end
        end
        (i_ += 1)
      end
      if ((brace_stack).equal?(0) && !(part).equal?(0))
        @max_offset = -1
        raise IllegalArgumentException.new("Unmatched braces in the pattern.")
      end
      @pattern = segments[0].to_s
    end
    
    typesig { [] }
    # Returns a pattern representing the current state of the message format.
    # The string is constructed from internal information and therefore
    # does not necessarily equal the previously applied pattern.
    # 
    # @return a pattern representing the current state of the message format
    def to_pattern
      # later, make this more extensible
      last_offset = 0
      result = StringBuffer.new
      i = 0
      while i <= @max_offset
        copy_and_fix_quotes(@pattern, last_offset, @offsets[i], result)
        last_offset = @offsets[i]
        result.append(Character.new(?{.ord))
        result.append(@argument_numbers[i])
        if ((@formats[i]).nil?)
          # do nothing, string format
        else
          if (@formats[i].is_a?(DecimalFormat))
            if ((@formats[i] == NumberFormat.get_instance(@locale)))
              result.append(",number")
            else
              if ((@formats[i] == NumberFormat.get_currency_instance(@locale)))
                result.append(",number,currency")
              else
                if ((@formats[i] == NumberFormat.get_percent_instance(@locale)))
                  result.append(",number,percent")
                else
                  if ((@formats[i] == NumberFormat.get_integer_instance(@locale)))
                    result.append(",number,integer")
                  else
                    result.append(",number," + RJava.cast_to_string((@formats[i]).to_pattern))
                  end
                end
              end
            end
          else
            if (@formats[i].is_a?(SimpleDateFormat))
              if ((@formats[i] == DateFormat.get_date_instance(DateFormat::DEFAULT, @locale)))
                result.append(",date")
              else
                if ((@formats[i] == DateFormat.get_date_instance(DateFormat::SHORT, @locale)))
                  result.append(",date,short")
                else
                  if ((@formats[i] == DateFormat.get_date_instance(DateFormat::DEFAULT, @locale)))
                    result.append(",date,medium")
                  else
                    if ((@formats[i] == DateFormat.get_date_instance(DateFormat::LONG, @locale)))
                      result.append(",date,long")
                    else
                      if ((@formats[i] == DateFormat.get_date_instance(DateFormat::FULL, @locale)))
                        result.append(",date,full")
                      else
                        if ((@formats[i] == DateFormat.get_time_instance(DateFormat::DEFAULT, @locale)))
                          result.append(",time")
                        else
                          if ((@formats[i] == DateFormat.get_time_instance(DateFormat::SHORT, @locale)))
                            result.append(",time,short")
                          else
                            if ((@formats[i] == DateFormat.get_time_instance(DateFormat::DEFAULT, @locale)))
                              result.append(",time,medium")
                            else
                              if ((@formats[i] == DateFormat.get_time_instance(DateFormat::LONG, @locale)))
                                result.append(",time,long")
                              else
                                if ((@formats[i] == DateFormat.get_time_instance(DateFormat::FULL, @locale)))
                                  result.append(",time,full")
                                else
                                  result.append(",date," + RJava.cast_to_string((@formats[i]).to_pattern))
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            else
              if (@formats[i].is_a?(ChoiceFormat))
                result.append(",choice," + RJava.cast_to_string((@formats[i]).to_pattern))
              else
                # result.append(", unknown");
              end
            end
          end
        end
        result.append(Character.new(?}.ord))
        (i += 1)
      end
      copy_and_fix_quotes(@pattern, last_offset, @pattern.length, result)
      return result.to_s
    end
    
    typesig { [Array.typed(Format)] }
    # Sets the formats to use for the values passed into
    # <code>format</code> methods or returned from <code>parse</code>
    # methods. The indices of elements in <code>newFormats</code>
    # correspond to the argument indices used in the previously set
    # pattern string.
    # The order of formats in <code>newFormats</code> thus corresponds to
    # the order of elements in the <code>arguments</code> array passed
    # to the <code>format</code> methods or the result array returned
    # by the <code>parse</code> methods.
    # <p>
    # If an argument index is used for more than one format element
    # in the pattern string, then the corresponding new format is used
    # for all such format elements. If an argument index is not used
    # for any format element in the pattern string, then the
    # corresponding new format is ignored. If fewer formats are provided
    # than needed, then only the formats for argument indices less
    # than <code>newFormats.length</code> are replaced.
    # 
    # @param newFormats the new formats to use
    # @exception NullPointerException if <code>newFormats</code> is null
    # @since 1.4
    def set_formats_by_argument_index(new_formats)
      i = 0
      while i <= @max_offset
        j = @argument_numbers[i]
        if (j < new_formats.attr_length)
          @formats[i] = new_formats[j]
        end
        i += 1
      end
    end
    
    typesig { [Array.typed(Format)] }
    # Sets the formats to use for the format elements in the
    # previously set pattern string.
    # The order of formats in <code>newFormats</code> corresponds to
    # the order of format elements in the pattern string.
    # <p>
    # If more formats are provided than needed by the pattern string,
    # the remaining ones are ignored. If fewer formats are provided
    # than needed, then only the first <code>newFormats.length</code>
    # formats are replaced.
    # <p>
    # Since the order of format elements in a pattern string often
    # changes during localization, it is generally better to use the
    # {@link #setFormatsByArgumentIndex setFormatsByArgumentIndex}
    # method, which assumes an order of formats corresponding to the
    # order of elements in the <code>arguments</code> array passed to
    # the <code>format</code> methods or the result array returned by
    # the <code>parse</code> methods.
    # 
    # @param newFormats the new formats to use
    # @exception NullPointerException if <code>newFormats</code> is null
    def set_formats(new_formats)
      runs_to_copy = new_formats.attr_length
      if (runs_to_copy > @max_offset + 1)
        runs_to_copy = @max_offset + 1
      end
      i = 0
      while i < runs_to_copy
        @formats[i] = new_formats[i]
        i += 1
      end
    end
    
    typesig { [::Java::Int, Format] }
    # Sets the format to use for the format elements within the
    # previously set pattern string that use the given argument
    # index.
    # The argument index is part of the format element definition and
    # represents an index into the <code>arguments</code> array passed
    # to the <code>format</code> methods or the result array returned
    # by the <code>parse</code> methods.
    # <p>
    # If the argument index is used for more than one format element
    # in the pattern string, then the new format is used for all such
    # format elements. If the argument index is not used for any format
    # element in the pattern string, then the new format is ignored.
    # 
    # @param argumentIndex the argument index for which to use the new format
    # @param newFormat the new format to use
    # @since 1.4
    def set_format_by_argument_index(argument_index, new_format)
      j = 0
      while j <= @max_offset
        if ((@argument_numbers[j]).equal?(argument_index))
          @formats[j] = new_format
        end
        j += 1
      end
    end
    
    typesig { [::Java::Int, Format] }
    # Sets the format to use for the format element with the given
    # format element index within the previously set pattern string.
    # The format element index is the zero-based number of the format
    # element counting from the start of the pattern string.
    # <p>
    # Since the order of format elements in a pattern string often
    # changes during localization, it is generally better to use the
    # {@link #setFormatByArgumentIndex setFormatByArgumentIndex}
    # method, which accesses format elements based on the argument
    # index they specify.
    # 
    # @param formatElementIndex the index of a format element within the pattern
    # @param newFormat the format to use for the specified format element
    # @exception ArrayIndexOutOfBoundsException if formatElementIndex is equal to or
    # larger than the number of format elements in the pattern string
    def set_format(format_element_index, new_format)
      @formats[format_element_index] = new_format
    end
    
    typesig { [] }
    # Gets the formats used for the values passed into
    # <code>format</code> methods or returned from <code>parse</code>
    # methods. The indices of elements in the returned array
    # correspond to the argument indices used in the previously set
    # pattern string.
    # The order of formats in the returned array thus corresponds to
    # the order of elements in the <code>arguments</code> array passed
    # to the <code>format</code> methods or the result array returned
    # by the <code>parse</code> methods.
    # <p>
    # If an argument index is used for more than one format element
    # in the pattern string, then the format used for the last such
    # format element is returned in the array. If an argument index
    # is not used for any format element in the pattern string, then
    # null is returned in the array.
    # 
    # @return the formats used for the arguments within the pattern
    # @since 1.4
    def get_formats_by_argument_index
      maximum_argument_number = -1
      i = 0
      while i <= @max_offset
        if (@argument_numbers[i] > maximum_argument_number)
          maximum_argument_number = @argument_numbers[i]
        end
        i += 1
      end
      result_array = Array.typed(Format).new(maximum_argument_number + 1) { nil }
      i_ = 0
      while i_ <= @max_offset
        result_array[@argument_numbers[i_]] = @formats[i_]
        i_ += 1
      end
      return result_array
    end
    
    typesig { [] }
    # Gets the formats used for the format elements in the
    # previously set pattern string.
    # The order of formats in the returned array corresponds to
    # the order of format elements in the pattern string.
    # <p>
    # Since the order of format elements in a pattern string often
    # changes during localization, it's generally better to use the
    # {@link #getFormatsByArgumentIndex getFormatsByArgumentIndex}
    # method, which assumes an order of formats corresponding to the
    # order of elements in the <code>arguments</code> array passed to
    # the <code>format</code> methods or the result array returned by
    # the <code>parse</code> methods.
    # 
    # @return the formats used for the format elements in the pattern
    def get_formats
      result_array = Array.typed(Format).new(@max_offset + 1) { nil }
      System.arraycopy(@formats, 0, result_array, 0, @max_offset + 1)
      return result_array
    end
    
    typesig { [Array.typed(Object), StringBuffer, FieldPosition] }
    # Formats an array of objects and appends the <code>MessageFormat</code>'s
    # pattern, with format elements replaced by the formatted objects, to the
    # provided <code>StringBuffer</code>.
    # <p>
    # The text substituted for the individual format elements is derived from
    # the current subformat of the format element and the
    # <code>arguments</code> element at the format element's argument index
    # as indicated by the first matching line of the following table. An
    # argument is <i>unavailable</i> if <code>arguments</code> is
    # <code>null</code> or has fewer than argumentIndex+1 elements.
    # <p>
    # <table border=1 summary="Examples of subformat,argument,and formatted text">
    # <tr>
    # <th>Subformat
    # <th>Argument
    # <th>Formatted Text
    # <tr>
    # <td><i>any</i>
    # <td><i>unavailable</i>
    # <td><code>"{" + argumentIndex + "}"</code>
    # <tr>
    # <td><i>any</i>
    # <td><code>null</code>
    # <td><code>"null"</code>
    # <tr>
    # <td><code>instanceof ChoiceFormat</code>
    # <td><i>any</i>
    # <td><code>subformat.format(argument).indexOf('{') >= 0 ?<br>
    # (new MessageFormat(subformat.format(argument), getLocale())).format(argument) :
    # subformat.format(argument)</code>
    # <tr>
    # <td><code>!= null</code>
    # <td><i>any</i>
    # <td><code>subformat.format(argument)</code>
    # <tr>
    # <td><code>null</code>
    # <td><code>instanceof Number</code>
    # <td><code>NumberFormat.getInstance(getLocale()).format(argument)</code>
    # <tr>
    # <td><code>null</code>
    # <td><code>instanceof Date</code>
    # <td><code>DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, getLocale()).format(argument)</code>
    # <tr>
    # <td><code>null</code>
    # <td><code>instanceof String</code>
    # <td><code>argument</code>
    # <tr>
    # <td><code>null</code>
    # <td><i>any</i>
    # <td><code>argument.toString()</code>
    # </table>
    # <p>
    # If <code>pos</code> is non-null, and refers to
    # <code>Field.ARGUMENT</code>, the location of the first formatted
    # string will be returned.
    # 
    # @param arguments an array of objects to be formatted and substituted.
    # @param result where text is appended.
    # @param pos On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @exception IllegalArgumentException if an argument in the
    # <code>arguments</code> array is not of the type
    # expected by the format element(s) that use it.
    def format(arguments, result, pos)
      return subformat(arguments, result, pos, nil)
    end
    
    class_module.module_eval {
      typesig { [String, Object] }
      # Creates a MessageFormat with the given pattern and uses it
      # to format the given arguments. This is equivalent to
      # <blockquote>
      # <code>(new {@link #MessageFormat(String) MessageFormat}(pattern)).{@link #format(java.lang.Object[], java.lang.StringBuffer, java.text.FieldPosition) format}(arguments, new StringBuffer(), null).toString()</code>
      # </blockquote>
      # 
      # @exception IllegalArgumentException if the pattern is invalid,
      # or if an argument in the <code>arguments</code> array
      # is not of the type expected by the format element(s)
      # that use it.
      def format(pattern, *arguments)
        temp = MessageFormat.new(pattern)
        return temp.format(arguments)
      end
    }
    
    typesig { [Object, StringBuffer, FieldPosition] }
    # Overrides
    # 
    # Formats an array of objects and appends the <code>MessageFormat</code>'s
    # pattern, with format elements replaced by the formatted objects, to the
    # provided <code>StringBuffer</code>.
    # This is equivalent to
    # <blockquote>
    # <code>{@link #format(java.lang.Object[], java.lang.StringBuffer, java.text.FieldPosition) format}((Object[]) arguments, result, pos)</code>
    # </blockquote>
    # 
    # @param arguments an array of objects to be formatted and substituted.
    # @param result where text is appended.
    # @param pos On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @exception IllegalArgumentException if an argument in the
    # <code>arguments</code> array is not of the type
    # expected by the format element(s) that use it.
    def format(arguments, result, pos)
      return subformat(arguments, result, pos, nil)
    end
    
    typesig { [Object] }
    # Formats an array of objects and inserts them into the
    # <code>MessageFormat</code>'s pattern, producing an
    # <code>AttributedCharacterIterator</code>.
    # You can use the returned <code>AttributedCharacterIterator</code>
    # to build the resulting String, as well as to determine information
    # about the resulting String.
    # <p>
    # The text of the returned <code>AttributedCharacterIterator</code> is
    # the same that would be returned by
    # <blockquote>
    # <code>{@link #format(java.lang.Object[], java.lang.StringBuffer, java.text.FieldPosition) format}(arguments, new StringBuffer(), null).toString()</code>
    # </blockquote>
    # <p>
    # In addition, the <code>AttributedCharacterIterator</code> contains at
    # least attributes indicating where text was generated from an
    # argument in the <code>arguments</code> array. The keys of these attributes are of
    # type <code>MessageFormat.Field</code>, their values are
    # <code>Integer</code> objects indicating the index in the <code>arguments</code>
    # array of the argument from which the text was generated.
    # <p>
    # The attributes/value from the underlying <code>Format</code>
    # instances that <code>MessageFormat</code> uses will also be
    # placed in the resulting <code>AttributedCharacterIterator</code>.
    # This allows you to not only find where an argument is placed in the
    # resulting String, but also which fields it contains in turn.
    # 
    # @param arguments an array of objects to be formatted and substituted.
    # @return AttributedCharacterIterator describing the formatted value.
    # @exception NullPointerException if <code>arguments</code> is null.
    # @exception IllegalArgumentException if an argument in the
    # <code>arguments</code> array is not of the type
    # expected by the format element(s) that use it.
    # @since 1.4
    def format_to_character_iterator(arguments)
      result = StringBuffer.new
      iterators = ArrayList.new
      if ((arguments).nil?)
        raise NullPointerException.new("formatToCharacterIterator must be passed non-null object")
      end
      subformat(arguments, result, nil, iterators)
      if ((iterators.size).equal?(0))
        return create_attributed_character_iterator("")
      end
      return create_attributed_character_iterator(iterators.to_array(Array.typed(AttributedCharacterIterator).new(iterators.size) { nil }))
    end
    
    typesig { [String, ParsePosition] }
    # Parses the string.
    # 
    # <p>Caveats: The parse may fail in a number of circumstances.
    # For example:
    # <ul>
    # <li>If one of the arguments does not occur in the pattern.
    # <li>If the format of an argument loses information, such as
    # with a choice format where a large number formats to "many".
    # <li>Does not yet handle recursion (where
    # the substituted strings contain {n} references.)
    # <li>Will not always find a match (or the correct match)
    # if some part of the parse is ambiguous.
    # For example, if the pattern "{1},{2}" is used with the
    # string arguments {"a,b", "c"}, it will format as "a,b,c".
    # When the result is parsed, it will return {"a", "b,c"}.
    # <li>If a single argument is parsed more than once in the string,
    # then the later parse wins.
    # </ul>
    # When the parse fails, use ParsePosition.getErrorIndex() to find out
    # where in the string the parsing failed.  The returned error
    # index is the starting offset of the sub-patterns that the string
    # is comparing with.  For example, if the parsing string "AAA {0} BBB"
    # is comparing against the pattern "AAD {0} BBB", the error index is
    # 0. When an error occurs, the call to this method will return null.
    # If the source is null, return an empty array.
    def parse(source, pos)
      if ((source).nil?)
        empty = Array.typed(Object).new([])
        return empty
      end
      maximum_argument_number = -1
      i = 0
      while i <= @max_offset
        if (@argument_numbers[i] > maximum_argument_number)
          maximum_argument_number = @argument_numbers[i]
        end
        i += 1
      end
      result_array = Array.typed(Object).new(maximum_argument_number + 1) { nil }
      pattern_offset = 0
      source_offset = pos.attr_index
      temp_status = ParsePosition.new(0)
      i_ = 0
      while i_ <= @max_offset
        # match up to format
        len = @offsets[i_] - pattern_offset
        if ((len).equal?(0) || @pattern.region_matches(pattern_offset, source, source_offset, len))
          source_offset += len
          pattern_offset += len
        else
          pos.attr_error_index = source_offset
          return nil # leave index as is to signal error
        end
        # now use format
        if ((@formats[i_]).nil?)
          # string format
          # if at end, use longest possible match
          # otherwise uses first match to intervening string
          # does NOT recursively try all possibilities
          temp_length = (!(i_).equal?(@max_offset)) ? @offsets[i_ + 1] : @pattern.length
          next_ = 0
          if (pattern_offset >= temp_length)
            next_ = source.length
          else
            next_ = source.index_of(@pattern.substring(pattern_offset, temp_length), source_offset)
          end
          if (next_ < 0)
            pos.attr_error_index = source_offset
            return nil # leave index as is to signal error
          else
            str_value = source.substring(source_offset, next_)
            if (!(str_value == "{" + RJava.cast_to_string(@argument_numbers[i_]) + "}"))
              result_array[@argument_numbers[i_]] = source.substring(source_offset, next_)
            end
            source_offset = next_
          end
        else
          temp_status.attr_index = source_offset
          result_array[@argument_numbers[i_]] = @formats[i_].parse_object(source, temp_status)
          if ((temp_status.attr_index).equal?(source_offset))
            pos.attr_error_index = source_offset
            return nil # leave index as is to signal error
          end
          source_offset = temp_status.attr_index # update
        end
        (i_ += 1)
      end
      len = @pattern.length - pattern_offset
      if ((len).equal?(0) || @pattern.region_matches(pattern_offset, source, source_offset, len))
        pos.attr_index = source_offset + len
      else
        pos.attr_error_index = source_offset
        return nil # leave index as is to signal error
      end
      return result_array
    end
    
    typesig { [String] }
    # Parses text from the beginning of the given string to produce an object
    # array.
    # The method may not use the entire text of the given string.
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on message parsing.
    # 
    # @param source A <code>String</code> whose beginning should be parsed.
    # @return An <code>Object</code> array parsed from the string.
    # @exception ParseException if the beginning of the specified string
    # cannot be parsed.
    def parse(source)
      pos = ParsePosition.new(0)
      result = parse(source, pos)
      if ((pos.attr_index).equal?(0))
        # unchanged, returned object is null
        raise ParseException.new("MessageFormat parse error!", pos.attr_error_index)
      end
      return result
    end
    
    typesig { [String, ParsePosition] }
    # Parses text from a string to produce an object array.
    # <p>
    # The method attempts to parse text starting at the index given by
    # <code>pos</code>.
    # If parsing succeeds, then the index of <code>pos</code> is updated
    # to the index after the last character used (parsing does not necessarily
    # use all characters up to the end of the string), and the parsed
    # object array is returned. The updated <code>pos</code> can be used to
    # indicate the starting point for the next call to this method.
    # If an error occurs, then the index of <code>pos</code> is not
    # changed, the error index of <code>pos</code> is set to the index of
    # the character where the error occurred, and null is returned.
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on message parsing.
    # 
    # @param source A <code>String</code>, part of which should be parsed.
    # @param pos A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return An <code>Object</code> array parsed from the string. In case of
    # error, returns null.
    # @exception NullPointerException if <code>pos</code> is null.
    def parse_object(source, pos)
      return parse(source, pos)
    end
    
    typesig { [] }
    # Creates and returns a copy of this object.
    # 
    # @return a clone of this instance.
    def clone
      other = super
      # clone arrays. Can't do with utility because of bug in Cloneable
      other.attr_formats = @formats.clone # shallow clone
      i = 0
      while i < @formats.attr_length
        if (!(@formats[i]).nil?)
          other.attr_formats[i] = @formats[i].clone
        end
        (i += 1)
      end
      # for primitives or immutables, shallow clone is enough
      other.attr_offsets = @offsets.clone
      other.attr_argument_numbers = @argument_numbers.clone
      return other
    end
    
    typesig { [Object] }
    # Equality comparison between two message format objects
    def ==(obj)
      if ((self).equal?(obj))
        # quick check
        return true
      end
      if ((obj).nil? || !(get_class).equal?(obj.get_class))
        return false
      end
      other = obj
      return ((@max_offset).equal?(other.attr_max_offset) && (@pattern == other.attr_pattern) && ((!(@locale).nil? && (@locale == other.attr_locale)) || ((@locale).nil? && (other.attr_locale).nil?)) && (Arrays == @offsets) && (Arrays == @argument_numbers) && (Arrays == @formats))
    end
    
    typesig { [] }
    # Generates a hash code for the message format object.
    def hash_code
      return @pattern.hash_code # enough for reasonable distribution
    end
    
    class_module.module_eval {
      # Defines constants that are used as attribute keys in the
      # <code>AttributedCharacterIterator</code> returned
      # from <code>MessageFormat.formatToCharacterIterator</code>.
      # 
      # @since 1.4
      const_set_lazy(:Field) { Class.new(Format::Field) do
        include_class_members MessageFormat
        
        class_module.module_eval {
          # Proclaim serial compatibility with 1.4 FCS
          const_set_lazy(:SerialVersionUID) { 7899943957617360810 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [String] }
        # Creates a Field with the specified name.
        # 
        # @param name Name of the attribute
        def initialize(name)
          super(name)
        end
        
        typesig { [] }
        # Resolves instances being deserialized to the predefined constants.
        # 
        # @throws InvalidObjectException if the constant could not be
        # resolved.
        # @return resolved MessageFormat.Field constant
        def read_resolve
          if (!(self.get_class).equal?(MessageFormat::Field))
            raise self.class::InvalidObjectException.new("subclass didn't correctly implement readResolve")
          end
          return self.class::ARGUMENT
        end
        
        class_module.module_eval {
          # The constants
          # 
          # 
          # Constant identifying a portion of a message that was generated
          # from an argument passed into <code>formatToCharacterIterator</code>.
          # The value associated with the key will be an <code>Integer</code>
          # indicating the index in the <code>arguments</code> array of the
          # argument from which the text was generated.
          const_set_lazy(:ARGUMENT) { class_self::Field.new("message argument field") }
          const_attr_reader  :ARGUMENT
        }
        
        private
        alias_method :initialize__field, :initialize
      end }
    }
    
    # ===========================privates============================
    # 
    # The locale to use for formatting numbers and dates.
    # @serial
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # The string that the formatted values are to be plugged into.  In other words, this
    # is the pattern supplied on construction with all of the {} expressions taken out.
    # @serial
    attr_accessor :pattern
    alias_method :attr_pattern, :pattern
    undef_method :pattern
    alias_method :attr_pattern=, :pattern=
    undef_method :pattern=
    
    class_module.module_eval {
      # The initially expected number of subformats in the format
      const_set_lazy(:INITIAL_FORMATS) { 10 }
      const_attr_reader  :INITIAL_FORMATS
    }
    
    # An array of formatters, which are used to format the arguments.
    # @serial
    attr_accessor :formats
    alias_method :attr_formats, :formats
    undef_method :formats
    alias_method :attr_formats=, :formats=
    undef_method :formats=
    
    # The positions where the results of formatting each argument are to be inserted
    # into the pattern.
    # @serial
    attr_accessor :offsets
    alias_method :attr_offsets, :offsets
    undef_method :offsets
    alias_method :attr_offsets=, :offsets=
    undef_method :offsets=
    
    # The argument numbers corresponding to each formatter.  (The formatters are stored
    # in the order they occur in the pattern, not in the order in which the arguments
    # are specified.)
    # @serial
    attr_accessor :argument_numbers
    alias_method :attr_argument_numbers, :argument_numbers
    undef_method :argument_numbers
    alias_method :attr_argument_numbers=, :argument_numbers=
    undef_method :argument_numbers=
    
    # One less than the number of entries in <code>offsets</code>.  Can also be thought of
    # as the index of the highest-numbered element in <code>offsets</code> that is being used.
    # All of these arrays should have the same number of elements being used as <code>offsets</code>
    # does, and so this variable suffices to tell us how many entries are in all of them.
    # @serial
    attr_accessor :max_offset
    alias_method :attr_max_offset, :max_offset
    undef_method :max_offset
    alias_method :attr_max_offset=, :max_offset=
    undef_method :max_offset=
    
    typesig { [Array.typed(Object), StringBuffer, FieldPosition, JavaList] }
    # Internal routine used by format. If <code>characterIterators</code> is
    # non-null, AttributedCharacterIterator will be created from the
    # subformats as necessary. If <code>characterIterators</code> is null
    # and <code>fp</code> is non-null and identifies
    # <code>Field.MESSAGE_ARGUMENT</code>, the location of
    # the first replaced argument will be set in it.
    # 
    # @exception IllegalArgumentException if an argument in the
    # <code>arguments</code> array is not of the type
    # expected by the format element(s) that use it.
    def subformat(arguments, result, fp, character_iterators)
      # note: this implementation assumes a fast substring & index.
      # if this is not true, would be better to append chars one by one.
      last_offset = 0
      last = result.length
      i = 0
      while i <= @max_offset
        result.append(@pattern.substring(last_offset, @offsets[i]))
        last_offset = @offsets[i]
        argument_number = @argument_numbers[i]
        if ((arguments).nil? || argument_number >= arguments.attr_length)
          result.append("{" + RJava.cast_to_string(argument_number) + "}")
          (i += 1)
          next
        end
        # int argRecursion = ((recursionProtection >> (argumentNumber*2)) & 0x3);
        if (false)
          # if (argRecursion == 3){
          # prevent loop!!!
          result.append(Character.new(0xFFFD))
        else
          obj = arguments[argument_number]
          arg = nil
          sub_formatter = nil
          if ((obj).nil?)
            arg = "null"
          else
            if (!(@formats[i]).nil?)
              sub_formatter = @formats[i]
              if (sub_formatter.is_a?(ChoiceFormat))
                arg = RJava.cast_to_string(@formats[i].format(obj))
                if (arg.index_of(Character.new(?{.ord)) >= 0)
                  sub_formatter = MessageFormat.new(arg, @locale)
                  obj = arguments
                  arg = RJava.cast_to_string(nil)
                end
              end
            else
              if (obj.is_a?(Numeric))
                # format number if can
                sub_formatter = NumberFormat.get_instance(@locale)
              else
                if (obj.is_a?(Date))
                  # format a Date if can
                  sub_formatter = DateFormat.get_date_time_instance(DateFormat::SHORT, DateFormat::SHORT, @locale) # fix
                else
                  if (obj.is_a?(String))
                    arg = RJava.cast_to_string(obj)
                  else
                    arg = RJava.cast_to_string(obj.to_s)
                    if ((arg).nil?)
                      arg = "null"
                    end
                  end
                end
              end
            end
          end
          # At this point we are in two states, either subFormatter
          # is non-null indicating we should format obj using it,
          # or arg is non-null and we should use it as the value.
          if (!(character_iterators).nil?)
            # If characterIterators is non-null, it indicates we need
            # to get the CharacterIterator from the child formatter.
            if (!(last).equal?(result.length))
              character_iterators.add(create_attributed_character_iterator(result.substring(last)))
              last = result.length
            end
            if (!(sub_formatter).nil?)
              sub_iterator = sub_formatter.format_to_character_iterator(obj)
              append(result, sub_iterator)
              if (!(last).equal?(result.length))
                character_iterators.add(create_attributed_character_iterator(sub_iterator, Field::ARGUMENT, argument_number))
                last = result.length
              end
              arg = RJava.cast_to_string(nil)
            end
            if (!(arg).nil? && arg.length > 0)
              result.append(arg)
              character_iterators.add(create_attributed_character_iterator(arg, Field::ARGUMENT, argument_number))
              last = result.length
            end
          else
            if (!(sub_formatter).nil?)
              arg = RJava.cast_to_string(sub_formatter.format(obj))
            end
            last = result.length
            result.append(arg)
            if ((i).equal?(0) && !(fp).nil? && (Field::ARGUMENT == fp.get_field_attribute))
              fp.set_begin_index(last)
              fp.set_end_index(result.length)
            end
            last = result.length
          end
        end
        (i += 1)
      end
      result.append(@pattern.substring(last_offset, @pattern.length))
      if (!(character_iterators).nil? && !(last).equal?(result.length))
        character_iterators.add(create_attributed_character_iterator(result.substring(last)))
      end
      return result
    end
    
    typesig { [StringBuffer, CharacterIterator] }
    # Convenience method to append all the characters in
    # <code>iterator</code> to the StringBuffer <code>result</code>.
    def append(result, iterator)
      if (!(iterator.first).equal?(CharacterIterator::DONE))
        a_char = 0
        result.append(iterator.first)
        while (!((a_char = iterator.next_)).equal?(CharacterIterator::DONE))
          result.append(a_char)
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:TypeList) { Array.typed(String).new(["", "", "number", "", "date", "", "time", "", "choice"]) }
      const_attr_reader  :TypeList
      
      const_set_lazy(:ModifierList) { Array.typed(String).new(["", "", "currency", "", "percent", "", "integer"]) }
      const_attr_reader  :ModifierList
      
      const_set_lazy(:DateModifierList) { Array.typed(String).new(["", "", "short", "", "medium", "", "long", "", "full"]) }
      const_attr_reader  :DateModifierList
    }
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(StringBuffer)] }
    def make_format(position, offset_number, segments)
      # get the argument number
      argument_number = 0
      begin
        argument_number = JavaInteger.parse_int(segments[1].to_s) # always unlocalized!
      rescue NumberFormatException => e
        raise IllegalArgumentException.new("can't parse argument number: " + RJava.cast_to_string(segments[1]))
      end
      if (argument_number < 0)
        raise IllegalArgumentException.new("negative argument number: " + RJava.cast_to_string(argument_number))
      end
      # resize format information arrays if necessary
      if (offset_number >= @formats.attr_length)
        new_length = @formats.attr_length * 2
        new_formats = Array.typed(Format).new(new_length) { nil }
        new_offsets = Array.typed(::Java::Int).new(new_length) { 0 }
        new_argument_numbers = Array.typed(::Java::Int).new(new_length) { 0 }
        System.arraycopy(@formats, 0, new_formats, 0, @max_offset + 1)
        System.arraycopy(@offsets, 0, new_offsets, 0, @max_offset + 1)
        System.arraycopy(@argument_numbers, 0, new_argument_numbers, 0, @max_offset + 1)
        @formats = new_formats
        @offsets = new_offsets
        @argument_numbers = new_argument_numbers
      end
      old_max_offset = @max_offset
      @max_offset = offset_number
      @offsets[offset_number] = segments[0].length
      @argument_numbers[offset_number] = argument_number
      # now get the format
      new_format = nil
      case (find_keyword(segments[2].to_s, TypeList))
      when 0
      when 1, 2
        # number
        case (find_keyword(segments[3].to_s, ModifierList))
        when 0
          # default;
          new_format = NumberFormat.get_instance(@locale)
        when 1, 2
          # currency
          new_format = NumberFormat.get_currency_instance(@locale)
        when 3, 4
          # percent
          new_format = NumberFormat.get_percent_instance(@locale)
        when 5, 6
          # integer
          new_format = NumberFormat.get_integer_instance(@locale)
        else
          # pattern
          new_format = DecimalFormat.new(segments[3].to_s, DecimalFormatSymbols.get_instance(@locale))
        end
      when 3, 4
        # date
        case (find_keyword(segments[3].to_s, DateModifierList))
        when 0
          # default
          new_format = DateFormat.get_date_instance(DateFormat::DEFAULT, @locale)
        when 1, 2
          # short
          new_format = DateFormat.get_date_instance(DateFormat::SHORT, @locale)
        when 3, 4
          # medium
          new_format = DateFormat.get_date_instance(DateFormat::DEFAULT, @locale)
        when 5, 6
          # long
          new_format = DateFormat.get_date_instance(DateFormat::LONG, @locale)
        when 7, 8
          # full
          new_format = DateFormat.get_date_instance(DateFormat::FULL, @locale)
        else
          new_format = SimpleDateFormat.new(segments[3].to_s, @locale)
        end
      when 5, 6
        # time
        case (find_keyword(segments[3].to_s, DateModifierList))
        when 0
          # default
          new_format = DateFormat.get_time_instance(DateFormat::DEFAULT, @locale)
        when 1, 2
          # short
          new_format = DateFormat.get_time_instance(DateFormat::SHORT, @locale)
        when 3, 4
          # medium
          new_format = DateFormat.get_time_instance(DateFormat::DEFAULT, @locale)
        when 5, 6
          # long
          new_format = DateFormat.get_time_instance(DateFormat::LONG, @locale)
        when 7, 8
          # full
          new_format = DateFormat.get_time_instance(DateFormat::FULL, @locale)
        else
          new_format = SimpleDateFormat.new(segments[3].to_s, @locale)
        end
      when 7, 8
        # choice
        begin
          new_format = ChoiceFormat.new(segments[3].to_s)
        rescue JavaException => e
          @max_offset = old_max_offset
          raise IllegalArgumentException.new("Choice Pattern incorrect")
        end
      else
        @max_offset = old_max_offset
        raise IllegalArgumentException.new("unknown format type: " + RJava.cast_to_string(segments[2].to_s))
      end
      @formats[offset_number] = new_format
      segments[1].set_length(0) # throw away other segments
      segments[2].set_length(0)
      segments[3].set_length(0)
    end
    
    class_module.module_eval {
      typesig { [String, Array.typed(String)] }
      def find_keyword(s, list)
        s = RJava.cast_to_string(s.trim.to_lower_case)
        i = 0
        while i < list.attr_length
          if ((s == list[i]))
            return i
          end
          (i += 1)
        end
        return -1
      end
      
      typesig { [String, ::Java::Int, ::Java::Int, StringBuffer] }
      def copy_and_fix_quotes(source, start, end_, target)
        i = start
        while i < end_
          ch = source.char_at(i)
          if ((ch).equal?(Character.new(?{.ord)))
            target.append("'{'")
          else
            if ((ch).equal?(Character.new(?}.ord)))
              target.append("'}'")
            else
              if ((ch).equal?(Character.new(?\'.ord)))
                target.append("''")
              else
                target.append(ch)
              end
            end
          end
          (i += 1)
        end
      end
    }
    
    typesig { [ObjectInputStream] }
    # After reading an object from the input stream, do a simple verification
    # to maintain class invariants.
    # @throws InvalidObjectException if the objects read from the stream is invalid.
    def read_object(in_)
      in_.default_read_object
      is_valid = @max_offset >= -1 && @formats.attr_length > @max_offset && @offsets.attr_length > @max_offset && @argument_numbers.attr_length > @max_offset
      if (is_valid)
        last_offset = @pattern.length + 1
        i = @max_offset
        while i >= 0
          if ((@offsets[i] < 0) || (@offsets[i] > last_offset))
            is_valid = false
            break
          else
            last_offset = @offsets[i]
          end
          (i -= 1)
        end
      end
      if (!is_valid)
        raise InvalidObjectException.new("Could not reconstruct MessageFormat from corrupt stream.")
      end
    end
    
    private
    alias_method :initialize__message_format, :initialize
  end
  
end

require "rjava"

# Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 2002 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module RuleBasedBreakIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Stack
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Text, :CharacterIterator
      include_const ::Java::Text, :StringCharacterIterator
      include_const ::Sun::Text, :CompactByteArray
      include_const ::Sun::Text, :SupplementaryCharacterData
    }
  end
  
  # <p>A subclass of BreakIterator whose behavior is specified using a list of rules.</p>
  # 
  # <p>There are two kinds of rules, which are separated by semicolons: <i>substitutions</i>
  # and <i>regular expressions.</i></p>
  # 
  # <p>A substitution rule defines a name that can be used in place of an expression. It
  # consists of a name, which is a string of characters contained in angle brackets, an equals
  # sign, and an expression. (There can be no whitespace on either side of the equals sign.)
  # To keep its syntactic meaning intact, the expression must be enclosed in parentheses or
  # square brackets. A substitution is visible after its definition, and is filled in using
  # simple textual substitution. Substitution definitions can contain other substitutions, as
  # long as those substitutions have been defined first. Substitutions are generally used to
  # make the regular expressions (which can get quite complex) shorted and easier to read.
  # They typically define either character categories or commonly-used subexpressions.</p>
  # 
  # <p>There is one special substitution.&nbsp; If the description defines a substitution
  # called &quot;&lt;ignore&gt;&quot;, the expression must be a [] expression, and the
  # expression defines a set of characters (the &quot;<em>ignore characters</em>&quot;) that
  # will be transparent to the BreakIterator.&nbsp; A sequence of characters will break the
  # same way it would if any ignore characters it contains are taken out.&nbsp; Break
  # positions never occur befoer ignore characters.</p>
  # 
  # <p>A regular expression uses a subset of the normal Unix regular-expression syntax, and
  # defines a sequence of characters to be kept together. With one significant exception, the
  # iterator uses a longest-possible-match algorithm when matching text to regular
  # expressions. The iterator also treats descriptions containing multiple regular expressions
  # as if they were ORed together (i.e., as if they were separated by |).</p>
  # 
  # <p>The special characters recognized by the regular-expression parser are as follows:</p>
  # 
  # <blockquote>
  # <table border="1" width="100%">
  # <tr>
  # <td width="6%">*</td>
  # <td width="94%">Specifies that the expression preceding the asterisk may occur any number
  # of times (including not at all).</td>
  # </tr>
  # <tr>
  # <td width="6%">{}</td>
  # <td width="94%">Encloses a sequence of characters that is optional.</td>
  # </tr>
  # <tr>
  # <td width="6%">()</td>
  # <td width="94%">Encloses a sequence of characters.&nbsp; If followed by *, the sequence
  # repeats.&nbsp; Otherwise, the parentheses are just a grouping device and a way to delimit
  # the ends of expressions containing |.</td>
  # </tr>
  # <tr>
  # <td width="6%">|</td>
  # <td width="94%">Separates two alternative sequences of characters.&nbsp; Either one
  # sequence or the other, but not both, matches this expression.&nbsp; The | character can
  # only occur inside ().</td>
  # </tr>
  # <tr>
  # <td width="6%">.</td>
  # <td width="94%">Matches any character.</td>
  # </tr>
  # <tr>
  # <td width="6%">*?</td>
  # <td width="94%">Specifies a non-greedy asterisk.&nbsp; *? works the same way as *, except
  # when there is overlap between the last group of characters in the expression preceding the
  # * and the first group of characters following the *.&nbsp; When there is this kind of
  # overlap, * will match the longest sequence of characters that match the expression before
  # the *, and *? will match the shortest sequence of characters matching the expression
  # before the *?.&nbsp; For example, if you have &quot;xxyxyyyxyxyxxyxyxyy&quot; in the text,
  # &quot;x[xy]*x&quot; will match through to the last x (i.e., &quot;<strong>xxyxyyyxyxyxxyxyx</strong>yy&quot;,
  # but &quot;x[xy]*?x&quot; will only match the first two xes (&quot;<strong>xx</strong>yxyyyxyxyxxyxyxyy&quot;).</td>
  # </tr>
  # <tr>
  # <td width="6%">[]</td>
  # <td width="94%">Specifies a group of alternative characters.&nbsp; A [] expression will
  # match any single character that is specified in the [] expression.&nbsp; For more on the
  # syntax of [] expressions, see below.</td>
  # </tr>
  # <tr>
  # <td width="6%">/</td>
  # <td width="94%">Specifies where the break position should go if text matches this
  # expression.&nbsp; (e.g., &quot;[a-z]&#42;/[:Zs:]*[1-0]&quot; will match if the iterator sees a run
  # of letters, followed by a run of whitespace, followed by a digit, but the break position
  # will actually go before the whitespace).&nbsp; Expressions that don't contain / put the
  # break position at the end of the matching text.</td>
  # </tr>
  # <tr>
  # <td width="6%">\</td>
  # <td width="94%">Escape character.&nbsp; The \ itself is ignored, but causes the next
  # character to be treated as literal character.&nbsp; This has no effect for many
  # characters, but for the characters listed above, this deprives them of their special
  # meaning.&nbsp; (There are no special escape sequences for Unicode characters, or tabs and
  # newlines; these are all handled by a higher-level protocol.&nbsp; In a Java string,
  # &quot;\n&quot; will be converted to a literal newline character by the time the
  # regular-expression parser sees it.&nbsp; Of course, this means that \ sequences that are
  # visible to the regexp parser must be written as \\ when inside a Java string.)&nbsp; All
  # characters in the ASCII range except for letters, digits, and control characters are
  # reserved characters to the parser and must be preceded by \ even if they currently don't
  # mean anything.</td>
  # </tr>
  # <tr>
  # <td width="6%">!</td>
  # <td width="94%">If ! appears at the beginning of a regular expression, it tells the regexp
  # parser that this expression specifies the backwards-iteration behavior of the iterator,
  # and not its normal iteration behavior.&nbsp; This is generally only used in situations
  # where the automatically-generated backwards-iteration brhavior doesn't produce
  # satisfactory results and must be supplemented with extra client-specified rules.</td>
  # </tr>
  # <tr>
  # <td width="6%"><em>(all others)</em></td>
  # <td width="94%">All other characters are treated as literal characters, which must match
  # the corresponding character(s) in the text exactly.</td>
  # </tr>
  # </table>
  # </blockquote>
  # 
  # <p>Within a [] expression, a number of other special characters can be used to specify
  # groups of characters:</p>
  # 
  # <blockquote>
  # <table border="1" width="100%">
  # <tr>
  # <td width="6%">-</td>
  # <td width="94%">Specifies a range of matching characters.&nbsp; For example
  # &quot;[a-p]&quot; matches all lowercase Latin letters from a to p (inclusive).&nbsp; The -
  # sign specifies ranges of continuous Unicode numeric values, not ranges of characters in a
  # language's alphabetical order: &quot;[a-z]&quot; doesn't include capital letters, nor does
  # it include accented letters such as a-umlaut.</td>
  # </tr>
  # <tr>
  # <td width="6%">::</td>
  # <td width="94%">A pair of colons containing a one- or two-letter code matches all
  # characters in the corresponding Unicode category.&nbsp; The two-letter codes are the same
  # as the two-letter codes in the Unicode database (for example, &quot;[:Sc::Sm:]&quot;
  # matches all currency symbols and all math symbols).&nbsp; Specifying a one-letter code is
  # the same as specifying all two-letter codes that begin with that letter (for example,
  # &quot;[:L:]&quot; matches all letters, and is equivalent to
  # &quot;[:Lu::Ll::Lo::Lm::Lt:]&quot;).&nbsp; Anything other than a valid two-letter Unicode
  # category code or a single letter that begins a Unicode category code is illegal within
  # colons.</td>
  # </tr>
  # <tr>
  # <td width="6%">[]</td>
  # <td width="94%">[] expressions can nest.&nbsp; This has no effect, except when used in
  # conjunction with the ^ token.</td>
  # </tr>
  # <tr>
  # <td width="6%">^</td>
  # <td width="94%">Excludes the character (or the characters in the [] expression) following
  # it from the group of characters.&nbsp; For example, &quot;[a-z^p]&quot; matches all Latin
  # lowercase letters except p.&nbsp; &quot;[:L:^[&#92;u4e00-&#92;u9fff]]&quot; matches all letters
  # except the Han ideographs.</td>
  # </tr>
  # <tr>
  # <td width="6%"><em>(all others)</em></td>
  # <td width="94%">All other characters are treated as literal characters.&nbsp; (For
  # example, &quot;[aeiou]&quot; specifies just the letters a, e, i, o, and u.)</td>
  # </tr>
  # </table>
  # </blockquote>
  # 
  # <p>For a more complete explanation, see <a
  # href="http://www.ibm.com/java/education/boundaries/boundaries.html">http://www.ibm.com/java/education/boundaries/boundaries.html</a>.
  # &nbsp; For examples, see the resource data (which is annotated).</p>
  # 
  # @author Richard Gillam
  class RuleBasedBreakIterator < RuleBasedBreakIteratorImports.const_get :BreakIterator
    include_class_members RuleBasedBreakIteratorImports
    
    class_module.module_eval {
      # A token used as a character-category value to identify ignore characters
      const_set_lazy(:IGNORE) { -1 }
      const_attr_reader  :IGNORE
      
      # The state number of the starting state
      const_set_lazy(:START_STATE) { 1 }
      const_attr_reader  :START_STATE
      
      # The state-transition value indicating "stop"
      const_set_lazy(:STOP_STATE) { 0 }
      const_attr_reader  :STOP_STATE
      
      # Magic number for the BreakIterator data file format.
      const_set_lazy(:LABEL) { Array.typed(::Java::Byte).new([Character.new(?B.ord), Character.new(?I.ord), Character.new(?d.ord), Character.new(?a.ord), Character.new(?t.ord), Character.new(?a.ord), Character.new(?\0.ord)]) }
      const_attr_reader  :LABEL
      
      const_set_lazy(:LABEL_LENGTH) { LABEL.attr_length }
      const_attr_reader  :LABEL_LENGTH
      
      # Version number of the dictionary that was read in.
      const_set_lazy(:SupportedVersion) { 1 }
      const_attr_reader  :SupportedVersion
      
      # Header size in byte count
      const_set_lazy(:HEADER_LENGTH) { 36 }
      const_attr_reader  :HEADER_LENGTH
      
      # An array length of indices for BMP characters
      const_set_lazy(:BMP_INDICES_LENGTH) { 512 }
      const_attr_reader  :BMP_INDICES_LENGTH
    }
    
    # Tables that indexes from character values to character category numbers
    attr_accessor :char_category_table
    alias_method :attr_char_category_table, :char_category_table
    undef_method :char_category_table
    alias_method :attr_char_category_table=, :char_category_table=
    undef_method :char_category_table=
    
    attr_accessor :supplementary_char_category_table
    alias_method :attr_supplementary_char_category_table, :supplementary_char_category_table
    undef_method :supplementary_char_category_table
    alias_method :attr_supplementary_char_category_table=, :supplementary_char_category_table=
    undef_method :supplementary_char_category_table=
    
    # The table of state transitions used for forward iteration
    attr_accessor :state_table
    alias_method :attr_state_table, :state_table
    undef_method :state_table
    alias_method :attr_state_table=, :state_table=
    undef_method :state_table=
    
    # The table of state transitions used to sync up the iterator with the
    # text in backwards and random-access iteration
    attr_accessor :backwards_state_table
    alias_method :attr_backwards_state_table, :backwards_state_table
    undef_method :backwards_state_table
    alias_method :attr_backwards_state_table=, :backwards_state_table=
    undef_method :backwards_state_table=
    
    # A list of flags indicating which states in the state table are accepting
    # ("end") states
    attr_accessor :end_states
    alias_method :attr_end_states, :end_states
    undef_method :end_states
    alias_method :attr_end_states=, :end_states=
    undef_method :end_states=
    
    # A list of flags indicating which states in the state table are
    # lookahead states (states which turn lookahead on and off)
    attr_accessor :lookahead_states
    alias_method :attr_lookahead_states, :lookahead_states
    undef_method :lookahead_states
    alias_method :attr_lookahead_states=, :lookahead_states=
    undef_method :lookahead_states=
    
    # A table for additional data. May be used by a subclass of
    # RuleBasedBreakIterator.
    attr_accessor :additional_data
    alias_method :attr_additional_data, :additional_data
    undef_method :additional_data
    alias_method :attr_additional_data=, :additional_data=
    undef_method :additional_data=
    
    # The number of character categories (and, thus, the number of columns in
    # the state tables)
    attr_accessor :num_categories
    alias_method :attr_num_categories, :num_categories
    undef_method :num_categories
    alias_method :attr_num_categories=, :num_categories=
    undef_method :num_categories=
    
    # The character iterator through which this BreakIterator accesses the text
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # A CRC32 value of all data in datafile
    attr_accessor :checksum
    alias_method :attr_checksum, :checksum
    undef_method :checksum
    alias_method :attr_checksum=, :checksum=
    undef_method :checksum=
    
    typesig { [String] }
    # =======================================================================
    # constructors
    # =======================================================================
    # 
    # Constructs a RuleBasedBreakIterator according to the datafile
    # provided.
    def initialize(datafile)
      @char_category_table = nil
      @supplementary_char_category_table = nil
      @state_table = nil
      @backwards_state_table = nil
      @end_states = nil
      @lookahead_states = nil
      @additional_data = nil
      @num_categories = 0
      @text = nil
      @checksum = 0
      super()
      @char_category_table = nil
      @supplementary_char_category_table = nil
      @state_table = nil
      @backwards_state_table = nil
      @end_states = nil
      @lookahead_states = nil
      @additional_data = nil
      @text = nil
      read_tables(datafile)
    end
    
    typesig { [String] }
    # Read datafile. The datafile's format is as follows:
    # <pre>
    # BreakIteratorData {
    # u1           magic[7];
    # u1           version;
    # u4           totalDataSize;
    # header_info  header;
    # body         value;
    # }
    # </pre>
    # <code>totalDataSize</code> is the summation of the size of
    # <code>header_info</code> and <code>body</code> in byte count.
    # <p>
    # In <code>header</code>, each field except for checksum implies the
    # length of each field. Since <code>BMPdataLength</code> is a fixed-length
    # data(512 entries), its length isn't included in <code>header</code>.
    # <code>checksum</code> is a CRC32 value of all in <code>body</code>.
    # <pre>
    # header_info {
    # u4           stateTableLength;
    # u4           backwardsStateTableLength;
    # u4           endStatesLength;
    # u4           lookaheadStatesLength;
    # u4           BMPdataLength;
    # u4           nonBMPdataLength;
    # u4           additionalDataLength;
    # u8           checksum;
    # }
    # </pre>
    # <p>
    # 
    # Finally, <code>BMPindices</code> and <code>BMPdata</code> are set to
    # <code>charCategoryTable</code>. <code>nonBMPdata</code> is set to
    # <code>supplementaryCharCategoryTable</code>.
    # <pre>
    # body {
    # u2           stateTable[stateTableLength];
    # u2           backwardsStateTable[backwardsStateTableLength];
    # u1           endStates[endStatesLength];
    # u1           lookaheadStates[lookaheadStatesLength];
    # u2           BMPindices[512];
    # u1           BMPdata[BMPdataLength];
    # u4           nonBMPdata[numNonBMPdataLength];
    # u1           additionalData[additionalDataLength];
    # }
    # </pre>
    def read_tables(datafile)
      buffer = read_file(datafile)
      # Read header_info.
      state_table_length = BreakIterator.get_int(buffer, 0)
      backwards_state_table_length = BreakIterator.get_int(buffer, 4)
      end_states_length = BreakIterator.get_int(buffer, 8)
      lookahead_states_length = BreakIterator.get_int(buffer, 12)
      bmpdata_length = BreakIterator.get_int(buffer, 16)
      non_bmpdata_length = BreakIterator.get_int(buffer, 20)
      additional_data_length = BreakIterator.get_int(buffer, 24)
      @checksum = BreakIterator.get_long(buffer, 28)
      # Read stateTable[numCategories * numRows]
      @state_table = Array.typed(::Java::Short).new(state_table_length) { 0 }
      offset = HEADER_LENGTH
      i = 0
      while i < state_table_length
        @state_table[i] = BreakIterator.get_short(buffer, offset)
        i += 1
        offset += 2
      end
      # Read backwardsStateTable[numCategories * numRows]
      @backwards_state_table = Array.typed(::Java::Short).new(backwards_state_table_length) { 0 }
      i_ = 0
      while i_ < backwards_state_table_length
        @backwards_state_table[i_] = BreakIterator.get_short(buffer, offset)
        i_ += 1
        offset += 2
      end
      # Read endStates[numRows]
      @end_states = Array.typed(::Java::Boolean).new(end_states_length) { false }
      i__ = 0
      while i__ < end_states_length
        @end_states[i__] = (buffer[offset]).equal?(1)
        i__ += 1
        offset += 1
      end
      # Read lookaheadStates[numRows]
      @lookahead_states = Array.typed(::Java::Boolean).new(lookahead_states_length) { false }
      i___ = 0
      while i___ < lookahead_states_length
        @lookahead_states[i___] = (buffer[offset]).equal?(1)
        i___ += 1
        offset += 1
      end
      # Read a category table and indices for BMP characters.
      temp1 = Array.typed(::Java::Short).new(BMP_INDICES_LENGTH) { 0 } # BMPindices
      i____ = 0
      while i____ < BMP_INDICES_LENGTH
        temp1[i____] = BreakIterator.get_short(buffer, offset)
        i____ += 1
        offset += 2
      end
      temp2 = Array.typed(::Java::Byte).new(bmpdata_length) { 0 } # BMPdata
      System.arraycopy(buffer, offset, temp2, 0, bmpdata_length)
      offset += bmpdata_length
      @char_category_table = CompactByteArray.new(temp1, temp2)
      # Read a category table for non-BMP characters.
      temp3 = Array.typed(::Java::Int).new(non_bmpdata_length) { 0 }
      i_____ = 0
      while i_____ < non_bmpdata_length
        temp3[i_____] = BreakIterator.get_int(buffer, offset)
        i_____ += 1
        offset += 4
      end
      @supplementary_char_category_table = SupplementaryCharacterData.new(temp3)
      # Read additional data
      if (additional_data_length > 0)
        @additional_data = Array.typed(::Java::Byte).new(additional_data_length) { 0 }
        System.arraycopy(buffer, offset, @additional_data, 0, additional_data_length)
      end
      # Set numCategories
      @num_categories = @state_table.attr_length / @end_states.attr_length
    end
    
    typesig { [String] }
    def read_file(datafile)
      is = nil
      begin
        is = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members RuleBasedBreakIterator
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::BufferedInputStream.new(get_class.get_resource_as_stream("/sun/text/resources/" + datafile))
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => e
        raise InternalError.new(e.to_s)
      end
      offset = 0
      # First, read magic, version, and header_info.
      len = LABEL_LENGTH + 5
      buf = Array.typed(::Java::Byte).new(len) { 0 }
      if (!(is.read(buf)).equal?(len))
        raise MissingResourceException.new("Wrong header length", datafile, "")
      end
      # Validate the magic number.
      i = 0
      while i < LABEL_LENGTH
        if (!(buf[offset]).equal?(LABEL[offset]))
          raise MissingResourceException.new("Wrong magic number", datafile, "")
        end
        i += 1
        offset += 1
      end
      # Validate the version number.
      if (!(buf[offset]).equal?(SupportedVersion))
        raise MissingResourceException.new("Unsupported version(" + RJava.cast_to_string(buf[offset]) + ")", datafile, "")
      end
      # Read data: totalDataSize + 8(for checksum)
      len = BreakIterator.get_int(buf, (offset += 1))
      buf = Array.typed(::Java::Byte).new(len) { 0 }
      if (!(is.read(buf)).equal?(len))
        raise MissingResourceException.new("Wrong data length", datafile, "")
      end
      is.close
      return buf
    end
    
    typesig { [] }
    def get_additional_data
      return @additional_data
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def set_additional_data(b)
      @additional_data = b
    end
    
    typesig { [] }
    # =======================================================================
    # boilerplate
    # =======================================================================
    # 
    # Clones this iterator.
    # @return A newly-constructed RuleBasedBreakIterator with the same
    # behavior as this one.
    def clone
      result = super
      if (!(@text).nil?)
        result.attr_text = @text.clone
      end
      return result
    end
    
    typesig { [Object] }
    # Returns true if both BreakIterators are of the same class, have the same
    # rules, and iterate over the same text.
    def ==(that)
      begin
        if ((that).nil?)
          return false
        end
        other = that
        if (!(@checksum).equal?(other.attr_checksum))
          return false
        end
        if ((@text).nil?)
          return (other.attr_text).nil?
        else
          return (@text == other.attr_text)
        end
      rescue ClassCastException => e
        return false
      end
    end
    
    typesig { [] }
    # Returns text
    def to_s
      sb = StringBuffer.new
      sb.append(Character.new(?[.ord))
      sb.append("checksum=0x" + RJava.cast_to_string(Long.to_hex_string(@checksum)))
      sb.append(Character.new(?].ord))
      return sb.to_s
    end
    
    typesig { [] }
    # Compute a hashcode for this BreakIterator
    # @return A hash code
    def hash_code
      return RJava.cast_to_int(@checksum)
    end
    
    typesig { [] }
    # =======================================================================
    # BreakIterator overrides
    # =======================================================================
    # 
    # Sets the current iteration position to the beginning of the text.
    # (i.e., the CharacterIterator's starting offset).
    # @return The offset of the beginning of the text.
    def first
      t = get_text
      t.first
      return t.get_index
    end
    
    typesig { [] }
    # Sets the current iteration position to the end of the text.
    # (i.e., the CharacterIterator's ending offset).
    # @return The text's past-the-end offset.
    def last
      t = get_text
      # I'm not sure why, but t.last() returns the offset of the last character,
      # rather than the past-the-end offset
      t.set_index(t.get_end_index)
      return t.get_index
    end
    
    typesig { [::Java::Int] }
    # Advances the iterator either forward or backward the specified number of steps.
    # Negative values move backward, and positive values move forward.  This is
    # equivalent to repeatedly calling next() or previous().
    # @param n The number of steps to move.  The sign indicates the direction
    # (negative is backwards, and positive is forwards).
    # @return The character offset of the boundary position n boundaries away from
    # the current one.
    def next_(n)
      result = current
      while (n > 0)
        result = handle_next
        (n -= 1)
      end
      while (n < 0)
        result = previous
        (n += 1)
      end
      return result
    end
    
    typesig { [] }
    # Advances the iterator to the next boundary position.
    # @return The position of the first boundary after this one.
    def next_
      return handle_next
    end
    
    typesig { [] }
    # Advances the iterator backwards, to the last boundary preceding this one.
    # @return The position of the last boundary position preceding this one.
    def previous
      # if we're already sitting at the beginning of the text, return DONE
      text = get_text
      if ((current).equal?(text.get_begin_index))
        return BreakIterator::DONE
      end
      # set things up.  handlePrevious() will back us up to some valid
      # break position before the current position (we back our internal
      # iterator up one step to prevent handlePrevious() from returning
      # the current position), but not necessarily the last one before
      # where we started
      start = current
      get_previous
      last_result = handle_previous
      result = last_result
      # iterate forward from the known break position until we pass our
      # starting point.  The last break position before the starting
      # point is our return value
      while (!(result).equal?(BreakIterator::DONE) && result < start)
        last_result = result
        result = handle_next
      end
      # set the current iteration position to be the last break position
      # before where we started, and then return that value
      text.set_index(last_result)
      return last_result
    end
    
    typesig { [] }
    # Returns previous character
    def get_previous
      c2 = @text.previous
      if (Character.is_low_surrogate(c2) && @text.get_index > @text.get_begin_index)
        c1 = @text.previous
        if (Character.is_high_surrogate(c1))
          return Character.to_code_point(c1, c2)
        else
          @text.next_
        end
      end
      return RJava.cast_to_int(c2)
    end
    
    typesig { [] }
    # Returns current character
    def get_current
      c1 = @text.current
      if (Character.is_high_surrogate(c1) && @text.get_index < @text.get_end_index)
        c2 = @text.next_
        @text.previous
        if (Character.is_low_surrogate(c2))
          return Character.to_code_point(c1, c2)
        end
      end
      return RJava.cast_to_int(c1)
    end
    
    typesig { [] }
    # Returns the count of next character.
    def get_current_code_point_count
      c1 = @text.current
      if (Character.is_high_surrogate(c1) && @text.get_index < @text.get_end_index)
        c2 = @text.next_
        @text.previous
        if (Character.is_low_surrogate(c2))
          return 2
        end
      end
      return 1
    end
    
    typesig { [] }
    # Returns next character
    def get_next
      index = @text.get_index
      end_index = @text.get_end_index
      if ((index).equal?(end_index) || (index = index + get_current_code_point_count) >= end_index)
        return CharacterIterator::DONE
      end
      @text.set_index(index)
      return get_current
    end
    
    typesig { [] }
    # Returns the position of next character.
    def get_next_index
      index = @text.get_index + get_current_code_point_count
      end_index = @text.get_end_index
      if (index > end_index)
        return end_index
      else
        return index
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, CharacterIterator] }
      # Throw IllegalArgumentException unless begin <= offset < end.
      def check_offset(offset, text)
        if (offset < text.get_begin_index || offset > text.get_end_index)
          raise IllegalArgumentException.new("offset out of bounds")
        end
      end
    }
    
    typesig { [::Java::Int] }
    # Sets the iterator to refer to the first boundary position following
    # the specified position.
    # @offset The position from which to begin searching for a break position.
    # @return The position of the first break after the current position.
    def following(offset)
      text = get_text
      check_offset(offset, text)
      # Set our internal iteration position (temporarily)
      # to the position passed in.  If this is the _beginning_ position,
      # then we can just use next() to get our return value
      text.set_index(offset)
      if ((offset).equal?(text.get_begin_index))
        return handle_next
      end
      # otherwise, we have to sync up first.  Use handlePrevious() to back
      # us up to a known break position before the specified position (if
      # we can determine that the specified position is a break position,
      # we don't back up at all).  This may or may not be the last break
      # position at or before our starting position.  Advance forward
      # from here until we've passed the starting position.  The position
      # we stop on will be the first break position after the specified one.
      result = handle_previous
      while (!(result).equal?(BreakIterator::DONE) && result <= offset)
        result = handle_next
      end
      return result
    end
    
    typesig { [::Java::Int] }
    # Sets the iterator to refer to the last boundary position before the
    # specified position.
    # @offset The position to begin searching for a break from.
    # @return The position of the last boundary before the starting position.
    def preceding(offset)
      # if we start by updating the current iteration position to the
      # position specified by the caller, we can just use previous()
      # to carry out this operation
      text = get_text
      check_offset(offset, text)
      text.set_index(offset)
      return previous
    end
    
    typesig { [::Java::Int] }
    # Returns true if the specfied position is a boundary position.  As a side
    # effect, leaves the iterator pointing to the first boundary position at
    # or after "offset".
    # @param offset the offset to check.
    # @return True if "offset" is a boundary position.
    def is_boundary(offset)
      text = get_text
      check_offset(offset, text)
      if ((offset).equal?(text.get_begin_index))
        return true
      # to check whether this is a boundary, we can use following() on the
      # position before the specified one and return true if the position we
      # get back is the one the user specified
      else
        return (following(offset - 1)).equal?(offset)
      end
    end
    
    typesig { [] }
    # Returns the current iteration position.
    # @return The current iteration position.
    def current
      return get_text.get_index
    end
    
    typesig { [] }
    # Return a CharacterIterator over the text being analyzed.  This version
    # of this method returns the actual CharacterIterator we're using internally.
    # Changing the state of this iterator can have undefined consequences.  If
    # you need to change it, clone it first.
    # @return An iterator over the text being analyzed.
    def get_text
      # The iterator is initialized pointing to no text at all, so if this
      # function is called while we're in that state, we have to fudge an
      # iterator to return.
      if ((@text).nil?)
        @text = StringCharacterIterator.new("")
      end
      return @text
    end
    
    typesig { [CharacterIterator] }
    # Set the iterator to analyze a new piece of text.  This function resets
    # the current iteration position to the beginning of the text.
    # @param newText An iterator over the text to analyze.
    def set_text(new_text)
      # Test iterator to see if we need to wrap it in a SafeCharIterator.
      # The correct behavior for CharacterIterators is to allow the
      # position to be set to the endpoint of the iterator.  Many
      # CharacterIterators do not uphold this, so this is a workaround
      # to permit them to use this class.
      end_ = new_text.get_end_index
      good_iterator = false
      begin
        new_text.set_index(end_) # some buggy iterators throw an exception here
        good_iterator = (new_text.get_index).equal?(end_)
      rescue IllegalArgumentException => e
        good_iterator = false
      end
      if (good_iterator)
        @text = new_text
      else
        @text = SafeCharIterator.new(new_text)
      end
      @text.first
    end
    
    typesig { [] }
    # =======================================================================
    # implementation
    # =======================================================================
    # 
    # This method is the actual implementation of the next() method.  All iteration
    # vectors through here.  This method initializes the state machine to state 1
    # and advances through the text character by character until we reach the end
    # of the text or the state machine transitions to state 0.  We update our return
    # value every time the state machine passes through a possible end state.
    def handle_next
      # if we're already at the end of the text, return DONE.
      text = get_text
      if ((text.get_index).equal?(text.get_end_index))
        return BreakIterator::DONE
      end
      # no matter what, we always advance at least one character forward
      result = get_next_index
      lookahead_result = 0
      # begin in state 1
      state = START_STATE
      category = 0
      c = get_current
      # loop until we reach the end of the text or transition to state 0
      while (!(c).equal?(CharacterIterator::DONE) && !(state).equal?(STOP_STATE))
        # look up the current character's character category (which tells us
        # which column in the state table to look at)
        category = lookup_category(c)
        # if the character isn't an ignore character, look up a state
        # transition in the state table
        if (!(category).equal?(IGNORE))
          state = lookup_state(state, category)
        end
        # if the state we've just transitioned to is a lookahead state,
        # (but not also an end state), save its position.  If it's
        # both a lookahead state and an end state, update the break position
        # to the last saved lookup-state position
        if (@lookahead_states[state])
          if (@end_states[state])
            result = lookahead_result
          else
            lookahead_result = get_next_index
          end
        # otherwise, if the state we've just transitioned to is an accepting
        # state, update the break position to be the current iteration position
        else
          if (@end_states[state])
            result = get_next_index
          end
        end
        c = get_next
      end
      # if we've run off the end of the text, and the very last character took us into
      # a lookahead state, advance the break position to the lookahead position
      # (the theory here is that if there are no characters at all after the lookahead
      # position, that always matches the lookahead criteria)
      if ((c).equal?(CharacterIterator::DONE) && (lookahead_result).equal?(text.get_end_index))
        result = lookahead_result
      end
      text.set_index(result)
      return result
    end
    
    typesig { [] }
    # This method backs the iterator back up to a "safe position" in the text.
    # This is a position that we know, without any context, must be a break position.
    # The various calling methods then iterate forward from this safe position to
    # the appropriate position to return.  (For more information, see the description
    # of buildBackwardsStateTable() in RuleBasedBreakIterator.Builder.)
    def handle_previous
      text = get_text
      state = START_STATE
      category = 0
      last_category = 0
      c = get_current
      # loop until we reach the beginning of the text or transition to state 0
      while (!(c).equal?(CharacterIterator::DONE) && !(state).equal?(STOP_STATE))
        # save the last character's category and look up the current
        # character's category
        last_category = category
        category = lookup_category(c)
        # if the current character isn't an ignore character, look up a
        # state transition in the backwards state table
        if (!(category).equal?(IGNORE))
          state = lookup_backward_state(state, category)
        end
        # then advance one character backwards
        c = get_previous
      end
      # if we didn't march off the beginning of the text, we're either one or two
      # positions away from the real break position.  (One because of the call to
      # previous() at the end of the loop above, and another because the character
      # that takes us into the stop state will always be the character BEFORE
      # the break position.)
      if (!(c).equal?(CharacterIterator::DONE))
        if (!(last_category).equal?(IGNORE))
          get_next
          get_next
        else
          get_next
        end
      end
      return text.get_index
    end
    
    typesig { [::Java::Int] }
    # Looks up a character's category (i.e., its category for breaking purposes,
    # not its Unicode category)
    def lookup_category(c)
      if (c < Character::MIN_SUPPLEMENTARY_CODE_POINT)
        return @char_category_table.element_at(RJava.cast_to_char(c))
      else
        return @supplementary_char_category_table.get_value(c)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Given a current state and a character category, looks up the
    # next state to transition to in the state table.
    def lookup_state(state, category)
      return @state_table[state * @num_categories + category]
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Given a current state and a character category, looks up the
    # next state to transition to in the backwards state table.
    def lookup_backward_state(state, category)
      return @backwards_state_table[state * @num_categories + category]
    end
    
    class_module.module_eval {
      # This class exists to work around a bug in incorrect implementations
      # of CharacterIterator, which incorrectly handle setIndex(endIndex).
      # This iterator relies only on base.setIndex(n) where n is less than
      # endIndex.
      # 
      # One caveat:  if the base iterator's begin and end indices change
      # the change will not be reflected by this wrapper.  Does that matter?
      const_set_lazy(:SafeCharIterator) { Class.new do
        include_class_members RuleBasedBreakIterator
        include CharacterIterator
        include Cloneable
        
        attr_accessor :base
        alias_method :attr_base, :base
        undef_method :base
        alias_method :attr_base=, :base=
        undef_method :base=
        
        attr_accessor :range_start
        alias_method :attr_range_start, :range_start
        undef_method :range_start
        alias_method :attr_range_start=, :range_start=
        undef_method :range_start=
        
        attr_accessor :range_limit
        alias_method :attr_range_limit, :range_limit
        undef_method :range_limit
        alias_method :attr_range_limit=, :range_limit=
        undef_method :range_limit=
        
        attr_accessor :current_index
        alias_method :attr_current_index, :current_index
        undef_method :current_index
        alias_method :attr_current_index=, :current_index=
        undef_method :current_index=
        
        typesig { [class_self::CharacterIterator] }
        def initialize(base)
          @base = nil
          @range_start = 0
          @range_limit = 0
          @current_index = 0
          @base = base
          @range_start = base.get_begin_index
          @range_limit = base.get_end_index
          @current_index = base.get_index
        end
        
        typesig { [] }
        def first
          return set_index(@range_start)
        end
        
        typesig { [] }
        def last
          return set_index(@range_limit - 1)
        end
        
        typesig { [] }
        def current
          if (@current_index < @range_start || @current_index >= @range_limit)
            return DONE
          else
            return @base.set_index(@current_index)
          end
        end
        
        typesig { [] }
        def next_
          @current_index += 1
          if (@current_index >= @range_limit)
            @current_index = @range_limit
            return DONE
          else
            return @base.set_index(@current_index)
          end
        end
        
        typesig { [] }
        def previous
          @current_index -= 1
          if (@current_index < @range_start)
            @current_index = @range_start
            return DONE
          else
            return @base.set_index(@current_index)
          end
        end
        
        typesig { [::Java::Int] }
        def set_index(i)
          if (i < @range_start || i > @range_limit)
            raise self.class::IllegalArgumentException.new("Invalid position")
          end
          @current_index = i
          return current
        end
        
        typesig { [] }
        def get_begin_index
          return @range_start
        end
        
        typesig { [] }
        def get_end_index
          return @range_limit
        end
        
        typesig { [] }
        def get_index
          return @current_index
        end
        
        typesig { [] }
        def clone
          copy = nil
          begin
            copy = super
          rescue self.class::CloneNotSupportedException => e
            raise self.class::JavaError.new("Clone not supported: " + RJava.cast_to_string(e))
          end
          copy_of_base = @base.clone
          copy.attr_base = copy_of_base
          return copy
        end
        
        private
        alias_method :initialize__safe_char_iterator, :initialize
      end }
    }
    
    private
    alias_method :initialize__rule_based_break_iterator, :initialize
  end
  
end

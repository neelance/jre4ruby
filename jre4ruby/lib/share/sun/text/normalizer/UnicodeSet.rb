require "rjava"

# Portions Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
#                                                                             *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module UnicodeSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Text, :ParsePosition
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :TreeSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Collection
    }
  end
  
  # A mutable set of Unicode characters and multicharacter strings.  Objects of this class
  # represent <em>character classes</em> used in regular expressions.
  # A character specifies a subset of Unicode code points.  Legal
  # code points are U+0000 to U+10FFFF, inclusive.
  # 
  # <p>The UnicodeSet class is not designed to be subclassed.
  # 
  # <p><code>UnicodeSet</code> supports two APIs. The first is the
  # <em>operand</em> API that allows the caller to modify the value of
  # a <code>UnicodeSet</code> object. It conforms to Java 2's
  # <code>java.util.Set</code> interface, although
  # <code>UnicodeSet</code> does not actually implement that
  # interface. All methods of <code>Set</code> are supported, with the
  # modification that they take a character range or single character
  # instead of an <code>Object</code>, and they take a
  # <code>UnicodeSet</code> instead of a <code>Collection</code>.  The
  # operand API may be thought of in terms of boolean logic: a boolean
  # OR is implemented by <code>add</code>, a boolean AND is implemented
  # by <code>retain</code>, a boolean XOR is implemented by
  # <code>complement</code> taking an argument, and a boolean NOT is
  # implemented by <code>complement</code> with no argument.  In terms
  # of traditional set theory function names, <code>add</code> is a
  # union, <code>retain</code> is an intersection, <code>remove</code>
  # is an asymmetric difference, and <code>complement</code> with no
  # argument is a set complement with respect to the superset range
  # <code>MIN_VALUE-MAX_VALUE</code>
  # 
  # <p>The second API is the
  # <code>applyPattern()</code>/<code>toPattern()</code> API from the
  # <code>java.text.Format</code>-derived classes.  Unlike the
  # methods that add characters, add categories, and control the logic
  # of the set, the method <code>applyPattern()</code> sets all
  # attributes of a <code>UnicodeSet</code> at once, based on a
  # string pattern.
  # 
  # <p><b>Pattern syntax</b></p>
  # 
  # Patterns are accepted by the constructors and the
  # <code>applyPattern()</code> methods and returned by the
  # <code>toPattern()</code> method.  These patterns follow a syntax
  # similar to that employed by version 8 regular expression character
  # classes.  Here are some simple examples:
  # 
  # <blockquote>
  #   <table>
  #     <tr align="top">
  #       <td nowrap valign="top" align="left"><code>[]</code></td>
  #       <td valign="top">No characters</td>
  #     </tr><tr align="top">
  #       <td nowrap valign="top" align="left"><code>[a]</code></td>
  #       <td valign="top">The character 'a'</td>
  #     </tr><tr align="top">
  #       <td nowrap valign="top" align="left"><code>[ae]</code></td>
  #       <td valign="top">The characters 'a' and 'e'</td>
  #     </tr>
  #     <tr>
  #       <td nowrap valign="top" align="left"><code>[a-e]</code></td>
  #       <td valign="top">The characters 'a' through 'e' inclusive, in Unicode code
  #       point order</td>
  #     </tr>
  #     <tr>
  #       <td nowrap valign="top" align="left"><code>[\\u4E01]</code></td>
  #       <td valign="top">The character U+4E01</td>
  #     </tr>
  #     <tr>
  #       <td nowrap valign="top" align="left"><code>[a{ab}{ac}]</code></td>
  #       <td valign="top">The character 'a' and the multicharacter strings &quot;ab&quot; and
  #       &quot;ac&quot;</td>
  #     </tr>
  #     <tr>
  #       <td nowrap valign="top" align="left"><code>[\p{Lu}]</code></td>
  #       <td valign="top">All characters in the general category Uppercase Letter</td>
  #     </tr>
  #   </table>
  # </blockquote>
  # 
  # Any character may be preceded by a backslash in order to remove any special
  # meaning.  White space characters, as defined by UCharacterProperty.isRuleWhiteSpace(), are
  # ignored, unless they are escaped.
  # 
  # <p>Property patterns specify a set of characters having a certain
  # property as defined by the Unicode standard.  Both the POSIX-like
  # "[:Lu:]" and the Perl-like syntax "\p{Lu}" are recognized.  For a
  # complete list of supported property patterns, see the User's Guide
  # for UnicodeSet at
  # <a href="http://oss.software.ibm.com/icu/userguide/unicodeSet.html">
  # http://oss.software.ibm.com/icu/userguide/unicodeSet.html</a>.
  # Actual determination of property data is defined by the underlying
  # Unicode database as implemented by UCharacter.
  # 
  # <p>Patterns specify individual characters, ranges of characters, and
  # Unicode property sets.  When elements are concatenated, they
  # specify their union.  To complement a set, place a '^' immediately
  # after the opening '['.  Property patterns are inverted by modifying
  # their delimiters; "[:^foo]" and "\P{foo}".  In any other location,
  # '^' has no special meaning.
  # 
  # <p>Ranges are indicated by placing two a '-' between two
  # characters, as in "a-z".  This specifies the range of all
  # characters from the left to the right, in Unicode order.  If the
  # left character is greater than or equal to the
  # right character it is a syntax error.  If a '-' occurs as the first
  # character after the opening '[' or '[^', or if it occurs as the
  # last character before the closing ']', then it is taken as a
  # literal.  Thus "[a\\-b]", "[-ab]", and "[ab-]" all indicate the same
  # set of three characters, 'a', 'b', and '-'.
  # 
  # <p>Sets may be intersected using the '&' operator or the asymmetric
  # set difference may be taken using the '-' operator, for example,
  # "[[:L:]&[\\u0000-\\u0FFF]]" indicates the set of all Unicode letters
  # with values less than 4096.  Operators ('&' and '|') have equal
  # precedence and bind left-to-right.  Thus
  # "[[:L:]-[a-z]-[\\u0100-\\u01FF]]" is equivalent to
  # "[[[:L:]-[a-z]]-[\\u0100-\\u01FF]]".  This only really matters for
  # difference; intersection is commutative.
  # 
  # <table>
  # <tr valign=top><td nowrap><code>[a]</code><td>The set containing 'a'
  # <tr valign=top><td nowrap><code>[a-z]</code><td>The set containing 'a'
  # through 'z' and all letters in between, in Unicode order
  # <tr valign=top><td nowrap><code>[^a-z]</code><td>The set containing
  # all characters but 'a' through 'z',
  # that is, U+0000 through 'a'-1 and 'z'+1 through U+10FFFF
  # <tr valign=top><td nowrap><code>[[<em>pat1</em>][<em>pat2</em>]]</code>
  # <td>The union of sets specified by <em>pat1</em> and <em>pat2</em>
  # <tr valign=top><td nowrap><code>[[<em>pat1</em>]&[<em>pat2</em>]]</code>
  # <td>The intersection of sets specified by <em>pat1</em> and <em>pat2</em>
  # <tr valign=top><td nowrap><code>[[<em>pat1</em>]-[<em>pat2</em>]]</code>
  # <td>The asymmetric difference of sets specified by <em>pat1</em> and
  # <em>pat2</em>
  # <tr valign=top><td nowrap><code>[:Lu:] or \p{Lu}</code>
  # <td>The set of characters having the specified
  # Unicode property; in
  # this case, Unicode uppercase letters
  # <tr valign=top><td nowrap><code>[:^Lu:] or \P{Lu}</code>
  # <td>The set of characters <em>not</em> having the given
  # Unicode property
  # </table>
  # 
  # <p><b>Warning</b>: you cannot add an empty string ("") to a UnicodeSet.</p>
  # 
  # <p><b>Formal syntax</b></p>
  # 
  # <blockquote>
  #   <table>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>pattern :=&nbsp; </code></td>
  #       <td valign="top"><code>('[' '^'? item* ']') |
  #       property</code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>item :=&nbsp; </code></td>
  #       <td valign="top"><code>char | (char '-' char) | pattern-expr<br>
  #       </code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>pattern-expr :=&nbsp; </code></td>
  #       <td valign="top"><code>pattern | pattern-expr pattern |
  #       pattern-expr op pattern<br>
  #       </code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>op :=&nbsp; </code></td>
  #       <td valign="top"><code>'&amp;' | '-'<br>
  #       </code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>special :=&nbsp; </code></td>
  #       <td valign="top"><code>'[' | ']' | '-'<br>
  #       </code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>char :=&nbsp; </code></td>
  #       <td valign="top"><em>any character that is not</em><code> special<br>
  #       | ('\\' </code><em>any character</em><code>)<br>
  #       | ('&#92;u' hex hex hex hex)<br>
  #       </code></td>
  #     </tr>
  #     <tr align="top">
  #       <td nowrap valign="top" align="right"><code>hex :=&nbsp; </code></td>
  #       <td valign="top"><em>any character for which
  #       </em><code>Character.digit(c, 16)</code><em>
  #       returns a non-negative result</em></td>
  #     </tr>
  #     <tr>
  #       <td nowrap valign="top" align="right"><code>property :=&nbsp; </code></td>
  #       <td valign="top"><em>a Unicode property set pattern</td>
  #     </tr>
  #   </table>
  #   <br>
  #   <table border="1">
  #     <tr>
  #       <td>Legend: <table>
  #         <tr>
  #           <td nowrap valign="top"><code>a := b</code></td>
  #           <td width="20" valign="top">&nbsp; </td>
  #           <td valign="top"><code>a</code> may be replaced by <code>b</code> </td>
  #         </tr>
  #         <tr>
  #           <td nowrap valign="top"><code>a?</code></td>
  #           <td valign="top"></td>
  #           <td valign="top">zero or one instance of <code>a</code><br>
  #           </td>
  #         </tr>
  #         <tr>
  #           <td nowrap valign="top"><code>a*</code></td>
  #           <td valign="top"></td>
  #           <td valign="top">one or more instances of <code>a</code><br>
  #           </td>
  #         </tr>
  #         <tr>
  #           <td nowrap valign="top"><code>a | b</code></td>
  #           <td valign="top"></td>
  #           <td valign="top">either <code>a</code> or <code>b</code><br>
  #           </td>
  #         </tr>
  #         <tr>
  #           <td nowrap valign="top"><code>'a'</code></td>
  #           <td valign="top"></td>
  #           <td valign="top">the literal string between the quotes </td>
  #         </tr>
  #       </table>
  #       </td>
  #     </tr>
  #   </table>
  # </blockquote>
  # 
  # @author Alan Liu
  # @stable ICU 2.0
  class UnicodeSet 
    include_class_members UnicodeSetImports
    include UnicodeMatcher
    
    class_module.module_eval {
      const_set_lazy(:LOW) { 0x0 }
      const_attr_reader  :LOW
      
      # LOW <= all valid values. ZERO for codepoints
      const_set_lazy(:HIGH) { 0x110000 }
      const_attr_reader  :HIGH
      
      # HIGH > all valid values. 10000 for code units.
      # 110000 for codepoints
      # Minimum value that can be stored in a UnicodeSet.
      # @stable ICU 2.0
      const_set_lazy(:MIN_VALUE) { LOW }
      const_attr_reader  :MIN_VALUE
      
      # Maximum value that can be stored in a UnicodeSet.
      # @stable ICU 2.0
      const_set_lazy(:MAX_VALUE) { HIGH - 1 }
      const_attr_reader  :MAX_VALUE
    }
    
    attr_accessor :len
    alias_method :attr_len, :len
    undef_method :len
    alias_method :attr_len=, :len=
    undef_method :len=
    
    # length used; list may be longer to minimize reallocs
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    # MUST be terminated with HIGH
    attr_accessor :range_list
    alias_method :attr_range_list, :range_list
    undef_method :range_list
    alias_method :attr_range_list=, :range_list=
    undef_method :range_list=
    
    # internal buffer
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # internal buffer
    # NOTE: normally the field should be of type SortedSet; but that is missing a public clone!!
    # is not private so that UnicodeSetIterator can get access
    attr_accessor :strings
    alias_method :attr_strings, :strings
    undef_method :strings
    alias_method :attr_strings=, :strings=
    undef_method :strings=
    
    # The pattern representation of this set.  This may not be the
    # most economical pattern.  It is the pattern supplied to
    # applyPattern(), with variables substituted and whitespace
    # removed.  For sets constructed without applyPattern(), or
    # modified using the non-pattern API, this string will be null,
    # indicating that toPattern() must generate a pattern
    # representation from the inversion list.
    attr_accessor :pat
    alias_method :attr_pat, :pat
    undef_method :pat
    alias_method :attr_pat=, :pat=
    undef_method :pat=
    
    class_module.module_eval {
      const_set_lazy(:START_EXTRA) { 16 }
      const_attr_reader  :START_EXTRA
      
      # initial storage. Must be >= 0
      const_set_lazy(:GROW_EXTRA) { START_EXTRA }
      const_attr_reader  :GROW_EXTRA
      
      # extra amount for growth. Must be >= 0
      # A set of all characters _except_ the second through last characters of
      # certain ranges.  These ranges are ranges of characters whose
      # properties are all exactly alike, e.g. CJK Ideographs from
      # U+4E00 to U+9FA5.
      
      def inclusions
        defined?(@@inclusions) ? @@inclusions : @@inclusions= nil
      end
      alias_method :attr_inclusions, :inclusions
      
      def inclusions=(value)
        @@inclusions = value
      end
      alias_method :attr_inclusions=, :inclusions=
    }
    
    typesig { [] }
    # ----------------------------------------------------------------
    # Public API
    # ----------------------------------------------------------------
    # Constructs an empty set.
    # @stable ICU 2.0
    def initialize
      @len = 0
      @list = nil
      @range_list = nil
      @buffer = nil
      @strings = TreeSet.new
      @pat = nil
      @list = Array.typed(::Java::Int).new(1 + START_EXTRA) { 0 }
      @list[((@len += 1) - 1)] = HIGH
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs a set containing the given range. If <code>end >
    # start</code> then an empty set is created.
    # 
    # @param start first character, inclusive, of range
    # @param end last character, inclusive, of range
    # @stable ICU 2.0
    def initialize(start, end_)
      initialize__unicode_set()
      complement(start, end_)
    end
    
    typesig { [String] }
    # Constructs a set from the given pattern.  See the class description
    # for the syntax of the pattern language.  Whitespace is ignored.
    # @param pattern a string specifying what characters are in the set
    # @exception java.lang.IllegalArgumentException if the pattern contains
    # a syntax error.
    # @stable ICU 2.0
    def initialize(pattern)
      initialize__unicode_set()
      apply_pattern(pattern, nil, nil, IGNORE_SPACE)
    end
    
    typesig { [UnicodeSet] }
    # Make this object represent the same set as <code>other</code>.
    # @param other a <code>UnicodeSet</code> whose value will be
    # copied to this object
    # @stable ICU 2.0
    def set(other)
      @list = other.attr_list.clone
      @len = other.attr_len
      @pat = RJava.cast_to_string(other.attr_pat)
      @strings = other.attr_strings.clone
      return self
    end
    
    typesig { [String] }
    # Modifies this set to represent the set specified by the given pattern.
    # See the class description for the syntax of the pattern language.
    # Whitespace is ignored.
    # @param pattern a string specifying what characters are in the set
    # @exception java.lang.IllegalArgumentException if the pattern
    # contains a syntax error.
    # @stable ICU 2.0
    def apply_pattern(pattern)
      return apply_pattern(pattern, nil, nil, IGNORE_SPACE)
    end
    
    class_module.module_eval {
      typesig { [StringBuffer, String, ::Java::Boolean] }
      # Append the <code>toPattern()</code> representation of a
      # string to the given <code>StringBuffer</code>.
      def __append_to_pat(buf, s, escape_unprintable)
        i = 0
        while i < s.length
          __append_to_pat(buf, UTF16.char_at(s, i), escape_unprintable)
          i += UTF16.get_char_count(i)
        end
      end
      
      typesig { [StringBuffer, ::Java::Int, ::Java::Boolean] }
      # Append the <code>toPattern()</code> representation of a
      # character to the given <code>StringBuffer</code>.
      def __append_to_pat(buf, c, escape_unprintable)
        if (escape_unprintable && Utility.is_unprintable(c))
          # Use hex escape notation (<backslash>uxxxx or <backslash>Uxxxxxxxx) for anything
          # unprintable
          if (Utility.escape_unprintable(buf, c))
            return
          end
        end
        # Okay to let ':' pass through
        case (c)
        when Character.new(?[.ord), Character.new(?].ord), Character.new(?-.ord), Character.new(?^.ord), Character.new(?&.ord), Character.new(?\\.ord), Character.new(?{.ord), Character.new(?}.ord), Character.new(?$.ord), Character.new(?:.ord)
          # SET_OPEN:
          # SET_CLOSE:
          # HYPHEN:
          # COMPLEMENT:
          # INTERSECTION:
          # BACKSLASH:
          buf.append(Character.new(?\\.ord))
        else
          # Escape whitespace
          if (UCharacterProperty.is_rule_white_space(c))
            buf.append(Character.new(?\\.ord))
          end
        end
        UTF16.append(buf, c)
      end
    }
    
    typesig { [StringBuffer, ::Java::Boolean] }
    # Append a string representation of this set to result.  This will be
    # a cleaned version of the string passed to applyPattern(), if there
    # is one.  Otherwise it will be generated.
    def __to_pattern(result, escape_unprintable_)
      if (!(@pat).nil?)
        i = 0
        backslash_count = 0
        i = 0
        while i < @pat.length
          c = UTF16.char_at(@pat, i)
          i += UTF16.get_char_count(c)
          if (escape_unprintable_ && Utility.is_unprintable(c))
            # If the unprintable character is preceded by an odd
            # number of backslashes, then it has been escaped.
            # Before unescaping it, we delete the final
            # backslash.
            if (((backslash_count % 2)).equal?(1))
              result.set_length(result.length - 1)
            end
            Utility.escape_unprintable(result, c)
            backslash_count = 0
          else
            UTF16.append(result, c)
            if ((c).equal?(Character.new(?\\.ord)))
              (backslash_count += 1)
            else
              backslash_count = 0
            end
          end
        end
        return result
      end
      return __generate_pattern(result, escape_unprintable_)
    end
    
    typesig { [StringBuffer, ::Java::Boolean] }
    # Generate and append a string representation of this set to result.
    # This does not use this.pat, the cleaned up copy of the string
    # passed to applyPattern().
    # @stable ICU 2.0
    def __generate_pattern(result, escape_unprintable_)
      result.append(Character.new(?[.ord))
      count = get_range_count
      # If the set contains at least 2 intervals and includes both
      # MIN_VALUE and MAX_VALUE, then the inverse representation will
      # be more economical.
      if (count > 1 && (get_range_start(0)).equal?(MIN_VALUE) && (get_range_end(count - 1)).equal?(MAX_VALUE))
        # Emit the inverse
        result.append(Character.new(?^.ord))
        i = 1
        while i < count
          start = get_range_end(i - 1) + 1
          end_ = get_range_start(i) - 1
          __append_to_pat(result, start, escape_unprintable_)
          if (!(start).equal?(end_))
            if (!((start + 1)).equal?(end_))
              result.append(Character.new(?-.ord))
            end
            __append_to_pat(result, end_, escape_unprintable_)
          end
          (i += 1)
        end
        # Default; emit the ranges as pairs
      else
        i = 0
        while i < count
          start = get_range_start(i)
          end_ = get_range_end(i)
          __append_to_pat(result, start, escape_unprintable_)
          if (!(start).equal?(end_))
            if (!((start + 1)).equal?(end_))
              result.append(Character.new(?-.ord))
            end
            __append_to_pat(result, end_, escape_unprintable_)
          end
          (i += 1)
        end
      end
      if (@strings.size > 0)
        it = @strings.iterator
        while (it.has_next)
          result.append(Character.new(?{.ord))
          __append_to_pat(result, it.next_, escape_unprintable_)
          result.append(Character.new(?}.ord))
        end
      end
      return result.append(Character.new(?].ord))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the specified range to this set if it is not already
    # present.  If this set already contains the specified range,
    # the call leaves this set unchanged.  If <code>end > start</code>
    # then an empty range is added, leaving the set unchanged.
    # 
    # @param start first character, inclusive, of range to be added
    # to this set.
    # @param end last character, inclusive, of range to be added
    # to this set.
    # @stable ICU 2.0
    def add(start, end_)
      if (start < MIN_VALUE || start > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(start, 6)))
      end
      if (end_ < MIN_VALUE || end_ > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(end_, 6)))
      end
      if (start < end_)
        add(range(start, end_), 2, 0)
      else
        if ((start).equal?(end_))
          add(start)
        end
      end
      return self
    end
    
    typesig { [::Java::Int] }
    # Adds the specified character to this set if it is not already
    # present.  If this set already contains the specified character,
    # the call leaves this set unchanged.
    # @stable ICU 2.0
    def add(c)
      if (c < MIN_VALUE || c > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(c, 6)))
      end
      # find smallest i such that c < list[i]
      # if odd, then it is IN the set
      # if even, then it is OUT of the set
      i = find_code_point(c)
      # already in set?
      if (!((i & 1)).equal?(0))
        return self
      end
      # HIGH is 0x110000
      # assert(list[len-1] == HIGH);
      # empty = [HIGH]
      # [start_0, limit_0, start_1, limit_1, HIGH]
      # [..., start_k-1, limit_k-1, start_k, limit_k, ..., HIGH]
      #                             ^
      #                             list[i]
      # i == 0 means c is before the first range
      if ((c).equal?(@list[i] - 1))
        # c is before start of next range
        @list[i] = c
        # if we touched the HIGH mark, then add a new one
        if ((c).equal?(MAX_VALUE))
          ensure_capacity(@len + 1)
          @list[((@len += 1) - 1)] = HIGH
        end
        if (i > 0 && (c).equal?(@list[i - 1]))
          # collapse adjacent ranges
          # [..., start_k-1, c, c, limit_k, ..., HIGH]
          #                     ^
          #                     list[i]
          System.arraycopy(@list, i + 1, @list, i - 1, @len - i - 1)
          @len -= 2
        end
      else
        if (i > 0 && (c).equal?(@list[i - 1]))
          # c is after end of prior range
          @list[i - 1] += 1
          # no need to chcek for collapse here
        else
          # At this point we know the new char is not adjacent to
          # any existing ranges, and it is not 10FFFF.
          # [..., start_k-1, limit_k-1, start_k, limit_k, ..., HIGH]
          #                             ^
          #                             list[i]
          # [..., start_k-1, limit_k-1, c, c+1, start_k, limit_k, ..., HIGH]
          #                             ^
          #                             list[i]
          # Don't use ensureCapacity() to save on copying.
          # NOTE: This has no measurable impact on performance,
          # but it might help in some usage patterns.
          if (@len + 2 > @list.attr_length)
            temp = Array.typed(::Java::Int).new(@len + 2 + GROW_EXTRA) { 0 }
            if (!(i).equal?(0))
              System.arraycopy(@list, 0, temp, 0, i)
            end
            System.arraycopy(@list, i, temp, i + 2, @len - i)
            @list = temp
          else
            System.arraycopy(@list, i, @list, i + 2, @len - i)
          end
          @list[i] = c
          @list[i + 1] = c + 1
          @len += 2
        end
      end
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    typesig { [String] }
    # Adds the specified multicharacter to this set if it is not already
    # present.  If this set already contains the multicharacter,
    # the call leaves this set unchanged.
    # Thus "ch" => {"ch"}
    # <br><b>Warning: you cannot add an empty string ("") to a UnicodeSet.</b>
    # @param s the source string
    # @return this object, for chaining
    # @stable ICU 2.0
    def add(s)
      cp = get_single_cp(s)
      if (cp < 0)
        @strings.add(s)
        @pat = RJava.cast_to_string(nil)
      else
        add(cp, cp)
      end
      return self
    end
    
    class_module.module_eval {
      typesig { [String] }
      # @return a code point IF the string consists of a single one.
      # otherwise returns -1.
      # @param string to test
      def get_single_cp(s)
        if (s.length < 1)
          raise IllegalArgumentException.new("Can't use zero-length strings in UnicodeSet")
        end
        if (s.length > 2)
          return -1
        end
        if ((s.length).equal?(1))
          return s.char_at(0)
        end
        # at this point, len = 2
        cp = UTF16.char_at(s, 0)
        if (cp > 0xffff)
          # is surrogate pair
          return cp
        end
        return -1
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Complements the specified range in this set.  Any character in
    # the range will be removed if it is in this set, or will be
    # added if it is not in this set.  If <code>end > start</code>
    # then an empty range is complemented, leaving the set unchanged.
    # 
    # @param start first character, inclusive, of range to be removed
    # from this set.
    # @param end last character, inclusive, of range to be removed
    # from this set.
    # @stable ICU 2.0
    def complement(start, end_)
      if (start < MIN_VALUE || start > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(start, 6)))
      end
      if (end_ < MIN_VALUE || end_ > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(end_, 6)))
      end
      if (start <= end_)
        xor(range(start, end_), 2, 0)
      end
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    typesig { [] }
    # This is equivalent to
    # <code>complement(MIN_VALUE, MAX_VALUE)</code>.
    # @stable ICU 2.0
    def complement
      if ((@list[0]).equal?(LOW))
        System.arraycopy(@list, 1, @list, 0, @len - 1)
        (@len -= 1)
      else
        ensure_capacity(@len + 1)
        System.arraycopy(@list, 0, @list, 1, @len)
        @list[0] = LOW
        (@len += 1)
      end
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    typesig { [::Java::Int] }
    # Returns true if this set contains the given character.
    # @param c character to be checked for containment
    # @return true if the test condition is met
    # @stable ICU 2.0
    def contains(c)
      if (c < MIN_VALUE || c > MAX_VALUE)
        raise IllegalArgumentException.new("Invalid code point U+" + RJava.cast_to_string(Utility.hex(c, 6)))
      end
      # // Set i to the index of the start item greater than ch
      # // We know we will terminate without length test!
      # int i = -1;
      # while (true) {
      #     if (c < list[++i]) break;
      # }
      i = find_code_point(c)
      return (!((i & 1)).equal?(0)) # return true if odd
    end
    
    typesig { [::Java::Int] }
    # Returns the smallest value i such that c < list[i].  Caller
    # must ensure that c is a legal value or this method will enter
    # an infinite loop.  This method performs a binary search.
    # @param c a character in the range MIN_VALUE..MAX_VALUE
    # inclusive
    # @return the smallest integer i in the range 0..len-1,
    # inclusive, such that c < list[i]
    def find_code_point(c)
      # Examples:
      #                                 findCodePoint(c)
      # set              list[]         c=0 1 3 4 7 8
      # ===              ==============   ===========
      # []               [110000]         0 0 0 0 0 0
      # [\u0000-\u0003]  [0, 4, 110000]   1 1 1 2 2 2
      # [\u0004-\u0007]  [4, 8, 110000]   0 0 0 1 1 2
      # [:all:]          [0, 110000]      1 1 1 1 1 1
      # Return the smallest i such that c < list[i].  Assume
      # list[len - 1] == HIGH and that c is legal (0..HIGH-1).
      if (c < @list[0])
        return 0
      end
      # High runner test.  c is often after the last range, so an
      # initial check for this condition pays off.
      if (@len >= 2 && c >= @list[@len - 2])
        return @len - 1
      end
      lo = 0
      hi = @len - 1
      # invariant: c >= list[lo]
      # invariant: c < list[hi]
      loop do
        i = (lo + hi) >> 1
        if ((i).equal?(lo))
          return hi
        end
        if (c < @list[i])
          hi = i
        else
          lo = i
        end
      end
    end
    
    typesig { [UnicodeSet] }
    # Adds all of the elements in the specified set to this set if
    # they're not already present.  This operation effectively
    # modifies this set so that its value is the <i>union</i> of the two
    # sets.  The behavior of this operation is unspecified if the specified
    # collection is modified while the operation is in progress.
    # 
    # @param c set whose elements are to be added to this set.
    # @stable ICU 2.0
    def add_all(c)
      add(c.attr_list, c.attr_len, 0)
      @strings.add_all(c.attr_strings)
      return self
    end
    
    typesig { [UnicodeSet] }
    # Retains only the elements in this set that are contained in the
    # specified set.  In other words, removes from this set all of
    # its elements that are not contained in the specified set.  This
    # operation effectively modifies this set so that its value is
    # the <i>intersection</i> of the two sets.
    # 
    # @param c set that defines which elements this set will retain.
    # @stable ICU 2.0
    def retain_all(c)
      retain(c.attr_list, c.attr_len, 0)
      @strings.retain_all(c.attr_strings)
      return self
    end
    
    typesig { [UnicodeSet] }
    # Removes from this set all of its elements that are contained in the
    # specified set.  This operation effectively modifies this
    # set so that its value is the <i>asymmetric set difference</i> of
    # the two sets.
    # 
    # @param c set that defines which elements will be removed from
    #          this set.
    # @stable ICU 2.0
    def remove_all(c)
      retain(c.attr_list, c.attr_len, 2)
      @strings.remove_all(c.attr_strings)
      return self
    end
    
    typesig { [] }
    # Removes all of the elements from this set.  This set will be
    # empty after this call returns.
    # @stable ICU 2.0
    def clear
      @list[0] = HIGH
      @len = 1
      @pat = RJava.cast_to_string(nil)
      @strings.clear
      return self
    end
    
    typesig { [] }
    # Iteration method that returns the number of ranges contained in
    # this set.
    # @see #getRangeStart
    # @see #getRangeEnd
    # @stable ICU 2.0
    def get_range_count
      return @len / 2
    end
    
    typesig { [::Java::Int] }
    # Iteration method that returns the first character in the
    # specified range of this set.
    # @exception ArrayIndexOutOfBoundsException if index is outside
    # the range <code>0..getRangeCount()-1</code>
    # @see #getRangeCount
    # @see #getRangeEnd
    # @stable ICU 2.0
    def get_range_start(index)
      return @list[index * 2]
    end
    
    typesig { [::Java::Int] }
    # Iteration method that returns the last character in the
    # specified range of this set.
    # @exception ArrayIndexOutOfBoundsException if index is outside
    # the range <code>0..getRangeCount()-1</code>
    # @see #getRangeStart
    # @see #getRangeEnd
    # @stable ICU 2.0
    def get_range_end(index)
      return (@list[index * 2 + 1] - 1)
    end
    
    typesig { [String, ParsePosition, SymbolTable, ::Java::Int] }
    # ----------------------------------------------------------------
    # Implementation: Pattern parsing
    # ----------------------------------------------------------------
    # Parses the given pattern, starting at the given position.  The character
    # at pattern.charAt(pos.getIndex()) must be '[', or the parse fails.
    # Parsing continues until the corresponding closing ']'.  If a syntax error
    # is encountered between the opening and closing brace, the parse fails.
    # Upon return from a successful parse, the ParsePosition is updated to
    # point to the character following the closing ']', and an inversion
    # list for the parsed pattern is returned.  This method
    # calls itself recursively to parse embedded subpatterns.
    # 
    # @param pattern the string containing the pattern to be parsed.  The
    # portion of the string from pos.getIndex(), which must be a '[', to the
    # corresponding closing ']', is parsed.
    # @param pos upon entry, the position at which to being parsing.  The
    # character at pattern.charAt(pos.getIndex()) must be a '['.  Upon return
    # from a successful parse, pos.getIndex() is either the character after the
    # closing ']' of the parsed pattern, or pattern.length() if the closing ']'
    # is the last character of the pattern string.
    # @return an inversion list for the parsed substring
    # of <code>pattern</code>
    # @exception java.lang.IllegalArgumentException if the parse fails.
    def apply_pattern(pattern, pos, symbols, options)
      # Need to build the pattern in a temporary string because
      # _applyPattern calls add() etc., which set pat to empty.
      parse_position_was_null = (pos).nil?
      if (parse_position_was_null)
        pos = ParsePosition.new(0)
      end
      rebuilt_pat = StringBuffer.new
      chars = RuleCharacterIterator.new(pattern, symbols, pos)
      apply_pattern(chars, symbols, rebuilt_pat, options)
      if (chars.in_variable)
        syntax_error(chars, "Extra chars in variable value")
      end
      @pat = RJava.cast_to_string(rebuilt_pat.to_s)
      if (parse_position_was_null)
        i = pos.get_index
        # Skip over trailing whitespace
        if (!((options & IGNORE_SPACE)).equal?(0))
          i = Utility.skip_whitespace(pattern, i)
        end
        if (!(i).equal?(pattern.length))
          raise IllegalArgumentException.new("Parse of \"" + pattern + "\" failed at " + RJava.cast_to_string(i))
        end
      end
      return self
    end
    
    typesig { [RuleCharacterIterator, SymbolTable, StringBuffer, ::Java::Int] }
    # Parse the pattern from the given RuleCharacterIterator.  The
    # iterator is advanced over the parsed pattern.
    # @param chars iterator over the pattern characters.  Upon return
    # it will be advanced to the first character after the parsed
    # pattern, or the end of the iteration if all characters are
    # parsed.
    # @param symbols symbol table to use to parse and dereference
    # variables, or null if none.
    # @param rebuiltPat the pattern that was parsed, rebuilt or
    # copied from the input pattern, as appropriate.
    # @param options a bit mask of zero or more of the following:
    # IGNORE_SPACE, CASE.
    def apply_pattern(chars, symbols, rebuilt_pat, options)
      # Syntax characters: [ ] ^ - & { }
      # Recognized special forms for chars, sets: c-c s-s s&s
      opts = RuleCharacterIterator::PARSE_VARIABLES | RuleCharacterIterator::PARSE_ESCAPES
      if (!((options & IGNORE_SPACE)).equal?(0))
        opts |= RuleCharacterIterator::SKIP_WHITESPACE
      end
      pat = StringBuffer.new
      buf = nil
      use_pat = false
      scratch = nil
      backup = nil
      # mode: 0=before [, 1=between [...], 2=after ]
      # lastItem: 0=none, 1=char, 2=set
      last_item = 0
      last_char = 0
      mode = 0
      op = 0
      invert = false
      clear
      while (!(mode).equal?(2) && !chars.at_end)
        if (false)
          # Debugging assertion
          if (!(((last_item).equal?(0) && (op).equal?(0)) || ((last_item).equal?(1) && ((op).equal?(0) || (op).equal?(Character.new(?-.ord)))) || ((last_item).equal?(2) && ((op).equal?(0) || (op).equal?(Character.new(?-.ord)) || (op).equal?(Character.new(?&.ord))))))
            raise IllegalArgumentException.new
          end
        end
        c = 0
        literal = false
        nested = nil
        # -------- Check for property pattern
        # setMode: 0=none, 1=unicodeset, 2=propertypat, 3=preparsed
        set_mode = 0
        if (resembles_property_pattern(chars, opts))
          set_mode = 2
          # -------- Parse '[' of opening delimiter OR nested set.
          # If there is a nested set, use `setMode' to define how
          # the set should be parsed.  If the '[' is part of the
          # opening delimiter for this pattern, parse special
          # strings "[", "[^", "[-", and "[^-".  Check for stand-in
          # characters representing a nested set in the symbol
          # table.
        else
          # Prepare to backup if necessary
          backup = chars.get_pos(backup)
          c = chars.next_(opts)
          literal = chars.is_escaped
          if ((c).equal?(Character.new(?[.ord)) && !literal)
            if ((mode).equal?(1))
              chars.set_pos(backup) # backup
              set_mode = 1
            else
              # Handle opening '[' delimiter
              mode = 1
              pat.append(Character.new(?[.ord))
              backup = chars.get_pos(backup) # prepare to backup
              c = chars.next_(opts)
              literal = chars.is_escaped
              if ((c).equal?(Character.new(?^.ord)) && !literal)
                invert = true
                pat.append(Character.new(?^.ord))
                backup = chars.get_pos(backup) # prepare to backup
                c = chars.next_(opts)
                literal = chars.is_escaped
              end
              # Fall through to handle special leading '-';
              # otherwise restart loop for nested [], \p{}, etc.
              if ((c).equal?(Character.new(?-.ord)))
                literal = true
                # Fall through to handle literal '-' below
              else
                chars.set_pos(backup) # backup
                next
              end
            end
          else
            if (!(symbols).nil?)
              m = symbols.lookup_matcher(c) # may be null
              if (!(m).nil?)
                begin
                  nested = m
                  set_mode = 3
                rescue ClassCastException => e
                  syntax_error(chars, "Syntax error")
                end
              end
            end
          end
        end
        # -------- Handle a nested set.  This either is inline in
        # the pattern or represented by a stand-in that has
        # previously been parsed and was looked up in the symbol
        # table.
        if (!(set_mode).equal?(0))
          if ((last_item).equal?(1))
            if (!(op).equal?(0))
              syntax_error(chars, "Char expected after operator")
            end
            add(last_char, last_char)
            __append_to_pat(pat, last_char, false)
            last_item = op = 0
          end
          if ((op).equal?(Character.new(?-.ord)) || (op).equal?(Character.new(?&.ord)))
            pat.append(op)
          end
          if ((nested).nil?)
            if ((scratch).nil?)
              scratch = UnicodeSet.new
            end
            nested = scratch
          end
          case (set_mode)
          when 1
            nested.apply_pattern(chars, symbols, pat, options)
          when 2
            chars.skip_ignored(opts)
            nested.apply_property_pattern(chars, pat, symbols)
          when 3
            # `nested' already parsed
            nested.__to_pattern(pat, false)
          end
          use_pat = true
          if ((mode).equal?(0))
            # Entire pattern is a category; leave parse loop
            set(nested)
            mode = 2
            break
          end
          case (op)
          when Character.new(?-.ord)
            remove_all(nested)
          when Character.new(?&.ord)
            retain_all(nested)
          when 0
            add_all(nested)
          end
          op = 0
          last_item = 2
          next
        end
        if ((mode).equal?(0))
          syntax_error(chars, "Missing '['")
        end
        # -------- Parse special (syntax) characters.  If the
        # current character is not special, or if it is escaped,
        # then fall through and handle it below.
        if (!literal)
          catch(:break_case) do
            case (c)
            when Character.new(?].ord)
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              # Treat final trailing '-' as a literal
              if ((op).equal?(Character.new(?-.ord)))
                add(op, op)
                pat.append(op)
              else
                if ((op).equal?(Character.new(?&.ord)))
                  syntax_error(chars, "Trailing '&'")
                end
              end
              pat.append(Character.new(?].ord))
              mode = 2
              next
              if ((op).equal?(0))
                if (!(last_item).equal?(0))
                  op = RJava.cast_to_char(c)
                  next
                else
                  # Treat final trailing '-' as a literal
                  add(c, c)
                  c = chars.next_(opts)
                  literal = chars.is_escaped
                  if ((c).equal?(Character.new(?].ord)) && !literal)
                    pat.append("-]")
                    mode = 2
                    next
                  end
                end
              end
              syntax_error(chars, "'-' not after char or set")
              if ((last_item).equal?(2) && (op).equal?(0))
                op = RJava.cast_to_char(c)
                next
              end
              syntax_error(chars, "'&' not after set")
              syntax_error(chars, "'^' not after '['")
              if (!(op).equal?(0))
                syntax_error(chars, "Missing operand after operator")
              end
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              last_item = 0
              if ((buf).nil?)
                buf = StringBuffer.new
              else
                buf.set_length(0)
              end
              ok = false
              while (!chars.at_end)
                c = chars.next_(opts)
                literal = chars.is_escaped
                if ((c).equal?(Character.new(?}.ord)) && !literal)
                  ok = true
                  break
                end
                UTF16.append(buf, c)
              end
              if (buf.length < 1 || !ok)
                syntax_error(chars, "Invalid multicharacter string")
              end
              # We have new string. Add it to set and continue;
              # we don't need to drop through to the further
              # processing
              add(buf.to_s)
              pat.append(Character.new(?{.ord))
              __append_to_pat(pat, buf.to_s, false)
              pat.append(Character.new(?}.ord))
              next
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            when Character.new(?-.ord)
              if ((op).equal?(0))
                if (!(last_item).equal?(0))
                  op = RJava.cast_to_char(c)
                  next
                else
                  # Treat final trailing '-' as a literal
                  add(c, c)
                  c = chars.next_(opts)
                  literal = chars.is_escaped
                  if ((c).equal?(Character.new(?].ord)) && !literal)
                    pat.append("-]")
                    mode = 2
                    next
                  end
                end
              end
              syntax_error(chars, "'-' not after char or set")
              if ((last_item).equal?(2) && (op).equal?(0))
                op = RJava.cast_to_char(c)
                next
              end
              syntax_error(chars, "'&' not after set")
              syntax_error(chars, "'^' not after '['")
              if (!(op).equal?(0))
                syntax_error(chars, "Missing operand after operator")
              end
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              last_item = 0
              if ((buf).nil?)
                buf = StringBuffer.new
              else
                buf.set_length(0)
              end
              ok = false
              while (!chars.at_end)
                c = chars.next_(opts)
                literal = chars.is_escaped
                if ((c).equal?(Character.new(?}.ord)) && !literal)
                  ok = true
                  break
                end
                UTF16.append(buf, c)
              end
              if (buf.length < 1 || !ok)
                syntax_error(chars, "Invalid multicharacter string")
              end
              # We have new string. Add it to set and continue;
              # we don't need to drop through to the further
              # processing
              add(buf.to_s)
              pat.append(Character.new(?{.ord))
              __append_to_pat(pat, buf.to_s, false)
              pat.append(Character.new(?}.ord))
              next
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            when Character.new(?&.ord)
              if ((last_item).equal?(2) && (op).equal?(0))
                op = RJava.cast_to_char(c)
                next
              end
              syntax_error(chars, "'&' not after set")
              syntax_error(chars, "'^' not after '['")
              if (!(op).equal?(0))
                syntax_error(chars, "Missing operand after operator")
              end
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              last_item = 0
              if ((buf).nil?)
                buf = StringBuffer.new
              else
                buf.set_length(0)
              end
              ok = false
              while (!chars.at_end)
                c = chars.next_(opts)
                literal = chars.is_escaped
                if ((c).equal?(Character.new(?}.ord)) && !literal)
                  ok = true
                  break
                end
                UTF16.append(buf, c)
              end
              if (buf.length < 1 || !ok)
                syntax_error(chars, "Invalid multicharacter string")
              end
              # We have new string. Add it to set and continue;
              # we don't need to drop through to the further
              # processing
              add(buf.to_s)
              pat.append(Character.new(?{.ord))
              __append_to_pat(pat, buf.to_s, false)
              pat.append(Character.new(?}.ord))
              next
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            when Character.new(?^.ord)
              syntax_error(chars, "'^' not after '['")
              if (!(op).equal?(0))
                syntax_error(chars, "Missing operand after operator")
              end
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              last_item = 0
              if ((buf).nil?)
                buf = StringBuffer.new
              else
                buf.set_length(0)
              end
              ok = false
              while (!chars.at_end)
                c = chars.next_(opts)
                literal = chars.is_escaped
                if ((c).equal?(Character.new(?}.ord)) && !literal)
                  ok = true
                  break
                end
                UTF16.append(buf, c)
              end
              if (buf.length < 1 || !ok)
                syntax_error(chars, "Invalid multicharacter string")
              end
              # We have new string. Add it to set and continue;
              # we don't need to drop through to the further
              # processing
              add(buf.to_s)
              pat.append(Character.new(?{.ord))
              __append_to_pat(pat, buf.to_s, false)
              pat.append(Character.new(?}.ord))
              next
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            when Character.new(?{.ord)
              if (!(op).equal?(0))
                syntax_error(chars, "Missing operand after operator")
              end
              if ((last_item).equal?(1))
                add(last_char, last_char)
                __append_to_pat(pat, last_char, false)
              end
              last_item = 0
              if ((buf).nil?)
                buf = StringBuffer.new
              else
                buf.set_length(0)
              end
              ok = false
              while (!chars.at_end)
                c = chars.next_(opts)
                literal = chars.is_escaped
                if ((c).equal?(Character.new(?}.ord)) && !literal)
                  ok = true
                  break
                end
                UTF16.append(buf, c)
              end
              if (buf.length < 1 || !ok)
                syntax_error(chars, "Invalid multicharacter string")
              end
              # We have new string. Add it to set and continue;
              # we don't need to drop through to the further
              # processing
              add(buf.to_s)
              pat.append(Character.new(?{.ord))
              __append_to_pat(pat, buf.to_s, false)
              pat.append(Character.new(?}.ord))
              next
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            when SymbolTable::SYMBOL_REF
              #         symbols  nosymbols
              # [a-$]   error    error (ambiguous)
              # [a$]    anchor   anchor
              # [a-$x]  var "x"* literal '$'
              # [a-$.]  error    literal '$'
              # *We won't get here in the case of var "x"
              backup = chars.get_pos(backup)
              c = chars.next_(opts)
              literal = chars.is_escaped
              anchor = ((c).equal?(Character.new(?].ord)) && !literal)
              if ((symbols).nil? && !anchor)
                c = SymbolTable::SYMBOL_REF
                chars.set_pos(backup)
                throw :break_case, :thrown # literal '$'
              end
              if (anchor && (op).equal?(0))
                if ((last_item).equal?(1))
                  add(last_char, last_char)
                  __append_to_pat(pat, last_char, false)
                end
                add(UnicodeMatcher::ETHER)
                use_pat = true
                pat.append(SymbolTable::SYMBOL_REF).append(Character.new(?].ord))
                mode = 2
                next
              end
              syntax_error(chars, "Unquoted '$'")
            else
            end
          end == :thrown or break
        end
        # -------- Parse literal characters.  This includes both
        # escaped chars ("\u4E01") and non-syntax characters
        # ("a").
        case (last_item)
        when 0
          last_item = 1
          last_char = c
        when 1
          if ((op).equal?(Character.new(?-.ord)))
            if (last_char >= c)
              # Don't allow redundant (a-a) or empty (b-a) ranges;
              # these are most likely typos.
              syntax_error(chars, "Invalid range")
            end
            add(last_char, c)
            __append_to_pat(pat, last_char, false)
            pat.append(op)
            __append_to_pat(pat, c, false)
            last_item = op = 0
          else
            add(last_char, last_char)
            __append_to_pat(pat, last_char, false)
            last_char = c
          end
        when 2
          if (!(op).equal?(0))
            syntax_error(chars, "Set expected after operator")
          end
          last_char = c
          last_item = 1
        end
      end
      if (!(mode).equal?(2))
        syntax_error(chars, "Missing ']'")
      end
      chars.skip_ignored(opts)
      if (invert)
        complement
      end
      # Use the rebuilt pattern (pat) only if necessary.  Prefer the
      # generated pattern.
      if (use_pat)
        rebuilt_pat.append(pat.to_s)
      else
        __generate_pattern(rebuilt_pat, false)
      end
    end
    
    class_module.module_eval {
      typesig { [RuleCharacterIterator, String] }
      def syntax_error(chars, msg)
        raise IllegalArgumentException.new("Error: " + msg + " at \"" + RJava.cast_to_string(Utility.escape(chars.to_s)) + RJava.cast_to_string(Character.new(?".ord)))
      end
    }
    
    typesig { [::Java::Int] }
    # ----------------------------------------------------------------
    # Implementation: Utility methods
    # ----------------------------------------------------------------
    def ensure_capacity(new_len)
      if (new_len <= @list.attr_length)
        return
      end
      temp = Array.typed(::Java::Int).new(new_len + GROW_EXTRA) { 0 }
      System.arraycopy(@list, 0, temp, 0, @len)
      @list = temp
    end
    
    typesig { [::Java::Int] }
    def ensure_buffer_capacity(new_len)
      if (!(@buffer).nil? && new_len <= @buffer.attr_length)
        return
      end
      @buffer = Array.typed(::Java::Int).new(new_len + GROW_EXTRA) { 0 }
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Assumes start <= end.
    def range(start, end_)
      if ((@range_list).nil?)
        @range_list = Array.typed(::Java::Int).new([start, end_ + 1, HIGH])
      else
        @range_list[0] = start
        @range_list[1] = end_ + 1
      end
      return @range_list
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
    # ----------------------------------------------------------------
    # Implementation: Fundamental operations
    # ----------------------------------------------------------------
    # polarity = 0, 3 is normal: x xor y
    # polarity = 1, 2: x xor ~y == x === y
    def xor(other, other_len, polarity)
      ensure_buffer_capacity(@len + other_len)
      i = 0
      j = 0
      k = 0
      a = @list[((i += 1) - 1)]
      b = 0
      if ((polarity).equal?(1) || (polarity).equal?(2))
        b = LOW
        if ((other[j]).equal?(LOW))
          # skip base if already LOW
          (j += 1)
          b = other[j]
        end
      else
        b = other[((j += 1) - 1)]
      end
      # simplest of all the routines
      # sort the values, discarding identicals!
      while (true)
        if (a < b)
          @buffer[((k += 1) - 1)] = a
          a = @list[((i += 1) - 1)]
        else
          if (b < a)
            @buffer[((k += 1) - 1)] = b
            b = other[((j += 1) - 1)]
          else
            if (!(a).equal?(HIGH))
              # at this point, a == b
              # discard both values!
              a = @list[((i += 1) - 1)]
              b = other[((j += 1) - 1)]
            else
              # DONE!
              @buffer[((k += 1) - 1)] = HIGH
              @len = k
              break
            end
          end
        end
      end
      # swap list and buffer
      temp = @list
      @list = @buffer
      @buffer = temp
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
    # polarity = 0 is normal: x union y
    # polarity = 2: x union ~y
    # polarity = 1: ~x union y
    # polarity = 3: ~x union ~y
    def add(other, other_len, polarity)
      ensure_buffer_capacity(@len + other_len)
      i = 0
      j = 0
      k = 0
      a = @list[((i += 1) - 1)]
      b = other[((j += 1) - 1)]
      # change from xor is that we have to check overlapping pairs
      # polarity bit 1 means a is second, bit 2 means b is.
      while (true)
        case (polarity)
        when 0
          # both first; take lower if unequal
          if (a < b)
            # take a
            # Back up over overlapping ranges in buffer[]
            if (k > 0 && a <= @buffer[k - 1])
              # Pick latter end value in buffer[] vs. list[]
              a = max(@list[i], @buffer[(k -= 1)])
            else
              # No overlap
              @buffer[((k += 1) - 1)] = a
              a = @list[i]
            end
            i += 1 # Common if/else code factored out
            polarity ^= 1
          else
            if (b < a)
              # take b
              if (k > 0 && b <= @buffer[k - 1])
                b = max(other[j], @buffer[(k -= 1)])
              else
                @buffer[((k += 1) - 1)] = b
                b = other[j]
              end
              j += 1
              polarity ^= 2
            else
              # a == b, take a, drop b
              if ((a).equal?(HIGH))
                break
              end
              # This is symmetrical; it doesn't matter if
              # we backtrack with a or b. - liu
              if (k > 0 && a <= @buffer[k - 1])
                a = max(@list[i], @buffer[(k -= 1)])
              else
                # No overlap
                @buffer[((k += 1) - 1)] = a
                a = @list[i]
              end
              i += 1
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        when 3
          # both second; take higher if unequal, and drop other
          if (b <= a)
            # take a
            if ((a).equal?(HIGH))
              break
            end
            @buffer[((k += 1) - 1)] = a
          else
            # take b
            if ((b).equal?(HIGH))
              break
            end
            @buffer[((k += 1) - 1)] = b
          end
          a = @list[((i += 1) - 1)]
          polarity ^= 1 # factored common code
          b = other[((j += 1) - 1)]
          polarity ^= 2
        when 1
          # a second, b first; if b < a, overlap
          if (a < b)
            # no overlap, take a
            @buffer[((k += 1) - 1)] = a
            a = @list[((i += 1) - 1)]
            polarity ^= 1
          else
            if (b < a)
              # OVERLAP, drop b
              b = other[((j += 1) - 1)]
              polarity ^= 2
            else
              # a == b, drop both!
              if ((a).equal?(HIGH))
                break
              end
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        when 2
          # a first, b second; if a < b, overlap
          if (b < a)
            # no overlap, take b
            @buffer[((k += 1) - 1)] = b
            b = other[((j += 1) - 1)]
            polarity ^= 2
          else
            if (a < b)
              # OVERLAP, drop a
              a = @list[((i += 1) - 1)]
              polarity ^= 1
            else
              # a == b, drop both!
              if ((a).equal?(HIGH))
                break
              end
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        end
      end
      @buffer[((k += 1) - 1)] = HIGH # terminate
      @len = k
      # swap list and buffer
      temp = @list
      @list = @buffer
      @buffer = temp
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
    # polarity = 0 is normal: x intersect y
    # polarity = 2: x intersect ~y == set-minus
    # polarity = 1: ~x intersect y
    # polarity = 3: ~x intersect ~y
    def retain(other, other_len, polarity)
      ensure_buffer_capacity(@len + other_len)
      i = 0
      j = 0
      k = 0
      a = @list[((i += 1) - 1)]
      b = other[((j += 1) - 1)]
      # change from xor is that we have to check overlapping pairs
      # polarity bit 1 means a is second, bit 2 means b is.
      while (true)
        case (polarity)
        when 0
          # both first; drop the smaller
          if (a < b)
            # drop a
            a = @list[((i += 1) - 1)]
            polarity ^= 1
          else
            if (b < a)
              # drop b
              b = other[((j += 1) - 1)]
              polarity ^= 2
            else
              # a == b, take one, drop other
              if ((a).equal?(HIGH))
                break
              end
              @buffer[((k += 1) - 1)] = a
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        when 3
          # both second; take lower if unequal
          if (a < b)
            # take a
            @buffer[((k += 1) - 1)] = a
            a = @list[((i += 1) - 1)]
            polarity ^= 1
          else
            if (b < a)
              # take b
              @buffer[((k += 1) - 1)] = b
              b = other[((j += 1) - 1)]
              polarity ^= 2
            else
              # a == b, take one, drop other
              if ((a).equal?(HIGH))
                break
              end
              @buffer[((k += 1) - 1)] = a
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        when 1
          # a second, b first;
          if (a < b)
            # NO OVERLAP, drop a
            a = @list[((i += 1) - 1)]
            polarity ^= 1
          else
            if (b < a)
              # OVERLAP, take b
              @buffer[((k += 1) - 1)] = b
              b = other[((j += 1) - 1)]
              polarity ^= 2
            else
              # a == b, drop both!
              if ((a).equal?(HIGH))
                break
              end
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        when 2
          # a first, b second; if a < b, overlap
          if (b < a)
            # no overlap, drop b
            b = other[((j += 1) - 1)]
            polarity ^= 2
          else
            if (a < b)
              # OVERLAP, take a
              @buffer[((k += 1) - 1)] = a
              a = @list[((i += 1) - 1)]
              polarity ^= 1
            else
              # a == b, drop both!
              if ((a).equal?(HIGH))
                break
              end
              a = @list[((i += 1) - 1)]
              polarity ^= 1
              b = other[((j += 1) - 1)]
              polarity ^= 2
            end
          end
        end
      end
      @buffer[((k += 1) - 1)] = HIGH # terminate
      @len = k
      # swap list and buffer
      temp = @list
      @list = @buffer
      @buffer = temp
      @pat = RJava.cast_to_string(nil)
      return self
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      def max(a, b)
        return (a > b) ? a : b
      end
      
      # ----------------------------------------------------------------
      # Generic filter-based scanning code
      # ----------------------------------------------------------------
      const_set_lazy(:Filter) { Module.new do
        include_class_members UnicodeSet
        
        typesig { [::Java::Int] }
        def contains(code_point)
          raise NotImplementedError
        end
      end }
      
      # VersionInfo for unassigned characters
      const_set_lazy(:NO_VERSION) { VersionInfo.get_instance(0, 0, 0, 0) }
      const_attr_reader  :NO_VERSION
      
      const_set_lazy(:VersionFilter) { Class.new do
        include_class_members UnicodeSet
        include Filter
        
        attr_accessor :version
        alias_method :attr_version, :version
        undef_method :version
        alias_method :attr_version=, :version=
        undef_method :version=
        
        typesig { [class_self::VersionInfo] }
        def initialize(version)
          @version = nil
          @version = version
        end
        
        typesig { [::Java::Int] }
        def contains(ch)
          v = UCharacter.get_age(ch)
          # Reference comparison ok; VersionInfo caches and reuses
          # unique objects.
          return !(v).equal?(NO_VERSION) && (v <=> @version) <= 0
        end
        
        private
        alias_method :initialize__version_filter, :initialize
      end }
      
      typesig { [] }
      def get_inclusions
        synchronized(self) do
          if ((self.attr_inclusions).nil?)
            property = UCharacterProperty.get_instance
            self.attr_inclusions = property.get_inclusions
          end
          return self.attr_inclusions
        end
      end
    }
    
    typesig { [Filter] }
    # Generic filter-based scanning code for UCD property UnicodeSets.
    def apply_filter(filter)
      # Walk through all Unicode characters, noting the start
      # and end of each range for which filter.contain(c) is
      # true.  Add each range to a set.
      # 
      # To improve performance, use the INCLUSIONS set, which
      # encodes information about character ranges that are known
      # to have identical properties, such as the CJK Ideographs
      # from U+4E00 to U+9FA5.  INCLUSIONS contains all characters
      # except the first characters of such ranges.
      # 
      # TODO Where possible, instead of scanning over code points,
      # use internal property data to initialize UnicodeSets for
      # those properties.  Scanning code points is slow.
      clear
      start_has_property = -1
      inclusions = get_inclusions
      limit_range = inclusions.get_range_count
      j = 0
      while j < limit_range
        # get current range
        start = inclusions.get_range_start(j)
        end_ = inclusions.get_range_end(j)
        # for all the code points in the range, process
        ch = start
        while ch <= end_
          # only add to the unicodeset on inflection points --
          # where the hasProperty value changes to false
          if (filter.contains(ch))
            if (start_has_property < 0)
              start_has_property = ch
            end
          else
            if (start_has_property >= 0)
              add(start_has_property, ch - 1)
              start_has_property = -1
            end
          end
          (ch += 1)
        end
        (j += 1)
      end
      if (start_has_property >= 0)
        add(start_has_property, 0x10ffff)
      end
      return self
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Remove leading and trailing rule white space and compress
      # internal rule white space to a single space character.
      # 
      # @see UCharacterProperty#isRuleWhiteSpace
      def munge_char_name(source)
        buf = StringBuffer.new
        i = 0
        while i < source.length
          ch = UTF16.char_at(source, i)
          i += UTF16.get_char_count(ch)
          if (UCharacterProperty.is_rule_white_space(ch))
            if ((buf.length).equal?(0) || (buf.char_at(buf.length - 1)).equal?(Character.new(?\s.ord)))
              next
            end
            ch = Character.new(?\s.ord) # convert to ' '
          end
          UTF16.append(buf, ch)
        end
        if (!(buf.length).equal?(0) && (buf.char_at(buf.length - 1)).equal?(Character.new(?\s.ord)))
          buf.set_length(buf.length - 1)
        end
        return buf.to_s
      end
    }
    
    typesig { [String, String, SymbolTable] }
    # ----------------------------------------------------------------
    # Property set API
    # ----------------------------------------------------------------
    # Modifies this set to contain those code points which have the
    # given value for the given property.  Prior contents of this
    # set are lost.
    # @param propertyAlias
    # @param valueAlias
    # @param symbols if not null, then symbols are first called to see if a property
    # is available. If true, then everything else is skipped.
    # @return this set
    # @draft ICU 3.2
    # @deprecated This is a draft API and might change in a future release of ICU.
    def apply_property_alias(property_alias, value_alias, symbols)
      if ((property_alias == "Age"))
        # Must munge name, since
        # VersionInfo.getInstance() does not do
        # 'loose' matching.
        version = VersionInfo.get_instance(munge_char_name(value_alias))
        apply_filter(VersionFilter.new(version))
        return self
      else
        raise IllegalArgumentException.new("Unsupported property")
      end
    end
    
    class_module.module_eval {
      typesig { [RuleCharacterIterator, ::Java::Int] }
      # Return true if the given iterator appears to point at a
      # property pattern.  Regardless of the result, return with the
      # iterator unchanged.
      # @param chars iterator over the pattern characters.  Upon return
      # it will be unchanged.
      # @param iterOpts RuleCharacterIterator options
      def resembles_property_pattern(chars, iter_opts)
        result = false
        iter_opts &= ~RuleCharacterIterator::PARSE_ESCAPES
        pos = chars.get_pos(nil)
        c = chars.next_(iter_opts)
        if ((c).equal?(Character.new(?[.ord)) || (c).equal?(Character.new(?\\.ord)))
          d = chars.next_(iter_opts & ~RuleCharacterIterator::SKIP_WHITESPACE)
          result = ((c).equal?(Character.new(?[.ord))) ? ((d).equal?(Character.new(?:.ord))) : ((d).equal?(Character.new(?N.ord)) || (d).equal?(Character.new(?p.ord)) || (d).equal?(Character.new(?P.ord)))
        end
        chars.set_pos(pos)
        return result
      end
    }
    
    typesig { [String, ParsePosition, SymbolTable] }
    # Parse the given property pattern at the given parse position.
    # @param symbols TODO
    def apply_property_pattern(pattern, ppos, symbols)
      pos = ppos.get_index
      # On entry, ppos should point to one of the following locations:
      # Minimum length is 5 characters, e.g. \p{L}
      if ((pos + 5) > pattern.length)
        return nil
      end
      posix = false # true for [:pat:], false for \p{pat} \P{pat} \N{pat}
      is_name = false # true for \N{pat}, o/w false
      invert = false
      # Look for an opening [:, [:^, \p, or \P
      if (pattern.region_matches(pos, "[:", 0, 2))
        posix = true
        pos = Utility.skip_whitespace(pattern, pos + 2)
        if (pos < pattern.length && (pattern.char_at(pos)).equal?(Character.new(?^.ord)))
          (pos += 1)
          invert = true
        end
      else
        if (pattern.region_matches(true, pos, "\\p", 0, 2) || pattern.region_matches(pos, "\\N", 0, 2))
          c = pattern.char_at(pos + 1)
          invert = ((c).equal?(Character.new(?P.ord)))
          is_name = ((c).equal?(Character.new(?N.ord)))
          pos = Utility.skip_whitespace(pattern, pos + 2)
          if ((pos).equal?(pattern.length) || !(pattern.char_at(((pos += 1) - 1))).equal?(Character.new(?{.ord)))
            # Syntax error; "\p" or "\P" not followed by "{"
            return nil
          end
        else
          # Open delimiter not seen
          return nil
        end
      end
      # Look for the matching close delimiter, either :] or }
      close = pattern.index_of(posix ? ":]" : "}", pos)
      if (close < 0)
        # Syntax error; close delimiter missing
        return nil
      end
      # Look for an '=' sign.  If this is present, we will parse a
      # medium \p{gc=Cf} or long \p{GeneralCategory=Format}
      # pattern.
      equals = pattern.index_of(Character.new(?=.ord), pos)
      prop_name = nil
      value_name = nil
      if (equals >= 0 && equals < close && !is_name)
        # Equals seen; parse medium/long pattern
        prop_name = RJava.cast_to_string(pattern.substring(pos, equals))
        value_name = RJava.cast_to_string(pattern.substring(equals + 1, close))
      else
        # Handle case where no '=' is seen, and \N{}
        prop_name = RJava.cast_to_string(pattern.substring(pos, close))
        value_name = ""
        # Handle \N{name}
        if (is_name)
          # This is a little inefficient since it means we have to
          # parse "na" back to UProperty.NAME even though we already
          # know it's UProperty.NAME.  If we refactor the API to
          # support args of (int, String) then we can remove
          # "na" and make this a little more efficient.
          value_name = prop_name
          prop_name = "na"
        end
      end
      apply_property_alias(prop_name, value_name, symbols)
      if (invert)
        complement
      end
      # Move to the limit position after the close delimiter
      ppos.set_index(close + (posix ? 2 : 1))
      return self
    end
    
    typesig { [RuleCharacterIterator, StringBuffer, SymbolTable] }
    # Parse a property pattern.
    # @param chars iterator over the pattern characters.  Upon return
    # it will be advanced to the first character after the parsed
    # pattern, or the end of the iteration if all characters are
    # parsed.
    # @param rebuiltPat the pattern that was parsed, rebuilt or
    # copied from the input pattern, as appropriate.
    # @param symbols TODO
    def apply_property_pattern(chars, rebuilt_pat, symbols)
      pat = chars.lookahead
      pos = ParsePosition.new(0)
      apply_property_pattern(pat, pos, symbols)
      if ((pos.get_index).equal?(0))
        syntax_error(chars, "Invalid property pattern")
      end
      chars.jumpahead(pos.get_index)
      rebuilt_pat.append(pat.substring(0, pos.get_index))
    end
    
    class_module.module_eval {
      # ----------------------------------------------------------------
      # Case folding API
      # ----------------------------------------------------------------
      # Bitmask for constructor and applyPattern() indicating that
      # white space should be ignored.  If set, ignore characters for
      # which UCharacterProperty.isRuleWhiteSpace() returns true,
      # unless they are quoted or escaped.  This may be ORed together
      # with other selectors.
      # @internal
      const_set_lazy(:IGNORE_SPACE) { 1 }
      const_attr_reader  :IGNORE_SPACE
    }
    
    private
    alias_method :initialize__unicode_set, :initialize
  end
  
end

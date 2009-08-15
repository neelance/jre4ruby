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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module RuleBasedCollatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Text, :Normalizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Locale
    }
  end
  
  # The <code>RuleBasedCollator</code> class is a concrete subclass of
  # <code>Collator</code> that provides a simple, data-driven, table
  # collator.  With this class you can create a customized table-based
  # <code>Collator</code>.  <code>RuleBasedCollator</code> maps
  # characters to sort keys.
  # 
  # <p>
  # <code>RuleBasedCollator</code> has the following restrictions
  # for efficiency (other subclasses may be used for more complex languages) :
  # <ol>
  # <li>If a special collation rule controlled by a &lt;modifier&gt; is
  # specified it applies to the whole collator object.
  # <li>All non-mentioned characters are at the end of the
  # collation order.
  # </ol>
  # 
  # <p>
  # The collation table is composed of a list of collation rules, where each
  # rule is of one of three forms:
  # <pre>
  # &lt;modifier&gt;
  # &lt;relation&gt; &lt;text-argument&gt;
  # &lt;reset&gt; &lt;text-argument&gt;
  # </pre>
  # The definitions of the rule elements is as follows:
  # <UL Type=disc>
  # <LI><strong>Text-Argument</strong>: A text-argument is any sequence of
  # characters, excluding special characters (that is, common
  # whitespace characters [0009-000D, 0020] and rule syntax characters
  # [0021-002F, 003A-0040, 005B-0060, 007B-007E]). If those
  # characters are desired, you can put them in single quotes
  # (e.g. ampersand => '&'). Note that unquoted white space characters
  # are ignored; e.g. <code>b c</code> is treated as <code>bc</code>.
  # <LI><strong>Modifier</strong>: There are currently two modifiers that
  # turn on special collation rules.
  # <UL Type=square>
  # <LI>'@' : Turns on backwards sorting of accents (secondary
  # differences), as in French.
  # <LI>'!' : Turns on Thai/Lao vowel-consonant swapping.  If this
  # rule is in force when a Thai vowel of the range
  # &#92;U0E40-&#92;U0E44 precedes a Thai consonant of the range
  # &#92;U0E01-&#92;U0E2E OR a Lao vowel of the range &#92;U0EC0-&#92;U0EC4
  # precedes a Lao consonant of the range &#92;U0E81-&#92;U0EAE then
  # the vowel is placed after the consonant for collation
  # purposes.
  # </UL>
  # <p>'@' : Indicates that accents are sorted backwards, as in French.
  # <LI><strong>Relation</strong>: The relations are the following:
  # <UL Type=square>
  # <LI>'&lt;' : Greater, as a letter difference (primary)
  # <LI>';' : Greater, as an accent difference (secondary)
  # <LI>',' : Greater, as a case difference (tertiary)
  # <LI>'=' : Equal
  # </UL>
  # <LI><strong>Reset</strong>: There is a single reset
  # which is used primarily for contractions and expansions, but which
  # can also be used to add a modification at the end of a set of rules.
  # <p>'&' : Indicates that the next rule follows the position to where
  # the reset text-argument would be sorted.
  # </UL>
  # 
  # <p>
  # This sounds more complicated than it is in practice. For example, the
  # following are equivalent ways of expressing the same thing:
  # <blockquote>
  # <pre>
  # a &lt; b &lt; c
  # a &lt; b &amp; b &lt; c
  # a &lt; c &amp; a &lt; b
  # </pre>
  # </blockquote>
  # Notice that the order is important, as the subsequent item goes immediately
  # after the text-argument. The following are not equivalent:
  # <blockquote>
  # <pre>
  # a &lt; b &amp; a &lt; c
  # a &lt; c &amp; a &lt; b
  # </pre>
  # </blockquote>
  # Either the text-argument must already be present in the sequence, or some
  # initial substring of the text-argument must be present. (e.g. "a &lt; b &amp; ae &lt;
  # e" is valid since "a" is present in the sequence before "ae" is reset). In
  # this latter case, "ae" is not entered and treated as a single character;
  # instead, "e" is sorted as if it were expanded to two characters: "a"
  # followed by an "e". This difference appears in natural languages: in
  # traditional Spanish "ch" is treated as though it contracts to a single
  # character (expressed as "c &lt; ch &lt; d"), while in traditional German
  # a-umlaut is treated as though it expanded to two characters
  # (expressed as "a,A &lt; b,B ... &amp;ae;&#92;u00e3&amp;AE;&#92;u00c3").
  # [&#92;u00e3 and &#92;u00c3 are, of course, the escape sequences for a-umlaut.]
  # <p>
  # <strong>Ignorable Characters</strong>
  # <p>
  # For ignorable characters, the first rule must start with a relation (the
  # examples we have used above are really fragments; "a &lt; b" really should be
  # "&lt; a &lt; b"). If, however, the first relation is not "&lt;", then all the all
  # text-arguments up to the first "&lt;" are ignorable. For example, ", - &lt; a &lt; b"
  # makes "-" an ignorable character, as we saw earlier in the word
  # "black-birds". In the samples for different languages, you see that most
  # accents are ignorable.
  # 
  # <p><strong>Normalization and Accents</strong>
  # <p>
  # <code>RuleBasedCollator</code> automatically processes its rule table to
  # include both pre-composed and combining-character versions of
  # accented characters.  Even if the provided rule string contains only
  # base characters and separate combining accent characters, the pre-composed
  # accented characters matching all canonical combinations of characters from
  # the rule string will be entered in the table.
  # <p>
  # This allows you to use a RuleBasedCollator to compare accented strings
  # even when the collator is set to NO_DECOMPOSITION.  There are two caveats,
  # however.  First, if the strings to be collated contain combining
  # sequences that may not be in canonical order, you should set the collator to
  # CANONICAL_DECOMPOSITION or FULL_DECOMPOSITION to enable sorting of
  # combining sequences.  Second, if the strings contain characters with
  # compatibility decompositions (such as full-width and half-width forms),
  # you must use FULL_DECOMPOSITION, since the rule tables only include
  # canonical mappings.
  # 
  # <p><strong>Errors</strong>
  # <p>
  # The following are errors:
  # <UL Type=disc>
  # <LI>A text-argument contains unquoted punctuation symbols
  # (e.g. "a &lt; b-c &lt; d").
  # <LI>A relation or reset character not followed by a text-argument
  # (e.g. "a &lt; ,b").
  # <LI>A reset where the text-argument (or an initial substring of the
  # text-argument) is not already in the sequence.
  # (e.g. "a &lt; b &amp; e &lt; f")
  # </UL>
  # If you produce one of these errors, a <code>RuleBasedCollator</code> throws
  # a <code>ParseException</code>.
  # 
  # <p><strong>Examples</strong>
  # <p>Simple:     "&lt; a &lt; b &lt; c &lt; d"
  # <p>Norwegian:  "&lt; a,A&lt; b,B&lt; c,C&lt; d,D&lt; e,E&lt; f,F&lt; g,G&lt; h,H&lt; i,I&lt; j,J
  # &lt; k,K&lt; l,L&lt; m,M&lt; n,N&lt; o,O&lt; p,P&lt; q,Q&lt; r,R&lt; s,S&lt; t,T
  # &lt; u,U&lt; v,V&lt; w,W&lt; x,X&lt; y,Y&lt; z,Z
  # &lt; &#92;u00E5=a&#92;u030A,&#92;u00C5=A&#92;u030A
  # ;aa,AA&lt; &#92;u00E6,&#92;u00C6&lt; &#92;u00F8,&#92;u00D8"
  # 
  # <p>
  # To create a <code>RuleBasedCollator</code> object with specialized
  # rules tailored to your needs, you construct the <code>RuleBasedCollator</code>
  # with the rules contained in a <code>String</code> object. For example:
  # <blockquote>
  # <pre>
  # String simple = "&lt; a&lt; b&lt; c&lt; d";
  # RuleBasedCollator mySimple = new RuleBasedCollator(simple);
  # </pre>
  # </blockquote>
  # Or:
  # <blockquote>
  # <pre>
  # String Norwegian = "&lt; a,A&lt; b,B&lt; c,C&lt; d,D&lt; e,E&lt; f,F&lt; g,G&lt; h,H&lt; i,I&lt; j,J" +
  # "&lt; k,K&lt; l,L&lt; m,M&lt; n,N&lt; o,O&lt; p,P&lt; q,Q&lt; r,R&lt; s,S&lt; t,T" +
  # "&lt; u,U&lt; v,V&lt; w,W&lt; x,X&lt; y,Y&lt; z,Z" +
  # "&lt; &#92;u00E5=a&#92;u030A,&#92;u00C5=A&#92;u030A" +
  # ";aa,AA&lt; &#92;u00E6,&#92;u00C6&lt; &#92;u00F8,&#92;u00D8";
  # RuleBasedCollator myNorwegian = new RuleBasedCollator(Norwegian);
  # </pre>
  # </blockquote>
  # 
  # <p>
  # A new collation rules string can be created by concatenating rules
  # strings. For example, the rules returned by {@link #getRules()} could
  # be concatenated to combine multiple <code>RuleBasedCollator</code>s.
  # 
  # <p>
  # The following example demonstrates how to change the order of
  # non-spacing accents,
  # <blockquote>
  # <pre>
  # // old rule
  # String oldRules = "=&#92;u0301;&#92;u0300;&#92;u0302;&#92;u0308"    // main accents
  # + ";&#92;u0327;&#92;u0303;&#92;u0304;&#92;u0305"    // main accents
  # + ";&#92;u0306;&#92;u0307;&#92;u0309;&#92;u030A"    // main accents
  # + ";&#92;u030B;&#92;u030C;&#92;u030D;&#92;u030E"    // main accents
  # + ";&#92;u030F;&#92;u0310;&#92;u0311;&#92;u0312"    // main accents
  # + "&lt; a , A ; ae, AE ; &#92;u00e6 , &#92;u00c6"
  # + "&lt; b , B &lt; c, C &lt; e, E & C &lt; d, D";
  # // change the order of accent characters
  # String addOn = "& &#92;u0300 ; &#92;u0308 ; &#92;u0302";
  # RuleBasedCollator myCollator = new RuleBasedCollator(oldRules + addOn);
  # </pre>
  # </blockquote>
  # 
  # @see        Collator
  # @see        CollationElementIterator
  # @author     Helena Shih, Laura Werner, Richard Gillam
  class RuleBasedCollator < RuleBasedCollatorImports.const_get :Collator
    include_class_members RuleBasedCollatorImports
    
    typesig { [String] }
    # IMPLEMENTATION NOTES:  The implementation of the collation algorithm is
    # divided across three classes: RuleBasedCollator, RBCollationTables, and
    # CollationElementIterator.  RuleBasedCollator contains the collator's
    # transient state and includes the code that uses the other classes to
    # implement comparison and sort-key building.  RuleBasedCollator also
    # contains the logic to handle French secondary accent sorting.
    # A RuleBasedCollator has two CollationElementIterators.  State doesn't
    # need to be preserved in these objects between calls to compare() or
    # getCollationKey(), but the objects persist anyway to avoid wasting extra
    # creation time.  compare() and getCollationKey() are synchronized to ensure
    # thread safety with this scheme.  The CollationElementIterator is responsible
    # for generating collation elements from strings and returning one element at
    # a time (sometimes there's a one-to-many or many-to-one mapping between
    # characters and collation elements-- this class handles that).
    # CollationElementIterator depends on RBCollationTables, which contains the
    # collator's static state.  RBCollationTables contains the actual data
    # tables specifying the collation order of characters for a particular locale
    # or use.  It also contains the base logic that CollationElementIterator
    # uses to map from characters to collation elements.  A single RBCollationTables
    # object is shared among all RuleBasedCollators for the same locale, and
    # thus by all the CollationElementIterators they create.
    # 
    # RuleBasedCollator constructor.  This takes the table rules and builds
    # a collation table out of them.  Please see RuleBasedCollator class
    # description for more details on the collation rule syntax.
    # @see java.util.Locale
    # @param rules the collation rules to build the collation table from.
    # @exception ParseException A format exception
    # will be thrown if the build process of the rules fails. For
    # example, build rule "a < ? < d" will cause the constructor to
    # throw the ParseException because the '?' is not quoted.
    def initialize(rules)
      initialize__rule_based_collator(rules, Collator::CANONICAL_DECOMPOSITION)
    end
    
    typesig { [String, ::Java::Int] }
    # RuleBasedCollator constructor.  This takes the table rules and builds
    # a collation table out of them.  Please see RuleBasedCollator class
    # description for more details on the collation rule syntax.
    # @see java.util.Locale
    # @param rules the collation rules to build the collation table from.
    # @param decomp the decomposition strength used to build the
    # collation table and to perform comparisons.
    # @exception ParseException A format exception
    # will be thrown if the build process of the rules fails. For
    # example, build rule "a < ? < d" will cause the constructor to
    # throw the ParseException because the '?' is not quoted.
    def initialize(rules, decomp)
      @tables = nil
      @prim_result = nil
      @sec_result = nil
      @ter_result = nil
      @source_cursor = nil
      @target_cursor = nil
      super()
      @tables = nil
      @prim_result = nil
      @sec_result = nil
      @ter_result = nil
      @source_cursor = nil
      @target_cursor = nil
      set_strength(Collator::TERTIARY)
      set_decomposition(decomp)
      @tables = RBCollationTables.new(rules, decomp)
    end
    
    typesig { [RuleBasedCollator] }
    # "Copy constructor."  Used in clone() for performance.
    def initialize(that)
      @tables = nil
      @prim_result = nil
      @sec_result = nil
      @ter_result = nil
      @source_cursor = nil
      @target_cursor = nil
      super()
      @tables = nil
      @prim_result = nil
      @sec_result = nil
      @ter_result = nil
      @source_cursor = nil
      @target_cursor = nil
      set_strength(that.get_strength)
      set_decomposition(that.get_decomposition)
      @tables = that.attr_tables
    end
    
    typesig { [] }
    # Gets the table-based rules for the collation object.
    # @return returns the collation rules that the table collation object
    # was created from.
    def get_rules
      return @tables.get_rules
    end
    
    typesig { [String] }
    # Return a CollationElementIterator for the given String.
    # @see java.text.CollationElementIterator
    def get_collation_element_iterator(source)
      return CollationElementIterator.new(source, self)
    end
    
    typesig { [CharacterIterator] }
    # Return a CollationElementIterator for the given String.
    # @see java.text.CollationElementIterator
    # @since 1.2
    def get_collation_element_iterator(source)
      return CollationElementIterator.new(source, self)
    end
    
    typesig { [String, String] }
    # Compares the character data stored in two different strings based on the
    # collation rules.  Returns information about whether a string is less
    # than, greater than or equal to another string in a language.
    # This can be overriden in a subclass.
    def compare(source, target)
      synchronized(self) do
        # The basic algorithm here is that we use CollationElementIterators
        # to step through both the source and target strings.  We compare each
        # collation element in the source string against the corresponding one
        # in the target, checking for differences.
        # 
        # If a difference is found, we set <result> to LESS or GREATER to
        # indicate whether the source string is less or greater than the target.
        # 
        # However, it's not that simple.  If we find a tertiary difference
        # (e.g. 'A' vs. 'a') near the beginning of a string, it can be
        # overridden by a primary difference (e.g. "A" vs. "B") later in
        # the string.  For example, "AA" < "aB", even though 'A' > 'a'.
        # 
        # To keep track of this, we use strengthResult to keep track of the
        # strength of the most significant difference that has been found
        # so far.  When we find a difference whose strength is greater than
        # strengthResult, it overrides the last difference (if any) that
        # was found.
        result = Collator::EQUAL
        if ((@source_cursor).nil?)
          @source_cursor = get_collation_element_iterator(source)
        else
          @source_cursor.set_text(source)
        end
        if ((@target_cursor).nil?)
          @target_cursor = get_collation_element_iterator(target)
        else
          @target_cursor.set_text(target)
        end
        s_order = 0
        t_order = 0
        initial_check_sec_ter = get_strength >= Collator::SECONDARY
        check_sec_ter = initial_check_sec_ter
        check_tertiary = get_strength >= Collator::TERTIARY
        gets = true
        gett = true
        while (true)
          # Get the next collation element in each of the strings, unless
          # we've been requested to skip it.
          if (gets)
            s_order = @source_cursor.next_
          else
            gets = true
          end
          if (gett)
            t_order = @target_cursor.next_
          else
            gett = true
          end
          # If we've hit the end of one of the strings, jump out of the loop
          if (((s_order).equal?(CollationElementIterator::NULLORDER)) || ((t_order).equal?(CollationElementIterator::NULLORDER)))
            break
          end
          p_sorder = CollationElementIterator.primary_order(s_order)
          p_torder = CollationElementIterator.primary_order(t_order)
          # If there's no difference at this position, we can skip it
          if ((s_order).equal?(t_order))
            if (@tables.is_french_sec && !(p_sorder).equal?(0))
              if (!check_sec_ter)
                # in french, a secondary difference more to the right is stronger,
                # so accents have to be checked with each base element
                check_sec_ter = initial_check_sec_ter
                # but tertiary differences are less important than the first
                # secondary difference, so checking tertiary remains disabled
                check_tertiary = false
              end
            end
            next
          end
          # Compare primary differences first.
          if (!(p_sorder).equal?(p_torder))
            if ((s_order).equal?(0))
              # The entire source element is ignorable.
              # Skip to the next source element, but don't fetch another target element.
              gett = false
              next
            end
            if ((t_order).equal?(0))
              gets = false
              next
            end
            # The source and target elements aren't ignorable, but it's still possible
            # for the primary component of one of the elements to be ignorable....
            if ((p_sorder).equal?(0))
              # primary order in source is ignorable
              # The source's primary is ignorable, but the target's isn't.  We treat ignorables
              # as a secondary difference, so remember that we found one.
              if (check_sec_ter)
                result = Collator::GREATER # (strength is SECONDARY)
                check_sec_ter = false
              end
              # Skip to the next source element, but don't fetch another target element.
              gett = false
            else
              if ((p_torder).equal?(0))
                # record differences - see the comment above.
                if (check_sec_ter)
                  result = Collator::LESS # (strength is SECONDARY)
                  check_sec_ter = false
                end
                # Skip to the next source element, but don't fetch another target element.
                gets = false
              else
                # Neither of the orders is ignorable, and we already know that the primary
                # orders are different because of the (pSOrder != pTOrder) test above.
                # Record the difference and stop the comparison.
                if (p_sorder < p_torder)
                  return Collator::LESS # (strength is PRIMARY)
                else
                  return Collator::GREATER # (strength is PRIMARY)
                end
              end
            end
          else
            # else of if ( pSOrder != pTOrder )
            # primary order is the same, but complete order is different. So there
            # are no base elements at this point, only ignorables (Since the strings are
            # normalized)
            if (check_sec_ter)
              # a secondary or tertiary difference may still matter
              sec_sorder = CollationElementIterator.secondary_order(s_order)
              sec_torder = CollationElementIterator.secondary_order(t_order)
              if (!(sec_sorder).equal?(sec_torder))
                # there is a secondary difference
                result = (sec_sorder < sec_torder) ? Collator::LESS : Collator::GREATER
                # (strength is SECONDARY)
                check_sec_ter = false
                # (even in french, only the first secondary difference within
                # a base character matters)
              else
                if (check_tertiary)
                  # a tertiary difference may still matter
                  ter_sorder = CollationElementIterator.tertiary_order(s_order)
                  ter_torder = CollationElementIterator.tertiary_order(t_order)
                  if (!(ter_sorder).equal?(ter_torder))
                    # there is a tertiary difference
                    result = (ter_sorder < ter_torder) ? Collator::LESS : Collator::GREATER
                    # (strength is TERTIARY)
                    check_tertiary = false
                  end
                end
              end
            end # if (checkSecTer)
          end # if ( pSOrder != pTOrder )
        end # while()
        if (!(s_order).equal?(CollationElementIterator::NULLORDER))
          # (tOrder must be CollationElementIterator::NULLORDER,
          # since this point is only reached when sOrder or tOrder is NULLORDER.)
          # The source string has more elements, but the target string hasn't.
          begin
            if (!(CollationElementIterator.primary_order(s_order)).equal?(0))
              # We found an additional non-ignorable base character in the source string.
              # This is a primary difference, so the source is greater
              return Collator::GREATER # (strength is PRIMARY)
            else
              if (!(CollationElementIterator.secondary_order(s_order)).equal?(0))
                # Additional secondary elements mean the source string is greater
                if (check_sec_ter)
                  result = Collator::GREATER # (strength is SECONDARY)
                  check_sec_ter = false
                end
              end
            end
          end while (!((s_order = @source_cursor.next_)).equal?(CollationElementIterator::NULLORDER))
        else
          if (!(t_order).equal?(CollationElementIterator::NULLORDER))
            # The target string has more elements, but the source string hasn't.
            begin
              if (!(CollationElementIterator.primary_order(t_order)).equal?(0))
                # We found an additional non-ignorable base character in the target string.
                # This is a primary difference, so the source is less
                return Collator::LESS
                 # (strength is PRIMARY)
              else
                if (!(CollationElementIterator.secondary_order(t_order)).equal?(0))
                  # Additional secondary elements in the target mean the source string is less
                  if (check_sec_ter)
                    result = Collator::LESS # (strength is SECONDARY)
                    check_sec_ter = false
                  end
                end
              end
            end while (!((t_order = @target_cursor.next_)).equal?(CollationElementIterator::NULLORDER))
          end
        end
        # For IDENTICAL comparisons, we use a bitwise character comparison
        # as a tiebreaker if all else is equal
        if ((result).equal?(0) && (get_strength).equal?(IDENTICAL))
          mode = get_decomposition
          form = nil
          if ((mode).equal?(CANONICAL_DECOMPOSITION))
            form = Normalizer::Form::NFD
          else
            if ((mode).equal?(FULL_DECOMPOSITION))
              form = Normalizer::Form::NFKD
            else
              return (source <=> target)
            end
          end
          source_decomposition = Normalizer.normalize(source, form)
          target_decomposition = Normalizer.normalize(target, form)
          return (source_decomposition <=> target_decomposition)
        end
        return result
      end
    end
    
    typesig { [String] }
    # Transforms the string into a series of characters that can be compared
    # with CollationKey.compareTo. This overrides java.text.Collator.getCollationKey.
    # It can be overriden in a subclass.
    def get_collation_key(source)
      synchronized(self) do
        # The basic algorithm here is to find all of the collation elements for each
        # character in the source string, convert them to a char representation,
        # and put them into the collation key.  But it's trickier than that.
        # Each collation element in a string has three components: primary (A vs B),
        # secondary (A vs A-acute), and tertiary (A' vs a); and a primary difference
        # at the end of a string takes precedence over a secondary or tertiary
        # difference earlier in the string.
        # 
        # To account for this, we put all of the primary orders at the beginning of the
        # string, followed by the secondary and tertiary orders, separated by nulls.
        # 
        # Here's a hypothetical example, with the collation element represented as
        # a three-digit number, one digit for primary, one for secondary, etc.
        # 
        # String:              A     a     B   \u00e9 <--(e-acute)
        # Collation Elements: 101   100   201  510
        # 
        # Collation Key:      1125<null>0001<null>1010
        # 
        # To make things even trickier, secondary differences (accent marks) are compared
        # starting at the *end* of the string in languages with French secondary ordering.
        # But when comparing the accent marks on a single base character, they are compared
        # from the beginning.  To handle this, we reverse all of the accents that belong
        # to each base character, then we reverse the entire string of secondary orderings
        # at the end.  Taking the same example above, a French collator might return
        # this instead:
        # 
        # Collation Key:      1125<null>1000<null>1010
        if ((source).nil?)
          return nil
        end
        if ((@prim_result).nil?)
          @prim_result = StringBuffer.new
          @sec_result = StringBuffer.new
          @ter_result = StringBuffer.new
        else
          @prim_result.set_length(0)
          @sec_result.set_length(0)
          @ter_result.set_length(0)
        end
        order = 0
        compare_sec = (get_strength >= Collator::SECONDARY)
        compare_ter = (get_strength >= Collator::TERTIARY)
        sec_order = CollationElementIterator::NULLORDER
        ter_order = CollationElementIterator::NULLORDER
        pre_sec_ignore = 0
        if ((@source_cursor).nil?)
          @source_cursor = get_collation_element_iterator(source)
        else
          @source_cursor.set_text(source)
        end
        # walk through each character
        while (!((order = @source_cursor.next_)).equal?(CollationElementIterator::NULLORDER))
          sec_order = CollationElementIterator.secondary_order(order)
          ter_order = CollationElementIterator.tertiary_order(order)
          if (!CollationElementIterator.is_ignorable(order))
            @prim_result.append(RJava.cast_to_char((CollationElementIterator.primary_order(order) + COLLATIONKEYOFFSET)))
            if (compare_sec)
              # accumulate all of the ignorable/secondary characters attached
              # to a given base character
              if (@tables.is_french_sec && pre_sec_ignore < @sec_result.length)
                # We're doing reversed secondary ordering and we've hit a base
                # (non-ignorable) character.  Reverse any secondary orderings
                # that applied to the last base character.  (see block comment above.)
                RBCollationTables.reverse(@sec_result, pre_sec_ignore, @sec_result.length)
              end
              # Remember where we are in the secondary orderings - this is how far
              # back to go if we need to reverse them later.
              @sec_result.append(RJava.cast_to_char((sec_order + COLLATIONKEYOFFSET)))
              pre_sec_ignore = @sec_result.length
            end
            if (compare_ter)
              @ter_result.append(RJava.cast_to_char((ter_order + COLLATIONKEYOFFSET)))
            end
          else
            if (compare_sec && !(sec_order).equal?(0))
              @sec_result.append(RJava.cast_to_char((sec_order + @tables.get_max_sec_order + COLLATIONKEYOFFSET)))
            end
            if (compare_ter && !(ter_order).equal?(0))
              @ter_result.append(RJava.cast_to_char((ter_order + @tables.get_max_ter_order + COLLATIONKEYOFFSET)))
            end
          end
        end
        if (@tables.is_french_sec)
          if (pre_sec_ignore < @sec_result.length)
            # If we've accumlated any secondary characters after the last base character,
            # reverse them.
            RBCollationTables.reverse(@sec_result, pre_sec_ignore, @sec_result.length)
          end
          # And now reverse the entire secResult to get French secondary ordering.
          RBCollationTables.reverse(@sec_result, 0, @sec_result.length)
        end
        @prim_result.append(RJava.cast_to_char(0))
        @sec_result.append(RJava.cast_to_char(0))
        @sec_result.append(@ter_result.to_s)
        @prim_result.append(@sec_result.to_s)
        if ((get_strength).equal?(IDENTICAL))
          @prim_result.append(RJava.cast_to_char(0))
          mode = get_decomposition
          if ((mode).equal?(CANONICAL_DECOMPOSITION))
            @prim_result.append(Normalizer.normalize(source, Normalizer::Form::NFD))
          else
            if ((mode).equal?(FULL_DECOMPOSITION))
              @prim_result.append(Normalizer.normalize(source, Normalizer::Form::NFKD))
            else
              @prim_result.append(source)
            end
          end
        end
        return RuleBasedCollationKey.new(source, @prim_result.to_s)
      end
    end
    
    typesig { [] }
    # Standard override; no change in semantics.
    def clone
      # if we know we're not actually a subclass of RuleBasedCollator
      # (this class really should have been made final), bypass
      # Object.clone() and use our "copy constructor".  This is faster.
      if ((get_class).equal?(RuleBasedCollator))
        return RuleBasedCollator.new(self)
      else
        result = super
        result.attr_prim_result = nil
        result.attr_sec_result = nil
        result.attr_ter_result = nil
        result.attr_source_cursor = nil
        result.attr_target_cursor = nil
        return result
      end
    end
    
    typesig { [Object] }
    # Compares the equality of two collation objects.
    # @param obj the table-based collation object to be compared with this.
    # @return true if the current table-based collation object is the same
    # as the table-based collation object obj; false otherwise.
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      if (!super(obj))
        return false
      end # super does class check
      other = obj
      # all other non-transient information is also contained in rules.
      return ((get_rules == other.get_rules))
    end
    
    typesig { [] }
    # Generates the hash code for the table-based collation object
    def hash_code
      return get_rules.hash_code
    end
    
    typesig { [] }
    # Allows CollationElementIterator access to the tables object
    def get_tables
      return @tables
    end
    
    class_module.module_eval {
      # ==============================================================
      # private
      # ==============================================================
      const_set_lazy(:CHARINDEX) { 0x70000000 }
      const_attr_reader  :CHARINDEX
      
      # need look up in .commit()
      const_set_lazy(:EXPANDCHARINDEX) { 0x7e000000 }
      const_attr_reader  :EXPANDCHARINDEX
      
      # Expand index follows
      const_set_lazy(:CONTRACTCHARINDEX) { 0x7f000000 }
      const_attr_reader  :CONTRACTCHARINDEX
      
      # contract indexes follow
      const_set_lazy(:UNMAPPED) { -0x1 }
      const_attr_reader  :UNMAPPED
      
      const_set_lazy(:COLLATIONKEYOFFSET) { 1 }
      const_attr_reader  :COLLATIONKEYOFFSET
    }
    
    attr_accessor :tables
    alias_method :attr_tables, :tables
    undef_method :tables
    alias_method :attr_tables=, :tables=
    undef_method :tables=
    
    # Internal objects that are cached across calls so that they don't have to
    # be created/destroyed on every call to compare() and getCollationKey()
    attr_accessor :prim_result
    alias_method :attr_prim_result, :prim_result
    undef_method :prim_result
    alias_method :attr_prim_result=, :prim_result=
    undef_method :prim_result=
    
    attr_accessor :sec_result
    alias_method :attr_sec_result, :sec_result
    undef_method :sec_result
    alias_method :attr_sec_result=, :sec_result=
    undef_method :sec_result=
    
    attr_accessor :ter_result
    alias_method :attr_ter_result, :ter_result
    undef_method :ter_result
    alias_method :attr_ter_result=, :ter_result=
    undef_method :ter_result=
    
    attr_accessor :source_cursor
    alias_method :attr_source_cursor, :source_cursor
    undef_method :source_cursor
    alias_method :attr_source_cursor=, :source_cursor=
    undef_method :source_cursor=
    
    attr_accessor :target_cursor
    alias_method :attr_target_cursor, :target_cursor
    undef_method :target_cursor
    alias_method :attr_target_cursor=, :target_cursor=
    undef_method :target_cursor=
    
    private
    alias_method :initialize__rule_based_collator, :initialize
  end
  
end

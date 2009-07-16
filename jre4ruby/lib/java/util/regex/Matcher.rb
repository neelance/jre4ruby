require "rjava"

# 
# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Regex
  module MatcherImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Regex
    }
  end
  
  # 
  # An engine that performs match operations on a {@link java.lang.CharSequence
  # </code>character sequence<code>} by interpreting a {@link Pattern}.
  # 
  # <p> A matcher is created from a pattern by invoking the pattern's {@link
  # Pattern#matcher matcher} method.  Once created, a matcher can be used to
  # perform three different kinds of match operations:
  # 
  # <ul>
  # 
  # <li><p> The {@link #matches matches} method attempts to match the entire
  # input sequence against the pattern.  </p></li>
  # 
  # <li><p> The {@link #lookingAt lookingAt} method attempts to match the
  # input sequence, starting at the beginning, against the pattern.  </p></li>
  # 
  # <li><p> The {@link #find find} method scans the input sequence looking for
  # the next subsequence that matches the pattern.  </p></li>
  # 
  # </ul>
  # 
  # <p> Each of these methods returns a boolean indicating success or failure.
  # More information about a successful match can be obtained by querying the
  # state of the matcher.
  # 
  # <p> A matcher finds matches in a subset of its input called the
  # <i>region</i>. By default, the region contains all of the matcher's input.
  # The region can be modified via the{@link #region region} method and queried
  # via the {@link #regionStart regionStart} and {@link #regionEnd regionEnd}
  # methods. The way that the region boundaries interact with some pattern
  # constructs can be changed. See {@link #useAnchoringBounds
  # useAnchoringBounds} and {@link #useTransparentBounds useTransparentBounds}
  # for more details.
  # 
  # <p> This class also defines methods for replacing matched subsequences with
  # new strings whose contents can, if desired, be computed from the match
  # result.  The {@link #appendReplacement appendReplacement} and {@link
  # #appendTail appendTail} methods can be used in tandem in order to collect
  # the result into an existing string buffer, or the more convenient {@link
  # #replaceAll replaceAll} method can be used to create a string in which every
  # matching subsequence in the input sequence is replaced.
  # 
  # <p> The explicit state of a matcher includes the start and end indices of
  # the most recent successful match.  It also includes the start and end
  # indices of the input subsequence captured by each <a
  # href="Pattern.html#cg">capturing group</a> in the pattern as well as a total
  # count of such subsequences.  As a convenience, methods are also provided for
  # returning these captured subsequences in string form.
  # 
  # <p> The explicit state of a matcher is initially undefined; attempting to
  # query any part of it before a successful match will cause an {@link
  # IllegalStateException} to be thrown.  The explicit state of a matcher is
  # recomputed by every match operation.
  # 
  # <p> The implicit state of a matcher includes the input character sequence as
  # well as the <i>append position</i>, which is initially zero and is updated
  # by the {@link #appendReplacement appendReplacement} method.
  # 
  # <p> A matcher may be reset explicitly by invoking its {@link #reset()}
  # method or, if a new input sequence is desired, its {@link
  # #reset(java.lang.CharSequence) reset(CharSequence)} method.  Resetting a
  # matcher discards its explicit state information and sets the append position
  # to zero.
  # 
  # <p> Instances of this class are not safe for use by multiple concurrent
  # threads. </p>
  # 
  # 
  # @author      Mike McCloskey
  # @author      Mark Reinhold
  # @author      JSR-51 Expert Group
  # @since       1.4
  # @spec        JSR-51
  class Matcher 
    include_class_members MatcherImports
    include MatchResult
    
    # 
    # The Pattern object that created this Matcher.
    attr_accessor :parent_pattern
    alias_method :attr_parent_pattern, :parent_pattern
    undef_method :parent_pattern
    alias_method :attr_parent_pattern=, :parent_pattern=
    undef_method :parent_pattern=
    
    # 
    # The storage used by groups. They may contain invalid values if
    # a group was skipped during the matching.
    attr_accessor :groups
    alias_method :attr_groups, :groups
    undef_method :groups
    alias_method :attr_groups=, :groups=
    undef_method :groups=
    
    # 
    # The range within the sequence that is to be matched. Anchors
    # will match at these "hard" boundaries. Changing the region
    # changes these values.
    attr_accessor :from
    alias_method :attr_from, :from
    undef_method :from
    alias_method :attr_from=, :from=
    undef_method :from=
    
    attr_accessor :to
    alias_method :attr_to, :to
    undef_method :to
    alias_method :attr_to=, :to=
    undef_method :to=
    
    # 
    # Lookbehind uses this value to ensure that the subexpression
    # match ends at the point where the lookbehind was encountered.
    attr_accessor :lookbehind_to
    alias_method :attr_lookbehind_to, :lookbehind_to
    undef_method :lookbehind_to
    alias_method :attr_lookbehind_to=, :lookbehind_to=
    undef_method :lookbehind_to=
    
    # 
    # The original string being matched.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    class_module.module_eval {
      # 
      # Matcher state used by the last node. NOANCHOR is used when a
      # match does not have to consume all of the input. ENDANCHOR is
      # the mode used for matching all the input.
      const_set_lazy(:ENDANCHOR) { 1 }
      const_attr_reader  :ENDANCHOR
      
      const_set_lazy(:NOANCHOR) { 0 }
      const_attr_reader  :NOANCHOR
    }
    
    attr_accessor :accept_mode
    alias_method :attr_accept_mode, :accept_mode
    undef_method :accept_mode
    alias_method :attr_accept_mode=, :accept_mode=
    undef_method :accept_mode=
    
    # 
    # The range of string that last matched the pattern. If the last
    # match failed then first is -1; last initially holds 0 then it
    # holds the index of the end of the last match (which is where the
    # next search starts).
    attr_accessor :first
    alias_method :attr_first, :first
    undef_method :first
    alias_method :attr_first=, :first=
    undef_method :first=
    
    attr_accessor :last
    alias_method :attr_last, :last
    undef_method :last
    alias_method :attr_last=, :last=
    undef_method :last=
    
    # 
    # The end index of what matched in the last match operation.
    attr_accessor :old_last
    alias_method :attr_old_last, :old_last
    undef_method :old_last
    alias_method :attr_old_last=, :old_last=
    undef_method :old_last=
    
    # 
    # The index of the last position appended in a substitution.
    attr_accessor :last_append_position
    alias_method :attr_last_append_position, :last_append_position
    undef_method :last_append_position
    alias_method :attr_last_append_position=, :last_append_position=
    undef_method :last_append_position=
    
    # 
    # Storage used by nodes to tell what repetition they are on in
    # a pattern, and where groups begin. The nodes themselves are stateless,
    # so they rely on this field to hold state during a match.
    attr_accessor :locals
    alias_method :attr_locals, :locals
    undef_method :locals
    alias_method :attr_locals=, :locals=
    undef_method :locals=
    
    # 
    # Boolean indicating whether or not more input could change
    # the results of the last match.
    # 
    # If hitEnd is true, and a match was found, then more input
    # might cause a different match to be found.
    # If hitEnd is true and a match was not found, then more
    # input could cause a match to be found.
    # If hitEnd is false and a match was found, then more input
    # will not change the match.
    # If hitEnd is false and a match was not found, then more
    # input will not cause a match to be found.
    attr_accessor :hit_end
    alias_method :attr_hit_end, :hit_end
    undef_method :hit_end
    alias_method :attr_hit_end=, :hit_end=
    undef_method :hit_end=
    
    # 
    # Boolean indicating whether or not more input could change
    # a positive match into a negative one.
    # 
    # If requireEnd is true, and a match was found, then more
    # input could cause the match to be lost.
    # If requireEnd is false and a match was found, then more
    # input might change the match but the match won't be lost.
    # If a match was not found, then requireEnd has no meaning.
    attr_accessor :require_end
    alias_method :attr_require_end, :require_end
    undef_method :require_end
    alias_method :attr_require_end=, :require_end=
    undef_method :require_end=
    
    # 
    # If transparentBounds is true then the boundaries of this
    # matcher's region are transparent to lookahead, lookbehind,
    # and boundary matching constructs that try to see beyond them.
    attr_accessor :transparent_bounds
    alias_method :attr_transparent_bounds, :transparent_bounds
    undef_method :transparent_bounds
    alias_method :attr_transparent_bounds=, :transparent_bounds=
    undef_method :transparent_bounds=
    
    # 
    # If anchoringBounds is true then the boundaries of this
    # matcher's region match anchors such as ^ and $.
    attr_accessor :anchoring_bounds
    alias_method :attr_anchoring_bounds, :anchoring_bounds
    undef_method :anchoring_bounds
    alias_method :attr_anchoring_bounds=, :anchoring_bounds=
    undef_method :anchoring_bounds=
    
    typesig { [] }
    # 
    # No default constructor.
    def initialize
      @parent_pattern = nil
      @groups = nil
      @from = 0
      @to = 0
      @lookbehind_to = 0
      @text = nil
      @accept_mode = NOANCHOR
      @first = -1
      @last = 0
      @old_last = -1
      @last_append_position = 0
      @locals = nil
      @hit_end = false
      @require_end = false
      @transparent_bounds = false
      @anchoring_bounds = true
    end
    
    typesig { [Pattern, CharSequence] }
    # 
    # All matchers have the state used by Pattern during a match.
    def initialize(parent, text)
      @parent_pattern = nil
      @groups = nil
      @from = 0
      @to = 0
      @lookbehind_to = 0
      @text = nil
      @accept_mode = NOANCHOR
      @first = -1
      @last = 0
      @old_last = -1
      @last_append_position = 0
      @locals = nil
      @hit_end = false
      @require_end = false
      @transparent_bounds = false
      @anchoring_bounds = true
      @parent_pattern = parent
      @text = text
      # Allocate state storage
      parent_group_count = Math.max(parent.attr_capturing_group_count, 10)
      @groups = Array.typed(::Java::Int).new(parent_group_count * 2) { 0 }
      @locals = Array.typed(::Java::Int).new(parent.attr_local_count) { 0 }
      # Put fields into initial states
      reset
    end
    
    typesig { [] }
    # 
    # Returns the pattern that is interpreted by this matcher.
    # 
    # @return  The pattern for which this matcher was created
    def pattern
      return @parent_pattern
    end
    
    typesig { [] }
    # 
    # Returns the match state of this matcher as a {@link MatchResult}.
    # The result is unaffected by subsequent operations performed upon this
    # matcher.
    # 
    # @return  a <code>MatchResult</code> with the state of this matcher
    # @since 1.5
    def to_match_result
      result = Matcher.new(@parent_pattern, @text.to_s)
      result.attr_first = @first
      result.attr_last = @last
      result.attr_groups = (@groups.clone)
      return result
    end
    
    typesig { [Pattern] }
    # 
    # Changes the <tt>Pattern</tt> that this <tt>Matcher</tt> uses to
    # find matches with.
    # 
    # <p> This method causes this matcher to lose information
    # about the groups of the last match that occurred. The
    # matcher's position in the input is maintained and its
    # last append position is unaffected.</p>
    # 
    # @param  newPattern
    # The new pattern used by this matcher
    # @return  This matcher
    # @throws  IllegalArgumentException
    # If newPattern is <tt>null</tt>
    # @since 1.5
    def use_pattern(new_pattern)
      if ((new_pattern).nil?)
        raise IllegalArgumentException.new("Pattern cannot be null")
      end
      @parent_pattern = new_pattern
      # Reallocate state storage
      parent_group_count = Math.max(new_pattern.attr_capturing_group_count, 10)
      @groups = Array.typed(::Java::Int).new(parent_group_count * 2) { 0 }
      @locals = Array.typed(::Java::Int).new(new_pattern.attr_local_count) { 0 }
      i = 0
      while i < @groups.attr_length
        @groups[i] = -1
        ((i += 1) - 1)
      end
      i_ = 0
      while i_ < @locals.attr_length
        @locals[i_] = -1
        ((i_ += 1) - 1)
      end
      return self
    end
    
    typesig { [] }
    # 
    # Resets this matcher.
    # 
    # <p> Resetting a matcher discards all of its explicit state information
    # and sets its append position to zero. The matcher's region is set to the
    # default region, which is its entire character sequence. The anchoring
    # and transparency of this matcher's region boundaries are unaffected.
    # 
    # @return  This matcher
    def reset
      @first = -1
      @last = 0
      @old_last = -1
      i = 0
      while i < @groups.attr_length
        @groups[i] = -1
        ((i += 1) - 1)
      end
      i_ = 0
      while i_ < @locals.attr_length
        @locals[i_] = -1
        ((i_ += 1) - 1)
      end
      @last_append_position = 0
      @from = 0
      @to = get_text_length
      return self
    end
    
    typesig { [CharSequence] }
    # 
    # Resets this matcher with a new input sequence.
    # 
    # <p> Resetting a matcher discards all of its explicit state information
    # and sets its append position to zero.  The matcher's region is set to
    # the default region, which is its entire character sequence.  The
    # anchoring and transparency of this matcher's region boundaries are
    # unaffected.
    # 
    # @param  input
    # The new input character sequence
    # 
    # @return  This matcher
    def reset(input)
      @text = input
      return reset
    end
    
    typesig { [] }
    # 
    # Returns the start index of the previous match.  </p>
    # 
    # @return  The index of the first character matched
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    def start
      if (@first < 0)
        raise IllegalStateException.new("No match available")
      end
      return @first
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the start index of the subsequence captured by the given group
    # during the previous match operation.
    # 
    # <p> <a href="Pattern.html#cg">Capturing groups</a> are indexed from left
    # to right, starting at one.  Group zero denotes the entire pattern, so
    # the expression <i>m.</i><tt>start(0)</tt> is equivalent to
    # <i>m.</i><tt>start()</tt>.  </p>
    # 
    # @param  group
    # The index of a capturing group in this matcher's pattern
    # 
    # @return  The index of the first character captured by the group,
    # or <tt>-1</tt> if the match was successful but the group
    # itself did not match anything
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    # 
    # @throws  IndexOutOfBoundsException
    # If there is no capturing group in the pattern
    # with the given index
    def start(group)
      if (@first < 0)
        raise IllegalStateException.new("No match available")
      end
      if (group > group_count)
        raise IndexOutOfBoundsException.new("No group " + (group).to_s)
      end
      return @groups[group * 2]
    end
    
    typesig { [] }
    # 
    # Returns the offset after the last character matched.  </p>
    # 
    # @return  The offset after the last character matched
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    def end
      if (@first < 0)
        raise IllegalStateException.new("No match available")
      end
      return @last
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the offset after the last character of the subsequence
    # captured by the given group during the previous match operation.
    # 
    # <p> <a href="Pattern.html#cg">Capturing groups</a> are indexed from left
    # to right, starting at one.  Group zero denotes the entire pattern, so
    # the expression <i>m.</i><tt>end(0)</tt> is equivalent to
    # <i>m.</i><tt>end()</tt>.  </p>
    # 
    # @param  group
    # The index of a capturing group in this matcher's pattern
    # 
    # @return  The offset after the last character captured by the group,
    # or <tt>-1</tt> if the match was successful
    # but the group itself did not match anything
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    # 
    # @throws  IndexOutOfBoundsException
    # If there is no capturing group in the pattern
    # with the given index
    def end(group)
      if (@first < 0)
        raise IllegalStateException.new("No match available")
      end
      if (group > group_count)
        raise IndexOutOfBoundsException.new("No group " + (group).to_s)
      end
      return @groups[group * 2 + 1]
    end
    
    typesig { [] }
    # 
    # Returns the input subsequence matched by the previous match.
    # 
    # <p> For a matcher <i>m</i> with input sequence <i>s</i>,
    # the expressions <i>m.</i><tt>group()</tt> and
    # <i>s.</i><tt>substring(</tt><i>m.</i><tt>start(),</tt>&nbsp;<i>m.</i><tt>end())</tt>
    # are equivalent.  </p>
    # 
    # <p> Note that some patterns, for example <tt>a*</tt>, match the empty
    # string.  This method will return the empty string when the pattern
    # successfully matches the empty string in the input.  </p>
    # 
    # @return The (possibly empty) subsequence matched by the previous match,
    # in string form
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    def group
      return group(0)
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns the input subsequence captured by the given group during the
    # previous match operation.
    # 
    # <p> For a matcher <i>m</i>, input sequence <i>s</i>, and group index
    # <i>g</i>, the expressions <i>m.</i><tt>group(</tt><i>g</i><tt>)</tt> and
    # <i>s.</i><tt>substring(</tt><i>m.</i><tt>start(</tt><i>g</i><tt>),</tt>&nbsp;<i>m.</i><tt>end(</tt><i>g</i><tt>))</tt>
    # are equivalent.  </p>
    # 
    # <p> <a href="Pattern.html#cg">Capturing groups</a> are indexed from left
    # to right, starting at one.  Group zero denotes the entire pattern, so
    # the expression <tt>m.group(0)</tt> is equivalent to <tt>m.group()</tt>.
    # </p>
    # 
    # <p> If the match was successful but the group specified failed to match
    # any part of the input sequence, then <tt>null</tt> is returned. Note
    # that some groups, for example <tt>(a*)</tt>, match the empty string.
    # This method will return the empty string when such a group successfully
    # matches the empty string in the input.  </p>
    # 
    # @param  group
    # The index of a capturing group in this matcher's pattern
    # 
    # @return  The (possibly empty) subsequence captured by the group
    # during the previous match, or <tt>null</tt> if the group
    # failed to match part of the input
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    # 
    # @throws  IndexOutOfBoundsException
    # If there is no capturing group in the pattern
    # with the given index
    def group(group_)
      if (@first < 0)
        raise IllegalStateException.new("No match found")
      end
      if (group_ < 0 || group_ > group_count)
        raise IndexOutOfBoundsException.new("No group " + (group_).to_s)
      end
      if (((@groups[group_ * 2]).equal?(-1)) || ((@groups[group_ * 2 + 1]).equal?(-1)))
        return nil
      end
      return get_sub_sequence(@groups[group_ * 2], @groups[group_ * 2 + 1]).to_s
    end
    
    typesig { [] }
    # 
    # Returns the number of capturing groups in this matcher's pattern.
    # 
    # <p> Group zero denotes the entire pattern by convention. It is not
    # included in this count.
    # 
    # <p> Any non-negative integer smaller than or equal to the value
    # returned by this method is guaranteed to be a valid group index for
    # this matcher.  </p>
    # 
    # @return The number of capturing groups in this matcher's pattern
    def group_count
      return @parent_pattern.attr_capturing_group_count - 1
    end
    
    typesig { [] }
    # 
    # Attempts to match the entire region against the pattern.
    # 
    # <p> If the match succeeds then more information can be obtained via the
    # <tt>start</tt>, <tt>end</tt>, and <tt>group</tt> methods.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, the entire region sequence
    # matches this matcher's pattern
    def matches
      return match(@from, ENDANCHOR)
    end
    
    typesig { [] }
    # 
    # Attempts to find the next subsequence of the input sequence that matches
    # the pattern.
    # 
    # <p> This method starts at the beginning of this matcher's region, or, if
    # a previous invocation of the method was successful and the matcher has
    # not since been reset, at the first character not matched by the previous
    # match.
    # 
    # <p> If the match succeeds then more information can be obtained via the
    # <tt>start</tt>, <tt>end</tt>, and <tt>group</tt> methods.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, a subsequence of the input
    # sequence matches this matcher's pattern
    def find
      next_search_index = @last
      if ((next_search_index).equal?(@first))
        ((next_search_index += 1) - 1)
      end
      # If next search starts before region, start it at region
      if (next_search_index < @from)
        next_search_index = @from
      end
      # If next search starts beyond region then it fails
      if (next_search_index > @to)
        i = 0
        while i < @groups.attr_length
          @groups[i] = -1
          ((i += 1) - 1)
        end
        return false
      end
      return search(next_search_index)
    end
    
    typesig { [::Java::Int] }
    # 
    # Resets this matcher and then attempts to find the next subsequence of
    # the input sequence that matches the pattern, starting at the specified
    # index.
    # 
    # <p> If the match succeeds then more information can be obtained via the
    # <tt>start</tt>, <tt>end</tt>, and <tt>group</tt> methods, and subsequent
    # invocations of the {@link #find()} method will start at the first
    # character not matched by this match.  </p>
    # 
    # @throws  IndexOutOfBoundsException
    # If start is less than zero or if start is greater than the
    # length of the input sequence.
    # 
    # @return  <tt>true</tt> if, and only if, a subsequence of the input
    # sequence starting at the given index matches this matcher's
    # pattern
    def find(start)
      limit = get_text_length
      if ((start < 0) || (start > limit))
        raise IndexOutOfBoundsException.new("Illegal start index")
      end
      reset
      return search(start)
    end
    
    typesig { [] }
    # 
    # Attempts to match the input sequence, starting at the beginning of the
    # region, against the pattern.
    # 
    # <p> Like the {@link #matches matches} method, this method always starts
    # at the beginning of the region; unlike that method, it does not
    # require that the entire region be matched.
    # 
    # <p> If the match succeeds then more information can be obtained via the
    # <tt>start</tt>, <tt>end</tt>, and <tt>group</tt> methods.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, a prefix of the input
    # sequence matches this matcher's pattern
    def looking_at
      return match(@from, NOANCHOR)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Returns a literal replacement <code>String</code> for the specified
      # <code>String</code>.
      # 
      # This method produces a <code>String</code> that will work
      # as a literal replacement <code>s</code> in the
      # <code>appendReplacement</code> method of the {@link Matcher} class.
      # The <code>String</code> produced will match the sequence of characters
      # in <code>s</code> treated as a literal sequence. Slashes ('\') and
      # dollar signs ('$') will be given no special meaning.
      # 
      # @param  s The string to be literalized
      # @return  A literal string replacement
      # @since 1.5
      def quote_replacement(s)
        if (((s.index_of(Character.new(?\\.ord))).equal?(-1)) && ((s.index_of(Character.new(?$.ord))).equal?(-1)))
          return s
        end
        sb = StringBuilder.new
        i = 0
        while i < s.length
          c = s.char_at(i)
          if ((c).equal?(Character.new(?\\.ord)) || (c).equal?(Character.new(?$.ord)))
            sb.append(Character.new(?\\.ord))
          end
          sb.append(c)
          ((i += 1) - 1)
        end
        return sb.to_s
      end
    }
    
    typesig { [StringBuffer, String] }
    # 
    # Implements a non-terminal append-and-replace step.
    # 
    # <p> This method performs the following actions: </p>
    # 
    # <ol>
    # 
    # <li><p> It reads characters from the input sequence, starting at the
    # append position, and appends them to the given string buffer.  It
    # stops after reading the last character preceding the previous match,
    # that is, the character at index {@link
    # #start()}&nbsp;<tt>-</tt>&nbsp;<tt>1</tt>.  </p></li>
    # 
    # <li><p> It appends the given replacement string to the string buffer.
    # </p></li>
    # 
    # <li><p> It sets the append position of this matcher to the index of
    # the last character matched, plus one, that is, to {@link #end()}.
    # </p></li>
    # 
    # </ol>
    # 
    # <p> The replacement string may contain references to subsequences
    # captured during the previous match: Each occurrence of
    # <tt>$</tt><i>g</i><tt></tt> will be replaced by the result of
    # evaluating {@link #group(int) group}<tt>(</tt><i>g</i><tt>)</tt>.
    # The first number after the <tt>$</tt> is always treated as part of
    # the group reference. Subsequent numbers are incorporated into g if
    # they would form a legal group reference. Only the numerals '0'
    # through '9' are considered as potential components of the group
    # reference. If the second group matched the string <tt>"foo"</tt>, for
    # example, then passing the replacement string <tt>"$2bar"</tt> would
    # cause <tt>"foobar"</tt> to be appended to the string buffer. A dollar
    # sign (<tt>$</tt>) may be included as a literal in the replacement
    # string by preceding it with a backslash (<tt>\$</tt>).
    # 
    # <p> Note that backslashes (<tt>\</tt>) and dollar signs (<tt>$</tt>) in
    # the replacement string may cause the results to be different than if it
    # were being treated as a literal replacement string. Dollar signs may be
    # treated as references to captured subsequences as described above, and
    # backslashes are used to escape literal characters in the replacement
    # string.
    # 
    # <p> This method is intended to be used in a loop together with the
    # {@link #appendTail appendTail} and {@link #find find} methods.  The
    # following code, for example, writes <tt>one dog two dogs in the
    # yard</tt> to the standard-output stream: </p>
    # 
    # <blockquote><pre>
    # Pattern p = Pattern.compile("cat");
    # Matcher m = p.matcher("one cat two cats in the yard");
    # StringBuffer sb = new StringBuffer();
    # while (m.find()) {
    # m.appendReplacement(sb, "dog");
    # }
    # m.appendTail(sb);
    # System.out.println(sb.toString());</pre></blockquote>
    # 
    # @param  sb
    # The target string buffer
    # 
    # @param  replacement
    # The replacement string
    # 
    # @return  This matcher
    # 
    # @throws  IllegalStateException
    # If no match has yet been attempted,
    # or if the previous match operation failed
    # 
    # @throws  IndexOutOfBoundsException
    # If the replacement string refers to a capturing group
    # that does not exist in the pattern
    def append_replacement(sb, replacement)
      # If no match, return error
      if (@first < 0)
        raise IllegalStateException.new("No match available")
      end
      # Process substitution string to replace group references with groups
      cursor = 0
      result = StringBuilder.new
      while (cursor < replacement.length)
        next_char = replacement.char_at(cursor)
        if ((next_char).equal?(Character.new(?\\.ord)))
          ((cursor += 1) - 1)
          next_char = replacement.char_at(cursor)
          result.append(next_char)
          ((cursor += 1) - 1)
        else
          if ((next_char).equal?(Character.new(?$.ord)))
            # Skip past $
            ((cursor += 1) - 1)
            # The first number is always a group
            ref_num = RJava.cast_to_int(replacement.char_at(cursor)) - Character.new(?0.ord)
            if ((ref_num < 0) || (ref_num > 9))
              raise IllegalArgumentException.new("Illegal group reference")
            end
            ((cursor += 1) - 1)
            # Capture the largest legal group string
            done = false
            while (!done)
              if (cursor >= replacement.length)
                break
              end
              next_digit = replacement.char_at(cursor) - Character.new(?0.ord)
              if ((next_digit < 0) || (next_digit > 9))
                # not a number
                break
              end
              new_ref_num = (ref_num * 10) + next_digit
              if (group_count < new_ref_num)
                done = true
              else
                ref_num = new_ref_num
                ((cursor += 1) - 1)
              end
            end
            # Append group
            if (!(start(ref_num)).equal?(-1) && !(end(ref_num)).equal?(-1))
              result.append(@text, start(ref_num), end(ref_num))
            end
          else
            result.append(next_char)
            ((cursor += 1) - 1)
          end
        end
      end
      # Append the intervening text
      sb.append(@text, @last_append_position, @first)
      # Append the match substitution
      sb.append(result)
      @last_append_position = @last
      return self
    end
    
    typesig { [StringBuffer] }
    # 
    # Implements a terminal append-and-replace step.
    # 
    # <p> This method reads characters from the input sequence, starting at
    # the append position, and appends them to the given string buffer.  It is
    # intended to be invoked after one or more invocations of the {@link
    # #appendReplacement appendReplacement} method in order to copy the
    # remainder of the input sequence.  </p>
    # 
    # @param  sb
    # The target string buffer
    # 
    # @return  The target string buffer
    def append_tail(sb)
      sb.append(@text, @last_append_position, get_text_length)
      return sb
    end
    
    typesig { [String] }
    # 
    # Replaces every subsequence of the input sequence that matches the
    # pattern with the given replacement string.
    # 
    # <p> This method first resets this matcher.  It then scans the input
    # sequence looking for matches of the pattern.  Characters that are not
    # part of any match are appended directly to the result string; each match
    # is replaced in the result by the replacement string.  The replacement
    # string may contain references to captured subsequences as in the {@link
    # #appendReplacement appendReplacement} method.
    # 
    # <p> Note that backslashes (<tt>\</tt>) and dollar signs (<tt>$</tt>) in
    # the replacement string may cause the results to be different than if it
    # were being treated as a literal replacement string. Dollar signs may be
    # treated as references to captured subsequences as described above, and
    # backslashes are used to escape literal characters in the replacement
    # string.
    # 
    # <p> Given the regular expression <tt>a*b</tt>, the input
    # <tt>"aabfooaabfooabfoob"</tt>, and the replacement string
    # <tt>"-"</tt>, an invocation of this method on a matcher for that
    # expression would yield the string <tt>"-foo-foo-foo-"</tt>.
    # 
    # <p> Invoking this method changes this matcher's state.  If the matcher
    # is to be used in further matching operations then it should first be
    # reset.  </p>
    # 
    # @param  replacement
    # The replacement string
    # 
    # @return  The string constructed by replacing each matching subsequence
    # by the replacement string, substituting captured subsequences
    # as needed
    def replace_all(replacement)
      reset
      result = find
      if (result)
        sb = StringBuffer.new
        begin
          append_replacement(sb, replacement)
          result = find
        end while (result)
        append_tail(sb)
        return sb.to_s
      end
      return @text.to_s
    end
    
    typesig { [String] }
    # 
    # Replaces the first subsequence of the input sequence that matches the
    # pattern with the given replacement string.
    # 
    # <p> This method first resets this matcher.  It then scans the input
    # sequence looking for a match of the pattern.  Characters that are not
    # part of the match are appended directly to the result string; the match
    # is replaced in the result by the replacement string.  The replacement
    # string may contain references to captured subsequences as in the {@link
    # #appendReplacement appendReplacement} method.
    # 
    # <p>Note that backslashes (<tt>\</tt>) and dollar signs (<tt>$</tt>) in
    # the replacement string may cause the results to be different than if it
    # were being treated as a literal replacement string. Dollar signs may be
    # treated as references to captured subsequences as described above, and
    # backslashes are used to escape literal characters in the replacement
    # string.
    # 
    # <p> Given the regular expression <tt>dog</tt>, the input
    # <tt>"zzzdogzzzdogzzz"</tt>, and the replacement string
    # <tt>"cat"</tt>, an invocation of this method on a matcher for that
    # expression would yield the string <tt>"zzzcatzzzdogzzz"</tt>.  </p>
    # 
    # <p> Invoking this method changes this matcher's state.  If the matcher
    # is to be used in further matching operations then it should first be
    # reset.  </p>
    # 
    # @param  replacement
    # The replacement string
    # @return  The string constructed by replacing the first matching
    # subsequence by the replacement string, substituting captured
    # subsequences as needed
    def replace_first(replacement)
      if ((replacement).nil?)
        raise NullPointerException.new("replacement")
      end
      reset
      if (!find)
        return @text.to_s
      end
      sb = StringBuffer.new
      append_replacement(sb, replacement)
      append_tail(sb)
      return sb.to_s
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Sets the limits of this matcher's region. The region is the part of the
    # input sequence that will be searched to find a match. Invoking this
    # method resets the matcher, and then sets the region to start at the
    # index specified by the <code>start</code> parameter and end at the
    # index specified by the <code>end</code> parameter.
    # 
    # <p>Depending on the transparency and anchoring being used (see
    # {@link #useTransparentBounds useTransparentBounds} and
    # {@link #useAnchoringBounds useAnchoringBounds}), certain constructs such
    # as anchors may behave differently at or around the boundaries of the
    # region.
    # 
    # @param  start
    # The index to start searching at (inclusive)
    # @param  end
    # The index to end searching at (exclusive)
    # @throws  IndexOutOfBoundsException
    # If start or end is less than zero, if
    # start is greater than the length of the input sequence, if
    # end is greater than the length of the input sequence, or if
    # start is greater than end.
    # @return  this matcher
    # @since 1.5
    def region(start_, end_)
      if ((start_ < 0) || (start_ > get_text_length))
        raise IndexOutOfBoundsException.new("start")
      end
      if ((end_ < 0) || (end_ > get_text_length))
        raise IndexOutOfBoundsException.new("end")
      end
      if (start_ > end_)
        raise IndexOutOfBoundsException.new("start > end")
      end
      reset
      @from = start_
      @to = end_
      return self
    end
    
    typesig { [] }
    # 
    # Reports the start index of this matcher's region. The
    # searches this matcher conducts are limited to finding matches
    # within {@link #regionStart regionStart} (inclusive) and
    # {@link #regionEnd regionEnd} (exclusive).
    # 
    # @return  The starting point of this matcher's region
    # @since 1.5
    def region_start
      return @from
    end
    
    typesig { [] }
    # 
    # Reports the end index (exclusive) of this matcher's region.
    # The searches this matcher conducts are limited to finding matches
    # within {@link #regionStart regionStart} (inclusive) and
    # {@link #regionEnd regionEnd} (exclusive).
    # 
    # @return  the ending point of this matcher's region
    # @since 1.5
    def region_end
      return @to
    end
    
    typesig { [] }
    # 
    # Queries the transparency of region bounds for this matcher.
    # 
    # <p> This method returns <tt>true</tt> if this matcher uses
    # <i>transparent</i> bounds, <tt>false</tt> if it uses <i>opaque</i>
    # bounds.
    # 
    # <p> See {@link #useTransparentBounds useTransparentBounds} for a
    # description of transparent and opaque bounds.
    # 
    # <p> By default, a matcher uses opaque region boundaries.
    # 
    # @return <tt>true</tt> iff this matcher is using transparent bounds,
    # <tt>false</tt> otherwise.
    # @see java.util.regex.Matcher#useTransparentBounds(boolean)
    # @since 1.5
    def has_transparent_bounds
      return @transparent_bounds
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Sets the transparency of region bounds for this matcher.
    # 
    # <p> Invoking this method with an argument of <tt>true</tt> will set this
    # matcher to use <i>transparent</i> bounds. If the boolean
    # argument is <tt>false</tt>, then <i>opaque</i> bounds will be used.
    # 
    # <p> Using transparent bounds, the boundaries of this
    # matcher's region are transparent to lookahead, lookbehind,
    # and boundary matching constructs. Those constructs can see beyond the
    # boundaries of the region to see if a match is appropriate.
    # 
    # <p> Using opaque bounds, the boundaries of this matcher's
    # region are opaque to lookahead, lookbehind, and boundary matching
    # constructs that may try to see beyond them. Those constructs cannot
    # look past the boundaries so they will fail to match anything outside
    # of the region.
    # 
    # <p> By default, a matcher uses opaque bounds.
    # 
    # @param  b a boolean indicating whether to use opaque or transparent
    # regions
    # @return this matcher
    # @see java.util.regex.Matcher#hasTransparentBounds
    # @since 1.5
    def use_transparent_bounds(b)
      @transparent_bounds = b
      return self
    end
    
    typesig { [] }
    # 
    # Queries the anchoring of region bounds for this matcher.
    # 
    # <p> This method returns <tt>true</tt> if this matcher uses
    # <i>anchoring</i> bounds, <tt>false</tt> otherwise.
    # 
    # <p> See {@link #useAnchoringBounds useAnchoringBounds} for a
    # description of anchoring bounds.
    # 
    # <p> By default, a matcher uses anchoring region boundaries.
    # 
    # @return <tt>true</tt> iff this matcher is using anchoring bounds,
    # <tt>false</tt> otherwise.
    # @see java.util.regex.Matcher#useAnchoringBounds(boolean)
    # @since 1.5
    def has_anchoring_bounds
      return @anchoring_bounds
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Sets the anchoring of region bounds for this matcher.
    # 
    # <p> Invoking this method with an argument of <tt>true</tt> will set this
    # matcher to use <i>anchoring</i> bounds. If the boolean
    # argument is <tt>false</tt>, then <i>non-anchoring</i> bounds will be
    # used.
    # 
    # <p> Using anchoring bounds, the boundaries of this
    # matcher's region match anchors such as ^ and $.
    # 
    # <p> Without anchoring bounds, the boundaries of this
    # matcher's region will not match anchors such as ^ and $.
    # 
    # <p> By default, a matcher uses anchoring region boundaries.
    # 
    # @param  b a boolean indicating whether or not to use anchoring bounds.
    # @return this matcher
    # @see java.util.regex.Matcher#hasAnchoringBounds
    # @since 1.5
    def use_anchoring_bounds(b)
      @anchoring_bounds = b
      return self
    end
    
    typesig { [] }
    # 
    # <p>Returns the string representation of this matcher. The
    # string representation of a <code>Matcher</code> contains information
    # that may be useful for debugging. The exact format is unspecified.
    # 
    # @return  The string representation of this matcher
    # @since 1.5
    def to_s
      sb = StringBuilder.new
      sb.append("java.util.regex.Matcher")
      sb.append("[pattern=" + (pattern).to_s)
      sb.append(" region=")
      sb.append((region_start).to_s + "," + (region_end).to_s)
      sb.append(" lastmatch=")
      if ((@first >= 0) && (!(group).nil?))
        sb.append(group)
      end
      sb.append("]")
      return sb.to_s
    end
    
    typesig { [] }
    # 
    # <p>Returns true if the end of input was hit by the search engine in
    # the last match operation performed by this matcher.
    # 
    # <p>When this method returns true, then it is possible that more input
    # would have changed the result of the last search.
    # 
    # @return  true iff the end of input was hit in the last match; false
    # otherwise
    # @since 1.5
    def hit_end
      return @hit_end
    end
    
    typesig { [] }
    # 
    # <p>Returns true if more input could change a positive match into a
    # negative one.
    # 
    # <p>If this method returns true, and a match was found, then more
    # input could cause the match to be lost. If this method returns false
    # and a match was found, then more input might change the match but the
    # match won't be lost. If a match was not found, then requireEnd has no
    # meaning.
    # 
    # @return  true iff more input could change a positive match into a
    # negative one.
    # @since 1.5
    def require_end
      return @require_end
    end
    
    typesig { [::Java::Int] }
    # 
    # Initiates a search to find a Pattern within the given bounds.
    # The groups are filled with default values and the match of the root
    # of the state machine is called. The state machine will hold the state
    # of the match as it proceeds in this matcher.
    # 
    # Matcher.from is not set here, because it is the "hard" boundary
    # of the start of the search which anchors will set to. The from param
    # is the "soft" boundary of the start of the search, meaning that the
    # regex tries to match at that index but ^ won't match there. Subsequent
    # calls to the search methods start at a new "soft" boundary which is
    # the end of the previous match.
    def search(from)
      @hit_end = false
      @require_end = false
      from = from < 0 ? 0 : from
      @first = from
      @old_last = @old_last < 0 ? from : @old_last
      i = 0
      while i < @groups.attr_length
        @groups[i] = -1
        ((i += 1) - 1)
      end
      @accept_mode = NOANCHOR
      result = @parent_pattern.attr_root.match(self, from, @text)
      if (!result)
        @first = -1
      end
      @old_last = @last
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Initiates a search for an anchored match to a Pattern within the given
    # bounds. The groups are filled with default values and the match of the
    # root of the state machine is called. The state machine will hold the
    # state of the match as it proceeds in this matcher.
    def match(from, anchor)
      @hit_end = false
      @require_end = false
      from = from < 0 ? 0 : from
      @first = from
      @old_last = @old_last < 0 ? from : @old_last
      i = 0
      while i < @groups.attr_length
        @groups[i] = -1
        ((i += 1) - 1)
      end
      @accept_mode = anchor
      result = @parent_pattern.attr_match_root.match(self, from, @text)
      if (!result)
        @first = -1
      end
      @old_last = @last
      return result
    end
    
    typesig { [] }
    # 
    # Returns the end index of the text.
    # 
    # @return the index after the last character in the text
    def get_text_length
      return @text.length
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # 
    # Generates a String from this Matcher's input in the specified range.
    # 
    # @param  beginIndex   the beginning index, inclusive
    # @param  endIndex     the ending index, exclusive
    # @return A String generated from this Matcher's input
    def get_sub_sequence(begin_index, end_index)
      return @text.sub_sequence(begin_index, end_index)
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns this Matcher's input character at index i.
    # 
    # @return A char from the specified index
    def char_at(i)
      return @text.char_at(i)
    end
    
    private
    alias_method :initialize__matcher, :initialize
  end
  
end

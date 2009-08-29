require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module UnicodeSetIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Util, :Iterator
    }
  end
  
  # UnicodeSetIterator iterates over the contents of a UnicodeSet.  It
  # iterates over either code points or code point ranges.  After all
  # code points or ranges have been returned, it returns the
  # multicharacter strings of the UnicodSet, if any.
  # 
  # <p>To iterate over code points, use a loop like this:
  # <pre>
  # UnicodeSetIterator it(set);
  # while (set.next()) {
  # if (set.codepoint != UnicodeSetIterator::IS_STRING) {
  # processCodepoint(set.codepoint);
  # } else {
  # processString(set.string);
  # }
  # }
  # </pre>
  # 
  # <p>To iterate over code point ranges, use a loop like this:
  # <pre>
  # UnicodeSetIterator it(set);
  # while (set.nextRange()) {
  # if (set.codepoint != UnicodeSetIterator::IS_STRING) {
  # processCodepointRange(set.codepoint, set.codepointEnd);
  # } else {
  # processString(set.string);
  # }
  # }
  # </pre>
  # @author M. Davis
  # @stable ICU 2.0
  class UnicodeSetIterator 
    include_class_members UnicodeSetIteratorImports
    
    class_module.module_eval {
      # Value of <tt>codepoint</tt> if the iterator points to a string.
      # If <tt>codepoint == IS_STRING</tt>, then examine
      # <tt>string</tt> for the current iteration result.
      # @stable ICU 2.0
      
      def is_string
        defined?(@@is_string) ? @@is_string : @@is_string= -1
      end
      alias_method :attr_is_string, :is_string
      
      def is_string=(value)
        @@is_string = value
      end
      alias_method :attr_is_string=, :is_string=
    }
    
    # Current code point, or the special value <tt>IS_STRING</tt>, if
    # the iterator points to a string.
    # @stable ICU 2.0
    attr_accessor :codepoint
    alias_method :attr_codepoint, :codepoint
    undef_method :codepoint
    alias_method :attr_codepoint=, :codepoint=
    undef_method :codepoint=
    
    # When iterating over ranges using <tt>nextRange()</tt>,
    # <tt>codepointEnd</tt> contains the inclusive end of the
    # iteration range, if <tt>codepoint != IS_STRING</tt>.  If
    # iterating over code points using <tt>next()</tt>, or if
    # <tt>codepoint == IS_STRING</tt>, then the value of
    # <tt>codepointEnd</tt> is undefined.
    # @stable ICU 2.0
    attr_accessor :codepoint_end
    alias_method :attr_codepoint_end, :codepoint_end
    undef_method :codepoint_end
    alias_method :attr_codepoint_end=, :codepoint_end=
    undef_method :codepoint_end=
    
    # If <tt>codepoint == IS_STRING</tt>, then <tt>string</tt> points
    # to the current string.  If <tt>codepoint != IS_STRING</tt>, the
    # value of <tt>string</tt> is undefined.
    # @stable ICU 2.0
    attr_accessor :string
    alias_method :attr_string, :string
    undef_method :string
    alias_method :attr_string=, :string=
    undef_method :string=
    
    typesig { [UnicodeSet] }
    # Create an iterator over the given set.
    # @param set set to iterate over
    # @stable ICU 2.0
    def initialize(set)
      @codepoint = 0
      @codepoint_end = 0
      @string = nil
      @set = nil
      @end_range = 0
      @range = 0
      @end_element = 0
      @next_element = 0
      @string_iterator = nil
      reset(set)
    end
    
    typesig { [] }
    # Returns the next element in the set, either a code point range
    # or a string.  If there are no more elements in the set, return
    # false.  If <tt>codepoint == IS_STRING</tt>, the value is a
    # string in the <tt>string</tt> field.  Otherwise the value is a
    # range of one or more code points from <tt>codepoint</tt> to
    # <tt>codepointeEnd</tt> inclusive.
    # 
    # <p>The order of iteration is all code points ranges in sorted
    # order, followed by all strings sorted order.  Ranges are
    # disjoint and non-contiguous.  <tt>string</tt> is undefined
    # unless <tt>codepoint == IS_STRING</tt>.  Do not mix calls to
    # <tt>next()</tt> and <tt>nextRange()</tt> without calling
    # <tt>reset()</tt> between them.  The results of doing so are
    # undefined.
    # 
    # @return true if there was another element in the set and this
    # object contains the element.
    # @stable ICU 2.0
    def next_range
      if (@next_element <= @end_element)
        @codepoint_end = @end_element
        @codepoint = @next_element
        @next_element = @end_element + 1
        return true
      end
      if (@range < @end_range)
        load_range((@range += 1))
        @codepoint_end = @end_element
        @codepoint = @next_element
        @next_element = @end_element + 1
        return true
      end
      # stringIterator == null iff there are no string elements remaining
      if ((@string_iterator).nil?)
        return false
      end
      @codepoint = self.attr_is_string # signal that value is actually a string
      @string = RJava.cast_to_string(@string_iterator.next_)
      if (!@string_iterator.has_next)
        @string_iterator = nil
      end
      return true
    end
    
    typesig { [UnicodeSet] }
    # Sets this iterator to visit the elements of the given set and
    # resets it to the start of that set.  The iterator is valid only
    # so long as <tt>set</tt> is valid.
    # @param set the set to iterate over.
    # @stable ICU 2.0
    def reset(set)
      @set = set
      reset
    end
    
    typesig { [] }
    # Resets this iterator to the start of the set.
    # @stable ICU 2.0
    def reset
      @end_range = @set.get_range_count - 1
      @range = 0
      @end_element = -1
      @next_element = 0
      if (@end_range >= 0)
        load_range(@range)
      end
      @string_iterator = nil
      if (!(@set.attr_strings).nil?)
        @string_iterator = @set.attr_strings.iterator
        if (!@string_iterator.has_next)
          @string_iterator = nil
        end
      end
    end
    
    # ======================= PRIVATES ===========================
    attr_accessor :set
    alias_method :attr_set, :set
    undef_method :set
    alias_method :attr_set=, :set=
    undef_method :set=
    
    attr_accessor :end_range
    alias_method :attr_end_range, :end_range
    undef_method :end_range
    alias_method :attr_end_range=, :end_range=
    undef_method :end_range=
    
    attr_accessor :range
    alias_method :attr_range, :range
    undef_method :range
    alias_method :attr_range=, :range=
    undef_method :range=
    
    # @internal
    attr_accessor :end_element
    alias_method :attr_end_element, :end_element
    undef_method :end_element
    alias_method :attr_end_element=, :end_element=
    undef_method :end_element=
    
    # @internal
    attr_accessor :next_element
    alias_method :attr_next_element, :next_element
    undef_method :next_element
    alias_method :attr_next_element=, :next_element=
    undef_method :next_element=
    
    attr_accessor :string_iterator
    alias_method :attr_string_iterator, :string_iterator
    undef_method :string_iterator
    alias_method :attr_string_iterator=, :string_iterator=
    undef_method :string_iterator=
    
    typesig { [::Java::Int] }
    # Invariant: stringIterator is null when there are no (more) strings remaining
    # 
    # 
    # @internal
    def load_range(range)
      @next_element = @set.get_range_start(range)
      @end_element = @set.get_range_end(range)
    end
    
    private
    alias_method :initialize__unicode_set_iterator, :initialize
  end
  
end

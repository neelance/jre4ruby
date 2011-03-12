require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss
  module TokenTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Org::Ietf::Jgss, :MessageProp
      include_const ::Java::Util, :LinkedList
    }
  end
  
  # A utility class that implements a number list that keeps track of which
  # tokens have arrived by storing their token numbers in the list. It helps
  # detect old tokens, out of sequence tokens, and duplicate tokens.
  # 
  # Each element of the list is an interval [a, b]. Its existence in the
  # list implies that all token numbers in the range a, a+1, ..., b-1, b
  # have arrived. Gaps in arrived token numbers are represented by the
  # numbers that fall in between two elements of the list. eg. {[a,b],
  # [c,d]} indicates that the token numbers b+1, ..., c-1 have not arrived
  # yet.
  # 
  # The maximum number of intervals that we keep track of is
  # MAX_INTERVALS. Thus if there are too many gaps, then some of the older
  # sequence numbers are deleted from the list. The earliest sequence number
  # that exists in the list is the windowStart. The next expected sequence
  # number, or expectedNumber, is one greater than the latest sequence
  # number in the list.
  # 
  # The list keeps track the first token number that should have arrived
  # (initNumber) so that it is able to detect if certain numbers occur after
  # the first valid token number but before windowStart. That would happen
  # if the number of elements (intervals) exceeds MAX_INTERVALS and some
  # initial elements had  to be deleted.
  # 
  # The working of the list is optimized for the normal case where the
  # tokens arrive in sequence.
  # 
  # @author Mayank Upadhyay
  # @since 1.4
  class TokenTracker 
    include_class_members TokenTrackerImports
    
    class_module.module_eval {
      const_set_lazy(:MAX_INTERVALS) { 5 }
      const_attr_reader  :MAX_INTERVALS
    }
    
    attr_accessor :init_number
    alias_method :attr_init_number, :init_number
    undef_method :init_number
    alias_method :attr_init_number=, :init_number=
    undef_method :init_number=
    
    attr_accessor :window_start
    alias_method :attr_window_start, :window_start
    undef_method :window_start
    alias_method :attr_window_start=, :window_start=
    undef_method :window_start=
    
    attr_accessor :expected_number
    alias_method :attr_expected_number, :expected_number
    undef_method :expected_number
    alias_method :attr_expected_number=, :expected_number=
    undef_method :expected_number=
    
    attr_accessor :window_start_index
    alias_method :attr_window_start_index, :window_start_index
    undef_method :window_start_index
    alias_method :attr_window_start_index=, :window_start_index=
    undef_method :window_start_index=
    
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    typesig { [::Java::Int] }
    def initialize(init_number)
      @init_number = 0
      @window_start = 0
      @expected_number = 0
      @window_start_index = 0
      @list = LinkedList.new
      @init_number = init_number
      @window_start = init_number
      @expected_number = init_number
      # Make an entry with one less than the expected first token
      entry = Entry.new_local(self, init_number - 1)
      @list.add(entry)
    end
    
    typesig { [::Java::Int] }
    # Returns the index for the entry into which this number will fit. If
    # there is none, it returns the index of the last interval
    # which precedes this number. It returns -1 if the number needs to be
    # a in a new interval ahead of the whole list.
    def get_interval_index(number)
      entry = nil
      i = 0
      # Start from the rear to optimize for the normal case
      i = @list.size - 1
      while i >= 0
        entry = @list.get(i)
        if ((entry <=> number) <= 0)
          break
        end
        i -= 1
      end
      return i
    end
    
    typesig { [::Java::Int, MessageProp] }
    # Sets the sequencing and replay information for the given token
    # number.
    # 
    # The following represents the number line with positions of
    # initNumber, windowStart, expectedNumber marked on it. Regions in
    # between them show the different sequencing and replay state
    # possibilites for tokens that fall in there.
    # 
    #  (1)      windowStart
    #           initNumber               expectedNumber
    #              |                           |
    #           ---|---------------------------|---
    #          GAP |    DUP/UNSEQ              | GAP
    # 
    # 
    #  (2)       initNumber   windowStart   expectedNumber
    #              |               |              |
    #           ---|---------------|--------------|---
    #          GAP |      OLD      |  DUP/UNSEQ   | GAP
    # 
    # 
    #  (3)                                windowStart
    #           expectedNumber            initNumber
    #              |                           |
    #           ---|---------------------------|---
    #    DUP/UNSEQ |           GAP             | DUP/UNSEQ
    # 
    # 
    #  (4)      expectedNumber    initNumber   windowStart
    #              |               |              |
    #           ---|---------------|--------------|---
    #    DUP/UNSEQ |        GAP    |    OLD       | DUP/UNSEQ
    # 
    # 
    # 
    #  (5)      windowStart   expectedNumber    initNumber
    #              |               |              |
    #           ---|---------------|--------------|---
    #          OLD |    DUP/UNSEQ  |     GAP      | OLD
    # 
    # 
    # 
    # (This analysis leaves out the possibility that expectedNumber passes
    # initNumber after wrapping around. That may be added later.)
    def get_props(number, prop)
      synchronized(self) do
        gap = false
        old = false
        unsequenced = false
        duplicate = false
        # System.out.println("\n\n==========");
        # System.out.println("TokenTracker.getProps(): number=" + number);
        # System.out.println(toString());
        pos = get_interval_index(number)
        entry = nil
        if (!(pos).equal?(-1))
          entry = @list.get(pos)
        end
        # Optimize for the expected case:
        if ((number).equal?(@expected_number))
          @expected_number += 1
        else
          # Next trivial case is to check for duplicate
          if (!(entry).nil? && entry.contains(number))
            duplicate = true
          else
            if (@expected_number >= @init_number)
              # Cases (1) and (2)
              if (number > @expected_number)
                gap = true
              else
                if (number >= @window_start)
                  unsequenced = true
                else
                  if (number >= @init_number)
                    old = true
                  else
                    gap = true
                  end
                end
              end
            else
              # Cases (3), (4) and (5)
              if (number > @expected_number)
                if (number < @init_number)
                  gap = true
                else
                  if (@window_start >= @init_number)
                    if (number >= @window_start)
                      unsequenced = true
                    else
                      old = true
                    end
                  else
                    old = true
                  end
                end
              else
                if (@window_start > @expected_number)
                  unsequenced = true
                else
                  if (number < @window_start)
                    old = true
                  else
                    unsequenced = true
                  end
                end
              end
            end
          end
        end
        if (!duplicate && !old)
          add(number, pos)
        end
        if (gap)
          @expected_number = number + 1
        end
        prop.set_supplementary_states(duplicate, old, unsequenced, gap, 0, nil)
        # System.out.println("Leaving with state:");
        # System.out.println(toString());
        # System.out.println("==========\n");
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the number to the list just after the entry that is currently
    # at position prevEntryPos. If prevEntryPos is -1, then the number
    # will begin a new interval at the front of the list.
    def add(number, prev_entry_pos)
      entry = nil
      entry_before = nil
      entry_after = nil
      appended = false
      prepended = false
      if (!(prev_entry_pos).equal?(-1))
        entry_before = @list.get(prev_entry_pos)
        # Can this number simply be added to the previous interval?
        if ((number).equal?((entry_before.get_end + 1)))
          entry_before.set_end(number)
          appended = true
        end
      end
      # Now check the interval that follows this number
      next_entry_pos = prev_entry_pos + 1
      if ((next_entry_pos) < @list.size)
        entry_after = @list.get(next_entry_pos)
        # Can this number simply be added to the next interval?
        if ((number).equal?((entry_after.get_start - 1)))
          if (!appended)
            entry_after.set_start(number)
          else
            # Merge the two entries
            entry_after.set_start(entry_before.get_start)
            @list.remove(prev_entry_pos)
            # Index of any entry following this gets decremented
            if (@window_start_index > prev_entry_pos)
              @window_start_index -= 1
            end
          end
          prepended = true
        end
      end
      if (prepended || appended)
        return
      end
      # At this point we know that the number will start a new interval
      # which needs to be added to the list. We might have to recyle an
      # older entry in the list.
      if (@list.size < MAX_INTERVALS)
        entry = Entry.new_local(self, number)
        if (prev_entry_pos < @window_start_index)
          @window_start_index += 1
        end # due to the insertion which will happen
      else
        # Delete the entry that marks the start of the current window.
        # The marker will automatically point to the next entry in the
        # list when this happens. If the current entry is at the end
        # of the list then set the marker to the start of the list.
        old_window_start_index = @window_start_index
        if ((@window_start_index).equal?((@list.size - 1)))
          @window_start_index = 0
        end
        entry = @list.remove(old_window_start_index)
        @window_start = @list.get(@window_start_index).get_start
        entry.set_start(number)
        entry.set_end(number)
        if (prev_entry_pos >= old_window_start_index)
          prev_entry_pos -= 1 # due to the deletion that just happened
        else
          # If the start of the current window just moved from the
          # end of the list to the front of the list, and if the new
          # entry will be added to the front of the list, then
          # the new entry is the actual window start.
          # eg, Consider { [-10, -8], ..., [-6, -3], [3, 9]}. In
          # this list, suppose the element [3, 9] is the start of
          # the window and has to be deleted to make place to add
          # [-12, -12]. The resultant list will be
          # {[-12, -12], [-10, -8], ..., [-6, -3]} and the new start
          # of the window should be the element [-12, -12], not
          # [-10, -8] which succeeded [3, 9] in the old list.
          if (!(old_window_start_index).equal?(@window_start_index))
            # windowStartIndex is 0 at this point
            if ((prev_entry_pos).equal?(-1))
              # The new entry is going to the front
              @window_start = number
            end
          else
            # due to the insertion which will happen:
            @window_start_index += 1
          end
        end
      end
      # Finally we are ready to actually add to the list at index
      # 'prevEntryPos+1'
      @list.add(prev_entry_pos + 1, entry)
    end
    
    typesig { [] }
    def to_s
      buf = StringBuffer.new("TokenTracker: ")
      buf.append(" initNumber=").append(@init_number)
      buf.append(" windowStart=").append(@window_start)
      buf.append(" expectedNumber=").append(@expected_number)
      buf.append(" windowStartIndex=").append(@window_start_index)
      buf.append("\n\tIntervals are: {")
      i = 0
      while i < @list.size
        if (!(i).equal?(0))
          buf.append(", ")
        end
        buf.append(@list.get(i).to_s)
        i += 1
      end
      buf.append(Character.new(?}.ord))
      return buf.to_s
    end
    
    class_module.module_eval {
      # An entry in the list that represents the sequence of received
      # tokens. Each entry is actaully an interval of numbers, all of which
      # have been received.
      const_set_lazy(:Entry) { Class.new do
        local_class_in TokenTracker
        include_class_members TokenTracker
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :end
        alias_method :attr_end, :end
        undef_method :end
        alias_method :attr_end=, :end=
        undef_method :end=
        
        typesig { [::Java::Int] }
        def initialize(number)
          @start = 0
          @end = 0
          @start = number
          @end = number
        end
        
        typesig { [::Java::Int] }
        # Returns -1 if this interval represented by this entry precedes
        # the number, 0 if the the number is contained in the interval,
        # and -1 if the interval occurs after the number.
        def compare_to(number)
          if (@start > number)
            return 1
          else
            if (@end < number)
              return -1
            else
              return 0
            end
          end
        end
        
        typesig { [::Java::Int] }
        def contains(number)
          return (number >= @start && number <= @end)
        end
        
        typesig { [::Java::Int] }
        def append(number)
          if ((number).equal?((@end + 1)))
            @end = number
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def set_interval(start, end_)
          @start = start
          @end = end_
        end
        
        typesig { [::Java::Int] }
        def set_end(end_)
          @end = end_
        end
        
        typesig { [::Java::Int] }
        def set_start(start)
          @start = start
        end
        
        typesig { [] }
        def get_start
          return @start
        end
        
        typesig { [] }
        def get_end
          return @end
        end
        
        typesig { [] }
        def to_s
          return ("[" + RJava.cast_to_string(@start) + ", " + RJava.cast_to_string(@end) + "]")
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    private
    alias_method :initialize__token_tracker, :initialize
  end
  
end

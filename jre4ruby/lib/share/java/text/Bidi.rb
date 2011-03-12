require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999-2003 - All Rights Reserved
# 
# The original version of this source code and documentation is
# copyrighted and owned by IBM. These materials are provided
# under terms of a License Agreement between IBM and Sun.
# This technology is protected by multiple US and International
# patents. This notice and attribution to IBM may not be removed.
module Java::Text
  module BidiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Awt, :Toolkit
      include_const ::Java::Awt::Font, :TextAttribute
      include_const ::Java::Awt::Font, :NumericShaper
      include_const ::Sun::Text, :CodePointIterator
    }
  end
  
  # This class implements the Unicode Bidirectional Algorithm.
  # <p>
  # A Bidi object provides information on the bidirectional reordering of the text
  # used to create it.  This is required, for example, to properly display Arabic
  # or Hebrew text.  These languages are inherently mixed directional, as they order
  # numbers from left-to-right while ordering most other text from right-to-left.
  # <p>
  # Once created, a Bidi object can be queried to see if the text it represents is
  # all left-to-right or all right-to-left.  Such objects are very lightweight and
  # this text is relatively easy to process.
  # <p>
  # If there are multiple runs of text, information about the runs can be accessed
  # by indexing to get the start, limit, and level of a run.  The level represents
  # both the direction and the 'nesting level' of a directional run.  Odd levels
  # are right-to-left, while even levels are left-to-right.  So for example level
  # 0 represents left-to-right text, while level 1 represents right-to-left text, and
  # level 2 represents left-to-right text embedded in a right-to-left run.
  # 
  # @since 1.4
  class Bidi 
    include_class_members BidiImports
    
    attr_accessor :dir
    alias_method :attr_dir, :dir
    undef_method :dir
    alias_method :attr_dir=, :dir=
    undef_method :dir=
    
    attr_accessor :baselevel
    alias_method :attr_baselevel, :baselevel
    undef_method :baselevel
    alias_method :attr_baselevel=, :baselevel=
    undef_method :baselevel=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :runs
    alias_method :attr_runs, :runs
    undef_method :runs
    alias_method :attr_runs=, :runs=
    undef_method :runs=
    
    attr_accessor :cws
    alias_method :attr_cws, :cws
    undef_method :cws
    alias_method :attr_cws=, :cws=
    undef_method :cws=
    
    class_module.module_eval {
      when_class_loaded do
        Sun::Font::FontManagerNativeLibrary.load
      end
      
      # Constant indicating base direction is left-to-right.
      const_set_lazy(:DIRECTION_LEFT_TO_RIGHT) { 0 }
      const_attr_reader  :DIRECTION_LEFT_TO_RIGHT
      
      # Constant indicating base direction is right-to-left.
      const_set_lazy(:DIRECTION_RIGHT_TO_LEFT) { 1 }
      const_attr_reader  :DIRECTION_RIGHT_TO_LEFT
      
      # Constant indicating that the base direction depends on the first strong
      # directional character in the text according to the Unicode
      # Bidirectional Algorithm.  If no strong directional character is present,
      # the base direction is left-to-right.
      const_set_lazy(:DIRECTION_DEFAULT_LEFT_TO_RIGHT) { -2 }
      const_attr_reader  :DIRECTION_DEFAULT_LEFT_TO_RIGHT
      
      # Constant indicating that the base direction depends on the first strong
      # directional character in the text according to the Unicode
      # Bidirectional Algorithm.  If no strong directional character is present,
      # the base direction is right-to-left.
      const_set_lazy(:DIRECTION_DEFAULT_RIGHT_TO_LEFT) { -1 }
      const_attr_reader  :DIRECTION_DEFAULT_RIGHT_TO_LEFT
      
      const_set_lazy(:DIR_MIXED) { 2 }
      const_attr_reader  :DIR_MIXED
    }
    
    typesig { [String, ::Java::Int] }
    # Create Bidi from the given paragraph of text and base direction.
    # @param paragraph a paragraph of text
    # @param flags a collection of flags that control the algorithm.  The
    # algorithm understands the flags DIRECTION_LEFT_TO_RIGHT, DIRECTION_RIGHT_TO_LEFT,
    # DIRECTION_DEFAULT_LEFT_TO_RIGHT, and DIRECTION_DEFAULT_RIGHT_TO_LEFT.
    # Other values are reserved.
    def initialize(paragraph, flags)
      @dir = 0
      @baselevel = 0
      @length = 0
      @runs = nil
      @cws = nil
      if ((paragraph).nil?)
        raise IllegalArgumentException.new("paragraph is null")
      end
      native_bidi_chars(self, paragraph.to_char_array, 0, nil, 0, paragraph.length, flags)
    end
    
    typesig { [AttributedCharacterIterator] }
    # Create Bidi from the given paragraph of text.
    # <p>
    # The RUN_DIRECTION attribute in the text, if present, determines the base
    # direction (left-to-right or right-to-left).  If not present, the base
    # direction is computes using the Unicode Bidirectional Algorithm, defaulting to left-to-right
    # if there are no strong directional characters in the text.  This attribute, if
    # present, must be applied to all the text in the paragraph.
    # <p>
    # The BIDI_EMBEDDING attribute in the text, if present, represents embedding level
    # information.  Negative values from -1 to -62 indicate overrides at the absolute value
    # of the level.  Positive values from 1 to 62 indicate embeddings.  Where values are
    # zero or not defined, the base embedding level as determined by the base direction
    # is assumed.
    # <p>
    # The NUMERIC_SHAPING attribute in the text, if present, converts European digits to
    # other decimal digits before running the bidi algorithm.  This attribute, if present,
    # must be applied to all the text in the paragraph.
    # 
    # @param paragraph a paragraph of text with optional character and paragraph attribute information
    # 
    # @see TextAttribute#BIDI_EMBEDDING
    # @see TextAttribute#NUMERIC_SHAPING
    # @see TextAttribute#RUN_DIRECTION
    def initialize(paragraph)
      @dir = 0
      @baselevel = 0
      @length = 0
      @runs = nil
      @cws = nil
      if ((paragraph).nil?)
        raise IllegalArgumentException.new("paragraph is null")
      end
      flags = DIRECTION_DEFAULT_LEFT_TO_RIGHT
      embeddings = nil
      start = paragraph.get_begin_index
      limit = paragraph.get_end_index
      length_ = limit - start
      n = 0
      text = CharArray.new(length_)
      c = paragraph.first
      while !(c).equal?(paragraph.attr_done)
        text[((n += 1) - 1)] = c
        c = paragraph.next_
      end
      paragraph.first
      begin
        run_direction = paragraph.get_attribute(TextAttribute::RUN_DIRECTION)
        if (!(run_direction).nil?)
          if ((TextAttribute::RUN_DIRECTION_LTR == run_direction))
            flags = DIRECTION_LEFT_TO_RIGHT # clears default setting
          else
            flags = DIRECTION_RIGHT_TO_LEFT
          end
        end
      rescue ClassCastException => e
      end
      begin
        shaper = paragraph.get_attribute(TextAttribute::NUMERIC_SHAPING)
        if (!(shaper).nil?)
          shaper.shape(text, 0, text.attr_length)
        end
      rescue ClassCastException => e
      end
      pos = start
      begin
        paragraph.set_index(pos)
        embedding_level = paragraph.get_attribute(TextAttribute::BIDI_EMBEDDING)
        newpos = paragraph.get_run_limit(TextAttribute::BIDI_EMBEDDING)
        if (!(embedding_level).nil?)
          begin
            int_level = (embedding_level).int_value
            if (int_level >= -61 && int_level < 61)
              level = (int_level < 0 ? (-int_level | 0x80) : int_level)
              if ((embeddings).nil?)
                embeddings = Array.typed(::Java::Byte).new(length_) { 0 }
              end
              i = pos - start
              while i < newpos - start
                embeddings[i] = level
                (i += 1)
              end
            end
          rescue ClassCastException => e
          end
        end
        pos = newpos
      end while (pos < limit)
      native_bidi_chars(self, text, 0, embeddings, 0, text.attr_length, flags)
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
    # Create Bidi from the given text, embedding, and direction information.
    # The embeddings array may be null.  If present, the values represent embedding level
    # information.  Negative values from -1 to -61 indicate overrides at the absolute value
    # of the level.  Positive values from 1 to 61 indicate embeddings.  Where values are
    # zero, the base embedding level as determined by the base direction is assumed.
    # @param text an array containing the paragraph of text to process.
    # @param textStart the index into the text array of the start of the paragraph.
    # @param embeddings an array containing embedding values for each character in the paragraph.
    # This can be null, in which case it is assumed that there is no external embedding information.
    # @param embStart the index into the embedding array of the start of the paragraph.
    # @param paragraphLength the length of the paragraph in the text and embeddings arrays.
    # @param flags a collection of flags that control the algorithm.  The
    # algorithm understands the flags DIRECTION_LEFT_TO_RIGHT, DIRECTION_RIGHT_TO_LEFT,
    # DIRECTION_DEFAULT_LEFT_TO_RIGHT, and DIRECTION_DEFAULT_RIGHT_TO_LEFT.
    # Other values are reserved.
    def initialize(text, text_start, embeddings, emb_start, paragraph_length, flags)
      @dir = 0
      @baselevel = 0
      @length = 0
      @runs = nil
      @cws = nil
      if ((text).nil?)
        raise IllegalArgumentException.new("text is null")
      end
      if (paragraph_length < 0)
        raise IllegalArgumentException.new("bad length: " + RJava.cast_to_string(paragraph_length))
      end
      if (text_start < 0 || paragraph_length > text.attr_length - text_start)
        raise IllegalArgumentException.new("bad range: " + RJava.cast_to_string(text_start) + " length: " + RJava.cast_to_string(paragraph_length) + " for text of length: " + RJava.cast_to_string(text.attr_length))
      end
      if (!(embeddings).nil? && (emb_start < 0 || paragraph_length > embeddings.attr_length - emb_start))
        raise IllegalArgumentException.new("bad range: " + RJava.cast_to_string(emb_start) + " length: " + RJava.cast_to_string(paragraph_length) + " for embeddings of length: " + RJava.cast_to_string(text.attr_length))
      end
      if (!(embeddings).nil?)
        # native uses high bit to indicate override, not negative value, sigh
        i = emb_start
        emb_limit = emb_start + paragraph_length
        while i < emb_limit
          if (embeddings[i] < 0)
            temp = Array.typed(::Java::Byte).new(paragraph_length) { 0 }
            System.arraycopy(embeddings, emb_start, temp, 0, paragraph_length)
            i -= emb_start
            while i < paragraph_length
              if (temp[i] < 0)
                temp[i] = (-temp[i] | 0x80)
              end
              (i += 1)
            end
            embeddings = temp
            emb_start = 0
            break
          end
          (i += 1)
        end
      end
      native_bidi_chars(self, text, text_start, embeddings, emb_start, paragraph_length, flags)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, Array.typed(::Java::Int), Array.typed(::Java::Int)] }
    # Private constructor used by line bidi.
    def initialize(dir, base_level, length_, data, cws)
      @dir = 0
      @baselevel = 0
      @length = 0
      @runs = nil
      @cws = nil
      reset(dir, base_level, length_, data, cws)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, Array.typed(::Java::Int), Array.typed(::Java::Int)] }
    # Private mutator used by native code.
    def reset(dir, baselevel, length_, data, cws)
      @dir = dir
      @baselevel = baselevel
      @length = length_
      @runs = data
      @cws = cws
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Create a Bidi object representing the bidi information on a line of text within
    # the paragraph represented by the current Bidi.  This call is not required if the
    # entire paragraph fits on one line.
    # @param lineStart the offset from the start of the paragraph to the start of the line.
    # @param lineLimit the offset from the start of the paragraph to the limit of the line.
    def create_line_bidi(line_start, line_limit)
      if ((line_start).equal?(0) && (line_limit).equal?(@length))
        return self
      end
      line_length = line_limit - line_start
      if (line_start < 0 || line_limit < line_start || line_limit > @length)
        raise IllegalArgumentException.new("range " + RJava.cast_to_string(line_start) + " to " + RJava.cast_to_string(line_limit) + " is invalid for paragraph of length " + RJava.cast_to_string(@length))
      end
      if ((@runs).nil?)
        return Bidi.new(@dir, @baselevel, line_length, nil, nil)
      else
        cwspos = -1
        ncws = nil
        if (!(@cws).nil?)
          cwss = 0
          cwsl = @cws.attr_length
          while (cwss < cwsl)
            if (@cws[cwss] >= line_start)
              cwsl = cwss
              while (cwsl < @cws.attr_length && @cws[cwsl] < line_limit)
                cwsl += 1
              end
              ll = line_limit - 1
              while (cwsl > cwss && (@cws[cwsl - 1]).equal?(ll))
                cwspos = ll # record start of counter-directional whitespace
                (cwsl -= 1)
                (ll -= 1)
              end
              if ((cwspos).equal?(line_start))
                # entire line is cws, so ignore
                return Bidi.new(@dir, @baselevel, line_length, nil, nil)
              end
              ncwslen = cwsl - cwss
              if (ncwslen > 0)
                ncws = Array.typed(::Java::Int).new(ncwslen) { 0 }
                i = 0
                while i < ncwslen
                  ncws[i] = @cws[cwss + i] - line_start
                  (i += 1)
                end
              end
              break
            end
            (cwss += 1)
          end
        end
        nruns = nil
        nlevel = @baselevel
        limit = (cwspos).equal?(-1) ? line_limit : cwspos
        rs = 0
        rl = @runs.attr_length
        ndir = @dir
        while rs < @runs.attr_length
          if (@runs[rs] > line_start)
            rl = rs
            while (rl < @runs.attr_length && @runs[rl] < limit)
              rl += 2
            end
            if ((rl > rs) || (!(@runs[rs + 1]).equal?(@baselevel)))
              rl += 2
              if (!(cwspos).equal?(-1) && rl > rs && !(@runs[rl - 1]).equal?(@baselevel))
                # add level for cws
                nruns = Array.typed(::Java::Int).new(rl - rs + 2) { 0 }
                nruns[rl - rs] = line_length
                nruns[rl - rs + 1] = @baselevel
              else
                limit = line_limit
                nruns = Array.typed(::Java::Int).new(rl - rs) { 0 }
              end
              n = 0
              i = rs
              while i < rl
                nruns[((n += 1) - 1)] = @runs[i] - line_start
                nruns[((n += 1) - 1)] = @runs[i + 1]
                i += 2
              end
              nruns[n - 2] = limit - line_start
            else
              ndir = ((@runs[rs + 1] & 0x1)).equal?(0) ? DIRECTION_LEFT_TO_RIGHT : DIRECTION_RIGHT_TO_LEFT
            end
            break
          end
          rs += 2
        end
        return Bidi.new(ndir, @baselevel, line_length, nruns, ncws)
      end
    end
    
    typesig { [] }
    # Return true if the line is not left-to-right or right-to-left.  This means it either has mixed runs of left-to-right
    # and right-to-left text, or the base direction differs from the direction of the only run of text.
    # @return true if the line is not left-to-right or right-to-left.
    def is_mixed
      return (@dir).equal?(DIR_MIXED)
    end
    
    typesig { [] }
    # Return true if the line is all left-to-right text and the base direction is left-to-right.
    # @return true if the line is all left-to-right text and the base direction is left-to-right
    def is_left_to_right
      return (@dir).equal?(DIRECTION_LEFT_TO_RIGHT)
    end
    
    typesig { [] }
    # Return true if the line is all right-to-left text, and the base direction is right-to-left.
    # @return true if the line is all right-to-left text, and the base direction is right-to-left
    def is_right_to_left
      return (@dir).equal?(DIRECTION_RIGHT_TO_LEFT)
    end
    
    typesig { [] }
    # Return the length of text in the line.
    # @return the length of text in the line
    def get_length
      return @length
    end
    
    typesig { [] }
    # Return true if the base direction is left-to-right.
    # @return true if the base direction is left-to-right
    def base_is_left_to_right
      return ((@baselevel & 0x1)).equal?(0)
    end
    
    typesig { [] }
    # Return the base level (0 if left-to-right, 1 if right-to-left).
    # @return the base level
    def get_base_level
      return @baselevel
    end
    
    typesig { [::Java::Int] }
    # Return the resolved level of the character at offset.  If offset is <0 or >=
    # the length of the line, return the base direction level.
    # @param offset the index of the character for which to return the level
    # @return the resolved level of the character at offset
    def get_level_at(offset)
      if ((@runs).nil? || offset < 0 || offset >= @length)
        return @baselevel
      else
        i = 0
        begin
          if (offset < @runs[i])
            return @runs[i + 1]
          end
          i += 2
        end while (true)
      end
    end
    
    typesig { [] }
    # Return the number of level runs.
    # @return the number of level runs
    def get_run_count
      return (@runs).nil? ? 1 : @runs.attr_length / 2
    end
    
    typesig { [::Java::Int] }
    # Return the level of the nth logical run in this line.
    # @param run the index of the run, between 0 and <code>getRunCount()</code>
    # @return the level of the run
    def get_run_level(run)
      return (@runs).nil? ? @baselevel : @runs[run * 2 + 1]
    end
    
    typesig { [::Java::Int] }
    # Return the index of the character at the start of the nth logical run in this line, as
    # an offset from the start of the line.
    # @param run the index of the run, between 0 and <code>getRunCount()</code>
    # @return the start of the run
    def get_run_start(run)
      return ((@runs).nil? || (run).equal?(0)) ? 0 : @runs[run * 2 - 2]
    end
    
    typesig { [::Java::Int] }
    # Return the index of the character past the end of the nth logical run in this line, as
    # an offset from the start of the line.  For example, this will return the length
    # of the line for the last run on the line.
    # @param run the index of the run, between 0 and <code>getRunCount()</code>
    # @return limit the limit of the run
    def get_run_limit(run)
      return (@runs).nil? ? @length : @runs[run * 2]
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Return true if the specified text requires bidi analysis.  If this returns false,
      # the text will display left-to-right.  Clients can then avoid constructing a Bidi object.
      # Text in the Arabic Presentation Forms area of Unicode is presumed to already be shaped
      # and ordered for display, and so will not cause this function to return true.
      # 
      # @param text the text containing the characters to test
      # @param start the start of the range of characters to test
      # @param limit the limit of the range of characters to test
      # @return true if the range of characters requires bidi analysis
      def requires_bidi(text, start, limit)
        cpi = CodePointIterator.create(text, start, limit)
        cp = cpi.next_
        while !(cp).equal?(CodePointIterator::DONE)
          if (cp > 0x590)
            dc = native_get_direction_code(cp)
            if (!((RMASK & (1 << dc))).equal?(0))
              return true
            end
          end
          cp = cpi.next_
        end
        return false
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(Object), ::Java::Int, ::Java::Int] }
      # Reorder the objects in the array into visual order based on their levels.
      # This is a utility function to use when you have a collection of objects
      # representing runs of text in logical order, each run containing text
      # at a single level.  The elements at <code>index</code> from
      # <code>objectStart</code> up to <code>objectStart + count</code>
      # in the objects array will be reordered into visual order assuming
      # each run of text has the level indicated by the corresponding element
      # in the levels array (at <code>index - objectStart + levelStart</code>).
      # 
      # @param levels an array representing the bidi level of each object
      # @param levelStart the start position in the levels array
      # @param objects the array of objects to be reordered into visual order
      # @param objectStart the start position in the objects array
      # @param count the number of objects to reorder
      def reorder_visually(levels, level_start, objects, object_start, count)
        if (count < 0)
          raise IllegalArgumentException.new("count " + RJava.cast_to_string(count) + " must be >= 0")
        end
        if (level_start < 0 || level_start + count > levels.attr_length)
          raise IllegalArgumentException.new("levelStart " + RJava.cast_to_string(level_start) + " and count " + RJava.cast_to_string(count) + " out of range [0, " + RJava.cast_to_string(levels.attr_length) + "]")
        end
        if (object_start < 0 || object_start + count > objects.attr_length)
          raise IllegalArgumentException.new("objectStart " + RJava.cast_to_string(object_start) + " and count " + RJava.cast_to_string(count) + " out of range [0, " + RJava.cast_to_string(objects.attr_length) + "]")
        end
        lowest_odd_level = (NUMLEVELS + 1)
        highest_level = 0
        # initialize mapping and levels
        level_limit = level_start + count
        i = level_start
        while i < level_limit
          level = levels[i]
          if (level > highest_level)
            highest_level = level
          end
          if (!((level & 0x1)).equal?(0) && level < lowest_odd_level)
            lowest_odd_level = level
          end
          i += 1
        end
        delta = object_start - level_start
        while (highest_level >= lowest_odd_level)
          i_ = level_start
          loop do
            while (i_ < level_limit && levels[i_] < highest_level)
              i_ += 1
            end
            begin_ = ((i_ += 1) - 1)
            if ((begin_).equal?(level_limit))
              break # no more runs at this level
            end
            while (i_ < level_limit && levels[i_] >= highest_level)
              i_ += 1
            end
            end_ = i_ - 1
            begin_ += delta
            end_ += delta
            while (begin_ < end_)
              temp = objects[begin_]
              objects[begin_] = objects[end_]
              objects[end_] = temp
              (begin_ += 1)
              (end_ -= 1)
            end
          end
          (highest_level -= 1)
        end
      end
      
      const_set_lazy(:NUMLEVELS) { 62 }
      const_attr_reader  :NUMLEVELS
      
      # U_RIGHT_TO_LEFT
      # U_ARABIC_NUMBER
      # U_RIGHT_TO_LEFT_ARABIC
      # U_RIGHT_TO_LEFT_EMBEDDING
      # U_RIGHT_TO_LEFT_OVERRIDE
      const_set_lazy(:RMASK) { (1 << 1) | (1 << 5) | (1 << 13) | (1 << 14) | (1 << 15) }
      const_attr_reader  :RMASK
      
      JNI.load_native_method :Java_java_text_Bidi_nativeGetDirectionCode, [:pointer, :long, :int32], :int32
      typesig { [::Java::Int] }
      # Access native bidi implementation.
      def native_get_direction_code(cp)
        JNI.call_native_method(:Java_java_text_Bidi_nativeGetDirectionCode, JNI.env, self.jni_id, cp.to_int)
      end
      
      JNI.load_native_method :Java_java_text_Bidi_nativeBidiChars, [:pointer, :long, :long, :long, :int32, :long, :int32, :int32, :int32], :void
      typesig { [Bidi, Array.typed(::Java::Char), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Access native bidi implementation.
      def native_bidi_chars(bidi, text, text_start, embeddings, embedding_start, length_, flags)
        JNI.call_native_method(:Java_java_text_Bidi_nativeBidiChars, JNI.env, self.jni_id, bidi.jni_id, text.jni_id, text_start.to_int, embeddings.jni_id, embedding_start.to_int, length_.to_int, flags.to_int)
      end
    }
    
    typesig { [] }
    # Display the bidi internal state, used in debugging.
    def to_s
      buf = StringBuffer.new(super)
      buf.append("[dir: " + RJava.cast_to_string(@dir))
      buf.append(" baselevel: " + RJava.cast_to_string(@baselevel))
      buf.append(" length: " + RJava.cast_to_string(@length))
      if ((@runs).nil?)
        buf.append(" runs: null")
      else
        buf.append(" runs: [")
        i = 0
        while i < @runs.attr_length
          if (!(i).equal?(0))
            buf.append(Character.new(?\s.ord))
          end
          buf.append(@runs[i]) # limit
          buf.append(Character.new(?/.ord))
          buf.append(@runs[i + 1]) # level
          i += 2
        end
        buf.append(Character.new(?].ord))
      end
      if ((@cws).nil?)
        buf.append(" cws: null")
      else
        buf.append(" cws: [")
        i = 0
        while i < @cws.attr_length
          if (!(i).equal?(0))
            buf.append(Character.new(?\s.ord))
          end
          buf.append(JavaInteger.to_hex_string(@cws[i]))
          (i += 1)
        end
        buf.append(Character.new(?].ord))
      end
      buf.append(Character.new(?].ord))
      return buf.to_s
    end
    
    private
    alias_method :initialize__bidi, :initialize
  end
  
end

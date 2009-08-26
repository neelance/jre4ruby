require "rjava"

# Copyright 1996-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996, 1997 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module PatternEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Lang, :Character
    }
  end
  
  # Utility class for normalizing and merging patterns for collation.
  # This is to be used with MergeCollation for adding patterns to an
  # existing rule table.
  # @see        MergeCollation
  # @author     Mark Davis, Helena Shih
  class PatternEntry 
    include_class_members PatternEntryImports
    
    typesig { [StringBuffer] }
    # Gets the current extension, quoted
    def append_quoted_extension(to_add_to)
      append_quoted(@extension, to_add_to)
    end
    
    typesig { [StringBuffer] }
    # Gets the current chars, quoted
    def append_quoted_chars(to_add_to)
      append_quoted(@chars, to_add_to)
    end
    
    typesig { [Object] }
    # WARNING this is used for searching in a Vector.
    # Because Vector.indexOf doesn't take a comparator,
    # this method is ill-defined and ignores strength.
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      other = obj
      result = (@chars == other.attr_chars)
      return result
    end
    
    typesig { [] }
    def hash_code
      return @chars.hash_code
    end
    
    typesig { [] }
    # For debugging.
    def to_s
      result = StringBuffer.new
      add_to_buffer(result, true, false, nil)
      return result.to_s
    end
    
    typesig { [] }
    # Gets the strength of the entry.
    def get_strength
      return @strength
    end
    
    typesig { [] }
    # Gets the expanding characters of the entry.
    def get_extension
      return @extension
    end
    
    typesig { [] }
    # Gets the core characters of the entry.
    def get_chars
      return @chars
    end
    
    typesig { [StringBuffer, ::Java::Boolean, ::Java::Boolean, PatternEntry] }
    # ===== privates =====
    def add_to_buffer(to_add_to, show_extension, show_white_space, last_entry)
      if (show_white_space && to_add_to.length > 0)
        if ((@strength).equal?(Collator::PRIMARY) || !(last_entry).nil?)
          to_add_to.append(Character.new(?\n.ord))
        else
          to_add_to.append(Character.new(?\s.ord))
        end
      end
      if (!(last_entry).nil?)
        to_add_to.append(Character.new(?&.ord))
        if (show_white_space)
          to_add_to.append(Character.new(?\s.ord))
        end
        last_entry.append_quoted_chars(to_add_to)
        append_quoted_extension(to_add_to)
        if (show_white_space)
          to_add_to.append(Character.new(?\s.ord))
        end
      end
      case (@strength)
      when Collator::IDENTICAL
        to_add_to.append(Character.new(?=.ord))
      when Collator::TERTIARY
        to_add_to.append(Character.new(?,.ord))
      when Collator::SECONDARY
        to_add_to.append(Character.new(?;.ord))
      when Collator::PRIMARY
        to_add_to.append(Character.new(?<.ord))
      when RESET
        to_add_to.append(Character.new(?&.ord))
      when UNSET
        to_add_to.append(Character.new(??.ord))
      end
      if (show_white_space)
        to_add_to.append(Character.new(?\s.ord))
      end
      append_quoted(@chars, to_add_to)
      if (show_extension && !(@extension.length).equal?(0))
        to_add_to.append(Character.new(?/.ord))
        append_quoted(@extension, to_add_to)
      end
    end
    
    class_module.module_eval {
      typesig { [String, StringBuffer] }
      def append_quoted(chars, to_add_to)
        in_quote = false
        ch = chars.char_at(0)
        if (Character.is_space_char(ch))
          in_quote = true
          to_add_to.append(Character.new(?\'.ord))
        else
          if (PatternEntry.is_special_char(ch))
            in_quote = true
            to_add_to.append(Character.new(?\'.ord))
          else
            case (ch)
            when 0x10, Character.new(?\f.ord), Character.new(?\r.ord), Character.new(?\t.ord), Character.new(?\n.ord), Character.new(?@.ord)
              in_quote = true
              to_add_to.append(Character.new(?\'.ord))
            when Character.new(?\'.ord)
              in_quote = true
              to_add_to.append(Character.new(?\'.ord))
            else
              if (in_quote)
                in_quote = false
                to_add_to.append(Character.new(?\'.ord))
              end
            end
          end
        end
        to_add_to.append(chars)
        if (in_quote)
          to_add_to.append(Character.new(?\'.ord))
        end
      end
    }
    
    typesig { [::Java::Int, StringBuffer, StringBuffer] }
    # ========================================================================
    # Parsing a pattern into a list of PatternEntries....
    # ========================================================================
    def initialize(strength, chars, extension)
      @strength = UNSET
      @chars = ""
      @extension = ""
      @strength = strength
      @chars = chars.to_s
      @extension = (extension.length > 0) ? extension.to_s : ""
    end
    
    class_module.module_eval {
      const_set_lazy(:Parser) { Class.new do
        include_class_members PatternEntry
        
        attr_accessor :pattern
        alias_method :attr_pattern, :pattern
        undef_method :pattern
        alias_method :attr_pattern=, :pattern=
        undef_method :pattern=
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        typesig { [String] }
        def initialize(pattern)
          @pattern = nil
          @i = 0
          @new_chars = self.class::StringBuffer.new
          @new_extension = self.class::StringBuffer.new
          @pattern = pattern
          @i = 0
        end
        
        typesig { [] }
        def next_
          new_strength = UNSET
          @new_chars.set_length(0)
          @new_extension.set_length(0)
          in_chars = true
          in_quote = false
          while (@i < @pattern.length)
            ch = @pattern.char_at(@i)
            if (in_quote)
              if ((ch).equal?(Character.new(?\'.ord)))
                in_quote = false
              else
                if ((@new_chars.length).equal?(0))
                  @new_chars.append(ch)
                else
                  if (in_chars)
                    @new_chars.append(ch)
                  else
                    @new_extension.append(ch)
                  end
                end
              end
            else
              case (ch)
              # skip whitespace TODO use Character
              when Character.new(?=.ord)
                if (!(new_strength).equal?(UNSET))
                  break
                end
                new_strength = Collator::IDENTICAL
              when Character.new(?,.ord)
                if (!(new_strength).equal?(UNSET))
                  break
                end
                new_strength = Collator::TERTIARY
              when Character.new(?;.ord)
                if (!(new_strength).equal?(UNSET))
                  break
                end
                new_strength = Collator::SECONDARY
              when Character.new(?<.ord)
                if (!(new_strength).equal?(UNSET))
                  break
                end
                new_strength = Collator::PRIMARY
              when Character.new(?&.ord)
                if (!(new_strength).equal?(UNSET))
                  break
                end
                new_strength = RESET
              when Character.new(?\t.ord), Character.new(?\n.ord), Character.new(?\f.ord), Character.new(?\r.ord), Character.new(?\s.ord)
              when Character.new(?/.ord)
                in_chars = false
              when Character.new(?\'.ord)
                in_quote = true
                ch = @pattern.char_at((@i += 1))
                if ((@new_chars.length).equal?(0))
                  @new_chars.append(ch)
                else
                  if (in_chars)
                    @new_chars.append(ch)
                  else
                    @new_extension.append(ch)
                  end
                end
              else
                if ((new_strength).equal?(UNSET))
                  raise self.class::ParseException.new("missing char (=,;<&) : " + RJava.cast_to_string(@pattern.substring(@i, (@i + 10 < @pattern.length) ? @i + 10 : @pattern.length)), @i)
                end
                if (PatternEntry.is_special_char(ch) && ((in_quote).equal?(false)))
                  raise self.class::ParseException.new("Unquoted punctuation character : " + RJava.cast_to_string(JavaInteger.to_s(ch, 16)), @i)
                end
                if (in_chars)
                  @new_chars.append(ch)
                else
                  @new_extension.append(ch)
                end
              end
            end
            @i += 1
          end
          if ((new_strength).equal?(UNSET))
            return nil
          end
          if ((@new_chars.length).equal?(0))
            raise self.class::ParseException.new("missing chars (=,;<&): " + RJava.cast_to_string(@pattern.substring(@i, (@i + 10 < @pattern.length) ? @i + 10 : @pattern.length)), @i)
          end
          return self.class::PatternEntry.new(new_strength, @new_chars, @new_extension)
        end
        
        # We re-use these objects in order to improve performance
        attr_accessor :new_chars
        alias_method :attr_new_chars, :new_chars
        undef_method :new_chars
        alias_method :attr_new_chars=, :new_chars=
        undef_method :new_chars=
        
        attr_accessor :new_extension
        alias_method :attr_new_extension, :new_extension
        undef_method :new_extension
        alias_method :attr_new_extension=, :new_extension=
        undef_method :new_extension=
        
        private
        alias_method :initialize__parser, :initialize
      end }
      
      typesig { [::Java::Char] }
      def is_special_char(ch)
        return (((ch).equal?(Character.new(0x0020))) || ((ch <= Character.new(0x002F)) && (ch >= Character.new(0x0022))) || ((ch <= Character.new(0x003F)) && (ch >= Character.new(0x003A))) || ((ch <= Character.new(0x0060)) && (ch >= Character.new(0x005B))) || ((ch <= Character.new(0x007E)) && (ch >= Character.new(0x007B))))
      end
      
      const_set_lazy(:RESET) { -2 }
      const_attr_reader  :RESET
      
      const_set_lazy(:UNSET) { -1 }
      const_attr_reader  :UNSET
    }
    
    attr_accessor :strength
    alias_method :attr_strength, :strength
    undef_method :strength
    alias_method :attr_strength=, :strength=
    undef_method :strength=
    
    attr_accessor :chars
    alias_method :attr_chars, :chars
    undef_method :chars
    alias_method :attr_chars=, :chars=
    undef_method :chars=
    
    attr_accessor :extension
    alias_method :attr_extension, :extension
    undef_method :extension
    alias_method :attr_extension=, :extension=
    undef_method :extension=
    
    private
    alias_method :initialize__pattern_entry, :initialize
  end
  
end

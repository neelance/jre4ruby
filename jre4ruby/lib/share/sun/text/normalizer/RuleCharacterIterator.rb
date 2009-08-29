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
# 
# 
# 
# 
# Author: Alan Liu
# Created: September 23 2003
# Since: ICU 2.8
module Sun::Text::Normalizer
  module RuleCharacterIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Text, :ParsePosition
    }
  end
  
  # An iterator that returns 32-bit code points.  This class is deliberately
  # <em>not</em> related to any of the JDK or ICU4J character iterator classes
  # in order to minimize complexity.
  # @author Alan Liu
  # @since ICU 2.8
  class RuleCharacterIterator 
    include_class_members RuleCharacterIteratorImports
    
    # TODO: Ideas for later.  (Do not implement if not needed, lest the
    # code coverage numbers go down due to unused methods.)
    # 1. Add a copy constructor, equals() method, clone() method.
    # 2. Rather than return DONE, throw an exception if the end
    # is reached -- this is an alternate usage model, probably not useful.
    # 3. Return isEscaped from next().  If this happens,
    # don't keep an isEscaped member variable.
    # 
    # Text being iterated.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # Position of iterator.
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    # Symbol table used to parse and dereference variables.  May be null.
    attr_accessor :sym
    alias_method :attr_sym, :sym
    undef_method :sym
    alias_method :attr_sym=, :sym=
    undef_method :sym=
    
    # Current variable expansion, or null if none.
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    # Position within buf[].  Meaningless if buf == null.
    attr_accessor :buf_pos
    alias_method :attr_buf_pos, :buf_pos
    undef_method :buf_pos
    alias_method :attr_buf_pos=, :buf_pos=
    undef_method :buf_pos=
    
    # Flag indicating whether the last character was parsed from an escape.
    attr_accessor :is_escaped
    alias_method :attr_is_escaped, :is_escaped
    undef_method :is_escaped
    alias_method :attr_is_escaped=, :is_escaped=
    undef_method :is_escaped=
    
    class_module.module_eval {
      # Value returned when there are no more characters to iterate.
      const_set_lazy(:DONE) { -1 }
      const_attr_reader  :DONE
      
      # Bitmask option to enable parsing of variable names.  If (options &
      # PARSE_VARIABLES) != 0, then an embedded variable will be expanded to
      # its value.  Variables are parsed using the SymbolTable API.
      const_set_lazy(:PARSE_VARIABLES) { 1 }
      const_attr_reader  :PARSE_VARIABLES
      
      # Bitmask option to enable parsing of escape sequences.  If (options &
      # PARSE_ESCAPES) != 0, then an embedded escape sequence will be expanded
      # to its value.  Escapes are parsed using Utility.unescapeAt().
      const_set_lazy(:PARSE_ESCAPES) { 2 }
      const_attr_reader  :PARSE_ESCAPES
      
      # Bitmask option to enable skipping of whitespace.  If (options &
      # SKIP_WHITESPACE) != 0, then whitespace characters will be silently
      # skipped, as if they were not present in the input.  Whitespace
      # characters are defined by UCharacterProperty.isRuleWhiteSpace().
      const_set_lazy(:SKIP_WHITESPACE) { 4 }
      const_attr_reader  :SKIP_WHITESPACE
    }
    
    typesig { [String, SymbolTable, ParsePosition] }
    # Constructs an iterator over the given text, starting at the given
    # position.
    # @param text the text to be iterated
    # @param sym the symbol table, or null if there is none.  If sym is null,
    # then variables will not be deferenced, even if the PARSE_VARIABLES
    # option is set.
    # @param pos upon input, the index of the next character to return.  If a
    # variable has been dereferenced, then pos will <em>not</em> increment as
    # characters of the variable value are iterated.
    def initialize(text, sym, pos)
      @text = nil
      @pos = nil
      @sym = nil
      @buf = nil
      @buf_pos = 0
      @is_escaped = false
      if ((text).nil? || pos.get_index > text.length)
        raise IllegalArgumentException.new
      end
      @text = text
      @sym = sym
      @pos = pos
      @buf = nil
    end
    
    typesig { [] }
    # Returns true if this iterator has no more characters to return.
    def at_end
      return (@buf).nil? && (@pos.get_index).equal?(@text.length)
    end
    
    typesig { [::Java::Int] }
    # Returns the next character using the given options, or DONE if there
    # are no more characters, and advance the position to the next
    # character.
    # @param options one or more of the following options, bitwise-OR-ed
    # together: PARSE_VARIABLES, PARSE_ESCAPES, SKIP_WHITESPACE.
    # @return the current 32-bit code point, or DONE
    def next_(options)
      c = DONE
      @is_escaped = false
      loop do
        c = __current
        __advance(UTF16.get_char_count(c))
        if ((c).equal?(SymbolTable::SYMBOL_REF) && (@buf).nil? && !((options & PARSE_VARIABLES)).equal?(0) && !(@sym).nil?)
          name = @sym.parse_reference(@text, @pos, @text.length)
          # If name == null there was an isolated SYMBOL_REF;
          # return it.  Caller must be prepared for this.
          if ((name).nil?)
            break
          end
          @buf_pos = 0
          @buf = @sym.lookup(name)
          if ((@buf).nil?)
            raise IllegalArgumentException.new("Undefined variable: " + name)
          end
          # Handle empty variable value
          if ((@buf.attr_length).equal?(0))
            @buf = nil
          end
          next
        end
        if (!((options & SKIP_WHITESPACE)).equal?(0) && UCharacterProperty.is_rule_white_space(c))
          next
        end
        if ((c).equal?(Character.new(?\\.ord)) && !((options & PARSE_ESCAPES)).equal?(0))
          offset = Array.typed(::Java::Int).new([0])
          c = Utility.unescape_at(lookahead, offset)
          jumpahead(offset[0])
          @is_escaped = true
          if (c < 0)
            raise IllegalArgumentException.new("Invalid escape")
          end
        end
        break
      end
      return c
    end
    
    typesig { [] }
    # Returns true if the last character returned by next() was
    # escaped.  This will only be the case if the option passed in to
    # next() included PARSE_ESCAPED and the next character was an
    # escape sequence.
    def is_escaped
      return @is_escaped
    end
    
    typesig { [] }
    # Returns true if this iterator is currently within a variable expansion.
    def in_variable
      return !(@buf).nil?
    end
    
    typesig { [Object] }
    # Returns an object which, when later passed to setPos(), will
    # restore this iterator's position.  Usage idiom:
    # 
    # RuleCharacterIterator iterator = ...;
    # Object pos = iterator.getPos(null); // allocate position object
    # for (;;) {
    # pos = iterator.getPos(pos); // reuse position object
    # int c = iterator.next(...);
    # ...
    # }
    # iterator.setPos(pos);
    # 
    # @param p a position object previously returned by getPos(),
    # or null.  If not null, it will be updated and returned.  If
    # null, a new position object will be allocated and returned.
    # @return a position object which may be passed to setPos(),
    # either `p,' or if `p' == null, a newly-allocated object
    def get_pos(p)
      if ((p).nil?)
        return Array.typed(Object).new([@buf, Array.typed(::Java::Int).new([@pos.get_index, @buf_pos])])
      end
      a = p
      a[0] = @buf
      v = a[1]
      v[0] = @pos.get_index
      v[1] = @buf_pos
      return p
    end
    
    typesig { [Object] }
    # Restores this iterator to the position it had when getPos()
    # returned the given object.
    # @param p a position object previously returned by getPos()
    def set_pos(p)
      a = p
      @buf = a[0]
      v = a[1]
      @pos.set_index(v[0])
      @buf_pos = v[1]
    end
    
    typesig { [::Java::Int] }
    # Skips ahead past any ignored characters, as indicated by the given
    # options.  This is useful in conjunction with the lookahead() method.
    # 
    # Currently, this only has an effect for SKIP_WHITESPACE.
    # @param options one or more of the following options, bitwise-OR-ed
    # together: PARSE_VARIABLES, PARSE_ESCAPES, SKIP_WHITESPACE.
    def skip_ignored(options)
      if (!((options & SKIP_WHITESPACE)).equal?(0))
        loop do
          a = __current
          if (!UCharacterProperty.is_rule_white_space(a))
            break
          end
          __advance(UTF16.get_char_count(a))
        end
      end
    end
    
    typesig { [] }
    # Returns a string containing the remainder of the characters to be
    # returned by this iterator, without any option processing.  If the
    # iterator is currently within a variable expansion, this will only
    # extend to the end of the variable expansion.  This method is provided
    # so that iterators may interoperate with string-based APIs.  The typical
    # sequence of calls is to call skipIgnored(), then call lookahead(), then
    # parse the string returned by lookahead(), then call jumpahead() to
    # resynchronize the iterator.
    # @return a string containing the characters to be returned by future
    # calls to next()
    def lookahead
      if (!(@buf).nil?)
        return String.new(@buf, @buf_pos, @buf.attr_length - @buf_pos)
      else
        return @text.substring(@pos.get_index)
      end
    end
    
    typesig { [::Java::Int] }
    # Advances the position by the given number of 16-bit code units.
    # This is useful in conjunction with the lookahead() method.
    # @param count the number of 16-bit code units to jump over
    def jumpahead(count)
      if (count < 0)
        raise IllegalArgumentException.new
      end
      if (!(@buf).nil?)
        @buf_pos += count
        if (@buf_pos > @buf.attr_length)
          raise IllegalArgumentException.new
        end
        if ((@buf_pos).equal?(@buf.attr_length))
          @buf = nil
        end
      else
        i = @pos.get_index + count
        @pos.set_index(i)
        if (i > @text.length)
          raise IllegalArgumentException.new
        end
      end
    end
    
    typesig { [] }
    # Returns the current 32-bit code point without parsing escapes, parsing
    # variables, or skipping whitespace.
    # @return the current 32-bit code point
    def __current
      if (!(@buf).nil?)
        return UTF16.char_at(@buf, 0, @buf.attr_length, @buf_pos)
      else
        i = @pos.get_index
        return (i < @text.length) ? UTF16.char_at(@text, i) : DONE
      end
    end
    
    typesig { [::Java::Int] }
    # Advances the position by the given amount.
    # @param count the number of 16-bit code units to advance past
    def __advance(count)
      if (!(@buf).nil?)
        @buf_pos += count
        if ((@buf_pos).equal?(@buf.attr_length))
          @buf = nil
        end
      else
        @pos.set_index(@pos.get_index + count)
        if (@pos.get_index > @text.length)
          @pos.set_index(@text.length)
        end
      end
    end
    
    private
    alias_method :initialize__rule_character_iterator, :initialize
  end
  
end

require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module SurrogateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnmappableCharacterException
    }
  end
  
  # Utility class for dealing with surrogates.
  # 
  # @author Mark Reinhold
  class Surrogate 
    include_class_members SurrogateImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # UTF-16 surrogate-character ranges
      const_set_lazy(:MIN_HIGH) { Character.new(0xD800) }
      const_attr_reader  :MIN_HIGH
      
      const_set_lazy(:MAX_HIGH) { Character.new(0xDBFF) }
      const_attr_reader  :MAX_HIGH
      
      const_set_lazy(:MIN_LOW) { Character.new(0xDC00) }
      const_attr_reader  :MIN_LOW
      
      const_set_lazy(:MAX_LOW) { Character.new(0xDFFF) }
      const_attr_reader  :MAX_LOW
      
      const_set_lazy(:MIN) { MIN_HIGH }
      const_attr_reader  :MIN
      
      const_set_lazy(:MAX) { MAX_LOW }
      const_attr_reader  :MAX
      
      # Range of UCS-4 values that need surrogates in UTF-16
      const_set_lazy(:UCS4_MIN) { 0x10000 }
      const_attr_reader  :UCS4_MIN
      
      const_set_lazy(:UCS4_MAX) { (1 << 20) + UCS4_MIN - 1 }
      const_attr_reader  :UCS4_MAX
      
      typesig { [::Java::Int] }
      # Tells whether or not the given UTF-16 value is a high surrogate.
      def is_high(c)
        return (MIN_HIGH <= c) && (c <= MAX_HIGH)
      end
      
      typesig { [::Java::Int] }
      # Tells whether or not the given UTF-16 value is a low surrogate.
      def is_low(c)
        return (MIN_LOW <= c) && (c <= MAX_LOW)
      end
      
      typesig { [::Java::Int] }
      # Tells whether or not the given UTF-16 value is a surrogate character,
      def is(c)
        return (MIN <= c) && (c <= MAX)
      end
      
      typesig { [::Java::Int] }
      # Tells whether or not the given UCS-4 character must be represented as a
      # surrogate pair in UTF-16.
      def needed_for(uc)
        return (uc >= UCS4_MIN) && (uc <= UCS4_MAX)
      end
      
      typesig { [::Java::Int] }
      # Returns the high UTF-16 surrogate for the given UCS-4 character.
      def high(uc)
        raise AssertError if not (needed_for(uc))
        return RJava.cast_to_char((0xd800 | (((uc - UCS4_MIN) >> 10) & 0x3ff)))
      end
      
      typesig { [::Java::Int] }
      # Returns the low UTF-16 surrogate for the given UCS-4 character.
      def low(uc)
        raise AssertError if not (needed_for(uc))
        return RJava.cast_to_char((0xdc00 | ((uc - UCS4_MIN) & 0x3ff)))
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Converts the given surrogate pair into a 32-bit UCS-4 character.
      def to_ucs4(c, d)
        raise AssertError if not (is_high(c) && is_low(d))
        return (((c & 0x3ff) << 10) | (d & 0x3ff)) + 0x10000
      end
      
      # Surrogate parsing support.  Charset implementations may use instances of
      # this class to handle the details of parsing UTF-16 surrogate pairs.
      const_set_lazy(:Parser) { Class.new do
        include_class_members Surrogate
        
        typesig { [] }
        def initialize
          @character = 0
          @error = CoderResult::UNDERFLOW
          @is_pair = false
        end
        
        attr_accessor :character
        alias_method :attr_character, :character
        undef_method :character
        alias_method :attr_character=, :character=
        undef_method :character=
        
        # UCS-4
        attr_accessor :error
        alias_method :attr_error, :error
        undef_method :error
        alias_method :attr_error=, :error=
        undef_method :error=
        
        attr_accessor :is_pair
        alias_method :attr_is_pair, :is_pair
        undef_method :is_pair
        alias_method :attr_is_pair=, :is_pair=
        undef_method :is_pair=
        
        typesig { [] }
        # Returns the UCS-4 character previously parsed.
        def character
          raise AssertError if not (((@error).nil?))
          return @character
        end
        
        typesig { [] }
        # Tells whether or not the previously-parsed UCS-4 character was
        # originally represented by a surrogate pair.
        def is_pair
          raise AssertError if not (((@error).nil?))
          return @is_pair
        end
        
        typesig { [] }
        # Returns the number of UTF-16 characters consumed by the previous
        # parse.
        def increment
          raise AssertError if not (((@error).nil?))
          return @is_pair ? 2 : 1
        end
        
        typesig { [] }
        # If the previous parse operation detected an error, return the object
        # describing that error.
        def error
          raise AssertError if not ((!(@error).nil?))
          return @error
        end
        
        typesig { [] }
        # Returns an unmappable-input result object, with the appropriate
        # input length, for the previously-parsed character.
        def unmappable_result
          raise AssertError if not (((@error).nil?))
          return CoderResult.unmappable_for_length(@is_pair ? 2 : 1)
        end
        
        typesig { [::Java::Char, class_self::CharBuffer] }
        # Parses a UCS-4 character from the given source buffer, handling
        # surrogates.
        # 
        # @param  c    The first character
        # @param  in   The source buffer, from which one more character
        # will be consumed if c is a high surrogate
        # 
        # @returns  Either a parsed UCS-4 character, in which case the isPair()
        # and increment() methods will return meaningful values, or
        # -1, in which case error() will return a descriptive result
        # object
        def parse(c, in_)
          if (Surrogate.is_high(c))
            if (!in_.has_remaining)
              @error = CoderResult::UNDERFLOW
              return -1
            end
            d = in_.get
            if (Surrogate.is_low(d))
              @character = to_ucs4(c, d)
              @is_pair = true
              @error = nil
              return @character
            end
            @error = CoderResult.malformed_for_length(1)
            return -1
          end
          if (Surrogate.is_low(c))
            @error = CoderResult.malformed_for_length(1)
            return -1
          end
          @character = c
          @is_pair = false
          @error = nil
          return @character
        end
        
        typesig { [::Java::Char, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        # Parses a UCS-4 character from the given source buffer, handling
        # surrogates.
        # 
        # @param  c    The first character
        # @param  ia   The input array, from which one more character
        # will be consumed if c is a high surrogate
        # @param  ip   The input index
        # @param  il   The input limit
        # 
        # @returns  Either a parsed UCS-4 character, in which case the isPair()
        # and increment() methods will return meaningful values, or
        # -1, in which case error() will return a descriptive result
        # object
        def parse(c, ia, ip, il)
          raise AssertError if not (((ia[ip]).equal?(c)))
          if (Surrogate.is_high(c))
            if (il - ip < 2)
              @error = CoderResult::UNDERFLOW
              return -1
            end
            d = ia[ip + 1]
            if (Surrogate.is_low(d))
              @character = to_ucs4(c, d)
              @is_pair = true
              @error = nil
              return @character
            end
            @error = CoderResult.malformed_for_length(1)
            return -1
          end
          if (Surrogate.is_low(c))
            @error = CoderResult.malformed_for_length(1)
            return -1
          end
          @character = c
          @is_pair = false
          @error = nil
          return @character
        end
        
        private
        alias_method :initialize__parser, :initialize
      end }
      
      # Surrogate generation support.  Charset implementations may use instances
      # of this class to handle the details of generating UTF-16 surrogate
      # pairs.
      const_set_lazy(:Generator) { Class.new do
        include_class_members Surrogate
        
        typesig { [] }
        def initialize
          @error = CoderResult::OVERFLOW
        end
        
        attr_accessor :error
        alias_method :attr_error, :error
        undef_method :error
        alias_method :attr_error=, :error=
        undef_method :error=
        
        typesig { [] }
        # If the previous generation operation detected an error, return the
        # object describing that error.
        def error
          raise AssertError if not (!(@error).nil?)
          return @error
        end
        
        typesig { [::Java::Int, ::Java::Int, class_self::CharBuffer] }
        # Generates one or two UTF-16 characters to represent the given UCS-4
        # character.
        # 
        # @param  uc   The UCS-4 character
        # @param  len  The number of input bytes from which the UCS-4 value
        # was constructed (used when creating result objects)
        # @param  dst  The destination buffer, to which one or two UTF-16
        # characters will be written
        # 
        # @returns  Either a positive count of the number of UTF-16 characters
        # written to the destination buffer, or -1, in which case
        # error() will return a descriptive result object
        def generate(uc, len, dst)
          if (uc <= 0xffff)
            if (Surrogate.is(uc))
              @error = CoderResult.malformed_for_length(len)
              return -1
            end
            if (dst.remaining < 1)
              @error = CoderResult::OVERFLOW
              return -1
            end
            dst.put(RJava.cast_to_char(uc))
            @error = nil
            return 1
          end
          if (uc < Surrogate::UCS4_MIN)
            @error = CoderResult.malformed_for_length(len)
            return -1
          end
          if (uc <= Surrogate::UCS4_MAX)
            if (dst.remaining < 2)
              @error = CoderResult::OVERFLOW
              return -1
            end
            dst.put(Surrogate.high(uc))
            dst.put(Surrogate.low(uc))
            @error = nil
            return 2
          end
          @error = CoderResult.unmappable_for_length(len)
          return -1
        end
        
        typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        # Generates one or two UTF-16 characters to represent the given UCS-4
        # character.
        # 
        # @param  uc   The UCS-4 character
        # @param  len  The number of input bytes from which the UCS-4 value
        # was constructed (used when creating result objects)
        # @param  da   The destination array, to which one or two UTF-16
        # characters will be written
        # @param  dp   The destination position
        # @param  dl   The destination limit
        # 
        # @returns  Either a positive count of the number of UTF-16 characters
        # written to the destination buffer, or -1, in which case
        # error() will return a descriptive result object
        def generate(uc, len, da, dp, dl)
          if (uc <= 0xffff)
            if (Surrogate.is(uc))
              @error = CoderResult.malformed_for_length(len)
              return -1
            end
            if (dl - dp < 1)
              @error = CoderResult::OVERFLOW
              return -1
            end
            da[dp] = RJava.cast_to_char(uc)
            @error = nil
            return 1
          end
          if (uc < Surrogate::UCS4_MIN)
            @error = CoderResult.malformed_for_length(len)
            return -1
          end
          if (uc <= Surrogate::UCS4_MAX)
            if (dl - dp < 2)
              @error = CoderResult::OVERFLOW
              return -1
            end
            da[dp] = Surrogate.high(uc)
            da[dp + 1] = Surrogate.low(uc)
            @error = nil
            return 2
          end
          @error = CoderResult.unmappable_for_length(len)
          return -1
        end
        
        private
        alias_method :initialize__generator, :initialize
      end }
    }
    
    private
    alias_method :initialize__surrogate, :initialize
  end
  
end

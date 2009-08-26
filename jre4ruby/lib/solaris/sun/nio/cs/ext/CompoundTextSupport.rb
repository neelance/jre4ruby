require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs::Ext
  module CompoundTextSupportImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include ::Java::Nio::Charset
    }
  end
  
  class CompoundTextSupport 
    include_class_members CompoundTextSupportImports
    
    class_module.module_eval {
      const_set_lazy(:ControlSequence) { Class.new do
        include_class_members CompoundTextSupport
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        attr_accessor :esc_sequence
        alias_method :attr_esc_sequence, :esc_sequence
        undef_method :esc_sequence
        alias_method :attr_esc_sequence=, :esc_sequence=
        undef_method :esc_sequence=
        
        attr_accessor :encoding
        alias_method :attr_encoding, :encoding
        undef_method :encoding
        alias_method :attr_encoding=, :encoding=
        undef_method :encoding=
        
        typesig { [Array.typed(::Java::Byte)] }
        def initialize(esc_sequence)
          initialize__control_sequence(esc_sequence, nil)
        end
        
        typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
        def initialize(esc_sequence, encoding)
          @hash = 0
          @esc_sequence = nil
          @encoding = nil
          if ((esc_sequence).nil?)
            raise self.class::NullPointerException.new
          end
          @esc_sequence = esc_sequence
          @encoding = encoding
          hash = 0
          length = esc_sequence.attr_length
          i = 0
          while i < esc_sequence.attr_length
            hash += ((RJava.cast_to_int(esc_sequence[i])) & 0xff) << (i % 4)
            i += 1
          end
          if (!(encoding).nil?)
            i_ = 0
            while i_ < encoding.attr_length
              hash += ((RJava.cast_to_int(encoding[i_])) & 0xff) << (i_ % 4)
              i_ += 1
            end
            # M L
            length += 2 + encoding.attr_length + 1
            # 0x02
          end
          @hash = hash
          if (self.attr_max_control_sequence_len < length)
            self.attr_max_control_sequence_len = length
          end
        end
        
        typesig { [self::Object] }
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if (!(obj.is_a?(self.class::ControlSequence)))
            return false
          end
          rhs = obj
          if (!(@esc_sequence).equal?(rhs.attr_esc_sequence))
            if (!(@esc_sequence.attr_length).equal?(rhs.attr_esc_sequence.attr_length))
              return false
            end
            i = 0
            while i < @esc_sequence.attr_length
              if (!(@esc_sequence[i]).equal?(rhs.attr_esc_sequence[i]))
                return false
              end
              i += 1
            end
          end
          if (!(@encoding).equal?(rhs.attr_encoding))
            if ((@encoding).nil? || (rhs.attr_encoding).nil? || !(@encoding.attr_length).equal?(rhs.attr_encoding.attr_length))
              return false
            end
            i = 0
            while i < @encoding.attr_length
              if (!(@encoding[i]).equal?(rhs.attr_encoding[i]))
                return false
              end
              i += 1
            end
          end
          return true
        end
        
        typesig { [] }
        def hash_code
          return @hash
        end
        
        typesig { [self::ControlSequence] }
        def concatenate(rhs)
          if (!(@encoding).nil?)
            raise self.class::IllegalArgumentException.new("cannot concatenate to a non-standard charset escape " + "sequence")
          end
          len = @esc_sequence.attr_length + rhs.attr_esc_sequence.attr_length
          new_esc_sequence = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(@esc_sequence, 0, new_esc_sequence, 0, @esc_sequence.attr_length)
          System.arraycopy(rhs.attr_esc_sequence, 0, new_esc_sequence, @esc_sequence.attr_length, rhs.attr_esc_sequence.attr_length)
          return self.class::ControlSequence.new(new_esc_sequence, rhs.attr_encoding)
        end
        
        private
        alias_method :initialize__control_sequence, :initialize
      end }
      
      
      def max_control_sequence_len
        defined?(@@max_control_sequence_len) ? @@max_control_sequence_len : @@max_control_sequence_len= 0
      end
      alias_method :attr_max_control_sequence_len, :max_control_sequence_len
      
      def max_control_sequence_len=(value)
        @@max_control_sequence_len = value
      end
      alias_method :attr_max_control_sequence_len=, :max_control_sequence_len=
      
      when_class_loaded do
        t_sequence_to_encoding_map = HashMap.new(33, 1.0)
        t_high_bits_map = HashMap.new(31, 1.0)
        t_encoding_to_sequence_map = HashMap.new(21, 1.0)
        t_encodings = ArrayList.new(21)
        if (!(is_encoding_supported("US-ASCII") && is_encoding_supported("ISO-8859-1")))
          raise ExceptionInInitializerError.new("US-ASCII and ISO-8859-1 unsupported")
        end
        # high bit off, leave off
        left_ascii = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x28, 0x42]))
        t_sequence_to_encoding_map.put(left_ascii, "US-ASCII")
        t_high_bits_map.put(left_ascii, Boolean::FALSE)
        # high bit on, turn off
        right_ascii = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x29, 0x42]))
        t_sequence_to_encoding_map.put(right_ascii, "US-ASCII")
        t_high_bits_map.put(right_ascii, Boolean::FALSE)
        # high bit on, leave on
        right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x41]))
        t_sequence_to_encoding_map.put(right_half, "ISO-8859-1")
        t_high_bits_map.put(right_half, Boolean::TRUE)
        full_set = left_ascii.concatenate(right_half)
        t_encoding_to_sequence_map.put("ISO-8859-1", full_set)
        t_encodings.add("ISO-8859-1")
        if (is_encoding_supported("ISO-8859-2"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x42]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-2")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-2", full_set)
          t_encodings.add("ISO-8859-2")
        end
        if (is_encoding_supported("ISO-8859-3"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x43]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-3")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-3", full_set)
          t_encodings.add("ISO-8859-3")
        end
        if (is_encoding_supported("ISO-8859-4"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x44]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-4")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-4", full_set)
          t_encodings.add("ISO-8859-4")
        end
        if (is_encoding_supported("ISO-8859-5"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x4c]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-5")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-5", full_set)
          t_encodings.add("ISO-8859-5")
        end
        if (is_encoding_supported("ISO-8859-6"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x47]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-6")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-6", full_set)
          t_encodings.add("ISO-8859-6")
        end
        if (is_encoding_supported("ISO-8859-7"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x46]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-7")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-7", full_set)
          t_encodings.add("ISO-8859-7")
        end
        if (is_encoding_supported("ISO-8859-8"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x48]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-8")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-8", full_set)
          t_encodings.add("ISO-8859-8")
        end
        if (is_encoding_supported("ISO-8859-9"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x4d]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-9")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-9", full_set)
          t_encodings.add("ISO-8859-9")
        end
        if (is_encoding_supported("JIS_X0201"))
          # high bit off, leave off
          gl_left = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x28, 0x4a]))
          # high bit off, turn on
          gl_right = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x28, 0x49]))
          # high bit on, turn off
          gr_left = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x29, 0x4a]))
          # high bit on, leave on
          gr_right = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x29, 0x49]))
          t_sequence_to_encoding_map.put(gl_left, "JIS_X0201")
          t_sequence_to_encoding_map.put(gl_right, "JIS_X0201")
          t_sequence_to_encoding_map.put(gr_left, "JIS_X0201")
          t_sequence_to_encoding_map.put(gr_right, "JIS_X0201")
          t_high_bits_map.put(gl_left, Boolean::FALSE)
          t_high_bits_map.put(gl_right, Boolean::TRUE)
          t_high_bits_map.put(gr_left, Boolean::FALSE)
          t_high_bits_map.put(gr_right, Boolean::TRUE)
          full_set = gl_left.concatenate(gr_right)
          t_encoding_to_sequence_map.put("JIS_X0201", full_set)
          t_encodings.add("JIS_X0201")
        end
        if (is_encoding_supported("X11GB2312"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x41]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x41]))
          t_sequence_to_encoding_map.put(left_half, "X11GB2312")
          t_sequence_to_encoding_map.put(right_half, "X11GB2312")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("X11GB2312", left_half)
          t_encodings.add("X11GB2312")
        end
        if (is_encoding_supported("x-JIS0208"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x42]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x42]))
          t_sequence_to_encoding_map.put(left_half, "x-JIS0208")
          t_sequence_to_encoding_map.put(right_half, "x-JIS0208")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("x-JIS0208", left_half)
          t_encodings.add("x-JIS0208")
        end
        if (is_encoding_supported("X11KSC5601"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x43]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x43]))
          t_sequence_to_encoding_map.put(left_half, "X11KSC5601")
          t_sequence_to_encoding_map.put(right_half, "X11KSC5601")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("X11KSC5601", left_half)
          t_encodings.add("X11KSC5601")
        end
        # Encodings not listed in Compound Text Encoding spec
        # Esc seq: -b
        if (is_encoding_supported("ISO-8859-15"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x62]))
          t_sequence_to_encoding_map.put(right_half, "ISO-8859-15")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("ISO-8859-15", full_set)
          t_encodings.add("ISO-8859-15")
        end
        # Esc seq: -T
        if (is_encoding_supported("TIS-620"))
          # high bit on, leave on
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x2d, 0x54]))
          t_sequence_to_encoding_map.put(right_half, "TIS-620")
          t_high_bits_map.put(right_half, Boolean::TRUE)
          full_set = left_ascii.concatenate(right_half)
          t_encoding_to_sequence_map.put("TIS-620", full_set)
          t_encodings.add("TIS-620")
        end
        if (is_encoding_supported("JIS_X0212-1990"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x44]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x44]))
          t_sequence_to_encoding_map.put(left_half, "JIS_X0212-1990")
          t_sequence_to_encoding_map.put(right_half, "JIS_X0212-1990")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("JIS_X0212-1990", left_half)
          t_encodings.add("JIS_X0212-1990")
        end
        if (is_encoding_supported("X11CNS11643P1"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x47]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x47]))
          t_sequence_to_encoding_map.put(left_half, "X11CNS11643P1")
          t_sequence_to_encoding_map.put(right_half, "X11CNS11643P1")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("X11CNS11643P1", left_half)
          t_encodings.add("X11CNS11643P1")
        end
        if (is_encoding_supported("X11CNS11643P2"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x48]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x48]))
          t_sequence_to_encoding_map.put(left_half, "X11CNS11643P2")
          t_sequence_to_encoding_map.put(right_half, "X11CNS11643P2")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("X11CNS11643P2", left_half)
          t_encodings.add("X11CNS11643P2")
        end
        if (is_encoding_supported("X11CNS11643P3"))
          # high bit off, leave off
          left_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x28, 0x49]))
          # high bit on, turn off
          right_half = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x24, 0x29, 0x49]))
          t_sequence_to_encoding_map.put(left_half, "X11CNS11643P3")
          t_sequence_to_encoding_map.put(right_half, "X11CNS11643P3")
          t_high_bits_map.put(left_half, Boolean::FALSE)
          t_high_bits_map.put(right_half, Boolean::FALSE)
          t_encoding_to_sequence_map.put("X11CNS11643P3", left_half)
          t_encodings.add("X11CNS11643P3")
        end
        # Esc seq: %/2??SUN-KSC5601.1992-3
        if (is_encoding_supported("x-Johab"))
          # 0x32 looks wrong. It's copied from the Sun X11 Compound Text
          # support code. It implies that all Johab characters comprise two
          # octets, which isn't true. Johab supports the ASCII/KS-Roman
          # characters from 0x21-0x7E with single-byte representations.
          johab = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x25, 0x2f, 0x32]), Array.typed(::Java::Byte).new([0x53, 0x55, 0x4e, 0x2d, 0x4b, 0x53, 0x43, 0x35, 0x36, 0x30, 0x31, 0x2e, 0x31, 0x39, 0x39, 0x32, 0x2d, 0x33]))
          t_sequence_to_encoding_map.put(johab, "x-Johab")
          t_encoding_to_sequence_map.put("x-Johab", johab)
          t_encodings.add("x-Johab")
        end
        # Esc seq: %/2??SUN-BIG5-1
        if (is_encoding_supported("Big5"))
          # 0x32 looks wrong. It's copied from the Sun X11 Compound Text
          # support code. It implies that all Big5 characters comprise two
          # octets, which isn't true. Big5 supports the ASCII/CNS-Roman
          # characters from 0x21-0x7E with single-byte representations.
          big5 = ControlSequence.new(Array.typed(::Java::Byte).new([0x1b, 0x25, 0x2f, 0x32]), Array.typed(::Java::Byte).new([0x53, 0x55, 0x4e, 0x2d, 0x42, 0x49, 0x47, 0x35, 0x2d, 0x31]))
          t_sequence_to_encoding_map.put(big5, "Big5")
          t_encoding_to_sequence_map.put("Big5", big5)
          t_encodings.add("Big5")
        end
        const_set :SequenceToEncodingMap, Collections.unmodifiable_map(t_sequence_to_encoding_map)
        const_set :HighBitsMap, Collections.unmodifiable_map(t_high_bits_map)
        const_set :EncodingToSequenceMap, Collections.unmodifiable_map(t_encoding_to_sequence_map)
        const_set :Encodings, Collections.unmodifiable_list(t_encodings)
      end
      
      typesig { [String] }
      def is_encoding_supported(encoding)
        begin
          if (Charset.is_supported(encoding))
            return true
          end
        rescue IllegalArgumentException => x
        end
        return (!(get_decoder(encoding)).nil? && !(get_encoder(encoding)).nil?)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # For Decoder
      def get_standard_decoder(esc_sequence)
        return get_non_standard_decoder(esc_sequence, nil)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def get_high_bit(esc_sequence)
        bool = HighBitsMap.get(ControlSequence.new(esc_sequence))
        return ((bool).equal?(Boolean::TRUE))
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      def get_non_standard_decoder(esc_sequence, encoding)
        return get_decoder(SequenceToEncodingMap.get(ControlSequence.new(esc_sequence, encoding)))
      end
      
      typesig { [String] }
      def get_decoder(enc)
        if ((enc).nil?)
          return nil
        end
        cs = nil
        begin
          cs = Charset.for_name(enc)
        rescue IllegalArgumentException => e
          cls = nil
          begin
            cls = Class.for_name("sun.awt.motif." + enc)
          rescue ClassNotFoundException => ee
            return nil
          end
          begin
            cs = cls.new_instance
          rescue InstantiationException => ee
            return nil
          rescue IllegalAccessException => ee
            return nil
          end
        end
        begin
          return cs.new_decoder
        rescue UnsupportedOperationException => e
        end
        return nil
      end
      
      typesig { [String] }
      # For Encoder
      def get_escape_sequence(encoding)
        seq = EncodingToSequenceMap.get(encoding)
        if (!(seq).nil?)
          return seq.attr_esc_sequence
        end
        return nil
      end
      
      typesig { [String] }
      def get_encoding(encoding)
        seq = EncodingToSequenceMap.get(encoding)
        if (!(seq).nil?)
          return seq.attr_encoding
        end
        return nil
      end
      
      typesig { [] }
      def get_encodings
        return Encodings
      end
      
      typesig { [String] }
      def get_encoder(enc)
        if ((enc).nil?)
          return nil
        end
        cs = nil
        begin
          cs = Charset.for_name(enc)
        rescue IllegalArgumentException => e
          cls = nil
          begin
            cls = Class.for_name("sun.awt.motif." + enc)
          rescue ClassNotFoundException => ee
            return nil
          end
          begin
            cs = cls.new_instance
          rescue InstantiationException => ee
            return nil
          rescue IllegalAccessException => ee
            return nil
          end
        end
        begin
          return cs.new_encoder
        rescue JavaThrowable => e
        end
        return nil
      end
    }
    
    typesig { [] }
    # Not an instantiable class
    def initialize
    end
    
    private
    alias_method :initialize__compound_text_support, :initialize
  end
  
end

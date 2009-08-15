require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module Base64Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
    }
  end
  
  # Static methods for translating Base64 encoded strings to byte arrays
  # and vice-versa.
  # 
  # @author  Josh Bloch
  # @see     Preferences
  # @since   1.4
  class Base64 
    include_class_members Base64Imports
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # Translates the specified byte array into a Base64 string as per
      # Preferences.put(byte[]).
      def byte_array_to_base64(a)
        return byte_array_to_base64(a, false)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Translates the specified byte array into an "alternate representation"
      # Base64 string.  This non-standard variant uses an alphabet that does
      # not contain the uppercase alphabetic characters, which makes it
      # suitable for use in situations where case-folding occurs.
      def byte_array_to_alt_base64(a)
        return byte_array_to_base64(a, true)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Boolean] }
      def byte_array_to_base64(a, alternate)
        a_len = a.attr_length
        num_full_groups = a_len / 3
        num_bytes_in_partial_group = a_len - 3 * num_full_groups
        result_len = 4 * ((a_len + 2) / 3)
        result = StringBuffer.new(result_len)
        int_to_alpha = (alternate ? IntToAltBase64 : IntToBase64)
        # Translate all full groups from byte array elements to Base64
        in_cursor = 0
        i = 0
        while i < num_full_groups
          byte0 = a[((in_cursor += 1) - 1)] & 0xff
          byte1 = a[((in_cursor += 1) - 1)] & 0xff
          byte2 = a[((in_cursor += 1) - 1)] & 0xff
          result.append(int_to_alpha[byte0 >> 2])
          result.append(int_to_alpha[(byte0 << 4) & 0x3f | (byte1 >> 4)])
          result.append(int_to_alpha[(byte1 << 2) & 0x3f | (byte2 >> 6)])
          result.append(int_to_alpha[byte2 & 0x3f])
          i += 1
        end
        # Translate partial group if present
        if (!(num_bytes_in_partial_group).equal?(0))
          byte0 = a[((in_cursor += 1) - 1)] & 0xff
          result.append(int_to_alpha[byte0 >> 2])
          if ((num_bytes_in_partial_group).equal?(1))
            result.append(int_to_alpha[(byte0 << 4) & 0x3f])
            result.append("==")
          else
            # assert numBytesInPartialGroup == 2;
            byte1 = a[((in_cursor += 1) - 1)] & 0xff
            result.append(int_to_alpha[(byte0 << 4) & 0x3f | (byte1 >> 4)])
            result.append(int_to_alpha[(byte1 << 2) & 0x3f])
            result.append(Character.new(?=.ord))
          end
        end
        # assert inCursor == a.length;
        # assert result.length() == resultLen;
        return result.to_s
      end
      
      # This array is a lookup table that translates 6-bit positive integer
      # index values into their "Base64 Alphabet" equivalents as specified
      # in Table 1 of RFC 2045.
      const_set_lazy(:IntToBase64) { Array.typed(::Java::Char).new([Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord), Character.new(?G.ord), Character.new(?H.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?K.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?N.ord), Character.new(?O.ord), Character.new(?P.ord), Character.new(?Q.ord), Character.new(?R.ord), Character.new(?S.ord), Character.new(?T.ord), Character.new(?U.ord), Character.new(?V.ord), Character.new(?W.ord), Character.new(?X.ord), Character.new(?Y.ord), Character.new(?Z.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord), Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord), Character.new(?n.ord), Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord), Character.new(?r.ord), Character.new(?s.ord), Character.new(?t.ord), Character.new(?u.ord), Character.new(?v.ord), Character.new(?w.ord), Character.new(?x.ord), Character.new(?y.ord), Character.new(?z.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?+.ord), Character.new(?/.ord)]) }
      const_attr_reader  :IntToBase64
      
      # This array is a lookup table that translates 6-bit positive integer
      # index values into their "Alternate Base64 Alphabet" equivalents.
      # This is NOT the real Base64 Alphabet as per in Table 1 of RFC 2045.
      # This alternate alphabet does not use the capital letters.  It is
      # designed for use in environments where "case folding" occurs.
      const_set_lazy(:IntToAltBase64) { Array.typed(::Java::Char).new([Character.new(?!.ord), Character.new(?".ord), Character.new(?#.ord), Character.new(?$.ord), Character.new(?%.ord), Character.new(?&.ord), Character.new(?\'.ord), Character.new(?(.ord), Character.new(?).ord), Character.new(?,.ord), Character.new(?-.ord), Character.new(?..ord), Character.new(?:.ord), Character.new(?;.ord), Character.new(?<.ord), Character.new(?>.ord), Character.new(?@.ord), Character.new(?[.ord), Character.new(?].ord), Character.new(?^.ord), Character.new(?`.ord), Character.new(?_.ord), Character.new(?{.ord), Character.new(?|.ord), Character.new(?}.ord), Character.new(?~.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord), Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord), Character.new(?n.ord), Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord), Character.new(?r.ord), Character.new(?s.ord), Character.new(?t.ord), Character.new(?u.ord), Character.new(?v.ord), Character.new(?w.ord), Character.new(?x.ord), Character.new(?y.ord), Character.new(?z.ord), Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?+.ord), Character.new(??.ord)]) }
      const_attr_reader  :IntToAltBase64
      
      typesig { [String] }
      # Translates the specified Base64 string (as per Preferences.get(byte[]))
      # into a byte array.
      # 
      # @throw IllegalArgumentException if <tt>s</tt> is not a valid Base64
      # string.
      def base64_to_byte_array(s)
        return base64_to_byte_array(s, false)
      end
      
      typesig { [String] }
      # Translates the specified "alternate representation" Base64 string
      # into a byte array.
      # 
      # @throw IllegalArgumentException or ArrayOutOfBoundsException
      # if <tt>s</tt> is not a valid alternate representation
      # Base64 string.
      def alt_base64to_byte_array(s)
        return base64_to_byte_array(s, true)
      end
      
      typesig { [String, ::Java::Boolean] }
      def base64_to_byte_array(s, alternate)
        alpha_to_int = (alternate ? AltBase64ToInt : Base64ToInt)
        s_len = s.length
        num_groups = s_len / 4
        if (!(4 * num_groups).equal?(s_len))
          raise IllegalArgumentException.new("String length must be a multiple of four.")
        end
        missing_bytes_in_last_group = 0
        num_full_groups = num_groups
        if (!(s_len).equal?(0))
          if ((s.char_at(s_len - 1)).equal?(Character.new(?=.ord)))
            missing_bytes_in_last_group += 1
            num_full_groups -= 1
          end
          if ((s.char_at(s_len - 2)).equal?(Character.new(?=.ord)))
            missing_bytes_in_last_group += 1
          end
        end
        result = Array.typed(::Java::Byte).new(3 * num_groups - missing_bytes_in_last_group) { 0 }
        # Translate all full groups from base64 to byte array elements
        in_cursor = 0
        out_cursor = 0
        i = 0
        while i < num_full_groups
          ch0 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          ch1 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          ch2 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          ch3 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          result[((out_cursor += 1) - 1)] = ((ch0 << 2) | (ch1 >> 4))
          result[((out_cursor += 1) - 1)] = ((ch1 << 4) | (ch2 >> 2))
          result[((out_cursor += 1) - 1)] = ((ch2 << 6) | ch3)
          i += 1
        end
        # Translate partial group, if present
        if (!(missing_bytes_in_last_group).equal?(0))
          ch0 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          ch1 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
          result[((out_cursor += 1) - 1)] = ((ch0 << 2) | (ch1 >> 4))
          if ((missing_bytes_in_last_group).equal?(1))
            ch2 = base64to_int(s.char_at(((in_cursor += 1) - 1)), alpha_to_int)
            result[((out_cursor += 1) - 1)] = ((ch1 << 4) | (ch2 >> 2))
          end
        end
        # assert inCursor == s.length()-missingBytesInLastGroup;
        # assert outCursor == result.length;
        return result
      end
      
      typesig { [::Java::Char, Array.typed(::Java::Byte)] }
      # Translates the specified character, which is assumed to be in the
      # "Base 64 Alphabet" into its equivalent 6-bit positive integer.
      # 
      # @throw IllegalArgumentException or ArrayOutOfBoundsException if
      # c is not in the Base64 Alphabet.
      def base64to_int(c, alpha_to_int)
        result = alpha_to_int[c]
        if (result < 0)
          raise IllegalArgumentException.new("Illegal character " + RJava.cast_to_string(c))
        end
        return result
      end
      
      # This array is a lookup table that translates unicode characters
      # drawn from the "Base64 Alphabet" (as specified in Table 1 of RFC 2045)
      # into their 6-bit positive integer equivalents.  Characters that
      # are not in the Base64 alphabet but fall within the bounds of the
      # array are translated to -1.
      const_set_lazy(:Base64ToInt) { Array.typed(::Java::Byte).new([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]) }
      const_attr_reader  :Base64ToInt
      
      # This array is the analogue of base64ToInt, but for the nonstandard
      # variant that avoids the use of uppercase alphabetic characters.
      const_set_lazy(:AltBase64ToInt) { Array.typed(::Java::Byte).new([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, -1, 62, 9, 10, 11, -1, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 12, 13, 14, -1, 15, 63, 16, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 17, -1, 18, 19, 21, 20, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 22, 23, 24, 25]) }
      const_attr_reader  :AltBase64ToInt
      
      typesig { [Array.typed(String)] }
      def main(args)
        num_runs = JavaInteger.parse_int(args[0])
        num_bytes = JavaInteger.parse_int(args[1])
        rnd = Java::Util::Random.new
        i = 0
        while i < num_runs
          j = 0
          while j < num_bytes
            arr = Array.typed(::Java::Byte).new(j) { 0 }
            k = 0
            while k < j
              arr[k] = rnd.next_int
              k += 1
            end
            s = byte_array_to_base64(arr)
            b = base64_to_byte_array(s)
            if (!(Java::Util::Arrays == arr))
              System.out.println("Dismal failure!")
            end
            s = RJava.cast_to_string(byte_array_to_alt_base64(arr))
            b = alt_base64to_byte_array(s)
            if (!(Java::Util::Arrays == arr))
              System.out.println("Alternate dismal failure!")
            end
            j += 1
          end
          i += 1
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__base64, :initialize
  end
  
  Base64.main($*) if $0 == __FILE__
end

require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module IDNImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Net::Idn, :StringPrep
      include_const ::Sun::Net::Idn, :Punycode
      include_const ::Sun::Text::Normalizer, :UCharacterIterator
    }
  end
  
  # Provides methods to convert internationalized domain names (IDNs) between
  # a normal Unicode representation and an ASCII Compatible Encoding (ACE) representation.
  # Internationalized domain names can use characters from the entire range of
  # Unicode, while traditional domain names are restricted to ASCII characters.
  # ACE is an encoding of Unicode strings that uses only ASCII characters and
  # can be used with software (such as the Domain Name System) that only
  # understands traditional domain names.
  # 
  # <p>Internationalized domain names are defined in <a href="http://www.ietf.org/rfc/rfc3490.txt">RFC 3490</a>.
  # RFC 3490 defines two operations: ToASCII and ToUnicode. These 2 operations employ
  # <a href="http://www.ietf.org/rfc/rfc3491.txt">Nameprep</a> algorithm, which is a
  # profile of <a href="http://www.ietf.org/rfc/rfc3454.txt">Stringprep</a>, and
  # <a href="http://www.ietf.org/rfc/rfc3492.txt">Punycode</a> algorithm to convert
  # domain name string back and forth.
  # 
  # <p>The behavior of aforementioned conversion process can be adjusted by various flags:
  # <ul>
  # <li>If the ALLOW_UNASSIGNED flag is used, the domain name string to be converted
  # can contain code points that are unassigned in Unicode 3.2, which is the
  # Unicode version on which IDN conversion is based. If the flag is not used,
  # the presence of such unassigned code points is treated as an error.
  # <li>If the USE_STD3_ASCII_RULES flag is used, ASCII strings are checked against <a href="http://www.ietf.org/rfc/rfc1122.txt">RFC 1122</a> and <a href="http://www.ietf.org/rfc/rfc1123.txt">RFC 1123</a>.
  # It is an error if they don't meet the requirements.
  # </ul>
  # These flags can be logically OR'ed together.
  # 
  # <p>The security consideration is important with respect to internationalization
  # domain name support. For example, English domain names may be <i>homographed</i>
  # - maliciously misspelled by substitution of non-Latin letters.
  # <a href="http://www.unicode.org/reports/tr36/">Unicode Technical Report #36</a>
  # discusses security issues of IDN support as well as possible solutions.
  # Applications are responsible for taking adequate security measures when using
  # international domain names.
  # 
  # @author Edward Wang
  # @since 1.6
  class IDN 
    include_class_members IDNImports
    
    class_module.module_eval {
      # Flag to allow processing of unassigned code points
      const_set_lazy(:ALLOW_UNASSIGNED) { 0x1 }
      const_attr_reader  :ALLOW_UNASSIGNED
      
      # Flag to turn on the check against STD-3 ASCII rules
      const_set_lazy(:USE_STD3_ASCII_RULES) { 0x2 }
      const_attr_reader  :USE_STD3_ASCII_RULES
      
      typesig { [String, ::Java::Int] }
      # Translates a string from Unicode to ASCII Compatible Encoding (ACE),
      # as defined by the ToASCII operation of <a href="http://www.ietf.org/rfc/rfc3490.txt">RFC 3490</a>.
      # 
      # <p>ToASCII operation can fail. ToASCII fails if any step of it fails.
      # If ToASCII operation fails, an IllegalArgumentException will be thrown.
      # In this case, the input string should not be used in an internationalized domain name.
      # 
      # <p> A label is an individual part of a domain name. The original ToASCII operation,
      # as defined in RFC 3490, only operates on a single label. This method can handle
      # both label and entire domain name, by assuming that labels in a domain name are
      # always separated by dots. The following characters are recognized as dots:
      # &#0092;u002E (full stop), &#0092;u3002 (ideographic full stop), &#0092;uFF0E (fullwidth full stop),
      # and &#0092;uFF61 (halfwidth ideographic full stop). if dots are
      # used as label separators, this method also changes all of them to &#0092;u002E (full stop)
      # in output translated string.
      # 
      # @param input     the string to be processed
      # @param flag      process flag; can be 0 or any logical OR of possible flags
      # 
      # @return          the translated <tt>String</tt>
      # 
      # @throws IllegalArgumentException   if the input string doesn't conform to RFC 3490 specification
      def to_ascii(input, flag)
        p = 0
        q = 0
        out = StringBuffer.new
        while (p < input.length)
          q = search_dots(input, p)
          out.append(to_asciiinternal(input.substring(p, q), flag))
          p = q + 1
          if (p < input.length)
            out.append(Character.new(?..ord))
          end
        end
        return out.to_s
      end
      
      typesig { [String] }
      # Translates a string from Unicode to ASCII Compatible Encoding (ACE),
      # as defined by the ToASCII operation of <a href="http://www.ietf.org/rfc/rfc3490.txt">RFC 3490</a>.
      # 
      # <p> This convenience method works as if by invoking the
      # two-argument counterpart as follows:
      # <blockquote><tt>
      # {@link #toASCII(String, int) toASCII}(input,&nbsp;0);
      # </tt></blockquote>
      # 
      # @param input     the string to be processed
      # 
      # @return          the translated <tt>String</tt>
      # 
      # @throws IllegalArgumentException   if the input string doesn't conform to RFC 3490 specification
      def to_ascii(input)
        return to_ascii(input, 0)
      end
      
      typesig { [String, ::Java::Int] }
      # Translates a string from ASCII Compatible Encoding (ACE) to Unicode,
      # as defined by the ToUnicode operation of <a href="http://www.ietf.org/rfc/rfc3490.txt">RFC 3490</a>.
      # 
      # <p>ToUnicode never fails. In case of any error, the input string is returned unmodified.
      # 
      # <p> A label is an individual part of a domain name. The original ToUnicode operation,
      # as defined in RFC 3490, only operates on a single label. This method can handle
      # both label and entire domain name, by assuming that labels in a domain name are
      # always separated by dots. The following characters are recognized as dots:
      # &#0092;u002E (full stop), &#0092;u3002 (ideographic full stop), &#0092;uFF0E (fullwidth full stop),
      # and &#0092;uFF61 (halfwidth ideographic full stop).
      # 
      # @param input     the string to be processed
      # @param flag      process flag; can be 0 or any logical OR of possible flags
      # 
      # @return          the translated <tt>String</tt>
      def to_unicode(input, flag)
        p = 0
        q = 0
        out = StringBuffer.new
        while (p < input.length)
          q = search_dots(input, p)
          out.append(to_unicode_internal(input.substring(p, q), flag))
          p = q + 1
          if (p < input.length)
            out.append(Character.new(?..ord))
          end
        end
        return out.to_s
      end
      
      typesig { [String] }
      # Translates a string from ASCII Compatible Encoding (ACE) to Unicode,
      # as defined by the ToUnicode operation of <a href="http://www.ietf.org/rfc/rfc3490.txt">RFC 3490</a>.
      # 
      # <p> This convenience method works as if by invoking the
      # two-argument counterpart as follows:
      # <blockquote><tt>
      # {@link #toUnicode(String, int) toUnicode}(input,&nbsp;0);
      # </tt></blockquote>
      # 
      # @param input     the string to be processed
      # 
      # @return          the translated <tt>String</tt>
      def to_unicode(input)
        return to_unicode(input, 0)
      end
      
      # ---------------- Private members --------------
      # ACE Prefix is "xn--"
      const_set_lazy(:ACE_PREFIX) { "xn--" }
      const_attr_reader  :ACE_PREFIX
      
      const_set_lazy(:ACE_PREFIX_LENGTH) { ACE_PREFIX.length }
      const_attr_reader  :ACE_PREFIX_LENGTH
      
      const_set_lazy(:MAX_LABEL_LENGTH) { 63 }
      const_attr_reader  :MAX_LABEL_LENGTH
      
      # single instance of nameprep
      
      def name_prep
        defined?(@@name_prep) ? @@name_prep : @@name_prep= nil
      end
      alias_method :attr_name_prep, :name_prep
      
      def name_prep=(value)
        @@name_prep = value
      end
      alias_method :attr_name_prep=, :name_prep=
      
      when_class_loaded do
        stream = nil
        begin
          idn_profile = "uidna.spp"
          if (!(System.get_security_manager).nil?)
            stream = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members IDN
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                return StringPrep.get_resource_as_stream(idn_profile)
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          else
            stream = StringPrep.get_resource_as_stream(idn_profile)
          end
          self.attr_name_prep = StringPrep.new(stream)
          stream.close
        rescue IOException => e
          # should never reach here
          raise AssertError if not (false)
        end
      end
    }
    
    typesig { [] }
    # ---------------- Private operations --------------
    # 
    # to suppress the default zero-argument constructor
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # toASCII operation; should only apply to a single label
      def to_asciiinternal(label, flag)
        # step 1
        # Check if the string contains code points outside the ASCII range 0..0x7c.
        is_ascii = is_all_ascii(label)
        dest = nil
        # step 2
        # perform the nameprep operation; flag ALLOW_UNASSIGNED is used here
        if (!is_ascii)
          iter = UCharacterIterator.get_instance(label)
          begin
            dest = self.attr_name_prep.prepare(iter, flag)
          rescue Java::Text::ParseException => e
            raise IllegalArgumentException.new(e)
          end
        else
          dest = StringBuffer.new(label)
        end
        # step 3
        # Verify the absence of non-LDH ASCII code points
        # 0..0x2c, 0x2e..0x2f, 0x3a..0x40, 0x5b..0x60, 0x7b..0x7f
        # Verify the absence of leading and trailing hyphen
        use_std3asciirules = (!((flag & USE_STD3_ASCII_RULES)).equal?(0))
        if (use_std3asciirules)
          i = 0
          while i < dest.length
            c = dest.char_at(i)
            if (!is_ldhchar(c))
              raise IllegalArgumentException.new("Contains non-LDH characters")
            end
            i += 1
          end
          if ((dest.char_at(0)).equal?(Character.new(?-.ord)) || (dest.char_at(dest.length - 1)).equal?(Character.new(?-.ord)))
            raise IllegalArgumentException.new("Has leading or trailing hyphen")
          end
        end
        if (!is_ascii)
          # step 4
          # If all code points are inside 0..0x7f, skip to step 8
          if (!is_all_ascii(dest.to_s))
            # step 5
            # verify the sequence does not begin with ACE prefix
            if (!starts_with_aceprefix(dest))
              # step 6
              # encode the sequence with punycode
              begin
                dest = Punycode.encode(dest, nil)
              rescue Java::Text::ParseException => e
                raise IllegalArgumentException.new(e)
              end
              dest = to_asciilower(dest)
              # step 7
              # prepend the ACE prefix
              dest.insert(0, ACE_PREFIX)
            else
              raise IllegalArgumentException.new("The input starts with the ACE Prefix")
            end
          end
        end
        # step 8
        # the length must be inside 1..63
        if (dest.length > MAX_LABEL_LENGTH)
          raise IllegalArgumentException.new("The label in the input is too long")
        end
        return dest.to_s
      end
      
      typesig { [String, ::Java::Int] }
      # toUnicode operation; should only apply to a single label
      def to_unicode_internal(label, flag)
        case_flags = nil
        dest = nil
        # step 1
        # find out if all the codepoints in input are ASCII
        is_ascii = is_all_ascii(label)
        if (!is_ascii)
          # step 2
          # perform the nameprep operation; flag ALLOW_UNASSIGNED is used here
          begin
            iter = UCharacterIterator.get_instance(label)
            dest = self.attr_name_prep.prepare(iter, flag)
          rescue JavaException => e
            # toUnicode never fails; if any step fails, return the input string
            return label
          end
        else
          dest = StringBuffer.new(label)
        end
        # step 3
        # verify ACE Prefix
        if (starts_with_aceprefix(dest))
          # step 4
          # Remove the ACE Prefix
          temp = dest.substring(ACE_PREFIX_LENGTH, dest.length)
          begin
            # step 5
            # Decode using punycode
            decode_out = Punycode.decode(StringBuffer.new(temp), nil)
            # step 6
            # Apply toASCII
            to_asciiout = to_ascii(decode_out.to_s, flag)
            # step 7
            # verify
            if (to_asciiout.equals_ignore_case(dest.to_s))
              # step 8
              # return output of step 5
              return decode_out.to_s
            end
          rescue JavaException => ignored
            # no-op
          end
        end
        # just return the input
        return label
      end
      
      typesig { [::Java::Int] }
      # LDH stands for "letter/digit/hyphen", with characters restricted to the
      # 26-letter Latin alphabet <A-Z a-z>, the digits <0-9>, and the hyphen
      # <->
      # non-LDH = 0..0x2C, 0x2E..0x2F, 0x3A..0x40, 0x56..0x60, 0x7B..0x7F
      def is_ldhchar(ch)
        # high runner case
        if (ch > 0x7a)
          return false
        end
        # ['-' '0'..'9' 'A'..'Z' 'a'..'z']
        if (((ch).equal?(0x2d)) || (0x30 <= ch && ch <= 0x39) || (0x41 <= ch && ch <= 0x5a) || (0x61 <= ch && ch <= 0x7a))
          return true
        end
        return false
      end
      
      typesig { [String, ::Java::Int] }
      # search dots in a string and return the index of that character;
      # or if there is no dots, return the length of input string
      # dots might be: \u002E (full stop), \u3002 (ideographic full stop), \uFF0E (fullwidth full stop),
      # and \uFF61 (halfwidth ideographic full stop).
      def search_dots(s, start)
        i = 0
        i = start
        while i < s.length
          c = s.char_at(i)
          if ((c).equal?(Character.new(?..ord)) || (c).equal?(Character.new(0x3002)) || (c).equal?(Character.new(0xFF0E)) || (c).equal?(Character.new(0xFF61)))
            break
          end
          i += 1
        end
        return i
      end
      
      typesig { [String] }
      # to check if a string only contains US-ASCII code point
      def is_all_ascii(input)
        is_ascii = true
        i = 0
        while i < input.length
          c = input.char_at(i)
          if (c > 0x7f)
            is_ascii = false
            break
          end
          i += 1
        end
        return is_ascii
      end
      
      typesig { [StringBuffer] }
      # to check if a string starts with ACE-prefix
      def starts_with_aceprefix(input)
        starts_with_prefix = true
        if (input.length < ACE_PREFIX_LENGTH)
          return false
        end
        i = 0
        while i < ACE_PREFIX_LENGTH
          if (!(to_asciilower(input.char_at(i))).equal?(ACE_PREFIX.char_at(i)))
            starts_with_prefix = false
          end
          i += 1
        end
        return starts_with_prefix
      end
      
      typesig { [::Java::Char] }
      def to_asciilower(ch)
        if (Character.new(?A.ord) <= ch && ch <= Character.new(?Z.ord))
          return RJava.cast_to_char((ch + Character.new(?a.ord) - Character.new(?A.ord)))
        end
        return ch
      end
      
      typesig { [StringBuffer] }
      def to_asciilower(input)
        dest = StringBuffer.new
        i = 0
        while i < input.length
          dest.append(to_asciilower(input.char_at(i)))
          i += 1
        end
        return dest
      end
    }
    
    private
    alias_method :initialize__idn, :initialize
  end
  
end

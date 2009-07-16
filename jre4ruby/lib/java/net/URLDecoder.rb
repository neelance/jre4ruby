require "rjava"

# 
# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URLDecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include ::Java::Io
    }
  end
  
  # 
  # Utility class for HTML form decoding. This class contains static methods
  # for decoding a String from the <CODE>application/x-www-form-urlencoded</CODE>
  # MIME format.
  # <p>
  # The conversion process is the reverse of that used by the URLEncoder class. It is assumed
  # that all characters in the encoded string are one of the following:
  # &quot;<code>a</code>&quot; through &quot;<code>z</code>&quot;,
  # &quot;<code>A</code>&quot; through &quot;<code>Z</code>&quot;,
  # &quot;<code>0</code>&quot; through &quot;<code>9</code>&quot;, and
  # &quot;<code>-</code>&quot;, &quot;<code>_</code>&quot;,
  # &quot;<code>.</code>&quot;, and &quot;<code>*</code>&quot;. The
  # character &quot;<code>%</code>&quot; is allowed but is interpreted
  # as the start of a special escaped sequence.
  # <p>
  # The following rules are applied in the conversion:
  # <p>
  # <ul>
  # <li>The alphanumeric characters &quot;<code>a</code>&quot; through
  # &quot;<code>z</code>&quot;, &quot;<code>A</code>&quot; through
  # &quot;<code>Z</code>&quot; and &quot;<code>0</code>&quot;
  # through &quot;<code>9</code>&quot; remain the same.
  # <li>The special characters &quot;<code>.</code>&quot;,
  # &quot;<code>-</code>&quot;, &quot;<code>*</code>&quot;, and
  # &quot;<code>_</code>&quot; remain the same.
  # <li>The plus sign &quot;<code>+</code>&quot; is converted into a
  # space character &quot;<code>&nbsp;</code>&quot; .
  # <li>A sequence of the form "<code>%<i>xy</i></code>" will be
  # treated as representing a byte where <i>xy</i> is the two-digit
  # hexadecimal representation of the 8 bits. Then, all substrings
  # that contain one or more of these byte sequences consecutively
  # will be replaced by the character(s) whose encoding would result
  # in those consecutive bytes.
  # The encoding scheme used to decode these characters may be specified,
  # or if unspecified, the default encoding of the platform will be used.
  # </ul>
  # <p>
  # There are two possible ways in which this decoder could deal with
  # illegal strings.  It could either leave illegal characters alone or
  # it could throw an <tt>{@link java.lang.IllegalArgumentException}</tt>.
  # Which approach the decoder takes is left to the
  # implementation.
  # 
  # @author  Mark Chamness
  # @author  Michael McCloskey
  # @since   1.2
  class URLDecoder 
    include_class_members URLDecoderImports
    
    class_module.module_eval {
      # The platform default encoding
      
      def dflt_enc_name
        defined?(@@dflt_enc_name) ? @@dflt_enc_name : @@dflt_enc_name= URLEncoder.attr_dflt_enc_name
      end
      alias_method :attr_dflt_enc_name, :dflt_enc_name
      
      def dflt_enc_name=(value)
        @@dflt_enc_name = value
      end
      alias_method :attr_dflt_enc_name=, :dflt_enc_name=
      
      typesig { [String] }
      # 
      # Decodes a <code>x-www-form-urlencoded</code> string.
      # The platform's default encoding is used to determine what characters
      # are represented by any consecutive sequences of the form
      # "<code>%<i>xy</i></code>".
      # @param s the <code>String</code> to decode
      # @deprecated The resulting string may vary depending on the platform's
      # default encoding. Instead, use the decode(String,String) method
      # to specify the encoding.
      # @return the newly decoded <code>String</code>
      def decode(s)
        str = nil
        begin
          str = (decode(s, self.attr_dflt_enc_name)).to_s
        rescue UnsupportedEncodingException => e
          # The system should always have the platform default
        end
        return str
      end
      
      typesig { [String, String] }
      # 
      # Decodes a <code>application/x-www-form-urlencoded</code> string using a specific
      # encoding scheme.
      # The supplied encoding is used to determine
      # what characters are represented by any consecutive sequences of the
      # form "<code>%<i>xy</i></code>".
      # <p>
      # <em><strong>Note:</strong> The <a href=
      # "http://www.w3.org/TR/html40/appendix/notes.html#non-ascii-chars">
      # World Wide Web Consortium Recommendation</a> states that
      # UTF-8 should be used. Not doing so may introduce
      # incompatibilites.</em>
      # 
      # @param s the <code>String</code> to decode
      # @param enc   The name of a supported
      # <a href="../lang/package-summary.html#charenc">character
      # encoding</a>.
      # @return the newly decoded <code>String</code>
      # @exception  UnsupportedEncodingException
      # If character encoding needs to be consulted, but
      # named character encoding is not supported
      # @see URLEncoder#encode(java.lang.String, java.lang.String)
      # @since 1.4
      def decode(s, enc)
        need_to_change = false
        num_chars = s.length
        sb = StringBuffer.new(num_chars > 500 ? num_chars / 2 : num_chars)
        i = 0
        if ((enc.length).equal?(0))
          raise UnsupportedEncodingException.new("URLDecoder: empty string enc parameter")
        end
        c = 0
        bytes = nil
        while (i < num_chars)
          c = s.char_at(i)
          case (c)
          when Character.new(?+.ord)
            sb.append(Character.new(?\s.ord))
            ((i += 1) - 1)
            need_to_change = true
          when Character.new(?%.ord)
            # 
            # Starting with this instance of %, process all
            # consecutive substrings of the form %xy. Each
            # substring %xy will yield a byte. Convert all
            # consecutive  bytes obtained this way to whatever
            # character(s) they represent in the provided
            # encoding.
            begin
              # (numChars-i)/3 is an upper bound for the number
              # of remaining bytes
              if ((bytes).nil?)
                bytes = Array.typed(::Java::Byte).new((num_chars - i) / 3) { 0 }
              end
              pos = 0
              while (((i + 2) < num_chars) && ((c).equal?(Character.new(?%.ord))))
                v = JavaInteger.parse_int(s.substring(i + 1, i + 3), 16)
                if (v < 0)
                  raise IllegalArgumentException.new("URLDecoder: Illegal hex characters in escape (%) pattern - negative value")
                end
                bytes[((pos += 1) - 1)] = v
                i += 3
                if (i < num_chars)
                  c = s.char_at(i)
                end
              end
              # A trailing, incomplete byte encoding such as
              # "%x" will cause an exception to be thrown
              if ((i < num_chars) && ((c).equal?(Character.new(?%.ord))))
                raise IllegalArgumentException.new("URLDecoder: Incomplete trailing escape (%) pattern")
              end
              sb.append(String.new(bytes, 0, pos, enc))
            rescue NumberFormatException => e
              raise IllegalArgumentException.new("URLDecoder: Illegal hex characters in escape (%) pattern - " + (e.get_message).to_s)
            end
            need_to_change = true
          else
            sb.append(c)
            ((i += 1) - 1)
          end
        end
        return (need_to_change ? sb.to_s : s)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__urldecoder, :initialize
  end
  
end

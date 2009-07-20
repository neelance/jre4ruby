require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URLEncoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :BufferedWriter
      include_const ::Java::Io, :OutputStreamWriter
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Io, :CharArrayWriter
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :IllegalCharsetNameException
      include_const ::Java::Nio::Charset, :UnsupportedCharsetException
      include_const ::Java::Util, :BitSet
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Security::Action, :GetBooleanAction
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # Utility class for HTML form encoding. This class contains static methods
  # for converting a String to the <CODE>application/x-www-form-urlencoded</CODE> MIME
  # format. For more information about HTML form encoding, consult the HTML
  # <A HREF="http://www.w3.org/TR/html4/">specification</A>.
  # 
  # <p>
  # When encoding a String, the following rules apply:
  # 
  # <p>
  # <ul>
  # <li>The alphanumeric characters &quot;<code>a</code>&quot; through
  # &quot;<code>z</code>&quot;, &quot;<code>A</code>&quot; through
  # &quot;<code>Z</code>&quot; and &quot;<code>0</code>&quot;
  # through &quot;<code>9</code>&quot; remain the same.
  # <li>The special characters &quot;<code>.</code>&quot;,
  # &quot;<code>-</code>&quot;, &quot;<code>*</code>&quot;, and
  # &quot;<code>_</code>&quot; remain the same.
  # <li>The space character &quot;<code>&nbsp;</code>&quot; is
  # converted into a plus sign &quot;<code>+</code>&quot;.
  # <li>All other characters are unsafe and are first converted into
  # one or more bytes using some encoding scheme. Then each byte is
  # represented by the 3-character string
  # &quot;<code>%<i>xy</i></code>&quot;, where <i>xy</i> is the
  # two-digit hexadecimal representation of the byte.
  # The recommended encoding scheme to use is UTF-8. However,
  # for compatibility reasons, if an encoding is not specified,
  # then the default encoding of the platform is used.
  # </ul>
  # 
  # <p>
  # For example using UTF-8 as the encoding scheme the string &quot;The
  # string &#252;@foo-bar&quot; would get converted to
  # &quot;The+string+%C3%BC%40foo-bar&quot; because in UTF-8 the character
  # &#252; is encoded as two bytes C3 (hex) and BC (hex), and the
  # character @ is encoded as one byte 40 (hex).
  # 
  # @author  Herb Jellinek
  # @since   JDK1.0
  class URLEncoder 
    include_class_members URLEncoderImports
    
    class_module.module_eval {
      
      def dont_need_encoding
        defined?(@@dont_need_encoding) ? @@dont_need_encoding : @@dont_need_encoding= nil
      end
      alias_method :attr_dont_need_encoding, :dont_need_encoding
      
      def dont_need_encoding=(value)
        @@dont_need_encoding = value
      end
      alias_method :attr_dont_need_encoding=, :dont_need_encoding=
      
      const_set_lazy(:CaseDiff) { (Character.new(?a.ord) - Character.new(?A.ord)) }
      const_attr_reader  :CaseDiff
      
      
      def dflt_enc_name
        defined?(@@dflt_enc_name) ? @@dflt_enc_name : @@dflt_enc_name= nil
      end
      alias_method :attr_dflt_enc_name, :dflt_enc_name
      
      def dflt_enc_name=(value)
        @@dflt_enc_name = value
      end
      alias_method :attr_dflt_enc_name=, :dflt_enc_name=
      
      when_class_loaded do
        # The list of characters that are not encoded has been
        # determined as follows:
        # 
        # RFC 2396 states:
        # -----
        # Data characters that are allowed in a URI but do not have a
        # reserved purpose are called unreserved.  These include upper
        # and lower case letters, decimal digits, and a limited set of
        # punctuation marks and symbols.
        # 
        # unreserved  = alphanum | mark
        # 
        # mark        = "-" | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")"
        # 
        # Unreserved characters can be escaped without changing the
        # semantics of the URI, but this should not be done unless the
        # URI is being used in a context that does not allow the
        # unescaped character to appear.
        # -----
        # 
        # It appears that both Netscape and Internet Explorer escape
        # all special characters from this list with the exception
        # of "-", "_", ".", "*". While it is not clear why they are
        # escaping the other characters, perhaps it is safest to
        # assume that there might be contexts in which the others
        # are unsafe if not escaped. Therefore, we will use the same
        # list. It is also noteworthy that this is consistent with
        # O'Reilly's "HTML: The Definitive Guide" (page 164).
        # 
        # As a last note, Intenet Explorer does not encode the "@"
        # character which is clearly not unreserved according to the
        # RFC. We are being consistent with the RFC in this matter,
        # as is Netscape.
        self.attr_dont_need_encoding = BitSet.new(256)
        i = 0
        i = Character.new(?a.ord)
        while i <= Character.new(?z.ord)
          self.attr_dont_need_encoding.set(i)
          i += 1
        end
        i = Character.new(?A.ord)
        while i <= Character.new(?Z.ord)
          self.attr_dont_need_encoding.set(i)
          i += 1
        end
        i = Character.new(?0.ord)
        while i <= Character.new(?9.ord)
          self.attr_dont_need_encoding.set(i)
          i += 1
        end
        self.attr_dont_need_encoding.set(Character.new(?\s.ord))
        # encoding a space to a + is done
        # in the encode() method
        self.attr_dont_need_encoding.set(Character.new(?-.ord))
        self.attr_dont_need_encoding.set(Character.new(?_.ord))
        self.attr_dont_need_encoding.set(Character.new(?..ord))
        self.attr_dont_need_encoding.set(Character.new(?*.ord))
        self.attr_dflt_enc_name = (AccessController.do_privileged(GetPropertyAction.new("file.encoding"))).to_s
      end
    }
    
    typesig { [] }
    # You can't call the constructor.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Translates a string into <code>x-www-form-urlencoded</code>
      # format. This method uses the platform's default encoding
      # as the encoding scheme to obtain the bytes for unsafe characters.
      # 
      # @param   s   <code>String</code> to be translated.
      # @deprecated The resulting string may vary depending on the platform's
      # default encoding. Instead, use the encode(String,String)
      # method to specify the encoding.
      # @return  the translated <code>String</code>.
      def encode(s)
        str = nil
        begin
          str = (encode(s, self.attr_dflt_enc_name)).to_s
        rescue UnsupportedEncodingException => e
          # The system should always have the platform default
        end
        return str
      end
      
      typesig { [String, String] }
      # Translates a string into <code>application/x-www-form-urlencoded</code>
      # format using a specific encoding scheme. This method uses the
      # supplied encoding scheme to obtain the bytes for unsafe
      # characters.
      # <p>
      # <em><strong>Note:</strong> The <a href=
      # "http://www.w3.org/TR/html40/appendix/notes.html#non-ascii-chars">
      # World Wide Web Consortium Recommendation</a> states that
      # UTF-8 should be used. Not doing so may introduce
      # incompatibilites.</em>
      # 
      # @param   s   <code>String</code> to be translated.
      # @param   enc   The name of a supported
      # <a href="../lang/package-summary.html#charenc">character
      # encoding</a>.
      # @return  the translated <code>String</code>.
      # @exception  UnsupportedEncodingException
      # If the named encoding is not supported
      # @see URLDecoder#decode(java.lang.String, java.lang.String)
      # @since 1.4
      def encode(s, enc)
        need_to_change = false
        out = StringBuffer.new(s.length)
        charset = nil
        char_array_writer = CharArrayWriter.new
        if ((enc).nil?)
          raise NullPointerException.new("charsetName")
        end
        begin
          charset = Charset.for_name(enc)
        rescue IllegalCharsetNameException => e
          raise UnsupportedEncodingException.new(enc)
        rescue UnsupportedCharsetException => e
          raise UnsupportedEncodingException.new(enc)
        end
        i = 0
        while i < s.length
          c = RJava.cast_to_int(s.char_at(i))
          # System.out.println("Examining character: " + c);
          if (self.attr_dont_need_encoding.get(c))
            if ((c).equal?(Character.new(?\s.ord)))
              c = Character.new(?+.ord)
              need_to_change = true
            end
            # System.out.println("Storing: " + c);
            out.append(RJava.cast_to_char(c))
            i += 1
          else
            # convert to external encoding before hex conversion
            begin
              char_array_writer.write(c)
              # If this character represents the start of a Unicode
              # surrogate pair, then pass in two characters. It's not
              # clear what should be done if a bytes reserved in the
              # surrogate pairs range occurs outside of a legal
              # surrogate pair. For now, just treat it as if it were
              # any other character.
              if (c >= 0xd800 && c <= 0xdbff)
                # System.out.println(Integer.toHexString(c)
                # + " is high surrogate");
                if ((i + 1) < s.length)
                  d = RJava.cast_to_int(s.char_at(i + 1))
                  # System.out.println("\tExamining "
                  # + Integer.toHexString(d));
                  if (d >= 0xdc00 && d <= 0xdfff)
                    # System.out.println("\t"
                    # + Integer.toHexString(d)
                    # + " is low surrogate");
                    char_array_writer.write(d)
                    i += 1
                  end
                end
              end
              i += 1
            end while (i < s.length && !self.attr_dont_need_encoding.get((c = RJava.cast_to_int(s.char_at(i)))))
            char_array_writer.flush
            str = String.new(char_array_writer.to_char_array)
            ba = str.get_bytes(charset)
            j = 0
            while j < ba.attr_length
              out.append(Character.new(?%.ord))
              ch = Character.for_digit((ba[j] >> 4) & 0xf, 16)
              # converting to use uppercase letter as part of
              # the hex value if ch is a letter.
              if (Character.is_letter(ch))
                ch -= CaseDiff
              end
              out.append(ch)
              ch = Character.for_digit(ba[j] & 0xf, 16)
              if (Character.is_letter(ch))
                ch -= CaseDiff
              end
              out.append(ch)
              j += 1
            end
            char_array_writer.reset
            need_to_change = true
          end
        end
        return (need_to_change ? out.to_s : s)
      end
    }
    
    private
    alias_method :initialize__urlencoder, :initialize
  end
  
end

require "rjava"

# Copyright 1998-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www
  module ParseUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Util, :BitSet
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URISyntaxException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Sun::Nio::Cs, :ThreadLocalCoders
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CodingErrorAction
    }
  end
  
  # A class that contains useful routines common to sun.net.www
  # @author  Mike McCloskey
  class ParseUtil 
    include_class_members ParseUtilImports
    
    class_module.module_eval {
      
      def encoded_in_path
        defined?(@@encoded_in_path) ? @@encoded_in_path : @@encoded_in_path= nil
      end
      alias_method :attr_encoded_in_path, :encoded_in_path
      
      def encoded_in_path=(value)
        @@encoded_in_path = value
      end
      alias_method :attr_encoded_in_path=, :encoded_in_path=
      
      when_class_loaded do
        self.attr_encoded_in_path = BitSet.new(256)
        # Set the bits corresponding to characters that are encoded in the
        # path component of a URI.
        # These characters are reserved in the path segment as described in
        # RFC2396 section 3.3.
        self.attr_encoded_in_path.set(Character.new(?=.ord))
        self.attr_encoded_in_path.set(Character.new(?;.ord))
        self.attr_encoded_in_path.set(Character.new(??.ord))
        self.attr_encoded_in_path.set(Character.new(?/.ord))
        # These characters are defined as excluded in RFC2396 section 2.4.3
        # and must be escaped if they occur in the data part of a URI.
        self.attr_encoded_in_path.set(Character.new(?#.ord))
        self.attr_encoded_in_path.set(Character.new(?\s.ord))
        self.attr_encoded_in_path.set(Character.new(?<.ord))
        self.attr_encoded_in_path.set(Character.new(?>.ord))
        self.attr_encoded_in_path.set(Character.new(?%.ord))
        self.attr_encoded_in_path.set(Character.new(?".ord))
        self.attr_encoded_in_path.set(Character.new(?{.ord))
        self.attr_encoded_in_path.set(Character.new(?}.ord))
        self.attr_encoded_in_path.set(Character.new(?|.ord))
        self.attr_encoded_in_path.set(Character.new(?\\.ord))
        self.attr_encoded_in_path.set(Character.new(?^.ord))
        self.attr_encoded_in_path.set(Character.new(?[.ord))
        self.attr_encoded_in_path.set(Character.new(?].ord))
        self.attr_encoded_in_path.set(Character.new(?`.ord))
        # US ASCII control characters 00-1F and 7F.
        i = 0
        while i < 32
          self.attr_encoded_in_path.set(i)
          ((i += 1) - 1)
        end
        self.attr_encoded_in_path.set(127)
      end
      
      typesig { [String] }
      # Constructs an encoded version of the specified path string suitable
      # for use in the construction of a URL.
      # 
      # A path separator is replaced by a forward slash. The string is UTF8
      # encoded. The % escape sequence is used for characters that are above
      # 0x7F or those defined in RFC2396 as reserved or excluded in the path
      # component of a URL.
      def encode_path(path)
        return encode_path(path, true)
      end
      
      typesig { [String, ::Java::Boolean] }
      # flag indicates whether path uses platform dependent
      # File.separatorChar or not. True indicates path uses platform
      # dependent File.separatorChar.
      def encode_path(path, flag)
        ret_cc = CharArray.new(path.length * 2 + 16)
        ret_len = 0
        path_cc = path.to_char_array
        n = path.length
        i = 0
        while i < n
          c = path_cc[i]
          if ((!flag && (c).equal?(Character.new(?/.ord))) || (flag && (c).equal?(JavaFile.attr_separator_char)))
            ret_cc[((ret_len += 1) - 1)] = Character.new(?/.ord)
          else
            if (c <= 0x7f)
              if (c >= Character.new(?a.ord) && c <= Character.new(?z.ord) || c >= Character.new(?A.ord) && c <= Character.new(?Z.ord) || c >= Character.new(?0.ord) && c <= Character.new(?9.ord))
                ret_cc[((ret_len += 1) - 1)] = c
              else
                if (self.attr_encoded_in_path.get(c))
                  ret_len = escape(ret_cc, c, ret_len)
                else
                  ret_cc[((ret_len += 1) - 1)] = c
                end
              end
            else
              if (c > 0x7ff)
                ret_len = escape(ret_cc, RJava.cast_to_char((0xe0 | ((c >> 12) & 0xf))), ret_len)
                ret_len = escape(ret_cc, RJava.cast_to_char((0x80 | ((c >> 6) & 0x3f))), ret_len)
                ret_len = escape(ret_cc, RJava.cast_to_char((0x80 | ((c >> 0) & 0x3f))), ret_len)
              else
                ret_len = escape(ret_cc, RJava.cast_to_char((0xc0 | ((c >> 6) & 0x1f))), ret_len)
                ret_len = escape(ret_cc, RJava.cast_to_char((0x80 | ((c >> 0) & 0x3f))), ret_len)
              end
            end
          end
          # worst case scenario for character [0x7ff-] every single
          # character will be encoded into 9 characters.
          if (ret_len + 9 > ret_cc.attr_length)
            new_len = ret_cc.attr_length * 2 + 16
            if (new_len < 0)
              new_len = JavaInteger::MAX_VALUE
            end
            buf = CharArray.new(new_len)
            System.arraycopy(ret_cc, 0, buf, 0, ret_len)
            ret_cc = buf
          end
          ((i += 1) - 1)
        end
        return String.new(ret_cc, 0, ret_len)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Char, ::Java::Int] }
      # Appends the URL escape sequence for the specified char to the
      # specified StringBuffer.
      def escape(cc, c, index)
        cc[((index += 1) - 1)] = Character.new(?%.ord)
        cc[((index += 1) - 1)] = Character.for_digit((c >> 4) & 0xf, 16)
        cc[((index += 1) - 1)] = Character.for_digit(c & 0xf, 16)
        return index
      end
      
      typesig { [String, ::Java::Int] }
      # Un-escape and return the character at position i in string s.
      def unescape(s, i)
        return JavaInteger.parse_int(s.substring(i + 1, i + 3), 16)
      end
      
      typesig { [String] }
      # Returns a new String constructed from the specified String by replacing
      # the URL escape sequences and UTF8 encoding with the characters they
      # represent.
      def decode(s)
        n = s.length
        if (((n).equal?(0)) || (s.index_of(Character.new(?%.ord)) < 0))
          return s
        end
        sb = StringBuilder.new(n)
        bb = ByteBuffer.allocate(n)
        cb = CharBuffer.allocate(n)
        dec = ThreadLocalCoders.decoder_for("UTF-8").on_malformed_input(CodingErrorAction::REPORT).on_unmappable_character(CodingErrorAction::REPORT)
        c = s.char_at(0)
        i = 0
        while i < n
          raise AssertError if not ((c).equal?(s.char_at(i)))
          if (!(c).equal?(Character.new(?%.ord)))
            sb.append(c)
            if ((i += 1) >= n)
              break
            end
            c = s.char_at(i)
            next
          end
          bb.clear
          ui = i
          loop do
            raise AssertError if not ((n - i >= 2))
            begin
              bb.put(unescape(s, i))
            rescue NumberFormatException => e
              raise IllegalArgumentException.new
            end
            i += 3
            if (i >= n)
              break
            end
            c = s.char_at(i)
            if (!(c).equal?(Character.new(?%.ord)))
              break
            end
          end
          bb.flip
          cb.clear
          dec.reset
          cr = dec.decode(bb, cb, true)
          if (cr.is_error)
            raise IllegalArgumentException.new("Error decoding percent encoded characters")
          end
          cr = dec.flush(cb)
          if (cr.is_error)
            raise IllegalArgumentException.new("Error decoding percent encoded characters")
          end
          sb.append(cb.flip.to_s)
        end
        return sb.to_s
      end
    }
    
    typesig { [String] }
    # Returns a canonical version of the specified string.
    def canonize_string(file)
      i = 0
      lim = file.length
      # Remove embedded /../
      while ((i = file.index_of("/../")) >= 0)
        if ((lim = file.last_index_of(Character.new(?/.ord), i - 1)) >= 0)
          file = (file.substring(0, lim) + file.substring(i + 3)).to_s
        else
          file = (file.substring(i + 3)).to_s
        end
      end
      # Remove embedded /./
      while ((i = file.index_of("/./")) >= 0)
        file = (file.substring(0, i) + file.substring(i + 2)).to_s
      end
      # Remove trailing ..
      while (file.ends_with("/.."))
        i = file.index_of("/..")
        if ((lim = file.last_index_of(Character.new(?/.ord), i - 1)) >= 0)
          file = (file.substring(0, lim + 1)).to_s
        else
          file = (file.substring(0, i)).to_s
        end
      end
      # Remove trailing .
      if (file.ends_with("/."))
        file = (file.substring(0, file.length - 1)).to_s
      end
      return file
    end
    
    class_module.module_eval {
      typesig { [JavaFile] }
      def file_to_encoded_url(file)
        path = file.get_absolute_path
        path = (ParseUtil.encode_path(path)).to_s
        if (!path.starts_with("/"))
          path = "/" + path
        end
        if (!path.ends_with("/") && file.is_directory)
          path = path + "/"
        end
        return URL.new("file", "", path)
      end
      
      typesig { [URL] }
      def to_uri(url)
        protocol = url.get_protocol
        auth = url.get_authority
        path = url.get_path
        query = url.get_query
        ref = url.get_ref
        if (!(path).nil? && !(path.starts_with("/")))
          path = "/" + path
        end
        # In java.net.URI class, a port number of -1 implies the default
        # port number. So get it stripped off before creating URI instance.
        if (!(auth).nil? && auth.ends_with(":-1"))
          auth = (auth.substring(0, auth.length - 3)).to_s
        end
        uri = nil
        begin
          uri = create_uri(protocol, auth, path, query, ref)
        rescue Java::Net::URISyntaxException => e
          uri = nil
        end
        return uri
      end
      
      typesig { [String, String, String, String, String] }
      # createURI() and its auxiliary code are cloned from java.net.URI.
      # Most of the code are just copy and paste, except that quote()
      # has been modified to avoid double-escape.
      # 
      # Usually it is unacceptable, but we're forced to do it because
      # otherwise we need to change public API, namely java.net.URI's
      # multi-argument constructors. It turns out that the changes cause
      # incompatibilities so can't be done.
      def create_uri(scheme, authority, path, query, fragment)
        s = to_s(scheme, nil, authority, nil, nil, -1, path, query, fragment)
        check_path(s, scheme, path)
        return URI.new(s)
      end
      
      typesig { [String, String, String, String, String, ::Java::Int, String, String, String] }
      def to_s(scheme, opaque_part, authority, user_info, host, port, path, query, fragment)
        sb = StringBuffer.new
        if (!(scheme).nil?)
          sb.append(scheme)
          sb.append(Character.new(?:.ord))
        end
        append_scheme_specific_part(sb, opaque_part, authority, user_info, host, port, path, query)
        append_fragment(sb, fragment)
        return sb.to_s
      end
      
      typesig { [StringBuffer, String, String, String, String, ::Java::Int, String, String] }
      def append_scheme_specific_part(sb, opaque_part, authority, user_info, host, port, path, query)
        if (!(opaque_part).nil?)
          # check if SSP begins with an IPv6 address
          # because we must not quote a literal IPv6 address
          if (opaque_part.starts_with("//["))
            end_ = opaque_part.index_of("]")
            if (!(end_).equal?(-1) && !(opaque_part.index_of(":")).equal?(-1))
              doquote = nil
              dontquote = nil
              if ((end_).equal?(opaque_part.length))
                dontquote = opaque_part
                doquote = ""
              else
                dontquote = (opaque_part.substring(0, end_ + 1)).to_s
                doquote = (opaque_part.substring(end_ + 1)).to_s
              end
              sb.append(dontquote)
              sb.append(quote(doquote, L_URIC, H_URIC))
            end
          else
            sb.append(quote(opaque_part, L_URIC, H_URIC))
          end
        else
          append_authority(sb, authority, user_info, host, port)
          if (!(path).nil?)
            sb.append(quote(path, L_PATH, H_PATH))
          end
          if (!(query).nil?)
            sb.append(Character.new(??.ord))
            sb.append(quote(query, L_URIC, H_URIC))
          end
        end
      end
      
      typesig { [StringBuffer, String, String, String, ::Java::Int] }
      def append_authority(sb, authority, user_info, host, port)
        if (!(host).nil?)
          sb.append("//")
          if (!(user_info).nil?)
            sb.append(quote(user_info, L_USERINFO, H_USERINFO))
            sb.append(Character.new(?@.ord))
          end
          need_brackets = ((host.index_of(Character.new(?:.ord)) >= 0) && !host.starts_with("[") && !host.ends_with("]"))
          if (need_brackets)
            sb.append(Character.new(?[.ord))
          end
          sb.append(host)
          if (need_brackets)
            sb.append(Character.new(?].ord))
          end
          if (!(port).equal?(-1))
            sb.append(Character.new(?:.ord))
            sb.append(port)
          end
        else
          if (!(authority).nil?)
            sb.append("//")
            if (authority.starts_with("["))
              end_ = authority.index_of("]")
              if (!(end_).equal?(-1) && !(authority.index_of(":")).equal?(-1))
                doquote = nil
                dontquote = nil
                if ((end_).equal?(authority.length))
                  dontquote = authority
                  doquote = ""
                else
                  dontquote = (authority.substring(0, end_ + 1)).to_s
                  doquote = (authority.substring(end_ + 1)).to_s
                end
                sb.append(dontquote)
                sb.append(quote(doquote, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER))
              end
            else
              sb.append(quote(authority, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER))
            end
          end
        end
      end
      
      typesig { [StringBuffer, String] }
      def append_fragment(sb, fragment)
        if (!(fragment).nil?)
          sb.append(Character.new(?#.ord))
          sb.append(quote(fragment, L_URIC, H_URIC))
        end
      end
      
      typesig { [String, ::Java::Long, ::Java::Long] }
      # Quote any characters in s that are not permitted
      # by the given mask pair
      def quote(s, low_mask, high_mask)
        n = s.length
        sb = nil
        allow_non_ascii = (!((low_mask & L_ESCAPED)).equal?(0))
        i = 0
        while i < s.length
          c = s.char_at(i)
          if (c < Character.new(0x0080))
            if (!match(c, low_mask, high_mask) && !is_escaped(s, i))
              if ((sb).nil?)
                sb = StringBuffer.new
                sb.append(s.substring(0, i))
              end
              append_escape(sb, c)
            else
              if (!(sb).nil?)
                sb.append(c)
              end
            end
          else
            if (allow_non_ascii && (Character.is_space_char(c) || Character.is_isocontrol(c)))
              if ((sb).nil?)
                sb = StringBuffer.new
                sb.append(s.substring(0, i))
              end
              append_encoded(sb, c)
            else
              if (!(sb).nil?)
                sb.append(c)
              end
            end
          end
          ((i += 1) - 1)
        end
        return ((sb).nil?) ? s : sb.to_s
      end
      
      typesig { [String, ::Java::Int] }
      # To check if the given string has an escaped triplet
      # at the given position
      def is_escaped(s, pos)
        if ((s).nil? || (s.length <= (pos + 2)))
          return false
        end
        return (s.char_at(pos)).equal?(Character.new(?%.ord)) && match(s.char_at(pos + 1), L_HEX, H_HEX) && match(s.char_at(pos + 2), L_HEX, H_HEX)
      end
      
      typesig { [StringBuffer, ::Java::Char] }
      def append_encoded(sb, c)
        bb = nil
        begin
          bb = ThreadLocalCoders.encoder_for("UTF-8").encode(CharBuffer.wrap("" + (c).to_s))
        rescue CharacterCodingException => x
          raise AssertError if not (false)
        end
        while (bb.has_remaining)
          b = bb.get & 0xff
          if (b >= 0x80)
            append_escape(sb, b)
          else
            sb.append(RJava.cast_to_char(b))
          end
        end
      end
      
      const_set_lazy(:HexDigits) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord)]) }
      const_attr_reader  :HexDigits
      
      typesig { [StringBuffer, ::Java::Byte] }
      def append_escape(sb, b)
        sb.append(Character.new(?%.ord))
        sb.append(HexDigits[(b >> 4) & 0xf])
        sb.append(HexDigits[(b >> 0) & 0xf])
      end
      
      typesig { [::Java::Char, ::Java::Long, ::Java::Long] }
      # Tell whether the given character is permitted by the given mask pair
      def match(c, low_mask, high_mask)
        if (c < 64)
          return !(((1 << c) & low_mask)).equal?(0)
        end
        if (c < 128)
          return !(((1 << (c - 64)) & high_mask)).equal?(0)
        end
        return false
      end
      
      typesig { [String, String, String] }
      # If a scheme is given then the path, if given, must be absolute
      def check_path(s, scheme, path)
        if (!(scheme).nil?)
          if ((!(path).nil?) && ((path.length > 0) && (!(path.char_at(0)).equal?(Character.new(?/.ord)))))
            raise URISyntaxException.new(s, "Relative path in absolute URI")
          end
        end
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # -- Character classes for parsing --
      # Compute a low-order mask for the characters
      # between first and last, inclusive
      def low_mask(first, last)
        m = 0
        f = Math.max(Math.min(first, 63), 0)
        l = Math.max(Math.min(last, 63), 0)
        i = f
        while i <= l
          m |= 1 << i
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [String] }
      # Compute the low-order mask for the characters in the given string
      def low_mask(chars)
        n = chars.length
        m = 0
        i = 0
        while i < n
          c = chars.char_at(i)
          if (c < 64)
            m |= (1 << c)
          end
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Compute a high-order mask for the characters
      # between first and last, inclusive
      def high_mask(first, last)
        m = 0
        f = Math.max(Math.min(first, 127), 64) - 64
        l = Math.max(Math.min(last, 127), 64) - 64
        i = f
        while i <= l
          m |= 1 << i
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [String] }
      # Compute the high-order mask for the characters in the given string
      def high_mask(chars)
        n = chars.length
        m = 0
        i = 0
        while i < n
          c = chars.char_at(i)
          if ((c >= 64) && (c < 128))
            m |= (1 << (c - 64))
          end
          ((i += 1) - 1)
        end
        return m
      end
      
      # Character-class masks
      # digit    = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" |
      # "8" | "9"
      const_set_lazy(:L_DIGIT) { low_mask(Character.new(?0.ord), Character.new(?9.ord)) }
      const_attr_reader  :L_DIGIT
      
      const_set_lazy(:H_DIGIT) { 0 }
      const_attr_reader  :H_DIGIT
      
      # hex           =  digit | "A" | "B" | "C" | "D" | "E" | "F" |
      # "a" | "b" | "c" | "d" | "e" | "f"
      const_set_lazy(:L_HEX) { L_DIGIT }
      const_attr_reader  :L_HEX
      
      const_set_lazy(:H_HEX) { high_mask(Character.new(?A.ord), Character.new(?F.ord)) | high_mask(Character.new(?a.ord), Character.new(?f.ord)) }
      const_attr_reader  :H_HEX
      
      # upalpha  = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" |
      # "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" |
      # "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
      const_set_lazy(:L_UPALPHA) { 0 }
      const_attr_reader  :L_UPALPHA
      
      const_set_lazy(:H_UPALPHA) { high_mask(Character.new(?A.ord), Character.new(?Z.ord)) }
      const_attr_reader  :H_UPALPHA
      
      # lowalpha = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" |
      # "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" |
      # "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
      const_set_lazy(:L_LOWALPHA) { 0 }
      const_attr_reader  :L_LOWALPHA
      
      const_set_lazy(:H_LOWALPHA) { high_mask(Character.new(?a.ord), Character.new(?z.ord)) }
      const_attr_reader  :H_LOWALPHA
      
      # alpha         = lowalpha | upalpha
      const_set_lazy(:L_ALPHA) { L_LOWALPHA | L_UPALPHA }
      const_attr_reader  :L_ALPHA
      
      const_set_lazy(:H_ALPHA) { H_LOWALPHA | H_UPALPHA }
      const_attr_reader  :H_ALPHA
      
      # alphanum      = alpha | digit
      const_set_lazy(:L_ALPHANUM) { L_DIGIT | L_ALPHA }
      const_attr_reader  :L_ALPHANUM
      
      const_set_lazy(:H_ALPHANUM) { H_DIGIT | H_ALPHA }
      const_attr_reader  :H_ALPHANUM
      
      # mark          = "-" | "_" | "." | "!" | "~" | "*" | "'" |
      # "(" | ")"
      const_set_lazy(:L_MARK) { low_mask("-_.!~*'()") }
      const_attr_reader  :L_MARK
      
      const_set_lazy(:H_MARK) { high_mask("-_.!~*'()") }
      const_attr_reader  :H_MARK
      
      # unreserved    = alphanum | mark
      const_set_lazy(:L_UNRESERVED) { L_ALPHANUM | L_MARK }
      const_attr_reader  :L_UNRESERVED
      
      const_set_lazy(:H_UNRESERVED) { H_ALPHANUM | H_MARK }
      const_attr_reader  :H_UNRESERVED
      
      # reserved      = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" |
      # "$" | "," | "[" | "]"
      # Added per RFC2732: "[", "]"
      const_set_lazy(:L_RESERVED) { low_mask(";/?:@&=+$,[]") }
      const_attr_reader  :L_RESERVED
      
      const_set_lazy(:H_RESERVED) { high_mask(";/?:@&=+$,[]") }
      const_attr_reader  :H_RESERVED
      
      # The zero'th bit is used to indicate that escape pairs and non-US-ASCII
      # characters are allowed; this is handled by the scanEscape method below.
      const_set_lazy(:L_ESCAPED) { 1 }
      const_attr_reader  :L_ESCAPED
      
      const_set_lazy(:H_ESCAPED) { 0 }
      const_attr_reader  :H_ESCAPED
      
      # Dash, for use in domainlabel and toplabel
      const_set_lazy(:L_DASH) { low_mask("-") }
      const_attr_reader  :L_DASH
      
      const_set_lazy(:H_DASH) { high_mask("-") }
      const_attr_reader  :H_DASH
      
      # uric          = reserved | unreserved | escaped
      const_set_lazy(:L_URIC) { L_RESERVED | L_UNRESERVED | L_ESCAPED }
      const_attr_reader  :L_URIC
      
      const_set_lazy(:H_URIC) { H_RESERVED | H_UNRESERVED | H_ESCAPED }
      const_attr_reader  :H_URIC
      
      # pchar         = unreserved | escaped |
      # ":" | "@" | "&" | "=" | "+" | "$" | ","
      const_set_lazy(:L_PCHAR) { L_UNRESERVED | L_ESCAPED | low_mask(":@&=+$,") }
      const_attr_reader  :L_PCHAR
      
      const_set_lazy(:H_PCHAR) { H_UNRESERVED | H_ESCAPED | high_mask(":@&=+$,") }
      const_attr_reader  :H_PCHAR
      
      # All valid path characters
      const_set_lazy(:L_PATH) { L_PCHAR | low_mask(";/") }
      const_attr_reader  :L_PATH
      
      const_set_lazy(:H_PATH) { H_PCHAR | high_mask(";/") }
      const_attr_reader  :H_PATH
      
      # userinfo      = *( unreserved | escaped |
      # ";" | ":" | "&" | "=" | "+" | "$" | "," )
      const_set_lazy(:L_USERINFO) { L_UNRESERVED | L_ESCAPED | low_mask(";:&=+$,") }
      const_attr_reader  :L_USERINFO
      
      const_set_lazy(:H_USERINFO) { H_UNRESERVED | H_ESCAPED | high_mask(";:&=+$,") }
      const_attr_reader  :H_USERINFO
      
      # reg_name      = 1*( unreserved | escaped | "$" | "," |
      # ";" | ":" | "@" | "&" | "=" | "+" )
      const_set_lazy(:L_REG_NAME) { L_UNRESERVED | L_ESCAPED | low_mask("$,;:@&=+") }
      const_attr_reader  :L_REG_NAME
      
      const_set_lazy(:H_REG_NAME) { H_UNRESERVED | H_ESCAPED | high_mask("$,;:@&=+") }
      const_attr_reader  :H_REG_NAME
      
      # All valid characters for server-based authorities
      const_set_lazy(:L_SERVER) { L_USERINFO | L_ALPHANUM | L_DASH | low_mask(".:@[]") }
      const_attr_reader  :L_SERVER
      
      const_set_lazy(:H_SERVER) { H_USERINFO | H_ALPHANUM | H_DASH | high_mask(".:@[]") }
      const_attr_reader  :H_SERVER
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__parse_util, :initialize
  end
  
end

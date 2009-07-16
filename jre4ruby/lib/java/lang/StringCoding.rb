require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module StringCodingImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :CharConversionException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio, :BufferOverflowException
      include_const ::Java::Nio, :BufferUnderflowException
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CodingErrorAction
      include_const ::Java::Nio::Charset, :IllegalCharsetNameException
      include_const ::Java::Nio::Charset, :MalformedInputException
      include_const ::Java::Nio::Charset, :UnsupportedCharsetException
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Misc, :MessageUtils
      include_const ::Sun::Nio::Cs, :HistoricallyNamedCharset
    }
  end
  
  # 
  # Utility class for string encoding and decoding.
  class StringCoding 
    include_class_members StringCodingImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # The cached coders for each thread
      
      def decoder
        defined?(@@decoder) ? @@decoder : @@decoder= ThreadLocal.new
      end
      alias_method :attr_decoder, :decoder
      
      def decoder=(value)
        @@decoder = value
      end
      alias_method :attr_decoder=, :decoder=
      
      
      def encoder
        defined?(@@encoder) ? @@encoder : @@encoder= ThreadLocal.new
      end
      alias_method :attr_encoder, :encoder
      
      def encoder=(value)
        @@encoder = value
      end
      alias_method :attr_encoder=, :encoder=
      
      
      def warn_unsupported_charset
        defined?(@@warn_unsupported_charset) ? @@warn_unsupported_charset : @@warn_unsupported_charset= true
      end
      alias_method :attr_warn_unsupported_charset, :warn_unsupported_charset
      
      def warn_unsupported_charset=(value)
        @@warn_unsupported_charset = value
      end
      alias_method :attr_warn_unsupported_charset=, :warn_unsupported_charset=
      
      typesig { [ThreadLocal] }
      def deref(tl)
        sr = tl.get
        if ((sr).nil?)
          return nil
        end
        return sr.get
      end
      
      typesig { [ThreadLocal, Object] }
      def set(tl, ob)
        tl.set(SoftReference.new(ob))
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Charset] }
      # Trim the given byte array to the given length
      def safe_trim(ba, len, cs)
        if ((len).equal?(ba.attr_length) && ((System.get_security_manager).nil? || (cs.get_class.get_class_loader0).nil?))
          return ba
        else
          return Arrays.copy_of(ba, len)
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, Charset] }
      # Trim the given char array to the given length
      def safe_trim(ca, len, cs)
        if ((len).equal?(ca.attr_length) && ((System.get_security_manager).nil? || (cs.get_class.get_class_loader0).nil?))
          return ca
        else
          return Arrays.copy_of(ca, len)
        end
      end
      
      typesig { [::Java::Int, ::Java::Float] }
      def scale(len, expansion_factor)
        # We need to perform double, not float, arithmetic; otherwise
        # we lose low order bits when len is larger than 2**24.
        return RJava.cast_to_int((len * (expansion_factor).to_f))
      end
      
      typesig { [String] }
      def lookup_charset(csn)
        if (Charset.is_supported(csn))
          begin
            return Charset.for_name(csn)
          rescue UnsupportedCharsetException => x
            raise JavaError.new(x)
          end
        end
        return nil
      end
      
      typesig { [String] }
      def warn_unsupported_charset(csn)
        if (self.attr_warn_unsupported_charset)
          # Use sun.misc.MessageUtils rather than the Logging API or
          # System.err since this method may be called during VM
          # initialization before either is available.
          MessageUtils.err("WARNING: Default charset " + csn + " not supported, using ISO-8859-1 instead")
          self.attr_warn_unsupported_charset = false
        end
      end
      
      # -- Decoding --
      const_set_lazy(:StringDecoder) { Class.new do
        include_class_members StringCoding
        
        attr_accessor :requested_charset_name
        alias_method :attr_requested_charset_name, :requested_charset_name
        undef_method :requested_charset_name
        alias_method :attr_requested_charset_name=, :requested_charset_name=
        undef_method :requested_charset_name=
        
        attr_accessor :cs
        alias_method :attr_cs, :cs
        undef_method :cs
        alias_method :attr_cs=, :cs=
        undef_method :cs=
        
        attr_accessor :cd
        alias_method :attr_cd, :cd
        undef_method :cd
        alias_method :attr_cd=, :cd=
        undef_method :cd=
        
        typesig { [Charset, String] }
        def initialize(cs, rcn)
          @requested_charset_name = nil
          @cs = nil
          @cd = nil
          @requested_charset_name = rcn
          @cs = cs
          @cd = cs.new_decoder.on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE)
        end
        
        typesig { [] }
        def charset_name
          if (@cs.is_a?(HistoricallyNamedCharset))
            return (@cs).historical_name
          end
          return @cs.name
        end
        
        typesig { [] }
        def requested_charset_name
          return @requested_charset_name
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def decode(ba, off, len)
          en = scale(len, @cd.max_chars_per_byte)
          ca = CharArray.new(en)
          if ((len).equal?(0))
            return ca
          end
          @cd.reset
          bb = ByteBuffer.wrap(ba, off, len)
          cb = CharBuffer.wrap(ca)
          begin
            cr = @cd.decode(bb, cb, true)
            if (!cr.is_underflow)
              cr.throw_exception
            end
            cr = @cd.flush(cb)
            if (!cr.is_underflow)
              cr.throw_exception
            end
          rescue CharacterCodingException => x
            # Substitution is always enabled,
            # so this shouldn't happen
            raise JavaError.new(x)
          end
          return safe_trim(ca, cb.position, @cs)
        end
        
        private
        alias_method :initialize__string_decoder, :initialize
      end }
      
      typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def decode(charset_name, ba, off, len)
        sd = deref(self.attr_decoder)
        csn = ((charset_name).nil?) ? "ISO-8859-1" : charset_name
        if (((sd).nil?) || !((csn == sd.requested_charset_name) || (csn == sd.charset_name)))
          sd = nil
          begin
            cs = lookup_charset(csn)
            if (!(cs).nil?)
              sd = StringDecoder.new(cs, csn)
            end
          rescue IllegalCharsetNameException => x
          end
          if ((sd).nil?)
            raise UnsupportedEncodingException.new(csn)
          end
          set(self.attr_decoder, sd)
        end
        return sd.decode(ba, off, len)
      end
      
      typesig { [Charset, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def decode(cs, ba, off, len)
        sd = StringDecoder.new(cs, cs.name)
        b = Arrays.copy_of(ba, ba.attr_length)
        return sd.decode(b, off, len)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def decode(ba, off, len)
        csn = Charset.default_charset.name
        begin
          return decode(csn, ba, off, len)
        rescue UnsupportedEncodingException => x
          warn_unsupported_charset(csn)
        end
        begin
          return decode("ISO-8859-1", ba, off, len)
        rescue UnsupportedEncodingException => x
          # If this code is hit during VM initialization, MessageUtils is
          # the only way we will be able to get any kind of error message.
          MessageUtils.err("ISO-8859-1 charset not available: " + (x_.to_s).to_s)
          # If we can not find ISO-8859-1 (a required encoding) then things
          # are seriously wrong with the installation.
          System.exit(1)
          return nil
        end
      end
      
      # -- Encoding --
      const_set_lazy(:StringEncoder) { Class.new do
        include_class_members StringCoding
        
        attr_accessor :cs
        alias_method :attr_cs, :cs
        undef_method :cs
        alias_method :attr_cs=, :cs=
        undef_method :cs=
        
        attr_accessor :ce
        alias_method :attr_ce, :ce
        undef_method :ce
        alias_method :attr_ce=, :ce=
        undef_method :ce=
        
        attr_accessor :requested_charset_name
        alias_method :attr_requested_charset_name, :requested_charset_name
        undef_method :requested_charset_name
        alias_method :attr_requested_charset_name=, :requested_charset_name=
        undef_method :requested_charset_name=
        
        typesig { [Charset, String] }
        def initialize(cs, rcn)
          @cs = nil
          @ce = nil
          @requested_charset_name = nil
          @requested_charset_name = rcn
          @cs = cs
          @ce = cs.new_encoder.on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE)
        end
        
        typesig { [] }
        def charset_name
          if (@cs.is_a?(HistoricallyNamedCharset))
            return (@cs).historical_name
          end
          return @cs.name
        end
        
        typesig { [] }
        def requested_charset_name
          return @requested_charset_name
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        def encode(ca, off, len)
          en = scale(len, @ce.max_bytes_per_char)
          ba = Array.typed(::Java::Byte).new(en) { 0 }
          if ((len).equal?(0))
            return ba
          end
          @ce.reset
          bb = ByteBuffer.wrap(ba)
          cb = CharBuffer.wrap(ca, off, len)
          begin
            cr = @ce.encode(cb, bb, true)
            if (!cr.is_underflow)
              cr.throw_exception
            end
            cr = @ce.flush(bb)
            if (!cr.is_underflow)
              cr.throw_exception
            end
          rescue CharacterCodingException => x
            # Substitution is always enabled,
            # so this shouldn't happen
            raise JavaError.new(x)
          end
          return safe_trim(ba, bb.position, @cs)
        end
        
        private
        alias_method :initialize__string_encoder, :initialize
      end }
      
      typesig { [String, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def encode(charset_name_, ca, off, len)
        se = deref(self.attr_encoder)
        csn = ((charset_name_).nil?) ? "ISO-8859-1" : charset_name_
        if (((se).nil?) || !((csn == se.requested_charset_name) || (csn == se.charset_name)))
          se = nil
          begin
            cs = lookup_charset(csn)
            if (!(cs).nil?)
              se = StringEncoder.new(cs, csn)
            end
          rescue IllegalCharsetNameException => x
          end
          if ((se).nil?)
            raise UnsupportedEncodingException.new(csn)
          end
          set(self.attr_encoder, se)
        end
        return se.encode(ca, off, len)
      end
      
      typesig { [Charset, Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def encode(cs, ca, off, len)
        se = StringEncoder.new(cs, cs.name)
        c = Arrays.copy_of(ca, ca.attr_length)
        return se.encode(c, off, len)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      def encode(ca, off, len)
        csn = Charset.default_charset.name
        begin
          return encode(csn, ca, off, len)
        rescue UnsupportedEncodingException => x
          warn_unsupported_charset(csn)
        end
        begin
          return encode("ISO-8859-1", ca, off, len)
        rescue UnsupportedEncodingException => x
          # If this code is hit during VM initialization, MessageUtils is
          # the only way we will be able to get any kind of error message.
          MessageUtils.err("ISO-8859-1 charset not available: " + (x_.to_s).to_s)
          # If we can not find ISO-8859-1 (a required encoding) then things
          # are seriously wrong with the installation.
          System.exit(1)
          return nil
        end
      end
    }
    
    private
    alias_method :initialize__string_coding, :initialize
  end
  
end

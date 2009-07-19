require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module P11UtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
    }
  end
  
  # Collection of static utility methods.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11Util 
    include_class_members P11UtilImports
    
    class_module.module_eval {
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Object.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      
      def sun
        defined?(@@sun) ? @@sun : @@sun= nil
      end
      alias_method :attr_sun, :sun
      
      def sun=(value)
        @@sun = value
      end
      alias_method :attr_sun=, :sun=
      
      
      def sun_rsa_sign
        defined?(@@sun_rsa_sign) ? @@sun_rsa_sign : @@sun_rsa_sign= nil
      end
      alias_method :attr_sun_rsa_sign, :sun_rsa_sign
      
      def sun_rsa_sign=(value)
        @@sun_rsa_sign = value
      end
      alias_method :attr_sun_rsa_sign=, :sun_rsa_sign=
      
      
      def sun_jce
        defined?(@@sun_jce) ? @@sun_jce : @@sun_jce= nil
      end
      alias_method :attr_sun_jce, :sun_jce
      
      def sun_jce=(value)
        @@sun_jce = value
      end
      alias_method :attr_sun_jce=, :sun_jce=
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_sun_provider
        p = self.attr_sun
        if ((p).nil?)
          synchronized((self.attr_lock)) do
            p = get_provider(self.attr_sun, "SUN", "sun.security.provider.Sun")
            self.attr_sun = p
          end
        end
        return p
      end
      
      typesig { [] }
      def get_sun_rsa_sign_provider
        p = self.attr_sun_rsa_sign
        if ((p).nil?)
          synchronized((self.attr_lock)) do
            p = get_provider(self.attr_sun_rsa_sign, "SunRsaSign", "sun.security.rsa.SunRsaSign")
            self.attr_sun_rsa_sign = p
          end
        end
        return p
      end
      
      typesig { [] }
      def get_sun_jce_provider
        p = self.attr_sun_jce
        if ((p).nil?)
          synchronized((self.attr_lock)) do
            p = get_provider(self.attr_sun_jce, "SunJCE", "com.sun.crypto.provider.SunJCE")
            self.attr_sun_jce = p
          end
        end
        return p
      end
      
      typesig { [Provider, String, String] }
      def get_provider(p, provider_name, class_name)
        if (!(p).nil?)
          return p
        end
        p = Security.get_provider(provider_name)
        if ((p).nil?)
          begin
            clazz = Class.for_name(class_name)
            p = clazz.new_instance
          rescue Exception => e
            raise ProviderException.new("Could not find provider " + provider_name, e)
          end
        end
        return p
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def convert(input, offset, len)
        if (((offset).equal?(0)) && ((len).equal?(input.attr_length)))
          return input
        else
          t = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(input, offset, t, 0, len)
          return t
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def subarray(b, ofs, len)
        out = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(b, ofs, out, 0, len)
        return out
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      def concat(b1, b2)
        b = Array.typed(::Java::Byte).new(b1.attr_length + b2.attr_length) { 0 }
        System.arraycopy(b1, 0, b, 0, b1.attr_length)
        System.arraycopy(b2, 0, b, b1.attr_length, b2.attr_length)
        return b
      end
      
      typesig { [Array.typed(::Java::Long), Array.typed(::Java::Long)] }
      def concat(b1, b2)
        if ((b1.attr_length).equal?(0))
          return b2
        end
        b = Array.typed(::Java::Long).new(b1.attr_length + b2.attr_length) { 0 }
        System.arraycopy(b1, 0, b, 0, b1.attr_length)
        System.arraycopy(b2, 0, b, b1.attr_length, b2.attr_length)
        return b
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # trim leading (most significant) zeroes from the result
      def trim_zeroes(b)
        i = 0
        while ((i < b.attr_length - 1) && ((b[i]).equal?(0)))
          ((i += 1) - 1)
        end
        if ((i).equal?(0))
          return b
        end
        t = Array.typed(::Java::Byte).new(b.attr_length - i) { 0 }
        System.arraycopy(b, i, t, 0, t.attr_length)
        return t
      end
      
      typesig { [BigInteger] }
      def get_magnitude(bi)
        b = bi.to_byte_array
        if ((b.attr_length > 1) && ((b[0]).equal?(0)))
          n = b.attr_length - 1
          newarray = Array.typed(::Java::Byte).new(n) { 0 }
          System.arraycopy(b, 1, newarray, 0, n)
          b = newarray
        end
        return b
      end
      
      typesig { [String] }
      def get_bytes_utf8(s)
        begin
          return s.get_bytes("UTF8")
        rescue Java::Io::UnsupportedEncodingException => e
          raise RuntimeException.new(e)
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def sha1(data)
        begin
          md = MessageDigest.get_instance("SHA-1")
          md.update(data)
          return md.digest
        rescue GeneralSecurityException => e
          raise ProviderException.new(e)
        end
      end
      
      const_set_lazy(:HexDigits) { "0123456789abcdef".to_char_array }
      const_attr_reader  :HexDigits
      
      typesig { [Array.typed(::Java::Byte)] }
      def to_s(b)
        if ((b).nil?)
          return "(null)"
        end
        sb = StringBuffer.new(b.attr_length * 3)
        i = 0
        while i < b.attr_length
          k = b[i] & 0xff
          if (!(i).equal?(0))
            sb.append(Character.new(?:.ord))
          end
          sb.append(HexDigits[k >> 4])
          sb.append(HexDigits[k & 0xf])
          ((i += 1) - 1)
        end
        return sb.to_s
      end
    }
    
    private
    alias_method :initialize__p11util, :initialize
  end
  
end

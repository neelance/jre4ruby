require "rjava"

# Copyright 2004-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Util
  module IPAddressUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Util
    }
  end
  
  class IPAddressUtil 
    include_class_members IPAddressUtilImports
    
    class_module.module_eval {
      const_set_lazy(:INADDR4SZ) { 4 }
      const_attr_reader  :INADDR4SZ
      
      const_set_lazy(:INADDR16SZ) { 16 }
      const_attr_reader  :INADDR16SZ
      
      const_set_lazy(:INT16SZ) { 2 }
      const_attr_reader  :INT16SZ
      
      typesig { [String] }
      # Converts IPv4 address in its textual presentation form
      # into its numeric binary form.
      # 
      # @param src a String representing an IPv4 address in standard format
      # @return a byte array representing the IPv4 numeric address
      def text_to_numeric_format_v4(src)
        if ((src.length).equal?(0))
          return nil
        end
        res = Array.typed(::Java::Byte).new(INADDR4SZ) { 0 }
        s = src.split("\\.", -1)
        val = 0
        begin
          case (s.attr_length)
          when 1
            # When only one part is given, the value is stored directly in
            # the network address without any byte rearrangement.
            val = Long.parse_long(s[0])
            if (val < 0 || val > 0xffffffff)
              return nil
            end
            res[0] = ((val >> 24) & 0xff)
            res[1] = (((val & 0xffffff) >> 16) & 0xff)
            res[2] = (((val & 0xffff) >> 8) & 0xff)
            res[3] = (val & 0xff)
          when 2
            # When a two part address is supplied, the last part is
            # interpreted as a 24-bit quantity and placed in the right
            # most three bytes of the network address. This makes the
            # two part address format convenient for specifying Class A
            # network addresses as net.host.
            val = JavaInteger.parse_int(s[0])
            if (val < 0 || val > 0xff)
              return nil
            end
            res[0] = (val & 0xff)
            val = JavaInteger.parse_int(s[1])
            if (val < 0 || val > 0xffffff)
              return nil
            end
            res[1] = ((val >> 16) & 0xff)
            res[2] = (((val & 0xffff) >> 8) & 0xff)
            res[3] = (val & 0xff)
          when 3
            # When a three part address is specified, the last part is
            # interpreted as a 16-bit quantity and placed in the right
            # most two bytes of the network address. This makes the
            # three part address format convenient for specifying
            # Class B net- work addresses as 128.net.host.
            i = 0
            while i < 2
              val = JavaInteger.parse_int(s[i])
              if (val < 0 || val > 0xff)
                return nil
              end
              res[i] = (val & 0xff)
              i += 1
            end
            val = JavaInteger.parse_int(s[2])
            if (val < 0 || val > 0xffff)
              return nil
            end
            res[2] = ((val >> 8) & 0xff)
            res[3] = (val & 0xff)
          when 4
            # When four parts are specified, each is interpreted as a
            # byte of data and assigned, from left to right, to the
            # four bytes of an IPv4 address.
            i = 0
            while i < 4
              val = JavaInteger.parse_int(s[i])
              if (val < 0 || val > 0xff)
                return nil
              end
              res[i] = (val & 0xff)
              i += 1
            end
          else
            return nil
          end
        rescue NumberFormatException => e
          return nil
        end
        return res
      end
      
      typesig { [String] }
      # Convert IPv6 presentation level address to network order binary form.
      # credit:
      # Converted from C code from Solaris 8 (inet_pton)
      # 
      # Any component of the string following a per-cent % is ignored.
      # 
      # @param src a String representing an IPv6 address in textual format
      # @return a byte array representing the IPv6 numeric address
      def text_to_numeric_format_v6(src)
        # Shortest valid string is "::", hence at least 2 chars
        if (src.length < 2)
          return nil
        end
        colonp = 0
        ch = 0
        saw_xdigit = false
        val = 0
        srcb = src.to_char_array
        dst = Array.typed(::Java::Byte).new(INADDR16SZ) { 0 }
        srcb_length = srcb.attr_length
        pc = src.index_of("%")
        if ((pc).equal?(srcb_length - 1))
          return nil
        end
        if (!(pc).equal?(-1))
          srcb_length = pc
        end
        colonp = -1
        i = 0
        j = 0
        # Leading :: requires some special handling.
        if ((srcb[i]).equal?(Character.new(?:.ord)))
          if (!(srcb[(i += 1)]).equal?(Character.new(?:.ord)))
            return nil
          end
        end
        curtok = i
        saw_xdigit = false
        val = 0
        while (i < srcb_length)
          ch = srcb[((i += 1) - 1)]
          chval = Character.digit(ch, 16)
          if (!(chval).equal?(-1))
            val <<= 4
            val |= chval
            if (val > 0xffff)
              return nil
            end
            saw_xdigit = true
            next
          end
          if ((ch).equal?(Character.new(?:.ord)))
            curtok = i
            if (!saw_xdigit)
              if (!(colonp).equal?(-1))
                return nil
              end
              colonp = j
              next
            else
              if ((i).equal?(srcb_length))
                return nil
              end
            end
            if (j + INT16SZ > INADDR16SZ)
              return nil
            end
            dst[((j += 1) - 1)] = ((val >> 8) & 0xff)
            dst[((j += 1) - 1)] = (val & 0xff)
            saw_xdigit = false
            val = 0
            next
          end
          if ((ch).equal?(Character.new(?..ord)) && ((j + INADDR4SZ) <= INADDR16SZ))
            ia4 = src.substring(curtok, srcb_length)
            # check this IPv4 address has 3 dots, ie. A.B.C.D
            dot_count = 0
            index = 0
            while (!((index = ia4.index_of(Character.new(?..ord), index))).equal?(-1))
              dot_count += 1
              index += 1
            end
            if (!(dot_count).equal?(3))
              return nil
            end
            v4addr = text_to_numeric_format_v4(ia4)
            if ((v4addr).nil?)
              return nil
            end
            k = 0
            while k < INADDR4SZ
              dst[((j += 1) - 1)] = v4addr[k]
              k += 1
            end
            saw_xdigit = false
            break
            # '\0' was seen by inet_pton4().
          end
          return nil
        end
        if (saw_xdigit)
          if (j + INT16SZ > INADDR16SZ)
            return nil
          end
          dst[((j += 1) - 1)] = ((val >> 8) & 0xff)
          dst[((j += 1) - 1)] = (val & 0xff)
        end
        if (!(colonp).equal?(-1))
          n = j - colonp
          if ((j).equal?(INADDR16SZ))
            return nil
          end
          i = 1
          while i <= n
            dst[INADDR16SZ - i] = dst[colonp + n - i]
            dst[colonp + n - i] = 0
            i += 1
          end
          j = INADDR16SZ
        end
        if (!(j).equal?(INADDR16SZ))
          return nil
        end
        newdst = convert_from_ipv4mapped_address(dst)
        if (!(newdst).nil?)
          return newdst
        else
          return dst
        end
      end
      
      typesig { [String] }
      # @param src a String representing an IPv4 address in textual format
      # @return a boolean indicating whether src is an IPv4 literal address
      def is_ipv4literal_address(src)
        return !(text_to_numeric_format_v4(src)).nil?
      end
      
      typesig { [String] }
      # @param src a String representing an IPv6 address in textual format
      # @return a boolean indicating whether src is an IPv6 literal address
      def is_ipv6literal_address(src)
        return !(text_to_numeric_format_v6(src)).nil?
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Convert IPv4-Mapped address to IPv4 address. Both input and
      # returned value are in network order binary form.
      # 
      # @param src a String representing an IPv4-Mapped address in textual format
      # @return a byte array representing the IPv4 numeric address
      def convert_from_ipv4mapped_address(addr)
        if (is_ipv4mapped_address(addr))
          new_addr = Array.typed(::Java::Byte).new(INADDR4SZ) { 0 }
          System.arraycopy(addr, 12, new_addr, 0, INADDR4SZ)
          return new_addr
        end
        return nil
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Utility routine to check if the InetAddress is an
      # IPv4 mapped IPv6 address.
      # 
      # @return a <code>boolean</code> indicating if the InetAddress is
      # an IPv4 mapped IPv6 address; or false if address is IPv4 address.
      def is_ipv4mapped_address(addr)
        if (addr.attr_length < INADDR16SZ)
          return false
        end
        if (((addr[0]).equal?(0x0)) && ((addr[1]).equal?(0x0)) && ((addr[2]).equal?(0x0)) && ((addr[3]).equal?(0x0)) && ((addr[4]).equal?(0x0)) && ((addr[5]).equal?(0x0)) && ((addr[6]).equal?(0x0)) && ((addr[7]).equal?(0x0)) && ((addr[8]).equal?(0x0)) && ((addr[9]).equal?(0x0)) && ((addr[10]).equal?(0xff)) && ((addr[11]).equal?(0xff)))
          return true
        end
        return false
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__ipaddress_util, :initialize
  end
  
end

require "rjava"

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
module Sun::Security::Jgss
  module GSSHeaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Org::Ietf::Jgss, :GSSException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This class represents the mechanism independent part of a GSS-API
  # context establishment token. Some mechanisms may choose to encode
  # all subsequent tokens as well such that they start with an encoding
  # of an instance of this class. e.g., The Kerberos v5 GSS-API Mechanism
  # uses this header for all GSS-API tokens.
  # <p>
  # The format is specified in RFC 2743 section 3.1.
  # 
  # @author Mayank Upadhyay
  # 
  # 
  # The RFC states that implementations should explicitly follow the
  # encoding scheme descibed in this section rather than use ASN.1
  # compilers. However, we should consider removing duplicate ASN.1
  # like code from here and depend on sun.security.util if possible.
  class GSSHeader 
    include_class_members GSSHeaderImports
    
    attr_accessor :mech_oid
    alias_method :attr_mech_oid, :mech_oid
    undef_method :mech_oid
    alias_method :attr_mech_oid=, :mech_oid=
    undef_method :mech_oid=
    
    attr_accessor :mech_oid_bytes
    alias_method :attr_mech_oid_bytes, :mech_oid_bytes
    undef_method :mech_oid_bytes
    alias_method :attr_mech_oid_bytes=, :mech_oid_bytes=
    undef_method :mech_oid_bytes=
    
    attr_accessor :mech_token_length
    alias_method :attr_mech_token_length, :mech_token_length
    undef_method :mech_token_length
    alias_method :attr_mech_token_length=, :mech_token_length=
    undef_method :mech_token_length=
    
    class_module.module_eval {
      # The tag defined in the GSS-API mechanism independent token
      # format.
      const_set_lazy(:TOKEN_ID) { 0x60 }
      const_attr_reader  :TOKEN_ID
    }
    
    typesig { [ObjectIdentifier, ::Java::Int] }
    # Creates a GSSHeader instance whose encoding can be used as the
    # prefix for a particular mechanism token.
    # @param mechOid the Oid of the mechanism which generated the token
    # @param mechTokenLength the length of the subsequent portion that
    # the mechanism will be adding.
    def initialize(mech_oid, mech_token_length)
      @mech_oid = nil
      @mech_oid_bytes = nil
      @mech_token_length = 0
      @mech_oid = mech_oid
      temp = DerOutputStream.new
      temp.put_oid(mech_oid)
      @mech_oid_bytes = temp.to_byte_array
      @mech_token_length = mech_token_length
    end
    
    typesig { [InputStream] }
    # Reads in a GSSHeader from an InputStream. Typically this would be
    # used as part of reading the complete token from an InputStream
    # that is obtained from a socket.
    def initialize(is)
      @mech_oid = nil
      @mech_oid_bytes = nil
      @mech_token_length = 0
      # debug("Parsing GSS token: ");
      tag = is.read
      # debug("tag=" + tag);
      if (!(tag).equal?(TOKEN_ID))
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "GSSHeader did not find the right tag")
      end
      length = get_length(is)
      temp = DerValue.new(is)
      @mech_oid_bytes = temp.to_byte_array
      @mech_oid = temp.get_oid
      # debug (" oid=" + mechOid);
      # debug (" len starting with oid=" + length);
      @mech_token_length = length - @mech_oid_bytes.attr_length
      # debug("  mechToken length=" + mechTokenLength);
    end
    
    typesig { [] }
    # Used to obtain the Oid stored in this GSSHeader instance.
    # @return the Oid of the mechanism.
    def get_oid
      return @mech_oid
    end
    
    typesig { [] }
    # Used to obtain the length of the mechanism specific token that
    # will follow the encoding of this GSSHeader instance.
    # @return the length of the mechanism specific token portion that
    # will follow this GSSHeader.
    def get_mech_token_length
      return @mech_token_length
    end
    
    typesig { [] }
    # Used to obtain the length of the encoding of this GSSHeader.
    # @return the lenght of the encoding of this GSSHeader instance.
    def get_length
      len_field = @mech_oid_bytes.attr_length + @mech_token_length
      return (1 + get_len_field_size(len_field) + @mech_oid_bytes.attr_length)
    end
    
    class_module.module_eval {
      typesig { [ObjectIdentifier, ::Java::Int] }
      # Used to determine what the maximum possible mechanism token
      # size is if the complete GSSToken returned to the application
      # (including a GSSHeader) is not to exceed some pre-determined
      # value in size.
      # @param mechOid the Oid of the mechanism that will generate
      # this GSS-API token
      # @param maxTotalSize the pre-determined value that serves as a
      # maximum size for the complete GSS-API token (including a
      # GSSHeader)
      # @return the maximum size of mechanism token that can be used
      # so as to not exceed maxTotalSize with the GSS-API token
      def get_max_mech_token_size(mech_oid, max_total_size)
        mech_oid_bytes_size = 0
        begin
          temp = DerOutputStream.new
          temp.put_oid(mech_oid)
          mech_oid_bytes_size = temp.to_byte_array.attr_length
        rescue IOException => e
        end
        # Subtract bytes needed for 0x60 tag and mechOidBytes
        max_total_size -= (1 + mech_oid_bytes_size)
        # Subtract maximum len bytes
        max_total_size -= 5
        return max_total_size
        # Len field and mechanism token must fit in remaining
        # space. The range of the len field that we allow is
        # 1 through 5.
        # 
        # 
        # int mechTokenSize = 0;
        # for (int lenFieldSize = 1; lenFieldSize <= 5;
        # lenFieldSize++) {
        # mechTokenSize = maxTotalSize - lenFieldSize;
        # if (getLenFieldSize(mechTokenSize + mechOidBytesSize +
        # lenFieldSize) <= lenFieldSize)
        # break;
        # }
        # 
        # return mechTokenSize;
      end
    }
    
    typesig { [::Java::Int] }
    # Used to determine the number of bytes that will be need to encode
    # the length field of the GSSHeader.
    def get_len_field_size(len)
      ret_val = 1
      if (len < 128)
        ret_val = 1
      else
        if (len < (1 << 8))
          ret_val = 2
        else
          if (len < (1 << 16))
            ret_val = 3
          else
            if (len < (1 << 24))
              ret_val = 4
            else
              ret_val = 5 # See getMaxMechTokenSize
            end
          end
        end
      end
      return ret_val
    end
    
    typesig { [OutputStream] }
    # Encodes this GSSHeader instance onto the provided OutputStream.
    # @param os the OutputStream to which the token should be written.
    # @return the number of bytes that are output as a result of this
    # encoding
    def encode(os)
      ret_val = 1 + @mech_oid_bytes.attr_length
      os.write(TOKEN_ID)
      length = @mech_oid_bytes.attr_length + @mech_token_length
      ret_val += put_length(length, os)
      os.write(@mech_oid_bytes)
      return ret_val
    end
    
    typesig { [InputStream] }
    # Get a length from the input stream, allowing for at most 32 bits of
    # encoding to be used. (Not the same as getting a tagged integer!)
    # 
    # @return the length or -1 if indefinite length found.
    # @exception IOException on parsing error or unsupported lengths.
    # 
    # shameless lifted from sun.security.util.DerInputStream.
    def get_length(in_)
      return get_length(in_.read, in_)
    end
    
    typesig { [::Java::Int, InputStream] }
    # Get a length from the input stream, allowing for at most 32 bits of
    # encoding to be used. (Not the same as getting a tagged integer!)
    # 
    # @return the length or -1 if indefinite length found.
    # @exception IOException on parsing error or unsupported lengths.
    # 
    # shameless lifted from sun.security.util.DerInputStream.
    def get_length(len_byte, in_)
      value = 0
      tmp = 0
      tmp = len_byte
      if (((tmp & 0x80)).equal?(0x0))
        # short form, 1 byte datum
        value = tmp
      else
        # long form or indefinite
        tmp &= 0x7f
        # NOTE:  tmp == 0 indicates indefinite length encoded data.
        # tmp > 4 indicates more than 4Gb of data.
        if ((tmp).equal?(0))
          return -1
        end
        if (tmp < 0 || tmp > 4)
          raise IOException.new("DerInputStream.getLength(): lengthTag=" + RJava.cast_to_string(tmp) + ", " + RJava.cast_to_string(((tmp < 0) ? "incorrect DER encoding." : "too big.")))
        end
        value = 0
        while tmp > 0
          value <<= 8
          value += 0xff & in_.read
          tmp -= 1
        end
      end
      return value
    end
    
    typesig { [::Java::Int, OutputStream] }
    # Put the encoding of the length in the specified stream.
    # 
    # @params len the length of the attribute.
    # @param out the outputstream to write the length to
    # @return the number of bytes written
    # @exception IOException on writing errors.
    # 
    # Shameless lifted from sun.security.util.DerOutputStream.
    def put_length(len, out)
      ret_val = 0
      if (len < 128)
        out.write(len)
        ret_val = 1
      else
        if (len < (1 << 8))
          out.write(0x81)
          out.write(len)
          ret_val = 2
        else
          if (len < (1 << 16))
            out.write(0x82)
            out.write((len >> 8))
            out.write(len)
            ret_val = 3
          else
            if (len < (1 << 24))
              out.write(0x83)
              out.write((len >> 16))
              out.write((len >> 8))
              out.write(len)
              ret_val = 4
            else
              out.write(0x84)
              out.write((len >> 24))
              out.write((len >> 16))
              out.write((len >> 8))
              out.write(len)
              ret_val = 5
            end
          end
        end
      end
      return ret_val
    end
    
    typesig { [String] }
    # XXX Call these two in some central class
    def debug(str)
      System.err.print(str)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def get_hex_bytes(bytes, len)
      sb = StringBuffer.new
      i = 0
      while i < len
        b1 = (bytes[i] >> 4) & 0xf
        b2 = bytes[i] & 0xf
        sb.append(JavaInteger.to_hex_string(b1))
        sb.append(JavaInteger.to_hex_string(b2))
        sb.append(Character.new(?\s.ord))
        i += 1
      end
      return sb.to_s
    end
    
    private
    alias_method :initialize__gssheader, :initialize
  end
  
end

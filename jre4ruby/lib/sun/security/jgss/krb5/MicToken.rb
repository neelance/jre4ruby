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
module Sun::Security::Jgss::Krb5
  module MicTokenImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :ByteArrayOutputStream
    }
  end
  
  class MicToken < MicTokenImports.const_get :MessageToken
    include_class_members MicTokenImports
    
    typesig { [Krb5Context, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, MessageProp] }
    def initialize(context, token_bytes, token_offset, token_len, prop)
      super(Krb5Token::MIC_ID, context, token_bytes, token_offset, token_len, prop)
    end
    
    typesig { [Krb5Context, InputStream, MessageProp] }
    def initialize(context, is, prop)
      super(Krb5Token::MIC_ID, context, is, prop)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def verify(data, offset, len)
      if (!verify_sign_and_seq_number(nil, data, offset, len, nil))
        raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum or sequence number in MIC token")
      end
    end
    
    typesig { [InputStream] }
    def verify(data)
      data_bytes = nil
      begin
        data_bytes = Array.typed(::Java::Byte).new(data.available) { 0 }
        data.read(data_bytes)
      rescue IOException => e
        # Error reading application data
        raise GSSException.new(GSSException::BAD_MIC, -1, "Corrupt checksum or sequence number in MIC token")
      end
      verify(data_bytes, 0, data_bytes.attr_length)
    end
    
    typesig { [Krb5Context, MessageProp, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def initialize(context, prop, data, pos, len)
      super(Krb5Token::MIC_ID, context)
      # debug("Application data to MicToken verify is [" +
      # getHexBytes(data, pos, len) + "]\n");
      if ((prop).nil?)
        prop = MessageProp.new(0, false)
      end
      gen_sign_and_seq_number(prop, nil, data, pos, len, nil)
    end
    
    typesig { [Krb5Context, MessageProp, InputStream] }
    def initialize(context, prop, data)
      super(Krb5Token::MIC_ID, context)
      data_bytes = Array.typed(::Java::Byte).new(data.available) { 0 }
      data.read(data_bytes)
      # debug("Application data to MicToken cons is [" +
      # getHexBytes(dataBytes) + "]\n");
      if ((prop).nil?)
        prop = MessageProp.new(0, false)
      end
      gen_sign_and_seq_number(prop, nil, data_bytes, 0, data_bytes.attr_length, nil)
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    def get_seal_alg(conf_requested, qop)
      return (SEAL_ALG_NONE)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def encode(out_token, offset)
      # Token  is small
      bos = ByteArrayOutputStream.new
      super(bos)
      token = bos.to_byte_array
      System.arraycopy(token, 0, out_token, offset, token.attr_length)
      return token.attr_length
    end
    
    typesig { [] }
    def encode
      # XXX Fine tune this initial size
      bos = ByteArrayOutputStream.new(50)
      encode(bos)
      return bos.to_byte_array
    end
    
    private
    alias_method :initialize__mic_token, :initialize
  end
  
end

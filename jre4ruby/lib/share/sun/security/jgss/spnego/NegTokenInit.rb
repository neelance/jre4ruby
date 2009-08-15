require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Spnego
  module NegTokenInitImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spnego
      include ::Java::Io
      include ::Java::Util
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss
      include ::Sun::Security::Util
    }
  end
  
  # Implements the SPNEGO NegTokenInit token
  # as specified in RFC 2478
  # 
  # NegTokenInit ::= SEQUENCE {
  # mechTypes       [0] MechTypeList  OPTIONAL,
  # reqFlags        [1] ContextFlags  OPTIONAL,
  # mechToken       [2] OCTET STRING  OPTIONAL,
  # mechListMIC     [3] OCTET STRING  OPTIONAL
  # }
  # 
  # MechTypeList ::= SEQUENCE OF MechType
  # 
  # MechType::= OBJECT IDENTIFIER
  # 
  # ContextFlags ::= BIT STRING {
  # delegFlag       (0),
  # mutualFlag      (1),
  # replayFlag      (2),
  # sequenceFlag    (3),
  # anonFlag        (4),
  # confFlag        (5),
  # integFlag       (6)
  # }
  # 
  # @author Seema Malkani
  # @since 1.6
  class NegTokenInit < NegTokenInitImports.const_get :SpNegoToken
    include_class_members NegTokenInitImports
    
    # DER-encoded mechTypes
    attr_accessor :mech_types
    alias_method :attr_mech_types, :mech_types
    undef_method :mech_types
    alias_method :attr_mech_types=, :mech_types=
    undef_method :mech_types=
    
    attr_accessor :mech_type_list
    alias_method :attr_mech_type_list, :mech_type_list
    undef_method :mech_type_list
    alias_method :attr_mech_type_list=, :mech_type_list=
    undef_method :mech_type_list=
    
    attr_accessor :req_flags
    alias_method :attr_req_flags, :req_flags
    undef_method :req_flags
    alias_method :attr_req_flags=, :req_flags=
    undef_method :req_flags=
    
    attr_accessor :mech_token
    alias_method :attr_mech_token, :mech_token
    undef_method :mech_token
    alias_method :attr_mech_token=, :mech_token=
    undef_method :mech_token=
    
    attr_accessor :mech_list_mic
    alias_method :attr_mech_list_mic, :mech_list_mic
    undef_method :mech_list_mic
    alias_method :attr_mech_list_mic=, :mech_list_mic=
    undef_method :mech_list_mic=
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def initialize(mech_types, flags, token, mech_list_mic)
      @mech_types = nil
      @mech_type_list = nil
      @req_flags = nil
      @mech_token = nil
      @mech_list_mic = nil
      super(NEG_TOKEN_INIT_ID)
      @mech_types = nil
      @mech_type_list = nil
      @req_flags = nil
      @mech_token = nil
      @mech_list_mic = nil
      @mech_types = mech_types
      @req_flags = flags
      @mech_token = token
      @mech_list_mic = mech_list_mic
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Used by sun.security.jgss.wrapper.NativeGSSContext
    # to parse SPNEGO tokens
    def initialize(in_)
      @mech_types = nil
      @mech_type_list = nil
      @req_flags = nil
      @mech_token = nil
      @mech_list_mic = nil
      super(NEG_TOKEN_INIT_ID)
      @mech_types = nil
      @mech_type_list = nil
      @req_flags = nil
      @mech_token = nil
      @mech_list_mic = nil
      parse_token(in_)
    end
    
    typesig { [] }
    def encode
      begin
        # create negInitToken
        init_token = DerOutputStream.new
        # DER-encoded mechTypes with CONTEXT 00
        if (!(@mech_types).nil?)
          init_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), @mech_types)
        end
        # write context flags with CONTEXT 01
        if (!(@req_flags).nil?)
          flags = DerOutputStream.new
          flags.put_bit_string(@req_flags)
          init_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), flags)
        end
        # mechToken with CONTEXT 02
        if (!(@mech_token).nil?)
          data_value = DerOutputStream.new
          data_value.put_octet_string(@mech_token)
          init_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), data_value)
        end
        # mechListMIC with CONTEXT 03
        if (!(@mech_list_mic).nil?)
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenInit: " + "sending MechListMIC")
          end
          mic = DerOutputStream.new
          mic.put_octet_string(@mech_list_mic)
          init_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), mic)
        end
        # insert in a SEQUENCE
        out = DerOutputStream.new
        out.write(DerValue.attr_tag_sequence, init_token)
        return out.to_byte_array
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid SPNEGO NegTokenInit token : " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def parse_token(in_)
      begin
        der = DerValue.new(in_)
        # verify NegotiationToken type token
        if (!der.is_context_specific(NEG_TOKEN_INIT_ID))
          raise IOException.new("SPNEGO NegoTokenInit : " + "did not have right token type")
        end
        tmp1 = der.attr_data.get_der_value
        if (!(tmp1.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("SPNEGO NegoTokenInit : " + "did not have the Sequence tag")
        end
        # parse SEQUENCE of mechTypes, if present
        if (tmp1.attr_data.available > 0)
          tmp2 = tmp1.attr_data.get_der_value
          if (!tmp2.is_context_specific(0x0))
            raise IOException.new("SPNEGO NegoTokenInit : " + "did not have the right context tag for mechTypes")
          end
          # get the DER-encoded sequence of mechTypes
          m_value = tmp2.attr_data
          @mech_types = m_value.to_byte_array
          # read all the mechTypes
          m_list = m_value.get_sequence(0)
          @mech_type_list = Array.typed(Oid).new(m_list.attr_length) { nil }
          mech = nil
          i = 0
          while i < m_list.attr_length
            mech = m_list[i].get_oid
            if (DEBUG)
              System.out.println("SpNegoToken NegTokenInit: " + "reading Mechanism Oid = " + RJava.cast_to_string(mech))
            end
            @mech_type_list[i] = Oid.new(mech.to_s)
            i += 1
          end
        end
        # parse mechToken, if present (skip reqFlags)
        if (tmp1.attr_data.available > 0)
          tmp3 = tmp1.attr_data.get_der_value
          if (tmp3.is_context_specific(0x1))
            # received reqFlags, skip it
            # now parse next field mechToken
            if (tmp1.attr_data.available > 0)
              tmp3 = tmp1.attr_data.get_der_value
            end
          end
          if (!tmp3.is_context_specific(0x2))
            raise IOException.new("SPNEGO NegoTokenInit : " + "did not have the right context tag for mechToken")
          end
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenInit: " + "reading Mech Token")
          end
          @mech_token = tmp3.attr_data.get_octet_string
        end
        # parse mechListMIC, if present and not in MS interop mode
        if (!GSSUtil.use_msinterop && (tmp1.attr_data.available > 0))
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenInit: " + "receiving MechListMIC")
          end
          tmp6 = tmp1.attr_data.get_der_value
          if (!tmp6.is_context_specific(0x3))
            raise IOException.new("SPNEGO NegoTokenInit : " + "did not have the right context tag for MICToken")
          end
          @mech_list_mic = tmp6.attr_data.get_octet_string
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenInit: " + "MechListMIC Token = " + RJava.cast_to_string(get_hex_bytes(@mech_list_mic)))
          end
        else
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenInit : " + "no MIC token included")
          end
        end
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid SPNEGO NegTokenInit token : " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [] }
    def get_mech_types
      return @mech_types
    end
    
    typesig { [] }
    # Used by sun.security.jgss.wrapper.NativeGSSContext
    # to find the mechs in SPNEGO tokens
    def get_mech_type_list
      return @mech_type_list
    end
    
    typesig { [] }
    def get_req_flags
      return @req_flags
    end
    
    typesig { [] }
    # Used by sun.security.jgss.wrapper.NativeGSSContext
    # to access the mech token portion of SPNEGO tokens
    def get_mech_token
      return @mech_token
    end
    
    typesig { [] }
    def get_mech_list_mic
      return @mech_list_mic
    end
    
    private
    alias_method :initialize__neg_token_init, :initialize
  end
  
end

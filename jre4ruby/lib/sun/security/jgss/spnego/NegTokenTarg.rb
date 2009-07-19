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
  module NegTokenTargImports
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
  
  # Implements the SPNEGO NegTokenTarg token
  # as specified in RFC 2478
  # 
  # NegTokenTarg ::= SEQUENCE {
  # negResult   [0] ENUMERATED {
  # accept_completed        (0),
  # accept_incomplete       (1),
  # reject                  (2) }   OPTIONAL,
  # supportedMech   [1] MechType            OPTIONAL,
  # responseToken   [2] OCTET STRING        OPTIONAL,
  # mechListMIC     [3] OCTET STRING        OPTIONAL
  # }
  # 
  # MechType::= OBJECT IDENTIFIER
  # 
  # 
  # @author Seema Malkani
  # @since 1.6
  class NegTokenTarg < NegTokenTargImports.const_get :SpNegoToken
    include_class_members NegTokenTargImports
    
    attr_accessor :neg_result
    alias_method :attr_neg_result, :neg_result
    undef_method :neg_result
    alias_method :attr_neg_result=, :neg_result=
    undef_method :neg_result=
    
    attr_accessor :supported_mech
    alias_method :attr_supported_mech, :supported_mech
    undef_method :supported_mech
    alias_method :attr_supported_mech=, :supported_mech=
    undef_method :supported_mech=
    
    attr_accessor :response_token
    alias_method :attr_response_token, :response_token
    undef_method :response_token
    alias_method :attr_response_token=, :response_token=
    undef_method :response_token=
    
    attr_accessor :mech_list_mic
    alias_method :attr_mech_list_mic, :mech_list_mic
    undef_method :mech_list_mic
    alias_method :attr_mech_list_mic=, :mech_list_mic=
    undef_method :mech_list_mic=
    
    typesig { [::Java::Int, Oid, Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def initialize(result, mech, token, mech_list_mic)
      @neg_result = 0
      @supported_mech = nil
      @response_token = nil
      @mech_list_mic = nil
      super(NEG_TOKEN_TARG_ID)
      @neg_result = 0
      @supported_mech = nil
      @response_token = nil
      @mech_list_mic = nil
      @neg_result = result
      @supported_mech = mech
      @response_token = token
      @mech_list_mic = mech_list_mic
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Used by sun.security.jgss.wrapper.NativeGSSContext
    # to parse SPNEGO tokens
    def initialize(in_)
      @neg_result = 0
      @supported_mech = nil
      @response_token = nil
      @mech_list_mic = nil
      super(NEG_TOKEN_TARG_ID)
      @neg_result = 0
      @supported_mech = nil
      @response_token = nil
      @mech_list_mic = nil
      parse_token(in_)
    end
    
    typesig { [] }
    def encode
      begin
        # create negTargToken
        targ_token = DerOutputStream.new
        # write the negotiated result with CONTEXT 00
        result = DerOutputStream.new
        result.put_enumerated(@neg_result)
        targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), result)
        # supportedMech with CONTEXT 01
        if (!(@supported_mech).nil?)
          mech = DerOutputStream.new
          mech_type = @supported_mech.get_der
          mech.write(mech_type)
          targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), mech)
        end
        # response Token with CONTEXT 02
        if (!(@response_token).nil?)
          rsp_token = DerOutputStream.new
          rsp_token.put_octet_string(@response_token)
          targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x2), rsp_token)
        end
        # mechListMIC with CONTEXT 03
        if (!(@mech_list_mic).nil?)
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg: " + "sending MechListMIC")
          end
          mic = DerOutputStream.new
          mic.put_octet_string(@mech_list_mic)
          targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), mic)
        else
          if (GSSUtil.use_msinterop)
            # required for MS-interoperability
            if (!(@response_token).nil?)
              if (DEBUG)
                System.out.println("SpNegoToken NegTokenTarg: " + "sending additional token for MS Interop")
              end
              rsp_token = DerOutputStream.new
              rsp_token.put_octet_string(@response_token)
              targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x3), rsp_token)
            end
          end
        end
        # insert in a SEQUENCE
        out = DerOutputStream.new
        out.write(DerValue.attr_tag_sequence, targ_token)
        return out.to_byte_array
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid SPNEGO NegTokenTarg token : " + (e.get_message).to_s)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def parse_token(in_)
      begin
        der = DerValue.new(in_)
        # verify NegotiationToken type token
        if (!der.is_context_specific(NEG_TOKEN_TARG_ID))
          raise IOException.new("SPNEGO NegoTokenTarg : " + "did not have the right token type")
        end
        tmp1 = der.attr_data.get_der_value
        if (!(tmp1.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("SPNEGO NegoTokenTarg : " + "did not have the Sequence tag")
        end
        # parse negResult, if present
        if (tmp1.attr_data.available > 0)
          tmp2 = tmp1.attr_data.get_der_value
          if (!tmp2.is_context_specific(0x0))
            raise IOException.new("SPNEGO NegoTokenTarg : " + "did not have the right context tag for negResult")
          end
          @neg_result = tmp2.attr_data.get_enumerated
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg: negotiated" + " result = " + (get_nego_result_string(@neg_result)).to_s)
          end
        end
        # parse supportedMech, if present
        if (tmp1.attr_data.available > 0)
          tmp3 = tmp1.attr_data.get_der_value
          if (!tmp3.is_context_specific(0x1))
            raise IOException.new("SPNEGO NegoTokenTarg : " + "did not have the right context tag for supportedMech")
          end
          mech = tmp3.attr_data.get_oid
          @supported_mech = Oid.new(mech.to_s)
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg: " + "supported mechanism = " + (@supported_mech).to_s)
          end
        end
        # parse ResponseToken, if present
        if (tmp1.attr_data.available > 0)
          tmp4 = tmp1.attr_data.get_der_value
          if (!tmp4.is_context_specific(0x2))
            raise IOException.new("SPNEGO NegoTokenTarg : did not" + " have the right context tag for response token")
          end
          @response_token = tmp4.attr_data.get_octet_string
        end
        # parse mechListMIC if present and not in MS interop
        if (!GSSUtil.use_msinterop && (tmp1.attr_data.available > 0))
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg: " + "receiving MechListMIC")
          end
          tmp5 = tmp1.attr_data.get_der_value
          if (!tmp5.is_context_specific(0x3))
            raise IOException.new("SPNEGO NegoTokenTarg : " + "did not have the right context tag for mechListMIC")
          end
          @mech_list_mic = tmp5.attr_data.get_octet_string
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg: " + "MechListMIC Token = " + (get_hex_bytes(@mech_list_mic)).to_s)
          end
        else
          if (DEBUG)
            System.out.println("SpNegoToken NegTokenTarg : " + "no MIC token included")
          end
        end
      rescue IOException => e
        raise GSSException.new(GSSException::DEFECTIVE_TOKEN, -1, "Invalid SPNEGO NegTokenTarg token : " + (e.get_message).to_s)
      end
    end
    
    typesig { [] }
    def get_negotiated_result
      return @neg_result
    end
    
    typesig { [] }
    # Used by sun.security.jgss.wrapper.NativeGSSContext
    # to find the supported mech in SPNEGO tokens
    def get_supported_mech
      return @supported_mech
    end
    
    typesig { [] }
    def get_response_token
      return @response_token
    end
    
    typesig { [] }
    def get_mech_list_mic
      return @mech_list_mic
    end
    
    private
    alias_method :initialize__neg_token_targ, :initialize
  end
  
end

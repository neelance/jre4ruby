require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SpNegoTokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Spnego
      include ::Java::Io
      include ::Java::Util
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Util
      include ::Sun::Security::Jgss
    }
  end
  
  # Astract class for SPNEGO tokens.
  # Implementation is based on RFC 2478
  # 
  # NegotiationToken ::= CHOICE {
  # negTokenInit  [0]        NegTokenInit,
  # negTokenTarg  [1]        NegTokenTarg }
  # 
  # 
  # @author Seema Malkani
  # @since 1.6
  class SpNegoToken < SpNegoTokenImports.const_get :GSSToken
    include_class_members SpNegoTokenImports
    
    class_module.module_eval {
      const_set_lazy(:NEG_TOKEN_INIT_ID) { 0x0 }
      const_attr_reader  :NEG_TOKEN_INIT_ID
      
      const_set_lazy(:NEG_TOKEN_TARG_ID) { 0x1 }
      const_attr_reader  :NEG_TOKEN_TARG_ID
      
      const_set_lazy(:ACCEPT_COMPLETE) { NegoResult::ACCEPT_COMPLETE }
      const_attr_reader  :ACCEPT_COMPLETE
      
      const_set_lazy(:ACCEPT_INCOMPLETE) { NegoResult::ACCEPT_INCOMPLETE }
      const_attr_reader  :ACCEPT_INCOMPLETE
      
      const_set_lazy(:REJECT) { NegoResult::REJECT }
      const_attr_reader  :REJECT
      
      class NegoResult 
        include_class_members SpNegoToken
        
        class_module.module_eval {
          const_set_lazy(:ACCEPT_COMPLETE) { NegoResult.new.set_value_name("ACCEPT_COMPLETE") }
          const_attr_reader  :ACCEPT_COMPLETE
          
          const_set_lazy(:ACCEPT_INCOMPLETE) { NegoResult.new.set_value_name("ACCEPT_INCOMPLETE") }
          const_attr_reader  :ACCEPT_INCOMPLETE
          
          const_set_lazy(:REJECT) { NegoResult.new.set_value_name("REJECT") }
          const_attr_reader  :REJECT
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [ACCEPT_COMPLETE, ACCEPT_INCOMPLETE, REJECT]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__nego_result, :initialize
      end
    }
    
    attr_accessor :token_type
    alias_method :attr_token_type, :token_type
    undef_method :token_type
    alias_method :attr_token_type=, :token_type=
    undef_method :token_type=
    
    class_module.module_eval {
      # property
      const_set_lazy(:DEBUG) { SpNegoContext::DEBUG }
      const_attr_reader  :DEBUG
      
      # The object identifier corresponding to the SPNEGO GSS-API
      # mechanism.
      
      def oid
        defined?(@@oid) ? @@oid : @@oid= nil
      end
      alias_method :attr_oid, :oid
      
      def oid=(value)
        @@oid = value
      end
      alias_method :attr_oid=, :oid=
      
      when_class_loaded do
        begin
          self.attr_oid = ObjectIdentifier.new(SpNegoMechFactory::GSS_SPNEGO_MECH_OID.to_s)
        rescue IOException => ioe
          # should not happen
        end
      end
    }
    
    typesig { [::Java::Int] }
    # Creates SPNEGO token of the specified type.
    def initialize(token_type)
      @token_type = 0
      super()
      @token_type = token_type
    end
    
    typesig { [] }
    # Returns the individual encoded SPNEGO token
    # 
    # @return the encoded token
    # @exception GSSException
    def encode
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the encoded SPNEGO token
    # Note: inserts the required CHOICE tags
    # 
    # @return the encoded token
    # @exception GSSException
    def get_encoded
      # get the token encoded value
      token = DerOutputStream.new
      token.write(encode)
      # now insert the CHOICE
      case (@token_type)
      when NEG_TOKEN_INIT_ID
        # Insert CHOICE of Negotiation Token
        init_token = DerOutputStream.new
        init_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, NEG_TOKEN_INIT_ID), token)
        return init_token.to_byte_array
      when NEG_TOKEN_TARG_ID
        # Insert CHOICE of Negotiation Token
        targ_token = DerOutputStream.new
        targ_token.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, NEG_TOKEN_TARG_ID), token)
        return targ_token.to_byte_array
      else
        return token.to_byte_array
      end
    end
    
    typesig { [] }
    # Returns the SPNEGO token type
    # 
    # @return the token type
    def get_type
      return @token_type
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns a string representing the token type.
      # 
      # @param tokenType the token type for which a string name is desired
      # @return the String name of this token type
      def get_token_name(type)
        case (type)
        when NEG_TOKEN_INIT_ID
          return "SPNEGO NegTokenInit"
        when NEG_TOKEN_TARG_ID
          return "SPNEGO NegTokenTarg"
        else
          return "SPNEGO Mechanism Token"
        end
      end
      
      typesig { [::Java::Int] }
      # Returns the enumerated type of the Negotiation result.
      # 
      # @param result the negotiated result represented by integer
      # @return the enumerated type of Negotiated result
      def get_nego_result_type(result)
        case (result)
        when 0
          return NegoResult::ACCEPT_COMPLETE
        when 1
          return NegoResult::ACCEPT_INCOMPLETE
        when 2
          return NegoResult::REJECT
        else
          # unknown - return optimistic result
          return NegoResult::ACCEPT_COMPLETE
        end
      end
      
      typesig { [::Java::Int] }
      # Returns a string representing the negotiation result.
      # 
      # @param result the negotiated result
      # @return the String message of this negotiated result
      def get_nego_result_string(result)
        case (result)
        when 0
          return "Accept Complete"
        when 1
          return "Accept InComplete"
        when 2
          return "Reject"
        else
          return ("Unknown Negotiated Result: " + RJava.cast_to_string(result))
        end
      end
    }
    
    private
    alias_method :initialize__sp_nego_token, :initialize
  end
  
end

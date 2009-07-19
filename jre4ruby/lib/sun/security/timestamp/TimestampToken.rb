require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Timestamp
  module TimestampTokenImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Timestamp
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Date
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::X509, :AlgorithmId
    }
  end
  
  # This class provides the timestamp token info resulting from a successful
  # timestamp request, as defined in
  # <a href="http://www.ietf.org/rfc/rfc3161.txt">RFC 3161</a>.
  # 
  # The timestampTokenInfo ASN.1 type has the following definition:
  # <pre>
  # 
  # TSTInfo ::= SEQUENCE {
  # version                INTEGER  { v1(1) },
  # policy                 TSAPolicyId,
  # messageImprint         MessageImprint,
  # -- MUST have the same value as the similar field in
  # -- TimeStampReq
  # serialNumber           INTEGER,
  # -- Time-Stamping users MUST be ready to accommodate integers
  # -- up to 160 bits.
  # genTime                GeneralizedTime,
  # accuracy               Accuracy                 OPTIONAL,
  # ordering               BOOLEAN             DEFAULT FALSE,
  # nonce                  INTEGER                  OPTIONAL,
  # -- MUST be present if the similar field was present
  # -- in TimeStampReq.  In that case it MUST have the same value.
  # tsa                    [0] GeneralName          OPTIONAL,
  # extensions             [1] IMPLICIT Extensions  OPTIONAL }
  # 
  # Accuracy ::= SEQUENCE {
  # seconds        INTEGER           OPTIONAL,
  # millis     [0] INTEGER  (1..999) OPTIONAL,
  # micros     [1] INTEGER  (1..999) OPTIONAL  }
  # 
  # </pre>
  # 
  # @since 1.5
  # @see Timestamper
  # @author Vincent Ryan
  class TimestampToken 
    include_class_members TimestampTokenImports
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :policy
    alias_method :attr_policy, :policy
    undef_method :policy
    alias_method :attr_policy=, :policy=
    undef_method :policy=
    
    attr_accessor :serial_number
    alias_method :attr_serial_number, :serial_number
    undef_method :serial_number
    alias_method :attr_serial_number=, :serial_number=
    undef_method :serial_number=
    
    attr_accessor :hash_algorithm
    alias_method :attr_hash_algorithm, :hash_algorithm
    undef_method :hash_algorithm
    alias_method :attr_hash_algorithm=, :hash_algorithm=
    undef_method :hash_algorithm=
    
    attr_accessor :hashed_message
    alias_method :attr_hashed_message, :hashed_message
    undef_method :hashed_message
    alias_method :attr_hashed_message=, :hashed_message=
    undef_method :hashed_message=
    
    attr_accessor :gen_time
    alias_method :attr_gen_time, :gen_time
    undef_method :gen_time
    alias_method :attr_gen_time=, :gen_time=
    undef_method :gen_time=
    
    attr_accessor :nonce
    alias_method :attr_nonce, :nonce
    undef_method :nonce
    alias_method :attr_nonce=, :nonce=
    undef_method :nonce=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs an object to store a timestamp token.
    # 
    # @param status A buffer containing the ASN.1 BER encoding of the
    # TSTInfo element defined in RFC 3161.
    def initialize(timestamp_token_info)
      @version = 0
      @policy = nil
      @serial_number = nil
      @hash_algorithm = nil
      @hashed_message = nil
      @gen_time = nil
      @nonce = nil
      if ((timestamp_token_info).nil?)
        raise IOException.new("No timestamp token info")
      end
      parse(timestamp_token_info)
    end
    
    typesig { [] }
    # Extract the date and time from the timestamp token.
    # 
    # @return The date and time when the timestamp was generated.
    def get_date
      return @gen_time
    end
    
    typesig { [] }
    def get_hash_algorithm
      return @hash_algorithm
    end
    
    typesig { [] }
    # should only be used internally, otherwise return a clone
    def get_hashed_message
      return @hashed_message
    end
    
    typesig { [] }
    def get_nonce
      return @nonce
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Parses the timestamp token info.
    # 
    # @param timestampTokenInfo A buffer containing an ASN.1 BER encoded
    # TSTInfo.
    # @throws IOException The exception is thrown if a problem is encountered
    # while parsing.
    def parse(timestamp_token_info)
      tst_info = DerValue.new(timestamp_token_info)
      if (!(tst_info.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Bad encoding for timestamp token info")
      end
      # Parse version
      @version = tst_info.attr_data.get_integer
      # Parse policy
      @policy = tst_info.attr_data.get_oid
      # Parse messageImprint
      message_imprint = tst_info.attr_data.get_der_value
      @hash_algorithm = AlgorithmId.parse(message_imprint.attr_data.get_der_value)
      @hashed_message = message_imprint.attr_data.get_octet_string
      # Parse serialNumber
      @serial_number = tst_info.attr_data.get_big_integer
      # Parse genTime
      @gen_time = tst_info.attr_data.get_generalized_time
      # Parse optional elements, if present
      while (tst_info.attr_data.available > 0)
        d = tst_info.attr_data.get_der_value
        if ((d.attr_tag).equal?(DerValue.attr_tag_integer))
          # must be the nonce
          @nonce = d.get_big_integer
          break
        end
      end
    end
    
    private
    alias_method :initialize__timestamp_token, :initialize
  end
  
end

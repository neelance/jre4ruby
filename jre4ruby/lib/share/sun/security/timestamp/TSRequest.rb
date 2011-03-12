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
  module TSRequestImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Timestamp
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security::Cert, :X509Extension
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # This class provides a timestamp request, as defined in
  # <a href="http://www.ietf.org/rfc/rfc3161.txt">RFC 3161</a>.
  # 
  # The TimeStampReq ASN.1 type has the following definition:
  # <pre>
  # 
  #     TimeStampReq ::= SEQUENCE {
  #         version           INTEGER { v1(1) },
  #         messageImprint    MessageImprint
  #           -- a hash algorithm OID and the hash value of the data to be
  #           -- time-stamped.
  #         reqPolicy         TSAPolicyId    OPTIONAL,
  #         nonce             INTEGER        OPTIONAL,
  #         certReq           BOOLEAN        DEFAULT FALSE,
  #         extensions        [0] IMPLICIT Extensions OPTIONAL }
  # 
  #     MessageImprint ::= SEQUENCE {
  #         hashAlgorithm     AlgorithmIdentifier,
  #         hashedMessage     OCTET STRING }
  # 
  #     TSAPolicyId ::= OBJECT IDENTIFIER
  # 
  # </pre>
  # 
  # @since 1.5
  # @author Vincent Ryan
  # @see Timestamper
  class TSRequest 
    include_class_members TSRequestImports
    
    class_module.module_eval {
      when_class_loaded do
        sha1 = nil
        md5 = nil
        begin
          sha1 = ObjectIdentifier.new("1.3.14.3.2.26")
          md5 = ObjectIdentifier.new("1.2.840.113549.2.5")
        rescue IOException => ioe
          # should not happen
        end
        const_set :SHA1_OID, sha1
        const_set :MD5_OID, md5
      end
    }
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :hash_algorithm_id
    alias_method :attr_hash_algorithm_id, :hash_algorithm_id
    undef_method :hash_algorithm_id
    alias_method :attr_hash_algorithm_id=, :hash_algorithm_id=
    undef_method :hash_algorithm_id=
    
    attr_accessor :hash_value
    alias_method :attr_hash_value, :hash_value
    undef_method :hash_value
    alias_method :attr_hash_value=, :hash_value=
    undef_method :hash_value=
    
    attr_accessor :policy_id
    alias_method :attr_policy_id, :policy_id
    undef_method :policy_id
    alias_method :attr_policy_id=, :policy_id=
    undef_method :policy_id=
    
    attr_accessor :nonce
    alias_method :attr_nonce, :nonce
    undef_method :nonce
    alias_method :attr_nonce=, :nonce=
    undef_method :nonce=
    
    attr_accessor :return_certificate
    alias_method :attr_return_certificate, :return_certificate
    undef_method :return_certificate
    alias_method :attr_return_certificate=, :return_certificate=
    undef_method :return_certificate=
    
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    typesig { [Array.typed(::Java::Byte), String] }
    # Constructs a timestamp request for the supplied hash value..
    # 
    # @param hashValue     The hash value. This is the data to be timestamped.
    # @param hashAlgorithm The name of the hash algorithm.
    def initialize(hash_value, hash_algorithm)
      @version = 1
      @hash_algorithm_id = nil
      @hash_value = nil
      @policy_id = nil
      @nonce = nil
      @return_certificate = false
      @extensions = nil
      # Check the common hash algorithms
      if ("MD5".equals_ignore_case(hash_algorithm))
        @hash_algorithm_id = MD5_OID
        # Check that the hash value matches the hash algorithm
        raise AssertError if not ((hash_value.attr_length).equal?(16))
      else
        if ("SHA-1".equals_ignore_case(hash_algorithm) || "SHA".equals_ignore_case(hash_algorithm) || "SHA1".equals_ignore_case(hash_algorithm))
          @hash_algorithm_id = SHA1_OID
          # Check that the hash value matches the hash algorithm
          raise AssertError if not ((hash_value.attr_length).equal?(20))
        end
      end
      # Clone the hash value
      @hash_value = Array.typed(::Java::Byte).new(hash_value.attr_length) { 0 }
      System.arraycopy(hash_value, 0, @hash_value, 0, hash_value.attr_length)
    end
    
    typesig { [::Java::Int] }
    # Sets the Time-Stamp Protocol version.
    # 
    # @param version The TSP version.
    def set_version(version)
      @version = version
    end
    
    typesig { [String] }
    # Sets an object identifier for the Time-Stamp Protocol policy.
    # 
    # @param version The policy object identifier.
    def set_policy_id(policy_id)
      @policy_id = policy_id
    end
    
    typesig { [BigInteger] }
    # Sets a nonce.
    # A nonce is a single-use random number.
    # 
    # @param nonce The nonce value.
    def set_nonce(nonce)
      @nonce = nonce
    end
    
    typesig { [::Java::Boolean] }
    # Request that the TSA include its signing certificate in the response.
    # 
    # @param returnCertificate True if the TSA should return its signing
    #                          certificate. By default it is not returned.
    def request_certificate(return_certificate)
      @return_certificate = return_certificate
    end
    
    typesig { [Array.typed(X509Extension)] }
    # Sets the Time-Stamp Protocol extensions.
    # 
    # @param extensions The protocol extensions.
    def set_extensions(extensions)
      @extensions = extensions
    end
    
    typesig { [] }
    def encode
      request = DerOutputStream.new
      # encode version
      request.put_integer(@version)
      # encode messageImprint
      message_imprint = DerOutputStream.new
      hash_algorithm = DerOutputStream.new
      hash_algorithm.put_oid(@hash_algorithm_id)
      message_imprint.write(DerValue.attr_tag_sequence, hash_algorithm)
      message_imprint.put_octet_string(@hash_value)
      request.write(DerValue.attr_tag_sequence, message_imprint)
      # encode optional elements
      if (!(@policy_id).nil?)
        request.put_oid(ObjectIdentifier.new(@policy_id))
      end
      if (!(@nonce).nil?)
        request.put_integer(@nonce)
      end
      if (@return_certificate)
        request.put_boolean(true)
      end
      out = DerOutputStream.new
      out.write(DerValue.attr_tag_sequence, request)
      return out.to_byte_array
    end
    
    private
    alias_method :initialize__tsrequest, :initialize
  end
  
end

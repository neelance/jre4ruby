require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TSResponseImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Timestamp
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Sun::Security::Pkcs, :PKCS7
      include_const ::Sun::Security::Pkcs, :PKCS9Attribute
      include_const ::Sun::Security::Pkcs, :PKCS9Attributes
      include_const ::Sun::Security::Pkcs, :ParsingException
      include_const ::Sun::Security::Pkcs, :SignerInfo
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::X509, :X500Name
    }
  end
  
  # This class provides the response corresponding to a timestamp request,
  # as defined in
  # <a href="http://www.ietf.org/rfc/rfc3161.txt">RFC 3161</a>.
  # 
  # The TimeStampResp ASN.1 type has the following definition:
  # <pre>
  # 
  # TimeStampResp ::= SEQUENCE {
  # status            PKIStatusInfo,
  # timeStampToken    TimeStampToken OPTIONAL ]
  # 
  # PKIStatusInfo ::= SEQUENCE {
  # status        PKIStatus,
  # statusString  PKIFreeText OPTIONAL,
  # failInfo      PKIFailureInfo OPTIONAL }
  # 
  # PKIStatus ::= INTEGER {
  # granted                (0),
  # -- when the PKIStatus contains the value zero a TimeStampToken, as
  # -- requested, is present.
  # grantedWithMods        (1),
  # -- when the PKIStatus contains the value one a TimeStampToken,
  # -- with modifications, is present.
  # rejection              (2),
  # waiting                (3),
  # revocationWarning      (4),
  # -- this message contains a warning that a revocation is
  # -- imminent
  # revocationNotification (5)
  # -- notification that a revocation has occurred }
  # 
  # PKIFreeText ::= SEQUENCE SIZE (1..MAX) OF UTF8String
  # -- text encoded as UTF-8 String (note:  each UTF8String SHOULD
  # -- include an RFC 1766 language tag to indicate the language
  # -- of the contained text)
  # 
  # PKIFailureInfo ::= BIT STRING {
  # badAlg              (0),
  # -- unrecognized or unsupported Algorithm Identifier
  # badRequest          (2),
  # -- transaction not permitted or supported
  # badDataFormat       (5),
  # -- the data submitted has the wrong format
  # timeNotAvailable    (14),
  # -- the TSA's time source is not available
  # unacceptedPolicy    (15),
  # -- the requested TSA policy is not supported by the TSA
  # unacceptedExtension (16),
  # -- the requested extension is not supported by the TSA
  # addInfoNotAvailable (17)
  # -- the additional information requested could not be understood
  # -- or is not available
  # systemFailure       (25)
  # -- the request cannot be handled due to system failure }
  # 
  # TimeStampToken ::= ContentInfo
  # -- contentType is id-signedData
  # -- content is SignedData
  # -- eContentType within SignedData is id-ct-TSTInfo
  # -- eContent within SignedData is TSTInfo
  # 
  # </pre>
  # 
  # @since 1.5
  # @author Vincent Ryan
  # @see Timestamper
  class TSResponse 
    include_class_members TSResponseImports
    
    class_module.module_eval {
      # Status codes (from RFC 3161)
      # 
      # The requested timestamp was granted.
      const_set_lazy(:GRANTED) { 0 }
      const_attr_reader  :GRANTED
      
      # The requested timestamp was granted with some modifications.
      const_set_lazy(:GRANTED_WITH_MODS) { 1 }
      const_attr_reader  :GRANTED_WITH_MODS
      
      # The requested timestamp was not granted.
      const_set_lazy(:REJECTION) { 2 }
      const_attr_reader  :REJECTION
      
      # The requested timestamp has not yet been processed.
      const_set_lazy(:WAITING) { 3 }
      const_attr_reader  :WAITING
      
      # A warning that a certificate revocation is imminent.
      const_set_lazy(:REVOCATION_WARNING) { 4 }
      const_attr_reader  :REVOCATION_WARNING
      
      # Notification that a certificate revocation has occurred.
      const_set_lazy(:REVOCATION_NOTIFICATION) { 5 }
      const_attr_reader  :REVOCATION_NOTIFICATION
      
      # Failure codes (from RFC 3161)
      # 
      # Unrecognized or unsupported algorithm identifier.
      const_set_lazy(:BAD_ALG) { 0 }
      const_attr_reader  :BAD_ALG
      
      # The requested transaction is not permitted or supported.
      const_set_lazy(:BAD_REQUEST) { 2 }
      const_attr_reader  :BAD_REQUEST
      
      # The data submitted has the wrong format.
      const_set_lazy(:BAD_DATA_FORMAT) { 5 }
      const_attr_reader  :BAD_DATA_FORMAT
      
      # The TSA's time source is not available.
      const_set_lazy(:TIME_NOT_AVAILABLE) { 14 }
      const_attr_reader  :TIME_NOT_AVAILABLE
      
      # The requested TSA policy is not supported by the TSA.
      const_set_lazy(:UNACCEPTED_POLICY) { 15 }
      const_attr_reader  :UNACCEPTED_POLICY
      
      # The requested extension is not supported by the TSA.
      const_set_lazy(:UNACCEPTED_EXTENSION) { 16 }
      const_attr_reader  :UNACCEPTED_EXTENSION
      
      # The additional information requested could not be understood or is not
      # available.
      const_set_lazy(:ADD_INFO_NOT_AVAILABLE) { 17 }
      const_attr_reader  :ADD_INFO_NOT_AVAILABLE
      
      # The request cannot be handled due to system failure.
      const_set_lazy(:SYSTEM_FAILURE) { 25 }
      const_attr_reader  :SYSTEM_FAILURE
      
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
    }
    
    attr_accessor :status
    alias_method :attr_status, :status
    undef_method :status
    alias_method :attr_status=, :status=
    undef_method :status=
    
    attr_accessor :status_string
    alias_method :attr_status_string, :status_string
    undef_method :status_string
    alias_method :attr_status_string=, :status_string=
    undef_method :status_string=
    
    attr_accessor :failure_info
    alias_method :attr_failure_info, :failure_info
    undef_method :failure_info
    alias_method :attr_failure_info=, :failure_info=
    undef_method :failure_info=
    
    attr_accessor :encoded_ts_token
    alias_method :attr_encoded_ts_token, :encoded_ts_token
    undef_method :encoded_ts_token
    alias_method :attr_encoded_ts_token=, :encoded_ts_token=
    undef_method :encoded_ts_token=
    
    attr_accessor :ts_token
    alias_method :attr_ts_token, :ts_token
    undef_method :ts_token
    alias_method :attr_ts_token=, :ts_token=
    undef_method :ts_token=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs an object to store the response to a timestamp request.
    # 
    # @param status A buffer containing the ASN.1 BER encoded response.
    # @throws IOException The exception is thrown if a problem is encountered
    # parsing the timestamp response.
    def initialize(ts_reply)
      @status = 0
      @status_string = nil
      @failure_info = -1
      @encoded_ts_token = nil
      @ts_token = nil
      parse(ts_reply)
    end
    
    typesig { [] }
    # Retrieve the status code returned by the TSA.
    def get_status_code
      return @status
    end
    
    typesig { [] }
    # Retrieve the status messages returned by the TSA.
    # 
    # @return If null then no status messages were received.
    def get_status_messages
      return @status_string
    end
    
    typesig { [] }
    # Retrieve the failure code returned by the TSA.
    # 
    # @return If -1 then no failure code was received.
    def get_failure_code
      return @failure_info
    end
    
    typesig { [] }
    def get_status_code_as_text
      case (@status)
      when GRANTED
        return "the timestamp request was granted."
      when GRANTED_WITH_MODS
        return "the timestamp request was granted with some modifications."
      when REJECTION
        return "the timestamp request was rejected."
      when WAITING
        return "the timestamp request has not yet been processed."
      when REVOCATION_WARNING
        return "warning: a certificate revocation is imminent."
      when REVOCATION_NOTIFICATION
        return "notification: a certificate revocation has occurred."
      else
        return ("unknown status code " + RJava.cast_to_string(@status) + ".")
      end
    end
    
    typesig { [] }
    def get_failure_code_as_text
      if ((@failure_info).equal?(-1))
        return nil
      end
      case (@failure_info)
      when BAD_ALG
        return "Unrecognized or unsupported alrorithm identifier."
      when BAD_REQUEST
        return "The requested transaction is not permitted or supported."
      when BAD_DATA_FORMAT
        return "The data submitted has the wrong format."
      when TIME_NOT_AVAILABLE
        return "The TSA's time source is not available."
      when UNACCEPTED_POLICY
        return "The requested TSA policy is not supported by the TSA."
      when UNACCEPTED_EXTENSION
        return "The requested extension is not supported by the TSA."
      when ADD_INFO_NOT_AVAILABLE
        return "The additional information requested could not be " + "understood or is not available."
      when SYSTEM_FAILURE
        return "The request cannot be handled due to system failure."
      else
        return ("unknown status code " + RJava.cast_to_string(@status))
      end
    end
    
    typesig { [] }
    # Retrieve the timestamp token returned by the TSA.
    # 
    # @return If null then no token was received.
    def get_token
      return @ts_token
    end
    
    typesig { [] }
    # Retrieve the ASN.1 BER encoded timestamp token returned by the TSA.
    # 
    # @return If null then no token was received.
    def get_encoded_token
      return @encoded_ts_token
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Parses the timestamp response.
    # 
    # @param status A buffer containing the ASN.1 BER encoded response.
    # @throws IOException The exception is thrown if a problem is encountered
    # parsing the timestamp response.
    def parse(ts_reply)
      # Decode TimeStampResp
      der_value = DerValue.new(ts_reply)
      if (!(der_value.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Bad encoding for timestamp response")
      end
      # Parse status
      status = der_value.attr_data.get_der_value
      # Parse status
      @status = status.attr_data.get_integer
      if (DEBUG)
        System.out.println("timestamp response: status=" + RJava.cast_to_string(@status))
      end
      # Parse statusString, if present
      if (status.attr_data.available > 0)
        strings = status.attr_data.get_sequence(1)
        @status_string = Array.typed(String).new(strings.attr_length) { nil }
        i = 0
        while i < strings.attr_length
          @status_string[i] = strings[i].attr_data.get_utf8string
          i += 1
        end
      end
      # Parse failInfo, if present
      if (status.attr_data.available > 0)
        fail_info = status.attr_data.get_bit_string
        failure_info = (Byte.new(fail_info[0])).int_value
        if (failure_info < 0 || failure_info > 25 || !(fail_info.attr_length).equal?(1))
          raise IOException.new("Bad encoding for timestamp response: " + "unrecognized value for the failInfo element")
        end
        @failure_info = failure_info
      end
      # Parse timeStampToken, if present
      if (der_value.attr_data.available > 0)
        timestamp_token = der_value.attr_data.get_der_value
        @encoded_ts_token = timestamp_token.to_byte_array
        @ts_token = PKCS7.new(@encoded_ts_token)
      end
      # Check the format of the timestamp response
      if ((@status).equal?(0) || (@status).equal?(1))
        if ((@ts_token).nil?)
          raise TimestampException.new("Bad encoding for timestamp response: " + "expected a timeStampToken element to be present")
        end
      else
        if (!(@ts_token).nil?)
          raise TimestampException.new("Bad encoding for timestamp response: " + "expected no timeStampToken element to be present")
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:TimestampException) { Class.new(IOException) do
        include_class_members TSResponse
        
        typesig { [String] }
        def initialize(message)
          super(message)
        end
        
        private
        alias_method :initialize__timestamp_exception, :initialize
      end }
    }
    
    private
    alias_method :initialize__tsresponse, :initialize
  end
  
end

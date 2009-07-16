require "rjava"

# 
# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module AlertsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Javax::Net::Ssl
    }
  end
  
  # 
  # A simple class to congregate alerts, their definitions, and common
  # support methods.
  class Alerts 
    include_class_members AlertsImports
    
    class_module.module_eval {
      # 
      # Alerts are always a fixed two byte format (level/description).
      # 
      # warnings and fatal errors are package private facilities/constants
      # Alert levels (enum AlertLevel)
      const_set_lazy(:Alert_warning) { 1 }
      const_attr_reader  :Alert_warning
      
      const_set_lazy(:Alert_fatal) { 2 }
      const_attr_reader  :Alert_fatal
      
      # 
      # Alert descriptions (enum AlertDescription)
      # 
      # We may not use them all in our processing, but if someone
      # sends us one, we can at least convert it to a string for the
      # user.
      const_set_lazy(:Alert_close_notify) { 0 }
      const_attr_reader  :Alert_close_notify
      
      const_set_lazy(:Alert_unexpected_message) { 10 }
      const_attr_reader  :Alert_unexpected_message
      
      const_set_lazy(:Alert_bad_record_mac) { 20 }
      const_attr_reader  :Alert_bad_record_mac
      
      const_set_lazy(:Alert_decryption_failed) { 21 }
      const_attr_reader  :Alert_decryption_failed
      
      const_set_lazy(:Alert_record_overflow) { 22 }
      const_attr_reader  :Alert_record_overflow
      
      const_set_lazy(:Alert_decompression_failure) { 30 }
      const_attr_reader  :Alert_decompression_failure
      
      const_set_lazy(:Alert_handshake_failure) { 40 }
      const_attr_reader  :Alert_handshake_failure
      
      const_set_lazy(:Alert_no_certificate) { 41 }
      const_attr_reader  :Alert_no_certificate
      
      const_set_lazy(:Alert_bad_certificate) { 42 }
      const_attr_reader  :Alert_bad_certificate
      
      const_set_lazy(:Alert_unsupported_certificate) { 43 }
      const_attr_reader  :Alert_unsupported_certificate
      
      const_set_lazy(:Alert_certificate_revoked) { 44 }
      const_attr_reader  :Alert_certificate_revoked
      
      const_set_lazy(:Alert_certificate_expired) { 45 }
      const_attr_reader  :Alert_certificate_expired
      
      const_set_lazy(:Alert_certificate_unknown) { 46 }
      const_attr_reader  :Alert_certificate_unknown
      
      const_set_lazy(:Alert_illegal_parameter) { 47 }
      const_attr_reader  :Alert_illegal_parameter
      
      const_set_lazy(:Alert_unknown_ca) { 48 }
      const_attr_reader  :Alert_unknown_ca
      
      const_set_lazy(:Alert_access_denied) { 49 }
      const_attr_reader  :Alert_access_denied
      
      const_set_lazy(:Alert_decode_error) { 50 }
      const_attr_reader  :Alert_decode_error
      
      const_set_lazy(:Alert_decrypt_error) { 51 }
      const_attr_reader  :Alert_decrypt_error
      
      const_set_lazy(:Alert_export_restriction) { 60 }
      const_attr_reader  :Alert_export_restriction
      
      const_set_lazy(:Alert_protocol_version) { 70 }
      const_attr_reader  :Alert_protocol_version
      
      const_set_lazy(:Alert_insufficient_security) { 71 }
      const_attr_reader  :Alert_insufficient_security
      
      const_set_lazy(:Alert_internal_error) { 80 }
      const_attr_reader  :Alert_internal_error
      
      const_set_lazy(:Alert_user_canceled) { 90 }
      const_attr_reader  :Alert_user_canceled
      
      const_set_lazy(:Alert_no_negotiation) { 100 }
      const_attr_reader  :Alert_no_negotiation
      
      # from RFC 3546 (TLS Extensions)
      const_set_lazy(:Alert_unsupported_extension) { 110 }
      const_attr_reader  :Alert_unsupported_extension
      
      const_set_lazy(:Alert_certificate_unobtainable) { 111 }
      const_attr_reader  :Alert_certificate_unobtainable
      
      const_set_lazy(:Alert_unrecognized_name) { 112 }
      const_attr_reader  :Alert_unrecognized_name
      
      const_set_lazy(:Alert_bad_certificate_status_response) { 113 }
      const_attr_reader  :Alert_bad_certificate_status_response
      
      const_set_lazy(:Alert_bad_certificate_hash_value) { 114 }
      const_attr_reader  :Alert_bad_certificate_hash_value
      
      typesig { [::Java::Byte] }
      def alert_description(code)
        case (code)
        when Alert_close_notify
          return "close_notify"
        when Alert_unexpected_message
          return "unexpected_message"
        when Alert_bad_record_mac
          return "bad_record_mac"
        when Alert_decryption_failed
          return "decryption_failed"
        when Alert_record_overflow
          return "record_overflow"
        when Alert_decompression_failure
          return "decompression_failure"
        when Alert_handshake_failure
          return "handshake_failure"
        when Alert_no_certificate
          return "no_certificate"
        when Alert_bad_certificate
          return "bad_certificate"
        when Alert_unsupported_certificate
          return "unsupported_certificate"
        when Alert_certificate_revoked
          return "certificate_revoked"
        when Alert_certificate_expired
          return "certificate_expired"
        when Alert_certificate_unknown
          return "certificate_unknown"
        when Alert_illegal_parameter
          return "illegal_parameter"
        when Alert_unknown_ca
          return "unknown_ca"
        when Alert_access_denied
          return "access_denied"
        when Alert_decode_error
          return "decode_error"
        when Alert_decrypt_error
          return "decrypt_error"
        when Alert_export_restriction
          return "export_restriction"
        when Alert_protocol_version
          return "protocol_version"
        when Alert_insufficient_security
          return "insufficient_security"
        when Alert_internal_error
          return "internal_error"
        when Alert_user_canceled
          return "user_canceled"
        when Alert_no_negotiation
          return "no_negotiation"
        when Alert_unsupported_extension
          return "unsupported_extension"
        when Alert_certificate_unobtainable
          return "certificate_unobtainable"
        when Alert_unrecognized_name
          return "unrecognized_name"
        when Alert_bad_certificate_status_response
          return "bad_certificate_status_response"
        when Alert_bad_certificate_hash_value
          return "bad_certificate_hash_value"
        else
          return "<UNKNOWN ALERT: " + ((code & 0xff)).to_s + ">"
        end
      end
      
      typesig { [::Java::Byte, String] }
      def get_sslexception(description, reason)
        return get_sslexception(description, nil, reason)
      end
      
      typesig { [::Java::Byte, Exception, String] }
      # 
      # Try to be a little more specific in our choice of
      # exceptions to throw.
      def get_sslexception(description, cause, reason)
        e = nil
        # the SSLException classes do not have a no-args constructor
        # make up a message if there is none
        if ((reason).nil?)
          if (!(cause).nil?)
            reason = (cause.to_s).to_s
          else
            reason = ""
          end
        end
        case (description)
        when Alert_handshake_failure, Alert_no_certificate, Alert_bad_certificate, Alert_unsupported_certificate, Alert_certificate_revoked, Alert_certificate_expired, Alert_certificate_unknown, Alert_unknown_ca, Alert_access_denied, Alert_decrypt_error, Alert_export_restriction, Alert_insufficient_security, Alert_unsupported_extension, Alert_certificate_unobtainable, Alert_unrecognized_name, Alert_bad_certificate_status_response, Alert_bad_certificate_hash_value
          e = SSLHandshakeException.new(reason)
        when Alert_close_notify, Alert_unexpected_message, Alert_bad_record_mac, Alert_decryption_failed, Alert_record_overflow, Alert_decompression_failure, Alert_illegal_parameter, Alert_decode_error, Alert_protocol_version, Alert_internal_error, Alert_user_canceled, Alert_no_negotiation
          e = SSLException.new(reason)
        else
          e = SSLException.new(reason)
        end
        if (!(cause).nil?)
          e.init_cause(cause)
        end
        return e
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__alerts, :initialize
  end
  
end

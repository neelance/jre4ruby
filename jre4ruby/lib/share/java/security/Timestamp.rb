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
module Java::Security
  module TimestampImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :Serializable
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :X509Extension
      include_const ::Java::Util, :Date
    }
  end
  
  # This class encapsulates information about a signed timestamp.
  # It is immutable.
  # It includes the timestamp's date and time as well as information about the
  # Timestamping Authority (TSA) which generated and signed the timestamp.
  # 
  # @since 1.5
  # @author Vincent Ryan
  class Timestamp 
    include_class_members TimestampImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -5502683707821851294 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The timestamp's date and time
    # 
    # @serial
    attr_accessor :timestamp
    alias_method :attr_timestamp, :timestamp
    undef_method :timestamp
    alias_method :attr_timestamp=, :timestamp=
    undef_method :timestamp=
    
    # The TSA's certificate path.
    # 
    # @serial
    attr_accessor :signer_cert_path
    alias_method :attr_signer_cert_path, :signer_cert_path
    undef_method :signer_cert_path
    alias_method :attr_signer_cert_path=, :signer_cert_path=
    undef_method :signer_cert_path=
    
    # Hash code for this timestamp.
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [Date, CertPath] }
    # Constructs a Timestamp.
    # 
    # @param timestamp is the timestamp's date and time. It must not be null.
    # @param signerCertPath is the TSA's certificate path. It must not be null.
    # @throws NullPointerException if timestamp or signerCertPath is null.
    def initialize(timestamp, signer_cert_path)
      @timestamp = nil
      @signer_cert_path = nil
      @myhash = -1
      if ((timestamp).nil? || (signer_cert_path).nil?)
        raise NullPointerException.new
      end
      @timestamp = Date.new(timestamp.get_time) # clone
      @signer_cert_path = signer_cert_path
    end
    
    typesig { [] }
    # Returns the date and time when the timestamp was generated.
    # 
    # @return The timestamp's date and time.
    def get_timestamp
      return Date.new(@timestamp.get_time) # clone
    end
    
    typesig { [] }
    # Returns the certificate path for the Timestamping Authority.
    # 
    # @return The TSA's certificate path.
    def get_signer_cert_path
      return @signer_cert_path
    end
    
    typesig { [] }
    # Returns the hash code value for this timestamp.
    # The hash code is generated using the date and time of the timestamp
    # and the TSA's certificate path.
    # 
    # @return a hash code value for this timestamp.
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = @timestamp.hash_code + @signer_cert_path.hash_code
      end
      return @myhash
    end
    
    typesig { [Object] }
    # Tests for equality between the specified object and this
    # timestamp. Two timestamps are considered equal if the date and time of
    # their timestamp's and their signer's certificate paths are equal.
    # 
    # @param obj the object to test for equality with this timestamp.
    # 
    # @return true if the timestamp are considered equal, false otherwise.
    def ==(obj)
      if ((obj).nil? || (!(obj.is_a?(Timestamp))))
        return false
      end
      that = obj
      if ((self).equal?(that))
        return true
      end
      return ((@timestamp == that.get_timestamp) && (@signer_cert_path == that.get_signer_cert_path))
    end
    
    typesig { [] }
    # Returns a string describing this timestamp.
    # 
    # @return A string comprising the date and time of the timestamp and
    # its signer's certificate.
    def to_s
      sb = StringBuffer.new
      sb.append("(")
      sb.append("timestamp: " + RJava.cast_to_string(@timestamp))
      sb.append("TSA: " + RJava.cast_to_string(@signer_cert_path.get_certificates.get(0)))
      sb.append(")")
      return sb.to_s
    end
    
    private
    alias_method :initialize__timestamp, :initialize
  end
  
end

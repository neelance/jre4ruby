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
module Java::Security
  module CodeSignerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :Serializable
      include_const ::Java::Security::Cert, :CertPath
    }
  end
  
  # This class encapsulates information about a code signer.
  # It is immutable.
  # 
  # @since 1.5
  # @author Vincent Ryan
  class CodeSigner 
    include_class_members CodeSignerImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6819288105193937581 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The signer's certificate path.
    # 
    # @serial
    attr_accessor :signer_cert_path
    alias_method :attr_signer_cert_path, :signer_cert_path
    undef_method :signer_cert_path
    alias_method :attr_signer_cert_path=, :signer_cert_path=
    undef_method :signer_cert_path=
    
    # The signature timestamp.
    # 
    # @serial
    attr_accessor :timestamp
    alias_method :attr_timestamp, :timestamp
    undef_method :timestamp
    alias_method :attr_timestamp=, :timestamp=
    undef_method :timestamp=
    
    # Hash code for this code signer.
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [CertPath, Timestamp] }
    # Constructs a CodeSigner object.
    # 
    # @param signerCertPath The signer's certificate path.
    # It must not be <code>null</code>.
    # @param timestamp A signature timestamp.
    # If <code>null</code> then no timestamp was generated
    # for the signature.
    # @throws NullPointerException if <code>signerCertPath</code> is
    # <code>null</code>.
    def initialize(signer_cert_path, timestamp)
      @signer_cert_path = nil
      @timestamp = nil
      @myhash = -1
      if ((signer_cert_path).nil?)
        raise NullPointerException.new
      end
      @signer_cert_path = signer_cert_path
      @timestamp = timestamp
    end
    
    typesig { [] }
    # Returns the signer's certificate path.
    # 
    # @return A certificate path.
    def get_signer_cert_path
      return @signer_cert_path
    end
    
    typesig { [] }
    # Returns the signature timestamp.
    # 
    # @return The timestamp or <code>null</code> if none is present.
    def get_timestamp
      return @timestamp
    end
    
    typesig { [] }
    # Returns the hash code value for this code signer.
    # The hash code is generated using the signer's certificate path and the
    # timestamp, if present.
    # 
    # @return a hash code value for this code signer.
    def hash_code
      if ((@myhash).equal?(-1))
        if ((@timestamp).nil?)
          @myhash = @signer_cert_path.hash_code
        else
          @myhash = @signer_cert_path.hash_code + @timestamp.hash_code
        end
      end
      return @myhash
    end
    
    typesig { [Object] }
    # Tests for equality between the specified object and this
    # code signer. Two code signers are considered equal if their
    # signer certificate paths are equal and if their timestamps are equal,
    # if present in both.
    # 
    # @param obj the object to test for equality with this object.
    # 
    # @return true if the objects are considered equal, false otherwise.
    def ==(obj)
      if ((obj).nil? || (!(obj.is_a?(CodeSigner))))
        return false
      end
      that = obj
      if ((self).equal?(that))
        return true
      end
      that_timestamp = that.get_timestamp
      if ((@timestamp).nil?)
        if (!(that_timestamp).nil?)
          return false
        end
      else
        if ((that_timestamp).nil? || (!(@timestamp == that_timestamp)))
          return false
        end
      end
      return (@signer_cert_path == that.get_signer_cert_path)
    end
    
    typesig { [] }
    # Returns a string describing this code signer.
    # 
    # @return A string comprising the signer's certificate and a timestamp,
    # if present.
    def to_s
      sb = StringBuffer.new
      sb.append("(")
      sb.append("Signer: " + RJava.cast_to_string(@signer_cert_path.get_certificates.get(0)))
      if (!(@timestamp).nil?)
        sb.append("timestamp: " + RJava.cast_to_string(@timestamp))
      end
      sb.append(")")
      return sb.to_s
    end
    
    private
    alias_method :initialize__code_signer, :initialize
  end
  
end

require "rjava"

# 
# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Cert
  module X509CRLEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Date
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # 
  # <p>Abstract class for a revoked certificate in a CRL (Certificate
  # Revocation List).
  # 
  # The ASN.1 definition for <em>revokedCertificates</em> is:
  # <pre>
  # revokedCertificates    SEQUENCE OF SEQUENCE  {
  # userCertificate    CertificateSerialNumber,
  # revocationDate     ChoiceOfTime,
  # crlEntryExtensions Extensions OPTIONAL
  # -- if present, must be v2
  # }  OPTIONAL
  # <p>
  # CertificateSerialNumber  ::=  INTEGER
  # <p>
  # Extensions  ::=  SEQUENCE SIZE (1..MAX) OF Extension
  # <p>
  # Extension  ::=  SEQUENCE  {
  # extnId        OBJECT IDENTIFIER,
  # critical      BOOLEAN DEFAULT FALSE,
  # extnValue     OCTET STRING
  # -- contains a DER encoding of a value
  # -- of the type registered for use with
  # -- the extnId object identifier value
  # }
  # </pre>
  # 
  # @see X509CRL
  # @see X509Extension
  # 
  # @author Hemma Prafullchandra
  class X509CRLEntry 
    include_class_members X509CRLEntryImports
    include X509Extension
    
    typesig { [Object] }
    # 
    # Compares this CRL entry for equality with the given
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>X509CRLEntry</code>, then
    # its encoded form (the inner SEQUENCE) is retrieved and compared
    # with the encoded form of this CRL entry.
    # 
    # @param other the object to test for equality with this CRL entry.
    # @return true iff the encoded forms of the two CRL entries
    # match, false otherwise.
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(X509CRLEntry)))
        return false
      end
      begin
        this_crlentry = self.get_encoded
        other_crlentry = (other).get_encoded
        if (!(this_crlentry.attr_length).equal?(other_crlentry.attr_length))
          return false
        end
        i = 0
        while i < this_crlentry.attr_length
          if (!(this_crlentry[i]).equal?(other_crlentry[i]))
            return false
          end
          ((i += 1) - 1)
        end
      rescue CRLException => ce
        return false
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns a hashcode value for this CRL entry from its
    # encoded form.
    # 
    # @return the hashcode value.
    def hash_code
      retval = 0
      begin
        entry_data = self.get_encoded
        i = 1
        while i < entry_data.attr_length
          retval += entry_data[i] * i
          ((i += 1) - 1)
        end
      rescue CRLException => ce
        return (retval)
      end
      return (retval)
    end
    
    typesig { [] }
    # 
    # Returns the ASN.1 DER-encoded form of this CRL Entry,
    # that is the inner SEQUENCE.
    # 
    # @return the encoded form of this certificate
    # @exception CRLException if an encoding error occurs.
    def get_encoded
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Gets the serial number from this X509CRLEntry,
    # the <em>userCertificate</em>.
    # 
    # @return the serial number.
    def get_serial_number
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Get the issuer of the X509Certificate described by this entry. If
    # the certificate issuer is also the CRL issuer, this method returns
    # null.
    # 
    # <p>This method is used with indirect CRLs. The default implementation
    # always returns null. Subclasses that wish to support indirect CRLs
    # should override it.
    # 
    # @return the issuer of the X509Certificate described by this entry
    # or null if it is issued by the CRL issuer.
    # 
    # @since 1.5
    def get_certificate_issuer
      return nil
    end
    
    typesig { [] }
    # 
    # Gets the revocation date from this X509CRLEntry,
    # the <em>revocationDate</em>.
    # 
    # @return the revocation date.
    def get_revocation_date
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns true if this CRL entry has extensions.
    # 
    # @return true if this entry has extensions, false otherwise.
    def has_extensions
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns a string representation of this CRL entry.
    # 
    # @return a string representation of this CRL entry.
    def to_s
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__x509crlentry, :initialize
  end
  
end

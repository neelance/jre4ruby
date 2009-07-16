require "rjava"

# 
# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Validator
  module SimpleValidatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include_const ::Java::Io, :IOException
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::X509, :NetscapeCertTypeExtension
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :ObjectIdentifier
    }
  end
  
  # 
  # A simple validator implementation. It is based on code from the JSSE
  # X509TrustManagerImpl. This implementation is designed for compatibility with
  # deployed certificates and previous J2SE versions. It will never support
  # more advanced features and will be deemphasized in favor of the PKIX
  # validator going forward.
  # 
  # @author Andreas Sterbenz
  class SimpleValidator < SimpleValidatorImports.const_get :Validator
    include_class_members SimpleValidatorImports
    
    class_module.module_eval {
      # Constants for the OIDs we need
      const_set_lazy(:OID_BASIC_CONSTRAINTS) { "2.5.29.19" }
      const_attr_reader  :OID_BASIC_CONSTRAINTS
      
      const_set_lazy(:OID_NETSCAPE_CERT_TYPE) { "2.16.840.1.113730.1.1" }
      const_attr_reader  :OID_NETSCAPE_CERT_TYPE
      
      const_set_lazy(:OID_KEY_USAGE) { "2.5.29.15" }
      const_attr_reader  :OID_KEY_USAGE
      
      const_set_lazy(:OID_EXTENDED_KEY_USAGE) { "2.5.29.37" }
      const_attr_reader  :OID_EXTENDED_KEY_USAGE
      
      const_set_lazy(:OID_EKU_ANY_USAGE) { "2.5.29.37.0" }
      const_attr_reader  :OID_EKU_ANY_USAGE
      
      const_set_lazy(:OBJID_NETSCAPE_CERT_TYPE) { NetscapeCertTypeExtension::NetscapeCertType_Id }
      const_attr_reader  :OBJID_NETSCAPE_CERT_TYPE
      
      const_set_lazy(:NSCT_SSL_CA) { NetscapeCertTypeExtension::SSL_CA }
      const_attr_reader  :NSCT_SSL_CA
      
      const_set_lazy(:NSCT_CODE_SIGNING_CA) { NetscapeCertTypeExtension::OBJECT_SIGNING_CA }
      const_attr_reader  :NSCT_CODE_SIGNING_CA
    }
    
    # 
    # The trusted certificates as:
    # Map (X500Principal)subject of trusted cert -> List of X509Certificate
    # The list is used because there may be multiple certificates
    # with an identical subject DN.
    attr_accessor :trusted_x500principals
    alias_method :attr_trusted_x500principals, :trusted_x500principals
    undef_method :trusted_x500principals
    alias_method :attr_trusted_x500principals=, :trusted_x500principals=
    undef_method :trusted_x500principals=
    
    # 
    # Set of the trusted certificates. Present only for
    # getTrustedCertificates().
    attr_accessor :trusted_certs
    alias_method :attr_trusted_certs, :trusted_certs
    undef_method :trusted_certs
    alias_method :attr_trusted_certs=, :trusted_certs=
    undef_method :trusted_certs=
    
    typesig { [String, Collection] }
    def initialize(variant, trusted_certs)
      @trusted_x500principals = nil
      @trusted_certs = nil
      super(TYPE_SIMPLE, variant)
      @trusted_certs = trusted_certs
      @trusted_x500principals = HashMap.new
      trusted_certs.each do |cert|
        principal = cert.get_subject_x500principal
        list = @trusted_x500principals.get(principal)
        if ((list).nil?)
          # this actually should be a set, but duplicate entries
          # are not a problem and we can avoid the Set overhead
          list = ArrayList.new(2)
          @trusted_x500principals.put(principal, list)
        end
        list.add(cert)
      end
    end
    
    typesig { [] }
    def get_trusted_certificates
      return @trusted_certs
    end
    
    typesig { [Array.typed(X509Certificate), Collection, Object] }
    # 
    # Perform simple validation of chain. The arguments otherCerts and
    # parameter are ignored.
    def engine_validate(chain, other_certs, parameter)
      if (((chain).nil?) || ((chain.attr_length).equal?(0)))
        raise CertificateException.new("null or zero-length certificate chain")
      end
      # make sure chain includes a trusted cert
      chain = build_trusted_chain(chain)
      date = self.attr_validation_date
      if ((date).nil?)
        date = Date.new
      end
      # verify top down, starting at the certificate issued by
      # the trust anchor
      i = chain.attr_length - 2
      while i >= 0
        issuer_cert = chain[i + 1]
        cert = chain[i]
        # no validity check for code signing certs
        if ((((self.attr_variant == VAR_CODE_SIGNING)).equal?(false)) && (((self.attr_variant == VAR_JCE_SIGNING)).equal?(false)))
          cert.check_validity(date)
        end
        # check name chaining
        if (((cert.get_issuer_x500principal == issuer_cert.get_subject_x500principal)).equal?(false))
          raise ValidatorException.new(ValidatorException::T_NAME_CHAINING, cert)
        end
        # check signature
        begin
          cert.verify(issuer_cert.get_public_key)
        rescue GeneralSecurityException => e
          raise ValidatorException.new(ValidatorException::T_SIGNATURE_ERROR, cert, e)
        end
        # check extensions for CA certs
        if (!(i).equal?(0))
          check_extensions(cert, i)
        end
        ((i -= 1) + 1)
      end
      return chain
    end
    
    typesig { [X509Certificate, ::Java::Int] }
    def check_extensions(cert, index)
      crit_set = cert.get_critical_extension_oids
      if ((crit_set).nil?)
        crit_set = Collections.empty_set
      end
      # Check the basic constraints extension
      check_basic_constraints(cert, crit_set, index)
      # Check the key usage and extended key usage extensions
      check_key_usage(cert, crit_set)
      # check Netscape certificate type extension
      check_netscape_cert_type(cert, crit_set)
      if (!crit_set.is_empty)
        raise ValidatorException.new("Certificate contains unknown critical extensions: " + (crit_set).to_s, ValidatorException::T_CA_EXTENSIONS, cert)
      end
    end
    
    typesig { [X509Certificate, JavaSet] }
    def check_netscape_cert_type(cert, crit_set)
      if ((self.attr_variant == VAR_GENERIC))
        # nothing
      else
        if ((self.attr_variant == VAR_TLS_CLIENT) || (self.attr_variant == VAR_TLS_SERVER))
          if ((get_netscape_cert_type_bit(cert, NSCT_SSL_CA)).equal?(false))
            raise ValidatorException.new("Invalid Netscape CertType extension for SSL CA " + "certificate", ValidatorException::T_CA_EXTENSIONS, cert)
          end
          crit_set.remove(OID_NETSCAPE_CERT_TYPE)
        else
          if ((self.attr_variant == VAR_CODE_SIGNING) || (self.attr_variant == VAR_JCE_SIGNING))
            if ((get_netscape_cert_type_bit(cert, NSCT_CODE_SIGNING_CA)).equal?(false))
              raise ValidatorException.new("Invalid Netscape CertType extension for code " + "signing CA certificate", ValidatorException::T_CA_EXTENSIONS, cert)
            end
            crit_set.remove(OID_NETSCAPE_CERT_TYPE)
          else
            raise CertificateException.new("Unknown variant " + (self.attr_variant).to_s)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate, String] }
      # 
      # Get the value of the specified bit in the Netscape certificate type
      # extension. If the extension is not present at all, we return true.
      def get_netscape_cert_type_bit(cert, type)
        begin
          ext = nil
          if (cert.is_a?(X509CertImpl))
            cert_impl = cert
            oid = OBJID_NETSCAPE_CERT_TYPE
            ext = cert_impl.get_extension(oid)
            if ((ext).nil?)
              return true
            end
          else
            ext_val = cert.get_extension_value(OID_NETSCAPE_CERT_TYPE)
            if ((ext_val).nil?)
              return true
            end
            in_ = DerInputStream.new(ext_val)
            encoded = in_.get_octet_string
            encoded = DerValue.new(encoded).get_unaligned_bit_string.to_byte_array
            ext = NetscapeCertTypeExtension.new(encoded)
          end
          val = ext.get(type)
          return val.boolean_value
        rescue IOException => e
          return false
        end
      end
    }
    
    typesig { [X509Certificate, JavaSet, ::Java::Int] }
    def check_basic_constraints(cert, crit_set, index)
      crit_set.remove(OID_BASIC_CONSTRAINTS)
      constraints = cert.get_basic_constraints
      # reject, if extension missing or not a CA (constraints == -1)
      if (constraints < 0)
        raise ValidatorException.new("End user tried to act as a CA", ValidatorException::T_CA_EXTENSIONS, cert)
      end
      if (index - 1 > constraints)
        raise ValidatorException.new("Violated path length constraints", ValidatorException::T_CA_EXTENSIONS, cert)
      end
    end
    
    typesig { [X509Certificate, JavaSet] }
    # 
    # Verify the key usage and extended key usage for intermediate
    # certificates.
    def check_key_usage(cert, crit_set)
      crit_set.remove(OID_KEY_USAGE)
      # EKU irrelevant in CA certificates
      crit_set.remove(OID_EXTENDED_KEY_USAGE)
      # check key usage extension
      key_usage_info = cert.get_key_usage
      if (!(key_usage_info).nil?)
        # keyUsageInfo[5] is for keyCertSign.
        if ((key_usage_info.attr_length < 6) || ((key_usage_info[5]).equal?(false)))
          raise ValidatorException.new("Wrong key usage: expected keyCertSign", ValidatorException::T_CA_EXTENSIONS, cert)
        end
      end
    end
    
    typesig { [Array.typed(X509Certificate)] }
    # 
    # Build a trusted certificate chain. This method always returns a chain
    # with a trust anchor as the final cert in the chain. If no trust anchor
    # could be found, a CertificateException is thrown.
    def build_trusted_chain(chain)
      c = ArrayList.new(chain.attr_length)
      # scan chain starting at EE cert
      # if a trusted certificate is found, append it and return
      i = 0
      while i < chain.attr_length
        cert = chain[i]
        trusted_cert = get_trusted_certificate(cert)
        if (!(trusted_cert).nil?)
          c.add(trusted_cert)
          return c.to_array(CHAIN0)
        end
        c.add(cert)
        ((i += 1) - 1)
      end
      # check if we can append a trusted cert
      cert_ = chain[chain.attr_length - 1]
      subject = cert_.get_subject_x500principal
      issuer = cert_.get_issuer_x500principal
      if (((subject == issuer)).equal?(false))
        list = @trusted_x500principals.get(issuer)
        if (!(list).nil?)
          trusted_cert_ = list.iterator.next
          c.add(trusted_cert_)
          return c.to_array(CHAIN0)
        end
      end
      # no trusted cert found, error
      raise ValidatorException.new(ValidatorException::T_NO_TRUST_ANCHOR)
    end
    
    typesig { [X509Certificate] }
    # 
    # Return a trusted certificate that matches the input certificate,
    # or null if no such certificate can be found. This method also handles
    # cases where a CA re-issues a trust anchor with the same public key and
    # same subject and issuer names but a new validity period, etc.
    def get_trusted_certificate(cert)
      cert_subject_name = cert.get_subject_x500principal
      list = @trusted_x500principals.get(cert_subject_name)
      if ((list).nil?)
        return nil
      end
      cert_issuer_name = cert.get_issuer_x500principal
      cert_public_key = cert.get_public_key
      list.each do |mycert|
        if ((mycert == cert))
          return cert
        end
        if (!(mycert.get_issuer_x500principal == cert_issuer_name))
          next
        end
        if (!(mycert.get_public_key == cert_public_key))
          next
        end
        # All tests pass, this must be the one to use...
        return mycert
      end
      return nil
    end
    
    private
    alias_method :initialize__simple_validator, :initialize
  end
  
end

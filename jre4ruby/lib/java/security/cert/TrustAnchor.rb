require "rjava"

# 
# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TrustAnchorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :PublicKey
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::X509, :NameConstraintsExtension
      include_const ::Sun::Security::X509, :X500Name
    }
  end
  
  # 
  # A trust anchor or most-trusted Certification Authority (CA).
  # <p>
  # This class represents a "most-trusted CA", which is used as a trust anchor
  # for validating X.509 certification paths. A most-trusted CA includes the
  # public key of the CA, the CA's name, and any constraints upon the set of
  # paths which may be validated using this key. These parameters can be
  # specified in the form of a trusted <code>X509Certificate</code> or as
  # individual parameters.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # <p>All <code>TrustAnchor</code> objects must be immutable and
  # thread-safe. That is, multiple threads may concurrently invoke the
  # methods defined in this class on a single <code>TrustAnchor</code>
  # object (or more than one) with no ill effects. Requiring
  # <code>TrustAnchor</code> objects to be immutable and thread-safe
  # allows them to be passed around to various pieces of code without
  # worrying about coordinating access. This stipulation applies to all
  # public fields and methods of this class and any added or overridden
  # by subclasses.
  # 
  # @see PKIXParameters#PKIXParameters(Set)
  # @see PKIXBuilderParameters#PKIXBuilderParameters(Set, CertSelector)
  # 
  # @since       1.4
  # @author      Sean Mullan
  class TrustAnchor 
    include_class_members TrustAnchorImports
    
    attr_accessor :pub_key
    alias_method :attr_pub_key, :pub_key
    undef_method :pub_key
    alias_method :attr_pub_key=, :pub_key=
    undef_method :pub_key=
    
    attr_accessor :ca_name
    alias_method :attr_ca_name, :ca_name
    undef_method :ca_name
    alias_method :attr_ca_name=, :ca_name=
    undef_method :ca_name=
    
    attr_accessor :ca_principal
    alias_method :attr_ca_principal, :ca_principal
    undef_method :ca_principal
    alias_method :attr_ca_principal=, :ca_principal=
    undef_method :ca_principal=
    
    attr_accessor :trusted_cert
    alias_method :attr_trusted_cert, :trusted_cert
    undef_method :trusted_cert
    alias_method :attr_trusted_cert=, :trusted_cert=
    undef_method :trusted_cert=
    
    attr_accessor :nc_bytes
    alias_method :attr_nc_bytes, :nc_bytes
    undef_method :nc_bytes
    alias_method :attr_nc_bytes=, :nc_bytes=
    undef_method :nc_bytes=
    
    attr_accessor :nc
    alias_method :attr_nc, :nc
    undef_method :nc
    alias_method :attr_nc=, :nc=
    undef_method :nc=
    
    typesig { [X509Certificate, Array.typed(::Java::Byte)] }
    # 
    # Creates an instance of <code>TrustAnchor</code> with the specified
    # <code>X509Certificate</code> and optional name constraints, which
    # are intended to be used as additional constraints when validating
    # an X.509 certification path.
    # <p>
    # The name constraints are specified as a byte array. This byte array
    # should contain the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in
    # <a href="http://www.ietf.org/rfc/rfc3280">RFC 3280</a>
    # and X.509. The ASN.1 definition of this structure appears below.
    # 
    # <pre><code>
    # NameConstraints ::= SEQUENCE {
    # permittedSubtrees       [0]     GeneralSubtrees OPTIONAL,
    # excludedSubtrees        [1]     GeneralSubtrees OPTIONAL }
    # 
    # GeneralSubtrees ::= SEQUENCE SIZE (1..MAX) OF GeneralSubtree
    # 
    # GeneralSubtree ::= SEQUENCE {
    # base                    GeneralName,
    # minimum         [0]     BaseDistance DEFAULT 0,
    # maximum         [1]     BaseDistance OPTIONAL }
    # 
    # BaseDistance ::= INTEGER (0..MAX)
    # 
    # GeneralName ::= CHOICE {
    # otherName                       [0]     OtherName,
    # rfc822Name                      [1]     IA5String,
    # dNSName                         [2]     IA5String,
    # x400Address                     [3]     ORAddress,
    # directoryName                   [4]     Name,
    # ediPartyName                    [5]     EDIPartyName,
    # uniformResourceIdentifier       [6]     IA5String,
    # iPAddress                       [7]     OCTET STRING,
    # registeredID                    [8]     OBJECT IDENTIFIER}
    # </code></pre>
    # <p>
    # Note that the name constraints byte array supplied is cloned to protect
    # against subsequent modifications.
    # 
    # @param trustedCert a trusted <code>X509Certificate</code>
    # @param nameConstraints a byte array containing the ASN.1 DER encoding of
    # a NameConstraints extension to be used for checking name constraints.
    # Only the value of the extension is included, not the OID or criticality
    # flag. Specify <code>null</code> to omit the parameter.
    # @throws IllegalArgumentException if the name constraints cannot be
    # decoded
    # @throws NullPointerException if the specified
    # <code>X509Certificate</code> is <code>null</code>
    def initialize(trusted_cert, name_constraints)
      @pub_key = nil
      @ca_name = nil
      @ca_principal = nil
      @trusted_cert = nil
      @nc_bytes = nil
      @nc = nil
      if ((trusted_cert).nil?)
        raise NullPointerException.new("the trustedCert parameter must " + "be non-null")
      end
      @trusted_cert = trusted_cert
      @pub_key = nil
      @ca_name = nil
      @ca_principal = nil
      set_name_constraints(name_constraints)
    end
    
    typesig { [X500Principal, PublicKey, Array.typed(::Java::Byte)] }
    # 
    # Creates an instance of <code>TrustAnchor</code> where the
    # most-trusted CA is specified as an X500Principal and public key.
    # Name constraints are an optional parameter, and are intended to be used
    # as additional constraints when validating an X.509 certification path.
    # <p>
    # The name constraints are specified as a byte array. This byte array
    # contains the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in RFC 3280
    # and X.509. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #TrustAnchor(X509Certificate, byte[])
    # TrustAnchor(X509Certificate trustedCert, byte[] nameConstraints) }.
    # <p>
    # Note that the name constraints byte array supplied here is cloned to
    # protect against subsequent modifications.
    # 
    # @param caPrincipal the name of the most-trusted CA as X500Principal
    # @param pubKey the public key of the most-trusted CA
    # @param nameConstraints a byte array containing the ASN.1 DER encoding of
    # a NameConstraints extension to be used for checking name constraints.
    # Only the value of the extension is included, not the OID or criticality
    # flag. Specify <code>null</code> to omit the parameter.
    # @throws NullPointerException if the specified <code>caPrincipal</code> or
    # <code>pubKey</code> parameter is <code>null</code>
    # @since 1.5
    def initialize(ca_principal, pub_key, name_constraints)
      @pub_key = nil
      @ca_name = nil
      @ca_principal = nil
      @trusted_cert = nil
      @nc_bytes = nil
      @nc = nil
      if (((ca_principal).nil?) || ((pub_key).nil?))
        raise NullPointerException.new
      end
      @trusted_cert = nil
      @ca_principal = ca_principal
      @ca_name = ca_principal.get_name
      @pub_key = pub_key
      set_name_constraints(name_constraints)
    end
    
    typesig { [String, PublicKey, Array.typed(::Java::Byte)] }
    # 
    # Creates an instance of <code>TrustAnchor</code> where the
    # most-trusted CA is specified as a distinguished name and public key.
    # Name constraints are an optional parameter, and are intended to be used
    # as additional constraints when validating an X.509 certification path.
    # <p>
    # The name constraints are specified as a byte array. This byte array
    # contains the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in RFC 3280
    # and X.509. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #TrustAnchor(X509Certificate, byte[])
    # TrustAnchor(X509Certificate trustedCert, byte[] nameConstraints) }.
    # <p>
    # Note that the name constraints byte array supplied here is cloned to
    # protect against subsequent modifications.
    # 
    # @param caName the X.500 distinguished name of the most-trusted CA in
    # <a href="http://www.ietf.org/rfc/rfc2253.txt">RFC 2253</a>
    # <code>String</code> format
    # @param pubKey the public key of the most-trusted CA
    # @param nameConstraints a byte array containing the ASN.1 DER encoding of
    # a NameConstraints extension to be used for checking name constraints.
    # Only the value of the extension is included, not the OID or criticality
    # flag. Specify <code>null</code> to omit the parameter.
    # @throws IllegalArgumentException if the specified <code>
    # caName</code> parameter is empty <code>(caName.length() == 0)</code>
    # or incorrectly formatted or the name constraints cannot be decoded
    # @throws NullPointerException if the specified <code>caName</code> or
    # <code>pubKey</code> parameter is <code>null</code>
    def initialize(ca_name, pub_key, name_constraints)
      @pub_key = nil
      @ca_name = nil
      @ca_principal = nil
      @trusted_cert = nil
      @nc_bytes = nil
      @nc = nil
      if ((pub_key).nil?)
        raise NullPointerException.new("the pubKey parameter must be " + "non-null")
      end
      if ((ca_name).nil?)
        raise NullPointerException.new("the caName parameter must be " + "non-null")
      end
      if ((ca_name.length).equal?(0))
        raise IllegalArgumentException.new("the caName " + "parameter must be a non-empty String")
      end
      # check if caName is formatted correctly
      @ca_principal = X500Principal.new(ca_name)
      @pub_key = pub_key
      @ca_name = ca_name
      @trusted_cert = nil
      set_name_constraints(name_constraints)
    end
    
    typesig { [] }
    # 
    # Returns the most-trusted CA certificate.
    # 
    # @return a trusted <code>X509Certificate</code> or <code>null</code>
    # if the trust anchor was not specified as a trusted certificate
    def get_trusted_cert
      return @trusted_cert
    end
    
    typesig { [] }
    # 
    # Returns the name of the most-trusted CA as an X500Principal.
    # 
    # @return the X.500 distinguished name of the most-trusted CA, or
    # <code>null</code> if the trust anchor was not specified as a trusted
    # public key and name or X500Principal pair
    # @since 1.5
    def get_ca
      return @ca_principal
    end
    
    typesig { [] }
    # 
    # Returns the name of the most-trusted CA in RFC 2253 <code>String</code>
    # format.
    # 
    # @return the X.500 distinguished name of the most-trusted CA, or
    # <code>null</code> if the trust anchor was not specified as a trusted
    # public key and name or X500Principal pair
    def get_caname
      return @ca_name
    end
    
    typesig { [] }
    # 
    # Returns the public key of the most-trusted CA.
    # 
    # @return the public key of the most-trusted CA, or <code>null</code>
    # if the trust anchor was not specified as a trusted public key and name
    # or X500Principal pair
    def get_capublic_key
      return @pub_key
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Decode the name constraints and clone them if not null.
    def set_name_constraints(bytes)
      if ((bytes).nil?)
        @nc_bytes = nil
        @nc = nil
      else
        @nc_bytes = bytes.clone
        # validate DER encoding
        begin
          @nc = NameConstraintsExtension.new(Boolean::FALSE, bytes)
        rescue IOException => ioe
          iae = IllegalArgumentException.new(ioe.get_message)
          iae.init_cause(ioe)
          raise iae
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns the name constraints parameter. The specified name constraints
    # are associated with this trust anchor and are intended to be used
    # as additional constraints when validating an X.509 certification path.
    # <p>
    # The name constraints are returned as a byte array. This byte array
    # contains the DER encoded form of the name constraints, as they
    # would appear in the NameConstraints structure defined in RFC 3280
    # and X.509. The ASN.1 notation for this structure is supplied in the
    # documentation for
    # {@link #TrustAnchor(X509Certificate, byte[])
    # TrustAnchor(X509Certificate trustedCert, byte[] nameConstraints) }.
    # <p>
    # Note that the byte array returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return a byte array containing the ASN.1 DER encoding of
    # a NameConstraints extension used for checking name constraints,
    # or <code>null</code> if not set.
    def get_name_constraints
      return ((@nc_bytes).nil? ? nil : @nc_bytes.clone)
    end
    
    typesig { [] }
    # 
    # Returns a formatted string describing the <code>TrustAnchor</code>.
    # 
    # @return a formatted string describing the <code>TrustAnchor</code>
    def to_s
      sb = StringBuffer.new
      sb.append("[\n")
      if (!(@pub_key).nil?)
        sb.append("  Trusted CA Public Key: " + (@pub_key.to_s).to_s + "\n")
        sb.append("  Trusted CA Issuer Name: " + (String.value_of(@ca_name)).to_s + "\n")
      else
        sb.append("  Trusted CA cert: " + (@trusted_cert.to_s).to_s + "\n")
      end
      if (!(@nc).nil?)
        sb.append("  Name Constraints: " + (@nc.to_s).to_s + "\n")
      end
      return sb.to_s
    end
    
    private
    alias_method :initialize__trust_anchor, :initialize
  end
  
end

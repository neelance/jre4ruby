require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X509CRLSelectorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::X509, :CRLNumberExtension
      include_const ::Sun::Security::X509, :X500Name
    }
  end
  
  # 
  # A <code>CRLSelector</code> that selects <code>X509CRLs</code> that
  # match all specified criteria. This class is particularly useful when
  # selecting CRLs from a <code>CertStore</code> to check revocation status
  # of a particular certificate.
  # <p>
  # When first constructed, an <code>X509CRLSelector</code> has no criteria
  # enabled and each of the <code>get</code> methods return a default
  # value (<code>null</code>). Therefore, the {@link #match match} method
  # would return <code>true</code> for any <code>X509CRL</code>. Typically,
  # several criteria are enabled (by calling {@link #setIssuers setIssuers}
  # or {@link #setDateAndTime setDateAndTime}, for instance) and then the
  # <code>X509CRLSelector</code> is passed to
  # {@link CertStore#getCRLs CertStore.getCRLs} or some similar
  # method.
  # <p>
  # Please refer to <a href="http://www.ietf.org/rfc/rfc3280.txt">RFC 3280:
  # Internet X.509 Public Key Infrastructure Certificate and CRL Profile</a>
  # for definitions of the X.509 CRL fields and extensions mentioned below.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CRLSelector
  # @see X509CRL
  # 
  # @since       1.4
  # @author      Steve Hanna
  class X509CRLSelector 
    include_class_members X509CRLSelectorImports
    include CRLSelector
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :issuer_names
    alias_method :attr_issuer_names, :issuer_names
    undef_method :issuer_names
    alias_method :attr_issuer_names=, :issuer_names=
    undef_method :issuer_names=
    
    attr_accessor :issuer_x500principals
    alias_method :attr_issuer_x500principals, :issuer_x500principals
    undef_method :issuer_x500principals
    alias_method :attr_issuer_x500principals=, :issuer_x500principals=
    undef_method :issuer_x500principals=
    
    attr_accessor :min_crl
    alias_method :attr_min_crl, :min_crl
    undef_method :min_crl
    alias_method :attr_min_crl=, :min_crl=
    undef_method :min_crl=
    
    attr_accessor :max_crl
    alias_method :attr_max_crl, :max_crl
    undef_method :max_crl
    alias_method :attr_max_crl=, :max_crl=
    undef_method :max_crl=
    
    attr_accessor :date_and_time
    alias_method :attr_date_and_time, :date_and_time
    undef_method :date_and_time
    alias_method :attr_date_and_time=, :date_and_time=
    undef_method :date_and_time=
    
    attr_accessor :cert_checking
    alias_method :attr_cert_checking, :cert_checking
    undef_method :cert_checking
    alias_method :attr_cert_checking=, :cert_checking=
    undef_method :cert_checking=
    
    typesig { [] }
    # 
    # Creates an <code>X509CRLSelector</code>. Initially, no criteria are set
    # so any <code>X509CRL</code> will match.
    def initialize
      @issuer_names = nil
      @issuer_x500principals = nil
      @min_crl = nil
      @max_crl = nil
      @date_and_time = nil
      @cert_checking = nil
    end
    
    typesig { [Collection] }
    # 
    # Sets the issuerNames criterion. The issuer distinguished name in the
    # <code>X509CRL</code> must match at least one of the specified
    # distinguished names. If <code>null</code>, any issuer distinguished name
    # will do.
    # <p>
    # This method allows the caller to specify, with a single method call,
    # the complete set of issuer names which <code>X509CRLs</code> may contain.
    # The specified value replaces the previous value for the issuerNames
    # criterion.
    # <p>
    # The <code>names</code> parameter (if not <code>null</code>) is a
    # <code>Collection</code> of <code>X500Principal</code>s.
    # <p>
    # Note that the <code>names</code> parameter can contain duplicate
    # distinguished names, but they may be removed from the
    # <code>Collection</code> of names returned by the
    # {@link #getIssuers getIssuers} method.
    # <p>
    # Note that a copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @param issuers a <code>Collection</code> of X500Principals
    # (or <code>null</code>)
    # @see #getIssuers
    # @since 1.5
    def set_issuers(issuers)
      if (((issuers).nil?) || issuers.is_empty)
        @issuer_names = nil
        @issuer_x500principals = nil
      else
        # clone
        @issuer_x500principals = HashSet.new(issuers)
        @issuer_names = HashSet.new
        @issuer_x500principals.each do |p|
          @issuer_names.add(p.get_encoded)
        end
      end
    end
    
    typesig { [Collection] }
    # 
    # <strong>Note:</strong> use {@linkplain #setIssuers(Collection)} instead
    # or only specify the byte array form of distinguished names when using
    # this method. See {@link #addIssuerName(String)} for more information.
    # <p>
    # Sets the issuerNames criterion. The issuer distinguished name in the
    # <code>X509CRL</code> must match at least one of the specified
    # distinguished names. If <code>null</code>, any issuer distinguished name
    # will do.
    # <p>
    # This method allows the caller to specify, with a single method call,
    # the complete set of issuer names which <code>X509CRLs</code> may contain.
    # The specified value replaces the previous value for the issuerNames
    # criterion.
    # <p>
    # The <code>names</code> parameter (if not <code>null</code>) is a
    # <code>Collection</code> of names. Each name is a <code>String</code>
    # or a byte array representing a distinguished name (in
    # <a href="http://www.ietf.org/rfc/rfc2253.txt">RFC 2253</a> or
    # ASN.1 DER encoded form, respectively). If <code>null</code> is supplied
    # as the value for this argument, no issuerNames check will be performed.
    # <p>
    # Note that the <code>names</code> parameter can contain duplicate
    # distinguished names, but they may be removed from the
    # <code>Collection</code> of names returned by the
    # {@link #getIssuerNames getIssuerNames} method.
    # <p>
    # If a name is specified as a byte array, it should contain a single DER
    # encoded distinguished name, as defined in X.501. The ASN.1 notation for
    # this structure is as follows.
    # <pre><code>
    # Name ::= CHOICE {
    # RDNSequence }
    # 
    # RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
    # 
    # RelativeDistinguishedName ::=
    # SET SIZE (1 .. MAX) OF AttributeTypeAndValue
    # 
    # AttributeTypeAndValue ::= SEQUENCE {
    # type     AttributeType,
    # value    AttributeValue }
    # 
    # AttributeType ::= OBJECT IDENTIFIER
    # 
    # AttributeValue ::= ANY DEFINED BY AttributeType
    # ....
    # DirectoryString ::= CHOICE {
    # teletexString           TeletexString (SIZE (1..MAX)),
    # printableString         PrintableString (SIZE (1..MAX)),
    # universalString         UniversalString (SIZE (1..MAX)),
    # utf8String              UTF8String (SIZE (1.. MAX)),
    # bmpString               BMPString (SIZE (1..MAX)) }
    # </code></pre>
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @param names a <code>Collection</code> of names (or <code>null</code>)
    # @throws IOException if a parsing error occurs
    # @see #getIssuerNames
    def set_issuer_names(names)
      if ((names).nil? || (names.size).equal?(0))
        @issuer_names = nil
        @issuer_x500principals = nil
      else
        temp_names = clone_and_check_issuer_names(names)
        # Ensure that we either set both of these or neither
        @issuer_x500principals = parse_issuer_names(temp_names)
        @issuer_names = temp_names
      end
    end
    
    typesig { [X500Principal] }
    # 
    # Adds a name to the issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names.
    # <p>
    # This method allows the caller to add a name to the set of issuer names
    # which <code>X509CRLs</code> may contain. The specified name is added to
    # any previous value for the issuerNames criterion.
    # If the specified name is a duplicate, it may be ignored.
    # 
    # @param issuer the issuer as X500Principal
    # @since 1.5
    def add_issuer(issuer)
      add_issuer_name_internal(issuer.get_encoded, issuer)
    end
    
    typesig { [String] }
    # 
    # <strong>Denigrated</strong>, use
    # {@linkplain #addIssuer(X500Principal)} or
    # {@linkplain #addIssuerName(byte[])} instead. This method should not be
    # relied on as it can fail to match some CRLs because of a loss of
    # encoding information in the RFC 2253 String form of some distinguished
    # names.
    # <p>
    # Adds a name to the issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names.
    # <p>
    # This method allows the caller to add a name to the set of issuer names
    # which <code>X509CRLs</code> may contain. The specified name is added to
    # any previous value for the issuerNames criterion.
    # If the specified name is a duplicate, it may be ignored.
    # 
    # @param name the name in RFC 2253 form
    # @throws IOException if a parsing error occurs
    def add_issuer_name(name)
      add_issuer_name_internal(name, X500Name.new(name).as_x500principal)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Adds a name to the issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names.
    # <p>
    # This method allows the caller to add a name to the set of issuer names
    # which <code>X509CRLs</code> may contain. The specified name is added to
    # any previous value for the issuerNames criterion. If the specified name
    # is a duplicate, it may be ignored.
    # If a name is specified as a byte array, it should contain a single DER
    # encoded distinguished name, as defined in X.501. The ASN.1 notation for
    # this structure is as follows.
    # <p>
    # The name is provided as a byte array. This byte array should contain
    # a single DER encoded distinguished name, as defined in X.501. The ASN.1
    # notation for this structure appears in the documentation for
    # {@link #setIssuerNames setIssuerNames(Collection names)}.
    # <p>
    # Note that the byte array supplied here is cloned to protect against
    # subsequent modifications.
    # 
    # @param name a byte array containing the name in ASN.1 DER encoded form
    # @throws IOException if a parsing error occurs
    def add_issuer_name(name)
      # clone because byte arrays are modifiable
      add_issuer_name_internal(name.clone, X500Name.new(name).as_x500principal)
    end
    
    typesig { [Object, X500Principal] }
    # 
    # A private method that adds a name (String or byte array) to the
    # issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names.
    # 
    # @param name the name in string or byte array form
    # @param principal the name in X500Principal form
    # @throws IOException if a parsing error occurs
    def add_issuer_name_internal(name, principal)
      if ((@issuer_names).nil?)
        @issuer_names = HashSet.new
      end
      if ((@issuer_x500principals).nil?)
        @issuer_x500principals = HashSet.new
      end
      @issuer_names.add(name)
      @issuer_x500principals.add(principal)
    end
    
    class_module.module_eval {
      typesig { [Collection] }
      # 
      # Clone and check an argument of the form passed to
      # setIssuerNames. Throw an IOException if the argument is malformed.
      # 
      # @param names a <code>Collection</code> of names. Each entry is a
      # String or a byte array (the name, in string or ASN.1
      # DER encoded form, respectively). <code>null</code> is
      # not an acceptable value.
      # @return a deep copy of the specified <code>Collection</code>
      # @throws IOException if a parsing error occurs
      def clone_and_check_issuer_names(names)
        names_copy = HashSet.new
        i = names.iterator
        while (i.has_next)
          name_object = i.next
          if (!(name_object.is_a?(Array.typed(::Java::Byte))) && !(name_object.is_a?(String)))
            raise IOException.new("name not byte array or String")
          end
          if (name_object.is_a?(Array.typed(::Java::Byte)))
            names_copy.add((name_object).clone)
          else
            names_copy.add(name_object)
          end
        end
        return (names_copy)
      end
      
      typesig { [Collection] }
      # 
      # Clone an argument of the form passed to setIssuerNames.
      # Throw a RuntimeException if the argument is malformed.
      # <p>
      # This method wraps cloneAndCheckIssuerNames, changing any IOException
      # into a RuntimeException. This method should be used when the object being
      # cloned has already been checked, so there should never be any exceptions.
      # 
      # @param names a <code>Collection</code> of names. Each entry is a
      # String or a byte array (the name, in string or ASN.1
      # DER encoded form, respectively). <code>null</code> is
      # not an acceptable value.
      # @return a deep copy of the specified <code>Collection</code>
      # @throws RuntimeException if a parsing error occurs
      def clone_issuer_names(names)
        begin
          return clone_and_check_issuer_names(names)
        rescue IOException => ioe
          raise RuntimeException.new(ioe)
        end
      end
      
      typesig { [Collection] }
      # 
      # Parse an argument of the form passed to setIssuerNames,
      # returning a Collection of issuerX500Principals.
      # Throw an IOException if the argument is malformed.
      # 
      # @param names a <code>Collection</code> of names. Each entry is a
      # String or a byte array (the name, in string or ASN.1
      # DER encoded form, respectively). <Code>Null</Code> is
      # not an acceptable value.
      # @return a HashSet of issuerX500Principals
      # @throws IOException if a parsing error occurs
      def parse_issuer_names(names)
        x500principals = HashSet.new
        t = names.iterator
        while t.has_next
          name_object = t.next
          if (name_object.is_a?(String))
            x500principals.add(X500Name.new(name_object).as_x500principal)
          else
            begin
              x500principals.add(X500Principal.new(name_object))
            rescue IllegalArgumentException => e
              raise IOException.new("Invalid name").init_cause(e)
            end
          end
        end
        return x500principals
      end
    }
    
    typesig { [BigInteger] }
    # 
    # Sets the minCRLNumber criterion. The <code>X509CRL</code> must have a
    # CRL number extension whose value is greater than or equal to the
    # specified value. If <code>null</code>, no minCRLNumber check will be
    # done.
    # 
    # @param minCRL the minimum CRL number accepted (or <code>null</code>)
    def set_min_crlnumber(min_crl)
      @min_crl = min_crl
    end
    
    typesig { [BigInteger] }
    # 
    # Sets the maxCRLNumber criterion. The <code>X509CRL</code> must have a
    # CRL number extension whose value is less than or equal to the
    # specified value. If <code>null</code>, no maxCRLNumber check will be
    # done.
    # 
    # @param maxCRL the maximum CRL number accepted (or <code>null</code>)
    def set_max_crlnumber(max_crl)
      @max_crl = max_crl
    end
    
    typesig { [Date] }
    # 
    # Sets the dateAndTime criterion. The specified date must be
    # equal to or later than the value of the thisUpdate component
    # of the <code>X509CRL</code> and earlier than the value of the
    # nextUpdate component. There is no match if the <code>X509CRL</code>
    # does not contain a nextUpdate component.
    # If <code>null</code>, no dateAndTime check will be done.
    # <p>
    # Note that the <code>Date</code> supplied here is cloned to protect
    # against subsequent modifications.
    # 
    # @param dateAndTime the <code>Date</code> to match against
    # (or <code>null</code>)
    # @see #getDateAndTime
    def set_date_and_time(date_and_time)
      if ((date_and_time).nil?)
        @date_and_time = nil
      else
        @date_and_time = date_and_time.clone
      end
    end
    
    typesig { [X509Certificate] }
    # 
    # Sets the certificate being checked. This is not a criterion. Rather,
    # it is optional information that may help a <code>CertStore</code>
    # find CRLs that would be relevant when checking revocation for the
    # specified certificate. If <code>null</code> is specified, then no
    # such optional information is provided.
    # 
    # @param cert the <code>X509Certificate</code> being checked
    # (or <code>null</code>)
    # @see #getCertificateChecking
    def set_certificate_checking(cert)
      @cert_checking = cert
    end
    
    typesig { [] }
    # 
    # Returns the issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names. If the value returned is <code>null</code>, any
    # issuer distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # unmodifiable <code>Collection</code> of <code>X500Principal</code>s.
    # 
    # @return an unmodifiable <code>Collection</code> of names
    # (or <code>null</code>)
    # @see #setIssuers
    # @since 1.5
    def get_issuers
      if ((@issuer_x500principals).nil?)
        return nil
      end
      return Collections.unmodifiable_collection(@issuer_x500principals)
    end
    
    typesig { [] }
    # 
    # Returns a copy of the issuerNames criterion. The issuer distinguished
    # name in the <code>X509CRL</code> must match at least one of the specified
    # distinguished names. If the value returned is <code>null</code>, any
    # issuer distinguished name will do.
    # <p>
    # If the value returned is not <code>null</code>, it is a
    # <code>Collection</code> of names. Each name is a <code>String</code>
    # or a byte array representing a distinguished name (in RFC 2253 or
    # ASN.1 DER encoded form, respectively).  Note that the
    # <code>Collection</code> returned may contain duplicate names.
    # <p>
    # If a name is specified as a byte array, it should contain a single DER
    # encoded distinguished name, as defined in X.501. The ASN.1 notation for
    # this structure is given in the documentation for
    # {@link #setIssuerNames setIssuerNames(Collection names)}.
    # <p>
    # Note that a deep copy is performed on the <code>Collection</code> to
    # protect against subsequent modifications.
    # 
    # @return a <code>Collection</code> of names (or <code>null</code>)
    # @see #setIssuerNames
    def get_issuer_names
      if ((@issuer_names).nil?)
        return nil
      end
      return clone_issuer_names(@issuer_names)
    end
    
    typesig { [] }
    # 
    # Returns the minCRLNumber criterion. The <code>X509CRL</code> must have a
    # CRL number extension whose value is greater than or equal to the
    # specified value. If <code>null</code>, no minCRLNumber check will be done.
    # 
    # @return the minimum CRL number accepted (or <code>null</code>)
    def get_min_crl
      return @min_crl
    end
    
    typesig { [] }
    # 
    # Returns the maxCRLNumber criterion. The <code>X509CRL</code> must have a
    # CRL number extension whose value is less than or equal to the
    # specified value. If <code>null</code>, no maxCRLNumber check will be
    # done.
    # 
    # @return the maximum CRL number accepted (or <code>null</code>)
    def get_max_crl
      return @max_crl
    end
    
    typesig { [] }
    # 
    # Returns the dateAndTime criterion. The specified date must be
    # equal to or later than the value of the thisUpdate component
    # of the <code>X509CRL</code> and earlier than the value of the
    # nextUpdate component. There is no match if the
    # <code>X509CRL</code> does not contain a nextUpdate component.
    # If <code>null</code>, no dateAndTime check will be done.
    # <p>
    # Note that the <code>Date</code> returned is cloned to protect against
    # subsequent modifications.
    # 
    # @return the <code>Date</code> to match against (or <code>null</code>)
    # @see #setDateAndTime
    def get_date_and_time
      if ((@date_and_time).nil?)
        return nil
      end
      return @date_and_time.clone
    end
    
    typesig { [] }
    # 
    # Returns the certificate being checked. This is not a criterion. Rather,
    # it is optional information that may help a <code>CertStore</code>
    # find CRLs that would be relevant when checking revocation for the
    # specified certificate. If the value returned is <code>null</code>, then
    # no such optional information is provided.
    # 
    # @return the certificate being checked (or <code>null</code>)
    # @see #setCertificateChecking
    def get_certificate_checking
      return @cert_checking
    end
    
    typesig { [] }
    # 
    # Returns a printable representation of the <code>X509CRLSelector</code>.
    # 
    # @return a <code>String</code> describing the contents of the
    # <code>X509CRLSelector</code>.
    def to_s
      sb = StringBuffer.new
      sb.append("X509CRLSelector: [\n")
      if (!(@issuer_names).nil?)
        sb.append("  IssuerNames:\n")
        i = @issuer_names.iterator
        while (i.has_next)
          sb.append("    " + (i.next).to_s + "\n")
        end
      end
      if (!(@min_crl).nil?)
        sb.append("  minCRLNumber: " + (@min_crl).to_s + "\n")
      end
      if (!(@max_crl).nil?)
        sb.append("  maxCRLNumber: " + (@max_crl).to_s + "\n")
      end
      if (!(@date_and_time).nil?)
        sb.append("  dateAndTime: " + (@date_and_time).to_s + "\n")
      end
      if (!(@cert_checking).nil?)
        sb.append("  Certificate being checked: " + (@cert_checking).to_s + "\n")
      end
      sb.append("]")
      return sb.to_s
    end
    
    typesig { [CRL] }
    # 
    # Decides whether a <code>CRL</code> should be selected.
    # 
    # @param crl the <code>CRL</code> to be checked
    # @return <code>true</code> if the <code>CRL</code> should be selected,
    # <code>false</code> otherwise
    def match(crl)
      if (!(crl.is_a?(X509CRL)))
        return false
      end
      xcrl = crl
      # match on issuer name
      if (!(@issuer_names).nil?)
        issuer = xcrl.get_issuer_x500principal
        i = @issuer_x500principals.iterator
        found = false
        while (!found && i.has_next)
          if ((i.next == issuer))
            found = true
          end
        end
        if (!found)
          if (!(Debug).nil?)
            Debug.println("X509CRLSelector.match: issuer DNs " + "don't match")
          end
          return false
        end
      end
      if ((!(@min_crl).nil?) || (!(@max_crl).nil?))
        # Get CRL number extension from CRL
        crl_num_ext_val = xcrl.get_extension_value("2.5.29.20")
        if ((crl_num_ext_val).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CRLSelector.match: no CRLNumber")
          end
        end
        crl_num = nil
        begin
          in_ = DerInputStream.new(crl_num_ext_val)
          encoded = in_.get_octet_string
          crl_num_ext = CRLNumberExtension.new(Boolean::FALSE, encoded)
          crl_num = crl_num_ext.get(CRLNumberExtension::NUMBER)
        rescue IOException => ex
          if (!(Debug).nil?)
            Debug.println("X509CRLSelector.match: exception in " + "decoding CRL number")
          end
          return false
        end
        # match on minCRLNumber
        if (!(@min_crl).nil?)
          if ((crl_num <=> @min_crl) < 0)
            if (!(Debug).nil?)
              Debug.println("X509CRLSelector.match: CRLNumber too small")
            end
            return false
          end
        end
        # match on maxCRLNumber
        if (!(@max_crl).nil?)
          if ((crl_num <=> @max_crl) > 0)
            if (!(Debug).nil?)
              Debug.println("X509CRLSelector.match: CRLNumber too large")
            end
            return false
          end
        end
      end
      # match on dateAndTime
      if (!(@date_and_time).nil?)
        crl_this_update = xcrl.get_this_update
        next_update = xcrl.get_next_update
        if ((next_update).nil?)
          if (!(Debug).nil?)
            Debug.println("X509CRLSelector.match: nextUpdate null")
          end
          return false
        end
        if (crl_this_update.after(@date_and_time) || next_update.before(@date_and_time))
          if (!(Debug).nil?)
            Debug.println("X509CRLSelector.match: update out of range")
          end
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns a copy of this object.
    # 
    # @return the copy
    def clone
      begin
        copy = super
        if (!(@issuer_names).nil?)
          copy.attr_issuer_names = HashSet.new(@issuer_names)
          copy.attr_issuer_x500principals = HashSet.new(@issuer_x500principals)
        end
        return copy
      rescue CloneNotSupportedException => e
        # Cannot happen
        raise InternalError.new(e.to_s)
      end
    end
    
    private
    alias_method :initialize__x509crlselector, :initialize
  end
  
end

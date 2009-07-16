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
module Sun::Security::Util
  module HostnameCheckerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include ::Java::Util
      include_const ::Java::Security, :Principal
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Net::Util, :IPAddressUtil
    }
  end
  
  # 
  # Class to check hostnames against the names specified in a certificate as
  # required for TLS and LDAP.
  class HostnameChecker 
    include_class_members HostnameCheckerImports
    
    class_module.module_eval {
      # Constant for a HostnameChecker for TLS
      const_set_lazy(:TYPE_TLS) { 1 }
      const_attr_reader  :TYPE_TLS
      
      const_set_lazy(:INSTANCE_TLS) { HostnameChecker.new(TYPE_TLS) }
      const_attr_reader  :INSTANCE_TLS
      
      # Constant for a HostnameChecker for LDAP
      const_set_lazy(:TYPE_LDAP) { 2 }
      const_attr_reader  :TYPE_LDAP
      
      const_set_lazy(:INSTANCE_LDAP) { HostnameChecker.new(TYPE_LDAP) }
      const_attr_reader  :INSTANCE_LDAP
      
      # constants for subject alt names of type DNS and IP
      const_set_lazy(:ALTNAME_DNS) { 2 }
      const_attr_reader  :ALTNAME_DNS
      
      const_set_lazy(:ALTNAME_IP) { 7 }
      const_attr_reader  :ALTNAME_IP
    }
    
    # the algorithm to follow to perform the check. Currently unused.
    attr_accessor :check_type
    alias_method :attr_check_type, :check_type
    undef_method :check_type
    alias_method :attr_check_type=, :check_type=
    undef_method :check_type=
    
    typesig { [::Java::Byte] }
    def initialize(check_type)
      @check_type = 0
      @check_type = check_type
    end
    
    class_module.module_eval {
      typesig { [::Java::Byte] }
      # 
      # Get a HostnameChecker instance. checkType should be one of the
      # TYPE_* constants defined in this class.
      def get_instance(check_type)
        if ((check_type).equal?(TYPE_TLS))
          return INSTANCE_TLS
        else
          if ((check_type).equal?(TYPE_LDAP))
            return INSTANCE_LDAP
          end
        end
        raise IllegalArgumentException.new("Unknown check type: " + (check_type).to_s)
      end
    }
    
    typesig { [String, X509Certificate] }
    # 
    # Perform the check.
    # 
    # @exception CertificateException if the name does not match any of
    # the names specified in the certificate
    def match(expected_name, cert)
      if (is_ip_address(expected_name))
        match_ip(expected_name, cert)
      else
        match_dns(expected_name, cert)
      end
    end
    
    class_module.module_eval {
      typesig { [String, KerberosPrincipal] }
      # 
      # Perform the check for Kerberos.
      def match(expected_name, principal)
        host_name = get_server_name(principal)
        return (expected_name.equals_ignore_case(host_name))
      end
      
      typesig { [KerberosPrincipal] }
      # 
      # Return the Server name from Kerberos principal.
      def get_server_name(principal)
        if ((principal).nil?)
          return nil
        end
        host_name = nil
        begin
          princ_name = PrincipalName.new(principal.get_name, PrincipalName::KRB_NT_SRV_HST)
          name_parts = princ_name.get_name_strings
          if (name_parts.attr_length >= 2)
            host_name = (name_parts[1]).to_s
          end
        rescue Exception => e
          # ignore
        end
        return host_name
      end
      
      typesig { [String] }
      # 
      # Test whether the given hostname looks like a literal IPv4 or IPv6
      # address. The hostname does not need to be a fully qualified name.
      # 
      # This is not a strict check that performs full input validation.
      # That means if the method returns true, name need not be a correct
      # IP address, rather that it does not represent a valid DNS hostname.
      # Likewise for IP addresses when it returns false.
      def is_ip_address(name)
        if (IPAddressUtil.is_ipv4literal_address(name) || IPAddressUtil.is_ipv6literal_address(name))
          return true
        else
          return false
        end
      end
      
      typesig { [String, X509Certificate] }
      # 
      # Check if the certificate allows use of the given IP address.
      # 
      # From RFC2818:
      # In some cases, the URI is specified as an IP address rather than a
      # hostname. In this case, the iPAddress subjectAltName must be present
      # in the certificate and must exactly match the IP in the URI.
      def match_ip(expected_ip, cert)
        subj_alt_names = cert.get_subject_alternative_names
        if ((subj_alt_names).nil?)
          raise CertificateException.new("No subject alternative names present")
        end
        subj_alt_names.each do |next|
          # For IP address, it needs to be exact match
          if (((next_.get(0)).int_value).equal?(ALTNAME_IP))
            ip_address = next_.get(1)
            if (expected_ip.equals_ignore_case(ip_address))
              return
            end
          end
        end
        raise CertificateException.new("No subject alternative " + "names matching " + "IP address " + expected_ip + " found")
      end
    }
    
    typesig { [String, X509Certificate] }
    # 
    # Check if the certificate allows use of the given DNS name.
    # 
    # From RFC2818:
    # If a subjectAltName extension of type dNSName is present, that MUST
    # be used as the identity. Otherwise, the (most specific) Common Name
    # field in the Subject field of the certificate MUST be used. Although
    # the use of the Common Name is existing practice, it is deprecated and
    # Certification Authorities are encouraged to use the dNSName instead.
    # 
    # Matching is performed using the matching rules specified by
    # [RFC2459].  If more than one identity of a given type is present in
    # the certificate (e.g., more than one dNSName name, a match in any one
    # of the set is considered acceptable.)
    def match_dns(expected_name, cert)
      subj_alt_names = cert.get_subject_alternative_names
      if (!(subj_alt_names).nil?)
        found_dns = false
        subj_alt_names.each do |next|
          if (((next_.get(0)).int_value).equal?(ALTNAME_DNS))
            found_dns = true
            dns_name = next_.get(1)
            if (is_matched(expected_name, dns_name))
              return
            end
          end
        end
        if (found_dns)
          # if certificate contains any subject alt names of type DNS
          # but none match, reject
          raise CertificateException.new("No subject alternative DNS " + "name matching " + expected_name + " found.")
        end
      end
      subject_name = get_subject_x500name(cert)
      der_value = subject_name.find_most_specific_attribute(X500Name.attr_common_name_oid)
      if (!(der_value).nil?)
        begin
          if (is_matched(expected_name, der_value.get_as_string))
            return
          end
        rescue IOException => e
          # ignore
        end
      end
      msg = "No name matching " + expected_name + " found"
      raise CertificateException.new(msg)
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # 
      # Return the subject of a certificate as X500Name, by reparsing if
      # necessary. X500Name should only be used if access to name components
      # is required, in other cases X500Principal is to be prefered.
      # 
      # This method is currently used from within JSSE, do not remove.
      def get_subject_x500name(cert)
        begin
          subject_dn = cert.get_subject_dn
          if (subject_dn.is_a?(X500Name))
            return subject_dn
          else
            subject_x500 = cert.get_subject_x500principal
            return X500Name.new(subject_x500.get_encoded)
          end
        rescue IOException => e
          raise CertificateParsingException.new.init_cause(e)
        end
      end
    }
    
    typesig { [String, String] }
    # 
    # Returns true if name matches against template.<p>
    # 
    # The matching is performed as per RFC 2818 rules for TLS and
    # RFC 2830 rules for LDAP.<p>
    # 
    # The <code>name</code> parameter should represent a DNS name.
    # The <code>template</code> parameter
    # may contain the wildcard character *
    def is_matched(name, template)
      if ((@check_type).equal?(TYPE_TLS))
        return match_all_wildcards(name, template)
      else
        if ((@check_type).equal?(TYPE_LDAP))
          return match_leftmost_wildcard(name, template)
        else
          return false
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      # 
      # Returns true if name matches against template.<p>
      # 
      # According to RFC 2818, section 3.1 -
      # Names may contain the wildcard character * which is
      # considered to match any single domain name component
      # or component fragment.
      # E.g., *.a.com matches foo.a.com but not
      # bar.foo.a.com. f*.com matches foo.com but not bar.com.
      def match_all_wildcards(name, template)
        name = (name.to_lower_case).to_s
        template = (template.to_lower_case).to_s
        name_st = StringTokenizer.new(name, ".")
        template_st = StringTokenizer.new(template, ".")
        if (!(name_st.count_tokens).equal?(template_st.count_tokens))
          return false
        end
        while (name_st.has_more_tokens)
          if (!match_wild_cards(name_st.next_token, template_st.next_token))
            return false
          end
        end
        return true
      end
      
      typesig { [String, String] }
      # 
      # Returns true if name matches against template.<p>
      # 
      # As per RFC 2830, section 3.6 -
      # The "*" wildcard character is allowed.  If present, it applies only
      # to the left-most name component.
      # E.g. *.bar.com would match a.bar.com, b.bar.com, etc. but not
      # bar.com.
      def match_leftmost_wildcard(name, template)
        name = (name.to_lower_case).to_s
        template = (template.to_lower_case).to_s
        # Retreive leftmost component
        template_idx = template.index_of(".")
        name_idx = name.index_of(".")
        if ((template_idx).equal?(-1))
          template_idx = template.length
        end
        if ((name_idx).equal?(-1))
          name_idx = name.length
        end
        if (match_wild_cards(name.substring(0, name_idx), template.substring(0, template_idx)))
          # match rest of the name
          return (template.substring(template_idx) == name.substring(name_idx))
        else
          return false
        end
      end
      
      typesig { [String, String] }
      # 
      # Returns true if the name matches against the template that may
      # contain wildcard char * <p>
      def match_wild_cards(name, template)
        wildcard_idx = template.index_of("*")
        if ((wildcard_idx).equal?(-1))
          return (name == template)
        end
        is_beginning = true
        before_wildcard = ""
        after_wildcard = template
        while (!(wildcard_idx).equal?(-1))
          # match in sequence the non-wildcard chars in the template.
          before_wildcard = (after_wildcard.substring(0, wildcard_idx)).to_s
          after_wildcard = (after_wildcard.substring(wildcard_idx + 1)).to_s
          before_start_idx = name.index_of(before_wildcard)
          if (((before_start_idx).equal?(-1)) || (is_beginning && !(before_start_idx).equal?(0)))
            return false
          end
          is_beginning = false
          # update the match scope
          name = (name.substring(before_start_idx + before_wildcard.length)).to_s
          wildcard_idx = after_wildcard.index_of("*")
        end
        return name.ends_with(after_wildcard)
      end
    }
    
    private
    alias_method :initialize__hostname_checker, :initialize
  end
  
end

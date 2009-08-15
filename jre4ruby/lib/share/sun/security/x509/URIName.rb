require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module URINameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URISyntaxException
      include ::Sun::Security::Util
    }
  end
  
  # This class implements the URIName as required by the GeneralNames
  # ASN.1 object.
  # <p>
  # [RFC3280] When the subjectAltName extension contains a URI, the name MUST be
  # stored in the uniformResourceIdentifier (an IA5String). The name MUST
  # be a non-relative URL, and MUST follow the URL syntax and encoding
  # rules specified in [RFC 1738].  The name must include both a scheme
  # (e.g., "http" or "ftp") and a scheme-specific-part.  The scheme-
  # specific-part must include a fully qualified domain name or IP
  # address as the host.
  # <p>
  # As specified in [RFC 1738], the scheme name is not case-sensitive
  # (e.g., "http" is equivalent to "HTTP").  The host part is also not
  # case-sensitive, but other components of the scheme-specific-part may
  # be case-sensitive. When comparing URIs, conforming implementations
  # MUST compare the scheme and host without regard to case, but assume
  # the remainder of the scheme-specific-part is case sensitive.
  # <p>
  # [RFC1738] In general, URLs are written as follows:
  # <pre>
  # <scheme>:<scheme-specific-part>
  # </pre>
  # A URL contains the name of the scheme being used (<scheme>) followed
  # by a colon and then a string (the <scheme-specific-part>) whose
  # interpretation depends on the scheme.
  # <p>
  # While the syntax for the rest of the URL may vary depending on the
  # particular scheme selected, URL schemes that involve the direct use
  # of an IP-based protocol to a specified host on the Internet use a
  # common syntax for the scheme-specific data:
  # <pre>
  # //<user>:<password>@<host>:<port>/<url-path>
  # </pre>
  # [RFC2732] specifies that an IPv6 address contained inside a URL
  # must be enclosed in square brackets (to allow distinguishing the
  # colons that separate IPv6 components from the colons that separate
  # scheme-specific data.
  # <p>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @author Sean Mullan
  # @author Steve Hanna
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class URIName 
    include_class_members URINameImports
    include GeneralNameInterface
    
    # private attributes
    attr_accessor :uri
    alias_method :attr_uri, :uri
    undef_method :uri
    alias_method :attr_uri=, :uri=
    undef_method :uri=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :host_dns
    alias_method :attr_host_dns, :host_dns
    undef_method :host_dns
    alias_method :attr_host_dns=, :host_dns=
    undef_method :host_dns=
    
    attr_accessor :host_ip
    alias_method :attr_host_ip, :host_ip
    undef_method :host_ip
    alias_method :attr_host_ip=, :host_ip=
    undef_method :host_ip=
    
    typesig { [DerValue] }
    # Create the URIName object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER URIName.
    # @exception IOException on error.
    def initialize(der_value)
      initialize__uriname(der_value.get_ia5string)
    end
    
    typesig { [String] }
    # Create the URIName object with the specified name.
    # 
    # @param name the URIName.
    # @throws IOException if name is not a proper URIName
    def initialize(name)
      @uri = nil
      @host = nil
      @host_dns = nil
      @host_ip = nil
      begin
        @uri = URI.new(name)
      rescue URISyntaxException => use
        raise IOException.new("invalid URI name:" + name).init_cause(use)
      end
      if ((@uri.get_scheme).nil?)
        raise IOException.new("URI name must include scheme:" + name)
      end
      @host = RJava.cast_to_string(@uri.get_host)
      # RFC 3280 says that the host should be non-null, but we allow it to
      # be null because some widely deployed certificates contain CDP
      # extensions with URIs that have no hostname (see bugs 4802236 and
      # 5107944).
      if (!(@host).nil?)
        if ((@host.char_at(0)).equal?(Character.new(?[.ord)))
          # Verify host is a valid IPv6 address name
          ip_v6host = @host.substring(1, @host.length - 1)
          begin
            @host_ip = IPAddressName.new(ip_v6host)
          rescue IOException => ioe
            raise IOException.new("invalid URI name (host " + "portion is not a valid IPv6 address):" + name)
          end
        else
          begin
            @host_dns = DNSName.new(@host)
          rescue IOException => ioe
            # Not a valid DNS Name; see if it is a valid IPv4
            # IPAddressName
            begin
              @host_ip = IPAddressName.new(@host)
            rescue JavaException => ioe2
              raise IOException.new("invalid URI name (host " + "portion is not a valid DNS name, IPv4 address," + " or IPv6 address):" + name)
            end
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [DerValue] }
      # Create the URIName object with the specified name constraint. URI
      # name constraints syntax is different than SubjectAltNames, etc. See
      # 4.2.1.11 of RFC 3280.
      # 
      # @param value the URI name constraint
      # @throws IOException if name is not a proper URI name constraint
      def name_constraint(value)
        uri = nil
        name = value.get_ia5string
        begin
          uri = URI.new(name)
        rescue URISyntaxException => use
          raise IOException.new("invalid URI name constraint:" + name).init_cause(use)
        end
        if ((uri.get_scheme).nil?)
          host = uri.get_scheme_specific_part
          begin
            host_dns = nil
            if ((host.char_at(0)).equal?(Character.new(?..ord)))
              host_dns = DNSName.new(host.substring(1))
            else
              host_dns = DNSName.new(host)
            end
            return URIName.new(uri, host, host_dns)
          rescue IOException => ioe
            raise IOException.new("invalid URI name constraint:" + name).init_cause(ioe)
          end
        else
          raise IOException.new("invalid URI name constraint (should not " + "include scheme):" + name)
        end
      end
    }
    
    typesig { [URI, String, DNSName] }
    def initialize(uri, host, host_dns)
      @uri = nil
      @host = nil
      @host_dns = nil
      @host_ip = nil
      @uri = uri
      @host = host
      @host_dns = host_dns
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return GeneralNameInterface::NAME_URI
    end
    
    typesig { [DerOutputStream] }
    # Encode the URI name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the URIName to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_ia5string(@uri.to_asciistring)
    end
    
    typesig { [] }
    # Convert the name into user readable string.
    def to_s
      return "URIName: " + RJava.cast_to_string(@uri.to_s)
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are equivalent according to RFC2459.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(URIName)))
        return false
      end
      other = obj
      return (@uri == other.get_uri)
    end
    
    typesig { [] }
    # Returns the URIName as a java.net.URI object
    def get_uri
      return @uri
    end
    
    typesig { [] }
    # Returns this URI name.
    def get_name
      return @uri.to_s
    end
    
    typesig { [] }
    # Return the scheme name portion of a URIName
    # 
    # @returns scheme portion of full name
    def get_scheme
      return @uri.get_scheme
    end
    
    typesig { [] }
    # Return the host name or IP address portion of the URIName
    # 
    # @returns host name or IP address portion of full name
    def get_host
      return @host
    end
    
    typesig { [] }
    # Return the host object type; if host name is a
    # DNSName, then this host object does not include any
    # initial "." on the name.
    # 
    # @returns host name as DNSName or IPAddressName
    def get_host_object
      if (!(@host_ip).nil?)
        return @host_ip
      else
        return @host_dns
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      return @uri.hash_code
    end
    
    typesig { [GeneralNameInterface] }
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name
    # (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the naming
    # subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the naming
    # subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but
    # is same type.
    # </ul>.
    # These results are used in checking NameConstraints during
    # certification path verification.
    # <p>
    # RFC3280: For URIs, the constraint applies to the host part of the name.
    # The constraint may specify a host or a domain.  Examples would be
    # "foo.bar.com";  and ".xyz.com".  When the the constraint begins with
    # a period, it may be expanded with one or more subdomains.  That is,
    # the constraint ".xyz.com" is satisfied by both abc.xyz.com and
    # abc.def.xyz.com.  However, the constraint ".xyz.com" is not satisfied
    # by "xyz.com".  When the constraint does not begin with a period, it
    # specifies a host.
    # <p>
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is not exact match, but
    # narrowing and widening are not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_URI))
          constraint_type = NAME_DIFF_TYPE
        else
          # Assuming from here on that one or both of these is
          # actually a URI name constraint (not a URI), so we
          # only need to compare the host portion of the name
          other_host = (input_name).get_host
          # Quick check for equality
          if (other_host.equals_ignore_case(@host))
            constraint_type = NAME_MATCH
          else
            other_host_object = (input_name).get_host_object
            if (((@host_dns).nil?) || !(other_host_object.is_a?(DNSName)))
              # If one (or both) is an IP address, only same type
              constraint_type = NAME_SAME_TYPE
            else
              # Both host portions are DNS names. Are they domains?
              this_domain = ((@host.char_at(0)).equal?(Character.new(?..ord)))
              other_domain = ((other_host.char_at(0)).equal?(Character.new(?..ord)))
              other_dns = other_host_object
              # Run DNSName.constrains.
              constraint_type = @host_dns.constrains(other_dns)
              # If neither one is a domain, then they can't
              # widen or narrow. That's just SAME_TYPE.
              if ((!this_domain && !other_domain) && (((constraint_type).equal?(NAME_WIDENS)) || ((constraint_type).equal?(NAME_NARROWS))))
                constraint_type = NAME_SAME_TYPE
              end
              # If one is a domain and the other isn't,
              # then they can't match. The one that's a
              # domain doesn't include the one that's
              # not a domain.
              if ((!(this_domain).equal?(other_domain)) && ((constraint_type).equal?(NAME_MATCH)))
                if (this_domain)
                  constraint_type = NAME_WIDENS
                else
                  constraint_type = NAME_NARROWS
                end
              end
            end
          end
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      dns_name = nil
      begin
        dns_name = DNSName.new(@host)
      rescue IOException => ioe
        raise UnsupportedOperationException.new(ioe.get_message)
      end
      return dns_name.subtree_depth
    end
    
    private
    alias_method :initialize__uriname, :initialize
  end
  
end

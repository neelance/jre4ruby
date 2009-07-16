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
module Sun::Security::Jgss::Krb5
  module Krb5NameElementImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss::Spi
      include ::Javax::Security::Auth::Kerberos
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :ServiceName
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Security, :Provider
    }
  end
  
  # 
  # Implements the GSSNameSpi for the krb5 mechanism.
  # 
  # @author Mayank Upadhyay
  class Krb5NameElement 
    include_class_members Krb5NameElementImports
    include GSSNameSpi
    
    attr_accessor :krb5principal_name
    alias_method :attr_krb5principal_name, :krb5principal_name
    undef_method :krb5principal_name
    alias_method :attr_krb5principal_name=, :krb5principal_name=
    undef_method :krb5principal_name=
    
    attr_accessor :gss_name_str
    alias_method :attr_gss_name_str, :gss_name_str
    undef_method :gss_name_str
    alias_method :attr_gss_name_str=, :gss_name_str=
    undef_method :gss_name_str=
    
    attr_accessor :gss_name_type
    alias_method :attr_gss_name_type, :gss_name_type
    undef_method :gss_name_type
    alias_method :attr_gss_name_type=, :gss_name_type=
    undef_method :gss_name_type=
    
    class_module.module_eval {
      # XXX Move this concept into PrincipalName's asn1Encode() sometime
      
      def char_encoding
        defined?(@@char_encoding) ? @@char_encoding : @@char_encoding= "UTF-8"
      end
      alias_method :attr_char_encoding, :char_encoding
      
      def char_encoding=(value)
        @@char_encoding = value
      end
      alias_method :attr_char_encoding=, :char_encoding=
    }
    
    typesig { [PrincipalName, String, Oid] }
    def initialize(principal_name, gss_name_str, gss_name_type)
      @krb5principal_name = nil
      @gss_name_str = nil
      @gss_name_type = nil
      @krb5principal_name = principal_name
      @gss_name_str = gss_name_str
      @gss_name_type = gss_name_type
    end
    
    class_module.module_eval {
      typesig { [String, Oid] }
      # 
      # Instantiates a new Krb5NameElement object. Internally it stores the
      # information provided by the input parameters so that they may later
      # be used for output when a printable representaion of this name is
      # needed in GSS-API format rather than in Kerberos format.
      def get_instance(gss_name_str, gss_name_type)
        # 
        # A null gssNameType implies that the mechanism default
        # Krb5MechFactory.NT_GSS_KRB5_PRINCIPAL be used.
        if ((gss_name_type).nil?)
          gss_name_type = Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL
        else
          if (!(gss_name_type == GSSName::NT_USER_NAME) && !(gss_name_type == GSSName::NT_HOSTBASED_SERVICE) && !(gss_name_type == Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL) && !(gss_name_type == GSSName::NT_EXPORT_NAME))
            raise GSSException.new(GSSException::BAD_NAMETYPE, -1, (gss_name_type.to_s).to_s + " is an unsupported nametype")
          end
        end
        principal_name = nil
        begin
          if ((gss_name_type == GSSName::NT_EXPORT_NAME) || (gss_name_type == Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL))
            principal_name = PrincipalName.new(gss_name_str, PrincipalName::KRB_NT_PRINCIPAL)
          else
            components = get_components(gss_name_str)
            # 
            # We have forms of GSS name strings that can come in:
            # 
            # 1. names of the form "foo" with just one
            # component. (This might include a "@" but only in escaped
            # form like "\@")
            # 2. names of the form "foo@bar" with two components
            # 
            # The nametypes that are accepted are NT_USER_NAME, and
            # NT_HOSTBASED_SERVICE.
            if ((gss_name_type == GSSName::NT_USER_NAME))
              principal_name = PrincipalName.new(gss_name_str, PrincipalName::KRB_NT_PRINCIPAL)
            else
              host_name = nil
              service = components[0]
              if (components.attr_length >= 2)
                host_name = (components[1]).to_s
              end
              principal = get_host_based_instance(service, host_name)
              principal_name = ServiceName.new(principal, PrincipalName::KRB_NT_SRV_HST)
            end
          end
        rescue KrbException => e
          raise GSSException.new(GSSException::BAD_NAME, -1, e.get_message)
        end
        return Krb5NameElement.new(principal_name, gss_name_str, gss_name_type)
      end
      
      typesig { [PrincipalName] }
      def get_instance(principal_name)
        return Krb5NameElement.new(principal_name, principal_name.get_name, Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL)
      end
      
      typesig { [String] }
      def get_components(gss_name_str)
        ret_val = nil
        # XXX Perhaps provide this parsing code in PrincipalName
        # Look for @ as in service@host
        # Assumes host name will not have an escaped '@'
        separator_pos = gss_name_str.last_index_of(Character.new(?@.ord), gss_name_str.length)
        # Not really a separator if it is escaped. Then this is just part
        # of the principal name or service name
        if ((separator_pos > 0) && ((gss_name_str.char_at(separator_pos - 1)).equal?(Character.new(?\\.ord))))
          # Is the `\` character escaped itself?
          if ((separator_pos - 2 < 0) || (!(gss_name_str.char_at(separator_pos - 2)).equal?(Character.new(?\\.ord))))
            separator_pos = -1
          end
        end
        if (separator_pos > 0)
          service_name = gss_name_str.substring(0, separator_pos)
          host_name = gss_name_str.substring(separator_pos + 1)
          ret_val = Array.typed(String).new([service_name, host_name])
        else
          ret_val = Array.typed(String).new([gss_name_str])
        end
        return ret_val
      end
      
      typesig { [String, String] }
      def get_host_based_instance(service_name, host_name)
        temp = StringBuffer.new(service_name)
        begin
          # A lack of "@" defaults to the service being on the local
          # host as per RFC 2743
          # XXX Move this part into JGSS framework
          if ((host_name).nil?)
            host_name = (InetAddress.get_local_host.get_host_name).to_s
          end
        rescue UnknownHostException => e
          # use hostname as it is
        end
        host_name = (host_name.to_lower_case).to_s
        temp = temp.append(Character.new(?/.ord)).append(host_name)
        return temp.to_s
      end
    }
    
    typesig { [] }
    def get_krb5principal_name
      return @krb5principal_name
    end
    
    typesig { [GSSNameSpi] }
    # 
    # Equal method for the GSSNameSpi objects.
    # If either name denotes an anonymous principal, the call should
    # return false.
    # 
    # @param name to be compared with
    # @returns true if they both refer to the same entity, else false
    # @exception GSSException with major codes of BAD_NAMETYPE,
    # BAD_NAME, FAILURE
    def equals(other)
      if ((other).equal?(self))
        return true
      end
      if (other.is_a?(Krb5NameElement))
        that = other
        return ((@krb5principal_name.get_name == that.attr_krb5principal_name.get_name))
      end
      return false
    end
    
    typesig { [Object] }
    # 
    # Compares this <code>GSSNameSpi</code> object to another Object
    # that might be a <code>GSSNameSpi</code>. The behaviour is exactly
    # the same as in {@link #equals(GSSNameSpi) equals} except that
    # no GSSException is thrown; instead, false will be returned in the
    # situation where an error occurs.
    # 
    # @param another the object to be compared to
    # @returns true if they both refer to the same entity, else false
    # @see #equals(GSSNameSpi)
    def equals(another)
      if ((self).equal?(another))
        return true
      end
      begin
        if (another.is_a?(Krb5NameElement))
          return equals(another)
        end
      rescue GSSException => e
        # ignore exception
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a hashcode value for this GSSNameSpi.
    # 
    # @return a hashCode value
    def hash_code
      return 37 * 17 + @krb5principal_name.get_name.hash_code
    end
    
    typesig { [] }
    # 
    # Returns the principal name in the form user@REALM or
    # host/service@REALM but with the following contraints that are
    # imposed by RFC 1964:
    # <pre>
    # (1) all occurrences of the characters `@`,  `/`, and `\` within
    # principal components or realm names shall be quoted with an
    # immediately-preceding `\`.
    # 
    # (2) all occurrences of the null, backspace, tab, or newline
    # characters within principal components or realm names will be
    # represented, respectively, with `\0`, `\b`, `\t`, or `\n`.
    # 
    # (3) the `\` quoting character shall not be emitted within an
    # exported name except to accomodate cases (1) and (2).
    # </pre>
    def export
      # XXX Apply the above constraints.
      ret_val = nil
      begin
        ret_val = @krb5principal_name.get_name.get_bytes(self.attr_char_encoding)
      rescue UnsupportedEncodingException => e
        # Can't happen
      end
      return ret_val
    end
    
    typesig { [] }
    # 
    # Get the mechanism type that this NameElement corresponds to.
    # 
    # @return the Oid of the mechanism type
    def get_mechanism
      return (Krb5MechFactory::GSS_KRB5_MECH_OID)
    end
    
    typesig { [] }
    # 
    # Returns a string representation for this name. The printed
    # name type can be obtained by calling getStringNameType().
    # 
    # @return string form of this name
    # @see #getStringNameType()
    # @overrides Object#toString
    def to_s
      return (@gss_name_str)
      # For testing: return (super.toString());
    end
    
    typesig { [] }
    # 
    # Returns the name type oid.
    def get_gssname_type
      return (@gss_name_type)
    end
    
    typesig { [] }
    # 
    # Returns the oid describing the format of the printable name.
    # 
    # @return the Oid for the format of the printed name
    def get_string_name_type
      # XXX For NT_EXPORT_NAME return a different name type. Infact,
      # don't even store NT_EXPORT_NAME in the cons.
      return (@gss_name_type)
    end
    
    typesig { [] }
    # 
    # Indicates if this name object represents an Anonymous name.
    def is_anonymous_name
      return ((@gss_name_type == GSSName::NT_ANONYMOUS))
    end
    
    typesig { [] }
    def get_provider
      return Krb5MechFactory::PROVIDER
    end
    
    private
    alias_method :initialize__krb5name_element, :initialize
  end
  
end

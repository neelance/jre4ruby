require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5
  module PrincipalNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Util
      include ::Java::Net
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Math, :BigInteger
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CCacheOutputStream
    }
  end
  
  # This class encapsulates a Kerberos principal.
  class PrincipalName 
    include_class_members PrincipalNameImports
    include Cloneable
    
    class_module.module_eval {
      # name types
      # 
      # Name type not known
      const_set_lazy(:KRB_NT_UNKNOWN) { 0 }
      const_attr_reader  :KRB_NT_UNKNOWN
      
      # Just the name of the principal as in DCE, or for users
      const_set_lazy(:KRB_NT_PRINCIPAL) { 1 }
      const_attr_reader  :KRB_NT_PRINCIPAL
      
      # Service and other unique instance (krbtgt)
      const_set_lazy(:KRB_NT_SRV_INST) { 2 }
      const_attr_reader  :KRB_NT_SRV_INST
      
      # Service with host name as instance (telnet, rcommands)
      const_set_lazy(:KRB_NT_SRV_HST) { 3 }
      const_attr_reader  :KRB_NT_SRV_HST
      
      # Service with host as remaining components
      const_set_lazy(:KRB_NT_SRV_XHST) { 4 }
      const_attr_reader  :KRB_NT_SRV_XHST
      
      # Unique ID
      const_set_lazy(:KRB_NT_UID) { 5 }
      const_attr_reader  :KRB_NT_UID
      
      # TGS Name
      const_set_lazy(:TGS_DEFAULT_SRV_NAME) { "krbtgt" }
      const_attr_reader  :TGS_DEFAULT_SRV_NAME
      
      const_set_lazy(:TGS_DEFAULT_NT) { KRB_NT_SRV_INST }
      const_attr_reader  :TGS_DEFAULT_NT
      
      const_set_lazy(:NAME_COMPONENT_SEPARATOR) { Character.new(?/.ord) }
      const_attr_reader  :NAME_COMPONENT_SEPARATOR
      
      const_set_lazy(:NAME_REALM_SEPARATOR) { Character.new(?@.ord) }
      const_attr_reader  :NAME_REALM_SEPARATOR
      
      const_set_lazy(:REALM_COMPONENT_SEPARATOR) { Character.new(?..ord) }
      const_attr_reader  :REALM_COMPONENT_SEPARATOR
      
      const_set_lazy(:NAME_COMPONENT_SEPARATOR_STR) { "/" }
      const_attr_reader  :NAME_COMPONENT_SEPARATOR_STR
      
      const_set_lazy(:NAME_REALM_SEPARATOR_STR) { "@" }
      const_attr_reader  :NAME_REALM_SEPARATOR_STR
      
      const_set_lazy(:REALM_COMPONENT_SEPARATOR_STR) { "." }
      const_attr_reader  :REALM_COMPONENT_SEPARATOR_STR
    }
    
    attr_accessor :name_type
    alias_method :attr_name_type, :name_type
    undef_method :name_type
    alias_method :attr_name_type=, :name_type=
    undef_method :name_type=
    
    attr_accessor :name_strings
    alias_method :attr_name_strings, :name_strings
    undef_method :name_strings
    alias_method :attr_name_strings=, :name_strings=
    undef_method :name_strings=
    
    # Principal names don't mutate often
    attr_accessor :name_realm
    alias_method :attr_name_realm, :name_realm
    undef_method :name_realm
    alias_method :attr_name_realm=, :name_realm=
    undef_method :name_realm=
    
    # optional; a null realm means use default
    # Note: the nameRealm is not included in the default ASN.1 encoding
    # salt for principal
    attr_accessor :salt
    alias_method :attr_salt, :salt
    undef_method :salt
    alias_method :attr_salt=, :salt=
    undef_method :salt=
    
    typesig { [] }
    def initialize
      @name_type = 0
      @name_strings = nil
      @name_realm = nil
      @salt = nil
    end
    
    typesig { [Array.typed(String), ::Java::Int] }
    def initialize(name_parts, type)
      @name_type = 0
      @name_strings = nil
      @name_realm = nil
      @salt = nil
      if ((name_parts).nil?)
        raise IllegalArgumentException.new("Null input not allowed")
      end
      @name_strings = Array.typed(String).new(name_parts.attr_length) { nil }
      System.arraycopy(name_parts, 0, @name_strings, 0, name_parts.attr_length)
      @name_type = type
      @name_realm = nil
    end
    
    typesig { [Array.typed(String)] }
    def initialize(name_parts)
      initialize__principal_name(name_parts, KRB_NT_UNKNOWN)
    end
    
    typesig { [] }
    def clone
      p_name = PrincipalName.new
      p_name.attr_name_type = @name_type
      if (!(@name_strings).nil?)
        p_name.attr_name_strings = Array.typed(String).new(@name_strings.attr_length) { nil }
        System.arraycopy(@name_strings, 0, p_name.attr_name_strings, 0, @name_strings.attr_length)
      end
      if (!(@name_realm).nil?)
        p_name.attr_name_realm = @name_realm.clone
      end
      return p_name
    end
    
    typesig { [Object] }
    # Added to workaround a bug where the equals method that takes a
    # PrincipalName is not being called but Object.equals(Object) is
    # being called.
    def equals(o)
      if (o.is_a?(PrincipalName))
        return equals(o)
      else
        return false
      end
    end
    
    typesig { [PrincipalName] }
    def equals(other)
      if (!equals_without_realm(other))
        return false
      end
      if ((!(@name_realm).nil? && (other.attr_name_realm).nil?) || ((@name_realm).nil? && !(other.attr_name_realm).nil?))
        return false
      end
      if (!(@name_realm).nil? && !(other.attr_name_realm).nil?)
        if (!(@name_realm == other.attr_name_realm))
          return false
        end
      end
      return true
    end
    
    typesig { [PrincipalName] }
    def equals_without_realm(other)
      if (!(@name_type).equal?(KRB_NT_UNKNOWN) && !(other.attr_name_type).equal?(KRB_NT_UNKNOWN) && !(@name_type).equal?(other.attr_name_type))
        return false
      end
      if ((!(@name_strings).nil? && (other.attr_name_strings).nil?) || ((@name_strings).nil? && !(other.attr_name_strings).nil?))
        return false
      end
      if (!(@name_strings).nil? && !(other.attr_name_strings).nil?)
        if (!(@name_strings.attr_length).equal?(other.attr_name_strings.attr_length))
          return false
        end
        i = 0
        while i < @name_strings.attr_length
          if (!(@name_strings[i] == other.attr_name_strings[i]))
            return false
          end
          i += 1
        end
      end
      return true
    end
    
    typesig { [DerValue] }
    # Returns the ASN.1 encoding of the
    # <xmp>
    # PrincipalName    ::= SEQUENCE {
    # name-type       [0] Int32,
    # name-string     [1] SEQUENCE OF KerberosString
    # }
    # 
    # KerberosString   ::= GeneralString (IA5String)
    # </xmp>
    # 
    # <p>
    # This definition reflects the Network Working Group RFC 4120
    # specification available at
    # <a href="http://www.ietf.org/rfc/rfc4120.txt">
    # http://www.ietf.org/rfc/rfc4120.txt</a>.
    # 
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding
    # an ASN1 encoded data.
    # @exception Asn1Exception if there is an ASN1 encoding error
    # @exception IOException if an I/O error occurs
    # @exception IllegalArgumentException if encoding is null
    # reading encoded data.
    def initialize(encoding)
      @name_type = 0
      @name_strings = nil
      @name_realm = nil
      @salt = nil
      @name_realm = nil
      der = nil
      if ((encoding).nil?)
        raise IllegalArgumentException.new("Null input not allowed")
      end
      if (!(encoding.get_tag).equal?(DerValue.attr_tag_sequence))
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x0))
        bint = der.get_data.get_big_integer
        @name_type = bint.int_value
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
      der = encoding.get_data.get_der_value
      if (((der.get_tag & 0x1f)).equal?(0x1))
        sub_der = der.get_data.get_der_value
        if (!(sub_der.get_tag).equal?(DerValue.attr_tag_sequence_of))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        end
        v = Vector.new
        sub_sub_der = nil
        while (sub_der.get_data.available > 0)
          sub_sub_der = sub_der.get_data.get_der_value
          v.add_element(sub_sub_der.get_general_string)
        end
        if (v.size > 0)
          @name_strings = Array.typed(String).new(v.size) { nil }
          v.copy_into(@name_strings)
        else
          @name_strings = Array.typed(String).new([""])
        end
      else
        raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
      end
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a <code>PrincipalName</code> from a DER
      # input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or
      # more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @return an instance of <code>PrincipalName</code>.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return PrincipalName.new(sub_der)
        end
      end
      
      typesig { [String] }
      # This is protected because the definition of a principal
      # string is fixed
      # XXX Error checkin consistent with MIT krb5_parse_name
      # Code repetition, realm parsed again by class Realm
      def parse_name(name)
        temp_strings = Vector.new
        temp = name
        i = 0
        component_start = 0
        component = nil
        while (i < temp.length)
          if ((temp.char_at(i)).equal?(NAME_COMPONENT_SEPARATOR))
            # If this separator is escaped then don't treat it
            # as a separator
            if (i > 0 && (temp.char_at(i - 1)).equal?(Character.new(?\\.ord)))
              temp = (temp.substring(0, i - 1) + temp.substring(i, temp.length)).to_s
              next
            else
              if (component_start < i)
                component = (temp.substring(component_start, i)).to_s
                temp_strings.add_element(component)
              end
              component_start = i + 1
            end
          else
            if ((temp.char_at(i)).equal?(NAME_REALM_SEPARATOR))
              # If this separator is escaped then don't treat it
              # as a separator
              if (i > 0 && (temp.char_at(i - 1)).equal?(Character.new(?\\.ord)))
                temp = (temp.substring(0, i - 1) + temp.substring(i, temp.length)).to_s
                next
              else
                if (component_start < i)
                  component = (temp.substring(component_start, i)).to_s
                  temp_strings.add_element(component)
                end
                component_start = i + 1
                break
              end
            end
          end
          i += 1
        end
        if ((i).equal?(temp.length))
          if (component_start < i)
            component = (temp.substring(component_start, i)).to_s
            temp_strings.add_element(component)
          end
        end
        result = Array.typed(String).new(temp_strings.size) { nil }
        temp_strings.copy_into(result)
        return result
      end
    }
    
    typesig { [String, ::Java::Int] }
    def initialize(name, type)
      @name_type = 0
      @name_strings = nil
      @name_realm = nil
      @salt = nil
      if ((name).nil?)
        raise IllegalArgumentException.new("Null name not allowed")
      end
      name_parts = parse_name(name)
      temp_realm = nil
      realm_string = Realm.parse_realm_at_separator(name)
      if ((realm_string).nil?)
        begin
          config = Config.get_instance
          realm_string = (config.get_default_realm).to_s
        rescue KrbException => e
          re = RealmException.new(e.get_message)
          re.init_cause(e)
          raise re
        end
      end
      if (!(realm_string).nil?)
        temp_realm = Realm.new(realm_string)
      end
      case (type)
      when KRB_NT_SRV_HST
        if (name_parts.attr_length >= 2)
          begin
            # Canonicalize the hostname as per the
            # RFC4120 Section 6.2.1 and
            # RFC1964 Section 2.1.2
            # we assume internet domain names
            host_name = (InetAddress.get_by_name(name_parts[1])).get_canonical_host_name
            name_parts[1] = host_name.to_lower_case
          rescue UnknownHostException => e
            # no canonicalization, just convert to lowercase
            name_parts[1] = name_parts[1].to_lower_case
          end
        end
        @name_strings = name_parts
        @name_type = type
        # We will try to get realm name from the mapping in
        # the configuration. If it is not specified
        # we will use the default realm. This nametype does
        # not allow a realm to be specified. The name string must of
        # the form service@host and this is internally changed into
        # service/host by Kerberos
        map_realm = map_host_to_realm(name_parts[1])
        if (!(map_realm).nil?)
          @name_realm = Realm.new(map_realm)
        else
          @name_realm = temp_realm
        end
      when KRB_NT_UNKNOWN, KRB_NT_PRINCIPAL, KRB_NT_SRV_INST, KRB_NT_SRV_XHST, KRB_NT_UID
        @name_strings = name_parts
        @name_type = type
        @name_realm = temp_realm
      else
        raise IllegalArgumentException.new("Illegal name type")
      end
    end
    
    typesig { [String] }
    def initialize(name)
      initialize__principal_name(name, KRB_NT_UNKNOWN)
    end
    
    typesig { [String, String] }
    def initialize(name, realm)
      initialize__principal_name(name, KRB_NT_UNKNOWN)
      @name_realm = Realm.new(realm)
    end
    
    typesig { [] }
    def get_realm_as_string
      return get_realm_string
    end
    
    typesig { [] }
    def get_principal_name_as_string
      temp = StringBuffer.new(@name_strings[0])
      i = 1
      while i < @name_strings.attr_length
        temp.append(@name_strings[i])
        i += 1
      end
      return temp.to_s
    end
    
    typesig { [] }
    def hash_code
      return to_s.hash_code
    end
    
    typesig { [] }
    def get_name
      return to_s
    end
    
    typesig { [] }
    def get_name_type
      return @name_type
    end
    
    typesig { [] }
    def get_name_strings
      return @name_strings
    end
    
    typesig { [] }
    def to_byte_array
      result = Array.typed(::Java::Byte).new(@name_strings.attr_length) { 0 }
      i = 0
      while i < @name_strings.attr_length
        result[i] = Array.typed(::Java::Byte).new(@name_strings[i].length) { 0 }
        result[i] = @name_strings[i].get_bytes
        i += 1
      end
      return result
    end
    
    typesig { [] }
    def get_realm_string
      if (!(@name_realm).nil?)
        return @name_realm.to_s
      end
      return nil
    end
    
    typesig { [] }
    def get_realm
      return @name_realm
    end
    
    typesig { [Realm] }
    def set_realm(new_name_realm)
      @name_realm = new_name_realm
    end
    
    typesig { [String] }
    def set_realm(realms_string)
      @name_realm = Realm.new(realms_string)
    end
    
    typesig { [] }
    def get_salt
      if ((@salt).nil?)
        salt = StringBuffer.new
        if (!(@name_realm).nil?)
          salt.append(@name_realm.to_s)
        end
        i = 0
        while i < @name_strings.attr_length
          salt.append(@name_strings[i])
          i += 1
        end
        return salt.to_s
      end
      return @salt
    end
    
    typesig { [String] }
    def set_salt(salt)
      @salt = salt
    end
    
    typesig { [] }
    def to_s
      str = StringBuffer.new
      i = 0
      while i < @name_strings.attr_length
        if (i > 0)
          str.append("/")
        end
        str.append(@name_strings[i])
        i += 1
      end
      if (!(@name_realm).nil?)
        str.append("@")
        str.append(@name_realm.to_s)
      end
      return str.to_s
    end
    
    typesig { [] }
    def get_name_string
      str = StringBuffer.new
      i = 0
      while i < @name_strings.attr_length
        if (i > 0)
          str.append("/")
        end
        str.append(@name_strings[i])
        i += 1
      end
      return str.to_s
    end
    
    typesig { [] }
    # Encodes a <code>PrincipalName</code> object.
    # @return the byte array of the encoded PrncipalName object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      bytes = DerOutputStream.new
      temp = DerOutputStream.new
      bint = BigInteger.value_of(@name_type)
      temp.put_integer(bint)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x0), temp)
      temp = DerOutputStream.new
      der = Array.typed(DerValue).new(@name_strings.attr_length) { nil }
      i = 0
      while i < @name_strings.attr_length
        der[i] = DerValue.new(DerValue.attr_tag_general_string, @name_strings[i])
        i += 1
      end
      temp.put_sequence(der)
      bytes.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0x1), temp)
      temp = DerOutputStream.new
      temp.write(DerValue.attr_tag_sequence, bytes)
      return temp.to_byte_array
    end
    
    typesig { [PrincipalName] }
    # Checks if two <code>PrincipalName</code> objects have identical values in their corresponding data fields.
    # 
    # @param pname the other <code>PrincipalName</code> object.
    # @return true if two have identical values, otherwise, return false.
    # 
    # It is used in <code>sun.security.krb5.internal.ccache</code> package.
    def match(pname)
      matched = true
      # name type is just a hint, no two names can be the same ignoring name type.
      # if (this.nameType != pname.nameType) {
      # matched = false;
      # }
      if ((!(@name_realm).nil?) && (!(pname.attr_name_realm).nil?))
        if (!(@name_realm.to_s.equals_ignore_case(pname.attr_name_realm.to_s)))
          matched = false
        end
      end
      if (!(@name_strings.attr_length).equal?(pname.attr_name_strings.attr_length))
        matched = false
      else
        i = 0
        while i < @name_strings.attr_length
          if (!(@name_strings[i].equals_ignore_case(pname.attr_name_strings[i])))
            matched = false
          end
          i += 1
        end
      end
      return matched
    end
    
    typesig { [CCacheOutputStream] }
    # Writes data field values of <code>PrincipalName</code> in FCC format to an output stream.
    # 
    # @param cos a <code>CCacheOutputStream</code> for writing data.
    # @exception IOException if an I/O exception occurs.
    # @see sun.security.krb5.internal.ccache.CCacheOutputStream
    def write_principal(cos)
      cos.write32(@name_type)
      cos.write32(@name_strings.attr_length)
      if (!(@name_realm).nil?)
        realm_bytes = nil
        realm_bytes = @name_realm.to_s.get_bytes
        cos.write32(realm_bytes.attr_length)
        cos.write(realm_bytes, 0, realm_bytes.attr_length)
      end
      bytes = nil
      i = 0
      while i < @name_strings.attr_length
        bytes = @name_strings[i].get_bytes
        cos.write32(bytes.attr_length)
        cos.write(bytes, 0, bytes.attr_length)
        i += 1
      end
    end
    
    typesig { [String, String, String, ::Java::Int] }
    # Creates a KRB_NT_SRV_INST name from the supplied
    # name components and realm.
    # @param primary the primary component of the name
    # @param instance the instance component of the name
    # @param realm the realm
    # @throws KrbException
    def initialize(primary, instance, realm, type)
      @name_type = 0
      @name_strings = nil
      @name_realm = nil
      @salt = nil
      if (!(type).equal?(KRB_NT_SRV_INST))
        raise KrbException.new(Krb5::KRB_ERR_GENERIC, "Bad name type")
      end
      n_parts = Array.typed(String).new(2) { nil }
      n_parts[0] = primary
      n_parts[1] = instance
      @name_strings = n_parts
      @name_realm = Realm.new(realm)
      @name_type = type
    end
    
    typesig { [] }
    # Returns the instance component of a name.
    # In a multi-component name such as a KRB_NT_SRV_INST
    # name, the second component is returned.
    # Null is returned if there are not two or more
    # components in the name.
    # @returns instance component of a multi-component name.
    def get_instance_component
      if (!(@name_strings).nil? && @name_strings.attr_length >= 2)
        return String.new(@name_strings[1])
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [String] }
      def map_host_to_realm(name)
        result = nil
        begin
          subname = nil
          c = Config.get_instance
          if (!((result = (c.get_default(name, "domain_realm")).to_s)).nil?)
            return result
          else
            i = 1
            while i < name.length
              if (((name.char_at(i)).equal?(Character.new(?..ord))) && (!(i).equal?(name.length - 1)))
                # mapping could be .ibm.com = AUSTIN.IBM.COM
                subname = (name.substring(i)).to_s
                result = (c.get_default(subname, "domain_realm")).to_s
                if (!(result).nil?)
                  break
                else
                  subname = (name.substring(i + 1)).to_s # or mapping could be ibm.com = AUSTIN.IBM.COM
                  result = (c.get_default(subname, "domain_realm")).to_s
                  if (!(result).nil?)
                    break
                  end
                end
              end
              i += 1
            end
          end
        rescue KrbException => e
        end
        return result
      end
    }
    
    private
    alias_method :initialize__principal_name, :initialize
  end
  
end

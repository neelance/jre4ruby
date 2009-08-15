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
  module GeneralNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This class implements the ASN.1 GeneralName object class.
  # <p>
  # The ASN.1 syntax for this is:
  # <pre>
  # GeneralName ::= CHOICE {
  # otherName                       [0]     OtherName,
  # rfc822Name                      [1]     IA5String,
  # dNSName                         [2]     IA5String,
  # x400Address                     [3]     ORAddress,
  # directoryName                   [4]     Name,
  # ediPartyName                    [5]     EDIPartyName,
  # uniformResourceIdentifier       [6]     IA5String,
  # iPAddress                       [7]     OCTET STRING,
  # registeredID                    [8]     OBJECT IDENTIFIER
  # }
  # </pre>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class GeneralName 
    include_class_members GeneralNameImports
    
    # Private data members
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [GeneralNameInterface] }
    # Default constructor for the class.
    # 
    # @param name the selected CHOICE from the list.
    # @throws NullPointerException if name is null
    def initialize(name)
      @name = nil
      if ((name).nil?)
        raise NullPointerException.new("GeneralName must not be null")
      end
      @name = name
    end
    
    typesig { [DerValue] }
    # Create the object from its DER encoded value.
    # 
    # @param encName the DER encoded GeneralName.
    def initialize(enc_name)
      initialize__general_name(enc_name, false)
    end
    
    typesig { [DerValue, ::Java::Boolean] }
    # Create the object from its DER encoded value.
    # 
    # @param encName the DER encoded GeneralName.
    # @param nameConstraint true if general name is a name constraint
    def initialize(enc_name, name_constraint)
      @name = nil
      tag = (enc_name.attr_tag & 0x1f)
      # All names except for NAME_DIRECTORY should be encoded with the
      # IMPLICIT tag.
      case (tag)
      when GeneralNameInterface::NAME_ANY
        if (enc_name.is_context_specific && enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_sequence)
          @name = OtherName.new(enc_name)
        else
          raise IOException.new("Invalid encoding of Other-Name")
        end
      when GeneralNameInterface::NAME_RFC822
        if (enc_name.is_context_specific && !enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_ia5string)
          @name = RFC822Name.new(enc_name)
        else
          raise IOException.new("Invalid encoding of RFC822 name")
        end
      when GeneralNameInterface::NAME_DNS
        if (enc_name.is_context_specific && !enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_ia5string)
          @name = DNSName.new(enc_name)
        else
          raise IOException.new("Invalid encoding of DNS name")
        end
      when GeneralNameInterface::NAME_URI
        if (enc_name.is_context_specific && !enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_ia5string)
          @name = (name_constraint ? URIName.name_constraint(enc_name) : URIName.new(enc_name))
        else
          raise IOException.new("Invalid encoding of URI")
        end
      when GeneralNameInterface::NAME_IP
        if (enc_name.is_context_specific && !enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_octet_string)
          @name = IPAddressName.new(enc_name)
        else
          raise IOException.new("Invalid encoding of IP address")
        end
      when GeneralNameInterface::NAME_OID
        if (enc_name.is_context_specific && !enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_object_id)
          @name = OIDName.new(enc_name)
        else
          raise IOException.new("Invalid encoding of OID name")
        end
      when GeneralNameInterface::NAME_DIRECTORY
        if (enc_name.is_context_specific && enc_name.is_constructed)
          @name = X500Name.new(enc_name.get_data)
        else
          raise IOException.new("Invalid encoding of Directory name")
        end
      when GeneralNameInterface::NAME_EDI
        if (enc_name.is_context_specific && enc_name.is_constructed)
          enc_name.reset_tag(DerValue.attr_tag_sequence)
          @name = EDIPartyName.new(enc_name)
        else
          raise IOException.new("Invalid encoding of EDI name")
        end
      else
        raise IOException.new("Unrecognized GeneralName tag, (" + RJava.cast_to_string(tag) + ")")
      end
    end
    
    typesig { [] }
    # Return the type of the general name.
    def get_type
      return @name.get_type
    end
    
    typesig { [] }
    # Return the GeneralNameInterface name.
    def get_name
      # XXXX May want to consider cloning this
      return @name
    end
    
    typesig { [] }
    # Return the name as user readable string
    def to_s
      return @name.to_s
    end
    
    typesig { [Object] }
    # Compare this GeneralName with another
    # 
    # @param other GeneralName to compare to this
    # @returns true if match
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(GeneralName)))
        return false
      end
      other_gni = (other).attr_name
      begin
        return (@name.constrains(other_gni)).equal?(GeneralNameInterface::NAME_MATCH)
      rescue UnsupportedOperationException => ioe
        return false
      end
    end
    
    typesig { [] }
    # Returns the hash code for this GeneralName.
    # 
    # @return a hash code value.
    def hash_code
      return @name.hash_code
    end
    
    typesig { [DerOutputStream] }
    # Encode the name to the specified DerOutputStream.
    # 
    # @param out the DerOutputStream to encode the the GeneralName to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      @name.encode(tmp)
      name_type = @name.get_type
      if ((name_type).equal?(GeneralNameInterface::NAME_ANY) || (name_type).equal?(GeneralNameInterface::NAME_X400) || (name_type).equal?(GeneralNameInterface::NAME_EDI))
        # implicit, constructed form
        out.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, name_type), tmp)
      else
        if ((name_type).equal?(GeneralNameInterface::NAME_DIRECTORY))
          # explicit, constructed form since underlying tag is CHOICE
          # (see X.680 section 30.6, part c)
          out.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, name_type), tmp)
        else
          # implicit, primitive form
          out.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, name_type), tmp)
        end
      end
    end
    
    private
    alias_method :initialize__general_name, :initialize
  end
  
end

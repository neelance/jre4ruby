require "rjava"

# 
# Copyright 2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module X400AddressImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # 
  # This class defines the X400Address of the GeneralName choice.
  # <p>
  # The ASN.1 syntax for this is:
  # <pre>
  # ORAddress ::= SEQUENCE {
  # built-in-standard-attributes BuiltInStandardAttributes,
  # built-in-domain-defined-attributes
  # BuiltInDomainDefinedAttributes OPTIONAL,
  # -- see also teletex-domain-defined-attributes
  # extension-attributes ExtensionAttributes OPTIONAL }
  # --      The OR-address is semantically absent from the OR-name if the
  # --      built-in-standard-attribute sequence is empty and the
  # --      built-in-domain-defined-attributes and extension-attributes are
  # --      both omitted.
  # 
  # --      Built-in Standard Attributes
  # 
  # BuiltInStandardAttributes ::= SEQUENCE {
  # country-name CountryName OPTIONAL,
  # administration-domain-name AdministrationDomainName OPTIONAL,
  # network-address      [0] NetworkAddress OPTIONAL,
  # -- see also extended-network-address
  # terminal-identifier  [1] TerminalIdentifier OPTIONAL,
  # private-domain-name  [2] PrivateDomainName OPTIONAL,
  # organization-name    [3] OrganizationName OPTIONAL,
  # -- see also teletex-organization-name
  # numeric-user-identifier      [4] NumericUserIdentifier OPTIONAL,
  # personal-name        [5] PersonalName OPTIONAL,
  # -- see also teletex-personal-name
  # organizational-unit-names    [6] OrganizationalUnitNames OPTIONAL
  # -- see also teletex-organizational-unit-names -- }
  # 
  # CountryName ::= [APPLICATION 1] CHOICE {
  # x121-dcc-code NumericString
  # (SIZE (ub-country-name-numeric-length)),
  # iso-3166-alpha2-code PrintableString
  # (SIZE (ub-country-name-alpha-length)) }
  # 
  # AdministrationDomainName ::= [APPLICATION 2] CHOICE {
  # numeric NumericString (SIZE (0..ub-domain-name-length)),
  # printable PrintableString (SIZE (0..ub-domain-name-length)) }
  # 
  # NetworkAddress ::= X121Address  -- see also extended-network-address
  # 
  # X121Address ::= NumericString (SIZE (1..ub-x121-address-length))
  # 
  # TerminalIdentifier ::= PrintableString (SIZE (1..ub-terminal-id-length))
  # 
  # PrivateDomainName ::= CHOICE {
  # numeric NumericString (SIZE (1..ub-domain-name-length)),
  # printable PrintableString (SIZE (1..ub-domain-name-length)) }
  # 
  # OrganizationName ::= PrintableString
  # (SIZE (1..ub-organization-name-length))
  # -- see also teletex-organization-name
  # 
  # NumericUserIdentifier ::= NumericString
  # (SIZE (1..ub-numeric-user-id-length))
  # 
  # PersonalName ::= SET {
  # surname [0] PrintableString (SIZE (1..ub-surname-length)),
  # given-name [1] PrintableString
  # (SIZE (1..ub-given-name-length)) OPTIONAL,
  # initials [2] PrintableString (SIZE (1..ub-initials-length)) OPTIONAL,
  # generation-qualifier [3] PrintableString
  # (SIZE (1..ub-generation-qualifier-length)) OPTIONAL }
  # -- see also teletex-personal-name
  # 
  # OrganizationalUnitNames ::= SEQUENCE SIZE (1..ub-organizational-units)
  # OF OrganizationalUnitName
  # -- see also teletex-organizational-unit-names
  # 
  # OrganizationalUnitName ::= PrintableString (SIZE
  # (1..ub-organizational-unit-name-length))
  # 
  # --      Built-in Domain-defined Attributes
  # 
  # BuiltInDomainDefinedAttributes ::= SEQUENCE SIZE
  # (1..ub-domain-defined-attributes) OF
  # BuiltInDomainDefinedAttribute
  # 
  # BuiltInDomainDefinedAttribute ::= SEQUENCE {
  # type PrintableString (SIZE
  # (1..ub-domain-defined-attribute-type-length)),
  # value PrintableString (SIZE
  # (1..ub-domain-defined-attribute-value-length))}
  # 
  # --      Extension Attributes
  # 
  # ExtensionAttributes ::= SET SIZE (1..ub-extension-attributes) OF
  # ExtensionAttribute
  # 
  # ExtensionAttribute ::=  SEQUENCE {
  # extension-attribute-type [0] INTEGER (0..ub-extension-attributes),
  # extension-attribute-value [1]
  # ANY DEFINED BY extension-attribute-type }
  # 
  # -- Extension types and attribute values
  # --
  # 
  # common-name INTEGER ::= 1
  # 
  # CommonName ::= PrintableString (SIZE (1..ub-common-name-length))
  # 
  # teletex-common-name INTEGER ::= 2
  # 
  # TeletexCommonName ::= TeletexString (SIZE (1..ub-common-name-length))
  # 
  # teletex-organization-name INTEGER ::= 3
  # 
  # TeletexOrganizationName ::=
  # TeletexString (SIZE (1..ub-organization-name-length))
  # 
  # teletex-personal-name INTEGER ::= 4
  # 
  # TeletexPersonalName ::= SET {
  # surname [0] TeletexString (SIZE (1..ub-surname-length)),
  # given-name [1] TeletexString
  # (SIZE (1..ub-given-name-length)) OPTIONAL,
  # initials [2] TeletexString (SIZE (1..ub-initials-length)) OPTIONAL,
  # generation-qualifier [3] TeletexString (SIZE
  # (1..ub-generation-qualifier-length)) OPTIONAL }
  # 
  # teletex-organizational-unit-names INTEGER ::= 5
  # 
  # TeletexOrganizationalUnitNames ::= SEQUENCE SIZE
  # (1..ub-organizational-units) OF TeletexOrganizationalUnitName
  # 
  # TeletexOrganizationalUnitName ::= TeletexString
  # (SIZE (1..ub-organizational-unit-name-length))
  # 
  # pds-name INTEGER ::= 7
  # 
  # PDSName ::= PrintableString (SIZE (1..ub-pds-name-length))
  # 
  # physical-delivery-country-name INTEGER ::= 8
  # 
  # PhysicalDeliveryCountryName ::= CHOICE {
  # x121-dcc-code NumericString (SIZE (ub-country-name-numeric-length)),
  # iso-3166-alpha2-code PrintableString
  # (SIZE (ub-country-name-alpha-length)) }
  # 
  # postal-code INTEGER ::= 9
  # 
  # PostalCode ::= CHOICE {
  # numeric-code NumericString (SIZE (1..ub-postal-code-length)),
  # printable-code PrintableString (SIZE (1..ub-postal-code-length)) }
  # 
  # physical-delivery-office-name INTEGER ::= 10
  # 
  # PhysicalDeliveryOfficeName ::= PDSParameter
  # 
  # physical-delivery-office-number INTEGER ::= 11
  # 
  # PhysicalDeliveryOfficeNumber ::= PDSParameter
  # 
  # extension-OR-address-components INTEGER ::= 12
  # 
  # ExtensionORAddressComponents ::= PDSParameter
  # 
  # physical-delivery-personal-name INTEGER ::= 13
  # 
  # PhysicalDeliveryPersonalName ::= PDSParameter
  # 
  # physical-delivery-organization-name INTEGER ::= 14
  # 
  # PhysicalDeliveryOrganizationName ::= PDSParameter
  # 
  # extension-physical-delivery-address-components INTEGER ::= 15
  # 
  # ExtensionPhysicalDeliveryAddressComponents ::= PDSParameter
  # 
  # unformatted-postal-address INTEGER ::= 16
  # 
  # UnformattedPostalAddress ::= SET {
  # printable-address SEQUENCE SIZE (1..ub-pds-physical-address-lines) OF
  # PrintableString (SIZE (1..ub-pds-parameter-length)) OPTIONAL,
  # teletex-string TeletexString
  # (SIZE (1..ub-unformatted-address-length)) OPTIONAL }
  # 
  # street-address INTEGER ::= 17
  # 
  # StreetAddress ::= PDSParameter
  # 
  # post-office-box-address INTEGER ::= 18
  # 
  # PostOfficeBoxAddress ::= PDSParameter
  # 
  # poste-restante-address INTEGER ::= 19
  # 
  # PosteRestanteAddress ::= PDSParameter
  # 
  # unique-postal-name INTEGER ::= 20
  # 
  # UniquePostalName ::= PDSParameter
  # 
  # local-postal-attributes INTEGER ::= 21
  # 
  # LocalPostalAttributes ::= PDSParameter
  # 
  # PDSParameter ::= SET {
  # printable-string PrintableString
  # (SIZE(1..ub-pds-parameter-length)) OPTIONAL,
  # teletex-string TeletexString
  # (SIZE(1..ub-pds-parameter-length)) OPTIONAL }
  # 
  # extended-network-address INTEGER ::= 22
  # 
  # ExtendedNetworkAddress ::= CHOICE {
  # e163-4-address SEQUENCE {
  # number [0] NumericString (SIZE (1..ub-e163-4-number-length)),
  # sub-address [1] NumericString
  # (SIZE (1..ub-e163-4-sub-address-length)) OPTIONAL },
  # psap-address [0] PresentationAddress }
  # 
  # PresentationAddress ::= SEQUENCE {
  # pSelector       [0] EXPLICIT OCTET STRING OPTIONAL,
  # sSelector       [1] EXPLICIT OCTET STRING OPTIONAL,
  # tSelector       [2] EXPLICIT OCTET STRING OPTIONAL,
  # nAddresses      [3] EXPLICIT SET SIZE (1..MAX) OF OCTET STRING }
  # 
  # terminal-type  INTEGER ::= 23
  # 
  # TerminalType ::= INTEGER {
  # telex (3),
  # teletex (4),
  # g3-facsimile (5),
  # g4-facsimile (6),
  # ia5-terminal (7),
  # videotex (8) } (0..ub-integer-options)
  # 
  # --      Extension Domain-defined Attributes
  # 
  # teletex-domain-defined-attributes INTEGER ::= 6
  # 
  # TeletexDomainDefinedAttributes ::= SEQUENCE SIZE
  # (1..ub-domain-defined-attributes) OF TeletexDomainDefinedAttribute
  # 
  # TeletexDomainDefinedAttribute ::= SEQUENCE {
  # type TeletexString
  # (SIZE (1..ub-domain-defined-attribute-type-length)),
  # value TeletexString
  # (SIZE (1..ub-domain-defined-attribute-value-length)) }
  # 
  # --  specifications of Upper Bounds shall be regarded as mandatory
  # --  from Annex B of ITU-T X.411 Reference Definition of MTS Parameter
  # --  Upper Bounds
  # 
  # --      Upper Bounds
  # ub-name INTEGER ::=     32768
  # ub-common-name  INTEGER ::=     64
  # ub-locality-name        INTEGER ::=     128
  # ub-state-name   INTEGER ::=     128
  # ub-organization-name    INTEGER ::=     64
  # ub-organizational-unit-name     INTEGER ::=     64
  # ub-title        INTEGER ::=     64
  # ub-match        INTEGER ::=     128
  # 
  # ub-emailaddress-length INTEGER ::= 128
  # 
  # ub-common-name-length INTEGER ::= 64
  # ub-country-name-alpha-length INTEGER ::= 2
  # ub-country-name-numeric-length INTEGER ::= 3
  # ub-domain-defined-attributes INTEGER ::= 4
  # ub-domain-defined-attribute-type-length INTEGER ::= 8
  # ub-domain-defined-attribute-value-length INTEGER ::= 128
  # ub-domain-name-length INTEGER ::= 16
  # ub-extension-attributes INTEGER ::= 256
  # ub-e163-4-number-length INTEGER ::= 15
  # ub-e163-4-sub-address-length INTEGER ::= 40
  # ub-generation-qualifier-length INTEGER ::= 3
  # ub-given-name-length INTEGER ::= 16
  # ub-initials-length INTEGER ::= 5
  # ub-integer-options INTEGER ::= 256
  # ub-numeric-user-id-length INTEGER ::= 32
  # ub-organization-name-length INTEGER ::= 64
  # ub-organizational-unit-name-length INTEGER ::= 32
  # ub-organizational-units INTEGER ::= 4
  # ub-pds-name-length INTEGER ::= 16
  # ub-pds-parameter-length INTEGER ::= 30
  # ub-pds-physical-address-lines INTEGER ::= 6
  # ub-postal-code-length INTEGER ::= 16
  # ub-surname-length INTEGER ::= 40
  # ub-terminal-id-length INTEGER ::= 24
  # ub-unformatted-address-length INTEGER ::= 180
  # ub-x121-address-length INTEGER ::= 16
  # 
  # -- Note - upper bounds on string types, such as TeletexString, are
  # -- measured in characters.  Excepting PrintableString or IA5String, a
  # -- significantly greater number of octets will be required to hold
  # -- such a value.  As a minimum, 16 octets, or twice the specified upper
  # -- bound, whichever is the larger, should be allowed for TeletexString.
  # -- For UTF8String or UniversalString at least four times the upper
  # -- bound should be allowed.
  # </pre>
  # 
  # @author Anne Anderson
  # @since       1.4
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class X400Address 
    include_class_members X400AddressImports
    include GeneralNameInterface
    
    # Private data members
    attr_accessor :name_value
    alias_method :attr_name_value, :name_value
    undef_method :name_value
    alias_method :attr_name_value=, :name_value=
    undef_method :name_value=
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Create the X400Address object from the specified byte array
    # 
    # @param nameValue value of the name as a byte array
    def initialize(value)
      @name_value = nil
      @name_value = value
    end
    
    typesig { [DerValue] }
    # 
    # Create the X400Address object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER X400Address.
    # @exception IOException on error.
    def initialize(der_value)
      @name_value = nil
      @name_value = der_value.to_byte_array
    end
    
    typesig { [] }
    # 
    # Return the type of the GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_X400)
    end
    
    typesig { [DerOutputStream] }
    # 
    # Encode the X400 name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the X400Address to.
    # @exception IOException on encoding errors.
    def encode(out)
      der_value = DerValue.new(@name_value)
      out.put_der_value(der_value)
    end
    
    typesig { [] }
    # 
    # Return the printable string.
    def to_s
      return ("X400Address: <DER-encoded value>")
    end
    
    typesig { [GeneralNameInterface] }
    # 
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the naming subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the naming subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but is same type.
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # 
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is same type, but comparison operations are
    # not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?(NAME_X400))
          constraint_type = NAME_DIFF_TYPE
        else
          # Narrowing, widening, and match constraints not defined in rfc2459 for X400Address
          raise UnsupportedOperationException.new("Narrowing, widening, and match are not supported for X400Address.")
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # 
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      raise UnsupportedOperationException.new("subtreeDepth not supported for X400Address")
    end
    
    private
    alias_method :initialize__x400address, :initialize
  end
  
end

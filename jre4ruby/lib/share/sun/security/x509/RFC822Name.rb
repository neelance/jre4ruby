require "rjava"

# Copyright 1997-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RFC822NameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This class implements the RFC822Name as required by the GeneralNames
  # ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class RFC822Name 
    include_class_members RFC822NameImports
    include GeneralNameInterface
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [DerValue] }
    # Create the RFC822Name object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER RFC822Name.
    # @exception IOException on error.
    def initialize(der_value)
      @name = nil
      @name = RJava.cast_to_string(der_value.get_ia5string)
      parse_name(@name)
    end
    
    typesig { [String] }
    # Create the RFC822Name object with the specified name.
    # 
    # @param name the RFC822Name.
    # @throws IOException on invalid input name
    def initialize(name)
      @name = nil
      parse_name(name)
      @name = name
    end
    
    typesig { [String] }
    # Parse an RFC822Name string to see if it is a valid
    # addr-spec according to IETF RFC822 and RFC2459:
    # [local-part@]domain
    # <p>
    # local-part@ could be empty for an RFC822Name NameConstraint,
    # but the domain at least must be non-empty.  Case is not
    # significant.
    # 
    # @param name the RFC822Name string
    # @throws IOException if name is not valid
    def parse_name(name)
      if ((name).nil? || (name.length).equal?(0))
        raise IOException.new("RFC822Name may not be null or empty")
      end
      # See if domain is a valid domain name
      domain = name.substring(name.index_of(Character.new(?@.ord)) + 1)
      if ((domain.length).equal?(0))
        raise IOException.new("RFC822Name may not end with @")
      else
        # An RFC822 NameConstraint could start with a ., although
        # a DNSName may not
        if (domain.starts_with("."))
          if ((domain.length).equal?(1))
            raise IOException.new("RFC822Name domain may not be just .")
          end
        end
      end
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_RFC822)
    end
    
    typesig { [] }
    # Return the actual name value of the GeneralName.
    def get_name
      return @name
    end
    
    typesig { [DerOutputStream] }
    # Encode the RFC822 name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the RFC822Name to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_ia5string(@name)
    end
    
    typesig { [] }
    # Convert the name into user readable string.
    def to_s
      return ("RFC822Name: " + @name)
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are equivalent
    # according to RFC2459.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(RFC822Name)))
        return false
      end
      other = obj
      # RFC2459 mandates that these names are
      # not case-sensitive
      return @name.equals_ignore_case(other.attr_name)
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      return @name.to_upper_case.hash_code
    end
    
    typesig { [GeneralNameInterface] }
    # Return constraint type:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name (i.e. does not constrain)
    # <li>NAME_MATCH = 0: input name matches name
    # <li>NAME_NARROWS = 1: input name narrows name
    # <li>NAME_WIDENS = 2: input name widens name
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but is same type
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # <p>
    # [RFC2459]    When the subjectAltName extension contains an Internet mail address,
    # the address MUST be included as an rfc822Name. The format of an
    # rfc822Name is an "addr-spec" as defined in RFC 822 [RFC 822]. An
    # addr-spec has the form "local-part@domain". Note that an addr-spec
    # has no phrase (such as a common name) before it, has no comment (text
    # surrounded in parentheses) after it, and is not surrounded by "&lt;" and
    # "&gt;". Note that while upper and lower case letters are allowed in an
    # RFC 822 addr-spec, no significance is attached to the case.
    # <p>
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is not exact match, but narrowing and widening are
    # not supported for this name type.
    def constrains(input_name)
      constraint_type = 0
      if ((input_name).nil?)
        constraint_type = NAME_DIFF_TYPE
      else
        if (!(input_name.get_type).equal?((GeneralNameInterface::NAME_RFC822)))
          constraint_type = NAME_DIFF_TYPE
        else
          # RFC2459 specifies that case is not significant in RFC822Names
          in_name = ((input_name).get_name).to_lower_case
          this_name = @name.to_lower_case
          if ((in_name == this_name))
            constraint_type = NAME_MATCH
          else
            if (this_name.ends_with(in_name))
              # if both names contain @, then they had to match exactly
              if (!(in_name.index_of(Character.new(?@.ord))).equal?(-1))
                constraint_type = NAME_SAME_TYPE
              else
                if (in_name.starts_with("."))
                  constraint_type = NAME_WIDENS
                else
                  in_ndx = this_name.last_index_of(in_name)
                  if ((this_name.char_at(in_ndx - 1)).equal?(Character.new(?@.ord)))
                    constraint_type = NAME_WIDENS
                  else
                    constraint_type = NAME_SAME_TYPE
                  end
                end
              end
            else
              if (in_name.ends_with(this_name))
                # if thisName contains @, then they had to match exactly
                if (!(this_name.index_of(Character.new(?@.ord))).equal?(-1))
                  constraint_type = NAME_SAME_TYPE
                else
                  if (this_name.starts_with("."))
                    constraint_type = NAME_NARROWS
                  else
                    ndx = in_name.last_index_of(this_name)
                    if ((in_name.char_at(ndx - 1)).equal?(Character.new(?@.ord)))
                      constraint_type = NAME_NARROWS
                    else
                      constraint_type = NAME_SAME_TYPE
                    end
                  end
                end
              else
                constraint_type = NAME_SAME_TYPE
              end
            end
          end
        end
      end
      return constraint_type
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      subtree = @name
      i = 1
      # strip off name@ portion
      at_ndx = subtree.last_index_of(Character.new(?@.ord))
      if (at_ndx >= 0)
        i += 1
        subtree = RJava.cast_to_string(subtree.substring(at_ndx + 1))
      end
      # count dots in dnsname, adding one if dnsname preceded by @
      while subtree.last_index_of(Character.new(?..ord)) >= 0
        subtree = RJava.cast_to_string(subtree.substring(0, subtree.last_index_of(Character.new(?..ord))))
        i += 1
      end
      return i
    end
    
    private
    alias_method :initialize__rfc822name, :initialize
  end
  
end

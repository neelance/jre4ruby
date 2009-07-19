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
  module DNSNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This class implements the DNSName as required by the GeneralNames
  # ASN.1 object.
  # <p>
  # [RFC2459] When the subjectAltName extension contains a domain name service
  # label, the domain name MUST be stored in the dNSName (an IA5String).
  # The name MUST be in the "preferred name syntax," as specified by RFC
  # 1034 [RFC 1034]. Note that while upper and lower case letters are
  # allowed in domain names, no signifigance is attached to the case.  In
  # addition, while the string " " is a legal domain name, subjectAltName
  # extensions with a dNSName " " are not permitted.  Finally, the use of
  # the DNS representation for Internet mail addresses (wpolk.nist.gov
  # instead of wpolk@nist.gov) is not permitted; such identities are to
  # be encoded as rfc822Name.
  # <p>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class DNSName 
    include_class_members DNSNameImports
    include GeneralNameInterface
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    class_module.module_eval {
      const_set_lazy(:Alpha) { "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" }
      const_attr_reader  :Alpha
      
      const_set_lazy(:DigitsAndHyphen) { "0123456789-" }
      const_attr_reader  :DigitsAndHyphen
      
      const_set_lazy(:AlphaDigitsAndHyphen) { Alpha + DigitsAndHyphen }
      const_attr_reader  :AlphaDigitsAndHyphen
    }
    
    typesig { [DerValue] }
    # Create the DNSName object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER DNSName.
    # @exception IOException on error.
    def initialize(der_value)
      @name = nil
      @name = (der_value.get_ia5string).to_s
    end
    
    typesig { [String] }
    # Create the DNSName object with the specified name.
    # 
    # @param name the DNSName.
    # @throws IOException if the name is not a valid DNSName subjectAltName
    def initialize(name)
      @name = nil
      if ((name).nil? || (name.length).equal?(0))
        raise IOException.new("DNS name must not be null")
      end
      if (!(name.index_of(Character.new(?\s.ord))).equal?(-1))
        raise IOException.new("DNS names or NameConstraints with blank components are not permitted")
      end
      if ((name.char_at(0)).equal?(Character.new(?..ord)) || (name.char_at(name.length - 1)).equal?(Character.new(?..ord)))
        raise IOException.new("DNS names or NameConstraints may not begin or end with a .")
      end
      # Name will consist of label components separated by "."
      # startIndex is the index of the first character of a component
      # endIndex is the index of the last character of a component plus 1
      end_index = 0
      start_index = 0
      while start_index < name.length
        end_index = name.index_of(Character.new(?..ord), start_index)
        if (end_index < 0)
          end_index = name.length
        end
        if ((end_index - start_index) < 1)
          raise IOException.new("DNSName SubjectAltNames with empty components are not permitted")
        end
        # DNSName components must begin with a letter A-Z or a-z
        if (Alpha.index_of(name.char_at(start_index)) < 0)
          raise IOException.new("DNSName components must begin with a letter")
        end
        # nonStartIndex: index for characters in the component beyond the first one
        non_start_index = start_index + 1
        while non_start_index < end_index
          x = name.char_at(non_start_index)
          if ((AlphaDigitsAndHyphen).index_of(x) < 0)
            raise IOException.new("DNSName components must consist of letters, digits, and hyphens")
          end
          ((non_start_index += 1) - 1)
        end
        start_index = end_index + 1
      end
      @name = name
    end
    
    typesig { [] }
    # Return the type of the GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_DNS)
    end
    
    typesig { [] }
    # Return the actual name value of the GeneralName.
    def get_name
      return @name
    end
    
    typesig { [DerOutputStream] }
    # Encode the DNS name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the DNSName to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_ia5string(@name)
    end
    
    typesig { [] }
    # Convert the name into user readable string.
    def to_s
      return ("DNSName: " + @name)
    end
    
    typesig { [Object] }
    # Compares this name with another, for equality.
    # 
    # @return true iff the names are equivalent
    # according to RFC2459.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(DNSName)))
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
    # Return type of constraint inputName places on this name:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name (i.e. does not constrain).
    # <li>NAME_MATCH = 0: input name matches name.
    # <li>NAME_NARROWS = 1: input name narrows name (is lower in the naming subtree)
    # <li>NAME_WIDENS = 2: input name widens name (is higher in the naming subtree)
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but is same type.
    # </ul>.  These results are used in checking NameConstraints during
    # certification path verification.
    # <p>
    # RFC2459: DNS name restrictions are expressed as foo.bar.com. Any subdomain
    # satisfies the name constraint. For example, www.foo.bar.com would
    # satisfy the constraint but bigfoo.bar.com would not.
    # <p>
    # draft-ietf-pkix-new-part1-00.txt:  DNS name restrictions are expressed as foo.bar.com.
    # Any DNS name that
    # can be constructed by simply adding to the left hand side of the name
    # satisfies the name constraint. For example, www.foo.bar.com would
    # satisfy the constraint but foo1.bar.com would not.
    # <p>
    # RFC1034: By convention, domain names can be stored with arbitrary case, but
    # domain name comparisons for all present domain functions are done in a
    # case-insensitive manner, assuming an ASCII character set, and a high
    # order zero bit.
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
        if (!(input_name.get_type).equal?(NAME_DNS))
          constraint_type = NAME_DIFF_TYPE
        else
          in_name = ((input_name).get_name).to_lower_case
          this_name = @name.to_lower_case
          if ((in_name == this_name))
            constraint_type = NAME_MATCH
          else
            if (this_name.ends_with(in_name))
              in_ndx = this_name.last_index_of(in_name)
              if ((this_name.char_at(in_ndx - 1)).equal?(Character.new(?..ord)))
                constraint_type = NAME_WIDENS
              else
                constraint_type = NAME_SAME_TYPE
              end
            else
              if (in_name.ends_with(this_name))
                ndx = in_name.last_index_of(this_name)
                if ((in_name.char_at(ndx - 1)).equal?(Character.new(?..ord)))
                  constraint_type = NAME_NARROWS
                else
                  constraint_type = NAME_SAME_TYPE
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
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      subtree = @name
      i = 1
      # count dots
      while subtree.last_index_of(Character.new(?..ord)) >= 0
        subtree = (subtree.substring(0, subtree.last_index_of(Character.new(?..ord)))).to_s
        ((i += 1) - 1)
      end
      return i
    end
    
    private
    alias_method :initialize__dnsname, :initialize
  end
  
end

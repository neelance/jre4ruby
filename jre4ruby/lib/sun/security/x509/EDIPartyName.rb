require "rjava"

# 
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
  module EDIPartyNameImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the EDIPartyName of the GeneralName choice.
  # The ASN.1 syntax for this is:
  # <pre>
  # EDIPartyName ::= SEQUENCE {
  # nameAssigner  [0]  DirectoryString OPTIONAL,
  # partyName     [1]  DirectoryString }
  # </pre>
  # 
  # @author Hemma Prafullchandra
  # @see GeneralName
  # @see GeneralNames
  # @see GeneralNameInterface
  class EDIPartyName 
    include_class_members EDIPartyNameImports
    include GeneralNameInterface
    
    class_module.module_eval {
      # Private data members
      const_set_lazy(:TAG_ASSIGNER) { 0 }
      const_attr_reader  :TAG_ASSIGNER
      
      const_set_lazy(:TAG_PARTYNAME) { 1 }
      const_attr_reader  :TAG_PARTYNAME
    }
    
    attr_accessor :assigner
    alias_method :attr_assigner, :assigner
    undef_method :assigner
    alias_method :attr_assigner=, :assigner=
    undef_method :assigner=
    
    attr_accessor :party
    alias_method :attr_party, :party
    undef_method :party
    alias_method :attr_party=, :party=
    undef_method :party=
    
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [String, String] }
    # 
    # Create the EDIPartyName object from the specified names.
    # 
    # @param assignerName the name of the assigner
    # @param partyName the name of the EDI party.
    def initialize(assigner_name, party_name)
      @assigner = nil
      @party = nil
      @myhash = -1
      @assigner = assigner_name
      @party = party_name
    end
    
    typesig { [String] }
    # 
    # Create the EDIPartyName object from the specified name.
    # 
    # @param partyName the name of the EDI party.
    def initialize(party_name)
      @assigner = nil
      @party = nil
      @myhash = -1
      @party = party_name
    end
    
    typesig { [DerValue] }
    # 
    # Create the EDIPartyName object from the passed encoded Der value.
    # 
    # @param derValue the encoded DER EDIPartyName.
    # @exception IOException on error.
    def initialize(der_value)
      @assigner = nil
      @party = nil
      @myhash = -1
      in_ = DerInputStream.new(der_value.to_byte_array)
      seq = in_.get_sequence(2)
      len = seq.attr_length
      if (len < 1 || len > 2)
        raise IOException.new("Invalid encoding of EDIPartyName")
      end
      i = 0
      while i < len
        opt = seq[i]
        if (opt.is_context_specific(TAG_ASSIGNER) && !opt.is_constructed)
          if (!(@assigner).nil?)
            raise IOException.new("Duplicate nameAssigner found in" + " EDIPartyName")
          end
          opt = opt.attr_data.get_der_value
          @assigner = (opt.get_as_string).to_s
        end
        if (opt.is_context_specific(TAG_PARTYNAME) && !opt.is_constructed)
          if (!(@party).nil?)
            raise IOException.new("Duplicate partyName found in" + " EDIPartyName")
          end
          opt = opt.attr_data.get_der_value
          @party = (opt.get_as_string).to_s
        end
        ((i += 1) - 1)
      end
    end
    
    typesig { [] }
    # 
    # Return the type of the GeneralName.
    def get_type
      return (GeneralNameInterface::NAME_EDI)
    end
    
    typesig { [DerOutputStream] }
    # 
    # Encode the EDI party name into the DerOutputStream.
    # 
    # @param out the DER stream to encode the EDIPartyName to.
    # @exception IOException on encoding errors.
    def encode(out)
      tagged = DerOutputStream.new
      tmp = DerOutputStream.new
      if (!(@assigner).nil?)
        tmp2 = DerOutputStream.new
        # XXX - shd check is chars fit into PrintableString
        tmp2.put_printable_string(@assigner)
        tagged.write(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_ASSIGNER), tmp2)
      end
      if ((@party).nil?)
        raise IOException.new("Cannot have null partyName")
      end
      # XXX - shd check is chars fit into PrintableString
      tmp.put_printable_string(@party)
      tagged.write(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_PARTYNAME), tmp)
      out.write(DerValue.attr_tag_sequence, tagged)
    end
    
    typesig { [] }
    # 
    # Return the assignerName
    # 
    # @returns String assignerName
    def get_assigner_name
      return @assigner
    end
    
    typesig { [] }
    # 
    # Return the partyName
    # 
    # @returns String partyName
    def get_party_name
      return @party
    end
    
    typesig { [Object] }
    # 
    # Compare this EDIPartyName with another.  Does a byte-string
    # comparison without regard to type of the partyName and
    # the assignerName.
    # 
    # @returns true if the two names match
    def equals(other)
      if (!(other.is_a?(EDIPartyName)))
        return false
      end
      other_assigner = (other).attr_assigner
      if ((@assigner).nil?)
        if (!(other_assigner).nil?)
          return false
        end
      else
        if (!((@assigner == other_assigner)))
          return false
        end
      end
      other_party = (other).attr_party
      if ((@party).nil?)
        if (!(other_party).nil?)
          return false
        end
      else
        if (!((@party == other_party)))
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns the hash code value for this EDIPartyName.
    # 
    # @return a hash code value.
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = 37 + @party.hash_code
        if (!(@assigner).nil?)
          @myhash = 37 * @myhash + @assigner.hash_code
        end
      end
      return @myhash
    end
    
    typesig { [] }
    # 
    # Return the printable string.
    def to_s
      return ("EDIPartyName: " + ((((@assigner).nil?) ? "" : ("  nameAssigner = " + @assigner + ","))).to_s + "  partyName = " + @party)
    end
    
    typesig { [GeneralNameInterface] }
    # 
    # Return constraint type:<ul>
    # <li>NAME_DIFF_TYPE = -1: input name is different type from name (i.e. does not constrain)
    # <li>NAME_MATCH = 0: input name matches name
    # <li>NAME_NARROWS = 1: input name narrows name
    # <li>NAME_WIDENS = 2: input name widens name
    # <li>NAME_SAME_TYPE = 3: input name does not match or narrow name, but is same type
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
        if (!(input_name.get_type).equal?(NAME_EDI))
          constraint_type = NAME_DIFF_TYPE
        else
          raise UnsupportedOperationException.new("Narrowing, widening, and matching of names not supported for EDIPartyName")
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
      raise UnsupportedOperationException.new("subtreeDepth() not supported for EDIPartyName")
    end
    
    private
    alias_method :initialize__ediparty_name, :initialize
  end
  
end

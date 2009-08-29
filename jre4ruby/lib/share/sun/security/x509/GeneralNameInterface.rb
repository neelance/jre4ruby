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
  module GeneralNameInterfaceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This interface specifies the abstract methods which have to be
  # implemented by all the members of the GeneralNames ASN.1 object.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  module GeneralNameInterface
    include_class_members GeneralNameInterfaceImports
    
    class_module.module_eval {
      # The list of names supported.
      const_set_lazy(:NAME_ANY) { 0 }
      const_attr_reader  :NAME_ANY
      
      const_set_lazy(:NAME_RFC822) { 1 }
      const_attr_reader  :NAME_RFC822
      
      const_set_lazy(:NAME_DNS) { 2 }
      const_attr_reader  :NAME_DNS
      
      const_set_lazy(:NAME_X400) { 3 }
      const_attr_reader  :NAME_X400
      
      const_set_lazy(:NAME_DIRECTORY) { 4 }
      const_attr_reader  :NAME_DIRECTORY
      
      const_set_lazy(:NAME_EDI) { 5 }
      const_attr_reader  :NAME_EDI
      
      const_set_lazy(:NAME_URI) { 6 }
      const_attr_reader  :NAME_URI
      
      const_set_lazy(:NAME_IP) { 7 }
      const_attr_reader  :NAME_IP
      
      const_set_lazy(:NAME_OID) { 8 }
      const_attr_reader  :NAME_OID
      
      # The list of constraint results.
      const_set_lazy(:NAME_DIFF_TYPE) { -1 }
      const_attr_reader  :NAME_DIFF_TYPE
      
      # input name is different type from name (i.e. does not constrain)
      const_set_lazy(:NAME_MATCH) { 0 }
      const_attr_reader  :NAME_MATCH
      
      # input name matches name
      const_set_lazy(:NAME_NARROWS) { 1 }
      const_attr_reader  :NAME_NARROWS
      
      # input name narrows name
      const_set_lazy(:NAME_WIDENS) { 2 }
      const_attr_reader  :NAME_WIDENS
      
      # input name widens name
      const_set_lazy(:NAME_SAME_TYPE) { 3 }
      const_attr_reader  :NAME_SAME_TYPE
    }
    
    typesig { [] }
    # input name does not match, narrow, or widen, but is same type
    # 
    # Return the type of the general name, as
    # defined above.
    def get_type
      raise NotImplementedError
    end
    
    typesig { [DerOutputStream] }
    # Encode the name to the specified DerOutputStream.
    # 
    # @param out the DerOutputStream to encode the GeneralName to.
    # @exception IOException thrown if the GeneralName could not be
    # encoded.
    def encode(out)
      raise NotImplementedError
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
    # 
    # @param inputName to be checked for being constrained
    # @returns constraint type above
    # @throws UnsupportedOperationException if name is same type, but comparison operations are
    # not supported for this name type.
    def constrains(input_name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return subtree depth of this name for purposes of determining
    # NameConstraints minimum and maximum bounds and for calculating
    # path lengths in name subtrees.
    # 
    # @returns distance of name from root
    # @throws UnsupportedOperationException if not supported for this name type
    def subtree_depth
      raise NotImplementedError
    end
  end
  
end

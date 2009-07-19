require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertAttrSetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Util, :Enumeration
    }
  end
  
  # This interface defines the methods required of a certificate attribute.
  # Examples of X.509 certificate attributes are Validity, Issuer_Name, and
  # Subject Name. A CertAttrSet may comprise one attribute or many
  # attributes.
  # <p>
  # A CertAttrSet itself can also be comprised of other sub-sets.
  # In the case of X.509 V3 certificates, for example, the "extensions"
  # attribute has subattributes, such as those for KeyUsage and
  # AuthorityKeyIdentifier.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertificateException
  module CertAttrSet
    include_class_members CertAttrSetImports
    
    typesig { [] }
    # Returns a short string describing this certificate attribute.
    # 
    # @return value of this certificate attribute in
    # printable form.
    def to_s
      raise NotImplementedError
    end
    
    typesig { [OutputStream] }
    # Encodes the attribute to the output stream in a format
    # that can be parsed by the <code>decode</code> method.
    # 
    # @param out the OutputStream to encode the attribute to.
    # 
    # @exception CertificateException on encoding or validity errors.
    # @exception IOException on other errors.
    def encode(out)
      raise NotImplementedError
    end
    
    typesig { [String, Object] }
    # Sets an attribute value within this CertAttrSet.
    # 
    # @param name the name of the attribute (e.g. "x509.info.key")
    # @param obj the attribute object.
    # 
    # @exception CertificateException on attribute handling errors.
    # @exception IOException on other errors.
    def set(name, obj)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Gets an attribute value for this CertAttrSet.
    # 
    # @param name the name of the attribute to return.
    # 
    # @exception CertificateException on attribute handling errors.
    # @exception IOException on other errors.
    def get(name)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Deletes an attribute value from this CertAttrSet.
    # 
    # @param name the name of the attribute to delete.
    # 
    # @exception CertificateException on attribute handling errors.
    # @exception IOException on other errors.
    def delete(name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an enumeration of the names of the attributes existing within
    # this attribute.
    # 
    # @return an enumeration of the attribute names.
    def get_elements
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the name (identifier) of this CertAttrSet.
    # 
    # @return the name of this CertAttrSet.
    def get_name
      raise NotImplementedError
    end
  end
  
end

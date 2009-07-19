require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FreshestCRLExtensionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaList
      include ::Sun::Security::Util
    }
  end
  
  # Represents the Freshest CRL Extension.
  # 
  # <p>
  # The extension identifies how delta CRL information for a
  # complete CRL is obtained.
  # 
  # <p>
  # The extension is defined in Section 5.2.6 of
  # <a href="http://www.ietf.org/rfc/rfc3280.txt">Internet X.509 PKI Certific
  # ate and Certificate Revocation List (CRL) Profile</a>.
  # 
  # <p>
  # Its ASN.1 definition is as follows:
  # <pre>
  # id-ce-freshestCRL OBJECT IDENTIFIER ::=  { id-ce 46 }
  # 
  # FreshestCRL ::= CRLDistributionPoints
  # </pre>
  # 
  # @since 1.6
  class FreshestCRLExtension < FreshestCRLExtensionImports.const_get :CRLDistributionPointsExtension
    include_class_members FreshestCRLExtensionImports
    
    class_module.module_eval {
      # Attribute name.
      const_set_lazy(:NAME) { "FreshestCRL" }
      const_attr_reader  :NAME
    }
    
    typesig { [JavaList] }
    # Creates a freshest CRL extension.
    # The criticality is set to false.
    # 
    # @param distributionPoints the list of delta CRL distribution points.
    def initialize(distribution_points)
      super(PKIXExtensions::FreshestCRL_Id, false, distribution_points, NAME)
    end
    
    typesig { [Boolean, Object] }
    # Creates the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception IOException on decoding error.
    def initialize(critical, value)
      super(PKIXExtensions::FreshestCRL_Id, critical.boolean_value, value, NAME)
    end
    
    typesig { [OutputStream] }
    # Writes the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      super(out, PKIXExtensions::FreshestCRL_Id, false)
    end
    
    private
    alias_method :initialize__freshest_crlextension, :initialize
  end
  
end

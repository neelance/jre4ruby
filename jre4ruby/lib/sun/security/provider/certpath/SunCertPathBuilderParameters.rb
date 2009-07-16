require "rjava"

# 
# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider::Certpath
  module SunCertPathBuilderParametersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :KeyStore
      include_const ::Java::Security, :KeyStoreException
      include ::Java::Security::Cert
    }
  end
  
  # 
  # This class specifies the set of parameters used as input for the Sun
  # certification path build algorithm. It is identical to PKIXBuilderParameters
  # with the addition of a <code>buildForward</code> parameter which allows
  # the caller to specify whether or not the path should be constructed in
  # the forward direction.
  # 
  # The default for the <code>buildForward</code> parameter is
  # true, which means that the build algorithm should construct paths
  # from the target subject back to the trusted anchor.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class SunCertPathBuilderParameters < SunCertPathBuilderParametersImports.const_get :PKIXBuilderParameters
    include_class_members SunCertPathBuilderParametersImports
    
    attr_accessor :build_forward
    alias_method :attr_build_forward, :build_forward
    undef_method :build_forward
    alias_method :attr_build_forward=, :build_forward=
    undef_method :build_forward=
    
    typesig { [JavaSet, CertSelector] }
    # 
    # Creates an instance of <code>SunCertPathBuilderParameters</code> with the
    # specified parameter values.
    # 
    # @param trustAnchors a <code>Set</code> of <code>TrustAnchor</code>s
    # @param targetConstraints a <code>CertSelector</code> specifying the
    # constraints on the target certificate
    # @throws InvalidAlgorithmParameterException if the specified
    # <code>Set</code> is empty <code>(trustAnchors.isEmpty() == true)</code>
    # @throws NullPointerException if the specified <code>Set</code> is
    # <code>null</code>
    # @throws ClassCastException if any of the elements in the <code>Set</code>
    # are not of type <code>java.security.cert.TrustAnchor</code>
    def initialize(trust_anchors, target_constraints)
      @build_forward = false
      super(trust_anchors, target_constraints)
      @build_forward = true
      set_build_forward(true)
    end
    
    typesig { [KeyStore, CertSelector] }
    # 
    # Creates an instance of <code>SunCertPathBuilderParameters</code> that
    # uses the specified <code>KeyStore</code> to populate the set
    # of most-trusted CA certificates.
    # 
    # @param keystore A keystore from which the set of most-trusted
    # CA certificates will be populated.
    # @param targetConstraints a <code>CertSelector</code> specifying the
    # constraints on the target certificate
    # @throws KeyStoreException if the keystore has not been initialized.
    # @throws InvalidAlgorithmParameterException if the keystore does
    # not contain at least one trusted certificate entry
    # @throws NullPointerException if the keystore is <code>null</code>
    def initialize(keystore, target_constraints)
      @build_forward = false
      super(keystore, target_constraints)
      @build_forward = true
      set_build_forward(true)
    end
    
    typesig { [] }
    # 
    # Returns the value of the buildForward flag.
    # 
    # @return the value of the buildForward flag
    def get_build_forward
      return @build_forward
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Sets the value of the buildForward flag. If true, paths
    # are built from the target subject to the trusted anchor.
    # If false, paths are built from the trusted anchor to the
    # target subject. The default value if not specified is true.
    # 
    # @param buildForward the value of the buildForward flag
    def set_build_forward(build_forward)
      @build_forward = build_forward
    end
    
    typesig { [] }
    # 
    # Returns a formatted string describing the parameters.
    # 
    # @return a formatted string describing the parameters.
    def to_s
      sb = StringBuffer.new
      sb.append("[\n")
      sb.append(super)
      sb.append("  Build Forward Flag: " + (String.value_of(@build_forward)).to_s + "\n")
      sb.append("]\n")
      return sb.to_s
    end
    
    private
    alias_method :initialize__sun_cert_path_builder_parameters, :initialize
  end
  
end

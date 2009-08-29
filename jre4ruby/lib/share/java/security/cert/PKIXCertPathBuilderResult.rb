require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Cert
  module PKIXCertPathBuilderResultImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :PublicKey
    }
  end
  
  # This class represents the successful result of the PKIX certification
  # path builder algorithm. All certification paths that are built and
  # returned using this algorithm are also validated according to the PKIX
  # certification path validation algorithm.
  # 
  # <p>Instances of <code>PKIXCertPathBuilderResult</code> are returned by
  # the <code>build</code> method of <code>CertPathBuilder</code>
  # objects implementing the PKIX algorithm.
  # 
  # <p>All <code>PKIXCertPathBuilderResult</code> objects contain the
  # certification path constructed by the build algorithm, the
  # valid policy tree and subject public key resulting from the build
  # algorithm, and a <code>TrustAnchor</code> describing the certification
  # authority (CA) that served as a trust anchor for the certification path.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathBuilderResult
  # 
  # @since       1.4
  # @author      Anne Anderson
  class PKIXCertPathBuilderResult < PKIXCertPathBuilderResultImports.const_get :PKIXCertPathValidatorResult
    include_class_members PKIXCertPathBuilderResultImports
    overload_protected {
      include CertPathBuilderResult
    }
    
    attr_accessor :cert_path
    alias_method :attr_cert_path, :cert_path
    undef_method :cert_path
    alias_method :attr_cert_path=, :cert_path=
    undef_method :cert_path=
    
    typesig { [CertPath, TrustAnchor, PolicyNode, PublicKey] }
    # Creates an instance of <code>PKIXCertPathBuilderResult</code>
    # containing the specified parameters.
    # 
    # @param certPath the validated <code>CertPath</code>
    # @param trustAnchor a <code>TrustAnchor</code> describing the CA that
    # served as a trust anchor for the certification path
    # @param policyTree the immutable valid policy tree, or <code>null</code>
    # if there are no valid policies
    # @param subjectPublicKey the public key of the subject
    # @throws NullPointerException if the <code>certPath</code>,
    # <code>trustAnchor</code> or <code>subjectPublicKey</code> parameters
    # are <code>null</code>
    def initialize(cert_path, trust_anchor, policy_tree, subject_public_key)
      @cert_path = nil
      super(trust_anchor, policy_tree, subject_public_key)
      if ((cert_path).nil?)
        raise NullPointerException.new("certPath must be non-null")
      end
      @cert_path = cert_path
    end
    
    typesig { [] }
    # Returns the built and validated certification path. The
    # <code>CertPath</code> object does not include the trust anchor.
    # Instead, use the {@link #getTrustAnchor() getTrustAnchor()} method to
    # obtain the <code>TrustAnchor</code> that served as the trust anchor
    # for the certification path.
    # 
    # @return the built and validated <code>CertPath</code> (never
    # <code>null</code>)
    def get_cert_path
      return @cert_path
    end
    
    typesig { [] }
    # Return a printable representation of this
    # <code>PKIXCertPathBuilderResult</code>.
    # 
    # @return a <code>String</code> describing the contents of this
    # <code>PKIXCertPathBuilderResult</code>
    def to_s
      sb = StringBuffer.new
      sb.append("PKIXCertPathBuilderResult: [\n")
      sb.append("  Certification Path: " + RJava.cast_to_string(@cert_path) + "\n")
      sb.append("  Trust Anchor: " + RJava.cast_to_string(get_trust_anchor.to_s) + "\n")
      sb.append("  Policy Tree: " + RJava.cast_to_string(String.value_of(get_policy_tree)) + "\n")
      sb.append("  Subject Public Key: " + RJava.cast_to_string(get_public_key) + "\n")
      sb.append("]")
      return sb.to_s
    end
    
    private
    alias_method :initialize__pkixcert_path_builder_result, :initialize
  end
  
end

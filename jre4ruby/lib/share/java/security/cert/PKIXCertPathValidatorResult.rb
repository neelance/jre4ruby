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
  module PKIXCertPathValidatorResultImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :PublicKey
    }
  end
  
  # This class represents the successful result of the PKIX certification
  # path validation algorithm.
  # 
  # <p>Instances of <code>PKIXCertPathValidatorResult</code> are returned by the
  # {@link CertPathValidator#validate validate} method of
  # <code>CertPathValidator</code> objects implementing the PKIX algorithm.
  # 
  # <p> All <code>PKIXCertPathValidatorResult</code> objects contain the
  # valid policy tree and subject public key resulting from the
  # validation algorithm, as well as a <code>TrustAnchor</code> describing
  # the certification authority (CA) that served as a trust anchor for the
  # certification path.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathValidatorResult
  # 
  # @since       1.4
  # @author      Yassir Elley
  # @author      Sean Mullan
  class PKIXCertPathValidatorResult 
    include_class_members PKIXCertPathValidatorResultImports
    include CertPathValidatorResult
    
    attr_accessor :trust_anchor
    alias_method :attr_trust_anchor, :trust_anchor
    undef_method :trust_anchor
    alias_method :attr_trust_anchor=, :trust_anchor=
    undef_method :trust_anchor=
    
    attr_accessor :policy_tree
    alias_method :attr_policy_tree, :policy_tree
    undef_method :policy_tree
    alias_method :attr_policy_tree=, :policy_tree=
    undef_method :policy_tree=
    
    attr_accessor :subject_public_key
    alias_method :attr_subject_public_key, :subject_public_key
    undef_method :subject_public_key
    alias_method :attr_subject_public_key=, :subject_public_key=
    undef_method :subject_public_key=
    
    typesig { [TrustAnchor, PolicyNode, PublicKey] }
    # Creates an instance of <code>PKIXCertPathValidatorResult</code>
    # containing the specified parameters.
    # 
    # @param trustAnchor a <code>TrustAnchor</code> describing the CA that
    # served as a trust anchor for the certification path
    # @param policyTree the immutable valid policy tree, or <code>null</code>
    # if there are no valid policies
    # @param subjectPublicKey the public key of the subject
    # @throws NullPointerException if the <code>subjectPublicKey</code> or
    # <code>trustAnchor</code> parameters are <code>null</code>
    def initialize(trust_anchor, policy_tree, subject_public_key)
      @trust_anchor = nil
      @policy_tree = nil
      @subject_public_key = nil
      if ((subject_public_key).nil?)
        raise NullPointerException.new("subjectPublicKey must be non-null")
      end
      if ((trust_anchor).nil?)
        raise NullPointerException.new("trustAnchor must be non-null")
      end
      @trust_anchor = trust_anchor
      @policy_tree = policy_tree
      @subject_public_key = subject_public_key
    end
    
    typesig { [] }
    # Returns the <code>TrustAnchor</code> describing the CA that served
    # as a trust anchor for the certification path.
    # 
    # @return the <code>TrustAnchor</code> (never <code>null</code>)
    def get_trust_anchor
      return @trust_anchor
    end
    
    typesig { [] }
    # Returns the root node of the valid policy tree resulting from the
    # PKIX certification path validation algorithm. The
    # <code>PolicyNode</code> object that is returned and any objects that
    # it returns through public methods are immutable.
    # 
    # <p>Most applications will not need to examine the valid policy tree.
    # They can achieve their policy processing goals by setting the
    # policy-related parameters in <code>PKIXParameters</code>. However, more
    # sophisticated applications, especially those that process policy
    # qualifiers, may need to traverse the valid policy tree using the
    # {@link PolicyNode#getParent PolicyNode.getParent} and
    # {@link PolicyNode#getChildren PolicyNode.getChildren} methods.
    # 
    # @return the root node of the valid policy tree, or <code>null</code>
    # if there are no valid policies
    def get_policy_tree
      return @policy_tree
    end
    
    typesig { [] }
    # Returns the public key of the subject (target) of the certification
    # path, including any inherited public key parameters if applicable.
    # 
    # @return the public key of the subject (never <code>null</code>)
    def get_public_key
      return @subject_public_key
    end
    
    typesig { [] }
    # Returns a copy of this object.
    # 
    # @return the copy
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        # Cannot happen
        raise InternalError.new(e.to_s)
      end
    end
    
    typesig { [] }
    # Return a printable representation of this
    # <code>PKIXCertPathValidatorResult</code>.
    # 
    # @return a <code>String</code> describing the contents of this
    # <code>PKIXCertPathValidatorResult</code>
    def to_s
      sb = StringBuffer.new
      sb.append("PKIXCertPathValidatorResult: [\n")
      sb.append("  Trust Anchor: " + RJava.cast_to_string(@trust_anchor.to_s) + "\n")
      sb.append("  Policy Tree: " + RJava.cast_to_string(String.value_of(@policy_tree)) + "\n")
      sb.append("  Subject Public Key: " + RJava.cast_to_string(@subject_public_key) + "\n")
      sb.append("]")
      return sb.to_s
    end
    
    private
    alias_method :initialize__pkixcert_path_validator_result, :initialize
  end
  
end

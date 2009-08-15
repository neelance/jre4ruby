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
module Sun::Security::Provider::Certpath
  module SunCertPathBuilderResultImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Sun::Security::Util, :Debug
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :PKIXCertPathBuilderResult
      include_const ::Java::Security::Cert, :PolicyNode
      include_const ::Java::Security::Cert, :TrustAnchor
    }
  end
  
  # This class represents the result of a SunCertPathBuilder build.
  # Since all paths returned by the SunCertPathProvider are PKIX validated
  # the result contains the valid policy tree and subject public key returned
  # by the algorithm. It also contains the trust anchor and debug information
  # represented in the form of an adjacency list.
  # 
  # @see PKIXCertPathBuilderResult
  # 
  # @since       1.4
  # @author      Sean Mullan
  # 
  # @@@ Note: this class is not in public API and access to adjacency list is
  # @@@ intended for debugging/replay of Sun PKIX CertPathBuilder implementation.
  class SunCertPathBuilderResult < SunCertPathBuilderResultImports.const_get :PKIXCertPathBuilderResult
    include_class_members SunCertPathBuilderResultImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :adj_list
    alias_method :attr_adj_list, :adj_list
    undef_method :adj_list
    alias_method :attr_adj_list=, :adj_list=
    undef_method :adj_list=
    
    typesig { [CertPath, TrustAnchor, PolicyNode, PublicKey, AdjacencyList] }
    # Creates a SunCertPathBuilderResult instance.
    # 
    # @param certPath the validated <code>CertPath</code>
    # @param trustAnchor a <code>TrustAnchor</code> describing the CA that
    # served as a trust anchor for the certification path
    # @param policyTree the valid policy tree, or <code>null</code>
    # if there are no valid policies
    # @param subjectPublicKey the public key of the subject
    # @param adjList an Adjacency list containing debug information
    def initialize(cert_path, trust_anchor, policy_tree, subject_public_key, adj_list)
      @adj_list = nil
      super(cert_path, trust_anchor, policy_tree, subject_public_key)
      @adj_list = adj_list
    end
    
    typesig { [] }
    # Returns the adjacency list containing information about the build.
    # 
    # @return The adjacency list containing information about the build.
    def get_adjacency_list
      return @adj_list
    end
    
    private
    alias_method :initialize__sun_cert_path_builder_result, :initialize
  end
  
end

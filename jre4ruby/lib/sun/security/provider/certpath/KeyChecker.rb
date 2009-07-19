require "rjava"

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
  module KeyCheckerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Util
      include ::Java::Security::Cert
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :PKIXExtensions
    }
  end
  
  # KeyChecker is a <code>PKIXCertPathChecker</code> that checks that the
  # keyCertSign bit is set in the keyUsage extension in an intermediate CA
  # certificate. It also checks whether the final certificate in a
  # certification path meets the specified target constraints specified as
  # a CertSelector in the PKIXParameters passed to the CertPathValidator.
  # 
  # @since       1.4
  # @author      Yassir Elley
  class KeyChecker < KeyCheckerImports.const_get :PKIXCertPathChecker
    include_class_members KeyCheckerImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      # the index of keyCertSign in the boolean KeyUsage array
      const_set_lazy(:KeyCertSign) { 5 }
      const_attr_reader  :KeyCertSign
    }
    
    attr_accessor :cert_path_len
    alias_method :attr_cert_path_len, :cert_path_len
    undef_method :cert_path_len
    alias_method :attr_cert_path_len=, :cert_path_len=
    undef_method :cert_path_len=
    
    attr_accessor :target_constraints
    alias_method :attr_target_constraints, :target_constraints
    undef_method :target_constraints
    alias_method :attr_target_constraints=, :target_constraints=
    undef_method :target_constraints=
    
    attr_accessor :remaining_certs
    alias_method :attr_remaining_certs, :remaining_certs
    undef_method :remaining_certs
    alias_method :attr_remaining_certs=, :remaining_certs=
    undef_method :remaining_certs=
    
    class_module.module_eval {
      
      def supported_exts
        defined?(@@supported_exts) ? @@supported_exts : @@supported_exts= nil
      end
      alias_method :attr_supported_exts, :supported_exts
      
      def supported_exts=(value)
        @@supported_exts = value
      end
      alias_method :attr_supported_exts=, :supported_exts=
    }
    
    typesig { [::Java::Int, CertSelector] }
    # Default Constructor
    # 
    # @param certPathLen allowable cert path length
    # @param targetCertSel a CertSelector object specifying the constraints
    # on the target certificate
    def initialize(cert_path_len, target_cert_sel)
      @cert_path_len = 0
      @target_constraints = nil
      @remaining_certs = 0
      super()
      @cert_path_len = cert_path_len
      @target_constraints = target_cert_sel
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    # Initializes the internal state of the checker from parameters
    # specified in the constructor
    def init(forward)
      if (!forward)
        @remaining_certs = @cert_path_len
      else
        raise CertPathValidatorException.new("forward checking not supported")
      end
    end
    
    typesig { [] }
    def is_forward_checking_supported
      return false
    end
    
    typesig { [] }
    def get_supported_extensions
      if ((self.attr_supported_exts).nil?)
        self.attr_supported_exts = HashSet.new
        self.attr_supported_exts.add(PKIXExtensions::KeyUsage_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::ExtendedKeyUsage_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::SubjectAlternativeName_Id.to_s)
        self.attr_supported_exts = Collections.unmodifiable_set(self.attr_supported_exts)
      end
      return self.attr_supported_exts
    end
    
    typesig { [Certificate, Collection] }
    # Checks that keyUsage and target constraints are satisfied by
    # the specified certificate.
    # 
    # @param cert the Certificate
    # @param unresolvedCritExts the unresolved critical extensions
    # @exception CertPathValidatorException Exception thrown if certificate
    # does not verify
    def check(cert, unres_crit_exts)
      curr_cert = cert
      ((@remaining_certs -= 1) + 1)
      # if final certificate, check that target constraints are satisfied
      if ((@remaining_certs).equal?(0))
        if ((!(@target_constraints).nil?) && ((@target_constraints.match(curr_cert)).equal?(false)))
          raise CertPathValidatorException.new("target certificate " + "constraints check failed")
        end
      else
        # otherwise, verify that keyCertSign bit is set in CA certificate
        verify_cakey_usage(curr_cert)
      end
      # remove the extensions that we have checked
      if (!(unres_crit_exts).nil? && !unres_crit_exts.is_empty)
        unres_crit_exts.remove(PKIXExtensions::KeyUsage_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::ExtendedKeyUsage_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::SubjectAlternativeName_Id.to_s)
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate] }
      # Static method to verify that the key usage and extended key usage
      # extension in a CA cert. The key usage extension, if present, must
      # assert the keyCertSign bit. The extended key usage extension, if
      # present, must include anyExtendedKeyUsage.
      def verify_cakey_usage(cert)
        msg = "CA key usage"
        if (!(Debug).nil?)
          Debug.println("KeyChecker.verifyCAKeyUsage() ---checking " + msg + "...")
        end
        key_usage_bits = cert.get_key_usage
        # getKeyUsage returns null if the KeyUsage extension is not present
        # in the certificate - in which case there is nothing to check
        if ((key_usage_bits).nil?)
          return
        end
        # throw an exception if the keyCertSign bit is not set
        if (!key_usage_bits[KeyCertSign])
          raise CertPathValidatorException.new(msg + " check failed: " + "keyCertSign bit is not set")
        end
        if (!(Debug).nil?)
          Debug.println("KeyChecker.verifyCAKeyUsage() " + msg + " verified.")
        end
      end
    }
    
    private
    alias_method :initialize__key_checker, :initialize
  end
  
end

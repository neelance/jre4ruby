require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PKIXMasterCertPathValidatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Sun::Security::Util, :Debug
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :X509Certificate
    }
  end
  
  # This class is initialized with a list of <code>PKIXCertPathChecker</code>s
  # and is used to verify the certificates in a <code>CertPath</code> by
  # feeding each certificate to each <code>PKIXCertPathChecker</code>.
  # 
  # @since       1.4
  # @author      Yassir Elley
  class PKIXMasterCertPathValidator 
    include_class_members PKIXMasterCertPathValidatorImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :cert_path_checkers
    alias_method :attr_cert_path_checkers, :cert_path_checkers
    undef_method :cert_path_checkers
    alias_method :attr_cert_path_checkers=, :cert_path_checkers=
    undef_method :cert_path_checkers=
    
    typesig { [JavaList] }
    # Initializes the list of PKIXCertPathCheckers whose checks
    # will be performed on each certificate in the certpath.
    # 
    # @param certPathCheckers a List of checkers to use
    def initialize(cert_path_checkers)
      @cert_path_checkers = nil
      @cert_path_checkers = cert_path_checkers
    end
    
    typesig { [CertPath, JavaList] }
    # Validates a certification path consisting exclusively of
    # <code>X509Certificate</code>s using the
    # <code>PKIXCertPathChecker</code>s specified
    # in the constructor. It is assumed that the
    # <code>PKIXCertPathChecker</code>s
    # have been initialized with any input parameters they may need.
    # 
    # @param cpOriginal the original X509 CertPath passed in by the user
    # @param reversedCertList the reversed X509 CertPath (as a List)
    # @exception CertPathValidatorException Exception thrown if cert
    # path does not validate.
    def validate(cp_original, reversed_cert_list)
      # we actually process reversedCertList, but we keep cpOriginal because
      # we need to return the original certPath when we throw an exception.
      # we will also need to modify the index appropriately when we
      # throw an exception.
      cp_size = reversed_cert_list.size
      if (!(Debug).nil?)
        Debug.println("--------------------------------------------------" + "------------")
        Debug.println("Executing PKIX certification path validation " + "algorithm.")
      end
      i = 0
      while i < cp_size
        # The basic loop algorithm is that we get the
        # current certificate, we verify the current certificate using
        # information from the previous certificate and from the state,
        # and we modify the state for the next loop by setting the
        # current certificate of this loop to be the previous certificate
        # of the next loop. The state is initialized during first loop.
        if (!(Debug).nil?)
          Debug.println("Checking cert" + RJava.cast_to_string((i + 1)) + " ...")
        end
        curr_cert = reversed_cert_list.get(i)
        unresolved_crit_exts = curr_cert.get_critical_extension_oids
        if ((unresolved_crit_exts).nil?)
          unresolved_crit_exts = Collections.empty_set
        end
        if (!(Debug).nil? && !unresolved_crit_exts.is_empty)
          Debug.println("Set of critical extensions:")
          unresolved_crit_exts.each do |oid|
            Debug.println(oid)
          end
        end
        ocsp_cause = nil
        j = 0
        while j < @cert_path_checkers.size
          curr_checker = @cert_path_checkers.get(j)
          if (!(Debug).nil?)
            Debug.println("-Using checker" + RJava.cast_to_string((j + 1)) + " ... [" + RJava.cast_to_string(curr_checker.get_class.get_name) + "]")
          end
          if ((i).equal?(0))
            curr_checker.init(false)
          end
          begin
            curr_checker.check(curr_cert, unresolved_crit_exts)
            # OCSP has validated the cert so skip the CRL check
            if (is_revocation_check(curr_checker, j, @cert_path_checkers))
              if (!(Debug).nil?)
                Debug.println("-checker" + RJava.cast_to_string((j + 1)) + " validation succeeded")
              end
              j += 1
              j += 1
              next # skip
            end
          rescue CertPathValidatorException => cpve
            # Throw the saved OCSP exception
            # (when the CRL check has also failed)
            if (!(ocsp_cause).nil? && curr_checker.is_a?(CrlRevocationChecker))
              raise ocsp_cause
            end
            # Handle failover from OCSP to CRLs
            current_cause = CertPathValidatorException.new(cpve.get_message, cpve.get_cause, cp_original, cp_size - (i + 1))
            # Check if OCSP has confirmed that the cert was revoked
            if (cpve.is_a?(CertificateRevokedException))
              raise current_cause
            end
            # Check if it is appropriate to failover
            if (!is_revocation_check(curr_checker, j, @cert_path_checkers))
              # no failover
              raise current_cause
            end
            # Save the current exception
            # (in case the CRL check also fails)
            ocsp_cause = current_cause
            # Otherwise, failover to CRLs
            if (!(Debug).nil?)
              Debug.println(cpve.get_message)
              Debug.println("preparing to failover (from OCSP to CRLs)")
            end
          end
          if (!(Debug).nil?)
            Debug.println("-checker" + RJava.cast_to_string((j + 1)) + " validation succeeded")
          end
          j += 1
        end
        if (!(Debug).nil?)
          Debug.println("checking for unresolvedCritExts")
        end
        if (!unresolved_crit_exts.is_empty)
          raise CertPathValidatorException.new("unrecognized " + "critical extension(s)", nil, cp_original, cp_size - (i + 1))
        end
        if (!(Debug).nil?)
          Debug.println("\ncert" + RJava.cast_to_string((i + 1)) + " validation succeeded.\n")
        end
        i += 1
      end
      if (!(Debug).nil?)
        Debug.println("Cert path validation succeeded. (PKIX validation " + "algorithm)")
        Debug.println("-------------------------------------------------" + "-------------")
      end
    end
    
    class_module.module_eval {
      typesig { [PKIXCertPathChecker, ::Java::Int, JavaList] }
      # Examines the list of PKIX cert path checkers to determine whether
      # both the current checker and the next checker are revocation checkers.
      # OCSPChecker and CrlRevocationChecker are both revocation checkers.
      def is_revocation_check(checker, index, checkers)
        if (checker.is_a?(OCSPChecker) && index + 1 < checkers.size)
          next_checker = checkers.get(index + 1)
          if (next_checker.is_a?(CrlRevocationChecker))
            return true
          end
        end
        return false
      end
    }
    
    private
    alias_method :initialize__pkixmaster_cert_path_validator, :initialize
  end
  
end

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
  module ConstraintsCheckerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashSet
      include_const ::Java::Io, :IOException
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :PKIXExtensions
      include_const ::Sun::Security::X509, :NameConstraintsExtension
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # ConstraintsChecker is a <code>PKIXCertPathChecker</code> that checks
  # constraints information on a PKIX certificate, namely basic constraints
  # and name constraints.
  # 
  # @since       1.4
  # @author      Yassir Elley
  class ConstraintsChecker < ConstraintsCheckerImports.const_get :PKIXCertPathChecker
    include_class_members ConstraintsCheckerImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    # length of cert path
    attr_accessor :cert_path_length
    alias_method :attr_cert_path_length, :cert_path_length
    undef_method :cert_path_length
    alias_method :attr_cert_path_length=, :cert_path_length=
    undef_method :cert_path_length=
    
    # current maximum path length (as defined in PKIX)
    attr_accessor :max_path_length
    alias_method :attr_max_path_length, :max_path_length
    undef_method :max_path_length
    alias_method :attr_max_path_length=, :max_path_length=
    undef_method :max_path_length=
    
    # current index of cert
    attr_accessor :i
    alias_method :attr_i, :i
    undef_method :i
    alias_method :attr_i=, :i=
    undef_method :i=
    
    attr_accessor :prev_nc
    alias_method :attr_prev_nc, :prev_nc
    undef_method :prev_nc
    alias_method :attr_prev_nc=, :prev_nc=
    undef_method :prev_nc=
    
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
    
    typesig { [::Java::Int] }
    # Creates a ConstraintsChecker.
    # 
    # @param certPathLength the length of the certification path
    # @throws CertPathValidatorException if the checker cannot be initialized
    def initialize(cert_path_length)
      @cert_path_length = 0
      @max_path_length = 0
      @i = 0
      @prev_nc = nil
      super()
      @cert_path_length = cert_path_length
      init(false)
    end
    
    typesig { [::Java::Boolean] }
    def init(forward)
      if (!forward)
        @i = 0
        @max_path_length = @cert_path_length
        @prev_nc = nil
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
        self.attr_supported_exts.add(PKIXExtensions::BasicConstraints_Id.to_s)
        self.attr_supported_exts.add(PKIXExtensions::NameConstraints_Id.to_s)
        self.attr_supported_exts = Collections.unmodifiable_set(self.attr_supported_exts)
      end
      return self.attr_supported_exts
    end
    
    typesig { [Certificate, Collection] }
    # Performs the basic constraints and name constraints
    # checks on the certificate using its internal state.
    # 
    # @param cert the <code>Certificate</code> to be checked
    # @param unresCritExts a <code>Collection</code> of OID strings
    # representing the current set of unresolved critical extensions
    # @throws CertPathValidatorException if the specified certificate
    # does not pass the check
    def check(cert, unres_crit_exts)
      curr_cert = cert
      @i += 1
      # MUST run NC check second, since it depends on BC check to
      # update remainingCerts
      check_basic_constraints(curr_cert)
      verify_name_constraints(curr_cert)
      if (!(unres_crit_exts).nil? && !unres_crit_exts.is_empty)
        unres_crit_exts.remove(PKIXExtensions::BasicConstraints_Id.to_s)
        unres_crit_exts.remove(PKIXExtensions::NameConstraints_Id.to_s)
      end
    end
    
    typesig { [X509Certificate] }
    # Internal method to check the name constraints against a cert
    def verify_name_constraints(curr_cert)
      msg = "name constraints"
      if (!(Debug).nil?)
        Debug.println("---checking " + msg + "...")
      end
      # check name constraints only if there is a previous name constraint
      # and either the currCert is the final cert or the currCert is not
      # self-issued
      if (!(@prev_nc).nil? && (((@i).equal?(@cert_path_length)) || !X509CertImpl.is_self_issued(curr_cert)))
        if (!(Debug).nil?)
          Debug.println("prevNC = " + RJava.cast_to_string(@prev_nc))
          Debug.println("currDN = " + RJava.cast_to_string(curr_cert.get_subject_x500principal))
        end
        begin
          if (!@prev_nc.verify(curr_cert))
            raise CertPathValidatorException.new(msg + " check failed")
          end
        rescue IOException => ioe
          raise CertPathValidatorException.new(ioe)
        end
      end
      # merge name constraints regardless of whether cert is self-issued
      @prev_nc = merge_name_constraints(curr_cert, @prev_nc)
      if (!(Debug).nil?)
        Debug.println(msg + " verified.")
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate, NameConstraintsExtension] }
      # Helper to fold sets of name constraints together
      def merge_name_constraints(curr_cert, prev_nc)
        curr_cert_impl = nil
        begin
          curr_cert_impl = X509CertImpl.to_impl(curr_cert)
        rescue CertificateException => ce
          raise CertPathValidatorException.new(ce)
        end
        new_constraints = curr_cert_impl.get_name_constraints_extension
        if (!(Debug).nil?)
          Debug.println("prevNC = " + RJava.cast_to_string(prev_nc))
          Debug.println("newNC = " + RJava.cast_to_string(String.value_of(new_constraints)))
        end
        # if there are no previous name constraints, we just return the
        # new name constraints.
        if ((prev_nc).nil?)
          if (!(Debug).nil?)
            Debug.println("mergedNC = " + RJava.cast_to_string(String.value_of(new_constraints)))
          end
          if ((new_constraints).nil?)
            return new_constraints
          else
            # Make sure we do a clone here, because we're probably
            # going to modify this object later and we don't want to
            # be sharing it with a Certificate object!
            return new_constraints.clone
          end
        else
          begin
            # after merge, prevNC should contain the merged constraints
            prev_nc.merge(new_constraints)
          rescue IOException => ioe
            raise CertPathValidatorException.new(ioe)
          end
          if (!(Debug).nil?)
            Debug.println("mergedNC = " + RJava.cast_to_string(prev_nc))
          end
          return prev_nc
        end
      end
    }
    
    typesig { [X509Certificate] }
    # Internal method to check that a given cert meets basic constraints.
    def check_basic_constraints(curr_cert)
      msg = "basic constraints"
      if (!(Debug).nil?)
        Debug.println("---checking " + msg + "...")
        Debug.println("i = " + RJava.cast_to_string(@i))
        Debug.println("maxPathLength = " + RJava.cast_to_string(@max_path_length))
      end
      # check if intermediate cert
      if (@i < @cert_path_length)
        path_len_constraint = curr_cert.get_basic_constraints
        if ((path_len_constraint).equal?(-1))
          raise CertPathValidatorException.new(msg + " check failed: " + "this is not a CA certificate")
        end
        if (!X509CertImpl.is_self_issued(curr_cert))
          if (@max_path_length <= 0)
            raise CertPathValidatorException.new(msg + " check failed: pathLenConstraint violated - " + "this cert must be the last cert in the " + "certification path")
          end
          @max_path_length -= 1
        end
        if (path_len_constraint < @max_path_length)
          @max_path_length = path_len_constraint
        end
      end
      if (!(Debug).nil?)
        Debug.println("after processing, maxPathLength = " + RJava.cast_to_string(@max_path_length))
        Debug.println(msg + " verified.")
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate, ::Java::Int] }
      # Merges the specified maxPathLength with the pathLenConstraint
      # obtained from the certificate.
      # 
      # @param cert the <code>X509Certificate</code>
      # @param maxPathLength the previous maximum path length
      # @return the new maximum path length constraint (-1 means no more
      # certificates can follow, Integer.MAX_VALUE means path length is
      # unconstrained)
      def merge_basic_constraints(cert, max_path_length)
        path_len_constraint = cert.get_basic_constraints
        if (!X509CertImpl.is_self_issued(cert))
          max_path_length -= 1
        end
        if (path_len_constraint < max_path_length)
          max_path_length = path_len_constraint
        end
        return max_path_length
      end
    }
    
    private
    alias_method :initialize__constraints_checker, :initialize
  end
  
end

require "rjava"

# 
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
  module ForwardStateImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertPathValidatorException
      include_const ::Java::Security::Cert, :PKIXCertPathChecker
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :SubjectAlternativeNameExtension
      include_const ::Sun::Security::X509, :GeneralNames
      include_const ::Sun::Security::X509, :GeneralName
      include_const ::Sun::Security::X509, :GeneralNameInterface
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # 
  # A specification of a forward PKIX validation state
  # which is initialized by each build and updated each time a
  # certificate is added to the current path.
  # @since       1.4
  # @author      Yassir Elley
  class ForwardState 
    include_class_members ForwardStateImports
    include State
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    # The issuer DN of the last cert in the path
    attr_accessor :issuer_dn
    alias_method :attr_issuer_dn, :issuer_dn
    undef_method :issuer_dn
    alias_method :attr_issuer_dn=, :issuer_dn=
    undef_method :issuer_dn=
    
    # The last cert in the path
    attr_accessor :cert
    alias_method :attr_cert, :cert
    undef_method :cert
    alias_method :attr_cert=, :cert=
    undef_method :cert=
    
    # The set of subjectDNs and subjectAltNames of all certs in the path
    attr_accessor :subject_names_traversed
    alias_method :attr_subject_names_traversed, :subject_names_traversed
    undef_method :subject_names_traversed
    alias_method :attr_subject_names_traversed=, :subject_names_traversed=
    undef_method :subject_names_traversed=
    
    # 
    # The number of intermediate CA certs which have been traversed so
    # far in the path
    attr_accessor :traversed_cacerts
    alias_method :attr_traversed_cacerts, :traversed_cacerts
    undef_method :traversed_cacerts
    alias_method :attr_traversed_cacerts=, :traversed_cacerts=
    undef_method :traversed_cacerts=
    
    # Flag indicating if state is initial (path is just starting)
    attr_accessor :init
    alias_method :attr_init, :init
    undef_method :init
    alias_method :attr_init=, :init=
    undef_method :init=
    
    # the checker used for revocation status
    attr_accessor :crl_checker
    alias_method :attr_crl_checker, :crl_checker
    undef_method :crl_checker
    alias_method :attr_crl_checker=, :crl_checker=
    undef_method :crl_checker=
    
    # The list of user-defined checkers that support forward checking
    attr_accessor :forward_checkers
    alias_method :attr_forward_checkers, :forward_checkers
    undef_method :forward_checkers
    alias_method :attr_forward_checkers=, :forward_checkers=
    undef_method :forward_checkers=
    
    # Flag indicating if key needing to inherit key parameters has been
    # encountered.
    attr_accessor :key_params_needed_flag
    alias_method :attr_key_params_needed_flag, :key_params_needed_flag
    undef_method :key_params_needed_flag
    alias_method :attr_key_params_needed_flag=, :key_params_needed_flag=
    undef_method :key_params_needed_flag=
    
    typesig { [] }
    # 
    # Returns a boolean flag indicating if the state is initial
    # (just starting)
    # 
    # @return boolean flag indicating if the state is initial (just starting)
    def is_initial
      return @init
    end
    
    typesig { [] }
    # 
    # Return boolean flag indicating whether a public key that needs to inherit
    # key parameters has been encountered.
    # 
    # @return boolean true if key needing to inherit parameters has been
    # encountered; false otherwise.
    def key_params_needed
      return @key_params_needed_flag
    end
    
    typesig { [] }
    # 
    # Display state for debugging purposes
    def to_s
      sb = StringBuffer.new
      begin
        sb.append("State [")
        sb.append("\n  issuerDN of last cert: " + (@issuer_dn).to_s)
        sb.append("\n  traversedCACerts: " + (@traversed_cacerts).to_s)
        sb.append("\n  init: " + (String.value_of(@init)).to_s)
        sb.append("\n  keyParamsNeeded: " + (String.value_of(@key_params_needed_flag)).to_s)
        sb.append("\n  subjectNamesTraversed: \n" + (@subject_names_traversed).to_s)
        sb.append("]\n")
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println("ForwardState.toString() unexpected exception")
          e.print_stack_trace
        end
      end
      return sb.to_s
    end
    
    typesig { [JavaList] }
    # 
    # Initialize the state.
    # 
    # @param certPathCheckers the list of user-defined PKIXCertPathCheckers
    def init_state(cert_path_checkers)
      @subject_names_traversed = HashSet.new
      @traversed_cacerts = 0
      # 
      # Populate forwardCheckers with every user-defined checker
      # that supports forward checking and initialize the forwardCheckers
      @forward_checkers = ArrayList.new
      if (!(cert_path_checkers).nil?)
        cert_path_checkers.each do |checker|
          if (checker.is_forward_checking_supported)
            checker.init(true)
            @forward_checkers.add(checker)
          end
        end
      end
      @init = true
    end
    
    typesig { [X509Certificate] }
    # 
    # Update the state with the next certificate added to the path.
    # 
    # @param cert the certificate which is used to update the state
    def update_state(cert)
      if ((cert).nil?)
        return
      end
      icert = X509CertImpl.to_impl(cert)
      # see if certificate key has null parameters
      new_key = icert.get_public_key
      if (new_key.is_a?(DSAPublicKey) && ((new_key).get_params).nil?)
        @key_params_needed_flag = true
      end
      # update certificate
      @cert = icert
      # update issuer DN
      @issuer_dn = cert.get_issuer_x500principal
      if (!X509CertImpl.is_self_issued(cert))
        # 
        # update traversedCACerts only if this is a non-self-issued
        # intermediate CA cert
        if (!@init && !(cert.get_basic_constraints).equal?(-1))
          ((@traversed_cacerts += 1) - 1)
        end
      end
      # update subjectNamesTraversed only if this is the EE cert or if
      # this cert is not self-issued
      if (@init || !X509CertImpl.is_self_issued(cert))
        subj_name = cert.get_subject_x500principal
        @subject_names_traversed.add(X500Name.as_x500name(subj_name))
        begin
          subj_alt_name_ext = icert.get_subject_alternative_name_extension
          if (!(subj_alt_name_ext).nil?)
            g_names = subj_alt_name_ext.get(SubjectAlternativeNameExtension::SUBJECT_NAME)
            t = g_names.iterator
            while t.has_next
              g_name = t.next.get_name
              @subject_names_traversed.add(g_name)
            end
          end
        rescue Exception => e
          if (!(Debug).nil?)
            Debug.println("ForwardState.updateState() unexpected " + "exception")
            e.print_stack_trace
          end
          raise CertPathValidatorException.new(e)
        end
      end
      @init = false
    end
    
    typesig { [] }
    # 
    # Clone current state. The state is cloned as each cert is
    # added to the path. This is necessary if backtracking occurs,
    # and a prior state needs to be restored.
    # 
    # Note that this is a SMART clone. Not all fields are fully copied,
    # because some of them will
    # not have their contents modified by subsequent calls to updateState.
    def clone
      begin
        cloned_state = super
        # clone checkers, if cloneable
        cloned_state.attr_forward_checkers = @forward_checkers.clone
        li = cloned_state.attr_forward_checkers.list_iterator
        while (li.has_next)
          checker = li.next
          if (checker.is_a?(Cloneable))
            li.set(checker.clone)
          end
        end
        # 
        # Shallow copy traversed names. There is no need to
        # deep copy contents, since the elements of the Set
        # are never modified by subsequent calls to updateState().
        cloned_state.attr_subject_names_traversed = @subject_names_traversed.clone
        return cloned_state
      rescue CloneNotSupportedException => e
        raise InternalError.new(e.to_s)
      end
    end
    
    typesig { [] }
    def initialize
      @issuer_dn = nil
      @cert = nil
      @subject_names_traversed = nil
      @traversed_cacerts = 0
      @init = true
      @crl_checker = nil
      @forward_checkers = nil
      @key_params_needed_flag = false
    end
    
    private
    alias_method :initialize__forward_state, :initialize
  end
  
end

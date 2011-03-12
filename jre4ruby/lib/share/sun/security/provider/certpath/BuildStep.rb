require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BuildStepImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Sun::Security::Util, :Debug
      include_const ::Java::Security::Cert, :X509Certificate
    }
  end
  
  # Describes one step of a certification path build, consisting of a
  # <code>Vertex</code> state description, a certificate, a possible throwable,
  # and a result code.
  # 
  # @author      Anne Anderson
  # @since       1.4
  # @see sun.security.provider.certpath.Vertex
  class BuildStep 
    include_class_members BuildStepImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :vertex
    alias_method :attr_vertex, :vertex
    undef_method :vertex
    alias_method :attr_vertex=, :vertex=
    undef_method :vertex=
    
    attr_accessor :cert
    alias_method :attr_cert, :cert
    undef_method :cert
    alias_method :attr_cert=, :cert=
    undef_method :cert=
    
    attr_accessor :throwable
    alias_method :attr_throwable, :throwable
    undef_method :throwable
    alias_method :attr_throwable=, :throwable=
    undef_method :throwable=
    
    attr_accessor :result
    alias_method :attr_result, :result
    undef_method :result
    alias_method :attr_result=, :result=
    undef_method :result=
    
    class_module.module_eval {
      # result code associated with a certificate that may continue a path from
      # the current certificate.
      const_set_lazy(:POSSIBLE) { 1 }
      const_attr_reader  :POSSIBLE
      
      # result code associated with a certificate that was tried, but that
      # represents an unsuccessful path, so the certificate has been backed out
      # to allow backtracking to the next possible path.
      const_set_lazy(:BACK) { 2 }
      const_attr_reader  :BACK
      
      # result code associated with a certificate that successfully continues the
      # current path, but does not yet reach the target.
      const_set_lazy(:FOLLOW) { 3 }
      const_attr_reader  :FOLLOW
      
      # result code associated with a certificate that represents the end of the
      # last possible path, where no path successfully reached the target.
      const_set_lazy(:FAIL) { 4 }
      const_attr_reader  :FAIL
      
      # result code associated with a certificate that represents the end of a
      # path that successfully reaches the target.
      const_set_lazy(:SUCCEED) { 5 }
      const_attr_reader  :SUCCEED
    }
    
    typesig { [Vertex, ::Java::Int] }
    # construct a BuildStep
    # 
    # @param vtx description of the vertex at this step
    # @param res result, where result is one of POSSIBLE, BACK,
    #            FOLLOW, FAIL, SUCCEED
    def initialize(vtx, res)
      @vertex = nil
      @cert = nil
      @throwable = nil
      @result = 0
      @vertex = vtx
      if (!(@vertex).nil?)
        @cert = @vertex.get_certificate
        @throwable = @vertex.get_throwable
      end
      @result = res
    end
    
    typesig { [] }
    # return vertex description for this build step
    # 
    # @returns Vertex
    def get_vertex
      return @vertex
    end
    
    typesig { [] }
    # return the certificate associated with this build step
    # 
    # @returns X509Certificate
    def get_certificate
      return @cert
    end
    
    typesig { [] }
    # return string form of issuer name from certificate associated with this
    # build step
    # 
    # @returns String form of issuer name or null, if no certificate.
    def get_issuer_name
      return ((@cert).nil? ? nil : @cert.get_issuer_x500principal.to_s)
    end
    
    typesig { [String] }
    # return string form of issuer name from certificate associated with this
    # build step, or a default name if no certificate associated with this
    # build step, or if issuer name could not be obtained from the certificate.
    # 
    # @param defaultName name to use as default if unable to return an issuer
    # name from the certificate, or if no certificate.
    # @returns String form of issuer name or defaultName, if no certificate or
    # exception received while trying to extract issuer name from certificate.
    def get_issuer_name(default_name)
      return ((@cert).nil? ? default_name : @cert.get_issuer_x500principal.to_s)
    end
    
    typesig { [] }
    # return string form of subject name from certificate associated with this
    # build step.
    # 
    # @returns String form of subject name or null, if no certificate.
    def get_subject_name
      return ((@cert).nil? ? nil : @cert.get_subject_x500principal.to_s)
    end
    
    typesig { [String] }
    # return string form of subject name from certificate associated with this
    # build step, or a default name if no certificate associated with this
    # build step, or if subject name could not be obtained from the
    # certificate.
    # 
    # @param defaultName name to use as default if unable to return a subject
    # name from the certificate, or if no certificate.
    # @returns String form of subject name or defaultName, if no certificate or
    # if an exception was received while attempting to extract the subject name
    # from the certificate.
    def get_subject_name(default_name)
      return ((@cert).nil? ? default_name : @cert.get_subject_x500principal.to_s)
    end
    
    typesig { [] }
    # return the exception associated with this build step.
    # 
    # @returns Throwable
    def get_throwable
      return @throwable
    end
    
    typesig { [] }
    # return the result code associated with this build step.  The result codes
    # are POSSIBLE, FOLLOW, BACK, FAIL, SUCCEED.
    # 
    # @returns int result code
    def get_result
      return @result
    end
    
    typesig { [::Java::Int] }
    # return a string representing the meaning of the result code associated
    # with this build step.
    # 
    # @param   res    result code
    # @returns String string representing meaning of the result code
    def result_to_string(res)
      result_string = ""
      case (res)
      when BuildStep::POSSIBLE
        result_string = "Certificate to be tried.\n"
      when BuildStep::BACK
        result_string = "Certificate backed out since path does not " + "satisfy build requirements.\n"
      when BuildStep::FOLLOW
        result_string = "Certificate satisfies conditions.\n"
      when BuildStep::FAIL
        result_string = "Certificate backed out since path does not " + "satisfy conditions.\n"
      when BuildStep::SUCCEED
        result_string = "Certificate satisfies conditions.\n"
      else
        result_string = "Internal error: Invalid step result value.\n"
      end
      return result_string
    end
    
    typesig { [] }
    # return a string representation of this build step, showing minimal
    # detail.
    # 
    # @returns String
    def to_s
      out = "Internal Error\n"
      case (@result)
      when BACK, FAIL
        out = RJava.cast_to_string(result_to_string(@result))
        out = out + RJava.cast_to_string(@vertex.throwable_to_string)
      when FOLLOW, SUCCEED, POSSIBLE
        out = RJava.cast_to_string(result_to_string(@result))
      else
        out = "Internal Error: Invalid step result\n"
      end
      return out
    end
    
    typesig { [] }
    # return a string representation of this build step, showing all detail of
    # the vertex state appropriate to the result of this build step, and the
    # certificate contents.
    # 
    # @returns String
    def verbose_to_string
      out = result_to_string(get_result)
      case (@result)
      when BACK, FAIL
        out = out + RJava.cast_to_string(@vertex.throwable_to_string)
      when FOLLOW, SUCCEED
        out = out + RJava.cast_to_string(@vertex.more_to_string)
      when POSSIBLE
      else
      end
      out = out + "Certificate contains:\n" + RJava.cast_to_string(@vertex.cert_to_string)
      return out
    end
    
    typesig { [] }
    # return a string representation of this build step, including all possible
    # detail of the vertex state, but not including the certificate contents.
    # 
    # @returns String
    def full_to_string
      out = result_to_string(get_result)
      out = out + RJava.cast_to_string(@vertex.to_s)
      return out
    end
    
    private
    alias_method :initialize__build_step, :initialize
  end
  
end

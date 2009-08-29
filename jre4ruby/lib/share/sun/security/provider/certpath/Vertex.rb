require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module VertexImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Sun::Security::Util, :Debug
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Sun::Security::X509, :AuthorityKeyIdentifierExtension
      include_const ::Sun::Security::X509, :KeyIdentifier
      include_const ::Sun::Security::X509, :SubjectKeyIdentifierExtension
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # This class represents a vertex in the adjacency list. A
  # vertex in the builder's view is just a distinguished name
  # in the directory.  The Vertex contains a certificate
  # along an attempted certification path, along with a pointer
  # to a list of certificates that followed this one in various
  # attempted certification paths.
  # 
  # @author      Sean Mullan
  # @since       1.4
  class Vertex 
    include_class_members VertexImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :cert
    alias_method :attr_cert, :cert
    undef_method :cert
    alias_method :attr_cert=, :cert=
    undef_method :cert=
    
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    attr_accessor :throwable
    alias_method :attr_throwable, :throwable
    undef_method :throwable
    alias_method :attr_throwable=, :throwable=
    undef_method :throwable=
    
    typesig { [Certificate] }
    # Constructor; creates vertex with index of -1
    # Use setIndex method to set another index.
    # 
    # @param cert Certificate associated with vertex
    def initialize(cert)
      @cert = nil
      @index = 0
      @throwable = nil
      @cert = cert
      @index = -1
    end
    
    typesig { [] }
    # return the certificate for this vertex
    # 
    # @returns Certificate
    def get_certificate
      return @cert
    end
    
    typesig { [] }
    # get the index for this vertex, where the index is the row of the
    # adjacency list that contains certificates that could follow this
    # certificate.
    # 
    # @returns int index for this vertex, or -1 if no following certificates.
    def get_index
      return @index
    end
    
    typesig { [::Java::Int] }
    # set the index for this vertex, where the index is the row of the
    # adjacency list that contains certificates that could follow this
    # certificate.
    # 
    # @param ndx int index for vertex, or -1 if no following certificates.
    def set_index(ndx)
      @index = ndx
    end
    
    typesig { [] }
    # return the throwable associated with this vertex;
    # returns null if none.
    # 
    # @returns Throwable
    def get_throwable
      return @throwable
    end
    
    typesig { [JavaThrowable] }
    # set throwable associated with this vertex; default value is null.
    # 
    # @param throwable Throwable associated with this vertex
    # (or null)
    def set_throwable(throwable)
      @throwable = throwable
    end
    
    typesig { [] }
    # Return full string representation of vertex
    # 
    # @returns String representation of vertex
    def to_s
      return cert_to_string + throwable_to_string + index_to_string
    end
    
    typesig { [] }
    # Return string representation of this vertex's
    # certificate information.
    # 
    # @returns String representation of certificate info
    def cert_to_string
      out = ""
      if ((@cert).nil? || !(@cert.is_a?(X509Certificate)))
        return "Cert:       Not an X509Certificate\n"
      end
      x509cert = nil
      begin
        x509cert = X509CertImpl.to_impl(@cert)
      rescue CertificateException => ce
        if (!(Debug).nil?)
          Debug.println("Vertex.certToString() unexpected exception")
          ce.print_stack_trace
        end
        return out
      end
      out = "Issuer:     " + RJava.cast_to_string(x509cert.get_issuer_x500principal) + "\n"
      out = out + "Subject:    " + RJava.cast_to_string(x509cert.get_subject_x500principal) + "\n"
      out = out + "SerialNum:  " + RJava.cast_to_string((x509cert.get_serial_number).to_s(16)) + "\n"
      out = out + "Expires:    " + RJava.cast_to_string(x509cert.get_not_after.to_s) + "\n"
      i_uid = x509cert.get_issuer_unique_id
      if (!(i_uid).nil?)
        out = out + "IssuerUID:  "
        i = 0
        while i < i_uid.attr_length
          out = out + RJava.cast_to_string((i_uid[i] ? 1 : 0))
          i += 1
        end
        out = out + "\n"
      end
      s_uid = x509cert.get_subject_unique_id
      if (!(s_uid).nil?)
        out = out + "SubjectUID: "
        i = 0
        while i < s_uid.attr_length
          out = out + RJava.cast_to_string((s_uid[i] ? 1 : 0))
          i += 1
        end
        out = out + "\n"
      end
      s_key_id = nil
      begin
        s_key_id = x509cert.get_subject_key_identifier_extension
        if (!(s_key_id).nil?)
          key_id = s_key_id.get(s_key_id.attr_key_id)
          out = out + "SubjKeyID:  " + RJava.cast_to_string(key_id.to_s)
        end
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("Vertex.certToString() unexpected exception")
          e.print_stack_trace
        end
      end
      a_key_id = nil
      begin
        a_key_id = x509cert.get_authority_key_identifier_extension
        if (!(a_key_id).nil?)
          key_id = a_key_id.get(a_key_id.attr_key_id)
          out = out + "AuthKeyID:  " + RJava.cast_to_string(key_id.to_s)
        end
      rescue JavaException => e
        if (!(Debug).nil?)
          Debug.println("Vertex.certToString() 2 unexpected exception")
          e.print_stack_trace
        end
      end
      return out
    end
    
    typesig { [] }
    # return Vertex throwable as String compatible with
    # the way toString returns other information
    # 
    # @returns String form of exception (or "none")
    def throwable_to_string
      out = "Exception:  "
      if (!(@throwable).nil?)
        out = out + RJava.cast_to_string(@throwable.to_s)
      else
        out = out + "null"
      end
      out = out + "\n"
      return out
    end
    
    typesig { [] }
    # return Vertex index as String compatible with
    # the way other Vertex.xToString() methods display
    # information.
    # 
    # @returns String form of index as "Last cert?  [Yes/No]
    def more_to_string
      out = "Last cert?  "
      out = out + RJava.cast_to_string((((@index).equal?(-1)) ? "Yes" : "No"))
      out = out + "\n"
      return out
    end
    
    typesig { [] }
    # return Vertex index as String compatible with
    # the way other Vertex.xToString() methods displays other information.
    # 
    # @returns String form of index as "Index:     [numeric index]"
    def index_to_string
      out = "Index:      " + RJava.cast_to_string(@index) + "\n"
      return out
    end
    
    private
    alias_method :initialize__vertex, :initialize
  end
  
end

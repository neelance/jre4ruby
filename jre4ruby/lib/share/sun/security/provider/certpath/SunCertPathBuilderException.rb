require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SunCertPathBuilderExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :JavaList
      include_const ::Java::Security::Cert, :CertPathBuilderException
    }
  end
  
  # This is a subclass of the generic <code>CertPathBuilderException</code>.
  # It contains an adjacency list with information regarding the unsuccessful
  # paths that the SunCertPathBuilder tried.
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @see         CertPathBuilderException
  class SunCertPathBuilderException < SunCertPathBuilderExceptionImports.const_get :CertPathBuilderException
    include_class_members SunCertPathBuilderExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7814288414129264709 }
      const_attr_reader  :SerialVersionUID
    }
    
    # @serial
    attr_accessor :adj_list
    alias_method :attr_adj_list, :adj_list
    undef_method :adj_list
    alias_method :attr_adj_list=, :adj_list=
    undef_method :adj_list=
    
    typesig { [] }
    # Constructs a <code>SunCertPathBuilderException</code> with
    # <code>null</code> as its detail message.
    def initialize
      @adj_list = nil
      super()
    end
    
    typesig { [String] }
    # Constructs a <code>SunCertPathBuilderException</code> with the specified
    # detail message. A detail message is a <code>String</code> that
    # describes this particular exception.
    # 
    # @param msg the detail message
    def initialize(msg)
      @adj_list = nil
      super(msg)
    end
    
    typesig { [JavaThrowable] }
    # Constructs a <code>SunCertPathBuilderException</code> that wraps the
    # specified throwable. This allows any exception to be converted into a
    # <code>SunCertPathBuilderException</code>, while retaining information
    # about the cause, which may be useful for debugging. The detail message is
    # set to (<code>cause==null ? null : cause.toString()</code>) (which
    # typically contains the class and detail message of cause).
    # 
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause getCause()} method). (A <code>null</code> value is
    # permitted, and indicates that the cause is nonexistent or unknown.)
    # root cause.
    def initialize(cause)
      @adj_list = nil
      super(cause)
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a <code>SunCertPathBuilderException</code> with the specified
    # detail message and cause.
    # 
    # @param msg the detail message
    # @param cause the cause
    def initialize(msg, cause)
      @adj_list = nil
      super(msg, cause)
    end
    
    typesig { [String, AdjacencyList] }
    # Creates a <code>SunCertPathBuilderException</code> withe the specified
    # detail message and adjacency list.
    # 
    # @param msg the detail message
    # @param adjList the adjacency list
    def initialize(msg, adj_list)
      initialize__sun_cert_path_builder_exception(msg)
      @adj_list = adj_list
    end
    
    typesig { [String, JavaThrowable, AdjacencyList] }
    # Creates a <code>SunCertPathBuilderException</code> with the specified
    # detail message, cause, and adjacency list.
    # 
    # @param msg the detail message
    # @param cause the throwable that occurred
    # @param adjList Adjacency list
    def initialize(msg, cause, adj_list)
      initialize__sun_cert_path_builder_exception(msg, cause)
      @adj_list = adj_list
    end
    
    typesig { [] }
    # Returns the adjacency list containing information about the build.
    # 
    # @return the adjacency list containing information about the build
    def get_adjacency_list
      return @adj_list
    end
    
    private
    alias_method :initialize__sun_cert_path_builder_exception, :initialize
  end
  
end

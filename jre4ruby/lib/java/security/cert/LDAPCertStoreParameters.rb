require "rjava"

# 
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
  module LDAPCertStoreParametersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
    }
  end
  
  # 
  # Parameters used as input for the LDAP <code>CertStore</code> algorithm.
  # <p>
  # This class is used to provide necessary configuration parameters (server
  # name and port number) to implementations of the LDAP <code>CertStore</code>
  # algorithm.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @since       1.4
  # @author      Steve Hanna
  # @see         CertStore
  class LDAPCertStoreParameters 
    include_class_members LDAPCertStoreParametersImports
    include CertStoreParameters
    
    class_module.module_eval {
      const_set_lazy(:LDAP_DEFAULT_PORT) { 389 }
      const_attr_reader  :LDAP_DEFAULT_PORT
    }
    
    # 
    # the port number of the LDAP server
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    # 
    # the DNS name of the LDAP server
    attr_accessor :server_name
    alias_method :attr_server_name, :server_name
    undef_method :server_name
    alias_method :attr_server_name=, :server_name=
    undef_method :server_name=
    
    typesig { [String, ::Java::Int] }
    # 
    # Creates an instance of <code>LDAPCertStoreParameters</code> with the
    # specified parameter values.
    # 
    # @param serverName the DNS name of the LDAP server
    # @param port the port number of the LDAP server
    # @exception NullPointerException if <code>serverName</code> is
    # <code>null</code>
    def initialize(server_name, port)
      @port = 0
      @server_name = nil
      if ((server_name).nil?)
        raise NullPointerException.new
      end
      @server_name = server_name
      @port = port
    end
    
    typesig { [String] }
    # 
    # Creates an instance of <code>LDAPCertStoreParameters</code> with the
    # specified server name and a default port of 389.
    # 
    # @param serverName the DNS name of the LDAP server
    # @exception NullPointerException if <code>serverName</code> is
    # <code>null</code>
    def initialize(server_name)
      initialize__ldapcert_store_parameters(server_name, LDAP_DEFAULT_PORT)
    end
    
    typesig { [] }
    # 
    # Creates an instance of <code>LDAPCertStoreParameters</code> with the
    # default parameter values (server name "localhost", port 389).
    def initialize
      initialize__ldapcert_store_parameters("localhost", LDAP_DEFAULT_PORT)
    end
    
    typesig { [] }
    # 
    # Returns the DNS name of the LDAP server.
    # 
    # @return the name (not <code>null</code>)
    def get_server_name
      return @server_name
    end
    
    typesig { [] }
    # 
    # Returns the port number of the LDAP server.
    # 
    # @return the port number
    def get_port
      return @port
    end
    
    typesig { [] }
    # 
    # Returns a copy of this object. Changes to the copy will not affect
    # the original and vice versa.
    # <p>
    # Note: this method currently performs a shallow copy of the object
    # (simply calls <code>Object.clone()</code>). This may be changed in a
    # future revision to perform a deep copy if new parameters are added
    # that should not be shared.
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
    # 
    # Returns a formatted string describing the parameters.
    # 
    # @return a formatted string describing the parameters
    def to_s
      sb = StringBuffer.new
      sb.append("LDAPCertStoreParameters: [\n")
      sb.append("  serverName: " + @server_name + "\n")
      sb.append("  port: " + (@port).to_s + "\n")
      sb.append("]")
      return sb.to_s
    end
    
    private
    alias_method :initialize__ldapcert_store_parameters, :initialize
  end
  
end

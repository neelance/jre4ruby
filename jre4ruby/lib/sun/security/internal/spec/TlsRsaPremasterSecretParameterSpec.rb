require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Internal::Spec
  module TlsRsaPremasterSecretParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Internal::Spec
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
    }
  end
  
  # Parameters for SSL/TLS RSA Premaster secret generation.
  # This class is used by SSL/TLS client to initialize KeyGenerators of the
  # type "TlsRsaPremasterSecret".
  # 
  # <p>Instances of this class are immutable.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @deprecated Sun JDK internal use only --- WILL BE REMOVED in Dolphin (JDK 7)
  class TlsRsaPremasterSecretParameterSpec 
    include_class_members TlsRsaPremasterSecretParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :major_version
    alias_method :attr_major_version, :major_version
    undef_method :major_version
    alias_method :attr_major_version=, :major_version=
    undef_method :major_version=
    
    attr_accessor :minor_version
    alias_method :attr_minor_version, :minor_version
    undef_method :minor_version
    alias_method :attr_minor_version=, :minor_version=
    undef_method :minor_version=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Constructs a new TlsRsaPremasterSecretParameterSpec.
    # 
    # <p>The version numbers will be placed inside the premaster secret to
    # detect version rollbacks attacks as described in the TLS specification.
    # Note that they do not indicate the protocol version negotiated for
    # the handshake.
    # 
    # @param majorVersion the major number of the protocol version
    # @param minorVersion the minor number of the protocol version
    # 
    # @throws IllegalArgumentException if minorVersion or majorVersion are
    # negative or larger than 255
    def initialize(major_version, minor_version)
      @major_version = 0
      @minor_version = 0
      @major_version = TlsMasterSecretParameterSpec.check_version(major_version)
      @minor_version = TlsMasterSecretParameterSpec.check_version(minor_version)
    end
    
    typesig { [] }
    # Returns the major version.
    # 
    # @return the major version.
    def get_major_version
      return @major_version
    end
    
    typesig { [] }
    # Returns the minor version.
    # 
    # @return the minor version.
    def get_minor_version
      return @minor_version
    end
    
    private
    alias_method :initialize__tls_rsa_premaster_secret_parameter_spec, :initialize
  end
  
end

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
module Java::Security::Cert
  module CertPathBuilderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
      include_const ::Sun::Security::Util, :Debug
      include ::Sun::Security::Jca
      include_const ::Sun::Security::Jca::GetInstance, :Instance
    }
  end
  
  # 
  # A class for building certification paths (also known as certificate chains).
  # <p>
  # This class uses a provider-based architecture.
  # To create a <code>CertPathBuilder</code>, call
  # one of the static <code>getInstance</code> methods, passing in the
  # algorithm name of the <code>CertPathBuilder</code> desired and optionally
  # the name of the provider desired.
  # <p>
  # Once a <code>CertPathBuilder</code> object has been created, certification
  # paths can be constructed by calling the {@link #build build} method and
  # passing it an algorithm-specific set of parameters. If successful, the
  # result (including the <code>CertPath</code> that was built) is returned
  # in an object that implements the <code>CertPathBuilderResult</code>
  # interface.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # The static methods of this class are guaranteed to be thread-safe.
  # Multiple threads may concurrently invoke the static methods defined in
  # this class with no ill effects.
  # <p>
  # However, this is not true for the non-static methods defined by this class.
  # Unless otherwise documented by a specific provider, threads that need to
  # access a single <code>CertPathBuilder</code> instance concurrently should
  # synchronize amongst themselves and provide the necessary locking. Multiple
  # threads each manipulating a different <code>CertPathBuilder</code> instance
  # need not synchronize.
  # 
  # @see CertPath
  # 
  # @since       1.4
  # @author      Sean Mullan
  # @author      Yassir Elley
  class CertPathBuilder 
    include_class_members CertPathBuilderImports
    
    class_module.module_eval {
      # 
      # Constant to lookup in the Security properties file to determine
      # the default certpathbuilder type. In the Security properties file,
      # the default certpathbuilder type is given as:
      # <pre>
      # certpathbuilder.type=PKIX
      # </pre>
      const_set_lazy(:CPB_TYPE) { "certpathbuilder.type" }
      const_attr_reader  :CPB_TYPE
      
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :builder_spi
    alias_method :attr_builder_spi, :builder_spi
    undef_method :builder_spi
    alias_method :attr_builder_spi=, :builder_spi=
    undef_method :builder_spi=
    
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    typesig { [CertPathBuilderSpi, Provider, String] }
    # 
    # Creates a <code>CertPathBuilder</code> object of the given algorithm,
    # and encapsulates the given provider implementation (SPI object) in it.
    # 
    # @param builderSpi the provider implementation
    # @param provider the provider
    # @param algorithm the algorithm name
    def initialize(builder_spi, provider, algorithm)
      @builder_spi = nil
      @provider = nil
      @algorithm = nil
      @builder_spi = builder_spi
      @provider = provider
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Returns a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new CertPathBuilder object encapsulating the
      # CertPathBuilderSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the requested <code>CertPathBuilder</code>
      # algorithm.  See Appendix A in the <a href=
      # "../../../../technotes/guides/security/certpath/CertPathProgGuide.html#AppA">
      # Java Certification Path API Programmer's Guide </a>
      # for information about standard algorithm names.
      # 
      # @return a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # @throws NoSuchAlgorithmException if no Provider supports a
      # CertPathBuilderSpi implementation for the
      # specified algorithm.
      # 
      # @see java.security.Provider
      def get_instance(algorithm)
        instance = GetInstance.get_instance("CertPathBuilder", CertPathBuilderSpi.class, algorithm)
        return CertPathBuilder.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
      
      typesig { [String, String] }
      # 
      # Returns a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # <p> A new CertPathBuilder object encapsulating the
      # CertPathBuilderSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the requested <code>CertPathBuilder</code>
      # algorithm.  See Appendix A in the <a href=
      # "../../../../technotes/guides/security/certpath/CertPathProgGuide.html#AppA">
      # Java Certification Path API Programmer's Guide </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # @throws NoSuchAlgorithmException if a CertPathBuilderSpi
      # implementation for the specified algorithm is not
      # available from the specified provider.
      # 
      # @throws NoSuchProviderException if the specified provider is not
      # registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the <code>provider</code> is
      # null or empty.
      # 
      # @see java.security.Provider
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("CertPathBuilder", CertPathBuilderSpi.class, algorithm, provider)
        return CertPathBuilder.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
      
      typesig { [String, Provider] }
      # 
      # Returns a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # <p> A new CertPathBuilder object encapsulating the
      # CertPathBuilderSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the name of the requested <code>CertPathBuilder</code>
      # algorithm.  See Appendix A in the <a href=
      # "../../../../technotes/guides/security/certpath/CertPathProgGuide.html#AppA">
      # Java Certification Path API Programmer's Guide </a>
      # for information about standard algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return a <code>CertPathBuilder</code> object that implements the
      # specified algorithm.
      # 
      # @exception NoSuchAlgorithmException if a CertPathBuilderSpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the <code>provider</code> is
      # null.
      # 
      # @see java.security.Provider
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("CertPathBuilder", CertPathBuilderSpi.class, algorithm, provider)
        return CertPathBuilder.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
    }
    
    typesig { [] }
    # 
    # Returns the provider of this <code>CertPathBuilder</code>.
    # 
    # @return the provider of this <code>CertPathBuilder</code>
    def get_provider
      return @provider
    end
    
    typesig { [] }
    # 
    # Returns the name of the algorithm of this <code>CertPathBuilder</code>.
    # 
    # @return the name of the algorithm of this <code>CertPathBuilder</code>
    def get_algorithm
      return @algorithm
    end
    
    typesig { [CertPathParameters] }
    # 
    # Attempts to build a certification path using the specified algorithm
    # parameter set.
    # 
    # @param params the algorithm parameters
    # @return the result of the build algorithm
    # @throws CertPathBuilderException if the builder is unable to construct
    # a certification path that satisfies the specified parameters
    # @throws InvalidAlgorithmParameterException if the specified parameters
    # are inappropriate for this <code>CertPathBuilder</code>
    def build(params)
      return @builder_spi.engine_build(params)
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Returns the default <code>CertPathBuilder</code> type as specified in
      # the Java security properties file, or the string &quot;PKIX&quot;
      # if no such property exists. The Java security properties file is
      # located in the file named &lt;JAVA_HOME&gt;/lib/security/java.security.
      # &lt;JAVA_HOME&gt; refers to the value of the java.home system property,
      # and specifies the directory where the JRE is installed.
      # 
      # <p>The default <code>CertPathBuilder</code> type can be used by
      # applications that do not want to use a hard-coded type when calling one
      # of the <code>getInstance</code> methods, and want to provide a default
      # type in case a user does not specify its own.
      # 
      # <p>The default <code>CertPathBuilder</code> type can be changed by
      # setting the value of the "certpathbuilder.type" security property
      # (in the Java security properties file) to the desired type.
      # 
      # @return the default <code>CertPathBuilder</code> type as specified
      # in the Java security properties file, or the string &quot;PKIX&quot;
      # if no such property exists.
      def get_default_type
        cpbtype = nil
        cpbtype = (AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members CertPathBuilder
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Security.get_property(CPB_TYPE)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))).to_s
        if ((cpbtype).nil?)
          cpbtype = "PKIX"
        end
        return cpbtype
      end
    }
    
    private
    alias_method :initialize__cert_path_builder, :initialize
  end
  
end

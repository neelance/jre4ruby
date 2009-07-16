require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module PolicyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Lang, :RuntimePermission
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :PropertyPermission
      include ::Java::Lang::Reflect
      include_const ::Java::Util, :WeakHashMap
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Jca, :GetInstance
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # 
  # A Policy object is responsible for determining whether code executing
  # in the Java runtime environment has permission to perform a
  # security-sensitive operation.
  # 
  # <p> There is only one Policy object installed in the runtime at any
  # given time.  A Policy object can be installed by calling the
  # <code>setPolicy</code> method.  The installed Policy object can be
  # obtained by calling the <code>getPolicy</code> method.
  # 
  # <p> If no Policy object has been installed in the runtime, a call to
  # <code>getPolicy</code> installs an instance of the default Policy
  # implementation (a default subclass implementation of this abstract class).
  # The default Policy implementation can be changed by setting the value
  # of the "policy.provider" security property (in the Java security properties
  # file) to the fully qualified name of the desired Policy subclass
  # implementation.  The Java security properties file is located in the
  # file named &lt;JAVA_HOME&gt;/lib/security/java.security.
  # &lt;JAVA_HOME&gt; refers to the value of the java.home system property,
  # and specifies the directory where the JRE is installed.
  # 
  # <p> Application code can directly subclass Policy to provide a custom
  # implementation.  In addition, an instance of a Policy object can be
  # constructed by invoking one of the <code>getInstance</code> factory methods
  # with a standard type.  The default policy type is "JavaPolicy".
  # See Appendix A in the <a href="../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
  # Java Cryptography Architecture API Specification &amp; Reference </a>
  # for a list of standard Policy types.
  # 
  # <p> Once a Policy instance has been installed (either by default, or by
  # calling <code>setPolicy</code>),
  # the Java runtime invokes its <code>implies</code> when it needs to
  # determine whether executing code (encapsulated in a ProtectionDomain)
  # can perform SecurityManager-protected operations.  How a Policy object
  # retrieves its policy data is up to the Policy implementation itself.
  # The policy data may be stored, for example, in a flat ASCII file,
  # in a serialized binary file of the Policy class, or in a database.
  # 
  # <p> The <code>refresh</code> method causes the policy object to
  # refresh/reload its data.  This operation is implementation-dependent.
  # For example, if the policy object stores its data in configuration files,
  # calling <code>refresh</code> will cause it to re-read the configuration
  # policy files.  If a refresh operation is not supported, this method does
  # nothing.  Note that refreshed policy may not have an effect on classes
  # in a particular ProtectionDomain. This is dependent on the Policy
  # provider's implementation of the <code>implies</code>
  # method and its PermissionCollection caching strategy.
  # 
  # @author Roland Schemers
  # @author Gary Ellison
  # @see java.security.Provider
  # @see java.security.ProtectionDomain
  # @see java.security.Permission
  class Policy 
    include_class_members PolicyImports
    
    class_module.module_eval {
      # 
      # A read-only empty PermissionCollection instance.
      # @since 1.6
      const_set_lazy(:UNSUPPORTED_EMPTY_COLLECTION) { UnsupportedEmptyCollection.new }
      const_attr_reader  :UNSUPPORTED_EMPTY_COLLECTION
      
      # the system-wide policy.
      
      def policy
        defined?(@@policy) ? @@policy : @@policy= nil
      end
      alias_method :attr_policy, :policy
      
      def policy=(value)
        @@policy = value
      end
      alias_method :attr_policy=, :policy=
      
      # package private for AccessControlContext
      const_set_lazy(:Debug) { Debug.get_instance("policy") }
      const_attr_reader  :Debug
    }
    
    # Cache mapping  ProtectionDomain to PermissionCollection
    attr_accessor :pd_mapping
    alias_method :attr_pd_mapping, :pd_mapping
    undef_method :pd_mapping
    alias_method :attr_pd_mapping=, :pd_mapping=
    undef_method :pd_mapping=
    
    class_module.module_eval {
      typesig { [] }
      # package private for AccessControlContext
      def is_set
        return !(self.attr_policy).nil?
      end
      
      typesig { [String] }
      def check_permission(type)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SecurityPermission.new("createPolicy." + type))
        end
      end
      
      typesig { [] }
      # 
      # Returns the installed Policy object. This value should not be cached,
      # as it may be changed by a call to <code>setPolicy</code>.
      # This method first calls
      # <code>SecurityManager.checkPermission</code> with a
      # <code>SecurityPermission("getPolicy")</code> permission
      # to ensure it's ok to get the Policy object..
      # 
      # @return the installed Policy.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # getting the Policy object.
      # 
      # @see SecurityManager#checkPermission(Permission)
      # @see #setPolicy(java.security.Policy)
      def get_policy
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SecurityConstants::GET_POLICY_PERMISSION)
        end
        return get_policy_no_check
      end
      
      typesig { [] }
      # 
      # Returns the installed Policy object, skipping the security check.
      # Used by SecureClassLoader and getPolicy.
      # 
      # @return the installed Policy.
      def get_policy_no_check
        synchronized(self) do
          if ((self.attr_policy).nil?)
            policy_class = nil
            policy_class = (AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members Policy
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                return Security.get_property("policy.provider")
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))).to_s
            if ((policy_class).nil?)
              policy_class = "sun.security.provider.PolicyFile"
            end
            begin
              self.attr_policy = Class.for_name(policy_class).new_instance
            rescue Exception => e
              # 
              # The policy_class seems to be an extension
              # so we have to bootstrap loading it via a policy
              # provider that is on the bootclasspath
              # If it loads then shift gears to using the configured
              # provider.
              # 
              # install the bootstrap provider to avoid recursion
              self.attr_policy = Sun::Security::Provider::PolicyFile.new
              pc = policy_class
              p = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
                extend LocalClass
                include_class_members Policy
                include PrivilegedAction if PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  begin
                    cl = ClassLoader.get_system_class_loader
                    # we want the extension loader
                    extcl = nil
                    while (!(cl).nil?)
                      extcl = cl
                      cl = cl.get_parent
                    end
                    return (!(extcl).nil? ? Class.for_name(pc, true, extcl).new_instance : nil)
                  rescue Exception => e
                    if (!(Debug).nil?)
                      Debug.println("policy provider " + pc + " not available")
                      e.print_stack_trace
                    end
                    return nil
                  end
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              # 
              # if it loaded install it as the policy provider. Otherwise
              # continue to use the system default implementation
              if (!(p).nil?)
                self.attr_policy = p
              else
                if (!(Debug).nil?)
                  Debug.println("using sun.security.provider.PolicyFile")
                end
              end
            end
          end
          return self.attr_policy
        end
      end
      
      typesig { [Policy] }
      # 
      # Sets the system-wide Policy object. This method first calls
      # <code>SecurityManager.checkPermission</code> with a
      # <code>SecurityPermission("setPolicy")</code>
      # permission to ensure it's ok to set the Policy.
      # 
      # @param p the new system Policy object.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow
      # setting the Policy.
      # 
      # @see SecurityManager#checkPermission(Permission)
      # @see #getPolicy()
      def set_policy(p)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SecurityPermission.new("setPolicy"))
        end
        if (!(p).nil?)
          init_policy(p)
        end
        synchronized((Policy.class)) do
          self.attr_policy.attr_policy = p
        end
      end
      
      typesig { [Policy] }
      # 
      # Initialize superclass state such that a legacy provider can
      # handle queries for itself.
      # 
      # @since 1.4
      def init_policy(p)
        policy_domain = AccessController.do_privileged(# 
        # A policy provider not on the bootclasspath could trigger
        # security checks fulfilling a call to either Policy.implies
        # or Policy.getPermissions. If this does occur the provider
        # must be able to answer for it's own ProtectionDomain
        # without triggering additional security checks, otherwise
        # the policy implementation will end up in an infinite
        # recursion.
        # 
        # To mitigate this, the provider can collect it's own
        # ProtectionDomain and associate a PermissionCollection while
        # it is being installed. The currently installed policy
        # provider (if there is one) will handle calls to
        # Policy.implies or Policy.getPermissions during this
        # process.
        # 
        # This Policy superclass caches away the ProtectionDomain and
        # statically binds permissions so that legacy Policy
        # implementations will continue to function.
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Policy
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return p.get_class.get_protection_domain
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # 
        # Collect the permissions granted to this protection domain
        # so that the provider can be security checked while processing
        # calls to Policy.implies or Policy.getPermissions.
        policy_perms = nil
        synchronized((p)) do
          if ((p.attr_pd_mapping).nil?)
            p.attr_pd_mapping = WeakHashMap.new
          end
        end
        if (!(policy_domain.get_code_source).nil?)
          if (Policy.is_set)
            policy_perms = self.attr_policy.get_permissions(policy_domain)
          end
          if ((policy_perms).nil?)
            # assume it has all
            policy_perms = Permissions.new
            policy_perms.add(SecurityConstants::ALL_PERMISSION)
          end
          synchronized((p.attr_pd_mapping)) do
            # cache of pd to permissions
            p.attr_pd_mapping.put(policy_domain, policy_perms)
          end
        end
        return
      end
      
      typesig { [String, Policy::Parameters] }
      # 
      # Returns a Policy object of the specified type.
      # 
      # <p> This method traverses the list of registered security providers,
      # starting with the most preferred Provider.
      # A new Policy object encapsulating the
      # PolicySpi implementation from the first
      # Provider that supports the specified type is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param type the specified Policy type.  See Appendix A in the
      # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for a list of standard Policy types.
      # 
      # @param params parameters for the Policy, which may be null.
      # 
      # @return the new Policy object.
      # 
      # @exception SecurityException if the caller does not have permission
      # to get a Policy instance for the specified type.
      # 
      # @exception NullPointerException if the specified type is null.
      # 
      # @exception IllegalArgumentException if the specified parameters
      # are not understood by the PolicySpi implementation
      # from the selected Provider.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a PolicySpi
      # implementation for the specified type.
      # 
      # @see Provider
      # @since 1.6
      def get_instance(type, params)
        check_permission(type)
        begin
          instance = GetInstance.get_instance("Policy", PolicySpi.class, type, params)
          return PolicyDelegate.new(instance.attr_impl, instance.attr_provider, type, params)
        rescue NoSuchAlgorithmException => nsae
          return handle_exception(nsae)
        end
      end
      
      typesig { [String, Policy::Parameters, String] }
      # 
      # Returns a Policy object of the specified type.
      # 
      # <p> A new Policy object encapsulating the
      # PolicySpi implementation from the specified provider
      # is returned.   The specified provider must be registered
      # in the provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param type the specified Policy type.  See Appendix A in the
      # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for a list of standard Policy types.
      # 
      # @param params parameters for the Policy, which may be null.
      # 
      # @param provider the provider.
      # 
      # @return the new Policy object.
      # 
      # @exception SecurityException if the caller does not have permission
      # to get a Policy instance for the specified type.
      # 
      # @exception NullPointerException if the specified type is null.
      # 
      # @exception IllegalArgumentException if the specified provider
      # is null or empty,
      # or if the specified parameters are not understood by
      # the PolicySpi implementation from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      # registered in the security provider list.
      # 
      # @exception NoSuchAlgorithmException if the specified provider does not
      # support a PolicySpi implementation for the specified type.
      # 
      # @see Provider
      # @since 1.6
      def get_instance(type, params, provider)
        if ((provider).nil? || (provider.length).equal?(0))
          raise IllegalArgumentException.new("missing provider")
        end
        check_permission(type)
        begin
          instance = GetInstance.get_instance("Policy", PolicySpi.class, type, params, provider)
          return PolicyDelegate.new(instance.attr_impl, instance.attr_provider, type, params)
        rescue NoSuchAlgorithmException => nsae
          return handle_exception(nsae)
        end
      end
      
      typesig { [String, Policy::Parameters, Provider] }
      # 
      # Returns a Policy object of the specified type.
      # 
      # <p> A new Policy object encapsulating the
      # PolicySpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param type the specified Policy type.  See Appendix A in the
      # <a href="../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for a list of standard Policy types.
      # 
      # @param params parameters for the Policy, which may be null.
      # 
      # @param provider the Provider.
      # 
      # @return the new Policy object.
      # 
      # @exception SecurityException if the caller does not have permission
      # to get a Policy instance for the specified type.
      # 
      # @exception NullPointerException if the specified type is null.
      # 
      # @exception IllegalArgumentException if the specified Provider is null,
      # or if the specified parameters are not understood by
      # the PolicySpi implementation from the specified Provider.
      # 
      # @exception NoSuchAlgorithmException if the specified Provider does not
      # support a PolicySpi implementation for the specified type.
      # 
      # @see Provider
      # @since 1.6
      def get_instance(type, params, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        check_permission(type)
        begin
          instance = GetInstance.get_instance("Policy", PolicySpi.class, type, params, provider)
          return PolicyDelegate.new(instance.attr_impl, instance.attr_provider, type, params)
        rescue NoSuchAlgorithmException => nsae
          return handle_exception(nsae)
        end
      end
      
      typesig { [NoSuchAlgorithmException] }
      def handle_exception(nsae)
        cause = nsae.get_cause
        if (cause.is_a?(IllegalArgumentException))
          raise cause
        end
        raise nsae
      end
    }
    
    typesig { [] }
    # 
    # Return the Provider of this Policy.
    # 
    # <p> This Policy instance will only have a Provider if it
    # was obtained via a call to <code>Policy.getInstance</code>.
    # Otherwise this method returns null.
    # 
    # @return the Provider of this Policy, or null.
    # 
    # @since 1.6
    def get_provider
      return nil
    end
    
    typesig { [] }
    # 
    # Return the type of this Policy.
    # 
    # <p> This Policy instance will only have a type if it
    # was obtained via a call to <code>Policy.getInstance</code>.
    # Otherwise this method returns null.
    # 
    # @return the type of this Policy, or null.
    # 
    # @since 1.6
    def get_type
      return nil
    end
    
    typesig { [] }
    # 
    # Return Policy parameters.
    # 
    # <p> This Policy instance will only have parameters if it
    # was obtained via a call to <code>Policy.getInstance</code>.
    # Otherwise this method returns null.
    # 
    # @return Policy parameters, or null.
    # 
    # @since 1.6
    def get_parameters
      return nil
    end
    
    typesig { [CodeSource] }
    # 
    # Return a PermissionCollection object containing the set of
    # permissions granted to the specified CodeSource.
    # 
    # <p> Applications are discouraged from calling this method
    # since this operation may not be supported by all policy implementations.
    # Applications should solely rely on the <code>implies</code> method
    # to perform policy checks.  If an application absolutely must call
    # a getPermissions method, it should call
    # <code>getPermissions(ProtectionDomain)</code>.
    # 
    # <p> The default implementation of this method returns
    # Policy.UNSUPPORTED_EMPTY_COLLECTION.  This method can be
    # overridden if the policy implementation can return a set of
    # permissions granted to a CodeSource.
    # 
    # @param codesource the CodeSource to which the returned
    # PermissionCollection has been granted.
    # 
    # @return a set of permissions granted to the specified CodeSource.
    # If this operation is supported, the returned
    # set of permissions must be a new mutable instance
    # and it must support heterogeneous Permission types.
    # If this operation is not supported,
    # Policy.UNSUPPORTED_EMPTY_COLLECTION is returned.
    def get_permissions(codesource)
      return Policy::UNSUPPORTED_EMPTY_COLLECTION
    end
    
    typesig { [ProtectionDomain] }
    # 
    # Return a PermissionCollection object containing the set of
    # permissions granted to the specified ProtectionDomain.
    # 
    # <p> Applications are discouraged from calling this method
    # since this operation may not be supported by all policy implementations.
    # Applications should rely on the <code>implies</code> method
    # to perform policy checks.
    # 
    # <p> The default implementation of this method first retrieves
    # the permissions returned via <code>getPermissions(CodeSource)</code>
    # (the CodeSource is taken from the specified ProtectionDomain),
    # as well as the permissions located inside the specified ProtectionDomain.
    # All of these permissions are then combined and returned in a new
    # PermissionCollection object.  If <code>getPermissions(CodeSource)</code>
    # returns Policy.UNSUPPORTED_EMPTY_COLLECTION, then this method
    # returns the permissions contained inside the specified ProtectionDomain
    # in a new PermissionCollection object.
    # 
    # <p> This method can be overridden if the policy implementation
    # supports returning a set of permissions granted to a ProtectionDomain.
    # 
    # @param domain the ProtectionDomain to which the returned
    # PermissionCollection has been granted.
    # 
    # @return a set of permissions granted to the specified ProtectionDomain.
    # If this operation is supported, the returned
    # set of permissions must be a new mutable instance
    # and it must support heterogeneous Permission types.
    # If this operation is not supported,
    # Policy.UNSUPPORTED_EMPTY_COLLECTION is returned.
    # 
    # @since 1.4
    def get_permissions(domain)
      pc = nil
      if ((domain).nil?)
        return Permissions.new
      end
      if ((@pd_mapping).nil?)
        init_policy(self)
      end
      synchronized((@pd_mapping)) do
        pc = @pd_mapping.get(domain)
      end
      if (!(pc).nil?)
        perms = Permissions.new
        synchronized((pc)) do
          e = pc.elements
          while e.has_more_elements
            perms.add(e.next_element)
          end
        end
        return perms
      end
      pc = get_permissions(domain.get_code_source)
      if ((pc).nil? || (pc).equal?(UNSUPPORTED_EMPTY_COLLECTION))
        pc = Permissions.new
      end
      add_static_perms(pc, domain.get_permissions)
      return pc
    end
    
    typesig { [PermissionCollection, PermissionCollection] }
    # 
    # add static permissions to provided permission collection
    def add_static_perms(perms, statics)
      if (!(statics).nil?)
        synchronized((statics)) do
          e = statics.elements
          while (e.has_more_elements)
            perms.add(e.next_element)
          end
        end
      end
    end
    
    typesig { [ProtectionDomain, Permission] }
    # 
    # Evaluates the global policy for the permissions granted to
    # the ProtectionDomain and tests whether the permission is
    # granted.
    # 
    # @param domain the ProtectionDomain to test
    # @param permission the Permission object to be tested for implication.
    # 
    # @return true if "permission" is a proper subset of a permission
    # granted to this ProtectionDomain.
    # 
    # @see java.security.ProtectionDomain
    # @since 1.4
    def implies(domain, permission)
      pc = nil
      if ((@pd_mapping).nil?)
        init_policy(self)
      end
      synchronized((@pd_mapping)) do
        pc = @pd_mapping.get(domain)
      end
      if (!(pc).nil?)
        return pc.implies(permission)
      end
      pc = get_permissions(domain)
      if ((pc).nil?)
        return false
      end
      synchronized((@pd_mapping)) do
        # cache it
        @pd_mapping.put(domain, pc)
      end
      return pc.implies(permission)
    end
    
    typesig { [] }
    # 
    # Refreshes/reloads the policy configuration. The behavior of this method
    # depends on the implementation. For example, calling <code>refresh</code>
    # on a file-based policy will cause the file to be re-read.
    # 
    # <p> The default implementation of this method does nothing.
    # This method should be overridden if a refresh operation is supported
    # by the policy implementation.
    def refresh
    end
    
    class_module.module_eval {
      # 
      # This subclass is returned by the getInstance calls.  All Policy calls
      # are delegated to the underlying PolicySpi.
      const_set_lazy(:PolicyDelegate) { Class.new(Policy) do
        include_class_members Policy
        
        attr_accessor :spi
        alias_method :attr_spi, :spi
        undef_method :spi
        alias_method :attr_spi=, :spi=
        undef_method :spi=
        
        attr_accessor :p
        alias_method :attr_p, :p
        undef_method :p
        alias_method :attr_p=, :p=
        undef_method :p=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :params
        alias_method :attr_params, :params
        undef_method :params
        alias_method :attr_params=, :params=
        undef_method :params=
        
        typesig { [PolicySpi, Provider, String, Policy::Parameters] }
        def initialize(spi, p, type, params)
          @spi = nil
          @p = nil
          @type = nil
          @params = nil
          super()
          @spi = spi
          @p = p
          @type = type
          @params = params
        end
        
        typesig { [] }
        def get_type
          return @type
        end
        
        typesig { [] }
        def get_parameters
          return @params
        end
        
        typesig { [] }
        def get_provider
          return @p
        end
        
        typesig { [CodeSource] }
        def get_permissions(codesource)
          return @spi.engine_get_permissions(codesource)
        end
        
        typesig { [ProtectionDomain] }
        def get_permissions(domain)
          return @spi.engine_get_permissions(domain)
        end
        
        typesig { [ProtectionDomain, Permission] }
        def implies(domain, perm)
          return @spi.engine_implies(domain, perm)
        end
        
        typesig { [] }
        def refresh
          @spi.engine_refresh
        end
        
        private
        alias_method :initialize__policy_delegate, :initialize
      end }
      
      # 
      # This represents a marker interface for Policy parameters.
      # 
      # @since 1.6
      const_set_lazy(:Parameters) { Module.new do
        include_class_members Policy
      end }
      
      # 
      # This class represents a read-only empty PermissionCollection object that
      # is returned from the <code>getPermissions(CodeSource)</code> and
      # <code>getPermissions(ProtectionDomain)</code>
      # methods in the Policy class when those operations are not
      # supported by the Policy implementation.
      const_set_lazy(:UnsupportedEmptyCollection) { Class.new(PermissionCollection) do
        include_class_members Policy
        
        attr_accessor :perms
        alias_method :attr_perms, :perms
        undef_method :perms
        alias_method :attr_perms=, :perms=
        undef_method :perms=
        
        typesig { [] }
        # 
        # Create a read-only empty PermissionCollection object.
        def initialize
          @perms = nil
          super()
          @perms = Permissions.new
          @perms.set_read_only
        end
        
        typesig { [Permission] }
        # 
        # Adds a permission object to the current collection of permission
        # objects.
        # 
        # @param permission the Permission object to add.
        # 
        # @exception SecurityException - if this PermissionCollection object
        # has been marked readonly
        def add(permission)
          @perms.add(permission)
        end
        
        typesig { [Permission] }
        # 
        # Checks to see if the specified permission is implied by the
        # collection of Permission objects held in this PermissionCollection.
        # 
        # @param permission the Permission object to compare.
        # 
        # @return true if "permission" is implied by the  permissions in
        # the collection, false if not.
        def implies(permission)
          return @perms.implies(permission)
        end
        
        typesig { [] }
        # 
        # Returns an enumeration of all the Permission objects in the
        # collection.
        # 
        # @return an enumeration of all the Permissions.
        def elements
          return @perms.elements
        end
        
        private
        alias_method :initialize__unsupported_empty_collection, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
      @pd_mapping = nil
    end
    
    private
    alias_method :initialize__policy, :initialize
  end
  
end

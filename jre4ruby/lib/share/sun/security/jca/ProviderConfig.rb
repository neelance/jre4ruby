require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jca
  module ProviderConfigImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jca
      include_const ::Java::Io, :JavaFile
      include ::Java::Lang::Reflect
      include ::Java::Security
      include_const ::Sun::Security::Util, :PropertyExpander
    }
  end
  
  # Class representing a configured provider. Encapsulates configuration
  # (className plus optional argument), the provider loading logic, and
  # the loaded Provider object itself.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class ProviderConfig 
    include_class_members ProviderConfigImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Sun::Security::Util::Debug.get_instance("jca", "ProviderConfig") }
      const_attr_reader  :Debug
      
      # classname of the SunPKCS11-Solaris provider
      const_set_lazy(:P11_SOL_NAME) { "sun.security.pkcs11.SunPKCS11" }
      const_attr_reader  :P11_SOL_NAME
      
      # config file argument of the SunPKCS11-Solaris provider
      const_set_lazy(:P11_SOL_ARG) { "${java.home}/lib/security/sunpkcs11-solaris.cfg" }
      const_attr_reader  :P11_SOL_ARG
      
      # maximum number of times to try loading a provider before giving up
      const_set_lazy(:MAX_LOAD_TRIES) { 30 }
      const_attr_reader  :MAX_LOAD_TRIES
      
      # parameters for the Provider(String) constructor,
      # use by doLoadProvider()
      const_set_lazy(:CL_STRING) { Array.typed(Class).new([String]) }
      const_attr_reader  :CL_STRING
      
      # lock to use while loading a provider. it ensures that each provider
      # is loaded only once and that we can detect recursion.
      # NOTE that because of 4944382 we use the system classloader as lock.
      # By using the same lock to load classes as to load providers we avoid
      # deadlock due to lock ordering. However, this class may be initialized
      # early in the startup when the system classloader has not yet been set
      # up. Use a temporary lock object if that is the case.
      # Any of this may break if the class loading implementation is changed.
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Object.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      typesig { [] }
      def get_lock
        o = self.attr_lock
        # check if lock is already set to the class loader
        if (o.is_a?(ClassLoader))
          return o
        end
        cl = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ProviderConfig
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return ClassLoader.get_system_class_loader
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # check if class loader initialized now (non-null)
        if (!(cl).nil?)
          self.attr_lock = cl
          o = cl
        end
        return o
      end
    }
    
    # name of the provider class
    attr_accessor :class_name
    alias_method :attr_class_name, :class_name
    undef_method :class_name
    alias_method :attr_class_name=, :class_name=
    undef_method :class_name=
    
    # argument to the provider constructor,
    # empty string indicates no-arg constructor
    attr_accessor :argument
    alias_method :attr_argument, :argument
    undef_method :argument
    alias_method :attr_argument=, :argument=
    undef_method :argument=
    
    # number of times we have already tried to load this provider
    attr_accessor :tries
    alias_method :attr_tries, :tries
    undef_method :tries
    alias_method :attr_tries=, :tries=
    undef_method :tries=
    
    # Provider object, if loaded
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # flag indicating if we are currently trying to load the provider
    # used to detect recursion
    attr_accessor :is_loading
    alias_method :attr_is_loading, :is_loading
    undef_method :is_loading
    alias_method :attr_is_loading=, :is_loading=
    undef_method :is_loading=
    
    typesig { [String, String] }
    def initialize(class_name, argument)
      @class_name = nil
      @argument = nil
      @tries = 0
      @provider = nil
      @is_loading = false
      if ((class_name == P11_SOL_NAME) && (argument == P11_SOL_ARG))
        check_sun_pkcs11solaris
      end
      @class_name = class_name
      @argument = expand(argument)
    end
    
    typesig { [String] }
    def initialize(class_name)
      initialize__provider_config(class_name, "")
    end
    
    typesig { [Provider] }
    def initialize(provider)
      @class_name = nil
      @argument = nil
      @tries = 0
      @provider = nil
      @is_loading = false
      @class_name = provider.get_class.get_name
      @argument = ""
      @provider = provider
    end
    
    typesig { [] }
    # check if we should try to load the SunPKCS11-Solaris provider
    # avoid if not available (pre Solaris 10) to reduce startup time
    # or if disabled via system property
    def check_sun_pkcs11solaris
      o = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ProviderConfig
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          file = JavaFile.new("/usr/lib/libpkcs11.so")
          if ((file.exists).equal?(false))
            return Boolean::FALSE
          end
          if ("false".equals_ignore_case(System.get_property("sun.security.pkcs11.enable-solaris")))
            return Boolean::FALSE
          end
          return Boolean::TRUE
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if ((o).equal?(Boolean::FALSE))
        @tries = MAX_LOAD_TRIES
      end
    end
    
    typesig { [] }
    def has_argument
      return !(@argument.length).equal?(0)
    end
    
    typesig { [] }
    # should we try to load this provider?
    def should_load
      return (@tries < MAX_LOAD_TRIES)
    end
    
    typesig { [] }
    # do not try to load this provider again
    def disable_load
      @tries = MAX_LOAD_TRIES
    end
    
    typesig { [] }
    def is_loaded
      return (!(@provider).nil?)
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(ProviderConfig)).equal?(false))
        return false
      end
      other = obj
      return (@class_name == other.attr_class_name) && (@argument == other.attr_argument)
    end
    
    typesig { [] }
    def hash_code
      return @class_name.hash_code + @argument.hash_code
    end
    
    typesig { [] }
    def to_s
      if (has_argument)
        return @class_name + "('" + @argument + "')"
      else
        return @class_name
      end
    end
    
    typesig { [] }
    # Get the provider object. Loads the provider if it is not already loaded.
    def get_provider
      # volatile variable load
      p = @provider
      if (!(p).nil?)
        return p
      end
      if ((should_load).equal?(false))
        return nil
      end
      synchronized((get_lock)) do
        p = @provider
        if (!(p).nil?)
          # loaded by another thread while we were blocked on lock
          return p
        end
        if (@is_loading)
          # because this method is synchronized, this can only
          # happen if there is recursion.
          if (!(Debug).nil?)
            Debug.println("Recursion loading provider: " + RJava.cast_to_string(self))
            JavaException.new("Call trace").print_stack_trace
          end
          return nil
        end
        begin
          @is_loading = true
          @tries += 1
          p = do_load_provider
        ensure
          @is_loading = false
        end
        @provider = p
      end
      return p
    end
    
    typesig { [] }
    # Load and instantiate the Provider described by this class.
    # 
    # NOTE use of doPrivileged().
    # 
    # @return null if the Provider could not be loaded
    # 
    # @throws ProviderException if executing the Provider's constructor
    # throws a ProviderException. All other Exceptions are ignored.
    def do_load_provider
      return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ProviderConfig
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          if (!(Debug).nil?)
            Debug.println("Loading provider: " + RJava.cast_to_string(@local_class_parent))
          end
          begin
            cl = ClassLoader.get_system_class_loader
            prov_class = nil
            if (!(cl).nil?)
              prov_class = cl.load_class(self.attr_class_name)
            else
              prov_class = Class.for_name(self.attr_class_name)
            end
            obj = nil
            if ((has_argument).equal?(false))
              obj = prov_class.new_instance
            else
              cons = prov_class.get_constructor(CL_STRING)
              obj = cons.new_instance(self.attr_argument)
            end
            if (obj.is_a?(Provider))
              if (!(Debug).nil?)
                Debug.println("Loaded provider " + RJava.cast_to_string(obj))
              end
              return obj
            else
              if (!(Debug).nil?)
                Debug.println(RJava.cast_to_string(self.attr_class_name) + " is not a provider")
              end
              disable_load
              return nil
            end
          rescue JavaException => e
            t = nil
            if (e.is_a?(InvocationTargetException))
              t = (e).get_cause
            else
              t = e
            end
            if (!(Debug).nil?)
              Debug.println("Error loading provider " + RJava.cast_to_string(@local_class_parent))
              t.print_stack_trace
            end
            # provider indicates fatal error, pass through exception
            if (t.is_a?(ProviderException))
              raise t
            end
            # provider indicates that loading should not be retried
            if (t.is_a?(UnsupportedOperationException))
              disable_load
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
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Perform property expansion of the provider value.
      # 
      # NOTE use of doPrivileged().
      def expand(value)
        # shortcut if value does not contain any properties
        if ((value.contains("${")).equal?(false))
          return value
        end
        return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ProviderConfig
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              return PropertyExpander.expand(value)
            rescue GeneralSecurityException => e
              raise ProviderException.new(e)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    private
    alias_method :initialize__provider_config, :initialize
  end
  
end

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
  module GetInstanceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jca
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Security::Provider, :Service
    }
  end
  
  # Collection of utility methods to facilitate implementing getInstance()
  # methods in the JCA/JCE/JSSE/... framework.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class GetInstance 
    include_class_members GetInstanceImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      # Static inner class representing a newly created instance.
      const_set_lazy(:Instance) { Class.new do
        include_class_members GetInstance
        
        # public final fields, access directly without accessors
        attr_accessor :provider
        alias_method :attr_provider, :provider
        undef_method :provider
        alias_method :attr_provider=, :provider=
        undef_method :provider=
        
        attr_accessor :impl
        alias_method :attr_impl, :impl
        undef_method :impl
        alias_method :attr_impl=, :impl=
        undef_method :impl=
        
        typesig { [class_self::Provider, Object] }
        def initialize(provider, impl)
          @provider = nil
          @impl = nil
          @provider = provider
          @impl = impl
        end
        
        typesig { [] }
        # Return Provider and implementation as an array as used in the
        # old Security.getImpl() methods.
        def to_array
          return Array.typed(Object).new([@impl, @provider])
        end
        
        private
        alias_method :initialize__instance, :initialize
      end }
      
      typesig { [String, String] }
      def get_service(type, algorithm)
        list = Providers.get_provider_list
        s = list.get_service(type, algorithm)
        if ((s).nil?)
          raise NoSuchAlgorithmException.new(algorithm + " " + type + " not available")
        end
        return s
      end
      
      typesig { [String, String, String] }
      def get_service(type, algorithm, provider)
        if (((provider).nil?) || ((provider.length).equal?(0)))
          raise IllegalArgumentException.new("missing provider")
        end
        p = Providers.get_provider_list.get_provider(provider)
        if ((p).nil?)
          raise NoSuchProviderException.new("no such provider: " + provider)
        end
        s = p.get_service(type, algorithm)
        if ((s).nil?)
          raise NoSuchAlgorithmException.new("no such algorithm: " + algorithm + " for provider " + provider)
        end
        return s
      end
      
      typesig { [String, String, Provider] }
      def get_service(type, algorithm, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        s = provider.get_service(type, algorithm)
        if ((s).nil?)
          raise NoSuchAlgorithmException.new("no such algorithm: " + algorithm + " for provider " + RJava.cast_to_string(provider.get_name))
        end
        return s
      end
      
      typesig { [String, String] }
      # Return a List of all the available Services that implement
      # (type, algorithm). Note that the list is initialized lazily
      # and Provider loading and lookup is only trigered when
      # necessary.
      def get_services(type, algorithm)
        list = Providers.get_provider_list
        return list.get_services(type, algorithm)
      end
      
      typesig { [String, JavaList] }
      # This method exists for compatibility with JCE only. It will be removed
      # once JCE has been changed to use the replacement method.
      # @deprecated use getServices(List<ServiceId>) instead
      def get_services(type, algorithms)
        list = Providers.get_provider_list
        return list.get_services(type, algorithms)
      end
      
      typesig { [JavaList] }
      # Return a List of all the available Services that implement any of
      # the specified algorithms. See getServices(String, String) for detals.
      def get_services(ids)
        list = Providers.get_provider_list
        return list.get_services(ids)
      end
      
      typesig { [String, Class, String] }
      # For all the getInstance() methods below:
      # @param type the type of engine (e.g. MessageDigest)
      # @param clazz the Spi class that the implementation must subclass
      # (e.g. MessageDigestSpi.class) or null if no superclass check
      # is required
      # @param algorithm the name of the algorithm (or alias), e.g. MD5
      # @param provider the provider (String or Provider object)
      # @param param the parameter to pass to the Spi constructor
      # (for CertStores)
      # 
      # There are overloaded methods for all the permutations.
      def get_instance(type, clazz, algorithm)
        # in the almost all cases, the first service will work
        # avoid taking long path if so
        list = Providers.get_provider_list
        first_service = list.get_service(type, algorithm)
        if ((first_service).nil?)
          raise NoSuchAlgorithmException.new(algorithm + " " + type + " not available")
        end
        failure = nil
        begin
          return get_instance(first_service, clazz)
        rescue NoSuchAlgorithmException => e
          failure = e
        end
        # if we cannot get the service from the prefered provider,
        # fail over to the next
        list.get_services(type, algorithm).each do |s|
          if ((s).equal?(first_service))
            # do not retry initial failed service
            next
          end
          begin
            return get_instance(s, clazz)
          rescue NoSuchAlgorithmException => e
            failure = e
          end
        end
        raise failure
      end
      
      typesig { [String, Class, String, Object] }
      def get_instance(type, clazz, algorithm, param)
        services = get_services(type, algorithm)
        failure = nil
        services.each do |s|
          begin
            return get_instance(s, clazz, param)
          rescue NoSuchAlgorithmException => e
            failure = e
          end
        end
        if (!(failure).nil?)
          raise failure
        else
          raise NoSuchAlgorithmException.new(algorithm + " " + type + " not available")
        end
      end
      
      typesig { [String, Class, String, String] }
      def get_instance(type, clazz, algorithm, provider)
        return get_instance(get_service(type, algorithm, provider), clazz)
      end
      
      typesig { [String, Class, String, Object, String] }
      def get_instance(type, clazz, algorithm, param, provider)
        return get_instance(get_service(type, algorithm, provider), clazz, param)
      end
      
      typesig { [String, Class, String, Provider] }
      def get_instance(type, clazz, algorithm, provider)
        return get_instance(get_service(type, algorithm, provider), clazz)
      end
      
      typesig { [String, Class, String, Object, Provider] }
      def get_instance(type, clazz, algorithm, param, provider)
        return get_instance(get_service(type, algorithm, provider), clazz, param)
      end
      
      typesig { [Service, Class] }
      # The two getInstance() methods below take a service. They are
      # intended for classes that cannot use the standard methods, e.g.
      # because they implement delayed provider selection like the
      # Signature class.
      def get_instance(s, clazz)
        instance = s.new_instance(nil)
        check_super_class(s, instance.get_class, clazz)
        return Instance.new(s.get_provider, instance)
      end
      
      typesig { [Service, Class, Object] }
      def get_instance(s, clazz, param)
        instance = s.new_instance(param)
        check_super_class(s, instance.get_class, clazz)
        return Instance.new(s.get_provider, instance)
      end
      
      typesig { [Service, Class, Class] }
      # Check is subClass is a subclass of superClass. If not,
      # throw a NoSuchAlgorithmException.
      def check_super_class(s, sub_class, super_class)
        if ((super_class).nil?)
          return
        end
        if ((super_class.is_assignable_from(sub_class)).equal?(false))
          raise NoSuchAlgorithmException.new("class configured for " + RJava.cast_to_string(s.get_type) + ": " + RJava.cast_to_string(s.get_class_name) + " not a " + RJava.cast_to_string(s.get_type))
        end
      end
    }
    
    private
    alias_method :initialize__get_instance, :initialize
  end
  
end

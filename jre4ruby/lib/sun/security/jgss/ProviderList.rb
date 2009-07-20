require "rjava"

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
module Sun::Security::Jgss
  module ProviderListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Javax::Security::Auth, :Subject
      include ::Sun::Security::Jgss::Spi
      include_const ::Sun::Security::Jgss::Wrapper, :NativeGSSFactory
      include_const ::Sun::Security::Jgss::Wrapper, :SunNativeProvider
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # This class stores the list of providers that this
  # GSS-Implementation is configured to use. The GSSManagerImpl class
  # queries this class whenever it needs a mechanism's factory.<p>
  # 
  # This class stores an ordered list of pairs of the form
  # <provider, oid>. When it attempts to instantiate a mechanism
  # defined by oid o, it steps through the list looking for an entry
  # with oid=o, or with oid=null. (An entry with oid=null matches all
  # mechanisms.) When it finds such an entry, the corresponding
  # provider is approached for the mechanism's factory class.
  # At instantiation time this list in initialized to contain those
  # system wide providers that contain a property of the form
  # "GssApiMechanism.x.y.z..." where "x.y.z..." is a numeric object
  # identifier with numbers x, y, z, etc. Such a property is defined
  # to map to that provider's implementation of the MechanismFactory
  # interface for the mechanism x.y.z...
  # As and when a MechanismFactory is instantiated, it is
  # cached for future use. <p>
  # 
  # An application can cause more providers to be added by means of
  # the addProviderAtFront and addProviderAtEnd methods on
  # GSSManager which get delegated to this class. The
  # addProviderAtFront method can also cause a change in the ordering
  # of the providers without adding any new providers, by causing a
  # provider to move up in a list. The method addProviderAtEnd can
  # only add providers at the end of the list if they are not already
  # in the list. The rationale is that an application will call
  # addProviderAtFront when it wants a provider to be used in
  # preference over the default ones. And it will call
  # addProviderAtEnd when it wants a provider to be used in case
  # the system ones don't suffice.<p>
  # 
  # If a mechanism's factory is being obtained from a provider as a
  # result of encountering a entryof the form <provider, oid> where
  # oid is non-null, then the assumption is that the application added
  # this entry and it wants this mechanism to be obtained from this
  # provider. Thus is the provider does not actually contain the
  # requested mechanism, an exception will be thrown. However, if the
  # entry were of the form <provider, null>, then it is viewed more
  # liberally and is simply skipped over if the provider does not claim to
  # support the requested mechanism.
  class ProviderList 
    include_class_members ProviderListImports
    
    class_module.module_eval {
      const_set_lazy(:PROV_PROP_PREFIX) { "GssApiMechanism." }
      const_attr_reader  :PROV_PROP_PREFIX
      
      const_set_lazy(:PROV_PROP_PREFIX_LEN) { PROV_PROP_PREFIX.length }
      const_attr_reader  :PROV_PROP_PREFIX_LEN
      
      const_set_lazy(:SPI_MECH_FACTORY_TYPE) { "sun.security.jgss.spi.MechanismFactory" }
      const_attr_reader  :SPI_MECH_FACTORY_TYPE
      
      # Undocumented property?
      const_set_lazy(:DEFAULT_MECH_PROP) { "sun.security.jgss.mechanism" }
      const_attr_reader  :DEFAULT_MECH_PROP
      
      when_class_loaded do
        # Set the default mechanism. Kerberos v5 is the default
        # mechanism unless it is overridden by a system property.
        # with a valid OID value
        def_oid = nil
        default_oid_str = AccessController.do_privileged(GetPropertyAction.new(DEFAULT_MECH_PROP))
        if (!(default_oid_str).nil?)
          def_oid = GSSUtil.create_oid(default_oid_str)
        end
        const_set :DEFAULT_MECH_OID, ((def_oid).nil? ? GSSUtil::GSS_KRB5_MECH_OID : def_oid)
      end
    }
    
    attr_accessor :preferences
    alias_method :attr_preferences, :preferences
    undef_method :preferences
    alias_method :attr_preferences=, :preferences=
    undef_method :preferences=
    
    attr_accessor :factories
    alias_method :attr_factories, :factories
    undef_method :factories
    alias_method :attr_factories=, :factories=
    undef_method :factories=
    
    attr_accessor :mechs
    alias_method :attr_mechs, :mechs
    undef_method :mechs
    alias_method :attr_mechs=, :mechs=
    undef_method :mechs=
    
    attr_accessor :caller
    alias_method :attr_caller, :caller
    undef_method :caller
    alias_method :attr_caller=, :caller=
    undef_method :caller=
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def initialize(caller, use_native)
      @preferences = ArrayList.new(5)
      @factories = HashMap.new(5)
      @mechs = HashSet.new(5)
      @caller = 0
      @caller = caller
      prov_list = nil
      if (use_native)
        prov_list = Array.typed(Provider).new(1) { nil }
        prov_list[0] = SunNativeProvider.new
      else
        prov_list = Security.get_providers
      end
      i = 0
      while i < prov_list.attr_length
        prov = prov_list[i]
        begin
          add_provider_at_end(prov, nil)
        rescue GSSException => ge
          # Move on to the next provider
          GSSUtil.debug("Error in adding provider " + (prov.get_name).to_s + ": " + (ge).to_s)
        end
        i += 1
      end # End of for loop
    end
    
    typesig { [String] }
    # Determines if the given provider property represents a GSS-API
    # Oid to MechanismFactory mapping.
    # @return true if this is a GSS-API property, false otherwise.
    def is_mech_factory_property(prop)
      # Try ignoring case
      return (prop.starts_with(PROV_PROP_PREFIX) || prop.region_matches(true, 0, PROV_PROP_PREFIX, 0, PROV_PROP_PREFIX_LEN))
    end
    
    typesig { [String] }
    def get_oid_from_mech_factory_property(prop)
      oid_part = prop.substring(PROV_PROP_PREFIX_LEN)
      return Oid.new(oid_part)
    end
    
    typesig { [Oid] }
    # So the existing code do not have to be changed
    def get_mech_factory(mech_oid)
      synchronized(self) do
        if ((mech_oid).nil?)
          mech_oid = ProviderList::DEFAULT_MECH_OID
        end
        return get_mech_factory(mech_oid, nil)
      end
    end
    
    typesig { [Oid, Provider] }
    # Obtains a MechanismFactory for a given mechanism. If the
    # specified provider is not null, then the impl from the
    # provider is used. Otherwise, the most preferred impl based
    # on the configured preferences is used.
    # @param mechOid the oid of the desired mechanism
    # @return a MechanismFactory for the desired mechanism.
    # @throws GSSException when the specified provider does not
    # support the desired mechanism, or when no provider supports
    # the desired mechanism.
    def get_mech_factory(mech_oid, p)
      synchronized(self) do
        if ((mech_oid).nil?)
          mech_oid = ProviderList::DEFAULT_MECH_OID
        end
        if ((p).nil?)
          # Iterate thru all preferences to find right provider
          class_name = nil
          entry = nil
          list = @preferences.iterator
          while (list.has_next)
            entry = list.next
            if (entry.implies_mechanism(mech_oid))
              ret_val = get_mech_factory(entry, mech_oid)
              if (!(ret_val).nil?)
                return ret_val
              end
            end
          end # end of while loop
          raise GSSExceptionImpl.new(GSSException::BAD_MECH, mech_oid)
        else
          # Use the impl from the specified provider; return null if the
          # the mech is unsupported by the specified provider.
          entry = PreferencesEntry.new(p, mech_oid)
          return get_mech_factory(entry, mech_oid)
        end
      end
    end
    
    typesig { [PreferencesEntry, Oid] }
    # Helper routine that uses a preferences entry to obtain an
    # implementation of a MechanismFactory from it.
    # @param e the preferences entry that contains the provider and
    # either a null of an explicit oid that matched the oid of the
    # desired mechanism.
    # @param mechOid the oid of the desired mechanism
    # @throws GSSException If the application explicitly requested
    # this entry's provider to be used for the desired mechanism but
    # some problem is encountered
    def get_mech_factory(e, mech_oid)
      p = e.get_provider
      # See if a MechanismFactory was previously instantiated for
      # this provider and mechanism combination.
      search_entry = PreferencesEntry.new(p, mech_oid)
      ret_val = @factories.get(search_entry)
      if ((ret_val).nil?)
        # Apparently not. Now try to instantiate this class from
        # the provider.
        prop = PROV_PROP_PREFIX + (mech_oid.to_s).to_s
        class_name = p.get_property(prop)
        if (!(class_name).nil?)
          ret_val = get_mech_factory_impl(p, class_name, mech_oid, @caller)
          @factories.put(search_entry, ret_val)
        else
          # This provider does not support this mechanism.
          # If the application explicitly requested that
          # this provider be used for this mechanism, then
          # throw an exception
          if (!(e.get_oid).nil?)
            raise GSSExceptionImpl.new(GSSException::BAD_MECH, "Provider " + (p.get_name).to_s + " does not support mechanism " + (mech_oid).to_s)
          end
        end
      end
      return ret_val
    end
    
    class_module.module_eval {
      typesig { [Provider, String, Oid, ::Java::Int] }
      # Helper routine to obtain a MechanismFactory implementation
      # from the same class loader as the provider of this
      # implementation.
      # @param p the provider whose classloader must be used for
      # instantiating the desired MechanismFactory
      # @ param className the name of the MechanismFactory class
      # @throws GSSException If some error occurs when trying to
      # instantiate this MechanismFactory.
      def get_mech_factory_impl(p, class_name, mech_oid, caller)
        begin
          base_class = Class.for_name(SPI_MECH_FACTORY_TYPE)
          # Load the implementation class with the same class loader
          # that was used to load the provider.
          # In order to get the class loader of a class, the
          # caller's class loader must be the same as or an ancestor of
          # the class loader being returned. Otherwise, the caller must
          # have "getClassLoader" permission, or a SecurityException
          # will be thrown.
          cl = p.get_class.get_class_loader
          impl_class = nil
          if (!(cl).nil?)
            impl_class = cl.load_class(class_name)
          else
            impl_class = Class.for_name(class_name)
          end
          if (base_class.is_assignable_from(impl_class))
            c = impl_class.get_constructor(JavaInteger::TYPE)
            mf = (c.new_instance(caller))
            if (mf.is_a?(NativeGSSFactory))
              (mf).set_mech(mech_oid)
            end
            return mf
          else
            raise create_gssexception(p, class_name, "is not a " + SPI_MECH_FACTORY_TYPE, nil)
          end
        rescue ClassNotFoundException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        rescue NoSuchMethodException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        rescue InvocationTargetException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        rescue InstantiationException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        rescue IllegalAccessException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        rescue SecurityException => e
          raise create_gssexception(p, class_name, "cannot be created", e)
        end
      end
      
      typesig { [Provider, String, String, Exception] }
      # Only used by getMechFactoryImpl
      def create_gssexception(p, class_name, trailing_msg, cause)
        err_class_info = class_name + " configured by " + (p.get_name).to_s + " for GSS-API Mechanism Factory "
        return GSSExceptionImpl.new(GSSException::BAD_MECH, err_class_info + trailing_msg, cause)
      end
    }
    
    typesig { [] }
    def get_mechs
      return @mechs.to_array(Array.typed(Oid).new([]))
    end
    
    typesig { [Provider, Oid] }
    def add_provider_at_front(p, mech_oid)
      synchronized(self) do
        new_entry = PreferencesEntry.new(p, mech_oid)
        old_entry = nil
        found_some_mech = false
        list = @preferences.iterator
        while (list.has_next)
          old_entry = list.next
          if (new_entry.implies(old_entry))
            list.remove
          end
        end
        if ((mech_oid).nil?)
          found_some_mech = add_all_mechs_from_provider(p)
        else
          oid_str = mech_oid.to_s
          if ((p.get_property(PROV_PROP_PREFIX + oid_str)).nil?)
            raise GSSExceptionImpl.new(GSSException::BAD_MECH, "Provider " + (p.get_name).to_s + " does not support " + oid_str)
          end
          @mechs.add(mech_oid)
          found_some_mech = true
        end
        if (found_some_mech)
          @preferences.add(0, new_entry)
        end
      end
    end
    
    typesig { [Provider, Oid] }
    def add_provider_at_end(p, mech_oid)
      synchronized(self) do
        new_entry = PreferencesEntry.new(p, mech_oid)
        old_entry = nil
        found_some_mech = false
        list = @preferences.iterator
        while (list.has_next)
          old_entry = list.next
          if (old_entry.implies(new_entry))
            return
          end
        end
        # System.out.println("addProviderAtEnd: No it is not redundant");
        if ((mech_oid).nil?)
          found_some_mech = add_all_mechs_from_provider(p)
        else
          oid_str = mech_oid.to_s
          if ((p.get_property(PROV_PROP_PREFIX + oid_str)).nil?)
            raise GSSExceptionImpl.new(GSSException::BAD_MECH, "Provider " + (p.get_name).to_s + " does not support " + oid_str)
          end
          @mechs.add(mech_oid)
          found_some_mech = true
        end
        if (found_some_mech)
          @preferences.add(new_entry)
        end
      end
    end
    
    typesig { [Provider] }
    # Helper routine to go through all properties contined in a
    # provider and add its mechanisms to the list of supported
    # mechanisms. If no default mechanism has been assinged so far,
    # it sets the default MechanismFactory and Oid as well.
    # @param p the provider to query
    # @return true if there is at least one mechanism that this
    # provider contributed, false otherwise
    def add_all_mechs_from_provider(p)
      prop = nil
      ret_val = false
      # Get all props for this provider
      props = p.keys
      # See if there are any GSS prop's
      while (props.has_more_elements)
        prop = (props.next_element).to_s
        if (is_mech_factory_property(prop))
          # Ok! This is a GSS provider!
          begin
            mech_oid = get_oid_from_mech_factory_property(prop)
            @mechs.add(mech_oid)
            ret_val = true
          rescue GSSException => e
            # Skip to next property
            GSSUtil.debug("Ignore the invalid property " + prop + " from provider " + (p.get_name).to_s)
          end
        end # Processed GSS property
      end # while loop
      return ret_val
    end
    
    class_module.module_eval {
      # Stores a provider and a mechanism oid indicating that the
      # provider should be used for the mechanism. If the mechanism
      # Oid is null, then it indicates that this preference holds for
      # any mechanism.<p>
      # 
      # The ProviderList maintains an ordered list of
      # PreferencesEntry's and iterates thru them as it tries to
      # instantiate MechanismFactory's.
      const_set_lazy(:PreferencesEntry) { Class.new do
        include_class_members ProviderList
        
        attr_accessor :p
        alias_method :attr_p, :p
        undef_method :p
        alias_method :attr_p=, :p=
        undef_method :p=
        
        attr_accessor :oid
        alias_method :attr_oid, :oid
        undef_method :oid
        alias_method :attr_oid=, :oid=
        undef_method :oid=
        
        typesig { [Provider, Oid] }
        def initialize(p, oid)
          @p = nil
          @oid = nil
          @p = p
          @oid = oid
        end
        
        typesig { [Object] }
        def equals(other)
          if ((self).equal?(other))
            return true
          end
          if (!(other.is_a?(PreferencesEntry)))
            return false
          end
          that = other
          if ((@p.get_name == that.attr_p.get_name))
            if (!(@oid).nil? && !(that.attr_oid).nil?)
              return (@oid == that.attr_oid)
            else
              return ((@oid).nil? && (that.attr_oid).nil?)
            end
          end
          return false
        end
        
        typesig { [] }
        def hash_code
          result = 17
          result = 37 * result + @p.get_name.hash_code
          if (!(@oid).nil?)
            result = 37 * result + @oid.hash_code
          end
          return result
        end
        
        typesig { [Object] }
        # Determines if a preference implies another. A preference
        # implies another if the latter is subsumed by the
        # former. e.g., <Provider1, null> implies <Provider1, OidX>
        # because the null in the former indicates that it should
        # be used for all mechanisms.
        def implies(other)
          if (other.is_a?(PreferencesEntry))
            temp = other
            return (equals(temp) || (@p.get_name == temp.attr_p.get_name) && (@oid).nil?)
          else
            return false
          end
        end
        
        typesig { [] }
        def get_provider
          return @p
        end
        
        typesig { [] }
        def get_oid
          return @oid
        end
        
        typesig { [Oid] }
        # Determines if this entry is applicable to the desired
        # mechanism. The entry is applicable to the desired mech if
        # it contains the same oid or if it contains a null oid
        # indicating that it is applicable to all mechs.
        # @param mechOid the desired mechanism
        # @return true if the provider in this entry should be
        # queried for this mechanism.
        def implies_mechanism(oid)
          return ((@oid).nil? || (@oid == oid))
        end
        
        typesig { [] }
        # For debugging
        def to_s
          buf = StringBuffer.new("<")
          buf.append(@p.get_name)
          buf.append(", ")
          buf.append(@oid)
          buf.append(">")
          return buf.to_s
        end
        
        private
        alias_method :initialize__preferences_entry, :initialize
      end }
    }
    
    private
    alias_method :initialize__provider_list, :initialize
  end
  
end

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
  module GSSCredentialImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss::Spi
      include ::Java::Util
    }
  end
  
  class GSSCredentialImpl 
    include_class_members GSSCredentialImplImports
    include GSSCredential
    
    attr_accessor :gss_manager
    alias_method :attr_gss_manager, :gss_manager
    undef_method :gss_manager
    alias_method :attr_gss_manager=, :gss_manager=
    undef_method :gss_manager=
    
    attr_accessor :destroyed
    alias_method :attr_destroyed, :destroyed
    undef_method :destroyed
    alias_method :attr_destroyed=, :destroyed=
    undef_method :destroyed=
    
    # We store all elements in a hashtable, using <oid, usage> as the
    # key. This makes it easy to locate the specific kind of credential we
    # need. The implementation needs to be optimized for the case where
    # there is just one element (tempCred).
    attr_accessor :hashtable
    alias_method :attr_hashtable, :hashtable
    undef_method :hashtable
    alias_method :attr_hashtable=, :hashtable=
    undef_method :hashtable=
    
    # XXX Optimization for single mech usage
    attr_accessor :temp_cred
    alias_method :attr_temp_cred, :temp_cred
    undef_method :temp_cred
    alias_method :attr_temp_cred=, :temp_cred=
    undef_method :temp_cred=
    
    typesig { [GSSManagerImpl, ::Java::Int] }
    def initialize(gss_manager, usage)
      initialize__gsscredential_impl(gss_manager, nil, GSSCredential::DEFAULT_LIFETIME, nil, usage)
    end
    
    typesig { [GSSManagerImpl, GSSName, ::Java::Int, Oid, ::Java::Int] }
    def initialize(gss_manager, name, lifetime, mech, usage)
      @gss_manager = nil
      @destroyed = false
      @hashtable = nil
      @temp_cred = nil
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      init(gss_manager)
      add(name, lifetime, lifetime, mech, usage)
    end
    
    typesig { [GSSManagerImpl, GSSName, ::Java::Int, Array.typed(Oid), ::Java::Int] }
    def initialize(gss_manager, name, lifetime, mechs, usage)
      @gss_manager = nil
      @destroyed = false
      @hashtable = nil
      @temp_cred = nil
      init(gss_manager)
      default_list = false
      if ((mechs).nil?)
        mechs = gss_manager.get_mechs
        default_list = true
      end
      i = 0
      while i < mechs.attr_length
        begin
          add(name, lifetime, lifetime, mechs[i], usage)
        rescue GSSException => e
          if (default_list)
            # Try the next mechanism
            GSSUtil.debug("Ignore " + RJava.cast_to_string(e) + " while acquring cred for " + RJava.cast_to_string(mechs[i]))
            # e.printStackTrace();
          else
            raise e
          end # else try the next mechanism
        end
        i += 1
      end
      if (((@hashtable.size).equal?(0)) || (!(usage).equal?(get_usage)))
        raise GSSException.new(GSSException::NO_CRED)
      end
    end
    
    typesig { [GSSManagerImpl, GSSCredentialSpi] }
    def initialize(gss_manager, mech_element)
      @gss_manager = nil
      @destroyed = false
      @hashtable = nil
      @temp_cred = nil
      init(gss_manager)
      usage = GSSCredential::ACCEPT_ONLY
      if (mech_element.is_initiator_credential)
        if (mech_element.is_acceptor_credential)
          usage = GSSCredential::INITIATE_AND_ACCEPT
        else
          usage = GSSCredential::INITIATE_ONLY
        end
      end
      key = SearchKey.new(mech_element.get_mechanism, usage)
      @temp_cred = mech_element
      @hashtable.put(key, @temp_cred)
    end
    
    typesig { [GSSManagerImpl] }
    def init(gss_manager)
      @gss_manager = gss_manager
      @hashtable = Hashtable.new(gss_manager.get_mechs.attr_length)
    end
    
    typesig { [] }
    def dispose
      if (!@destroyed)
        element = nil
        values = @hashtable.elements
        while (values.has_more_elements)
          element = values.next_element
          element.dispose
        end
        @destroyed = true
      end
    end
    
    typesig { [] }
    def get_name
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      return GSSNameImpl.wrap_element(@gss_manager, @temp_cred.get_name)
    end
    
    typesig { [Oid] }
    def get_name(mech)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      key = nil
      element = nil
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_ONLY)
      element = @hashtable.get(key)
      if ((element).nil?)
        key = SearchKey.new(mech, GSSCredential::ACCEPT_ONLY)
        element = @hashtable.get(key)
      end
      if ((element).nil?)
        key = SearchKey.new(mech, GSSCredential::INITIATE_AND_ACCEPT)
        element = @hashtable.get(key)
      end
      if ((element).nil?)
        raise GSSExceptionImpl.new(GSSException::BAD_MECH, mech)
      end
      return GSSNameImpl.wrap_element(@gss_manager, element.get_name)
    end
    
    typesig { [] }
    # Returns the remaining lifetime of this credential. The remaining
    # lifetime is defined as the minimum lifetime, either for initiate or
    # for accept, across all elements contained in it. Not terribly
    # useful, but required by GSS-API.
    def get_remaining_lifetime
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      temp_key = nil
      temp_cred = nil
      temp_life = 0
      temp_init_life = 0
      temp_accept_life = 0
      min = INDEFINITE_LIFETIME
      e = @hashtable.keys
      while e.has_more_elements
        temp_key = e.next_element
        temp_cred = @hashtable.get(temp_key)
        if ((temp_key.get_usage).equal?(INITIATE_ONLY))
          temp_life = temp_cred.get_init_lifetime
        else
          if ((temp_key.get_usage).equal?(ACCEPT_ONLY))
            temp_life = temp_cred.get_accept_lifetime
          else
            temp_init_life = temp_cred.get_init_lifetime
            temp_accept_life = temp_cred.get_accept_lifetime
            temp_life = (temp_init_life < temp_accept_life ? temp_init_life : temp_accept_life)
          end
        end
        if (min > temp_life)
          min = temp_life
        end
      end
      return min
    end
    
    typesig { [Oid] }
    def get_remaining_init_lifetime(mech)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      element = nil
      key = nil
      found = false
      max = 0
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_ONLY)
      element = @hashtable.get(key)
      if (!(element).nil?)
        found = true
        if (max < element.get_init_lifetime)
          max = element.get_init_lifetime
        end
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_AND_ACCEPT)
      element = @hashtable.get(key)
      if (!(element).nil?)
        found = true
        if (max < element.get_init_lifetime)
          max = element.get_init_lifetime
        end
      end
      if (!found)
        raise GSSExceptionImpl.new(GSSException::BAD_MECH, mech)
      end
      return max
    end
    
    typesig { [Oid] }
    def get_remaining_accept_lifetime(mech)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      element = nil
      key = nil
      found = false
      max = 0
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      key = SearchKey.new(mech, GSSCredential::ACCEPT_ONLY)
      element = @hashtable.get(key)
      if (!(element).nil?)
        found = true
        if (max < element.get_accept_lifetime)
          max = element.get_accept_lifetime
        end
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_AND_ACCEPT)
      element = @hashtable.get(key)
      if (!(element).nil?)
        found = true
        if (max < element.get_accept_lifetime)
          max = element.get_accept_lifetime
        end
      end
      if (!found)
        raise GSSExceptionImpl.new(GSSException::BAD_MECH, mech)
      end
      return max
    end
    
    typesig { [] }
    # Returns the usage mode for this credential. Returns
    # INITIATE_AND_ACCEPT if any one element contained in it supports
    # INITIATE_AND_ACCEPT or if two different elements exist where one
    # support INITIATE_ONLY and the other supports ACCEPT_ONLY.
    def get_usage
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      temp_key = nil
      initiate = false
      accept = false
      e = @hashtable.keys
      while e.has_more_elements
        temp_key = e.next_element
        if ((temp_key.get_usage).equal?(INITIATE_ONLY))
          initiate = true
        else
          if ((temp_key.get_usage).equal?(ACCEPT_ONLY))
            accept = true
          else
            return INITIATE_AND_ACCEPT
          end
        end
      end
      if (initiate)
        if (accept)
          return INITIATE_AND_ACCEPT
        else
          return INITIATE_ONLY
        end
      else
        return ACCEPT_ONLY
      end
    end
    
    typesig { [Oid] }
    def get_usage(mech)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      element = nil
      key = nil
      initiate = false
      accept = false
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_ONLY)
      element = @hashtable.get(key)
      if (!(element).nil?)
        initiate = true
      end
      key = SearchKey.new(mech, GSSCredential::ACCEPT_ONLY)
      element = @hashtable.get(key)
      if (!(element).nil?)
        accept = true
      end
      key = SearchKey.new(mech, GSSCredential::INITIATE_AND_ACCEPT)
      element = @hashtable.get(key)
      if (!(element).nil?)
        initiate = true
        accept = true
      end
      if (initiate && accept)
        return GSSCredential::INITIATE_AND_ACCEPT
      else
        if (initiate)
          return GSSCredential::INITIATE_ONLY
        else
          if (accept)
            return GSSCredential::ACCEPT_ONLY
          else
            raise GSSExceptionImpl.new(GSSException::BAD_MECH, mech)
          end
        end
      end
    end
    
    typesig { [] }
    def get_mechs
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      result = Vector.new(@hashtable.size)
      e = @hashtable.keys
      while e.has_more_elements
        temp_key = e.next_element
        result.add_element(temp_key.get_mech)
      end
      return result.to_array(Array.typed(Oid).new(0) { nil })
    end
    
    typesig { [GSSName, ::Java::Int, ::Java::Int, Oid, ::Java::Int] }
    def add(name, init_lifetime, accept_lifetime, mech, usage)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      key = SearchKey.new(mech, usage)
      if (@hashtable.contains_key(key))
        raise GSSExceptionImpl.new(GSSException::DUPLICATE_ELEMENT, "Duplicate element found: " + RJava.cast_to_string(get_element_str(mech, usage)))
      end
      # XXX If not instance of GSSNameImpl then throw exception
      # Application mixing GSS implementations
      name_element = ((name).nil? ? nil : (name).get_element(mech))
      @temp_cred = @gss_manager.get_credential_element(name_element, init_lifetime, accept_lifetime, mech, usage)
      # Not all mechanisms support the concept of one credential element
      # that can be used for both initiating and accepting a context. In
      # the event that an application requests usage INITIATE_AND_ACCEPT
      # for a credential from such a mechanism, the GSS framework will
      # need to obtain two different credential elements from the
      # mechanism, one that will have usage INITIATE_ONLY and another
      # that will have usage ACCEPT_ONLY. The mechanism will help the
      # GSS-API realize this by returning a credential element with
      # usage INITIATE_ONLY or ACCEPT_ONLY prompting it to make another
      # call to getCredentialElement, this time with the other usage
      # mode.
      if (!(@temp_cred).nil?)
        if ((usage).equal?(GSSCredential::INITIATE_AND_ACCEPT) && (!@temp_cred.is_acceptor_credential || !@temp_cred.is_initiator_credential))
          current_usage = 0
          desired_usage = 0
          if (!@temp_cred.is_initiator_credential)
            current_usage = GSSCredential::ACCEPT_ONLY
            desired_usage = GSSCredential::INITIATE_ONLY
          else
            current_usage = GSSCredential::INITIATE_ONLY
            desired_usage = GSSCredential::ACCEPT_ONLY
          end
          key = SearchKey.new(mech, current_usage)
          @hashtable.put(key, @temp_cred)
          @temp_cred = @gss_manager.get_credential_element(name_element, init_lifetime, accept_lifetime, mech, desired_usage)
          key = SearchKey.new(mech, desired_usage)
          @hashtable.put(key, @temp_cred)
        else
          @hashtable.put(key, @temp_cred)
        end
      end
    end
    
    typesig { [Object] }
    def ==(another)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      if ((self).equal?(another))
        return true
      end
      if (!(another.is_a?(GSSCredentialImpl)))
        return false
      end
      # NOTE: The specification does not define the criteria to compare
      # credentials.
      # 
      # XXX
      # The RFC says: "Tests if this GSSCredential refers to the same
      # entity as the supplied object.  The two credentials must be
      # acquired over the same mechanisms and must refer to the same
      # principal.  Returns "true" if the two GSSCredentials refer to
      # the same entity; "false" otherwise."
      # 
      # Well, when do two credentials refer to the same principal? Do
      # they need to have one GSSName in common for the different
      # GSSName's that the credential elements return? Or do all
      # GSSName's have to be in common when the names are exported with
      # their respective mechanisms for the credential elements?
      return false
    end
    
    typesig { [] }
    # Returns a hashcode value for this GSSCredential.
    # 
    # @return a hashCode value
    def hash_code
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      # NOTE: The specification does not define the criteria to compare
      # credentials.
      # 
      # XXX
      # Decide on a criteria for equals first then do this.
      return 1
    end
    
    typesig { [Oid, ::Java::Boolean] }
    # Returns the specified mechanism's credential-element.
    # 
    # @param mechOid - the oid for mechanism to retrieve
    # @param throwExcep - boolean indicating if the function is
    # to throw exception or return null when element is not
    # found.
    # @return mechanism credential object
    # @exception GSSException of invalid mechanism
    def get_element(mech_oid, initiate)
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      key = nil
      element = nil
      if ((mech_oid).nil?)
        # First see if the default mechanism satisfies the
        # desired usage.
        mech_oid = ProviderList::DEFAULT_MECH_OID
        key = SearchKey.new(mech_oid, initiate ? INITIATE_ONLY : ACCEPT_ONLY)
        element = @hashtable.get(key)
        if ((element).nil?)
          key = SearchKey.new(mech_oid, INITIATE_AND_ACCEPT)
          element = @hashtable.get(key)
          if ((element).nil?)
            # Now just return any element that satisfies the
            # desired usage.
            elements_ = @hashtable.entry_set.to_array
            i = 0
            while i < elements_.attr_length
              element = (elements_[i]).get_value
              if ((element.is_initiator_credential).equal?(initiate))
                break
              end
              i += 1
            end # for loop
          end
        end
      else
        if (initiate)
          key = SearchKey.new(mech_oid, INITIATE_ONLY)
        else
          key = SearchKey.new(mech_oid, ACCEPT_ONLY)
        end
        element = @hashtable.get(key)
        if ((element).nil?)
          key = SearchKey.new(mech_oid, INITIATE_AND_ACCEPT)
          element = @hashtable.get(key)
        end
      end
      if ((element).nil?)
        raise GSSExceptionImpl.new(GSSException::NO_CRED, "No credential found for: " + RJava.cast_to_string(mech_oid) + RJava.cast_to_string(get_element_str(mech_oid, initiate ? INITIATE_ONLY : ACCEPT_ONLY)))
      end
      return element
    end
    
    typesig { [] }
    def get_elements
      ret_val = HashSet.new(@hashtable.size)
      values = @hashtable.elements
      while (values.has_more_elements)
        o = values.next_element
        ret_val.add(o)
      end
      return ret_val
    end
    
    class_module.module_eval {
      typesig { [Oid, ::Java::Int] }
      def get_element_str(mech_oid, usage)
        display_string = mech_oid.to_s
        if ((usage).equal?(GSSCredential::INITIATE_ONLY))
          display_string = RJava.cast_to_string(display_string.concat(" usage: Initiate"))
        else
          if ((usage).equal?(GSSCredential::ACCEPT_ONLY))
            display_string = RJava.cast_to_string(display_string.concat(" usage: Accept"))
          else
            display_string = RJava.cast_to_string(display_string.concat(" usage: Initiate and Accept"))
          end
        end
        return display_string
      end
    }
    
    typesig { [] }
    def to_s
      if (@destroyed)
        raise IllegalStateException.new("This credential is " + "no longer valid")
      end
      element = nil
      buffer = StringBuffer.new("[GSSCredential: ")
      elements_ = @hashtable.entry_set.to_array
      i = 0
      while i < elements_.attr_length
        begin
          buffer.append(Character.new(?\n.ord))
          element = (elements_[i]).get_value
          buffer.append(element.get_name)
          buffer.append(Character.new(?\s.ord))
          buffer.append(element.get_mechanism)
          buffer.append(element.is_initiator_credential ? " Initiate" : "")
          buffer.append(element.is_acceptor_credential ? " Accept" : "")
          buffer.append(" [")
          buffer.append(element.to_s)
          buffer.append(Character.new(?].ord))
        rescue GSSException => e
          # skip to next element
        end
        i += 1
      end
      buffer.append(Character.new(?].ord))
      return buffer.to_s
    end
    
    class_module.module_eval {
      const_set_lazy(:SearchKey) { Class.new do
        include_class_members GSSCredentialImpl
        
        attr_accessor :mech_oid
        alias_method :attr_mech_oid, :mech_oid
        undef_method :mech_oid
        alias_method :attr_mech_oid=, :mech_oid=
        undef_method :mech_oid=
        
        attr_accessor :usage
        alias_method :attr_usage, :usage
        undef_method :usage
        alias_method :attr_usage=, :usage=
        undef_method :usage=
        
        typesig { [self::Oid, ::Java::Int] }
        def initialize(mech_oid, usage)
          @mech_oid = nil
          @usage = GSSCredential::INITIATE_AND_ACCEPT
          @mech_oid = mech_oid
          @usage = usage
        end
        
        typesig { [] }
        def get_mech
          return @mech_oid
        end
        
        typesig { [] }
        def get_usage
          return @usage
        end
        
        typesig { [self::Object] }
        def ==(other)
          if (!(other.is_a?(self.class::SearchKey)))
            return false
          end
          that = other
          return (((@mech_oid == that.attr_mech_oid)) && ((@usage).equal?(that.attr_usage)))
        end
        
        typesig { [] }
        def hash_code
          return @mech_oid.hash_code
        end
        
        private
        alias_method :initialize__search_key, :initialize
      end }
    }
    
    private
    alias_method :initialize__gsscredential_impl, :initialize
  end
  
end

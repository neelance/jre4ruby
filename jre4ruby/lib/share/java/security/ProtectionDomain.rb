require "rjava"

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
  module ProtectionDomainImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # <p>
  # This ProtectionDomain class encapsulates the characteristics of a domain,
  # which encloses a set of classes whose instances are granted a set
  # of permissions when being executed on behalf of a given set of Principals.
  # <p>
  # A static set of permissions can be bound to a ProtectionDomain when it is
  # constructed; such permissions are granted to the domain regardless of the
  # Policy in force. However, to support dynamic security policies, a
  # ProtectionDomain can also be constructed such that it is dynamically
  # mapped to a set of permissions by the current Policy whenever a permission
  # is checked.
  # <p>
  # 
  # @author Li Gong
  # @author Roland Schemers
  # @author Gary Ellison
  class ProtectionDomain 
    include_class_members ProtectionDomainImports
    
    # CodeSource
    attr_accessor :codesource
    alias_method :attr_codesource, :codesource
    undef_method :codesource
    alias_method :attr_codesource=, :codesource=
    undef_method :codesource=
    
    # ClassLoader the protection domain was consed from
    attr_accessor :classloader
    alias_method :attr_classloader, :classloader
    undef_method :classloader
    alias_method :attr_classloader=, :classloader=
    undef_method :classloader=
    
    # Principals running-as within this protection domain
    attr_accessor :principals
    alias_method :attr_principals, :principals
    undef_method :principals
    alias_method :attr_principals=, :principals=
    undef_method :principals=
    
    # the rights this protection domain is granted
    attr_accessor :permissions
    alias_method :attr_permissions, :permissions
    undef_method :permissions
    alias_method :attr_permissions=, :permissions=
    undef_method :permissions=
    
    # if the permissions object has AllPermission
    attr_accessor :has_all_perm
    alias_method :attr_has_all_perm, :has_all_perm
    undef_method :has_all_perm
    alias_method :attr_has_all_perm=, :has_all_perm=
    undef_method :has_all_perm=
    
    # the PermissionCollection is static (pre 1.4 constructor)
    # or dynamic (via a policy refresh)
    attr_accessor :static_permissions
    alias_method :attr_static_permissions, :static_permissions
    undef_method :static_permissions
    alias_method :attr_static_permissions=, :static_permissions=
    undef_method :static_permissions=
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("domain") }
      const_attr_reader  :Debug
    }
    
    typesig { [CodeSource, PermissionCollection] }
    # Creates a new ProtectionDomain with the given CodeSource and
    # Permissions. If the permissions object is not null, then
    # <code>setReadOnly())</code> will be called on the passed in
    # Permissions object. The only permissions granted to this domain
    # are the ones specified; the current Policy will not be consulted.
    # 
    # @param codesource the codesource associated with this domain
    # @param permissions the permissions granted to this domain
    def initialize(codesource, permissions)
      @codesource = nil
      @classloader = nil
      @principals = nil
      @permissions = nil
      @has_all_perm = false
      @static_permissions = false
      @codesource = codesource
      if (!(permissions).nil?)
        @permissions = permissions
        @permissions.set_read_only
        if (permissions.is_a?(Permissions) && !((permissions).attr_all_permission).nil?)
          @has_all_perm = true
        end
      end
      @classloader = nil
      @principals = Array.typed(Principal).new(0) { nil }
      @static_permissions = true
    end
    
    typesig { [CodeSource, PermissionCollection, ClassLoader, Array.typed(Principal)] }
    # Creates a new ProtectionDomain qualified by the given CodeSource,
    # Permissions, ClassLoader and array of Principals. If the
    # permissions object is not null, then <code>setReadOnly()</code>
    # will be called on the passed in Permissions object.
    # The permissions granted to this domain are dynamic; they include
    # both the static permissions passed to this constructor, and any
    # permissions granted to this domain by the current Policy at the
    # time a permission is checked.
    # <p>
    # This constructor is typically used by
    # {@link SecureClassLoader ClassLoaders}
    # and {@link DomainCombiner DomainCombiners} which delegate to
    # <code>Policy</code> to actively associate the permissions granted to
    # this domain. This constructor affords the
    # Policy provider the opportunity to augment the supplied
    # PermissionCollection to reflect policy changes.
    # <p>
    # 
    # @param codesource the CodeSource associated with this domain
    # @param permissions the permissions granted to this domain
    # @param classloader the ClassLoader associated with this domain
    # @param principals the array of Principals associated with this
    # domain. The contents of the array are copied to protect against
    # subsequent modification.
    # @see Policy#refresh
    # @see Policy#getPermissions(ProtectionDomain)
    # @since 1.4
    def initialize(codesource, permissions, classloader, principals)
      @codesource = nil
      @classloader = nil
      @principals = nil
      @permissions = nil
      @has_all_perm = false
      @static_permissions = false
      @codesource = codesource
      if (!(permissions).nil?)
        @permissions = permissions
        @permissions.set_read_only
        if (permissions.is_a?(Permissions) && !((permissions).attr_all_permission).nil?)
          @has_all_perm = true
        end
      end
      @classloader = classloader
      @principals = (!(principals).nil? ? principals.clone : Array.typed(Principal).new(0) { nil })
      @static_permissions = false
    end
    
    typesig { [] }
    # Returns the CodeSource of this domain.
    # @return the CodeSource of this domain which may be null.
    # @since 1.2
    def get_code_source
      return @codesource
    end
    
    typesig { [] }
    # Returns the ClassLoader of this domain.
    # @return the ClassLoader of this domain which may be null.
    # 
    # @since 1.4
    def get_class_loader
      return @classloader
    end
    
    typesig { [] }
    # Returns an array of principals for this domain.
    # @return a non-null array of principals for this domain.
    # Returns a new array each time this method is called.
    # 
    # @since 1.4
    def get_principals
      return @principals.clone
    end
    
    typesig { [] }
    # Returns the static permissions granted to this domain.
    # 
    # @return the static set of permissions for this domain which may be null.
    # @see Policy#refresh
    # @see Policy#getPermissions(ProtectionDomain)
    def get_permissions
      return @permissions
    end
    
    typesig { [Permission] }
    # Check and see if this ProtectionDomain implies the permissions
    # expressed in the Permission object.
    # <p>
    # The set of permissions evaluated is a function of whether the
    # ProtectionDomain was constructed with a static set of permissions
    # or it was bound to a dynamically mapped set of permissions.
    # <p>
    # If the ProtectionDomain was constructed to a
    # {@link #ProtectionDomain(CodeSource, PermissionCollection)
    # statically bound} PermissionCollection then the permission will
    # only be checked against the PermissionCollection supplied at
    # construction.
    # <p>
    # However, if the ProtectionDomain was constructed with
    # the constructor variant which supports
    # {@link #ProtectionDomain(CodeSource, PermissionCollection,
    # ClassLoader, java.security.Principal[]) dynamically binding}
    # permissions, then the permission will be checked against the
    # combination of the PermissionCollection supplied at construction and
    # the current Policy binding.
    # <p>
    # 
    # @param permission the Permission object to check.
    # 
    # @return true if "permission" is implicit to this ProtectionDomain.
    def implies(permission)
      if (@has_all_perm)
        # internal permission collection already has AllPermission -
        # no need to go to policy
        return true
      end
      if (!@static_permissions && Policy.get_policy_no_check.implies(self, permission))
        return true
      end
      if (!(@permissions).nil?)
        return @permissions.implies(permission)
      end
      return false
    end
    
    typesig { [] }
    # Convert a ProtectionDomain to a String.
    def to_s
      pals = "<no principals>"
      if (!(@principals).nil? && @principals.attr_length > 0)
        pal_buf = StringBuilder.new("(principals ")
        i = 0
        while i < @principals.attr_length
          pal_buf.append(RJava.cast_to_string(@principals[i].get_class.get_name) + " \"" + RJava.cast_to_string(@principals[i].get_name) + "\"")
          if (i < @principals.attr_length - 1)
            pal_buf.append(",\n")
          else
            pal_buf.append(")\n")
          end
          i += 1
        end
        pals = RJava.cast_to_string(pal_buf.to_s)
      end
      # Check if policy is set; we don't want to load
      # the policy prematurely here
      pc = Policy.is_set && see_allp ? merge_permissions : get_permissions
      return "ProtectionDomain " + " " + RJava.cast_to_string(@codesource) + "\n" + " " + RJava.cast_to_string(@classloader) + "\n" + " " + pals + "\n" + " " + RJava.cast_to_string(pc) + "\n"
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return true (merge policy permissions) in the following cases:
      # 
      # . SecurityManager is null
      # 
      # . SecurityManager is not null,
      # debug is not null,
      # SecurityManager impelmentation is in bootclasspath,
      # Policy implementation is in bootclasspath
      # (the bootclasspath restrictions avoid recursion)
      # 
      # . SecurityManager is not null,
      # debug is null,
      # caller has Policy.getPolicy permission
      def see_allp
        sm = System.get_security_manager
        if ((sm).nil?)
          return true
        else
          if (!(Debug).nil?)
            if ((sm.get_class.get_class_loader).nil? && (Policy.get_policy_no_check.get_class.get_class_loader).nil?)
              return true
            end
          else
            begin
              sm.check_permission(SecurityConstants::GET_POLICY_PERMISSION)
              return true
            rescue SecurityException => se
              # fall thru and return false
            end
          end
        end
        return false
      end
    }
    
    typesig { [] }
    def merge_permissions
      if (@static_permissions)
        return @permissions
      end
      perms = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members ProtectionDomain
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          p = Policy.get_policy_no_check
          return p.get_permissions(@local_class_parent)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      merged_perms = Permissions.new
      swag = 32
      vcap = 8
      e = nil
      pd_vector = ArrayList.new(vcap)
      pl_vector = ArrayList.new(swag)
      # Build a vector of domain permissions for subsequent merge
      if (!(@permissions).nil?)
        synchronized((@permissions)) do
          e = @permissions.elements
          while (e.has_more_elements)
            pd_vector.add(e.next_element)
          end
        end
      end
      # Build a vector of Policy permissions for subsequent merge
      if (!(perms).nil?)
        synchronized((perms)) do
          e = perms.elements
          while (e.has_more_elements)
            pl_vector.add(e.next_element)
            vcap += 1
          end
        end
      end
      if (!(perms).nil? && !(@permissions).nil?)
        # Weed out the duplicates from the policy. Unless a refresh
        # has occured since the pd was consed this should result in
        # an empty vector.
        synchronized((@permissions)) do
          e = @permissions.elements # domain vs policy
          while (e.has_more_elements)
            pdp = e.next_element
            pdp_class = pdp.get_class
            pdp_actions = pdp.get_actions
            pdp_name = pdp.get_name
            i = 0
            while i < pl_vector.size
              pp = pl_vector.get(i)
              if (pdp_class.is_instance(pp))
                # The equals() method on some permissions
                # have some side effects so this manual
                # comparison is sufficient.
                if ((pdp_name == pp.get_name) && (pdp_actions == pp.get_actions))
                  pl_vector.remove(i)
                  break
                end
              end
              i += 1
            end
          end
        end
      end
      if (!(perms).nil?)
        # the order of adding to merged perms and permissions
        # needs to preserve the bugfix 4301064
        i = pl_vector.size - 1
        while i >= 0
          merged_perms.add(pl_vector.get(i))
          i -= 1
        end
      end
      if (!(@permissions).nil?)
        i = pd_vector.size - 1
        while i >= 0
          merged_perms.add(pd_vector.get(i))
          i -= 1
        end
      end
      return merged_perms
    end
    
    private
    alias_method :initialize__protection_domain, :initialize
  end
  
end

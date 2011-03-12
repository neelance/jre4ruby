require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IdentityScopeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :Serializable
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Properties
    }
  end
  
  # <p>This class represents a scope for identities. It is an Identity
  # itself, and therefore has a name and can have a scope. It can also
  # optionally have a public key and associated certificates.
  # 
  # <p>An IdentityScope can contain Identity objects of all kinds, including
  # Signers. All types of Identity objects can be retrieved, added, and
  # removed using the same methods. Note that it is possible, and in fact
  # expected, that different types of identity scopes will
  # apply different policies for their various operations on the
  # various types of Identities.
  # 
  # <p>There is a one-to-one mapping between keys and identities, and
  # there can only be one copy of one key per scope. For example, suppose
  # <b>Acme Software, Inc</b> is a software publisher known to a user.
  # Suppose it is an Identity, that is, it has a public key, and a set of
  # associated certificates. It is named in the scope using the name
  # "Acme Software". No other named Identity in the scope has the same
  # public  key. Of course, none has the same name as well.
  # 
  # @see Identity
  # @see Signer
  # @see Principal
  # @see Key
  # 
  # @author Benjamin Renaud
  # 
  # @deprecated This class is no longer used. Its functionality has been
  # replaced by <code>java.security.KeyStore</code>, the
  # <code>java.security.cert</code> package, and
  # <code>java.security.Principal</code>.
  class IdentityScope < IdentityScopeImports.const_get :Identity
    include_class_members IdentityScopeImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2337346281189773310 }
      const_attr_reader  :SerialVersionUID
      
      # The system's scope
      
      def scope
        defined?(@@scope) ? @@scope : @@scope= nil
      end
      alias_method :attr_scope, :scope
      
      def scope=(value)
        @@scope = value
      end
      alias_method :attr_scope=, :scope=
      
      typesig { [] }
      # initialize the system scope
      def initialize_system_scope
        classname = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in IdentityScope
          include_class_members IdentityScope
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Security.get_property("system.scope")
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if ((classname).nil?)
          return
        else
          begin
            Class.for_name(classname)
          rescue ClassNotFoundException => e
            # Security.error("unable to establish a system scope from " +
            #             classname);
            e.print_stack_trace
          end
        end
      end
    }
    
    typesig { [] }
    # This constructor is used for serialization only and should not
    # be used by subclasses.
    def initialize
      initialize__identity_scope("restoring...")
    end
    
    typesig { [String] }
    # Constructs a new identity scope with the specified name.
    # 
    # @param name the scope name.
    def initialize(name)
      super(name)
    end
    
    typesig { [String, IdentityScope] }
    # Constructs a new identity scope with the specified name and scope.
    # 
    # @param name the scope name.
    # @param scope the scope for the new identity scope.
    # 
    # @exception KeyManagementException if there is already an identity
    # with the same name in the scope.
    def initialize(name, scope)
      super(name, scope)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the system's identity scope.
      # 
      # @return the system's identity scope.
      # 
      # @see #setSystemScope
      def get_system_scope
        if ((self.attr_scope).nil?)
          initialize_system_scope
        end
        return self.attr_scope
      end
      
      typesig { [IdentityScope] }
      # Sets the system's identity scope.
      # 
      # <p>First, if there is a security manager, its
      # <code>checkSecurityAccess</code>
      # method is called with <code>"setSystemScope"</code>
      # as its argument to see if it's ok to set the identity scope.
      # 
      # @param scope the scope to set.
      # 
      # @exception  SecurityException  if a security manager exists and its
      # <code>checkSecurityAccess</code> method doesn't allow
      # setting the identity scope.
      # 
      # @see #getSystemScope
      # @see SecurityManager#checkSecurityAccess
      def set_system_scope(scope)
        check("setSystemScope")
        self.attr_scope = scope
      end
    }
    
    typesig { [] }
    # Returns the number of identities within this identity scope.
    # 
    # @return the number of identities within this identity scope.
    def size
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the identity in this scope with the specified name (if any).
    # 
    # @param name the name of the identity to be retrieved.
    # 
    # @return the identity named <code>name</code>, or null if there are
    # no identities named <code>name</code> in this scope.
    def get_identity(name)
      raise NotImplementedError
    end
    
    typesig { [Principal] }
    # Retrieves the identity whose name is the same as that of the
    # specified principal. (Note: Identity implements Principal.)
    # 
    # @param principal the principal corresponding to the identity
    # to be retrieved.
    # 
    # @return the identity whose name is the same as that of the
    # principal, or null if there are no identities of the same name
    # in this scope.
    def get_identity(principal)
      return get_identity(principal.get_name)
    end
    
    typesig { [PublicKey] }
    # Retrieves the identity with the specified public key.
    # 
    # @param key the public key for the identity to be returned.
    # 
    # @return the identity with the given key, or null if there are
    # no identities in this scope with that key.
    def get_identity(key)
      raise NotImplementedError
    end
    
    typesig { [Identity] }
    # Adds an identity to this identity scope.
    # 
    # @param identity the identity to be added.
    # 
    # @exception KeyManagementException if the identity is not
    # valid, a name conflict occurs, another identity has the same
    # public key as the identity being added, or another exception
    # occurs.
    def add_identity(identity)
      raise NotImplementedError
    end
    
    typesig { [Identity] }
    # Removes an identity from this identity scope.
    # 
    # @param identity the identity to be removed.
    # 
    # @exception KeyManagementException if the identity is missing,
    # or another exception occurs.
    def remove_identity(identity)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an enumeration of all identities in this identity scope.
    # 
    # @return an enumeration of all identities in this identity scope.
    def identities
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a string representation of this identity scope, including
    # its name, its scope name, and the number of identities in this
    # identity scope.
    # 
    # @return a string representation of this identity scope.
    def to_s
      return RJava.cast_to_string(super) + "[" + RJava.cast_to_string(size) + "]"
    end
    
    class_module.module_eval {
      typesig { [String] }
      def check(directive)
        security = System.get_security_manager
        if (!(security).nil?)
          security.check_security_access(directive)
        end
      end
    }
    
    private
    alias_method :initialize__identity_scope, :initialize
  end
  
end

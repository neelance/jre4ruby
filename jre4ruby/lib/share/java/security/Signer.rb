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
  module SignerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
    }
  end
  
  # This class is used to represent an Identity that can also digitally
  # sign data.
  # 
  # <p>The management of a signer's private keys is an important and
  # sensitive issue that should be handled by subclasses as appropriate
  # to their intended use.
  # 
  # @see Identity
  # 
  # @author Benjamin Renaud
  # 
  # @deprecated This class is no longer used. Its functionality has been
  # replaced by <code>java.security.KeyStore</code>, the
  # <code>java.security.cert</code> package, and
  # <code>java.security.Principal</code>.
  class Signer < SignerImports.const_get :Identity
    include_class_members SignerImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -1763464102261361480 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The signer's private key.
    # 
    # @serial
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    typesig { [] }
    # Creates a signer. This constructor should only be used for
    # serialization.
    def initialize
      @private_key = nil
      super()
    end
    
    typesig { [String] }
    # Creates a signer with the specified identity name.
    # 
    # @param name the identity name.
    def initialize(name)
      @private_key = nil
      super(name)
    end
    
    typesig { [String, IdentityScope] }
    # Creates a signer with the specified identity name and scope.
    # 
    # @param name the identity name.
    # 
    # @param scope the scope of the identity.
    # 
    # @exception KeyManagementException if there is already an identity
    # with the same name in the scope.
    def initialize(name, scope)
      @private_key = nil
      super(name, scope)
    end
    
    typesig { [] }
    # Returns this signer's private key.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"getSignerPrivateKey"</code>
    # as its argument to see if it's ok to return the private key.
    # 
    # @return this signer's private key, or null if the private key has
    # not yet been set.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # returning the private key.
    # 
    # @see SecurityManager#checkSecurityAccess
    def get_private_key
      check("getSignerPrivateKey")
      return @private_key
    end
    
    typesig { [KeyPair] }
    # Sets the key pair (public key and private key) for this signer.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"setSignerKeyPair"</code>
    # as its argument to see if it's ok to set the key pair.
    # 
    # @param pair an initialized key pair.
    # 
    # @exception InvalidParameterException if the key pair is not
    # properly initialized.
    # @exception KeyException if the key pair cannot be set for any
    # other reason.
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # setting the key pair.
    # 
    # @see SecurityManager#checkSecurityAccess
    def set_key_pair(pair)
      check("setSignerKeyPair")
      pub = pair.get_public
      priv = pair.get_private
      if ((pub).nil? || (priv).nil?)
        raise InvalidParameterException.new
      end
      begin
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          local_class_in Signer
          include_class_members Signer
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            set_public_key(pub)
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue PrivilegedActionException => pae
        raise pae.get_exception
      end
      @private_key = priv
    end
    
    typesig { [] }
    def print_keys
      keys = ""
      public_key = get_public_key
      if (!(public_key).nil? && !(@private_key).nil?)
        keys = "\tpublic and private keys initialized"
      else
        keys = "\tno keys"
      end
      return keys
    end
    
    typesig { [] }
    # Returns a string of information about the signer.
    # 
    # @return a string of information about the signer.
    def to_s
      return "[Signer]" + RJava.cast_to_string(super)
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
    alias_method :initialize__signer, :initialize
  end
  
end

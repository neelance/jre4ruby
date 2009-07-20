require "rjava"

# Copyright 1996-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module SystemSignerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include ::Java::Security
    }
  end
  
  # SunSecurity signer. Like SystemIdentity, it has a trust bit, which
  # can be set by SunSecurity classes, and a set of accessors for other
  # classes in sun.security.*.
  # 
  # @author Benjamin Renaud
  class SystemSigner < SystemSignerImports.const_get :Signer
    include_class_members SystemSignerImports
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -2127743304301557711 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Is this signer trusted
    attr_accessor :trusted
    alias_method :attr_trusted, :trusted
    undef_method :trusted
    alias_method :attr_trusted=, :trusted=
    undef_method :trusted=
    
    typesig { [String] }
    # Construct a signer with a given name.
    def initialize(name)
      @trusted = false
      super(name)
      @trusted = false
    end
    
    typesig { [String, IdentityScope] }
    # Construct a signer with a name and a scope.
    # 
    # @param name the signer's name.
    # 
    # @param scope the scope for this signer.
    def initialize(name, scope)
      @trusted = false
      super(name, scope)
      @trusted = false
    end
    
    typesig { [::Java::Boolean] }
    # Set the trust status of this signer
    def set_trusted(trusted)
      @trusted = trusted
    end
    
    typesig { [] }
    # Returns true if this signer is trusted.
    def is_trusted
      return @trusted
    end
    
    typesig { [KeyPair] }
    # friendly callback for set keys
    def set_signer_key_pair(pair)
      set_key_pair(pair)
    end
    
    typesig { [] }
    # friendly callback for getting private keys
    def get_signer_private_key
      return get_private_key
    end
    
    typesig { [String] }
    def set_signer_info(s)
      set_info(s)
    end
    
    typesig { [Certificate] }
    # Call back method into a protected method for package friends.
    def add_signer_certificate(cert)
      add_certificate(cert)
    end
    
    typesig { [] }
    def clear_certificates
      certs = certificates
      i = 0
      while i < certs.attr_length
        remove_certificate(certs[i])
        i += 1
      end
    end
    
    typesig { [] }
    def to_s
      trusted_string = "not trusted"
      if (@trusted)
        trusted_string = "trusted"
      end
      return (super).to_s + "[" + trusted_string + "]"
    end
    
    private
    alias_method :initialize__system_signer, :initialize
  end
  
end

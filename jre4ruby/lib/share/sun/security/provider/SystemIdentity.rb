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
  module SystemIdentityImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Io, :Serializable
      include_const ::Java::Util, :Enumeration
      include ::Java::Security
    }
  end
  
  # An identity with a very simple trust mechanism.
  # 
  # @author      Benjamin Renaud
  class SystemIdentity < SystemIdentityImports.const_get :Identity
    include_class_members SystemIdentityImports
    overload_protected {
      include Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { 9060648952088498478 }
      const_attr_reader  :SerialVersionUID
    }
    
    # This should be changed to ACL
    attr_accessor :trusted
    alias_method :attr_trusted, :trusted
    undef_method :trusted
    alias_method :attr_trusted=, :trusted=
    undef_method :trusted=
    
    # Free form additional information about this identity.
    attr_accessor :info
    alias_method :attr_info, :info
    undef_method :info
    alias_method :attr_info=, :info=
    undef_method :info=
    
    typesig { [String, IdentityScope] }
    def initialize(name, scope)
      @trusted = false
      @info = nil
      super(name, scope)
      @trusted = false
    end
    
    typesig { [] }
    # Is this identity trusted by sun.* facilities?
    def is_trusted
      return @trusted
    end
    
    typesig { [::Java::Boolean] }
    # Set the trust status of this identity.
    def set_trusted(trusted)
      @trusted = trusted
    end
    
    typesig { [String] }
    def set_identity_info(info)
      Identity.instance_method(:set_info).bind(self).call(info)
    end
    
    typesig { [] }
    def get_indentity_info
      return Identity.instance_method(:get_info).bind(self).call
    end
    
    typesig { [PublicKey] }
    # Call back method into a protected method for package friends.
    def set_identity_public_key(key)
      set_public_key(key)
    end
    
    typesig { [Certificate] }
    # Call back method into a protected method for package friends.
    def add_identity_certificate(cert)
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
      return RJava.cast_to_string(super) + "[" + trusted_string + "]"
    end
    
    private
    alias_method :initialize__system_identity, :initialize
  end
  
end

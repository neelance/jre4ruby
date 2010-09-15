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
  module IdentityImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :Serializable
      include ::Java::Util
    }
  end
  
  # <p>This class represents identities: real-world objects such as people,
  # companies or organizations whose identities can be authenticated using
  # their public keys. Identities may also be more abstract (or concrete)
  # constructs, such as daemon threads or smart cards.
  # 
  # <p>All Identity objects have a name and a public key. Names are
  # immutable. Identities may also be scoped. That is, if an Identity is
  # specified to have a particular scope, then the name and public
  # key of the Identity are unique within that scope.
  # 
  # <p>An Identity also has a set of certificates (all certifying its own
  # public key). The Principal names specified in these certificates need
  # not be the same, only the key.
  # 
  # <p>An Identity can be subclassed, to include postal and email addresses,
  # telephone numbers, images of faces and logos, and so on.
  # 
  # @see IdentityScope
  # @see Signer
  # @see Principal
  # 
  # @author Benjamin Renaud
  # @deprecated This class is no longer used. Its functionality has been
  # replaced by <code>java.security.KeyStore</code>, the
  # <code>java.security.cert</code> package, and
  # <code>java.security.Principal</code>.
  class Identity 
    include_class_members IdentityImports
    include Principal
    include Serializable
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1.x for interoperability
      const_set_lazy(:SerialVersionUID) { 3609922007826600659 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The name for this identity.
    # 
    # @serial
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # The public key for this identity.
    # 
    # @serial
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    # Generic, descriptive information about the identity.
    # 
    # @serial
    attr_accessor :info
    alias_method :attr_info, :info
    undef_method :info
    alias_method :attr_info=, :info=
    undef_method :info=
    
    # The scope of the identity.
    # 
    # @serial
    attr_accessor :scope
    alias_method :attr_scope, :scope
    undef_method :scope
    alias_method :attr_scope=, :scope=
    undef_method :scope=
    
    # The certificates for this identity.
    # 
    # @serial
    attr_accessor :certificates
    alias_method :attr_certificates, :certificates
    undef_method :certificates
    alias_method :attr_certificates=, :certificates=
    undef_method :certificates=
    
    typesig { [] }
    # Constructor for serialization only.
    def initialize
      initialize__identity("restoring...")
    end
    
    typesig { [String, IdentityScope] }
    # Constructs an identity with the specified name and scope.
    # 
    # @param name the identity name.
    # @param scope the scope of the identity.
    # 
    # @exception KeyManagementException if there is already an identity
    # with the same name in the scope.
    def initialize(name, scope)
      initialize__identity(name)
      if (!(scope).nil?)
        scope.add_identity(self)
      end
      @scope = scope
    end
    
    typesig { [String] }
    # Constructs an identity with the specified name and no scope.
    # 
    # @param name the identity name.
    def initialize(name)
      @name = nil
      @public_key = nil
      @info = "No further information available."
      @scope = nil
      @certificates = nil
      @name = name
    end
    
    typesig { [] }
    # Returns this identity's name.
    # 
    # @return the name of this identity.
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns this identity's scope.
    # 
    # @return the scope of this identity.
    def get_scope
      return @scope
    end
    
    typesig { [] }
    # Returns this identity's public key.
    # 
    # @return the public key for this identity.
    # 
    # @see #setPublicKey
    def get_public_key
      return @public_key
    end
    
    typesig { [PublicKey] }
    # Sets this identity's public key. The old key and all of this
    # identity's certificates are removed by this operation.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"setIdentityPublicKey"</code>
    # as its argument to see if it's ok to set the public key.
    # 
    # @param key the public key for this identity.
    # 
    # @exception KeyManagementException if another identity in the
    # identity's scope has the same public key, or if another exception occurs.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # setting the public key.
    # 
    # @see #getPublicKey
    # @see SecurityManager#checkSecurityAccess
    # 
    # Should we throw an exception if this is already set?
    def set_public_key(key)
      check("setIdentityPublicKey")
      @public_key = key
      @certificates = Vector.new
    end
    
    typesig { [String] }
    # Specifies a general information string for this identity.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"setIdentityInfo"</code>
    # as its argument to see if it's ok to specify the information string.
    # 
    # @param info the information string.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # setting the information string.
    # 
    # @see #getInfo
    # @see SecurityManager#checkSecurityAccess
    def set_info(info)
      check("setIdentityInfo")
      @info = info
    end
    
    typesig { [] }
    # Returns general information previously specified for this identity.
    # 
    # @return general information about this identity.
    # 
    # @see #setInfo
    def get_info
      return @info
    end
    
    typesig { [Certificate] }
    # Adds a certificate for this identity. If the identity has a public
    # key, the public key in the certificate must be the same, and if
    # the identity does not have a public key, the identity's
    # public key is set to be that specified in the certificate.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"addIdentityCertificate"</code>
    # as its argument to see if it's ok to add a certificate.
    # 
    # @param certificate the certificate to be added.
    # 
    # @exception KeyManagementException if the certificate is not valid,
    # if the public key in the certificate being added conflicts with
    # this identity's public key, or if another exception occurs.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # adding a certificate.
    # 
    # @see SecurityManager#checkSecurityAccess
    def add_certificate(certificate)
      check("addIdentityCertificate")
      if ((@certificates).nil?)
        @certificates = Vector.new
      end
      if (!(@public_key).nil?)
        if (!key_equals(@public_key, certificate.get_public_key))
          raise KeyManagementException.new("public key different from cert public key")
        end
      else
        @public_key = certificate.get_public_key
      end
      @certificates.add_element(certificate)
    end
    
    typesig { [Key, Key] }
    def key_equals(a_key, another_key)
      a_key_format = a_key.get_format
      another_key_format = another_key.get_format
      if (((a_key_format).nil?) ^ ((another_key_format).nil?))
        return false
      end
      if (!(a_key_format).nil? && !(another_key_format).nil?)
        if (!a_key_format.equals_ignore_case(another_key_format))
          return false
        end
      end
      return Java::Util::Arrays.==(a_key.get_encoded, another_key.get_encoded)
    end
    
    typesig { [Certificate] }
    # Removes a certificate from this identity.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"removeIdentityCertificate"</code>
    # as its argument to see if it's ok to remove a certificate.
    # 
    # @param certificate the certificate to be removed.
    # 
    # @exception KeyManagementException if the certificate is
    # missing, or if another exception occurs.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # removing a certificate.
    # 
    # @see SecurityManager#checkSecurityAccess
    def remove_certificate(certificate)
      check("removeIdentityCertificate")
      if (!(@certificates).nil?)
        @certificates.remove_element(certificate)
      end
    end
    
    typesig { [] }
    # Returns a copy of all the certificates for this identity.
    # 
    # @return a copy of all the certificates for this identity.
    def certificates
      if ((@certificates).nil?)
        return Array.typed(Certificate).new(0) { nil }
      end
      len = @certificates.size
      certs = Array.typed(Certificate).new(len) { nil }
      @certificates.copy_into(certs)
      return certs
    end
    
    typesig { [Object] }
    # Tests for equality between the specified object and this identity.
    # This first tests to see if the entities actually refer to the same
    # object, in which case it returns true. Next, it checks to see if
    # the entities have the same name and the same scope. If they do,
    # the method returns true. Otherwise, it calls
    # {@link #identityEquals(Identity) identityEquals}, which subclasses should
    # override.
    # 
    # @param identity the object to test for equality with this identity.
    # 
    # @return true if the objects are considered equal, false otherwise.
    # 
    # @see #identityEquals
    def ==(identity)
      if ((identity).equal?(self))
        return true
      end
      if (identity.is_a?(Identity))
        i = identity
        if ((self.full_name == i.full_name))
          return true
        else
          return identity_equals(i)
        end
      end
      return false
    end
    
    typesig { [Identity] }
    # Tests for equality between the specified identity and this identity.
    # This method should be overriden by subclasses to test for equality.
    # The default behavior is to return true if the names and public keys
    # are equal.
    # 
    # @param identity the identity to test for equality with this identity.
    # 
    # @return true if the identities are considered equal, false
    # otherwise.
    # 
    # @see #equals
    def identity_equals(identity)
      if (!@name.equals_ignore_case(identity.attr_name))
        return false
      end
      if (((@public_key).nil?) ^ ((identity.attr_public_key).nil?))
        return false
      end
      if (!(@public_key).nil? && !(identity.attr_public_key).nil?)
        if (!(@public_key == identity.attr_public_key))
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    # Returns a parsable name for identity: identityName.scopeName
    def full_name
      parsable = @name
      if (!(@scope).nil?)
        parsable += "." + RJava.cast_to_string(@scope.get_name)
      end
      return parsable
    end
    
    typesig { [] }
    # Returns a short string describing this identity, telling its
    # name and its scope (if any).
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"printIdentity"</code>
    # as its argument to see if it's ok to return the string.
    # 
    # @return information about this identity, such as its name and the
    # name of its scope (if any).
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # returning a string describing this identity.
    # 
    # @see SecurityManager#checkSecurityAccess
    def to_s
      check("printIdentity")
      printable = @name
      if (!(@scope).nil?)
        printable += "[" + RJava.cast_to_string(@scope.get_name) + "]"
      end
      return printable
    end
    
    typesig { [::Java::Boolean] }
    # Returns a string representation of this identity, with
    # optionally more details than that provided by the
    # <code>toString</code> method without any arguments.
    # 
    # <p>First, if there is a security manager, its <code>checkSecurityAccess</code>
    # method is called with <code>"printIdentity"</code>
    # as its argument to see if it's ok to return the string.
    # 
    # @param detailed whether or not to provide detailed information.
    # 
    # @return information about this identity. If <code>detailed</code>
    # is true, then this method returns more information than that
    # provided by the <code>toString</code> method without any arguments.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkSecurityAccess</code> method doesn't allow
    # returning a string describing this identity.
    # 
    # @see #toString
    # @see SecurityManager#checkSecurityAccess
    def to_s(detailed)
      out = to_s
      if (detailed)
        out += "\n"
        out += RJava.cast_to_string(print_keys)
        out += "\n" + RJava.cast_to_string(print_certificates)
        if (!(@info).nil?)
          out += "\n\t" + @info
        else
          out += "\n\tno additional information available."
        end
      end
      return out
    end
    
    typesig { [] }
    def print_keys
      key = ""
      if (!(@public_key).nil?)
        key = "\tpublic key initialized"
      else
        key = "\tno public key"
      end
      return key
    end
    
    typesig { [] }
    def print_certificates
      out = ""
      if ((@certificates).nil?)
        return "\tno certificates"
      else
        out += "\tcertificates: \n"
        i = 1
        @certificates.each do |cert|
          out += "\tcertificate " + RJava.cast_to_string(((i += 1) - 1)) + "\tfor  : " + RJava.cast_to_string(cert.get_principal) + "\n"
          out += "\t\t\tfrom : " + RJava.cast_to_string(cert.get_guarantor) + "\n"
        end
      end
      return out
    end
    
    typesig { [] }
    # Returns a hashcode for this identity.
    # 
    # @return a hashcode for this identity.
    def hash_code
      return @name.hash_code
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
    alias_method :initialize__identity, :initialize
  end
  
end

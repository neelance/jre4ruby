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
  module UnresolvedPermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Vector
      include ::Java::Lang::Reflect
      include ::Java::Security::Cert
    }
  end
  
  # The UnresolvedPermission class is used to hold Permissions that
  # were "unresolved" when the Policy was initialized.
  # An unresolved permission is one whose actual Permission class
  # does not yet exist at the time the Policy is initialized (see below).
  # 
  # <p>The policy for a Java runtime (specifying
  # which permissions are available for code from various principals)
  # is represented by a Policy object.
  # Whenever a Policy is initialized or refreshed, Permission objects of
  # appropriate classes are created for all permissions
  # allowed by the Policy.
  # 
  # <p>Many permission class types
  # referenced by the policy configuration are ones that exist
  # locally (i.e., ones that can be found on CLASSPATH).
  # Objects for such permissions can be instantiated during
  # Policy initialization. For example, it is always possible
  # to instantiate a java.io.FilePermission, since the
  # FilePermission class is found on the CLASSPATH.
  # 
  # <p>Other permission classes may not yet exist during Policy
  # initialization. For example, a referenced permission class may
  # be in a JAR file that will later be loaded.
  # For each such class, an UnresolvedPermission is instantiated.
  # Thus, an UnresolvedPermission is essentially a "placeholder"
  # containing information about the permission.
  # 
  # <p>Later, when code calls AccessController.checkPermission
  # on a permission of a type that was previously unresolved,
  # but whose class has since been loaded, previously-unresolved
  # permissions of that type are "resolved". That is,
  # for each such UnresolvedPermission, a new object of
  # the appropriate class type is instantiated, based on the
  # information in the UnresolvedPermission.
  # 
  # <p> To instantiate the new class, UnresolvedPermission assumes
  # the class provides a zero, one, and/or two-argument constructor.
  # The zero-argument constructor would be used to instantiate
  # a permission without a name and without actions.
  # A one-arg constructor is assumed to take a <code>String</code>
  # name as input, and a two-arg constructor is assumed to take a
  # <code>String</code> name and <code>String</code> actions
  # as input.  UnresolvedPermission may invoke a
  # constructor with a <code>null</code> name and/or actions.
  # If an appropriate permission constructor is not available,
  # the UnresolvedPermission is ignored and the relevant permission
  # will not be granted to executing code.
  # 
  # <p> The newly created permission object replaces the
  # UnresolvedPermission, which is removed.
  # 
  # <p> Note that the <code>getName</code> method for an
  # <code>UnresolvedPermission</code> returns the
  # <code>type</code> (class name) for the underlying permission
  # that has not been resolved.
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.security.Policy
  # 
  # 
  # @author Roland Schemers
  class UnresolvedPermission < UnresolvedPermissionImports.const_get :Permission
    include_class_members UnresolvedPermissionImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -4821973115467008846 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:Debug) { Sun::Security::Util::Debug.get_instance("policy,access", "UnresolvedPermission") }
      const_attr_reader  :Debug
    }
    
    # The class name of the Permission class that will be
    # created when this unresolved permission is resolved.
    # 
    # @serial
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    # The permission name.
    # 
    # @serial
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # The actions of the permission.
    # 
    # @serial
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    typesig { [String, String, String, Array.typed(Java::Security::Cert::Certificate)] }
    # Creates a new UnresolvedPermission containing the permission
    # information needed later to actually create a Permission of the
    # specified class, when the permission is resolved.
    # 
    # @param type the class name of the Permission class that will be
    # created when this unresolved permission is resolved.
    # @param name the name of the permission.
    # @param actions the actions of the permission.
    # @param certs the certificates the permission's class was signed with.
    # This is a list of certificate chains, where each chain is composed of a
    # signer certificate and optionally its supporting certificate chain.
    # Each chain is ordered bottom-to-top (i.e., with the signer certificate
    # first and the (root) certificate authority last). The signer
    # certificates are copied from the array. Subsequent changes to
    # the array will not affect this UnsolvedPermission.
    def initialize(type, name, actions, certs)
      @type = nil
      @name = nil
      @actions = nil
      @certs = nil
      super(type)
      if ((type).nil?)
        raise NullPointerException.new("type can't be null")
      end
      @type = type
      @name = name
      @actions = actions
      if (!(certs).nil?)
        # Extract the signer certs from the list of certificates.
        i = 0
        while i < certs.attr_length
          if (!(certs[i].is_a?(X509Certificate)))
            # there is no concept of signer certs, so we store the
            # entire cert array
            @certs = certs.clone
            break
          end
          i += 1
        end
        if ((@certs).nil?)
          # Go through the list of certs and see if all the certs are
          # signer certs.
          i_ = 0
          count = 0
          while (i_ < certs.attr_length)
            count += 1
            while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
              i_ += 1
            end
            i_ += 1
          end
          if ((count).equal?(certs.attr_length))
            # All the certs are signer certs, so we store the entire
            # array
            @certs = certs.clone
          end
          if ((@certs).nil?)
            # extract the signer certs
            signer_certs = ArrayList.new
            i_ = 0
            while (i_ < certs.attr_length)
              signer_certs.add(certs[i_])
              while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
                i_ += 1
              end
              i_ += 1
            end
            @certs = Array.typed(Java::Security::Cert::Certificate).new(signer_certs.size) { nil }
            signer_certs.to_array(@certs)
          end
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:PARAMS0) { Array.typed(Class).new([]) }
      const_attr_reader  :PARAMS0
      
      const_set_lazy(:PARAMS1) { Array.typed(Class).new([String.class]) }
      const_attr_reader  :PARAMS1
      
      const_set_lazy(:PARAMS2) { Array.typed(Class).new([String.class, String.class]) }
      const_attr_reader  :PARAMS2
    }
    
    typesig { [Permission, Array.typed(Java::Security::Cert::Certificate)] }
    # try and resolve this permission using the class loader of the permission
    # that was passed in.
    def resolve(p, certs)
      if (!(@certs).nil?)
        # if p wasn't signed, we don't have a match
        if ((certs).nil?)
          return nil
        end
        # all certs in this.certs must be present in certs
        match = false
        i = 0
        while i < @certs.attr_length
          match = false
          j = 0
          while j < certs.attr_length
            if ((@certs[i] == certs[j]))
              match = true
              break
            end
            j += 1
          end
          if (!match)
            return nil
          end
          i += 1
        end
      end
      begin
        pc = p.get_class
        if ((@name).nil? && (@actions).nil?)
          begin
            c = pc.get_constructor(PARAMS0)
            return c.new_instance(Array.typed(Object).new([]))
          rescue NoSuchMethodException => ne
            begin
              c_ = pc.get_constructor(PARAMS1)
              return c_.new_instance(Array.typed(Object).new([@name]))
            rescue NoSuchMethodException => ne1
              c__ = pc.get_constructor(PARAMS2)
              return c__.new_instance(Array.typed(Object).new([@name, @actions]))
            end
          end
        else
          if (!(@name).nil? && (@actions).nil?)
            begin
              c = pc.get_constructor(PARAMS1)
              return c.new_instance(Array.typed(Object).new([@name]))
            rescue NoSuchMethodException => ne
              c_ = pc.get_constructor(PARAMS2)
              return c_.new_instance(Array.typed(Object).new([@name, @actions]))
            end
          else
            c = pc.get_constructor(PARAMS2)
            return c.new_instance(Array.typed(Object).new([@name, @actions]))
          end
        end
      rescue NoSuchMethodException => nsme
        if (!(Debug).nil?)
          Debug.println("NoSuchMethodException:\n  could not find " + "proper constructor for " + @type)
          nsme.print_stack_trace
        end
        return nil
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println("unable to instantiate " + @name)
          e.print_stack_trace
        end
        return nil
      end
    end
    
    typesig { [Permission] }
    # This method always returns false for unresolved permissions.
    # That is, an UnresolvedPermission is never considered to
    # imply another permission.
    # 
    # @param p the permission to check against.
    # 
    # @return false.
    def implies(p)
      return false
    end
    
    typesig { [Object] }
    # Checks two UnresolvedPermission objects for equality.
    # Checks that <i>obj</i> is an UnresolvedPermission, and has
    # the same type (class) name, permission name, actions, and
    # certificates as this object.
    # 
    # <p> To determine certificate equality, this method only compares
    # actual signer certificates.  Supporting certificate chains
    # are not taken into consideration by this method.
    # 
    # @param obj the object we are testing for equality with this object.
    # 
    # @return true if obj is an UnresolvedPermission, and has the same
    # type (class) name, permission name, actions, and
    # certificates as this object.
    def equals(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(UnresolvedPermission)))
        return false
      end
      that = obj
      # check type
      if (!(@type == that.attr_type))
        return false
      end
      # check name
      if ((@name).nil?)
        if (!(that.attr_name).nil?)
          return false
        end
      else
        if (!(@name == that.attr_name))
          return false
        end
      end
      # check actions
      if ((@actions).nil?)
        if (!(that.attr_actions).nil?)
          return false
        end
      else
        if (!(@actions == that.attr_actions))
          return false
        end
      end
      # check certs
      if (((@certs).nil? && !(that.attr_certs).nil?) || (!(@certs).nil? && (that.attr_certs).nil?) || (!(@certs).nil? && !(that.attr_certs).nil? && !(@certs.attr_length).equal?(that.attr_certs.attr_length)))
        return false
      end
      i = 0
      j = 0
      match = false
      i = 0
      while !(@certs).nil? && i < @certs.attr_length
        match = false
        j = 0
        while j < that.attr_certs.attr_length
          if ((@certs[i] == that.attr_certs[j]))
            match = true
            break
          end
          j += 1
        end
        if (!match)
          return false
        end
        i += 1
      end
      i = 0
      while !(that.attr_certs).nil? && i < that.attr_certs.attr_length
        match = false
        j = 0
        while j < @certs.attr_length
          if ((that.attr_certs[i] == @certs[j]))
            match = true
            break
          end
          j += 1
        end
        if (!match)
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      hash = @type.hash_code
      if (!(@name).nil?)
        hash ^= @name.hash_code
      end
      if (!(@actions).nil?)
        hash ^= @actions.hash_code
      end
      return hash
    end
    
    typesig { [] }
    # Returns the canonical string representation of the actions,
    # which currently is the empty string "", since there are no actions for
    # an UnresolvedPermission. That is, the actions for the
    # permission that will be created when this UnresolvedPermission
    # is resolved may be non-null, but an UnresolvedPermission
    # itself is never considered to have any actions.
    # 
    # @return the empty string "".
    def get_actions
      return ""
    end
    
    typesig { [] }
    # Get the type (class name) of the underlying permission that
    # has not been resolved.
    # 
    # @return the type (class name) of the underlying permission that
    # has not been resolved
    # 
    # @since 1.5
    def get_unresolved_type
      return @type
    end
    
    typesig { [] }
    # Get the target name of the underlying permission that
    # has not been resolved.
    # 
    # @return the target name of the underlying permission that
    # has not been resolved, or <code>null</code>,
    # if there is no targe name
    # 
    # @since 1.5
    def get_unresolved_name
      return @name
    end
    
    typesig { [] }
    # Get the actions for the underlying permission that
    # has not been resolved.
    # 
    # @return the actions for the underlying permission that
    # has not been resolved, or <code>null</code>
    # if there are no actions
    # 
    # @since 1.5
    def get_unresolved_actions
      return @actions
    end
    
    typesig { [] }
    # Get the signer certificates (without any supporting chain)
    # for the underlying permission that has not been resolved.
    # 
    # @return the signer certificates for the underlying permission that
    # has not been resolved, or null, if there are no signer certificates.
    # Returns a new array each time this method is called.
    # 
    # @since 1.5
    def get_unresolved_certs
      return ((@certs).nil?) ? nil : @certs.clone
    end
    
    typesig { [] }
    # Returns a string describing this UnresolvedPermission.  The convention
    # is to specify the class name, the permission name, and the actions, in
    # the following format: '(unresolved "ClassName" "name" "actions")'.
    # 
    # @return information about this UnresolvedPermission.
    def to_s
      return "(unresolved " + @type + " " + @name + " " + @actions + ")"
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing
    # UnresolvedPermission  objects.
    # <p>
    # @return a new PermissionCollection object suitable for
    # storing UnresolvedPermissions.
    def new_permission_collection
      return UnresolvedPermissionCollection.new
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Writes this object out to a stream (i.e., serializes it).
    # 
    # @serialData An initial <code>String</code> denoting the
    # <code>type</code> is followed by a <code>String</code> denoting the
    # <code>name</code> is followed by a <code>String</code> denoting the
    # <code>actions</code> is followed by an <code>int</code> indicating the
    # number of certificates to follow
    # (a value of "zero" denotes that there are no certificates associated
    # with this object).
    # Each certificate is written out starting with a <code>String</code>
    # denoting the certificate type, followed by an
    # <code>int</code> specifying the length of the certificate encoding,
    # followed by the certificate encoding itself which is written out as an
    # array of bytes.
    def write_object(oos)
      oos.default_write_object
      if ((@certs).nil? || (@certs.attr_length).equal?(0))
        oos.write_int(0)
      else
        # write out the total number of certs
        oos.write_int(@certs.attr_length)
        # write out each cert, including its type
        i = 0
        while i < @certs.attr_length
          cert = @certs[i]
          begin
            oos.write_utf(cert.get_type)
            encoded = cert.get_encoded
            oos.write_int(encoded.attr_length)
            oos.write(encoded)
          rescue CertificateEncodingException => cee
            raise IOException.new(cee.get_message)
          end
          i += 1
        end
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Restores this object from a stream (i.e., deserializes it).
    def read_object(ois)
      cf = nil
      cfs = nil
      ois.default_read_object
      if ((@type).nil?)
        raise NullPointerException.new("type can't be null")
      end
      # process any new-style certs in the stream (if present)
      size_ = ois.read_int
      if (size_ > 0)
        # we know of 3 different cert types: X.509, PGP, SDSI, which
        # could all be present in the stream at the same time
        cfs = Hashtable.new(3)
        @certs = Array.typed(Java::Security::Cert::Certificate).new(size_) { nil }
      end
      i = 0
      while i < size_
        # read the certificate type, and instantiate a certificate
        # factory of that type (reuse existing factory if possible)
        cert_type = ois.read_utf
        if (cfs.contains_key(cert_type))
          # reuse certificate factory
          cf = cfs.get(cert_type)
        else
          # create new certificate factory
          begin
            cf = CertificateFactory.get_instance(cert_type)
          rescue CertificateException => ce
            raise ClassNotFoundException.new("Certificate factory for " + cert_type + " not found")
          end
          # store the certificate factory so we can reuse it later
          cfs.put(cert_type, cf)
        end
        # parse the certificate
        encoded = nil
        begin
          encoded = Array.typed(::Java::Byte).new(ois.read_int) { 0 }
        rescue OutOfMemoryError => oome
          raise IOException.new("Certificate too big")
        end
        ois.read_fully(encoded)
        bais = ByteArrayInputStream.new(encoded)
        begin
          @certs[i] = cf.generate_certificate(bais)
        rescue CertificateException => ce
          raise IOException.new(ce.get_message)
        end
        bais.close
        i += 1
      end
    end
    
    private
    alias_method :initialize__unresolved_permission, :initialize
  end
  
end

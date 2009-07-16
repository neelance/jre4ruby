require "rjava"

# 
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
  module SecureClassLoaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Net, :URL
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # 
  # This class extends ClassLoader with additional support for defining
  # classes with an associated code source and permissions which are
  # retrieved by the system policy by default.
  # 
  # @author  Li Gong
  # @author  Roland Schemers
  class SecureClassLoader < SecureClassLoaderImports.const_get :ClassLoader
    include_class_members SecureClassLoaderImports
    
    # 
    # If initialization succeed this is set to true and security checks will
    # succeed. Otherwise the object is not initialized and the object is
    # useless.
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    # HashMap that maps CodeSource to ProtectionDomain
    attr_accessor :pdcache
    alias_method :attr_pdcache, :pdcache
    undef_method :pdcache
    alias_method :attr_pdcache=, :pdcache=
    undef_method :pdcache=
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("scl") }
      const_attr_reader  :Debug
    }
    
    typesig { [ClassLoader] }
    # 
    # Creates a new SecureClassLoader using the specified parent
    # class loader for delegation.
    # 
    # <p>If there is a security manager, this method first
    # calls the security manager's <code>checkCreateClassLoader</code>
    # method  to ensure creation of a class loader is allowed.
    # <p>
    # @param parent the parent ClassLoader
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkCreateClassLoader</code> method doesn't allow
    # creation of a class loader.
    # @see SecurityManager#checkCreateClassLoader
    def initialize(parent)
      @initialized = false
      @pdcache = nil
      super(parent)
      @initialized = false
      @pdcache = HashMap.new(11)
      # this is to make the stack depth consistent with 1.1
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @initialized = true
    end
    
    typesig { [] }
    # 
    # Creates a new SecureClassLoader using the default parent class
    # loader for delegation.
    # 
    # <p>If there is a security manager, this method first
    # calls the security manager's <code>checkCreateClassLoader</code>
    # method  to ensure creation of a class loader is allowed.
    # 
    # @exception  SecurityException  if a security manager exists and its
    # <code>checkCreateClassLoader</code> method doesn't allow
    # creation of a class loader.
    # @see SecurityManager#checkCreateClassLoader
    def initialize
      @initialized = false
      @pdcache = nil
      super()
      @initialized = false
      @pdcache = HashMap.new(11)
      # this is to make the stack depth consistent with 1.1
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @initialized = true
    end
    
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, CodeSource] }
    # 
    # Converts an array of bytes into an instance of class Class,
    # with an optional CodeSource. Before the
    # class can be used it must be resolved.
    # <p>
    # If a non-null CodeSource is supplied a ProtectionDomain is
    # constructed and associated with the class being defined.
    # <p>
    # @param      name the expected name of the class, or <code>null</code>
    # if not known, using '.' and not '/' as the separator
    # and without a trailing ".class" suffix.
    # @param      b    the bytes that make up the class data. The bytes in
    # positions <code>off</code> through <code>off+len-1</code>
    # should have the format of a valid class file as defined
    # by the
    # <a href="http://java.sun.com/docs/books/vmspec/">Java
    # Virtual Machine Specification</a>.
    # @param      off  the start offset in <code>b</code> of the class data
    # @param      len  the length of the class data
    # @param      cs   the associated CodeSource, or <code>null</code> if none
    # @return the <code>Class</code> object created from the data,
    # and optional CodeSource.
    # @exception  ClassFormatError if the data did not contain a valid class
    # @exception  IndexOutOfBoundsException if either <code>off</code> or
    # <code>len</code> is negative, or if
    # <code>off+len</code> is greater than <code>b.length</code>.
    # 
    # @exception  SecurityException if an attempt is made to add this class
    # to a package that contains classes that were signed by
    # a different set of certificates than this class, or if
    # the class name begins with "java.".
    def define_class(name, b, off, len, cs)
      if ((cs).nil?)
        return define_class(name, b, off, len)
      else
        return define_class(name, b, off, len, get_protection_domain(cs))
      end
    end
    
    typesig { [String, Java::Nio::ByteBuffer, CodeSource] }
    # 
    # Converts a {@link java.nio.ByteBuffer <tt>ByteBuffer</tt>}
    # into an instance of class <tt>Class</tt>, with an optional CodeSource.
    # Before the class can be used it must be resolved.
    # <p>
    # If a non-null CodeSource is supplied a ProtectionDomain is
    # constructed and associated with the class being defined.
    # <p>
    # @param      name the expected name of the class, or <code>null</code>
    # if not known, using '.' and not '/' as the separator
    # and without a trailing ".class" suffix.
    # @param      b    the bytes that make up the class data.  The bytes from positions
    # <tt>b.position()</tt> through <tt>b.position() + b.limit() -1</tt>
    # should have the format of a valid class file as defined by the
    # <a href="http://java.sun.com/docs/books/vmspec/">Java Virtual
    # Machine Specification</a>.
    # @param      cs   the associated CodeSource, or <code>null</code> if none
    # @return the <code>Class</code> object created from the data,
    # and optional CodeSource.
    # @exception  ClassFormatError if the data did not contain a valid class
    # @exception  SecurityException if an attempt is made to add this class
    # to a package that contains classes that were signed by
    # a different set of certificates than this class, or if
    # the class name begins with "java.".
    # 
    # @since  1.5
    def define_class(name, b, cs)
      if ((cs).nil?)
        return define_class(name, b, nil)
      else
        return define_class(name, b, get_protection_domain(cs))
      end
    end
    
    typesig { [CodeSource] }
    # 
    # Returns the permissions for the given CodeSource object.
    # <p>
    # This method is invoked by the defineClass method which takes
    # a CodeSource as an argument when it is constructing the
    # ProtectionDomain for the class being defined.
    # <p>
    # @param codesource the codesource.
    # 
    # @return the permissions granted to the codesource.
    def get_permissions(codesource)
      check
      return Permissions.new # ProtectionDomain defers the binding
    end
    
    typesig { [CodeSource] }
    # 
    # Returned cached ProtectionDomain for the specified CodeSource.
    def get_protection_domain(cs)
      if ((cs).nil?)
        return nil
      end
      pd = nil
      synchronized((@pdcache)) do
        pd = @pdcache.get(cs)
        if ((pd).nil?)
          perms = get_permissions(cs)
          pd = ProtectionDomain.new(cs, perms, self, nil)
          if (!(pd).nil?)
            @pdcache.put(cs, pd)
            if (!(Debug).nil?)
              Debug.println(" getPermissions " + (pd).to_s)
              Debug.println("")
            end
          end
        end
      end
      return pd
    end
    
    typesig { [] }
    # 
    # Check to make sure the class loader has been initialized.
    def check
      if (!@initialized)
        raise SecurityException.new("ClassLoader object not initialized")
      end
    end
    
    private
    alias_method :initialize__secure_class_loader, :initialize
  end
  
end

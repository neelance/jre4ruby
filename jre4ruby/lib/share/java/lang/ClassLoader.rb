require "rjava"

# Copyright 1994-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module ClassLoaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :CodeSource
      include_const ::Java::Security, :Policy
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :ProtectionDomain
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Stack
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :Vector
      include_const ::Sun::Misc, :ClassFileTransformer
      include_const ::Sun::Misc, :CompoundEnumeration
      include_const ::Sun::Misc, :Resource
      include_const ::Sun::Misc, :URLClassPath
      include_const ::Sun::Misc, :VM
      include_const ::Sun::Reflect, :Reflection
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # A class loader is an object that is responsible for loading classes. The
  # class <tt>ClassLoader</tt> is an abstract class.  Given the <a
  # href="#name">binary name</a> of a class, a class loader should attempt to
  # locate or generate data that constitutes a definition for the class.  A
  # typical strategy is to transform the name into a file name and then read a
  # "class file" of that name from a file system.
  # 
  # <p> Every {@link Class <tt>Class</tt>} object contains a {@link
  # Class#getClassLoader() reference} to the <tt>ClassLoader</tt> that defined
  # it.
  # 
  # <p> <tt>Class</tt> objects for array classes are not created by class
  # loaders, but are created automatically as required by the Java runtime.
  # The class loader for an array class, as returned by {@link
  # Class#getClassLoader()} is the same as the class loader for its element
  # type; if the element type is a primitive type, then the array class has no
  # class loader.
  # 
  # <p> Applications implement subclasses of <tt>ClassLoader</tt> in order to
  # extend the manner in which the Java virtual machine dynamically loads
  # classes.
  # 
  # <p> Class loaders may typically be used by security managers to indicate
  # security domains.
  # 
  # <p> The <tt>ClassLoader</tt> class uses a delegation model to search for
  # classes and resources.  Each instance of <tt>ClassLoader</tt> has an
  # associated parent class loader.  When requested to find a class or
  # resource, a <tt>ClassLoader</tt> instance will delegate the search for the
  # class or resource to its parent class loader before attempting to find the
  # class or resource itself.  The virtual machine's built-in class loader,
  # called the "bootstrap class loader", does not itself have a parent but may
  # serve as the parent of a <tt>ClassLoader</tt> instance.
  # 
  # <p> Normally, the Java virtual machine loads classes from the local file
  # system in a platform-dependent manner.  For example, on UNIX systems, the
  # virtual machine loads classes from the directory defined by the
  # <tt>CLASSPATH</tt> environment variable.
  # 
  # <p> However, some classes may not originate from a file; they may originate
  # from other sources, such as the network, or they could be constructed by an
  # application.  The method {@link #defineClass(String, byte[], int, int)
  # <tt>defineClass</tt>} converts an array of bytes into an instance of class
  # <tt>Class</tt>. Instances of this newly defined class can be created using
  # {@link Class#newInstance <tt>Class.newInstance</tt>}.
  # 
  # <p> The methods and constructors of objects created by a class loader may
  # reference other classes.  To determine the class(es) referred to, the Java
  # virtual machine invokes the {@link #loadClass <tt>loadClass</tt>} method of
  # the class loader that originally created the class.
  # 
  # <p> For example, an application could create a network class loader to
  # download class files from a server.  Sample code might look like:
  # 
  # <blockquote><pre>
  # ClassLoader loader&nbsp;= new NetworkClassLoader(host,&nbsp;port);
  # Object main&nbsp;= loader.loadClass("Main", true).newInstance();
  # &nbsp;.&nbsp;.&nbsp;.
  # </pre></blockquote>
  # 
  # <p> The network class loader subclass must define the methods {@link
  # #findClass <tt>findClass</tt>} and <tt>loadClassData</tt> to load a class
  # from the network.  Once it has downloaded the bytes that make up the class,
  # it should use the method {@link #defineClass <tt>defineClass</tt>} to
  # create a class instance.  A sample implementation is:
  # 
  # <blockquote><pre>
  # class NetworkClassLoader extends ClassLoader {
  # String host;
  # int port;
  # 
  # public Class findClass(String name) {
  # byte[] b = loadClassData(name);
  # return defineClass(name, b, 0, b.length);
  # }
  # 
  # private byte[] loadClassData(String name) {
  # // load the class data from the connection
  # &nbsp;.&nbsp;.&nbsp;.
  # }
  # }
  # </pre></blockquote>
  # 
  # <h4> <a name="name">Binary names</a> </h4>
  # 
  # <p> Any class name provided as a {@link String} parameter to methods in
  # <tt>ClassLoader</tt> must be a binary name as defined by the <a
  # href="http://java.sun.com/docs/books/jls/">Java Language Specification</a>.
  # 
  # <p> Examples of valid class names include:
  # <blockquote><pre>
  # "java.lang.String"
  # "javax.swing.JSpinner$DefaultEditor"
  # "java.security.KeyStore$Builder$FileBuilder$1"
  # "java.net.URLClassLoader$3$1"
  # </pre></blockquote>
  # 
  # @see      #resolveClass(Class)
  # @since 1.0
  class ClassLoader 
    include_class_members ClassLoaderImports
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_lang_ClassLoader_registerNatives, [:pointer, :long], :void
      typesig { [] }
      def register_natives
        JNI.call_native_method(:Java_java_lang_ClassLoader_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
      end
    }
    
    # If initialization succeed this is set to true and security checks will
    # succeed.  Otherwise the object is not initialized and the object is
    # useless.
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    # The parent class loader for delegation
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # Hashtable that maps packages to certs
    attr_accessor :package2certs
    alias_method :attr_package2certs, :package2certs
    undef_method :package2certs
    alias_method :attr_package2certs=, :package2certs=
    undef_method :package2certs=
    
    # Shared among all packages with unsigned classes
    attr_accessor :nocerts
    alias_method :attr_nocerts, :nocerts
    undef_method :nocerts
    alias_method :attr_nocerts=, :nocerts=
    undef_method :nocerts=
    
    # The classes loaded by this class loader.  The only purpose of this table
    # is to keep the classes from being GC'ed until the loader is GC'ed.
    attr_accessor :classes
    alias_method :attr_classes, :classes
    undef_method :classes
    alias_method :attr_classes=, :classes=
    undef_method :classes=
    
    # The initiating protection domains for all classes loaded by this loader
    attr_accessor :domains
    alias_method :attr_domains, :domains
    undef_method :domains
    alias_method :attr_domains=, :domains=
    undef_method :domains=
    
    typesig { [Class] }
    # Invoked by the VM to record every loaded class with this loader.
    def add_class(c)
      @classes.add_element(c)
    end
    
    # The packages defined in this class loader.  Each package name is mapped
    # to its corresponding Package object.
    attr_accessor :packages
    alias_method :attr_packages, :packages
    undef_method :packages
    alias_method :attr_packages=, :packages=
    undef_method :packages=
    
    typesig { [ClassLoader] }
    # Creates a new class loader using the specified parent class loader for
    # delegation.
    # 
    # <p> If there is a security manager, its {@link
    # SecurityManager#checkCreateClassLoader()
    # <tt>checkCreateClassLoader</tt>} method is invoked.  This may result in
    # a security exception.  </p>
    # 
    # @param  parent
    # The parent class loader
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # <tt>checkCreateClassLoader</tt> method doesn't allow creation
    # of a new class loader.
    # 
    # @since  1.2
    def initialize(parent)
      @initialized = false
      @parent = nil
      @package2certs = Hashtable.new(11)
      @nocerts = nil
      @classes = Vector.new
      @domains = HashSet.new
      @packages = HashMap.new
      @default_domain = nil
      @native_libraries = Vector.new
      @default_assertion_status = false
      @package_assertion_status = nil
      @class_assertion_status = nil
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @parent = parent
      @initialized = true
    end
    
    typesig { [] }
    # Creates a new class loader using the <tt>ClassLoader</tt> returned by
    # the method {@link #getSystemClassLoader()
    # <tt>getSystemClassLoader()</tt>} as the parent class loader.
    # 
    # <p> If there is a security manager, its {@link
    # SecurityManager#checkCreateClassLoader()
    # <tt>checkCreateClassLoader</tt>} method is invoked.  This may result in
    # a security exception.  </p>
    # 
    # @throws  SecurityException
    # If a security manager exists and its
    # <tt>checkCreateClassLoader</tt> method doesn't allow creation
    # of a new class loader.
    def initialize
      @initialized = false
      @parent = nil
      @package2certs = Hashtable.new(11)
      @nocerts = nil
      @classes = Vector.new
      @domains = HashSet.new
      @packages = HashMap.new
      @default_domain = nil
      @native_libraries = Vector.new
      @default_assertion_status = false
      @package_assertion_status = nil
      @class_assertion_status = nil
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_create_class_loader
      end
      @parent = get_system_class_loader
      @initialized = true
    end
    
    typesig { [String] }
    # -- Class --
    # 
    # Loads the class with the specified <a href="#name">binary name</a>.
    # This method searches for classes in the same manner as the {@link
    # #loadClass(String, boolean)} method.  It is invoked by the Java virtual
    # machine to resolve class references.  Invoking this method is equivalent
    # to invoking {@link #loadClass(String, boolean) <tt>loadClass(name,
    # false)</tt>}.  </p>
    # 
    # @param  name
    # The <a href="#name">binary name</a> of the class
    # 
    # @return  The resulting <tt>Class</tt> object
    # 
    # @throws  ClassNotFoundException
    # If the class was not found
    def load_class(name)
      return load_class(name, false)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Loads the class with the specified <a href="#name">binary name</a>.  The
    # default implementation of this method searches for classes in the
    # following order:
    # 
    # <p><ol>
    # 
    # <li><p> Invoke {@link #findLoadedClass(String)} to check if the class
    # has already been loaded.  </p></li>
    # 
    # <li><p> Invoke the {@link #loadClass(String) <tt>loadClass</tt>} method
    # on the parent class loader.  If the parent is <tt>null</tt> the class
    # loader built-in to the virtual machine is used, instead.  </p></li>
    # 
    # <li><p> Invoke the {@link #findClass(String)} method to find the
    # class.  </p></li>
    # 
    # </ol>
    # 
    # <p> If the class was found using the above steps, and the
    # <tt>resolve</tt> flag is true, this method will then invoke the {@link
    # #resolveClass(Class)} method on the resulting <tt>Class</tt> object.
    # 
    # <p> Subclasses of <tt>ClassLoader</tt> are encouraged to override {@link
    # #findClass(String)}, rather than this method.  </p>
    # 
    # @param  name
    # The <a href="#name">binary name</a> of the class
    # 
    # @param  resolve
    # If <tt>true</tt> then resolve the class
    # 
    # @return  The resulting <tt>Class</tt> object
    # 
    # @throws  ClassNotFoundException
    # If the class could not be found
    def load_class(name, resolve)
      synchronized(self) do
        # First, check if the class has already been loaded
        c = find_loaded_class(name)
        if ((c).nil?)
          begin
            if (!(@parent).nil?)
              c = @parent.load_class(name, false)
            else
              c = find_bootstrap_class0(name)
            end
          rescue ClassNotFoundException => e
            # If still not found, then invoke findClass in order
            # to find the class.
            c = find_class(name)
          end
        end
        if (resolve)
          resolve_class(c)
        end
        return c
      end
    end
    
    typesig { [String] }
    # This method is invoked by the virtual machine to load a class.
    def load_class_internal(name)
      synchronized(self) do
        return load_class(name)
      end
    end
    
    typesig { [Class, ProtectionDomain] }
    def check_package_access(cls, pd)
      sm = System.get_security_manager
      if (!(sm).nil?)
        name = cls.get_name
        i = name.last_index_of(Character.new(?..ord))
        if (!(i).equal?(-1))
          AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ClassLoader
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              sm.check_package_access(name.substring(0, i))
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self), AccessControlContext.new(Array.typed(ProtectionDomain).new([pd])))
        end
      end
      @domains.add(pd)
    end
    
    typesig { [String] }
    # Finds the class with the specified <a href="#name">binary name</a>.
    # This method should be overridden by class loader implementations that
    # follow the delegation model for loading classes, and will be invoked by
    # the {@link #loadClass <tt>loadClass</tt>} method after checking the
    # parent class loader for the requested class.  The default implementation
    # throws a <tt>ClassNotFoundException</tt>.  </p>
    # 
    # @param  name
    # The <a href="#name">binary name</a> of the class
    # 
    # @return  The resulting <tt>Class</tt> object
    # 
    # @throws  ClassNotFoundException
    # If the class could not be found
    # 
    # @since  1.2
    def find_class(name)
      raise ClassNotFoundException.new(name)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Converts an array of bytes into an instance of class <tt>Class</tt>.
    # Before the <tt>Class</tt> can be used it must be resolved.  This method
    # is deprecated in favor of the version that takes a <a
    # href="#name">binary name</a> as its first argument, and is more secure.
    # 
    # @param  b
    # The bytes that make up the class data.  The bytes in positions
    # <tt>off</tt> through <tt>off+len-1</tt> should have the format
    # of a valid class file as defined by the <a
    # href="http://java.sun.com/docs/books/vmspec/">Java Virtual
    # Machine Specification</a>.
    # 
    # @param  off
    # The start offset in <tt>b</tt> of the class data
    # 
    # @param  len
    # The length of the class data
    # 
    # @return  The <tt>Class</tt> object that was created from the specified
    # class data
    # 
    # @throws  ClassFormatError
    # If the data did not contain a valid class
    # 
    # @throws  IndexOutOfBoundsException
    # If either <tt>off</tt> or <tt>len</tt> is negative, or if
    # <tt>off+len</tt> is greater than <tt>b.length</tt>.
    # 
    # @see  #loadClass(String, boolean)
    # @see  #resolveClass(Class)
    # 
    # @deprecated  Replaced by {@link #defineClass(String, byte[], int, int)
    # defineClass(String, byte[], int, int)}
    def define_class(b, off, len)
      return define_class(nil, b, off, len, nil)
    end
    
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Converts an array of bytes into an instance of class <tt>Class</tt>.
    # Before the <tt>Class</tt> can be used it must be resolved.
    # 
    # <p> This method assigns a default {@link java.security.ProtectionDomain
    # <tt>ProtectionDomain</tt>} to the newly defined class.  The
    # <tt>ProtectionDomain</tt> is effectively granted the same set of
    # permissions returned when {@link
    # java.security.Policy#getPermissions(java.security.CodeSource)
    # <tt>Policy.getPolicy().getPermissions(new CodeSource(null, null))</tt>}
    # is invoked.  The default domain is created on the first invocation of
    # {@link #defineClass(String, byte[], int, int) <tt>defineClass</tt>},
    # and re-used on subsequent invocations.
    # 
    # <p> To assign a specific <tt>ProtectionDomain</tt> to the class, use
    # the {@link #defineClass(String, byte[], int, int,
    # java.security.ProtectionDomain) <tt>defineClass</tt>} method that takes a
    # <tt>ProtectionDomain</tt> as one of its arguments.  </p>
    # 
    # @param  name
    # The expected <a href="#name">binary name</a> of the class, or
    # <tt>null</tt> if not known
    # 
    # @param  b
    # The bytes that make up the class data.  The bytes in positions
    # <tt>off</tt> through <tt>off+len-1</tt> should have the format
    # of a valid class file as defined by the <a
    # href="http://java.sun.com/docs/books/vmspec/">Java Virtual
    # Machine Specification</a>.
    # 
    # @param  off
    # The start offset in <tt>b</tt> of the class data
    # 
    # @param  len
    # The length of the class data
    # 
    # @return  The <tt>Class</tt> object that was created from the specified
    # class data.
    # 
    # @throws  ClassFormatError
    # If the data did not contain a valid class
    # 
    # @throws  IndexOutOfBoundsException
    # If either <tt>off</tt> or <tt>len</tt> is negative, or if
    # <tt>off+len</tt> is greater than <tt>b.length</tt>.
    # 
    # @throws  SecurityException
    # If an attempt is made to add this class to a package that
    # contains classes that were signed by a different set of
    # certificates than this class (which is unsigned), or if
    # <tt>name</tt> begins with "<tt>java.</tt>".
    # 
    # @see  #loadClass(String, boolean)
    # @see  #resolveClass(Class)
    # @see  java.security.CodeSource
    # @see  java.security.SecureClassLoader
    # 
    # @since  1.1
    def define_class(name, b, off, len)
      return define_class(name, b, off, len, nil)
    end
    
    typesig { [String, ProtectionDomain] }
    # Determine protection domain, and check that:
    # - not define java.* class,
    # - signer of this class matches signers for the rest of the classes in package.
    def pre_define_class(name, protection_domain)
      if (!check_name(name))
        raise NoClassDefFoundError.new("IllegalName: " + name)
      end
      if ((!(name).nil?) && name.starts_with("java."))
        raise SecurityException.new("Prohibited package name: " + RJava.cast_to_string(name.substring(0, name.last_index_of(Character.new(?..ord)))))
      end
      if ((protection_domain).nil?)
        protection_domain = get_default_domain
      end
      if (!(name).nil?)
        check_certs(name, protection_domain.get_code_source)
      end
      return protection_domain
    end
    
    typesig { [ProtectionDomain] }
    def define_class_source_location(protection_domain)
      cs = protection_domain.get_code_source
      source = nil
      if (!(cs).nil? && !(cs.get_location).nil?)
        source = RJava.cast_to_string(cs.get_location.to_s)
      end
      return source
    end
    
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ProtectionDomain, ClassFormatError, String] }
    def define_transformed_class(name, b, off, len, protection_domain, cfe, source)
      # Class format error - try to transform the bytecode and
      # define the class again
      transformers = ClassFileTransformer.get_transformers
      c = nil
      i = 0
      while !(transformers).nil? && i < transformers.attr_length
        begin
          # Transform byte code using transformer
          tb = (transformers[i]).transform(b, off, len)
          c = define_class1(name, tb, 0, tb.attr_length, protection_domain, source)
          break
        rescue ClassFormatError => cfe2
          # If ClassFormatError occurs, try next transformer
        end
        i += 1
      end
      # Rethrow original ClassFormatError if unable to transform
      # bytecode to well-formed
      if ((c).nil?)
        raise cfe
      end
      return c
    end
    
    typesig { [Class, ProtectionDomain] }
    def post_define_class(c, protection_domain)
      if (!(protection_domain.get_code_source).nil?)
        certs = protection_domain.get_code_source.get_certificates
        if (!(certs).nil?)
          set_signers(c, certs)
        end
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ProtectionDomain] }
    # Converts an array of bytes into an instance of class <tt>Class</tt>,
    # with an optional <tt>ProtectionDomain</tt>.  If the domain is
    # <tt>null</tt>, then a default domain will be assigned to the class as
    # specified in the documentation for {@link #defineClass(String, byte[],
    # int, int)}.  Before the class can be used it must be resolved.
    # 
    # <p> The first class defined in a package determines the exact set of
    # certificates that all subsequent classes defined in that package must
    # contain.  The set of certificates for a class is obtained from the
    # {@link java.security.CodeSource <tt>CodeSource</tt>} within the
    # <tt>ProtectionDomain</tt> of the class.  Any classes added to that
    # package must contain the same set of certificates or a
    # <tt>SecurityException</tt> will be thrown.  Note that if
    # <tt>name</tt> is <tt>null</tt>, this check is not performed.
    # You should always pass in the <a href="#name">binary name</a> of the
    # class you are defining as well as the bytes.  This ensures that the
    # class you are defining is indeed the class you think it is.
    # 
    # <p> The specified <tt>name</tt> cannot begin with "<tt>java.</tt>", since
    # all classes in the "<tt>java.*</tt> packages can only be defined by the
    # bootstrap class loader.  If <tt>name</tt> is not <tt>null</tt>, it
    # must be equal to the <a href="#name">binary name</a> of the class
    # specified by the byte array "<tt>b</tt>", otherwise a {@link
    # <tt>NoClassDefFoundError</tt>} will be thrown.  </p>
    # 
    # @param  name
    # The expected <a href="#name">binary name</a> of the class, or
    # <tt>null</tt> if not known
    # 
    # @param  b
    # The bytes that make up the class data. The bytes in positions
    # <tt>off</tt> through <tt>off+len-1</tt> should have the format
    # of a valid class file as defined by the <a
    # href="http://java.sun.com/docs/books/vmspec/">Java Virtual
    # Machine Specification</a>.
    # 
    # @param  off
    # The start offset in <tt>b</tt> of the class data
    # 
    # @param  len
    # The length of the class data
    # 
    # @param  protectionDomain
    # The ProtectionDomain of the class
    # 
    # @return  The <tt>Class</tt> object created from the data,
    # and optional <tt>ProtectionDomain</tt>.
    # 
    # @throws  ClassFormatError
    # If the data did not contain a valid class
    # 
    # @throws  NoClassDefFoundError
    # If <tt>name</tt> is not equal to the <a href="#name">binary
    # name</a> of the class specified by <tt>b</tt>
    # 
    # @throws  IndexOutOfBoundsException
    # If either <tt>off</tt> or <tt>len</tt> is negative, or if
    # <tt>off+len</tt> is greater than <tt>b.length</tt>.
    # 
    # @throws  SecurityException
    # If an attempt is made to add this class to a package that
    # contains classes that were signed by a different set of
    # certificates than this class, or if <tt>name</tt> begins with
    # "<tt>java.</tt>".
    def define_class(name, b, off, len, protection_domain)
      check
      protection_domain = pre_define_class(name, protection_domain)
      c = nil
      source = define_class_source_location(protection_domain)
      begin
        c = define_class1(name, b, off, len, protection_domain, source)
      rescue ClassFormatError => cfe
        c = define_transformed_class(name, b, off, len, protection_domain, cfe, source)
      end
      post_define_class(c, protection_domain)
      return c
    end
    
    typesig { [String, Java::Nio::ByteBuffer, ProtectionDomain] }
    # Converts a {@link java.nio.ByteBuffer <tt>ByteBuffer</tt>}
    # into an instance of class <tt>Class</tt>,
    # with an optional <tt>ProtectionDomain</tt>.  If the domain is
    # <tt>null</tt>, then a default domain will be assigned to the class as
    # specified in the documentation for {@link #defineClass(String, byte[],
    # int, int)}.  Before the class can be used it must be resolved.
    # 
    # <p>The rules about the first class defined in a package determining the set of
    # certificates for the package, and the restrictions on class names are identical
    # to those specified in the documentation for {@link #defineClass(String, byte[],
    # int, int, ProtectionDomain)}.
    # 
    # <p> An invocation of this method of the form
    # <i>cl</i><tt>.defineClass(</tt><i>name</i><tt>,</tt>
    # <i>bBuffer</i><tt>,</tt> <i>pd</i><tt>)</tt> yields exactly the same
    # result as the statements
    # 
    # <blockquote><tt>
    # ...<br>
    # byte[] temp = new byte[</tt><i>bBuffer</i><tt>.{@link java.nio.ByteBuffer#remaining
    # remaining}()];<br>
    # </tt><i>bBuffer</i><tt>.{@link java.nio.ByteBuffer#get(byte[])
    # get}(temp);<br>
    # return {@link #defineClass(String, byte[], int, int, ProtectionDomain)
    # </tt><i>cl</i><tt>.defineClass}(</tt><i>name</i><tt>, temp, 0, temp.length, </tt><i>pd</i><tt>);<br>
    # </tt></blockquote>
    # 
    # @param  name
    # The expected <a href="#name">binary name</a. of the class, or
    # <tt>null</tt> if not known
    # 
    # @param  b
    # The bytes that make up the class data. The bytes from positions
    # <tt>b.position()</tt> through <tt>b.position() + b.limit() -1 </tt>
    # should have the format of a valid class file as defined by the <a
    # href="http://java.sun.com/docs/books/vmspec/">Java Virtual
    # Machine Specification</a>.
    # 
    # @param  protectionDomain
    # The ProtectionDomain of the class, or <tt>null</tt>.
    # 
    # @return  The <tt>Class</tt> object created from the data,
    # and optional <tt>ProtectionDomain</tt>.
    # 
    # @throws  ClassFormatError
    # If the data did not contain a valid class.
    # 
    # @throws  NoClassDefFoundError
    # If <tt>name</tt> is not equal to the <a href="#name">binary
    # name</a> of the class specified by <tt>b</tt>
    # 
    # @throws  SecurityException
    # If an attempt is made to add this class to a package that
    # contains classes that were signed by a different set of
    # certificates than this class, or if <tt>name</tt> begins with
    # "<tt>java.</tt>".
    # 
    # @see      #defineClass(String, byte[], int, int, ProtectionDomain)
    # 
    # @since  1.5
    def define_class(name, b, protection_domain)
      check
      len = b.remaining
      # Use byte[] if not a direct ByteBufer:
      if (!b.is_direct)
        if (b.has_array)
          return define_class(name, b.array, b.position + b.array_offset, len, protection_domain)
        else
          # no array, or read-only array
          tb = Array.typed(::Java::Byte).new(len) { 0 }
          b.get(tb) # get bytes out of byte buffer.
          return define_class(name, tb, 0, len, protection_domain)
        end
      end
      protection_domain = pre_define_class(name, protection_domain)
      c = nil
      source = define_class_source_location(protection_domain)
      begin
        c = define_class2(name, b, b.position, len, protection_domain, source)
      rescue ClassFormatError => cfe
        tb = Array.typed(::Java::Byte).new(len) { 0 }
        b.get(tb) # get bytes out of byte buffer.
        c = define_transformed_class(name, tb, 0, len, protection_domain, cfe, source)
      end
      post_define_class(c, protection_domain)
      return c
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_defineClass0, [:pointer, :long, :long, :long, :int32, :int32, :long], :long
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ProtectionDomain] }
    def define_class0(name, b, off, len, pd)
      JNI.call_native_method(:Java_java_lang_ClassLoader_defineClass0, JNI.env, self.jni_id, name.jni_id, b.jni_id, off.to_int, len.to_int, pd.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_defineClass1, [:pointer, :long, :long, :long, :int32, :int32, :long, :long], :long
    typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ProtectionDomain, String] }
    def define_class1(name, b, off, len, pd, source)
      JNI.call_native_method(:Java_java_lang_ClassLoader_defineClass1, JNI.env, self.jni_id, name.jni_id, b.jni_id, off.to_int, len.to_int, pd.jni_id, source.jni_id)
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_defineClass2, [:pointer, :long, :long, :long, :int32, :int32, :long, :long], :long
    typesig { [String, Java::Nio::ByteBuffer, ::Java::Int, ::Java::Int, ProtectionDomain, String] }
    def define_class2(name, b, off, len, pd, source)
      JNI.call_native_method(:Java_java_lang_ClassLoader_defineClass2, JNI.env, self.jni_id, name.jni_id, b.jni_id, off.to_int, len.to_int, pd.jni_id, source.jni_id)
    end
    
    typesig { [String] }
    # true if the name is null or has the potential to be a valid binary name
    def check_name(name)
      if (((name).nil?) || ((name.length).equal?(0)))
        return true
      end
      if ((!(name.index_of(Character.new(?/.ord))).equal?(-1)) || (!VM.allow_array_syntax && ((name.char_at(0)).equal?(Character.new(?[.ord)))))
        return false
      end
      return true
    end
    
    typesig { [String, CodeSource] }
    def check_certs(name, cs)
      synchronized(self) do
        i = name.last_index_of(Character.new(?..ord))
        pname = ((i).equal?(-1)) ? "" : name.substring(0, i)
        pcerts = @package2certs.get(pname)
        if ((pcerts).nil?)
          # first class in this package gets to define which
          # certificates must be the same for all other classes
          # in this package
          if (!(cs).nil?)
            pcerts = cs.get_certificates
          end
          if ((pcerts).nil?)
            if ((@nocerts).nil?)
              @nocerts = Array.typed(Java::Security::Cert::Certificate).new(0) { nil }
            end
            pcerts = @nocerts
          end
          @package2certs.put(pname, pcerts)
        else
          certs = nil
          if (!(cs).nil?)
            certs = cs.get_certificates
          end
          if (!compare_certs(pcerts, certs))
            raise SecurityException.new("class \"" + name + "\"'s signer information does not match signer information of other classes in the same package")
          end
        end
      end
    end
    
    typesig { [Array.typed(Java::Security::Cert::Certificate), Array.typed(Java::Security::Cert::Certificate)] }
    # check to make sure the certs for the new class (certs) are the same as
    # the certs for the first class inserted in the package (pcerts)
    def compare_certs(pcerts, certs)
      # certs can be null, indicating no certs.
      if (((certs).nil?) || ((certs.attr_length).equal?(0)))
        return (pcerts.attr_length).equal?(0)
      end
      # the length must be the same at this point
      if (!(certs.attr_length).equal?(pcerts.attr_length))
        return false
      end
      # go through and make sure all the certs in one array
      # are in the other and vice-versa.
      match = false
      i = 0
      while i < certs.attr_length
        match = false
        j = 0
        while j < pcerts.attr_length
          if ((certs[i] == pcerts[j]))
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
      # now do the same for pcerts
      i_ = 0
      while i_ < pcerts.attr_length
        match = false
        j = 0
        while j < certs.attr_length
          if ((pcerts[i_] == certs[j]))
            match = true
            break
          end
          j += 1
        end
        if (!match)
          return false
        end
        i_ += 1
      end
      return true
    end
    
    typesig { [Class] }
    # Links the specified class.  This (misleadingly named) method may be
    # used by a class loader to link a class.  If the class <tt>c</tt> has
    # already been linked, then this method simply returns. Otherwise, the
    # class is linked as described in the "Execution" chapter of the <a
    # href="http://java.sun.com/docs/books/jls/">Java Language
    # Specification</a>.
    # </p>
    # 
    # @param  c
    # The class to link
    # 
    # @throws  NullPointerException
    # If <tt>c</tt> is <tt>null</tt>.
    # 
    # @see  #defineClass(String, byte[], int, int)
    def resolve_class(c)
      check
      resolve_class0(c)
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_resolveClass0, [:pointer, :long, :long], :void
    typesig { [Class] }
    def resolve_class0(c)
      JNI.call_native_method(:Java_java_lang_ClassLoader_resolveClass0, JNI.env, self.jni_id, c.jni_id)
    end
    
    typesig { [String] }
    # Finds a class with the specified <a href="#name">binary name</a>,
    # loading it if necessary.
    # 
    # <p> This method loads the class through the system class loader (see
    # {@link #getSystemClassLoader()}).  The <tt>Class</tt> object returned
    # might have more than one <tt>ClassLoader</tt> associated with it.
    # Subclasses of <tt>ClassLoader</tt> need not usually invoke this method,
    # because most class loaders need to override just {@link
    # #findClass(String)}.  </p>
    # 
    # @param  name
    # The <a href="#name">binary name</a> of the class
    # 
    # @return  The <tt>Class</tt> object for the specified <tt>name</tt>
    # 
    # @throws  ClassNotFoundException
    # If the class could not be found
    # 
    # @see  #ClassLoader(ClassLoader)
    # @see  #getParent()
    def find_system_class(name)
      check
      system = get_system_class_loader
      if ((system).nil?)
        if (!check_name(name))
          raise ClassNotFoundException.new(name)
        end
        return find_bootstrap_class(name)
      end
      return system.load_class(name)
    end
    
    typesig { [String] }
    def find_bootstrap_class0(name)
      check
      if (!check_name(name))
        raise ClassNotFoundException.new(name)
      end
      return find_bootstrap_class(name)
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_findBootstrapClass, [:pointer, :long, :long], :long
    typesig { [String] }
    def find_bootstrap_class(name)
      JNI.call_native_method(:Java_java_lang_ClassLoader_findBootstrapClass, JNI.env, self.jni_id, name.jni_id)
    end
    
    typesig { [] }
    # Check to make sure the class loader has been initialized.
    def check
      if (!@initialized)
        raise SecurityException.new("ClassLoader object not initialized")
      end
    end
    
    typesig { [String] }
    # Returns the class with the given <a href="#name">binary name</a> if this
    # loader has been recorded by the Java virtual machine as an initiating
    # loader of a class with that <a href="#name">binary name</a>.  Otherwise
    # <tt>null</tt> is returned.  </p>
    # 
    # @param  name
    # The <a href="#name">binary name</a> of the class
    # 
    # @return  The <tt>Class</tt> object, or <tt>null</tt> if the class has
    # not been loaded
    # 
    # @since  1.1
    def find_loaded_class(name)
      check
      if (!check_name(name))
        return nil
      end
      return find_loaded_class0(name)
    end
    
    JNI.load_native_method :Java_java_lang_ClassLoader_findLoadedClass0, [:pointer, :long, :long], :long
    typesig { [String] }
    def find_loaded_class0(name)
      JNI.call_native_method(:Java_java_lang_ClassLoader_findLoadedClass0, JNI.env, self.jni_id, name.jni_id)
    end
    
    typesig { [Class, Array.typed(Object)] }
    # Sets the signers of a class.  This should be invoked after defining a
    # class.  </p>
    # 
    # @param  c
    # The <tt>Class</tt> object
    # 
    # @param  signers
    # The signers for the class
    # 
    # @since  1.1
    def set_signers(c, signers)
      check
      c.set_signers(signers)
    end
    
    typesig { [String] }
    # -- Resource --
    # 
    # Finds the resource with the given name.  A resource is some data
    # (images, audio, text, etc) that can be accessed by class code in a way
    # that is independent of the location of the code.
    # 
    # <p> The name of a resource is a '<tt>/</tt>'-separated path name that
    # identifies the resource.
    # 
    # <p> This method will first search the parent class loader for the
    # resource; if the parent is <tt>null</tt> the path of the class loader
    # built-in to the virtual machine is searched.  That failing, this method
    # will invoke {@link #findResource(String)} to find the resource.  </p>
    # 
    # @param  name
    # The resource name
    # 
    # @return  A <tt>URL</tt> object for reading the resource, or
    # <tt>null</tt> if the resource could not be found or the invoker
    # doesn't have adequate  privileges to get the resource.
    # 
    # @since  1.1
    def get_resource(name)
      url = nil
      if (!(@parent).nil?)
        url = @parent.get_resource(name)
      else
        url = get_bootstrap_resource(name)
      end
      if ((url).nil?)
        url = find_resource(name)
      end
      return url
    end
    
    typesig { [String] }
    # Finds all the resources with the given name. A resource is some data
    # (images, audio, text, etc) that can be accessed by class code in a way
    # that is independent of the location of the code.
    # 
    # <p>The name of a resource is a <tt>/</tt>-separated path name that
    # identifies the resource.
    # 
    # <p> The search order is described in the documentation for {@link
    # #getResource(String)}.  </p>
    # 
    # @param  name
    # The resource name
    # 
    # @return  An enumeration of {@link java.net.URL <tt>URL</tt>} objects for
    # the resource.  If no resources could  be found, the enumeration
    # will be empty.  Resources that the class loader doesn't have
    # access to will not be in the enumeration.
    # 
    # @throws  IOException
    # If I/O errors occur
    # 
    # @see  #findResources(String)
    # 
    # @since  1.2
    def get_resources(name)
      tmp = Array.typed(Enumeration).new(2) { nil }
      if (!(@parent).nil?)
        tmp[0] = @parent.get_resources(name)
      else
        tmp[0] = get_bootstrap_resources(name)
      end
      tmp[1] = find_resources(name)
      return CompoundEnumeration.new(tmp)
    end
    
    typesig { [String] }
    # Finds the resource with the given name. Class loader implementations
    # should override this method to specify where to find resources.  </p>
    # 
    # @param  name
    # The resource name
    # 
    # @return  A <tt>URL</tt> object for reading the resource, or
    # <tt>null</tt> if the resource could not be found
    # 
    # @since  1.2
    def find_resource(name)
      return nil
    end
    
    typesig { [String] }
    # Returns an enumeration of {@link java.net.URL <tt>URL</tt>} objects
    # representing all the resources with the given name. Class loader
    # implementations should override this method to specify where to load
    # resources from.  </p>
    # 
    # @param  name
    # The resource name
    # 
    # @return  An enumeration of {@link java.net.URL <tt>URL</tt>} objects for
    # the resources
    # 
    # @throws  IOException
    # If I/O errors occur
    # 
    # @since  1.2
    def find_resources(name)
      return CompoundEnumeration.new(Array.typed(Enumeration).new(0) { nil })
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Find a resource of the specified name from the search path used to load
      # classes.  This method locates the resource through the system class
      # loader (see {@link #getSystemClassLoader()}).  </p>
      # 
      # @param  name
      # The resource name
      # 
      # @return  A {@link java.net.URL <tt>URL</tt>} object for reading the
      # resource, or <tt>null</tt> if the resource could not be found
      # 
      # @since  1.1
      def get_system_resource(name)
        system = get_system_class_loader
        if ((system).nil?)
          return get_bootstrap_resource(name)
        end
        return system.get_resource(name)
      end
      
      typesig { [String] }
      # Finds all resources of the specified name from the search path used to
      # load classes.  The resources thus found are returned as an
      # {@link java.util.Enumeration <tt>Enumeration</tt>} of {@link
      # java.net.URL <tt>URL</tt>} objects.
      # 
      # <p> The search order is described in the documentation for {@link
      # #getSystemResource(String)}.  </p>
      # 
      # @param  name
      # The resource name
      # 
      # @return  An enumeration of resource {@link java.net.URL <tt>URL</tt>}
      # objects
      # 
      # @throws  IOException
      # If I/O errors occur
      # 
      # @since  1.2
      def get_system_resources(name)
        system = get_system_class_loader
        if ((system).nil?)
          return get_bootstrap_resources(name)
        end
        return system.get_resources(name)
      end
      
      typesig { [String] }
      # Find resources from the VM's built-in classloader.
      def get_bootstrap_resource(name)
        ucp = get_bootstrap_class_path
        res = ucp.get_resource(name)
        return !(res).nil? ? res.get_url : nil
      end
      
      typesig { [String] }
      # Find resources from the VM's built-in classloader.
      def get_bootstrap_resources(name)
        e = get_bootstrap_class_path.get_resources(name)
        return Class.new(Enumeration.class == Class ? Enumeration : Object) do
          extend LocalClass
          include_class_members ClassLoader
          include Enumeration if Enumeration.class == Module
          
          typesig { [] }
          define_method :next_element do
            return (e.next_element).get_url
          end
          
          typesig { [] }
          define_method :has_more_elements do
            return e.has_more_elements
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [] }
      # Returns the URLClassPath that is used for finding system resources.
      def get_bootstrap_class_path
        if ((self.attr_bootstrap_class_path).nil?)
          self.attr_bootstrap_class_path = Sun::Misc::Launcher.get_bootstrap_class_path
        end
        return self.attr_bootstrap_class_path
      end
      
      
      def bootstrap_class_path
        defined?(@@bootstrap_class_path) ? @@bootstrap_class_path : @@bootstrap_class_path= nil
      end
      alias_method :attr_bootstrap_class_path, :bootstrap_class_path
      
      def bootstrap_class_path=(value)
        @@bootstrap_class_path = value
      end
      alias_method :attr_bootstrap_class_path=, :bootstrap_class_path=
    }
    
    typesig { [String] }
    # Returns an input stream for reading the specified resource.
    # 
    # <p> The search order is described in the documentation for {@link
    # #getResource(String)}.  </p>
    # 
    # @param  name
    # The resource name
    # 
    # @return  An input stream for reading the resource, or <tt>null</tt>
    # if the resource could not be found
    # 
    # @since  1.1
    def get_resource_as_stream(name)
      url = get_resource(name)
      begin
        return !(url).nil? ? url.open_stream : nil
      rescue IOException => e
        return nil
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Open for reading, a resource of the specified name from the search path
      # used to load classes.  This method locates the resource through the
      # system class loader (see {@link #getSystemClassLoader()}).  </p>
      # 
      # @param  name
      # The resource name
      # 
      # @return  An input stream for reading the resource, or <tt>null</tt>
      # if the resource could not be found
      # 
      # @since  1.1
      def get_system_resource_as_stream(name)
        url = get_system_resource(name)
        begin
          return !(url).nil? ? url.open_stream : nil
        rescue IOException => e
          return nil
        end
      end
    }
    
    typesig { [] }
    # -- Hierarchy --
    # 
    # Returns the parent class loader for delegation. Some implementations may
    # use <tt>null</tt> to represent the bootstrap class loader. This method
    # will return <tt>null</tt> in such implementations if this class loader's
    # parent is the bootstrap class loader.
    # 
    # <p> If a security manager is present, and the invoker's class loader is
    # not <tt>null</tt> and is not an ancestor of this class loader, then this
    # method invokes the security manager's {@link
    # SecurityManager#checkPermission(java.security.Permission)
    # <tt>checkPermission</tt>} method with a {@link
    # RuntimePermission#RuntimePermission(String)
    # <tt>RuntimePermission("getClassLoader")</tt>} permission to verify
    # access to the parent class loader is permitted.  If not, a
    # <tt>SecurityException</tt> will be thrown.  </p>
    # 
    # @return  The parent <tt>ClassLoader</tt>
    # 
    # @throws  SecurityException
    # If a security manager exists and its <tt>checkPermission</tt>
    # method doesn't allow access to this class loader's parent class
    # loader.
    # 
    # @since  1.2
    def get_parent
      if ((@parent).nil?)
        return nil
      end
      sm = System.get_security_manager
      if (!(sm).nil?)
        ccl = get_caller_class_loader
        if (!(ccl).nil? && !is_ancestor(ccl))
          sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
        end
      end
      return @parent
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the system class loader for delegation.  This is the default
      # delegation parent for new <tt>ClassLoader</tt> instances, and is
      # typically the class loader used to start the application.
      # 
      # <p> This method is first invoked early in the runtime's startup
      # sequence, at which point it creates the system class loader and sets it
      # as the context class loader of the invoking <tt>Thread</tt>.
      # 
      # <p> The default system class loader is an implementation-dependent
      # instance of this class.
      # 
      # <p> If the system property "<tt>java.system.class.loader</tt>" is defined
      # when this method is first invoked then the value of that property is
      # taken to be the name of a class that will be returned as the system
      # class loader.  The class is loaded using the default system class loader
      # and must define a public constructor that takes a single parameter of
      # type <tt>ClassLoader</tt> which is used as the delegation parent.  An
      # instance is then created using this constructor with the default system
      # class loader as the parameter.  The resulting class loader is defined
      # to be the system class loader.
      # 
      # <p> If a security manager is present, and the invoker's class loader is
      # not <tt>null</tt> and the invoker's class loader is not the same as or
      # an ancestor of the system class loader, then this method invokes the
      # security manager's {@link
      # SecurityManager#checkPermission(java.security.Permission)
      # <tt>checkPermission</tt>} method with a {@link
      # RuntimePermission#RuntimePermission(String)
      # <tt>RuntimePermission("getClassLoader")</tt>} permission to verify
      # access to the system class loader.  If not, a
      # <tt>SecurityException</tt> will be thrown.  </p>
      # 
      # @return  The system <tt>ClassLoader</tt> for delegation, or
      # <tt>null</tt> if none
      # 
      # @throws  SecurityException
      # If a security manager exists and its <tt>checkPermission</tt>
      # method doesn't allow access to the system class loader.
      # 
      # @throws  IllegalStateException
      # If invoked recursively during the construction of the class
      # loader specified by the "<tt>java.system.class.loader</tt>"
      # property.
      # 
      # @throws  Error
      # If the system property "<tt>java.system.class.loader</tt>"
      # is defined but the named class could not be loaded, the
      # provider class does not define the required constructor, or an
      # exception is thrown by that constructor when it is invoked. The
      # underlying cause of the error can be retrieved via the
      # {@link Throwable#getCause()} method.
      # 
      # @revised  1.4
      def get_system_class_loader
        init_system_class_loader
        if ((self.attr_scl).nil?)
          return nil
        end
        sm = System.get_security_manager
        if (!(sm).nil?)
          ccl = get_caller_class_loader
          if (!(ccl).nil? && !(ccl).equal?(self.attr_scl) && !self.attr_scl.is_ancestor(ccl))
            sm.check_permission(SecurityConstants::GET_CLASSLOADER_PERMISSION)
          end
        end
        return self.attr_scl
      end
      
      typesig { [] }
      def init_system_class_loader
        synchronized(self) do
          if (!self.attr_scl_set)
            if (!(self.attr_scl).nil?)
              raise IllegalStateException.new("recursive invocation")
            end
            l = Sun::Misc::Launcher.get_launcher
            if (!(l).nil?)
              oops = nil
              self.attr_scl = l.get_class_loader
              begin
                a = nil
                a = SystemClassLoaderAction.new(self.attr_scl)
                self.attr_scl = AccessController.do_privileged(a)
              rescue PrivilegedActionException => pae
                oops = pae.get_cause
                if (oops.is_a?(InvocationTargetException))
                  oops = oops.get_cause
                end
              end
              if (!(oops).nil?)
                if (oops.is_a?(JavaError))
                  raise oops
                else
                  # wrap the exception
                  raise JavaError.new(oops)
                end
              end
            end
            self.attr_scl_set = true
          end
        end
      end
    }
    
    typesig { [ClassLoader] }
    # Returns true if the specified class loader can be found in this class
    # loader's delegation chain.
    def is_ancestor(cl)
      acl = self
      begin
        acl = acl.attr_parent
        if ((cl).equal?(acl))
          return true
        end
      end while (!(acl).nil?)
      return false
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the invoker's class loader, or null if none.
      # NOTE: This must always be invoked when there is exactly one intervening
      # frame from the core libraries on the stack between this method's
      # invocation and the desired invoker.
      def get_caller_class_loader
        # NOTE use of more generic Reflection.getCallerClass()
        caller = Reflection.get_caller_class(3)
        # This can be null if the VM is requesting it
        if ((caller).nil?)
          return nil
        end
        # Circumvent security check since this is package-private
        return caller.get_class_loader0
      end
      
      # The class loader for the system
      
      def scl
        defined?(@@scl) ? @@scl : @@scl= nil
      end
      alias_method :attr_scl, :scl
      
      def scl=(value)
        @@scl = value
      end
      alias_method :attr_scl=, :scl=
      
      # Set to true once the system class loader has been set
      
      def scl_set
        defined?(@@scl_set) ? @@scl_set : @@scl_set= false
      end
      alias_method :attr_scl_set, :scl_set
      
      def scl_set=(value)
        @@scl_set = value
      end
      alias_method :attr_scl_set=, :scl_set=
    }
    
    typesig { [String, String, String, String, String, String, String, URL] }
    # -- Package --
    # 
    # Defines a package by name in this <tt>ClassLoader</tt>.  This allows
    # class loaders to define the packages for their classes. Packages must
    # be created before the class is defined, and package names must be
    # unique within a class loader and cannot be redefined or changed once
    # created.  </p>
    # 
    # @param  name
    # The package name
    # 
    # @param  specTitle
    # The specification title
    # 
    # @param  specVersion
    # The specification version
    # 
    # @param  specVendor
    # The specification vendor
    # 
    # @param  implTitle
    # The implementation title
    # 
    # @param  implVersion
    # The implementation version
    # 
    # @param  implVendor
    # The implementation vendor
    # 
    # @param  sealBase
    # If not <tt>null</tt>, then this package is sealed with
    # respect to the given code source {@link java.net.URL
    # <tt>URL</tt>}  object.  Otherwise, the package is not sealed.
    # 
    # @return  The newly defined <tt>Package</tt> object
    # 
    # @throws  IllegalArgumentException
    # If package name duplicates an existing package either in this
    # class loader or one of its ancestors
    # 
    # @since  1.2
    def define_package(name, spec_title, spec_version, spec_vendor, impl_title, impl_version, impl_vendor, seal_base)
      synchronized((@packages)) do
        pkg = get_package(name)
        if (!(pkg).nil?)
          raise IllegalArgumentException.new(name)
        end
        pkg = Package.new(name, spec_title, spec_version, spec_vendor, impl_title, impl_version, impl_vendor, seal_base, self)
        @packages.put(name, pkg)
        return pkg
      end
    end
    
    typesig { [String] }
    # Returns a <tt>Package</tt> that has been defined by this class loader
    # or any of its ancestors.  </p>
    # 
    # @param  name
    # The package name
    # 
    # @return  The <tt>Package</tt> corresponding to the given name, or
    # <tt>null</tt> if not found
    # 
    # @since  1.2
    def get_package(name)
      synchronized((@packages)) do
        pkg = @packages.get(name)
        if ((pkg).nil?)
          if (!(@parent).nil?)
            pkg = @parent.get_package(name)
          else
            pkg = Package.get_system_package(name)
          end
          if (!(pkg).nil?)
            @packages.put(name, pkg)
          end
        end
        return pkg
      end
    end
    
    typesig { [] }
    # Returns all of the <tt>Packages</tt> defined by this class loader and
    # its ancestors.  </p>
    # 
    # @return  The array of <tt>Package</tt> objects defined by this
    # <tt>ClassLoader</tt>
    # 
    # @since  1.2
    def get_packages
      map = nil
      synchronized((@packages)) do
        map = @packages.clone
      end
      pkgs = nil
      if (!(@parent).nil?)
        pkgs = @parent.get_packages
      else
        pkgs = Package.get_system_packages
      end
      if (!(pkgs).nil?)
        i = 0
        while i < pkgs.attr_length
          pkg_name = pkgs[i].get_name
          if ((map.get(pkg_name)).nil?)
            map.put(pkg_name, pkgs[i])
          end
          i += 1
        end
      end
      return map.values.to_array(Array.typed(Package).new(map.size) { nil })
    end
    
    typesig { [String] }
    # -- Native library access --
    # 
    # Returns the absolute path name of a native library.  The VM invokes this
    # method to locate the native libraries that belong to classes loaded with
    # this class loader. If this method returns <tt>null</tt>, the VM
    # searches the library along the path specified as the
    # "<tt>java.library.path</tt>" property.  </p>
    # 
    # @param  libname
    # The library name
    # 
    # @return  The absolute path of the native library
    # 
    # @see  System#loadLibrary(String)
    # @see  System#mapLibraryName(String)
    # 
    # @since  1.2
    def find_library(libname)
      return nil
    end
    
    class_module.module_eval {
      # The inner class NativeLibrary denotes a loaded native library instance.
      # Every classloader contains a vector of loaded native libraries in the
      # private field <tt>nativeLibraries</tt>.  The native libraries loaded
      # into the system are entered into the <tt>systemNativeLibraries</tt>
      # vector.
      # 
      # <p> Every native library requires a particular version of JNI. This is
      # denoted by the private <tt>jniVersion</tt> field.  This field is set by
      # the VM when it loads the library, and used by the VM to pass the correct
      # version of JNI to the native methods.  </p>
      # 
      # @see      ClassLoader
      # @since    1.2
      const_set_lazy(:NativeLibrary) { Class.new do
        include_class_members ClassLoader
        
        # opaque handle to native library, used in native code.
        attr_accessor :handle
        alias_method :attr_handle, :handle
        undef_method :handle
        alias_method :attr_handle=, :handle=
        undef_method :handle=
        
        # the version of JNI environment the native library requires.
        attr_accessor :jni_version
        alias_method :attr_jni_version, :jni_version
        undef_method :jni_version
        alias_method :attr_jni_version=, :jni_version=
        undef_method :jni_version=
        
        # the class from which the library is loaded, also indicates
        # the loader this native library belongs.
        attr_accessor :from_class
        alias_method :attr_from_class, :from_class
        undef_method :from_class
        alias_method :attr_from_class=, :from_class=
        undef_method :from_class=
        
        # the canonicalized name of the native library.
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        JNI.load_native_method :Java_java_lang_NativeLibrary_load, [:pointer, :long, :long], :void
        typesig { [String] }
        def load(name)
          JNI.call_native_method(:Java_java_lang_NativeLibrary_load, JNI.env, self.jni_id, name.jni_id)
        end
        
        JNI.load_native_method :Java_java_lang_NativeLibrary_find, [:pointer, :long, :long], :int64
        typesig { [String] }
        def find(name)
          JNI.call_native_method(:Java_java_lang_NativeLibrary_find, JNI.env, self.jni_id, name.jni_id)
        end
        
        JNI.load_native_method :Java_java_lang_NativeLibrary_unload, [:pointer, :long], :void
        typesig { [] }
        def unload
          JNI.call_native_method(:Java_java_lang_NativeLibrary_unload, JNI.env, self.jni_id)
        end
        
        typesig { [class_self::Class, String] }
        def initialize(from_class, name)
          @handle = 0
          @jni_version = 0
          @from_class = nil
          @name = nil
          @name = name
          @from_class = from_class
        end
        
        typesig { [] }
        def finalize
          synchronized((self.attr_loaded_library_names)) do
            if (!(@from_class.get_class_loader).nil? && !(@handle).equal?(0))
              # remove the native library name
              size_ = self.attr_loaded_library_names.size
              i = 0
              while i < size_
                if ((@name == self.attr_loaded_library_names.element_at(i)))
                  self.attr_loaded_library_names.remove_element_at(i)
                  break
                end
                i += 1
              end
              # unload the library.
              ClassLoader.attr_native_library_context.push(self)
              begin
                unload
              ensure
                ClassLoader.attr_native_library_context.pop
              end
            end
          end
        end
        
        class_module.module_eval {
          typesig { [] }
          # Invoked in the VM to determine the context class in
          # JNI_Load/JNI_Unload
          def get_from_class
            return ((ClassLoader.attr_native_library_context.peek)).attr_from_class
          end
        }
        
        private
        alias_method :initialize__native_library, :initialize
      end }
    }
    
    # The "default" domain. Set as the default ProtectionDomain on newly
    # created classes.
    attr_accessor :default_domain
    alias_method :attr_default_domain, :default_domain
    undef_method :default_domain
    alias_method :attr_default_domain=, :default_domain=
    undef_method :default_domain=
    
    typesig { [] }
    # Returns (and initializes) the default domain.
    def get_default_domain
      synchronized(self) do
        if ((@default_domain).nil?)
          cs = CodeSource.new(nil, nil)
          @default_domain = ProtectionDomain.new(cs, nil, self, nil)
        end
        return @default_domain
      end
    end
    
    class_module.module_eval {
      # All native library names we've loaded.
      
      def loaded_library_names
        defined?(@@loaded_library_names) ? @@loaded_library_names : @@loaded_library_names= Vector.new
      end
      alias_method :attr_loaded_library_names, :loaded_library_names
      
      def loaded_library_names=(value)
        @@loaded_library_names = value
      end
      alias_method :attr_loaded_library_names=, :loaded_library_names=
      
      # Native libraries belonging to system classes.
      
      def system_native_libraries
        defined?(@@system_native_libraries) ? @@system_native_libraries : @@system_native_libraries= Vector.new
      end
      alias_method :attr_system_native_libraries, :system_native_libraries
      
      def system_native_libraries=(value)
        @@system_native_libraries = value
      end
      alias_method :attr_system_native_libraries=, :system_native_libraries=
    }
    
    # Native libraries associated with the class loader.
    attr_accessor :native_libraries
    alias_method :attr_native_libraries, :native_libraries
    undef_method :native_libraries
    alias_method :attr_native_libraries=, :native_libraries=
    undef_method :native_libraries=
    
    class_module.module_eval {
      # native libraries being loaded/unloaded.
      
      def native_library_context
        defined?(@@native_library_context) ? @@native_library_context : @@native_library_context= Stack.new
      end
      alias_method :attr_native_library_context, :native_library_context
      
      def native_library_context=(value)
        @@native_library_context = value
      end
      alias_method :attr_native_library_context=, :native_library_context=
      
      # The paths searched for libraries
      
      def usr_paths
        defined?(@@usr_paths) ? @@usr_paths : @@usr_paths= nil
      end
      alias_method :attr_usr_paths, :usr_paths
      
      def usr_paths=(value)
        @@usr_paths = value
      end
      alias_method :attr_usr_paths=, :usr_paths=
      
      
      def sys_paths
        defined?(@@sys_paths) ? @@sys_paths : @@sys_paths= nil
      end
      alias_method :attr_sys_paths, :sys_paths
      
      def sys_paths=(value)
        @@sys_paths = value
      end
      alias_method :attr_sys_paths=, :sys_paths=
      
      typesig { [String] }
      def initialize_path(propname)
        ldpath = System.get_property(propname, "")
        ps = JavaFile.attr_path_separator
        ldlen = ldpath.length
        i = 0
        j = 0
        n = 0
        # Count the separators in the path
        i = ldpath.index_of(ps)
        n = 0
        while (i >= 0)
          n += 1
          i = ldpath.index_of(ps, i + 1)
        end
        # allocate the array of paths - n :'s = n + 1 path elements
        paths = Array.typed(String).new(n + 1) { nil }
        # Fill the array with paths from the ldpath
        n = i = 0
        j = ldpath.index_of(ps)
        while (j >= 0)
          if (j - i > 0)
            paths[((n += 1) - 1)] = ldpath.substring(i, j)
          else
            if ((j - i).equal?(0))
              paths[((n += 1) - 1)] = "."
            end
          end
          i = j + 1
          j = ldpath.index_of(ps, i)
        end
        paths[n] = ldpath.substring(i, ldlen)
        return paths
      end
      
      typesig { [Class, String, ::Java::Boolean] }
      # Invoked in the java.lang.Runtime class to implement load and loadLibrary.
      def load_library(from_class, name, is_absolute)
        loader = ((from_class).nil?) ? nil : from_class.get_class_loader
        if ((self.attr_sys_paths).nil?)
          self.attr_usr_paths = initialize_path("java.library.path")
          self.attr_sys_paths = initialize_path("sun.boot.library.path")
        end
        if (is_absolute)
          if (load_library0(from_class, JavaFile.new(name)))
            return
          end
          raise UnsatisfiedLinkError.new("Can't load library: " + name)
        end
        if (!(loader).nil?)
          libfilename = loader.find_library(name)
          if (!(libfilename).nil?)
            libfile = JavaFile.new(libfilename)
            if (!libfile.is_absolute)
              raise UnsatisfiedLinkError.new("ClassLoader.findLibrary failed to return an absolute path: " + libfilename)
            end
            if (load_library0(from_class, libfile))
              return
            end
            raise UnsatisfiedLinkError.new("Can't load " + libfilename)
          end
        end
        i = 0
        while i < self.attr_sys_paths.attr_length
          libfile = JavaFile.new(self.attr_sys_paths[i], System.map_library_name(name))
          if (load_library0(from_class, libfile))
            return
          end
          i += 1
        end
        if (!(loader).nil?)
          i_ = 0
          while i_ < self.attr_usr_paths.attr_length
            libfile = JavaFile.new(self.attr_usr_paths[i_], System.map_library_name(name))
            if (load_library0(from_class, libfile))
              return
            end
            i_ += 1
          end
        end
        # Oops, it failed
        raise UnsatisfiedLinkError.new("no " + name + " in java.library.path")
      end
      
      typesig { [Class, JavaFile] }
      def load_library0(from_class, file)
        exists = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ClassLoader
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Boolean.new(file.exists)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (!exists.boolean_value)
          return false
        end
        name = nil
        begin
          name = RJava.cast_to_string(file.get_canonical_path)
        rescue IOException => e
          return false
        end
        loader = ((from_class).nil?) ? nil : from_class.get_class_loader
        libs = !(loader).nil? ? loader.attr_native_libraries : self.attr_system_native_libraries
        synchronized((libs)) do
          size_ = libs.size
          i = 0
          while i < size_
            lib = libs.element_at(i)
            if ((name == lib.attr_name))
              return true
            end
            i += 1
          end
          synchronized((self.attr_loaded_library_names)) do
            if (self.attr_loaded_library_names.contains(name))
              raise UnsatisfiedLinkError.new("Native Library " + name + " already loaded in another classloader")
            end
            # If the library is being loaded (must be by the same thread,
            # because Runtime.load and Runtime.loadLibrary are
            # synchronous). The reason is can occur is that the JNI_OnLoad
            # function can cause another loadLibrary invocation.
            # 
            # Thus we can use a static stack to hold the list of libraries
            # we are loading.
            # 
            # If there is a pending load operation for the library, we
            # immediately return success; otherwise, we raise
            # UnsatisfiedLinkError.
            n = self.attr_native_library_context.size
            i_ = 0
            while i_ < n
              lib = self.attr_native_library_context.element_at(i_)
              if ((name == lib.attr_name))
                if ((loader).equal?(lib.attr_from_class.get_class_loader))
                  return true
                else
                  raise UnsatisfiedLinkError.new("Native Library " + name + " is being loaded in another classloader")
                end
              end
              i_ += 1
            end
            lib = NativeLibrary.new(from_class, name)
            self.attr_native_library_context.push(lib)
            begin
              lib.load(name)
            ensure
              self.attr_native_library_context.pop
            end
            if (!(lib.attr_handle).equal?(0))
              self.attr_loaded_library_names.add_element(name)
              libs.add_element(lib)
              return true
            end
            return false
          end
        end
      end
      
      typesig { [ClassLoader, String] }
      # Invoked in the VM class linking code.
      def find_native(loader, name)
        libs = !(loader).nil? ? loader.attr_native_libraries : self.attr_system_native_libraries
        synchronized((libs)) do
          size_ = libs.size
          i = 0
          while i < size_
            lib = libs.element_at(i)
            entry = lib.find(name)
            if (!(entry).equal?(0))
              return entry
            end
            i += 1
          end
        end
        return 0
      end
    }
    
    # -- Assertion management --
    # The default toggle for assertion checking.
    attr_accessor :default_assertion_status
    alias_method :attr_default_assertion_status, :default_assertion_status
    undef_method :default_assertion_status
    alias_method :attr_default_assertion_status=, :default_assertion_status=
    undef_method :default_assertion_status=
    
    # Maps String packageName to Boolean package default assertion status Note
    # that the default package is placed under a null map key.  If this field
    # is null then we are delegating assertion status queries to the VM, i.e.,
    # none of this ClassLoader's assertion status modification methods have
    # been invoked.
    attr_accessor :package_assertion_status
    alias_method :attr_package_assertion_status, :package_assertion_status
    undef_method :package_assertion_status
    alias_method :attr_package_assertion_status=, :package_assertion_status=
    undef_method :package_assertion_status=
    
    # Maps String fullyQualifiedClassName to Boolean assertionStatus If this
    # field is null then we are delegating assertion status queries to the VM,
    # i.e., none of this ClassLoader's assertion status modification methods
    # have been invoked.
    attr_accessor :class_assertion_status
    alias_method :attr_class_assertion_status, :class_assertion_status
    undef_method :class_assertion_status
    alias_method :attr_class_assertion_status=, :class_assertion_status=
    undef_method :class_assertion_status=
    
    typesig { [::Java::Boolean] }
    # Sets the default assertion status for this class loader.  This setting
    # determines whether classes loaded by this class loader and initialized
    # in the future will have assertions enabled or disabled by default.
    # This setting may be overridden on a per-package or per-class basis by
    # invoking {@link #setPackageAssertionStatus(String, boolean)} or {@link
    # #setClassAssertionStatus(String, boolean)}.  </p>
    # 
    # @param  enabled
    # <tt>true</tt> if classes loaded by this class loader will
    # henceforth have assertions enabled by default, <tt>false</tt>
    # if they will have assertions disabled by default.
    # 
    # @since  1.4
    def set_default_assertion_status(enabled)
      synchronized(self) do
        if ((@class_assertion_status).nil?)
          initialize_java_assertion_maps
        end
        @default_assertion_status = enabled
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    # Sets the package default assertion status for the named package.  The
    # package default assertion status determines the assertion status for
    # classes initialized in the future that belong to the named package or
    # any of its "subpackages".
    # 
    # <p> A subpackage of a package named p is any package whose name begins
    # with "<tt>p.</tt>".  For example, <tt>javax.swing.text</tt> is a
    # subpackage of <tt>javax.swing</tt>, and both <tt>java.util</tt> and
    # <tt>java.lang.reflect</tt> are subpackages of <tt>java</tt>.
    # 
    # <p> In the event that multiple package defaults apply to a given class,
    # the package default pertaining to the most specific package takes
    # precedence over the others.  For example, if <tt>javax.lang</tt> and
    # <tt>javax.lang.reflect</tt> both have package defaults associated with
    # them, the latter package default applies to classes in
    # <tt>javax.lang.reflect</tt>.
    # 
    # <p> Package defaults take precedence over the class loader's default
    # assertion status, and may be overridden on a per-class basis by invoking
    # {@link #setClassAssertionStatus(String, boolean)}.  </p>
    # 
    # @param  packageName
    # The name of the package whose package default assertion status
    # is to be set. A <tt>null</tt> value indicates the unnamed
    # package that is "current"
    # (<a href="http://java.sun.com/docs/books/jls/">Java Language
    # Specification</a>, section 7.4.2).
    # 
    # @param  enabled
    # <tt>true</tt> if classes loaded by this classloader and
    # belonging to the named package or any of its subpackages will
    # have assertions enabled by default, <tt>false</tt> if they will
    # have assertions disabled by default.
    # 
    # @since  1.4
    def set_package_assertion_status(package_name, enabled)
      synchronized(self) do
        if ((@package_assertion_status).nil?)
          initialize_java_assertion_maps
        end
        @package_assertion_status.put(package_name, Boolean.value_of(enabled))
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    # Sets the desired assertion status for the named top-level class in this
    # class loader and any nested classes contained therein.  This setting
    # takes precedence over the class loader's default assertion status, and
    # over any applicable per-package default.  This method has no effect if
    # the named class has already been initialized.  (Once a class is
    # initialized, its assertion status cannot change.)
    # 
    # <p> If the named class is not a top-level class, this invocation will
    # have no effect on the actual assertion status of any class. </p>
    # 
    # @param  className
    # The fully qualified class name of the top-level class whose
    # assertion status is to be set.
    # 
    # @param  enabled
    # <tt>true</tt> if the named class is to have assertions
    # enabled when (and if) it is initialized, <tt>false</tt> if the
    # class is to have assertions disabled.
    # 
    # @since  1.4
    def set_class_assertion_status(class_name, enabled)
      synchronized(self) do
        if ((@class_assertion_status).nil?)
          initialize_java_assertion_maps
        end
        @class_assertion_status.put(class_name, Boolean.value_of(enabled))
      end
    end
    
    typesig { [] }
    # Sets the default assertion status for this class loader to
    # <tt>false</tt> and discards any package defaults or class assertion
    # status settings associated with the class loader.  This method is
    # provided so that class loaders can be made to ignore any command line or
    # persistent assertion status settings and "start with a clean slate."
    # </p>
    # 
    # @since  1.4
    def clear_assertion_status
      synchronized(self) do
        # Whether or not "Java assertion maps" are initialized, set
        # them to empty maps, effectively ignoring any present settings.
        @class_assertion_status = HashMap.new
        @package_assertion_status = HashMap.new
        @default_assertion_status = false
      end
    end
    
    typesig { [String] }
    # Returns the assertion status that would be assigned to the specified
    # class if it were to be initialized at the time this method is invoked.
    # If the named class has had its assertion status set, the most recent
    # setting will be returned; otherwise, if any package default assertion
    # status pertains to this class, the most recent setting for the most
    # specific pertinent package default assertion status is returned;
    # otherwise, this class loader's default assertion status is returned.
    # </p>
    # 
    # @param  className
    # The fully qualified class name of the class whose desired
    # assertion status is being queried.
    # 
    # @return  The desired assertion status of the specified class.
    # 
    # @see  #setClassAssertionStatus(String, boolean)
    # @see  #setPackageAssertionStatus(String, boolean)
    # @see  #setDefaultAssertionStatus(boolean)
    # 
    # @since  1.4
    def desired_assertion_status(class_name)
      synchronized(self) do
        result = nil
        # assert classAssertionStatus   != null;
        # assert packageAssertionStatus != null;
        # Check for a class entry
        result = @class_assertion_status.get(class_name)
        if (!(result).nil?)
          return result.boolean_value
        end
        # Check for most specific package entry
        dot_index = class_name.last_index_of(".")
        if (dot_index < 0)
          # default package
          result = @package_assertion_status.get(nil)
          if (!(result).nil?)
            return result.boolean_value
          end
        end
        while (dot_index > 0)
          class_name = RJava.cast_to_string(class_name.substring(0, dot_index))
          result = @package_assertion_status.get(class_name)
          if (!(result).nil?)
            return result.boolean_value
          end
          dot_index = class_name.last_index_of(".", dot_index - 1)
        end
        # Return the classloader default
        return @default_assertion_status
      end
    end
    
    typesig { [] }
    # Set up the assertions with information provided by the VM.
    def initialize_java_assertion_maps
      # assert Thread.holdsLock(this);
      @class_assertion_status = HashMap.new
      @package_assertion_status = HashMap.new
      directives = retrieve_directives
      i = 0
      while i < directives.attr_classes.attr_length
        @class_assertion_status.put(directives.attr_classes[i], Boolean.value_of(directives.attr_class_enabled[i]))
        i += 1
      end
      i_ = 0
      while i_ < directives.attr_packages.attr_length
        @package_assertion_status.put(directives.attr_packages[i_], Boolean.value_of(directives.attr_package_enabled[i_]))
        i_ += 1
      end
      @default_assertion_status = directives.attr_deflt
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_lang_ClassLoader_retrieveDirectives, [:pointer, :long], :long
      typesig { [] }
      # Retrieves the assertion directives from the VM.
      def retrieve_directives
        JNI.call_native_method(:Java_java_lang_ClassLoader_retrieveDirectives, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__class_loader, :initialize
  end
  
  class SystemClassLoaderAction 
    include_class_members ClassLoaderImports
    include PrivilegedExceptionAction
    
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    typesig { [ClassLoader] }
    def initialize(parent)
      @parent = nil
      @parent = parent
    end
    
    typesig { [] }
    def run
      sys = nil
      ctor = nil
      c = nil
      cp = Array.typed(Class).new([ClassLoader])
      params = Array.typed(Object).new([@parent])
      cls = System.get_property("java.system.class.loader")
      if ((cls).nil?)
        return @parent
      end
      c = Class.for_name(cls, true, @parent)
      ctor = c.get_declared_constructor(cp)
      sys = ctor.new_instance(params)
      JavaThread.current_thread.set_context_class_loader(sys)
      return sys
    end
    
    private
    alias_method :initialize__system_class_loader_action, :initialize
  end
  
end

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
module Java::Lang
  module PackageImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :InputStream
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util::Jar, :JarInputStream
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar::Attributes, :Name
      include_const ::Java::Util::Jar, :JarException
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Java::Lang::Annotation, :Annotation
    }
  end
  
  # {@code Package} objects contain version information
  # about the implementation and specification of a Java package.
  # This versioning information is retrieved and made available
  # by the {@link ClassLoader} instance that
  # loaded the class(es).  Typically, it is stored in the manifest that is
  # distributed with the classes.
  # 
  # <p>The set of classes that make up the package may implement a
  # particular specification and if so the specification title, version number,
  # and vendor strings identify that specification.
  # An application can ask if the package is
  # compatible with a particular version, see the {@link
  # #isCompatibleWith isCompatibleWith}
  # method for details.
  # 
  # <p>Specification version numbers use a syntax that consists of nonnegative
  # decimal integers separated by periods ".", for example "2.0" or
  # "1.2.3.4.5.6.7".  This allows an extensible number to be used to represent
  # major, minor, micro, etc. versions.  The version specification is described
  # by the following formal grammar:
  # <blockquote>
  # <dl>
  # <dt><i>SpecificationVersion:
  # <dd>Digits RefinedVersion<sub>opt</sub></i>
  # 
  # <p><dt><i>RefinedVersion:</i>
  # <dd>{@code .} <i>Digits</i>
  # <dd>{@code .} <i>Digits RefinedVersion</i>
  # 
  # <p><dt><i>Digits:
  # <dd>Digit
  # <dd>Digits</i>
  # 
  # <p><dt><i>Digit:</i>
  # <dd>any character for which {@link Character#isDigit} returns {@code true},
  # e.g. 0, 1, 2, ...
  # </dl>
  # </blockquote>
  # 
  # <p>The implementation title, version, and vendor strings identify an
  # implementation and are made available conveniently to enable accurate
  # reporting of the packages involved when a problem occurs. The contents
  # all three implementation strings are vendor specific. The
  # implementation version strings have no specified syntax and should
  # only be compared for equality with desired version identifiers.
  # 
  # <p>Within each {@code ClassLoader} instance all classes from the same
  # java package have the same Package object.  The static methods allow a package
  # to be found by name or the set of all packages known to the current class
  # loader to be found.
  # 
  # @see ClassLoader#definePackage
  class Package 
    include_class_members PackageImports
    include Java::Lang::Reflect::AnnotatedElement
    
    typesig { [] }
    # Return the name of this package.
    # 
    # @return  The fully-qualified name of this package as defined in the
    # <em>Java Language Specification, Third Edition</em>
    # <a href="http://java.sun.com/docs/books/jls/third_edition/html/names.html#6.5.3">
    # &sect;6.5.3</a>, for example, {@code java.lang}
    def get_name
      return @pkg_name
    end
    
    typesig { [] }
    # Return the title of the specification that this package implements.
    # @return the specification title, null is returned if it is not known.
    def get_specification_title
      return @spec_title
    end
    
    typesig { [] }
    # Returns the version number of the specification
    # that this package implements.
    # This version string must be a sequence of nonnegative decimal
    # integers separated by "."'s and may have leading zeros.
    # When version strings are compared the most significant
    # numbers are compared.
    # @return the specification version, null is returned if it is not known.
    def get_specification_version
      return @spec_version
    end
    
    typesig { [] }
    # Return the name of the organization, vendor,
    # or company that owns and maintains the specification
    # of the classes that implement this package.
    # @return the specification vendor, null is returned if it is not known.
    def get_specification_vendor
      return @spec_vendor
    end
    
    typesig { [] }
    # Return the title of this package.
    # @return the title of the implementation, null is returned if it is not known.
    def get_implementation_title
      return @impl_title
    end
    
    typesig { [] }
    # Return the version of this implementation. It consists of any string
    # assigned by the vendor of this implementation and does
    # not have any particular syntax specified or expected by the Java
    # runtime. It may be compared for equality with other
    # package version strings used for this implementation
    # by this vendor for this package.
    # @return the version of the implementation, null is returned if it is not known.
    def get_implementation_version
      return @impl_version
    end
    
    typesig { [] }
    # Returns the name of the organization,
    # vendor or company that provided this implementation.
    # @return the vendor that implemented this package..
    def get_implementation_vendor
      return @impl_vendor
    end
    
    typesig { [] }
    # Returns true if this package is sealed.
    # 
    # @return true if the package is sealed, false otherwise
    def is_sealed
      return !(@seal_base).nil?
    end
    
    typesig { [URL] }
    # Returns true if this package is sealed with respect to the specified
    # code source url.
    # 
    # @param url the code source url
    # @return true if this package is sealed with respect to url
    def is_sealed(url)
      return (url == @seal_base)
    end
    
    typesig { [String] }
    # Compare this package's specification version with a
    # desired version. It returns true if
    # this packages specification version number is greater than or equal
    # to the desired version number. <p>
    # 
    # Version numbers are compared by sequentially comparing corresponding
    # components of the desired and specification strings.
    # Each component is converted as a decimal integer and the values
    # compared.
    # If the specification value is greater than the desired
    # value true is returned. If the value is less false is returned.
    # If the values are equal the period is skipped and the next pair of
    # components is compared.
    # 
    # @param desired the version string of the desired version.
    # @return true if this package's version number is greater
    # than or equal to the desired version number
    # 
    # @exception NumberFormatException if the desired or current version
    # is not of the correct dotted form.
    def is_compatible_with(desired)
      if ((@spec_version).nil? || @spec_version.length < 1)
        raise NumberFormatException.new("Empty version string")
      end
      sa = @spec_version.split(Regexp.new("\\."))
      si = Array.typed(::Java::Int).new(sa.attr_length) { 0 }
      i = 0
      while i < sa.attr_length
        si[i] = JavaInteger.parse_int(sa[i])
        if (si[i] < 0)
          raise NumberFormatException.for_input_string("" + (si[i]).to_s)
        end
        i += 1
      end
      da = desired.split(Regexp.new("\\."))
      di = Array.typed(::Java::Int).new(da.attr_length) { 0 }
      i_ = 0
      while i_ < da.attr_length
        di[i_] = JavaInteger.parse_int(da[i_])
        if (di[i_] < 0)
          raise NumberFormatException.for_input_string("" + (di[i_]).to_s)
        end
        i_ += 1
      end
      len = Math.max(di.attr_length, si.attr_length)
      i__ = 0
      while i__ < len
        d = (i__ < di.attr_length ? di[i__] : 0)
        s = (i__ < si.attr_length ? si[i__] : 0)
        if (s < d)
          return false
        end
        if (s > d)
          return true
        end
        i__ += 1
      end
      return true
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Find a package by name in the callers {@code ClassLoader} instance.
      # The callers {@code ClassLoader} instance is used to find the package
      # instance corresponding to the named class. If the callers
      # {@code ClassLoader} instance is null then the set of packages loaded
      # by the system {@code ClassLoader} instance is searched to find the
      # named package. <p>
      # 
      # Packages have attributes for versions and specifications only if the class
      # loader created the package instance with the appropriate attributes. Typically,
      # those attributes are defined in the manifests that accompany the classes.
      # 
      # @param name a package name, for example, java.lang.
      # @return the package of the requested name. It may be null if no package
      # information is available from the archive or codebase.
      def get_package(name)
        l = ClassLoader.get_caller_class_loader
        if (!(l).nil?)
          return l.get_package(name)
        else
          return get_system_package(name)
        end
      end
      
      typesig { [] }
      # Get all the packages currently known for the caller's {@code ClassLoader}
      # instance.  Those packages correspond to classes loaded via or accessible by
      # name to that {@code ClassLoader} instance.  If the caller's
      # {@code ClassLoader} instance is the bootstrap {@code ClassLoader}
      # instance, which may be represented by {@code null} in some implementations,
      # only packages corresponding to classes loaded by the bootstrap
      # {@code ClassLoader} instance will be returned.
      # 
      # @return a new array of packages known to the callers {@code ClassLoader}
      # instance.  An zero length array is returned if none are known.
      def get_packages
        l = ClassLoader.get_caller_class_loader
        if (!(l).nil?)
          return l.get_packages
        else
          return get_system_packages
        end
      end
      
      typesig { [Class] }
      # Get the package for the specified class.
      # The class's class loader is used to find the package instance
      # corresponding to the specified class. If the class loader
      # is the bootstrap class loader, which may be represented by
      # {@code null} in some implementations, then the set of packages
      # loaded by the bootstrap class loader is searched to find the package.
      # <p>
      # Packages have attributes for versions and specifications only
      # if the class loader created the package
      # instance with the appropriate attributes. Typically those
      # attributes are defined in the manifests that accompany
      # the classes.
      # 
      # @param class the class to get the package of.
      # @return the package of the class. It may be null if no package
      # information is available from the archive or codebase.
      def get_package(c)
        name = c.get_name
        i = name.last_index_of(Character.new(?..ord))
        if (!(i).equal?(-1))
          name = (name.substring(0, i)).to_s
          cl = c.get_class_loader
          if (!(cl).nil?)
            return cl.get_package(name)
          else
            return get_system_package(name)
          end
        else
          return nil
        end
      end
    }
    
    typesig { [] }
    # Return the hash code computed from the package name.
    # @return the hash code computed from the package name.
    def hash_code
      return @pkg_name.hash_code
    end
    
    typesig { [] }
    # Returns the string representation of this Package.
    # Its value is the string "package " and the package name.
    # If the package title is defined it is appended.
    # If the package version is defined it is appended.
    # @return the string representation of the package.
    def to_s
      spec = @spec_title
      ver = @spec_version
      if (!(spec).nil? && spec.length > 0)
        spec = ", " + spec
      else
        spec = ""
      end
      if (!(ver).nil? && ver.length > 0)
        ver = ", version " + ver
      else
        ver = ""
      end
      return "package " + @pkg_name + spec + ver
    end
    
    typesig { [] }
    def get_package_info
      if ((@package_info).nil?)
        begin
          @package_info = Class.for_name(@pkg_name + ".package-info", false, @loader)
        rescue ClassNotFoundException => ex
          package_info_proxy_class = # store a proxy for the package info that has no annotations
          Class.new do
            extend LocalClass
            include_class_members Package
            
            typesig { [] }
            define_method :initialize do
            end
            
            private
            alias_method :initialize__package_info_proxy, :initialize
          end
          @package_info = PackageInfoProxy.class
        end
      end
      return @package_info
    end
    
    typesig { [Class] }
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def get_annotation(annotation_class)
      return get_package_info.get_annotation(annotation_class)
    end
    
    typesig { [Class] }
    # @throws NullPointerException {@inheritDoc}
    # @since 1.5
    def is_annotation_present(annotation_class)
      return get_package_info.is_annotation_present(annotation_class)
    end
    
    typesig { [] }
    # @since 1.5
    def get_annotations
      return get_package_info.get_annotations
    end
    
    typesig { [] }
    # @since 1.5
    def get_declared_annotations
      return get_package_info.get_declared_annotations
    end
    
    typesig { [String, String, String, String, String, String, String, URL, ClassLoader] }
    # Construct a package instance with the specified version
    # information.
    # @param pkgName the name of the package
    # @param spectitle the title of the specification
    # @param specversion the version of the specification
    # @param specvendor the organization that maintains the specification
    # @param impltitle the title of the implementation
    # @param implversion the version of the implementation
    # @param implvendor the organization that maintains the implementation
    # @return a new package for containing the specified information.
    def initialize(name, spectitle, specversion, specvendor, impltitle, implversion, implvendor, sealbase, loader)
      @pkg_name = nil
      @spec_title = nil
      @spec_version = nil
      @spec_vendor = nil
      @impl_title = nil
      @impl_version = nil
      @impl_vendor = nil
      @seal_base = nil
      @loader = nil
      @package_info = nil
      @pkg_name = name
      @impl_title = impltitle
      @impl_version = implversion
      @impl_vendor = implvendor
      @spec_title = spectitle
      @spec_version = specversion
      @spec_vendor = specvendor
      @seal_base = sealbase
      @loader = loader
    end
    
    typesig { [String, Manifest, URL, ClassLoader] }
    # Construct a package using the attributes from the specified manifest.
    # 
    # @param name the package name
    # @param man the optional manifest for the package
    # @param url the optional code source url for the package
    def initialize(name, man, url, loader)
      @pkg_name = nil
      @spec_title = nil
      @spec_version = nil
      @spec_vendor = nil
      @impl_title = nil
      @impl_version = nil
      @impl_vendor = nil
      @seal_base = nil
      @loader = nil
      @package_info = nil
      path = name.replace(Character.new(?..ord), Character.new(?/.ord)).concat("/")
      sealed = nil
      spec_title = nil
      spec_version = nil
      spec_vendor = nil
      impl_title = nil
      impl_version = nil
      impl_vendor = nil
      seal_base = nil
      attr = man.get_attributes(path)
      if (!(attr).nil?)
        spec_title = (attr.get_value(Name::SPECIFICATION_TITLE)).to_s
        spec_version = (attr.get_value(Name::SPECIFICATION_VERSION)).to_s
        spec_vendor = (attr.get_value(Name::SPECIFICATION_VENDOR)).to_s
        impl_title = (attr.get_value(Name::IMPLEMENTATION_TITLE)).to_s
        impl_version = (attr.get_value(Name::IMPLEMENTATION_VERSION)).to_s
        impl_vendor = (attr.get_value(Name::IMPLEMENTATION_VENDOR)).to_s
        sealed = (attr.get_value(Name::SEALED)).to_s
      end
      attr = man.get_main_attributes
      if (!(attr).nil?)
        if ((spec_title).nil?)
          spec_title = (attr.get_value(Name::SPECIFICATION_TITLE)).to_s
        end
        if ((spec_version).nil?)
          spec_version = (attr.get_value(Name::SPECIFICATION_VERSION)).to_s
        end
        if ((spec_vendor).nil?)
          spec_vendor = (attr.get_value(Name::SPECIFICATION_VENDOR)).to_s
        end
        if ((impl_title).nil?)
          impl_title = (attr.get_value(Name::IMPLEMENTATION_TITLE)).to_s
        end
        if ((impl_version).nil?)
          impl_version = (attr.get_value(Name::IMPLEMENTATION_VERSION)).to_s
        end
        if ((impl_vendor).nil?)
          impl_vendor = (attr.get_value(Name::IMPLEMENTATION_VENDOR)).to_s
        end
        if ((sealed).nil?)
          sealed = (attr.get_value(Name::SEALED)).to_s
        end
      end
      if ("true".equals_ignore_case(sealed))
        seal_base = url
      end
      @pkg_name = name
      @spec_title = spec_title
      @spec_version = spec_version
      @spec_vendor = spec_vendor
      @impl_title = impl_title
      @impl_version = impl_version
      @impl_vendor = impl_vendor
      @seal_base = seal_base
      @loader = loader
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the loaded system package for the specified name.
      def get_system_package(name)
        synchronized((self.attr_pkgs)) do
          pkg = self.attr_pkgs.get(name)
          if ((pkg).nil?)
            name = (name.replace(Character.new(?..ord), Character.new(?/.ord)).concat("/")).to_s
            fn = get_system_package0(name)
            if (!(fn).nil?)
              pkg = define_system_package(name, fn)
            end
          end
          return pkg
        end
      end
      
      typesig { [] }
      # Return an array of loaded system packages.
      def get_system_packages
        # First, update the system package map with new package names
        names = get_system_packages0
        synchronized((self.attr_pkgs)) do
          i = 0
          while i < names.attr_length
            define_system_package(names[i], get_system_package0(names[i]))
            i += 1
          end
          return self.attr_pkgs.values.to_array(Array.typed(Package).new(self.attr_pkgs.size) { nil })
        end
      end
      
      typesig { [String, String] }
      def define_system_package(iname, fn)
        return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Package
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            name = iname
            # Get the cached code source url for the file name
            url = self.attr_urls.get(fn)
            if ((url).nil?)
              # URL not found, so create one
              file = JavaFile.new(fn)
              begin
                url = ParseUtil.file_to_encoded_url(file)
              rescue MalformedURLException => e
              end
              if (!(url).nil?)
                self.attr_urls.put(fn, url)
                # If loading a JAR file, then also cache the manifest
                if (file.is_file)
                  self.attr_mans.put(fn, load_manifest(fn))
                end
              end
            end
            # Convert to "."-separated package name
            name = (name.substring(0, name.length - 1).replace(Character.new(?/.ord), Character.new(?..ord))).to_s
            pkg = nil
            man = self.attr_mans.get(fn)
            if (!(man).nil?)
              pkg = Package.new(name, man, url, nil)
            else
              pkg = Package.new(name, nil, nil, nil, nil, nil, nil, nil, nil)
            end
            self.attr_pkgs.put(name, pkg)
            return pkg
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [String] }
      # Returns the Manifest for the specified JAR file name.
      def load_manifest(fn)
        begin
          fis = FileInputStream.new(fn)
          jis = JarInputStream.new(fis, false)
          man = jis.get_manifest
          jis.close
          return man
        rescue IOException => e
          return nil
        end
      end
      
      # The map of loaded system packages
      
      def pkgs
        defined?(@@pkgs) ? @@pkgs : @@pkgs= HashMap.new(31)
      end
      alias_method :attr_pkgs, :pkgs
      
      def pkgs=(value)
        @@pkgs = value
      end
      alias_method :attr_pkgs=, :pkgs=
      
      # Maps each directory or zip file name to its corresponding url
      
      def urls
        defined?(@@urls) ? @@urls : @@urls= HashMap.new(10)
      end
      alias_method :attr_urls, :urls
      
      def urls=(value)
        @@urls = value
      end
      alias_method :attr_urls=, :urls=
      
      # Maps each code source url for a jar file to its manifest
      
      def mans
        defined?(@@mans) ? @@mans : @@mans= HashMap.new(10)
      end
      alias_method :attr_mans, :mans
      
      def mans=(value)
        @@mans = value
      end
      alias_method :attr_mans=, :mans=
      
      JNI.native_method :Java_java_lang_Package_getSystemPackage0, [:pointer, :long, :long], :long
      typesig { [String] }
      def get_system_package0(name)
        JNI.__send__(:Java_java_lang_Package_getSystemPackage0, JNI.env, self.jni_id, name.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Package_getSystemPackages0, [:pointer, :long], :long
      typesig { [] }
      def get_system_packages0
        JNI.__send__(:Java_java_lang_Package_getSystemPackages0, JNI.env, self.jni_id)
      end
    }
    
    # Private storage for the package name and attributes.
    attr_accessor :pkg_name
    alias_method :attr_pkg_name, :pkg_name
    undef_method :pkg_name
    alias_method :attr_pkg_name=, :pkg_name=
    undef_method :pkg_name=
    
    attr_accessor :spec_title
    alias_method :attr_spec_title, :spec_title
    undef_method :spec_title
    alias_method :attr_spec_title=, :spec_title=
    undef_method :spec_title=
    
    attr_accessor :spec_version
    alias_method :attr_spec_version, :spec_version
    undef_method :spec_version
    alias_method :attr_spec_version=, :spec_version=
    undef_method :spec_version=
    
    attr_accessor :spec_vendor
    alias_method :attr_spec_vendor, :spec_vendor
    undef_method :spec_vendor
    alias_method :attr_spec_vendor=, :spec_vendor=
    undef_method :spec_vendor=
    
    attr_accessor :impl_title
    alias_method :attr_impl_title, :impl_title
    undef_method :impl_title
    alias_method :attr_impl_title=, :impl_title=
    undef_method :impl_title=
    
    attr_accessor :impl_version
    alias_method :attr_impl_version, :impl_version
    undef_method :impl_version
    alias_method :attr_impl_version=, :impl_version=
    undef_method :impl_version=
    
    attr_accessor :impl_vendor
    alias_method :attr_impl_vendor, :impl_vendor
    undef_method :impl_vendor
    alias_method :attr_impl_vendor=, :impl_vendor=
    undef_method :impl_vendor=
    
    attr_accessor :seal_base
    alias_method :attr_seal_base, :seal_base
    undef_method :seal_base
    alias_method :attr_seal_base=, :seal_base=
    undef_method :seal_base=
    
    attr_accessor :loader
    alias_method :attr_loader, :loader
    undef_method :loader
    alias_method :attr_loader=, :loader=
    undef_method :loader=
    
    attr_accessor :package_info
    alias_method :attr_package_info, :package_info
    undef_method :package_info
    alias_method :attr_package_info=, :package_info=
    undef_method :package_info=
    
    private
    alias_method :initialize__package, :initialize
  end
  
end

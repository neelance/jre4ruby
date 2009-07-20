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
module Java::Util::Jar
  module JarFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include ::Java::Io
      include_const ::Java::Lang::Ref, :SoftReference
      include ::Java::Util
      include ::Java::Util::Zip
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Util, :ManifestEntryVerifier
      include_const ::Sun::Misc, :SharedSecrets
    }
  end
  
  # The <code>JarFile</code> class is used to read the contents of a jar file
  # from any file that can be opened with <code>java.io.RandomAccessFile</code>.
  # It extends the class <code>java.util.zip.ZipFile</code> with support
  # for reading an optional <code>Manifest</code> entry. The
  # <code>Manifest</code> can be used to specify meta-information about the
  # jar file and its entries.
  # 
  # <p> Unless otherwise noted, passing a <tt>null</tt> argument to a constructor
  # or method in this class will cause a {@link NullPointerException} to be
  # thrown.
  # 
  # @author  David Connelly
  # @see     Manifest
  # @see     java.util.zip.ZipFile
  # @see     java.util.jar.JarEntry
  # @since   1.2
  class JarFile < JarFileImports.const_get :ZipFile
    include_class_members JarFileImports
    
    attr_accessor :man_ref
    alias_method :attr_man_ref, :man_ref
    undef_method :man_ref
    alias_method :attr_man_ref=, :man_ref=
    undef_method :man_ref=
    
    attr_accessor :man_entry
    alias_method :attr_man_entry, :man_entry
    undef_method :man_entry
    alias_method :attr_man_entry=, :man_entry=
    undef_method :man_entry=
    
    attr_accessor :jv
    alias_method :attr_jv, :jv
    undef_method :jv
    alias_method :attr_jv=, :jv=
    undef_method :jv=
    
    attr_accessor :jv_initialized
    alias_method :attr_jv_initialized, :jv_initialized
    undef_method :jv_initialized
    alias_method :attr_jv_initialized=, :jv_initialized=
    undef_method :jv_initialized=
    
    attr_accessor :verify
    alias_method :attr_verify, :verify
    undef_method :verify
    alias_method :attr_verify=, :verify=
    undef_method :verify=
    
    attr_accessor :computed_has_class_path_attribute
    alias_method :attr_computed_has_class_path_attribute, :computed_has_class_path_attribute
    undef_method :computed_has_class_path_attribute
    alias_method :attr_computed_has_class_path_attribute=, :computed_has_class_path_attribute=
    undef_method :computed_has_class_path_attribute=
    
    attr_accessor :has_class_path_attribute
    alias_method :attr_has_class_path_attribute, :has_class_path_attribute
    undef_method :has_class_path_attribute
    alias_method :attr_has_class_path_attribute=, :has_class_path_attribute=
    undef_method :has_class_path_attribute=
    
    class_module.module_eval {
      # Set up JavaUtilJarAccess in SharedSecrets
      when_class_loaded do
        SharedSecrets.set_java_util_jar_access(JavaUtilJarAccessImpl.new)
      end
      
      # The JAR manifest file name.
      const_set_lazy(:MANIFEST_NAME) { "META-INF/MANIFEST.MF" }
      const_attr_reader  :MANIFEST_NAME
    }
    
    typesig { [String] }
    # Creates a new <code>JarFile</code> to read from the specified
    # file <code>name</code>. The <code>JarFile</code> will be verified if
    # it is signed.
    # @param name the name of the jar file to be opened for reading
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if access to the file is denied
    # by the SecurityManager
    def initialize(name)
      initialize__jar_file(JavaFile.new(name), true, ZipFile::OPEN_READ)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Creates a new <code>JarFile</code> to read from the specified
    # file <code>name</code>.
    # @param name the name of the jar file to be opened for reading
    # @param verify whether or not to verify the jar file if
    # it is signed.
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if access to the file is denied
    # by the SecurityManager
    def initialize(name, verify)
      initialize__jar_file(JavaFile.new(name), verify, ZipFile::OPEN_READ)
    end
    
    typesig { [JavaFile] }
    # Creates a new <code>JarFile</code> to read from the specified
    # <code>File</code> object. The <code>JarFile</code> will be verified if
    # it is signed.
    # @param file the jar file to be opened for reading
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if access to the file is denied
    # by the SecurityManager
    def initialize(file)
      initialize__jar_file(file, true, ZipFile::OPEN_READ)
    end
    
    typesig { [JavaFile, ::Java::Boolean] }
    # Creates a new <code>JarFile</code> to read from the specified
    # <code>File</code> object.
    # @param file the jar file to be opened for reading
    # @param verify whether or not to verify the jar file if
    # it is signed.
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if access to the file is denied
    # by the SecurityManager.
    def initialize(file, verify)
      initialize__jar_file(file, verify, ZipFile::OPEN_READ)
    end
    
    typesig { [JavaFile, ::Java::Boolean, ::Java::Int] }
    # Creates a new <code>JarFile</code> to read from the specified
    # <code>File</code> object in the specified mode.  The mode argument
    # must be either <tt>OPEN_READ</tt> or <tt>OPEN_READ | OPEN_DELETE</tt>.
    # 
    # @param file the jar file to be opened for reading
    # @param verify whether or not to verify the jar file if
    # it is signed.
    # @param mode the mode in which the file is to be opened
    # @throws IOException if an I/O error has occurred
    # @throws IllegalArgumentException
    # if the <tt>mode</tt> argument is invalid
    # @throws SecurityException if access to the file is denied
    # by the SecurityManager
    # @since 1.3
    def initialize(file, verify, mode)
      @man_ref = nil
      @man_entry = nil
      @jv = nil
      @jv_initialized = false
      @verify = false
      @computed_has_class_path_attribute = false
      @has_class_path_attribute = false
      super(file, mode)
      @verify = verify
    end
    
    typesig { [] }
    # Returns the jar file manifest, or <code>null</code> if none.
    # 
    # @return the jar file manifest, or <code>null</code> if none
    # 
    # @throws IllegalStateException
    # may be thrown if the jar file has been closed
    def get_manifest
      return get_manifest_from_reference
    end
    
    typesig { [] }
    def get_manifest_from_reference
      man = !(@man_ref).nil? ? @man_ref.get : nil
      if ((man).nil?)
        man_entry = get_man_entry
        # If found then load the manifest
        if (!(man_entry).nil?)
          if (@verify)
            b = get_bytes(man_entry)
            man = Manifest.new(ByteArrayInputStream.new(b))
            if (!@jv_initialized)
              @jv = JarVerifier.new(b)
            end
          else
            man = Manifest.new(ZipFile.instance_method(:get_input_stream).bind(self).call(man_entry))
          end
          @man_ref = SoftReference.new(man)
        end
      end
      return man
    end
    
    JNI.native_method :Java_java_util_jar_JarFile_getMetaInfEntryNames, [:pointer, :long], :long
    typesig { [] }
    def get_meta_inf_entry_names
      JNI.__send__(:Java_java_util_jar_JarFile_getMetaInfEntryNames, JNI.env, self.jni_id)
    end
    
    typesig { [String] }
    # Returns the <code>JarEntry</code> for the given entry name or
    # <code>null</code> if not found.
    # 
    # @param name the jar file entry name
    # @return the <code>JarEntry</code> for the given entry name or
    # <code>null</code> if not found.
    # 
    # @throws IllegalStateException
    # may be thrown if the jar file has been closed
    # 
    # @see java.util.jar.JarEntry
    def get_jar_entry(name)
      return get_entry(name)
    end
    
    typesig { [String] }
    # Returns the <code>ZipEntry</code> for the given entry name or
    # <code>null</code> if not found.
    # 
    # @param name the jar file entry name
    # @return the <code>ZipEntry</code> for the given entry name or
    # <code>null</code> if not found
    # 
    # @throws IllegalStateException
    # may be thrown if the jar file has been closed
    # 
    # @see java.util.zip.ZipEntry
    def get_entry(name)
      ze = super(name)
      if (!(ze).nil?)
        return JarFileEntry.new_local(self, ze)
      end
      return nil
    end
    
    typesig { [] }
    # Returns an enumeration of the zip file entries.
    def entries
      enum_ = super
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members JarFile
        include Enumeration if Enumeration.class == Module
        
        typesig { [] }
        define_method :has_more_elements do
          return enum_.has_more_elements
        end
        
        typesig { [] }
        define_method :next_element do
          ze = enum_.next_element
          return JarFileEntry.new(ze)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:JarFileEntry) { Class.new(JarEntry) do
        extend LocalClass
        include_class_members JarFile
        
        typesig { [ZipEntry] }
        def initialize(ze)
          super(ze)
        end
        
        typesig { [] }
        def get_attributes
          man = @local_class_parent.get_manifest
          if (!(man).nil?)
            return man.get_attributes(get_name)
          else
            return nil
          end
        end
        
        typesig { [] }
        def get_certificates
          begin
            maybe_instantiate_verifier
          rescue IOException => e
            raise RuntimeException.new(e)
          end
          if ((self.attr_certs).nil? && !(self.attr_jv).nil?)
            self.attr_certs = self.attr_jv.get_certs(get_name)
          end
          return (self.attr_certs).nil? ? nil : self.attr_certs.clone
        end
        
        typesig { [] }
        def get_code_signers
          begin
            maybe_instantiate_verifier
          rescue IOException => e
            raise RuntimeException.new(e)
          end
          if ((self.attr_signers).nil? && !(self.attr_jv).nil?)
            self.attr_signers = self.attr_jv.get_code_signers(get_name)
          end
          return (self.attr_signers).nil? ? nil : self.attr_signers.clone
        end
        
        private
        alias_method :initialize__jar_file_entry, :initialize
      end }
    }
    
    typesig { [] }
    # Ensures that the JarVerifier has been created if one is
    # necessary (i.e., the jar appears to be signed.) This is done as
    # a quick check to avoid processing of the manifest for unsigned
    # jars.
    def maybe_instantiate_verifier
      if (!(@jv).nil?)
        return
      end
      if (@verify)
        names = get_meta_inf_entry_names
        if (!(names).nil?)
          i = 0
          while i < names.attr_length
            name = names[i].to_upper_case(Locale::ENGLISH)
            if (name.ends_with(".DSA") || name.ends_with(".RSA") || name.ends_with(".SF"))
              # Assume since we found a signature-related file
              # that the jar is signed and that we therefore
              # need a JarVerifier and Manifest
              get_manifest
              return
            end
            i += 1
          end
        end
        # No signature-related files; don't instantiate a
        # verifier
        @verify = false
      end
    end
    
    typesig { [] }
    # Initializes the verifier object by reading all the manifest
    # entries and passing them to the verifier.
    def initialize_verifier
      mev = nil
      # Verify "META-INF/" entries...
      begin
        names = get_meta_inf_entry_names
        if (!(names).nil?)
          i = 0
          while i < names.attr_length
            e = get_jar_entry(names[i])
            if (!e.is_directory)
              if ((mev).nil?)
                mev = ManifestEntryVerifier.new(get_manifest_from_reference)
              end
              b = get_bytes(e)
              if (!(b).nil? && b.attr_length > 0)
                @jv.begin_entry(e, mev)
                @jv.update(b.attr_length, b, 0, b.attr_length, mev)
                @jv.update(-1, nil, 0, 0, mev)
              end
            end
            i += 1
          end
        end
      rescue IOException => ex
        # if we had an error parsing any blocks, just
        # treat the jar file as being unsigned
        @jv = nil
        @verify = false
      end
      # if after initializing the verifier we have nothing
      # signed, we null it out.
      if (!(@jv).nil?)
        @jv.done_with_meta
        if (!(JarVerifier.attr_debug).nil?)
          JarVerifier.attr_debug.println("done with meta!")
        end
        if (@jv.nothing_to_verify)
          if (!(JarVerifier.attr_debug).nil?)
            JarVerifier.attr_debug.println("nothing to verify!")
          end
          @jv = nil
          @verify = false
        end
      end
    end
    
    typesig { [ZipEntry] }
    # Reads all the bytes for a given entry. Used to process the
    # META-INF files.
    def get_bytes(ze)
      b = Array.typed(::Java::Byte).new(RJava.cast_to_int(ze.get_size)) { 0 }
      is = DataInputStream.new(ZipFile.instance_method(:get_input_stream).bind(self).call(ze))
      is.read_fully(b, 0, b.attr_length)
      is.close
      return b
    end
    
    typesig { [ZipEntry] }
    # Returns an input stream for reading the contents of the specified
    # zip file entry.
    # @param ze the zip file entry
    # @return an input stream for reading the contents of the specified
    # zip file entry
    # @throws ZipException if a zip file format error has occurred
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if any of the jar file entries
    # are incorrectly signed.
    # @throws IllegalStateException
    # may be thrown if the jar file has been closed
    def get_input_stream(ze)
      synchronized(self) do
        maybe_instantiate_verifier
        if ((@jv).nil?)
          return super(ze)
        end
        if (!@jv_initialized)
          initialize_verifier
          @jv_initialized = true
          # could be set to null after a call to
          # initializeVerifier if we have nothing to
          # verify
          if ((@jv).nil?)
            return super(ze)
          end
        end
        # wrap a verifier stream around the real stream
        return JarVerifier::VerifierStream.new(get_manifest_from_reference, ze.is_a?(JarFileEntry) ? ze : get_jar_entry(ze.get_name), super(ze), @jv)
      end
    end
    
    class_module.module_eval {
      # Statics for hand-coded Boyer-Moore search in hasClassPathAttribute()
      # The bad character shift for "class-path"
      
      def last_occ
        defined?(@@last_occ) ? @@last_occ : @@last_occ= nil
      end
      alias_method :attr_last_occ, :last_occ
      
      def last_occ=(value)
        @@last_occ = value
      end
      alias_method :attr_last_occ=, :last_occ=
      
      # The good suffix shift for "class-path"
      
      def opto_sft
        defined?(@@opto_sft) ? @@opto_sft : @@opto_sft= nil
      end
      alias_method :attr_opto_sft, :opto_sft
      
      def opto_sft=(value)
        @@opto_sft = value
      end
      alias_method :attr_opto_sft=, :opto_sft=
      
      # Initialize the shift arrays to search for "class-path"
      
      def src
        defined?(@@src) ? @@src : @@src= Array.typed(::Java::Char).new([Character.new(?c.ord), Character.new(?l.ord), Character.new(?a.ord), Character.new(?s.ord), Character.new(?s.ord), Character.new(?-.ord), Character.new(?p.ord), Character.new(?a.ord), Character.new(?t.ord), Character.new(?h.ord)])
      end
      alias_method :attr_src, :src
      
      def src=(value)
        @@src = value
      end
      alias_method :attr_src=, :src=
      
      when_class_loaded do
        self.attr_last_occ = Array.typed(::Java::Int).new(128) { 0 }
        self.attr_opto_sft = Array.typed(::Java::Int).new(10) { 0 }
        self.attr_last_occ[RJava.cast_to_int(Character.new(?c.ord))] = 1
        self.attr_last_occ[RJava.cast_to_int(Character.new(?l.ord))] = 2
        self.attr_last_occ[RJava.cast_to_int(Character.new(?s.ord))] = 5
        self.attr_last_occ[RJava.cast_to_int(Character.new(?-.ord))] = 6
        self.attr_last_occ[RJava.cast_to_int(Character.new(?p.ord))] = 7
        self.attr_last_occ[RJava.cast_to_int(Character.new(?a.ord))] = 8
        self.attr_last_occ[RJava.cast_to_int(Character.new(?t.ord))] = 9
        self.attr_last_occ[RJava.cast_to_int(Character.new(?h.ord))] = 10
        i = 0
        while i < 9
          self.attr_opto_sft[i] = 10
          i += 1
        end
        self.attr_opto_sft[9] = 1
      end
    }
    
    typesig { [] }
    def get_man_entry
      if ((@man_entry).nil?)
        # First look up manifest entry using standard name
        @man_entry = get_jar_entry(MANIFEST_NAME)
        if ((@man_entry).nil?)
          # If not found, then iterate through all the "META-INF/"
          # entries to find a match.
          names = get_meta_inf_entry_names
          if (!(names).nil?)
            i = 0
            while i < names.attr_length
              if ((MANIFEST_NAME == names[i].to_upper_case(Locale::ENGLISH)))
                @man_entry = get_jar_entry(names[i])
                break
              end
              i += 1
            end
          end
        end
      end
      return @man_entry
    end
    
    typesig { [] }
    # Returns true iff this jar file has a manifest with a class path
    # attribute. Returns false if there is no manifest or the manifest
    # does not contain a "Class-Path" attribute. Currently exported to
    # core libraries via sun.misc.SharedSecrets.
    def has_class_path_attribute
      if (@computed_has_class_path_attribute)
        return @has_class_path_attribute
      end
      @has_class_path_attribute = false
      if (!is_known_to_not_have_class_path_attribute)
        man_entry = get_man_entry
        if (!(man_entry).nil?)
          b = Array.typed(::Java::Byte).new(RJava.cast_to_int(man_entry.get_size)) { 0 }
          dis = DataInputStream.new(ZipFile.instance_method(:get_input_stream).bind(self).call(man_entry))
          dis.read_fully(b, 0, b.attr_length)
          dis.close
          last = b.attr_length - self.attr_src.attr_length
          i = 0
          while (i <= last)
            catch(:next_next) do
              j = 9
              while j >= 0
                c = RJava.cast_to_char(b[i + j])
                c = (((c - Character.new(?A.ord)) | (Character.new(?Z.ord) - c)) >= 0) ? RJava.cast_to_char((c + 32)) : c
                if (!(c).equal?(self.attr_src[j]))
                  i += Math.max(j + 1 - self.attr_last_occ[c & 0x7f], self.attr_opto_sft[j])
                  throw :next_next, :thrown
                end
                j -= 1
              end
              @has_class_path_attribute = true
              break
            end
          end
        end
      end
      @computed_has_class_path_attribute = true
      return @has_class_path_attribute
    end
    
    class_module.module_eval {
      
      def java_home
        defined?(@@java_home) ? @@java_home : @@java_home= nil
      end
      alias_method :attr_java_home, :java_home
      
      def java_home=(value)
        @@java_home = value
      end
      alias_method :attr_java_home=, :java_home=
      
      
      def jar_names
        defined?(@@jar_names) ? @@jar_names : @@jar_names= nil
      end
      alias_method :attr_jar_names, :jar_names
      
      def jar_names=(value)
        @@jar_names = value
      end
      alias_method :attr_jar_names=, :jar_names=
    }
    
    typesig { [] }
    def is_known_to_not_have_class_path_attribute
      # Optimize away even scanning of manifest for jar files we
      # deliver which don't have a class-path attribute. If one of
      # these jars is changed to include such an attribute this code
      # must be changed.
      if ((self.attr_java_home).nil?)
        self.attr_java_home = (AccessController.do_privileged(GetPropertyAction.new("java.home"))).to_s
      end
      if ((self.attr_jar_names).nil?)
        names = Array.typed(String).new(10) { nil }
        file_sep = JavaFile.attr_separator
        i = 0
        names[((i += 1) - 1)] = file_sep + "rt.jar"
        names[((i += 1) - 1)] = file_sep + "sunrsasign.jar"
        names[((i += 1) - 1)] = file_sep + "jsse.jar"
        names[((i += 1) - 1)] = file_sep + "jce.jar"
        names[((i += 1) - 1)] = file_sep + "charsets.jar"
        names[((i += 1) - 1)] = file_sep + "dnsns.jar"
        names[((i += 1) - 1)] = file_sep + "ldapsec.jar"
        names[((i += 1) - 1)] = file_sep + "localedata.jar"
        names[((i += 1) - 1)] = file_sep + "sunjce_provider.jar"
        names[((i += 1) - 1)] = file_sep + "sunpkcs11.jar"
        self.attr_jar_names = names
      end
      name = get_name
      local_java_home = self.attr_java_home
      if (name.starts_with(local_java_home))
        names = self.attr_jar_names
        i = 0
        while i < names.attr_length
          if (name.ends_with(names[i]))
            return true
          end
          i += 1
        end
      end
      return false
    end
    
    private
    alias_method :initialize__jar_file, :initialize
  end
  
end

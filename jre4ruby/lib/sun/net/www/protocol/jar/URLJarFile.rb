require "rjava"

# 
# Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Jar
  module URLJarFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Jar
      include ::Java::Io
      include ::Java::Net
      include ::Java::Util
      include ::Java::Util::Jar
      include_const ::Java::Util::Zip, :ZipFile
      include_const ::Java::Util::Zip, :ZipEntry
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # URL jar file is a common JarFile subtype used for JarURLConnection
  class URLJarFile < URLJarFileImports.const_get :JarFile
    include_class_members URLJarFileImports
    
    class_module.module_eval {
      # 
      # Interface to be able to call retrieve() in plugin if
      # this variable is set.
      
      def callback
        defined?(@@callback) ? @@callback : @@callback= nil
      end
      alias_method :attr_callback, :callback
      
      def callback=(value)
        @@callback = value
      end
      alias_method :attr_callback=, :callback=
    }
    
    # Controller of the Jar File's closing
    attr_accessor :close_controller
    alias_method :attr_close_controller, :close_controller
    undef_method :close_controller
    alias_method :attr_close_controller=, :close_controller=
    undef_method :close_controller=
    
    class_module.module_eval {
      
      def buf_size
        defined?(@@buf_size) ? @@buf_size : @@buf_size= 2048
      end
      alias_method :attr_buf_size, :buf_size
      
      def buf_size=(value)
        @@buf_size = value
      end
      alias_method :attr_buf_size=, :buf_size=
    }
    
    attr_accessor :super_man
    alias_method :attr_super_man, :super_man
    undef_method :super_man
    alias_method :attr_super_man=, :super_man=
    undef_method :super_man=
    
    attr_accessor :super_attr
    alias_method :attr_super_attr, :super_attr
    undef_method :super_attr
    alias_method :attr_super_attr=, :super_attr=
    undef_method :super_attr=
    
    attr_accessor :super_entries
    alias_method :attr_super_entries, :super_entries
    undef_method :super_entries
    alias_method :attr_super_entries=, :super_entries=
    undef_method :super_entries=
    
    class_module.module_eval {
      typesig { [URL] }
      def get_jar_file(url)
        return get_jar_file(url, nil)
      end
      
      typesig { [URL, URLJarFileCloseController] }
      def get_jar_file(url, close_controller)
        if (is_file_url(url))
          return URLJarFile.new(url, close_controller)
        else
          return retrieve(url, close_controller)
        end
      end
    }
    
    typesig { [JavaFile] }
    # 
    # Changed modifier from private to public in order to be able
    # to instantiate URLJarFile from sun.plugin package.
    def initialize(file)
      initialize__urljar_file(file, nil)
    end
    
    typesig { [JavaFile, URLJarFileCloseController] }
    # 
    # Changed modifier from private to public in order to be able
    # to instantiate URLJarFile from sun.plugin package.
    def initialize(file, close_controller)
      @close_controller = nil
      @super_man = nil
      @super_attr = nil
      @super_entries = nil
      super(file, true, ZipFile::OPEN_READ | ZipFile::OPEN_DELETE)
      @close_controller = nil
      @close_controller = close_controller
    end
    
    typesig { [URL, URLJarFileCloseController] }
    def initialize(url, close_controller)
      @close_controller = nil
      @super_man = nil
      @super_attr = nil
      @super_entries = nil
      super(ParseUtil.decode(url.get_file))
      @close_controller = nil
      @close_controller = close_controller
    end
    
    class_module.module_eval {
      typesig { [URL] }
      def is_file_url(url)
        if (url.get_protocol.equals_ignore_case("file"))
          # 
          # Consider this a 'file' only if it's a LOCAL file, because
          # 'file:' URLs can be accessible through ftp.
          host = url.get_host
          if ((host).nil? || (host == "") || (host == "~") || host.equals_ignore_case("localhost"))
            return true
          end
        end
        return false
      end
    }
    
    typesig { [] }
    # 
    # close the jar file.
    def finalize
      close
    end
    
    typesig { [String] }
    # 
    # Returns the <code>ZipEntry</code> for the given entry name or
    # <code>null</code> if not found.
    # 
    # @param name the JAR file entry name
    # @return the <code>ZipEntry</code> for the given entry name or
    # <code>null</code> if not found
    # @see java.util.zip.ZipEntry
    def get_entry(name)
      ze = super(name)
      if (!(ze).nil?)
        if (ze.is_a?(JarEntry))
          return URLJarFileEntry.new_local(self, ze)
        else
          raise InternalError.new((JarFile.instance_method(:get_class).bind(self).call).to_s + " returned unexpected entry type " + (ze.get_class).to_s)
        end
      end
      return nil
    end
    
    typesig { [] }
    def get_manifest
      if (!is_super_man)
        return nil
      end
      man = Manifest.new
      attr = man.get_main_attributes
      attr.put_all(@super_attr.clone)
      # now deep copy the manifest entries
      if (!(@super_entries).nil?)
        entries = man.get_entries
        it = @super_entries.key_set.iterator
        while (it.has_next)
          key = it.next
          at = @super_entries.get(key)
          entries.put(key, at.clone)
        end
      end
      return man
    end
    
    typesig { [] }
    # If close controller is set the notify the controller about the pending close
    def close
      if (!(@close_controller).nil?)
        @close_controller.close(self)
      end
      super
    end
    
    typesig { [] }
    # optimal side-effects
    def is_super_man
      synchronized(self) do
        if ((@super_man).nil?)
          @super_man = JarFile.instance_method(:get_manifest).bind(self).call
        end
        if (!(@super_man).nil?)
          @super_attr = @super_man.get_main_attributes
          @super_entries = @super_man.get_entries
          return true
        else
          return false
        end
      end
    end
    
    class_module.module_eval {
      typesig { [URL] }
      # 
      # Given a URL, retrieves a JAR file, caches it to disk, and creates a
      # cached JAR file object.
      def retrieve(url)
        return retrieve(url, nil)
      end
      
      typesig { [URL, URLJarFileCloseController] }
      # 
      # Given a URL, retrieves a JAR file, caches it to disk, and creates a
      # cached JAR file object.
      def retrieve(url, close_controller)
        # 
        # See if interface is set, then call retrieve function of the class
        # that implements URLJarFileCallBack interface (sun.plugin - to
        # handle the cache failure for JARJAR file.)
        if (!(self.attr_callback).nil?)
          return self.attr_callback.retrieve(url)
        else
          result = nil
          # get the stream before asserting privileges
          in_ = url.open_connection.get_input_stream
          begin
            result = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members URLJarFile
              include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                out = nil
                tmp_file = nil
                begin
                  tmp_file = JavaFile.create_temp_file("jar_cache", nil)
                  tmp_file.delete_on_exit
                  out = FileOutputStream.new(tmp_file)
                  read = 0
                  buf = Array.typed(::Java::Byte).new(self.attr_buf_size) { 0 }
                  while (!((read = in_.read(buf))).equal?(-1))
                    out.write(buf, 0, read)
                  end
                  out.close
                  out = nil
                  return URLJarFile.new(tmp_file, close_controller)
                rescue IOException => e
                  if (!(tmp_file).nil?)
                    tmp_file.delete
                  end
                  raise e
                ensure
                  if (!(in_).nil?)
                    in_.close
                  end
                  if (!(out).nil?)
                    out.close
                  end
                end
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          rescue PrivilegedActionException => pae
            raise pae.get_exception
          end
          return result
        end
      end
      
      typesig { [URLJarFileCallBack] }
      # 
      # Set the call back interface to call retrive function in sun.plugin
      # package if plugin is running.
      def set_call_back(cb)
        self.attr_callback = cb
      end
      
      const_set_lazy(:URLJarFileEntry) { Class.new(JarEntry) do
        extend LocalClass
        include_class_members URLJarFile
        
        attr_accessor :je
        alias_method :attr_je, :je
        undef_method :je
        alias_method :attr_je=, :je=
        undef_method :je=
        
        typesig { [JarEntry] }
        def initialize(je)
          @je = nil
          super(je)
          @je = je
        end
        
        typesig { [] }
        def get_attributes
          if (@local_class_parent.is_super_man)
            e = @local_class_parent.attr_super_entries
            if (!(e).nil?)
              a = e.get(get_name)
              if (!(a).nil?)
                return a.clone
              end
            end
          end
          return nil
        end
        
        typesig { [] }
        def get_certificates
          certs = @je.get_certificates
          return (certs).nil? ? nil : certs.clone
        end
        
        typesig { [] }
        def get_code_signers
          csg = @je.get_code_signers
          return (csg).nil? ? nil : csg.clone
        end
        
        private
        alias_method :initialize__urljar_file_entry, :initialize
      end }
      
      const_set_lazy(:URLJarFileCloseController) { Module.new do
        include_class_members URLJarFile
        
        typesig { [JarFile] }
        def close(jar_file)
          raise NotImplementedError
        end
      end }
    }
    
    private
    alias_method :initialize__urljar_file, :initialize
  end
  
end

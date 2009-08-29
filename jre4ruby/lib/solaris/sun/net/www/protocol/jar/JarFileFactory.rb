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
module Sun::Net::Www::Protocol::Jar
  module JarFileFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Jar
      include ::Java::Io
      include ::Java::Net
      include ::Java::Util
      include ::Java::Util::Jar
      include_const ::Java::Util::Zip, :ZipFile
      include_const ::Java::Security, :Permission
    }
  end
  
  # A factory for cached JAR file. This class is used to both retrieve
  # and cache Jar files.
  # 
  # @author Benjamin Renaud
  # @since JDK1.2
  class JarFileFactory 
    include_class_members JarFileFactoryImports
    include URLJarFile::URLJarFileCloseController
    
    class_module.module_eval {
      # the url to file cache
      
      def file_cache
        defined?(@@file_cache) ? @@file_cache : @@file_cache= HashMap.new
      end
      alias_method :attr_file_cache, :file_cache
      
      def file_cache=(value)
        @@file_cache = value
      end
      alias_method :attr_file_cache=, :file_cache=
      
      # the file to url cache
      
      def url_cache
        defined?(@@url_cache) ? @@url_cache : @@url_cache= HashMap.new
      end
      alias_method :attr_url_cache, :url_cache
      
      def url_cache=(value)
        @@url_cache = value
      end
      alias_method :attr_url_cache=, :url_cache=
    }
    
    typesig { [JarFile] }
    def get_connection(jar_file)
      u = self.attr_url_cache.get(jar_file)
      if (!(u).nil?)
        return u.open_connection
      end
      return nil
    end
    
    typesig { [URL] }
    def get(url)
      return get(url, true)
    end
    
    typesig { [URL, ::Java::Boolean] }
    def get(url, use_caches)
      result = nil
      local_result = nil
      if (use_caches)
        synchronized((self)) do
          result = get_cached_jar_file(url)
        end
        if ((result).nil?)
          local_result = URLJarFile.get_jar_file(url, self)
          synchronized((self)) do
            result = get_cached_jar_file(url)
            if ((result).nil?)
              self.attr_file_cache.put(url, local_result)
              self.attr_url_cache.put(local_result, url)
              result = local_result
            else
              if (!(local_result).nil?)
                local_result.close
              end
            end
          end
        end
      else
        result = URLJarFile.get_jar_file(url, self)
      end
      if ((result).nil?)
        raise FileNotFoundException.new(url.to_s)
      end
      return result
    end
    
    typesig { [JarFile] }
    # Callback method of the URLJarFileCloseController to
    # indicate that the JarFile is close. This way we can
    # remove the JarFile from the cache
    def close(jar_file)
      url_removed = self.attr_url_cache.remove(jar_file)
      if (!(url_removed).nil?)
        self.attr_file_cache.remove(url_removed)
      end
    end
    
    typesig { [URL] }
    def get_cached_jar_file(url)
      result = self.attr_file_cache.get(url)
      # if the JAR file is cached, the permission will always be there
      if (!(result).nil?)
        perm = get_permission(result)
        if (!(perm).nil?)
          sm = System.get_security_manager
          if (!(sm).nil?)
            begin
              sm.check_permission(perm)
            rescue SecurityException => se
              # fallback to checkRead/checkConnect for pre 1.2
              # security managers
              if ((perm.is_a?(Java::Io::FilePermission)) && !(perm.get_actions.index_of("read")).equal?(-1))
                sm.check_read(perm.get_name)
              else
                if ((perm.is_a?(Java::Net::SocketPermission)) && !(perm.get_actions.index_of("connect")).equal?(-1))
                  sm.check_connect(url.get_host, url.get_port)
                else
                  raise se
                end
              end
            end
          end
        end
      end
      return result
    end
    
    typesig { [JarFile] }
    def get_permission(jar_file)
      begin
        uc = get_connection(jar_file)
        if (!(uc).nil?)
          return uc.get_permission
        end
      rescue IOException => ioe
        # gulp
      end
      return nil
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__jar_file_factory, :initialize
  end
  
end

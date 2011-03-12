require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ClassLoaderUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URLClassLoader
      include ::Java::Util
      include_const ::Java::Util::Jar, :JarFile
    }
  end
  
  # Provides utility functions related to URLClassLoaders or subclasses of it.
  # 
  #                  W  A  R  N  I  N  G
  # 
  # This class uses undocumented, unpublished, private data structures inside
  # java.net.URLClassLoader and sun.misc.URLClassPath.  Use with extreme caution.
  # 
  # @author      tjquinn
  class ClassLoaderUtil 
    include_class_members ClassLoaderUtilImports
    
    class_module.module_eval {
      typesig { [URLClassLoader] }
      # Releases resources held by a URLClassLoader. A new classloader must
      # be created before the underlying resources can be accessed again.
      # @param classLoader the instance of URLClassLoader (or a subclass)
      def release_loader(class_loader)
        release_loader(class_loader, nil)
      end
      
      typesig { [URLClassLoader, JavaList] }
      # Releases resources held by a URLClassLoader.  Notably, close the jars
      # opened by the loader. Initializes and updates the List of
      # jars that have been successfully closed.
      # <p>
      # @param classLoader the instance of URLClassLoader (or a subclass)
      # @param jarsClosed a List of Strings that will contain the names of jars
      #  successfully closed; can be null if the caller does not need the information returned
      # @return a List of IOExceptions reporting jars that failed to close; null
      # indicates that an error other than an IOException occurred attempting to
      # release the loader; empty indicates a successful release; non-empty
      # indicates at least one error attempting to close an open jar.
      def release_loader(class_loader, jars_closed)
        io_exceptions = LinkedList.new
        begin
          # Records all IOExceptions thrown while closing jar files.
          if (!(jars_closed).nil?)
            jars_closed.clear
          end
          System.out.println("classLoader = " + RJava.cast_to_string(class_loader))
          System.out.println("SharedSecrets.getJavaNetAccess()=" + RJava.cast_to_string(SharedSecrets.get_java_net_access))
          ucp = SharedSecrets.get_java_net_access.get_urlclass_path(class_loader)
          loaders = ucp.attr_loaders
          urls = ucp.attr_urls
          lmap = ucp.attr_lmap
          # The urls variable in the URLClassPath object holds URLs that have not yet
          # been used to resolve a resource or load a class and, therefore, do
          # not yet have a loader associated with them.  Clear the stack so any
          # future requests that might incorrectly reach the loader cannot be
          # resolved and cannot open a jar file after we think we've closed
          # them all.
          synchronized((urls)) do
            urls.clear
          end
          # Also clear the map of URLs to loaders so the class loader cannot use
          # previously-opened jar files - they are about to be closed.
          synchronized((lmap)) do
            lmap.clear
          end
          # The URLClassPath object's path variable records the list of all URLs that are on
          # the URLClassPath's class path.  Leave that unchanged.  This might
          # help someone trying to debug why a released class loader is still used.
          # Because the stack and lmap are now clear, code that incorrectly uses a
          # the released class loader will trigger an exception if the
          # class or resource would have been resolved by the class
          # loader (and no other) if it had not been released.
          # 
          # The list of URLs might provide some hints to the person as to where
          # in the code the class loader was set up, which might in turn suggest
          # where in the code the class loader needs to stop being used.
          # The URLClassPath does not use the path variable to open new jar
          # files - it uses the urls Stack for that - so leaving the path variable
          # will not by itself allow the class loader to continue handling requests.
          # For each loader, close the jar file associated with that loader.
          # 
          # The URLClassPath's use of loaders is sync-ed on the entire URLClassPath
          # object.
          synchronized((ucp)) do
            loaders.each do |o|
              if (!(o).nil?)
                # If the loader is a JarLoader inner class and its jarFile
                # field is non-null then try to close that jar file.  Add
                # it to the list of closed files if successful.
                if (o.is_a?(URLClassPath::JarLoader))
                  jl = o
                  jar_file = jl.get_jar_file
                  begin
                    if (!(jar_file).nil?)
                      jar_file.close
                      if (!(jars_closed).nil?)
                        jars_closed.add(jar_file.get_name)
                      end
                    end
                  rescue IOException => ioe
                    # Wrap the IOException to identify which jar
                    # could not be closed and add it to the list
                    # of IOExceptions to be returned to the caller.
                    jar_file_name = ((jar_file).nil?) ? "filename not available" : jar_file.get_name
                    msg = "Error closing JAR file: " + jar_file_name
                    new_ioe = IOException.new(msg)
                    new_ioe.init_cause(ioe)
                    io_exceptions.add(new_ioe)
                  end
                end
              end
            end
            # Now clear the loaders ArrayList.
            loaders.clear
          end
        rescue JavaThrowable => t
          raise RuntimeException.new(t)
        end
        return io_exceptions
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__class_loader_util, :initialize
  end
  
end

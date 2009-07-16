require "rjava"

# 
# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MetaIndexImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :FileReader
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
    }
  end
  
  # 
  # MetaIndex is intended to decrease startup time (in particular cold
  # start, when files are not yet in the disk cache) by providing a
  # quick reject mechanism for probes into jar files. The on-disk
  # representation of the meta-index is a flat text file with per-jar
  # entries indicating (generally speaking) prefixes of package names
  # contained in the jar. As an example, here is an edited excerpt of
  # the meta-index generated for jre/lib in the current build:
  # 
  # <PRE>
  # % VERSION 1
  # # charsets.jar
  # sun/
  # # jce.jar
  # javax/
  # ! jsse.jar
  # sun/
  # com/sun/net/
  # javax/
  # com/sun/security/
  # @ resources.jar
  # com/sun/xml/
  # com/sun/rowset/
  # com/sun/org/
  # sun/
  # com/sun/imageio/
  # javax/
  # com/sun/java/swing/
  # META-INF/services/
  # com/sun/java/util/jar/pack/
  # com/sun/corba/
  # com/sun/jndi/
  # ! rt.jar
  # org/w3c/
  # com/sun/imageio/
  # javax/
  # sunw/util/
  # java/
  # sun/
  # ...
  # </PRE>
  # <p> A few notes about the design of the meta-index:
  # 
  # <UL>
  # 
  # <LI> It contains entries for multiple jar files. This is
  # intentional, to reduce the number of disk accesses that need to be
  # performed during startup.
  # 
  # <LI> It is only intended to act as a fast reject mechanism to
  # prevent application and other classes from forcing all jar files on
  # the boot and extension class paths to be opened. It is not intended
  # as a precise index of the contents of the jar.
  # 
  # <LI> It should be as small as possible to reduce the amount of time
  # required to parse it during startup. For example, adding on the
  # secondary package element to java/ and javax/ packages
  # ("javax/swing/", for example) causes the meta-index to grow
  # significantly. This is why substrings of the packages have been
  # chosen as the principal contents.
  # 
  # <LI> It is versioned, and optional, to prevent strong dependencies
  # between the JVM and JDK. It is also potentially applicable to more
  # than just the boot and extension class paths.
  # 
  # <LI> Precisely speaking, it plays different role in JVM and J2SE
  # side.  On the JVM side, meta-index file is used to speed up locating the
  # class files only while on the J2SE side, meta-index file is used to speed
  # up the resources file & class file.
  # To help the JVM and J2SE code to better utilize the information in meta-index
  # file, we mark the jar file differently. Here is the current rule we use.
  # For jar file containing only class file, we put '!' before the jar file name;
  # for jar file containing only resources file, we put '@' before the jar file name;
  # for jar file containing both resources and class file, we put '#' before the
  # jar name.
  # Notice the fact that every jar file contains at least the manifest file, so when
  # we say "jar file containing only class file", we don't include that file.
  # 
  # </UL>
  # 
  # <p> To avoid changing the behavior of the current application
  # loader and other loaders, the current MetaIndex implementation in
  # the JDK requires that the directory containing the meta-index be
  # registered with the MetaIndex class before construction of the
  # associated URLClassPath. This prevents the need for automatic
  # searching for the meta-index in the URLClassPath code and potential
  # changes in behavior for non-core ClassLoaders.
  # 
  # This class depends on make/tools/MetaIndex/BuildMetaIndex.java and
  # is used principally by sun.misc.URLClassPath.
  class MetaIndex 
    include_class_members MetaIndexImports
    
    class_module.module_eval {
      # Maps jar file names in registered directories to meta-indices
      
      def jar_map
        defined?(@@jar_map) ? @@jar_map : @@jar_map= nil
      end
      alias_method :attr_jar_map, :jar_map
      
      def jar_map=(value)
        @@jar_map = value
      end
      alias_method :attr_jar_map=, :jar_map=
    }
    
    # List of contents of this meta-index
    attr_accessor :contents
    alias_method :attr_contents, :contents
    undef_method :contents
    alias_method :attr_contents=, :contents=
    undef_method :contents=
    
    # Indicate whether the coresponding jar file is a pure class jar file or not
    attr_accessor :is_class_only_jar
    alias_method :attr_is_class_only_jar, :is_class_only_jar
    undef_method :is_class_only_jar
    alias_method :attr_is_class_only_jar=, :is_class_only_jar=
    undef_method :is_class_only_jar=
    
    class_module.module_eval {
      typesig { [JavaFile] }
      # ----------------------------------------------------------------------
      # Registration of directories (which can cause parsing of the
      # meta-index file if it is present), and fetching of parsed
      # meta-indices
      # jarMap is not strictly thread-safe when the meta index mechanism
      # is extended for user-provided jar files in future.
      def for_jar(jar)
        return get_jar_map.get(jar)
      end
      
      typesig { [JavaFile] }
      # 'synchronized' is added to protect the jarMap from being modified
      # by multiple threads.
      def register_directory(dir)
        synchronized(self) do
          # Note that this does not currently check to see whether the
          # directory has previously been registered, since the meta-index
          # in a particular directory creates multiple entries in the
          # jarMap. If this mechanism is extended beyond the boot and
          # extension class paths (for example, automatically searching for
          # meta-index files in directories containing jars which have been
          # explicitly opened) then this code should be generalized.
          # 
          # This method must be called from a privileged context.
          index_file = JavaFile.new(dir, "meta-index")
          if (index_file.exists)
            begin
              reader = BufferedReader.new(FileReader.new(index_file))
              line = nil
              cur_jar_name = nil
              is_cur_jar_contain_class_only = false
              contents = ArrayList.new
              map = get_jar_map
              # Convert dir into canonical form.
              dir = dir.get_canonical_file
              # Note: The first line should contain the version of
              # the meta-index file. We have to match the right version
              # before trying to parse this file.
              line = (reader.read_line).to_s
              if ((line).nil? || !(line == "% VERSION 2"))
                reader.close
                return
              end
              while (!((line = (reader.read_line).to_s)).nil?)
                catch(:break_case) do
                  case (line.char_at(0))
                  when Character.new(?!.ord), Character.new(?#.ord), Character.new(?@.ord)
                    # Store away current contents, if any
                    if ((!(cur_jar_name).nil?) && (contents.size > 0))
                      map.put(JavaFile.new(dir, cur_jar_name), MetaIndex.new(contents, is_cur_jar_contain_class_only))
                      contents.clear
                    end
                    # Fetch new current jar file name
                    cur_jar_name = (line.substring(2)).to_s
                    if ((line.char_at(0)).equal?(Character.new(?!.ord)))
                      is_cur_jar_contain_class_only = true
                    else
                      if (is_cur_jar_contain_class_only)
                        is_cur_jar_contain_class_only = false
                      end
                    end
                    throw :break_case, :thrown
                  when Character.new(?%.ord)
                  else
                    contents.add(line)
                  end
                end == :thrown or break
              end
              # Store away current contents, if any
              if ((!(cur_jar_name).nil?) && (contents.size > 0))
                map.put(JavaFile.new(dir, cur_jar_name), MetaIndex.new(contents, is_cur_jar_contain_class_only))
              end
              reader.close
            rescue IOException => e
              # Silently fail for now (similar behavior to elsewhere in
              # extension and core loaders)
            end
          end
        end
      end
    }
    
    typesig { [String] }
    # ----------------------------------------------------------------------
    # Public APIs
    def may_contain(entry)
      # Ask non-class file from class only jar returns false
      # This check is important to avoid some class only jar
      # files such as rt.jar are opened for resource request.
      if (@is_class_only_jar && !entry.ends_with(".class"))
        return false
      end
      conts = @contents
      i = 0
      while i < conts.attr_length
        if (entry.starts_with(conts[i]))
          return true
        end
        ((i += 1) - 1)
      end
      return false
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # ----------------------------------------------------------------------
    # Implementation only below this point
    # @IllegalArgumentException if entries is null.
    def initialize(entries, is_class_only_jar)
      @contents = nil
      @is_class_only_jar = false
      if ((entries).nil?)
        raise IllegalArgumentException.new
      end
      @contents = entries.to_array(Array.typed(String).new(0) { nil })
      @is_class_only_jar = is_class_only_jar
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_jar_map
        if ((self.attr_jar_map).nil?)
          synchronized((MetaIndex.class)) do
            if ((self.attr_jar_map).nil?)
              self.attr_jar_map = HashMap.new
            end
          end
        end
        raise AssertError if not (!(self.attr_jar_map).nil?)
        return self.attr_jar_map
      end
    }
    
    private
    alias_method :initialize__meta_index, :initialize
  end
  
end

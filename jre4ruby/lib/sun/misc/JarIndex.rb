require "rjava"

# Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JarIndexImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include ::Java::Io
      include ::Java::Util
      include ::Java::Util::Jar
      include ::Java::Util::Zip
    }
  end
  
  # This class is used to maintain mappings from packages, classes
  # and resources to their enclosing JAR files. Mappings are kept
  # at the package level except for class or resource files that
  # are located at the root directory. URLClassLoader uses the mapping
  # information to determine where to fetch an extension class or
  # resource from.
  # 
  # @author  Zhenghua Li
  # @since   1.3
  class JarIndex 
    include_class_members JarIndexImports
    
    # The hash map that maintains mappings from
    # package/classe/resource to jar file list(s)
    attr_accessor :index_map
    alias_method :attr_index_map, :index_map
    undef_method :index_map
    alias_method :attr_index_map=, :index_map=
    undef_method :index_map=
    
    # The hash map that maintains mappings from
    # jar file to package/class/resource lists
    attr_accessor :jar_map
    alias_method :attr_jar_map, :jar_map
    undef_method :jar_map
    alias_method :attr_jar_map=, :jar_map=
    undef_method :jar_map=
    
    # An ordered list of jar file names.
    attr_accessor :jar_files
    alias_method :attr_jar_files, :jar_files
    undef_method :jar_files
    alias_method :attr_jar_files=, :jar_files=
    undef_method :jar_files=
    
    class_module.module_eval {
      # The index file name.
      const_set_lazy(:INDEX_NAME) { "META-INF/INDEX.LIST" }
      const_attr_reader  :INDEX_NAME
    }
    
    typesig { [] }
    # Constructs a new, empty jar index.
    def initialize
      @index_map = nil
      @jar_map = nil
      @jar_files = nil
      @index_map = HashMap.new
      @jar_map = HashMap.new
    end
    
    typesig { [InputStream] }
    # Constructs a new index from the specified input stream.
    # 
    # @param is the input stream containing the index data
    def initialize(is)
      initialize__jar_index()
      read(is)
    end
    
    typesig { [Array.typed(String)] }
    # Constructs a new index for the specified list of jar files.
    # 
    # @param files the list of jar files to construct the index from.
    def initialize(files)
      initialize__jar_index()
      @jar_files = files
      parse_jars(files)
    end
    
    class_module.module_eval {
      typesig { [JarFile, MetaIndex] }
      # Returns the jar index, or <code>null</code> if none.
      # 
      # @param jar the JAR file to get the index from.
      # @exception IOException if an I/O error has occurred.
      def get_jar_index(jar, meta_index)
        index = nil
        # If metaIndex is not null, check the meta index to see
        # if META-INF/INDEX.LIST is contained in jar file or not.
        if (!(meta_index).nil? && !meta_index.may_contain(INDEX_NAME))
          return nil
        end
        e = jar.get_jar_entry(INDEX_NAME)
        # if found, then load the index
        if (!(e).nil?)
          index = JarIndex.new(jar.get_input_stream(e))
        end
        return index
      end
    }
    
    typesig { [] }
    # Returns the jar files that are defined in this index.
    def get_jar_files
      return @jar_files
    end
    
    typesig { [String, String, HashMap] }
    # Add the key, value pair to the hashmap, the value will
    # be put in a linked list which is created if necessary.
    def add_to_list(key, value, t)
      list = t.get(key)
      if ((list).nil?)
        list = LinkedList.new
        list.add(value)
        t.put(key, list)
      else
        if (!list.contains(value))
          list.add(value)
        end
      end
    end
    
    typesig { [String] }
    # Returns the list of jar files that are mapped to the file.
    # 
    # @param fileName the key of the mapping
    def get(file_name)
      jar_files = nil
      if (((jar_files = @index_map.get(file_name))).nil?)
        # try the package name again
        pos = 0
        if (!((pos = file_name.last_index_of("/"))).equal?(-1))
          jar_files = @index_map.get(file_name.substring(0, pos))
        end
      end
      return jar_files
    end
    
    typesig { [String, String] }
    # Add the mapping from the specified file to the specified
    # jar file. If there were no mapping for the package of the
    # specified file before, a new linked list will be created,
    # the jar file is added to the list and a new mapping from
    # the package to the jar file list is added to the hashmap.
    # Otherwise, the jar file will be added to the end of the
    # existing list.
    # 
    # @param fileName the file name
    # @param jarName the jar file that the file is mapped to
    def add(file_name, jar_name)
      package_name = nil
      pos = 0
      if (!((pos = file_name.last_index_of("/"))).equal?(-1))
        package_name = (file_name.substring(0, pos)).to_s
      else
        package_name = file_name
      end
      # add the mapping to indexMap
      add_to_list(package_name, jar_name, @index_map)
      # add the mapping to jarMap
      add_to_list(jar_name, package_name, @jar_map)
    end
    
    typesig { [Array.typed(String)] }
    # Go through all the jar files and construct the
    # index table.
    def parse_jars(files)
      if ((files).nil?)
        return
      end
      current_jar = nil
      i = 0
      while i < files.attr_length
        current_jar = (files[i]).to_s
        zrf = ZipFile.new(current_jar.replace(Character.new(?/.ord), JavaFile.attr_separator_char))
        entries_ = zrf.entries
        while (entries_.has_more_elements)
          file_name = ((entries_.next_element)).get_name
          # Index the META-INF directory, but not the index or manifest.
          if (!file_name.starts_with("META-INF/") || !((file_name == "META-INF/") || (file_name == INDEX_NAME) || (file_name == JarFile::MANIFEST_NAME)))
            add(file_name, current_jar)
          end
        end
        zrf.close
        i += 1
      end
    end
    
    typesig { [OutputStream] }
    # Writes the index to the specified OutputStream
    # 
    # @param out the output stream
    # @exception IOException if an I/O error has occurred
    def write(out)
      bw = BufferedWriter.new(OutputStreamWriter.new(out, "UTF8"))
      bw.write("JarIndex-Version: 1.0\n\n")
      if (!(@jar_files).nil?)
        i = 0
        while i < @jar_files.attr_length
          # print out the jar file name
          jar = @jar_files[i]
          bw.write(jar + "\n")
          jarlist = @jar_map.get(jar)
          if (!(jarlist).nil?)
            listitr = jarlist.iterator
            while (listitr.has_next)
              bw.write(((listitr.next)).to_s + "\n")
            end
          end
          bw.write("\n")
          i += 1
        end
        bw.flush
      end
    end
    
    typesig { [InputStream] }
    # Reads the index from the specified InputStream.
    # 
    # @param is the input stream
    # @exception IOException if an I/O error has occurred
    def read(is)
      br = BufferedReader.new(InputStreamReader.new(is, "UTF8"))
      line = nil
      current_jar = nil
      # an ordered list of jar file names
      jars = Vector.new
      # read until we see a .jar line
      while (!((line = (br.read_line).to_s)).nil? && !line.ends_with(".jar"))
      end
      while !(line).nil?
        if ((line.length).equal?(0))
          line = (br.read_line).to_s
          next
        end
        if (line.ends_with(".jar"))
          current_jar = line
          jars.add(current_jar)
        else
          name = line
          add_to_list(name, current_jar, @index_map)
          add_to_list(current_jar, name, @jar_map)
        end
        line = (br.read_line).to_s
      end
      @jar_files = jars.to_array(Array.typed(String).new(jars.size) { nil })
    end
    
    typesig { [JarIndex, String] }
    # Merges the current index into another index, taking into account
    # the relative path of the current index.
    # 
    # @param toIndex The destination index which the current index will
    # merge into.
    # @param path    The relative path of the this index to the destination
    # index.
    def merge(to_index, path)
      itr = @index_map.entry_set.iterator
      while (itr.has_next)
        e = itr.next
        package_name = e.get_key
        from_list = e.get_value
        list_itr = from_list.iterator
        while (list_itr.has_next)
          jar_name = list_itr.next
          if (!(path).nil?)
            jar_name = (path.concat(jar_name)).to_s
          end
          to_index.add(package_name, jar_name)
        end
      end
    end
    
    private
    alias_method :initialize__jar_index, :initialize
  end
  
end

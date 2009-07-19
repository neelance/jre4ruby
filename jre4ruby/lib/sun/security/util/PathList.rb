require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module PathListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang, :String
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLClassLoader
      include_const ::Java::Net, :MalformedURLException
    }
  end
  
  # A utility class for handle path list
  class PathList 
    include_class_members PathListImports
    
    class_module.module_eval {
      typesig { [String, String] }
      # Utility method for appending path from pathFrom to pathTo.
      # 
      # @param pathTo the target path
      # @param pathSource the path to be appended to pathTo
      # @return the resulting path
      def append_path(path_to, path_from)
        if ((path_to).nil? || (path_to.length).equal?(0))
          return path_from
        else
          if ((path_from).nil? || (path_from.length).equal?(0))
            return path_to
          else
            return path_to + (JavaFile.attr_path_separator).to_s + path_from
          end
        end
      end
      
      typesig { [String] }
      # Utility method for converting a search path string to an array
      # of directory and JAR file URLs.
      # 
      # @param path the search path string
      # @return the resulting array of directory and JAR file URLs
      def path_to_urls(path)
        st = StringTokenizer.new(path, JavaFile.attr_path_separator)
        urls = Array.typed(URL).new(st.count_tokens) { nil }
        count = 0
        while (st.has_more_tokens)
          url = file_to_url(JavaFile.new(st.next_token))
          if (!(url).nil?)
            urls[((count += 1) - 1)] = url
          end
        end
        if (!(urls.attr_length).equal?(count))
          tmp = Array.typed(URL).new(count) { nil }
          System.arraycopy(urls, 0, tmp, 0, count)
          urls = tmp
        end
        return urls
      end
      
      typesig { [JavaFile] }
      # Returns the directory or JAR file URL corresponding to the specified
      # local file name.
      # 
      # @param file the File object
      # @return the resulting directory or JAR file URL, or null if unknown
      def file_to_url(file)
        name = nil
        begin
          name = (file.get_canonical_path).to_s
        rescue IOException => e
          name = (file.get_absolute_path).to_s
        end
        name = (name.replace(JavaFile.attr_separator_char, Character.new(?/.ord))).to_s
        if (!name.starts_with("/"))
          name = "/" + name
        end
        # If the file does not exist, then assume that it's a directory
        if (!file.is_file)
          name = name + "/"
        end
        begin
          return URL.new("file", "", name)
        rescue MalformedURLException => e
          raise IllegalArgumentException.new("file")
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__path_list, :initialize
  end
  
end

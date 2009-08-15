require "rjava"

# Copyright 2002-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FileURLMapperImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Net, :URL
      include_const ::Java::Io, :JavaFile
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # (Solaris) platform specific handling for file: URLs .
  # urls must not contain a hostname in the authority field
  # other than "localhost".
  # 
  # This implementation could be updated to map such URLs
  # on to /net/host/...
  # 
  # @author      Michael McMahon
  class FileURLMapper 
    include_class_members FileURLMapperImports
    
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    typesig { [URL] }
    def initialize(url)
      @url = nil
      @path = nil
      @url = url
    end
    
    typesig { [] }
    # @returns the platform specific path corresponding to the URL
    # so long as the URL does not contain a hostname in the authority field.
    def get_path
      if (!(@path).nil?)
        return @path
      end
      host = @url.get_host
      if ((host).nil? || ("" == host) || "localhost".equals_ignore_case(host))
        @path = RJava.cast_to_string(@url.get_file)
        @path = RJava.cast_to_string(ParseUtil.decode(@path))
      end
      return @path
    end
    
    typesig { [] }
    # Checks whether the file identified by the URL exists.
    def exists
      s = get_path
      if ((s).nil?)
        return false
      else
        f = JavaFile.new(s)
        return f.exists
      end
    end
    
    private
    alias_method :initialize__file_urlmapper, :initialize
  end
  
end

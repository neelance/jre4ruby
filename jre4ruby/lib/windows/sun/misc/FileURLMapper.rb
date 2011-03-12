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
  module FileURLMapperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Net, :URL
      include_const ::Java::Io, :JavaFile
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # (Windows) Platform specific handling for file: URLs . In particular deals
  # with network paths mapping them to UNCs.
  # 
  # @author      Michael McMahon
  class FileURLMapper 
    include_class_members FileURLMapperImports
    
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    attr_accessor :file
    alias_method :attr_file, :file
    undef_method :file
    alias_method :attr_file=, :file=
    undef_method :file=
    
    typesig { [URL] }
    def initialize(url)
      @url = nil
      @file = nil
      @url = url
    end
    
    typesig { [] }
    # @returns the platform specific path corresponding to the URL, and in particular
    #  returns a UNC when the authority contains a hostname
    def get_path
      if (!(@file).nil?)
        return @file
      end
      host = @url.get_host
      if (!(host).nil? && !(host == "") && !"localhost".equals_ignore_case(host))
        rest = @url.get_file
        s = host + RJava.cast_to_string(ParseUtil.decode(@url.get_file))
        @file = "\\\\" + RJava.cast_to_string(s.replace(Character.new(?/.ord), Character.new(?\\.ord)))
        return @file
      end
      path = @url.get_file.replace(Character.new(?/.ord), Character.new(?\\.ord))
      @file = RJava.cast_to_string(ParseUtil.decode(path))
      return @file
    end
    
    typesig { [] }
    def exists
      path = get_path
      f = JavaFile.new(path)
      return f.exists
    end
    
    private
    alias_method :initialize__file_urlmapper, :initialize
  end
  
end

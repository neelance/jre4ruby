require "rjava"

# Copyright 1999-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::JavaFile
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::JavaFile
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Java::Io, :JavaFile
    }
  end
  
  # Open an file input stream given a URL.
  # @author      James Gosling
  class Handler < HandlerImports.const_get :URLStreamHandler
    include_class_members HandlerImports
    
    typesig { [URL] }
    def get_host(url)
      host = url.get_host
      if ((host).nil?)
        host = ""
      end
      return host
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Int] }
    def parse_url(u, spec, start, limit)
      # Ugly backwards compatibility. Flip any file separator
      # characters to be forward slashes. This is a nop on Unix
      # and "fixes" win32 file paths. According to RFC 2396,
      # only forward slashes may be used to represent hierarchy
      # separation in a URL but previous releases unfortunately
      # performed this "fixup" behavior in the file URL parsing code
      # rather than forcing this to be fixed in the caller of the URL
      # class where it belongs. Since backslash is an "unwise"
      # character that would normally be encoded if literally intended
      # as a non-seperator character the damage of veering away from the
      # specification is presumably limited.
      super(u, spec.replace(JavaFile.attr_separator_char, Character.new(?/.ord)), start, limit)
    end
    
    typesig { [URL] }
    def open_connection(url)
      synchronized(self) do
        return open_connection(url, nil)
      end
    end
    
    typesig { [URL, Proxy] }
    def open_connection(url, p)
      synchronized(self) do
        path = nil
        file = url.get_file
        host = url.get_host
        path = RJava.cast_to_string(ParseUtil.decode(file))
        path = RJava.cast_to_string(path.replace(Character.new(?/.ord), Character.new(?\\.ord)))
        path = RJava.cast_to_string(path.replace(Character.new(?|.ord), Character.new(?:.ord)))
        if (((host).nil?) || (host == "") || host.equals_ignore_case("localhost") || (host == "~"))
          return create_file_urlconnection(url, JavaFile.new(path))
        end
        # attempt to treat this as a UNC path. See 4180841
        path = "\\\\" + host + path
        f = JavaFile.new(path)
        if (f.exists)
          return create_file_urlconnection(url, f)
        end
        # Now attempt an ftp connection.
        uc = nil
        newurl = nil
        begin
          newurl = URL.new("ftp", host, file + RJava.cast_to_string(((url.get_ref).nil? ? "" : "#" + RJava.cast_to_string(url.get_ref))))
          if (!(p).nil?)
            uc = newurl.open_connection(p)
          else
            uc = newurl.open_connection
          end
        rescue IOException => e
          uc = nil
        end
        if ((uc).nil?)
          raise IOException.new("Unable to connect to: " + RJava.cast_to_string(url.to_external_form))
        end
        return uc
      end
    end
    
    typesig { [URL, JavaFile] }
    # Template method to be overriden by Java Plug-in. [stanleyh]
    def create_file_urlconnection(url, file)
      return FileURLConnection.new(url, file)
    end
    
    typesig { [URL, URL] }
    # Compares the host components of two URLs.
    # @param u1 the URL of the first host to compare
    # @param u2 the URL of the second host to compare
    # @return  <tt>true</tt> if and only if they
    # are equal, <tt>false</tt> otherwise.
    def hosts_equal(u1, u2)
      # Special case for file: URLs
      # per RFC 1738 no hostname is equivalent to 'localhost'
      # i.e. file:///path is equal to file://localhost/path
      s1 = u1.get_host
      s2 = u2.get_host
      if ("localhost".equals_ignore_case(s1) && ((s2).nil? || ("" == s2)))
        return true
      end
      if ("localhost".equals_ignore_case(s2) && ((s1).nil? || ("" == s1)))
        return true
      end
      return super(u1, u2)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end

require "rjava"

# 
# Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# -
# FTP stream opener
module Sun::Net::Www::Protocol::Ftp
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Ftp
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :Proxy
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Sun::Net::Ftp, :FtpClient
      include_const ::Sun::Net::Www::Protocol::Http, :HttpURLConnection
    }
  end
  
  # open an ftp connection given a URL
  class Handler < Java::Net::URLStreamHandler
    include_class_members HandlerImports
    
    typesig { [] }
    def get_default_port
      return 21
    end
    
    typesig { [URL, URL] }
    def equals(u1, u2)
      user_info1 = u1.get_user_info
      user_info2 = u2.get_user_info
      return super(u1, u2) && ((user_info1).nil? ? (user_info2).nil? : (user_info1 == user_info2))
    end
    
    typesig { [URL] }
    def open_connection(u)
      return open_connection(u, nil)
    end
    
    typesig { [URL, Proxy] }
    def open_connection(u, p)
      return FtpURLConnection.new(u, p)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end

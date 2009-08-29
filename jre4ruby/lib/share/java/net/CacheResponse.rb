require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module CacheResponseImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :InputStream
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Io, :IOException
    }
  end
  
  # Represent channels for retrieving resources from the
  # ResponseCache. Instances of such a class provide an
  # InputStream that returns the entity body, and also a
  # getHeaders() method which returns the associated response headers.
  # 
  # @author Yingxian Wang
  # @since 1.5
  class CacheResponse 
    include_class_members CacheResponseImports
    
    typesig { [] }
    # Returns the response headers as a Map.
    # 
    # @return An immutable Map from response header field names to
    # lists of field values. The status line has null as its
    # field name.
    # @throws IOException if an I/O error occurs
    # while getting the response headers
    def get_headers
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the response body as an InputStream.
    # 
    # @return an InputStream from which the response body can
    # be accessed
    # @throws IOException if an I/O error occurs while
    # getting the response body
    def get_body
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__cache_response, :initialize
  end
  
end

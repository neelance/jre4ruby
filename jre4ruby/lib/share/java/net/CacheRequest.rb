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
  module CacheRequestImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # Represents channels for storing resources in the
  # ResponseCache. Instances of such a class provide an
  # OutputStream object which is called by protocol handlers to
  # store the resource data into the cache, and also an abort() method
  # which allows a cache store operation to be interrupted and
  # abandoned. If an IOException is encountered while reading the
  # response or writing to the cache, the current cache store operation
  # will be aborted.
  # 
  # @author Yingxian Wang
  # @since 1.5
  class CacheRequest 
    include_class_members CacheRequestImports
    
    typesig { [] }
    # Returns an OutputStream to which the response body can be
    # written.
    # 
    # @return an OutputStream to which the response body can
    # be written
    # @throws IOException if an I/O error occurs while
    # writing the response body
    def get_body
      raise NotImplementedError
    end
    
    typesig { [] }
    # Aborts the attempt to cache the response. If an IOException is
    # encountered while reading the response or writing to the cache,
    # the current cache store operation will be abandoned.
    def abort
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__cache_request, :initialize
  end
  
end

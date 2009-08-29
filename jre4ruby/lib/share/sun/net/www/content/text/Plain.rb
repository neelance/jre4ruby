require "rjava"

# Copyright 1994-1996 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# Plain text file handler.
# @author  Steven B. Byrne
module Sun::Net::Www::Content::Text
  module PlainImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Content::Text
      include ::Java::Net
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  class Plain < PlainImports.const_get :ContentHandler
    include_class_members PlainImports
    
    typesig { [URLConnection] }
    # Returns a PlainTextInputStream object from which data
    # can be read.
    def get_content(uc)
      begin
        is = uc.get_input_stream
        return PlainTextInputStream.new(uc.get_input_stream)
      rescue IOException => e
        return "Error reading document:\n" + RJava.cast_to_string(e.to_s)
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize_plain, :initialize
  end
  
end

require "rjava"

# Copyright 1995-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Content::Image
  module JpegImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Content::Image
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include ::Java::Net
      include ::Sun::Awt::Image
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Awt, :Image
      include_const ::Java::Awt, :Toolkit
    }
  end
  
  class Jpeg < JpegImports.const_get :ContentHandler
    include_class_members JpegImports
    
    typesig { [URLConnection] }
    def get_content(urlc)
      return URLImageSource.new(urlc)
    end
    
    typesig { [URLConnection, Array.typed(Class)] }
    def get_content(urlc, classes)
      i = 0
      while i < classes.attr_length
        if (classes[i].is_assignable_from(URLImageSource.class))
          return URLImageSource.new(urlc)
        end
        if (classes[i].is_assignable_from(Image.class))
          tk = Toolkit.get_default_toolkit
          return tk.create_image(URLImageSource.new(urlc))
        end
        ((i += 1) - 1)
      end
      return nil
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize_jpeg, :initialize
  end
  
end

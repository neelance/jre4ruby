require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module UTF_32Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
    }
  end
  
  class UTF_32 < UTF_32Imports.const_get :Unicode
    include_class_members UTF_32Imports
    
    typesig { [] }
    def initialize
      super("UTF-32", StandardCharsets.attr_aliases_utf_32)
    end
    
    typesig { [] }
    def historical_name
      return "UTF-32"
    end
    
    typesig { [] }
    def new_decoder
      return UTF_32Coder::Decoder.new(self, UTF_32Coder::NONE)
    end
    
    typesig { [] }
    def new_encoder
      return UTF_32Coder::Encoder.new(self, UTF_32Coder::BIG, false)
    end
    
    private
    alias_method :initialize__utf_32, :initialize
  end
  
end

require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module UTF8Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  # It is necessary to use a "bootstrap" UTF-8 encoder for encoding
  # constant pool entries because the character set converters rely on
  # Class.newInstance().
  class UTF8 
    include_class_members UTF8Imports
    
    class_module.module_eval {
      typesig { [String] }
      # This encoder is not quite correct.  It does not handle surrogate pairs.
      def encode(str)
        len = str.length
        res = Array.typed(::Java::Byte).new(utf8_length(str)) { 0 }
        utf8idx = 0
        begin
          i = 0
          while i < len
            c = str.char_at(i) & 0xffff
            if (c >= 0x1 && c <= 0x7f)
              res[((utf8idx += 1) - 1)] = c
            else
              if ((c).equal?(0x0) || (c >= 0x80 && c <= 0x7ff))
                res[((utf8idx += 1) - 1)] = (0xc0 + (c >> 6))
                res[((utf8idx += 1) - 1)] = (0x80 + (c & 0x3f))
              else
                res[((utf8idx += 1) - 1)] = (0xe0 + (c >> 12))
                res[((utf8idx += 1) - 1)] = (0x80 + ((c >> 6) & 0x3f))
                res[((utf8idx += 1) - 1)] = (0x80 + (c & 0x3f))
              end
            end
            i += 1
          end
        rescue ArrayIndexOutOfBoundsException => e
          raise InternalError.new("Bug in sun.reflect bootstrap UTF-8 encoder")
        end
        return res
      end
      
      typesig { [String] }
      def utf8_length(str)
        len = str.length
        utf8len = 0
        i = 0
        while i < len
          c = str.char_at(i) & 0xffff
          if (c >= 0x1 && c <= 0x7f)
            utf8len += 1
          else
            if ((c).equal?(0x0) || (c >= 0x80 && c <= 0x7ff))
              utf8len += 2
            else
              utf8len += 3
            end
          end
          i += 1
        end
        return utf8len
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__utf8, :initialize
  end
  
end

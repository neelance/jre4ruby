require "rjava"

# 
# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc::Resources
  module Messages_jaImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc::Resources
    }
  end
  
  # 
  # <p> This class represents the <code>ResourceBundle</code>
  # for sun.misc.
  # 
  # @author Michael Colburn
  class Messages_ja < Java::Util::ListResourceBundle
    include_class_members Messages_jaImports
    
    typesig { [] }
    # 
    # Returns the contents of this <code>ResourceBundle</code>.
    # <p>
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    class_module.module_eval {
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["optpkg.versionerror", ("".to_u << 0x30a8 << "".to_u << 0x30e9 << "".to_u << 0x30fc << ": JAR ".to_u << 0x30d5 << "".to_u << 0x30a1 << "".to_u << 0x30a4 << "".to_u << 0x30eb << " {0} ".to_u << 0x3067 << "".to_u << 0x7121 << "".to_u << 0x52b9 << "".to_u << 0x306a << "".to_u << 0x30d0 << "".to_u << 0x30fc << "".to_u << 0x30b8 << "".to_u << 0x30e7 << "".to_u << 0x30f3 << "".to_u << 0x5f62 << "".to_u << 0x5f0f << "".to_u << 0x304c << "".to_u << 0x4f7f << "".to_u << 0x7528 << "".to_u << 0x3055 << "".to_u << 0x308c << "".to_u << 0x3066 << "".to_u << 0x3044 << "".to_u << 0x307e << "".to_u << 0x3059 << "".to_u << 0x3002 << "".to_u << 0x30b5 << "".to_u << 0x30dd << "".to_u << 0x30fc << "".to_u << 0x30c8 << "".to_u << 0x3055 << "".to_u << 0x308c << "".to_u << 0x308b << "".to_u << 0x30d0 << "".to_u << 0x30fc << "".to_u << 0x30b8 << "".to_u << 0x30e7 << "".to_u << 0x30f3 << "".to_u << 0x5f62 << "".to_u << 0x5f0f << "".to_u << 0x306b << "".to_u << 0x3064 << "".to_u << 0x3044 << "".to_u << 0x3066 << "".to_u << 0x306e << "".to_u << 0x30c9 << "".to_u << 0x30ad << "".to_u << 0x30e5 << "".to_u << 0x30e1 << "".to_u << 0x30f3 << "".to_u << 0x30c8 << "".to_u << 0x3092 << "".to_u << 0x53c2 << "".to_u << 0x7167 << "".to_u << 0x3057 << "".to_u << 0x3066 << "".to_u << 0x304f << "".to_u << 0x3060 << "".to_u << 0x3055 << "".to_u << 0x3044 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["optpkg.attributeerror", ("".to_u << 0x30a8 << "".to_u << 0x30e9 << "".to_u << 0x30fc << ": ".to_u << 0x5fc5 << "".to_u << 0x8981 << "".to_u << 0x306a << " JAR ".to_u << 0x30de << "".to_u << 0x30cb << "".to_u << 0x30d5 << "".to_u << 0x30a7 << "".to_u << 0x30b9 << "".to_u << 0x30c8 << "".to_u << 0x5c5e << "".to_u << 0x6027 << " {0} ".to_u << 0x304c << " JAR ".to_u << 0x30d5 << "".to_u << 0x30a1 << "".to_u << 0x30a4 << "".to_u << 0x30eb << " {1} ".to_u << 0x306b << "".to_u << 0x8a2d << "".to_u << 0x5b9a << "".to_u << 0x3055 << "".to_u << 0x308c << "".to_u << 0x3066 << "".to_u << 0x3044 << "".to_u << 0x307e << "".to_u << 0x305b << "".to_u << 0x3093 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["optpkg.attributeserror", ("".to_u << 0x30a8 << "".to_u << 0x30e9 << "".to_u << 0x30fc << ": ".to_u << 0x8907 << "".to_u << 0x6570 << "".to_u << 0x306e << "".to_u << 0x5fc5 << "".to_u << 0x8981 << "".to_u << 0x306a << " JAR ".to_u << 0x30de << "".to_u << 0x30cb << "".to_u << 0x30d5 << "".to_u << 0x30a7 << "".to_u << 0x30b9 << "".to_u << 0x30c8 << "".to_u << 0x5c5e << "".to_u << 0x6027 << "".to_u << 0x304c << " JAR ".to_u << 0x30d5 << "".to_u << 0x30a1 << "".to_u << 0x30a4 << "".to_u << 0x30eb << " {0} ".to_u << 0x306b << "".to_u << 0x8a2d << "".to_u << 0x5b9a << "".to_u << 0x3055 << "".to_u << 0x308c << "".to_u << 0x3066 << "".to_u << 0x3044 << "".to_u << 0x307e << "".to_u << 0x305b << "".to_u << 0x3093 << "".to_u << 0x3002 << "")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__messages_ja, :initialize
  end
  
end

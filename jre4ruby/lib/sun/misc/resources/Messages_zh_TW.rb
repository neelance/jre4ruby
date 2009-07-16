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
  module Messages_zh_TWImports
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
  class Messages_zh_TW < Java::Util::ListResourceBundle
    include_class_members Messages_zh_TWImports
    
    typesig { [] }
    # 
    # Returns the contents of this <code>ResourceBundle</code>.
    # <p>
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    class_module.module_eval {
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["optpkg.versionerror", ("".to_u << 0x932f << "".to_u << 0x8aa4 << ": {0} JAR ".to_u << 0x6a94 << "".to_u << 0x4f7f << "".to_u << 0x7528 << "".to_u << 0x4e86 << "".to_u << 0x7121 << "".to_u << 0x6548 << "".to_u << 0x7684 << "".to_u << 0x7248 << "".to_u << 0x672c << "".to_u << 0x683c << "".to_u << 0x5f0f << "".to_u << 0x3002 << "".to_u << 0x8acb << "".to_u << 0x6aa2 << "".to_u << 0x67e5 << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0xff0c << "".to_u << 0x4ee5 << "".to_u << 0x7372 << "".to_u << 0x5f97 << "".to_u << 0x652f << "".to_u << 0x63f4 << "".to_u << 0x7684 << "".to_u << 0x7248 << "".to_u << 0x672c << "".to_u << 0x683c << "".to_u << 0x5f0f << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["optpkg.attributeerror", ("".to_u << 0x932f << "".to_u << 0x8aa4 << ": {1} JAR ".to_u << 0x6a94 << "".to_u << 0x4e2d << "".to_u << 0x672a << "".to_u << 0x8a2d << "".to_u << 0x5b9a << "".to_u << 0x5fc5 << "".to_u << 0x8981 << "".to_u << 0x7684 << " {0} JAR ".to_u << 0x6a19 << "".to_u << 0x660e << "".to_u << 0x5c6c << "".to_u << 0x6027 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["optpkg.attributeserror", ("".to_u << 0x932f << "".to_u << 0x8aa4 << ": {0} JAR ".to_u << 0x6a94 << "".to_u << 0x4e2d << "".to_u << 0x672a << "".to_u << 0x8a2d << "".to_u << 0x5b9a << "".to_u << 0x67d0 << "".to_u << 0x4e9b << "".to_u << 0x5fc5 << "".to_u << 0x8981 << "".to_u << 0x7684 << " JAR ".to_u << 0x6a19 << "".to_u << 0x660e << "".to_u << 0x5c6c << "".to_u << 0x6027 << "".to_u << 0x3002 << "")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__messages_zh_tw, :initialize
  end
  
end

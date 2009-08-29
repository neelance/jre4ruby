require "rjava"

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
  module Messages_koImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc::Resources
    }
  end
  
  # <p> This class represents the <code>ResourceBundle</code>
  # for sun.misc.
  # 
  # @author Michael Colburn
  class Messages_ko < Java::Util::ListResourceBundle
    include_class_members Messages_koImports
    
    typesig { [] }
    # Returns the contents of this <code>ResourceBundle</code>.
    # <p>
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    class_module.module_eval {
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["optpkg.versionerror", ("".to_u << 0xc624 << "".to_u << 0xb958 << ": {0} JAR ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc5d0 << " ".to_u << 0xc798 << "".to_u << 0xbabb << "".to_u << 0xb41c << " ".to_u << 0xbc84 << "".to_u << 0xc804 << " ".to_u << 0xd615 << "".to_u << 0xc2dd << "".to_u << 0xc774 << " ".to_u << 0xc0ac << "".to_u << 0xc6a9 << "".to_u << 0xb418 << "".to_u << 0xc5c8 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ". ".to_u << 0xc124 << "".to_u << 0xba85 << "".to_u << 0xc11c << "".to_u << 0xb97c << " ".to_u << 0xcc38 << "".to_u << 0xc870 << "".to_u << 0xd558 << "".to_u << 0xc5ec << " ".to_u << 0xc9c0 << "".to_u << 0xc6d0 << "".to_u << 0xb418 << "".to_u << 0xb294 << " ".to_u << 0xbc84 << "".to_u << 0xc804 << " ".to_u << 0xd615 << "".to_u << 0xc2dd << "".to_u << 0xc744 << " ".to_u << 0xd655 << "".to_u << 0xc778 << "".to_u << 0xd558 << "".to_u << 0xc2ed << "".to_u << 0xc2dc << "".to_u << 0xc624 << ".")]), Array.typed(Object).new(["optpkg.attributeerror", ("".to_u << 0xc624 << "".to_u << 0xb958 << ": ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd55c << " {0} JAR ".to_u << 0xd45c << "".to_u << 0xc2dc << " ".to_u << 0xc18d << "".to_u << 0xc131 << "".to_u << 0xc774 << " {1} JAR ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc5d0 << " ".to_u << 0xc124 << "".to_u << 0xc815 << "".to_u << 0xb418 << "".to_u << 0xc5b4 << " ".to_u << 0xc788 << "".to_u << 0xc9c0 << " ".to_u << 0xc54a << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["optpkg.attributeserror", ("".to_u << 0xc624 << "".to_u << 0xb958 << ": ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd55c << " JAR ".to_u << 0xd45c << "".to_u << 0xc2dc << " ".to_u << 0xc18d << "".to_u << 0xc131 << " ".to_u << 0xc77c << "".to_u << 0xbd80 << "".to_u << 0xac00 << " {0} JAR ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc5d0 << " ".to_u << 0xc124 << "".to_u << 0xc815 << "".to_u << 0xb418 << "".to_u << 0xc5b4 << " ".to_u << 0xc788 << "".to_u << 0xc9c0 << " ".to_u << 0xc54a << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__messages_ko, :initialize
  end
  
end

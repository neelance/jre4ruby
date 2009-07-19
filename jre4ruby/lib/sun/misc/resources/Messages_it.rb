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
  module Messages_itImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc::Resources
    }
  end
  
  # <p> This class represents the <code>ResourceBundle</code>
  # for sun.misc.
  # 
  # @author Michael Colburn
  class Messages_it < Java::Util::ListResourceBundle
    include_class_members Messages_itImports
    
    typesig { [] }
    # Returns the contents of this <code>ResourceBundle</code>.
    # <p>
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    class_module.module_eval {
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["optpkg.versionerror", "ERRORE: Formato versione non valido nel file JAR {0}. Verificare nella documentazione il formato della versione supportato."]), Array.typed(Object).new(["optpkg.attributeerror", ("ERRORE: L''attributo manifesto JAR {0} richiesto non ".to_u << 0x00e8 << " impostato nel file JAR {1}.")]), Array.typed(Object).new(["optpkg.attributeserror", "ERRORE: Alcuni attributi manifesti JAR {0} richiesti non sono impostati nel file JAR {1}."])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__messages_it, :initialize
  end
  
end

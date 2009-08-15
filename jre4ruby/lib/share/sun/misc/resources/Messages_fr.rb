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
  module Messages_frImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc::Resources
    }
  end
  
  # <p> This class represents the <code>ResourceBundle</code>
  # for sun.misc.
  # 
  # @author Michael Colburn
  class Messages_fr < Java::Util::ListResourceBundle
    include_class_members Messages_frImports
    
    typesig { [] }
    # Returns the contents of this <code>ResourceBundle</code>.
    # <p>
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    class_module.module_eval {
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["optpkg.versionerror", ("ERREUR".to_u << 0x00a0 << ": Format de version utilis".to_u << 0x00e9 << " pour le fichier JAR {0} non valide. Consultez la documentation pour voir le format de version pris en charge.")]), Array.typed(Object).new(["optpkg.attributeerror", ("ERREUR".to_u << 0x00a0 << ": L''attribut manifeste JAR {0} n".to_u << 0x00e9 << "cessaire n''est pas d".to_u << 0x00e9 << "fini pour le fichier {1}. ")]), Array.typed(Object).new(["optpkg.attributeserror", ("ERREUR".to_u << 0x00a0 << ": Certains attributs manifeste JAR {0} n".to_u << 0x00e9 << "cessaires ne sont pas d".to_u << 0x00e9 << "finis pour le fichier {1}. ")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__messages_fr, :initialize
  end
  
end

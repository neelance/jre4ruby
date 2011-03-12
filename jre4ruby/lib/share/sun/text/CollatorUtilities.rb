require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Text
  module CollatorUtilitiesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
      include_const ::Sun::Text::Normalizer, :NormalizerBase
    }
  end
  
  class CollatorUtilities 
    include_class_members CollatorUtilitiesImports
    
    class_module.module_eval {
      typesig { [NormalizerBase::Mode] }
      def to_legacy_mode(mode)
        # find the index of the legacy mode in the table;
        # if it's not there, default to Collator.NO_DECOMPOSITION (0)
        legacy_mode = self.attr_legacy_mode_map.attr_length
        while (legacy_mode > 0)
          (legacy_mode -= 1)
          if ((self.attr_legacy_mode_map[legacy_mode]).equal?(mode))
            break
          end
        end
        return legacy_mode
      end
      
      typesig { [::Java::Int] }
      def to_normalizer_mode(mode)
        normalizer_mode = nil
        begin
          normalizer_mode = self.attr_legacy_mode_map[mode]
        rescue ArrayIndexOutOfBoundsException => e
          normalizer_mode = NormalizerBase::NONE
        end
        return normalizer_mode
      end
      
      # Collator.NO_DECOMPOSITION
      # Collator.CANONICAL_DECOMPOSITION
      # Collator.FULL_DECOMPOSITION
      
      def legacy_mode_map
        defined?(@@legacy_mode_map) ? @@legacy_mode_map : @@legacy_mode_map= Array.typed(NormalizerBase::Mode).new([NormalizerBase::NONE, NormalizerBase::NFD, NormalizerBase::NFKD])
      end
      alias_method :attr_legacy_mode_map, :legacy_mode_map
      
      def legacy_mode_map=(value)
        @@legacy_mode_map = value
      end
      alias_method :attr_legacy_mode_map=, :legacy_mode_map=
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__collator_utilities, :initialize
  end
  
end

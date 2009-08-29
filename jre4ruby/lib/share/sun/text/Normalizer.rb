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
module Sun::Text
  module NormalizerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
      include_const ::Sun::Text::Normalizer, :NormalizerBase
      include_const ::Sun::Text::Normalizer, :NormalizerImpl
    }
  end
  
  # This Normalizer is for Unicode 3.2 support for IDNA only.
  # Developers should not use this class.
  # 
  # @ since 1.6
  class Normalizer 
    include_class_members NormalizerImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # Option to select Unicode 3.2 (without corrigendum 4 corrections) for
      # normalization.
      const_set_lazy(:UNICODE_3_2) { NormalizerBase::UNICODE_3_2_0_ORIGINAL }
      const_attr_reader  :UNICODE_3_2
      
      typesig { [CharSequence, Java::Text::Normalizer::Form, ::Java::Int] }
      # Normalize a sequence of char values.
      # The sequence will be normalized according to the specified normalization
      # from.
      # @param src        The sequence of char values to normalize.
      # @param form       The normalization form; one of
      # {@link java.text.Normalizer.Form#NFC},
      # {@link java.text.Normalizer.Form#NFD},
      # {@link java.text.Normalizer.Form#NFKC},
      # {@link java.text.Normalizer.Form#NFKD}
      # @param option     The normalization option;
      # {@link sun.text.Normalizer#UNICODE_3_2}
      # @return The normalized String
      # @throws NullPointerException If <code>src</code> or <code>form</code>
      # is null.
      def normalize(src, form, option)
        return NormalizerBase.normalize(src.to_s, form, option)
      end
      
      typesig { [CharSequence, Java::Text::Normalizer::Form, ::Java::Int] }
      # Determines if the given sequence of char values is normalized.
      # @param src        The sequence of char values to be checked.
      # @param form       The normalization form; one of
      # {@link java.text.Normalizer.Form#NFC},
      # {@link java.text.Normalizer.Form#NFD},
      # {@link java.text.Normalizer.Form#NFKC},
      # {@link java.text.Normalizer.Form#NFKD}
      # @param option     The normalization option;
      # {@link sun.text.Normalizer#UNICODE_3_2}
      # @return true if the sequence of char values is normalized;
      # false otherwise.
      # @throws NullPointerException If <code>src</code> or <code>form</code>
      # is null.
      def is_normalized(src, form, option)
        return NormalizerBase.is_normalized(src.to_s, form, option)
      end
      
      typesig { [::Java::Int] }
      # Returns the combining class of the given character
      # @param ch character to retrieve combining class of
      # @return combining class of the given character
      def get_combining_class(ch)
        return NormalizerImpl.get_combining_class(ch)
      end
    }
    
    private
    alias_method :initialize__normalizer, :initialize
  end
  
end

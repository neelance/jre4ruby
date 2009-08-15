require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ComposedCharIterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
      include_const ::Sun::Text::Normalizer, :NormalizerBase
      include_const ::Sun::Text::Normalizer, :NormalizerImpl
    }
  end
  
  class ComposedCharIter 
    include_class_members ComposedCharIterImports
    
    class_module.module_eval {
      # Constant that indicates the iteration has completed.
      # {@link #next} returns this value when there are no more composed characters
      # over which to iterate.
      const_set_lazy(:DONE) { NormalizerBase::DONE }
      const_attr_reader  :DONE
      
      # cache the decomps mapping, so the seconde composedcharIter does
      # not need to get the data again.
      
      def chars
        defined?(@@chars) ? @@chars : @@chars= nil
      end
      alias_method :attr_chars, :chars
      
      def chars=(value)
        @@chars = value
      end
      alias_method :attr_chars=, :chars=
      
      
      def decomps
        defined?(@@decomps) ? @@decomps : @@decomps= nil
      end
      alias_method :attr_decomps, :decomps
      
      def decomps=(value)
        @@decomps = value
      end
      alias_method :attr_decomps=, :decomps=
      
      
      def decomp_num
        defined?(@@decomp_num) ? @@decomp_num : @@decomp_num= 0
      end
      alias_method :attr_decomp_num, :decomp_num
      
      def decomp_num=(value)
        @@decomp_num = value
      end
      alias_method :attr_decomp_num=, :decomp_num=
      
      when_class_loaded do
        max_num = 2000 # TBD: Unicode 4.0 only has 1926 canoDecomp...
        self.attr_chars = Array.typed(::Java::Int).new(max_num) { 0 }
        self.attr_decomps = Array.typed(String).new(max_num) { nil }
        self.attr_decomp_num = NormalizerImpl.get_decompose(self.attr_chars, self.attr_decomps)
      end
    }
    
    typesig { [] }
    # Construct a new <tt>ComposedCharIter</tt>.  The iterator will return
    # all Unicode characters with canonical decompositions, excluding Korean
    # Hangul characters.
    def initialize
      @cur_char = -1
    end
    
    typesig { [] }
    # Returns the next precomposed Unicode character.
    # Repeated calls to <tt>next</tt> return all of the precomposed characters defined
    # by Unicode, in ascending order.  After all precomposed characters have
    # been returned, {@link #hasNext} will return <tt>false</tt> and further calls
    # to <tt>next</tt> will return {@link #DONE}.
    def next_
      if ((@cur_char).equal?(self.attr_decomp_num - 1))
        return DONE
      end
      return self.attr_chars[(@cur_char += 1)]
    end
    
    typesig { [] }
    # Returns the Unicode decomposition of the current character.
    # This method returns the decomposition of the precomposed character most
    # recently returned by {@link #next}.  The resulting decomposition is
    # affected by the settings of the options passed to the constructor.
    def decomposition
      return self.attr_decomps[@cur_char]
    end
    
    attr_accessor :cur_char
    alias_method :attr_cur_char, :cur_char
    undef_method :cur_char
    alias_method :attr_cur_char=, :cur_char=
    undef_method :cur_char=
    
    private
    alias_method :initialize__composed_char_iter, :initialize
  end
  
end

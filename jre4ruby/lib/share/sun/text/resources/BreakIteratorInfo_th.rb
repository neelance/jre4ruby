require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# Licensed Materials - Property of IBM
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# (C) IBM Corp. 1997-1998.  All Rights Reserved.
# 
# The program is provided "as is" without any warranty express or
# implied, including the warranty of non-infringement and the implied
# warranties of merchantibility and fitness for a particular purpose.
# IBM will not be liable for any damages suffered by you as a result
# of using the Program. In no event will IBM be liable for any
# special, indirect or consequential damages or lost profits even if
# IBM has been advised of the possibility of their occurrence. IBM
# will not be liable for any third party claims against you.
module Sun::Text::Resources
  module BreakIteratorInfo_thImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class BreakIteratorInfo_th < BreakIteratorInfo_thImports.const_get :ListResourceBundle
    include_class_members BreakIteratorInfo_thImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["BreakIteratorClasses", Array.typed(String).new(["RuleBasedBreakIterator", "DictionaryBasedBreakIterator", "DictionaryBasedBreakIterator", "RuleBasedBreakIterator"])]), Array.typed(Object).new(["WordData", "WordBreakIteratorData_th"]), Array.typed(Object).new(["LineData", "LineBreakIteratorData_th"]), Array.typed(Object).new(["WordDictionary", "thai_dict"]), Array.typed(Object).new(["LineDictionary", "thai_dict"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__break_iterator_info_th, :initialize
  end
  
end

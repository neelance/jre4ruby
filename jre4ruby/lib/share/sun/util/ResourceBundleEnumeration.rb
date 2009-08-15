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
module Sun::Util
  module ResourceBundleEnumerationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # Implements an Enumeration that combines elements from a Set and
  # an Enumeration. Used by ListResourceBundle and PropertyResourceBundle.
  class ResourceBundleEnumeration 
    include_class_members ResourceBundleEnumerationImports
    include Enumeration
    
    attr_accessor :set
    alias_method :attr_set, :set
    undef_method :set
    alias_method :attr_set=, :set=
    undef_method :set=
    
    attr_accessor :iterator
    alias_method :attr_iterator, :iterator
    undef_method :iterator
    alias_method :attr_iterator=, :iterator=
    undef_method :iterator=
    
    attr_accessor :enumeration
    alias_method :attr_enumeration, :enumeration
    undef_method :enumeration
    alias_method :attr_enumeration=, :enumeration=
    undef_method :enumeration=
    
    typesig { [JavaSet, Enumeration] }
    # may remain null
    # 
    # Constructs a resource bundle enumeration.
    # @param set an set providing some elements of the enumeration
    # @param enumeration an enumeration providing more elements of the enumeration.
    # enumeration may be null.
    def initialize(set, enumeration)
      @set = nil
      @iterator = nil
      @enumeration = nil
      @next = nil
      @set = set
      @iterator = set.iterator
      @enumeration = enumeration
    end
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    typesig { [] }
    def has_more_elements
      if ((@next).nil?)
        if (@iterator.has_next)
          @next = RJava.cast_to_string(@iterator.next_)
        else
          if (!(@enumeration).nil?)
            while ((@next).nil? && @enumeration.has_more_elements)
              @next = RJava.cast_to_string(@enumeration.next_element)
              if (@set.contains(@next))
                @next = RJava.cast_to_string(nil)
              end
            end
          end
        end
      end
      return !(@next).nil?
    end
    
    typesig { [] }
    def next_element
      if (has_more_elements)
        result = @next
        @next = RJava.cast_to_string(nil)
        return result
      else
        raise NoSuchElementException.new
      end
    end
    
    private
    alias_method :initialize__resource_bundle_enumeration, :initialize
  end
  
end

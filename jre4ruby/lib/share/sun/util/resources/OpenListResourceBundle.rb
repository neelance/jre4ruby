require "rjava"

# Portions Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Sun::Util::Resources
  module OpenListResourceBundleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Resources
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Sun::Util, :ResourceBundleEnumeration
    }
  end
  
  # Subclass of <code>ResourceBundle</code> which mimics
  # <code>ListResourceBundle</code>, but provides more hooks
  # for specialized subclass behavior. For general description,
  # see {@link java.util.ListResourceBundle}.
  # <p>
  # This class leaves handleGetObject non-final, and
  # adds a method createMap which allows subclasses to
  # use specialized Map implementations.
  class OpenListResourceBundle < OpenListResourceBundleImports.const_get :ResourceBundle
    include_class_members OpenListResourceBundleImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @lookup = nil
      super()
      @lookup = nil
    end
    
    typesig { [String] }
    # Implements java.util.ResourceBundle.handleGetObject; inherits javadoc specification.
    def handle_get_object(key)
      if ((key).nil?)
        raise NullPointerException.new
      end
      load_lookup_tables_if_necessary
      return @lookup.get(key) # this class ignores locales
    end
    
    typesig { [] }
    # Implementation of ResourceBundle.getKeys.
    def get_keys
      parent = self.attr_parent
      return ResourceBundleEnumeration.new(handle_get_keys, (!(parent).nil?) ? parent.get_keys : nil)
    end
    
    typesig { [] }
    # Returns a set of keys provided in this resource bundle
    def handle_get_keys
      load_lookup_tables_if_necessary
      return @lookup.key_set
    end
    
    typesig { [] }
    # Returns the parent bundle
    def get_parent
      return self.attr_parent
    end
    
    typesig { [] }
    # See ListResourceBundle class description.
    def get_contents
      raise NotImplementedError
    end
    
    typesig { [] }
    # Load lookup tables if they haven't been loaded already.
    def load_lookup_tables_if_necessary
      if ((@lookup).nil?)
        load_lookup
      end
    end
    
    typesig { [] }
    # We lazily load the lookup hashtable.  This function does the
    # loading.
    def load_lookup
      synchronized(self) do
        if (!(@lookup).nil?)
          return
        end
        contents = get_contents
        temp = create_map(contents.attr_length)
        i = 0
        while i < contents.attr_length
          # key must be non-null String, value must be non-null
          key = contents[i][0]
          value = contents[i][1]
          if ((key).nil? || (value).nil?)
            raise NullPointerException.new
          end
          temp.put(key, value)
          (i += 1)
        end
        @lookup = temp
      end
    end
    
    typesig { [::Java::Int] }
    # Lets subclasses provide specialized Map implementations.
    # Default uses HashMap.
    def create_map(size)
      return HashMap.new(size)
    end
    
    attr_accessor :lookup
    alias_method :attr_lookup, :lookup
    undef_method :lookup
    alias_method :attr_lookup=, :lookup=
    undef_method :lookup=
    
    private
    alias_method :initialize__open_list_resource_bundle, :initialize
  end
  
end

require "rjava"

# Copyright 1997 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module X509AttributeNameImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
    }
  end
  
  # This class is used to parse attribute names like "x509.info.extensions".
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class X509AttributeName 
    include_class_members X509AttributeNameImports
    
    class_module.module_eval {
      # Public members
      const_set_lazy(:SEPARATOR) { Character.new(?..ord) }
      const_attr_reader  :SEPARATOR
    }
    
    # Private data members
    attr_accessor :prefix
    alias_method :attr_prefix, :prefix
    undef_method :prefix
    alias_method :attr_prefix=, :prefix=
    undef_method :prefix=
    
    attr_accessor :suffix
    alias_method :attr_suffix, :suffix
    undef_method :suffix
    alias_method :attr_suffix=, :suffix=
    undef_method :suffix=
    
    typesig { [String] }
    # Default constructor for the class. Name is of the form
    # "x509.info.extensions".
    # 
    # @param name the attribute name.
    def initialize(name)
      @prefix = nil
      @suffix = nil
      i = name.index_of(SEPARATOR)
      if ((i).equal?((-1)))
        @prefix = name
      else
        @prefix = RJava.cast_to_string(name.substring(0, i))
        @suffix = RJava.cast_to_string(name.substring(i + 1))
      end
    end
    
    typesig { [] }
    # Return the prefix of the name.
    def get_prefix
      return (@prefix)
    end
    
    typesig { [] }
    # Return the suffix of the name.
    def get_suffix
      return (@suffix)
    end
    
    private
    alias_method :initialize__x509attribute_name, :initialize
  end
  
end

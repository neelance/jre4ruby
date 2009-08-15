require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ClassFileTransformerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # This is an abstract base class which is called by java.lang.ClassLoader
  # when ClassFormatError is thrown inside defineClass().
  # 
  # The purpose of this class is to allow applications (e.g. Java Plug-in)
  # to have a chance to transform the byte code from one form to another
  # if necessary.
  # 
  # One application of this class is used by Java Plug-in to transform
  # malformed JDK 1.1 class file into a well-formed Java 2 class file
  # on-the-fly, so JDK 1.1 applets with malformed class file in the
  # Internet may run in Java 2 after transformation.
  # 
  # @author      Stanley Man-Kit Ho
  class ClassFileTransformer 
    include_class_members ClassFileTransformerImports
    
    class_module.module_eval {
      # Singleton of ClassFileTransformer
      
      def transformer_list
        defined?(@@transformer_list) ? @@transformer_list : @@transformer_list= ArrayList.new
      end
      alias_method :attr_transformer_list, :transformer_list
      
      def transformer_list=(value)
        @@transformer_list = value
      end
      alias_method :attr_transformer_list=, :transformer_list=
      
      
      def transformers
        defined?(@@transformers) ? @@transformers : @@transformers= Array.typed(Object).new(0) { nil }
      end
      alias_method :attr_transformers, :transformers
      
      def transformers=(value)
        @@transformers = value
      end
      alias_method :attr_transformers=, :transformers=
      
      typesig { [ClassFileTransformer] }
      # Add the class file transformer object.
      # 
      # @param t Class file transformer instance
      def add(t)
        synchronized((self.attr_transformer_list)) do
          self.attr_transformer_list.add(t)
          self.attr_transformers = self.attr_transformer_list.to_array
        end
      end
      
      typesig { [] }
      # Get the array of ClassFileTransformer object.
      # 
      # @return ClassFileTransformer object array
      def get_transformers
        # transformers is not intended to be changed frequently,
        # so it is okay to not put synchronized block here
        # to speed up performance.
        return self.attr_transformers
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Transform a byte array from one to the other.
    # 
    # @param b Byte array
    # @param off Offset
    # @param len Length of byte array
    # @return Transformed byte array
    def transform(b, off, len)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__class_file_transformer, :initialize
  end
  
end
